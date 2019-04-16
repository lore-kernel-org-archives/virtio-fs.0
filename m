From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:15 +0800
Message-Id: <20190416180322.65113-3-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/9] virtio-fs: clean up dax mapping before
	aborting connection
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

fstests generic/127 reported that we failed to remove dax mapping during
umount,

-----
run fstests generic/127 at 2019-03-20 04:54:35
fuse_removemapping_one request failed -107
Failed to removemapping. offset=0x200000 len=0x200000
-----

The root cause:
virtio_kill_sb
  -> fuse_kill_sb_anon
    -> fuse_sb_destroy
      -> fuse_abort_conn #fiq->connect = 0
  -> kill_anon_super
    -> fuse_evict_inode
      -> fuse_removemapping
        -> fuse_removemapping_one
           # get -ENOTCONN, bail out

Unfortunately we have to make sure that all dax mappings linked in
per-inode interval tree are moved back to fc->busy_ranges in order to
avoid mapping leakage.

As we've tracked all dax mappings in fc->busy_ranges, this forces to free
dax mappings before aborting connection.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/fuse/fuse_i.h | 2 ++
 fs/fuse/inode.c  | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 25e1e50..2c32846 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -1202,4 +1202,6 @@ ssize_t fuse_getxattr(struct inode *inode, const char *name, void *value,
 void fuse_dax_free_mem_worker(struct work_struct *work);
 void fuse_removemapping(struct inode *inode);
 
+int fuse_dax_free_memory(struct fuse_conn *fc, unsigned long nr_to_free);
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 6e96613..22d5f6a 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1378,6 +1378,15 @@ static void fuse_sb_destroy(struct super_block *sb)
 	if (fc) {
 		fuse_send_destroy(fc);
 
+		/* cleanup dax mapping ranges before aborting connection. */
+		spin_lock(&fc->lock);
+		if (fc->nr_busy_ranges) {
+			spin_unlock(&fc->lock);
+			fuse_dax_free_memory(fc, -1UL);
+		} else {
+			spin_unlock(&fc->lock);
+		}
+
 		fuse_abort_conn(fc, false);
 		fuse_wait_aborted(fc);
 
-- 
1.8.3.1

