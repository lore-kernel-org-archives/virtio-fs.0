Date: Thu, 8 Aug 2019 08:53:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20190808125320.GB3147@redhat.com>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
	<20190808095316.GC2852@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808095316.GC2852@work-vm>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Thu, Aug 08, 2019 at 10:53:16AM +0100, Dr. David Alan Gilbert wrote:
> * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> > > Kernel also serializes MAP/UNMAP on one inode. So you will need to run
> > > multiple jobs operating on different inodes to see parallel MAP/UNMAP
> > > (atleast from kernel's point of view).
> > 
> > Okay, there is still room to experiment with how MAP and UNMAP are
> > handled by virtiofsd and QEMU even if the host kernel ultimately becomes
> > the bottleneck.
> > 
> > One possible optimization is to eliminate REMOVEMAPPING requests when
> > the guest driver knows a SETUPMAPPING will follow immediately.  I see
> > the following request pattern in a fio randread iodepth=64 job:
> > 
> >   unique: 995348, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
> >   lo_setupmapping(ino=135, fi=0x(nil), foffset=3860856832, len=2097152, moffset=859832320, flags=0)
> >      unique: 995348, success, outsize: 16
> >   unique: 995350, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
> >      unique: 995350, success, outsize: 16
> >   unique: 995352, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
> >   lo_setupmapping(ino=135, fi=0x(nil), foffset=16777216, len=2097152, moffset=861929472, flags=0)
> >      unique: 995352, success, outsize: 16
> >   unique: 995354, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
> >      unique: 995354, success, outsize: 16
> >   virtio_send_msg: elem 9: with 1 in desc of length 16
> >   unique: 995356, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
> >   lo_setupmapping(ino=135, fi=0x(nil), foffset=383778816, len=2097152, moffset=864026624, flags=0)
> >      unique: 995356, success, outsize: 16
> >   unique: 995358, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
> > 
> > The REMOVEMAPPING requests are unnecessary since we can map over the top
> > of the old mapping instead of taking the extra step of removing it
> > first.
> 
> Yep, those should go - I think Vivek likes to keep them for testing
> since they make things fail more completely if there's a screwup.

I like to keep them because otherwise they keep the resources busy
on host. If DAX range is being used immediately, then this optimization
makes more sense. I will keep this in mind.

> 
> > Some more questions to consider for DAX performance optimization:
> > 
> > 1. Is FUSE_READ/FUSE_WRITE more efficient than DAX for some I/O patterns?
> 
> Probably for cases where the data is only accessed once, and you can't
> preemptively map.
> Another variant on (1) is whether we could do read/writes while the mmap
> is happening to absorb the latency.

For small random I/O, dax might not be very effective. Overhead of
setting up mapping and tearing it down is significant.

Vivek

