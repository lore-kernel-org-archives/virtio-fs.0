Return-Path: <jefflexu@linux.alibaba.com>
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 16 May 2022 11:39:04 +0800
Message-Id: <20220516033906.58771-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
References: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v8 1/3] virtiofsd: add .ioctl() support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com
Cc: joseph.qi@linux.alibaba.com, hsiangkao@linux.alibaba.com, haibinzhang@tencent.com, liudonghua@uniontech.com

Support FS_IOC_[G|S]ETFLAGS and FS_IOC_FS[G|S]ETXATTR ioctls in prep
for the following per-inode DAX feature.

Currently only quering and setting FS_DAX_FL/FS_XFLAG_DAX flag are
supported for security concern. The restriction can be relaxed if it
is needed later.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/passthrough_ll.c      | 121 ++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |   1 +
 2 files changed, 122 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b7c1fa71b5..f52398f1f4 100644
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
@@ -2188,6 +2190,124 @@ out:
     fuse_reply_err(req, saverr);
 }
 
+static int lo_ioctl_write(int fd, unsigned int cmd, const void *in_buf)
+{
+    int res = 0;
+
+    if (cmd == FS_IOC_SETFLAGS) {
+        const unsigned int *in_flags = in_buf;
+        unsigned int flags;
+
+        res = ioctl(fd, FS_IOC_GETFLAGS, &flags);
+        if (res < 0) {
+            return errno;
+        }
+
+        if (*in_flags & FS_DAX_FL) {
+            flags |= FS_DAX_FL;
+        } else {
+            flags &= ~FS_DAX_FL;
+        }
+
+        res = ioctl(fd, cmd, &flags);
+    } else if (cmd == FS_IOC_FSSETXATTR) {
+        const struct fsxattr *in_xfa = in_buf;
+        struct fsxattr xfa;
+
+        res = ioctl(fd, FS_IOC_FSGETXATTR, &xfa);
+        if (res < 0) {
+            return errno;
+        }
+
+        if (in_xfa->fsx_xflags & FS_XFLAG_DAX) {
+            xfa.fsx_xflags |= FS_XFLAG_DAX;
+        } else {
+            xfa.fsx_xflags &= ~FS_XFLAG_DAX;
+        }
+
+        res = ioctl(fd, cmd, &xfa);
+    }
+
+    return res < 0 ? errno : 0;
+}
+
+static int lo_ioctl_read(int fd, unsigned int cmd, size_t out_bufsz,
+                         void **out_buf)
+{
+    int res;
+    void *buf = NULL;
+
+    buf = malloc(out_bufsz);
+    if (!buf) {
+        return errno;
+    }
+
+    res = ioctl(fd, cmd, buf);
+    if (res < 0) {
+        free(buf);
+        return errno;
+    }
+
+    if (cmd == FS_IOC_GETFLAGS) {
+        unsigned int *flags = buf;
+
+        *flags = *flags & FS_DAX_FL;
+    } else if (cmd == FS_IOC_FSGETXATTR) {
+        struct fsxattr *xfa = buf;
+
+        *xfa = (struct fsxattr) {
+            .fsx_xflags = xfa->fsx_xflags & FS_XFLAG_DAX,
+        };
+    }
+
+    *out_buf = buf;
+    return 0;
+}
+
+static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd,
+                     void *arg, struct fuse_file_info *fi,
+                     unsigned flags, const void *in_buf,
+                     size_t in_bufsz, size_t out_bufsz)
+{
+    int fd = lo_fi_fd(req, fi);
+    int res = ENOSYS;
+    void *buf = NULL;
+    size_t size = 0;
+
+    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
+            "in_bufsz = %lu, out_bufsz = %lu)\n",
+            ino, cmd, flags, in_bufsz, out_bufsz);
+
+    /*
+     * Unrestricted ioctl is not supported yet.
+     * Currently only quering and setting FS_DAX_FL/FS_XFLAG_DAX flag are
+     * supported to enable per-inode DAX feature. The restriction can be
+     * relaxed if it's needed later.
+     */
+    if (flags & FUSE_IOCTL_UNRESTRICTED ||
+        !(cmd == FS_IOC_SETFLAGS || cmd == FS_IOC_GETFLAGS ||
+          cmd == FS_IOC_FSSETXATTR || cmd == FS_IOC_FSGETXATTR)) {
+        fuse_log(FUSE_LOG_DEBUG, "unsupported cmd %u, flags %x\n", cmd, flags);
+        goto err;
+    }
+
+    if (_IOC_DIR(cmd) == _IOC_READ) {
+        size = out_bufsz;
+        res = lo_ioctl_read(fd, cmd, out_bufsz, &buf);
+    } else if (_IOC_DIR(cmd) == _IOC_WRITE) {
+        res = lo_ioctl_write(fd, cmd, in_buf);
+    }
+    if (res) {
+        goto err;
+    }
+
+    fuse_reply_ioctl(req, 0, buf, size);
+    free(buf);
+    return;
+err:
+    fuse_reply_err(req, res);
+}
+
 static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
                         struct fuse_file_info *fi)
 {
@@ -3474,6 +3594,7 @@ static struct fuse_lowlevel_ops lo_oper = {
     .fsyncdir = lo_fsyncdir,
     .create = lo_create,
     .getlk = lo_getlk,
+    .ioctl = lo_ioctl,
     .setlk = lo_setlk,
     .open = lo_open,
     .release = lo_release,
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index f49ed94b5e..eaed5b151b 100644
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

