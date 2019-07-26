From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Fri, 26 Jul 2019 09:33:21 +0100
Message-Id: <20190726083322.13637-3-stefanha@redhat.com>
In-Reply-To: <20190726083322.13637-1-stefanha@redhat.com>
References: <20190726083322.13637-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/3] virtiofsd: add map_alignment to
	fuse_kernel.h
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com

This new FUSE_INIT field communicates the alignment constraint for
FUSE_SETUPMAPPING/FUSE_REMOVEMAPPING.

This feature will be implemented in the next commit.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/fuse_kernel.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
index 7722e0ac23..550fc3cb64 100644
--- a/contrib/virtiofsd/fuse_kernel.h
+++ b/contrib/virtiofsd/fuse_kernel.h
@@ -263,6 +263,9 @@ struct fuse_file_lock {
  * FUSE_MAX_PAGES: init_out.max_pages contains the max number of req pages
  * FUSE_CACHE_SYMLINKS: cache READLINK responses
  * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
+ * FUSE_MAP_ALIGNMENT: init_out.map_alignment contains byte alignment for
+ *                     foffset and moffset fields in struct
+ *                     fuse_setupmapping_out and fuse_removemapping_one.
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -289,6 +292,7 @@ struct fuse_file_lock {
 #define FUSE_MAX_PAGES		(1 << 22)
 #define FUSE_CACHE_SYMLINKS	(1 << 23)
 #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
+#define FUSE_MAP_ALIGNMENT      (1 << 25)
 
 /**
  * CUSE INIT request/reply flags
@@ -637,7 +641,8 @@ struct fuse_init_out {
 	uint32_t	time_gran;
 	uint16_t	max_pages;
 	uint16_t	padding;
-	uint32_t	unused[8];
+	uint32_t	map_alignment;
+	uint32_t	unused[7];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
-- 
2.21.0

