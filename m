From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:32 -0400
Message-Id: <20210930153037.1194279-9-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 08/13] virtiofsd: Create a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

Add a notification queue which will be used to send async notifications
for file lock availability.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
---
 hw/virtio/vhost-user-fs-pci.c     |  4 +-
 hw/virtio/vhost-user-fs.c         | 62 +++++++++++++++++++++++++--
 include/hw/virtio/vhost-user-fs.h |  2 +
 tools/virtiofsd/fuse_i.h          |  1 +
 tools/virtiofsd/fuse_virtio.c     | 70 +++++++++++++++++++++++--------
 5 files changed, 116 insertions(+), 23 deletions(-)

diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
index 2ed8492b3f..cdb9471088 100644
--- a/hw/virtio/vhost-user-fs-pci.c
+++ b/hw/virtio/vhost-user-fs-pci.c
@@ -41,8 +41,8 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
     DeviceState *vdev = DEVICE(&dev->vdev);
 
     if (vpci_dev->nvectors == DEV_NVECTORS_UNSPECIFIED) {
-        /* Also reserve config change and hiprio queue vectors */
-        vpci_dev->nvectors = dev->vdev.conf.num_request_queues + 2;
+        /* Also reserve config change, hiprio and notification queue vectors */
+        vpci_dev->nvectors = dev->vdev.conf.num_request_queues + 3;
     }
 
     qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index d1efbc5b18..6bafcf0243 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -31,6 +31,7 @@ static const int user_feature_bits[] = {
     VIRTIO_F_NOTIFY_ON_EMPTY,
     VIRTIO_F_RING_PACKED,
     VIRTIO_F_IOMMU_PLATFORM,
+    VIRTIO_FS_F_NOTIFICATION,
 
     VHOST_INVALID_FEATURE_BIT
 };
@@ -147,7 +148,7 @@ static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
      */
 }
 
-static void vuf_create_vqs(VirtIODevice *vdev)
+static void vuf_create_vqs(VirtIODevice *vdev, bool notification_vq)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
     unsigned int i;
@@ -155,6 +156,15 @@ static void vuf_create_vqs(VirtIODevice *vdev)
     /* Hiprio queue */
     fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size,
                                      vuf_handle_output);
+    /*
+     * Notification queue. Feature negotiation happens later. So at this
+     * point of time we don't know if driver will use notification queue
+     * or not.
+     */
+    if (notification_vq) {
+        fs->notification_vq = virtio_add_queue(vdev, fs->conf.queue_size,
+                                               vuf_handle_output);
+    }
 
     /* Request queues */
     fs->req_vqs = g_new(VirtQueue *, fs->conf.num_request_queues);
@@ -163,8 +173,12 @@ static void vuf_create_vqs(VirtIODevice *vdev)
                                           vuf_handle_output);
     }
 
-    /* 1 high prio queue, plus the number configured */
-    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
+    /* 1 high prio queue, 1 notification queue plus the number configured */
+    if (notification_vq) {
+        fs->vhost_dev.nvqs = 2 + fs->conf.num_request_queues;
+    } else {
+        fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
+    }
     fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
 }
 
@@ -176,6 +190,11 @@ static void vuf_cleanup_vqs(VirtIODevice *vdev)
     virtio_delete_queue(fs->hiprio_vq);
     fs->hiprio_vq = NULL;
 
+    if (fs->notification_vq) {
+        virtio_delete_queue(fs->notification_vq);
+    }
+    fs->notification_vq = NULL;
+
     for (i = 0; i < fs->conf.num_request_queues; i++) {
         virtio_delete_queue(fs->req_vqs[i]);
     }
@@ -194,9 +213,43 @@ static uint64_t vuf_get_features(VirtIODevice *vdev,
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
 
+    virtio_add_feature(&features, VIRTIO_FS_F_NOTIFICATION);
+
     return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
 }
 
