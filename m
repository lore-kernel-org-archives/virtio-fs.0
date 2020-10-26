From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:25 +0000
Message-Id: <20201026184331.272953-11-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 10/16] virtiofsd: Announce FUSE_ATTR_FLAGS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Max Reitz <mreitz@redhat.com>

The fuse_attr.flags field is currently just initialized to 0, which is
valid.  Thus, there is no reason not to always announce FUSE_ATTR_FLAGS
(when the kernel supports it).

Signed-off-by: Max Reitz <mreitz@redhat.com>
Message-Id: <20200909184028.262297-3-mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_common.h   | 8 ++++++++
 tools/virtiofsd/fuse_lowlevel.c | 7 +++++++
 2 files changed, 15 insertions(+)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index 686c42c0a5..870544fe13 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -352,6 +352,14 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_NO_OPENDIR_SUPPORT (1 << 24)
 
+/**
+ * Indicates that the client will provide fuse_attr.flags, and the kernel will
+ * interpret it.
+ *
+ * This feature is enabled by default when supported by the kernel.
+ */
+#define FUSE_CAP_ATTR_FLAGS (1 << 27)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 4d1ba2925d..8679594255 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1988,6 +1988,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
             bufsize = max_bufsize;
         }
     }
+    if (arg->flags & FUSE_ATTR_FLAGS) {
+        se->conn.capable |= FUSE_CAP_ATTR_FLAGS;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
@@ -2014,6 +2017,7 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     LL_SET_DEFAULT(1, FUSE_CAP_ASYNC_DIO);
     LL_SET_DEFAULT(1, FUSE_CAP_IOCTL_DIR);
     LL_SET_DEFAULT(1, FUSE_CAP_ATOMIC_O_TRUNC);
+    LL_SET_DEFAULT(1, FUSE_CAP_ATTR_FLAGS);
     LL_SET_DEFAULT(se->op.write_buf, FUSE_CAP_SPLICE_READ);
     LL_SET_DEFAULT(se->op.getlk && se->op.setlk, FUSE_CAP_POSIX_LOCKS);
     LL_SET_DEFAULT(se->op.flock, FUSE_CAP_FLOCK_LOCKS);
@@ -2103,6 +2107,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
     if (se->conn.want & FUSE_CAP_POSIX_ACL) {
         outarg.flags |= FUSE_POSIX_ACL;
     }
+    if (se->conn.want & FUSE_CAP_ATTR_FLAGS) {
+        outarg.flags |= FUSE_ATTR_FLAGS;
+    }
     outarg.max_readahead = se->conn.max_readahead;
     outarg.max_write = se->conn.max_write;
     if (se->conn.max_background >= (1 << 16)) {
-- 
2.28.0

