DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=r3VJe/dxyES65jnKtxYvETSNTHRiCAT6fnUUzfyEBsw=;
	b=IntyA5ICPEcRthqRYPCmMbZcDUdsPJKB41XMg3aNHyS8R6cuHoUT2CPYMdsXtRhIV/
	LE4AcTadPsbgzvkcanUbj/feghWprHupsWmFBAPc7sYF+VAsmKBx0fZyJQK8bF8M1Psc
	370rbvXm8e9yiT13+D5wg9K9mjUTdZdQ9TNUaJGocfOBIb2O4l3RX+l6g6lrQRLR542K
	uq6u075ZxqWd1dtGOT1YwXlKc+p25Z2v9ktm+IMQk7DdS4ccYqbvvQwR3hNsxwzI7ML7
	uZQ0x6Z/8r+EpXB5udA1qIlwP1zqd7XKjywpXRr4ylCkyezT+6v9gNmT4LaYtbSFwB4R
	bikA==
MIME-Version: 1.0
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-2-vgoyal@redhat.com>
	<20190826115152.GA21051@infradead.org>
	<20190827163828.GA6859@redhat.com>
	<20190828065809.GA27426@infradead.org>
	<20190828175843.GB912@redhat.com>
	<20190828225322.GA7777@dread.disaster.area>
	<CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
	<20200107125159.GA15745@infradead.org>
In-Reply-To: <20200107125159.GA15745@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 7 Jan 2020 06:22:54 -0800
Message-ID: <CAPcyv4jZE35sbDo6J4ihioEUFTuekJ3_h0=2Ra4PY+xn2xn1cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Tue, Jan 7, 2020 at 4:52 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Mon, Dec 16, 2019 at 01:10:14PM -0500, Vivek Goyal wrote:
> > > Agree. In retrospect it was my laziness in the dax-device
> > > implementation to expect the block-device to be available.
> > >
> > > It looks like fs_dax_get_by_bdev() is an intercept point where a
> > > dax_device could be dynamically created to represent the subset range
> > > indicated by the block-device partition. That would open up more
> > > cleanup opportunities.
> >
> > Hi Dan,
> >
> > After a long time I got time to look at it again. Want to work on this
> > cleanup so that I can make progress with virtiofs DAX paches.
> >
> > I am not sure I understand the requirements fully. I see that right now
> > dax_device is created per device and all block partitions refer to it. If
> > we want to create one dax_device per partition, then it looks like this
> > will be structured more along the lines how block layer handles disk and
> > partitions. (One gendisk for disk and block_devices for partitions,
> > including partition 0). That probably means state belong to whole device
> > will be in common structure say dax_device_common, and per partition state
> > will be in dax_device and dax_device can carry a pointer to
> > dax_device_common.
> >
> > I am also not sure what does it mean to partition dax devices. How will
> > partitions be exported to user space.
>
> Dan, last time we talked you agreed that partitioned dax devices are
> rather pointless IIRC.  Should we just deprecate partitions on DAX
> devices and then remove them after a cycle or two?

That does seem a better plan than trying to force partition support
where it is not needed.


