From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:27 +0100
Message-Id: <20210414155137.46522-16-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 15/25] DAX: virtiofsd: route se down to
	destroy method
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

We're going to need to pass the session down to destroy so that it can
pass it back to do the remove mapping.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c  | 6 +++---
 tools/virtiofsd/fuse_lowlevel.h  | 2 +-
 tools/virtiofsd/passthrough_ll.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 81c4c2b373..e82edce72a 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2222,7 +2222,7 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid,
     se->got_destroy = 1;
     se->got_init = 0;
     if (se->op.destroy) {
-        se->op.destroy(se->userdata);
+        se->op.destroy(se->userdata, se);
     }
 
     send_reply_ok(req, NULL, 0);
@@ -2449,7 +2449,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
             se->got_destroy = 1;
             se->got_init = 0;
             if (se->op.destroy) {
-                se->op.destroy(se->userdata);
+                se->op.destroy(se->userdata, se);
             }
         } else {
             goto reply_err;
@@ -2538,7 +2538,7 @@ void fuse_session_destroy(struct fuse_session *se)
 {
     if (se->got_init && !se->got_destroy) {
         if (se->op.destroy) {
-            se->op.destroy(se->userdata);
+            se->op.destroy(se->userdata, se);
         }
     }
     pthread_rwlock_destroy(&se->init_rwlock);
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 0bf206264d..27b07bfc22 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -209,7 +209,7 @@ struct fuse_lowlevel_ops {
      *
      * @param userdata the user data passed to fuse_session_new()
      */
-    void (*destroy)(void *userdata);
+    void (*destroy)(void *userdata, struct fuse_session *se);
 
     /**
      * Look up a directory entry by name and get its attributes.
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a9f0505414..910c4831fb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3124,7 +3124,7 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
     }
 }
 
-static void lo_destroy(void *userdata)
+static void lo_destroy(void *userdata, struct fuse_session *se)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
 
-- 
2.31.1

