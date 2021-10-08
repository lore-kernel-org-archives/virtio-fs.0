DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=RZ13MZivdugXV0dLtx5xbRJbITUpu2zyl25L9nPmuJw=;
	b=EHcKVYbg4wGng2H68ZxfN62Jvs
	J/19ViQpHUiMycxY2NlYLj0fNcA2B79J9JIGXFAYmMsZhUb+7rXhimWPMjrsWbCXfvxHSbGU/PCet
	kAg0wBZm8c/4VdRursOoURbPnVI4YEMSTJ6pCgVjyU9lcokNpciqCOVTSQTlYuP3XIwscs6ErNfuE
	hZjMe132MwgehU7xRXHs/1K8ag8tDzRxYOd7vNlv23f3EnLvAoqcRsX6CxaUEPr5hZ2LZ5DFSFbnI
	6opNNpWcPTtvXb2PCUBbyylRkNNAbdJBkK3OSGO9fwroSNoQQcajHs+X4yFAncwT3xUjW/jl7XD6y
	/ynduDmfG0mbCL5rE+U8c7wCtF2dycOsxDiRbPpirFrR5/0axMB3H2tIMGa5rLPnfyfyZLIfIWp/A
	u2/2HGgibpN/bsWIAcw9UHI8Mw7ylMHzNeUHydnI7tjaUHroTL3tWmbKETaslEESS6kAd7NQdEg3m
	fj/ejDzvfXkFgvUfM0V7oxZflCwIXPjRyR6exy0Ok1V08SnqMXzbd2jc0SEPd09oPeZNOwJZYUijY
	j0AOUFIHcYVlPbpQ9dlEtovSCZboWdZs3rJcz6hNFOqT+V74kno2wNdiEV13pmUardUCPab0WbMtJ
	K8ROIpi9OpdjlM3C8p14XnVm9lM5wIo3zI3JiKJcw=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Fri, 08 Oct 2021 16:48:33 +0200
Message-ID: <1903319.Sgii2z2lGP@silver>
In-Reply-To: <YV8Pqwap4oR8fpvc@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<5138892.89BctLniTh@silver>
	<YV8Pqwap4oR8fpvc@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] [PATCH v2 1/3] virtio: turn VIRTQUEUE_MAX_SIZE into
	a variable
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>

