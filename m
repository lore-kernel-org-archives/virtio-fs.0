DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com;
	h=date : from : to : cc
	: subject : message-id : references : mime-version : content-type :
	in-reply-to; s=corp-2019-08-05;
	bh=TonZdKs5flBwONqESEptkzUdNDu8nb8volKmuzA6Cz0=;
	b=Dg5eAnULbmvdHQzXt/MZgtHB0R/zWD0HQ+5s3azeZp8EEZ34ay8U8IXHjZGsgK27rehS
	bb8ffV2JEBwuogOZg4wcANMgdMBKS97CpXpWk7KU7SVlPQgFUWlVHu1DAfnGryIv1LKI
	M5AvVllmupEsFvrHYTNamVFhNzc87ByL1gWOw0iTmEuPoX1/m7tYqFY+EvYYNZUwGLxG
	1Lo8F+6TNJ6Q1EeRhKR2XXV7l75GPDLV1kYwFuGmzfY9nlZh5W1Im1qMYi7elyFGtzp+
	gnwn6VDCbHk8N4C5wW46kKsyxAWes1ui6aXftOTsyPgLj2wHtLqD0FgPkvrqcDbM/whH
	9A==
Date: Tue, 7 Jan 2020 09:07:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Message-ID: <20200107170731.GA472641@magnolia>
References: <20190821175720.25901-2-vgoyal@redhat.com>
	<20190826115152.GA21051@infradead.org>
	<20190827163828.GA6859@redhat.com>
	<20190828065809.GA27426@infradead.org>
	<20190828175843.GB912@redhat.com>
	<20190828225322.GA7777@dread.disaster.area>
	<CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
	<20200107125159.GA15745@infradead.org>
	<CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 01/19] dax: remove block device dependencies
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Dan Williams <dan.j.williams@intel.com>
Cc: virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 07, 2020 at 06:22:54AM -0800, Dan Williams wrote:
> On Tue, Jan 7, 2020 at 4:52 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Mon, Dec 16, 2019 at 01:10:14PM -0500, Vivek Goyal wrote:
> > > > Agree. In retrospect it was my laziness in the dax-device
> > > > implementation to expect the block-device to be available.
> > > >
> > > > It looks like fs_dax_get_by_bdev() is an intercept point where a
> > > > dax_device could be dynamically created to represent the subset range
> > > > indicated by the block-device partition. That would open up more
> > > > cleanup opportunities.
> > >
> > > Hi Dan,
> > >
> > > After a long time I got time to look at it again. Want to work on this
> > > cleanup so that I can make progress with virtiofs DAX paches.
> > >
> > > I am not sure I understand the requirements fully. I see that right now
> > > dax_device is created per device and all block partitions refer to it. If
> > > we want to create one dax_device per partition, then it looks like this
> > > will be structured more along the lines how block layer handles disk and
> > > partitions. (One gendisk for disk and block_devices for partitions,
> > > including partition 0). That probably means state belong to whole device
> > > will be in common structure say dax_device_common, and per partition state
> > > will be in dax_device and dax_device can carry a pointer to
> > > dax_device_common.
> > >
> > > I am also not sure what does it mean to partition dax devices. How will
> > > partitions be exported to user space.
> >
> > Dan, last time we talked you agreed that partitioned dax devices are
> > rather pointless IIRC.  Should we just deprecate partitions on DAX
> > devices and then remove them after a cycle or two?
> 
> That does seem a better plan than trying to force partition support
> where it is not needed.

Question: if one /did/ have a partitioned DAX device and used kpartx to
create dm-linear devices for each partition, will DAX still work through
that?

--D


