Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488275; x=1684080275;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=Ac6OXeQsb/93HLbnF+qlx0Y/JMMvx4eaZHVLLhBGMnw=;
 b=RdaJOdn8FisdymopEgb4lrpOBYUrGosSgLoD8zlv0WiTwZFjeV8KjQmJ76VQFwJA7j
 MDcVYXVpkZXue1Tq0rsvBLC9raEUoAlAUhbpjKkLMCBQn7mnklvRuzxxFW2S37S4ddgx
 XqpsDd9xoSlltwSsw2qc03KPJzkl9hlM4EbqVPHY8BcE9C3X1kBgdZdlhJq3ImU/POl0
 oBc24Tcrlx9iZc65cFw9J/AQ6IgK16TtyIEsKQp5kP9WOx/PWw84d8n3vHyIoqF7h1uV
 YVLsdc2AmQo1rgTB8dt+gsNrkFj49EhwJJQsHLq4JgrIZzcfWBmtoJl/cmCvrxlg6MpJ
 UcRA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:22 +0100
Message-Id: <20230414160433.2096866-2-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 01/12] hw/virtio: fix typo in
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
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

Fixes: 544f0278af (virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX)
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/display/vhost-user-gpu.c    | 4 ++--
 hw/net/virtio-net.c            | 4 ++--
 hw/virtio/vhost-user-fs.c      | 4 ++--
 hw/virtio/vhost-user-gpio.c    | 2 +-
 hw/virtio/vhost-vsock-common.c | 4 ++--
 hw/virtio/virtio-crypto.c      | 4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
index 71dfd956b8..7c61a7c3ac 100644
--- a/hw/display/vhost-user-gpu.c
+++ b/hw/display/vhost-user-gpu.c
@@ -489,7 +489,7 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -506,7 +506,7 @@ vhost_user_gpu_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 53e1c32643..c53616a080 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -3359,7 +3359,7 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
     }
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return false
      */
 
@@ -3391,7 +3391,7 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
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
index d2b5519d5a..623bdf91cc 100644
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
index 802e1b9659..6b3e607329 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -1208,7 +1208,7 @@ static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
@@ -1227,7 +1227,7 @@ static bool virtio_crypto_guest_notifier_pending(VirtIODevice *vdev, int idx)
 
     /*
      * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
-     * as the Marco of configure interrupt's IDX, If this driver does not
+     * as the macro of configure interrupt's IDX, If this driver does not
      * support, the function will return
      */
 
-- 
2.39.2

