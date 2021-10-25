DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=XKhNnE3Lf39+tglyt/YDURzuB8IrY2nusvkOxS2Hg4A=;
	b=o5zRUlLHKo+qFIWJF/w+AHGSne
	3IaLWevXqlA0nEJe67BXmz5aNGycor4hEEj4wItY7AcEFJwZ5tjMEEepSyBfJ6jV8W7K1JYIWyotR
	CXhfBgkl6X/LpwJ+Sa34RsQQCnQ9dniPBYDvHXBfhJJRvkzwuPf+SGFXqJoWVRqXjvN0TJMOo+Vmz
	XiE3NcdqMVC2uP6BoPphjAPGkUQoy22AN5rfl2cpjMqNtOiH/KBsjOA83i8NP6m6Cf7DQuu1j/dF/
	pkTPokzOfEBIuF0CmmPPwsCB3e/eH6we1iCQ07bdgYiJMT9/hsObbz8xojnlZRPC3C8uCkqoKchbV
	zBQH/ePYxZhCGCRaMKrxvFn6XMS7sGvsJ6VCyGFOa46KTthxxU6q2S4Lh/uWncE7Oxs+k8uQwuu6b
	ndB4B4v9OIBGjXQHUWKEYBlcPP+jgCcxr4gQd2w228+NaM2UrTDwvqllGCqhr8utIP/kN0lNG+NJW
	vwklwl+gc1NXDjCnj2/sRQ7t9qTDWir/ve0Zl7Aca250Iw8gx/me9kQuvKP7a2hnnFYA4YXSMvuZ6
	NDpctO24EpQuaS6L1xQwrBn96109JLOGHeMm5W+w2QpwOnqnPNWkrz+0n+PMo9oukguSGjh4fMTTz
	Mp4qK/je85iCP/HhRklBqU2qstPaRpNMYzDXXm8tw=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Mon, 25 Oct 2021 17:03:25 +0200
Message-ID: <10221570.6MffRmy8Bz@silver>
In-Reply-To: <YXaHUbtGoHRbcBBO@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<4038040.djDU9dF7GM@silver>
	<YXaHUbtGoHRbcBBO@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtio: increase VIRTQUEUE_MAX_SIZE
	to 32k
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

