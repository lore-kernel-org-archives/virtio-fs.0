From: Max Reitz <mreitz@redhat.com>
Date: Wed,  6 May 2020 17:40:09 +0200
Message-Id: <20200506154010.241055-1-mreitz@redhat.com>
In-Reply-To: <20200506153832.240812-1-mreitz@redhat.com>
References: <20200506153832.240812-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 1/2] virtiofsd: Store every lo_inode's parent_dev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Max Reitz <mreitz@redhat.com>

We want to detect mount points in the shared tree.  We report them to
the guest by setting st_rdev to their st_dev, but because the FUSE
client will create a submount for every directory that has st_rdev set,
we must do this only for the actual mount points.

We can detect mount points by comparing a directory's st_dev with its
parent's st_dev.  To be able to do so, we need to store the parent's
st_dev in the lo_inode object.

Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3ba1d90984..6cf471d31a 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -124,6 +124,14 @@ struct lo_inode {
     GHashTable *posix_locks; /* protected by lo_inode->plock_mutex */
 
     mode_t filetype;
+
+    /*
+     * So we can detect crossmount roots
+     * (As such, this only needs to be valid for directories.  Note
+     * that files can have multiple parents due to hard links, and so
+     * their parent_dev may fluctuate.)
+     */
+    dev_t parent_dev;
 };
 
 struct lo_cred {
@@ -673,6 +681,9 @@ retry:
     *parent = p;
     memmove(path, last, strlen(last) + 1);
 
+    /* Use this opportunity to update the inode's parent_dev */
+    inode->parent_dev = p->key.dev;
+
     return 0;
 
 fail_unref:
@@ -950,6 +961,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         g_hash_table_insert(lo->inodes, &inode->key, inode);
         pthread_mutex_unlock(&lo->mutex);
     }
+    inode->parent_dev = dir->key.dev;
     e->ino = inode->fuse_ino;
     lo_inode_put(lo, &inode);
     lo_inode_put(lo, &dir);
@@ -1208,6 +1220,14 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
     fuse_log(FUSE_LOG_DEBUG, "  %lli/%s -> %lli\n", (unsigned long long)parent,
              name, (unsigned long long)e.ino);
 
+    /*
+     * No need to update inode->parent_dev, because
+     * (1) We cannot, the inode now has more than one parent,
+     * (2) Directories cannot have more than one parent, so link()
+     *     does not work for them; but parent_dev only needs to be
+     *     valid for directories.
+     */
+
     fuse_reply_entry(req, &e);
     lo_inode_put(lo, &parent_inode);
     lo_inode_put(lo, &inode);
-- 
2.26.2

