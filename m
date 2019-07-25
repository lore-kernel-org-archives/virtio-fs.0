From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 25 Jul 2019 15:20:14 +0100
Message-Id: <20190725142014.1726-3-stefanha@redhat.com>
In-Reply-To: <20190725142014.1726-1-stefanha@redhat.com>
References: <20190725142014.1726-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] fuse: make FUSE_REMOVEMAPPING_MAX_ENTRY
	private
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

FUSE_REMOVEMAPPING_MAX_ENTRY is only used by fs/fuse/file.c and is not
part of the FUSE protocol.  Do not expose it in the uapi header file.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/fuse.h | 3 ---
 fs/fuse/file.c            | 3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 8c36aadb6294..0f4b69b9c751 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -853,7 +853,4 @@ struct fuse_removemapping_one {
         uint64_t	len;
 };
 
-#define FUSE_REMOVEMAPPING_MAX_ENTRY   \
-		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
-
 #endif /* _LINUX_FUSE_H */
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index fc40e0f44578..1e890a8491ae 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -22,6 +22,9 @@
 #include <linux/iomap.h>
 #include <linux/interval_tree_generic.h>
 
+#define FUSE_REMOVEMAPPING_MAX_ENTRY   \
+		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
+
 INTERVAL_TREE_DEFINE(struct fuse_dax_mapping, rb, __u64, __subtree_last,
                      START, LAST, static inline, fuse_dax_interval_tree);
 
-- 
2.21.0

