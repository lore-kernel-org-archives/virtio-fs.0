From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 26 Jul 2019 11:49:46 -0400
Message-Id: <20190726154948.28540-2-vgoyal@redhat.com>
In-Reply-To: <20190726154948.28540-1-vgoyal@redhat.com>
References: <20190726154948.28540-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/3] fuse: Get rid of file parameter from setup
	mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

There is only one caller of fuse_setup_one_mapping() and that passes file
argument as NULL. So get rid of this parameter as there are no callers.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/fuse/file.c | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index fc40e0f44578..93f8e62e2b5b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -264,41 +264,26 @@ static void dmap_add_to_free_pool(struct fuse_conn *fc,
 }
 
 /* offset passed in should be aligned to FUSE_DAX_MEM_RANGE_SZ */
-static int fuse_setup_one_mapping(struct inode *inode,
-				struct file *file, loff_t offset,
-				struct fuse_dax_mapping *dmap)
+static int fuse_setup_one_mapping(struct inode *inode, loff_t offset,
+				  struct fuse_dax_mapping *dmap)
 {
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct fuse_file *ff = NULL;
 	struct fuse_setupmapping_in inarg;
 	FUSE_ARGS(args);
 	ssize_t err;
 
-	if (file)
-		ff = file->private_data;
-
 	WARN_ON(offset % FUSE_DAX_MEM_RANGE_SZ);
 	WARN_ON(fc->nr_free_ranges < 0);
 
 	/* Ask fuse daemon to setup mapping */
 	memset(&inarg, 0, sizeof(inarg));
 	inarg.foffset = offset;
-	if (ff)
-		inarg.fh = ff->fh;
-	else
-		inarg.fh = -1;
+	inarg.fh = -1;
 	inarg.moffset = dmap->window_offset;
 	inarg.len = FUSE_DAX_MEM_RANGE_SZ;
-	if (file) {
-		inarg.flags |= (file->f_mode & FMODE_WRITE) ?
-				FUSE_SETUPMAPPING_FLAG_WRITE : 0;
-		inarg.flags |= (file->f_mode & FMODE_READ) ?
-				FUSE_SETUPMAPPING_FLAG_READ : 0;
-	} else {
-		inarg.flags |= FUSE_SETUPMAPPING_FLAG_READ;
-		inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
-	}
+	inarg.flags |= FUSE_SETUPMAPPING_FLAG_READ;
+	inarg.flags |= FUSE_SETUPMAPPING_FLAG_WRITE;
 	args.in.h.opcode = FUSE_SETUPMAPPING;
 	args.in.h.nodeid = fi->nodeid;
 	args.in.numargs = 1;
@@ -1985,9 +1970,8 @@ static int fuse_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		/* Setup one mapping */
-		ret = fuse_setup_one_mapping(inode, NULL,
-				ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ),
-				alloc_dmap);
+		ret = fuse_setup_one_mapping(inode,
+			ALIGN_DOWN(pos, FUSE_DAX_MEM_RANGE_SZ), alloc_dmap);
 		if (ret < 0) {
 			printk("fuse_setup_one_mapping() failed. err=%d"
 				" pos=0x%llx\n", ret, pos);
-- 
2.17.2

