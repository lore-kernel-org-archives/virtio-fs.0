Date: Thu, 25 Apr 2019 14:35:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190425183557.GC17670@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-7-bo.liu@linux.alibaba.com>
	<20190416193837.GE2222@redhat.com>
	<CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
	<20190417193553.t367ekb37vnpnkd4@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190417193553.t367ekb37vnpnkd4@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 6/9] virtio-fs: let dax style override
 directIO style when dax+cache=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Miklos Szeredi <mszeredi@redhat.com>

On Wed, Apr 17, 2019 at 12:35:54PM -0700, Liu Bo wrote:
> On Wed, Apr 17, 2019 at 10:25:53AM +0200, Miklos Szeredi wrote:
> > On Tue, Apr 16, 2019 at 9:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Apr 17, 2019 at 02:03:19AM +0800, Liu Bo wrote:
> > > > In case of dax+cache=none, mmap uses dax style prior to directIO style,
> > > > while read/write don't, but it seems that there is no reason not to do so.
> > > >
> > > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> > >
> > > This is interesting. I was thinking about it today itself. I noticed
> > > that ext4 and xfs also check for DAX inode first and use dax path
> > > if dax is enabled.
> > >
> > > cache=never sets FOPEN_DIRECT_IO (even if application never asked for
> > > direct IO). If dax is enabled, for data its equivalent to doing direct
> > > IO. And for mmap() we are already checking for DAX first. So it makes
> > > sense to do same thing for read/write path as well.
> > >
> > > CCing Miklos as well. He might have some thougts on this. I am curios
> > > that initially whey did he make this change only for mmap() and not
> > > for read/write paths.
> > 
> > AFAIR the main reason was that we had performance issues with size
> > extending writes with dax.
> > 
> > There is also the question of mtime updates and atime updates, which
> > are handled properly with FOPEN_DIRECT_IO, but not with DAX I/O.
> 
> Looks like fuse_iget() has set inode with NOATIME and NOCMTIME under
> the case "!fc->writeback_cache", which is true in dax mode, do we
> still case about time update?
> 
> AFAICS, these metadata are maintained by host side.

I guess what Miklos is alluding to is that with cache=none,
FOPEN_DIRECT_IO will always be set. That means file data will not be
cached in guest and all read/writes and file changes will go through
fuse daemon and that will result in atime/ctime/mtime update on file
on host (because of fuse daemon operations).

But with DAX path, it translates to mmap() IO on host and atime/mtime/ctime
update semantics are every different there as opposed to read/write.

My take on this is that we have two modes here. "cache=none" and
"cache=none+dax". Those who are concerned with strict atime/ctime/mtime
update behavior, should not mount with dax enabled.

Thanks
Vivek

