Date: Wed, 8 May 2019 19:32:00 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190509023159.64faeoxlg6ngcddn@US-160370MP2.local>
References: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
	<1557208691-43817-3-git-send-email-bo.liu@linux.alibaba.com>
	<20190508152704.GC16971@redhat.com>
	<20190508184805.fw2h5r5yn75ut7ff@US-160370MP2.local>
	<CACGKRzWW3Js1vvy7ZVLZsykijwi7SMxdRZhuev9yQX+98n3=gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGKRzWW3Js1vvy7ZVLZsykijwi7SMxdRZhuev9yQX+98n3=gA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofs: add dmap flags to
 differentiate write mapping from read mapping
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Tao Peng <bergwolf@hyper.sh>
Cc: virtio-fs@redhat.com

On Thu, May 09, 2019 at 10:01:03AM +0800, Tao Peng wrote:
> On Thu, May 9, 2019 at 2:48 AM Liu Bo <bo.liu@linux.alibaba.com> wrote:
> >
> > On Wed, May 08, 2019 at 11:27:04AM -0400, Vivek Goyal wrote:
> > > On Tue, May 07, 2019 at 01:58:11PM +0800, Liu Bo wrote:
> > > > There're 2 problems in dax rw path which were found by [1][2],

> > > >
> > > > a) setupmapping always sends a RW mapping message to virtiofs daemon side
> > > > no matter it's doing reads or writes, the end result is that guest reads
> > > > on a mapping will cause a write page fault on host, which is unnecessary.
> > > >
> > > > b) After a successful setupmapping, it doesn't guarantee the following
> > > > writes can land on host, e.g. page fault on host may fail because of
> > > > ENOSPC.
> > > >
> > > > This is trying to solve the problems by
> > > > a) marking a dmap as RO or RW to indicate it's being used for reads or
> > > >    writes,
> > > > b) setting up a RO dmap for reads
> > > > c) setting up a RW dmap for writes
> > > > d) using an existing dmap for reads if it's availalbe in the interval tree
> > > > e) converting an existing dmap from RO to RW for writes if it's available
> > > >    in the interval tree
> > > >
> > > > The downside of the above approach is write amplification.
> > >
> > > Another downside of using fallocate() is performance overhead. I wrote
> > > a problem to do small 16K file extending writes and measure total time
> > > with and without fallocate. Fallocate version seems to be much slower.
> > >
> > > With fallocate()
> > > ===============
> > > # ./file-extending-writes /mnt/virtio-fs/foo.txt
> > > 16384 extending writes took 14 secs and 647210 us
> > > 16384 extending writes took 11 secs and 571941 us
> > > 16384 extending writes took 11 secs and 981329 us
> > >
> > > With dax + direct write (FUSE_WRITE)
> > > ==============================
> > > # ./file-extending-writes /mnt/virtio-fs/foo.txt
> > > 16384 extending writes took 2 secs and 477642 us
> > > 16384 extending writes took 2 secs and 352413 us
> > > 16384 extending writes took 2 secs and 347223 us
> > >
> > > I ran your test script as well and that does not show much difference.
> > > I think part of the problem is that every write launches new xfs_io
> > > process. So overhead of launching process, opening fd again hides the
> > > fallocate overhead.
> >
> > It's so weird, with the below C test, I couldn't reproduce the huge
> > difference of w/ or w/o fallocate.
> >
> ext4 vs. xfs difference?

Indeed there exists a gap, but on my box it's not as much as Vivek's,

=========================
using xfs as shared dir
- w/ fallocate
$ ./a.out /mnt/test/newtest
16384 extending writes took 3 secs and 908534 us
16384 extending writes took 3 secs and 988464 us
16384 extending writes took 3 secs and 908328 us
[root@debug010000002015 virtiofs]
$ ./a.out /mnt/test/newtest
16384 extending writes took 3 secs and 523781 us
16384 extending writes took 3 secs and 474909 us
16384 extending writes took 3 secs and 524108 us
[root@debug010000002015 virtiofs]
$ ./a.out /mnt/test/newtest
16384 extending writes took 3 secs and 846989 us
16384 extending writes took 3 secs and 888489 us
16384 extending writes took 3 secs and 885019 us

- w/o fallocate
[root@debug010000002015 virtiofs]
$ ./a.out /mnt/test/newtest 
16384 extending writes took 2 secs and 317730 us
16384 extending writes took 2 secs and 336573 us
16384 extending writes took 2 secs and 398379 us
[root@debug010000002015 virtiofs]
$ ./a.out /mnt/test/newtest
16384 extending writes took 2 secs and 184630 us
16384 extending writes took 2 secs and 117942 us
16384 extending writes took 2 secs and 168083 us
[root@debug010000002015 virtiofs]
$ ./a.out /mnt/test/newtest
16384 extending writes took 2 secs and 200756 us
16384 extending writes took 2 secs and 225786 us
16384 extending writes took 2 secs and 183911 us


thanks,
-liubo

