DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jXWv6rxcD/Ytdxuw9oCBSvjHqSotwy8H8FiFgT6NRRg=;
	b=eNdor4/fygoZH6Xvs2bMeOvXp
	tLJNYDfk1cimf7+kbTn2BtXDWxLqRI4BEoxvkM59QMQwbcBMvCELCNq/zJkLCXbTBzuB4qK60s7R/
	haWdRVRaEqnJlYuCV4UwO8CFnpN8keiifEYRocm9hSV7hdJbuhyANoVbu4fvGSZZTtQWctl+4PkEQ
	/oN+phe7MFMf78kAF3jl7VDQ4vwdv93FRJN87qRsxSrA+o2vNKwsWkTPjLWfJ6jdO987prP1KZI6Z
	19zNadIV1LWue77KVSIM1O13lgtmraWBA1EkdjuK6SDKTpSqH94t7Ag5Ad+KKj2s3isfBEvJQ6hgD
	xAZ0rNRsA==;
Date: Thu, 29 Aug 2019 02:32:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20190829093238.GA23102@infradead.org>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-2-vgoyal@redhat.com>
	<20190826115152.GA21051@infradead.org>
	<20190827163828.GA6859@redhat.com>
	<20190828065809.GA27426@infradead.org>
	<20190828175843.GB912@redhat.com>
	<20190828225322.GA7777@dread.disaster.area>
	<CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jGEAbYSJef2zLzgg6Arozsuz7eN_vZL1iTcd1XQuNT4Q@mail.gmail.com>
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

On Wed, Aug 28, 2019 at 05:04:11PM -0700, Dan Williams wrote:
> Agree. In retrospect it was my laziness in the dax-device
> implementation to expect the block-device to be available.
> 
> It looks like fs_dax_get_by_bdev() is an intercept point where a
> dax_device could be dynamically created to represent the subset range
> indicated by the block-device partition. That would open up more
> cleanup opportunities.

That seems like a decent short-term plan.  But in the long I'd just let
dax call into the partition table parser directly, as we might want to
support partitions without first having to create a block device on top
of the dax device.  Same for the badblocks handling story.

