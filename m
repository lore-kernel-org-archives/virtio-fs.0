DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=VZbRNVKPx+MHKWsMTYMesIpjX+Sn7oV5qyS4D4WEG+g=;
	b=T3H8ZzUMlEEGiHCobSPBhWBNsVuoDLuetUpkdZ7+NJAcKeqDolb2sALrbCdxWeXSqj
	EBkY0uGHePg7Iha96qlwvd/T/VhTnRaWmIqtai8TMhT1NJp9y8zcKFU7BUr/D41kmdRk
	uh8EYkPnLFX+9jkKh6YPg8I+zPi69MmrWiglM=
From: Chirantan Ekbote <chirantan@chromium.org>
Date: Mon,  1 Jun 2020 14:32:14 +0900
Message-Id: <20200601053214.201723-1-chirantan@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] RFC: fuse: virtiofs: Call security hooks on new
	inodes
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

Add a new `init_security` field to `fuse_conn` that controls whether we
initialize security when a new inode is created.  Set this to true for
virtiofs but false for regular fuse file systems.

Calling security hooks is needed for `setfscreatecon` to work since it
is applied as part of the selinux security hook.

Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
---
 fs/fuse/dir.c       | 74 ++++++++++++++++++++++++++++++++++++++++++---
 fs/fuse/fuse_i.h    |  4 +++
 fs/fuse/inode.c     |  1 +
 fs/fuse/virtio_fs.c |  1 +
 4 files changed, 75 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index de1e2fde60bd4..b18c92a8a4c11 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -16,6 +16,9 @@
 #include <linux/xattr.h>
 #include <linux/iversion.h>
 #include <linux/posix_acl.h>
+#include <linux/security.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
 
 static void fuse_advise_use_readdirplus(struct inode *dir)
 {
@@ -135,6 +138,50 @@ static void fuse_dir_changed(struct inode *dir)
 	inode_maybe_inc_iversion(dir, false);
 }
 
+static int fuse_initxattrs(struct inode *inode, const struct xattr *xattrs,
+			   void *fs_info)
+{
+	const struct xattr *xattr;
+	int err = 0;
+	int len;
+	char *name;
+
+	for (xattr = xattrs; xattr->name != NULL; ++xattr) {
+		len = XATTR_SECURITY_PREFIX_LEN + strlen(xattr->name) + 1;
+		name = kmalloc(len, GFP_KERNEL);
+		if (!name) {
+			err = -ENOMEM;
+			break;
+		}
+
+		scnprintf(name, len, XATTR_SECURITY_PREFIX "%s", xattr->name);
+		err = fuse_setxattr(inode, name, xattr->value, xattr->value_len,
+				    0);
+		kfree(name);
+		if (err < 0)
+			break;
+	}
+
+	return err;
+}
+
+/*
+ * Initialize security on newly created inodes if supported by the filesystem.
+ */
+static int fuse_init_security(struct inode *inode, struct inode *dir,
+			      const struct qstr *qstr)
+{
+	struct fuse_conn *conn = get_fuse_conn(dir);
+	int err = 0;
+
+	if (conn->init_security) {
+		err = security_inode_init_security(inode, dir, qstr,
+						   fuse_initxattrs, NULL);
+	}
+
+	return err;
+}
+
 /**
  * Mark the attributes as stale due to an atime change.  Avoid the invalidate if
  * atime is not used.
@@ -498,7 +545,17 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry,
 		err = -ENOMEM;
 		goto out_err;
 	}
+
+	err = fuse_init_security(inode, dir, &entry->d_name);
+	if (err) {
+		flags &= ~(O_CREAT | O_EXCL | O_TRUNC);
+		fi = get_fuse_inode(inode);
+		fuse_sync_release(fi, ff, flags);
+		fuse_queue_forget(fc, forget, outentry.nodeid, 1);
+		goto out_err;
+	}
 	kfree(forget);
+
 	d_instantiate(entry, inode);
 	fuse_change_entry_timeout(entry, &outentry);
 	fuse_dir_changed(dir);
@@ -569,7 +626,7 @@ static int fuse_atomic_open(struct inode *dir, struct dentry *entry,
  */
 static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 			    struct inode *dir, struct dentry *entry,
