From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:36 +0800
Message-Id: <1559695356-75503-6-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 5/5] virtiofsd: add helper for lo_data cleanup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This offers an helper function for lo_data's cleanup.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 649991e..73ca09f 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2205,6 +2205,24 @@ static gboolean lo_key_equal(gconstpointer a, gconstpointer b)
                la->dev == lb->dev;
 }
 
+static void fuse_lo_data_cleanup(struct lo_data *lo, bool free_source)
+{
+        if (lo->inodes)
+                g_hash_table_destroy(lo->inodes);
+	lo_map_destroy(&lo->fd_map);
+	lo_map_destroy(&lo->dirp_map);
+	lo_map_destroy(&lo->ino_map);
+
+	if (lo->proc_self_fd >= 0) {
+		close(lo->proc_self_fd);
+	}
+
+	if (lo->root.fd >= 0)
+		close(lo->root.fd);
+
+        if (free_source)
+                free((char *)lo->source);
+}
 
 int main(int argc, char *argv[])
 {
@@ -2325,21 +2343,7 @@ err_out2:
 err_out1:
 	fuse_opt_free_args(&args);
 
-        if (lo.inodes)
-                g_hash_table_destroy(lo.inodes);
-	lo_map_destroy(&lo.fd_map);
-	lo_map_destroy(&lo.dirp_map);
-	lo_map_destroy(&lo.ino_map);
-
-	if (lo.proc_self_fd >= 0) {
-		close(lo.proc_self_fd);
-	}
-
-	if (lo.root.fd >= 0)
-		close(lo.root.fd);
-
-        if (free_source)
-                free((char *)lo.source);
+        fuse_lo_data_cleanup(&lo, free_source);
 
 	return ret ? 1 : 0;
 }
-- 
1.8.3.1

