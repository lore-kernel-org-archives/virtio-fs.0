From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Wed, 23 Oct 2019 21:25:23 +0900
Message-ID: <20191023122523.1816-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Subject: [Virtio-fs] [PATCH] virtiofsd: Fix data corruption with O_APPEND
	wirte in writeback mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org

When writeback mode is enabled (-o writeback), O_APPEND handling is
done in kernel. Therefore virtiofsd clears O_APPEND flag when open.
Otherwise O_APPEND flag takes precedence over pwrite() and write
data may corrupt.

Currently clearing O_APPEND flag is done in lo_open(), but we also
need the same operation in lo_create(). So, factor out the flag
update operation in lo_open() to update_open_flags() and call it
in both lo_open() and lo_create().

This fixes the failure of xfstest generic/069 in writeback mode
(which tests O_APPEND write data integrity).

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 contrib/virtiofsd/passthrough_ll.c | 56 +++++++++++++++---------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index e8892c3c32..79fb78ecce 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1733,6 +1733,32 @@ static void lo_releasedir(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info
 	fuse_reply_err(req, 0);
 }
 
+static void update_open_flags(int writeback, struct fuse_file_info *fi)
+{
+	/* With writeback cache, kernel may send read requests even
+	   when userspace opened write-only */
+	if (writeback && (fi->flags & O_ACCMODE) == O_WRONLY) {
+		fi->flags &= ~O_ACCMODE;
+		fi->flags |= O_RDWR;
+	}
+
+	/* With writeback cache, O_APPEND is handled by the kernel.
+	   This breaks atomicity (since the file may change in the
+	   underlying filesystem, so that the kernel's idea of the
+	   end of the file isn't accurate anymore). In this example,
+	   we just accept that. A more rigorous filesystem may want
+	   to return an error here */
+	if (writeback && (fi->flags & O_APPEND))
+		fi->flags &= ~O_APPEND;
+
+	/*
+	 * O_DIRECT in guest should not necessarily mean bypassing page
+	 * cache on host as well. If somebody needs that behavior, it
+	 * probably should be a configuration knob in daemon.
+	 */
+	fi->flags &= ~O_DIRECT;
+}
+
 static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 		      mode_t mode, struct fuse_file_info *fi)
 {
@@ -1760,12 +1786,7 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
 	if (err)
 		goto out;
 
-	/*
-	 * O_DIRECT in guest should not necessarily mean bypassing page
-	 * cache on host as well. If somebody needs that behavior, it
-	 * probably should be a configuration knob in daemon.
-	 */
-	fi->flags &= ~O_DIRECT;
+	update_open_flags(lo->writeback, fi);
 
 	fd = openat(parent_inode->fd, name,
 		    (fi->flags | O_CREAT) & ~O_NOFOLLOW, mode);
@@ -1966,28 +1987,7 @@ static void lo_open(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 
 	fuse_log(FUSE_LOG_DEBUG, "lo_open(ino=%" PRIu64 ", flags=%d)\n", ino, fi->flags);
 
-	/* With writeback cache, kernel may send read requests even
-	   when userspace opened write-only */
-	if (lo->writeback && (fi->flags & O_ACCMODE) == O_WRONLY) {
-		fi->flags &= ~O_ACCMODE;
-		fi->flags |= O_RDWR;
-	}
-
-	/* With writeback cache, O_APPEND is handled by the kernel.
-	   This breaks atomicity (since the file may change in the
-	   underlying filesystem, so that the kernel's idea of the
-	   end of the file isn't accurate anymore). In this example,
-	   we just accept that. A more rigorous filesystem may want
-	   to return an error here */
-	if (lo->writeback && (fi->flags & O_APPEND))
-		fi->flags &= ~O_APPEND;
-
-	/*
-	 * O_DIRECT in guest should not necessarily mean bypassing page
-	 * cache on host as well. If somebody needs that behavior, it
-	 * probably should be a configuration knob in daemon.
-	 */
-	fi->flags &= ~O_DIRECT;
+	update_open_flags(lo->writeback, fi);
 
 	sprintf(buf, "%i", lo_fd(req, ino));
 	fd = openat(lo->proc_self_fd, buf, fi->flags & ~O_NOFOLLOW);
-- 
2.21.0

