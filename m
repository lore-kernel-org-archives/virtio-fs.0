From: Max Reitz <mreitz@redhat.com>
Date: Mon,  2 Nov 2020 17:18:53 +0100
Message-Id: <20201102161859.156603-2-mreitz@redhat.com>
In-Reply-To: <20201102161859.156603-1-mreitz@redhat.com>
References: <20201102161859.156603-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 1/7] virtiofsd: Check FUSE_SUBMOUNTS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Eduardo Habkost <ehabkost@redhat.com>, Max Reitz <mreitz@redhat.com>, virtio-fs@redhat.com

FUSE_SUBMOUNTS is a pure indicator by the kernel to signal that it
supports submounts.  It does not check its state in the init reply, so
there is nothing for fuse_lowlevel.c to do but to check its existence
and copy it into fuse_conn_info.capable.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_common.h   | 7 +++++++
 tools/virtiofsd/fuse_lowlevel.c | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/tools/virtiofsd/fuse_common.h b/tools/virtiofsd/fuse_common.h
index 686c42c0a5..5aee5193eb 100644
--- a/tools/virtiofsd/fuse_common.h
+++ b/tools/virtiofsd/fuse_common.h
@@ -352,6 +352,13 @@ struct fuse_file_info {
  */
 #define FUSE_CAP_NO_OPENDIR_SUPPORT (1 << 24)
 
+/**
+ * Indicates that the kernel supports the FUSE_ATTR_SUBMOUNT flag.
+ *
+ * Setting (or unsetting) this flag in the `want` field has *no effect*.
+ */
+#define FUSE_CAP_SUBMOUNTS (1 << 27)
+
 /**
  * Ioctl flags
  *
diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 4d1ba2925d..370222339b 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1988,6 +1988,9 @@ static void do_init(fuse_req_t req, fuse_ino_t nodeid,
             bufsize = max_bufsize;
         }
     }
+    if (arg->flags & FUSE_SUBMOUNTS) {
+        se->conn.capable |= FUSE_CAP_SUBMOUNTS;
+    }
 #ifdef HAVE_SPLICE
 #ifdef HAVE_VMSPLICE
     se->conn.capable |= FUSE_CAP_SPLICE_WRITE | FUSE_CAP_SPLICE_MOVE;
-- 
2.26.2

