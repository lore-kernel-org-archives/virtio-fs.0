From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:46:02 +0200
Message-Id: <20200909184603.263700-9-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 8/9] fuse: Allow fuse_fill_super_common() for
	submounts
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

Submounts have their own superblock, which needs to be initialized.
However, they do not have a fuse_fs_context associated with them, and
the root node's attributes should be taken from the mountpoint's node.

Extend fuse_fill_super_common() to work for submounts by making the @ctx
parameter optional, and by adding a @submount_finode parameter.

(There is a plain "unsigned" in an existing code block that is being
indented by this commit.  Extend it to "unsigned int" so checkpatch does
not complain.)

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h    |  10 ++--
 fs/fuse/inode.c     | 129 +++++++++++++++++++++++++++++++++++---------
 fs/fuse/virtio_fs.c |   2 +-
 3 files changed, 112 insertions(+), 29 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 8afe3972471a..2e400b479e19 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1030,11 +1030,15 @@ void fuse_dev_free(struct fuse_dev *fud);
 void fuse_send_init(struct fuse_mount *fm);
 
 /**
- * Fill in superblock and initialize fuse connection
+ * Fill in superblock and initialize fuse connection for root mounts.
  * @sb: partially-initialized superblock to fill in
- * @ctx: mount context
+ * @ctx: mount context (for root mounts)
+ * @submount_finode: For submounts: The fuse_inode of the parent
+ *                   filesystem where this submount is mounted
+ *                   (NULL for root mounts)
  */
-int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx);
+int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx,
+			   struct fuse_inode *submount_finode);
 
 /**
  * Disassociate fuse connection from superblock and kill the superblock
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 3ecce4255030..22179cf55c08 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1187,22 +1187,55 @@ void fuse_dev_free(struct fuse_dev *fud)
 }
 EXPORT_SYMBOL_GPL(fuse_dev_free);
 
-int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
+static void fuse_fill_attr_from_inode(struct fuse_attr *attr,
+				      const struct fuse_inode *fi)
+{
+	*attr = (struct fuse_attr){
+		.ino		= fi->inode.i_ino,
+		.size		= fi->inode.i_size,
+		.blocks		= fi->inode.i_blocks,
+		.atime		= fi->inode.i_atime.tv_sec,
+		.mtime		= fi->inode.i_mtime.tv_sec,
+		.ctime		= fi->inode.i_ctime.tv_sec,
+		.atimensec	= fi->inode.i_atime.tv_nsec,
+		.mtimensec	= fi->inode.i_mtime.tv_nsec,
+		.ctimensec	= fi->inode.i_ctime.tv_nsec,
+		.mode		= fi->inode.i_mode,
+		.nlink		= fi->inode.i_nlink,
+		.uid		= fi->inode.i_uid.val,
+		.gid		= fi->inode.i_gid.val,
+		.rdev		= fi->inode.i_rdev,
+		.blksize	= 1u << fi->inode.i_blkbits,
+	};
+}
+
+int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx,
+			   struct fuse_inode *submount_finode)
 {
 	struct fuse_dev *fud = NULL;
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
+	struct fuse_mount *fm_iter;
 	struct fuse_conn *fc = fm->fc;
+	struct backing_dev_info *fm_bdi;
 	struct inode *root;
 	struct dentry *root_dentry;
 	int err;
 
 	err = -EINVAL;
+	/* One must be NULL, the other must be non-NULL */
+	if (!ctx == !submount_finode)
+		goto err;
+
+	/* ctx must be given if and only if this is about a root mount */
+	if ((bool)ctx != fm->root)
+		goto err;
+
 	if (sb->s_flags & SB_MANDLOCK)
 		goto err;
 
 	sb->s_flags &= ~(SB_NOSEC | SB_I_VERSION);
 
