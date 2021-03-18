From: Connor Kuehl <ckuehl@redhat.com>
Date: Thu, 18 Mar 2021 08:52:22 -0500
Message-Id: <20210318135223.1342795-3-ckuehl@redhat.com>
In-Reply-To: <20210318135223.1342795-1-ckuehl@redhat.com>
References: <20210318135223.1342795-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 2/3] virtiofs: split requests that exceed
	virtqueue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

If an incoming FUSE request can't fit on the virtqueue, the request is
placed onto a workqueue so a worker can try to resubmit it later where
there will (hopefully) be space for it next time.

This is fine for requests that aren't larger than a virtqueue's maximum
capacity. However, if a request's size exceeds the maximum capacity of
the virtqueue (even if the virtqueue is empty), it will be doomed to a
life of being placed on the workqueue, removed, discovered it won't fit,
and placed on the workqueue yet again.

Furthermore, from section 2.6.5.3.1 (Driver Requirements: Indirect
Descriptors) of the virtio spec:

  "A driver MUST NOT create a descriptor chain longer than the Queue
  Size of the device."

To fix this, limit the number of pages FUSE will use for an overall
request. This way, each request can realistically fit on the virtqueue
when it is decomposed into a scattergather list and avoid violating
section 2.6.5.3.1 of the virtio spec.

Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
 fs/fuse/fuse_i.h    |  5 +++++
 fs/fuse/inode.c     |  7 +++++++
 fs/fuse/virtio_fs.c | 14 ++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 68cca8d4db6e..f0e4ee906464 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -555,6 +555,11 @@ struct fuse_conn {
 	/** Maxmum number of pages that can be used in a single request */
 	unsigned int max_pages;
 
+#if IS_ENABLED(CONFIG_VIRTIO_FS)
+	/** Constrain ->max_pages to this value during feature negotiation */
+	unsigned int transport_capacity;
+#endif
+
 	/** Input queue */
 	struct fuse_iqueue iq;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index b0e18b470e91..42cc72ba13d9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1058,6 +1058,13 @@ static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 			fc->no_flock = 1;
 		}
 
+#if IS_ENABLED(CONFIG_VIRTIO_FS)
+		/* fuse_conn_init() sets this to zero for all others, this is
+		 * explicitly set by virtio_fs.
+		 */
+		if (fc->transport_capacity)
+			fc->max_pages = min_t(unsigned int, fc->max_pages, fc->transport_capacity);
+#endif
 		fm->sb->s_bdi->ra_pages =
 				min(fm->sb->s_bdi->ra_pages, ra_pages);
 		fc->minor = arg->minor;
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 8868ac31a3c0..a6ffba85d59a 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -18,6 +18,12 @@
 #include <linux/uio.h>
 #include "fuse_i.h"
 
+/* Used to help calculate the FUSE connection's max_pages limit for a request's
+ * size. Parts of the struct fuse_req are sliced into scattergather lists in
+ * addition to the pages used, so this can help account for that overhead.
+ */
+#define FUSE_HEADER_OVERHEAD    4
+
 /* List of virtio-fs device instances and a lock for the list. Also provides
  * mutual exclusion in device removal and mounting path
  */
@@ -1408,6 +1414,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	struct super_block *sb;
 	struct fuse_conn *fc;
 	struct fuse_mount *fm;
+	unsigned int virtqueue_size;
 	int err;
 
 	/* This gets a reference on virtio_fs object. This ptr gets installed
@@ -1435,6 +1442,13 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	fc->delete_stale = true;
 	fc->auto_submounts = true;
 
+	/* Tell FUSE to split requests that exceed the virtqueue's size */
+	virtqueue_size = virtqueue_get_vring_size(fs->vqs[VQ_REQUEST].vq);
+	WARN_ON(virtqueue_size <= FUSE_HEADER_OVERHEAD);
+	fc->transport_capacity = min_t(unsigned int,
+			virtqueue_size - FUSE_HEADER_OVERHEAD,
+			FUSE_MAX_MAX_PAGES);
+
 	fsc->s_fs_info = fm;
 	sb = sget_fc(fsc, virtio_fs_test_super, set_anon_super_fc);
 	if (fsc->s_fs_info) {
-- 
2.30.2

