From: Greg Kurz <groug@kaod.org>
Date: Fri,  4 Jun 2021 18:11:56 +0200
Message-Id: <20210604161156.408496-8-groug@kaod.org>
In-Reply-To: <20210604161156.408496-1-groug@kaod.org>
References: <20210604161156.408496-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 7/7] fuse: Make fuse_fill_super_submount()
	static
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

This function used to be called from fuse_dentry_automount(). This code
was moved to fuse_get_tree_submount() in the same file since then. It
is unlikely there will ever be another user. No need to be extern in
this case.

Signed-off-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Max Reitz <mreitz@redhat.com>
---
 fs/fuse/fuse_i.h | 9 ---------
 fs/fuse/inode.c  | 4 ++--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 862ad317bc89..1d32251a439a 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1081,15 +1081,6 @@ void fuse_send_init(struct fuse_mount *fm);
  */
 int fuse_fill_super_common(struct super_block *sb, struct fuse_fs_context *ctx);
 
-/*
- * Fill in superblock for submounts
- * @sb: partially-initialized superblock to fill in
- * @parent_fi: The fuse_inode of the parent filesystem where this submount is
- * 	       mounted
- */
-int fuse_fill_super_submount(struct super_block *sb,
-			     struct fuse_inode *parent_fi);
-
 /*
  * Remove the mount from the connection
  *
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index bec1676811d4..72d44121ea38 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1275,8 +1275,8 @@ static void fuse_sb_defaults(struct super_block *sb)
 		sb->s_xattr = fuse_no_acl_xattr_handlers;
 }
 
-int fuse_fill_super_submount(struct super_block *sb,
-			     struct fuse_inode *parent_fi)
+static int fuse_fill_super_submount(struct super_block *sb,
+				    struct fuse_inode *parent_fi)
 {
 	struct fuse_mount *fm = get_fuse_mount_super(sb);
 	struct super_block *parent_sb = parent_fi->inode.i_sb;
-- 
2.31.1

