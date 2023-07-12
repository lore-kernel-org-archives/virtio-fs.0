Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed, 12 Jul 2023 13:17:01 +0200
Message-ID: <20230712111703.28031-4-hreitz@redhat.com>
In-Reply-To: <20230712111703.28031-1-hreitz@redhat.com>
References: <20230712111703.28031-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/4] vhost: Add high-level state save/load
 functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>

vhost_save_backend_state() and vhost_load_backend_state() can be used by
vhost front-ends to easily save and load the back-end's state to/from
the migration stream.

Because we do not know the full state size ahead of time,
vhost_save_backend_state() simply reads the data in 1 MB chunks, and
writes each chunk consecutively into the migration stream, prefixed by
its length.  EOF is indicated by a 0-length chunk.

Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 include/hw/virtio/vhost.h |  35 +++++++
 hw/virtio/vhost.c         | 204 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 239 insertions(+)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index d8877496e5..0c282abd4e 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -425,4 +425,39 @@ int vhost_set_device_state_fd(struct vhost_dev *dev,
  */
 int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
 
+/**
+ * vhost_save_backend_state(): High-level function to receive a vhost
+ * back-end's state, and save it in `f`.  Uses
+ * `vhost_set_device_state_fd()` to get the data from the back-end, and
+ * stores it in consecutive chunks that are each prefixed by their
+ * respective length (be32).  The end is marked by a 0-length chunk.
+ *
+ * Must only be called while the device and all its vrings are stopped
+ * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
+ *
+ * @dev: The vhost device from which to save the state
+ * @f: Migration stream in which to save the state
+ * @errp: Potential error message
+ *
+ * Returns 0 on success, and -errno otherwise.
+ */
+int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
+
+/**
+ * vhost_load_backend_state(): High-level function to load a vhost
+ * back-end's state from `f`, and send it over to the back-end.  Reads
+ * the data from `f` in the format used by `vhost_save_state()`, and
+ * uses `vhost_set_device_state_fd()` to transfer it to the back-end.
+ *
+ * Must only be called while the device and all its vrings are stopped
+ * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
+ *
+ * @dev: The vhost device to which to send the sate
+ * @f: Migration stream from which to load the state
+ * @errp: Potential error message
+ *
+ * Returns 0 on success, and -errno otherwise.
+ */
+int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp);
+
 #endif
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 756b6d55a8..332d49a310 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -2128,3 +2128,207 @@ int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
                "vhost transport does not support migration state transfer");
     return -ENOSYS;
 }
