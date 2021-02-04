From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  4 Feb 2021 18:34:38 +0000
Message-Id: <20210204183439.546918-5-dgilbert@redhat.com>
In-Reply-To: <20210204183439.546918-1-dgilbert@redhat.com>
References: <20210204183439.546918-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 4/5] virtiofsd: Add _llseek to the seccomp
	whitelist
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, groug@kaod.org, qemu-stable@nongnu.org

From: Greg Kurz <groug@kaod.org>

This is how glibc implements lseek(2) on POWER.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1917692
Signed-off-by: Greg Kurz <groug@kaod.org>
Message-Id: <20210121171540.1449777-1-groug@kaod.org>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_seccomp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index a60d7da4b4..1ecf5bf318 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -65,6 +65,7 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(linkat),
     SCMP_SYS(listxattr),
     SCMP_SYS(lseek),
+    SCMP_SYS(_llseek), /* For POWER */
     SCMP_SYS(madvise),
     SCMP_SYS(mkdirat),
     SCMP_SYS(mknodat),
-- 
2.29.2

