Date: Wed, 5 May 2021 19:59:45 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YJLrIW4ifEaePnPa@work-vm>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-9-dgilbert@redhat.com>
	<YJKLkQA2s6sgF587@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKLkQA2s6sgF587@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 08/26] DAX: virtio-fs: Add cache BAR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Apr 28, 2021 at 12:00:42PM +0100, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > Add a cache BAR into which files will be directly mapped.
> > The size can be set with the cache-size= property, e.g.
> >    -device vhost-user-fs-pci,chardev=char0,tag=myfs,cache-size=16G
> > 
> > The default is no cache.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > with PPC fixes by:
> > Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> > ---
> >  hw/virtio/vhost-user-fs-pci.c     | 32 +++++++++++++++++++++++++++++++
> >  hw/virtio/vhost-user-fs.c         | 32 +++++++++++++++++++++++++++++++
> >  include/hw/virtio/vhost-user-fs.h |  2 ++
> >  3 files changed, 66 insertions(+)
> > 
> > diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
> > index 2ed8492b3f..20e447631f 100644
> > --- a/hw/virtio/vhost-user-fs-pci.c
> > +++ b/hw/virtio/vhost-user-fs-pci.c
> > @@ -12,14 +12,19 @@
> >   */
> >  
> >  #include "qemu/osdep.h"
> > +#include "qapi/error.h"
> >  #include "hw/qdev-properties.h"
> >  #include "hw/virtio/vhost-user-fs.h"
> >  #include "virtio-pci.h"
> >  #include "qom/object.h"
> > +#include "standard-headers/linux/virtio_fs.h"
> > +
> > +#define VIRTIO_FS_PCI_CACHE_BAR 2
> >  
> >  struct VHostUserFSPCI {
> >      VirtIOPCIProxy parent_obj;
> >      VHostUserFS vdev;
> > +    MemoryRegion cachebar;
> >  };
> >  
> >  typedef struct VHostUserFSPCI VHostUserFSPCI;
> > @@ -38,7 +43,9 @@ static Property vhost_user_fs_pci_properties[] = {
> >  static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> >  {
> >      VHostUserFSPCI *dev = VHOST_USER_FS_PCI(vpci_dev);
> > +    bool modern_pio = vpci_dev->flags & VIRTIO_PCI_FLAG_MODERN_PIO_NOTIFY;
> >      DeviceState *vdev = DEVICE(&dev->vdev);
> > +    uint64_t cachesize;
> >  
> >      if (vpci_dev->nvectors == DEV_NVECTORS_UNSPECIFIED) {
> >          /* Also reserve config change and hiprio queue vectors */
> > @@ -46,6 +53,31 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> >      }
> >  
> >      qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> > +    cachesize = dev->vdev.conf.cache_size;
> > +
> > +    if (cachesize && modern_pio) {
> > +        error_setg(errp, "DAX Cache can not be used together with modern_pio");
> 
> It's not necessary to respin but it would help to capture the reason for
> this limitation either in the error message or at least in a comment.
> 
> The problem is that PCI BARs are limited resources and enabling modern
> PIO notify conflicts with the DAX Window BAR usage.

OK, I've added that as a comment:

    if (cachesize && modern_pio) {
        /*
         * We've not got enough BARs for the one used by the DAX cache
         * and also the one used by modern_pio
         */
        error_setg(errp, "DAX Cache can not be used together with modern_pio");
        return;
    }

> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

Thanks.

Dave


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

