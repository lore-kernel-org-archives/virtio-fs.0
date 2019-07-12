Date: Fri, 12 Jul 2019 20:27:24 +0800
From: Eric Ren <renzhen@linux.alibaba.com>
Message-ID: <20190712122724.GC8976@ali-6c96cfe09cf9.local>
References: <5e2722ade8346b09cbc4a147757a45b527b5a846.1562763758.git.renzhen@linux.alibaba.com>
	<20190712080446.GC24428@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190712080446.GC24428@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: conditional compile seccomp flag
 support
Reply-To: Eric Ren <renzhen@linux.alibaba.com>
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

On Fri, Jul 12, 2019 at 10:04:46AM +0200, Stefan Hajnoczi wrote:
> On Wed, Jul 10, 2019 at 09:06:42PM +0800, Eric Ren wrote:
> > SCMP_FLTATTR_CTL_TSYNC flag is only available on
> > Linux Kernel 3.17 or greater. So, conditional compile
> > to make virtio-fs work on older host kernel.
> > 
> > Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> > ---
> >  contrib/virtiofsd/seccomp.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/contrib/virtiofsd/seccomp.c b/contrib/virtiofsd/seccomp.c
> > index 4e388adc9c..5a28a90859 100644
> > --- a/contrib/virtiofsd/seccomp.c
> > +++ b/contrib/virtiofsd/seccomp.c
> > @@ -11,6 +11,7 @@
> >  #include <errno.h>
> >  #include <seccomp.h>
> >  #include <glib.h>
> > +#include <linux/version.h>
> >  #include "seccomp.h"
> >  
> >  static const int syscall_whitelist[] = {
> > @@ -92,9 +93,12 @@ void setup_seccomp(void)
> >  		err(1, "seccomp_init()");
> >  	}
> >  
> > +#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,17,0)
> > +	// SCMP_FLTATR_CTL_TSYNC flag is only available on Linux Kernel 3.17 or greater
> >  	if (seccomp_attr_set(ctx, SCMP_FLTATR_CTL_TSYNC, 1) != 0) {
> >  		err(1, "seccomp_attr_set(ctx, SCMP_FLTATTR_CTL_TSYNC, 1)");
> >  	}
> > +#endif
> 
> There are no threads when setup_seccomp() is invoked so the TSYNC
> attribute is not required.

Aha, great.

> Please remove the TSYNC call.  Then we don't need to worry about version
> or feature checks.

OK.

Regards,
Eric


> 
> Thanks,
> Stefan