+
+int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
+{
+    /* Maximum chunk size in which to transfer the state */
+    const size_t chunk_size = 1 * 1024 * 1024;
+    void *transfer_buf = NULL;
+    g_autoptr(GError) g_err = NULL;
+    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
+    int ret;
+
+    /* [0] for reading (our end), [1] for writing (back-end's end) */
+    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
+        error_setg(errp, "Failed to set up state transfer pipe: %s",
+                   g_err->message);
+        ret = -EINVAL;
+        goto fail;
+    }
+
+    read_fd = pipe_fds[0];
+    write_fd = pipe_fds[1];
+
+    /*
+     * VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped.
+     * We cannot check dev->suspended, because the back-end may not support
+     * suspending.
+     */
+    assert(!dev->started);
+
+    /* Transfer ownership of write_fd to the back-end */
+    ret = vhost_set_device_state_fd(dev,
+                                    VHOST_TRANSFER_STATE_DIRECTION_SAVE,
+                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
+                                    write_fd,
+                                    &reply_fd,
+                                    errp);
+    if (ret < 0) {
+        error_prepend(errp, "Failed to initiate state transfer: ");
+        goto fail;
+    }
+
+    /* If the back-end wishes to use a different pipe, switch over */
+    if (reply_fd >= 0) {
+        close(read_fd);
+        read_fd = reply_fd;
+    }
+
+    transfer_buf = g_malloc(chunk_size);
+
+    while (true) {
+        ssize_t read_ret;
+
+        read_ret = read(read_fd, transfer_buf, chunk_size);
+        if (read_ret < 0) {
+            ret = -errno;
+            error_setg_errno(errp, -ret, "Failed to receive state");
+            goto fail;
+        }
+
+        assert(read_ret <= chunk_size);
+        qemu_put_be32(f, read_ret);
+
+        if (read_ret == 0) {
+            /* EOF */
+            break;
+        }
+
+        qemu_put_buffer(f, transfer_buf, read_ret);
+    }
+
+    /*
+     * Back-end will not really care, but be clean and close our end of the pipe
+     * before inquiring the back-end about whether transfer was successful
+     */
+    close(read_fd);
+    read_fd = -1;
+
+    /* Also, verify that the device is still stopped */
+    assert(!dev->started);
+
+    ret = vhost_check_device_state(dev, errp);
+    if (ret < 0) {
+        goto fail;
+    }
+
+    ret = 0;
+fail:
+    g_free(transfer_buf);
+    if (read_fd >= 0) {
+        close(read_fd);
+    }
+
+    return ret;
+}
+
+int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error **errp)
+{
+    size_t transfer_buf_size = 0;
+    void *transfer_buf = NULL;
+    g_autoptr(GError) g_err = NULL;
+    int pipe_fds[2], read_fd = -1, write_fd = -1, reply_fd = -1;
+    int ret;
+
+    /* [0] for reading (back-end's end), [1] for writing (our end) */
+    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
+        error_setg(errp, "Failed to set up state transfer pipe: %s",
+                   g_err->message);
+        ret = -EINVAL;
+        goto fail;
+    }
+
+    read_fd = pipe_fds[0];
+    write_fd = pipe_fds[1];
+
+    /*
+     * VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopped.
+     * We cannot check dev->suspended, because the back-end may not support
+     * suspending.
+     */
+    assert(!dev->started);
+
+    /* Transfer ownership of read_fd to the back-end */
+    ret = vhost_set_device_state_fd(dev,
+                                    VHOST_TRANSFER_STATE_DIRECTION_LOAD,
+                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
+                                    read_fd,
+                                    &reply_fd,
+                                    errp);
+    if (ret < 0) {
+        error_prepend(errp, "Failed to initiate state transfer: ");
+        goto fail;
+    }
+
+    /* If the back-end wishes to use a different pipe, switch over */
+    if (reply_fd >= 0) {
+        close(write_fd);
+        write_fd = reply_fd;
+    }
+
+    while (true) {
+        size_t this_chunk_size = qemu_get_be32(f);
+        ssize_t write_ret;
+        const uint8_t *transfer_pointer;
+
+        if (this_chunk_size == 0) {
+            /* End of state */
+            break;
+        }
+
+        if (transfer_buf_size < this_chunk_size) {
+            transfer_buf = g_realloc(transfer_buf, this_chunk_size);
+            transfer_buf_size = this_chunk_size;
+        }
+
+        if (qemu_get_buffer(f, transfer_buf, this_chunk_size) <
+                this_chunk_size)
+        {
+            error_setg(errp, "Failed to read state");
+            ret = -EINVAL;
+            goto fail;
+        }
+
+        transfer_pointer = transfer_buf;
+        while (this_chunk_size > 0) {
+            write_ret = write(write_fd, transfer_pointer, this_chunk_size);
+            if (write_ret < 0) {
+                ret = -errno;
+                error_setg_errno(errp, -ret, "Failed to send state");
+                goto fail;
+            } else if (write_ret == 0) {
+                error_setg(errp, "Failed to send state: Connection is closed");
+                ret = -ECONNRESET;
+                goto fail;
+            }
+
+            assert(write_ret <= this_chunk_size);
+            this_chunk_size -= write_ret;
+            transfer_pointer += write_ret;
+        }
+    }
+
+    /*
+     * Close our end, thus ending transfer, before inquiring the back-end about
+     * whether transfer was successful
+     */
+    close(write_fd);
+    write_fd = -1;
+
+    /* Also, verify that the device is still stopped */
+    assert(!dev->started);
+
+    ret = vhost_check_device_state(dev, errp);
+    if (ret < 0) {
+        goto fail;
+    }
+
+    ret = 0;
+fail:
+    g_free(transfer_buf);
+    if (write_fd >= 0) {
+        close(write_fd);
+    }
+
+    return ret;
+}
-- 
2.41.0

