From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Mon, 25 Oct 2021 16:46:33 -0400
Message-Id: <20211025204634.2517-7-iangelak@redhat.com>
In-Reply-To: <20211025204634.2517-1-iangelak@redhat.com>
References: <20211025204634.2517-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 6/7] FUSE,
	Fsnotify: Add the fuse_fsnotify_event inode operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, linux-kernel@vger.kernel.org, jack@suse.cz, amir73il@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu, vgoyal@redhat.com

To avoid duplicate events we need to "suppress" the local events generated
by the guest kernel for FUSE inodes. To achieve this we introduce a new
inode operation "fuse_fsnotify_event". Any VFS operation on a FUSE inode
that calls the fsnotify subsystem will call this function.

Specifically, the new inode operation "fuse_fsnotify_event" is called by
the "fsnotify" wrapper function in fsnotify.c, if the inode is a FUSE
inode. In turn "fuse_fsnotify_event" will check if the remote inotify is
enabled and if yes the event will be dropped, since the local inotify
events should be "suppressed". If the remote inotify is not enabled the
event will go through as expected.

In the case where the remote inotify is enabled, FUSE will directly call
"__fsnotify" to send the remote events to user space and not the "fsnotify"
wrapper.

Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 fs/fuse/dir.c      | 27 +++++++++++++++++++++++++++
 include/linux/fs.h |  3 +++
 2 files changed, 30 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index f666aafc8d3f..d36f85bd4dda 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1831,6 +1831,30 @@ static int fuse_fsnotify_update_mark(struct inode *inode, uint32_t action,
 	return fuse_fsnotify_send_request(inode, mask, action, group);
 }
 
+static int fuse_fsnotify_event(__u32 mask, const void *data, int data_type,
+			       struct inode *dir, const struct qstr *file_name,
+			       struct inode *inode, u32 cookie)
+{
+	struct fuse_mount *fm = NULL;
+
+	if (inode != NULL)
+		fm = get_fuse_mount(inode);
+	else
+		fm = get_fuse_mount(dir);
+
+	/* Remote inotify supported. Do nothing */
+	if (!(fm->fc->no_fsnotify)) {
+		return 0;
+	/*
+	 * Remote inotify not supported. Call the __fsnotify function
+	 * directly
+	 */
+	} else {
+		return __fsnotify(mask, data, data_type, dir, file_name,
+				  inode, cookie);
+	}
+}
+
 static const struct inode_operations fuse_dir_inode_operations = {
 	.lookup		= fuse_lookup,
 	.mkdir		= fuse_mkdir,
@@ -1851,6 +1875,7 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.fileattr_get	= fuse_fileattr_get,
 	.fileattr_set	= fuse_fileattr_set,
 	.fsnotify_update = fuse_fsnotify_update_mark,
+	.fsnotify_event = fuse_fsnotify_event,
 };
 
 static const struct file_operations fuse_dir_operations = {
@@ -1874,6 +1899,7 @@ static const struct inode_operations fuse_common_inode_operations = {
 	.fileattr_get	= fuse_fileattr_get,
 	.fileattr_set	= fuse_fileattr_set,
 	.fsnotify_update = fuse_fsnotify_update_mark,
+	.fsnotify_event = fuse_fsnotify_event,
 };
 
 static const struct inode_operations fuse_symlink_inode_operations = {
@@ -1882,6 +1908,7 @@ static const struct inode_operations fuse_symlink_inode_operations = {
 	.getattr	= fuse_getattr,
 	.listxattr	= fuse_listxattr,
 	.fsnotify_update = fuse_fsnotify_update_mark,
+	.fsnotify_event = fuse_fsnotify_event,
 };
 
 void fuse_init_common(struct inode *inode)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 86bcc44e3ab8..ed6b62e2131a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2151,6 +2151,9 @@ struct inode_operations {
 	int (*fileattr_get)(struct dentry *dentry, struct fileattr *fa);
 	int (*fsnotify_update)(struct inode *inode, uint32_t action,
 			       uint64_t group, uint32_t mask);
+	int (*fsnotify_event)(__u32 mask, const void *data, int data_type,
+			      struct inode *dir, const struct qstr *file_name,
+			      struct inode *inode, u32 cookie);
 } ____cacheline_aligned;
 
 static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
-- 
2.33.0

