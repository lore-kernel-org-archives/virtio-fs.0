Message-ID: <014cde63-06de-16d1-8e28-2471c8c7eb14@redhat.com>
Date: Wed, 20 Oct 2021 11:11:21 +0200
MIME-Version: 1.0
References: <20210916084045.31684-1-hreitz@redhat.com>
	<20210916084045.31684-3-hreitz@redhat.com>
	<YW2s9+UQa0jozC7z@redhat.com>
From: Hanna Reitz <hreitz@redhat.com>
In-Reply-To: <YW2s9+UQa0jozC7z@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 02/12] virtiofsd: Limit setxattr()'s
 creds-dropped region
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

On 18.10.21 19:20, Vivek Goyal wrote:
> On Thu, Sep 16, 2021 at 10:40:35AM +0200, Hanna Reitz wrote:
>> We only need to drop/switch our credentials for the (f)setxattr() call
>> alone, not for the openat() or fchdir() around it.
>>
>> (Right now, this may not be that big of a problem, but with inodes being
>> identified by file handles instead of an O_PATH fd, we will need
>> open_by_handle_at() calls here, which is really fickle when it comes to
>> credentials being dropped.)
>>
>> Signed-off-by: Hanna Reitz <hreitz@redhat.com>
>> ---
>>   tools/virtiofsd/passthrough_ll.c | 34 +++++++++++++++++++++++---------
>>   1 file changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index 6511a6acb4..b43afdfbd3 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -3123,6 +3123,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>>       bool switched_creds = false;
>>       bool cap_fsetid_dropped = false;
>>       struct lo_cred old = {};
>> +    bool changed_cwd = false;
>>   
>>       if (block_xattr(lo, in_name)) {
>>           fuse_reply_err(req, EOPNOTSUPP);
>> @@ -3158,6 +3159,24 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
>>                ", name=%s value=%s size=%zd)\n", ino, name, value, size);
>>   
>>       sprintf(procname, "%i", inode->fd);
>> +    /*
>> +     * We can only open regular files or directories.  If the inode is
>> +     * something else, we have to enter /proc/self/fd and use
>> +     * setxattr() on the link's filename there.
>> +     */
>> +    if (S_ISREG(inode->filetype) || S_ISDIR(inode->filetype)) {
>> +        fd = openat(lo->proc_self_fd, procname, O_RDONLY);
>> +        if (fd < 0) {
>> +            saverr = errno;
>> +            goto out;
>> +        }
>> +    } else {
>> +        /* fchdir should not fail here */
>> +        FCHDIR_NOFAIL(lo->proc_self_fd);
>> +        /* Set flag so the clean-up path will chdir back */
>> +        changed_cwd = true;
> Is there a need to move FCHDIR_NOFAIL() call earlier too? I am assuming
> this will not be impacted by file handle stuff. So we probably could
> leave it in place. Easier to read.

I wanted to limit the region where the creds are dropped to an absolute 
minimum, i.e. just around (f)setxattr().  I prefer this in general, not 
just because it breaks opening file handles, and so I wanted to pull out 
not just the openat(), but the fchdir() as well.

Hanna

