From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:14 +0000
Message-Id: <20210209190224.62827-15-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 14/24] DAX: virtiofsd: route se down to destroy
	method
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

We're going to need to pass the session down to destroy so that it can
pass it back to do the remove mapping.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c  | 6 +++---
 tools/virtiofsd/fuse_lowlevel.h  | 2 +-
 tools/virtiofsd/passthrough_ll.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index f74583e095..99ba000c2e 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2212,7 +2212,7 @@ static void do_destroy(fuse_req_t req, fuse_ino_t nodeid,
     se->got_destroy = 1;
     se->got_init = 0;
     if (se->op.destroy) {
-        se->op.destroy(se->userdata);
+        se->op.destroy(se->userdata, se);
     }
 
     send_reply_ok(req, NULL, 0);
@@ -2439,7 +2439,7 @@ void fuse_session_process_buf_int(struct fuse_session *se,
             se->got_destroy = 1;
             se->got_init = 0;
             if (se->op.destroy) {
-                se->op.destroy(se->userdata);
+                se->op.destroy(se->userdata, se);
             }
         } else {
             goto reply_err;
@@ -2527,7 +2527,7 @@ void fuse_session_destroy(struct fuse_session *se)
 {
     if (se->got_init && !se->got_destroy) {
         if (se->op.destroy) {
-            se->op.destroy(se->userdata);
+            se->op.destroy(se->userdata, se);
         }
     }
     pthread_rwlock_destroy(&se->init_rwlock);
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 014564ff07..53439f5432 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -208,7 +208,7 @@ struct fuse_lowlevel_ops {
      *
      * @param userdata the user data passed to fuse_session_new()
      */
-    void (*destroy)(void *userdata);
+    void (*destroy)(void *userdata, struct fuse_session *se);
 
     /**
      * Look up a directory entry by name and get its attributes.
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 971ff2b2ea..badac23fef 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2943,7 +2943,7 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
     }
 }
 
-static void lo_destroy(void *userdata)
+static void lo_destroy(void *userdata, struct fuse_session *se)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
 
-- 
2.29.2

