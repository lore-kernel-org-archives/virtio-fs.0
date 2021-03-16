Date: Tue, 16 Mar 2021 19:59:59 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YFEOP+zJF4ciZ3ap@work-vm>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-17-dgilbert@redhat.com>
	<20210211141734.GQ247031@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211141734.GQ247031@stefanha-x1.localdomain>
Subject: Re: [Virtio-fs] [PATCH 16/24] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com

* Stefan Hajnoczi (stefanha@redhat.com) wrote:
> On Tue, Feb 09, 2021 at 07:02:16PM +0000, Dr. David Alan Gilbert (git) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > Define a new slave command 'VHOST_USER_SLAVE_FS_IO' for a
> > client to ask qemu to perform a read/write from an fd directly
> > to GPA.
> > 
> > Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> > ---
> >  docs/interop/vhost-user.rst               | 11 +++
> >  hw/virtio/trace-events                    |  6 ++
> >  hw/virtio/vhost-user-fs.c                 | 84 +++++++++++++++++++++++
> >  hw/virtio/vhost-user.c                    |  4 ++
> >  include/hw/virtio/vhost-user-fs.h         |  2 +
> >  subprojects/libvhost-user/libvhost-user.h |  1 +
> >  6 files changed, 108 insertions(+)
> > 
> > diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> > index 1deedd3407..821712f4a2 100644
> > --- a/docs/interop/vhost-user.rst
> > +++ b/docs/interop/vhost-user.rst
> > @@ -1452,6 +1452,17 @@ Slave message types
> >    multiple chunks can be unmapped in one command.
> >    A reply is generated indicating whether unmapping succeeded.
> >  
> > +``VHOST_USER_SLAVE_FS_IO``
> > +  :id: 9
> > +  :equivalent ioctl: N/A
> > +  :slave payload: fd + n * (offset + address + len)
> 
> Please clarify the payload representation. This is not enough for
> someone to implement the spec.

Done:
)
+  :slave payload: ``struct VhostUserFSSlaveMsg``
   :master payload: N/A
 
+  Requests that IO be performed directly from an fd, passed in ancillary
+  data, to guest memory on behalf of the daemon; this is normally for a
+  case where a memory region isn't visible to the daemon. slave payload
+  has flags which determine the direction of IO operation.
+
 
 .. 
> > +  :master payload: N/A
> > +
> > +  Requests that the QEMU performs IO directly from an fd to guest memory
> 
> To avoid naming a particular VMM:
> 
> s/the QEMU performs IO/IO be performed/
> 
> > +  on behalf of the daemon; this is normally for a case where a memory region
> > +  isn't visible to the daemon. slave payload has flags which determine
> > +  the direction of IO operation.
> 
> Please document the payload flags in the spec.


+  The ``VHOST_USER_FS_FLAG_MAP_R`` flag must be set in the ``flags`` field to
+  read from the file into RAM.
+  The ``VHOST_USER_FS_FLAG_MAP_W`` flag must be set in the ``flags`` field to
+  write to the file from RAM.

> > +
> >  .. _reply_ack:
> >  
> >  VHOST_USER_PROTOCOL_F_REPLY_ACK
> > diff --git a/hw/virtio/trace-events b/hw/virtio/trace-events
> > index c62727f879..20557a078e 100644
> > --- a/hw/virtio/trace-events
> > +++ b/hw/virtio/trace-events
> > @@ -53,6 +53,12 @@ vhost_vdpa_get_features(void *dev, uint64_t features) "dev: %p features: 0x%"PRI
> >  vhost_vdpa_set_owner(void *dev) "dev: %p"
> >  vhost_vdpa_vq_get_addr(void *dev, void *vq, uint64_t desc_user_addr, uint64_t avail_user_addr, uint64_t used_user_addr) "dev: %p vq: %p desc_user_addr: 0x%"PRIx64" avail_user_addr: 0x%"PRIx64" used_user_addr: 0x%"PRIx64
> >  
> > +# vhost-user-fs.c
> > +
> > +vhost_user_fs_slave_io_loop(const char *name, uint64_t owr, int is_ram, int is_romd, size_t size) "region %s with internal offset 0x%"PRIx64 " ram=%d romd=%d mrs.size=%zd"
> > +vhost_user_fs_slave_io_loop_res(ssize_t transferred) "%zd"
> > +vhost_user_fs_slave_io_exit(int res, size_t done) "res: %d done: %zd"
> > +
> >  # virtio.c
> >  virtqueue_alloc_element(void *elem, size_t sz, unsigned in_num, unsigned out_num) "elem %p size %zd in_num %u out_num %u"
> >  virtqueue_fill(void *vq, const void *elem, unsigned int len, unsigned int idx) "vq %p elem %p len %u idx %u"
> > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > index 5f2fca4d82..357bc1d04e 100644
> > --- a/hw/virtio/vhost-user-fs.c
> > +++ b/hw/virtio/vhost-user-fs.c
> > @@ -23,6 +23,8 @@
> >  #include "hw/virtio/vhost-user-fs.h"
> >  #include "monitor/monitor.h"
> >  #include "sysemu/sysemu.h"
> > +#include "exec/address-spaces.h"
> > +#include "trace.h"
> >  
> >  /*
> >   * The powerpc kernel code expects the memory to be accessible during
> > @@ -155,6 +157,88 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
> >      return (uint64_t)res;
> >  }
> >  
> > +uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
> > +                                int fd)
> > +{
> > +    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
> > +    if (!fs) {
> > +        /* Shouldn't happen - but seen it in error paths */
> > +        error_report("Bad fs ptr");
> > +        return (uint64_t)-1;
> > +    }
> 
> Same pointer casting issue as with map/unmap.

