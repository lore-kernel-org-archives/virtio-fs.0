Return-Path: <zhangjiachen.jaycee@bytedance.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=AiDm+83/VDbozzVf3AWSlrdlCGBECNCktU5HJHthiAs=;
 b=VS6+ksV8eaaAXSlBA5ZSltuFWyms6zYCinT4+IDsZ/vZMCPFmSHFKvag971CGJ5O/l
 0A4QNLMTwrEm4L2ow9KccAZJEqIAvLmI2q0805bosSmK94it4jcGFD5z2Vagb0F8Hu7H
 V/CeXGpDJVupb+lJ9Uwem17Ms9CIsUxTleeEwzHkIUaTIDSyxCZ/xo3dl2R7jM6TlPgf
 XK4AioBF0Avg/jRx8zt5xivG98lwuuYfKogCx3AtlAktQwRH4Z0EtLNneaZPALrshDbj
 oNzlEaoe9YgRDuSuzWh8nEs7vU3Lo44vSn2YzW7FQl+/BfWjoFEQrTtrC+r2pnPnvh9W
 G7bw==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Sun, 11 Dec 2022 18:47:43 +0800
Message-Id: <20221211104743.27333-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH] virtiofsd: support setting multiple request
 virtqueues
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, Connor Kuehl <ckuehl@redhat.com>

Add an option '-o num_request_queues' to configure the queue number,
currently the total number of vqs should be (1 hiprio queue +
num_request_queues).

The code is based on Connor's previous version in the virtio-fs
mailing-list [1], but change the semantic of the new option from total
queue number to request queue number.

The corresponding virtio-fs kernel part modification can be found at the
mail [2].

Link:
[1] https://www.mail-archive.com/virtio-fs@redhat.com/msg03333.html
[2] https://lore.kernel.org/linux-fsdevel/20221211103857.25805-1-zhangjiachen.jaycee@bytedance.com/
Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
 tools/virtiofsd/fuse_lowlevel.c  |  4 ++--
 tools/virtiofsd/fuse_lowlevel.h  |  2 +-
 tools/virtiofsd/fuse_virtio.c    | 20 +++-----------------
 tools/virtiofsd/fuse_virtio.h    |  2 +-
 tools/virtiofsd/helper.c         |  4 ++++
 tools/virtiofsd/passthrough_ll.c | 12 +++++++++++-
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 2f08471627..528492d2cf 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2708,9 +2708,9 @@ out1:
     return NULL;
 }
 
-int fuse_session_mount(struct fuse_session *se)
+int fuse_session_mount(struct fuse_session *se, unsigned int num_queues)
 {
-    return virtio_session_mount(se);
+    return virtio_session_mount(se, num_queues);
 }
 
 int fuse_session_fd(struct fuse_session *se)
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index b889dae4de..aee02d3e91 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1856,7 +1856,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
  *
  * @return 0 on success, -1 on failure.
  **/
