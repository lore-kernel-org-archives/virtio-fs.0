From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:26 +0000
Message-Id: <20201026184331.272953-12-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 11/16] virtiofsd: Add attr_flags to
	fuse_entry_param
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, mreitz@redhat.com, misono.tomohiro@jp.fujitsu.com
Cc: virtio-fs@redhat.com, vgoyal@redhat.com

From: Max Reitz <mreitz@redhat.com>

fuse_entry_param is converted to fuse_attr on the line (by
fill_entry()), so it should have a member that mirrors fuse_attr.flags.

fill_entry() should then copy this fuse_entry_param.attr_flags to
fuse_attr.flags.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Message-Id: <20200909184028.262297-4-mreitz@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 13 +++++++++----
 tools/virtiofsd/fuse_lowlevel.h |  5 +++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 8679594255..00da84432c 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -329,7 +329,8 @@ static unsigned int calc_timeout_nsec(double t)
     }
 }
 
-static void fill_entry(struct fuse_entry_out *arg,
+static void fill_entry(struct fuse_session *se,
+                       struct fuse_entry_out *arg,
                        const struct fuse_entry_param *e)
 {
     *arg = (struct fuse_entry_out){
@@ -341,6 +342,10 @@ static void fill_entry(struct fuse_entry_out *arg,
         .attr_valid_nsec = calc_timeout_nsec(e->attr_timeout),
     };
     convert_stat(&e->attr, &arg->attr);
+
+    if (se->conn.capable & FUSE_CAP_ATTR_FLAGS) {
+        arg->attr.flags = e->attr_flags;
+    }
 }
 
 /*
@@ -365,7 +370,7 @@ size_t fuse_add_direntry_plus(fuse_req_t req, char *buf, size_t bufsize,
 
     struct fuse_direntplus *dp = (struct fuse_direntplus *)buf;
     memset(&dp->entry_out, 0, sizeof(dp->entry_out));
-    fill_entry(&dp->entry_out, e);
+    fill_entry(req->se, &dp->entry_out, e);
 
     struct fuse_dirent *dirent = &dp->dirent;
     *dirent = (struct fuse_dirent){
@@ -403,7 +408,7 @@ int fuse_reply_entry(fuse_req_t req, const struct fuse_entry_param *e)
     size_t size = sizeof(arg);
 
     memset(&arg, 0, sizeof(arg));
-    fill_entry(&arg, e);
+    fill_entry(req->se, &arg, e);
     return send_reply_ok(req, &arg, size);
 }
 
@@ -416,7 +421,7 @@ int fuse_reply_create(fuse_req_t req, const struct fuse_entry_param *e,
     struct fuse_open_out *oarg = (struct fuse_open_out *)(buf + entrysize);
 
     memset(buf, 0, sizeof(buf));
-    fill_entry(earg, e);
+    fill_entry(req->se, earg, e);
     fill_open(oarg, f);
     return send_reply_ok(req, buf, entrysize + sizeof(struct fuse_open_out));
 }
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 562fd5241e..9c06240f9e 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -102,6 +102,11 @@ struct fuse_entry_param {
      *  large value.
      */
     double entry_timeout;
+
+    /**
+     * Flags for fuse_attr.flags that do not fit into attr.
+     */
+    uint32_t attr_flags;
 };
 
 /**
-- 
2.28.0

