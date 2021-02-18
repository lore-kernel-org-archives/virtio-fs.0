Date: Thu, 18 Feb 2021 17:33:11 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YC6k156oLZt9fx5T@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-7-dgilbert@redhat.com>
	<20210211102555.GG247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211102555.GG247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 06/24] DAX: virtio-fs: Add cache BAR
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Feb 09, 2021 at 07:02:06PM +0000, Dr. David Alan Gilbert (git) wrote:
> > @@ -46,6 +51,26 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
> >      }
> >  
> >      qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> > +    cachesize = dev->vdev.conf.cache_size;
> > +
> > +    /*
> > +     * The bar starts with the data/DAX cache
> > +     * Others will be added later.
> > +     */
> > +    memory_region_init(&dev->cachebar, OBJECT(vpci_dev),
> > +                       "vhost-fs-pci-cachebar", cachesize);
> 
> s/vhost-fs/vhost-user-fs/ for consistency. Only worth changing if you
> respin.

Done.

> > +    if (cachesize) {
> > +        memory_region_add_subregion(&dev->cachebar, 0, &dev->vdev.cache);
> > +        virtio_pci_add_shm_cap(vpci_dev, VIRTIO_FS_PCI_CACHE_BAR, 0, cachesize,
> > +                               VIRTIO_FS_SHMCAP_ID_CACHE);
> > +    }
> > +
> > +    /* After 'realized' so the memory region exists */
> > +    pci_register_bar(&vpci_dev->pci_dev, VIRTIO_FS_PCI_CACHE_BAR,
> > +                     PCI_BASE_ADDRESS_SPACE_MEMORY |
> > +                     PCI_BASE_ADDRESS_MEM_PREFETCH |
> > +                     PCI_BASE_ADDRESS_MEM_TYPE_64,
> > +                     &dev->cachebar);
> 
> Please include a comment explainig why it's okay to use BAR 2, which is
> already used for the virtio-pci modern io bar (off by default):
> 
>     /*
>      * virtio pci bar layout used by default.
>      * subclasses can re-arrange things if needed.
>      *
>      *   region 0   --  virtio legacy io bar
>      *   region 1   --  msi-x bar
>      *   region 2   --  virtio modern io bar (off by default)
>      *   region 4+5 --  virtio modern memory (64bit) bar
>      *
>      */
> 
> I guess the idea is that the io bar is available since it's off by
> default. What happens if the io bar is enabled?

We don't have many choices; the only other option would be to extend
the modern memory bar at 4/5.

For now, I've added a check:

qemu-system-x86_64: -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=4G,modern-pio-notify=true: Cache can not be used together with modern_pio

> Should this bar registration should be conditional (only when cache size
> is greater than 0)?

Yes, added.

Dave


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

