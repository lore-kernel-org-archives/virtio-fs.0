From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Thu, 20 Feb 2020 20:47:03 +0900
Message-ID: <20200220114704.11592-2-misono.tomohiro@jp.fujitsu.com>
In-Reply-To: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
References: <20200220114704.11592-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 1/2] virtiofs: passthrough_ll: cleanup
	getxattr/listxattr
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: vgoyal@redhat.com

This is a cleanup patch to simplify the following xattr fix and
there is no functional changes.

- Move memory allocation to head of the function
- Unify fgetxattr/flistxattr call for both size == 0 and
  size != 0 case
- Remove redundant lo_inode_put call in error path
  (Note: second call is ignored now since @inode is already NULL)

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 62 ++++++++++++++------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 9772823066..33cff8c2c8 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2370,8 +2370,8 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
         return;
     }
 
-    saverr = ENOSYS;
     if (!lo_data(req)->xattr) {
+        saverr = ENOSYS;
         goto out;
     }
 
@@ -2384,34 +2384,30 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
         goto out;
     }
 
+    if (size) {
+        value = malloc(size);
+        if (!value) {
+            goto out_err;
+        }
+    }
+
     sprintf(procname, "%i", inode->fd);
     fd = openat(lo->proc_self_fd, procname, O_RDONLY);
     if (fd < 0) {
         goto out_err;
     }
 
+    ret = fgetxattr(fd, name, value, size);
+    if (ret == -1) {
+        goto out_err;
+    }
     if (size) {
-        value = malloc(size);
-        if (!value) {
-            goto out_err;
-        }
-
-        ret = fgetxattr(fd, name, value, size);
-        if (ret == -1) {
-            goto out_err;
-        }
-        saverr = 0;
         if (ret == 0) {
+            saverr = 0;
             goto out;
         }
-
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = fgetxattr(fd, name, NULL, 0);
-        if (ret == -1) {
-            goto out_err;
-        }
-
         fuse_reply_xattr(req, ret);
     }
 out_free:
@@ -2427,7 +2423,6 @@ out_free:
 out_err:
     saverr = errno;
 out:
-    lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
     goto out_free;
 }
@@ -2448,8 +2443,8 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         return;
     }
 
-    saverr = ENOSYS;
     if (!lo_data(req)->xattr) {
+        saverr = ENOSYS;
         goto out;
     }
 
@@ -2462,34 +2457,30 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
         goto out;
     }
 
+    if (size) {
+        value = malloc(size);
+        if (!value) {
+            goto out_err;
+        }
+    }
+
     sprintf(procname, "%i", inode->fd);
     fd = openat(lo->proc_self_fd, procname, O_RDONLY);
     if (fd < 0) {
         goto out_err;
     }
 
+    ret = flistxattr(fd, value, size);
+    if (ret == -1) {
+        goto out_err;
+    }
     if (size) {
-        value = malloc(size);
-        if (!value) {
-            goto out_err;
-        }
-
-        ret = flistxattr(fd, value, size);
-        if (ret == -1) {
-            goto out_err;
-        }
-        saverr = 0;
         if (ret == 0) {
+            saverr = 0;
             goto out;
         }
-
         fuse_reply_buf(req, value, ret);
     } else {
-        ret = flistxattr(fd, NULL, 0);
-        if (ret == -1) {
-            goto out_err;
-        }
-
         fuse_reply_xattr(req, ret);
     }
 out_free:
@@ -2505,7 +2496,6 @@ out_free:
 out_err:
     saverr = errno;
 out:
-    lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
     goto out_free;
 }
-- 
2.21.1


