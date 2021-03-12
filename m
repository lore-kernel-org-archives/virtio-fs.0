From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:09 +0100
Message-Id: <20210312092212.782255-5-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 4/7] vhost-user: Convert slave channel to
	QIOChannelSocket
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

The slave channel is implemented with socketpair() : QEMU creates
the pair, passes one of the socket to virtiofsd and monitors the
other one with the main event loop using qemu_set_fd_handler().

In order to fix a potential deadlock between QEMU and a vhost-user
external process (e.g. virtiofsd with DAX), we want to be able to
monitor and service the slave channel while handling vhost-user
requests.

Prepare ground for this by converting the slave channel to be a
QIOChannelSocket. This will make monitoring of the slave channel
as simple as calling qio_channel_add_watch_source(). Since the
connection is already established between the two sockets, only
incoming I/O (G_IO_IN) and disconnect (G_IO_HUP) need to be
serviced.

This also allows to get rid of the ancillary data parsing since
QIOChannelSocket can do this for us. Note that the MSG_CTRUNC
check is dropped on the way because QIOChannelSocket ignores this
case. This isn't a problem since slave_read() provisions space for
8 file descriptors, but affected vhost-user slave protocol messages
generally only convey one. If for some reason a buggy implementation
passes more file descriptors, no need to break the connection, just
like we don't break it if some other type of ancillary data is
received : this isn't explicitely violating the protocol per-se so
it seems better to ignore it.

The current code errors out on short reads and writes. Use the
qio_channel_*_all() variants to address this on the way.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
v2: - also monitor G_IO_HUP (Stefan)
    - use the qio_channel_*_all() variants (Daniel)
    - simplified thanks to previous refactoring
---
 hw/virtio/vhost-user.c | 99 +++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 60 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index cb0c98f30a8d..3c1e1611b087 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -16,6 +16,7 @@
 #include "hw/virtio/virtio.h"
 #include "hw/virtio/virtio-net.h"
 #include "chardev/char-fe.h"
+#include "io/channel-socket.h"
 #include "sysemu/kvm.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
