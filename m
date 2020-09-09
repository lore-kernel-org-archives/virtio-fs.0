From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:45:56 +0200
Message-Id: <20200909184603.263700-3-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/9] fuse: Add FUSE_ATTR_SUBMOUNT
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

This is a flag for fuse_attr.flags that indicates that the given entry
resides on a different filesystem than the parent, and as such should
have a different st_dev.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 include/uapi/linux/fuse.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index de94c11cfc3b..c034cdf8f5f4 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -417,6 +417,13 @@ struct fuse_file_lock {
  */
 #define FUSE_FSYNC_FDATASYNC	(1 << 0)
 
+/**
+ * fuse_attr flags
+ *
+ * FUSE_ATTR_SUBMOUNT: File/directory is a submount point
+ */
+#define FUSE_ATTR_SUBMOUNT      (1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
-- 
2.26.2

