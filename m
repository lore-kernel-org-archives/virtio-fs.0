From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Tue, 17 Aug 2021 10:23:44 +0800
Message-Id: <20210817022347.18098-2-jefflexu@linux.alibaba.com>
In-Reply-To: <20210817022347.18098-1-jefflexu@linux.alibaba.com>
References: <20210817022220.17574-1-jefflexu@linux.alibaba.com>
	<20210817022347.18098-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd PATCH v4 1/4] virtiofsd: add .ioctl() support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, joseph.qi@linux.alibaba.com, virtualization@lists.linux-foundation.org

Add .ioctl() support for passthrough, in prep for the following support
for following per-file DAX feature.

Once advertising support for per-file DAX feature, virtiofsd should
support storing FS_DAX_FL flag persistently passed by
FS_IOC_SETFLAGS/FS_IOC_FSSETXATTR ioctl, and set FUSE_ATTR_DAX in
FUSE_LOOKUP accordingly if the file is capable of per-file DAX.

When it comes to passthrough, it passes corresponding ioctls to host
directly. Currently only these ioctls that are needed for per-file DAX
feature, i.e., FS_IOC_GETFLAGS/FS_IOC_SETFLAGS and
FS_IOC_FSGETXATTR/FS_IOC_FSSETXATTR are supported. Later we can restrict
the flags/attributes allowed to be set to reinforce the security, or
extend the scope of allowed ioctls if it is really needed later.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/passthrough_ll.c      | 53 +++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 2 files changed, 54 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b76d878509..e170b17adb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -54,6 +54,7 @@
 #include <sys/wait.h>
 #include <sys/xattr.h>
 #include <syslog.h>
+#include <linux/fs.h>
 
 #include "qemu/cutils.h"
 #include "passthrough_helpers.h"
@@ -2105,6 +2106,57 @@ out:
     fuse_reply_err(req, saverr);
 }
 
+static void lo_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd, void *arg,
+                  struct fuse_file_info *fi, unsigned flags, const void *in_buf,
+                  size_t in_bufsz, size_t out_bufsz)
+{
+    int fd = lo_fi_fd(req, fi);
+    int res;
+    int saverr = ENOSYS;
+
+    fuse_log(FUSE_LOG_DEBUG, "lo_ioctl(ino=%" PRIu64 ", cmd=0x%x, flags=0x%x, "
+	     "in_bufsz = %lu, out_bufsz = %lu)\n",
+	     ino, cmd, flags, in_bufsz, out_bufsz);
+
+    /* unrestricted ioctl is not supported yet */
+    if (flags & FUSE_IOCTL_UNRESTRICTED)
+        goto out;
+
+    /*
+     * Currently only those ioctls needed to support per-file DAX feature,
+     * i.e., FS_IOC_GETFLAGS/FS_IOC_SETFLAGS and
+     * FS_IOC_FSGETXATTR/FS_IOC_FSSETXATTR are supported.
+     */
+    if (cmd == FS_IOC_SETFLAGS || cmd == FS_IOC_FSSETXATTR) {
+        res = ioctl(fd, cmd, in_buf);
+        if (res < 0)
+            goto out_err;
+
+	fuse_reply_ioctl(req, 0, NULL, 0);
+    }
+    else if (cmd == FS_IOC_GETFLAGS || cmd == FS_IOC_FSGETXATTR) {
+	/* reused for 'unsigned int' for FS_IOC_GETFLAGS */
+	struct fsxattr attr;
+
+        res = ioctl(fd, cmd, &attr);
+        if (res < 0)
+            goto out_err;
+
+        fuse_reply_ioctl(req, 0, &attr, out_bufsz);
+    }
+    else {
+	fuse_log(FUSE_LOG_DEBUG, "Unsupported ioctl 0x%x\n", cmd);
+	goto out;
+    }
+
+    return;
+
+out_err:
+	saverr = errno;
+out:
+	fuse_reply_err(req, saverr);
+}
+
 static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
                         struct fuse_file_info *fi)
 {
@@ -3279,6 +3331,7 @@ static struct fuse_lowlevel_ops lo_oper = {
     .create = lo_create,
     .getlk = lo_getlk,
     .setlk = lo_setlk,
+    .ioctl = lo_ioctl,
     .open = lo_open,
     .release = lo_release,
     .flush = lo_flush,
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

