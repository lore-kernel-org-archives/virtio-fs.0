From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:34 +0100
Message-Id: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 00/26] virtiofs dax patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

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

and then the guest must mount with -o dax

  Note that the cache doesn't really take VM up on the host, because
everything placed there is just an mmap of a file, so you can afford
to use quite a large cache size.

  Unlike a real DAX device, the cache is a finite size that's
potentially smaller than the underlying filesystem (especially when
mapping granuality is taken into account).  Mapping, unmapping and
remapping must take place to juggle files into the cache if it's too
small.  Some workloads benefit more than others.

Gotchas:
  a) If something else on the host truncates an mmap'd file,
kvm gets rather upset;  for this reason it's advised that DAX is
currently only suitable for use on non-shared filesystems.

(This series, with a couple of other patches, is at:
https://gitlab.com/virtio-fs/qemu/-/tree/dgilbert-dax-2021-04-28 )

Dave

v3
  Review cleanups
  Fix some printf formating issues

Dr. David Alan Gilbert (21):
  virtiofs: Fixup printf args
  virtiofsd: Don't assume header layout
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
 docs/interop/vhost-user.rst               |  37 ++
 hw/virtio/meson.build                     |   1 +
 hw/virtio/trace-events                    |   6 +
 hw/virtio/vhost-backend.c                 |   6 +-
 hw/virtio/vhost-user-fs-pci.c             |  32 ++
 hw/virtio/vhost-user-fs.c                 | 395 ++++++++++++++++++++++
 hw/virtio/vhost-user.c                    |  62 +++-
 hw/virtio/virtio-pci.c                    |  20 ++
 hw/virtio/virtio-pci.h                    |   4 +
 include/hw/virtio/vhost-backend.h         |   2 +-
 include/hw/virtio/vhost-user-fs.h         |  43 +++
 meson.build                               |   6 +
 subprojects/libvhost-user/libvhost-user.c | 113 ++++++-
 subprojects/libvhost-user/libvhost-user.h |  57 +++-
 tests/vhost-user-bridge.c                 |   4 +-
 tools/virtiofsd/buffer.c                  |  22 +-
 tools/virtiofsd/fuse_common.h             |  17 +-
 tools/virtiofsd/fuse_lowlevel.c           |  92 ++++-
 tools/virtiofsd/fuse_lowlevel.h           |  78 ++++-
 tools/virtiofsd/fuse_virtio.c             | 372 ++++++++++++++++----
 tools/virtiofsd/passthrough_ll.c          | 138 +++++++-
 26 files changed, 1393 insertions(+), 130 deletions(-)

-- 
2.31.1

