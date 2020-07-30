From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Jul 2020 15:47:34 -0400
Message-Id: <20200730194736.173994-4-vgoyal@redhat.com>
In-Reply-To: <20200730194736.173994-1-vgoyal@redhat.com>
References: <20200730194736.173994-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/5] virtiofsd: open /proc/self/fd/ in
	sandbox=NONE mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: berrange@redhat.com, vromanso@redhat.com, virtio-fs@redhat.com, vgoyal@redhat.com

We need /proc/self/fd descriptor even in sandbox=NONE mode.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index cd91c4a831..76ef891105 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2969,6 +2969,15 @@ static void setup_capabilities(char *modcaps_in)
     pthread_mutex_unlock(&cap.mutex);
 }
 
+static void setup_none(struct lo_data *lo)
+{
+    lo->proc_self_fd = open("/proc/self/fd", O_PATH);
+    if (lo->proc_self_fd == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(\"/proc/self/fd\", O_PATH): %m\n");
+        exit(1);
+    }
+}
+
 /*
  * Use chroot as a weaker sandbox for environments where the process is
  * launched without CAP_SYS_ADMIN.
@@ -3014,8 +3023,10 @@ static void setup_sandbox(struct lo_data *lo, struct fuse_session *se,
     if (lo->sandbox == SANDBOX_NAMESPACE) {
         setup_namespaces(lo, se);
         setup_mounts(lo->source);
-    } else {
+    } else if (lo->sandbox == SANDBOX_CHROOT) {
         setup_chroot(lo);
+    } else {
+        setup_none(lo);
     }
 
     setup_seccomp(enable_syslog);
-- 
2.25.4