-			    umode_t mode)
+			    umode_t mode, bool init_security)
 {
 	struct fuse_entry_out outarg;
 	struct inode *inode;
@@ -603,6 +660,13 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_args *args,
 		fuse_queue_forget(fc, forget, outarg.nodeid, 1);
 		return -ENOMEM;
 	}
+	if (init_security) {
+		err = fuse_init_security(inode, dir, &entry->d_name);
+		if (err) {
+			fuse_queue_forget(fc, forget, outarg.nodeid, 1);
+			return err;
+		}
+	}
 	kfree(forget);
 
 	d_drop(entry);
@@ -644,7 +708,7 @@ static int fuse_mknod(struct inode *dir, struct dentry *entry, umode_t mode,
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
-	return create_new_entry(fc, &args, dir, entry, mode);
+	return create_new_entry(fc, &args, dir, entry, mode, true);
 }
 
 static int fuse_create(struct inode *dir, struct dentry *entry, umode_t mode,
@@ -671,7 +735,7 @@ static int fuse_mkdir(struct inode *dir, struct dentry *entry, umode_t mode)
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = entry->d_name.len + 1;
 	args.in_args[1].value = entry->d_name.name;
-	return create_new_entry(fc, &args, dir, entry, S_IFDIR);
+	return create_new_entry(fc, &args, dir, entry, S_IFDIR, true);
 }
 
 static int fuse_symlink(struct inode *dir, struct dentry *entry,
@@ -687,7 +751,7 @@ static int fuse_symlink(struct inode *dir, struct dentry *entry,
 	args.in_args[0].value = entry->d_name.name;
 	args.in_args[1].size = len;
 	args.in_args[1].value = link;
-	return create_new_entry(fc, &args, dir, entry, S_IFLNK);
+	return create_new_entry(fc, &args, dir, entry, S_IFLNK, true);
 }
 
 void fuse_update_ctime(struct inode *inode)
@@ -858,7 +922,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	args.in_args[0].value = &inarg;
 	args.in_args[1].size = newent->d_name.len + 1;
 	args.in_args[1].value = newent->d_name.name;
-	err = create_new_entry(fc, &args, newdir, newent, inode->i_mode);
+	err = create_new_entry(fc, &args, newdir, newent, inode->i_mode, false);
 	/* Contrary to "normal" filesystems it can happen that link
 	   makes two "logical" inodes point to the same "physical"
 	   inode.  We invalidate the attributes of the old one, so it
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ca344bf714045..ed871742db584 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -482,6 +482,7 @@ struct fuse_fs_context {
 	bool no_control:1;
 	bool no_force_umount:1;
 	bool no_mount_options:1;
+	bool init_security:1;
 	unsigned int max_read;
 	unsigned int blksize;
 	const char *subtype;
@@ -719,6 +720,9 @@ struct fuse_conn {
 	/* Do not show mount options */
 	unsigned int no_mount_options:1;
 
+	/* Initialize security xattrs when creating a new inode */
+	unsigned int init_security : 1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 95d712d44ca13..ab47e73566864 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1179,6 +1179,7 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 	fc->no_control = ctx->no_control;
 	fc->no_force_umount = ctx->no_force_umount;
 	fc->no_mount_options = ctx->no_mount_options;
+	fc->init_security = ctx->init_security;
 
 	err = -ENOMEM;
 	root = fuse_get_root_inode(sb, ctx->rootmode);
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index bade747689033..ee22e9a8309df 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1051,6 +1051,7 @@ static int virtio_fs_fill_super(struct super_block *sb)
 		.no_control = true,
 		.no_force_umount = true,
 		.no_mount_options = true,
+		.init_security = true,
 	};
 
 	mutex_lock(&virtio_fs_mutex);
-- 
2.27.0.rc0.183.gde8f92d652-goog

