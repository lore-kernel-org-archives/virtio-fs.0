Message-ID: <85b2d980-f309-cf58-ae5c-a1be00511219@redhat.com>
Date: Wed, 20 Oct 2021 11:15:55 +0200
MIME-Version: 1.0
References: <20210916084045.31684-1-hreitz@redhat.com>
	<20210916084045.31684-8-hreitz@redhat.com>
	<YW3ImM9WhNrZnSxN@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
In-Reply-To: <YW3ImM9WhNrZnSxN@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 07/12] virtiofsd: Let lo_inode_open()
	return a TempFd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 18.10.21 21:18, Vivek Goyal wrote:
> On Thu, Sep 16, 2021 at 10:40:40AM +0200, Hanna Reitz wrote:
>> Strictly speaking, this is not necessary, because lo_inode_open() will
>> always return a new FD owned by the caller, so TempFd.owned will always
>> be true.
>>
>> The auto-cleanup is nice, though.  Also, we get a more unified interface
>> where you always get a TempFd when you need an FD for an lo_inode
>> (regardless of whether it is an O_PATH FD or a non-O_PATH FD).
>>
>> Signed-off-by: Hanna Reitz <hreitz@redhat.com>
>> ---
>>   tools/virtiofsd/passthrough_ll.c | 156 +++++++++++++++----------------
>>   1 file changed, 75 insertions(+), 81 deletions(-)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 3bf20b8659..d257eda129 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -293,10 +293,8 @@ static void temp_fd_clear(TempFd *temp_fd)
>>   /**
>>    * Return an owned fd from *temp_fd that will not be closed when
>>    * *temp_fd goes out of scope.
>> - *
>> - * (TODO: Remove __attribute__ once this is used.)
>>    */
>> -static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
>> +static int temp_fd_steal(TempFd *temp_fd)
>>   {
>>       if (temp_fd->owned) {
>>           temp_fd->owned = false;
>> @@ -309,10 +307,8 @@ static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
>>   /**
>>    * Create a borrowing copy of an existing TempFd.  Note that *to is
>>    * only valid as long as *from is valid.
>> - *
>> - * (TODO: Remove __attribute__ once this is used.)
>>    */
>> -static __attribute__((unused)) void temp_fd_copy(const TempFd *from, TempFd *to)
>> +static void temp_fd_copy(const TempFd *from, TempFd *to)
>>   {
>>       *to = (TempFd) {
>>           .fd = from->fd,
>> @@ -689,9 +685,12 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
>>    * when a malicious client opens special files such as block device nodes.
>>    * Symlink inodes are also rejected since symlinks must already have been
>>    * traversed on the client side.
>> + *
>> + * The fd is returned in tfd->fd.  The return value is 0 on success and -errno
>> + * otherwise.
>>    */
>>   static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
>> -                         int open_flags)
>> +                         int open_flags, TempFd *tfd)
>>   {
>>       g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
>>       int fd;
>> @@ -710,7 +709,13 @@ static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
>>       if (fd < 0) {
>>           return -errno;
>>       }
>> -    return fd;
>> +
>> +    *tfd = (TempFd) {
>> +        .fd = fd,
>> +        .owned = true,
>> +    };
>> +
>> +    return 0;
>>   }
>>   
>>   static void lo_init(void *userdata, struct fuse_conn_info *conn)
>> @@ -854,7 +859,8 @@ static int lo_fi_fd(fuse_req_t req, struct fuse_file_info *fi)
>>   static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>                          int valid, struct fuse_file_info *fi)
>>   {
>> -    g_auto(TempFd) path_fd = TEMP_FD_INIT;
>> +    g_auto(TempFd) path_fd = TEMP_FD_INIT; /* at least an O_PATH fd */
> What does atleast O_PATH fd mean?

It means it might as well be an O_RDWR FD.  When we open an O_RDWR FD, 
it’s pointless to open an O_PATH FD, too, because we can use the O_RDWR 
FD everywhere where we’d need an O_PATH FD.  Hence in this case, we open 
rw_fd and copy it to path_fd.

Users still use rw_fd and path_fd according to what they need.

>
>> +    g_auto(TempFd) rw_fd = TEMP_FD_INIT; /* O_RDWR fd */
>>       int saverr;
>>       char procname[64];
>>       struct lo_data *lo = lo_data(req);
>> @@ -868,7 +874,15 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>           return;
>>       }
>>   
>> -    res = lo_inode_fd(inode, &path_fd);
>> +    if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
>> +        /* We need an O_RDWR FD for ftruncate() */
>> +        res = lo_inode_open(lo, inode, O_RDWR, &rw_fd);
>> +        if (res >= 0) {
>> +            temp_fd_copy(&rw_fd, &path_fd);
> I am lost here. If lo_inode_open() failed, why are we calling this
> temp_fd_copy()? path_fd is not even a valid fd yet.

We’re calling it on success.

> Still beats me that why open rw_fd now instead of down in
> FUSE_SET_ATTR_SIZE block. I think we had this discussion and you
> had some reasons to move it up.

Because it’s pointless overhead to open two FDs.

Before file handles, getting the O_PATH FD was a trivial operation. If 
we needed an O_RDWR FD later, we’d open it later.  No duplicate work 
involved.

With file handles, getting the O_PATH FD may mean opening a new FD. 
Opening another FD from the same file handle, just with different flags, 
later on would be strange, because we could have just opened the FD as 
O_RDWR right from the start.

Hanna

