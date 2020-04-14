Date: Tue, 14 Apr 2020 08:54:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200414125411.GA210453@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-14-vgoyal@redhat.com>
	<20200404002521.GA125697@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200404002521.GA125697@rsjd01523.et2sqa>
Subject: Re: [Virtio-fs] [PATCH 13/20] fuse,
	dax: Implement dax read/write operations
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: miklos@szeredi.hu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, mst@redhat.com, linux-fsdevel@vger.kernel.org

On Sat, Apr 04, 2020 at 08:25:21AM +0800, Liu Bo wrote:

[..]
> > +static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
> > +					 loff_t length, unsigned flags,
> > +					 struct iomap *iomap)
> > +{
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	struct fuse_dax_mapping *dmap;
> > +	int ret;
> > +
> > +	/*
> > +	 * Take exclusive lock so that only one caller can try to setup
> > +	 * mapping and others wait.
> > +	 */
> > +	down_write(&fi->i_dmap_sem);
> > +	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos, pos);
> > +
> > +	/* We are holding either inode lock or i_mmap_sem, and that should
> > +	 * ensure that dmap can't reclaimed or truncated and it should still
> > +	 * be there in tree despite the fact we dropped and re-acquired the
> > +	 * lock.
> > +	 */
> > +	ret = -EIO;
> > +	if (WARN_ON(!dmap))
> > +		goto out_err;
> > +
> > +	/* Maybe another thread already upgraded mapping while we were not
> > +	 * holding lock.
> > +	 */
> > +	if (dmap->writable)
> 
> oops, looks like it's still returning -EIO here, %ret should be zero.
> 

Good catch. Will fix it.

Vivek

