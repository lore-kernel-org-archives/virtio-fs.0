From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:36:36 +0200
Message-Id: <20200506153637.240191-4-mreitz@redhat.com>
In-Reply-To: <20200506153529.239939-1-mreitz@redhat.com>
References: <20200506153529.239939-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 4/5] fuse: Allow fuse_fill_super_common() for
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
Cc: Max Reitz <mreitz@redhat.com>

Submounts have their own superblock, which needs to be initialized.
However, they do not have a fuse_fs_context associated with them, and
the root node's attributes should be taken from the mountpoint's node.

Extend fuse_fill_super_common() to work for submounts by making the @ctx
parameter optional, and by adding a @submount_finode parameter.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h    | 10 +++--
 fs/fuse/inode.c     | 89 +++++++++++++++++++++++++++++++++------------
 fs/fuse/virtio_fs.c |  2 +-
 3 files changed, 74 insertions(+), 27 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 3b2b47e2e966..d8528aa97386 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1015,11 +1015,15 @@ void fuse_dev_free(struct fuse_dev *fud);
 void fuse_send_init(struct fuse_mount *fm);
 
 /**
- * Fill in superblock and initialize fuse connection
+ * Fill in superblock and initialize fuse connection for root mounts.
  * @sb: partially-initialized superblock to fill in
- * @ctx: mount context
+ * @ctx: mount context (for root mounts)
+ * @submount_finode: For submounts: The fuse_inode of the parent
+ *                   filesystem where this submount is mounted
+ *		     (NULL for root mounts)
  */
-int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx);
+int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx,
+			   struct fuse_inode *submount_finode);
 
 /**
  * Disassociate fuse connection from superblock and kill the superblock
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 596504321cc7..ff30d30b3faf 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1140,9 +1140,32 @@ void fuse_dev_free(struct fuse_dev *fud)
 }
 EXPORT_SYMBOL_GPL(fuse_dev_free);
 
-int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
-{
-	struct fuse_dev *fud;
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
+{
+	struct fuse_dev *fud = NULL;
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	struct fuse_conn *fc = fm->fc;
 	struct inode *root;
@@ -1150,12 +1173,16 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	int err;
 
 	err = -EINVAL;
+	/* One must be NULL, the other must be non-NULL */
+	if (!ctx == !submount_finode)
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
@@ -1166,8 +1193,12 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
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
@@ -1185,9 +1216,11 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	if (sb->s_user_ns != &init_user_ns)
 		sb->s_xattr = fuse_no_acl_xattr_handlers;
 
-	fud = fuse_dev_alloc_install(fc);
-	if (!fud)
-		goto err;
+	if (ctx) {
+		fud = fuse_dev_alloc_install(fc);
+		if (!fud)
+			goto err;
+	}
 
 	fm->dev = sb->s_dev;
 	fm->sb = sb;
@@ -1200,18 +1233,26 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
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
+		fc->max_read = max_t(unsigned, 4096, ctx->max_read);
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
+		fuse_fill_attr_from_inode(&root_attr, submount_finode);
+		root = fuse_iget(sb, submount_finode->nodeid, 0, &root_attr, 0, 0);
+	}
 	sb->s_d_op = &fuse_root_dentry_operations;
 	root_dentry = d_make_root(root);
 	if (!root_dentry)
@@ -1221,7 +1262,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 
 	mutex_lock(&fuse_mutex);
 	err = -EINVAL;
-	if (*ctx->fudptr)
+	if (ctx && *ctx->fudptr)
 		goto err_unlock;
 
 	err = fuse_ctl_add_conn(fm);
@@ -1230,7 +1271,8 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 
 	list_add_tail(&fm->entry, &fuse_mount_list);
 	sb->s_root = root_dentry;
-	*ctx->fudptr = fud;
+	if (ctx)
+		*ctx->fudptr = fud;
 	mutex_unlock(&fuse_mutex);
 	return 0;
 
@@ -1238,7 +1280,8 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	mutex_unlock(&fuse_mutex);
 	dput(root_dentry);
  err_dev_free:
-	fuse_dev_free(fud);
+	if (fud)
+		fuse_dev_free(fud);
  err:
 	return err;
 }
@@ -1284,7 +1327,7 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	fuse_conn_put(fc);
 	sb->s_fs_info = fm;
 
-	err = fuse_fill_super_common(sb, ctx);
+	err = fuse_fill_super_common(sb, ctx, NULL);
 	if (err)
 		goto err_put_conn;
 	/*
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 492ddd34ecd9..38100f096421 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1075,7 +1075,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 	}
 
 	ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
-	err = fuse_fill_super_common(sb, &ctx);
+	err = fuse_fill_super_common(sb, &ctx, NULL);
 	if (err < 0)
 		goto err_free_fuse_devs;
 
-- 
2.26.2