-int fuse_session_mount(struct fuse_session *se);
+int fuse_session_mount(struct fuse_session *se, unsigned int num_queues);
 
 /**
  * Enter a single threaded, blocking event loop.
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 9368e292e4..a3ebcbea8e 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -762,20 +762,6 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
              started);
     assert(qidx >= 0);
 
-    /*
-     * Ignore additional request queues for now.  passthrough_ll.c must be
-     * audited for thread-safety issues first.  It was written with a
-     * well-behaved client in mind and may not protect against all types of
-     * races yet.
-     */
-    if (qidx > 1) {
-        fuse_log(FUSE_LOG_ERR,
-                 "%s: multiple request queues not yet implemented, please only "
-                 "configure 1 request queue\n",
-                 __func__);
-        exit(EXIT_FAILURE);
-    }
-
     if (started) {
         /* Fire up a thread to watch this queue */
         if (qidx >= vud->nqueues) {
@@ -1011,7 +997,7 @@ static int fv_create_listen_socket(struct fuse_session *se)
     return 0;
 }
 
-int virtio_session_mount(struct fuse_session *se)
+int virtio_session_mount(struct fuse_session *se, unsigned int num_queues)
 {
     int ret;
 
@@ -1057,8 +1043,8 @@ int virtio_session_mount(struct fuse_session *se)
     se->vu_socketfd = data_sock;
     se->virtio_dev->se = se;
     pthread_rwlock_init(&se->virtio_dev->vu_dispatch_rwlock, NULL);
-    if (!vu_init(&se->virtio_dev->dev, 2, se->vu_socketfd, fv_panic, NULL,
-                 fv_set_watch, fv_remove_watch, &fv_iface)) {
+    if (!vu_init(&se->virtio_dev->dev, num_queues, se->vu_socketfd,
+                fv_panic, NULL, fv_set_watch, fv_remove_watch, &fv_iface)) {
         fuse_log(FUSE_LOG_ERR, "%s: vu_init failed\n", __func__);
         return -1;
     }
diff --git a/tools/virtiofsd/fuse_virtio.h b/tools/virtiofsd/fuse_virtio.h
index 111684032c..a0e78b9b84 100644
--- a/tools/virtiofsd/fuse_virtio.h
+++ b/tools/virtiofsd/fuse_virtio.h
@@ -18,7 +18,7 @@
 
 struct fuse_session;
 
-int virtio_session_mount(struct fuse_session *se);
+int virtio_session_mount(struct fuse_session *se, unsigned int num_queues);
 void virtio_session_close(struct fuse_session *se);
 int virtio_loop(struct fuse_session *se);
 
diff --git a/tools/virtiofsd/helper.c b/tools/virtiofsd/helper.c
index f5f66f292c..b5138ce17d 100644
--- a/tools/virtiofsd/helper.c
+++ b/tools/virtiofsd/helper.c
@@ -191,6 +191,10 @@ void fuse_cmdline_help(void)
            "    -o killpriv_v2/no_killpriv_v2\n"
            "                               Enable/Disable FUSE_HANDLE_KILLPRIV_V2.\n"
            "                               (default: enabled as long as client supports it)\n"
+           "    -o num_request_queues=<num>\n"
+           "                               set maximum number of request virtqueues\n"
+           "                               supported by virtiofsd"
+           "                               default: 1\n"
            );
 }
 
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 20f0f41f99..f9d8075835 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -182,6 +182,7 @@ struct lo_data {
     /* Keeps track if /proc/<pid>/attr/fscreate should be used or not */
     bool use_fscreate;
     int user_security_label;
+    int num_request_queues;
 };
 
 static const struct fuse_opt lo_opts[] = {
@@ -218,6 +219,8 @@ static const struct fuse_opt lo_opts[] = {
     { "no_posix_acl", offsetof(struct lo_data, user_posix_acl), 0 },
     { "security_label", offsetof(struct lo_data, user_security_label), 1 },
     { "no_security_label", offsetof(struct lo_data, user_security_label), 0 },
+    { "num_request_queues=%d",
+      offsetof(struct lo_data, num_request_queues), 1 },
     FUSE_OPT_END
 };
 static bool use_syslog = false;
@@ -4479,6 +4482,12 @@ int main(int argc, char *argv[])
 
     lo.use_statx = true;
 
+    if (lo.num_request_queues < 1) {
+        fuse_log(FUSE_LOG_ERR, "num_request_queues must be at least 1 (got %d)"
+                 "\n", lo.num_request_queues);
+        exit(1);
+    }
+
     se = fuse_session_new(&args, &lo_oper, sizeof(lo_oper), &lo);
     if (se == NULL) {
         goto err_out1;
@@ -4488,7 +4497,8 @@ int main(int argc, char *argv[])
         goto err_out2;
     }
 
-    if (fuse_session_mount(se) != 0) {
+    /* There will be 1 hirpio queue plus lo.num_request_queues request queues */
+    if (fuse_session_mount(se, lo.num_request_queues + 1) != 0) {
         goto err_out3;
     }
 
-- 
2.20.1

