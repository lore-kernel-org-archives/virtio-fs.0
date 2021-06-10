DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding;
	bh=di2Bc1dMXaIWwytWrNJ6VH6k4Sm+c/u0WhK1IYB5KBI=;
	b=g/b4dJnjmu45IB3EwVUgsTx/PEueA4JduRxDAXsPu2qYNwY9gc4AGIxGobiZJXtw9y
	oNd3ZKKNhsW5ZVFqUGShGgisUrxVL25jWSFQMHq0UFaF0IQonpaW8iNqnKcO/EqhWPFa
	2y/RJPMDU1uHUpL6hoF0pDqIqtAa6xvfkJ/WxNOVcQaTx3qoi6AeJAAOUYJncyw+hRRC
	MFWZ1auGOumdbiCAzx2/8g1TdzYeg3sLCxnX2E9iPLVWMXg7iAQ26bP0WX9/RVsYzx08
	02x0e6Ixr+/jH0KnDQGq25MwTI6IgCglyWMD/obf+Ze3ov/5yAitQCV9b9wKVMhoO7J2
	OxAQ==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Thu, 10 Jun 2021 22:25:49 +0800
Message-Id: <20210610142549.33220-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH] virtiofsd: Avoid increasing nlookup when
	calling lookup_name
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: qemu-devel@nongnu.org

Commit 9257e514d861afa7 introduced lookup_name(), which will calls
lo_find(), to increase the refcount of the inodes used in lo_rename,
lo_rmdir, and lo_unlink.

However, as lo_find() increases both refcount and nlookup, and the
three functions do not need to increase nlookup, unref_inode_lolocked()
is called later in the three function to decrease nlookup by one.

This commit adds a increase_nlookup flag to lo_find(), it is set to
false when called from lookup_name(). This way we can make the behavior
more clear, and also makes it easier to maintain nlookup crash consistency
if we are introducing crash recovery feature in the future.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
 tools/virtiofsd/passthrough_ll.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 49c21fd855..3e7c2f6b9d 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -219,7 +219,7 @@ static struct {
 static __thread bool cap_loaded = 0;
 
 static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
-                                uint64_t mnt_id);
+                                uint64_t mnt_id, bool increase_nlookup);
 static int xattr_map_client(const struct lo_data *lo, const char *client_name,
                             char **out_name);
 
@@ -880,7 +880,7 @@ out_err:
 }
 
 static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
-                                uint64_t mnt_id)
+                                uint64_t mnt_id, bool increase_nlookup)
 {
     struct lo_inode *p;
     struct lo_key key = {
@@ -893,7 +893,9 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st,
     p = g_hash_table_lookup(lo->inodes, &key);
     if (p) {
         assert(p->nlookup > 0);
-        p->nlookup++;
+        if (increase_nlookup) {
+            p->nlookup++;
+        }
         g_atomic_int_inc(&p->refcount);
     }
     pthread_mutex_unlock(&lo->mutex);
@@ -1023,7 +1025,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         e->attr_flags |= FUSE_ATTR_SUBMOUNT;
     }
 
-    inode = lo_find(lo, &e->attr, mnt_id);
+    inode = lo_find(lo, &e->attr, mnt_id, true);
     if (inode) {
         close(newfd);
     } else {
@@ -1316,7 +1318,7 @@ out_err:
     fuse_reply_err(req, saverr);
 }
 
-/* Increments nlookup and caller must release refcount using lo_inode_put() */
+/* Caller must release refcount using lo_inode_put() */
 static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
                                     const char *name)
 {
@@ -1336,7 +1338,7 @@ static struct lo_inode *lookup_name(fuse_req_t req, fuse_ino_t parent,
         return NULL;
     }
 
-    return lo_find(lo, &attr, mnt_id);
+    return lo_find(lo, &attr, mnt_id, false);
 }
 
 static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
@@ -1364,7 +1366,6 @@ static void lo_rmdir(fuse_req_t req, fuse_ino_t parent, const char *name)
     res = unlinkat(lo_fd(req, parent), name, AT_REMOVEDIR);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
-    unref_inode_lolocked(lo, inode, 1);
     lo_inode_put(lo, &inode);
 }
 
@@ -1423,8 +1424,6 @@ static void lo_rename(fuse_req_t req, fuse_ino_t parent, const char *name,
 
     fuse_reply_err(req, res == -1 ? errno : 0);
 out:
-    unref_inode_lolocked(lo, oldinode, 1);
-    unref_inode_lolocked(lo, newinode, 1);
     lo_inode_put(lo, &oldinode);
     lo_inode_put(lo, &newinode);
     lo_inode_put(lo, &parent_inode);
@@ -1456,7 +1455,6 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
     res = unlinkat(lo_fd(req, parent), name, 0);
 
     fuse_reply_err(req, res == -1 ? errno : 0);
-    unref_inode_lolocked(lo, inode, 1);
     lo_inode_put(lo, &inode);
 }
 
-- 
2.20.1

