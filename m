Date: Mon, 16 Aug 2021 15:44:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <YRrALRGy2cROwsP9@redhat.com>
References: <20210730150134.216126-1-mreitz@redhat.com>
	<20210730150134.216126-10-mreitz@redhat.com>
	<YRF2xjwSKOiqB/Al@redhat.com>
	<df64553c-c03d-076a-bcef-bec8554977a4@redhat.com>
	<YRKZ415xrDtcYaQR@redhat.com>
	<4a74bbbd-92f6-a7d1-0c8d-fa8b121b9643@redhat.com>
	<YRKh/fbBntF+GfS8@redhat.com>
	<6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e943ee0-dcb3-6812-3a0b-eb2b72b503ad@redhat.com>
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

On Wed, Aug 11, 2021 at 08:41:18AM +0200, Hanna Reitz wrote:

[..]
> > > But given the inotify complications, there’s really a good reason we should
> > > use mountinfo.
> > > 
> > > > > It’s a bit tricky because our sandboxing prevents easy access to mountinfo,
> > > > > but if that’s the only way...
> > > > yes. We already have lo->proc_self_fd. Maybe we need to keep
> > > > /proc/self/mountinfo open in lo->proc_self_mountinfo. I am assuming
> > > > that any mount table changes will still be visible despite the fact
> > > > I have fd open (and don't have to open new fd to notice new mount/unmount
> > > > changes).
> > > Well, yes, that was my idea.  Unfortunately, I wasn’t quite successful yet;
> > > when I tried keeping the fd open, reading from it would just return 0
> > > bytes.  Perhaps that’s because we bind-mount /proc/self/fd to /proc so that
> > > nothing else in /proc is visible. Perhaps we need to bind-mount
> > > /proc/self/mountinfo into /proc/self/fd before that...
> > Or perhaps open /proc/self/mountinfo and save fd in lo->proc_mountinfo
> > before /proc/self/fd is bind mounted on /proc?
> 
> Yes, I tried that, and then reading would just return 0 bytes.

Hi Hanna,

I tried this simple patch and I can read /proc/self/mountinfo before
bind mounting /proc/self/fd and after bind mounting /proc/self/fd. Am
I missing something.

Vivek

---
 tools/virtiofsd/passthrough_ll.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c
===================================================================
--- rhvgoyal-qemu.orig/tools/virtiofsd/passthrough_ll.c	2021-08-16 15:29:27.712223551 -0400
+++ rhvgoyal-qemu/tools/virtiofsd/passthrough_ll.c	2021-08-16 15:41:29.500032032 -0400
@@ -172,6 +172,7 @@ struct lo_data {
 
     /* An O_PATH file descriptor to /proc/self/fd/ */
     int proc_self_fd;
+    int proc_mountinfo;
     int user_killpriv_v2, killpriv_v2;
     /* If set, virtiofsd is responsible for setting umask during creation */
     bool change_umask;
@@ -3409,6 +3410,9 @@ static void setup_wait_parent_capabiliti
 static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
 {
     pid_t child;
+    int fd;
+    char buf[128];
+    ssize_t count;
 
     /*
      * Create a new pid namespace for *child* processes.  We'll have to
@@ -3472,6 +3476,24 @@ static void setup_namespaces(struct lo_d
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
+    count = read(lo->proc_mountinfo, buf, 127);
+    if (count == -1) {
+        fuse_log(FUSE_LOG_ERR, "read(/proc/self/mountinfo): %m\n");
+        exit(1);
+    }
+
+    fuse_log(FUSE_LOG_INFO, "read(%d) bytes\n", count);
+    buf[count] = '\0';
+    fuse_log(FUSE_LOG_INFO, "%s\n", buf);
+
     /*
      * We only need /proc/self/fd. Prevent ".." from accessing parent
      * directories of /proc/self/fd by bind-mounting it over /proc. Since / was
@@ -3489,6 +3511,16 @@ static void setup_namespaces(struct lo_d
         fuse_log(FUSE_LOG_ERR, "open(/proc, O_PATH): %m\n");
         exit(1);
     }
+
+    count = read(lo->proc_mountinfo, buf, 127);
+    if (count == -1) {
+        fuse_log(FUSE_LOG_ERR, "read(/proc/self/mountinfo): %m\n");
+        exit(1);
+    }
+
+    fuse_log(FUSE_LOG_INFO, "read(%d) bytes\n", count);
+    buf[count] = '\0';
+    fuse_log(FUSE_LOG_INFO, "%s\n", buf);
 }
 
 /*

