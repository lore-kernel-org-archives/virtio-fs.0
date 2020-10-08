From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Thu, 8 Oct 2020 20:01:48 +0900
Message-ID: <20201008110148.2757734-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH] virtiofsd: passthrough_ll: set FUSE_LOG_INFO as
	default log_level
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

Just noticed that although help message says default log level is INFO,
it is actually 0 (EMRGE) and no mesage will be shown when error occurs.
It's better to follow help message.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 0b229ebd57..4ff9f1b688 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2888,12 +2888,11 @@ int main(int argc, char *argv[])
         goto err_out1;
     }
 
-    /*
-     * log_level is 0 if not configured via cmd options (0 is LOG_EMERG,
-     * and we don't use this log level).
-     */
     if (opts.log_level != 0) {
         current_log_level = opts.log_level;
+    } else {
+        /* default log level is INFO */
+        current_log_level = FUSE_LOG_INFO;
     }
     lo.debug = opts.debug;
     if (lo.debug) {
-- 
2.25.4

