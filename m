From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Aug 2019 13:37:41 -0400
Message-Id: <20190821173742.24574-13-vgoyal@redhat.com>
In-Reply-To: <20190821173742.24574-1-vgoyal@redhat.com>
References: <20190821173742.24574-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 12/13] virtio-fs: Do not provide abort interface
	in fusectl
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

virtio-fs does not support aborting requests which are being processed. That
is requests which have been sent to fuse daemon on host.

So do not provide "abort" interface for virtio-fs in fusectl.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/control.c   | 4 ++--
 fs/fuse/fuse_i.h    | 4 ++++
 fs/fuse/inode.c     | 1 +
 fs/fuse/virtio_fs.c | 1 +
 4 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index c23f6f243ad4..c4681efc5ece 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -279,8 +279,8 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 
 	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400, 1,
 				 NULL, &fuse_ctl_waiting_ops) ||
-	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200, 1,
-				 NULL, &fuse_ctl_abort_ops) ||
+	    (!fc->no_abort && !fuse_ctl_add_dentry(parent, fc, "abort",
+			S_IFREG | 0200, 1, NULL, &fuse_ctl_abort_ops)) ||
 	    !fuse_ctl_add_dentry(parent, fc, "max_background", S_IFREG | 0600,
 				 1, NULL, &fuse_conn_max_background_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "congestion_threshold",
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 73b23421b48e..25a6da6ee8c3 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -73,6 +73,7 @@ struct fuse_mount_data {
 	unsigned default_permissions:1;
 	unsigned allow_other:1;
 	unsigned destroy:1;
+	unsigned no_abort:1;
 	unsigned max_read;
 	unsigned blksize;
 
@@ -789,6 +790,9 @@ struct fuse_conn {
 	/** Does the filesystem support copy_file_range? */
 	unsigned no_copy_file_range:1;
 
+	/** Do not create abort file in fuse control fs */
+	unsigned no_abort:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index fca81c40b2d7..16bcf0f95979 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1157,6 +1157,7 @@ int fuse_fill_super_common(struct super_block *sb,
 	fc->user_id = mount_data->user_id;
 	fc->group_id = mount_data->group_id;
 	fc->max_read = max_t(unsigned, 4096, mount_data->max_read);
+	fc->no_abort = mount_data->no_abort;
 
 	/* Used by get_root_inode() */
 	sb->s_fs_info = fc;
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index ce6b76598e74..ce1de9acde84 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -886,6 +886,7 @@ static int virtio_fs_fill_super(struct super_block *sb, char *opts,
 
 	d->fudptr = (void **)&fs->vqs[VQ_REQUEST].fud;
 	d->destroy = true; /* Send destroy request on unmount */
+	d->no_abort = 1;
 	err = fuse_fill_super_common(sb, d);
 	if (err < 0)
 		goto err_free_init_req;
-- 
2.20.1

