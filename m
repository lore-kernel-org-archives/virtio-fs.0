From: Vivek Goyal <vgoyal@redhat.com>
Date: Fri, 15 Nov 2019 15:55:41 -0500
Message-Id: <20191115205543.1816-3-vgoyal@redhat.com>
In-Reply-To: <20191115205543.1816-1-vgoyal@redhat.com>
References: <20191115205543.1816-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/4] virtiofd: Create a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: miklos@szeredi.hu, vgoyal@redhat.com

Add a notification queue which will be used to send async notifications
for file lock availability.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_i.h                 |   1 +
 contrib/virtiofsd/fuse_virtio.c            | 108 ++++++++++++++++++---
 hw/virtio/vhost-user-fs-pci.c              |   2 +-
 hw/virtio/vhost-user-fs.c                  |  37 +++++--
 include/hw/virtio/vhost-user-fs.h          |   1 +
 include/standard-headers/linux/virtio_fs.h |   3 +
 6 files changed, 130 insertions(+), 22 deletions(-)

diff --git a/contrib/virtiofsd/fuse_i.h b/contrib/virtiofsd/fuse_i.h
index 966b1a3baa..4eeae0bfeb 100644
--- a/contrib/virtiofsd/fuse_i.h
+++ b/contrib/virtiofsd/fuse_i.h
@@ -74,6 +74,7 @@ struct fuse_session {
 	char *vu_socket_lock;
 	struct fv_VuDev *virtio_dev;
 	int thread_pool_size;
+	bool notify_enabled;
 };
 
 struct fuse_chan {
diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index 31c8542b6c..411114c9b3 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 #include "qemu/iov.h"
 #include "qapi/error.h"
+#include "standard-headers/linux/virtio_fs.h"
 #include "fuse_i.h"
 #include "fuse_kernel.h"
 #include "fuse_misc.h"
@@ -98,23 +99,31 @@ struct fv_VuDev {
      */
     size_t nqueues;
     struct fv_QueueInfo **qi;
-};
-
-/* From spec */
-struct virtio_fs_config {
-    char tag[36];
-    uint32_t num_queues;
+    /* True if notification queue is being used */
+    bool notify_enabled;
 };
 
 /* Callback from libvhost-user */
 static uint64_t fv_get_features(VuDev *dev)
 {
-    return 1ULL << VIRTIO_F_VERSION_1;
+    uint64_t features;
+
+    features = 1ull << VIRTIO_F_VERSION_1 |
+               1ull << VIRTIO_FS_F_NOTIFICATION;
+
+    return features;
 }
 
 /* Callback from libvhost-user */
 static void fv_set_features(VuDev *dev, uint64_t features)
 {
+    struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
+    struct fuse_session *se = vud->se;
+
+    if ((1 << VIRTIO_FS_F_NOTIFICATION) & features) {
+        vud->notify_enabled = true;
+        se->notify_enabled = true;
+    }
 }
 
 /*
@@ -662,6 +671,65 @@ static void fv_queue_worker(gpointer data, gpointer user_data)
     free(req);
 }
 
+static void *fv_queue_notify_thread(void *opaque)
+{
+    struct fv_QueueInfo *qi = opaque;
+
+    fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __func__,
+             qi->qidx, qi->kick_fd);
+
+    while (1) {
+        struct pollfd pf[2];
+
+        pf[0].fd = qi->kick_fd;
+        pf[0].events = POLLIN;
+        pf[0].revents = 0;
+        pf[1].fd = qi->kill_fd;
+        pf[1].events = POLLIN;
+        pf[1].revents = 0;
+
+        fuse_log(FUSE_LOG_DEBUG, "%s: Waiting for Queue %d event\n", __func__,
+                 qi->qidx);
+        int poll_res = ppoll(pf, 2, NULL, NULL);
+
+        if (poll_res == -1) {
+            if (errno == EINTR) {
+                fuse_log(FUSE_LOG_INFO, "%s: ppoll interrupted, going around\n",
+                         __func__);
+                continue;
+            }
+            fuse_log(FUSE_LOG_ERR, "fv_queue_thread ppoll: %m\n");
+            break;
+        }
+        assert(poll_res >= 1);
+        if (pf[0].revents & (POLLERR | POLLHUP | POLLNVAL)) {
+            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue %d\n",
+                     __func__, pf[0].revents, qi->qidx);
+             break;
+        }
+        if (pf[1].revents & (POLLERR | POLLHUP | POLLNVAL)) {
+            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue %d"
+                     "killfd\n", __func__, pf[1].revents, qi->qidx);
+            break;
+        }
+        if (pf[1].revents) {
+            fuse_log(FUSE_LOG_INFO, "%s: kill event on queue %d - quitting\n",
+                     __func__, qi->qidx);
+            break;
+        }
+        assert(pf[0].revents & POLLIN);
+        fuse_log(FUSE_LOG_DEBUG, "%s: Got queue event on Queue %d\n", __func__,
+                 qi->qidx);
+
+        eventfd_t evalue;
+        if (eventfd_read(qi->kick_fd, &evalue)) {
+            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
+            break;
+        }
+    }
+    return NULL;
+}
+
 /* Thread function for individual queues, created when a queue is 'started' */
 static void *fv_queue_thread(void *opaque)
 {
@@ -771,6 +839,8 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
     struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
     struct fv_QueueInfo *ourqi;
+    void * (*thread_func) (void *) = fv_queue_thread;
+    int valid_queues = 2; /* One hiprio queue and one request queue */
 
     fuse_log(FUSE_LOG_INFO, "%s: qidx=%d started=%d\n", __func__, qidx,
              started);
@@ -782,10 +852,12 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
      * well-behaved client in mind and may not protect against all types of
      * races yet.
      */
-    if (qidx > 1) {
-        fuse_log(FUSE_LOG_ERR,
-                 "%s: multiple request queues not yet implemented, please only "
-                 "configure 1 request queue\n",
+    if (vud->notify_enabled)
+        valid_queues++;
+
+    if (qidx >= valid_queues) {
+        fuse_log(FUSE_LOG_ERR, "%s: multiple request queues not yet"
+                 "implemented, please only configure 1 request queue\n",
                  __func__);
         exit(EXIT_FAILURE);
     }
@@ -813,9 +885,17 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 
         ourqi->kill_fd = eventfd(0, EFD_CLOEXEC | EFD_SEMAPHORE);
         assert(ourqi->kill_fd != -1);
-        pthread_mutex_init(&ourqi->vq_lock, NULL);
+        /*
+         * First queue (idx = 0)  is hiprio queue. Second queue is
+         * notification queue (if enabled). And rest are request
+         * queues.
+         */
+        if (vud->notify_enabled && qidx == 1) {
+            thread_func = fv_queue_notify_thread;
+        }
 
-        if (pthread_create(&ourqi->thread, NULL, fv_queue_thread, ourqi)) {
+        pthread_mutex_init(&ourqi->vq_lock, NULL);
+        if (pthread_create(&ourqi->thread, NULL, thread_func, ourqi)) {
             fuse_log(FUSE_LOG_ERR, "%s: Failed to create thread for queue %d\n",
                      __func__, qidx);
             assert(0);
@@ -1040,7 +1120,7 @@ int virtio_session_mount(struct fuse_session *se)
     se->virtio_dev = calloc(sizeof(struct fv_VuDev), 1);
     se->virtio_dev->se = se;
     pthread_rwlock_init(&se->virtio_dev->vu_dispatch_rwlock, NULL);
-    vu_init(&se->virtio_dev->dev, 2, se->vu_socketfd, fv_panic, fv_set_watch,
+    vu_init(&se->virtio_dev->dev, 3, se->vu_socketfd, fv_panic, fv_set_watch,
             fv_remove_watch, &fv_iface);
 
     return 0;
diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
index 0f3c3c8711..95f9fe5c5c 100644
--- a/hw/virtio/vhost-user-fs-pci.c
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -44,7 +44,7 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
     uint64_t totalsize;
 
     if (vpci_dev->nvectors == DEV_NVECTORS_UNSPECIFIED) {
-        vpci_dev->nvectors = dev->vdev.conf.num_request_queues + 1;
+        vpci_dev->nvectors = dev->vdev.conf.num_request_queues + 2;
     }
 
     qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 455e97beea..5555fe9dbe 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -24,6 +24,10 @@
 #include "exec/address-spaces.h"
 #include "trace.h"
 
+static const int user_feature_bits[] = {
+    VIRTIO_FS_F_NOTIFICATION,
+};
+
 uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
                                  int fd)
 {
@@ -378,12 +382,23 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
     }
 }
 
-static uint64_t vuf_get_features(VirtIODevice *vdev,
-                                      uint64_t requested_features,
-                                      Error **errp)
+static uint64_t vuf_get_features(VirtIODevice *vdev, uint64_t features,
+                                 Error **errp)
 {
-    /* No feature bits used yet */
-    return requested_features;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    virtio_add_feature(&features, VIRTIO_FS_F_NOTIFICATION);
+
+    return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
+}
+
+static void vuf_set_features(VirtIODevice *vdev, uint64_t features)
+{
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    if (virtio_has_feature(features, VIRTIO_FS_F_NOTIFICATION)) {
+        fs->notify_enabled = true;
+    }
 }
 
 static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
@@ -515,13 +530,20 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     /* Hiprio queue */
     virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
 
+    /* Notification queue. Feature negotiation happens later. So at this
+     * point of time we don't know if driver will use notification queue
+     * or not.
+     */
+    virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
+
     /* Request queues */
     for (i = 0; i < fs->conf.num_request_queues; i++) {
         virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
     }
 
-    /* 1 high prio queue, plus the number configured */
-    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
+    /* 1 high prio queue, 1 notification queue plus the number configured */
+    fs->vhost_dev.nvqs = 2 + fs->conf.num_request_queues;
+
     fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0);
@@ -584,6 +606,7 @@ static void vuf_class_init(ObjectClass *klass, void *data)
     vdc->realize = vuf_device_realize;
     vdc->unrealize = vuf_device_unrealize;
     vdc->get_features = vuf_get_features;
+    vdc->set_features = vuf_set_features;
     vdc->get_config = vuf_get_config;
     vdc->set_status = vuf_set_status;
     vdc->guest_notifier_mask = vuf_guest_notifier_mask;
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 4e7be1f312..bd47e0da98 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -64,6 +64,7 @@ typedef struct {
     /* Metadata version table */
     size_t mdvt_size;
     MemoryRegion mdvt;
+    bool notify_enabled;
 } VHostUserFS;
 
 /* Callbacks from the vhost-user code for slave commands */
diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index 310210b7b6..9ee95f584f 100644
--- a/include/standard-headers/linux/virtio_fs.h
+++ b/include/standard-headers/linux/virtio_fs.h
@@ -8,6 +8,9 @@
 #include "standard-headers/linux/virtio_config.h"
 #include "standard-headers/linux/virtio_types.h"
 
+/* Feature bits */
+#define VIRTIO_FS_F_NOTIFICATION	0	/* Notification queue supported */
+
 struct virtio_fs_config {
 	/* Filesystem name (UTF-8, not NUL-terminated, padded with NULs) */
 	uint8_t tag[36];
-- 
2.20.1