@@ -237,7 +238,8 @@ struct vhost_user {
     struct vhost_dev *dev;
     /* Shared between vhost devs of the same virtio device */
     VhostUserState *user;
-    int slave_fd;
+    QIOChannel *slave_ioc;
+    GSource *slave_src;
     NotifierWithReturn postcopy_notifier;
     struct PostCopyFD  postcopy_fd;
     uint64_t           postcopy_client_bases[VHOST_USER_MAX_RAM_SLOTS];
@@ -1394,61 +1396,37 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
 
 static void close_slave_channel(struct vhost_user *u)
 {
-    qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
-    close(u->slave_fd);
-    u->slave_fd = -1;
+    g_source_destroy(u->slave_src);
+    g_source_unref(u->slave_src);
+    u->slave_src = NULL;
+    object_unref(OBJECT(u->slave_ioc));
+    u->slave_ioc = NULL;
 }
 
-static void slave_read(void *opaque)
+static gboolean slave_read(QIOChannel *ioc, GIOCondition condition,
+                           gpointer opaque)
 {
     struct vhost_dev *dev = opaque;
     struct vhost_user *u = dev->opaque;
     VhostUserHeader hdr = { 0, };
     VhostUserPayload payload = { 0, };
-    int size, ret = 0;
+    Error *local_err = NULL;
+    gboolean rc = G_SOURCE_CONTINUE;
+    int ret = 0;
     struct iovec iov;
-    struct msghdr msgh;
-    int fd[VHOST_USER_SLAVE_MAX_FDS];
-    char control[CMSG_SPACE(sizeof(fd))];
-    struct cmsghdr *cmsg;
-    int i, fdsize = 0;
-
-    memset(&msgh, 0, sizeof(msgh));
-    msgh.msg_iov = &iov;
-    msgh.msg_iovlen = 1;
-    msgh.msg_control = control;
-    msgh.msg_controllen = sizeof(control);
-
-    memset(fd, -1, sizeof(fd));
+    g_autofree int *fd = NULL;
+    size_t fdsize = 0;
+    int i;
 
     /* Read header */
     iov.iov_base = &hdr;
     iov.iov_len = VHOST_USER_HDR_SIZE;
 
-    do {
-        size = recvmsg(u->slave_fd, &msgh, 0);
-    } while (size < 0 && errno == EINTR);
-
-    if (size != VHOST_USER_HDR_SIZE) {
-        error_report("Failed to read from slave.");
+    if (qio_channel_readv_full_all(ioc, &iov, 1, &fd, &fdsize, &local_err)) {
+        error_report_err(local_err);
         goto err;
     }
 
-    if (msgh.msg_flags & MSG_CTRUNC) {
-        error_report("Truncated message.");
-        goto err;
-    }
-
-    for (cmsg = CMSG_FIRSTHDR(&msgh); cmsg != NULL;
-         cmsg = CMSG_NXTHDR(&msgh, cmsg)) {
-            if (cmsg->cmsg_level == SOL_SOCKET &&
-                cmsg->cmsg_type == SCM_RIGHTS) {
-                    fdsize = cmsg->cmsg_len - CMSG_LEN(0);
-                    memcpy(fd, CMSG_DATA(cmsg), fdsize);
-                    break;
-            }
-    }
-
     if (hdr.size > VHOST_USER_PAYLOAD_SIZE) {
         error_report("Failed to read msg header."
                 " Size %d exceeds the maximum %zu.", hdr.size,
@@ -1457,12 +1435,8 @@ static void slave_read(void *opaque)
     }
 
     /* Read payload */
-    do {
-        size = read(u->slave_fd, &payload, hdr.size);
-    } while (size < 0 && errno == EINTR);
-
-    if (size != hdr.size) {
-        error_report("Failed to read payload from slave.");
+    if (qio_channel_read_all(ioc, (char *) &payload, hdr.size, &local_err)) {
+        error_report_err(local_err);
         goto err;
     }
 
@@ -1475,7 +1449,7 @@ static void slave_read(void *opaque)
         break;
     case VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG:
         ret = vhost_user_slave_handle_vring_host_notifier(dev, &payload.area,
-                                                          fd[0]);
+                                                          fd ? fd[0] : -1);
         break;
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
@@ -1501,12 +1475,8 @@ static void slave_read(void *opaque)
         iovec[1].iov_base = &payload;
         iovec[1].iov_len = hdr.size;
 
-        do {
-            size = writev(u->slave_fd, iovec, ARRAY_SIZE(iovec));
-        } while (size < 0 && errno == EINTR);
-
-        if (size != VHOST_USER_HDR_SIZE + hdr.size) {
-            error_report("Failed to send msg reply to slave.");
+        if (qio_channel_writev_all(ioc, iovec, ARRAY_SIZE(iovec), &local_err)) {
+            error_report_err(local_err);
             goto err;
         }
     }
@@ -1515,14 +1485,15 @@ static void slave_read(void *opaque)
 
 err:
     close_slave_channel(u);
+    rc = G_SOURCE_REMOVE;
 
 fdcleanup:
-    for (i = 0; i < fdsize; i++) {
-        if (fd[i] != -1) {
+    if (fd) {
+        for (i = 0; i < fdsize; i++) {
             close(fd[i]);
         }
     }
-    return;
+    return rc;
 }
 
 static int vhost_setup_slave_channel(struct vhost_dev *dev)
@@ -1535,6 +1506,8 @@ static int vhost_setup_slave_channel(struct vhost_dev *dev)
     int sv[2], ret = 0;
     bool reply_supported = virtio_has_feature(dev->protocol_features,
                                               VHOST_USER_PROTOCOL_F_REPLY_ACK);
+    Error *local_err = NULL;
+    QIOChannel *ioc;
 
     if (!virtio_has_feature(dev->protocol_features,
                             VHOST_USER_PROTOCOL_F_SLAVE_REQ)) {
@@ -1546,8 +1519,15 @@ static int vhost_setup_slave_channel(struct vhost_dev *dev)
         return -1;
     }
 
-    u->slave_fd = sv[0];
-    qemu_set_fd_handler(u->slave_fd, slave_read, NULL, dev);
+    ioc = QIO_CHANNEL(qio_channel_socket_new_fd(sv[0], &local_err));
+    if (!ioc) {
+        error_report_err(local_err);
+        return -1;
+    }
+    u->slave_ioc = ioc;
+    u->slave_src = qio_channel_add_watch_source(u->slave_ioc,
+                                                G_IO_IN | G_IO_HUP,
+                                                slave_read, dev, NULL, NULL);
 
     if (reply_supported) {
         msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
@@ -1802,7 +1782,6 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque)
 
     u = g_new0(struct vhost_user, 1);
     u->user = opaque;
-    u->slave_fd = -1;
     u->dev = dev;
     dev->opaque = u;
 
@@ -1917,7 +1896,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
         close(u->postcopy_fd.fd);
         u->postcopy_fd.handler = NULL;
     }
-    if (u->slave_fd >= 0) {
+    if (u->slave_ioc) {
         close_slave_channel(u);
     }
     g_free(u->region_rb);
-- 
2.26.2

