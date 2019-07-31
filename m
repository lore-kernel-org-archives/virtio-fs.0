From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 31 Jul 2019 17:10:04 +0100
Message-Id: <20190731161006.9447-4-stefanha@redhat.com>
In-Reply-To: <20190731161006.9447-1-stefanha@redhat.com>
References: <20190731161006.9447-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/5] virtiofsd: rename inode->refcount to
	inode->nlookup
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org

This reference counter plays a specific role in the FUSE protocol.  It's
not a generic object reference counter and the FUSE kernel code calls it
"nlookup".

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 36 ++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index e1d729d26b..135123366a 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -97,7 +97,19 @@ struct lo_inode {
 	int fd;
 	bool is_symlink;
 	struct lo_key key;
-	uint64_t refcount; /* protected by lo->mutex */
+
+	/* This counter keeps the inode alive during the FUSE session.
+	 * Incremented when the FUSE inode number is sent in a reply
+	 * (FUSE_LOOKUP, FUSE_READDIRPLUS, etc).  Decremented when an inode is
+	 * released by requests like FUSE_FORGET, FUSE_RMDIR, FUSE_RENAME, etc.
+	 *
+	 * Note that this value is untrusted because the client can manipulate
+	 * it arbitrarily using FUSE_FORGET requests.
+	 *
+	 * Protected by lo->mutex.
+	 */
+	uint64_t nlookup;
+
 	uint64_t version_offset;
 	uint64_t ireg_refid;
 	fuse_ino_t fuse_ino;
@@ -485,7 +497,7 @@ retry:
 	if (last == path) {
 		p = &lo->root;
 		pthread_mutex_lock(&lo->mutex);
-		p->refcount++;
+		p->nlookup++;
 		pthread_mutex_unlock(&lo->mutex);
 	} else {
 		*last = '\0';
@@ -688,8 +700,8 @@ static struct lo_inode *lo_find(struct lo_data *lo, struct stat *st)
 	pthread_mutex_lock(&lo->mutex);
 	p = g_hash_table_lookup(lo->inodes, &key);
 	if (p) {
-		assert(p->refcount > 0);
-		p->refcount++;
+		assert(p->nlookup > 0);
+		p->nlookup++;
 	}
 	pthread_mutex_unlock(&lo->mutex);
 
@@ -797,7 +809,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 			goto out_err;
 
 		inode->is_symlink = S_ISLNK(e->attr.st_mode);
-		inode->refcount = 1;
+		inode->nlookup = 1;
 		inode->fd = newfd;
 		newfd = -1;
 		inode->key.ino = e->attr.st_ino;
@@ -1051,7 +1063,7 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
 		goto out_err;
 
 	pthread_mutex_lock(&lo->mutex);
-	inode->refcount++;
+	inode->nlookup++;
 	pthread_mutex_unlock(&lo->mutex);
 	e.ino = inode->fuse_ino;
 	update_version(lo, inode);
@@ -1200,9 +1212,9 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 		return;
 
 	pthread_mutex_lock(&lo->mutex);
-	assert(inode->refcount >= n);
-	inode->refcount -= n;
-	if (!inode->refcount) {
+	assert(inode->nlookup >= n);
+	inode->nlookup -= n;
+	if (!inode->nlookup) {
 		lo_map_remove(&lo->ino_map, inode->fuse_ino);
                 g_hash_table_remove(lo->inodes, &inode->key);
 		if (g_hash_table_size(inode->posix_locks)) {
@@ -1225,7 +1237,7 @@ static int unref_all_inodes_cb(gpointer key, gpointer value,
 	struct lo_inode *inode  = value;
 	struct lo_data *lo = user_data;
 
-	inode->refcount = 0;
+	inode->nlookup = 0;
 	lo_map_remove(&lo->ino_map, inode->fuse_ino);
 	close(inode->fd);
 
@@ -1252,7 +1264,7 @@ static void lo_forget_one(fuse_req_t req, fuse_ino_t ino, uint64_t nlookup)
 	if (lo_debug(req)) {
 		fuse_debug("  forget %lli %lli -%lli\n",
 			   (unsigned long long) ino,
-			   (unsigned long long) inode->refcount,
+			   (unsigned long long) inode->nlookup,
 			   (unsigned long long) nlookup);
 	}
 
@@ -2581,7 +2593,7 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
 	root->fd = fd;
 	root->key.ino = stat.st_ino;
 	root->key.dev = stat.st_dev;
-	root->refcount = 2;
+	root->nlookup = 2;
 }
 
 static void setup_proc_self_fd(struct lo_data *lo)
-- 
2.21.0

