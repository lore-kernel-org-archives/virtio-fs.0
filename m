From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:46:01 +0200
Message-Id: <20200909184603.263700-8-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 7/9] fuse: Split fuse_mount off of fuse_conn
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

We want to allow submounts for the same fuse_conn, but with different
superblocks so that each of the submounts has its own device ID.  To do
so, we need to split all mount-specific information off of fuse_conn
into a new fuse_mount structure, so that multiple mounts can share a
single fuse_conn.

We need to take care only to perform connection-level actions once (i.e.
when the fuse_conn and thus the first fuse_mount are established, or
when the last fuse_mount and thus the fuse_conn are destroyed).  For
example, fuse_sb_destroy() must invoke fuse_send_destroy() until the
last superblock is released.

To do so, we keep track of which fuse_mount is the root mount and
perform all fuse_conn-level actions only when this fuse_mount is
involved.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h    | 119 ++++++++++++++++++++-----
 fs/fuse/control.c   |  28 ++++--
 fs/fuse/dev.c       | 106 +++++++++++-----------
 fs/fuse/dir.c       | 111 +++++++++++------------
 fs/fuse/file.c      | 211 ++++++++++++++++++++++----------------------
 fs/fuse/inode.c     | 147 ++++++++++++++++++++++--------
 fs/fuse/readdir.c   |  10 +--
 fs/fuse/virtio_fs.c |  62 ++++++++-----
 fs/fuse/xattr.c     |  34 +++----
 9 files changed, 502 insertions(+), 326 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 2e1b037bf7e8..8afe3972471a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -161,12 +161,13 @@ enum {
 };
 
 struct fuse_conn;
