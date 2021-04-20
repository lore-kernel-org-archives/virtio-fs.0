DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=Fg7014VWMzQTkIEvl7LENz5/48AAvautKhUCOqhNxxQ=;
	b=c+UJd+1qsSDp1lVZOwZ3dvdRxzZzclTMtzWLcepJqC/y+8t4QyiSflvFGgfTMa7X0/
	20kysU49505eCIwz2NenfzUGztxACJ+SmLcKbQWd/y/8g2JvIxl7T6itzFa4oB+7O9Vy
	ksfkHCqjef7FGVHQcilKh5xT4nLE4duANApD5VRGqZqehoUdqICv1zr9kzzT1Foun4VX
	pY4plgcZNaCwEaXiMyAfRX1sBQhUKKZn4FJzRxpT90wlj7T6ZEyF/Fo8Ad5w+FANjD2c
	lLBIF7ZKoWgnNhiXe9iWgFqsk9Rucosvz4UlPUvny5wBf+IMHxGbSig5ICXZ0t+WN/n2
	Yuew==
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 20 Apr 2021 17:46:42 +0200
Message-Id: <20210420154643.58439-8-ma.mandourr@gmail.com>
In-Reply-To: <20210420154643.58439-1-ma.mandourr@gmail.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 7/7] virtiofsd/fuse_virtio.c: Changed
	allocations of locals to GLib
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

Replaced the allocation of local variables from malloc() to
GLib allocation functions.

In one instance, dropped the usage to an assert after a malloc()
call and used g_malloc() instead.

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 5828b9a76f..587403b026 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -472,8 +472,7 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
      * They're spread over multiple descriptors in a scatter/gather set
      * and we can't trust the guest to keep them still; so copy in/out.
      */
-    fbuf.mem = malloc(se->bufsize);
-    assert(fbuf.mem);
+    fbuf.mem = g_malloc(se->bufsize);
 
     fuse_mutex_init(&req->ch.lock);
     req->ch.fd = -1;
@@ -524,7 +523,7 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
         fbuf.size = out_sg[0].iov_len + out_sg[1].iov_len;
 
         /* Allocate the bufv, with space for the rest of the iov */
-        pbufv = malloc(sizeof(struct fuse_bufvec) +
+        pbufv = g_try_malloc(sizeof(struct fuse_bufvec) +
                        sizeof(struct fuse_buf) * (out_num - 2));
         if (!pbufv) {
             fuse_log(FUSE_LOG_ERR, "%s: pbufv malloc failed\n",
@@ -569,7 +568,7 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
 
 out:
     if (allocated_bufv) {
-        free(pbufv);
+        g_free(pbufv);
     }
 
     /* If the request has no reply, still recycle the virtqueue element */
@@ -588,7 +587,7 @@ out:
     }
 
     pthread_mutex_destroy(&req->ch.lock);
-    free(fbuf.mem);
+    g_free(fbuf.mem);
     free(req);
 }
 
-- 
2.25.1

