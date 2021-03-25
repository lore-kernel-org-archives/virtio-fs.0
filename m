From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 25 Mar 2021 11:38:47 -0400
Message-Id: <20210325153852.572927-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 0/5] virtiofsd: Add support to enable/disable
	posix acls
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Hi,

This is V5 of the patches.

Changes since V4:

- Added support to clear SGID while setting posix access acl. fuse
  client sends this information in a flag in SETXATTR message. This
  also requires opting in for using SETXATTR V2.

These patches have dependency on fuse kernel patches. So kernel patches
need to be get merged first.

https://lore.kernel.org/linux-fsdevel/20210325151823.572089-1-vgoyal@redhat.com/

Posting patches anyway, so that patches can get reviewed and tested.

Thanks
Vivek
 
Vivek Goyal (5):
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Add capability to change/restore umask
  virtiofsd: Add an option to enable/disable posix acls
  virtiofsd: Add support for setxattr_v2
  virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr

 docs/tools/virtiofsd.rst              |   3 +
 include/standard-headers/linux/fuse.h |  19 ++-
 tools/virtiofsd/fuse_common.h         |   6 +
 tools/virtiofsd/fuse_lowlevel.c       |  42 ++++++-
 tools/virtiofsd/fuse_lowlevel.h       |   3 +-
 tools/virtiofsd/helper.c              |   1 +
 tools/virtiofsd/passthrough_ll.c      | 166 ++++++++++++++++++++++++--
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 8 files changed, 230 insertions(+), 11 deletions(-)

-- 
2.25.4

