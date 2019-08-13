From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue, 13 Aug 2019 15:29:43 -0400
Message-Id: <20190813192944.26009-4-vgoyal@redhat.com>
In-Reply-To: <20190813192944.26009-1-vgoyal@redhat.com>
References: <20190813192944.26009-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] virtiofsd: Parse flag FUSE_WRITE_KILL_PRIV
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Caller can set FUSE_WRITE_KILL_PRIV in write_flags. Parse it and pass it
to the filesystem.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_common.h   | 5 ++++-
 contrib/virtiofsd/fuse_kernel.h   | 1 +
 contrib/virtiofsd/fuse_lowlevel.c | 2 ++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/contrib/virtiofsd/fuse_common.h b/contrib/virtiofsd/fuse_common.h
index 4d95f6f28b..5f4af98999 100644
--- a/contrib/virtiofsd/fuse_common.h
+++ b/contrib/virtiofsd/fuse_common.h
@@ -64,8 +64,11 @@ struct fuse_file_info {
 	   May only be set in ->release(). */
 	unsigned int flock_release : 1;
 
+	/* Indicates that suid/sgid bits should be removed upon write */
+	unsigned int kill_priv : 1;
+
 	/** Padding.  Do not use*/
-	unsigned int padding : 26;
+	unsigned int padding : 25;
 
 	/** File handle.  May be filled in by filesystem in open().
 	    Available in all other file operations */
diff --git a/contrib/virtiofsd/fuse_kernel.h b/contrib/virtiofsd/fuse_kernel.h
index d477c70028..d2b7ccf96b 100644
--- a/contrib/virtiofsd/fuse_kernel.h
+++ b/contrib/virtiofsd/fuse_kernel.h
@@ -325,6 +325,7 @@ struct fuse_file_lock {
  */
 #define FUSE_WRITE_CACHE	(1 << 0)
 #define FUSE_WRITE_LOCKOWNER	(1 << 1)
+#define FUSE_WRITE_KILL_PRIV    (1 << 2)
 
 /**
  * Read flags
diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 417f99e8dc..ce27a6dd16 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1162,6 +1162,7 @@ static void do_write(fuse_req_t req, fuse_ino_t nodeid,
 	memset(&fi, 0, sizeof(fi));
 	fi.fh = arg->fh;
 	fi.writepage = (arg->write_flags & FUSE_WRITE_CACHE) != 0;
+	fi.kill_priv = !!(arg->write_flags & FUSE_WRITE_KILL_PRIV);
 
 	if (!compat) {
 		fi.lock_owner = arg->lock_owner;
@@ -1209,6 +1210,7 @@ static void do_write_buf(fuse_req_t req, fuse_ino_t nodeid,
 
 	fi.fh = arg->fh;
 	fi.writepage = !!(arg->write_flags & FUSE_WRITE_CACHE);
+	fi.kill_priv = !!(arg->write_flags & FUSE_WRITE_KILL_PRIV);
 
         if (ibufv->count == 1) {
 		assert(!(tmpbufv.buf[0].flags & FUSE_BUF_IS_FD));
-- 
2.17.2

