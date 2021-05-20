From: Greg Kurz <groug@kaod.org>
Date: Thu, 20 May 2021 17:46:52 +0200
Message-Id: <20210520154654.1791183-4-groug@kaod.org>
In-Reply-To: <20210520154654.1791183-1-groug@kaod.org>
References: <20210520154654.1791183-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 3/5] fuse: Make fuse_fill_super_submount()
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
Cc: linux-kernel@vger.kernel.org, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>

This function used to be called from fuse_dentry_automount(). This code
was moved to fuse_get_tree_submount() in the same file since then. It
is unlikely there will ever be another user. No need to be extern in
this case.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 fs/fuse/fuse_i.h | 9 ---------
 fs/fuse/inode.c  | 4 ++--
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index d7fcf59a6a0e..e2f5c8617e0d 100644
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
  * Get the mountable root for the submount
  * @fsc: superblock configuration context
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 74e5205f203c..123b53d1c3c6 100644
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
2.26.3

