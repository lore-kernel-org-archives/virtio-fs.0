From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:00 +0000
Message-Id: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 00/24] virtiofs dax patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Hi,
  This series adds support for acceleration of virtiofs via DAX
mapping, using features added in the 5.11 Linux kernel.

  DAX originally existed in the kernel for mapping real storage
devices directly into memory, so that reads/writes turn into
reads/writes directly mapped into the storage device.

  virtiofs's DAX support is similar; a PCI BAR is exposed on the
virtiofs device corresponding to a DAX 'cache' of a user defined size.
The guest daemon then requests files to be mapped into that cache;
when that happens the virtiofsd sends filedescriptors and commands back
to the QEMU that mmap's those files directly into the memory slot
exposed to kvm.  The guest can then directly read/write to the files
exposed by virtiofs by reading/writing into the BAR.

  A typical invocation would be:
     -device vhost-user-fs-pci,queue-size=1024,chardev=char0,tag=myfs,cache-size=4G 

and then the guest must mount with -o mount.

  Note that the cache doesn't really take VM up on the host, because
everything placed there is just an mmap of a file, so you can afford
to use quite a large cache size.

  Unlike a real DAX device, the cache is a finite size that's
potentially smaller than the underlying filesystem (especially when
mapping granuality is taken into account).  Mapping, unmapping and
remapping must take place to juggle files into the cache if it's too
small.  Some workloads benefit more than others.

Gotchas:
  a) The vhost-user slave channel has some bad reset behaviours;
these are fixed by Vivek's '[RFC PATCH 0/6] vhost-user: Shutdown/Flush
slave channel properly' that are on the list.

  b) If something else on the host truncates an mmap'd file,
kvm gets rather upset;  for this reason it's advised that DAX is
currently only suitable for use on non-shared filesystems.

Thanks a lot to Vivek who has spent a lot of time on the kernel side
and cleaning this series up.

Dave

Dr. David Alan Gilbert (19):
  DAX: vhost-user: Rework slave return values
  DAX: libvhost-user: Route slave message payload
  DAX: libvhost-user: Allow popping a queue element with bad pointers
  DAX subprojects/libvhost-user: Add virtio-fs slave types
  DAX: virtio: Add shared memory capability
  DAX: virtio-fs: Add cache BAR
  DAX: virtio-fs: Add vhost-user slave commands for mapping
  DAX: virtio-fs: Fill in slave commands for mapping
  DAX: virtiofsd Add cache accessor functions
  DAX: virtiofsd: Add setup/remove mappings fuse commands
  DAX: virtiofsd: Add setup/remove mapping handlers to passthrough_ll
  DAX: virtiofsd: Wire up passthrough_ll's lo_setupmapping
  DAX: virtiofsd: route se down to destroy method
  DAX: virtiofsd: Perform an unmap on destroy
  DAX/unmap: virtiofsd: Add VHOST_USER_SLAVE_FS_IO
  DAX/unmap virtiofsd: Add wrappers for VHOST_USER_SLAVE_FS_IO
  DAX/unmap virtiofsd: Parse unmappable elements
  DAX/unmap virtiofsd: Route unmappable reads
  DAX/unmap virtiofsd: route unmappable write to slave command

Stefan Hajnoczi (1):
  DAX:virtiofsd: implement FUSE_INIT map_alignment field

Vivek Goyal (4):
  DAX: virtiofsd: Make lo_removemapping() work
  vhost-user-fs: Extend VhostUserFSSlaveMsg to pass additional info
  vhost-user-fs: Implement drop CAP_FSETID functionality
  virtiofsd: Ask qemu to drop CAP_FSETID if client asked for it

 block/export/vhost-user-blk-server.c      |   2 +-
 contrib/vhost-user-blk/vhost-user-blk.c   |   3 +-
 contrib/vhost-user-gpu/vhost-user-gpu.c   |   5 +-
 contrib/vhost-user-input/main.c           |   4 +-
 contrib/vhost-user-scsi/vhost-user-scsi.c |   2 +-
 docs/interop/vhost-user.rst               |  31 ++
 hw/virtio/meson.build                     |   1 +
 hw/virtio/trace-events                    |   6 +
 hw/virtio/vhost-backend.c                 |   4 +-
 hw/virtio/vhost-user-fs-pci.c             |  25 ++
 hw/virtio/vhost-user-fs.c                 | 330 ++++++++++++++++++++++
 hw/virtio/vhost-user.c                    |  50 +++-
 hw/virtio/virtio-pci.c                    |  20 ++
 hw/virtio/virtio-pci.h                    |   4 +
 include/hw/virtio/vhost-backend.h         |   2 +-
 include/hw/virtio/vhost-user-fs.h         |  34 +++
 meson.build                               |   6 +
 subprojects/libvhost-user/libvhost-user.c | 106 ++++++-
 subprojects/libvhost-user/libvhost-user.h |  48 +++-
 tests/vhost-user-bridge.c                 |   4 +-
 tools/virtiofsd/buffer.c                  |  22 +-
 tools/virtiofsd/fuse_common.h             |  17 +-
 tools/virtiofsd/fuse_lowlevel.c           |  91 +++++-
 tools/virtiofsd/fuse_lowlevel.h           |  78 ++++-
 tools/virtiofsd/fuse_virtio.c             | 282 ++++++++++++++----
 tools/virtiofsd/passthrough_ll.c          | 103 ++++++-
 26 files changed, 1166 insertions(+), 114 deletions(-)

-- 
2.29.2

