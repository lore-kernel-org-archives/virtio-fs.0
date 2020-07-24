From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 24 Jul 2020 14:38:10 -0400
Message-Id: <20200724183812.19573-4-vgoyal@redhat.com>
In-Reply-To: <20200724183812.19573-1-vgoyal@redhat.com>
References: <20200724183812.19573-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/5] fuse: Add a flag FUSE_SETATTR_KILL_PRIV
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

With handle_killpriv_v2, server needs to kill suid/sgid on truncate (setattr)
but it does not know if caller has CAP_FSETID or not. So like write, send
killpriv information in fuse_setattr_in and add a flag FUSE_SETATTR_KILL_PRIV.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/dir.c             | 11 ++++++++---
 include/uapi/linux/fuse.h | 11 ++++++++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 26f028bc760b..82747ca4c5c8 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1437,13 +1437,15 @@ void fuse_release_nowrite(struct inode *inode)
 static void fuse_setattr_fill(struct fuse_conn *fc, struct fuse_args *args,
 			      struct inode *inode,
 			      struct fuse_setattr_in *inarg_p,
-			      struct fuse_attr_out *outarg_p)
+			      struct fuse_attr_out *outarg_p,
+			      uint32_t setattr_flags)
 {
 	args->opcode = FUSE_SETATTR;
 	args->nodeid = get_node_id(inode);
 	args->in_numargs = 1;
 	args->in_args[0].size = sizeof(*inarg_p);
 	args->in_args[0].value = inarg_p;
+	inarg_p->setattr_flags = setattr_flags;
 	args->out_numargs = 1;
 	args->out_args[0].size = sizeof(*outarg_p);
 	args->out_args[0].value = outarg_p;
@@ -1474,7 +1476,7 @@ int fuse_flush_times(struct inode *inode, struct fuse_file *ff)
 		inarg.valid |= FATTR_FH;
 		inarg.fh = ff->fh;
 	}
-	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
+	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg, 0);
 
 	return fuse_simple_request(fc, &args);
 }
@@ -1501,6 +1503,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 	loff_t oldsize;
 	int err;
 	bool trust_local_cmtime = is_wb && S_ISREG(inode->i_mode);
+	uint32_t setattr_flags = 0;
 
 	if (!fc->default_permissions)
 		attr->ia_valid |= ATTR_FORCE;
@@ -1529,6 +1532,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 	if (attr->ia_valid & ATTR_SIZE) {
 		if (WARN_ON(!S_ISREG(inode->i_mode)))
 			return -EIO;
+		if (fc->handle_killpriv_v2 && !capable(CAP_FSETID))
+			setattr_flags |= FUSE_SETATTR_KILL_PRIV;
 		is_truncate = true;
 	}
 
@@ -1565,7 +1570,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		inarg.valid |= FATTR_LOCKOWNER;
 		inarg.lock_owner = fuse_lock_owner_id(fc, current->files);
 	}
-	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg);
+	fuse_setattr_fill(fc, &args, inode, &inarg, &outarg, setattr_flags);
 	err = fuse_simple_request(fc, &args);
 	if (err) {
 		if (err == -EINTR)
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 960ba8af5cf4..4b275653ac2e 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -173,6 +173,7 @@
  *  - add FUSE_SETUPMAPPING and FUSE_REMOVEMAPPING
  *  - add map_alignment to fuse_init_out, add FUSE_MAP_ALIGNMENT flag
  *  - add FUSE_HANDLE_KILLPRIV_V2
+ *  - add FUSE_SETATTR_KILL_PRIV
  */
 
 #ifndef _LINUX_FUSE_H
@@ -368,6 +369,14 @@ struct fuse_file_lock {
  */
 #define FUSE_GETATTR_FH		(1 << 0)
 
+/**
+ * Setattr flags
+ * FUSE_SETATTR_KILL_PRIV: kill suid and sgid bits. sgid should be killed
+ * only if group execute bit (S_IXGRP) is set. Meant to be used together
+ * with FUSE_HANDLE_KILLPRIV_V2.
+ */
+#define FUSE_SETATTR_KILL_PRIV	(1 << 0)
+
 /**
  * Lock flags
  */
@@ -566,7 +575,7 @@ struct fuse_link_in {
 
 struct fuse_setattr_in {
 	uint32_t	valid;
-	uint32_t	padding;
+	uint32_t	setattr_flags;
 	uint64_t	fh;
 	uint64_t	size;
 	uint64_t	lock_owner;
-- 
2.25.4

