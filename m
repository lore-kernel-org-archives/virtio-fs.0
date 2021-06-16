From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Wed, 16 Jun 2021 15:39:16 -0400
Message-Id: <20210616193921.608720-2-iangelak@redhat.com>
In-Reply-To: <20210616193921.608720-1-iangelak@redhat.com>
References: <20210616193921.608720-1-iangelak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/6] virtiofsd: Release file locks using F_UNLCK
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: vgoyal@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

We are emulating posix locks for guest using open file description locks
in virtiofsd. When any of the fd is closed in guest, we find associated
OFD lock fd (if there is one) and close it to release all the locks.

Assumption here is that there is no other thread using lo_inode_plock
structure or plock->fd, hence it is safe to do so.

But now we are about to introduce blocking variant of locks (SETLKW),
and that means we might be waiting to a lock to be available and
using plock->fd. And that means there are still users of plock
structure.

So release locks using fcntl(SETLK, F_UNLCK) instead and plock will
be freed later.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 49c21fd855..f2fa9d95bb 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -968,6 +968,14 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
     return 0;
 }
 
+static void posix_locks_value_destroy(gpointer data)
+{
+    struct lo_inode_plock *plock = data;
+
+    close(plock->fd);
+    free(plock);
+}
+
 /*
  * Increments nlookup on the inode on success. unref_inode_lolocked() must be
  * called eventually to decrement nlookup again. If inodep is non-NULL, the
@@ -1473,9 +1481,6 @@ static void unref_inode(struct lo_data *lo, struct lo_inode *inode, uint64_t n)
         lo_map_remove(&lo->ino_map, inode->fuse_ino);
         g_hash_table_remove(lo->inodes, &inode->key);
         if (lo->posix_lock) {
-            if (g_hash_table_size(inode->posix_locks)) {
-                fuse_log(FUSE_LOG_WARNING, "Hash table is not empty\n");
-            }
             g_hash_table_destroy(inode->posix_locks);
             pthread_mutex_destroy(&inode->plock_mutex);
         }
@@ -1974,6 +1979,9 @@ static struct lo_inode_plock *lookup_create_plock_ctx(struct lo_data *lo,
     plock =
         g_hash_table_lookup(inode->posix_locks, GUINT_TO_POINTER(lock_owner));
 
+    fuse_log(FUSE_LOG_DEBUG, "lookup_create_plock_ctx():"
+             " Inserted element in posix_locks hash table"
+             " with value pointer %p\n", plock);
     if (plock) {
         return plock;
     }
@@ -2182,6 +2190,8 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
     (void)ino;
     struct lo_inode *inode;
     struct lo_data *lo = lo_data(req);
+    struct lo_inode_plock *plock;
+    struct flock flock;
 
     inode = lo_inode(req, ino);
     if (!inode) {
@@ -2198,8 +2208,22 @@ static void lo_flush(fuse_req_t req, fuse_ino_t ino, struct fuse_file_info *fi)
     /* An fd is going away. Cleanup associated posix locks */
     if (lo->posix_lock) {
         pthread_mutex_lock(&inode->plock_mutex);
-        g_hash_table_remove(inode->posix_locks,
+        plock = g_hash_table_lookup(inode->posix_locks,
             GUINT_TO_POINTER(fi->lock_owner));
+
+        if (plock) {
+            /*
+             * An fd is being closed. For posix locks, this means
+             * drop all the associated locks.
+             */
+            memset(&flock, 0, sizeof(struct flock));
+            flock.l_type = F_UNLCK;
+            flock.l_whence = SEEK_SET;
+            /* Unlock whole file */
+            flock.l_start = flock.l_len = 0;
+            fcntl(plock->fd, F_OFD_SETLK, &flock);
+        }
+
         pthread_mutex_unlock(&inode->plock_mutex);
     }
     res = close(dup(lo_fi_fd(req, fi)));
-- 
2.27.0

