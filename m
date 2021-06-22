From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 22 Jun 2021 11:08:45 -0400
Message-Id: <20210622150852.1507204-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v7 0/7] virtiofsd: Add support to enable/disable
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
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Hi,

This is V7 of the patches.

Changes since V6.

- Dropped kernel header update patch as somebody else did it.
- Fixed coding style issues.

Currently posix ACL support does not work well with virtiofs and bunch
of tests fail when I run xfstests "./check -g acl".

This patches series fixes the issues with virtiofs posix acl support
and provides options to enable/disable posix acl (-o posix_acl/no_posix_acl).
By default posix_acls are disabled.

With this patch series applied and virtiofsd running with "-o posix_acl",
xfstests "./check -g acl" passes.

Thanks
Vivek


Vivek Goyal (7):
  virtiofsd: Fix fuse setxattr() API change issue
  virtiofsd: Fix xattr operations overwriting errno
  virtiofsd: Add support for extended setxattr
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Add capability to change/restore umask
  virtiofsd: Switch creds, drop FSETID for system.posix_acl_access xattr
  virtiofsd: Add an option to enable/disable posix acls

 docs/tools/virtiofsd.rst              |   3 +
 tools/virtiofsd/fuse_common.h         |  10 ++
 tools/virtiofsd/fuse_lowlevel.c       |  18 +-
 tools/virtiofsd/fuse_lowlevel.h       |   3 +-
 tools/virtiofsd/helper.c              |   1 +
 tools/virtiofsd/passthrough_ll.c      | 229 ++++++++++++++++++++++++--
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 7 files changed, 249 insertions(+), 16 deletions(-)

-- 
2.25.4

