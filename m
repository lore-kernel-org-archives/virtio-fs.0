Date: Mon, 10 May 2021 14:16:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210510181623.GA185367@horse>
References: <20210506184304.321645-1-vgoyal@redhat.com>
	<20210506184304.321645-2-vgoyal@redhat.com>
	<YJQ+ex2DUPYo1GV5@work-vm>
	<20210506193517.GF388843@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <20210506193517.GF388843@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH 1/2] virtiofs,
 dax: Fix smatch warning about loss of info during shift
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Matthew Wilcox <willy@infradead.org>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com

On Thu, May 06, 2021 at 12:35:17PM -0700, Matthew Wilcox wrote:
> On Thu, May 06, 2021 at 08:07:39PM +0100, Dr. David Alan Gilbert wrote:
> > > @@ -186,7 +186,7 @@ static int fuse_setup_one_mapping(struct inode *inode, unsigned long start_idx,
> > >  	struct fuse_conn_dax *fcd = fm->fc->dax;
> > >  	struct fuse_inode *fi = get_fuse_inode(inode);
> > >  	struct fuse_setupmapping_in inarg;
> > > -	loff_t offset = start_idx << FUSE_DAX_SHIFT;
> > > +	loff_t offset = (loff_t)start_idx << FUSE_DAX_SHIFT;
> > 
> > I've not followed the others back, but isn't it easier to change
> > the start_idx parameter to be a loff_t, since the places it's called
> > from are poth loff_t pos?
> 
> But an index isn't a file offset, and shouldn't be typed as such.

Agreed. This is index, so it seems better to not use "loff_t" to
represent it.

Vivek

