Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003802; x=1691595802;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=PmygjvZg8uFQsUpexNqFXIftg/uxTgYWjvmcSaLAlsA=;
 b=K+2L5/KZsyNq2tWxX1t3NkN+Tas0iUV8sqmJbF8Bc1mBDsis9QGrtaPM6uWbU0O6EJ
 3bSL27/+49AgEl/1zUOzqznhTS7uptifshnsILnPb8Ysxny83UMqJv7qrX1EJSfNbaLE
 Y6hUgGF/ljtDn+1/g/obYmnkGelgzkpeSwAlR7o/l9tfJZXMmJbqw40/Ik1pt8LL+oxC
 ubbYAkTFnF+GkjSTpMQRpy9dJnk2lai7+GH5xVRt7EgWpiQV0uEUefvA0EbkXHwLurp7
 /uobhuxqpzB4FGOZ9bLsboHb9Ig+4QMo4/9GYqxDGdUgazYs4cRI6JoT7A14GzQYDILz
 8d7g==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:16 +0100
Message-Id: <20230710153522.3469097-15-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 14/20] docs/interop: define STANDALONE
 protocol feature for vhost-user
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

Currently QEMU has to know some details about the back-end to be able
to setup the guest. While various parts of the setup can be delegated
to the backend (for example config handling) this is a very piecemeal
approach.

This patch suggests a new feature flag (VHOST_USER_PROTOCOL_F_STANDALONE)
which the back-end can advertise which allows a probe message to be
sent to get all the details QEMU needs to know in one message.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
Initial RFC for discussion. I intend to prototype this work with QEMU
and one of the rust-vmm vhost-user daemons.
---
 docs/interop/vhost-user.rst | 39 +++++++++++++++++++++++++++++++++++++
 hw/virtio/vhost-user.c      |  8 ++++++++
 2 files changed, 47 insertions(+)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 5a070adbc1..a2080f56f3 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -275,6 +275,21 @@ Inflight description
 
 :queue size: a 16-bit size of virtqueues
 
+Backend specifications
+^^^^^^^^^^^^^^^^^^^^^^
+
++-----------+-------------+------------+------------+
+| device id | config size |   min_vqs  |   max_vqs  |
++-----------+-------------+------------+------------+
+
+:device id: a 32-bit value holding the VirtIO device ID
+
+:config size: a 32-bit value holding the config size (see ``VHOST_USER_GET_CONFIG``)
+
+:min_vqs: a 32-bit value holding the minimum number of vqs supported
+
+:max_vqs: a 32-bit value holding the maximum number of vqs supported, must be >= min_vqs
+
 C structure
 -----------
 
@@ -296,6 +311,7 @@ In QEMU the vhost-user message is implemented with the following struct:
           VhostUserConfig config;
           VhostUserVringArea area;
           VhostUserInflight inflight;
+          VhostUserBackendSpecs specs;
       };
   } QEMU_PACKED VhostUserMsg;
 
@@ -316,6 +332,7 @@ replies. Here is a list of the ones that do:
 * ``VHOST_USER_GET_VRING_BASE``
 * ``VHOST_USER_SET_LOG_BASE`` (if ``VHOST_USER_PROTOCOL_F_LOG_SHMFD``)
 * ``VHOST_USER_GET_INFLIGHT_FD`` (if ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD``)
+* ``VHOST_USER_GET_BACKEND_SPECS`` (if ``VHOST_USER_PROTOCOL_F_STANDALONE``)
 
 .. seealso::
 
@@ -885,6 +902,15 @@ Protocol features
   #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
   #define VHOST_USER_PROTOCOL_F_STATUS               16
   #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
+  #define VHOST_USER_PROTOCOL_F_STANDALONE           18
+
+Some features depend on others to be supported:
+
+* ``VHOST_USER_PROTOCOL_F_STANDALONE`` depends on:
+
+  * ``VHOST_USER_PROTOCOL_F_STATUS``
+  * ``VHOST_USER_PROTOCOL_F_CONFIG`` (if there is a config space)
+
 
 Front-end message types
 -----------------------
@@ -1440,6 +1466,19 @@ Front-end message types
   query the back-end for its device status as defined in the Virtio
   specification.
 
+``VHOST_USER_GET_BACKEND_SPECS``
+  :id: 41
+  :request payload: N/A
+  :reply payload: ``Backend specifications``
+
+  When the ``VHOST_USER_PROTOCOL_F_STANDALONE`` protocol feature has been
+  successfully negotiated, this message is submitted by the front-end to
+  query the back-end for its capabilities. This is intended to remove
+  the need for the front-end to know ahead of time what the VirtIO
+  device the backend emulates is.
+
+  The reply contains the device id, size of the config space and the
+  range of VirtQueues the backend supports.
 
 Back-end message types
 ----------------------
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index c4e0cbd702..28b021d5d3 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -202,6 +202,13 @@ typedef struct VhostUserInflight {
     uint16_t queue_size;
 } VhostUserInflight;
 
+typedef struct VhostUserBackendSpecs {
+    uint32_t device_id;
+    uint32_t config_size;
+    uint32_t min_vqs;
+    uint32_t max_vqs;
+} VhostUserBackendSpecs;
+
 typedef struct {
     VhostUserRequest request;
 
@@ -226,6 +233,7 @@ typedef union {
         VhostUserCryptoSession session;
         VhostUserVringArea area;
         VhostUserInflight inflight;
+        VhostUserBackendSpecs specs;
 } VhostUserPayload;
 
 typedef struct VhostUserMsg {
-- 
2.39.2

