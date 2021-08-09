References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-7-mreitz@redhat.com>
	<YQ2TleuDejJY4O4V@redhat.com>
From: Max Reitz <hreitz@redhat.com>
Message-ID: <87ab005c-9ae2-d2c8-f20f-8dea9627ccbc@redhat.com>
Date: Mon, 9 Aug 2021 15:40:48 +0200
MIME-Version: 1.0
In-Reply-To: <YQ2TleuDejJY4O4V@redhat.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Subject: Re: [Virtio-fs] [PATCH v3 06/10] virtiofsd: Let lo_inode_open()
	return a TempFd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>, Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On 06.08.21 21:55, Vivek Goyal wrote:
> On Fri, Jul 30, 2021 at 05:01:30PM +0200, Max Reitz wrote:
>> Strictly speaking, this is not necessary, because lo_inode_open() will
>> always return a new FD owned by the caller, so TempFd.owned will always
>> be true.
>>
>> However, auto-cleanup is nice, and in some cases this plays nicely with
>> an lo_inode_fd() call in another conditional branch (see lo_setattr()).
>>
>> Signed-off-by: Max Reitz <mreitz@redhat.com>
>> ---
>>   tools/virtiofsd/passthrough_ll.c | 138 +++++++++++++------------------
>>   1 file changed, 59 insertions(+), 79 deletions(-)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 9e1bc37af8..292b7f7e27 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -291,10 +291,8 @@ static void temp_fd_clear(TempFd *temp_fd)
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
>> @@ -673,9 +671,12 @@ static int lo_fd(fuse_req_t req, fuse_ino_t ino, TempFd *tfd)
>>    * when a malicious client opens special files such as block device nodes.
>>    * Symlink inodes are also rejected since symlinks must already have been
>>    * traversed on the client side.
>> + *
>> + * The fd is returned in tfd->fd.  The return value is 0 on success and -errno
>> + * otherwise.
>>    */
>> -static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
>> -                         int open_flags)
>> +static int lo_inode_open(const struct lo_data *lo, const struct lo_inode *inode,
>> +                         int open_flags, TempFd *tfd)
>>   {
>>       g_autofree char *fd_str = g_strdup_printf("%d", inode->fd);
>>       int fd;
>> @@ -694,7 +695,13 @@ static int lo_inode_open(struct lo_data *lo, struct lo_inode *inode,
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
>> @@ -852,7 +859,12 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>           return;
>>       }
>>   
>> -    res = lo_inode_fd(inode, &inode_fd);
>> +    if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
>> +        /* We need an O_RDWR FD for ftruncate() */
>> +        res = lo_inode_open(lo, inode, O_RDWR, &inode_fd);
>> +    } else {
>> +        res = lo_inode_fd(inode, &inode_fd);
>> +    }
> A minor nit.
>
> So inode_fd could hold either an O_PATH fd returned by lo_inode_fd()
> or a O_RDWR fd returned by lo_inode_open().
>
> Previous code held these fds in two different variables, inode_fd and
> truncfd respectively. I kind of found that easier to read because looking
> at variable name, I knew whether I am dealing with O_PATH fd or an
> O_RDWR fd I just opened.
>
> So a minor nit. We could continue to have two variables, say
> inode_fd and trunc_fd. Just that type of trunc_fd will now be TempFd.
>
> Also I liked previous style easier to read where I always got hold
> of O_PATH fd first. And later opened a O_RDWR fd if operation
> is FUSE_ATTR_SIZE. So "valid & FUSE_SET_ATTR_SIZE" check was not
> at two places.

Oh, yes.  The problem with that approach is that we unconditionally need 
to get an O_PATH fd, which is trivial for when we have one, but with 
file handles this means an open_by_handle_at() operation – and then 
another one to get the O_RDWR fd.  So there’s a superfluous 
open_by_handle_at() operation there.

I understand this makes the code a bit more complicated, but I felt 
there was sufficient reason for it.

That also means that I don’t really want to differentiate the fd into 
two distinct fd variables.  Nothing in this function needs an O_PATH fd, 
it’s just that that’s the easier one to open, so those places can work 
with any fd.

What we could do is have an rw_fd variable and a path_fd variable. The 
former will only be valid if the conditions are right (!fi && (valid & 
FUSE_SET_ATTR_SIZE)), the latter will always be valid and will be the 
same fd as rw_fd if the latter is valid.

However, both need to be TempFds, because both lo_inode_open() and 
lo_inode_fd() return TempFds.  So copying from rw_fd to path_fd would 
require a new function temp_fd_copy() or something, so the code would 
look like:

