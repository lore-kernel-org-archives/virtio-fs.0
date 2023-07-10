Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003334; x=1691595334;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=iuW0jAfNN8A5+sR2hBxbLj3ogPv3jO9gBXIeFboC3qM=;
 b=uyAiHWBKNrwXEov3SUlRfOs5mb5vduz8KJDIwGc22Efvyl+2qKo9Zs9VaFUSexdvqN
 7o/qHbdGLuwVwwmC12VVfHJYOiN3pK3bggm76Njrj68DbNckyQjiQ7TrINZUeNV4kaYW
 X/V1oNbZ5ksSD4VWDC63Cpa89U6JiHy/KqNr4NGx0cvXUBRR+tuwxkudV6IONi8OISNw
 kXHcahtWyWFtthYN8r62h2Y+sXERXJwT+AoqvVKAsTEB3p1WFHdKRf0Pg6Vzc7UvzXEG
 +HfS5dsd9B231biK+6+Me2kgX7JGxMHzvyWshCgNDK7ncdA/R+d5ZUEY7SS/3L8Pi4XB
 gEmg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:21 +0100
Message-Id: <20230710153522.3469097-20-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 19/20] hw/virtio: probe backend for specs
 if it supports it
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

Now we have detected and validated the protocol support lets do the
probe. The empty state indicates no probe took place.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 include/hw/virtio/vhost.h | 12 +++++++
 hw/virtio/vhost-user.c    | 73 +++++++++++++++++++++++++++++++++++----
 hw/virtio/vhost.c         |  2 +-
 3 files changed, 79 insertions(+), 8 deletions(-)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index 912706668a..1d8de1c558 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -68,6 +68,13 @@ typedef struct VhostDevConfigOps {
 
 struct vhost_memory;
 
+typedef struct VhostUserBackendSpecs {
+    uint32_t device_id;
+    uint32_t config_size;
+    uint32_t min_vqs;
+    uint32_t max_vqs;
+} VhostUserBackendSpecs;
+
 /**
  * struct vhost_dev - common vhost_dev structure
  * @vhost_ops: backend specific ops
@@ -107,11 +114,15 @@ struct vhost_dev {
      * VHOST_USER_SET_FEATURES or VHOST_NET_F_VIRTIO_NET_HDR. Its
      * future use should be discouraged and the variable retired as
      * its easy to confuse with the VirtIO backend_features.
+     *
+     * @specs: the results of a GET_BACKEND_SPECS probe.
      */
     uint64_t features;
     uint64_t acked_features;
     uint64_t backend_features;
 
+    VhostUserBackendSpecs specs;
+
     /**
      * @protocol_features: is the vhost-user only feature set by
      * VHOST_USER_SET_PROTOCOL_FEATURES. Protocol features are only
@@ -134,6 +145,7 @@ struct vhost_dev {
     QLIST_HEAD(, vhost_iommu) iommu_list;
     IOMMUNotifier n;
     const VhostDevConfigOps *config_ops;
+
 };
 
 extern const VhostOps kernel_ops;
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 3116b3e46a..36aa4ec2d5 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -123,6 +123,7 @@ typedef enum VhostUserRequest {
     VHOST_USER_REM_MEM_REG = 38,
     VHOST_USER_SET_STATUS = 39,
     VHOST_USER_GET_STATUS = 40,
+    VHOST_USER_GET_BACKEND_SPECS = 41,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -204,13 +205,6 @@ typedef struct VhostUserInflight {
     uint16_t queue_size;
 } VhostUserInflight;
 
-typedef struct VhostUserBackendSpecs {
-    uint32_t device_id;
-    uint32_t config_size;
-    uint32_t min_vqs;
-    uint32_t max_vqs;
-} VhostUserBackendSpecs;
-
 typedef struct {
     VhostUserRequest request;
 
@@ -1991,6 +1985,56 @@ static int vhost_user_postcopy_notifier(NotifierWithReturn *notifier,
     return 0;
 }
 
+static bool vhost_user_get_backend_specs(struct vhost_dev *dev, Error **errp)
+{
+    int ret;
+    VhostUserMsg msg = {
+        .hdr.request = VHOST_USER_GET_BACKEND_SPECS,
+        .hdr.flags = VHOST_USER_VERSION,
+        .hdr.size = VHOST_USER_HDR_SIZE,
+    };
+
+    if (!virtio_has_feature(dev->protocol_features,
+                VHOST_USER_PROTOCOL_F_STANDALONE)) {
+        error_setg(errp, "VHOST_USER_PROTOCOL_F_STANDALONE not supported");
+        return -EINVAL;
+    }
+
+    ret = vhost_user_write(dev, &msg, NULL, 0);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "vhost_get_backend send failed");
+        return ret;
+    }
+
+    ret = vhost_user_read(dev, &msg);
+    if (ret < 0) {
+        error_setg_errno(errp, -ret, "vhost_get_backend recv failed");
+        return ret;
+    }
+
+    if (msg.hdr.request != VHOST_USER_GET_BACKEND_SPECS) {
+        error_setg(errp,
+                   "Received unexpected msg type. Expected %d received %d",
+                   VHOST_USER_GET_BACKEND_SPECS, msg.hdr.request);
+        return -EPROTO;
+    }
+
+    if (msg.hdr.size != sizeof(msg.payload.specs)) {
+        error_setg(errp, "Received bad msg size.");
+        return -EPROTO;
+    }
+
+    if (msg.payload.specs.config_size && !virtio_has_feature(dev->protocol_features,
+                                                             VHOST_USER_PROTOCOL_F_CONFIG)) {
+        error_setg(errp, "VHOST_USER_PROTOCOL_F_CONFIG not supported");
+        return -EPROTO;
+    }
+
+    dev->specs = msg.payload.specs;
+
+    return 0;
+}
+
 static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
                                    Error **errp)
 {
@@ -2073,6 +2117,21 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
             return -EPROTO;
         }
 
+        if (dev->protocol_features & (1ULL << VHOST_USER_PROTOCOL_F_STANDALONE)) {
+            err = vhost_user_get_backend_specs(dev, errp);
+            if (err < 0) {
+                error_setg_errno(errp, EPROTO, "vhost_get_backend_specs failed");
+                return -EPROTO;
+            }
+            /*
+             * If this was never set by the user we can now fill it in
+             * so we can continue the initialisation
+             */
+            if (!dev->nvqs) {
+                dev->nvqs = dev->specs.min_vqs;
+            }
+        }
+
         /* query the max queues we support if backend supports Multiple Queue */
         if (dev->protocol_features & (1ULL << VHOST_USER_PROTOCOL_F_MQ)) {
             err = vhost_user_get_u64(dev, VHOST_USER_GET_QUEUE_NUM,
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 4c73ced3b7..d14467aa1c 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1450,7 +1450,7 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     }
 
     /* Skip if we don't yet have number of vqs */
-    if (hdev->vqs && hdev->nvqs) {
+    if (hdev->nvqs) {
         if (!vhost_init_virtqs(hdev, busyloop_timeout, errp)) {
             goto fail_busyloop;
         }
-- 
2.39.2

