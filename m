From: Max Reitz <mreitz@redhat.com>
Date: Wed,  9 Sep 2020 20:46:03 +0200
Message-Id: <20200909184603.263700-10-mreitz@redhat.com>
In-Reply-To: <20200909184603.263700-1-mreitz@redhat.com>
References: <20200909184603.263700-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 9/9] fuse: Implement crossmounts
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

With this commit, FUSE servers can indicate crossmount points by setting
the respective fuse_attr.flags flag.  The inode will then be marked as
S_AUTOMOUNT, and the .d_automount implementation creates a new submount
at that location, so that the submount gets a distinct st_dev value.

Note that all submounts get a distinct superblock and a distinct st_dev
value, so for virtio-fs, even if the same filesystem is mounted more
than once on the host, none of its mount points will have the same
st_dev.  We need distinct superblocks because the superblock points to
the root node, but the different host mounts may show different trees
(e.g. due to submounts in some of them, but not in others).

Right now, this behavior is only enabled when fuse_conn.auto_submounts
is set, which is the case only for virtio-fs.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h    |  3 ++
 fs/fuse/dir.c       | 87 +++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/inode.c     |  9 +++--
 fs/fuse/virtio_fs.c |  1 +
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 2e400b479e19..49e35eb81e89 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -727,6 +727,9 @@ struct fuse_conn {
 	/* fuse_attr.flags is present and valid */
 	unsigned int attr_flags:1;
 
+	/* Auto-mount submounts announced by the server */
+	unsigned int auto_submounts:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4854b628ef61..8a253d23819c 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -10,6 +10,7 @@
 
 #include <linux/pagemap.h>
 #include <linux/file.h>
+#include <linux/fs_context.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
@@ -299,6 +300,91 @@ static int fuse_dentry_delete(const struct dentry *dentry)
 	return time_before64(fuse_dentry_time(dentry), get_jiffies_64());
 }
 
+static int fuse_submount_set_super(struct super_block *sb,
+				   struct fs_context *fsc)
+{
+	int err;
+
+	err = get_anon_bdev(&sb->s_dev);
+	if (!err)
+		fuse_mount_get(fsc->s_fs_info);
+
+	return err;
+}
+
+/*
+ * Create a fuse_mount object with a new superblock (with path->dentry
+ * as the root), and return that mount so it can be auto-mounted on
+ * @path.
+ */
+static struct vfsmount *fuse_dentry_automount(struct path *path)
+{
+	struct fs_context *fsc;
+	struct fuse_mount *parent_fm = get_fuse_mount_super(path->mnt->mnt_sb);
+	struct fuse_conn *fc = parent_fm->fc;
+	struct fuse_mount *fm;
+	struct vfsmount *mnt;
+	struct fuse_inode *mp_finode = get_fuse_inode(d_inode(path->dentry));
+	struct super_block *sb;
+	int err;
+
+	fsc = fs_context_for_submount(path->mnt->mnt_sb->s_type, path->dentry);
+	if (IS_ERR(fsc)) {
+		err = PTR_ERR(fsc);
+		goto out;
+	}
+
+	err = -ENOMEM;
+	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
+	if (!fm)
+		goto out_put_fsc;
+
+	/* Create new fuse_mount for the existing fuse_conn */
+	fuse_mount_init(fm, fc, false);
+
+	/* Get (new) superblock for this new fuse_mount */
+	fsc->s_fs_info = fm;
+	sb = sget_fc(fsc, NULL, fuse_submount_set_super);
+	fuse_mount_put(fm);
+	if (IS_ERR(sb)) {
+		err = PTR_ERR(sb);
+		goto out_put_fsc;
+	}
+
+	/* Initialize superblock, making @mp_finode its root */
+	err = fuse_fill_super_common(sb, NULL, mp_finode);
+	if (err)
+		goto out_put_sb;
+
+	sb->s_flags |= SB_ACTIVE;
+	fsc->root = dget(sb->s_root);
+	/* We are done configuring the superblock, so unlock it */
+	up_write(&sb->s_umount);
+
+	/* Create the submount */
+	mnt = vfs_create_mount(fsc);
+	if (IS_ERR(mnt)) {
+		err = PTR_ERR(mnt);
+		goto out_put_fsc;
+	}
+
+	mntget(mnt);
+
+	put_fs_context(fsc);
+	return mnt;
+
+out_put_sb:
+	/*
+	 * Only jump here when fsc->root is NULL and sb is still locked
+	 * (otherwise put_fs_context() will put the superblock)
+	 */
+	deactivate_locked_super(sb);
+out_put_fsc:
+	put_fs_context(fsc);
+out:
+	return ERR_PTR(err);
+}
+
 const struct dentry_operations fuse_dentry_operations = {
 	.d_revalidate	= fuse_dentry_revalidate,
 	.d_delete	= fuse_dentry_delete,
@@ -306,6 +392,7 @@ const struct dentry_operations fuse_dentry_operations = {
 	.d_init		= fuse_dentry_init,
 	.d_release	= fuse_dentry_release,
 #endif
+	.d_automount	= fuse_dentry_automount,
 };
 
 const struct dentry_operations fuse_root_dentry_operations = {
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 22179cf55c08..1bc6fe28e7b9 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -255,9 +255,14 @@ static void fuse_init_inode(struct inode *inode, struct fuse_attr *attr)
 	if (S_ISREG(inode->i_mode)) {
 		fuse_init_common(inode);
 		fuse_init_file_inode(inode);
-	} else if (S_ISDIR(inode->i_mode))
+	} else if (S_ISDIR(inode->i_mode)) {
+		struct fuse_conn *fc = get_fuse_conn(inode);
+
 		fuse_init_dir(inode);
-	else if (S_ISLNK(inode->i_mode))
+		if (fc->attr_flags && (attr->flags & FUSE_ATTR_SUBMOUNT) &&
+		    fc->auto_submounts)
+			inode->i_flags |= S_AUTOMOUNT;
+	} else if (S_ISLNK(inode->i_mode))
 		fuse_init_symlink(inode);
 	else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
 		 S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 761ecccb1c36..2e2e17ade1a0 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1231,6 +1231,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 		       fs);
 	fc->release = fuse_free_conn;
 	fc->delete_stale = true;
+	fc->auto_submounts = true;
 
 	fuse_mount_init(fm, fc, true);
 	fuse_conn_put(fc);
-- 
2.26.2