On Donnerstag, 7. Oktober 2021 17:18:03 CEST Stefan Hajnoczi wrote:
> On Thu, Oct 07, 2021 at 03:09:16PM +0200, Christian Schoenebeck wrote:
> > On Mittwoch, 6. Oktober 2021 16:42:34 CEST Stefan Hajnoczi wrote:
> > > On Wed, Oct 06, 2021 at 02:50:07PM +0200, Christian Schoenebeck wrote:
> > > > On Mittwoch, 6. Oktober 2021 13:06:55 CEST Stefan Hajnoczi wrote:
> > > > > On Tue, Oct 05, 2021 at 06:32:46PM +0200, Christian Schoenebeck 
wrote:
> > > > > > On Dienstag, 5. Oktober 2021 17:10:40 CEST Stefan Hajnoczi wrote:
> > > > > > > On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck
> > 
> > wrote:
> > > > > > > > On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi 
wrote:
> > > > > > > > > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian
> > > > > > > > > Schoenebeck
> > > > 
> > > > wrote:
> > > > > > > > > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a
> > > > > > > > > > runtime
> > > > > > > > > > variable per virtio user.
> > > > > > > > > 
> > > > > > > > > virtio user == virtio device model?
> > > > > > > > 
> > > > > > > > Yes
> > > > > > > > 
> > > > > > > > > > Reasons:
> > > > > > > > > > 
> > > > > > > > > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute
> > > > > > > > > > theoretical
> > > > > > > > > > 
> > > > > > > > > >     maximum queue size possible. Which is actually the
> > > > > > > > > >     maximum
> > > > > > > > > >     queue size allowed by the virtio protocol. The
> > > > > > > > > >     appropriate
> > > > > > > > > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > > > > > > > > >     
> > > > > > > > > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/vi
> > > > > > > > > >     rtio
> > > > > > > > > >     -v1.
> > > > > > > > > >     1-cs
> > > > > > > > > >     01.h
> > > > > > > > > >     tml#x1-240006
> > > > > > > > > >     
> > > > > > > > > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with
> > > > > > > > > >     a
> > > > > > > > > >     more or less arbitrary value of 1024 in the past,
> > > > > > > > > >     which
> > > > > > > > > >     limits the maximum transfer size with virtio to 4M
> > > > > > > > > >     (more precise: 1024 * PAGE_SIZE, with the latter
> > > > > > > > > >     typically
> > > > > > > > > >     being 4k).
> > > > > > > > > 
> > > > > > > > > Being equal to IOV_MAX is a likely reason. Buffers with more
> > > > > > > > > iovecs
> > > > > > > > > than
> > > > > > > > > that cannot be passed to host system calls (sendmsg(2),
> > > > > > > > > pwritev(2),
> > > > > > > > > etc).
> > > > > > > > 
> > > > > > > > Yes, that's use case dependent. Hence the solution to opt-in
> > > > > > > > if it
> > > > > > > > is
> > > > > > > > desired and feasible.
> > > > > > > > 
> > > > > > > > > > (2) Additionally the current value of 1024 poses a hidden
> > > > > > > > > > limit,
> > > > > > > > > > 
> > > > > > > > > >     invisible to guest, which causes a system hang with
> > > > > > > > > >     the
> > > > > > > > > >     following QEMU error if guest tries to exceed it:
> > > > > > > > > >     
> > > > > > > > > >     virtio: too many write descriptors in indirect table
> > > > > > > > > 
> > > > > > > > > I don't understand this point. 2.6.5 The Virtqueue
> > > > > > > > > Descriptor
> > > > > > > > > Table
> > > > > > 
> > > > > > says:
> > > > > > > > >   The number of descriptors in the table is defined by the
> > > > > > > > >   queue
> > > > > > > > >   size
> > > > > > > > >   for
> > > > > > > > > 
> > > > > > > > > this virtqueue: this is the maximum possible descriptor
> > > > > > > > > chain
> > > > > > > > > length.
> > > > > > > > > 
> > > > > > > > > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors 
says:
> > > > > > > > >   A driver MUST NOT create a descriptor chain longer than
> > > > > > > > >   the
> > > > > > > > >   Queue
> > > > > > > > >   Size
> > > > > > > > >   of
> > > > > > > > > 
> > > > > > > > > the device.
> > > > > > > > > 
> > > > > > > > > Do you mean a broken/malicious guest driver that is
> > > > > > > > > violating
> > > > > > > > > the
> > > > > > > > > spec?
> > > > > > > > > That's not a hidden limit, it's defined by the spec.
> > > > > > > > 
> > > > > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781
> > > > > > > > .htm
> > > > > > > > l
> > > > > > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788
> > > > > > > > .htm
> > > > > > > > l
> > > > > > > > 
> > > > > > > > You can already go beyond that queue size at runtime with the
> > > > > > > > indirection
> > > > > > > > table. The only actual limit is the currently hard coded value
> > > > > > > > of
> > > > > > > > 1k
> > > > > > > > pages.
> > > > > > > > Hence the suggestion to turn that into a variable.
> > > > > > > 
> > > > > > > Exceeding Queue Size is a VIRTIO spec violation. Drivers that
> > > > > > > operate
> > > > > > > outsided the spec do so at their own risk. They may not be
> > > > > > > compatible
> > > > > > > with all device implementations.
> > > > > > 
> > > > > > Yes, I am ware about that. And still, this practice is already
> > > > > > done,
> > > > > > which
> > > > > > apparently is not limited to 9pfs.
> > > > > > 
> > > > > > > The limit is not hidden, it's Queue Size as defined by the spec
> > > > > > > :).
> > > > > > > 
> > > > > > > If you have a driver that is exceeding the limit, then please
> > > > > > > fix
> > > > > > > the
> > > > > > > driver.
> > > > > > 
> > > > > > I absolutely understand your position, but I hope you also
> > > > > > understand
> > > > > > that
> > > > > > this violation of the specs is a theoretical issue, it is not a
> > > > > > real-life
> > > > > > problem right now, and due to lack of man power unfortunately I
> > > > > > have
> > > > > > to
> > > > > > prioritize real-life problems over theoretical ones ATM. Keep in
> > > > > > mind
> > > > > > that
> > > > > > right now I am the only person working on 9pfs actively, I do this
> > > > > > voluntarily whenever I find a free time slice, and I am not paid
> > > > > > for
> > > > > > it
> > > > > > either.
> > > > > > 
> > > > > > I don't see any reasonable way with reasonable effort to do what
> > > > > > you
> > > > > > are
> > > > > > asking for here in 9pfs, and Greg may correct me here if I am
> > > > > > saying
> > > > > > anything wrong. If you are seeing any specific real-life issue
> > > > > > here,
> > > > > > then
> > > > > > please tell me which one, otherwise I have to postpone that "specs
> > > > > > violation" issue.
> > > > > > 
> > > > > > There is still a long list of real problems that I need to hunt
> > > > > > down
> > > > > > in
> > > > > > 9pfs, afterwards I can continue with theoretical ones if you want,
> > > > > > but
> > > > > > right now I simply can't, sorry.
> > > > > 
> > > > > I understand. If you don't have time to fix the Linux virtio-9p
> > > > > driver
> > > > > then that's fine.
> > > > 
> > > > I will look at this again, but it might be tricky. On doubt I'll
> > > > postpone
> > > > it.>
> > > > 
> > > > > I still wanted us to agree on the spec position because the commit
> > > > > description says it's a "hidden limit", which is incorrect. It might
> > > > > seem pedantic, but my concern is that misconceptions can spread if
> > > > > we
> > > > > let them. That could cause people to write incorrect code later on.
> > > > > Please update the commit description either by dropping 2) or by
> > > > > 
> > > > > replacing it with something else. For example:
> > > > >   2) The Linux virtio-9p guest driver does not honor the VIRTIO
> > > > >   Queue
> > > > >   
> > > > >      Size value and can submit descriptor chains that exceed it.
> > > > >      That is
> > > > >      a spec violation but is accepted by QEMU's device
> > > > >      implementation.
> > > > >      
> > > > >      When the guest creates a descriptor chain larger than 1024 the
> > > > >      following QEMU error is printed and the guest hangs:
> > > > >      
> > > > >      virtio: too many write descriptors in indirect table
> > > > 
> > > > I am fine with both, probably preferring the text block above instead
> > > > of
> > > > silently dropping the reason, just for clarity.
> > > > 
> > > > But keep in mind that this might not be limited to virtio-9p as your
> > > > text
> > > > would suggest, see below.
> > > > 
> > > > > > > > > > (3) Unfortunately not all virtio users in QEMU would
> > > > > > > > > > currently
> > > > > > > > > > 
> > > > > > > > > >     work correctly with the new value of 32768.
> > > > > > > > > > 
> > > > > > > > > > So let's turn this hard coded global value into a runtime
> > > > > > > > > > variable as a first step in this commit, configurable for
> > > > > > > > > > each
> > > > > > > > > > virtio user by passing a corresponding value with
> > > > > > > > > > virtio_init()
> > > > > > > > > > call.
> > > > > > > > > 
> > > > > > > > > virtio_add_queue() already has an int queue_size argument,
> > > > > > > > > why
> > > > > > > > > isn't
> > > > > > > > > that enough to deal with the maximum queue size? There's
> > > > > > > > > probably a
> > > > > > > > > good
> > > > > > > > > reason for it, but please include it in the commit
> > > > > > > > > description.
> > > > > > > > 
> > > > > > > > [...]
> > > > > > > > 
> > > > > > > > > Can you make this value per-vq instead of per-vdev since
> > > > > > > > > virtqueues
> > > > > > > > > can
> > > > > > > > > have different queue sizes?
> > > > > > > > > 
> > > > > > > > > The same applies to the rest of this patch. Anything using
> > > > > > > > > vdev->queue_max_size should probably use vq->vring.num
> > > > > > > > > instead.
> > > > > > > > 
> > > > > > > > I would like to avoid that and keep it per device. The maximum
> > > > > > > > size
> > > > > > > > stored
> > > > > > > > there is the maximum size supported by virtio user (or vortio
> > > > > > > > device
> > > > > > > > model,
> > > > > > > > however you want to call it). So that's really a limit per
> > > > > > > > device,
> > > > > > > > not
> > > > > > > > per
> > > > > > > > queue, as no queue of the device would ever exceed that limit.
> > > > > > > > 
> > > > > > > > Plus a lot more code would need to be refactored, which I
> > > > > > > > think is
> > > > > > > > unnecessary.
> > > > > > > 
> > > > > > > I'm against a per-device limit because it's a concept that
> > > > > > > cannot
> > > > > > > accurately describe reality. Some devices have multiple classes
> > > > > > > of
> > > > > > 
> > > > > > It describes current reality, because VIRTQUEUE_MAX_SIZE obviously
> > > > > > is
> > > > > > not
> > > > > > per queue either ATM, and nobody ever cared.
> > > > > > 
> > > > > > All this series does, is allowing to override that currently
> > > > > > project-wide
> > > > > > compile-time constant to a per-driver-model compile-time constant.
> > > > > > Which
> > > > > > makes sense, because that's what it is: some drivers could cope
> > > > > > with
> > > > > > any
> > > > > > transfer size, and some drivers are constrained to a certain
> > > > > > maximum
> > > > > > application specific transfer size (e.g. IOV_MAX).
> > > > > > 
> > > > > > > virtqueues and they are sized differently, so a per-device limit
> > > > > > > is
> > > > > > > insufficient. virtio-net has separate rx_queue_size and
> > > > > > > tx_queue_size
> > > > > > > parameters (plus a control vq hardcoded to 64 descriptors).
> > > > > > 
> > > > > > I simply find this overkill. This value semantically means "my
> > > > > > driver
> > > > > > model
> > > > > > supports at any time and at any coincidence at the very most x *
> > > > > > PAGE_SIZE
> > > > > > = max_transfer_size". Do you see any driver that might want a more
> > > > > > fine
> > > > > > graded control over this?
> > > > > 
> > > > > One reason why per-vq limits could make sense is that the maximum
> > > > > possible number of struct elements is allocated upfront in some code
> > > > > paths. Those code paths may need to differentiate between per-vq
> > > > > limits
> > > > > for performance or memory utilization reasons. Today some places
> > > > > allocate 1024 elements on the stack in some code paths, but maybe
> > > > > that's
> > > > > not acceptable when the per-device limit is 32k. This can matter
> > > > > when a
> > > > > device has vqs with very different sizes.
> > > > 
> > > > [...]
> > > > 
> > > > > > ... I leave that up to Michael or whoever might be in charge to
> > > > > > decide. I
> > > > > > still find this overkill, but I will adapt this to whatever the
> > > > > > decision
> > > > > > eventually will be in v3.
> > > > > > 
> > > > > > But then please tell me the precise representation that you find
> > > > > > appropriate, i.e. whether you want a new function for that, or
> > > > > > rather
> > > > > > an
> > > > > > additional argument to virtio_add_queue(). Your call.
> > > > > 
> > > > > virtio_add_queue() already takes an int queue_size argument. I think
> > > > > the
> > > > > necessary information is already there.
> > > > > 
> > > > > This patch just needs to be tweaked to use the
> > > > > virtio_queue_get_num()
> > > > > (or a new virtqueue_get_num() API if that's easier because only a
> > > > > VirtQueue *vq pointer is available) instead of introducing a new
> > > > > per-device limit.
> > > > 
> > > > My understanding is that both the original 9p virtio device authors,
> > > > as
> > > > well as other virtio device authors in QEMU have been and are still
> > > > using
> > > > this as a default value (i.e. to allocate some upfront, and the rest
> > > > on
> > > > demand).
> > > > 
> > > > So yes, I know your argument about the specs, but AFAICS if I would
> > > > just
> > > > take this existing numeric argument for the limit, then it would
> > > > probably
> > > > break those other QEMU devices as well.
> > > 
> > > This is a good point that I didn't consider. If guest drivers currently
> > > violate the spec, then restricting descriptor chain length to vring.num
> > > will introduce regressions.
> > > 
> > > We can't use virtio_queue_get_num() directly. A backwards-compatible
> > > 
> > > limit is required:
> > >   int virtio_queue_get_desc_chain_max(VirtIODevice *vdev, int n)
> > >   {
> > >   
> > >       /*
> > >       
> > >        * QEMU historically allowed 1024 descriptors even if the
> > >        * descriptor table was smaller.
> > >        */
> > >       
> > >       return MAX(virtio_queue_get_num(vdev, qidx), 1024);
> > >   
> > >   }
> > 
> > That was an alternative that I thought about as well, but decided against.
> > It would require devices (that would want to support large transmissions
> > sizes)> 
> > to create the virtio queue(s) with the maximum possible size, i.e:
> >   virtio_add_queue(32k);
> 
> The spec allows drivers to set the size of the vring as long as they do
> not exceed Queue Size.
> 
> The Linux drivers accept the device's default size, so you're right that
> this would cause large vrings to be allocated if the device sets the
> virtqueue size to 32k.
> 
> > And that's the point where my current lack of knowledge, of what this
> > would
> > precisely mean to the resulting allocation set, decided against it. I mean
> > would that mean would QEMU's virtio implementation would just a) allocate
> > 32k scatter gather list entries? Or would it rather b) additionally also
> > allocate the destination memory pages as well?
> 
> The vring consumes guest RAM but it just consists of descriptors, not
> the buffer memory pages. The guest RAM requirements are:
> - split layout: 32k * 16 + 6 + 32k * 2 + 6 + 8 * 32k = 851,980 bytes
> - packed layout: 32k * 16 + 4 + 4 = 524,296 bytes
> 
> That's still quite large!
> 
> By the way, virtio-blk currently uses a virtqueue size of 256
> descriptors and this has been found reasonable for disk I/O performance.
> The Linux block layer splits requests at around 1.25 MB for virtio-blk.
> The virtio-blk queue limits are reported by the device and the guest
> Linux block layer uses them to size/split requests appropriately. I'm
> not sure 9p really needs 32k, although you're right that fragmented
> physical memory requires 32k descriptors to describe 128 MB of buffers.
> 
> Going back to the original problem, a vring feature bit could be added
> to the VIRTIO specification indicating that indirect descriptor tables
> are limited to the maximum (32k) instead of Queue Size. This way the
> device's default vring size could be small but drivers could allocate
> indirect descriptor tables that are large when necessary. Then the Linux
> virtio driver API would need to report the maximum supported sglist
> length for a given virtqueue so drivers can take advantage of this
> information.

Due to forced pragmatism, ~1M unused/wasted space would be acceptable IMHO.

But if that might really go up to 128M+ as you said if physical RAM is highly 
fragmented, then a cleaner solution would definitely make sense, yes, if 
that's possible.

But as changing specs etc. is probably a long process, it would make sense 
first doing some more tests with the kernel patches to find out whether there 
was probably some show stopper like IOV_MAX anyway.

As for whether large transfer sizes make sense at all: well, from the 
benchmarks I made so far I "think" it does make sense going >4M. It might be 
something specific to 9p (its a full file server), I guess it has a higher 
latency than raw virtio block devices. OTOH with M.2 SSDs we now have several 
thousand MB/s, so not sure if the old common transfer size of 1M for block 
devices is still reasonable today.

Best regards,
Christian Schoenebeck


