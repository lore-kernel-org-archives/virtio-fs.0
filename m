From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Thu,  6 May 2021 19:56:40 +0100
Message-Id: <20210506185641.284821-12-dgilbert@redhat.com>
In-Reply-To: <20210506185641.284821-1-dgilbert@redhat.com>
References: <20210506185641.284821-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 11/12] virtiofsd/passthrough_ll.c: Changed local
	allocations to GLib functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, groug@kaod.org, jose.carlos.venegas.munoz@intel.com, ma.mandourr@gmail.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Mahmoud Mandour <ma.mandourr@gmail.com>

Changed the allocations of some local variables to GLib's allocation
functions, such as g_try_malloc0(), and annotated those variables
as g_autofree. Subsequently, I was able to remove the calls to free().

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20210420154643.58439-7-ma.mandourr@gmail.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 406b5bd10e..49c21fd855 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -1653,7 +1653,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
     struct lo_data *lo = lo_data(req);
     struct lo_dirp *d = NULL;
     struct lo_inode *dinode;
-    char *buf = NULL;
+    g_autofree char *buf = NULL;
     char *p;
     size_t rem = size;
     int err = EBADF;
@@ -1669,7 +1669,7 @@ static void lo_do_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
     }
 
     err = ENOMEM;
-    buf = calloc(1, size);
+    buf = g_try_malloc0(size);
     if (!buf) {
         goto error;
     }
@@ -1755,7 +1755,6 @@ error:
     } else {
         fuse_reply_buf(req, buf, size - rem);
     }
-    free(buf);
 }
 
 static void lo_readdir(fuse_req_t req, fuse_ino_t ino, size_t size,
@@ -2732,7 +2731,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
     struct lo_data *lo = lo_data(req);
-    char *value = NULL;
+    g_autofree char *value = NULL;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -2773,7 +2772,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
              ino, name, size);
 
     if (size) {
-        value = malloc(size);
+        value = g_try_malloc(size);
         if (!value) {
             goto out_err;
         }
@@ -2812,8 +2811,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    free(value);
-
     if (fd >= 0) {
         close(fd);
     }
@@ -2832,7 +2829,7 @@ out:
 static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 {
     struct lo_data *lo = lo_data(req);
-    char *value = NULL;
+    g_autofree char *value = NULL;
     char procname[64];
     struct lo_inode *inode;
     ssize_t ret;
@@ -2854,7 +2851,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
              size);
 
     if (size) {
-        value = malloc(size);
+        value = g_try_malloc(size);
         if (!value) {
             goto out_err;
         }
@@ -2939,8 +2936,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    free(value);
-
     if (fd >= 0) {
         close(fd);
     }
-- 
2.31.1

