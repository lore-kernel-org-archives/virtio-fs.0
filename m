From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Tue,  7 May 2019 13:58:11 +0800
Message-Id: <1557208691-43817-3-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1557208691-43817-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 2/2] virtiofs: add dmap flags to differentiate
	write mapping from read mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

There're 2 problems in dax rw path which were found by [1][2],

a) setupmapping always sends a RW mapping message to virtiofs daemon side
no matter it's doing reads or writes, the end result is that guest reads
on a mapping will cause a write page fault on host, which is unnecessary.

b) After a successful setupmapping, it doesn't guarantee the following
writes can land on host, e.g. page fault on host may fail because of
ENOSPC.

This is trying to solve the problems by
a) marking a dmap as RO or RW to indicate it's being used for reads or
   writes,
b) setting up a RO dmap for reads
c) setting up a RW dmap for writes
d) using an existing dmap for reads if it's availalbe in the interval tree
e) converting an existing dmap from RO to RW for writes if it's available
   in the interval tree

The downside of the above approach is write amplification, i.e. even if a
4k write is only made, setupmapping [0, 2M) will do a fallocate [0, 2M)
against the mmap'd file on host fs (fallocate will use FALLOC_FL_KEEP_SIZE
though), this is because some following writes landing on [4k, 2m) are
possible and having no space for [4k, 2m) can end up with guest hanging
forever, which is something we can't afford in real world.

w/o:
- reproducer[1] in guest will hang on dax_copy_{from,to}_iter because
  of write page fault on host fs getting ENOSPC,
- reproducer[2] in guest will hang on dax_copy_{from,to}_iter because
  of write page fault on host fs getting ENOSPC,

w/:
- reproducer[1] can read all 100G as they're just page cache on host fs.
- reproducer[2] can get an early ENOSPC error.

[1]:
mount -odax,tag=myvirt test /mnt/virtiofs
truncate -s 100G /mnt/virtiofs/foobar
od -x /mnt/virtiofs/foobar

[2]
mount -odax,tag=myvirt test /mnt/virtiofs
truncate -s 100G /mnt/virtiofs/foobar
xfs_io -c "pwrite 0 100G" /mnt/virtiofs/foobar

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 fs/fuse/file.c   | 64 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h |  3 +++
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 6f403c8..7362aab 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -250,9 +250,9 @@ static void free_dax_mapping(struct fuse_conn *fc,
 }
 
 /* offset passed in should be aligned to FUSE_DAX_MEM_RANGE_SZ */
-static int fuse_setup_one_mapping(struct inode *inode,
+static int __fuse_setup_one_mapping(struct inode *inode,
 				  struct file *file, loff_t offset, unsigned flags,
-				  struct fuse_dax_mapping *dmap)
+				    struct fuse_dax_mapping *dmap, bool mkwrite)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
@@ -299,12 +299,19 @@ static int fuse_setup_one_mapping(struct inode *inode,
 	args.in.args[0].value = &inarg;
 	err = fuse_simple_request(fc, &args);
 	if (err < 0) {
-		printk(KERN_ERR "%s request failed at mem_offset=0x%llx %zd\n",
-				 __func__, dmap->window_offset, err);
+		printk(KERN_ERR "%s request failed at mem_offset=0x%llx %zd mkwrite=%d\n",
+		       __func__, dmap->window_offset, err, mkwrite);
 		return err;
 	}
 
-	pr_debug("fuse_setup_one_mapping() succeeded. offset=0x%llx err=%zd\n", offset, err);
+	pr_debug("%s succeeded. offset=0x%llx err=%zd mkwrite=%d\n",
+		 __func__, offset, err, mkwrite);
+
+	/* We only want to flip an existing dmap's flags. */
+	if (mkwrite) {
+		dmap->flags = IOMAP_WRITE;
+		return 0;
+	}
 
 	/*
 	 * We don't take a refernce on inode. inode is valid right now and
@@ -317,6 +324,8 @@ static int fuse_setup_one_mapping(struct inode *inode,
 	dmap->inode = inode;
 	dmap->start = offset;
 	dmap->end = offset + FUSE_DAX_MEM_RANGE_SZ - 1;
+	dmap->flags = (flags & IOMAP_WRITE) ? IOMAP_WRITE : 0;
+
 	/* Protected by fi->i_dmap_sem */
 	fuse_dax_interval_tree_insert(dmap, &fi->dmap_tree);
 	fi->nr_dmaps++;
@@ -327,6 +336,20 @@ static int fuse_setup_one_mapping(struct inode *inode,
 	return 0;
 }
 
+static int fuse_setup_one_mapping(struct inode *inode, struct file *file,
+				  loff_t offset, unsigned flags,
+				  struct fuse_dax_mapping *dmap)
+{
+	return __fuse_setup_one_mapping(inode, file, offset, flags, dmap, false);
+}
+
+static int fuse_mkwrite_one_mapping(struct inode *inode, struct file *file,
+				    loff_t offset, unsigned flags,
+				    struct fuse_dax_mapping *dmap)
+{
+	return __fuse_setup_one_mapping(inode, file, offset, flags, dmap, true);
+}
+
 static int fuse_removemapping_one(struct inode *inode,
 					struct fuse_dax_mapping *dmap)
 {
@@ -1765,6 +1788,16 @@ static void fuse_fill_iomap(struct inode *inode, loff_t pos, loff_t length,
 	}
 }
 
+static bool dmap_match(struct fuse_dax_mapping *dmap, unsigned flags)
+{
+	if (!(flags & IOMAP_WRITE))
+		return true;
+
+	if (dmap->flags & IOMAP_WRITE)
+		return true;
+	return false;
+}
+
 /* This is just for DAX and the mapping is ephemeral, do not use it for other
  * purposes since there is no block device with a permanent mapping.
  */
@@ -1804,7 +1837,7 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 	down_read(&fi->i_dmap_sem);
 	dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos, pos);
 
-	if (dmap) {
+	if (dmap && dmap_match(dmap, flags)) {
 		fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
 		up_read(&fi->i_dmap_sem);
 		return 0;
@@ -1846,12 +1879,27 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		dmap = fuse_dax_interval_tree_iter_first(&fi->dmap_tree, pos,
 							pos);
 		if (dmap) {
-			fuse_fill_iomap(inode, pos, length, iomap, dmap, flags);
+			if (dmap_match(dmap, flags)) {
+				ret = 0;
+			} else {
+				/* switch to IOMAP_WRITE */
+				ret = fuse_mkwrite_one_mapping(inode, NULL,
+					ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
+							       flags, dmap);
+				if (ret < 0) {
+					pr_err("fuse_mkwrite_one_mapping failed err=%d, pos=0x%llx\n",
+					       ret, pos);
+				}
+			}
+			if (!ret)
+				fuse_fill_iomap(inode, pos, length, iomap,
+						dmap, flags);
 			free_dax_mapping(fc, alloc_dmap);
 			up_write(&fi->i_dmap_sem);
-			return 0;
+			return ret;
 		}
 
+		/* !dmap case */
 		/* Setup one mapping */
 		ret = fuse_setup_one_mapping(inode, NULL,
 					ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index c492426..346689d 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -138,6 +138,9 @@ struct fuse_dax_mapping {
 
        /** Length of mapping, in bytes */
        loff_t length;
+
+	/* indicate if the mapping is set up for write purpose */
+	unsigned flags;
 };
 
 /** FUSE inode */
-- 
1.8.3.1

