Return-Path: <jefflexu@linux.alibaba.com>
From: Jeffle Xu <jefflexu@linux.alibaba.com>
Date: Mon, 16 May 2022 11:39:05 +0800
Message-Id: <20220516033906.58771-3-jefflexu@linux.alibaba.com>
In-Reply-To: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
References: <20220516033906.58771-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH v8 2/3] virtiofsd: implement DAX policies for
 per inodex DAX mode
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: vgoyal@redhat.com, stefanha@redhat.com, miklos@szeredi.hu, virtio-fs@redhat.com
Cc: joseph.qi@linux.alibaba.com, hsiangkao@linux.alibaba.com, haibinzhang@tencent.com, liudonghua@uniontech.com

Implement various dax policies when guest virtiofs is mounted in per
inode DAX mode. Currently there are four valid such policies, "none",
"always", "inode" and "filesize".

When "none" policy is specified, DAX is always disabled for all files;
Similarly, DAX is always enabled for all files when "always" policy is

When "inode" policy is specified, virtiofsd enables DAX or not depending
on the persistent FS_XFLAG_DAX inode flag.

When works in per inode DAX mode, ext4/xfs uses the persistent inode
flag, i.e. FS_DAX_FL/FS_XFLAG_DAX, to indicate if DAX shall be enabled
for this file or not. To keep the consistency of per inode DAX
semantics, virtiofs also supports enabling DAX depending on the
persistent inode flag, which may be set/cleared by users inside guest or
admin on host.

As for "filesize" policy, it is inspired by the scenario where DAX
window is run out and needs to be expanded to avoid the performance
fluctuation triggered by DAX window recaliming. Considering from the
perspective of memory overhead, it may not be wise to allocate DAX
window for files with size smaller than a specific threshold. The
threshold can be calculated from the hint that guest virtiofs manages
DAX mapping at 2MB granularity.

To maintain one DAX window chunk (2MB in size), 32KB (512 * 64 bytes)
memory footprint will be consumed for page descriptors inside guest.
Thus it'd better disable DAX for those files smaller than 32KB, to
reduce the demand for DAX window and thus avoid the unworthy memory
overhead. Thus only enable DAX for those with the file size greater
than 32 KB.

Besides, it is worth mentioning that both FUSE_LOOKUP and
FUSE_READDIRPLUS are affected, and will convey FUSE_ATTR_DAX flag to
the guest.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index f52398f1f4..00ec21bfc9 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -54,6 +54,7 @@
 #include <sys/syscall.h>
 #include <sys/wait.h>
 #include <sys/xattr.h>
+#include <sys/user.h>
 #include <syslog.h>
 #include <linux/fs.h>
 
@@ -61,6 +62,20 @@
 #include "passthrough_helpers.h"
 #include "passthrough_seccomp.h"
 
+/*
+ * One page descriptor (64 bytes in size) needs to be maintained for every page
+ * in the DAX window chunk, i.e., there is certain guest memory overhead when
+ * DAX is enabled. Thus disable DAX for those with file size smaller than this
+ * certain memory overhead if virtiofs is mounted in per inode DAX mode. In
+ * this case, the guest page cache will consume less memory than that when DAX
+ * is enabled.
+ */
+#define FUSE_DAX_SHIFT      21
+#define PAGE_DESC_SHIFT     6
+#define FUSE_INODE_DAX_SHIFT \
+    (FUSE_DAX_SHIFT - PAGE_SHIFT + PAGE_DESC_SHIFT)
+#define FUSE_INODE_DAX_THRESH  (1 << FUSE_INODE_DAX_SHIFT)
+
 /* Keep track of inode posix locks for each owner. */
 struct lo_inode_plock {
     uint64_t lock_owner;
@@ -138,6 +153,13 @@ enum {
     SANDBOX_CHROOT,
 };
 
+enum {
+    INODE_DAX_NONE,
+    INODE_DAX_ALWAYS,
+    INODE_DAX_INODE,
+    INODE_DAX_FILESIZE,
+};
+
 typedef struct xattr_map_entry {
     char *key;
     char *prepend;
@@ -163,6 +185,7 @@ struct lo_data {
     int readdirplus_clear;
     int allow_direct_io;
     int announce_submounts;
+    int dax;
     bool use_statx;
     struct lo_inode root;
     GHashTable *inodes; /* protected by lo->mutex */
@@ -1002,6 +1025,42 @@ static int do_statx(struct lo_data *lo, int dirfd, const char *pathname,
     return 0;
 }
 
+static int lo_should_enable_dax(struct lo_data *lo, struct lo_inode *inode,
+                                struct fuse_entry_param *e)
+{
+    if (lo->dax == INODE_DAX_NONE || !S_ISREG(e->attr.st_mode)) {
+        return 0;
+    }
+
+    if (lo->dax == INODE_DAX_ALWAYS) {
+        return 1;
+    }
+
+    if (lo->dax == INODE_DAX_INODE) {
+        int res, fd;
+        unsigned int attr;
+
+        fd = lo_inode_open(lo, inode, O_RDONLY);
+        if (fd == -1) {
+            return -1;
+        }
+
+        res = ioctl(fd, FS_IOC_GETFLAGS, &attr);
+        if (res == 0 && (attr & FS_DAX_FL)) {
+            res = 1;
+        }
+
+        close(fd);
+        return res;
+    }
+
+    if (lo->dax == INODE_DAX_FILESIZE) {
+        return e->attr.st_size > FUSE_INODE_DAX_THRESH;
+    }
+
+    return -1;
+}
+
 /*
  * Increments nlookup on the inode on success. unref_inode_lolocked() must be
  * called eventually to decrement nlookup again. If inodep is non-NULL, the
@@ -1049,6 +1108,7 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
     res = do_statx(lo, newfd, "", &e->attr, AT_EMPTY_PATH | AT_SYMLINK_NOFOLLOW,
                    &mnt_id);
     if (res == -1) {
+        close(newfd);
         goto out_err;
     }
 
@@ -1092,6 +1152,13 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
     }
     e->ino = inode->fuse_ino;
 
+    res = lo_should_enable_dax(lo, inode, e);
+    if (res == -1) {
+        goto out_err;
+    } else if (res == 1) {
+        e->attr_flags |= FUSE_ATTR_DAX;
+    }
+
     /* Transfer ownership of inode pointer to caller or drop it */
     if (inodep) {
         *inodep = inode;
@@ -1108,9 +1175,6 @@ static int lo_do_lookup(fuse_req_t req, fuse_ino_t parent, const char *name,
 
 out_err:
     saverr = errno;
-    if (newfd != -1) {
-        close(newfd);
-    }
     lo_inode_put(lo, &inode);
     lo_inode_put(lo, &dir);
     return saverr;
-- 
2.27.0