On Montag, 25. Oktober 2021 12:30:41 CEST Stefan Hajnoczi wrote:
> On Thu, Oct 21, 2021 at 05:39:28PM +0200, Christian Schoenebeck wrote:
> > On Freitag, 8. Oktober 2021 18:08:48 CEST Christian Schoenebeck wrote:
> > > On Freitag, 8. Oktober 2021 16:24:42 CEST Christian Schoenebeck wrote:
> > > > On Freitag, 8. Oktober 2021 09:25:33 CEST Greg Kurz wrote:
> > > > > On Thu, 7 Oct 2021 16:42:49 +0100
> > > > > 
> > > > > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > > > On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian Schoenebeck wrote:
> > > > > > > On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan Hajnoczi wrote:
> > > > > > > > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian
> > > > > > > > Schoenebeck
> > > 
> > > wrote:
> > > > > > > > > At the moment the maximum transfer size with virtio is
> > > > > > > > > limited
> > > > > > > > > to
> > > > > > > > > 4M
> > > > > > > > > (1024 * PAGE_SIZE). This series raises this limit to its
> > > > > > > > > maximum
> > > > > > > > > theoretical possible transfer size of 128M (32k pages)
> > > > > > > > > according
> > > > > > > > > to
> > > > > > > > > the
> > > > > > > > > virtio specs:
> > > > > > > > > 
> > > > > > > > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v
> > > > > > > > > 1.1-
> > > > > > > > > cs
> > > > > > > > > 01
> > > > > > > > > .html#
> > > > > > > > > x1-240006
> > > > > > > > 
> > > > > > > > Hi Christian,
> > > > > 
> > > > > > > > I took a quick look at the code:
> > > > > Hi,
> > > > > 
> > > > > Thanks Stefan for sharing virtio expertise and helping Christian !
> > > > > 
> > > > > > > > - The Linux 9p driver restricts descriptor chains to 128
> > > > > > > > elements
> > > > > > > > 
> > > > > > > >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
> > > > > > > 
> > > > > > > Yes, that's the limitation that I am about to remove (WIP);
> > > > > > > current
> > > > > > > kernel
> > > > > > > patches:
> > > > > > > https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@cr
> > > > > > > udeb
> > > > > > > yt
> > > > > > > e.
> > > > > > > com/>
> > > > > > 
> > > > > > I haven't read the patches yet but I'm concerned that today the
> > > > > > driver
> > > > > > is pretty well-behaved and this new patch series introduces a spec
> > > > > > violation. Not fixing existing spec violations is okay, but adding
> > > > > > new
> > > > > > ones is a red flag. I think we need to figure out a clean
> > > > > > solution.
> > > > 
> > > > Nobody has reviewed the kernel patches yet. My main concern therefore
> > > > actually is that the kernel patches are already too complex, because
> > > > the
> > > > current situation is that only Dominique is handling 9p patches on
> > > > kernel
> > > > side, and he barely has time for 9p anymore.
> > > > 
> > > > Another reason for me to catch up on reading current kernel code and
> > > > stepping in as reviewer of 9p on kernel side ASAP, independent of this
> > > > issue.
> > > > 
> > > > As for current kernel patches' complexity: I can certainly drop patch
> > > > 7
> > > > entirely as it is probably just overkill. Patch 4 is then the biggest
> > > > chunk, I have to see if I can simplify it, and whether it would make
> > > > sense to squash with patch 3.
> > > > 
> > > > > > > > - The QEMU 9pfs code passes iovecs directly to preadv(2) and
> > > > > > > > will
> > > > > > > > fail
> > > > > > > > 
> > > > > > > >   with EINVAL when called with more than IOV_MAX iovecs
> > > > > > > >   (hw/9pfs/9p.c:v9fs_read())
> > > > > > > 
> > > > > > > Hmm, which makes me wonder why I never encountered this error
> > > > > > > during
> > > > > > > testing.
> > > > > > > 
> > > > > > > Most people will use the 9p qemu 'local' fs driver backend in
> > > > > > > practice,
> > > > > > > so
> > > > > > > that v9fs_read() call would translate for most people to this
> > > > > > > implementation on QEMU side (hw/9p/9p-local.c):
> > > > > > > 
> > > > > > > static ssize_t local_preadv(FsContext *ctx, V9fsFidOpenState
> > > > > > > *fs,
> > > > > > > 
> > > > > > >                             const struct iovec *iov,
> > > > > > >                             int iovcnt, off_t offset)
> > > > > > > 
> > > > > > > {
> > > > > > > #ifdef CONFIG_PREADV
> > > > > > > 
> > > > > > >     return preadv(fs->fd, iov, iovcnt, offset);
> > > > > > > 
> > > > > > > #else
> > > > > > > 
> > > > > > >     int err = lseek(fs->fd, offset, SEEK_SET);
> > > > > > >     if (err == -1) {
> > > > > > >     
> > > > > > >         return err;
> > > > > > >     
> > > > > > >     } else {
> > > > > > >     
> > > > > > >         return readv(fs->fd, iov, iovcnt);
> > > > > > >     
> > > > > > >     }
> > > > > > > 
> > > > > > > #endif
> > > > > > > }
> > > > > > > 
> > > > > > > > Unless I misunderstood the code, neither side can take
> > > > > > > > advantage
> > > > > > > > of
> > > > > > > > the
> > > > > > > > new 32k descriptor chain limit?
> > > > > > > > 
> > > > > > > > Thanks,
> > > > > > > > Stefan
> > > > > > > 
> > > > > > > I need to check that when I have some more time. One possible
> > > > > > > explanation
> > > > > > > might be that preadv() already has this wrapped into a loop in
> > > > > > > its
> > > > > > > implementation to circumvent a limit like IOV_MAX. It might be
> > > > > > > another
> > > > > > > "it
> > > > > > > works, but not portable" issue, but not sure.
> > > > > > > 
> > > > > > > There are still a bunch of other issues I have to resolve. If
> > > > > > > you
> > > > > > > look
> > > > > > > at
> > > > > > > net/9p/client.c on kernel side, you'll notice that it basically
> > > > > > > does
> > > > > > > this ATM> >
> > > > > > > 
> > > > > > >     kmalloc(msize);
> > > > > 
> > > > > Note that this is done twice : once for the T message (client
> > > > > request)
> > > > > and
> > > > > once for the R message (server answer). The 9p driver could adjust
> > > > > the
> > > > > size
> > > > > of the T message to what's really needed instead of allocating the
> > > > > full
> > > > > msize. R message size is not known though.
> > > > 
> > > > Would it make sense adding a second virtio ring, dedicated to server
> > > > responses to solve this? IIRC 9p server already calculates appropriate
> > > > exact sizes for each response type. So server could just push space
> > > > that's
> > > > really needed for its responses.
> > > > 
> > > > > > > for every 9p request. So not only does it allocate much more
> > > > > > > memory
> > > > > > > for
> > > > > > > every request than actually required (i.e. say 9pfs was mounted
> > > > > > > with
> > > > > > > msize=8M, then a 9p request that actually would just need 1k
> > > > > > > would
> > > > > > > nevertheless allocate 8M), but also it allocates > PAGE_SIZE,
> > > > > > > which
> > > > > > > obviously may fail at any time.>
> > > > > > 
> > > > > > The PAGE_SIZE limitation sounds like a kmalloc() vs vmalloc()
> > > > > > situation.
> > > > 
> > > > Hu, I didn't even consider vmalloc(). I just tried the kvmalloc()
> > > > wrapper
> > > > as a quick & dirty test, but it crashed in the same way as kmalloc()
> > > > with
> > > > large msize values immediately on mounting:
> > > > 
> > > > diff --git a/net/9p/client.c b/net/9p/client.c
> > > > index a75034fa249b..cfe300a4b6ca 100644
> > > > --- a/net/9p/client.c
> > > > +++ b/net/9p/client.c
> > > > @@ -227,15 +227,18 @@ static int parse_opts(char *opts, struct
> > > > p9_client
> > > > *clnt)
> > > > 
> > > >  static int p9_fcall_init(struct p9_client *c, struct p9_fcall *fc,
> > > >  
> > > >                          int alloc_msize)
> > > >  
> > > >  {
> > > > 
> > > > -       if (likely(c->fcall_cache) && alloc_msize == c->msize) {
> > > > +       //if (likely(c->fcall_cache) && alloc_msize == c->msize) {
> > > > +       if (false) {
> > > > 
> > > >                 fc->sdata = kmem_cache_alloc(c->fcall_cache,
> > > >                 GFP_NOFS);
> > > >                 fc->cache = c->fcall_cache;
> > > >         
> > > >         } else {
> > > > 
> > > > -               fc->sdata = kmalloc(alloc_msize, GFP_NOFS);
> > > > +               fc->sdata = kvmalloc(alloc_msize, GFP_NOFS);
> > > 
> > > Ok, GFP_NOFS -> GFP_KERNEL did the trick.
> > > 
> > > Now I get:
> > >    virtio: bogus descriptor or out of resources
> > > 
> > > So, still some work ahead on both ends.
> > 
> > Few hacks later (only changes on 9p client side) I got this running stable
> > now. The reason for the virtio error above was that kvmalloc() returns a
> > non-logical kernel address for any kvmalloc(>4M), i.e. an address that is
> > inaccessible from host side, hence that "bogus descriptor" message by
> > QEMU.
> > So I had to split those linear 9p client buffers into sparse ones (set of
> > individual pages).
> > 
> > I tested this for some days with various virtio transmission sizes and it
> > works as expected up to 128 MB (more precisely: 128 MB read space + 128 MB
> > write space per virtio round trip message).
> > 
> > I did not encounter a show stopper for large virtio transmission sizes
> > (4 MB ... 128 MB) on virtio level, neither as a result of testing, nor
> > after reviewing the existing code.
> > 
> > About IOV_MAX: that's apparently not an issue on virtio level. Most of the
> > iovec code, both on Linux kernel side and on QEMU side do not have this
> > limitation. It is apparently however indeed a limitation for userland apps
> > calling the Linux kernel's syscalls yet.
> > 
> > Stefan, as it stands now, I am even more convinced that the upper virtio
> > transmission size limit should not be squeezed into the queue size
> > argument of virtio_add_queue(). Not because of the previous argument that
> > it would waste space (~1MB), but rather because they are two different
> > things. To outline this, just a quick recap of what happens exactly when
> > a bulk message is pushed over the virtio wire (assuming virtio "split"
> > layout here):
> > 
> > ---------- [recap-start] ----------
> > 
> > For each bulk message sent guest <-> host, exactly *one* of the
> > pre-allocated descriptors is taken and placed (subsequently) into exactly
> > *one* position of the two available/used ring buffers. The actual
> > descriptor table though, containing all the DMA addresses of the message
> > bulk data, is allocated just in time for each round trip message. Say, it
> > is the first message sent, it yields in the following structure:
> > 
> > Ring Buffer   Descriptor Table      Bulk Data Pages
> > 
> >    +-+              +-+           +-----------------+
> >    
> >    |D|------------->|d|---------->| Bulk data block |
> >    
> >    +-+              |d|--------+  +-----------------+
> >    
> >    | |              |d|------+ |
> >    
> >    +-+               .       | |  +-----------------+
> >    
> >    | |               .       | +->| Bulk data block |
> >     
> >     .                .       |    +-----------------+
> >     .               |d|-+    |
> >     .               +-+ |    |    +-----------------+
> >     
> >    | |                  |    +--->| Bulk data block |
> >    
> >    +-+                  |         +-----------------+
> >    
> >    | |                  |                 .
> >    
> >    +-+                  |                 .
> >    
> >                         |                 .
> >                         |         
> >                         |         +-----------------+
> >                         
> >                         +-------->| Bulk data block |
> >                         
> >                                   +-----------------+
> > 
> > Legend:
> > D: pre-allocated descriptor
> > d: just in time allocated descriptor
> > -->: memory pointer (DMA)
> > 
> > The bulk data blocks are allocated by the respective device driver above
> > virtio subsystem level (guest side).
> > 
> > There are exactly as many descriptors pre-allocated (D) as the size of a
> > ring buffer.
> > 
> > A "descriptor" is more or less just a chainable DMA memory pointer;
> > defined
> > as:
> > 
> > /* Virtio ring descriptors: 16 bytes.  These can chain together via
> > "next". */ struct vring_desc {
> > 
> > 	/* Address (guest-physical). */
> > 	__virtio64 addr;
> > 	/* Length. */
> > 	__virtio32 len;
> > 	/* The flags as indicated above. */
> > 	__virtio16 flags;
> > 	/* We chain unused descriptors via this, too */
> > 	__virtio16 next;
> > 
> > };
> > 
> > There are 2 ring buffers; the "available" ring buffer is for sending a
> > message guest->host (which will transmit DMA addresses of guest allocated
> > bulk data blocks that are used for data sent to device, and separate
> > guest allocated bulk data blocks that will be used by host side to place
> > its response bulk data), and the "used" ring buffer is for sending
> > host->guest to let guest know about host's response and that it could now
> > safely consume and then deallocate the bulk data blocks subsequently.
> > 
> > ---------- [recap-end] ----------
> > 
> > So the "queue size" actually defines the ringbuffer size. It does not
> > define the maximum amount of descriptors. The "queue size" rather defines
> > how many pending messages can be pushed into either one ringbuffer before
> > the other side would need to wait until the counter side would step up
> > (i.e. ring buffer full).
> > 
> > The maximum amount of descriptors (what VIRTQUEUE_MAX_SIZE actually is)
> > OTOH defines the max. bulk data size that could be transmitted with each
> > virtio round trip message.
> > 
> > And in fact, 9p currently handles the virtio "queue size" as directly
> > associative with its maximum amount of active 9p requests the server could
> > 
> > handle simultaniously:
> >   hw/9pfs/9p.h:#define MAX_REQ         128
> >   hw/9pfs/9p.h:    V9fsPDU pdus[MAX_REQ];
> >   hw/9pfs/virtio-9p-device.c:    v->vq = virtio_add_queue(vdev, MAX_REQ,
> >   
> >                                  handle_9p_output);
> > 
> > So if I would change it like this, just for the purpose to increase the
> > max. virtio transmission size:
> > 
> > --- a/hw/9pfs/virtio-9p-device.c
> > +++ b/hw/9pfs/virtio-9p-device.c
> > @@ -218,7 +218,7 @@ static void virtio_9p_device_realize(DeviceState *dev,
> > Error **errp)> 
> >      v->config_size = sizeof(struct virtio_9p_config) +
> >      strlen(s->fsconf.tag);
> >      virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
> >      
> >                  VIRTQUEUE_MAX_SIZE);
> > 
> > -    v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
> > +    v->vq = virtio_add_queue(vdev, 32*1024, handle_9p_output);
> > 
> >  }
> > 
> > Then it would require additional synchronization code on both ends and
> > therefore unnecessary complexity, because it would now be possible that
> > more requests are pushed into the ringbuffer than server could handle.
> > 
> > There is one potential issue though that probably did justify the "don't
> > exceed the queue size" rule:
> > 
> > ATM the descriptor table is allocated (just in time) as *one* continuous
> > buffer via kmalloc_array():
> > https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c7
> > d33a4/drivers/virtio/virtio_ring.c#L440
> > 
> > So assuming transmission size of 2 * 128 MB that kmalloc_array() call
> > would
> > yield in kmalloc(1M) and the latter might fail if guest had highly
> > fragmented physical memory. For such kind of error case there is
> > currently a fallback path in virtqueue_add_split() that would then use
> > the required amount of pre-allocated descriptors instead:
> > https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c7
> > d33a4/drivers/virtio/virtio_ring.c#L525
> > 
> > That fallback recovery path would no longer be viable if the queue size
> > was
> > exceeded. There would be alternatives though, e.g. by allowing to chain
> > indirect descriptor tables (currently prohibited by the virtio specs).
> 
> Making the maximum number of descriptors independent of the queue size
> requires a change to the VIRTIO spec since the two values are currently
> explicitly tied together by the spec.

Yes, that's what the virtio specs say. But they don't say why, nor did I hear
a reason in this dicussion.

That's why I invested time reviewing current virtio implementation and specs,
as well as actually testing exceeding that limit. And as I outlined in detail
in my previous email, I only found one theoretical issue that could be
addressed though.

> Before doing that, are there benchmark results showing that 1 MB vs 128
> MB produces a performance improvement? I'm asking because if performance
> with 1 MB is good then you can probably do that without having to change
> VIRTIO and also because it's counter-intuitive that 9p needs 128 MB for
> good performance when it's ultimately implemented on top of disk and
> network I/O that have lower size limits.

First some numbers, linear reading a 12 GB file:

msize    average      notes

8 kB     52.0 MB/s    default msize of Linux kernel <v5.15
128 kB   624.8 MB/s   default msize of Linux kernel >=v5.15
512 kB   1961 MB/s    current max. msize with any Linux kernel <=v5.15
1 MB     2551 MB/s    this msize would already violate virtio specs
2 MB     2521 MB/s    this msize would already violate virtio specs
4 MB     2628 MB/s    planned max. msize of my current kernel patches [1]

Note that current 9p Linux client implementation used here, has a bunch of
known code simplifications that cost a lot the more you increase msize, which
also explains the bumb at 1 MB vs 2 MB here. I will address these issues with
my kernel patches soon. Current numbers already suggest though that you will
see growing performance above 4 MB msize as well.

I have not even bothered benchmarking my current, heavily hacked kernel for
the case 4 MB .. 128 MB, because I'm using ridiculous expensive hacks that
copy huge buffers between 9p client level (linear buffers, non-logical address
space) and virtio level (sparse buffers, logical address space for DMA)
several times back and forth.

The point of my current hacks were just to find out whether it was feasible
and sane to exceed current virtio limit, and I think it is.

But again, this is not just about performance. My conclusion as described in
my previous email is that virtio currently squeezes

	"max. simultanious amount of bulk messages"

vs.

	"max. bulk data transmission size per bulk messaage"

into the same configuration parameter, which is IMO inappropriate and hence
splitting them into 2 separate parameters when creating a queue makes sense,
independent of the performance benchmarks.

[1] https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudebyte.com/

Best regards,
Christian Schoenebeck


