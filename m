Date: Tue, 22 Jun 2021 09:45:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210622134529.GA1493988@redhat.com>
References: <6CB1BF38-465E-44CB-B9C4-BB09258BAB1B@ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6CB1BF38-465E-44CB-B9C4-BB09258BAB1B@ibm.com>
Subject: Re: [Virtio-fs] virtiofsd: doesn't garant write access at users
 allowed by group permission
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ameer Ghani <Ameer.Ghani@ibm.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

On Fri, Jun 18, 2021 at 11:28:13PM +0000, Ameer Ghani wrote:
> Hello,
> 
> We were experiencing the same issue w/r/t group permissions not being respected
> on directories.
> 
> I did a quick-and-dirty hack to add the SECBIT_NO_SETUID_FIXUP securebit, as
> suggested by Chirantan and Vivek, and that seems to have done the trick. Looks
> like if we set the securebits before we setup sandbox we can avoid leaving the
> process with CAP_SETPCAP.

This is assuming that in all the cases we need not drop capabilities upon
uid switch. Hmm.., thinking about couple of use caches of swithing uid/gid
I have in mind.

- I have proposed ACL support patches for virtiofs. There I need to switch
  gid (atleast) and drop CAP_FSETID. Currently I am switching both uid/gid
  and dropping CAP_FSETID explicitly. But If I know that I am switching
  uid to non-zero and that will automatically drop CAP_FSETID, then I 
  will not have made explicit call to drop CAP_FSETID.

- There have been reports of some xfstests failing when virtiofsd is
  running on top of NFS with "-o killpriv_v2" enabled. For NFS, just
  dropping CAP_FSETID is not enough to clear suid/sgid (as local file
  systems do). So we probably will have to switch uid/gid in some
  more places where we kill suid/sgid bits so that it works on top of
  NFS too. Do we care about dropping capabilities, not sure. Maybe not.

  So I guess this is just an optimization. If we leave SECBIT_NO_SETUID_FIXUP
  set for virtiofsd for its life, then we need to make sure if we need
  to make sure that any capability will have to be dropped explicitly
  and just uid switch will not drop capability automatically.

I guess its ok to set SECBIT_NO_SETUID_FIXUP and drop CAP_SETPCAP and
let virtiosd drop capabilities explicitly where need be.

If this becomes too painful or inefficient from performance point of view,
we probably will have to change it and set SECBIT_NO_SETUID_FIXUP only
during file creation path. (lo_create and lo_mknod).

> 
> Seems a better approach would just to expose the ability to set securebits at
> the CLI like what is done with caps. Then anybody affected by this bug can set
> SECBIT_NO_SETUID_FIXUP themselves. I'd prefer this if the maintainers agree.

I would think that don't ask user to opt-in for this behavior and just
implement it for everyone. Asking too many many questions will make
configuration more complex.

> 
> Would be happy to clean up my patch and submit it--just want to check if this
> is an approach y'all are content with.

Can you please also run xfstests and see if this patch introduces any
regressions. Just want to make sure there are no unintended side affects.

Please do submit a formal patch.

> 
> Current patch is included if anybody wants to try it out. Note that the
> securebits header is lifted from kernel 5.4.0 /usr/include/linux/securebits.h

You have have to split changes in two patches. First patch probably adds
latest header (from 5.13-rc5) kernel and second patch does the securebit
magic.

