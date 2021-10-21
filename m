References: <20211011030938.109206-1-jefflexu@linux.alibaba.com>
	<20211011030938.109206-2-jefflexu@linux.alibaba.com>
	<YXBThZt5/Z/RS1S6@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <386f2d9c-bb9e-24e9-014d-bd8f83a1bd64@linux.alibaba.com>
Date: Thu, 21 Oct 2021 10:32:58 +0800
MIME-Version: 1.0
In-Reply-To: <YXBThZt5/Z/RS1S6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [virtiofsd PATCH v6 1/6] virtiofsd: add .ioctl()
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, miklos@szeredi.hu



On 10/21/21 1:36 AM, Vivek Goyal wrote:
> On Mon, Oct 11, 2021 at 11:09:33AM +0800, Jeffle Xu wrote:
>> For passthrough, it passes corresponding ioctls to host directly.
>>
>> Currently only these ioctls that handling persistent inode flags, i.e.,
>> FS_IOC_[G|S]ETFLAGS and FS_IOC_FS[G|S]ETXATTR are supported for security
>> concern, though it's implemented in a quite general way, so that we can
>> expand the scope of allowed ioctls if it is really needed later.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  tools/virtiofsd/passthrough_ll.c      | 59 +++++++++++++++++++++++++++
>>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>>  2 files changed, 60 insertions(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index b76d878509..5969d67810 100644
>> --- a/tools/virtiofsd/passthrough_ll.c
>> +++ b/tools/virtiofsd/passthrough_ll.c
>> @@ -47,6 +47,7 @@
>>  #include <dirent.h>
>>  #include <pthread.h>
>>  #include <sys/file.h>
>> +#include <sys/ioctl.h>
>>  #include <sys/mount.h>
>>  #include <sys/prctl.h>
>>  #include <sys/resource.h>
>> @@ -54,6 +55,7 @@
>>  #include <sys/wait.h>
>>  #include <sys/xattr.h>
>>  #include <syslog.h>
>> +#include <linux/fs.h>
>>  
>>  #include "qemu/cutils.h"
>>  #include "passthrough_helpers.h"
>> @@ -2105,6 +2107,62 @@ out:
>>      fuse_reply_err(req, saverr);
>>  }
>>  
>> +
>> +static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd, void *arg,
>> +                          struct fuse_file_info *fi, unsigned flags, const void *in_buf,
>> +                          size_t in_bufsz, size_t out_bufsz)
>> +{
>> +    int fd = lo_fi_fd(req, fi);
>> +    int res;
>> +    int saverr = ENOSYS;
>> +    int dir;
>> +    void *buf = NULL;
>> +    size_t size = 0;
>> +
>> +    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
>> +            "in_bufsz = %lu, out_bufsz = %lu)\n",
>> +            ino, cmd, flags, in_bufsz, out_bufsz);
>> +
>> +    if (cmd != FS_IOC_SETFLAGS || cmd != FS_IOC_GETFLAGS ||
>> +        cmd != FS_IOC_FSSETXATTR || cmd != FS_IOC_FSGETXATTR)
>> +        goto out;
>> +
>> +    /* unrestricted ioctl is not supported yet */
>> +    if (flags & FUSE_IOCTL_UNRESTRICTED)
>> +        goto out;
>> +
>> +    dir = _IOC_DIR(cmd);
>> +
>> +    if (dir & _IOC_READ) {
>> +        size = out_bufsz;
>> +        buf = malloc(size);
>> +        if (!buf)
>> +            goto out_err;
>> +
>> +        if (dir & _IOC_WRITE)
>> +            memcpy(buf, in_buf, size);
>> +
>> +        res = ioctl(fd, cmd, buf);
>> +    }
>> +    else if (dir & _IOC_WRITE) {
> 
> Typically else is on same line as } braces.
> 
> } else if (dir & _IOC_WRITE) {
> 
> Have you tried running qemu/script/checkpatch.pl on these patches. Does it
> flag it?

Sorry, not yet. I have no experience contributing to qemu before... I
will check it next time and send a new version later.


-- 
Thanks,
Jeffle

