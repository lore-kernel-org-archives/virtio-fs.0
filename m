DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209;
	h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=lZnBdyi3U2JinlfRXPGTK6Ot4IAtObs74Nrk19Et59I=;
	b=h4nljASh9KzABQmHDW5KPiI5y
	rYfaQ9ckmtTLidzXqdVCp0kF98xjf4iYIvzChMQ+kZPX5dFnceTCsbzUIUgXzefxzhTIey+QON6E3
	HdKAyQOYx2zGew4MWxorz2O/U4UXjDKU8vLrNzb/YCEO23oqRpsSvaQ+xzPFCXiGigwnO51UQU8Ng
	c2nipNf141NY7vJYW1pgnwmI3CJ2N2UQXsUkB8/CWGoqHPEmwsC99YcpjCUNrRkng2qqYkxwezrRV
	bdEm2DiIK+AbKnMruJeHndTGfb4h0UTWaRATbqcGJPhWonnBXPiaTIWTzgA5TCnXYX7nZzgLDuvGR
	A5CXgO69w==;
Date: Mon, 26 Aug 2019 04:53:16 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20190826115316.GB21051@infradead.org>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821175720.25901-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 02/19] dax: Pass dax_dev to
	dax_writeback_mapping_range()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Wed, Aug 21, 2019 at 01:57:03PM -0400, Vivek Goyal wrote:
> Right now dax_writeback_mapping_range() is passed a bdev and dax_dev
> is searched from that bdev name.
> 
> virtio-fs does not have a bdev. So pass in dax_dev also to
> dax_writeback_mapping_range(). If dax_dev is passed in, bdev is not
> used otherwise dax_dev is searched using bdev.

Please just pass in only the dax_device and get rid of the block device.
The callers should have one at hand easily, e.g. for XFS just call
xfs_find_daxdev_for_inode instead of xfs_find_bdev_for_inode.

