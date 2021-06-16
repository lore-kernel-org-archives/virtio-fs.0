Date: Wed, 16 Jun 2021 19:35:26 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YMpEbqEhCz9kMM8G@work-vm>
References: <YJQNIPaFCJlG7ZKc@stefanha-x1.localdomain>
	<20210506160223.GA277745@redhat.com>
	<YJj3RSxXKZHxmiKu@stefanha-x1.localdomain>
	<20210510152324.GB150402@horse>
	<YJlSHZ0vzNtCAjkJ@stefanha-x1.localdomain>
	<YK/uUUZI3zy9k8Vk@work-vm> <YMIv5odJWdkbJzWL@work-vm>
	<YMI8fS6m8CjtUtmE@stefanha-x1.localdomain>
	<YMnwOs9bxKLB8wSL@work-vm>
	<YMoY27s0zoFzE5wg@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMoY27s0zoFzE5wg@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH v3 26/26] virtiofsd: Ask qemu to drop
 CAP_FSETID if client asked for it
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Jun 16, 2021 at 01:36:10PM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > On Thu, Jun 10, 2021 at 04:29:42PM +0100, Dr. David Alan Gilbert wrote:
> > > > * Dr. David Alan Gilbert (dgilbert@redhat.com) wrote:
> > > > > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > > +    uint64_t addr; /* In the bus address of the device */
> > > 
> > > Please check the spec for preferred terminology. "bus address" isn't
> > > used in the spec, so there's probably another term for it.
> > 
> > I'm not seeing anything useful in the virtio spec; it mostly talks about
> > guest physical addresses; it does say 'bus addresses' in the definition
> > of 'VIRTIO_F_ACCESS_PLATFORM' .
> 
> I meant the docs/interop/vhost-user.rst spec.

I think they use the phrase 'guest address' so I've changed that to:

    uint64_t guest_addr; 

   Elsewhere in the vhost-user.rst it says:
   
   When the ``VIRTIO_F_IOMMU_PLATFORM`` feature has not been negotiated:
    
   * Guest addresses map to the vhost memory region containing that guest
     address.
    
   When the ``VIRTIO_F_IOMMU_PLATFORM`` feature has been negotiated:
    
   * Guest addresses are also called I/O virtual addresses (IOVAs).  They are
     translated to user addresses via the IOTLB.
   
> Stefan


-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

