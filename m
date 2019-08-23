Date: Fri, 23 Aug 2019 08:52:23 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190823125223.GA11009@redhat.com>
References: <1566367838-47809-1-git-send-email-bo.liu@linux.alibaba.com>
	<20190822201627.GD8999@redhat.com> <5D5F31BC.1020704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D5F31BC.1020704@huawei.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: fix return value of
 iomap_begin_upgrade_mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: piaojun <piaojun@huawei.com>
Cc: virtio-fs@redhat.com

On Fri, Aug 23, 2019 at 08:22:20AM +0800, piaojun wrote:
> 
> 
> On 2019/8/23 4:16, Vivek Goyal wrote:
> > On Wed, Aug 21, 2019 at 02:10:38PM +0800, Liu Bo wrote:
> >> Set ret = 0 if everything runs fine.
> >>
> >> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> >> ---
> >>  fs/fuse/file.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> >> index eb7543a..d3c5e45 100644
> >> --- a/fs/fuse/file.c
> >> +++ b/fs/fuse/file.c
> >> @@ -1985,6 +1985,7 @@ static int iomap_begin_upgrade_mapping(struct inode *inode, loff_t pos,
> >>  
> >>  out_fill_iomap:
> >>  	fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
> >> +	ret = 0;
> > 
> > Thanks. I initialized ret = 0 in the beginning itself now. 
> 
> This probably would not work as ret will be set -EIO again immediately.

I changed that ret = -EIO as well. I now set it only when error happens.

Vivek

