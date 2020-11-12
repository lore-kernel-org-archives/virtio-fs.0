From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 12 Nov 2020 13:24:17 -0500
Message-Id: <20201112182418.25395-2-vgoyal@redhat.com>
In-Reply-To: <20201112182418.25395-1-vgoyal@redhat.com>
References: <20201112182418.25395-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/2] virtiofsd: Save error code early at the
	failure callsite
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

Change error code handling slightly in lo_setattr(). Right now we seem
to jump to out_err and assume that "errno" is valid and use that to
send reply.

But if caller has to do some other operations before jumping to out_err,
then it does the dance of first saving errno to saverr and the restore
errno before jumping to out_err. This makes it more confusing.

I am about to make more changes where caller will have to do some
work after error before jumping to out_err. I found it easier to
change the convention a bit. That is caller saves error in "saverr"
before jumping to out_err. And out_err uses "saverr" to send error
back and does not rely on "errno" having actual error.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ec1008bceb..6407b1a2e1 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -686,6 +686,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             res = fchmodat(lo->proc_self_fd, procname, attr->st_mode, 0);
         }
         if (res == -1) {
+            saverr = errno;
             goto out_err;
         }
     }
@@ -695,6 +696,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
 
         res = fchownat(ifd, "", uid, gid, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW);
         if (res == -1) {
+            saverr = errno;
             goto out_err;
         }
     }
@@ -707,15 +709,15 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             sprintf(procname, "%i", ifd);
             truncfd = openat(lo->proc_self_fd, procname, O_RDWR);
             if (truncfd < 0) {
+                saverr = errno;
                 goto out_err;
             }
         }
 
         res = ftruncate(truncfd, attr->st_size);
+        saverr = res == -1 ? errno : 0;
         if (!fi) {
-            saverr = errno;
             close(truncfd);
-            errno = saverr;
         }
         if (res == -1) {
             goto out_err;
@@ -748,6 +750,7 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
             res = utimensat(lo->proc_self_fd, procname, tv, 0);
         }
         if (res == -1) {
+            saverr = errno;
             goto out_err;
         }
     }
@@ -756,7 +759,6 @@ static void lo_setattr(fuse_req_t req, fuse_ino_t ino, struct stat *attr,
     return lo_getattr(req, ino, fi);
 
 out_err:
-    saverr = errno;
     lo_inode_put(lo, &inode);
     fuse_reply_err(req, saverr);
 }
-- 
2.25.4

