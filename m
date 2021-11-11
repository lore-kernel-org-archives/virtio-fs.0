DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Content-ID:Content-Description;
	bh=W7wQoCLArWvskGiXcgMWsqLxBL+Bk5wPXKj6ORmZhc0=;
	b=ZtmO/grEHoJ+cBNGK0IHlZ1b2q
	kanE+95I/v5JAUk/FkBR5I3kXsY6h15DU/wvCbkCEPx8+MBPy+8caYhRgziELFPX9uHaPQVVcNVu4
	nvuGEJv54enIv88bZDMN5obP47KT2LzCxwYg/KYt3omHi83sCVO3GB8++1roCquo45uWUm+4LZInU
	n+yMlzniaXyp+X+BklYHaIcMboECqqdJEt2XHEXje/vUs9M1EX8WqBgc4gJFn1kVAquh2TTlOc+Rv
	DKwh49kcBGbhbB/ZjjRy2OhNpBEMotdExAQtIET2leWw7Wap7H1zg9eE7YdHJBobXmwQF+nsjEKpb
	Cb0TFhVC3v3lrmaMNaQThhU/Ujg2ECAgPk02FjgUu0ZMLcfoObZcaQ9DHIy/GTTlHNey5nQnGzgXU
	+t1oMfXXOh3/XKruUSJqdfqSUHF9cKWxQXvJpKAwNg4e9sTpAvrkIBWc+Ey7iOsOpLgC0PTtr50L8
	QBXT7GYpPUHA7Lql6qJKgPfSLlGqoDs7oRC/c664l5EfWEACBr0acgN2lYnH9E+DQfMxLw8HP8rQL
	/sP6vnXEz0K1N+B5dNSBaw2vAu2epWe/rDN9QCrPM8HK2jpewfh2kQZrRc11FltJL2hRnNdN6zv10
	v0jyzK/nl4t4bTndT2Utyafjwx6Ss+z14HVi7TR04=
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Thu, 11 Nov 2021 18:54:03 +0100
Message-ID: <2186445.RDNOEBgitd@silver>
In-Reply-To: <YY1FeMyvTOOWYEhV@stefanha-x1.localdomain>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
	<1965987.S3ubrJPkfX@silver>
	<YY1FeMyvTOOWYEhV@stefanha-x1.localdomain>
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

On Donnerstag, 11. November 2021 17:31:52 CET Stefan Hajnoczi wrote:
> On Wed, Nov 10, 2021 at 04:53:33PM +0100, Christian Schoenebeck wrote:
> > On Mittwoch, 10. November 2021 16:14:19 CET Stefan Hajnoczi wrote:
> > > On Wed, Nov 10, 2021 at 02:14:43PM +0100, Christian Schoenebeck wrote:
> > > > On Mittwoch, 10. November 2021 11:05:50 CET Stefan Hajnoczi wrote:
> > > > As you are apparently reluctant for changing the virtio specs, what
> > > > about
> > > > introducing those discussed virtio capabalities either as experimental
> > > > ones
> > > > without specs changes, or even just as 9p specific device capabilities
> > > > for
> > > > now. I mean those could be revoked on both sides at any time anyway.
> > > 
> > > I would like to understand the root cause before making changes.
> > > 
> > > "It's faster when I do X" is useful information but it doesn't
> > > necessarily mean doing X is the solution. The "it's faster when I do X
> > > because Y" part is missing in my mind. Once there is evidence that shows
> > > Y then it will be clearer if X is a good solution, if there's a more
> > > general solution, or if it was just a side-effect.
> > 
> > I think I made it clear that the root cause of the observed performance
> > gain with rising transmission size is latency (and also that performance
> > is not the only reason for addressing this queue size issue).
> > 
> > Each request roundtrip has a certain minimum latency, the virtio ring
> > alone
> > has its latency, plus latency of the controller portion of the file server
> > (e.g. permissions, sandbox checks, file IDs) that is executed with *every*
> > request, plus latency of dispatching the request handling between threads
> > several times back and forth (also for each request).
> > 
> > Therefore when you split large payloads (e.g. reading a large file) into
> > smaller n amount of chunks, then that individual latency per request
> > accumulates to n times the individual latency, eventually leading to
> > degraded transmission speed as those requests are serialized.
> 
> It's easy to increase the blocksize in benchmarks, but real applications
> offer less control over the I/O pattern. If latency in the device
> implementation (QEMU) is the root cause then reduce the latency to speed
> up all applications, even those that cannot send huge requests.

Which I did, still do, and also mentioned before, e.g.:

8d6cb100731c4d28535adbf2a3c2d1f29be3fef4 9pfs: reduce latency of Twalk
0c4356ba7dafc8ecb5877a42fc0d68d45ccf5951 9pfs: T_readdir latency optimization

Reducing overall latency is a process that is ongoing and will still take a 
very long development time. Not because of me, but because of lack of 
reviewers. And even then, it does not make the effort to support higher 
transmission sizes obsolete.

> One idea is request merging on the QEMU side. If the application sends
> 10 sequential read or write requests, coalesce them together before the
> main part of request processing begins in the device. Process a single
> large request to spread the cost of the file server over the 10
> requests. (virtio-blk has request merging to help with the cost of lots
> of small qcow2 I/O requests.) The cool thing about this is that the
> guest does not need to change its I/O pattern to benefit from the
> optimization.
> 
> Stefan

Ok, don't get me wrong: I appreciate that you are suggesting approaches that 
could improve things. But I could already hand you over a huge list of mine. 
The limiting factor here is not the lack of ideas of what could be improved, 
but rather the lack of people helping out actively on 9p side:
https://lists.gnu.org/archive/html/qemu-devel/2021-10/msg06452.html

The situation on kernel side is the same. I already have a huge list of what 
could & should be improved. But there is basically no reviewer for 9p patches 
on Linux kernel side either.

The much I appreciate suggestions of what could be improved, I would 
appreciate much more if there was *anybody* actively assisting as well. In the 
time being I have to work the list down in small patch chunks, priority based.

Best regards,
Christian Schoenebeck