if (!fi && (valid & FUSE_SET_ATTR_SIZE)) {
     res = lo_inode_open(..., &rw_fd);
     if (res >= 0) {
         temp_fd_copy(&rw_fd, &path_fd);
     }
} else {
     res = lo_inode_fd(..., &path_fd);
}

with

void temp_fd_copy(const TempFd *from, const TempFd *to)
{
     *to = {
         .fd = to->fd,
         .owned = false,
     };
}

And then we use path_fd wherever an O_PATH fd would suffice, and rw_fd 
elsewhere (perhaps with a preceding assert(rw_fd.fd >= 0)).  Would that 
be kind of in accordance with what you had in mind?

> Anyway, this is a minor nit. If you don't like the idea of using
> two separate variables to hold O_PATH fd and O_RDWR fd, that's ok.
>
>
>>       if (res < 0) {
>>           saverr = -res;
>>           goto out_err;
>> @@ -900,18 +912,11 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>           if (fi) {
>>               truncfd = fd;
>>           } else {
>> -            truncfd = lo_inode_open(lo, inode, O_RDWR);
>> -            if (truncfd < 0) {
>> -                saverr = -truncfd;
>> -                goto out_err;
>> -            }
>> +            truncfd = inode_fd.fd;
>>           }
>>   
>>           saverr = drop_security_capability(lo, truncfd);
>>           if (saverr) {
>> -            if (!fi) {
>> -                close(truncfd);
>> -            }
>>               goto out_err;
>>           }
>>   
>> @@ -919,9 +924,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>               res = drop_effective_cap("FSETID", &cap_fsetid_dropped);
>>               if (res != 0) {
>>                   saverr = res;
>> -                if (!fi) {
>> -                    close(truncfd);
>> -                }
>>                   goto out_err;
>>               }
>>           }
>> @@ -934,9 +936,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
>>                   fuse_log(FUSE_LOG_ERR, "Failed to gain CAP_FSETID\n");
>>               }
>>           }
>> -        if (!fi) {
>> -            close(truncfd);
>> -        }
>>           if (res == -1) {
>>               goto out_err;
>>           }
>> @@ -1822,11 +1821,12 @@ static struct lo_dirp *lo_dirp(fuse_req_t req, struct fuse_file_info *fi)
>>   static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>>                          struct fuse_file_info *fi)
>>   {
>> +    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
>>       int error = ENOMEM;
>>       struct lo_data *lo = lo_data(req);
>>       struct lo_inode *inode;
>>       struct lo_dirp *d = NULL;
>> -    int fd;
>> +    int res;
>>       ssize_t fh;
>>   
>>       inode = lo_inode(req, ino);
>> @@ -1840,13 +1840,13 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
>>           goto out_err;
>>       }
>>   
>> -    fd = lo_inode_open(lo, inode, O_RDONLY);
>> -    if (fd < 0) {
>> -        error = -fd;
>> +    res = lo_inode_open(lo, inode, O_RDONLY, &inode_fd);
>> +    if (res < 0) {
>> +        error = -res;
>>           goto out_err;
>>       }
>>   
>> -    d->dp = fdopendir(fd);
>> +    d->dp = fdopendir(temp_fd_steal(&inode_fd));
> So we are using temp_fd_steal(), because if fdopendir() is succesful,
> we don't want to close fd instead it will be closed during closedir()
> call. inode_fd will be closed once lo_opendir(), so we get fd ownership
> which will need to close explicitly, when appropriate.
>
> Who closes the stolen fd returned by temp_fd_steal() if fdopendir() fails?

Nobody, I forgot handling it in the error path. O:)

Thanks for the catch.

>>       if (d->dp == NULL) {
>>           goto out_errno;
>>       }
>> @@ -1876,8 +1876,6 @@ out_err:
>>       if (d) {
>>           if (d->dp) {
>>               closedir(d->dp);
>> -        } else if (fd != -1) {
>> -            close(fd);
>>           }
>>           free(d);
>>       }
>> @@ -2077,6 +2075,7 @@ static void update_open_flags(int writeback, int allow_direct_io,
>>   static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
>>                         int existing_fd, struct fuse_file_info *fi)
>>   {
>> +    g_auto(TempFd) inode_fd = TEMP_FD_INIT;
> It bothers me that we are using variable inode_fd both to hold O_PATH
> fd as well as regular fd. Will be nice if just by looking at variable
> name I could figure out which type of fd it is.
>
> Will it make sense to use path_fd, or ipath_fd, or inode_path_fd to
> represent where we are using O_PATH fd.

I suppose you mean in general and not specifically for lo_do_open()?  
Sure, I vote for path_fd.

I can imagine the diff stat may become rather large, though, so while I 
agree in principle, I’ll have to take a look first to know how invasive 
such a change would be (and then let you know).

Thanks for you feedback!

Max

