From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 16 Feb 2022 17:36:20 +0000
Message-Id: <20220216173625.128109-8-dgilbert@redhat.com>
In-Reply-To: <20220216173625.128109-1-dgilbert@redhat.com>
References: <20220216173625.128109-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 07/12] virtiofsd: Move core file creation code in
	separate function
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, groug@kaod.org, sebastian.hasler@stuvus.uni-stuttgart.de
Cc: virtio-fs@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Move core file creation bits in a separate function. Soon this is going
to get more complex as file creation need to set security context also.
And there will be multiple modes of file creation in next patch.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Message-Id: <20220208204813.682906-7-vgoyal@redhat.com>
Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 36 ++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 3e56d1cd95..e27479f1c9 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2001,6 +2001,30 @@ static int lo_do_open(struct lo_data *lo, struct lo_inode *inode,
     return 0;
 }
 
+static int do_lo_create(fuse_req_t req, struct lo_inode *parent_inode,
+                        const char *name, mode_t mode,
+                        struct fuse_file_info *fi, int* open_fd)
+{
+    int err = 0, fd;
+    struct lo_cred old = {};
+    struct lo_data *lo = lo_data(req);
+
+    err = lo_change_cred(req, &old, lo->change_umask);
+    if (err) {
+        return err;
+    }
+
+    /* Try to create a new file but don't open existing files */
+    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
+    if (fd == -1) {
+        err = errno;
+    } else {
+        *open_fd = fd;
+    }
+    lo_restore_cred(&old, lo->change_umask);
+    return err;
+}
+
 static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
                       mode_t mode, struct fuse_file_info *fi)
 {
@@ -2010,7 +2034,6 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
     struct lo_inode *inode = NULL;
     struct fuse_entry_param e;
     int err;
-    struct lo_cred old = {};
 
     fuse_log(FUSE_LOG_DEBUG, "lo_create(parent=%" PRIu64 ", name=%s)"
              " kill_priv=%d\n", parent, name, fi->kill_priv);
@@ -2026,18 +2049,9 @@ static void lo_create(fuse_req_t req, fuse_ino_t parent, const char *name,
         return;
     }
 
-    err = lo_change_cred(req, &old, lo->change_umask);
-    if (err) {
-        goto out;
-    }
-
     update_open_flags(lo->writeback, lo->allow_direct_io, fi);
 
-    /* Try to create a new file but don't open existing files */
-    fd = openat(parent_inode->fd, name, fi->flags | O_CREAT | O_EXCL, mode);
-    err = fd == -1 ? errno : 0;
-
-    lo_restore_cred(&old, lo->change_umask);
+    err = do_lo_create(req, parent_inode, name, mode, fi, &fd);
 
     /* Ignore the error if file exists and O_EXCL was not given */
     if (err && (err != EEXIST || (fi->flags & O_EXCL))) {
-- 
2.35.1

