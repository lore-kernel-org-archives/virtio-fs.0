DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=intel-com.20150623.gappssmtp.com; s=20150623;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=k3brJhWTSesWIRxDSnHgjF8nIZbts1Wu314rZzjXn1M=;
	b=lAn6FgwQQMYzkHNrvN1rRFNYVp+0/0fgWehxuV9jdkjbcq9UCjg/LWklrQMinMlTD+
	rjYhtgI2mNvRwWUnxAh3hV7ai1xjTahx4eD0I1E9IdQ4AWpZK0J6emaWKMy8TPy41pKP
	h63PGVQD/FEUvYx/yJwAhI8+3ooXUTbsu+MiCIAAHl1x2cxQqUlcp3d01qkIiWnF0sdv
	N2jvz2p8Z951aXN0UyUCkTU2WzwTU9HH0ZeLgyQzMMEl2rsW74FOlfswuDQP5Pw2wqYc
	ECOLx9irUQlfTHxACK2Lo5WiAl8FxMN5h06QpbaSb3r19c6QAS8YIyYY0iE0yDWNxke9
	SqmA==
MIME-Version: 1.0
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-3-vgoyal@redhat.com>
	<20190826115316.GB21051@infradead.org>
	<20190826203326.GB13860@redhat.com>
	<20190826205829.GC13860@redhat.com> <20200103141235.GA13350@redhat.com>
In-Reply-To: <20200103141235.GA13350@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 3 Jan 2020 10:12:09 -0800
Message-ID: <CAPcyv4hr-KXUAT_tVy-GuTOq1GvVGHKsHwAPih60wcW3DGmqRg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Cc: Christoph Hellwig <hch@infradead.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, virtio-fs@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 3, 2020 at 6:12 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Aug 26, 2019 at 04:58:29PM -0400, Vivek Goyal wrote:
> > On Mon, Aug 26, 2019 at 04:33:26PM -0400, Vivek Goyal wrote:
> > > On Mon, Aug 26, 2019 at 04:53:16AM -0700, Christoph Hellwig wrote:
> > > > On Wed, Aug 21, 2019 at 01:57:03PM -0400, Vivek Goyal wrote:
> > > > > Right now dax_writeback_mapping_range() is passed a bdev and dax_dev
> > > > > is searched from that bdev name.
> > > > >
> > > > > virtio-fs does not have a bdev. So pass in dax_dev also to
> > > > > dax_writeback_mapping_range(). If dax_dev is passed in, bdev is not
> > > > > used otherwise dax_dev is searched using bdev.
> > > >
> > > > Please just pass in only the dax_device and get rid of the block device.
> > > > The callers should have one at hand easily, e.g. for XFS just call
> > > > xfs_find_daxdev_for_inode instead of xfs_find_bdev_for_inode.
> > >
> > > Sure. Here is the updated patch.
> > >
> > > This patch can probably go upstream independently. If you are fine with
> > > the patch, I can post it separately for inclusion.
> >
> > Forgot to update function declaration in case of !CONFIG_FS_DAX. Here is
> > the updated patch.
> >
> > Subject: dax: Pass dax_dev instead of bdev to dax_writeback_mapping_range()
> >
> > As of now dax_writeback_mapping_range() takes "struct block_device" as a
> > parameter and dax_dev is searched from bdev name. This also involves taking
> > a fresh reference on dax_dev and putting that reference at the end of
> > function.
> >
> > We are developing a new filesystem virtio-fs and using dax to access host
> > page cache directly. But there is no block device. IOW, we want to make
> > use of dax but want to get rid of this assumption that there is always
> > a block device associated with dax_dev.
> >
> > So pass in "struct dax_device" as parameter instead of bdev.
> >
> > ext2/ext4/xfs are current users and they already have a reference on
> > dax_device. So there is no need to take reference and drop reference to
> > dax_device on each call of this function.
> >
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>
> Hi Dan,
>
> Ping for this patch. I see christoph and Jan acked it. Can we take it. Not
> sure how to get ack from ext4 developers.

Jan counts for ext4, I just missed this. Now merged.


