DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=LrbTd6tSNQjqaBaj1lpQXcV7DowubxzC111+FmraES4=;
	b=KetU5L0oYdz+enH/xtchCDwmc2o+w40N8VfbpoR5w8ixB0GzrCzo41FGsnc+iVZA3p
	Rui9+FQngfe9DHiiIIWuwWcylCh9pkCoG6X/L8zis6H0126T7uNh0yik0m91bYPlIJdb
	61p/DkGBLPpi9fHwDKgxzgrgqFQ3SnDoLhkW/H4T+WR6DqNBMCoRZ2l+lWl1r2METv5X
	2M+VNMGbD0sQaxafRXQFTNhu25O5nycp7cNBzpk8AG67DxtfpSmMJY6C1T4VGvkEPMoL
	eMLPweBCBH/YKGNezBUepPf8zcn0jTD7OWVPIXdPgYy6zt8doZED6vSY/6eBYeTCLoBn
	3K3A==
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 20 Apr 2021 17:46:41 +0200
Message-Id: <20210420154643.58439-7-ma.mandourr@gmail.com>
In-Reply-To: <20210420154643.58439-1-ma.mandourr@gmail.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 6/7] virtiofsd/passthrough_ll.c: Changed
	local allocations to GLib functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

Changed the allocations of some local variables to GLib's allocation
functions, such as g_try_malloc0(), and annotated those variables
as g_autofree. Subsequently, I was able to remove the calls to free().

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b9260c26d4..886498e8c3 100644
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
@@ -2727,7 +2726,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
                         size_t size)
 {
     struct lo_data *lo = lo_data(req);
-    char *value = NULL;
+    g_autofree char *value = NULL;
     char procname[64];
     const char *name;
     char *mapped_name;
@@ -2768,7 +2767,7 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
              ino, name, size);
 
     if (size) {
-        value = malloc(size);
+        value = g_try_malloc(size);
         if (!value) {
             goto out_err;
         }
@@ -2807,8 +2806,6 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    free(value);
-
     if (fd >= 0) {
         close(fd);
     }
@@ -2827,7 +2824,7 @@ out:
 static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
 {
     struct lo_data *lo = lo_data(req);
-    char *value = NULL;
+    g_autofree char *value = NULL;
     char procname[64];
     struct lo_inode *inode;
     ssize_t ret;
@@ -2849,7 +2846,7 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
              size);
 
     if (size) {
-        value = malloc(size);
+        value = g_try_malloc(size);
         if (!value) {
             goto out_err;
         }
@@ -2934,8 +2931,6 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         fuse_reply_xattr(req, ret);
     }
 out_free:
-    free(value);
-
     if (fd >= 0) {
         close(fd);
     }
-- 
2.25.1

