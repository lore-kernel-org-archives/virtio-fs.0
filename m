DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2kBnL5gA8Hu2OCxhQ/ljIeIBv2eKrh+kqk+I83yZiPg=;
	b=ZWBdCh+xKxFQSUSue/qfzQHsj
	6T5S7vMsw+xLZ62ufe9Nw3VxsvMHHudJaF8KytEMMXsDhKtJIMWpsjy+CQ2AaJlNh+CZM7spuk1qi
	/GG/VNY7ofqvL8y2h70Tkp7c2xkCRxKZ1rFFxsF9ewZVdfm5fMyeHS7JZqUgbOIVcUM4enC/7CPfL
	YvahSVPFgA+tsvy8E7FsjcEDyCoXQ7NeHHA9vZPIY3RKwvTq97SGhEeSWoA7Sbe4ZJF+SklJGS433
	rfYX021bytGaEdqU7+9n2lMTY4eAmfRy/GoDNiu+qsLx1wh+rUf9RelcB0PwHzVtNjAEn/Sepic4P
	CyVpuzEdg==;
Date: Tue, 7 Jan 2020 04:51:59 -0800
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20200107125159.GA15745@infradead.org>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-2-vgoyal@redhat.com>
	<20190826115152.GA21051@infradead.org>
	<20190827163828.GA6859@redhat.com>
	<20190828065809.GA27426@infradead.org>
	<20190828175843.GB912@redhat.com>
	<20190828225322.GA7777@dread.disaster.area>
	<CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
	<20191216181014.GA30106@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191216181014.GA30106@redhat.com>
Content-Type: text/plain; charset=us-ascii
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
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>

On Mon, Dec 16, 2019 at 01:10:14PM -0500, Vivek Goyal wrote:
> > Agree. In retrospect it was my laziness in the dax-device
> > implementation to expect the block-device to be available.
> > 
> > It looks like fs_dax_get_by_bdev() is an intercept point where a
> > dax_device could be dynamically created to represent the subset range
> > indicated by the block-device partition. That would open up more
> > cleanup opportunities.
> 
> Hi Dan,
> 
> After a long time I got time to look at it again. Want to work on this
> cleanup so that I can make progress with virtiofs DAX paches.
> 
> I am not sure I understand the requirements fully. I see that right now
> dax_device is created per device and all block partitions refer to it. If
> we want to create one dax_device per partition, then it looks like this
> will be structured more along the lines how block layer handles disk and
> partitions. (One gendisk for disk and block_devices for partitions,
> including partition 0). That probably means state belong to whole device
> will be in common structure say dax_device_common, and per partition state
> will be in dax_device and dax_device can carry a pointer to
> dax_device_common.
> 
> I am also not sure what does it mean to partition dax devices. How will
> partitions be exported to user space.

Dan, last time we talked you agreed that partitioned dax devices are
rather pointless IIRC.  Should we just deprecate partitions on DAX
devices and then remove them after a cycle or two?


