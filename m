From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Fri, 23 Aug 2019 16:02:45 +0100
Message-Id: <20190823150245.17246-3-dgilbert@redhat.com>
In-Reply-To: <20190823150245.17246-1-dgilbert@redhat.com>
References: <20190823150245.17246-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: Convert lo_destroy to take the
	lo->mutex lock itself
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, stefanha@redhat.com, vgoyal@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

lo_destroy was relying on some implicit knowledge of the locking;
we can avoid this if we create an unref_inode that doesn't take
the lock and then grab it for the whole of the lo_destroy.

Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index 20b6c7ae91..0ef01b7e3f 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -1416,12 +1416,12 @@ static void lo_unlink(fuse_req_t req, fuse_ino_t parent, const char *name)
 	lo_inode_put(lo, &inode);
 }
 
-static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
+/* To be called with lo->mutex held */
+static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 {
 	if (!inode)
 		return;
 
-	pthread_mutex_lock(&lo->mutex);
 	assert(inode->nlookup >= n);
 	inode->nlookup -= n;
 	if (!inode->nlookup) {
@@ -1432,15 +1432,22 @@ static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uin
 		}
 		g_hash_table_destroy(inode->posix_locks);
 		pthread_mutex_destroy(&inode->plock_mutex);
-		pthread_mutex_unlock(&lo->mutex);
 
 		/* Drop our refcount from lo_do_lookup() */
 		lo_inode_put(lo, &inode);
-	} else {
-		pthread_mutex_unlock(&lo->mutex);
 	}
 }
 
+static void unref_inode_lolocked(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
+{
+	if (!inode)
+		return;
+
+	pthread_mutex_lock(&lo->mutex);
+	unref_inode(lo, inode, n);
+	pthread_mutex_unlock(&lo->mutex);
+}
+
 static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
 {
 	struct lo_data *lo = lo_data(req);
@@ -2561,12 +2568,7 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
                 }
         }
 
-        /* Normally lo->mutex must be taken when traversing lo->inodes but
-         * lo_destroy() is a serialized request so no races are possible here.
-         *
-         * In addition, we cannot acquire lo->mutex since unref_inode() takes it
-         * too and this would result in a recursive lock.
-         */
+        pthread_mutex_lock(&lo->mutex);
         while (true) {
                 GHashTableIter iter;
                 gpointer key, value;
@@ -2577,8 +2579,9 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
                 }
 
                 struct lo_inode *inode = value;
-                unref_inode_lolocked(lo, inode, inode->nlookup);
+                unref_inode(lo, inode, inode->nlookup);
         }
+        pthread_mutex_unlock(&lo->mutex);
 }
 
 static struct fuse_lowlevel_ops lo_oper = {
-- 
2.21.0

