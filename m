DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=hdlGHdLFsTLrEs0ug5auof9JDB8L0ieyKazTitvR/18=;
	b=UcttY6MTtY0GKOlsc8Vp2x6CqL
	a7m4ziC3xA1qOngR8+6oGc0WQ8mMfWxCMecp8FaKvzcXuQHKq7lWoibrfQo6m7l7yLrqLIO+0ZmEm
	3s00MAXGYOLap2vgDNfnhFSjrrdkezgUl1iktvyrwnvXEo5XhjqW0ARJ8DmzsQaTTDaTHY5N0HmHM
	0xwZWf0Y/55cczDfEgKFZgCFZUcqob65nt/9X63HtWdyQd55tl4Wx9s81zivu31THf4E4hZ/ZUxt6
	cdz261zIWjlZx/E4mvlOWW7rUNoz5xePQkVtJ6DisGTSGliW4m24KC6pSap3dmRiyW/3ZxvYyzdJy
	W3THdfWDVIWght/6xwNFxpA5Suh+9W/+5fHePSyzJsv4+moCC7lzDtMCbU6603y16mqXCI1s8xCe9
	QZUSADL0XHLX19ArIsEFNVTGtfqI+qq28BNfwNLjKvWkG20+Cnffii0bC9Q9C4ocyprEvnxFiV08L
	4WbnCgdKBCt66cBtVLjldMWmtGtEPt6DlacYB1AeI3bW+u92XrXsa03IrZ50OlSdKpeYLfNdaOcZ7
	wKwybLo8KyL3QgLNpNUPeo8F2dg7kMyT/vOCepGGr1NRpVyU7h5RFA0ZQJjaZGIpcx8ioZnLcZ8ma
	8ga7EgX0MZS5PQL0X+kJ6Bjn2zK5rFsHjae/p6bck=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 05 Oct 2021 15:15:26 +0200
Message-ID: <14205148.YOBg3JvQBA@silver>
In-Reply-To: <YVxJBKqsytKlos6M@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<c9dea2e27ae19b2b9a51e8f08687067bf3e47bd5.1633376313.git.qemu_oss@crudebyte.com>
	<YVxJBKqsytKlos6M@stefanha-x1.localdomain>
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

On Dienstag, 5. Oktober 2021 14:45:56 CEST Stefan Hajnoczi wrote:
> On Mon, Oct 04, 2021 at 09:38:04PM +0200, Christian Schoenebeck wrote:
> > Refactor VIRTQUEUE_MAX_SIZE to effectively become a runtime
> > variable per virtio user.
> 
> virtio user == virtio device model?

Yes

> > Reasons:
> > 
> > (1) VIRTQUEUE_MAX_SIZE should reflect the absolute theoretical
> > 
> >     maximum queue size possible. Which is actually the maximum
> >     queue size allowed by the virtio protocol. The appropriate
> >     value for VIRTQUEUE_MAX_SIZE would therefore be 32768:
> >     
> >     https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.h
> >     tml#x1-240006
> >     
> >     Apparently VIRTQUEUE_MAX_SIZE was instead defined with a
> >     more or less arbitrary value of 1024 in the past, which
> >     limits the maximum transfer size with virtio to 4M
> >     (more precise: 1024 * PAGE_SIZE, with the latter typically
> >     being 4k).
> 
> Being equal to IOV_MAX is a likely reason. Buffers with more iovecs than
> that cannot be passed to host system calls (sendmsg(2), pwritev(2),
> etc).

Yes, that's use case dependent. Hence the solution to opt-in if it is desired 
and feasible.

> > (2) Additionally the current value of 1024 poses a hidden limit,
> > 
> >     invisible to guest, which causes a system hang with the
> >     following QEMU error if guest tries to exceed it:
> >     
> >     virtio: too many write descriptors in indirect table
> 
> I don't understand this point. 2.6.5 The Virtqueue Descriptor Table says:
> 
>   The number of descriptors in the table is defined by the queue size for
> this virtqueue: this is the maximum possible descriptor chain length.
> 
> and 2.6.5.3.1 Driver Requirements: Indirect Descriptors says:
> 
>   A driver MUST NOT create a descriptor chain longer than the Queue Size of
> the device.
> 
> Do you mean a broken/malicious guest driver that is violating the spec?
> That's not a hidden limit, it's defined by the spec.

https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00781.html
https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg00788.html

You can already go beyond that queue size at runtime with the indirection 
table. The only actual limit is the currently hard coded value of 1k pages. 
Hence the suggestion to turn that into a variable.

> > (3) Unfortunately not all virtio users in QEMU would currently
> > 
> >     work correctly with the new value of 32768.
> > 
> > So let's turn this hard coded global value into a runtime
> > variable as a first step in this commit, configurable for each
> > virtio user by passing a corresponding value with virtio_init()
> > call.
> 
> virtio_add_queue() already has an int queue_size argument, why isn't
> that enough to deal with the maximum queue size? There's probably a good
> reason for it, but please include it in the commit description.
[...]
> Can you make this value per-vq instead of per-vdev since virtqueues can
> have different queue sizes?
> 
> The same applies to the rest of this patch. Anything using
> vdev->queue_max_size should probably use vq->vring.num instead.

I would like to avoid that and keep it per device. The maximum size stored 
there is the maximum size supported by virtio user (or vortio device model, 
however you want to call it). So that's really a limit per device, not per 
queue, as no queue of the device would ever exceed that limit.

Plus a lot more code would need to be refactored, which I think is 
unnecessary.

Best regards,
Christian Schoenebeck


