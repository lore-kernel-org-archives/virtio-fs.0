Date: Mon, 20 May 2019 20:01:03 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20190520190103.GK2726@work-vm>
References: <20190416190858.16833-4-bo.liu@linux.alibaba.com>
	<20190417145121.GG2839@work-vm>
	<20190423120919.GG32465@stefanha-x1.localdomain>
	<20190423184915.pkqbggfrbazz4bfd@US-160370MP2.local>
	<20190425143323.GC17806@stefanha-x1.localdomain>
	<20190425212158.GA32135@redhat.com>
	<20190426090524.GB1249@stefanha-x1.localdomain>
	<20190518022821.zjumw623xot2ejgt@US-160370MP2.local>
	<20190520134934.GB28008@redhat.com>
	<20190520183357.ffniox6gve3of4gw@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520183357.ffniox6gve3of4gw@US-160370MP2.local>
Subject: Re: [Virtio-fs] [PATCH 3/4] virtiofsd: use file-backend memory
 region for virtiofsd's cache area
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

* Liu Bo (bo.liu@linux.alibaba.com) wrote:
> On Mon, May 20, 2019 at 09:49:34AM -0400, Vivek Goyal wrote:
> > On Fri, May 17, 2019 at 07:28:22PM -0700, Liu Bo wrote:
> > 
> > [..]
> > > > > > > > That case happened with cache=none and the dax mount option.
> > > > > > > > 
> > > > > > > > The general problem is when FUSE_READ/FUSE_WRITE is sent and the buffer
> > > > > > > > is outside guest RAM.
> > > > > 
> > > > > Stefan,
> > > > > 
> > > > > Can this be emulated by sending a request to qemu? If virtiofsd can detect
> > > > > that source/destination of READ/WRITE is not guest RAM, can it forward
> > > > > message to qemu to do this operation (which has access to all the DAX
> > > > > windows)?
> > > > > 
> > > > > This probably will mean introducing new messages like
> > > > > setupmapping/removemapping messages between virtiofsd/qemu.  
> > > > 
> > > > Yes, interesting idea!
> > > > 
> > > > When virtiofsd is unable to map the virtqueue iovecs due to addresses
> > > > outside guest RAM, it could forward READ/WRITE requests to QEMU along
> > > > with the file descriptor.  It would be slow but fixes the problem.
> > > >
> > > 
> > > It is probably not easy to do.
> > > 
> > > Imagine the following case,
> > > // foo1 is on a dax virtiofs, foo2 is on a nondax virtiofs
> > > 
> > > p = mmap(foo1, ...);
> > > write(foo2, p, ...);
> > > 
> > > virtiofsd where foo2 is using needs to interpret gpa from virtiofs
> > > where foo1 exists along with fd being foo1, but a write fuse_req
> > > doesn't have foo1's fd.
> > > 
> > > And are you suggesting that qemu goes to read the data on gpa and
> > > returns via vhost-user message?  or let this virtiofsd (foo2) do mmap
> > > on foo1 directly?
> > 
> > Hi Liu Bo,
> > 
> > Not sure I understand the question. Assuming foo2 virtiofs instances
> > is mounted with cache=none, write(foo2), will trigger FUSE_WRITE
> > request to daemon with source address being in dax window of first
> > virtiofs instance. 
> > 
> > This request should be forwarded to qemu which can just read from
> > foo1 mmaped area in qemu address space and write to foo2. I am assuming
> > before FUSE_WRITE comes in, mapping for foo1 has already been
> > establied.
> 
> Bofore sending any message to qemu, fv_queue_thread() will fail at
> vu_queue_pop()->vu_queue_map_desc()->virtqueue_map_desc()->vu_gpa_to_va(),
> because virtiofsd (where foo2 is on) doesn't have the information of
> foo1's mapping within its address space.

The trick is to bounce the problem back to qemu; as soon as the mapping
fails I add a flag to say the mapping failed; then that causes the
request to be sent to qemu via a slave command - and qemu has all of
the mappings so can read/write to all of the fs's.

Dave

> It could be reproduced by fstests/generic/413.
> 
> thanks,
> -liubo
> 
> > 
> > IOW, foo1 is already mmaped in qemu address space so there is no
> > need to pass fd of foo1 in FUSE_WRITE(foo2) request. Did I miss
> > something?
> > 
> > Vivek
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

