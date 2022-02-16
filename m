Date: Wed, 16 Feb 2022 16:05:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <Yg1nFPqBnOf+4pDi@redhat.com>
References: <20220216173625.128109-1-dgilbert@redhat.com>
	<Yg1THoNoxjSAcK7u@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg1THoNoxjSAcK7u@work-vm>
Subject: Re: [Virtio-fs] [PULL 00/12] virtiofs queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org

On Wed, Feb 16, 2022 at 07:40:14PM +0000, Dr. David Alan Gilbert wrote:
> * Dr. David Alan Gilbert (git) (dgilbert@redhat.com) wrote:
> > From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
> > 
> > The following changes since commit c13b8e9973635f34f3ce4356af27a311c993729c:
> > 
> >   Merge remote-tracking branch 'remotes/alistair/tags/pull-riscv-to-apply-20220216' into staging (2022-02-16 09:57:11 +0000)
> > 
> > are available in the Git repository at:
> > 
> >   https://gitlab.com/dagrh/qemu.git tags/pull-virtiofs-20220216
> > 
> > for you to fetch changes up to 47cc3ef597b2ee926c13c9433f4f73645429e128:
> > 
> >   virtiofsd: Add basic support for FUSE_SYNCFS request (2022-02-16 17:29:32 +0000)
> 
> NAK
> this doesn't build on older Linuxes.
> 
> Rework version in the works.

Hi David,

I think it is patch 8 which is using gettid(). I have updated that
patch and now I am using syscall(NR_gettid) instead. Here is the
updated patch. I hope this solves the build on older Linux issue.


Subject: virtiofsd: Add helpers to work with /proc/self/task/tid/attr/fscreate

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
 tools/virtiofsd/passthrough_ll.c |   92 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
===================================================================
--- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2022-02-16 15:53:13.657015138 -0500
+++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2022-02-16 15:55:14.911234993 -0500
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
@@ -257,6 +261,72 @@ static struct lo_data *lo_data(fuse_req_
 }
 
 /*
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
+    sprintf(procname, "%ld/attr/fscreate", syscall(SYS_gettid));
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
+    sprintf(procname, "%ld/attr/fscreate", syscall(SYS_gettid));
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
+/*
  * Load capng's state from our saved state if the current thread
  * hadn't previously been loaded.
  * returns 0 on success
@@ -3522,6 +3592,15 @@ static void setup_namespaces(struct lo_d
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
@@ -3738,6 +3817,14 @@ static void setup_chroot(struct lo_data
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
@@ -3923,6 +4010,10 @@ static void fuse_lo_data_cleanup(struct
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

