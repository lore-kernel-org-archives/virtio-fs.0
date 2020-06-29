From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 29 Jun 2020 12:54:19 +0100
Message-Id: <20200629115420.98443-3-dgilbert@redhat.com>
In-Reply-To: <20200629115420.98443-1-dgilbert@redhat.com>
References: <20200629115420.98443-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/3] virtiofsd: Check capability calls
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Check the capability calls worked.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index e373e3b36e..99d562046a 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2589,7 +2589,7 @@ static void setup_capabilities(void)
      */
     capng_setpid(syscall(SYS_gettid));
     capng_clear(CAPNG_SELECT_BOTH);
-    capng_updatev(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE,
+    if (capng_updatev(CAPNG_ADD, CAPNG_PERMITTED | CAPNG_EFFECTIVE,
             CAP_CHOWN,
             CAP_DAC_OVERRIDE,
             CAP_DAC_READ_SEARCH,
@@ -2599,11 +2599,21 @@ static void setup_capabilities(void)
             CAP_SETUID,
             CAP_MKNOD,
             CAP_SETFCAP,
-            -1);
+            -1)) {
+        fuse_log(FUSE_LOG_ERR, "%s: capng_updatev failed\n", __func__);
+        exit(1);
+    }
 
-    capng_apply(CAPNG_SELECT_BOTH);
+    if (capng_apply(CAPNG_SELECT_BOTH)) {
+        fuse_log(FUSE_LOG_ERR, "%s: capng_apply failed\n", __func__);
+        exit(1);
+    }
 
     cap.saved = capng_save_state();
+    if (!cap.saved) {
+        fuse_log(FUSE_LOG_ERR, "%s: capng_save_state failed\n", __func__);
+        exit(1);
+    }
     pthread_mutex_unlock(&cap.mutex);
 }
 
-- 
2.26.2

