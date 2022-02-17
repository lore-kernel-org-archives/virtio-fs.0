From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu, 17 Feb 2022 14:23:50 +0000
Message-Id: <20220217142402.52819-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 00/12] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, groug@kaod.org, sebastian.hasler@stuvus.uni-stuttgart.de
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit c13b8e9973635f34f3ce4356af27a311c993729c:

  Merge remote-tracking branch 'remotes/alistair/tags/pull-riscv-to-apply-20220216' into staging (2022-02-16 09:57:11 +0000)

are available in the Git repository at:

  https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20220217

for you to fetch changes up to e138ec4ac86ea71d10ecd032edc433290776a5f2:

  virtiofsd: Add basic support for FUSE_SYNCFS request (2022-02-17 13:35:55 +0000)

----------------------------------------------------------------
V2: virtiofs pull 2022-02-17

Security label improvements from Vivek
  - includes a fix for building against new kernel headers
  [V2: Fix building on old Linux]
Blocking flock disable from Sebastian
SYNCFS support from Greg

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>

----------------------------------------------------------------
Greg Kurz (1):
      virtiofsd: Add basic support for FUSE_SYNCFS request

Sebastian Hasler (1):
      virtiofsd: Do not support blocking flock

Vivek Goyal (10):
      virtiofsd: Fix breakage due to fuse_init_in size change
      linux-headers: Update headers to v5.17-rc1
      virtiofsd: Parse extended "struct fuse_init_in"
      virtiofsd: Extend size of fuse_conn_info->capable and ->want fields
      virtiofsd, fuse_lowlevel.c: Add capability to parse security context
      virtiofsd: Move core file creation code in separate function
      virtiofsd: Add helpers to work with /proc/self/task/tid/attr/fscreate
      virtiofsd: Create new file with security context
      virtiofsd: Create new file using O_TMPFILE and set security context
      virtiofsd: Add an option to enable/disable security label

 docs/tools/virtiofsd.rst                       |  32 ++
 include/standard-headers/asm-x86/kvm_para.h    |   1 +
 include/standard-headers/drm/drm_fourcc.h      |  11 +
 include/standard-headers/linux/ethtool.h       |   1 +
 include/standard-headers/linux/fuse.h          |  60 +++-
 include/standard-headers/linux/pci_regs.h      | 142 ++++----
 include/standard-headers/linux/virtio_gpio.h   |  72 ++++
 include/standard-headers/linux/virtio_i2c.h    |  47 +++
 include/standard-headers/linux/virtio_iommu.h  |   8 +-
 include/standard-headers/linux/virtio_pcidev.h |  65 ++++
 include/standard-headers/linux/virtio_scmi.h   |  24 ++
 linux-headers/asm-generic/unistd.h             |   5 +-
 linux-headers/asm-mips/unistd_n32.h            |   2 +
 linux-headers/asm-mips/unistd_n64.h            |   2 +
 linux-headers/asm-mips/unistd_o32.h            |   2 +
 linux-headers/asm-powerpc/unistd_32.h          |   2 +
 linux-headers/asm-powerpc/unistd_64.h          |   2 +
 linux-headers/asm-riscv/bitsperlong.h          |  14 +
 linux-headers/asm-riscv/mman.h                 |   1 +
 linux-headers/asm-riscv/unistd.h               |  44 +++
 linux-headers/asm-s390/unistd_32.h             |   2 +
 linux-headers/asm-s390/unistd_64.h             |   2 +
 linux-headers/asm-x86/kvm.h                    |  16 +-
 linux-headers/asm-x86/unistd_32.h              |   1 +
 linux-headers/asm-x86/unistd_64.h              |   1 +
 linux-headers/asm-x86/unistd_x32.h             |   1 +
 linux-headers/linux/kvm.h                      |  17 +
 tools/virtiofsd/fuse_common.h                  |   9 +-
 tools/virtiofsd/fuse_i.h                       |   7 +
 tools/virtiofsd/fuse_lowlevel.c                | 179 ++++++++--
 tools/virtiofsd/fuse_lowlevel.h                |  13 +
 tools/virtiofsd/helper.c                       |   1 +
 tools/virtiofsd/passthrough_ll.c               | 467 +++++++++++++++++++++++--
 tools/virtiofsd/passthrough_seccomp.c          |   1 +
 34 files changed, 1122 insertions(+), 132 deletions(-)
 create mode 100644 include/standard-headers/linux/virtio_gpio.h
 create mode 100644 include/standard-headers/linux/virtio_i2c.h
 create mode 100644 include/standard-headers/linux/virtio_pcidev.h
 create mode 100644 include/standard-headers/linux/virtio_scmi.h
 create mode 100644 linux-headers/asm-riscv/bitsperlong.h
 create mode 100644 linux-headers/asm-riscv/mman.h
 create mode 100644 linux-headers/asm-riscv/unistd.h

