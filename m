From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 17 Jun 2021 14:12:08 -0400
Message-Id: <20210617181213.1177835-4-vgoyal@redhat.com>
In-Reply-To: <20210617181213.1177835-1-vgoyal@redhat.com>
References: <20210617181213.1177835-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 3/8] virtiofsd: Fix xattr operations
	overwriting errno
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, vgoyal@redhat.com, miklos@szeredi.hu

getxattr/setxattr/removexattr/listxattr operations handle regualar
and non-regular files differently. For the case of non-regular files
we do fchdir(/proc/self/fd) and the xattr operation and then revert
back to original working directory. After this we are saving errno
and that's buggy because fchdir() will overwrite the errno.

FCHDIR_NOFAIL(lo->proc_self_fd);
ret = getxattr(procname, name, value, size);
FCHDIR_NOFAIL(lo->root.fd);

if (ret == -1)
    saverr = errno

In above example, if getxattr() failed, we will still return 0 to caller
as errno must have been written by FCHDIR_NOFAIL(lo->root.fd) call.
Fix all such instances and capture "errno" early and save in "saverr"
variable.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 49c21fd855..ec91b3c133 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2791,15 +2791,17 @@ static void lo_getxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
             goto out_err;
         }
         ret = fgetxattr(fd, name, value, size);
+        saverr = ret == -1 ? errno : 0;
     } else {
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = getxattr(procname, name, value, size);
+        saverr = ret == -1 ? errno : 0;
         FCHDIR_NOFAIL(lo->root.fd);
     }
 
     if (ret == -1) {
-        goto out_err;
+        goto out;
     }
     if (size) {
         saverr = 0;
@@ -2864,15 +2866,17 @@ static void lo_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
             goto out_err;
         }
         ret = flistxattr(fd, value, size);
+        saverr = ret == -1 ? errno : 0;
     } else {
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = listxattr(procname, value, size);
+        saverr = ret == -1 ? errno : 0;
         FCHDIR_NOFAIL(lo->root.fd);
     }
 
     if (ret == -1) {
-        goto out_err;
+        goto out;
     }
     if (size) {
         saverr = 0;
@@ -2998,15 +3002,15 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *in_name,
             goto out;
         }
         ret = fsetxattr(fd, name, value, size, flags);
+        saverr = ret == -1 ? errno : 0;
     } else {
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = setxattr(procname, name, value, size, flags);
+        saverr = ret == -1 ? errno : 0;
         FCHDIR_NOFAIL(lo->root.fd);
     }
 
-    saverr = ret == -1 ? errno : 0;
-
 out:
     if (fd >= 0) {
         close(fd);
@@ -3064,15 +3068,15 @@ static void lo_removexattr(fuse_req_t req, fuse_ino_t ino, const char *in_name)
             goto out;
         }
         ret = fremovexattr(fd, name);
+        saverr = ret == -1 ? errno : 0;
     } else {
         /* fchdir should not fail here */
         FCHDIR_NOFAIL(lo->proc_self_fd);
         ret = removexattr(procname, name);
+        saverr = ret == -1 ? errno : 0;
         FCHDIR_NOFAIL(lo->root.fd);
     }
 
-    saverr = ret == -1 ? errno : 0;
-
 out:
     if (fd >= 0) {
         close(fd);
-- 
2.25.4

