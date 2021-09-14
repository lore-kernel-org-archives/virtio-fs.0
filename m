From: Thomas Huth <thuth@redhat.com>
Date: Tue, 14 Sep 2021 14:32:14 +0200
Message-Id: <20210914123214.181885-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] tools/virtiofsd: Add fstatfs64 syscall to the
	seccomp allowlist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-s390x@nongnu.org, Vivek Goyal <vgoyal@redhat.com>

The virtiofsd currently crashes on s390x when doing something like
this in the guest:

 mkdir -p /mnt/myfs
 mount -t virtiofs myfs /mnt/myfs
 touch /mnt/myfs/foo.txt
 stat -f /mnt/myfs/foo.txt

The problem is that the fstatfs64 syscall is called in this case
from the virtiofsd. We have to put it on the seccomp allowlist to
avoid that the daemon gets killed in this case.

Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=2001728
Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 tools/virtiofsd/passthrough_seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index f49ed94b5e..a3ce9f898d 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -51,6 +51,7 @@ static const int syscall_allowlist[] = {
     SCMP_SYS(fsetxattr),
     SCMP_SYS(fstat),
     SCMP_SYS(fstatfs),
+    SCMP_SYS(fstatfs64),
     SCMP_SYS(fsync),
     SCMP_SYS(ftruncate),
     SCMP_SYS(futex),
-- 
2.27.0

