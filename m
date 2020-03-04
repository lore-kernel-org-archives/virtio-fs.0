From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed,  4 Mar 2020 11:58:33 -0500
Message-Id: <20200304165845.3081-9-vgoyal@redhat.com>
In-Reply-To: <20200304165845.3081-1-vgoyal@redhat.com>
References: <20200304165845.3081-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 08/20] fuse,
	virtiofs: Add a mount option to enable dax
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, miklos@szeredi.hu
Cc: mst@redhat.com, vgoyal@redhat.com

Add a mount option to allow using dax with virtio_fs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/fuse_i.h    |  7 ++++
 fs/fuse/inode.c     |  3 ++
 fs/fuse/virtio_fs.c | 82 +++++++++++++++++++++++++++++++++++++--------
 3 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 2cebdf6dcfd8..1fe5065a2902 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -483,10 +483,14 @@ struct fuse_fs_context {
 	bool destroy:1;
 	bool no_control:1;
 	bool no_force_umount:1;
+	bool dax:1;
 	unsigned int max_read;
 	unsigned int blksize;
 	const char *subtype;
 
+	/* DAX device, may be NULL */
+	struct dax_device *dax_dev;
+
 	/* fuse_dev pointer to fill in, should contain NULL on entry */
 	void **fudptr;
 };
@@ -758,6 +762,9 @@ struct fuse_conn {
 
 	/** List of device instances belonging to this connection */
 	struct list_head devices;
+
+	/** DAX device, non-NULL if DAX is supported */
+	struct dax_device *dax_dev;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index f160a3d47b63..84295fac4ff3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -569,6 +569,8 @@ static int fuse_show_options(struct seq_file *m, struct dentry *root)
 		seq_printf(m, ",max_read=%u", fc->max_read);
 	if (sb->s_bdev && sb->s_blocksize != FUSE_DEFAULT_BLKSIZE)
 		seq_printf(m, ",blksize=%lu", sb->s_blocksize);
+	if (fc->dax_dev)
+		seq_printf(m, ",dax");
 	return 0;
 }
 
@@ -1185,6 +1187,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	fc->destroy = ctx->destroy;
 	fc->no_control = ctx->no_control;
 	fc->no_force_umount = ctx->no_force_umount;
+	fc->dax_dev = ctx->dax_dev;
 
 	err = -ENOMEM;
 	root = fuse_get_root_inode(sb, ctx->rootmode);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 3f786a15b0d9..62cdd6817b5b 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -10,6 +10,7 @@
 #include <linux/virtio_fs.h>
 #include <linux/delay.h>
 #include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include <linux/highmem.h>
 #include "fuse_i.h"
 
@@ -65,6 +66,45 @@ struct virtio_fs_forget {
 static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 				 struct fuse_req *req, bool in_flight);
 
+enum {
+	OPT_DAX,
+};
+
+static const struct fs_parameter_spec virtio_fs_parameters[] = {
+	fsparam_flag	("dax",		OPT_DAX),
+	{}
+};
+
+static int virtio_fs_parse_param(struct fs_context *fc,
+				 struct fs_parameter *param)
+{
+	struct fs_parse_result result;
+	struct fuse_fs_context *ctx = fc->fs_private;
+	int opt;
+
+	opt = fs_parse(fc, virtio_fs_parameters, param, &result);
+	if (opt < 0)
+		return opt;
+
+	switch(opt) {
+	case OPT_DAX:
+		ctx->dax = 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void virtio_fs_free_fc(struct fs_context *fc)
+{
+	struct fuse_fs_context *ctx = fc->fs_private;
+
+	if (ctx)
+		kfree(ctx);
+}
+
 static inline struct virtio_fs_vq *vq_to_fsvq(struct virtqueue *vq)
 {
 	struct virtio_fs *fs = vq->vdev->priv;
@@ -1045,23 +1085,27 @@ static const struct fuse_iqueue_ops virtio_fs_fiq_ops = {
 	.release			= virtio_fs_fiq_release,
 };
 
-static int virtio_fs_fill_super(struct super_block *sb)
+static inline void virtio_fs_ctx_set_defaults(struct fuse_fs_context *ctx)
+{
+	ctx->rootmode = S_IFDIR;
+	ctx->default_permissions = 1;
+	ctx->allow_other = 1;
+	ctx->max_read = UINT_MAX;
+	ctx->blksize = 512;
+	ctx->destroy = true;
+	ctx->no_control = true;
+	ctx->no_force_umount = true;
+}
+
+static int virtio_fs_fill_super(struct super_block *sb, struct fs_context *fsc)
 {
 	struct fuse_conn *fc = get_fuse_conn_super(sb);
 	struct virtio_fs *fs = fc->iq.priv;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 	unsigned int i;
 	int err;
-	struct fuse_fs_context ctx = {
-		.rootmode = S_IFDIR,
-		.default_permissions = 1,
-		.allow_other = 1,
-		.max_read = UINT_MAX,
-		.blksize = 512,
-		.destroy = true,
-		.no_control = true,
-		.no_force_umount = true,
-	};
 
+	virtio_fs_ctx_set_defaults(ctx);
 	mutex_lock(&virtio_fs_mutex);
 
 	/* After holding mutex, make sure virtiofs device is still there.
@@ -1084,8 +1128,10 @@ static int virtio_fs_fill_super(struct super_block *sb)
 			goto err_free_fuse_devs;
 	}
 
-	ctx.fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
-	err = fuse_fill_super_common(sb, &ctx);
+	ctx->fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
+	if (ctx->dax)
+		ctx->dax_dev = fs->dax_dev;
+	err = fuse_fill_super_common(sb, ctx);
 	if (err < 0)
 		goto err_free_fuse_devs;
 
@@ -1200,7 +1246,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		return PTR_ERR(sb);
 
 	if (!sb->s_root) {
-		err = virtio_fs_fill_super(sb);
+		err = virtio_fs_fill_super(sb, fsc);
 		if (err) {
 			deactivate_locked_super(sb);
 			return err;
@@ -1215,11 +1261,19 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 }
 
 static const struct fs_context_operations virtio_fs_context_ops = {
+	.free		= virtio_fs_free_fc,
+	.parse_param	= virtio_fs_parse_param,
 	.get_tree	= virtio_fs_get_tree,
 };
 
 static int virtio_fs_init_fs_context(struct fs_context *fsc)
 {
+	struct fuse_fs_context *ctx;
+
+	ctx = kzalloc(sizeof(struct fuse_fs_context), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+	fsc->fs_private = ctx;
 	fsc->ops = &virtio_fs_context_ops;
 	return 0;
 }
-- 
2.20.1

