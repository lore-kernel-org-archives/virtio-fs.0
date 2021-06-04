From: Greg Kurz <groug@kaod.org>
Date: Fri,  4 Jun 2021 18:11:55 +0200
Message-Id: <20210604161156.408496-7-groug@kaod.org>
In-Reply-To: <20210604161156.408496-1-groug@kaod.org>
References: <20210604161156.408496-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 6/7] fuse: Switch to fc_mount() for submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

fc_mount() already handles the vfs_get_tree(), sb->s_umount
unlocking and vfs_create_mount() sequence. Using it greatly
simplifies fuse_dentry_automount().

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c | 26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b88e5785a3dd..fc9eddf7f9b2 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -311,38 +311,22 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 	struct fs_context *fsc;
 	struct vfsmount *mnt;
 	struct fuse_inode *mp_fi = get_fuse_inode(d_inode(path->dentry));
-	int err;
 
 	fsc = fs_context_for_submount(path->mnt->mnt_sb->s_type, path->dentry);
-	if (IS_ERR(fsc)) {
-		err = PTR_ERR(fsc);
-		goto out;
-	}
+	if (IS_ERR(fsc))
+		return (struct vfsmount *) fsc;
 
 	/* Pass the FUSE inode of the mount for fuse_get_tree_submount() */
 	fsc->fs_private = mp_fi;
 
-	err = vfs_get_tree(fsc);
-	if (err)
-		goto out_put_fsc;
-
-	/* We are done configuring the superblock, so unlock it */
-	up_write(&fsc->root->d_sb->s_umount);
-
 	/* Create the submount */
-	mnt = vfs_create_mount(fsc);
-	if (IS_ERR(mnt)) {
-		err = PTR_ERR(mnt);
+	mnt = fc_mount(fsc);
+	if (IS_ERR(mnt))
 		goto out_put_fsc;
-	}
 	mntget(mnt);
-	put_fs_context(fsc);
-	return mnt;
-
 out_put_fsc:
 	put_fs_context(fsc);
-out:
-	return ERR_PTR(err);
+	return mnt;
 }
 
 const struct dentry_operations fuse_dentry_operations = {
-- 
2.31.1