+static void vuf_set_features(VirtIODevice *vdev, uint64_t features)
+{
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    if (virtio_has_feature(features, VIRTIO_FS_F_NOTIFICATION)) {
+        fs->notify_enabled = true;
+        /*
+         * If guest first booted with no notification queue support and
+         * later rebooted with kernel which supports notification, we
+         * can end up here
+         */
+        if (!fs->notification_vq) {
+            vuf_cleanup_vqs(vdev);
+            vuf_create_vqs(vdev, true);
+        }
+        return;
+    }
+
+    fs->notify_enabled = false;
+    if (!fs->notification_vq) {
+        return;
+    }
+    /*
+     * Driver does not support notification queue. Reconfigure queues
+     * and do not create notification queue.
+     */
+    vuf_cleanup_vqs(vdev);
+
+    /* Create queues again */
+    vuf_create_vqs(vdev, false);
+}
+
 static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
                                             bool mask)
 {
@@ -262,7 +315,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     virtio_init(vdev, "vhost-user-fs", VIRTIO_ID_FS,
                 sizeof(struct virtio_fs_config));
 
-    vuf_create_vqs(vdev);
+    vuf_create_vqs(vdev, true);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
                          VHOST_BACKEND_TYPE_USER, 0, errp);
     if (ret < 0) {
@@ -327,6 +380,7 @@ static void vuf_class_init(ObjectClass *klass, void *data)
     vdc->realize = vuf_device_realize;
     vdc->unrealize = vuf_device_unrealize;
     vdc->get_features = vuf_get_features;
+    vdc->set_features = vuf_set_features;
     vdc->get_config = vuf_get_config;
     vdc->set_status = vuf_set_status;
     vdc->guest_notifier_mask = vuf_guest_notifier_mask;
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 0d62834c25..95dc0dd402 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -39,7 +39,9 @@ struct VHostUserFS {
     VhostUserState vhost_user;
     VirtQueue **req_vqs;
     VirtQueue *hiprio_vq;
+    VirtQueue *notification_vq;
     int32_t bootindex;
+    bool notify_enabled;
 
     /*< public >*/
 };
diff --git a/tools/virtiofsd/fuse_i.h b/tools/virtiofsd/fuse_i.h
index 492e002181..4942d080da 100644
--- a/tools/virtiofsd/fuse_i.h
+++ b/tools/virtiofsd/fuse_i.h
@@ -73,6 +73,7 @@ struct fuse_session {
     int   vu_socketfd;
     struct fv_VuDev *virtio_dev;
     int thread_pool_size;
+    bool notify_enabled;
 };
 
 struct fuse_chan {
diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index baead08b28..f5b87a508a 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -14,6 +14,7 @@
 #include "qemu/osdep.h"
 #include "qemu/iov.h"
 #include "qapi/error.h"
+#include "standard-headers/linux/virtio_fs.h"
 #include "fuse_i.h"
 #include "standard-headers/linux/fuse.h"
 #include "fuse_misc.h"
@@ -85,12 +86,25 @@ struct fv_VuDev {
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
+        se->notify_enabled = true;
+    } else {
+        se->notify_enabled = false;
+    }
 }
 
 /*
@@ -719,22 +733,25 @@ static void fv_queue_cleanup_thread(struct fv_VuDev *vud, int qidx)
 {
     int ret;
     struct fv_QueueInfo *ourqi;
+    struct fuse_session *se = vud->se;
 
     assert(qidx < vud->nqueues);
     ourqi = vud->qi[qidx];
 
-    /* Kill the thread */
-    if (eventfd_write(ourqi->kill_fd, 1)) {
-        fuse_log(FUSE_LOG_ERR, "Eventfd_write for queue %d: %s\n",
-                 qidx, strerror(errno));
-    }
-    ret = pthread_join(ourqi->thread, NULL);
-    if (ret) {
-        fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d\n",
-                 __func__, qidx, ret);
+    /* qidx == 1 is the notification queue if notifications are enabled */
+    if (!se->notify_enabled || qidx != 1) {
+        /* Kill the thread */
+        if (eventfd_write(ourqi->kill_fd, 1)) {
+            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
+        }
+        ret = pthread_join(ourqi->thread, NULL);
+        if (ret) {
+            fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err"
+                     " %d\n", __func__, qidx, ret);
+        }
+        close(ourqi->kill_fd);
     }
     pthread_mutex_destroy(&ourqi->vq_lock);
-    close(ourqi->kill_fd);
     ourqi->kick_fd = -1;
     g_free(vud->qi[qidx]);
     vud->qi[qidx] = NULL;
@@ -757,6 +774,9 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
 {
     struct fv_VuDev *vud = container_of(dev, struct fv_VuDev, dev);
     struct fv_QueueInfo *ourqi;
+    int valid_queues = 2; /* One hiprio queue and one request queue */
+    bool notification_q = false;
+    struct fuse_session *se = vud->se;
 
     fuse_log(FUSE_LOG_INFO, "%s: qidx=%d started=%d\n", __func__, qidx,
              started);
@@ -768,10 +788,19 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
      * well-behaved client in mind and may not protect against all types of
      * races yet.
      */
-    if (qidx > 1) {
-        fuse_log(FUSE_LOG_ERR,
-                 "%s: multiple request queues not yet implemented, please only "
-                 "configure 1 request queue\n",
+    if (se->notify_enabled) {
+        valid_queues++;
+        /*
+         * If notification queue is enabled, then qidx 1 is notificaiton queue.
+         */
+        if (qidx == 1) {
+            notification_q = true;
+        }
+    }
+
+    if (qidx >= valid_queues) {
+        fuse_log(FUSE_LOG_ERR, "%s: multiple request queues not yet"
+                 "implemented, please only configure 1 request queue\n",
                  __func__);
         exit(EXIT_FAILURE);
     }
@@ -793,11 +822,18 @@ static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
             assert(vud->qi[qidx]->kick_fd == -1);
         }
         ourqi = vud->qi[qidx];
+        pthread_mutex_init(&ourqi->vq_lock, NULL);
+        /*
+         * For notification queue, we don't have to start a thread yet.
+         */
+        if (notification_q) {
+            return;
+        }
+
         ourqi->kick_fd = dev->vq[qidx].kick_fd;
 
         ourqi->kill_fd = eventfd(0, EFD_CLOEXEC | EFD_SEMAPHORE);
         assert(ourqi->kill_fd != -1);
-        pthread_mutex_init(&ourqi->vq_lock, NULL);
 
         if (pthread_create(&ourqi->thread, NULL, fv_queue_thread, ourqi)) {
             fuse_log(FUSE_LOG_ERR, "%s: Failed to create thread for queue %d\n",
@@ -1048,7 +1084,7 @@ int virtio_session_mount(struct fuse_session *se)
     se->vu_socketfd = data_sock;
     se->virtio_dev->se = se;
     pthread_rwlock_init(&se->virtio_dev->vu_dispatch_rwlock, NULL);
-    if (!vu_init(&se->virtio_dev->dev, 2, se->vu_socketfd, fv_panic, NULL,
+    if (!vu_init(&se->virtio_dev->dev, 3, se->vu_socketfd, fv_panic, NULL,
                  fv_set_watch, fv_remove_watch, &fv_iface)) {
         fuse_log(FUSE_LOG_ERR, "%s: vu_init failed\n", __func__);
         return -1;
-- 
2.31.1

