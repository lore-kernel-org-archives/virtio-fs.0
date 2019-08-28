Date: Thu, 29 Aug 2019 08:53:22 +1000
From: Dave Chinner <david@fromorbit.com>
Message-ID: <20190828225322.GA7777@dread.disaster.area>
References: <20190821175720.25901-1-vgoyal@redhat.com>
	<20190821175720.25901-2-vgoyal@redhat.com>
	<20190826115152.GA21051@infradead.org>
	<20190827163828.GA6859@redhat.com>
	<20190828065809.GA27426@infradead.org>
	<20190828175843.GB912@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190828175843.GB912@redhat.com>
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
Cc: virtio-fs@redhat.com, linux-nvdimm@lists.01.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>

On Wed, Aug 28, 2019 at 01:58:43PM -0400, Vivek Goyal wrote:
> On Tue, Aug 27, 2019 at 11:58:09PM -0700, Christoph Hellwig wrote:
> > On Tue, Aug 27, 2019 at 12:38:28PM -0400, Vivek Goyal wrote:
> > > > For bdev_dax_pgoff
> > > > I'd much rather have the partition offset if there is on in the daxdev
> > > > somehow so that we can get rid of the block device entirely.
> > > 
> > > IIUC, there is one block_device per partition while there is only one
> > > dax_device for the whole disk. So we can't directly move bdev logical
> > > offset into dax_device.
> > 
> > Well, then we need to find a way to get partitions for dax devices,
> > as we really should not expect a block device hiding behind a dax
> > dev.  That is just a weird legacy assumption - block device need to
> > layer on top of the dax device optionally.
> > 
> > > 
> > > We probably could put this in "iomap" and leave it to filesystems to
> > > report offset into dax_dev in iomap that way dax generic code does not
> > > have to deal with it. But that probably will be a bigger change.
> > 
> > And where would the file system get that information from?
> 
> File system knows about block device, can it just call get_start_sect()
> while filling iomap->addr. And this means we don't have to have
> parition information in dax device. Will something like following work?
> (Just a proof of concept patch).
> 
> 
> ---
>  drivers/dax/super.c |   11 +++++++++++
>  fs/dax.c            |    6 +++---
>  fs/ext4/inode.c     |    6 +++++-
>  include/linux/dax.h |    1 +
>  4 files changed, 20 insertions(+), 4 deletions(-)
> 
> Index: rhvgoyal-linux/fs/ext4/inode.c
> ===================================================================
> --- rhvgoyal-linux.orig/fs/ext4/inode.c	2019-08-28 13:51:16.051937204 -0400
> +++ rhvgoyal-linux/fs/ext4/inode.c	2019-08-28 13:51:44.453937204 -0400
> @@ -3589,7 +3589,11 @@ retry:
>  			WARN_ON_ONCE(1);
>  			return -EIO;
>  		}
> -		iomap->addr = (u64)map.m_pblk << blkbits;
> +		if (IS_DAX(inode))
> +			iomap->addr = ((u64)map.m_pblk << blkbits) +
> +				      (get_start_sect(iomap->bdev) * 512);
> +		else
> +			iomap->addr = (u64)map.m_pblk << blkbits;

I'm not a fan of returning a physical device sector address from an
interface where ever other user/caller expects this address to be a
logical block address into the block device. It creates a landmine
in the iomap API that callers may not be aware of and that's going
to cause bugs. We're trying really hard to keep special case hacks
like this out of the iomap infrastructure, so on those grounds alone
I'd suggest this is a dead end approach.

Hence I think that if the dax device needs a physical offset from
the start of the block device the filesystem sits on, it should be
set up at dax device instantiation time and so the filesystem/bdev
never needs to be queried again for this information.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