Thanks
Vivek
> 
> Thanks,
> Ameer Ghani
> 
> ---
> include/standard-headers/linux/securebits.h | 61 +++++++++++++++++++++
> tools/virtiofsd/passthrough_ll.c            | 15 +++++
> 2 files changed, 76 insertions(+)
> create mode 100644 include/standard-headers/linux/securebits.h
> 
> diff --git a/include/standard-headers/linux/securebits.h b/include/standard-headers/linux/securebits.h
> new file mode 100644
> index 0000000000..69c11a49c5
> --- /dev/null
> +++ b/include/standard-headers/linux/securebits.h
> @@ -0,0 +1,61 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _LINUX_SECUREBITS_H
> +#define _LINUX_SECUREBITS_H
> +
> +/* Each securesetting is implemented using two bits. One bit specifies
> +   whether the setting is on or off. The other bit specify whether the
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
> +#define issecure_mask(X)  (1 << (X))
> +
> +#define SECUREBITS_DEFAULT 0x00000000
> +
> +/* When set UID 0 has no special privileges. When unset, we support
> +   inheritance of root-permissions and suid-root executable under
> +   compatibility mode. We raise the effective and inheritable bitmasks
> +   *of the executable file* if the effective uid of the new process is
> +   0. If the real uid is 0, we raise the effective (legacy) bit of the
> +   executable file. */
> +#define SECURE_NOROOT                0
> +#define SECURE_NOROOT_LOCKED         1  /* make bit-0 immutable */
> +
> +#define SECBIT_NOROOT          (issecure_mask(SECURE_NOROOT))
> +#define SECBIT_NOROOT_LOCKED    (issecure_mask(SECURE_NOROOT_LOCKED))
> +
> +/* When set, setuid to/from uid 0 does not trigger capability-"fixup".
> +   When unset, to provide compatiblility with old programs relying on
> +   set*uid to gain/lose privilege, transitions to/from uid 0 cause
> +   capabilities to be gained/lost. */
> +#define SECURE_NO_SETUID_FIXUP       2
> +#define SECURE_NO_SETUID_FIXUP_LOCKED 3  /* make bit-2 immutable */
> +
> +#define SECBIT_NO_SETUID_FIXUP  (issecure_mask(SECURE_NO_SETUID_FIXUP))
> +#define SECBIT_NO_SETUID_FIXUP_LOCKED \
> +               (issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))
> +
> +/* When set, a process can retain its capabilities even after
> +   transitioning to a non-root user (the set-uid fixup suppressed by
> +   bit 2). Bit-4 is cleared when a process calls exec(); setting both
> +   bit 4 and 5 will create a barrier through exec that no exec()'d
> +   child can use this feature again. */
> +#define SECURE_KEEP_CAPS        4
> +#define SECURE_KEEP_CAPS_LOCKED      5  /* make bit-4 immutable */
> +
> +#define SECBIT_KEEP_CAPS  (issecure_mask(SECURE_KEEP_CAPS))
> +#define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
> +
> +/* When set, a process cannot add new capabilities to its ambient set. */
> +#define SECURE_NO_CAP_AMBIENT_RAISE       6
> +#define SECURE_NO_CAP_AMBIENT_RAISE_LOCKED 7  /* make bit-6 immutable */
> +
> +#define SECBIT_NO_CAP_AMBIENT_RAISE (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
> +#define SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED \
> +               (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE_LOCKED))
> +
> +#define SECURE_ALL_BITS         (issecure_mask(SECURE_NOROOT) | \
> +                    issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> +                    issecure_mask(SECURE_KEEP_CAPS) | \
> +                    issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE))
> +#define SECURE_ALL_LOCKS  (SECURE_ALL_BITS << 1)
> +
> +#endif /* _LINUX_SECUREBITS_H */
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
> index 49c21fd855..afec9a6567 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -43,6 +43,7 @@
> #include "fuse_log.h"
> #include "fuse_lowlevel.h"
> #include "standard-headers/linux/fuse.h"
> +#include "standard-headers/linux/securebits.h"
> #include <cap-ng.h>
> #include <dirent.h>
> #include <pthread.h>
> @@ -3515,6 +3516,17 @@ static void setup_chroot(struct lo_data *lo)
>      }
> }
> +static void setup_securebits(void)
> +{
> +    int status;
> +
> +    status = prctl(PR_SET_SECUREBITS, SECBIT_NO_SETUID_FIXUP);
> +    if (status == -1) {
> +        fuse_log(FUSE_LOG_ERR, "prctl(PR_SET_SECUREBITS): %m\n");
> +        exit(1);
> +    }
> +}
> +
> /*
>   * Lock down this process to prevent access to other processes or files outside
>   * source directory.  This reduces the impact of arbitrary code execution bugs.
> @@ -3869,6 +3881,9 @@ int main(int argc, char *argv[])
>      setup_nofile_rlimit(opts.rlimit_nofile);
> +    /* Set securebits before we drop CAP_SETPCAP */
> +    setup_securebits();
> +
>      /* Must be before sandbox since it wants /proc */
>      setup_capng();
> --
> 2.25.1
> 

