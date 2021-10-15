From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Fri, 15 Oct 2021 10:49:10 +0800
Message-Id: <20211015024910.22049-1-jefflexu@linux.alibaba.com>
In-Reply-To: <20211011030938.109206-2-jefflexu@linux.alibaba.com>
References: <20211011030938.109206-2-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v7 1/6] virtiofsd: add .ioctl() support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: virtio-fs@redhat.com, joseph.qi@linux.alibaba.com

changes since v6:
- correct the logic of limiting ioctls other than FS_IOC_[G|S]ETFLAGS
  and FS_IOC_FS[G|S]ETXATTR
- add missing free() corresponding to malloc()

For passthrough, it passes corresponding ioctls to host directly.

Currently only these ioctls that handling persistent inode flags, i.e.,
FS_IOC_[G|S]ETFLAGS and FS_IOC_FS[G|S]ETXATTR are supported for security
concern, though it's implemented in a quite general way, so that we can
expand the scope of allowed ioctls if it is really needed later.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/passthrough_ll.c      | 61 +++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 2 files changed, 62 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b76d878509..c1cb54c31a 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -47,6 +47,7 @@
 #include <dirent.h>
 #include <pthread.h>
 #include <sys/file.h>
+#include <sys/ioctl.h>
 #include <sys/mount.h>
 #include <sys/prctl.h>
 #include <sys/resource.h>
@@ -54,6 +55,7 @@
 #include <sys/wait.h>
 #include <sys/xattr.h>
 #include <syslog.h>
+#include <linux/fs.h>
 
 #include "qemu/cutils.h"
 #include "passthrough_helpers.h"
@@ -2105,6 +2107,64 @@ out:
     fuse_reply_err(req, saverr);
 }
 
+
+static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd, void *arg,
+                          struct fuse_file_info *fi, unsigned flags, const void *in_buf,
+                          size_t in_bufsz, size_t out_bufsz)
+{
+    int res, dir;
+    int fd = lo_fi_fd(req, fi);
+    int saverr = ENOSYS;
+    void *buf = NULL;
+    size_t size = 0;
+
+    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
+            "in_bufsz = %lu, out_bufsz = %lu)\n",
+            ino, cmd, flags, in_bufsz, out_bufsz);
+
+    if (!(cmd == FS_IOC_SETFLAGS || cmd == FS_IOC_GETFLAGS ||
+          cmd == FS_IOC_FSSETXATTR || cmd == FS_IOC_FSGETXATTR))
+        goto out;
+
+    /* unrestricted ioctl is not supported yet */
+    if (flags & FUSE_IOCTL_UNRESTRICTED)
+        goto out;
+
+    dir = _IOC_DIR(cmd);
+
+    if (dir & _IOC_READ) {
+        size = out_bufsz;
+        buf = malloc(size);
+        if (!buf)
+            goto out_err;
+
+        if (dir & _IOC_WRITE)
+            memcpy(buf, in_buf, size);
+
+        res = ioctl(fd, cmd, buf);
+    }
+    else if (dir & _IOC_WRITE) {
+        res = ioctl(fd, cmd, in_buf);
+    }
+    else {
+        res = ioctl(fd, cmd, arg);
+    }
+
+    if (res < 0)
+        goto out_err;
+
+    fuse_reply_ioctl(req, 0, buf, size);
+    free(buf);
+
+    return;
+
+out_err:
+    saverr = errno;
+out:
+    fuse_reply_err(req, saverr);
+    free(buf);
+}
+
 static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
                         struct fuse_file_info *fi)
 {
@@ -3278,6 +3338,7 @@ static struct fuse_lowlevel_ops lo_oper = {
     .fsyncdir = lo_fsyncdir,
     .create = lo_create,
     .getlk = lo_getlk,
+    .ioctl = lo_ioctl,
     .setlk = lo_setlk,
     .open = lo_open,
     .release = lo_release,
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 62441cfcdb..2a5f7614fc 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -62,6 +62,7 @@ static const int syscall_allowlist[] = {
     SCMP_SYS(gettid),
     SCMP_SYS(gettimeofday),
     SCMP_SYS(getxattr),
+    SCMP_SYS(ioctl),
     SCMP_SYS(linkat),
     SCMP_SYS(listxattr),
     SCMP_SYS(lseek),
-- 
2.27.0

