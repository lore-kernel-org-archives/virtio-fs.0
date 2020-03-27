Date: Fri, 27 Mar 2020 10:01:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200327140114.GB32717@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
	<20200304165845.3081-21-vgoyal@redhat.com>
	<20200326000904.GA34937@rsjd01523.et2sqa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326000904.GA34937@rsjd01523.et2sqa>
Subject: Re: [Virtio-fs] [PATCH 20/20] fuse,
	virtiofs: Add logic to free up a memory range
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

On Thu, Mar 26, 2020 at 08:09:05AM +0800, Liu Bo wrote:

[..]
> > +/*
> > + * Find first mapping in the tree and free it and return it. Do not add
> > + * it back to free pool. If fault == true, this function should be called
> > + * with fi->i_mmap_sem held.
> > + */
> > +static struct fuse_dax_mapping *inode_reclaim_one_dmap(struct fuse_conn *fc,
> > +							 struct inode *inode,
> > +							 bool fault)
> > +{
> > +	struct fuse_inode *fi = get_fuse_inode(inode);
> > +	struct fuse_dax_mapping *dmap;
> > +	int ret;
> > +
> > +	if (!fault)
> > +		down_write(&fi->i_mmap_sem);
> > +
> > +	/*
> > +	 * Make sure there are no references to inode pages using
> > +	 * get_user_pages()
> > +	 */
> > +	ret = fuse_break_dax_layouts(inode, 0, 0);
> 
> Hi Vivek,
> 
> This patch is enabling inline reclaim for fault path, but fault path
> has already holds a locked exceptional entry which I believe the above
> fuse_break_dax_layouts() needs to wait for, can you please elaborate
> on how this can be avoided?
> 

Hi Liubo,

Can you please point to the exact lock you are referring to. I will
check it out. Once we got rid of needing to take inode lock in
reclaim path, that opended the door to do inline reclaim in fault
path as well. But I was not aware of this exceptional entry lock.

Vivek

