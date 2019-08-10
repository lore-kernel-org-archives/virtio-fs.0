Date: Sat, 10 Aug 2019 14:34:00 -0700
From: Liu Bo <bo.liu@linux.alibaba.com>
Message-ID: <20190810213400.rpzxazwfrbxxkneq@US-160370MP2.local>
References: <20190801165409.20121-1-stefanha@redhat.com>
	<20190807180355.GA22758@stefanha-x1.localdomain>
	<20190807205715.GE18557@redhat.com>
	<20190808090213.GD31476@stefanha-x1.localdomain>
	<20190808095316.GC2852@work-vm>
	<20190809082102.GB25286@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809082102.GB25286@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 0/4] virtiofsd: multithreading preparation
 part 3
Reply-To: bo.liu@linux.alibaba.com
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>, qemu-devel@nongnu.org

On Fri, Aug 09, 2019 at 09:21:02AM +0100, Stefan Hajnoczi wrote:
> On Thu, Aug 08, 2019 at 10:53:16AM +0100, Dr. David Alan Gilbert wrote:
> > * Stefan Hajnoczi (stefanha@redhat.com) wrote:
> > > On Wed, Aug 07, 2019 at 04:57:15PM -0400, Vivek Goyal wrote:
> > > 2. Can MAP/UNMAP be performed directly in QEMU via a separate virtqueue?
> > 
> > I think there's two things to solve here that I don't currently know the
> > answer to:
> >   2a) We'd need to get the fd to qemu for the thing to mmap;
> >       we might be able to cache the fd on the qemu side for existing
> >       mappings, so when asking for a new mapping for an existing file then
> >       it would already have the fd.
> > 
> >   2b) Running a device with a mix of queues inside QEMU and on
> >       vhost-user; I don't think we have anything with that mix
> 
> vhost-user-net works in the same way.  The ctrl queue is handled by QEMU
> and the rx/tx queues by the vhost device.  This is in fact how vhost was
> initially designed: the vhost device is not a full virtio device, only
> the dataplane.

> > > 3. Can READ/WRITE be performed directly in QEMU via a separate virtqueue
> > >    to eliminate the bad address problem?
> > 
> > Are you thinking of doing all read/writes that way, or just the corner
> > cases? It doesn't seem worth it for the corner cases unless you're
> > finding them cropping up in real work loads.
> 
> Send all READ/WRITE requests to QEMU instead of virtiofsd.
> 
> Only handle metadata requests in virtiofsd (OPEN, RELEASE, READDIR,
> MKDIR, etc).

For now qemu is not aware of virtio-fs's fd info, but I think it's
doable, I like the idea.

thanks,
-liubo
> 
> > > I'm not going to tackle DAX optimization myself right now but wanted to
> > > share these ideas.
> > 
> > One I was thinking about that feels easier than (2) was to change the
> > vhost slave protocol to be split transaction; it wouldn't do anything
> > for the latency but it would be able to do some in parallel if we can
> > get the kernel to feed it.
> 
> There are two cases:
> 1. mmapping multiple inode.  This should benefit from parallelism,
>    although mmap is still expensive because it involves TLB shootdown
>    for all other threads running this process.
> 2. mmapping the same inode.  Here the host kernel is likely to serialize
>    mmaps even more, making it hard to gain performance.
> 
> It's probably worth writing a tiny benchmark first to evaluate the
> potential gains.
> 
> Stefan



> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

