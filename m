From: Greg Kurz <groug@kaod.org>
Date: Tue, 25 Jan 2022 15:12:12 +0100
Message-Id: <20220125141213.361930-3-groug@kaod.org>
In-Reply-To: <20220125141213.361930-1-groug@kaod.org>
References: <20220125141213.361930-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 2/2] virtiofsd: Add support for FUSE_SYNCFS
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
Cc: virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

Honor the expected behavior of syncfs() to synchronously flush all data
and metadata on linux systems.

If virtiofsd is started with '-o announce_submounts', the client is
expected to send a FUSE_SYNCFS request for each individual submount.
In this case, we just create a new file descriptor on the submount
inode with lo_inode_open(), call syncfs() on it and close it. The
intermediary file is needed because O_PATH descriptors aren't
backed by an actual file and syncfs() would fail with EBADF.

If virtiofsd is started without '-o announce_submounts', the client
only sends a single FUSE_SYNCFS request, for the root inode. In this
case, we need to loop on all known submounts to sync them. We cannot
call syncfs() with the lo->mutex held since it could stall virtiofsd
for an unbounded time : let's generate the list of inodes with the
mutex held, drop the mutex and then loop on the temporary list. A
reference must be taken on each inode to ensure it doesn't go away
when the mutex is dropped.

Note that syncfs() might suffer from a time penalty if the submounts
are being hammered by some unrelated workload on the host. The only
solution to prevent that is to avoid shared mounts.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 tools/virtiofsd/fuse_lowlevel.c       | 11 +++
 tools/virtiofsd/fuse_lowlevel.h       | 13 ++++
 tools/virtiofsd/passthrough_ll.c      | 98 +++++++++++++++++++++++++++
 tools/virtiofsd/passthrough_seccomp.c |  1 +
 4 files changed, 123 insertions(+)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index e4679c73abc2..e02d8b25a5f6 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -1876,6 +1876,16 @@ static void do_lseek(fuse_req_t req, fuse_ino_t nodeid,
     }
 }
 
+static void do_syncfs(fuse_req_t req, fuse_ino_t nodeid,
+                      struct fuse_mbuf_iter *iter)
+{
+    if (req->se->op.syncfs) {
+        req->se->op.syncfs(req, nodeid);
+    } else {
+        fuse_reply_err(req, ENOSYS);
+    }
+}
+
 static void do_init(fuse_req_t req, fuse_ino_t nodeid,
                     struct fuse_mbuf_iter *iter)
 {
@@ -2280,6 +2290,7 @@ static struct {
     [FUSE_RENAME2] = { do_rename2, "RENAME2" },
     [FUSE_COPY_FILE_RANGE] = { do_copy_file_range, "COPY_FILE_RANGE" },
     [FUSE_LSEEK] = { do_lseek, "LSEEK" },
+    [FUSE_SYNCFS] = { do_syncfs, "SYNCFS" },
 };
 
 #define FUSE_MAXOP (sizeof(fuse_ll_ops) / sizeof(fuse_ll_ops[0]))
diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowlevel.h
index c55c0ca2fc1c..b889dae4de0e 100644
--- a/tools/virtiofsd/fuse_lowlevel.h
+++ b/tools/virtiofsd/fuse_lowlevel.h
@@ -1226,6 +1226,19 @@ struct fuse_lowlevel_ops {
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
+     * @param ino the inode number
+     */
+    void (*syncfs)(fuse_req_t req, fuse_ino_t ino);
 };
 
 /**
diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 7bf31fc129c8..9021eb091a28 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3362,6 +3362,103 @@ static void lo_lseek(fuse_req_t req, fuse_ino_t ino, off_t off, int whence,
     }
 }
 
+static int do_syncfs(struct lo_data *lo, struct lo_inode *inode)
+{
+    int fd, err = 0;
+
+    fuse_log(FUSE_LOG_DEBUG, "lo_syncfs(ino=%" PRIu64 ")\n", inode->fuse_ino);
+
+    fd = lo_inode_open(lo, inode, O_RDONLY);
+    if (fd < 0) {
+        return -fd;
+    }
+
+    if (syncfs(fd) < 0) {
+        err = -errno;
+    }
+
+    close(fd);
+    return err;
+}
+
+struct syncfs_func_data {
+    struct lo_data *lo;
+    int err;
+};
+
+static void syncfs_func(gpointer data, gpointer user_data)
+{
+    struct syncfs_func_data *sfdata = user_data;
+    struct lo_data *lo = sfdata->lo;
+    struct lo_inode *inode = data;
+
+    if (!sfdata->err) {
+        sfdata->err = do_syncfs(lo, inode);
+    }
+
+    lo_inode_put(lo, &inode);
+}
+
+static int lo_syncfs_all(fuse_req_t req)
+{
+    struct lo_data *lo = lo_data(req);
+    GHashTableIter iter;
+    gpointer key, value;
+    GSList *list = NULL;
+    struct syncfs_func_data sfdata = {
+        .lo = lo,
+        .err = 0,
+    };
+
+    pthread_mutex_lock(&lo->mutex);
+
+    g_hash_table_iter_init(&iter, lo->mnt_inodes);
+    while (g_hash_table_iter_next(&iter, &key, &value)) {
+        struct lo_inode *inode = value;
+
+        /* Reference is put in syncfs_func() */
+        g_atomic_int_inc(&inode->refcount);
+        list = g_slist_prepend(list, inode);
+    }
+
+    pthread_mutex_unlock(&lo->mutex);
+
+    g_slist_foreach(list, syncfs_func, &sfdata);
+    g_slist_free(list);
+    return sfdata.err;
+}
+
+static int lo_syncfs_one(fuse_req_t req, fuse_ino_t ino)
+{
+    struct lo_data *lo = lo_data(req);
+    struct lo_inode *inode;
+    int err;
+
+    inode = lo_inode(req, ino);
+    if (!inode) {
+        return -EBADF;
+    }
+
+    err = do_syncfs(lo, inode);
+    lo_inode_put(lo, &inode);
+    return err;
+}
+
+static void lo_syncfs(fuse_req_t req, fuse_ino_t ino)
+{
+    struct lo_data *lo = lo_data(req);
+    int err;
+
+    if (lo->announce_submounts) {
+        err = lo_syncfs_one(req, ino);
+    } else {
+        err = lo_syncfs_all(req);
+    }
+
+    fuse_reply_err(req, err);
+}
+
+
 static void lo_destroy(void *userdata)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
@@ -3423,6 +3520,7 @@ static struct fuse_lowlevel_ops lo_oper = {
     .copy_file_range = lo_copy_file_range,
 #endif
     .lseek = lo_lseek,
+    .syncfs = lo_syncfs,
     .destroy = lo_destroy,
 };
 
diff --git a/tools/virtiofsd/passthrough_seccomp.c b/tools/virtiofsd/passthrough_seccomp.c
index a3ce9f898d2d..3e9d6181dc69 100644
--- a/tools/virtiofsd/passthrough_seccomp.c
+++ b/tools/virtiofsd/passthrough_seccomp.c
@@ -108,6 +108,7 @@ static const int syscall_allowlist[] = {
     SCMP_SYS(set_robust_list),
     SCMP_SYS(setxattr),
     SCMP_SYS(symlinkat),
+    SCMP_SYS(syncfs),
     SCMP_SYS(time), /* Rarely needed, except on static builds */
     SCMP_SYS(tgkill),
     SCMP_SYS(unlinkat),
-- 
2.34.1

