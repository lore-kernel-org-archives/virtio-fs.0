From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  8 Feb 2022 15:48:03 -0500
Message-Id: <20220208204813.682906-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 00/10] virtiofsd: Add support for file
	security context at file creation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: berrange@redhat.com, vgoyal@redhat.com

Hi,

This is V6 of the patches. I posted V5 here.

https://listman.redhat.com/archives/virtio-fs/2022-February/msg00012.html

This patch series basically allows client to send a security context 
(which is expected to be xattr security.selinux and its content) to
virtiofsd and it will set that security context on file during creation
based on various settings. Hence, this patch series basically allows
supporting SELinux with virtiofs.

There are primarily 3 modes.

- If no security context enabled, then it continues to create files without
  security context.

- If security context is enabled and but security.selinux has not been
  remapped, then it uses /proc/thread-self/attr/fscreate knob to set
  security context and then create the file. This will make sure that
  newly created file gets the security context as set in "fscreate" and
  this is atomic w.r.t file creation.

  This is useful and host and guest SELinux policies don't conflict and
  can work with each other. In that case, guest security.selinux xattr
  is not remapped and it is passthrough as "security.selinux" xattr
  on host.

- If security context is enabled but security.selinux xattr has been
  remapped to something else, then it first creates the file and then
  uses setxattr() to set the remapped xattr with the security context.
  This is a non-atomic operation w.r.t file creation.

  This mode will be most versatile and allow host and guest to have their
  own separate SELinux xattrs and have their own separate SELinux policies.

Changes since V5:

- Added some documentation to recommend using xattr remapping to remap
  "security.selinux" to "trusted.virtiofs.security.selinux" and also 
  give CAP_SYS_ADMIN to daemon. Also put a warning to make users aware
  of trade-off involved here. ("Daniel P. Berrangé")

- Used macro endof() to determine end of fuse_init_in struct. (David
  Gilbert).

- Added a check to make sure fsecctx->size is not zero. Also added
  "return" statement at few places where it was required. (David Gilbert)

- Split patch 7 in the series. Some of the handling of setting and
  clearing fscreate knob has been moved into a separate patch. Found
  it hard to break it down further. So it helps a bit but not too
  much. (David Gilbert).

Thanks
Vivek

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

 docs/tools/virtiofsd.rst                      |  32 ++
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     |  11 +
 include/standard-headers/linux/ethtool.h      |   1 +
 include/standard-headers/linux/fuse.h         |  60 ++-
 include/standard-headers/linux/pci_regs.h     | 142 +++---
 include/standard-headers/linux/virtio_gpio.h  |  72 +++
 include/standard-headers/linux/virtio_i2c.h   |  47 ++
 include/standard-headers/linux/virtio_iommu.h |   8 +-
 .../standard-headers/linux/virtio_pcidev.h    |  65 +++
 include/standard-headers/linux/virtio_scmi.h  |  24 +
 linux-headers/asm-generic/unistd.h            |   5 +-
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-riscv/bitsperlong.h         |  14 +
 linux-headers/asm-riscv/mman.h                |   1 +
 linux-headers/asm-riscv/unistd.h              |  44 ++
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/kvm.h                   |  16 +-
 linux-headers/asm-x86/unistd_32.h             |   1 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/kvm.h                     |  17 +
 tools/virtiofsd/fuse_common.h                 |   9 +-
 tools/virtiofsd/fuse_i.h                      |   7 +
 tools/virtiofsd/fuse_lowlevel.c               | 168 +++++--
 tools/virtiofsd/helper.c                      |   1 +
 tools/virtiofsd/passthrough_ll.c              | 414 ++++++++++++++++--
 32 files changed, 1044 insertions(+), 132 deletions(-)
 create mode 100644 include/standard-headers/linux/virtio_gpio.h
 create mode 100644 include/standard-headers/linux/virtio_i2c.h
 create mode 100644 include/standard-headers/linux/virtio_pcidev.h
 create mode 100644 include/standard-headers/linux/virtio_scmi.h
 create mode 100644 linux-headers/asm-riscv/bitsperlong.h
 create mode 100644 linux-headers/asm-riscv/mman.h
 create mode 100644 linux-headers/asm-riscv/unistd.h

-- 
2.34.1

