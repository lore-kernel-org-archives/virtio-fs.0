Return-Path: <quintela@redhat.com>
From: Juan Quintela <quintela@redhat.com>
Date: Mon,  5 Dec 2022 10:51:51 +0100
Message-Id: <20221205095228.1314-15-quintela@redhat.com>
In-Reply-To: <20221205095228.1314-1-quintela@redhat.com>
References: <20221205095228.1314-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 14/51] hw/virtio: add started_vu status field
 to vhost-user-gpio
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

As per the fix to vhost-user-blk in f5b22d06fb (vhost: recheck dev
state in the vhost_migration_log routine) we really should track the
connection and starting separately.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20221130112439.2527228-4-alex.bennee@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/virtio/vhost-user-gpio.h | 10 ++++++++++
 hw/virtio/vhost-user-gpio.c         | 11 ++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/hw/virtio/vhost-user-gpio.h b/include/hw/virtio/vhost-user-gpio.h
index 4fe9aeecc0..a9305c5e6c 100644
--- a/include/hw/virtio/vhost-user-gpio.h
+++ b/include/hw/virtio/vhost-user-gpio.h
@@ -28,7 +28,17 @@ struct VHostUserGPIO {
     VhostUserState vhost_user;
     VirtQueue *command_vq;
     VirtQueue *interrupt_vq;
+    /**
+     * There are at least two steps of initialization of the
+     * vhost-user device. The first is a "connect" step and
+     * second is a "start" step. Make a separation between
+     * those initialization phases by using two fields.
+     *
+     * @connected: see vu_gpio_connect()/vu_gpio_disconnect()
+     * @started_vu: see vu_gpio_start()/vu_gpio_stop()
+     */
     bool connected;
+    bool started_vu;
     /*< public >*/
 };
 
diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index 0b40ebd15a..be9be08b4c 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -86,6 +86,7 @@ static int vu_gpio_start(VirtIODevice *vdev)
         error_report("Error starting vhost-user-gpio: %d", ret);
         goto err_guest_notifiers;
     }
+    gpio->started_vu = true;
 
     /*
      * guest_notifier_mask/pending not used yet, so just unmask
@@ -126,16 +127,12 @@ static void vu_gpio_stop(VirtIODevice *vdev)
     struct vhost_dev *vhost_dev = &gpio->vhost_dev;
     int ret;
 
-    if (!k->set_guest_notifiers) {
+    if (!gpio->started_vu) {
         return;
     }
+    gpio->started_vu = false;
 
-    /*
-     * We can call vu_gpio_stop multiple times, for example from
-     * vm_state_notify and the final object finalisation. Check we
-     * aren't already stopped before doing so.
-     */
-    if (!vhost_dev_is_started(vhost_dev)) {
+    if (!k->set_guest_notifiers) {
         return;
     }
 
-- 
2.38.1

