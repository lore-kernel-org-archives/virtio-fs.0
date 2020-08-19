From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 19 Aug 2020 18:19:38 -0400
Message-Id: <20200819221956.845195-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 00/18] virtiofs: Add DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com
Cc: Jan Kara <jack@suse.cz>, miklos@szeredi.hu, Vishal L Verma <vishal.l.verma@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, dan.j.williams@intel.com, Ira Weiny <ira.weiny@intel.com>, vgoyal@redhat.com

Hi All,

This is V3 of patches. I had posted version v2 version here.

https://lore.kernel.org/linux-fsdevel/20200807195526.426056-1-vgoyal@redhat.com/

I have taken care of comments from V2. Changes from V2 are.

- Rebased patches on top of 5.9-rc1

- Renamed couple of functions to get rid of iomap prefix. (Dave Chinner)

- Modified truncate/punch_hole paths to serialize with dax fault
  path. For now did this only for dax paths. May be non-dax path
  can benefit from this too. But that is an option for a different
  day. (Dave Chinner).

- Took care of comments by Jan Kara in dax_layout_busy_page_range()
  implementation patch.

- Dropped one of the patches which forced sync release in
  fuse_file_put() path for DAX files. It was redundant now as virtiofs
  already sets fs_context->destroy which forces sync release. (Miklos)

- Took care of some of the errors flagged by checkpatch.pl.

Description from previous post
------------------------------

This patch series adds DAX support to virtiofs filesystem. This allows
bypassing guest page cache and allows mapping host page cache directly
in guest address space.

When a page of file is needed, guest sends a request to map that page
(in host page cache) in qemu address space. Inside guest this is
a physical memory range controlled by virtiofs device. And guest
directly maps this physical address range using DAX and hence gets
access to file data on host.

This can speed up things considerably in many situations. Also this
can result in substantial memory savings as file data does not have
to be copied in guest and it is directly accessed from host page
cache.

Most of the changes are limited to fuse/virtiofs. There are couple
of changes needed in generic dax infrastructure and couple of changes
in virtio to be able to access shared memory region.

Thanks
Vivek

Sebastien Boeuf (3):
  virtio: Add get_shm_region method
  virtio: Implement get_shm_region for PCI transport
  virtio: Implement get_shm_region for MMIO transport

Stefan Hajnoczi (2):
  virtio_fs, dax: Set up virtio_fs dax_device
  fuse,dax: add DAX mmap support

Vivek Goyal (13):
  dax: Modify bdev_dax_pgoff() to handle NULL bdev
  dax: Create a range version of dax_layout_busy_page()
  virtiofs: Provide a helper function for virtqueue initialization
  fuse: Get rid of no_mount_options
  fuse,virtiofs: Add a mount option to enable dax
  fuse,virtiofs: Keep a list of free dax memory ranges
  fuse: implement FUSE_INIT map_alignment field
  fuse: Introduce setupmapping/removemapping commands
  fuse, dax: Implement dax read/write operations
  fuse,virtiofs: Define dax address space operations
  fuse, dax: Serialize truncate/punch_hole and dax fault path
  fuse,virtiofs: Maintain a list of busy elements
  fuse,virtiofs: Add logic to free up a memory range

 drivers/dax/super.c                |    3 +-
 drivers/virtio/virtio_mmio.c       |   31 +
 drivers/virtio/virtio_pci_modern.c |   95 +++
 fs/dax.c                           |   29 +-
 fs/fuse/dir.c                      |   32 +-
 fs/fuse/file.c                     | 1198 +++++++++++++++++++++++++++-
 fs/fuse/fuse_i.h                   |  114 ++-
 fs/fuse/inode.c                    |  146 +++-
 fs/fuse/virtio_fs.c                |  279 ++++++-
 include/linux/dax.h                |    6 +
 include/linux/virtio_config.h      |   17 +
 include/uapi/linux/fuse.h          |   34 +-
 include/uapi/linux/virtio_fs.h     |    3 +
 include/uapi/linux/virtio_mmio.h   |   11 +
 include/uapi/linux/virtio_pci.h    |   11 +-
 15 files changed, 1933 insertions(+), 76 deletions(-)

Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vishal L Verma <vishal.l.verma@intel.com>
-- 
2.25.4

