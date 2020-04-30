Date: Thu, 30 Apr 2020 13:18:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200430171814.GA275398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [Virtio-fs] [PATCH][v2] fuse,
 virtiofs: Do not alloc/install fuse device in
 fuse_fill_super_common()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs-list <virtio-fs@redhat.com>

As of now fuse_fill_super_common() allocates and installs one fuse device.
Filesystems like virtiofs can have more than one filesystem queues and
can have one fuse device per queue. Give, fuse_fill_super_common() only
handles one device, virtiofs allocates and installes fuse devices for
all queues except one.

This makes logic little twisted and hard to understand. It probably
is better to not do any device allocation/installation in
fuse_fill_super_common() and let caller take care of it instead.

v2: Removed fuse_dev_alloc_install() call from fuse_fill_super_common().

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/fuse_i.h    |  3 ---
 fs/fuse/inode.c     | 30 ++++++++++++++----------------
 fs/fuse/virtio_fs.c |  9 +--------
 3 files changed, 15 insertions(+), 27 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ca344bf71404..df0a62f963a8 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -485,9 +485,6 @@ struct fuse_fs_context {
 	unsigned int max_read;
 	unsigned int blksize;
 	const char *subtype;
-
-	/* fuse_dev pointer to fill in, should contain NULL on entry */
-	void **fudptr;
 };
 
 /**
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 95d712d44ca1..6b38e0391c96 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1113,7 +1113,6 @@ EXPORT_SYMBOL_GPL(fuse_dev_free);
 
 int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 {
-	struct fuse_dev *fud;
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct inode *root;
 	struct dentry *root_dentry;
@@ -1155,15 +1154,11 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	if (sb->s_user_ns != &init_user_ns)
 		sb->s_xattr = fuse_no_acl_xattr_handlers;
 
-	fud = fuse_dev_alloc_install(fc);
-	if (!fud)
-		goto err;
-
 	fc->dev = sb->s_dev;
 	fc->sb = sb;
 	err = fuse_bdi_init(fc, sb);
 	if (err)
-		goto err_dev_free;
+		goto err;
 
 	/* Handle umasking inside the fuse code */
 	if (sb->s_flags & SB_POSIXACL)
@@ -1185,30 +1180,24 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	sb->s_d_op = &fuse_root_dentry_operations;
 	root_dentry = d_make_root(root);
 	if (!root_dentry)
-		goto err_dev_free;
+		goto err;
 	/* Root dentry doesn't have .d_revalidate */
 	sb->s_d_op = &fuse_dentry_operations;
 
 	mutex_lock(&fuse_mutex);
 	err = -EINVAL;
-	if (*ctx->fudptr)
-		goto err_unlock;
-
 	err = fuse_ctl_add_conn(fc);
 	if (err)
 		goto err_unlock;
 
 	list_add_tail(&fc->entry, &fuse_conn_list);
 	sb->s_root = root_dentry;
-	*ctx->fudptr = fud;
 	mutex_unlock(&fuse_mutex);
 	return 0;
 
  err_unlock:
 	mutex_unlock(&fuse_mutex);
 	dput(root_dentry);
- err_dev_free:
-	fuse_dev_free(fud);
  err:
 	return err;
 }
@@ -1220,6 +1209,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	struct file *file;
 	int err;
 	struct fuse_conn *fc;
+	struct fuse_dev *fud;
 
 	err = -EINVAL;
 	file = fget(ctx->fd);
@@ -1233,13 +1223,16 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	if ((file->f_op != &fuse_dev_operations) ||
 	    (file->f_cred->user_ns != sb->s_user_ns))
 		goto err_fput;
-	ctx->fudptr = &file->private_data;
 
-	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
 	err = -ENOMEM;
-	if (!fc)
+	fud = fuse_dev_alloc();
+	if (!fud)
 		goto err_fput;
 
+	fc = kmalloc(sizeof(*fc), GFP_KERNEL);
+	if (!fc)
+		goto err_free_dev;
+
 	fuse_conn_init(fc, sb->s_user_ns, &fuse_dev_fiq_ops, NULL);
 	fc->release = fuse_free_conn;
 	sb->s_fs_info = fc;
@@ -1247,6 +1240,9 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	err = fuse_fill_super_common(sb, ctx);
 	if (err)
 		goto err_put_conn;
+
+	fuse_dev_install(fud, fc);
+	file->private_data = fud;
 	/*
 	 * atomic_dec_and_test() in fput() provides the necessary
 	 * memory barrier for file->private_data to be visible on all
@@ -1259,6 +1255,8 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
  err_put_conn:
 	fuse_conn_put(fc);
 	sb->s_fs_info = NULL;
+ err_free_dev:
+	fuse_dev_free(fud);
  err_fput:
 	fput(file);
  err:
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index bade74768903..87a7bc0f193c 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1066,8 +1066,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 	}
 
 	err = -ENOMEM;
-	/* Allocate fuse_dev for hiprio and notification queues */
-	for (i = 0; i < VQ_REQUEST; i++) {
+	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
 
 		fsvq->fud = fuse_dev_alloc();
@@ -1075,18 +1074,12 @@ static int virtio_fs_fill_super(struct super_block *sb)
 			goto err_free_fuse_devs;
 	}
 
-	ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
 	err = fuse_fill_super_common(sb, &ctx);
 	if (err < 0)
 		goto err_free_fuse_devs;
 
-	fc = fs->vqs[VQ_REQUEST].fud->fc;
-
 	for (i = 0; i < fs->nvqs; i++) {
 		struct virtio_fs_vq *fsvq = &fs->vqs[i];
-
-		if (i == VQ_REQUEST)
-			continue; /* already initialized */
 		fuse_dev_install(fsvq->fud, fc);
 	}
 
-- 
2.25.4

