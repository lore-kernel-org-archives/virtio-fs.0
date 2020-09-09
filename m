From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:45:57 +0200
Message-Id: <20200909184603.263700-4-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/9] fuse: Add FUSE_ATTR_FLAGS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: fuse-devel@lists.sourceforge.net, Max Reitz <mreitz@redhat.com>

The client sets this flag when it expects fuse_attr.flags (instead of
just padding).  The server sets it when it will provide a proper value
for it.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 include/uapi/linux/fuse.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index c034cdf8f5f4..432c16dfbcd9 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -314,6 +314,7 @@ struct fuse_file_lock {
  * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
  * FUSE_EXPLICIT_INVAL_DATA: only invalidate cached pages on explicit request
  * FUSE_MAP_ALIGNMENT: map_alignment field is valid
+ * FUSE_ATTR_FLAGS: fuse_attr.flags is present and valid
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -342,6 +343,7 @@ struct fuse_file_lock {
 #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
 #define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
 #define FUSE_MAP_ALIGNMENT	(1 << 26)
+#define FUSE_ATTR_FLAGS		(1 << 27)
 
 /**
  * CUSE INIT request/reply flags
-- 
2.26.2

