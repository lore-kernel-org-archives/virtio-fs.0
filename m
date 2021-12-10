Message-ID: <f2a1bceb-5983-b450-f3c6-dbbbae11af3a@linux.alibaba.com>
Date: Fri, 10 Dec 2021 10:51:45 +0800
MIME-Version: 1.0
References: <20211102055646.103337-1-jefflexu@linux.alibaba.com>
	<20211102055646.103337-2-jefflexu@linux.alibaba.com>
	<YbJaJ90FldHUo1/C@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
In-Reply-To: <YbJaJ90FldHUo1/C@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v7 1/6] virtiofsd: add .ioctl() support
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



On 12/10/21 3:33 AM, Vivek Goyal wrote:
> On Tue, Nov 02, 2021 at 01:56:41PM +0800, Jeffle Xu wrote:
>> For passthrough, it passes corresponding ioctls to host directly.
>>
>> Currently only these ioctls that handling persistent inode flags, i.e.,
>> FS_IOC_[G|S]ETFLAGS and FS_IOC_FS[G|S]ETXATTR are supported for security
>> concern, though it's implemented in a quite general way, so that we can
>> expand the scope of allowed ioctls if it is really needed later.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  tools/virtiofsd/passthrough_ll.c      | 65 +++++++++++++++++++++++++++
>>  tools/virtiofsd/passthrough_seccomp.c |  1 +
>>  2 files changed, 66 insertions(+)
>>
>> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
>> index b7c1fa71b5..2768497be4 100644
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
>> @@ -2188,6 +2190,68 @@ out:
>>      fuse_reply_err(req, saverr);
>>  }
>>  
>> +
>> +static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd,
>> +                     void *arg, struct fuse_file_info *fi,
>> +                     unsigned flags, const void *in_buf,
>> +                     size_t in_bufsz, size_t out_bufsz)
>> +{
>> +    int res, dir;
>> +    int fd = lo_fi_fd(req, fi);
>> +    int saverr = ENOSYS;
>> +    void *buf = NULL;
>> +    size_t size = 0;
>> +
>> +    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
>> +            "in_bufsz = %lu, out_bufsz = %lu)\n",
>> +            ino, cmd, flags, in_bufsz, out_bufsz);
>> +
>> +    if (!(cmd == FS_IOC_SETFLAGS || cmd == FS_IOC_GETFLAGS ||
>> +          cmd == FS_IOC_FSSETXATTR || cmd == FS_IOC_FSGETXATTR)) {
>> +        goto out;
> 
> Good that you allowed only two operations. Still I think people might
> have concern about all the inode attrs and whether it is safe to
> allow that. For example immutable flag. Now even host can't delete
> that file without first clearing that flag. 

Yes, this will be an issue.

> I think it is doable
> just that involves extra step.
> 
> So we probably might have to block certain attrs if it becomes an
> issue or make it configurable.

Currently fuse kernel module only requires that virtiofsd shall support
the set flag path (FS_IOC_SETFLAGS/FS_IOC_FSSETXATTR), so that users
inside guest are able to set/clear FS_XFLAG_DAX flag. For the set flag
path, maybe we could support modifying FS_XFLAG_DAX flag first for the
security concern?

The get flag path(FS_IOC_GETFLAGS/FS_IOC_FSGETXATTR) is not strongly
required currently, since the DAX flag is totally constructed by
virtiofsd now. The use case of the get flag path may be like, users
inside guest may want to query the FS_XFLAG_DAX flag after setting
FS_XFLAG_DAX flag previously. The get flag path may also expose the file
attr of the host file to the guest, and thus maybe we shall also only
support quering FS_XFLAG_DAX flag as the first step.


> 
>> +    }
>> +
>> +    /* unrestricted ioctl is not supported yet */
>> +    if (flags & FUSE_IOCTL_UNRESTRICTED) {
>> +        goto out;
>> +    }
>> +
>> +    dir = _IOC_DIR(cmd);
>> +
>> +    if (dir & _IOC_READ) {
>> +        size = out_bufsz;
>> +        buf = malloc(size);
>> +        if (!buf) {
>> +            goto out_err;
>> +        }
>> +
>> +        if (dir & _IOC_WRITE) {
>> +            memcpy(buf, in_buf, size);
>> +        }
>> +
>> +        res = ioctl(fd, cmd, buf);
>> +    } else if (dir & _IOC_WRITE) {
>> +        res = ioctl(fd, cmd, in_buf);
>> +    } else {
>> +        res = ioctl(fd, cmd, arg);
>> +    }
> 
> I do not understand this if block. So if _IOC_READ and _IOC_WRITE
> is not set, then we just send "arg" as third argument. Can you
> shed some light on how this third argument works for file attr
> flags. 

In theory ioctl could be neither _IOC_READ nor _IOC_WRITE. I implement
this if block just for the completeness of the logic for ioctl support.
It doesn't matter with the file attr though.


> I am assuming that "lsattr" will use the _IOC_READ path,
> while chattr will use "_IOC_WRITE" path? If that's the case,
> as of now third condition is not even required. Until and unless
> we are supporting more ioctls.
> 

Sure, I can remove this if block for now.

-- 
Thanks,
Jeffle

