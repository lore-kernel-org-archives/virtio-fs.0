Return-Path: <mst@redhat.com>
Date: Mon, 10 Jul 2023 19:04:54 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <7e8094f0dfd04d4772b65dc92dd087dc86783dc4.1689030052.git.mst@redhat.com>
References: <cover.1689030052.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1689030052.git.mst@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 52/66] hw/virtio: fix typo in
 VIRTIO_CONFIG_IRQ_IDX comments
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, virtio-fs@redhat.com

From: Alex Bennée <alex.bennee@linaro.org>

Fixes: 544f0278af (virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX)
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230710153522.3469097-4-alex.bennee@linaro.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/display/vhost-user-gpu.c    | 4 ++--
 hw/net/virtio-net.c            | 4 ++--
 hw/virtio/vhost-user-fs.c      | 4 ++--
 hw/virtio/vhost-user-gpio.c    | 2 +-
 hw/virtio/vhost-vsock-common.c | 4 ++--
 hw/virtio/virtio-crypto.c      | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 543ea92721..e8ee03094e 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -521,7 +521,7 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -538,7 +538,7 @@ vhost_user_gpu_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index d51067123b..7102ec4817 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -3362,7 +3362,7 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
     }
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return false
      */
 
@@ -3394,7 +3394,7 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
     }
     /*
      *Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 83fc20e49e..49d699ffc2 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -161,7 +161,7 @@ static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -177,7 +177,7 @@ static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
index d6927b610a..3b013f2d0f 100644
--- a/hw/virtio/vhost-user-gpio.c
+++ b/hw/virtio/vhost-user-gpio.c
@@ -194,7 +194,7 @@ static void vu_gpio_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index 321262f6b3..12ea87d7a7 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -129,7 +129,7 @@ static void vhost_vsock_common_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -146,7 +146,7 @@ static bool vhost_vsock_common_guest_notifier_pending(VirtIODevice *vdev,
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index a6d7e1e8ec..44faf5a522 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -1210,7 +1210,7 @@ static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -1229,7 +1229,7 @@ static bool virtio_crypto_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
-- 
MST

