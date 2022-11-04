Return-Path: <vgoyal@redhat.com>
Date: Fri, 4 Nov 2022 09:00:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Y2UM/C3aYtQwf40M@redhat.com>
References: <87r0yj17l6.fsf@oldenburg.str.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0yj17l6.fsf@oldenburg.str.redhat.com>
Subject: Re: [Virtio-fs] Use of unshare(CLONE_FS) in virtiofsd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Florian Weimer <fweimer@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, Sergio Lopez <slp@redhat.com>


On Fri, Nov 04, 2022 at 08:50:45AM +0100, Florian Weimer wrote:
> I've got a proposed extension for glibc's pthread_create which allows
> the creation of threads with a dedicated current working
> directory/umask/chroot:
> 
>   [PATCH 0/2] Introduce per-thread file system properties on Linux
>   <https://sourceware.org/pipermail/libc-alpha/2022-October/142640.html>
> 
> I expect that glibc integration will work around the seccomp issue
> mentioned in a comment (also brought up by the Samba people for their
> use) because glibc will perform the unshare directly during the clone
> system call, and not via a separate system call.
> 
> I see that unshare(CLONE_FS) was introduced in this commit:
> 
> commit bdfd66788349acc43cd3f1298718ad491663cfcc
> Author: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Date:   Thu Feb 27 14:59:27 2020 +0900
> 
>     virtiofsd: Fix xattr operations
>     
>     Current virtiofsd has problems about xattr operations and
>     they does not work properly for directory/symlink/special file.
>     
>     The fundamental cause is that virtiofsd uses openat() + f...xattr()
>     systemcalls for xattr operation but we should not open symlink/special
>     file in the daemon. Therefore the function is restricted.
>     
>     Fix this problem by:
>      1. during setup of each thread, call unshare(CLONE_FS)
>      2. in xattr operations (i.e. lo_getxattr), if inode is not a regular
>         file or directory, use fchdir(proc_loot_fd) + ...xattr() +
>         fchdir(root.fd) instead of openat() + f...xattr()
>     
>         (Note: for a regular file/directory openat() + f...xattr()
>          is still used for performance reason)
>     
>     With this patch, xfstests generic/062 passes on virtiofs.
>     
>     This fix is suggested by Miklos Szeredi and Stefan Hajnoczi.
>     The original discussion can be found here:
>       https://www.redhat.com/archives/virtio-fs/2019-October/msg00046.html
>     
>     Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>     Message-Id: <20200227055927.24566-3-misono.tomohiro@jp.fujitsu.com>
>     Acked-by: Vivek Goyal <vgoyal@redhat.com>
>     Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>     Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> Now the question has come up on the libc-coord list why the *at
> interfaces are not used in such cases:
> 
>   <https://www.openwall.com/lists/libc-coord/2022/10/24/3>
> 
> Clearly the kernel lacks support for fgetxattrat today.

[ CC German, Sergio ]

fgetxattrat() will be nice.

>  The usual
> recommendation for emulating it is to use openat with O_PATH, and then
> use getxattr on the virtual /proc/self/fd path.  This needs an
> additional system call (openat, getxattr, close instead of fchdir,
> getxattr),

openat(O_PATH) + getxattr(/proc/self/fd) + close() sounds reasonable
too. Not sure why did we not take that path. May be due to that extra
syscall or something else.

> but it avoids the unshare(CLONE_FS) call behind libc's back.

Hmm.., did not know that libc does not like threads calling
unshare(CLONE_FS). Not sure why that is a problem.

BTW, we need separate umask per thread as well. During file creation 
we might be switching to umask provide in fuse protocol message
and then switch back. Given multiple therads might be doing this
creation in parallel, so we ofcourse need this to be per thread
property.

So if your patches for pthread_create() with per thread filesystem
attributes finally goes upstream, I guess we should be able to
make use of it and drop unshare(CLONE_FS).

Thanks
Vivek

> The directory entries in /proc/self/fd present as symbolic links, but
> are not implemented as such by the kernel: there is no separate pathname
> lookup for already-open O_PATH descriptors, so there is no race.
> 
> Thoughts?
> 
> Thanks,
> Florian
> 
