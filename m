Date: Wed, 17 Apr 2019 16:56:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190417205653.GB3003@redhat.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
	<20190416180322.65113-7-bo.liu@linux.alibaba.com>
	<20190416193837.GE2222@redhat.com>
	<CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOssrKcnCzt9+om9=5pFqGBAeNds7U3FWpXWHLp6KNgHmVZ=Pg@mail.gmail.com>
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
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: virtio-fs@redhat.com

On Wed, Apr 17, 2019 at 10:25:53AM +0200, Miklos Szeredi wrote:
> On Tue, Apr 16, 2019 at 9:38 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Wed, Apr 17, 2019 at 02:03:19AM +0800, Liu Bo wrote:
> > > In case of dax+cache=none, mmap uses dax style prior to directIO style,
> > > while read/write don't, but it seems that there is no reason not to do so.
> > >
> > > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> > > Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> >
> > This is interesting. I was thinking about it today itself. I noticed
> > that ext4 and xfs also check for DAX inode first and use dax path
> > if dax is enabled.
> >
> > cache=never sets FOPEN_DIRECT_IO (even if application never asked for
> > direct IO). If dax is enabled, for data its equivalent to doing direct
> > IO. And for mmap() we are already checking for DAX first. So it makes
> > sense to do same thing for read/write path as well.
> >
> > CCing Miklos as well. He might have some thougts on this. I am curios
> > that initially whey did he make this change only for mmap() and not
> > for read/write paths.
> 
> AFAIR the main reason was that we had performance issues with size
> extending writes with dax.

Finally I decided to do some measurement on performance cost of file
extending writes. I wrote a small program to keep on writing 5 bytes
at the end of file 16K times and measure total time.

With cache=never and dax not enabled, it takes around 2.5 to 3 seconds.
With cache=never and dax enabled (and code modified to call dax path),
it takes around 12 to 13 seconds.

So fallocate() path is definitely seem to be 4-5 times slower. I tried
replacing fallocate() with truncate operation but that does not help
much either.

Part of the reason it being slow seems to be fallocate() operation on
host itself is expensive. It roughly took 4 seconds to perform 16K
fallocate() requests while it took only 100 us to perform 16K write
requests (as received by lo_write_buf()).

But that explains only about 4 seconds of extra latency. Assuming fuse
and virtio communication latency is same between two commands (FUSE_WRITE,
FUSE_FALLOCATE), not sure where another 5-6 seconds of latency comes
from.

Apart from latency, fallocate() also has the issue that its not atomic.

Thanks
Vivek

