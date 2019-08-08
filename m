Date: Thu, 8 Aug 2019 10:53:16 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190808095316.GC2852@work-vm>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808090213.GD31476@stefanha-x1.localdomain>
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> > Kernel also serializes MAP/UNMAP on one inode. So you will need to run
> > multiple jobs operating on different inodes to see parallel MAP/UNMAP
> > (atleast from kernel's point of view).
> 
> Okay, there is still room to experiment with how MAP and UNMAP are
> handled by virtiofsd and QEMU even if the host kernel ultimately becomes
> the bottleneck.
> 
> One possible optimization is to eliminate REMOVEMAPPING requests when
> the guest driver knows a SETUPMAPPING will follow immediately.  I see
> the following request pattern in a fio randread iodepth=64 job:
> 
>   unique: 995348, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
>   lo_setupmapping(ino=135, fi=0x(nil), foffset=3860856832, len=2097152, moffset=859832320, flags=0)
>      unique: 995348, success, outsize: 16
>   unique: 995350, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
>      unique: 995350, success, outsize: 16
>   unique: 995352, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
>   lo_setupmapping(ino=135, fi=0x(nil), foffset=16777216, len=2097152, moffset=861929472, flags=0)
>      unique: 995352, success, outsize: 16
>   unique: 995354, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
>      unique: 995354, success, outsize: 16
>   virtio_send_msg: elem 9: with 1 in desc of length 16
>   unique: 995356, opcode: SETUPMAPPING (48), nodeid: 135, insize: 80, pid: 1351
>   lo_setupmapping(ino=135, fi=0x(nil), foffset=383778816, len=2097152, moffset=864026624, flags=0)
>      unique: 995356, success, outsize: 16
>   unique: 995358, opcode: REMOVEMAPPING (49), nodeid: 135, insize: 60, pid: 12
> 
> The REMOVEMAPPING requests are unnecessary since we can map over the top
> of the old mapping instead of taking the extra step of removing it
> first.

Yep, those should go - I think Vivek likes to keep them for testing
since they make things fail more completely if there's a screwup.

> Some more questions to consider for DAX performance optimization:
> 
> 1. Is FUSE_READ/FUSE_WRITE more efficient than DAX for some I/O patterns?

Probably for cases where the data is only accessed once, and you can't
preemptively map.
Another variant on (1) is whether we could do read/writes while the mmap
is happening to absorb the latency.

> 2. Can MAP/UNMAP be performed directly in QEMU via a separate virtqueue?

I think there's two things to solve here that I don't currently know the
answer to:
  2a) We'd need to get the fd to qemu for the thing to mmap;
      we might be able to cache the fd on the qemu side for existing
      mappings, so when asking for a new mapping for an existing file then
      it would already have the fd.

  2b) Running a device with a mix of queues inside QEMU and on
      vhost-user; I don't think we have anything with that mix
 
> 3. Can READ/WRITE be performed directly in QEMU via a separate virtqueue
>    to eliminate the bad address problem?

Are you thinking of doing all read/writes that way, or just the corner
cases? It doesn't seem worth it for the corner cases unless you're
finding them cropping up in real work loads.

> 4. Can OPEN+MAP be fused into a single request for small files, avoiding
>    the 2nd request?

Sounds possible.

> I'm not going to tackle DAX optimization myself right now but wanted to
> share these ideas.

One I was thinking about that feels easier than (2) was to change the
vhost slave protocol to be split transaction; it wouldn't do anything
for the latency but it would be able to do some in parallel if we can
get the kernel to feed it.

Dave

> Stefan



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

