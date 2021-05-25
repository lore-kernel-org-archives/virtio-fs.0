From: Greg Kurz <groug@kaod.org>
Date: Tue, 25 May 2021 17:02:29 +0200
Message-Id: <20210525150230.157586-4-groug@kaod.org>
In-Reply-To: <20210525150230.157586-1-groug@kaod.org>
References: <20210525150230.157586-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] fuse: Call vfs_get_tree() for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>

We recently fixed an infinite loop by setting the SB_BORN flag on
submounts along with the write barrier needed by super_cache_count().
This is the job of vfs_get_tree() and FUSE shouldn't have to care
about the barrier at all.

Split out some code from fuse_dentry_automount() to a new dedicated
fuse_get_tree_submount() handler for submounts and call vfs_get_tree().

The fs_private field of the filesystem context isn't used with
submounts : hijack it to pass the FUSE inode of the mount point
down to fuse_get_tree_submount().

Finally, adapt virtiofs to use this.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c       | 58 +++++++--------------------------------------
 fs/fuse/fuse_i.h    |  6 +++++
 fs/fuse/inode.c     | 44 ++++++++++++++++++++++++++++++++++
 fs/fuse/virtio_fs.c |  3 +++
 4 files changed, 62 insertions(+), 49 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 3b0482738741..97649dcfeccd 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -309,12 +309,8 @@ static int fuse_dentry_delete(const struct dentry *dentry)
 static struct vfsmount *fuse_dentry_automount(struct path *path)
 {
 	struct fs_context *fsc;
-	struct fuse_mount *parent_fm = get_fuse_mount_super(path->mnt->mnt_sb);
-	struct fuse_conn *fc = parent_fm->fc;
-	struct fuse_mount *fm;
 	struct vfsmount *mnt;
 	struct fuse_inode *mp_fi = get_fuse_inode(d_inode(path->dentry));
-	struct super_block *sb;
 	int err;
 
 	fsc = fs_context_for_submount(path->mnt->mnt_sb->s_type, path->dentry);
@@ -323,47 +319,17 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 		goto out;
 	}
 
-	err = -ENOMEM;
-	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
-	if (!fm)
-		goto out_put_fsc;
-
-	fsc->s_fs_info = fm;
-	sb = sget_fc(fsc, NULL, set_anon_super_fc);
-	if (IS_ERR(sb)) {
-		err = PTR_ERR(sb);
-		kfree(fm);
-		goto out_put_fsc;
-	}
-	fm->fc = fuse_conn_get(fc);
-
-	/* Initialize superblock, making @mp_fi its root */
-	err = fuse_fill_super_submount(sb, mp_fi);
-	if (err) {
-		fuse_conn_put(fc);
-		kfree(fm);
-		sb->s_fs_info = NULL;
-		goto out_put_sb;
-	}
-
 	/*
-	 * FIXME: setting SB_BORN requires a write barrier for
-	 *        super_cache_count(). We should actually come
-	 *        up with a proper ->get_tree() implementation
-	 *        for submounts and call vfs_get_tree() to take
-	 *        care of the write barrier.
+	 * Hijack fsc->fs_private to pass the mount point inode to
+	 * fuse_get_tree_submount(). It *must* be NULLified afterwards
+	 * to avoid the inode pointer to be passed to kfree() when
+	 * the context gets freed.
 	 */
-	smp_wmb();
-	sb->s_flags |= SB_BORN;
-
-	sb->s_flags |= SB_ACTIVE;
-	fsc->root = dget(sb->s_root);
-	/* We are done configuring the superblock, so unlock it */
-	up_write(&sb->s_umount);
-
-	down_write(&fc->killsb);
-	list_add_tail(&fm->fc_entry, &fc->mounts);
-	up_write(&fc->killsb);
+	fsc->fs_private = mp_fi;
+	err = vfs_get_tree(fsc);
+	fsc->fs_private = NULL;
+	if (err)
+		goto out_put_fsc;
 
 	/* Create the submount */
 	mnt = vfs_create_mount(fsc);
@@ -375,12 +341,6 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 	put_fs_context(fsc);
 	return mnt;
 
-out_put_sb:
-	/*
-	 * Only jump here when fsc->root is NULL and sb is still locked
-	 * (otherwise put_fs_context() will put the superblock)
-	 */
-	deactivate_locked_super(sb);
 out_put_fsc:
 	put_fs_context(fsc);
 out:
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 7e463e220053..d7fcf59a6a0e 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1090,6 +1090,12 @@ int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx);
 int fuse_fill_super_submount(struct super_block *sb,
 			     struct fuse_inode *parent_fi);
 
+/*
+ * Get the mountable root for the submount
+ * @fsc: superblock configuration context
+ */
+int fuse_get_tree_submount(struct fs_context *fsc);
+
 /*
  * Remove the mount from the connection
  *
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 393e36b74dc4..433ca2b13046 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1313,6 +1313,50 @@ int fuse_fill_super_submount(struct super_block *sb,
 	return 0;
 }
 
+/* Filesystem context private data holds the FUSE inode of the mount point */
+int fuse_get_tree_submount(struct fs_context *fsc)
+{
+	struct fuse_mount *fm;
+	struct fuse_inode *mp_fi = fsc->fs_private;
+	struct fuse_conn *fc = get_fuse_conn(&mp_fi->inode);
+	struct super_block *sb;
+	int err;
+
+	fm = kzalloc(sizeof(struct fuse_mount), GFP_KERNEL);
+	if (!fm)
+		return -ENOMEM;
+
+	fsc->s_fs_info = fm;
+	sb = sget_fc(fsc, NULL, set_anon_super_fc);
+	if (IS_ERR(sb)) {
+		kfree(fm);
+		return PTR_ERR(sb);
+	}
+	fm->fc = fuse_conn_get(fc);
+
+	/* Initialize superblock, making @mp_fi its root */
+	err = fuse_fill_super_submount(sb, mp_fi);
+	if (err) {
+		fuse_conn_put(fc);
+		kfree(fm);
+		sb->s_fs_info = NULL;
+		deactivate_locked_super(sb);
+		return err;
+	}
+
+	sb->s_flags |= SB_ACTIVE;
+	fsc->root = dget(sb->s_root);
+	/* We are done configuring the superblock, so unlock it */
+	up_write(&sb->s_umount);
+
+	down_write(&fc->killsb);
+	list_add_tail(&fm->fc_entry, &fc->mounts);
+	up_write(&fc->killsb);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fuse_get_tree_submount);
+
 int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx)
 {
 	struct fuse_dev *fud = NULL;
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index bcb8a02e2d8b..e12e5190352c 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -1420,6 +1420,9 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 	unsigned int virtqueue_size;
 	int err = -EIO;
 
+	if (fsc->purpose == FS_CONTEXT_FOR_SUBMOUNT)
+		return fuse_get_tree_submount(fsc);
+
 	/* This gets a reference on virtio_fs object. This ptr gets installed
 	 * in fc->iq->priv. Once fuse_conn is going away, it calls ->put()
 	 * to drop the reference to this object.
-- 
2.31.1

