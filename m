DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=CxQ442I4VUiYwoh8W91ZacufD1Fdb/a06fawcfhKy7o=;
	b=RsWNra3v3RXGyJ7sD4Qnok28fl
	HAWjoKrVSlpHOQw/cbPysNAC5UnJ63/njGq5uKHVBHy2AE7+DVxNPboTvM4UfeCh7fgkrWCZUNck/
	vtHK4jZQzzORHuZwTldFP5EMWvadkmpT1a9whrwVEavJC/37h7w//e0KQoyan2gd/AQizKqKNNTK1
	2hNrFUVOGJ6CXJnsa98oIrI9tTquQl8ybaJx4os/qC+apMNqx7VEn1wHUL5KO4qnTF5AM3ypXNq+w
	xX09XEG+kNP3BU72GuyfXEmBgrbdhoqOgVtyT4Se9/0YpXW3djoZjhnzdBnfwj34c7uoMKlFjfqhb
	+RSXggecG7l2glzDmzFNIN8Nd8sZnL1mTnZQlPoE4aq402nm+uWVRNKl6J0uHVak5z59IhP9qLEfp
	vWdb94JUpgPHRy+Z35rIlFMis9t+/pbY2Id6CMBP+7rzibOf3wqEjRK58X4vxBcpA52BAZ36Avrzl
	jFIFA82L8BBIYgBYCCAMYRIQ71oRYMFBODWYuhT27ev2Fr1zUeLX+ImJ/SXk7KRMeDnnHY2PiQAfU
	6inHh5X6mbIYkNRRhzWSS/v5SO+Jgo9qC76zWiKpO5NoH+ZeUxuI0rOYuWILPaB4wFg3rZT5EaZJZ
	p/ErZ4XjD2qd59/eUBJ0jFje1l9oEL02t02wSlcrs=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Thu, 21 Oct 2021 17:39:28 +0200
Message-ID: <4038040.djDU9dF7GM@silver>
In-Reply-To: <2657765.azTuxnmmC0@silver>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<1853723.Wj769PA2Ue@silver> <2657765.azTuxnmmC0@silver>
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>

