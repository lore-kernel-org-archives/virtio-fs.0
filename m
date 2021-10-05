DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=raFlPqOXr5gfQYPl4l0uonFA7Ywzt3rKj6cQmkfyCPw=;
	b=C6vOI2e9AOmtRvBfdiXKhKevgG
	urC1mBIvP2ydKKQjySWrE2n+usxXILQv/PHe9XvhAYUVV7B9fATRZ0Rl8RLVs3PZAya89zRZOvwUA
	L7XdCOWWolKPS3xrgJcSy1HPi5wY8CgMxUh7lq0moMQq0AnpMxbd/GFBT5hE8Frs21g2hd3TnSgCE
	VJ6ins0RiBZNzTkfUVxM1DPq7YD6v21q417A/lwwl5g0EVLjL7A31driKMRnvxDXv1SeCaLtBTHxF
	ixrt2cFMsmDARBEbFIEL8UUHXnLdxO/Eedrmn7fpgz0yvZYQmsQCPlVXui4VA3qh02osPirWqTXZC
	AVewYvn/SKuftbaVrJwRUsUfXLjJuMDbDf+8j609fvb0xZIBXEUGdBXqleoGyqGTlopAAoX58Y/Kr
	tXcR1ObcHoPwGuLau9TjwHQ2ZK9B0Xc3BX59/5R5H2k8Uy/j7sty2kQqq9+SYLPwRAGFcZTLpaBm4
	NSi/i1pFjynrjUJOk+7A6Lnk7uh2Dr3FILSq2y5C9vBPQYxb7EyAxGjtI5tL1NDTc6lErHfNX/nRb
	0GDIQacEEwdmjMFHU1nbrkx1iDNOX+9y5I1oRzSzsQPiJ1SEGYFN7Xxv/PIXNb2l9YiILn+ixBSPk
	HQn3SvBT3eAf9vwllyflO5DSWzAR26TuDY84n3LHM=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Tue, 05 Oct 2021 13:43:14 +0200
Message-ID: <1754360.17xrOKl2ua@silver>
In-Reply-To: <20211005071300-mutt-send-email-mst@kernel.org>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<3198289.vhBqKWSW6W@silver>
	<20211005071300-mutt-send-email-mst@kernel.org>
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
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, David Hildenbrand <david@redhat.com>, Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Amit Shah <amit@kernel.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?ISO-8859-1?Q?Marc=2DAndr=E9?= Lureau <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

On Dienstag, 5. Oktober 2021 13:19:43 CEST Michael S. Tsirkin wrote:
> On Tue, Oct 05, 2021 at 01:10:56PM +0200, Christian Schoenebeck wrote:
> > On Dienstag, 5. Oktober 2021 09:38:53 CEST David Hildenbrand wrote:
> > > On 04.10.21 21:38, Christian Schoenebeck wrote:
> > > > At the moment the maximum transfer size with virtio is limited to 4M
> > > > (1024 * PAGE_SIZE). This series raises this limit to its maximum
> > > > theoretical possible transfer size of 128M (32k pages) according to
> > > > the
> > > > virtio specs:
> > > > 
> > > > https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.h
> > > > tml#
> > > > x1-240006
> > > 
> > > I'm missing the "why do we care". Can you comment on that?
> > 
> > Primary motivation is the possibility of improved performance, e.g. in
> > case of 9pfs, people can raise the maximum transfer size with the Linux
> > 9p client's 'msize' option on guest side (and only on guest side
> > actually). If guest performs large chunk I/O, e.g. consider something
> > "useful" like this one on> 
> > guest side:
> >   time cat large_file_on_9pfs.dat > /dev/null
> > 
> > Then there is a noticable performance increase with higher transfer size
> > values. That performance gain is continuous with rising transfer size
> > values, but the performance increase obviously shrinks with rising
> > transfer sizes as well, as with similar concepts in general like cache
> > sizes, etc.
> > 
> > Then a secondary motivation is described in reason (2) of patch 2: if the
> > transfer size is configurable on guest side (like it is the case with the
> > 9pfs 'msize' option), then there is the unpleasant side effect that the
> > current virtio limit of 4M is invisible to guest; as this value of 4M is
> > simply an arbitrarily limit set on QEMU side in the past (probably just
> > implementation motivated on QEMU side at that point), i.e. it is not a
> > limit specified by the virtio protocol,
> 
> According to the spec it's specified, sure enough: vq size limits the
> size of indirect descriptors too.

In the virtio specs the only hard limit that I see is the aforementioned 32k:

"Queue Size corresponds to the maximum number of buffers in the virtqueue. 
Queue Size value is always a power of 2. The maximum Queue Size value is 
32768. This value is specified in a bus-specific way."

> However, ever since commit 44ed8089e991a60d614abe0ee4b9057a28b364e4 we
> do not enforce it in the driver ...

Then there is the current queue size (that you probably mean) which is 
transmitted to guest with whatever virtio was initialized with.

In case of 9p client however the virtio queue size is first initialized with 
some initial hard coded value when the 9p driver is loaded on Linux kernel 
guest side, then when some 9pfs is mounted later on by guest, it may include 
the 'msize' mount option to raise the transfer size, and that's the problem. I 
don't see any way for guest to see that it cannot go above that 4M transfer 
size now.

> > nor is this limit be made aware to guest via virtio protocol
> > at all. The consequence with 9pfs would be if user tries to go higher than
> > 4M,> 
> > then the system would simply hang with this QEMU error:
> >   virtio: too many write descriptors in indirect table
> > 
> > Now whether this is an issue or not for individual virtio users, depends
> > on
> > whether the individual virtio user already had its own limitation <= 4M
> > enforced on its side.
> > 
> > Best regards,
> > Christian Schoenebeck


