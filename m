From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon,  7 Dec 2020 13:30:19 -0500
Message-Id: <20201207183021.22752-2-vgoyal@redhat.com>
In-Reply-To: <20201207183021.22752-1-vgoyal@redhat.com>
References: <20201207183021.22752-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/3] virtiofsd: Set up posix_lock hash table for
	root inode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, lersek@redhat.com, vgoyal@redhat.com

We setup per inode hash table ->posix_lock to support remote posix locks.
But we forgot to initialize this table for root inode.

Laszlo managed to trigger an issue where he sent a FUSE_FLUSH request for
root inode and lo_flush() found inode with inode->posix_lock NULL and
accessing this table crashed virtiofsd.

May be we can get rid of initializing this hash table for directory
objects completely. But that optimization is for another day.

Reported-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 97485b22b4..59202a843b 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3372,6 +3372,9 @@ static void setup_root(struct lo_data *lo, struct lo_inode *root)
     root->key.mnt_id = mnt_id;
     root->nlookup = 2;
     g_atomic_int_set(&root->refcount, 2);
+    pthread_mutex_init(&root->plock_mutex, NULL);
+    root->posix_locks = g_hash_table_new_full(
+        g_direct_hash, g_direct_equal, NULL, posix_locks_value_destroy);
 }
 
 static guint lo_key_hash(gconstpointer key)
@@ -3394,6 +3397,10 @@ static void fuse_lo_data_cleanup(struct lo_data *lo)
     if (lo->inodes) {
         g_hash_table_destroy(lo->inodes);
     }
+
+    if (lo->root.posix_locks)
+       g_hash_table_destroy(lo->root.posix_locks);
+
     lo_map_destroy(&lo->fd_map);
     lo_map_destroy(&lo->dirp_map);
     lo_map_destroy(&lo->ino_map);
-- 
2.25.4

