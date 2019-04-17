Date: Tue, 16 Apr 2019 17:12:09 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190417001209.banbxo7yrimhky7n@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-6-bo.liu@linux.alibaba.com>
	<20190416201621.GH2222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416201621.GH2222@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 5/9] fuse: do not write whole page while
 page straddles i_size
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Tue, Apr 16, 2019 at 04:16:21PM -0400, Vivek Goyal wrote:
> On Wed, Apr 17, 2019 at 02:03:18AM +0800, Liu Bo wrote:
> > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > 
> > If page straddles i_size and we write the whole page, the fuse
> > user-space filesystem may extend file size, it will confuse users.
> > 
> > Before this patch:
> > xfs_io -t -f \
> >         -c "truncate 5120" \
> >         -c "pwrite -S 0x58 0 5120"      \
> >         -c "mmap -rw 0 5120"            \
> >         -c "mwrite -S 0x59 2048 3072" \
> >         -c "close"      \
> >         testfile
> > testfile's length will be 8192 bytes, with this patch, testfile's
> > length will be 5120 bytes.
> > 
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> [cc miklos]
> 
> This sounds like a generic fuse issue as well (and not virtio-fs specic)?
> If yes, can you please send this fix separately to miklos and fuse
> mailing list.

Sure, will do.

thanks,
-liubo

> 
> Vivek
> > ---
> >  fs/fuse/file.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index bb45acc..c6090f5 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -2293,6 +2293,8 @@ static int fuse_writepages_fill(struct page *page,
> >  	struct page *tmp_page;
> >  	bool is_writeback;
> >  	int err;
> > +	loff_t size;
> > +	unsigned int len;
> >  
> >  	if (!data->ff) {
> >  		err = -EIO;
> > @@ -2364,7 +2366,12 @@ static int fuse_writepages_fill(struct page *page,
> >  	copy_highpage(tmp_page, page);
> >  	req->pages[req->num_pages] = tmp_page;
> >  	req->page_descs[req->num_pages].offset = 0;
> > -	req->page_descs[req->num_pages].length = PAGE_SIZE;
> > +	size = i_size_read(inode);
> > +	if (page->index == size >> PAGE_SHIFT)
> > +		len = size & ~PAGE_MASK;
> > +	else
> > +		len = PAGE_SIZE;
> > +	req->page_descs[req->num_pages].length = len;
> >  
> >  	inc_wb_stat(&inode_to_bdi(inode)->wb, WB_WRITEBACK);
> >  	inc_node_page_state(tmp_page, NR_WRITEBACK_TEMP);
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

