DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=xEbAHzBZGManaZn7xLbPWUqVC2J5Xz3w2kxcX8Y/eSA=;
	b=pvH94jE/7YJeV/ifdbFPGD+iQr
	8R3OyTWRzJZKzt0IuItK2VorxNh0k08VkYRbx2Jw8D3BBbmsNqq/zJlabOekd9DPAHJlp3BaSiPbv
	jqF4m9kBj07pTaH7hgzrzTg5AbYhSNh6m8Ekq+YGIMKcx2j7FpzSAN+rC5P2onZaiK6Sfvf/aTEnZ
	BDeyovIkJFDoL5oIlGYAuct7O+BlxLchCd3PO4fQSZDuBkls9b2fCSX4HcYbYCMnJXsZ+oRuU0ozN
	8YyCh2t0IFETd9FH3iGc/WwCgHoW5HmNHm1NCBGCtNo0IFYa1XVR3UNybCxwONBUscebF0OFfkpSH
	y9gMxvACkrVUDiUduMGvXWEPDb0TG//SVMI40iGvylYubkkj4DDIIaumlT2j4Rq8pvryeMLYhrm73
	eWNMksQIQqBtwFEKuI42za0Zf54GkiZIps6rhUkBIVmBvLi5MIFBhJocuI2Zz9qG8k4iRxymTnMHx
	vhmMC2e7MeP4HvSmiL6U38e8P+Q/2nnP3wcCgRNPcO8gucyeMlO7ULBgRXHWYAbiZcTSv2chkjPBD
	S3O0CiTuuwKENZQ5v5HOSMGpXaAlME0q6m7URjp1tHwTyoFFDO0qCCp62H8yVN1DE1XffR8JPYExR
	1RrcNWhmx6ychb701dO+wLbMGGFDf4z0GBCCt+FDA=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 10 Nov 2021 14:14:43 +0100
Message-ID: <2300275.fgjvgC56zr@silver>
In-Reply-To: <YYuZfkfbxcX0JDRN@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<25571471.tMsSMU6axZ@silver>
	<YYuZfkfbxcX0JDRN@stefanha-x1.localdomain>
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

On Mittwoch, 10. November 2021 11:05:50 CET Stefan Hajnoczi wrote:
> > > > So looks like it was probably still easier and realistic to just add
> > > > virtio
> > > > capabilities for now for allowing to exceed current descriptor limit.
> > > 
> > > I'm still not sure why virtio-net, virtio-blk, virtio-fs, etc perform
> > > fine under today's limits while virtio-9p needs a much higher limit to
> > > achieve good performance. Maybe there is an issue in a layer above the
> > > vring that's causing the virtio-9p performance you've observed?
> > 
> > Are you referring to (somewhat) recent benchmarks when saying those would
> > all still perform fine today?
> 
> I'm not referring to specific benchmark results. Just that none of those
> devices needed to raise the descriptor chain length, so I'm surprised
> that virtio-9p needs it because it's conceptually similar to these
> devices.

I would not say virtio-net and virtio-blk were comparable with virtio-9p and 
virtio-fs. virtio-9p and virtio-fs are fully fledged file servers which must 
perform various controller tasks before handling the actually requested I/O 
task, which inevitably adds latency to each request, whereas virtio-net and 
virtio-blk are just very thin layers that do not have that controller task 
overhead per request. And a network device only needs to handle very small 
messages in the first place.

> > Vivek was running detailed benchmarks for virtiofs vs. 9p:
> > https://lists.gnu.org/archive/html/qemu-devel/2020-12/msg02704.html
> > 
> > For the virtio aspect discussed here, only the benchmark configurations
> > without cache are relevant (9p-none, vtfs-none) and under this aspect the
> > situation seems to be quite similar between 9p and virtio-fs. You'll also
> > note once DAX is enabled (vtfs-none-dax) that apparently boosts virtio-fs
> > performance significantly, which however seems to corelate to numbers
> > when I am running 9p with msize > 300k. Note: Vivek was presumably
> > running 9p effecively with msize=300k, as this was the kernel limitation
> > at that time.
> Agreed, virtio-9p and virtiofs are similar without caching.
> 
> I think we shouldn't consider DAX here since it bypasses the virtqueue.

DAX bypasses virtio, sure, but the performance boost you get with DAX actually 
shows the limiting factor with virtio pretty well.

> > To bring things into relation: there are known performance aspects in 9p
> > that can be improved, yes, both on Linux kernel side and on 9p server
> > side in QEMU. For instance 9p server uses coroutines [1] and currently
> > dispatches between worker thread(s) and main thread too often per request
> > (partly addressed already [2], but still WIP), which accumulates to
> > overall latency. But Vivek was actually using a 9p patch here which
> > disabled coroutines entirely, which suggests that the virtio transmission
> > size limit still represents a bottleneck.
> 
> These results were collected with 4k block size. Neither msize nor the
> descriptor chain length limits will be stressed, so I don't think these
> results are relevant here.
> 
> Maybe a more relevant comparison would be virtio-9p, virtiofs, and
> virtio-blk when block size is large (e.g. 1M). The Linux block layer in
> the guest will split virtio-blk requests when they exceed the block
> queue limits.

I am sorry, I cannot spend time for more benchmarks like that. For really 
making fair comparisons I would need to review all their code on both ends, 
adjust configuration/sources, etc.

I do think that I performed enough benchmarks and tests to show that 
increasing the transmission size can significantly improve performance with 
9p, and that allowing to exceed the queue size does make sense even for small 
transmission sizes (e.g. max. active requests on 9p server side vs. max. 
transmission size per request).

The reason for the performance gain is the minimum latency involved per 
request, and like I said, that can be improved to a certain extent with 9p, 
but that will take a long time and it could not be eliminated entirely.

As you are apparently reluctant for changing the virtio specs, what about 
introducing those discussed virtio capabalities either as experimental ones 
without specs changes, or even just as 9p specific device capabilities for 
now. I mean those could be revoked on both sides at any time anyway.

Best regards,
Christian Schoenebeck


