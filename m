From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:55:40 -0500
Message-Id: <20191115205543.1816-2-vgoyal@redhat.com>
In-Reply-To: <20191115205543.1816-1-vgoyal@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/4] virtiofsd: Release file locks using F_UNLCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

We are emulating posix locks for guest using open file description locks
in virtiofsd. When any of the fd is closed in guest, we find associated
OFD lock fd (if there is one) and close it to release all the locks.

Assumption here is that there is no other thread using lo_inode_plock
structure or plock->fd, hence it is safe to do so.

But now we are about to introduce blocking variant of locks (SETLKW),
and that means we might be waiting to a lock to be available and
using plock->fd. And that means there are still users of plock structure.

So release locks using fcntl(SETLK, F_UNLCK) instead and plock will
be freed later.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/passthrough_ll.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index bc214df0c7..028e7da273 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -936,6 +936,14 @@ static void put_shared(struct lo_data *lo, struct lo_inode *inode)
 	}
 }
 
+static void release_plock(gpointer data)
+{
+	struct lo_inode_plock *plock = data;
+
+	close(plock->fd);
+	free(plock);
+}
+
 /* Increments nlookup and caller must release refcount using
  * lo_inode_put(&parent).
  */
@@ -994,7 +1002,8 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 		inode->key.ino = e->attr.st_ino;
 		inode->key.dev = e->attr.st_dev;
 		pthread_mutex_init(&inode->plock_mutex, NULL);
-		inode->posix_locks = g_hash_table_new(g_direct_hash, g_direct_equal);
+		inode->posix_locks = g_hash_table_new_full(g_direct_hash,
+					g_direct_equal, NULL, release_plock);
 
 		get_shared(lo, inode);
 
@@ -1436,9 +1445,6 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
 	if (!inode->nlookup) {
 		lo_map_remove(&lo->ino_map, inode->fuse_ino);
                 g_hash_table_remove(lo->inodes, &inode->key);
-		if (g_hash_table_size(inode->posix_locks)) {
-			fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
-		}
 		g_hash_table_destroy(inode->posix_locks);
 		pthread_mutex_destroy(&inode->plock_mutex);
 
@@ -1868,6 +1874,7 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
 	plock->fd = fd;
 	g_hash_table_insert(inode->posix_locks,
 			    GUINT_TO_POINTER(plock->lock_owner), plock);
+	fuse_log(FUSE_LOG_DEBUG, "lookup_create_plock_ctx(): Inserted element in posix_locks hash table with value pointer %p\n", plock);
 	return plock;
 }
 
@@ -2046,6 +2053,7 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 	(void) ino;
 	struct lo_inode *inode;
 	struct lo_inode_plock *plock;
+	struct flock flock;
 
 	inode = lo_inode(req, ino);
 	if (!inode) {
@@ -2058,14 +2066,16 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
 	plock = g_hash_table_lookup(inode->posix_locks,
 				    GUINT_TO_POINTER(fi->lock_owner));
 	if (plock) {
-		g_hash_table_remove(inode->posix_locks,
-				    GUINT_TO_POINTER(fi->lock_owner));
 		/*
-		 * We had used open() for locks and had only one fd. So
-		 * closing this fd should release all OFD locks.
+		 * An fd is being closed. For posix locks, this means
+		 * drop all the associated locks.
 		 */
-		close(plock->fd);
-		free(plock);
+		memset(&flock, 0, sizeof(struct flock));
+		flock.l_type = F_UNLCK;
+		flock.l_whence = SEEK_SET;
+		/* Unlock whole file */
+		flock.l_start = flock.l_len = 0;
+		fcntl(plock->fd, F_SETLK, &flock);
 	}
 	pthread_mutex_unlock(&inode->plock_mutex);
 
-- 
2.20.1

