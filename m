Date: Thu, 11 Jul 2019 12:25:58 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190711112558.GJ3971@work-vm>
References: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: conditional compile seccomp flag
	support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ren <renzhen@linux.alibaba.com>
Cc: virtio-fs@redhat.com

* Eric Ren (renzhen@linux.alibaba.com) wrote:
> SCMP_FLTATTR_CTL_TSYNC flag is only available on
> Linux Kernel 3.17 or greater. So, conditional compile
> to make virtio-fs work on older host kernel.
> 
> Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> ---
>  contrib/virtiofsd/seccomp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> index 4e388adc9c..5a28a90859 100644
> --- a/contrib/virtiofsd/seccomp.c
> +++ b/contrib/virtiofsd/seccomp.c
> @@ -11,6 +11,7 @@
>  #include <errno.h>
>  #include <seccomp.h>
>  #include <glib.h>
> +#include <linux/version.h>
>  #include "seccomp.h"
>  
>  static const int syscall_whitelist[] = {
> @@ -92,9 +93,12 @@ void setup_seccomp(void)
>  		err(1, "seccomp_init()");
>  	}
>  
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,17,0)

I don't really like using kernel versions, because sometimes downstreams
backport stuff (I checked and it looks like RHEL7 did this somewhere
around 7.5).

If I understand correctly the right thing to do is check the
SCMP_VER_MAJOR/MINOR/MICRO version defines; and I think tsync came in
with 2.3.1.

> +	// SCMP_FLTATR_CTL_TSYNC flag is only available on Linux Kernel 3.17 or greater
>  	if (seccomp_attr_set(ctx, SCMP_FLTATR_CTL_TSYNC, 1) != 0) {
>  		err(1, "seccomp_attr_set(ctx, SCMP_FLTATTR_CTL_TSYNC, 1)");

Also, what happens if this fails?  e.g. I run it on an older kernel than
it's built for;  do we actually fail here or just print the error.

Eithe rway, is it actually safe without this define - or does the thread
which actually runs the work not get the support?

Dave

>  	}
> +#endif
>  
>  	for (i = 0; i < G_N_ELEMENTS(syscall_whitelist); i++) {
>  		if (seccomp_rule_add(ctx, SCMP_ACT_ALLOW,
> -- 
> 2.17.2 (Apple Git-113)
> 
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

