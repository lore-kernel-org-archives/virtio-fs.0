From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 02:03:19 +0800
Message-Id: <20190416180322.65113-7-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
References: <20190416180322.65113-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 6/9] virtio-fs: let dax style override directIO
	style when dax+cache=none
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

In case of dax+cache=none, mmap uses dax style prior to directIO style,
while read/write don't, but it seems that there is no reason not to do so.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
---
 fs/fuse/file.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index c6090f5..620326e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1158,12 +1158,12 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct inode *inode = file->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
 
-	if (ff->open_flags & FOPEN_DIRECT_IO)
-		return fuse_direct_read_iter(iocb, to);
-
 	if (IS_DAX(inode))
 		return fuse_dax_read_iter(iocb, to);
 
+	if (ff->open_flags & FOPEN_DIRECT_IO)
+		return fuse_direct_read_iter(iocb, to);
+
 	/*
 	 * In auto invalidate mode, always update attributes on read.
 	 * Otherwise, only update if we attempt to read past EOF (to ensure
@@ -1426,11 +1426,12 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t err;
 	loff_t endbyte = 0;
 
-	if (ff->open_flags & FOPEN_DIRECT_IO)
-		return fuse_direct_write_iter(iocb, from);
 	if (IS_DAX(inode))
 		return fuse_dax_write_iter(iocb, from);
 
+	if (ff->open_flags & FOPEN_DIRECT_IO)
+		return fuse_direct_write_iter(iocb, from);
+
 	if (get_fuse_conn(inode)->writeback_cache) {
 		/* Update size (EOF optimization) and mode (SUID clearing) */
 		err = fuse_update_attributes(mapping->host, file);
-- 
1.8.3.1

