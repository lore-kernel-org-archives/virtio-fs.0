Date: Tue, 17 Aug 2021 15:45:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRwRz8aZGq6QLpx/@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
	<df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
	<YRKZ415xrDtcYaQR@redhat.com>
	<4a74bbbd-92f6-a7d1-0c8d-fa8b121b9643@redhat.com>
	<YRKh/fbBntF+GfS8@redhat.com>
	<6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
	<YRrALRGy2cROwsP9@redhat.com>
	<89b416e7-c0ca-7831-da13-683e8a74b7ae@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89b416e7-c0ca-7831-da13-683e8a74b7ae@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 09/10] virtiofsd: Optionally fill
	lo_inode.fhandle
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Reitz <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

On Tue, Aug 17, 2021 at 10:27:16AM +0200, Hanna Reitz wrote:
> On 16.08.21 21:44, Vivek Goyal wrote:
> > On Wed, Aug 11, 2021 at 08:41:18AM +0200, Hanna Reitz wrote:
> > 
> > [..]
> > > > > But given the inotify complications, there’s really a good reason we should
> > > > > use mountinfo.
> > > > > 
> > > > > > > It’s a bit tricky because our sandboxing prevents easy access to mountinfo,
> > > > > > > but if that’s the only way...
> > > > > > yes. We already have lo->proc_self_fd. Maybe we need to keep
> > > > > > /proc/self/mountinfo open in lo->proc_self_mountinfo. I am assuming
> > > > > > that any mount table changes will still be visible despite the fact
> > > > > > I have fd open (and don't have to open new fd to notice new mount/unmount
> > > > > > changes).
> > > > > Well, yes, that was my idea.  Unfortunately, I wasn’t quite successful yet;
> > > > > when I tried keeping the fd open, reading from it would just return 0
> > > > > bytes.  Perhaps that’s because we bind-mount /proc/self/fd to /proc so that
> > > > > nothing else in /proc is visible. Perhaps we need to bind-mount
> > > > > /proc/self/mountinfo into /proc/self/fd before that...
> > > > Or perhaps open /proc/self/mountinfo and save fd in lo->proc_mountinfo
> > > > before /proc/self/fd is bind mounted on /proc?
> > > Yes, I tried that, and then reading would just return 0 bytes.
> > Hi Hanna,
> > 
> > I tried this simple patch and I can read /proc/self/mountinfo before
> > bind mounting /proc/self/fd and after bind mounting /proc/self/fd. Am
> > I missing something.
> 
> Yes, but I tried reading it in the main loop (where we’d actually need it). 
> It looks like the umount2(".", MNT_DETACH) in setup_mounts() breaks it.

Good point. I modified my code and notice too that after umoutn2() it
always reads 0 bytes. I can understand that all the other mount points
could go away but new rootfs mount point of virtiofsd should still be
visible, IIUC. I don't understand why.

Anyway, I tried re-opening /proc/self/mountinfo file after umount2(".",
MNT_DETACH), and that seems to work and it shows root mount point. I 
created a bind mount and it shows that too.

So looks like quick fix can be that we re-open /proc/self/mountinfo. But
that means we can't bind /proc/self/fd on /proc/. We could bind mount
/proc/self on /proc. Not sure is it safe enough.

Here is the debug patch I tried.


---
 tools/virtiofsd/passthrough_ll.c |  101 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 5 deletions(-)

Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
===================================================================
--- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-08-16 15:29:27.712223551 -0400
+++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-08-17 15:40:20.456811218 -0400
@@ -172,6 +172,8 @@ struct lo_data {
 
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
+    int proc_mountinfo;
+    int proc_self;
     int user_killpriv_v2, killpriv_v2;
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
@@ -3403,12 +3405,56 @@ static void setup_wait_parent_capabiliti
     capng_apply(CAPNG_SELECT_BOTH);
 }
 
