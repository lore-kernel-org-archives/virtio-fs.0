From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:17 +0000
Message-Id: <20201026184331.272953-3-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 02/16] virtiofsd: passthrough_ll: set
	FUSE_LOG_INFO as default log_level
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Just noticed that although help message says default log level is INFO,
it is actually 0 (EMRGE) and no mesage will be shown when error occurs.
It's better to follow help message.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-Id: <20201008110148.2757734-1-misono.tomohiro@jp.fujitsu.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ff53df4451..13fdb12367 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2878,12 +2878,11 @@ int main(int argc, char *argv[])
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
2.28.0

