DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=ILlNwQ7IYNn33LRxFCAi5oYlzntM/30JEoLe+sVzVCg=;
	b=bCK/J8SWnJEv/4om3fKbfMX03oFef6Um4Z4bT+Wb0xOqocFNWWaSFw/R/5JB/myuMH
	PDQRuFN1K5bGSMli5b6UOEB+FdKQL3J4MeE7pd6+ZgL0nxDRiSImpqn+tqwl0UAit/Vl
	gBR18/OAc+Oate+v29u8eEdZDTvvXKEzhKJPM=
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Fri, 24 Apr 2020 15:25:40 +0900
Message-Id: <20200424062540.23679-2-chirantan@chromium.org>
In-Reply-To: <20200424062540.23679-1-chirantan@chromium.org>
References: <20200424062540.23679-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] fuse: virtiofs: Add basic multiqueue support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Suleiman Souhlal <suleiman@chromium.org>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>, Vivek Goyal <vgoyal@redhat.com>

Use simple round-robin scheduling based on the `unique` field of the
fuse request to spread requests across multiple queues, if supported by
the device.

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
---
 fs/fuse/dev.c       | 4 ----
 fs/fuse/fuse_i.h    | 4 ++++
 fs/fuse/virtio_fs.c | 4 +++-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 97eec7522bf20..cad9f76c2519c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -25,10 +25,6 @@
 MODULE_ALIAS_MISCDEV(FUSE_MINOR);
 MODULE_ALIAS("devname:fuse");
 
-/* Ordinary requests have even IDs, while interrupts IDs are odd */
-#define FUSE_INT_REQ_BIT (1ULL << 0)
-#define FUSE_REQ_ID_STEP (1ULL << 1)
-
 static struct kmem_cache *fuse_req_cachep;
 
 static struct fuse_dev *fuse_get_dev(struct file *file)
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ca344bf714045..110b917d950a8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -47,6 +47,10 @@
 /** Number of dentries for each connection in the control filesystem */
 #define FUSE_CTL_NUM_DENTRIES 5
 
+/* Ordinary requests have even IDs, while interrupts IDs are odd */
+#define FUSE_INT_REQ_BIT (1ULL << 0)
+#define FUSE_REQ_ID_STEP (1ULL << 1)
+
 /** List of active connections */
 extern struct list_head fuse_conn_list;
 
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d3c38222a7e4e..c5129fd27930c 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -980,7 +980,7 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *fiq)
 __releases(fiq->lock)
 {
-	unsigned int queue_id = VQ_REQUEST; /* TODO multiqueue */
+	unsigned int queue_id;
 	struct virtio_fs *fs;
 	struct fuse_req *req;
 	struct virtio_fs_vq *fsvq;
@@ -994,6 +994,8 @@ __releases(fiq->lock)
 	spin_unlock(&fiq->lock);
 
 	fs = fiq->priv;
+	queue_id = ((req->in.h.unique / FUSE_REQ_ID_STEP) %
+		    (uint64_t)fs->num_request_queues) + VQ_REQUEST;
 
 	pr_debug("%s: opcode %u unique %#llx nodeid %#llx in.len %u out.len %u\n",
 		  __func__, req->in.h.opcode, req->in.h.unique,
-- 
2.26.2.303.gf8c07b1a785-goog


