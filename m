From: Miklos Szeredi <mszeredi@redhat.com>
Date: Wed, 29 Apr 2020 14:47:33 +0200
Message-Id: <20200429124733.22488-1-mszeredi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: jail lo->proc_self_fd
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com

While it's not possible to escape the proc filesystem through
lo->proc_self_fd, it is possible to escape to the root of the proc
filesystem itself through "../..".

Use a temporary mount for opening lo->proc_self_fd, that has it's root at
/proc/self/fd/, preventing access to the ancestor directories.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 4c35c95b256c..bc9c44c760f4 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2536,6 +2536,8 @@ static void print_capabilities(void)
 static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
 {
     pid_t child;
+    char template[] = "virtiofsd-XXXXXX";
+    char *tmpdir;
 
     /*
      * Create a new pid namespace for *child* processes.  We'll have to
@@ -2597,12 +2599,33 @@ static void setup_namespaces(struct lo_data *lo, struct fuse_session *se)
         exit(1);
     }
 
+    tmpdir = mkdtemp(template);
+    if (!tmpdir) {
+        fuse_log(FUSE_LOG_ERR, "tmpdir(%s): %m\n", template);
+        exit(1);
+    }
+
+    if (mount("/proc/self/fd", tmpdir, NULL, MS_BIND, NULL) < 0) {
+        fuse_log(FUSE_LOG_ERR, "mount(/proc/self/fd, %s, MS_BIND): %m\n",
+                 tmpdir);
+        exit(1);
+    }
+
     /* Now we can get our /proc/self/fd directory file descriptor */
-    lo->proc_self_fd = open("/proc/self/fd", O_PATH);
+    lo->proc_self_fd = open(tmpdir, O_PATH);
     if (lo->proc_self_fd == -1) {
-        fuse_log(FUSE_LOG_ERR, "open(/proc/self/fd, O_PATH): %m\n");
+        fuse_log(FUSE_LOG_ERR, "open(%s, O_PATH): %m\n", tmpdir);
         exit(1);
     }
+
+    if (umount2(tmpdir, MNT_DETACH) < 0) {
+        fuse_log(FUSE_LOG_ERR, "umount2(%s, MNT_DETACH): %m\n", tmpdir);
+        exit(1);
+    }
+
+    if (rmdir(tmpdir) < 0) {
+        fuse_log(FUSE_LOG_ERR, "rmdir(%s): %m\n", tmpdir);
+    }
 }
 
 /*
-- 
2.21.1


