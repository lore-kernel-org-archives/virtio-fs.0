DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=/uuTssCrIpb2FxRAXo1XepgllJ62U9XSI0xLSAg/Mvs=;
	b=SyljRAQQkDULjCY5PCG3a/iuY2
	3dZQTImefoWQw90zCP4h67tEOk0+cACnEVo1z+B2MTIybxOe4NF0fkVY2kHtoUu8PZd0u0Tkyrm2h
	8nBrvEJ31j0XQL6hvhydLtteAK4CL/1jVaym3F1n5H7F/i9SA8zVUP8vbmE+jYZkRotG4HNyzHuzt
	CNWEMwiYmCP6bz5fEkXp1ARcJxW1Cff5jJ8RzWTt73vLDQJ+/zkwYerzhp7ImI2GhL8SxzQ4+WniC
	xWZruUWAue2pIuVxA0ZbiJravHCDn2qzk+2grBReiCsn0QMMX7i41qkvuIylqGNagrOn0l9WFWtC9
	xgjGvts3Nou9Iwf3fB2prLcFVfYOJg0Zn14E/SyrNQU/OKw+s0iJiMeMY2gXDimESLdPpKfxF/hl4
	QM21DbLz3rhIGBhI6HmFxd+a5nlpANIQu0hCPn5iZPKRzRHaYecgEMcglK5aOMm06myv0RN4BIQJJ
	9ulGZInHCdmpE2FojoZgb69uKNtPs4pbXNn/hIoZG0SsD8yw/3Cvs5Mc/m/C2ZFgDMJ3JN7T2XpKI
	71ILsQ7ozWWi9DJha6HEVFywakXXsZz7AZLX39nQjIYlyfQs5pvSIKpOTbiQKLio34CGgO9jWe2GN
	B1/3KTZMl9U0FeK0V/E2Dj8iSMwj8YqFBIn9bwK1s=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 06 Oct 2021 14:50:07 +0200
Message-ID: <6923459.JjrQbDWbmU@silver>
In-Reply-To: <YV2DT+EMqDN+gSHf@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<1950551.Wq8TZpmmRU@silver>
	<YV2DT+EMqDN+gSHf@stefanha-x1.localdomain>
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

On Mittwoch, 6. Oktober 2021 13:06:55 CEST Stefan Hajnoczi wrote:
> On Tue, Oct 05, 2021 at 06:32:46PM +0200, Christian Schoenebeck wrote:
> > On Dienstag, 5. Oktober 2021 17:10:40 CEST Stefan Hajnoczi wrote:
> > > On Tue, Oct 05, 2021 at 03:15:26PM +0200, Christian Schoenebeck wrote:
> > > > On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wrote:
> > > > > On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck 
wrote:
> > > > > > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> > > > > > variable per virtio user.
> > > > > 
> > > > > virtio user == virtio device model?
> > > > 
> > > > Yes
> > > > 
> > > > > > Reasons:
> > > > > > 
> > > > > > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
> > > > > > 
> > > > > >     maximum queue size possible. Which is actually the maximum
> > > > > >     queue size allowed by the virtio protocol. The appropriate
> > > > > >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> > > > > >     
> > > > > >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.
> > > > > >     1-cs
> > > > > >     01.h
> > > > > >     tml#x1-240006
> > > > > >     
> > > > > >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
> > > > > >     more or less arbitrary value of 1024 in the past, which
> > > > > >     limits the maximum transfer size with virtio to 4M
> > > > > >     (more precise: 1024 * PAGE_SIZE, with the latter typically
> > > > > >     being 4k).
> > > > > 
> > > > > Being equal to IOV_MAX is a likely reason. Buffers with more iovecs
> > > > > than
> > > > > that cannot be passed to host system calls (sendmsg(2), pwritev(2),
> > > > > etc).
> > > > 
> > > > Yes, that's use case dependent. Hence the solution to opt-in if it is
> > > > desired and feasible.
> > > > 
> > > > > > (2) Additionally the current value of 1024 poses a hidden limit,
> > > > > > 
> > > > > >     invisible to guest, which causes a system hang with the
> > > > > >     following QEMU error if guest tries to exceed it:
> > > > > >     
> > > > > >     virtio: too many write descriptors in indirect table
> > > > > 
> > > > > I don't understand this point. 2.6.5 The Virtqueue Descriptor Table
> > 
> > says:
> > > > >   The number of descriptors in the table is defined by the queue
> > > > >   size
> > > > >   for
> > > > > 
> > > > > this virtqueue: this is the maximum possible descriptor chain
> > > > > length.
> > > > > 
> > > > > and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:
> > > > >   A driver MUST NOT create a descriptor chain longer than the Queue
> > > > >   Size
> > > > >   of
> > > > > 
> > > > > the device.
> > > > > 
> > > > > Do you mean a broken/malicious guest driver that is violating the
> > > > > spec?
> > > > > That's not a hidden limit, it's defined by the spec.
> > > > 
> > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781.html
> > > > https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788.html
> > > > 
> > > > You can already go beyond that queue size at runtime with the
> > > > indirection
> > > > table. The only actual limit is the currently hard coded value of 1k
> > > > pages.
> > > > Hence the suggestion to turn that into a variable.
> > > 
> > > Exceeding Queue Size is a VIRTIO spec violation. Drivers that operate
> > > outsided the spec do so at their own risk. They may not be compatible
> > > with all device implementations.
> > 
> > Yes, I am ware about that. And still, this practice is already done, which
> > apparently is not limited to 9pfs.
> > 
> > > The limit is not hidden, it's Queue Size as defined by the spec :).
> > > 
> > > If you have a driver that is exceeding the limit, then please fix the
> > > driver.
> > 
> > I absolutely understand your position, but I hope you also understand that
> > this violation of the specs is a theoretical issue, it is not a real-life
> > problem right now, and due to lack of man power unfortunately I have to
> > prioritize real-life problems over theoretical ones ATM. Keep in mind that
> > right now I am the only person working on 9pfs actively, I do this
> > voluntarily whenever I find a free time slice, and I am not paid for it
> > either.
> > 
> > I don't see any reasonable way with reasonable effort to do what you are
> > asking for here in 9pfs, and Greg may correct me here if I am saying
> > anything wrong. If you are seeing any specific real-life issue here, then
> > please tell me which one, otherwise I have to postpone that "specs
> > violation" issue.
> > 
> > There is still a long list of real problems that I need to hunt down in
> > 9pfs, afterwards I can continue with theoretical ones if you want, but
> > right now I simply can't, sorry.
> 
> I understand. If you don't have time to fix the Linux virtio-9p driver
> then that's fine.

