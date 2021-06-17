From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 17 Jun 2021 14:12:05 -0400
Message-Id: <20210617181213.1177835-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 0/8] virtiofsd: Add support to enable/disable
	posix acls
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

Hi,

This is V6 of the patches.

Changes since V5:

- Kernel patches for extended setxattr have been merged in 5.13-rc1.
  These patches have been modified to work with FUSE_SETXATTR_EXT.

Currently posix ACL support does not work well with virtiofs and bunch
of tests fail when I run xfstests "./check -g acl".

This patches series fixes the issues with virtiofs posix acl support
and provides options to enable/disable posix acl (-o posix_acl/no_posix_acl).
By default posix_acls are disabled.

With this patch series applied and virtiofsd running with "-o posix_acl",
xfstests "./check -g acl" passes.

Thanks
Vivek

Vivek Goyal (8):
  linux-headers: Update linux headers to 5.13.0-rc6
  virtiofsd: Fix fuse setxattr() API change issue
  virtiofsd: Fix xattr operations overwriting errno
  virtiofsd: Add support for extended setxattr
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Add capability to change/restore umask
  virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr
  virtiofsd: Add an option to enable/disable posix acls

 docs/tools/virtiofsd.rst                      |   3 +
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h   |  35 -
 include/standard-headers/drm/drm_fourcc.h     |  23 +-
 include/standard-headers/linux/ethtool.h      | 109 ++-
 include/standard-headers/linux/fuse.h         |  17 +-
 .../linux/input-event-codes.h                 |   1 +
 include/standard-headers/linux/input.h        |   2 +-
 include/standard-headers/linux/virtio_ids.h   |   2 +
 .../standard-headers/rdma/vmw_pvrdma-abi.h    |   7 +
 linux-headers/asm-generic/unistd.h            |  13 +-
 linux-headers/asm-mips/unistd_n32.h           | 751 +++++++--------
 linux-headers/asm-mips/unistd_n64.h           | 703 +++++++-------
 linux-headers/asm-mips/unistd_o32.h           | 843 ++++++++---------
 linux-headers/asm-powerpc/kvm.h               |   2 +
 linux-headers/asm-powerpc/unistd_32.h         | 856 +++++++++---------
 linux-headers/asm-powerpc/unistd_64.h         | 800 ++++++++--------
 linux-headers/asm-s390/unistd_32.h            |   4 +
 linux-headers/asm-s390/unistd_64.h            |   4 +
 linux-headers/asm-x86/kvm.h                   |   3 +
 linux-headers/asm-x86/unistd_32.h             |   4 +
 linux-headers/asm-x86/unistd_64.h             |   4 +
 linux-headers/asm-x86/unistd_x32.h            |   4 +
 linux-headers/linux/kvm.h                     | 131 ++-
 linux-headers/linux/userfaultfd.h             |  36 +-
 linux-headers/linux/vfio.h                    |  35 +
 tools/virtiofsd/fuse_common.h                 |  10 +
 tools/virtiofsd/fuse_lowlevel.c               |  18 +-
 tools/virtiofsd/fuse_lowlevel.h               |   3 +-
 tools/virtiofsd/helper.c                      |   1 +
 tools/virtiofsd/passthrough_ll.c              | 229 ++++-
 tools/virtiofsd/passthrough_seccomp.c         |   1 +
 31 files changed, 2592 insertions(+), 2062 deletions(-)

-- 
2.25.4

