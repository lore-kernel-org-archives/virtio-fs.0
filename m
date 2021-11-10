DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=gqemoYYsYaGJaWk/bHWQLjNvPrfpS3sKuboPpwMs6uw=;
	b=stTCt0uDVxem5zzOi5fnUr539Z
	uAfgCLm54OMDXx/i6OByqyKT6KWN/q4mh9tl2GR64YTX2nvIR1oq8VICgUAp5xw76ZRdG+M/o9gDG
	wi9Q4Kfu1ETycYoQl8uYlw9Vqj1B81VGFdJce59rryOhk3Z5C8yxlk/FEK/yUUAAXf1P4E4W4+FTG
	DbXmQJllMefsOfJWzLnezcOExjcJeNBVadAD1r+9xWFYpzVu4VFV2CSZweHueC7GHfgJmA1TrV/Sm
	zL4zohI+UThY15hGA23GBTpRtVsYcjVPQ0rm/+yDpLSs37k2YnyYaEuiZfQQdc3O/7YC1UPJajku6
	IdMwERRGPBEBwqy1TzLdIB4411PcWeE3SUa3TFdDOVDHZIQGm5jlBMwg2Mz/zxM9uS9bSx0NAVydr
	Ee0T4DNa1EhAoVnlrOPLiWso/V5VEhJ4hMyXgaRsmNlpFqvOeQ5zJ+P/rkYXc1kHe/ZMoLT5sSPYt
	6184bWyQL5gGVILkjI6MT/AEAh90KywVhxZPswehO7D8CAWkbiYwy0koS3v3kYncSAUx3hA6TOMA2
	rFlhOVsiD4rIUG+kC0GdQ2I1uRAju1CmMDdR9LTtULMA+9NLVO9QLozUn/NmfloSdtssTpy2H1iQh
	07zTBDt/aPBd4bknelPxoewAXDOzTRIQOzfd6JfXU=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Wed, 10 Nov 2021 16:53:33 +0100
Message-ID: <1965987.S3ubrJPkfX@silver>
In-Reply-To: <YYvhy5Lm7YaqCWix@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<2300275.fgjvgC56zr@silver>
	<YYvhy5Lm7YaqCWix@stefanha-x1.localdomain>
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

On Mittwoch, 10. November 2021 16:14:19 CET Stefan Hajnoczi wrote:
> On Wed, Nov 10, 2021 at 02:14:43PM +0100, Christian Schoenebeck wrote:
> > On Mittwoch, 10. November 2021 11:05:50 CET Stefan Hajnoczi wrote:
> > As you are apparently reluctant for changing the virtio specs, what about
> > introducing those discussed virtio capabalities either as experimental
> > ones
> > without specs changes, or even just as 9p specific device capabilities for
> > now. I mean those could be revoked on both sides at any time anyway.
> 
> I would like to understand the root cause before making changes.
> 
> "It's faster when I do X" is useful information but it doesn't
> necessarily mean doing X is the solution. The "it's faster when I do X
> because Y" part is missing in my mind. Once there is evidence that shows
> Y then it will be clearer if X is a good solution, if there's a more
> general solution, or if it was just a side-effect.

I think I made it clear that the root cause of the observed performance gain 
with rising transmission size is latency (and also that performance is not the 
only reason for addressing this queue size issue).

Each request roundtrip has a certain minimum latency, the virtio ring alone 
has its latency, plus latency of the controller portion of the file server 
(e.g. permissions, sandbox checks, file IDs) that is executed with *every* 
request, plus latency of dispatching the request handling between threads 
several times back and forth (also for each request).

Therefore when you split large payloads (e.g. reading a large file) into 
smaller n amount of chunks, then that individual latency per request 
accumulates to n times the individual latency, eventually leading to degraded 
transmission speed as those requests are serialized.

> I'm sorry for frustrating your efforts here. We have discussed a lot of
> different ideas and maybe our perspectives are not that far apart
> anymore.
> 
> Keep going with what you think is best. If I am still skeptical we can
> ask someone else to review the patches instead of me so you have a
> second opinion.
> 
> Stefan

Thanks Stefan!

In the meantime I try to address your objections as far as I can. If there is 
more I can do (with reasonable effort) to resolve your doubts, just let me 
know.

Best regards,
Christian Schoenebeck


