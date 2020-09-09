From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:45:59 +0200
Message-Id: <20200909184603.263700-6-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/9] fuse: Store fuse_conn in fuse_req
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

Every fuse_req belongs to a fuse_conn.  Right now, we always know which
fuse_conn that is based on the respective device, but we want to allow
multiple (sub)mounts per single connection, and then the corresponding
filesystem is not going to be so trivial to obtain.

Storing a pointer to the associated fuse_conn in every fuse_req will
allow us to trivially find any request's superblock (and thus
filesystem) even then.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h |  3 +++
 fs/fuse/dev.c    | 13 +++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 21d1d1f41361..9a58ed3e8a97 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -360,6 +360,9 @@ struct fuse_req {
 	/** virtio-fs's physically contiguous buffer for in and out args */
 	void *argbuf;
 #endif
+
+	/** fuse_conn this request belongs to */
+	struct fuse_conn *fc;
 };
 
 struct fuse_iqueue;
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 02b3c36b3676..966aa7d7171e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -40,20 +40,21 @@ static struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
-static void fuse_request_init(struct fuse_req *req)
+static void fuse_request_init(struct fuse_conn *fc, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
 	INIT_LIST_HEAD(&req->intr_entry);
 	init_waitqueue_head(&req->waitq);
 	refcount_set(&req->count, 1);
 	__set_bit(FR_PENDING, &req->flags);
+	req->fc = fc;
 }
 
-static struct fuse_req *fuse_request_alloc(gfp_t flags)
+static struct fuse_req *fuse_request_alloc(struct fuse_conn *fc, gfp_t flags)
 {
 	struct fuse_req *req = kmem_cache_zalloc(fuse_req_cachep, flags);
 	if (req)
-		fuse_request_init(req);
+		fuse_request_init(fc, req);
 
 	return req;
 }
@@ -125,7 +126,7 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 	if (fc->conn_error)
 		goto out;
 
-	req = fuse_request_alloc(GFP_KERNEL);
+	req = fuse_request_alloc(fc, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!req) {
 		if (for_background)
@@ -480,7 +481,7 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
-		req = fuse_request_alloc(GFP_KERNEL | __GFP_NOFAIL);
+		req = fuse_request_alloc(fc, GFP_KERNEL | __GFP_NOFAIL);
 
 		if (!args->nocreds)
 			fuse_force_creds(fc, req);
@@ -547,7 +548,7 @@ int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
 
 	if (args->force) {
 		WARN_ON(!args->nocreds);
-		req = fuse_request_alloc(gfp_flags);
+		req = fuse_request_alloc(fc, gfp_flags);
 		if (!req)
 			return -ENOMEM;
 		__set_bit(FR_BACKGROUND, &req->flags);
-- 
2.26.2