+struct fuse_mount;
 struct fuse_release_args;
 
 /** FUSE specific file data */
 struct fuse_file {
 	/** Fuse connection for this file */
-	struct fuse_conn *fc;
+	struct fuse_mount *fm;
 
 	/* Argument space reserved for release */
 	struct fuse_release_args *release_args;
@@ -252,7 +253,7 @@ struct fuse_args {
 	bool may_block:1;
 	struct fuse_in_arg in_args[3];
 	struct fuse_arg out_args[2];
-	void (*end)(struct fuse_conn *fc, struct fuse_args *args, int error);
+	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
 };
 
 struct fuse_args_pages {
@@ -361,8 +362,8 @@ struct fuse_req {
 	void *argbuf;
 #endif
 
-	/** fuse_conn this request belongs to */
-	struct fuse_conn *fc;
+	/** fuse_mount this request belongs to */
+	struct fuse_mount *fm;
 };
 
 struct fuse_iqueue;
@@ -497,9 +498,9 @@ struct fuse_fs_context {
 /**
  * A Fuse connection.
  *
- * This structure is created, when the filesystem is mounted, and is
- * destroyed, when the client device is closed and the filesystem is
- * unmounted.
+ * This structure is created, when the root filesystem is mounted, and
+ * is destroyed, when the client device is closed and the last
+ * fuse_mount is destroyed.
  */
 struct fuse_conn {
 	/** Lock protecting accessess to  members of this structure */
@@ -732,12 +733,9 @@ struct fuse_conn {
 	/** Negotiated minor version */
 	unsigned minor;
 
-	/** Entry on the fuse_conn_list */
+	/** Entry on the fuse_mount_list */
 	struct list_head entry;
 
-	/** Device ID from super block */
-	dev_t dev;
-
 	/** Dentries in the control filesystem */
 	struct dentry *ctl_dentry[FUSE_CTL_NUM_DENTRIES];
 
@@ -753,24 +751,71 @@ struct fuse_conn {
 	/** Called on final put */
 	void (*release)(struct fuse_conn *);
 
-	/** Super block for this connection. */
-	struct super_block *sb;
-
-	/** Read/write semaphore to hold when accessing sb. */
+	/**
+	 * Read/write semaphore to hold when accessing the sb of any
+	 * fuse_mount belonging to this connection
+	 */
 	struct rw_semaphore killsb;
 
 	/** List of device instances belonging to this connection */
 	struct list_head devices;
+
+	/** List of filesystems using this connection */
+	struct list_head mounts;
 };
 
-static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
+/**
+ * Represents a mounted filesystem, potentially a submount.
+ *
+ * This object allows sharing a fuse_conn between separate mounts to
+ * allow submounts with dedicated superblocks and thus separate device
+ * IDs.
+ */
+struct fuse_mount {
+	/** Underlying (potentially shared) connection to the FUSE server */
+	struct fuse_conn *fc;
+
+	/** Refcount */
+	refcount_t count;
+
+	/** Device ID from super block */
+	dev_t dev;
+
+	/**
+	 * Super block for this connection (fc->killsb must be held
+	 * when accessing this).
+	 */
+	struct super_block *sb;
+
+	/** Entry on fc->mounts */
+	struct list_head fc_entry;
+
+	/** True for root mounts, false for submounts */
+	bool root;
+};
+
+static inline struct fuse_mount *get_fuse_mount_super(struct super_block *sb)
 {
 	return sb->s_fs_info;
 }
 
+static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
+{
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
+
+	return fm ? fm->fc : NULL;
+}
+
+static inline struct fuse_mount *get_fuse_mount(struct inode *inode)
+{
+	return get_fuse_mount_super(inode->i_sb);
+}
+
 static inline struct fuse_conn *get_fuse_conn(struct inode *inode)
 {
-	return get_fuse_conn_super(inode->i_sb);
+	struct fuse_mount *fm = get_fuse_mount(inode);
+
+	return fm ? fm->fc : NULL;
 }
 
 static inline struct fuse_inode *get_fuse_inode(struct inode *inode)
@@ -854,7 +899,7 @@ void fuse_read_args_fill(struct fuse_io_args *ia, struct file *file, loff_t pos,
  */
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir);
 
-struct fuse_file *fuse_file_alloc(struct fuse_conn *fc);
+struct fuse_file *fuse_file_alloc(struct fuse_mount *fm);
 void fuse_file_free(struct fuse_file *ff);
 void fuse_finish_open(struct inode *inode, struct file *file);
 
@@ -922,8 +967,8 @@ void __exit fuse_ctl_cleanup(void);
 /**
  * Simple request sending that does request allocation and freeing
  */
-ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args);
-int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
+ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args);
+int fuse_simple_background(struct fuse_mount *fm, struct fuse_args *args,
 			   gfp_t gfp_flags);
 
 /**
@@ -963,11 +1008,26 @@ void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns,
  */
 void fuse_conn_put(struct fuse_conn *fc);
 
+/**
+ * Acquire reference to fuse_mount
+ */
+struct fuse_mount *fuse_mount_get(struct fuse_mount *fm);
+
+/**
+ * Initialize fuse_mount for a given fuse_conn
+ */
+void fuse_mount_init(struct fuse_mount *fm, struct fuse_conn *fc, bool root);
+
+/**
+ * Release reference to fuse_mount
+ */
+void fuse_mount_put(struct fuse_mount *fm);
+
 struct fuse_dev *fuse_dev_alloc_install(struct fuse_conn *fc);
 struct fuse_dev *fuse_dev_alloc(void);
 void fuse_dev_install(struct fuse_dev *fud, struct fuse_conn *fc);
 void fuse_dev_free(struct fuse_dev *fud);
-void fuse_send_init(struct fuse_conn *fc);
+void fuse_send_init(struct fuse_mount *fm);
 
 /**
  * Fill in superblock and initialize fuse connection
@@ -1016,10 +1076,21 @@ void fuse_flush_writepages(struct inode *inode);
 void fuse_set_nowrite(struct inode *inode);
 void fuse_release_nowrite(struct inode *inode);
 
+/**
+ * Scan all fuse_mounts belonging to fc to find the first where
+ * ilookup5() returns a result.  Return that result and the
+ * respective fuse_mount in *fm (unless fm is NULL).
+ *
+ * The caller must hold fc->killsb.
+ */
+struct inode *fuse_ilookup(struct fuse_conn *fc, unsigned long hashval,
+			   int (*test)(struct inode *, void *),
+			   void *data, struct fuse_mount **fm);
+
 /**
  * File-system tells the kernel to invalidate cache for the given node id.
  */
-int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
+int fuse_reverse_inval_inode(struct fuse_conn *fc, u64 nodeid,
 			     loff_t offset, loff_t len);
 
 /**
@@ -1032,10 +1103,10 @@ int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
  *    - is a file or oan empty directory
  * then the dentry is unhashed (d_delete()).
  */
-int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
+int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 			     u64 child_nodeid, struct qstr *name);
 
-int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
+int fuse_do_open(struct fuse_mount *fm, u64 nodeid, struct file *file,
 		 bool isdir);
 
 /**
diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index a1303ad303ba..9f9581301ddc 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -164,6 +164,7 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 {
 	unsigned val;
 	struct fuse_conn *fc;
+	struct fuse_mount *first_fm = NULL;
 	ssize_t ret;
 
 	ret = fuse_conn_limit_write(file, buf, count, ppos, &val,
@@ -176,13 +177,22 @@ static ssize_t fuse_conn_congestion_threshold_write(struct file *file,
 
 	spin_lock(&fc->bg_lock);
 	fc->congestion_threshold = val;
-	if (fc->sb) {
+
+	/*
+	 * Get any fuse_mount belonging to this fuse_conn; s_bdi is
+	 * shared between all of them
+	 */
+	if (!list_empty(&fc->mounts))
+		first_fm = list_first_entry(&fc->mounts, struct fuse_mount,
+					    fc_entry);
+
+	if (first_fm && first_fm->sb) {
 		if (fc->num_background < fc->congestion_threshold) {
-			clear_bdi_congested(fc->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fc->sb->s_bdi, BLK_RW_ASYNC);
+			clear_bdi_congested(first_fm->sb->s_bdi, BLK_RW_SYNC);
+			clear_bdi_congested(first_fm->sb->s_bdi, BLK_RW_ASYNC);
 		} else {
-			set_bdi_congested(fc->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fc->sb->s_bdi, BLK_RW_ASYNC);
+			set_bdi_congested(first_fm->sb->s_bdi, BLK_RW_SYNC);
+			set_bdi_congested(first_fm->sb->s_bdi, BLK_RW_ASYNC);
 		}
 	}
 	spin_unlock(&fc->bg_lock);
@@ -263,14 +273,20 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 int fuse_ctl_add_conn(struct fuse_conn *fc)
 {
 	struct dentry *parent;
+	struct fuse_mount *first_fm;
 	char name[32];
 
 	if (!fuse_control_sb)
 		return 0;
 
+	if (list_empty(&fc->mounts))
+		return 0;
+
+	first_fm = list_first_entry(&fc->mounts, struct fuse_mount, fc_entry);
+	sprintf(name, "%u", first_fm->dev);
+
 	parent = fuse_control_sb->s_root;
 	inc_nlink(d_inode(parent));
-	sprintf(name, "%u", fc->dev);
 	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500, 2,
 				     &simple_dir_inode_operations,
 				     &simple_dir_operations);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 7684d69c7cd1..c29380696152 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -40,21 +40,21 @@ static struct fuse_dev *fuse_get_dev(struct file *file)
 	return READ_ONCE(file->private_data);
 }
 
-static void fuse_request_init(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_request_init(struct fuse_mount *fm, struct fuse_req *req)
 {
 	INIT_LIST_HEAD(&req->list);
 	INIT_LIST_HEAD(&req->intr_entry);
 	init_waitqueue_head(&req->waitq);
 	refcount_set(&req->count, 1);
 	__set_bit(FR_PENDING, &req->flags);
-	req->fc = fc;
+	req->fm = fm;
 }
 
-static struct fuse_req *fuse_request_alloc(struct fuse_conn *fc, gfp_t flags)
+static struct fuse_req *fuse_request_alloc(struct fuse_mount *fm, gfp_t flags)
 {
 	struct fuse_req *req = kmem_cache_zalloc(fuse_req_cachep, flags);
 	if (req)
-		fuse_request_init(fc, req);
+		fuse_request_init(fm, req);
 
 	return req;
 }
@@ -103,8 +103,9 @@ static void fuse_drop_waiting(struct fuse_conn *fc)
 
 static void fuse_put_request(struct fuse_req *req);
 
-static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
+static struct fuse_req *fuse_get_req(struct fuse_mount *fm, bool for_background)
 {
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_req *req;
 	int err;
 	atomic_inc(&fc->num_waiting);
@@ -126,7 +127,7 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 	if (fc->conn_error)
 		goto out;
 
-	req = fuse_request_alloc(fc, GFP_KERNEL);
+	req = fuse_request_alloc(fm, GFP_KERNEL);
 	err = -ENOMEM;
 	if (!req) {
 		if (for_background)
@@ -156,7 +157,7 @@ static struct fuse_req *fuse_get_req(struct fuse_conn *fc, bool for_background)
 
 static void fuse_put_request(struct fuse_req *req)
 {
-	struct fuse_conn *fc = req->fc;
+	struct fuse_conn *fc = req->fm->fc;
 
 	if (refcount_dec_and_test(&req->count)) {
 		if (test_bit(FR_BACKGROUND, &req->flags)) {
@@ -278,7 +279,8 @@ static void flush_bg_queue(struct fuse_conn *fc)
  */
 void fuse_request_end(struct fuse_req *req)
 {
-	struct fuse_conn *fc = req->fc;
+	struct fuse_mount *fm = req->fm;
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 
 	if (test_and_set_bit(FR_FINISHED, &req->flags))
@@ -313,9 +315,9 @@ void fuse_request_end(struct fuse_req *req)
 				wake_up(&fc->blocked_waitq);
 		}
 
-		if (fc->num_background == fc->congestion_threshold && fc->sb) {
-			clear_bdi_congested(fc->sb->s_bdi, BLK_RW_SYNC);
-			clear_bdi_congested(fc->sb->s_bdi, BLK_RW_ASYNC);
+		if (fc->num_background == fc->congestion_threshold && fm->sb) {
+			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
+			clear_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
 		}
 		fc->num_background--;
 		fc->active_background--;
@@ -327,7 +329,7 @@ void fuse_request_end(struct fuse_req *req)
 	}
 
 	if (test_bit(FR_ASYNC, &req->flags))
-		req->args->end(fc, req->args, req->out.h.error);
+		req->args->end(fm, req->args, req->out.h.error);
 put_request:
 	fuse_put_request(req);
 }
@@ -335,7 +337,7 @@ EXPORT_SYMBOL_GPL(fuse_request_end);
 
 static int queue_interrupt(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &req->fc->iq;
+	struct fuse_iqueue *fiq = &req->fm->fc->iq;
 
 	spin_lock(&fiq->lock);
 	/* Check for we've sent request to interrupt this req */
@@ -365,7 +367,7 @@ static int queue_interrupt(struct fuse_req *req)
 
 static void request_wait_answer(struct fuse_req *req)
 {
-	struct fuse_conn *fc = req->fc;
+	struct fuse_conn *fc = req->fm->fc;
 	struct fuse_iqueue *fiq = &fc->iq;
 	int err;
 
@@ -411,7 +413,7 @@ static void request_wait_answer(struct fuse_req *req)
 
 static void __fuse_request_send(struct fuse_req *req)
 {
-	struct fuse_iqueue *fiq = &req->fc->iq;
+	struct fuse_iqueue *fiq = &req->fm->fc->iq;
 
 	BUG_ON(test_bit(FR_BACKGROUND, &req->flags));
 	spin_lock(&fiq->lock);
@@ -466,7 +468,7 @@ static void fuse_adjust_compat(struct fuse_conn *fc, struct fuse_args *args)
 
 static void fuse_force_creds(struct fuse_req *req)
 {
-	struct fuse_conn *fc = req->fc;
+	struct fuse_conn *fc = req->fm->fc;
 
 	req->in.h.uid = from_kuid_munged(fc->user_ns, current_fsuid());
 	req->in.h.gid = from_kgid_munged(fc->user_ns, current_fsgid());
@@ -482,14 +484,15 @@ static void fuse_args_to_req(struct fuse_req *req, struct fuse_args *args)
 		__set_bit(FR_ASYNC, &req->flags);
 }
 
-ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
+ssize_t fuse_simple_request(struct fuse_mount *fm, struct fuse_args *args)
 {
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_req *req;
 	ssize_t ret;
 
 	if (args->force) {
 		atomic_inc(&fc->num_waiting);
-		req = fuse_request_alloc(fc, GFP_KERNEL | __GFP_NOFAIL);
+		req = fuse_request_alloc(fm, GFP_KERNEL | __GFP_NOFAIL);
 
 		if (!args->nocreds)
 			fuse_force_creds(req);
@@ -498,7 +501,7 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 		__set_bit(FR_FORCE, &req->flags);
 	} else {
 		WARN_ON(args->nocreds);
-		req = fuse_get_req(fc, false);
+		req = fuse_get_req(fm, false);
 		if (IS_ERR(req))
 			return PTR_ERR(req);
 	}
@@ -522,7 +525,8 @@ ssize_t fuse_simple_request(struct fuse_conn *fc, struct fuse_args *args)
 
 static bool fuse_request_queue_background(struct fuse_req *req)
 {
-	struct fuse_conn *fc = req->fc;
+	struct fuse_mount *fm = req->fm;
+	struct fuse_conn *fc = fm->fc;
 	bool queued = false;
 
 	WARN_ON(!test_bit(FR_BACKGROUND, &req->flags));
@@ -536,9 +540,9 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 		fc->num_background++;
 		if (fc->num_background == fc->max_background)
 			fc->blocked = 1;
-		if (fc->num_background == fc->congestion_threshold && fc->sb) {
-			set_bdi_congested(fc->sb->s_bdi, BLK_RW_SYNC);
-			set_bdi_congested(fc->sb->s_bdi, BLK_RW_ASYNC);
+		if (fc->num_background == fc->congestion_threshold && fm->sb) {
+			set_bdi_congested(fm->sb->s_bdi, BLK_RW_SYNC);
+			set_bdi_congested(fm->sb->s_bdi, BLK_RW_ASYNC);
 		}
 		list_add_tail(&req->list, &fc->bg_queue);
 		flush_bg_queue(fc);
@@ -549,20 +553,20 @@ static bool fuse_request_queue_background(struct fuse_req *req)
 	return queued;
 }
 
-int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
+int fuse_simple_background(struct fuse_mount *fm, struct fuse_args *args,
 			    gfp_t gfp_flags)
 {
 	struct fuse_req *req;
 
 	if (args->force) {
 		WARN_ON(!args->nocreds);
-		req = fuse_request_alloc(fc, gfp_flags);
+		req = fuse_request_alloc(fm, gfp_flags);
 		if (!req)
 			return -ENOMEM;
 		__set_bit(FR_BACKGROUND, &req->flags);
 	} else {
 		WARN_ON(args->nocreds);
-		req = fuse_get_req(fc, true);
+		req = fuse_get_req(fm, true);
 		if (IS_ERR(req))
 			return PTR_ERR(req);
 	}
@@ -578,14 +582,14 @@ int fuse_simple_background(struct fuse_conn *fc, struct fuse_args *args,
 }
 EXPORT_SYMBOL_GPL(fuse_simple_background);
 
-static int fuse_simple_notify_reply(struct fuse_conn *fc,
+static int fuse_simple_notify_reply(struct fuse_mount *fm,
 				    struct fuse_args *args, u64 unique)
 {
 	struct fuse_req *req;
-	struct fuse_iqueue *fiq = &fc->iq;
+	struct fuse_iqueue *fiq = &fm->fc->iq;
 	int err = 0;
 
-	req = fuse_get_req(fc, false);
+	req = fuse_get_req(fm, false);
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -1425,11 +1429,8 @@ static int fuse_notify_inval_inode(struct fuse_conn *fc, unsigned int size,
 	fuse_copy_finish(cs);
 
 	down_read(&fc->killsb);
-	err = -ENOENT;
-	if (fc->sb) {
-		err = fuse_reverse_inval_inode(fc->sb, outarg.ino,
-					       outarg.off, outarg.len);
-	}
+	err = fuse_reverse_inval_inode(fc, outarg.ino,
+				       outarg.off, outarg.len);
 	up_read(&fc->killsb);
 	return err;
 
@@ -1475,9 +1476,7 @@ static int fuse_notify_inval_entry(struct fuse_conn *fc, unsigned int size,
 	buf[outarg.namelen] = 0;
 
 	down_read(&fc->killsb);
-	err = -ENOENT;
-	if (fc->sb)
-		err = fuse_reverse_inval_entry(fc->sb, outarg.parent, 0, &name);
+	err = fuse_reverse_inval_entry(fc, outarg.parent, 0, &name);
 	up_read(&fc->killsb);
 	kfree(buf);
 	return err;
@@ -1525,10 +1524,7 @@ static int fuse_notify_delete(struct fuse_conn *fc, unsigned int size,
 	buf[outarg.namelen] = 0;
 
 	down_read(&fc->killsb);
-	err = -ENOENT;
-	if (fc->sb)
-		err = fuse_reverse_inval_entry(fc->sb, outarg.parent,
-					       outarg.child, &name);
+	err = fuse_reverse_inval_entry(fc, outarg.parent, outarg.child, &name);
 	up_read(&fc->killsb);
 	kfree(buf);
 	return err;
@@ -1570,10 +1566,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 	down_read(&fc->killsb);
 
 	err = -ENOENT;
-	if (!fc->sb)
-		goto out_up_killsb;
-
-	inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
+	inode = fuse_ilookup(fc, nodeid, fuse_inode_eq, &nodeid, NULL);
 	if (!inode)
 		goto out_up_killsb;
 
@@ -1630,7 +1623,7 @@ struct fuse_retrieve_args {
 	struct fuse_notify_retrieve_in inarg;
 };
 
-static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_args *args,
+static void fuse_retrieve_end(struct fuse_mount *fm, struct fuse_args *args,
 			      int error)
 {
 	struct fuse_retrieve_args *ra =
@@ -1640,7 +1633,7 @@ static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_args *args,
 	kfree(ra);
 }
 
-static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
+static int fuse_retrieve(struct fuse_mount *fm, struct inode *inode,
 			 struct fuse_notify_retrieve_out *outarg)
 {
 	int err;
@@ -1651,6 +1644,7 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 	unsigned int offset;
 	size_t total_len = 0;
 	unsigned int num_pages;
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_retrieve_args *ra;
 	size_t args_size = sizeof(*ra);
 	struct fuse_args_pages *ap;
@@ -1712,9 +1706,9 @@ static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
 	args->in_args[0].value = &ra->inarg;
 	args->in_args[1].size = total_len;
 
-	err = fuse_simple_notify_reply(fc, args, outarg->notify_unique);
+	err = fuse_simple_notify_reply(fm, args, outarg->notify_unique);
 	if (err)
-		fuse_retrieve_end(fc, args, err);
+		fuse_retrieve_end(fm, args, err);
 
 	return err;
 }
@@ -1723,7 +1717,9 @@ static int fuse_notify_retrieve(struct fuse_conn *fc, unsigned int size,
 				struct fuse_copy_state *cs)
 {
 	struct fuse_notify_retrieve_out outarg;
+	struct fuse_mount *fm;
 	struct inode *inode;
+	u64 nodeid;
 	int err;
 
 	err = -EINVAL;
@@ -1738,14 +1734,12 @@ static int fuse_notify_retrieve(struct fuse_conn *fc, unsigned int size,
 
 	down_read(&fc->killsb);
 	err = -ENOENT;
-	if (fc->sb) {
-		u64 nodeid = outarg.nodeid;
+	nodeid = outarg.nodeid;
 
-		inode = ilookup5(fc->sb, nodeid, fuse_inode_eq, &nodeid);
-		if (inode) {
-			err = fuse_retrieve(fc, inode, &outarg);
-			iput(inode);
-		}
+	inode = fuse_ilookup(fc, nodeid, fuse_inode_eq, &nodeid, &fm);
+	if (inode) {
+		err = fuse_retrieve(fm, inode, &outarg);
+		iput(inode);
 	}
 	up_read(&fc->killsb);
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 26f028bc760b..4854b628ef61 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -196,7 +196,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 {
 	struct inode *inode;
 	struct dentry *parent;
-	struct fuse_conn *fc;
+	struct fuse_mount *fm;
 	struct fuse_inode *fi;
 	int ret;
 
@@ -218,19 +218,19 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (flags & LOOKUP_RCU)
 			goto out;
 
-		fc = get_fuse_conn(inode);
+		fm = get_fuse_mount(inode);
 
 		forget = fuse_alloc_forget();
 		ret = -ENOMEM;
 		if (!forget)
 			goto out;
 
-		attr_version = fuse_get_attr_version(fc);
+		attr_version = fuse_get_attr_version(fm->fc);
 
 		parent = dget_parent(entry);
-		fuse_lookup_init(fc, &args, get_node_id(d_inode(parent)),
+		fuse_lookup_init(fm->fc, &args, get_node_id(d_inode(parent)),
 				 &entry->d_name, &outarg);
-		ret = fuse_simple_request(fc, &args);
+		ret = fuse_simple_request(fm, &args);
 		dput(parent);
 		/* Zero nodeid is same as -ENOENT */
 		if (!ret && !outarg.nodeid)
@@ -238,7 +238,8 @@ static int fuse_dentry_revalidate(struct dentry *entry, unsigned int flags)
 		if (!ret) {
 			fi = get_fuse_inode(inode);
 			if (outarg.nodeid != get_node_id(inode)) {
-				fuse_queue_forget(fc, forget, outarg.nodeid, 1);
+				fuse_queue_forget(fm->fc, forget,
+						  outarg.nodeid, 1);
 				goto invalid;
 			}
 			spin_lock(&fi->lock);
@@ -329,7 +330,7 @@ bool fuse_invalid_attr(struct fuse_attr *attr)
 int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name,
 		     struct fuse_entry_out *outarg, struct inode **inode)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	FUSE_ARGS(args);
 	struct fuse_forget_link *forget;
 	u64 attr_version;
@@ -346,10 +347,10 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 	if (!forget)
 		goto out;
 
-	attr_version = fuse_get_attr_version(fc);
+	attr_version = fuse_get_attr_version(fm->fc);
 
-	fuse_lookup_init(fc, &args, nodeid, name, outarg);
-	err = fuse_simple_request(fc, &args);
+	fuse_lookup_init(fm->fc, &args, nodeid, name, outarg);
+	err = fuse_simple_request(fm, &args);
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
 	if (err || !outarg->nodeid)
 		goto out_put_forget;
@@ -365,7 +366,7 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, const struct qstr *name
 			   attr_version);
 	err = -ENOMEM;
 	if (!*inode) {
-		fuse_queue_forget(fc, forget, outarg->nodeid, 1);
+		fuse_queue_forget(fm->fc, forget, outarg->nodeid, 1);
 		goto out;
 	}
 	err = 0;
@@ -434,7 +435,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 {
 	int err;
 	struct inode *inode;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 	struct fuse_forget_link *forget;
 	struct fuse_create_in inarg;
@@ -452,11 +453,11 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 		goto out_err;
 
 	err = -ENOMEM;
-	ff = fuse_file_alloc(fc);
+	ff = fuse_file_alloc(fm);
 	if (!ff)
 		goto out_put_forget_req;
 
-	if (!fc->dont_mask)
+	if (!fm->fc->dont_mask)
 		mode &= ~current_umask();
 
 	flags &= ~O_NOCTTY;
@@ -477,7 +478,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	args.out_args[0].value = &outentry;
 	args.out_args[1].size = sizeof(outopen);
 	args.out_args[1].value = &outopen;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err)
 		goto out_free_ff;
 
@@ -494,7 +495,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 	if (!inode) {
 		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
 		fuse_sync_release(NULL, ff, flags);
-		fuse_queue_forget(fc, forget, outentry.nodeid, 1);
+		fuse_queue_forget(fm->fc, forget, outentry.nodeid, 1);
 		err = -ENOMEM;
 		goto out_err;
 	}
@@ -567,7 +568,7 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
 /*
  * Code shared between mknod, mkdir, symlink and link
  */
-static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
+static int create_new_entry(struct fuse_mount *fm, struct fuse_args *args,
 			    struct inode *dir, struct dentry *entry,
 			    umode_t mode)
 {
@@ -586,7 +587,7 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(outarg);
 	args->out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, args);
+	err = fuse_simple_request(fm, args);
 	if (err)
 		goto out_put_forget_req;
 
@@ -600,7 +601,7 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 	inode = fuse_iget(dir->i_sb, outarg.nodeid, outarg.generation,
 			  &outarg.attr, entry_attr_timeout(&outarg), 0);
 	if (!inode) {
-		fuse_queue_forget(fc, forget, outarg.nodeid, 1);
+		fuse_queue_forget(fm->fc, forget, outarg.nodeid, 1);
 		return -ENOMEM;
 	}
 	kfree(forget);
@@ -628,10 +629,10 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 		      dev_t rdev)
 {
 	struct fuse_mknod_in inarg;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
-	if (!fc->dont_mask)
+	if (!fm->fc->dont_mask)
 		mode &= ~current_umask();
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -644,7 +645,7 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
-	return create_new_entry(fc, &args, dir, entry, mode);
+	return create_new_entry(fm, &args, dir, entry, mode);
 }
 
 static int fuse_create(struct inode *dir, struct dentry *entry, umode_t mode,
@@ -656,10 +657,10 @@ static int fuse_create(struct inode *dir, struct dentry *entry, umode_t mode,
 static int fuse_mkdir(struct inode *dir, struct dentry *entry, umode_t mode)
 {
 	struct fuse_mkdir_in inarg;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
-	if (!fc->dont_mask)
+	if (!fm->fc->dont_mask)
 		mode &= ~current_umask();
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -671,13 +672,13 @@ static int fuse_mkdir(struct inode *dir, struct dentry *entry, umode_t mode)
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
-	return create_new_entry(fc, &args, dir, entry, S_IFDIR);
+	return create_new_entry(fm, &args, dir, entry, S_IFDIR);
 }
 
 static int fuse_symlink(struct inode *dir, struct dentry *entry,
 			const char *link)
 {
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	unsigned len = strlen(link) + 1;
 	FUSE_ARGS(args);
 
@@ -687,7 +688,7 @@ static int fuse_symlink(struct inode *dir, struct dentry *entry,
 	args.in_args[0].value = entry->d_name.name;
 	args.in_args[1].size = len;
 	args.in_args[1].value = link;
-	return create_new_entry(fc, &args, dir, entry, S_IFLNK);
+	return create_new_entry(fm, &args, dir, entry, S_IFLNK);
 }
 
 void fuse_update_ctime(struct inode *inode)
@@ -701,7 +702,7 @@ void fuse_update_ctime(struct inode *inode)
 static int fuse_unlink(struct inode *dir, struct dentry *entry)
 {
 	int err;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_UNLINK;
@@ -709,13 +710,13 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	args.in_numargs = 1;
 	args.in_args[0].size = entry->d_name.len + 1;
 	args.in_args[0].value = entry->d_name.name;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		struct inode *inode = d_inode(entry);
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
 		spin_lock(&fi->lock);
-		fi->attr_version = atomic64_inc_return(&fc->attr_version);
+		fi->attr_version = atomic64_inc_return(&fm->fc->attr_version);
 		/*
 		 * If i_nlink == 0 then unlink doesn't make sense, yet this can
 		 * happen if userspace filesystem is careless.  It would be
@@ -737,7 +738,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 {
 	int err;
-	struct fuse_conn *fc = get_fuse_conn(dir);
+	struct fuse_mount *fm = get_fuse_mount(dir);
 	FUSE_ARGS(args);
 
 	args.opcode = FUSE_RMDIR;
@@ -745,7 +746,7 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	args.in_numargs = 1;
 	args.in_args[0].size = entry->d_name.len + 1;
 	args.in_args[0].value = entry->d_name.name;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		clear_nlink(d_inode(entry));
 		fuse_dir_changed(dir);
@@ -761,7 +762,7 @@ static int fuse_rename_common(struct inode *olddir, struct dentry *oldent,
 {
 	int err;
 	struct fuse_rename2_in inarg;
-	struct fuse_conn *fc = get_fuse_conn(olddir);
+	struct fuse_mount *fm = get_fuse_mount(olddir);
 	FUSE_ARGS(args);
 
 	memset(&inarg, 0, argsize);
@@ -776,7 +777,7 @@ static int fuse_rename_common(struct inode *olddir, struct dentry *oldent,
 	args.in_args[1].value = oldent->d_name.name;
 	args.in_args[2].size = newent->d_name.len + 1;
 	args.in_args[2].value = newent->d_name.name;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		/* ctime changes */
 		fuse_invalidate_attr(d_inode(oldent));
@@ -847,7 +848,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	int err;
 	struct fuse_link_in inarg;
 	struct inode *inode = d_inode(entry);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -858,7 +859,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = newent->d_name.len + 1;
 	args.in_args[1].value = newent->d_name.name;
-	err = create_new_entry(fc, &args, newdir, newent, inode->i_mode);
+	err = create_new_entry(fm, &args, newdir, newent, inode->i_mode);
 	/* Contrary to "normal" filesystems it can happen that link
 	   makes two "logical" inodes point to the same "physical"
 	   inode.  We invalidate the attributes of the old one, so it
@@ -869,7 +870,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 		struct fuse_inode *fi = get_fuse_inode(inode);
 
 		spin_lock(&fi->lock);
-		fi->attr_version = atomic64_inc_return(&fc->attr_version);
+		fi->attr_version = atomic64_inc_return(&fm->fc->attr_version);
 		if (likely(inode->i_nlink < UINT_MAX))
 			inc_nlink(inode);
 		spin_unlock(&fi->lock);
@@ -926,11 +927,11 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	int err;
 	struct fuse_getattr_in inarg;
 	struct fuse_attr_out outarg;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	u64 attr_version;
 
-	attr_version = fuse_get_attr_version(fc);
+	attr_version = fuse_get_attr_version(fm->fc);
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
@@ -949,7 +950,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err) {
 		if (fuse_invalid_attr(&outarg.attr) ||
 		    (inode->i_mode ^ outarg.attr.mode) & S_IFMT) {
@@ -1002,7 +1003,7 @@ int fuse_update_attributes(struct inode *inode, struct file *file)
 				    STATX_BASIC_STATS & ~STATX_ATIME, 0);
 }
 
-int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
+int fuse_reverse_inval_entry(struct fuse_conn *fc, u64 parent_nodeid,
 			     u64 child_nodeid, struct qstr *name)
 {
 	int err = -ENOTDIR;
@@ -1010,7 +1011,8 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
 	struct dentry *dir;
 	struct dentry *entry;
 
-	parent = ilookup5(sb, parent_nodeid, fuse_inode_eq, &parent_nodeid);
+	parent = fuse_ilookup(fc, parent_nodeid, fuse_inode_eq, &parent_nodeid,
+			      NULL);
 	if (!parent)
 		return -ENOENT;
 
@@ -1102,14 +1104,14 @@ int fuse_allow_current_process(struct fuse_conn *fc)
 
 static int fuse_access(struct inode *inode, int mask)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_access_in inarg;
 	int err;
 
 	BUG_ON(mask & MAY_NOT_BLOCK);
 
-	if (fc->no_access)
+	if (fm->fc->no_access)
 		return 0;
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -1119,9 +1121,9 @@ static int fuse_access(struct inode *inode, int mask)
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
 	args.in_args[0].value = &inarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		fc->no_access = 1;
+		fm->fc->no_access = 1;
 		err = 0;
 	}
 	return err;
@@ -1209,7 +1211,7 @@ static int fuse_permission(struct inode *inode, int mask)
 
 static int fuse_readlink_page(struct inode *inode, struct page *page)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_page_desc desc = { .length = PAGE_SIZE - 1 };
 	struct fuse_args_pages ap = {
 		.num_pages = 1,
@@ -1226,7 +1228,7 @@ static int fuse_readlink_page(struct inode *inode, struct page *page)
 	ap.args.page_zeroing = true;
 	ap.args.out_numargs = 1;
 	ap.args.out_args[0].size = desc.length;
-	res = fuse_simple_request(fc, &ap.args);
+	res = fuse_simple_request(fm, &ap.args);
 
 	fuse_invalidate_atime(inode);
 
@@ -1454,7 +1456,7 @@ static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_args *args,
  */
 int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1465,7 +1467,7 @@ int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
 	inarg.valid = FATTR_MTIME;
 	inarg.mtime = inode->i_mtime.tv_sec;
 	inarg.mtimensec = inode->i_mtime.tv_nsec;
-	if (fc->minor >= 23) {
+	if (fm->fc->minor >= 23) {
 		inarg.valid |= FATTR_CTIME;
 		inarg.ctime = inode->i_ctime.tv_sec;
 		inarg.ctimensec = inode->i_ctime.tv_nsec;
@@ -1474,9 +1476,9 @@ int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
 		inarg.valid |= FATTR_FH;
 		inarg.fh = ff->fh;
 	}
-	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
+	fuse_setattr_fill(fm->fc, &args, inode, &inarg, &outarg);
 
-	return fuse_simple_request(fc, &args);
+	return fuse_simple_request(fm, &args);
 }
 
 /*
@@ -1491,7 +1493,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		    struct file *file)
 {
 	struct inode *inode = d_inode(dentry);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	FUSE_ARGS(args);
 	struct fuse_setattr_in inarg;
@@ -1566,7 +1569,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
 	}
 	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err) {
 		if (err == -EINTR)
 			fuse_invalidate_attr(inode);
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6611ef3269a8..c3230087b957 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -32,7 +32,7 @@ static struct page **fuse_pages_alloc(unsigned int npages, gfp_t flags,
 	return pages;
 }
 
-static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
+static int fuse_send_open(struct fuse_mount *fm, u64 nodeid, struct file *file,
 			  int opcode, struct fuse_open_out *outargp)
 {
 	struct fuse_open_in inarg;
@@ -40,7 +40,7 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
-	if (!fc->atomic_o_trunc)
+	if (!fm->fc->atomic_o_trunc)
 		inarg.flags &= ~O_TRUNC;
 	args.opcode = opcode;
 	args.nodeid = nodeid;
@@ -51,7 +51,7 @@ static int fuse_send_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 	args.out_args[0].size = sizeof(*outargp);
 	args.out_args[0].value = outargp;
 
-	return fuse_simple_request(fc, &args);
+	return fuse_simple_request(fm, &args);
 }
 
 struct fuse_release_args {
@@ -60,7 +60,7 @@ struct fuse_release_args {
 	struct inode *inode;
 };
 
-struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
+struct fuse_file *fuse_file_alloc(struct fuse_mount *fm)
 {
 	struct fuse_file *ff;
 
@@ -68,7 +68,7 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	if (unlikely(!ff))
 		return NULL;
 
-	ff->fc = fc;
+	ff->fm = fm;
 	ff->release_args = kzalloc(sizeof(*ff->release_args),
 				   GFP_KERNEL_ACCOUNT);
 	if (!ff->release_args) {
@@ -82,7 +82,7 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	RB_CLEAR_NODE(&ff->polled_node);
 	init_waitqueue_head(&ff->poll_wait);
 
-	ff->kh = atomic64_inc_return(&fc->khctr);
+	ff->kh = atomic64_inc_return(&fm->fc->khctr);
 
 	return ff;
 }
@@ -100,7 +100,7 @@ static struct fuse_file *fuse_file_get(struct fuse_file *ff)
 	return ff;
 }
 
-static void fuse_release_end(struct fuse_conn *fc, struct fuse_args *args,
+static void fuse_release_end(struct fuse_mount *fm, struct fuse_args *args,
 			     int error)
 {
 	struct fuse_release_args *ra = container_of(args, typeof(*ra), args);
@@ -114,29 +114,30 @@ static void fuse_file_put(struct fuse_file *ff, bool sync, bool isdir)
 	if (refcount_dec_and_test(&ff->count)) {
 		struct fuse_args *args = &ff->release_args->args;
 
-		if (isdir ? ff->fc->no_opendir : ff->fc->no_open) {
+		if (isdir ? ff->fm->fc->no_opendir : ff->fm->fc->no_open) {
 			/* Do nothing when client does not implement 'open' */
-			fuse_release_end(ff->fc, args, 0);
+			fuse_release_end(ff->fm, args, 0);
 		} else if (sync) {
-			fuse_simple_request(ff->fc, args);
-			fuse_release_end(ff->fc, args, 0);
+			fuse_simple_request(ff->fm, args);
+			fuse_release_end(ff->fm, args, 0);
 		} else {
 			args->end = fuse_release_end;
-			if (fuse_simple_background(ff->fc, args,
+			if (fuse_simple_background(ff->fm, args,
 						   GFP_KERNEL | __GFP_NOFAIL))
-				fuse_release_end(ff->fc, args, -ENOTCONN);
+				fuse_release_end(ff->fm, args, -ENOTCONN);
 		}
 		kfree(ff);
 	}
 }
 
-int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
+int fuse_do_open(struct fuse_mount *fm, u64 nodeid, struct file *file,
 		 bool isdir)
 {
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_file *ff;
 	int opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 
-	ff = fuse_file_alloc(fc);
+	ff = fuse_file_alloc(fm);
 	if (!ff)
 		return -ENOMEM;
 
@@ -147,7 +148,7 @@ int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		struct fuse_open_out outarg;
 		int err;
 
-		err = fuse_send_open(fc, nodeid, file, opcode, &outarg);
+		err = fuse_send_open(fm, nodeid, file, opcode, &outarg);
 		if (!err) {
 			ff->fh = outarg.fh;
 			ff->open_flags = outarg.open_flags;
@@ -216,11 +217,11 @@ void fuse_finish_open(struct inode *inode, struct file *file)
 
 int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	int err;
 	bool is_wb_truncate = (file->f_flags & O_TRUNC) &&
-			  fc->atomic_o_trunc &&
-			  fc->writeback_cache;
+			  fm->fc->atomic_o_trunc &&
+			  fm->fc->writeback_cache;
 
 	err = generic_file_open(inode, file);
 	if (err)
@@ -231,7 +232,7 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 		fuse_set_nowrite(inode);
 	}
 
-	err = fuse_do_open(fc, get_node_id(inode), file, isdir);
+	err = fuse_do_open(fm, get_node_id(inode), file, isdir);
 
 	if (!err)
 		fuse_finish_open(inode, file);
@@ -247,7 +248,7 @@ int fuse_open_common(struct inode *inode, struct file *file, bool isdir)
 static void fuse_prepare_release(struct fuse_inode *fi, struct fuse_file *ff,
 				 int flags, int opcode)
 {
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_conn *fc = ff->fm->fc;
 	struct fuse_release_args *ra = ff->release_args;
 
 	/* Inode is NULL on error path of fuse_create_open() */
@@ -285,7 +286,7 @@ void fuse_release_common(struct file *file, bool isdir)
 
 	if (ff->flock) {
 		ra->inarg.release_flags |= FUSE_RELEASE_FLOCK_UNLOCK;
-		ra->inarg.lock_owner = fuse_lock_owner_id(ff->fc,
+		ra->inarg.lock_owner = fuse_lock_owner_id(ff->fm->fc,
 							  (fl_owner_t) file);
 	}
 	/* Hold inode until release is finished */
@@ -300,7 +301,7 @@ void fuse_release_common(struct file *file, bool isdir)
 	 * synchronous RELEASE is allowed (and desirable) in this case
 	 * because the server can be trusted not to screw up.
 	 */
-	fuse_file_put(ff, ff->fc->destroy, isdir);
+	fuse_file_put(ff, ff->fm->fc->destroy, isdir);
 }
 
 static int fuse_open(struct inode *inode, struct file *file)
@@ -443,7 +444,7 @@ static void fuse_sync_writes(struct inode *inode)
 static int fuse_flush(struct file *file, fl_owner_t id)
 {
 	struct inode *inode = file_inode(file);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_file *ff = file->private_data;
 	struct fuse_flush_in inarg;
 	FUSE_ARGS(args);
@@ -465,12 +466,12 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 		return err;
 
 	err = 0;
-	if (fc->no_flush)
+	if (fm->fc->no_flush)
 		goto inval_attr_out;
 
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.fh = ff->fh;
-	inarg.lock_owner = fuse_lock_owner_id(fc, id);
+	inarg.lock_owner = fuse_lock_owner_id(fm->fc, id);
 	args.opcode = FUSE_FLUSH;
 	args.nodeid = get_node_id(inode);
 	args.in_numargs = 1;
@@ -478,9 +479,9 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	args.in_args[0].value = &inarg;
 	args.force = true;
 
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		fc->no_flush = 1;
+		fm->fc->no_flush = 1;
 		err = 0;
 	}
 
@@ -489,7 +490,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	 * In memory i_blocks is not maintained by fuse, if writeback cache is
 	 * enabled, i_blocks from cached attr may not be accurate.
 	 */
-	if (!err && fc->writeback_cache)
+	if (!err && fm->fc->writeback_cache)
 		fuse_invalidate_attr(inode);
 	return err;
 }
@@ -498,7 +499,7 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 		      int datasync, int opcode)
 {
 	struct inode *inode = file->f_mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_file *ff = file->private_data;
 	FUSE_ARGS(args);
 	struct fuse_fsync_in inarg;
@@ -511,7 +512,7 @@ int fuse_fsync_common(struct file *file, loff_t start, loff_t end,
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
 	args.in_args[0].value = &inarg;
-	return fuse_simple_request(fc, &args);
+	return fuse_simple_request(fm, &args);
 }
 
 static int fuse_fsync(struct file *file, loff_t start, loff_t end,
@@ -686,7 +687,7 @@ static void fuse_io_free(struct fuse_io_args *ia)
 	kfree(ia);
 }
 
-static void fuse_aio_complete_req(struct fuse_conn *fc, struct fuse_args *args,
+static void fuse_aio_complete_req(struct fuse_mount *fm, struct fuse_args *args,
 				  int err)
 {
 	struct fuse_io_args *ia = container_of(args, typeof(*ia), ap.args);
@@ -715,7 +716,7 @@ static void fuse_aio_complete_req(struct fuse_conn *fc, struct fuse_args *args,
 	fuse_io_free(ia);
 }
 
-static ssize_t fuse_async_req_send(struct fuse_conn *fc,
+static ssize_t fuse_async_req_send(struct fuse_mount *fm,
 				   struct fuse_io_args *ia, size_t num_bytes)
 {
 	ssize_t err;
@@ -729,9 +730,9 @@ static ssize_t fuse_async_req_send(struct fuse_conn *fc,
 
 	ia->ap.args.end = fuse_aio_complete_req;
 	ia->ap.args.may_block = io->should_dirty;
-	err = fuse_simple_background(fc, &ia->ap.args, GFP_KERNEL);
+	err = fuse_simple_background(fm, &ia->ap.args, GFP_KERNEL);
 	if (err)
-		fuse_aio_complete_req(fc, &ia->ap.args, err);
+		fuse_aio_complete_req(fm, &ia->ap.args, err);
 
 	return num_bytes;
 }
@@ -741,18 +742,18 @@ static ssize_t fuse_send_read(struct fuse_io_args *ia, loff_t pos, size_t count,
 {
 	struct file *file = ia->io->iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 
 	fuse_read_args_fill(ia, file, pos, count, FUSE_READ);
 	if (owner != NULL) {
 		ia->read.in.read_flags |= FUSE_READ_LOCKOWNER;
-		ia->read.in.lock_owner = fuse_lock_owner_id(fc, owner);
+		ia->read.in.lock_owner = fuse_lock_owner_id(fm->fc, owner);
 	}
 
 	if (ia->io->async)
-		return fuse_async_req_send(fc, ia, count);
+		return fuse_async_req_send(fm, ia, count);
 
-	return fuse_simple_request(fc, &ia->ap.args);
+	return fuse_simple_request(fm, &ia->ap.args);
 }
 
 static void fuse_read_update_size(struct inode *inode, loff_t size,
@@ -798,7 +799,7 @@ static void fuse_short_read(struct inode *inode, u64 attr_ver, size_t num_read,
 static int fuse_do_readpage(struct file *file, struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	loff_t pos = page_offset(page);
 	struct fuse_page_desc desc = { .length = PAGE_SIZE };
 	struct fuse_io_args ia = {
@@ -818,14 +819,14 @@ static int fuse_do_readpage(struct file *file, struct page *page)
 	 */
 	fuse_wait_on_page_writeback(inode, page->index);
 
-	attr_ver = fuse_get_attr_version(fc);
+	attr_ver = fuse_get_attr_version(fm->fc);
 
 	/* Don't overflow end offset */
 	if (pos + (desc.length - 1) == LLONG_MAX)
 		desc.length--;
 
 	fuse_read_args_fill(&ia, file, pos, desc.length, FUSE_READ);
-	res = fuse_simple_request(fc, &ia.ap.args);
+	res = fuse_simple_request(fm, &ia.ap.args);
 	if (res < 0)
 		return res;
 	/*
@@ -855,7 +856,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	return err;
 }
 
-static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_args *args,
+static void fuse_readpages_end(struct fuse_mount *fm, struct fuse_args *args,
 			       int err)
 {
 	int i;
@@ -899,7 +900,7 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_args *args,
 static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file)
 {
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	struct fuse_args_pages *ap = &ia->ap;
 	loff_t pos = page_offset(ap->pages[0]);
 	size_t count = ap->num_pages << PAGE_SHIFT;
@@ -918,18 +919,18 @@ static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file)
 	WARN_ON((loff_t) (pos + count) < 0);
 
 	fuse_read_args_fill(ia, file, pos, count, FUSE_READ);
-	ia->read.attr_ver = fuse_get_attr_version(fc);
-	if (fc->async_read) {
+	ia->read.attr_ver = fuse_get_attr_version(fm->fc);
+	if (fm->fc->async_read) {
 		ia->ff = fuse_file_get(ff);
 		ap->args.end = fuse_readpages_end;
-		err = fuse_simple_background(fc, &ap->args, GFP_KERNEL);
+		err = fuse_simple_background(fm, &ap->args, GFP_KERNEL);
 		if (!err)
 			return;
 	} else {
-		res = fuse_simple_request(fc, &ap->args);
+		res = fuse_simple_request(fm, &ap->args);
 		err = res < 0 ? res : 0;
 	}
-	fuse_readpages_end(fc, &ap->args, err);
+	fuse_readpages_end(fm, &ap->args, err);
 }
 
 static void fuse_readahead(struct readahead_control *rac)
@@ -1000,7 +1001,7 @@ static void fuse_write_args_fill(struct fuse_io_args *ia, struct fuse_file *ff,
 	args->opcode = FUSE_WRITE;
 	args->nodeid = ff->nodeid;
 	args->in_numargs = 2;
-	if (ff->fc->minor < 9)
+	if (ff->fm->fc->minor < 9)
 		args->in_args[0].size = FUSE_COMPAT_WRITE_IN_SIZE;
 	else
 		args->in_args[0].size = sizeof(ia->write.in);
@@ -1029,7 +1030,7 @@ static ssize_t fuse_send_write(struct fuse_io_args *ia, loff_t pos,
 	struct kiocb *iocb = ia->io->iocb;
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	struct fuse_write_in *inarg = &ia->write.in;
 	ssize_t err;
 
@@ -1037,13 +1038,13 @@ static ssize_t fuse_send_write(struct fuse_io_args *ia, loff_t pos,
 	inarg->flags = fuse_write_flags(iocb);
 	if (owner != NULL) {
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
-		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+		inarg->lock_owner = fuse_lock_owner_id(fm->fc, owner);
 	}
 
 	if (ia->io->async)
-		return fuse_async_req_send(fc, ia, count);
+		return fuse_async_req_send(fm, ia, count);
 
-	err = fuse_simple_request(fc, &ia->ap.args);
+	err = fuse_simple_request(fm, &ia->ap.args);
 	if (!err && ia->write.out.size > count)
 		err = -EIO;
 
@@ -1074,7 +1075,7 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 	struct fuse_args_pages *ap = &ia->ap;
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	unsigned int offset, i;
 	int err;
 
@@ -1084,7 +1085,7 @@ static ssize_t fuse_send_write_pages(struct fuse_io_args *ia,
 	fuse_write_args_fill(ia, ff, pos, count);
 	ia->write.in.flags = fuse_write_flags(iocb);
 
-	err = fuse_simple_request(fc, &ap->args);
+	err = fuse_simple_request(fm, &ap->args);
 	if (!err && ia->write.out.size > count)
 		err = -EIO;
 
@@ -1399,7 +1400,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *iter,
 	struct file *file = io->iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_conn *fc = ff->fm->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
 	loff_t pos = *ppos;
 	size_t count = iov_iter_count(iter);
@@ -1578,7 +1579,7 @@ static void fuse_writepage_free(struct fuse_writepage_args *wpa)
 	kfree(wpa);
 }
 
-static void fuse_writepage_finish(struct fuse_conn *fc,
+static void fuse_writepage_finish(struct fuse_mount *fm,
 				  struct fuse_writepage_args *wpa)
 {
 	struct fuse_args_pages *ap = &wpa->ia.ap;
@@ -1596,7 +1597,7 @@ static void fuse_writepage_finish(struct fuse_conn *fc,
 }
 
 /* Called under fi->lock, may release and reacquire it */
-static void fuse_send_writepage(struct fuse_conn *fc,
+static void fuse_send_writepage(struct fuse_mount *fm,
 				struct fuse_writepage_args *wpa, loff_t size)
 __releases(fi->lock)
 __acquires(fi->lock)
@@ -1622,10 +1623,10 @@ __acquires(fi->lock)
 	args->force = true;
 	args->nocreds = true;
 
-	err = fuse_simple_background(fc, args, GFP_ATOMIC);
+	err = fuse_simple_background(fm, args, GFP_ATOMIC);
 	if (err == -ENOMEM) {
 		spin_unlock(&fi->lock);
-		err = fuse_simple_background(fc, args, GFP_NOFS | __GFP_NOFAIL);
+		err = fuse_simple_background(fm, args, GFP_NOFS | __GFP_NOFAIL);
 		spin_lock(&fi->lock);
 	}
 
@@ -1638,7 +1639,7 @@ __acquires(fi->lock)
  out_free:
 	fi->writectr--;
 	rb_erase(&wpa->writepages_entry, &fi->writepages);
-	fuse_writepage_finish(fc, wpa);
+	fuse_writepage_finish(fm, wpa);
 	spin_unlock(&fi->lock);
 
 	/* After fuse_writepage_finish() aux request list is private */
@@ -1662,7 +1663,7 @@ void fuse_flush_writepages(struct inode *inode)
 __releases(fi->lock)
 __acquires(fi->lock)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
 	loff_t crop = i_size_read(inode);
 	struct fuse_writepage_args *wpa;
@@ -1671,7 +1672,7 @@ __acquires(fi->lock)
 		wpa = list_entry(fi->queued_writes.next,
 				 struct fuse_writepage_args, queue_entry);
 		list_del_init(&wpa->queue_entry);
-		fuse_send_writepage(fc, wpa, crop);
+		fuse_send_writepage(fm, wpa, crop);
 	}
 }
 
@@ -1712,7 +1713,7 @@ static void tree_insert(struct rb_root *root, struct fuse_writepage_args *wpa)
 	WARN_ON(fuse_insert_writeback(root, wpa));
 }
 
-static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_args *args,
+static void fuse_writepage_end(struct fuse_mount *fm, struct fuse_args *args,
 			       int error)
 {
 	struct fuse_writepage_args *wpa =
@@ -1724,7 +1725,7 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_args *args,
 	spin_lock(&fi->lock);
 	rb_erase(&wpa->writepages_entry, &fi->writepages);
 	while (wpa->next) {
-		struct fuse_conn *fc = get_fuse_conn(inode);
+		struct fuse_mount *fm = get_fuse_mount(inode);
 		struct fuse_write_in *inarg = &wpa->ia.write.in;
 		struct fuse_writepage_args *next = wpa->next;
 
@@ -1756,10 +1757,10 @@ static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_args *args,
 		 * no invocations of fuse_writepage_end() while we're in
 		 * fuse_set_nowrite..fuse_release_nowrite section.
 		 */
-		fuse_send_writepage(fc, next, inarg->offset + inarg->size);
+		fuse_send_writepage(fm, next, inarg->offset + inarg->size);
 	}
 	fi->writectr--;
-	fuse_writepage_finish(fc, wpa);
+	fuse_writepage_finish(fm, wpa);
 	spin_unlock(&fi->lock);
 	fuse_writepage_free(wpa);
 }
@@ -2395,7 +2396,7 @@ static void fuse_lk_fill(struct fuse_args *args, struct file *file,
 static int fuse_getlk(struct file *file, struct file_lock *fl)
 {
 	struct inode *inode = file_inode(file);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_lk_in inarg;
 	struct fuse_lk_out outarg;
@@ -2405,9 +2406,9 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err)
-		err = convert_fuse_file_lock(fc, &outarg.lk, fl);
+		err = convert_fuse_file_lock(fm->fc, &outarg.lk, fl);
 
 	return err;
 }
@@ -2415,12 +2416,12 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 {
 	struct inode *inode = file_inode(file);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_lk_in inarg;
 	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
 	struct pid *pid = fl->fl_type != F_UNLCK ? task_tgid(current) : NULL;
-	pid_t pid_nr = pid_nr_ns(pid, fc->pid_ns);
+	pid_t pid_nr = pid_nr_ns(pid, fm->fc->pid_ns);
 	int err;
 
 	if (fl->fl_lmops && fl->fl_lmops->lm_grant) {
@@ -2433,7 +2434,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 		return 0;
 
 	fuse_lk_fill(&args, file, fl, opcode, pid_nr, flock, &inarg);
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 
 	/* locking is restartable */
 	if (err == -EINTR)
@@ -2487,13 +2488,13 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_bmap_in inarg;
 	struct fuse_bmap_out outarg;
 	int err;
 
-	if (!inode->i_sb->s_bdev || fc->no_bmap)
+	if (!inode->i_sb->s_bdev || fm->fc->no_bmap)
 		return 0;
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -2507,9 +2508,9 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS)
-		fc->no_bmap = 1;
+		fm->fc->no_bmap = 1;
 
 	return err ? 0 : outarg.block;
 }
@@ -2517,7 +2518,7 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 static loff_t fuse_lseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_file *ff = file->private_data;
 	FUSE_ARGS(args);
 	struct fuse_lseek_in inarg = {
@@ -2528,7 +2529,7 @@ static loff_t fuse_lseek(struct file *file, loff_t offset, int whence)
 	struct fuse_lseek_out outarg;
 	int err;
 
-	if (fc->no_lseek)
+	if (fm->fc->no_lseek)
 		goto fallback;
 
 	args.opcode = FUSE_LSEEK;
@@ -2539,10 +2540,10 @@ static loff_t fuse_lseek(struct file *file, loff_t offset, int whence)
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err) {
 		if (err == -ENOSYS) {
-			fc->no_lseek = 1;
+			fm->fc->no_lseek = 1;
 			goto fallback;
 		}
 		return err;
@@ -2728,7 +2729,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		   unsigned int flags)
 {
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	struct fuse_ioctl_in inarg = {
 		.fh = ff->fh,
 		.cmd = cmd,
@@ -2761,12 +2762,12 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 	BUILD_BUG_ON(sizeof(struct fuse_ioctl_iovec) * FUSE_IOCTL_MAX_IOV > PAGE_SIZE);
 
 	err = -ENOMEM;
-	ap.pages = fuse_pages_alloc(fc->max_pages, GFP_KERNEL, &ap.descs);
+	ap.pages = fuse_pages_alloc(fm->fc->max_pages, GFP_KERNEL, &ap.descs);
 	iov_page = (struct iovec *) __get_free_page(GFP_KERNEL);
 	if (!ap.pages || !iov_page)
 		goto out;
 
-	fuse_page_descs_length_init(ap.descs, 0, fc->max_pages);
+	fuse_page_descs_length_init(ap.descs, 0, fm->fc->max_pages);
 
 	/*
 	 * If restricted, initialize IO parameters as encoded in @cmd.
@@ -2811,7 +2812,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 
 	/* make sure there are enough buffer pages and init request with them */
 	err = -ENOMEM;
-	if (max_pages > fc->max_pages)
+	if (max_pages > fm->fc->max_pages)
 		goto out;
 	while (ap.num_pages < max_pages) {
 		ap.pages[ap.num_pages] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
@@ -2848,7 +2849,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 	ap.args.out_pages = true;
 	ap.args.out_argvar = true;
 
-	transferred = fuse_simple_request(fc, &ap.args);
+	transferred = fuse_simple_request(fm, &ap.args);
 	err = transferred;
 	if (transferred < 0)
 		goto out;
@@ -2876,7 +2877,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 			goto out;
 
 		vaddr = kmap_atomic(ap.pages[0]);
-		err = fuse_copy_ioctl_iovec(fc, iov_page, vaddr,
+		err = fuse_copy_ioctl_iovec(fm->fc, iov_page, vaddr,
 					    transferred, in_iovs + out_iovs,
 					    (flags & FUSE_IOCTL_COMPAT) != 0);
 		kunmap_atomic(vaddr);
@@ -2886,11 +2887,11 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		in_iov = iov_page;
 		out_iov = in_iov + in_iovs;
 
-		err = fuse_verify_ioctl_iov(fc, in_iov, in_iovs);
+		err = fuse_verify_ioctl_iov(fm->fc, in_iov, in_iovs);
 		if (err)
 			goto out;
 
-		err = fuse_verify_ioctl_iov(fc, out_iov, out_iovs);
+		err = fuse_verify_ioctl_iov(fm->fc, out_iov, out_iovs);
 		if (err)
 			goto out;
 
@@ -3000,13 +3001,13 @@ static void fuse_register_polled_file(struct fuse_conn *fc,
 __poll_t fuse_file_poll(struct file *file, poll_table *wait)
 {
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	struct fuse_poll_in inarg = { .fh = ff->fh, .kh = ff->kh };
 	struct fuse_poll_out outarg;
 	FUSE_ARGS(args);
 	int err;
 
-	if (fc->no_poll)
+	if (fm->fc->no_poll)
 		return DEFAULT_POLLMASK;
 
 	poll_wait(file, &ff->poll_wait, wait);
@@ -3018,7 +3019,7 @@ __poll_t fuse_file_poll(struct file *file, poll_table *wait)
 	 */
 	if (waitqueue_active(&ff->poll_wait)) {
 		inarg.flags |= FUSE_POLL_SCHEDULE_NOTIFY;
-		fuse_register_polled_file(fc, ff);
+		fuse_register_polled_file(fm->fc, ff);
 	}
 
 	args.opcode = FUSE_POLL;
@@ -3029,12 +3030,12 @@ __poll_t fuse_file_poll(struct file *file, poll_table *wait)
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 
 	if (!err)
 		return demangle_poll(outarg.revents);
 	if (err == -ENOSYS) {
-		fc->no_poll = 1;
+		fm->fc->no_poll = 1;
 		return DEFAULT_POLLMASK;
 	}
 	return EPOLLERR;
@@ -3091,7 +3092,7 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	ssize_t ret = 0;
 	struct file *file = iocb->ki_filp;
 	struct fuse_file *ff = file->private_data;
-	bool async_dio = ff->fc->async_dio;
+	bool async_dio = ff->fm->fc->async_dio;
 	loff_t pos = 0;
 	struct inode *inode;
 	loff_t i_size;
@@ -3110,7 +3111,8 @@ fuse_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	if (async_dio && iov_iter_rw(iter) != WRITE && offset + count > i_size) {
 		if (offset >= i_size)
 			return 0;
-		iov_iter_truncate(iter, fuse_round_up(ff->fc, i_size - offset));
+		iov_iter_truncate(iter, fuse_round_up(ff->fm->fc,
+						      i_size - offset));
 		count = iov_iter_count(iter);
 	}
 
@@ -3197,7 +3199,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct fuse_conn *fc = ff->fc;
+	struct fuse_mount *fm = ff->fm;
 	FUSE_ARGS(args);
 	struct fuse_fallocate_in inarg = {
 		.fh = ff->fh,
@@ -3212,7 +3214,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
-	if (fc->no_fallocate)
+	if (fm->fc->no_fallocate)
 		return -EOPNOTSUPP;
 
 	if (lock_inode) {
@@ -3241,9 +3243,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	args.in_numargs = 1;
 	args.in_args[0].size = sizeof(inarg);
 	args.in_args[0].value = &inarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		fc->no_fallocate = 1;
+		fm->fc->no_fallocate = 1;
 		err = -EOPNOTSUPP;
 	}
 	if (err)
@@ -3253,7 +3255,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
 		bool changed = fuse_write_update_size(inode, offset + length);
 
-		if (changed && fc->writeback_cache)
+		if (changed && fm->fc->writeback_cache)
 			file_update_time(file);
 	}
 
@@ -3281,7 +3283,8 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct fuse_inode *fi_out = get_fuse_inode(inode_out);
-	struct fuse_conn *fc = ff_in->fc;
+	struct fuse_mount *fm = ff_in->fm;
+	struct fuse_conn *fc = fm->fc;
 	FUSE_ARGS(args);
 	struct fuse_copy_file_range_in inarg = {
 		.fh_in = ff_in->fh,
@@ -3350,7 +3353,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
 		fc->no_copy_file_range = 1;
 		err = -EOPNOTSUPP;
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 78226f38cb3d..3ecce4255030 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -320,16 +320,37 @@ struct inode *fuse_iget(struct super_block *sb, u64 nodeid,
 	return inode;
 }
 
-int fuse_reverse_inval_inode(struct super_block *sb, u64 nodeid,
+struct inode *fuse_ilookup(struct fuse_conn *fc, unsigned long hashval,
+			   int (*test)(struct inode *, void *),
+			   void *data, struct fuse_mount **fm)
+{
+	struct fuse_mount *fm_iter;
+	struct inode *inode;
+
+	list_for_each_entry(fm_iter, &fc->mounts, fc_entry) {
+		if (!fm_iter->sb)
+			continue;
+
+		inode = ilookup5(fm_iter->sb, hashval, test, data);
+		if (inode) {
+			if (fm)
+				*fm = fm_iter;
+			return inode;
+		}
+	}
+
+	return NULL;
+}
+
+int fuse_reverse_inval_inode(struct fuse_conn *fc, u64 nodeid,
 			     loff_t offset, loff_t len)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct fuse_inode *fi;
 	struct inode *inode;
 	pgoff_t pg_start;
 	pgoff_t pg_end;
 
-	inode = ilookup5(sb, nodeid, fuse_inode_eq, &nodeid);
+	inode = fuse_ilookup(fc, nodeid, fuse_inode_eq, &nodeid, NULL);
 	if (!inode)
 		return -ENOENT;
 
@@ -379,28 +400,31 @@ static void fuse_umount_begin(struct super_block *sb)
 		fuse_abort_conn(fc);
 }
 
-static void fuse_send_destroy(struct fuse_conn *fc)
+static void fuse_send_destroy(struct fuse_mount *fm)
 {
-	if (fc->conn_init) {
+	if (fm->fc->conn_init) {
 		FUSE_ARGS(args);
 
 		args.opcode = FUSE_DESTROY;
 		args.force = true;
 		args.nocreds = true;
-		fuse_simple_request(fc, &args);
+		fuse_simple_request(fm, &args);
 	}
 }
 
 static void fuse_put_super(struct super_block *sb)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
+	struct fuse_conn *fc = fm->fc;
 
 	mutex_lock(&fuse_mutex);
-	list_del(&fc->entry);
-	fuse_ctl_remove_conn(fc);
+	if (fm->root) {
+		list_del(&fc->entry);
+		fuse_ctl_remove_conn(fc);
+	}
 	mutex_unlock(&fuse_mutex);
 
-	fuse_conn_put(fc);
+	fuse_mount_put(fm);
 }
 
 static void convert_fuse_statfs(struct kstatfs *stbuf, struct fuse_kstatfs *attr)
@@ -420,12 +444,12 @@ static void convert_fuse_statfs(struct kstatfs *stbuf, struct fuse_kstatfs *attr
 static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	FUSE_ARGS(args);
 	struct fuse_statfs_out outarg;
 	int err;
 
-	if (!fuse_allow_current_process(fc)) {
+	if (!fuse_allow_current_process(fm->fc)) {
 		buf->f_type = FUSE_SUPER_MAGIC;
 		return 0;
 	}
@@ -437,7 +461,7 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 	args.out_numargs = 1;
 	args.out_args[0].size = sizeof(outarg);
 	args.out_args[0].value = &outarg;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (!err)
 		convert_fuse_statfs(buf, &outarg.st);
 	return err;
@@ -629,6 +653,7 @@ void fuse_conn_init(struct fuse_conn *fc, struct user_namespace *user_ns,
 	INIT_LIST_HEAD(&fc->bg_queue);
 	INIT_LIST_HEAD(&fc->entry);
 	INIT_LIST_HEAD(&fc->devices);
+	INIT_LIST_HEAD(&fc->mounts);
 	atomic_set(&fc->num_waiting, 0);
 	fc->max_background = FUSE_DEFAULT_MAX_BACKGROUND;
 	fc->congestion_threshold = FUSE_DEFAULT_CONGESTION_THRESHOLD;
@@ -666,6 +691,34 @@ struct fuse_conn *fuse_conn_get(struct fuse_conn *fc)
 }
 EXPORT_SYMBOL_GPL(fuse_conn_get);
 
+void fuse_mount_init(struct fuse_mount *fm, struct fuse_conn *fc, bool root)
+{
+	memset(fm, 0, sizeof(*fm));
+	refcount_set(&fm->count, 1);
+	fm->fc = fuse_conn_get(fc);
+	list_add_tail(&fm->fc_entry, &fc->mounts);
+	fm->root = root;
+}
+EXPORT_SYMBOL_GPL(fuse_mount_init);
+
+void fuse_mount_put(struct fuse_mount *fm)
+{
+	if (refcount_dec_and_test(&fm->count)) {
+		list_del(&fm->fc_entry);
+		if (fm->fc)
+			fuse_conn_put(fm->fc);
+		kfree(fm);
+	}
+}
+EXPORT_SYMBOL_GPL(fuse_mount_put);
+
+struct fuse_mount *fuse_mount_get(struct fuse_mount *fm)
+{
+	refcount_inc(&fm->count);
+	return fm;
+}
+EXPORT_SYMBOL_GPL(fuse_mount_get);
+
 static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 {
 	struct fuse_attr attr;
@@ -895,9 +948,10 @@ struct fuse_init_args {
 	struct fuse_init_out out;
 };
 
-static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
+static void process_init_reply(struct fuse_mount *fm, struct fuse_args *args,
 			       int error)
 {
+	struct fuse_conn *fc = fm->fc;
 	struct fuse_init_args *ia = container_of(args, typeof(*ia), args);
 	struct fuse_init_out *arg = &ia->out;
 
@@ -950,11 +1004,11 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
 			if (arg->flags & FUSE_HANDLE_KILLPRIV)
 				fc->handle_killpriv = 1;
 			if (arg->time_gran && arg->time_gran <= 1000000000)
-				fc->sb->s_time_gran = arg->time_gran;
+				fm->sb->s_time_gran = arg->time_gran;
 			if ((arg->flags & FUSE_POSIX_ACL)) {
 				fc->default_permissions = 1;
 				fc->posix_acl = 1;
-				fc->sb->s_xattr = fuse_acl_xattr_handlers;
+				fm->sb->s_xattr = fuse_acl_xattr_handlers;
 			}
 			if (arg->flags & FUSE_CACHE_SYMLINKS)
 				fc->cache_symlinks = 1;
@@ -973,8 +1027,8 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
 			fc->no_flock = 1;
 		}
 
-		fc->sb->s_bdi->ra_pages =
-				min(fc->sb->s_bdi->ra_pages, ra_pages);
+		fm->sb->s_bdi->ra_pages =
+				min(fm->sb->s_bdi->ra_pages, ra_pages);
 		fc->minor = arg->minor;
 		fc->max_write = arg->minor < 5 ? 4096 : arg->max_write;
 		fc->max_write = max_t(unsigned, 4096, fc->max_write);
@@ -986,7 +1040,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_args *args,
 	wake_up_all(&fc->blocked_waitq);
 }
 
-void fuse_send_init(struct fuse_conn *fc)
+void fuse_send_init(struct fuse_mount *fm)
 {
 	struct fuse_init_args *ia;
 
@@ -994,7 +1048,7 @@ void fuse_send_init(struct fuse_conn *fc)
 
 	ia->in.major = FUSE_KERNEL_VERSION;
 	ia->in.minor = FUSE_KERNEL_MINOR_VERSION;
-	ia->in.max_readahead = fc->sb->s_bdi->ra_pages * PAGE_SIZE;
+	ia->in.max_readahead = fm->sb->s_bdi->ra_pages * PAGE_SIZE;
 	ia->in.flags |=
 		FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_ATOMIC_O_TRUNC |
 		FUSE_EXPORT_SUPPORT | FUSE_BIG_WRITES | FUSE_DONT_MASK |
@@ -1021,8 +1075,8 @@ void fuse_send_init(struct fuse_conn *fc)
 	ia->args.nocreds = true;
 	ia->args.end = process_init_reply;
 
-	if (fuse_simple_background(fc, &ia->args, GFP_KERNEL) != 0)
-		process_init_reply(fc, &ia->args, -ENOTCONN);
+	if (fuse_simple_background(fm, &ia->args, GFP_KERNEL) != 0)
+		process_init_reply(fm, &ia->args, -ENOTCONN);
 }
 EXPORT_SYMBOL_GPL(fuse_send_init);
 
@@ -1033,7 +1087,7 @@ void fuse_free_conn(struct fuse_conn *fc)
 }
 EXPORT_SYMBOL_GPL(fuse_free_conn);
 
-static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
+static int fuse_bdi_init(struct fuse_mount *fm, struct super_block *sb)
 {
 	int err;
 	char *suffix = "";
@@ -1047,8 +1101,8 @@ static int fuse_bdi_init(struct fuse_conn *fc, struct super_block *sb)
 		bdi_put(sb->s_bdi);
 		sb->s_bdi = &noop_backing_dev_info;
 	}
-	err = super_setup_bdi_name(sb, "%u:%u%s", MAJOR(fc->dev),
-				   MINOR(fc->dev), suffix);
+	err = super_setup_bdi_name(sb, "%u:%u%s", MAJOR(fm->dev),
+				   MINOR(fm->dev), suffix);
 	if (err)
 		return err;
 
@@ -1136,7 +1190,8 @@ EXPORT_SYMBOL_GPL(fuse_dev_free);
 int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 {
 	struct fuse_dev *fud = NULL;
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
+	struct fuse_conn *fc = fm->fc;
 	struct inode *root;
 	struct dentry *root_dentry;
 	int err;
@@ -1184,9 +1239,9 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 			goto err;
 	}
 
-	fc->dev = sb->s_dev;
-	fc->sb = sb;
-	err = fuse_bdi_init(fc, sb);
+	fm->dev = sb->s_dev;
+	fm->sb = sb;
+	err = fuse_bdi_init(fm, sb);
 	if (err)
 		goto err_dev_free;
 
@@ -1247,6 +1302,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	struct file *file;
 	int err;
 	struct fuse_conn *fc;
+	struct fuse_mount *fm;
 
 	err = -EINVAL;
 	file = fget(ctx->fd);
@@ -1267,9 +1323,18 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	if (!fc)
 		goto err_fput;
 
+	fm = kmalloc(sizeof(*fm), GFP_KERNEL);
+	if (!fm) {
+		kfree(fc);
+		goto err_fput;
+	}
+
 	fuse_conn_init(fc, sb->s_user_ns, &fuse_dev_fiq_ops, NULL);
 	fc->release = fuse_free_conn;
-	sb->s_fs_info = fc;
+
+	fuse_mount_init(fm, fc, true);
+	fuse_conn_put(fc);
+	sb->s_fs_info = fm;
 
 	err = fuse_fill_super_common(sb, ctx);
 	if (err)
@@ -1280,11 +1345,11 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	 * CPUs after this
 	 */
 	fput(file);
-	fuse_send_init(get_fuse_conn_super(sb));
+	fuse_send_init(get_fuse_mount_super(sb));
 	return 0;
 
  err_put_conn:
-	fuse_conn_put(fc);
+	fuse_mount_put(fm);
 	sb->s_fs_info = NULL;
  err_fput:
 	fput(file);
@@ -1343,17 +1408,21 @@ static int fuse_init_fs_context(struct fs_context *fc)
 
 static void fuse_sb_destroy(struct super_block *sb)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
 
-	if (fc) {
-		if (fc->destroy)
-			fuse_send_destroy(fc);
+	if (fm) {
+		struct fuse_conn *fc = fm->fc;
 
-		fuse_abort_conn(fc);
-		fuse_wait_aborted(fc);
+		if (fm->root) {
+			if (fc->destroy)
+				fuse_send_destroy(fm);
+
+			fuse_abort_conn(fc);
+			fuse_wait_aborted(fc);
+		}
 
 		down_write(&fc->killsb);
-		fc->sb = NULL;
+		fm->sb = NULL;
 		up_write(&fc->killsb);
 	}
 }
diff --git a/fs/fuse/readdir.c b/fs/fuse/readdir.c
index 90e3f01bd796..3b5e91045871 100644
--- a/fs/fuse/readdir.c
+++ b/fs/fuse/readdir.c
@@ -252,7 +252,7 @@ static int fuse_direntplus_link(struct file *file,
 static void fuse_force_forget(struct file *file, u64 nodeid)
 {
 	struct inode *inode = file_inode(file);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_forget_in inarg;
 	FUSE_ARGS(args);
 
@@ -266,7 +266,7 @@ static void fuse_force_forget(struct file *file, u64 nodeid)
 	args.force = true;
 	args.noreply = true;
 
-	fuse_simple_request(fc, &args);
+	fuse_simple_request(fm, &args);
 	/* ignore errors */
 }
 
@@ -320,7 +320,7 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 	ssize_t res;
 	struct page *page;
 	struct inode *inode = file_inode(file);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	struct fuse_io_args ia = {};
 	struct fuse_args_pages *ap = &ia.ap;
 	struct fuse_page_desc desc = { .length = PAGE_SIZE };
@@ -337,7 +337,7 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 	ap->pages = &page;
 	ap->descs = &desc;
 	if (plus) {
-		attr_version = fuse_get_attr_version(fc);
+		attr_version = fuse_get_attr_version(fm->fc);
 		fuse_read_args_fill(&ia, file, ctx->pos, PAGE_SIZE,
 				    FUSE_READDIRPLUS);
 	} else {
@@ -345,7 +345,7 @@ static int fuse_readdir_uncached(struct file *file, struct dir_context *ctx)
 				    FUSE_READDIR);
 	}
 	locked = fuse_lock_inode(inode);
-	res = fuse_simple_request(fc, &ap->args);
+	res = fuse_simple_request(fm, &ap->args);
 	fuse_unlock_inode(inode, locked);
 	if (res >= 0) {
 		if (!res) {
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 9ec3e7cc18c9..3dd5a6cf6a6d 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1071,7 +1071,8 @@ static const struct fuse_iqueue_ops virtio_fs_fiq_ops = {
 
 static int virtio_fs_fill_super(struct super_block *sb)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
+	struct fuse_conn *fc = fm->fc;
 	struct virtio_fs *fs = fc->iq.priv;
 	unsigned int i;
 	int err;
@@ -1123,7 +1124,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 
 	/* Previous unmount will stop all queues. Start these again */
 	virtio_fs_start_all_queues(fs);
-	fuse_send_init(fc);
+	fuse_send_init(fm);
 	mutex_unlock(&virtio_fs_mutex);
 	return 0;
 
@@ -1136,7 +1137,8 @@ static int virtio_fs_fill_super(struct super_block *sb)
 
 static void virtio_kill_sb(struct super_block *sb)
 {
-	struct fuse_conn *fc = get_fuse_conn_super(sb);
+	struct fuse_mount *fm = get_fuse_mount_super(sb);
+	struct fuse_conn *fc = fm->fc;
 	struct virtio_fs *vfs;
 	struct virtio_fs_vq *fsvq;
 
@@ -1147,30 +1149,35 @@ static void virtio_kill_sb(struct super_block *sb)
 	vfs = fc->iq.priv;
 	fsvq = &vfs->vqs[VQ_HIPRIO];
 
-	/* Stop forget queue. Soon destroy will be sent */
-	spin_lock(&fsvq->lock);
-	fsvq->connected = false;
-	spin_unlock(&fsvq->lock);
-	virtio_fs_drain_all_queues(vfs);
+	if (fm->root) {
+		/* Stop forget queue. Soon destroy will be sent */
+		spin_lock(&fsvq->lock);
+		fsvq->connected = false;
+		spin_unlock(&fsvq->lock);
+		virtio_fs_drain_all_queues(vfs);
+	}
 
 	fuse_kill_sb_anon(sb);
 
-	/* fuse_kill_sb_anon() must have sent destroy. Stop all queues
-	 * and drain one more time and free fuse devices. Freeing fuse
-	 * devices will drop their reference on fuse_conn and that in
-	 * turn will drop its reference on virtio_fs object.
-	 */
-	virtio_fs_stop_all_queues(vfs);
-	virtio_fs_drain_all_queues(vfs);
-	virtio_fs_free_devs(vfs);
+	if (fm->root) {
+		/* fuse_kill_sb_anon() must have sent destroy. Stop all queues
+		 * and drain one more time and free fuse devices. Freeing fuse
+		 * devices will drop their reference on fuse_conn and that in
+		 * turn will drop its reference on virtio_fs object.
+		 */
+		virtio_fs_stop_all_queues(vfs);
+		virtio_fs_drain_all_queues(vfs);
+		virtio_fs_free_devs(vfs);
+	}
 }
 
 static int virtio_fs_test_super(struct super_block *sb,
 				struct fs_context *fsc)
 {
-	struct fuse_conn *fc = fsc->s_fs_info;
+	struct fuse_mount *fsc_fm = fsc->s_fs_info;
+	struct fuse_mount *sb_fm = get_fuse_mount_super(sb);
 
-	return fc->iq.priv == get_fuse_conn_super(sb)->iq.priv;
+	return fsc_fm->fc->iq.priv == sb_fm->fc->iq.priv;
 }
 
 static int virtio_fs_set_super(struct super_block *sb,
@@ -1180,7 +1187,7 @@ static int virtio_fs_set_super(struct super_block *sb,
 
 	err = get_anon_bdev(&sb->s_dev);
 	if (!err)
-		fuse_conn_get(fsc->s_fs_info);
+		fuse_mount_get(fsc->s_fs_info);
 
 	return err;
 }
@@ -1190,6 +1197,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	struct virtio_fs *fs;
 	struct super_block *sb;
 	struct fuse_conn *fc;
+	struct fuse_mount *fm;
 	int err;
 
 	/* This gets a reference on virtio_fs object. This ptr gets installed
@@ -1210,14 +1218,26 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return -ENOMEM;
 	}
 
+	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
+	if (!fm) {
+		mutex_lock(&virtio_fs_mutex);
+		virtio_fs_put(fs);
+		mutex_unlock(&virtio_fs_mutex);
+		kfree(fc);
+		return -ENOMEM;
+	}
+
 	fuse_conn_init(fc, get_user_ns(current_user_ns()), &virtio_fs_fiq_ops,
 		       fs);
 	fc->release = fuse_free_conn;
 	fc->delete_stale = true;
 
-	fsc->s_fs_info = fc;
-	sb = sget_fc(fsc, virtio_fs_test_super, virtio_fs_set_super);
+	fuse_mount_init(fm, fc, true);
 	fuse_conn_put(fc);
+
+	fsc->s_fs_info = fm;
+	sb = sget_fc(fsc, virtio_fs_test_super, virtio_fs_set_super);
+	fuse_mount_put(fm);
 	if (IS_ERR(sb))
 		return PTR_ERR(sb);
 
diff --git a/fs/fuse/xattr.c b/fs/fuse/xattr.c
index 20d052e08b3b..371bdcbc7233 100644
--- a/fs/fuse/xattr.c
+++ b/fs/fuse/xattr.c
@@ -14,12 +14,12 @@
 int fuse_setxattr(struct inode *inode, const char *name, const void *value,
 		  size_t size, int flags)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_setxattr_in inarg;
 	int err;
 
-	if (fc->no_setxattr)
+	if (fm->fc->no_setxattr)
 		return -EOPNOTSUPP;
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -34,9 +34,9 @@ int fuse_setxattr(struct inode *inode, const char *name, const void *value,
 	args.in_args[1].value = name;
 	args.in_args[2].size = size;
 	args.in_args[2].value = value;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		fc->no_setxattr = 1;
+		fm->fc->no_setxattr = 1;
 		err = -EOPNOTSUPP;
 	}
 	if (!err) {
@@ -49,13 +49,13 @@ int fuse_setxattr(struct inode *inode, const char *name, const void *value,
 ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
 		      size_t size)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_getxattr_in inarg;
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
-	if (fc->no_getxattr)
+	if (fm->fc->no_getxattr)
 		return -EOPNOTSUPP;
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -77,11 +77,11 @@ ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
 		args.out_args[0].size = sizeof(outarg);
 		args.out_args[0].value = &outarg;
 	}
-	ret = fuse_simple_request(fc, &args);
+	ret = fuse_simple_request(fm, &args);
 	if (!ret && !size)
 		ret = min_t(ssize_t, outarg.size, XATTR_SIZE_MAX);
 	if (ret == -ENOSYS) {
-		fc->no_getxattr = 1;
+		fm->fc->no_getxattr = 1;
 		ret = -EOPNOTSUPP;
 	}
 	return ret;
@@ -107,16 +107,16 @@ static int fuse_verify_xattr_list(char *list, size_t size)
 ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 {
 	struct inode *inode = d_inode(entry);
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	struct fuse_getxattr_in inarg;
 	struct fuse_getxattr_out outarg;
 	ssize_t ret;
 
-	if (!fuse_allow_current_process(fc))
+	if (!fuse_allow_current_process(fm->fc))
 		return -EACCES;
 
-	if (fc->no_listxattr)
+	if (fm->fc->no_listxattr)
 		return -EOPNOTSUPP;
 
 	memset(&inarg, 0, sizeof(inarg));
@@ -136,13 +136,13 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 		args.out_args[0].size = sizeof(outarg);
 		args.out_args[0].value = &outarg;
 	}
-	ret = fuse_simple_request(fc, &args);
+	ret = fuse_simple_request(fm, &args);
 	if (!ret && !size)
 		ret = min_t(ssize_t, outarg.size, XATTR_LIST_MAX);
 	if (ret > 0 && size)
 		ret = fuse_verify_xattr_list(list, ret);
 	if (ret == -ENOSYS) {
-		fc->no_listxattr = 1;
+		fm->fc->no_listxattr = 1;
 		ret = -EOPNOTSUPP;
 	}
 	return ret;
@@ -150,11 +150,11 @@ ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 
 int fuse_removexattr(struct inode *inode, const char *name)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_mount *fm = get_fuse_mount(inode);
 	FUSE_ARGS(args);
 	int err;
 
-	if (fc->no_removexattr)
+	if (fm->fc->no_removexattr)
 		return -EOPNOTSUPP;
 
 	args.opcode = FUSE_REMOVEXATTR;
@@ -162,9 +162,9 @@ int fuse_removexattr(struct inode *inode, const char *name)
 	args.in_numargs = 1;
 	args.in_args[0].size = strlen(name) + 1;
 	args.in_args[0].value = name;
-	err = fuse_simple_request(fc, &args);
+	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		fc->no_removexattr = 1;
+		fm->fc->no_removexattr = 1;
 		err = -EOPNOTSUPP;
 	}
 	if (!err) {
-- 
2.26.2

