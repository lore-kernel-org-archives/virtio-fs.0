Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:52 +0100
Message-Id: <20221205095228.1314-16-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 15/51] hw/virtio: generalise CHR_EVENT_CLOSED
 handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Fam Zheng <fam@euphon.net>, Thomas Huth <huth@tuxfamily.org>, Viresh Kumar <viresh.kumar@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Laurent Vivier <laurent@vivier.eu>, Eric Blake <eblake@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juan Quintela <quintela@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Christian Borntraeger <borntraeger@linux.ibm.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, qemu-block@nongnu.org, Xiaojuan Yang <yangxiaojuan@loongson.cn>, Thomas Huth <thuth@redhat.com>, Ilya Leoshkevich <iii@linux.ibm.com>, Eduardo Habkost <eduardo@habkost.net>, Gerd Hoffmann <kraxel@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Peter Maydell <peter.maydell@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, Jason Wang <jasowang@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Song Gao <gaosong@loongson.cn>, qemu-s390x@nongnu.org, Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>, Klaus Jensen <its@irrelevant.dk>, John Snow <jsnow@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Keith Busch <kbusch@kernel.org>, David Hildenbrand <david@redhat.com>, qemu-trivial@nongnu.org, Hanna Reitz <hreitz@redhat.com>

From: Alex Bennée <alex.bennee@linaro.org>

..and use for both virtio-user-blk and virtio-user-gpio. This avoids
the circular close by deferring shutdown due to disconnection until a
later point. virtio-user-blk already had this mechanism in place so
generalise it as a vhost-user helper function and use for both blk and
gpio devices.

While we are at it we also fix up vhost-user-gpio to re-establish the
event handler after close down so we can reconnect later.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Raphael Norwitz <raphael.norwitz@nutanix.com>
Message-Id: <20221130112439.2527228-5-alex.bennee@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/vhost-user.h | 18 +++++++++
 hw/block/vhost-user-blk.c      | 41 +++-----------------
 hw/virtio/vhost-user-gpio.c    | 11 +++++-
 hw/virtio/vhost-user.c         | 71 ++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 37 deletions(-)

diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index c6e693cd3f..191216a74f 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -68,4 +68,22 @@ bool vhost_user_init(VhostUserState *user, CharBackend *chr, Error **errp);
  */
 void vhost_user_cleanup(VhostUserState *user);
 
+/**
+ * vhost_user_async_close() - cleanup vhost-user post connection drop
+ * @d: DeviceState for the associated device (passed to callback)
+ * @chardev: the CharBackend associated with the connection
+ * @vhost: the common vhost device
+ * @cb: the user callback function to complete the clean-up
+ *
+ * This function is used to handle the shutdown of a vhost-user
+ * connection to a backend. We handle this centrally to make sure we
+ * do all the steps and handle potential races due to VM shutdowns.
+ * Once the connection is disabled we call a backhalf to ensure
+ */
+typedef void (*vu_async_close_fn)(DeviceState *cb);
+
+void vhost_user_async_close(DeviceState *d,
+                            CharBackend *chardev, struct vhost_dev *vhost,
+                            vu_async_close_fn cb);
+
 #endif
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 1177064631..aff4d2b8cb 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -369,17 +369,10 @@ static void vhost_user_blk_disconnect(DeviceState *dev)
     vhost_user_blk_stop(vdev);
 
     vhost_dev_cleanup(&s->dev);
-}
 
-static void vhost_user_blk_chr_closed_bh(void *opaque)
-{
-    DeviceState *dev = opaque;
-    VirtIODevice *vdev = VIRTIO_DEVICE(dev);
-    VHostUserBlk *s = VHOST_USER_BLK(vdev);
-
-    vhost_user_blk_disconnect(dev);
+    /* Re-instate the event handler for new connections */
     qemu_chr_fe_set_handlers(&s->chardev, NULL, NULL, vhost_user_blk_event,
-                             NULL, opaque, NULL, true);
+                             NULL, dev, NULL, true);
 }
 
 static void vhost_user_blk_event(void *opaque, QEMUChrEvent event)
@@ -398,33 +391,9 @@ static void vhost_user_blk_event(void *opaque, QEMUChrEvent event)
         }
         break;
     case CHR_EVENT_CLOSED:
