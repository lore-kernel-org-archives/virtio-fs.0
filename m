From: Greg Kurz <groug@kaod.org>
Date: Mon, 10 May 2021 17:55:39 +0200
Message-Id: <20210510155539.998747-4-groug@kaod.org>
In-Reply-To: <20210510155539.998747-1-groug@kaod.org>
References: <20210510155539.998747-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [for-6.1 v3 3/3] virtiofsd: Add support for FUSE_SYNCFS
	request
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>, virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>, Paolo Bonzini <pbonzini@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

Honor the expected behavior of syncfs() to synchronously flush all data
and metadata on linux systems. Simply loop on all known submounts and
call syncfs() on them.

Note that syncfs() might suffer from a time penalty if the submounts
are being hammered by some unrelated workload on the host. The only
solution to avoid that is to avoid shared submounts.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/fuse_lowlevel.c       | 11 ++++++++
 tools/virtiofsd/fuse_lowlevel.h       | 12 +++++++++
 tools/virtiofsd/passthrough_ll.c      | 38 +++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 4 files changed, 62 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index 58e32fc96369..3be95ec903c9 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1870,6 +1870,16 @@ static void do_lseek(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static void do_syncfs(fuse_req_t req, fuse_ino_t nodeid,
+                      struct fuse_mbuf_iter *iter)
+{
+    if (req->se->op.syncfs) {
+        req->se->op.syncfs(req);
+    } else {
+        fuse_reply_err(req, ENOSYS);
+    }
+}
+
 static void do_init(fuse_req_t req, fuse_ino_t nodeid,
                     struct fuse_mbuf_iter *iter)
 {
@@ -2267,6 +2277,7 @@ static struct {
     [FUSE_RENAME2] = { do_rename2, "RENAME2" },
     [FUSE_COPY_FILE_RANGE] = { do_copy_file_range, "COPY_FILE_RANGE" },
     [FUSE_LSEEK] = { do_lseek, "LSEEK" },
+    [FUSE_SYNCFS] = { do_syncfs, "SYNCFS" },
 };
 
 #define FUSE_MAXOP (sizeof(fuse_ll_ops) / sizeof(fuse_ll_ops[0]))
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index 3bf786b03485..890c520b195a 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1225,6 +1225,18 @@ struct fuse_lowlevel_ops {
      */
     void (*lseek)(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
                   struct fuse_file_info *fi);
+
+    /**
+     * Synchronize file system content
+     *
+     * If this request is answered with an error code of ENOSYS,
+     * this is treated as success and future calls to syncfs() will
+     * succeed automatically without being sent to the filesystem
+     * process.
+     *
+     * @param req request handle
+     */
+    void (*syncfs)(fuse_req_t req);
 };
 
 /**
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index dc940a1d048b..289900c6d274 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3153,6 +3153,43 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
     }
 }
 
+static void lo_syncfs(fuse_req_t req)
+{
+    struct lo_data *lo = lo_data(req);
+    GHashTableIter iter;
+    gpointer key, value;
+    int err = 0;
+
+    pthread_mutex_lock(&lo->mutex);
+
+    g_hash_table_iter_init(&iter, lo->mnt_inodes);
+    while (g_hash_table_iter_next(&iter, &key, &value)) {
+        struct lo_inode *inode = value;
+        int fd;
+
+        fuse_log(FUSE_LOG_DEBUG, "lo_syncfs(ino=%" PRIu64 ")\n",
+                 inode->fuse_ino);
+
+        fd = lo_inode_open(lo, inode, O_RDONLY);
+        if (fd < 0) {
+            err = -fd;
+            break;
+        }
+
+        if (syncfs(fd) < 0) {
+            err = errno;
+            close(fd);
+            break;
+        }
+
+        close(fd);
+    }
+
+    pthread_mutex_unlock(&lo->mutex);
+
+    fuse_reply_err(req, err);
+}
+
 static void lo_destroy(void *userdata)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
@@ -3214,6 +3251,7 @@ static struct fuse_lowlevel_ops lo_oper = {
     .copy_file_range = lo_copy_file_range,
 #endif
     .lseek = lo_lseek,
+    .syncfs = lo_syncfs,
     .destroy = lo_destroy,
 };
 
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index 62441cfcdb95..343188447901 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -107,6 +107,7 @@ static const int syscall_allowlist[] = {
     SCMP_SYS(set_robust_list),
     SCMP_SYS(setxattr),
     SCMP_SYS(symlinkat),
+    SCMP_SYS(syncfs),
     SCMP_SYS(time), /* Rarely needed, except on static builds */
     SCMP_SYS(tgkill),
     SCMP_SYS(unlinkat),
-- 
2.26.3

