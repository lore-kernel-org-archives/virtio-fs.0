From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Mon, 26 Oct 2020 18:43:28 +0000
Message-Id: <20201026184331.272953-14-dgilbert@redhat.com>
In-Reply-To: <20201026184331.272953-1-dgilbert@redhat.com>
References: <20201026184331.272953-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 13/16] virtiofsd: Store every lo_inode's
	parent_dev
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

We want to detect mount points in the shared tree.  We report them to
the guest by setting the FUSE_ATTR_SUBMOUNT flag in fuse_attr.flags, but
because the FUSE client will create a submount for every directory that
has this flag set, we must do this only for the actual mount points.

We can detect mount points by comparing a directory's st_dev with its
parent's st_dev.  To be able to do so, we need to store the parent's
st_dev in the lo_inode object.

Note that mount points need not necessarily be directories; a single
file can be a mount point as well.  However, for the sake of simplicity
let us ignore any non-directory mount points for now.

Signed-off-by: Max Reitz <mreitz@redhat.com>
Message-Id: <20200909184028.262297-6-mreitz@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index a0beb986f3..4188bf3ad2 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -125,6 +125,14 @@ struct lo_inode {
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
@@ -847,6 +855,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
         g_hash_table_insert(lo->inodes, &inode->key, inode);
         pthread_mutex_unlock(&lo->mutex);
     }
+    inode->parent_dev = dir->key.dev;
     e->ino = inode->fuse_ino;
     lo_inode_put(lo, &inode);
     lo_inode_put(lo, &dir);
@@ -1073,6 +1082,14 @@ static void lo_link(fuse_req_t req, fuse_ino_t ino, fuse_ino_t parent,
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
2.28.0