I will look at this again, but it might be tricky. On doubt I'll postpone it.

> I still wanted us to agree on the spec position because the commit
> description says it's a "hidden limit", which is incorrect. It might
> seem pedantic, but my concern is that misconceptions can spread if we
> let them. That could cause people to write incorrect code later on.
> Please update the commit description either by dropping 2) or by
> replacing it with something else. For example:
> 
>   2) The Linux virtio-9p guest driver does not honor the VIRTIO Queue
>      Size value and can submit descriptor chains that exceed it. That is
>      a spec violation but is accepted by QEMU's device implementation.
> 
>      When the guest creates a descriptor chain larger than 1024 the
>      following QEMU error is printed and the guest hangs:
> 
>      virtio: too many write descriptors in indirect table

I am fine with both, probably preferring the text block above instead of 
silently dropping the reason, just for clarity.

But keep in mind that this might not be limited to virtio-9p as your text 
would suggest, see below.

> > > > > > (3) Unfortunately not all virtio users in QEMU would currently
> > > > > > 
> > > > > >     work correctly with the new value of 32768.
> > > > > > 
> > > > > > So let's turn this hard coded global value into a runtime
> > > > > > variable as a first step in this commit, configurable for each
> > > > > > virtio user by passing a corresponding value with virtio_init()
> > > > > > call.
> > > > > 
> > > > > virtio_add_queue() already has an int queue_size argument, why isn't
> > > > > that enough to deal with the maximum queue size? There's probably a
> > > > > good
> > > > > reason for it, but please include it in the commit description.
> > > > 
> > > > [...]
> > > > 
> > > > > Can you make this value per-vq instead of per-vdev since virtqueues
> > > > > can
> > > > > have different queue sizes?
> > > > > 
> > > > > The same applies to the rest of this patch. Anything using
> > > > > vdev->queue_max_size should probably use vq->vring.num instead.
> > > > 
> > > > I would like to avoid that and keep it per device. The maximum size
> > > > stored
> > > > there is the maximum size supported by virtio user (or vortio device
> > > > model,
> > > > however you want to call it). So that's really a limit per device, not
> > > > per
> > > > queue, as no queue of the device would ever exceed that limit.
> > > > 
> > > > Plus a lot more code would need to be refactored, which I think is
> > > > unnecessary.
> > > 
> > > I'm against a per-device limit because it's a concept that cannot
> > > accurately describe reality. Some devices have multiple classes of
> > 
> > It describes current reality, because VIRTQUEUE_MAX_SIZE obviously is not
> > per queue either ATM, and nobody ever cared.
> > 
> > All this series does, is allowing to override that currently project-wide
> > compile-time constant to a per-driver-model compile-time constant. Which
> > makes sense, because that's what it is: some drivers could cope with any
> > transfer size, and some drivers are constrained to a certain maximum
> > application specific transfer size (e.g. IOV_MAX).
> > 
> > > virtqueues and they are sized differently, so a per-device limit is
> > > insufficient. virtio-net has separate rx_queue_size and tx_queue_size
> > > parameters (plus a control vq hardcoded to 64 descriptors).
> > 
> > I simply find this overkill. This value semantically means "my driver
> > model
> > supports at any time and at any coincidence at the very most x * PAGE_SIZE
> > = max_transfer_size". Do you see any driver that might want a more fine
> > graded control over this?
> 
> One reason why per-vq limits could make sense is that the maximum
> possible number of struct elements is allocated upfront in some code
> paths. Those code paths may need to differentiate between per-vq limits
> for performance or memory utilization reasons. Today some places
> allocate 1024 elements on the stack in some code paths, but maybe that's
> not acceptable when the per-device limit is 32k. This can matter when a
> device has vqs with very different sizes.
> 
[...]
> > ... I leave that up to Michael or whoever might be in charge to decide. I
> > still find this overkill, but I will adapt this to whatever the decision
> > eventually will be in v3.
> > 
> > But then please tell me the precise representation that you find
> > appropriate, i.e. whether you want a new function for that, or rather an
> > additional argument to virtio_add_queue(). Your call.
> 
> virtio_add_queue() already takes an int queue_size argument. I think the
> necessary information is already there.
> 
> This patch just needs to be tweaked to use the virtio_queue_get_num()
> (or a new virtqueue_get_num() API if that's easier because only a
> VirtQueue *vq pointer is available) instead of introducing a new
> per-device limit.

My understanding is that both the original 9p virtio device authors, as well 
as other virtio device authors in QEMU have been and are still using this as a 
default value (i.e. to allocate some upfront, and the rest on demand).

So yes, I know your argument about the specs, but AFAICS if I would just take 
this existing numeric argument for the limit, then it would probably break 
those other QEMU devices as well.

Best regards,
Christian Schoenebeck


