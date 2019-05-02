Date: Thu, 2 May 2019 15:10:15 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190502221014.b2k352rb5zleadxo@US-160370MP2.local>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-10-bo.liu@linux.alibaba.com>
	<20190416180756.GA2222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190416180756.GA2222@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 9/9] fuse: fix deadlock in
 __fuse_file_fallocate()
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
Cc: virtio-fs@redhat.com

On Tue, Apr 16, 2019 at 02:07:56PM -0400, Vivek Goyal wrote:
> On Wed, Apr 17, 2019 at 02:03:22AM +0800, Liu Bo wrote:
> > From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > 
> > This bug is obvious, fix it.
> > 
> > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> 
> Thanks. This one I ran into late last week while testing
> fallocate(PUNCH_HOLE) and fixed it already in my internal branch.

Hi Vivek,

FYI, the bug still exists in
https://github.com/rhvgoyal/linux/tree/virtio-fs-4.19.28

thanks,
-liubo

> 
> Vivek
> > ---
> >  fs/fuse/file.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 6ab23d7..0236783 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -3623,7 +3623,7 @@ static long __fuse_file_fallocate(struct file *file, int mode,
> >  	if (mode & FALLOC_FL_PUNCH_HOLE) {
> >  		down_write(&fi->i_mmap_sem);
> >  		truncate_pagecache_range(inode, offset, offset + length - 1);
> > -		down_write(&fi->i_mmap_sem);
> > +		up_write(&fi->i_mmap_sem);
> >  	}
> >  	fuse_invalidate_attr(inode);
> >  
> > -- 
> > 1.8.3.1
> > 
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs

