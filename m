From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed,  4 Dec 2019 14:08:34 -0500
Message-Id: <20191204190836.31324-4-vgoyal@redhat.com>
In-Reply-To: <20191204190836.31324-1-vgoyal@redhat.com>
References: <20191204190836.31324-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/5] virtiofd: Create a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com, qemu-devel@nongnu.org
Cc: mszeredi@redhat.com

Add a notification queue which will be used to send async notifications
for file lock availability.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 contrib/virtiofsd/fuse_i.h                 |  1 +
 contrib/virtiofsd/fuse_virtio.c            | 74 +++++++++++++++-------
 hw/virtio/vhost-user-fs-pci.c              |  2 +-
 hw/virtio/vhost-user-fs.c                  | 37 +++++++++--
 include/hw/virtio/vhost-user-fs.h          |  1 +
 include/standard-headers/linux/virtio_fs.h |  3 +
 6 files changed, 87 insertions(+), 31 deletions(-)

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
index 2a9cd60a01..b1eebcf054 100644
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
@@ -92,23 +93,31 @@ struct fv_VuDev {
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
+    if ((1ull << VIRTIO_FS_F_NOTIFICATION) & features) {
+        vud->notify_enabled = true;
+        se->notify_enabled = true;
+    }
 }
 
 /*
@@ -765,6 +774,9 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
     struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
     struct fv_QueueInfo *ourqi;
+    void * (*thread_func) (void *) = fv_queue_thread;
+    int valid_queues = 2; /* One hiprio queue and one request queue */
+    bool notification_q = false;
 
     fuse_log(FUSE_LOG_INFO, "%s: qidx=%d started=%d\n", __func__, qidx,
              started);
@@ -776,10 +788,18 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
      * well-behaved client in mind and may not protect against all types of
      * races yet.
      */
-    if (qidx > 1) {
-        fuse_log(FUSE_LOG_ERR,
-                 "%s: multiple request queues not yet implemented, please only "
-                 "configure 1 request queue\n",
+    if (vud->notify_enabled) {
+        valid_queues++;
+        /*
+         * If notification queue is enabled, then qidx 1 is notificaiton queue.
+         */
+        if (qidx == 1)
+            notification_q = true;
+    }
+
+    if (qidx >= valid_queues) {
+        fuse_log(FUSE_LOG_ERR, "%s: multiple request queues not yet"
+                 "implemented, please only configure 1 request queue\n",
                  __func__);
         exit(EXIT_FAILURE);
     }
@@ -803,13 +823,19 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
             assert(vud->qi[qidx]->kick_fd == -1);
         }
         ourqi = vud->qi[qidx];
+        pthread_mutex_init(&ourqi->vq_lock, NULL);
+        /*
+         * For notification queue, we don't have to start a thread yet.
+         */
+        if (notification_q)
+            return;
+
         ourqi->kick_fd = dev->vq[qidx].kick_fd;
 
         ourqi->kill_fd = eventfd(0, EFD_CLOEXEC | EFD_SEMAPHORE);
         assert(ourqi->kill_fd != -1);
-        pthread_mutex_init(&ourqi->vq_lock, NULL);
 
-        if (pthread_create(&ourqi->thread, NULL, fv_queue_thread, ourqi)) {
+        if (pthread_create(&ourqi->thread, NULL, thread_func, ourqi)) {
             fuse_log(FUSE_LOG_ERR, "%s: Failed to create thread for queue %d\n",
                      __func__, qidx);
             assert(0);
@@ -819,17 +845,19 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
         assert(qidx < vud->nqueues);
         ourqi = vud->qi[qidx];
 
-        /* Kill the thread */
-        if (eventfd_write(ourqi->kill_fd, 1)) {
-            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
-        }
-        ret = pthread_join(ourqi->thread, NULL);
-        if (ret) {
-            fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
-                     __func__, qidx, ret);
+        if (!notification_q) {
+            /* Kill the thread */
+            if (eventfd_write(ourqi->kill_fd, 1)) {
+                fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
+            }
+            ret = pthread_join(ourqi->thread, NULL);
+            if (ret) {
+                fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err"
+                         " %d\n", __func__, qidx, ret);
+            }
+            close(ourqi->kill_fd);
         }
         pthread_mutex_destroy(&ourqi->vq_lock);
-        close(ourqi->kill_fd);
         ourqi->kick_fd = -1;
         free(vud->qi[qidx]);
         vud->qi[qidx] = NULL;
@@ -1034,7 +1062,7 @@ int virtio_session_mount(struct fuse_session *se)
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