Done

> > +
> > +    unsigned int i;
> > +    int res = 0;
> > +    size_t done = 0;
> > +
> > +    if (fd < 0) {
> > +        error_report("Bad fd for map");
> > +        return (uint64_t)-1;
> > +    }
> > +
> > +    for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES && !res; i++) {
> > +        if (sm->len[i] == 0) {
> > +            continue;
> > +        }
> > +
> > +        size_t len = sm->len[i];
> > +        hwaddr gpa = sm->c_offset[i];
> > +
> > +        while (len && !res) {
> > +            MemoryRegionSection mrs = memory_region_find(get_system_memory(),
> > +                                                         gpa, len);
> > +            size_t mrs_size = (size_t)int128_get64(mrs.size);
> 
> If there is a vIOMMU then the vhost-user device backend should be
> restricted to just areas of guest RAM that are mapped. I think this can
> be achieved by using the vhost-user-fs device's address space instead of
> get_system_memory(). For example, virtio_pci_get_dma_as().

Written but not yet tested, as :

            bool is_write = e->flags & VHOST_USER_FS_FLAG_MAP_W;
            MemoryRegion *mr = address_space_translate(dev->vdev->dma_as, gpa,
                                                       &xlat, &xlat_len,
                                                       is_write,
                                                       MEMTXATTRS_UNSPECIFIED);

> > +
> > +            if (!mrs_size) {
> > +                error_report("No guest region found for 0x%" HWADDR_PRIx, gpa);
> > +                res = -EFAULT;
> > +                break;
> > +            }
> > +
> > +            trace_vhost_user_fs_slave_io_loop(mrs.mr->name,
> > +                                          (uint64_t)mrs.offset_within_region,
> > +                                          memory_region_is_ram(mrs.mr),
> > +                                          memory_region_is_romd(mrs.mr),
> > +                                          (size_t)mrs_size);
> > +
> > +            void *hostptr = qemu_map_ram_ptr(mrs.mr->ram_block,
> > +                                             mrs.offset_within_region);
> > +            ssize_t transferred;
> > +            if (sm->flags[i] & VHOST_USER_FS_FLAG_MAP_R) {
> 
> The flag name is specific to map requests but it's shared with the IO
> request. Perhaps rename the flags?

They're both read/write's; do you have a preferred alternative?

> > +                /* Read from file into RAM */
> > +                if (mrs.mr->readonly) {
> > +                    res = -EFAULT;
> > +                    break;
> > +                }
> > +                transferred = pread(fd, hostptr, mrs_size, sm->fd_offset[i]);
> > +            } else {
> > +                /* Write into file from RAM */
> > +                assert((sm->flags[i] & VHOST_USER_FS_FLAG_MAP_W));
> 
> The vhost-user device backend must not be able to crash the VMM. Please
> use an if statement and fail the request if the flags are invalid
> instead of assert().

Done

> > +                transferred = pwrite(fd, hostptr, mrs_size, sm->fd_offset[i]);
> > +            }
> > +            trace_vhost_user_fs_slave_io_loop_res(transferred);
> > +            if (transferred < 0) {
> > +                res = -errno;
> > +                break;
> > +            }
> > +            if (!transferred) {
> > +                /* EOF */
> > +                break;
> > +            }
> > +
> > +            done += transferred;
> > +            len -= transferred;
> 
> Is gpa += transferred missing so that this loop can handle crossing
> MemoryRegion boundaries?
> 
> sm->fd_offset[i] also needs to be put into a local variable and
> incremented by transferred each time around the loop.

Hmm yes, both of those are right; this obviously needs more testing,
especially across boundaries.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

