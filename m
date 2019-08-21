From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:37:34 -0400
Message-Id: <20190821173742.24574-6-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 05/13] fuse: Export fuse_send_init_request()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

This will be used by virtio-fs to send init request to fuse server after
initialization of virt queues.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dev.c    | 1 +
 fs/fuse/fuse_i.h | 1 +
 fs/fuse/inode.c  | 3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index d90dba54f0d4..14c8ea3d189c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -139,6 +139,7 @@ void fuse_request_free(struct fuse_req *req)
 	fuse_req_pages_free(req);
 	kmem_cache_free(fuse_req_cachep, req);
 }
+EXPORT_SYMBOL_GPL(fuse_request_free);
 
 void __fuse_get_request(struct fuse_req *req)
 {
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f41ce8f39006..49f83f00c79c 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -994,6 +994,7 @@ void fuse_conn_put(struct fuse_conn *fc);
 
 struct fuse_dev *fuse_dev_alloc(struct fuse_conn *fc);
 void fuse_dev_free(struct fuse_dev *fud);
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req);
 
 /**
  * Add connection to control filesystem
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4bb885b0f032..14a4e915294c 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -955,7 +955,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 	wake_up_all(&fc->blocked_waitq);
 }
 
-static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	struct fuse_init_in *arg = &req->misc.init_in;
 
@@ -985,6 +985,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->end = process_init_reply;
 	fuse_request_send_background(fc, req);
 }
+EXPORT_SYMBOL_GPL(fuse_send_init);
 
 static void fuse_free_conn(struct fuse_conn *fc)
 {
-- 
2.20.1