-        if (!runstate_check(RUN_STATE_SHUTDOWN)) {
-            /*
-             * A close event may happen during a read/write, but vhost
-             * code assumes the vhost_dev remains setup, so delay the
-             * stop & clear.
-             */
-            AioContext *ctx = qemu_get_current_aio_context();
-
-            qemu_chr_fe_set_handlers(&s->chardev, NULL, NULL, NULL, NULL,
-                    NULL, NULL, false);
-            aio_bh_schedule_oneshot(ctx, vhost_user_blk_chr_closed_bh, opaque);
-
-            /*
-             * Move vhost device to the stopped state. The vhost-user device
-             * will be clean up and disconnected in BH. This can be useful in
-             * the vhost migration code. If disconnect was caught there is an
-             * option for the general vhost code to get the dev state without
-             * knowing its type (in this case vhost-user).
-             *
-             * FIXME: this is sketchy to be reaching into vhost_dev
-             * now because we are forcing something that implies we
-             * have executed vhost_dev_stop() but that won't happen
-             * until vhost_user_blk_stop() gets called from the bh.
-             * Really this state check should be tracked locally.
-             */
-            s->dev.started = false;
-        }
+        /* defer close until later to avoid circular close */
+        vhost_user_async_close(dev, &s->chardev, &s->dev,
+                               vhost_user_blk_disconnect);
         break;
     case CHR_EVENT_BREAK:
     case CHR_EVENT_MUX_IN:
diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index be9be08b4c..b7b82a1099 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -233,6 +233,8 @@ static int vu_gpio_connect(DeviceState *dev, Error **errp)
     return 0;
 }
 
+static void vu_gpio_event(void *opaque, QEMUChrEvent event);
+
 static void vu_gpio_disconnect(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
@@ -245,6 +247,11 @@ static void vu_gpio_disconnect(DeviceState *dev)
 
     vu_gpio_stop(vdev);
     vhost_dev_cleanup(&gpio->vhost_dev);
+
+    /* Re-instate the event handler for new connections */
+    qemu_chr_fe_set_handlers(&gpio->chardev,
+                             NULL, NULL, vu_gpio_event,
+                             NULL, dev, NULL, true);
 }
 
 static void vu_gpio_event(void *opaque, QEMUChrEvent event)
@@ -262,7 +269,9 @@ static void vu_gpio_event(void *opaque, QEMUChrEvent event)
         }
         break;
     case CHR_EVENT_CLOSED:
-        vu_gpio_disconnect(dev);
+        /* defer close until later to avoid circular close */
+        vhost_user_async_close(dev, &gpio->chardev, &gpio->vhost_dev,
+                               vu_gpio_disconnect);
         break;
     case CHR_EVENT_BREAK:
     case CHR_EVENT_MUX_IN:
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index abe23d4ebe..8f635844af 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -21,6 +21,7 @@
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
 #include "qemu/sockets.h"
+#include "sysemu/runstate.h"
 #include "sysemu/cryptodev.h"
 #include "migration/migration.h"
 #include "migration/postcopy-ram.h"
@@ -2670,6 +2671,76 @@ void vhost_user_cleanup(VhostUserState *user)
     user->chr = NULL;
 }
 
+
+typedef struct {
+    vu_async_close_fn cb;
+    DeviceState *dev;
+    CharBackend *cd;
+    struct vhost_dev *vhost;
+} VhostAsyncCallback;
+
+static void vhost_user_async_close_bh(void *opaque)
+{
+    VhostAsyncCallback *data = opaque;
+    struct vhost_dev *vhost = data->vhost;
+
+    /*
+     * If the vhost_dev has been cleared in the meantime there is
+     * nothing left to do as some other path has completed the
+     * cleanup.
+     */
+    if (vhost->vdev) {
+        data->cb(data->dev);
+    }
+
+    g_free(data);
+}
+
+/*
+ * We only schedule the work if the machine is running. If suspended
+ * we want to keep all the in-flight data as is for migration
+ * purposes.
+ */
+void vhost_user_async_close(DeviceState *d,
+                            CharBackend *chardev, struct vhost_dev *vhost,
+                            vu_async_close_fn cb)
+{
+    if (!runstate_check(RUN_STATE_SHUTDOWN)) {
+        /*
+         * A close event may happen during a read/write, but vhost
+         * code assumes the vhost_dev remains setup, so delay the
+         * stop & clear.
+         */
+        AioContext *ctx = qemu_get_current_aio_context();
+        VhostAsyncCallback *data = g_new0(VhostAsyncCallback, 1);
+
+        /* Save data for the callback */
+        data->cb = cb;
+        data->dev = d;
+        data->cd = chardev;
+        data->vhost = vhost;
+
+        /* Disable any further notifications on the chardev */
+        qemu_chr_fe_set_handlers(chardev,
+                                 NULL, NULL, NULL, NULL, NULL, NULL,
+                                 false);
+
+        aio_bh_schedule_oneshot(ctx, vhost_user_async_close_bh, data);
+
+        /*
+         * Move vhost device to the stopped state. The vhost-user device
+         * will be clean up and disconnected in BH. This can be useful in
+         * the vhost migration code. If disconnect was caught there is an
+         * option for the general vhost code to get the dev state without
+         * knowing its type (in this case vhost-user).
+         *
+         * Note if the vhost device is fully cleared by the time we
+         * execute the bottom half we won't continue with the cleanup.
+         */
+        vhost->started = false;
+    }
+}
+
 static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
 {
     if (!virtio_has_feature(dev->protocol_features,
-- 
2.38.1

