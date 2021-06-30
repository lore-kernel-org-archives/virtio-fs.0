Date: Wed, 30 Jun 2021 13:33:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210630173358.GD75386@redhat.com>
References: <20210621062657.3641879-1-hch@lst.de>
	<20210622081217.GA2975@lst.de>
	<YNGhERcnLuzjn8j9@stefanha-x1.localdomain>
	<20210629205048.GE5231@redhat.com> <20210630053601.GA29241@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210630053601.GA29241@lst.de>
Subject: Re: [Virtio-fs] [PATCH 3/2] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org

On Wed, Jun 30, 2021 at 07:36:01AM +0200, Christoph Hellwig wrote:
> On Tue, Jun 29, 2021 at 04:50:48PM -0400, Vivek Goyal wrote:
> > May be we should modify mount_block_root() code so that it does not
> > require that extra "\0". Possibly zero initialize page and that should
> > make sure list_bdev_fs_names() does not have to worry about it.
> > 
> > It is possible that a page gets full from the list of filesystems, and
> > last byte on page is terminating null. In that case just zeroing page
> > will not help. We can keep track of some sort of end pointer and make
> > sure we are not searching beyond that for valid filesystem types.
> > 
> > end = page + PAGE_SIZE - 1;
> > 
> > mount_block_root()
> > {
> > 	for (p = fs_names; p < end && *p; p += strlen(p)+1) {
> > 	}
> > }
> 
> Maybe.  To honest I'd prefer to not even touch this unrelated code given
> how full of landmines it is :)

Agreed. It probably is better to make such changes incrementally. 

Given third patch is nice to have cleanup kind of thing, can we first
just merge first two patches to support non-block device filesystems as
rootfs.

We will really like to have a method to properly boot virtiofs as rootfs.

Thanks
Vivek