-	if (ctx->is_bdev) {
+	if (ctx && ctx->is_bdev) {
 #ifdef CONFIG_BLOCK
 		err = -EINVAL;
 		if (!sb_set_blocksize(sb, ctx->blksize))
@@ -1213,8 +1246,12 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 		sb->s_blocksize_bits = PAGE_SHIFT;
 	}
 
-	sb->s_subtype = ctx->subtype;
-	ctx->subtype = NULL;
+	if (ctx) {
+		sb->s_subtype = ctx->subtype;
+		ctx->subtype = NULL;
+	} else
+		sb->s_subtype = NULL;
+
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;
 	sb->s_xattr = fuse_xattr_handlers;
@@ -1232,7 +1269,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	if (sb->s_user_ns != &init_user_ns)
 		sb->s_xattr = fuse_no_acl_xattr_handlers;
 
-	if (ctx->fudptr) {
+	if (ctx && ctx->fudptr) {
 		err = -ENOMEM;
 		fud = fuse_dev_alloc_install(fc);
 		if (!fud)
@@ -1241,27 +1278,66 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 
 	fm->dev = sb->s_dev;
 	fm->sb = sb;
-	err = fuse_bdi_init(fm, sb);
-	if (err)
-		goto err_dev_free;
+
+	/* Look for whether there already is a BDI we can share */
+	fm_bdi = sb->s_bdi;
+	sb->s_bdi = NULL;
+
+	list_for_each_entry(fm_iter, &fc->mounts, fc_entry) {
+		if (fm_iter->sb && fm_iter->sb->s_bdi) {
+			sb->s_bdi = bdi_get(fm_iter->sb->s_bdi);
+			break;
+		}
+	}
+
+	if (sb->s_bdi) {
+		if (sb->s_bdev)
+			bdi_put(fm_bdi);
+	} else {
+		/* There is no BDI to share yet */
+		sb->s_bdi = fm_bdi;
+		err = fuse_bdi_init(fm, sb);
+		if (err)
+			goto err_dev_free;
+	}
 
 	/* Handle umasking inside the fuse code */
 	if (sb->s_flags & SB_POSIXACL)
 		fc->dont_mask = 1;
 	sb->s_flags |= SB_POSIXACL;
 
-	fc->default_permissions = ctx->default_permissions;
-	fc->allow_other = ctx->allow_other;
-	fc->user_id = ctx->user_id;
-	fc->group_id = ctx->group_id;
-	fc->max_read = max_t(unsigned, 4096, ctx->max_read);
-	fc->destroy = ctx->destroy;
-	fc->no_control = ctx->no_control;
-	fc->no_force_umount = ctx->no_force_umount;
-	fc->no_mount_options = ctx->no_mount_options;
+	if (ctx) {
+		fc->default_permissions = ctx->default_permissions;
+		fc->allow_other = ctx->allow_other;
+		fc->user_id = ctx->user_id;
+		fc->group_id = ctx->group_id;
+		fc->max_read = max_t(unsigned int, 4096, ctx->max_read);
+		fc->destroy = ctx->destroy;
+		fc->no_control = ctx->no_control;
+		fc->no_force_umount = ctx->no_force_umount;
+		fc->no_mount_options = ctx->no_mount_options;
+	}
 
 	err = -ENOMEM;
-	root = fuse_get_root_inode(sb, ctx->rootmode);
+	if (ctx) {
+		root = fuse_get_root_inode(sb, ctx->rootmode);
+	} else {
+		struct fuse_attr root_attr;
+		struct fuse_inode *root_fi;
+
+		fuse_fill_attr_from_inode(&root_attr, submount_finode);
+		root = fuse_iget(sb, submount_finode->nodeid, 0, &root_attr, 0, 0);
+
+		/*
+		 * This inode is just a duplicate, so it is not looked up and
+		 * its nlookup should not be incremented.  fuse_iget() does
+		 * that, though, so undo it here.
+		 */
+		root_fi = get_fuse_inode(root);
+		spin_lock(&root_fi->lock);
+		root_fi->nlookup--;
+		spin_unlock(&root_fi->lock);
+	}
 	sb->s_d_op = &fuse_root_dentry_operations;
 	root_dentry = d_make_root(root);
 	if (!root_dentry)
@@ -1271,16 +1347,19 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 
 	mutex_lock(&fuse_mutex);
 	err = -EINVAL;
-	if (ctx->fudptr && *ctx->fudptr)
+	if (ctx && ctx->fudptr && *ctx->fudptr)
 		goto err_unlock;
 
-	err = fuse_ctl_add_conn(fc);
-	if (err)
-		goto err_unlock;
+	if (ctx) {
+		err = fuse_ctl_add_conn(fc);
+		if (err)
+			goto err_unlock;
+
+		list_add_tail(&fc->entry, &fuse_conn_list);
+	}
 
-	list_add_tail(&fc->entry, &fuse_conn_list);
 	sb->s_root = root_dentry;
-	if (ctx->fudptr)
+	if (ctx && ctx->fudptr)
 		*ctx->fudptr = fud;
 	mutex_unlock(&fuse_mutex);
 	return 0;
@@ -1336,7 +1415,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	fuse_conn_put(fc);
 	sb->s_fs_info = fm;
 
-	err = fuse_fill_super_common(sb, ctx);
+	err = fuse_fill_super_common(sb, ctx, NULL);
 	if (err)
 		goto err_put_conn;
 	/*
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 3dd5a6cf6a6d..761ecccb1c36 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1112,7 +1112,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 
 	/* virtiofs allocates and installs its own fuse devices */
 	ctx.fudptr = NULL;
-	err = fuse_fill_super_common(sb, &ctx);
+	err = fuse_fill_super_common(sb, &ctx, NULL);
 	if (err < 0)
 		goto err_free_fuse_devs;
 
-- 
2.26.2

