From: Vivek Goyal <vgoyal@redhat.com>
Date: Tue,  8 Feb 2022 15:48:10 -0500
Message-Id: <20220208204813.682906-8-vgoyal@redhat.com>
In-Reply-To: <20220208204813.682906-1-vgoyal@redhat.com>
References: <20220208204813.682906-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v6 07/10] virtiofsd: Add helpers to work with
	/proc/self/task/tid/attr/fscreate
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: berrange@redhat.com, vgoyal@redhat.com

Soon we will be able to create and also set security context on the file
atomically using /proc/self/task/tid/attr/fscreate knob. If this knob
is available on the system, first set the knob with the desired context
and then create the file. It will be created with the context set in
fscreate. This works basically for SELinux and its per thread.

This patch just introduces the helper functions. Subsequent patches will
make use of these helpers.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 92 ++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 82023bf3d4..7762bf0d2c 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -173,10 +173,14 @@ struct lo_data {
 
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
+    /* An O_PATH file descriptor to /proc/self/task/ */
+    int proc_self_task;
     int user_killpriv_v2, killpriv_v2;
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
     int user_posix_acl, posix_acl;
+    /* Keeps track if /proc/<pid>/attr/fscreate should be used or not */
+    bool use_fscreate;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -256,6 +260,72 @@ static struct lo_data *lo_data(fuse_req_t req)
     return (struct lo_data *)fuse_req_userdata(req);
 }
 
+/*
+ * Tries to figure out if /proc/<pid>/attr/fscreate is usable or not. With
+ * selinux=0, read from fscreate returns -EINVAL.
+ *
+ * TODO: Link with libselinux and use is_selinux_enabled() instead down
+ * the line. It probably will be more reliable indicator.
+ */
+static bool is_fscreate_usable(struct lo_data *lo)
+{
+    char procname[64];
+    int fscreate_fd;
+    size_t bytes_read;
+
+    sprintf(procname, "%d/attr/fscreate", gettid());
+    fscreate_fd = openat(lo->proc_self_task, procname, O_RDWR);
+    if (fscreate_fd == -1) {
+        return false;
+    }
+
+    bytes_read = read(fscreate_fd, procname, 64);
+    close(fscreate_fd);
+    if (bytes_read == -1) {
+        return false;
+    }
+    return true;
+}
+
+/* Helpers to set/reset fscreate */
+__attribute__((unused))
+static int open_set_proc_fscreate(struct lo_data *lo, const void *ctx,
+                                  size_t ctxlen,int *fd)
+{
+    char procname[64];
+    int fscreate_fd, err = 0;
+    size_t written;
+
+    sprintf(procname, "%d/attr/fscreate", gettid());
+    fscreate_fd = openat(lo->proc_self_task, procname, O_WRONLY);
+    err = fscreate_fd == -1 ? errno : 0;
+    if (err) {
+        return err;
+    }
+
+    written = write(fscreate_fd, ctx, ctxlen);
+    err = written == -1 ? errno : 0;
+    if (err) {
+        goto out;
+    }
+
+    *fd = fscreate_fd;
+    return 0;
+out:
+    close(fscreate_fd);
+    return err;
+}
+
+__attribute__((unused))
+static void close_reset_proc_fscreate(int fd)
+{
+    if ((write(fd, NULL, 0)) == -1) {
+        fuse_log(FUSE_LOG_WARNING, "Failed to reset fscreate. err=%d\n", errno);
+    }
+    close(fd);
+    return;
+}
+
 /*
  * Load capng's state from our saved state if the current thread
  * hadn't previously been loaded.
@@ -3522,6 +3592,15 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
         exit(1);
     }
 
+    /* Get the /proc/self/task descriptor */
+    lo->proc_self_task = open("/proc/self/task/", O_PATH);
+    if (lo->proc_self_task == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(/proc/self/task, O_PATH): %m\n");
+        exit(1);
+    }
+
+    lo->use_fscreate = is_fscreate_usable(lo);
+
     /*
      * We only need /proc/self/fd. Prevent ".." from accessing parent
      * directories of /proc/self/fd by bind-mounting it over /proc. Since / was
@@ -3738,6 +3817,14 @@ static void setup_chroot(struct lo_data *lo)
         exit(1);
     }
 
+    lo->proc_self_task = open("/proc/self/task", O_PATH);
+    if (lo->proc_self_fd == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(\"/proc/self/task\", O_PATH): %m\n");
+        exit(1);
+    }
+
+    lo->use_fscreate = is_fscreate_usable(lo);
+
     /*
      * Make the shared directory the file system root so that FUSE_OPEN
      * (lo_open()) cannot escape the shared directory by opening a symlink.
@@ -3923,6 +4010,10 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
         close(lo->proc_self_fd);
     }
 
+    if (lo->proc_self_task >= 0) {
+        close(lo->proc_self_task);
+    }
+
     if (lo->root.fd >= 0) {
         close(lo->root.fd);
     }
@@ -3950,6 +4041,7 @@ int main(int argc, char *argv[])
         .posix_lock = 0,
         .allow_direct_io = 0,
         .proc_self_fd = -1,
+        .proc_self_task = -1,
         .user_killpriv_v2 = -1,
         .user_posix_acl = -1,
     };
-- 
2.34.1