+static void read_mountinfo(struct lo_data *lo)
+{
+    char buf[4096];
+    ssize_t count, total_read = 0;
+    int ret;
+
+    ret = lseek(lo->proc_mountinfo, 0, SEEK_SET);
+    if (ret == -1) {
+            fuse_log(FUSE_LOG_ERR, "lseek(): %m\n");
+            exit(1);
+    }
+
+    do {
+        count = read(lo->proc_mountinfo, buf, 4095);
+        if (count == -1) {
+            fuse_log(FUSE_LOG_ERR, "read(/proc/self/mountinfo): %m\n");
+            exit(1);
+        }
+
+        //fuse_log(FUSE_LOG_INFO, "read(%d) bytes\n", count);
+        buf[count] = '\0';
+        fuse_log(FUSE_LOG_INFO, "%s", buf);
+        total_read += count;
+    } while(count);
+
+    fuse_log(FUSE_LOG_INFO, "read(%d) bytes\n", total_read);
+}
+
+static void reopen_mountinfo(struct lo_data *lo)
+{
+    int fd;
+
+    close(lo->proc_mountinfo);
+
+    fd = openat(lo->proc_self, "mountinfo", O_RDONLY);
+    if (fd == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(/proc/self/mountinfo, O_RDONLY): %m\n");
+        exit(1);
+    }
+
+    lo->proc_mountinfo = fd;
+}
+
 /*
  * Move to a new mount, net, and pid namespaces to isolate this process.
  */
 static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
 {
     pid_t child;
+    int fd;
 
     /*
      * Create a new pid namespace for *child* processes.  We'll have to
@@ -3472,21 +3518,35 @@ static void setup_namespaces(struct lo_d
         exit(1);
     }
 
+    fd = open("/proc/self/mountinfo", O_RDONLY);
+    if (fd == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(/proc/self/mountinfo, O_RDONLY): %m\n");
+        exit(1);
+    }
+
+    lo->proc_mountinfo = fd;
+
     /*
      * We only need /proc/self/fd. Prevent ".." from accessing parent
      * directories of /proc/self/fd by bind-mounting it over /proc. Since / was
      * previously remounted with MS_REC | MS_SLAVE this mount change only
      * affects our process.
      */
-    if (mount("/proc/self/fd", "/proc", NULL, MS_BIND, NULL) < 0) {
+    if (mount("/proc/self/", "/proc", NULL, MS_BIND, NULL) < 0) {
         fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, MS_BIND): %m\n");
         exit(1);
     }
 
     /* Get the /proc (actually /proc/self/fd, see above) file descriptor */
-    lo->proc_self_fd = open("/proc", O_PATH);
+    lo->proc_self_fd = open("/proc/fd", O_PATH);
     if (lo->proc_self_fd == -1) {
-        fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
+        fuse_log(FUSE_LOG_ERR, "open(/proc/fd, O_PATH): %m\n");
+        exit(1);
+    }
+
+    lo->proc_self = open("/proc/", O_PATH);
+    if (lo->proc_self == -1) {
+        fuse_log(FUSE_LOG_ERR, "open(/proc/self, O_PATH): %m\n");
         exit(1);
     }
 }
@@ -3524,7 +3584,7 @@ static void cleanup_capng(void)
  * Make the source directory our root so symlinks cannot escape and no other
  * files are accessible.  Assumes unshare(CLONE_NEWNS) was already called.
  */
-static void setup_mounts(const char *source)
+static void setup_mounts(const char *source, struct lo_data *lo)
 {
     int oldroot;
     int newroot;
@@ -3552,26 +3612,43 @@ static void setup_mounts(const char *sou
         exit(1);
     }
 
+    fuse_log(FUSE_LOG_INFO, "mountinfo before pivot_root()\n");
+    read_mountinfo(lo);
+
     if (syscall(__NR_pivot_root, ".", ".") < 0) {
         fuse_log(FUSE_LOG_ERR, "pivot_root(., .): %m\n");
         exit(1);
     }
 
+    fuse_log(FUSE_LOG_INFO, "mountinfo after pivot_root()\n");
+    read_mountinfo(lo);
+
     if (fchdir(oldroot) < 0) {
         fuse_log(FUSE_LOG_ERR, "fchdir(oldroot): %m\n");
         exit(1);
     }
 
+    fuse_log(FUSE_LOG_INFO, "mountinfo after fchdir()\n");
+    read_mountinfo(lo);
+
     if (mount("", ".", "", MS_SLAVE | MS_REC, NULL) < 0) {
         fuse_log(FUSE_LOG_ERR, "mount(., MS_SLAVE | MS_REC): %m\n");
         exit(1);
     }
 
+    fuse_log(FUSE_LOG_INFO, "mountinfo before umount2(., MNT_DETACH): %m\n");
+    reopen_mountinfo(lo);
+    read_mountinfo(lo);
+
     if (umount2(".", MNT_DETACH) < 0) {
         fuse_log(FUSE_LOG_ERR, "umount2(., MNT_DETACH): %m\n");
         exit(1);
     }
 
+    fuse_log(FUSE_LOG_INFO, "mountinfo after umount2(., MNT_DETACH): %m\n");
+    reopen_mountinfo(lo);
+    read_mountinfo(lo);
+
     if (fchdir(newroot) < 0) {
         fuse_log(FUSE_LOG_ERR, "fchdir(newroot): %m\n");
         exit(1);
@@ -3711,6 +3788,19 @@ static void setup_chroot(struct lo_data
     }
 }
 
+static void create_mount(struct lo_data *lo)
+{
+    const char *source="foo", *dest="bar";
+
+    if (mount(source, dest, NULL, MS_BIND | MS_REC, NULL) < 0) {
+        fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
+        exit(1);
+    }
+
+    fuse_log(FUSE_LOG_INFO, "mountinfo after mounting foo\n");
+    read_mountinfo(lo);
+}
+
 /*
  * Lock down this process to prevent access to other processes or files outside
  * source directory.  This reduces the impact of arbitrary code execution bugs.
@@ -3720,7 +3810,8 @@ static void setup_sandbox(struct lo_data
 {
     if (lo->sandbox == SANDBOX_NAMESPACE) {
         setup_namespaces(lo, se);
-        setup_mounts(lo->source);
+        setup_mounts(lo->source, lo);
+        create_mount(lo);
     } else {
         setup_chroot(lo);
     }

