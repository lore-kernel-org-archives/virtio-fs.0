From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 23 Feb 2021 17:52:48 -0500
Message-Id: <20210223225250.23945-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/2] virtiofsd: Enable posix_acl by default
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

This is V3 of the patches. Changes since v2 are.

- I dropped the patch to give user an option to enable/disable acls.
  Now acls are enabled by default if xattrs are enabled and fuse
  client offers FUSE_POSIX_ACL capability.
 
Miklos mentioned that ACLS might not have lot of overhead as these
can be cached. So it might make sense to enable these by default.

If we run into performance issues, then we can add another patch to
give option to enable/disable and disable it by default.

Luis Henriques reported that fstest generic/099 fails with virtiofs.
Little debugging showed that we don't enable acl support. This
patch series should fix the issue

Vivek Goyal (2):
  virtiofsd: Add umask to seccom allow list
  virtiofsd: Enable posix_acls by default if xattrs are enabled

 tools/virtiofsd/passthrough_ll.c      | 29 +++++++++++++++++++++------
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

-- 
2.25.4

