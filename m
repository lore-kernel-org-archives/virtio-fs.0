From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:57:01 -0400
Message-Id: <20190821175720.25901-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 00/19][RFC] virtio-fs: Enable DAX support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

Hi,

This patch series enables DAX support for virtio-fs filesystem. Patches
are based on 5.3-rc5 kernel and need first patch series posted for
virtio-fs support with subject "virtio-fs: shared file system for virtual
machines".

https://www.redhat.com/archives/virtio-fs/2019-August/msg00281.html

Enabling DAX seems to improve performance for most of the operations
in general a great deal. I have reported performance numbers in first patch
series so I am not repeating these here.

Any comments or feedback is welcome.

Thanks
Vivek

Sebastien Boeuf (3):
  virtio: Add get_shm_region method
  virtio: Implement get_shm_region for PCI transport
  virtio: Implement get_shm_region for MMIO transport

Stefan Hajnoczi (4):
  dax: remove block device dependencies
  fuse, dax: add fuse_conn->dax_dev field
  virtio_fs, dax: Set up virtio_fs dax_device
  fuse, dax: add DAX mmap support

Vivek Goyal (12):
  dax: Pass dax_dev to dax_writeback_mapping_range()
  fuse: Keep a list of free dax memory ranges
  fuse: implement FUSE_INIT map_alignment field
  fuse: Introduce setupmapping/removemapping commands
  fuse, dax: Implement dax read/write operations
  fuse: Define dax address space operations
  fuse, dax: Take ->i_mmap_sem lock during dax page fault
  fuse: Maintain a list of busy elements
  dax: Create a range version of dax_layout_busy_page()
  fuse: Add logic to free up a memory range
  fuse: Release file in process context
  fuse: Take inode lock for dax inode truncation

 drivers/dax/super.c                |    3 +-
 drivers/virtio/virtio_mmio.c       |   32 +
 drivers/virtio/virtio_pci_modern.c |  108 +++
 fs/dax.c                           |   89 +-
 fs/ext2/inode.c                    |    2 +-
 fs/ext4/inode.c                    |    2 +-
 fs/fuse/cuse.c                     |    3 +-
 fs/fuse/dir.c                      |    2 +
 fs/fuse/file.c                     | 1206 +++++++++++++++++++++++++++-
 fs/fuse/fuse_i.h                   |   99 ++-
 fs/fuse/inode.c                    |  138 +++-
 fs/fuse/virtio_fs.c                |  134 +++-
 fs/xfs/xfs_aops.c                  |    2 +-
 include/linux/dax.h                |   12 +-
 include/linux/virtio_config.h      |   17 +
 include/uapi/linux/fuse.h          |   47 +-
 include/uapi/linux/virtio_fs.h     |    3 +
 include/uapi/linux/virtio_mmio.h   |   11 +
 include/uapi/linux/virtio_pci.h    |   11 +-
 19 files changed, 1868 insertions(+), 53 deletions(-)

-- 
2.20.1

