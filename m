From: Hanna Reitz <hreitz@redhat.com>
Date: Thu, 16 Sep 2021 10:40:36 +0200
Message-Id: <20210916084045.31684-4-hreitz@redhat.com>
In-Reply-To: <20210916084045.31684-1-hreitz@redhat.com>
References: <20210916084045.31684-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 03/12] virtiofsd: Add TempFd structure
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Reitz <hreitz@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

We are planning to add file handles to lo_inode objects as an
alternative to lo_inode.fd.  That means that everywhere where we
currently reference lo_inode.fd, we will have to open a temporary file
descriptor that needs to be closed after use.

So instead of directly accessing lo_inode.fd, there will be a helper
function (lo_inode_fd()) that either returns lo_inode.fd, or opens a new
file descriptor with open_by_handle_at().  It encapsulates this result
in a TempFd structure to let the caller know whether the FD needs to be
closed after use (opened from the handle) or not (copied from
lo_inode.fd).

By using g_auto(TempFd) to store this result, callers will not even have
to care about closing a temporary FD after use.  It will be done
automatically once the object goes out of scope.

Signed-off-by: Hanna Reitz <hreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 63 ++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index b43afdfbd3..88318a4ba9 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -180,6 +180,28 @@ struct lo_data {
     int user_posix_acl, posix_acl;
 };
 
+/**
+ * Represents a file descriptor that may either be owned by this
+ * TempFd, or only referenced (i.e. the ownership belongs to some
+ * other object, and the value has just been copied into this TempFd).
+ *
+ * The purpose of this encapsulation is to be used as g_auto(TempFd)
+ * to automatically clean up owned file descriptors when this object
+ * goes out of scope.
+ *
+ * Use temp_fd_steal() to get an owned file descriptor that will not
+ * be closed when the TempFd goes out of scope.
+ */
+typedef struct {
+    int fd;
+    bool owned; /* fd owned by this object? */
+} TempFd;
+
+#define TEMP_FD_INIT ((TempFd) { .fd = -1, .owned = false })
+
+static void temp_fd_clear(TempFd *temp_fd);
+G_DEFINE_AUTO_CLEANUP_CLEAR_FUNC(TempFd, temp_fd_clear);
+
 static const struct fuse_opt lo_opts[] = {
     { "sandbox=namespace",
       offsetof(struct lo_data, sandbox),
@@ -257,6 +279,47 @@ static struct lo_data *lo_data(fuse_req_t req)
     return (struct lo_data *)fuse_req_userdata(req);
 }
 
+/**
+ * Clean-up function for TempFds
+ */
+static void temp_fd_clear(TempFd *temp_fd)
+{
+    if (temp_fd->owned) {
+        close(temp_fd->fd);
+        *temp_fd = TEMP_FD_INIT;
+    }
+}
+
+/**
+ * Return an owned fd from *temp_fd that will not be closed when
+ * *temp_fd goes out of scope.
+ *
+ * (TODO: Remove __attribute__ once this is used.)
+ */
+static __attribute__((unused)) int temp_fd_steal(TempFd *temp_fd)
+{
+    if (temp_fd->owned) {
+        temp_fd->owned = false;
+        return temp_fd->fd;
+    } else {
+        return dup(temp_fd->fd);
+    }
+}
+
+/**
+ * Create a borrowing copy of an existing TempFd.  Note that *to is
+ * only valid as long as *from is valid.
+ *
+ * (TODO: Remove __attribute__ once this is used.)
+ */
+static __attribute__((unused)) void temp_fd_copy(const TempFd *from, TempFd *to)
+{
+    *to = (TempFd) {
+        .fd = from->fd,
+        .owned = false,
+    };
+}
+
 /*
  * Load capng's state from our saved state if the current thread
  * hadn't previously been loaded.
-- 
2.31.1

