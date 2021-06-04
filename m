From: Greg Kurz <groug@kaod.org>
Date: Fri,  4 Jun 2021 18:11:51 +0200
Message-Id: <20210604161156.408496-3-groug@kaod.org>
In-Reply-To: <20210604161156.408496-1-groug@kaod.org>
References: <20210604161156.408496-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/7] fuse: Fix crash if superblock of
	submount gets killed early
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

As soon as fuse_dentry_automount() does up_write(&sb->s_umount), the
superblock can theoretically be killed. If this happens before the
submount was added to the &fc->mounts list, fuse_mount_remove() later
crashes in list_del_init() because it assumes the submount to be
already there.

Add the submount before dropping sb->s_umount to fix the inconsistency.
It is okay to nest fc->killsb under sb->s_umount, we already do this
on the ->kill_sb() path.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 01559061cbfb..3fd1b71e546b 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -346,15 +346,15 @@ static struct vfsmount *fuse_dentry_automount(struct path *path)
 		goto out_put_sb;
 	}
 
+	down_write(&fc->killsb);
+	list_add_tail(&fm->fc_entry, &fc->mounts);
+	up_write(&fc->killsb);
+
 	sb->s_flags |= SB_ACTIVE;
 	fsc->root = dget(sb->s_root);
 	/* We are done configuring the superblock, so unlock it */
 	up_write(&sb->s_umount);
 
-	down_write(&fc->killsb);
-	list_add_tail(&fm->fc_entry, &fc->mounts);
-	up_write(&fc->killsb);
-
 	/* Create the submount */
 	mnt = vfs_create_mount(fsc);
 	if (IS_ERR(mnt)) {
-- 
2.31.1