On Freitag, 8. Oktober 2021 18:08:48 CEST Christian Schoenebeck wrote:
> On Freitag, 8. Oktober 2021 16:24:42 CEST Christian Schoenebeck wrote:
> > On Freitag, 8. Oktober 2021 09:25:33 CEST Greg Kurz wrote:
> > > On Thu, 7 Oct 2021 16:42:49 +0100
> > > 
> > > Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > On Thu, Oct 07, 2021 at 02:51:55PM +0200, Christian Schoenebeck wrote:
> > > > > On Donnerstag, 7. Oktober 2021 07:23:59 CEST Stefan Hajnoczi wrote:
> > > > > > On Mon, Oct 04, 2021 at 09:38:00PM +0200, Christian Schoenebeck
> 
> wrote:
> > > > > > > At the moment the maximum transfer size with virtio is limited
> > > > > > > to
> > > > > > > 4M
> > > > > > > (1024 * PAGE_SIZE). This series raises this limit to its maximum
> > > > > > > theoretical possible transfer size of 128M (32k pages) according
> > > > > > > to
> > > > > > > the
> > > > > > > virtio specs:
> > > > > > > 
> > > > > > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-
> > > > > > > cs
> > > > > > > 01
> > > > > > > .html#
> > > > > > > x1-240006
> > > > > > 
> > > > > > Hi Christian,
> > > 
> > > > > > I took a quick look at the code:
> > > Hi,
> > > 
> > > Thanks Stefan for sharing virtio expertise and helping Christian !
> > > 
> > > > > > - The Linux 9p driver restricts descriptor chains to 128 elements
> > > > > > 
> > > > > >   (net/9p/trans_virtio.c:VIRTQUEUE_NUM)
> > > > > 
> > > > > Yes, that's the limitation that I am about to remove (WIP); current
> > > > > kernel
> > > > > patches:
> > > > > https://lore.kernel.org/netdev/cover.1632327421.git.linux_oss@crudeb
> > > > > yt
> > > > > e.
> > > > > com/>
> > > > 
> > > > I haven't read the patches yet but I'm concerned that today the driver
> > > > is pretty well-behaved and this new patch series introduces a spec
> > > > violation. Not fixing existing spec violations is okay, but adding new
> > > > ones is a red flag. I think we need to figure out a clean solution.
> > 
> > Nobody has reviewed the kernel patches yet. My main concern therefore
> > actually is that the kernel patches are already too complex, because the
> > current situation is that only Dominique is handling 9p patches on kernel
> > side, and he barely has time for 9p anymore.
> > 
> > Another reason for me to catch up on reading current kernel code and
> > stepping in as reviewer of 9p on kernel side ASAP, independent of this
> > issue.
> > 
> > As for current kernel patches' complexity: I can certainly drop patch 7
> > entirely as it is probably just overkill. Patch 4 is then the biggest
> > chunk, I have to see if I can simplify it, and whether it would make
> > sense to squash with patch 3.
> > 
> > > > > > - The QEMU 9pfs code passes iovecs directly to preadv(2) and will
> > > > > > fail
> > > > > > 
> > > > > >   with EINVAL when called with more than IOV_MAX iovecs
> > > > > >   (hw/9pfs/9p.c:v9fs_read())
> > > > > 
> > > > > Hmm, which makes me wonder why I never encountered this error during
> > > > > testing.
> > > > > 
> > > > > Most people will use the 9p qemu 'local' fs driver backend in
> > > > > practice,
> > > > > so
> > > > > that v9fs_read() call would translate for most people to this
> > > > > implementation on QEMU side (hw/9p/9p-local.c):
> > > > > 
> > > > > static ssize_t local_preadv(FsContext *ctx, V9fsFidOpenState *fs,
> > > > > 
> > > > >                             const struct iovec *iov,
> > > > >                             int iovcnt, off_t offset)
> > > > > 
> > > > > {
> > > > > #ifdef CONFIG_PREADV
> > > > > 
> > > > >     return preadv(fs->fd, iov, iovcnt, offset);
> > > > > 
> > > > > #else
> > > > > 
> > > > >     int err = lseek(fs->fd, offset, SEEK_SET);
> > > > >     if (err == -1) {
> > > > >     
> > > > >         return err;
> > > > >     
> > > > >     } else {
> > > > >     
> > > > >         return readv(fs->fd, iov, iovcnt);
> > > > >     
> > > > >     }
> > > > > 
> > > > > #endif
> > > > > }
> > > > > 
> > > > > > Unless I misunderstood the code, neither side can take advantage
> > > > > > of
> > > > > > the
> > > > > > new 32k descriptor chain limit?
> > > > > > 
> > > > > > Thanks,
> > > > > > Stefan
> > > > > 
> > > > > I need to check that when I have some more time. One possible
> > > > > explanation
> > > > > might be that preadv() already has this wrapped into a loop in its
> > > > > implementation to circumvent a limit like IOV_MAX. It might be
> > > > > another
> > > > > "it
> > > > > works, but not portable" issue, but not sure.
> > > > > 
> > > > > There are still a bunch of other issues I have to resolve. If you
> > > > > look
> > > > > at
> > > > > net/9p/client.c on kernel side, you'll notice that it basically does
> > > > > this ATM> >
> > > > > 
> > > > >     kmalloc(msize);
> > > 
> > > Note that this is done twice : once for the T message (client request)
> > > and
> > > once for the R message (server answer). The 9p driver could adjust the
> > > size
> > > of the T message to what's really needed instead of allocating the full
> > > msize. R message size is not known though.
> > 
> > Would it make sense adding a second virtio ring, dedicated to server
> > responses to solve this? IIRC 9p server already calculates appropriate
> > exact sizes for each response type. So server could just push space that's
> > really needed for its responses.
> > 
> > > > > for every 9p request. So not only does it allocate much more memory
> > > > > for
> > > > > every request than actually required (i.e. say 9pfs was mounted with
> > > > > msize=8M, then a 9p request that actually would just need 1k would
> > > > > nevertheless allocate 8M), but also it allocates > PAGE_SIZE, which
> > > > > obviously may fail at any time.>
> > > > 
> > > > The PAGE_SIZE limitation sounds like a kmalloc() vs vmalloc()
> > > > situation.
> > 
> > Hu, I didn't even consider vmalloc(). I just tried the kvmalloc() wrapper
> > as a quick & dirty test, but it crashed in the same way as kmalloc() with
> > large msize values immediately on mounting:
> > 
> > diff --git a/net/9p/client.c b/net/9p/client.c
> > index a75034fa249b..cfe300a4b6ca 100644
> > --- a/net/9p/client.c
> > +++ b/net/9p/client.c
> > @@ -227,15 +227,18 @@ static int parse_opts(char *opts, struct p9_client
> > *clnt)
> > 
> >  static int p9_fcall_init(struct p9_client *c, struct p9_fcall *fc,
> >  
> >                          int alloc_msize)
> >  
> >  {
> > 
> > -       if (likely(c->fcall_cache) && alloc_msize == c->msize) {
> > +       //if (likely(c->fcall_cache) && alloc_msize == c->msize) {
> > +       if (false) {
> > 
> >                 fc->sdata = kmem_cache_alloc(c->fcall_cache, GFP_NOFS);
> >                 fc->cache = c->fcall_cache;
> >         
> >         } else {
> > 
> > -               fc->sdata = kmalloc(alloc_msize, GFP_NOFS);
> > +               fc->sdata = kvmalloc(alloc_msize, GFP_NOFS);
> 
> Ok, GFP_NOFS -> GFP_KERNEL did the trick.
> 
> Now I get:
> 
>    virtio: bogus descriptor or out of resources
> 
> So, still some work ahead on both ends.

Few hacks later (only changes on 9p client side) I got this running stable
now. The reason for the virtio error above was that kvmalloc() returns a
non-logical kernel address for any kvmalloc(>4M), i.e. an address that is
inaccessible from host side, hence that "bogus descriptor" message by QEMU.
So I had to split those linear 9p client buffers into sparse ones (set of
individual pages).

I tested this for some days with various virtio transmission sizes and it
works as expected up to 128 MB (more precisely: 128 MB read space + 128 MB
write space per virtio round trip message).

I did not encounter a show stopper for large virtio transmission sizes
(4 MB ... 128 MB) on virtio level, neither as a result of testing, nor after
reviewing the existing code.

About IOV_MAX: that's apparently not an issue on virtio level. Most of the
iovec code, both on Linux kernel side and on QEMU side do not have this
limitation. It is apparently however indeed a limitation for userland apps
calling the Linux kernel's syscalls yet.

Stefan, as it stands now, I am even more convinced that the upper virtio
transmission size limit should not be squeezed into the queue size argument of
virtio_add_queue(). Not because of the previous argument that it would waste
space (~1MB), but rather because they are two different things. To outline
this, just a quick recap of what happens exactly when a bulk message is pushed
over the virtio wire (assuming virtio "split" layout here):

---------- [recap-start] ----------

For each bulk message sent guest <-> host, exactly *one* of the pre-allocated
descriptors is taken and placed (subsequently) into exactly *one* position of
the two available/used ring buffers. The actual descriptor table though,
containing all the DMA addresses of the message bulk data, is allocated just
in time for each round trip message. Say, it is the first message sent, it
yields in the following structure:

Ring Buffer   Descriptor Table      Bulk Data Pages

   +-+              +-+           +-----------------+
   |D|------------->|d|---------->| Bulk data block |
   +-+              |d|--------+  +-----------------+
   | |              |d|------+ |
   +-+               .       | |  +-----------------+
   | |               .       | +->| Bulk data block |
    .                .       |    +-----------------+
    .               |d|-+    |
    .               +-+ |    |    +-----------------+
   | |                  |    +--->| Bulk data block |
   +-+                  |         +-----------------+
   | |                  |                 .
   +-+                  |                 .
                        |                 .
                        |         +-----------------+
                        +-------->| Bulk data block |
                                  +-----------------+
Legend:
D: pre-allocated descriptor
d: just in time allocated descriptor
-->: memory pointer (DMA)

The bulk data blocks are allocated by the respective device driver above
virtio subsystem level (guest side).

There are exactly as many descriptors pre-allocated (D) as the size of a ring
buffer.

A "descriptor" is more or less just a chainable DMA memory pointer; defined
as:

/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
struct vring_desc {
	/* Address (guest-physical). */
	__virtio64 addr;
	/* Length. */
	__virtio32 len;
	/* The flags as indicated above. */
	__virtio16 flags;
	/* We chain unused descriptors via this, too */
	__virtio16 next;
};

There are 2 ring buffers; the "available" ring buffer is for sending a message
guest->host (which will transmit DMA addresses of guest allocated bulk data
blocks that are used for data sent to device, and separate guest allocated
bulk data blocks that will be used by host side to place its response bulk
data), and the "used" ring buffer is for sending host->guest to let guest know
about host's response and that it could now safely consume and then deallocate
the bulk data blocks subsequently.

---------- [recap-end] ----------

So the "queue size" actually defines the ringbuffer size. It does not define
the maximum amount of descriptors. The "queue size" rather defines how many
pending messages can be pushed into either one ringbuffer before the other
side would need to wait until the counter side would step up (i.e. ring buffer
full).

The maximum amount of descriptors (what VIRTQUEUE_MAX_SIZE actually is) OTOH
defines the max. bulk data size that could be transmitted with each virtio
round trip message.

And in fact, 9p currently handles the virtio "queue size" as directly
associative with its maximum amount of active 9p requests the server could
handle simultaniously:

  hw/9pfs/9p.h:#define MAX_REQ         128
  hw/9pfs/9p.h:    V9fsPDU pdus[MAX_REQ];
  hw/9pfs/virtio-9p-device.c:    v->vq = virtio_add_queue(vdev, MAX_REQ,
                                 handle_9p_output);

So if I would change it like this, just for the purpose to increase the max.
virtio transmission size:

--- a/hw/9pfs/virtio-9p-device.c
+++ b/hw/9pfs/virtio-9p-device.c
@@ -218,7 +218,7 @@ static void virtio_9p_device_realize(DeviceState *dev, Error **errp)
     v->config_size = sizeof(struct virtio_9p_config) + strlen(s->fsconf.tag);
     virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
                 VIRTQUEUE_MAX_SIZE);
-    v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
+    v->vq = virtio_add_queue(vdev, 32*1024, handle_9p_output);
 }
 
Then it would require additional synchronization code on both ends and
therefore unnecessary complexity, because it would now be possible that more
requests are pushed into the ringbuffer than server could handle.

There is one potential issue though that probably did justify the "don't
exceed the queue size" rule:

ATM the descriptor table is allocated (just in time) as *one* continuous
buffer via kmalloc_array():
https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c7d33a4/drivers/virtio/virtio_ring.c#L440

So assuming transmission size of 2 * 128 MB that kmalloc_array() call would
yield in kmalloc(1M) and the latter might fail if guest had highly fragmented
physical memory. For such kind of error case there is currently a fallback
path in virtqueue_add_split() that would then use the required amount of
pre-allocated descriptors instead:
https://github.com/torvalds/linux/blob/2f111a6fd5b5297b4e92f53798ca086f7c7d33a4/drivers/virtio/virtio_ring.c#L525

That fallback recovery path would no longer be viable if the queue size was
exceeded. There would be alternatives though, e.g. by allowing to chain
indirect descriptor tables (currently prohibited by the virtio specs).

Best regards,
Christian Schoenebeck

> 
> >                 fc->cache = NULL;
> >         
> >         }
> > 
> > -       if (!fc->sdata)
> > +       if (!fc->sdata) {
> > +               pr_info("%s !fc->sdata", __func__);
> > 
> >                 return -ENOMEM;
> > 
> > +       }
> > 
> >         fc->capacity = alloc_msize;
> >         return 0;
> >  
> >  }
> > 
> > I try to look at this at the weekend, I would have expected this hack to
> > bypass this issue.
> > 
> > > > I saw zerocopy code in the 9p guest driver but didn't investigate when
> > > > it's used. Maybe that should be used for large requests (file
> > > > reads/writes)?
> > > 
> > > This is the case already : zero-copy is only used for
> > > reads/writes/readdir
> > > if the requested size is 1k or more.
> > > 
> > > Also you'll note that in this case, the 9p driver doesn't allocate msize
> > > for the T/R messages but only 4k, which is largely enough to hold the
> > > header.
> > > 
> > > 	/*
> > > 	
> > > 	 * We allocate a inline protocol data of only 4k bytes.
> > > 	 * The actual content is passed in zero-copy fashion.
> > > 	 */
> > > 	
> > > 	req = p9_client_prepare_req(c, type, P9_ZC_HDR_SZ, fmt, ap);
> > > 
> > > and
> > > 
> > > /* size of header for zero copy read/write */
> > > #define P9_ZC_HDR_SZ 4096
> > > 
> > > A huge msize only makes sense for Twrite, Rread and Rreaddir because
> > > of the amount of data they convey. All other messages certainly fit
> > > in a couple of kilobytes only (sorry, don't remember the numbers).
> > > 
> > > A first change should be to allocate MIN(XXX, msize) for the
> > > regular non-zc case, where XXX could be a reasonable fixed
> > > value (8k?). In the case of T messages, it is even possible
> > > to adjust the size to what's exactly needed, ala snprintf(NULL).
> > 
> > Good idea actually! That would limit this problem to reviewing the 9p
> > specs
> > and picking one reasonable max value. Because you are right, those message
> > types are tiny. Probably not worth to pile up new code to calculate exact
> > message sizes for each one of them.
> > 
> > Adding some safety net would make sense though, to force e.g. if a new
> > message type is added in future, that this value would be reviewed as
> > well,
> > something like:
> > 
> > static int max_msg_size(int msg_type) {
> > 
> >     switch (msg_type) {
> >     
> >         /* large zero copy messages */
> >         case Twrite:
> >         case Tread:
> >         
> >         case Treaddir:
> >             BUG_ON(true);
> >         
> >         /* small messages */
> >         case Tversion:
> >         ....
> >         
> >             return 8k; /* to be replaced with appropriate max value */
> >     
> >     }
> > 
> > }
> > 
> > That way the compiler would bark on future additions. But on doubt, a
> > simple comment on msg type enum might do as well though.
> > 
> > > > virtio-blk/scsi don't memcpy data into a new buffer, they
> > > > directly access page cache or O_DIRECT pinned pages.
> > > > 
> > > > Stefan
> > > 
> > > Cheers,
> > > 
> > > --
> > > Greg


