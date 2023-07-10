Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003803; x=1691595803;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=b0ilIKM9UzrdIh1IGF/Dd3LVm1ZupBEQeVXkMJAA6OY=;
 b=jxGO4ib/7xl0KK29LlO6eT9Q5mPWTQSH5ZA7JO+oBfOkMqUt48G2424F2Bggu4Y1K3
 eS2gJn5s4IsmfRA6Kc/PilOY0eGLJw4sNZeWsuLAixtkcOazolJEBW7CL/YrIHY8FHJj
 3c+NEJI2MRqwC777n7sf2C9xufCHv0AZAB5dhUfiAkk0XXpqIkTAQ7lR+Z7RWmAsBAJr
 lPTXknQqVPkLZV4RoInWpXcqE/7b7zFU273iwgIKba0oT2gNA8d+ouUl7WzxoWIICMuU
 i+dVpkZfIJq03Kc2NV3o702IJl6f4MErKzukJkkniZ61uOcqlaspvsIWuX4mB8RqtOhn
 UlqA==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:18 +0100
Message-Id: <20230710153522.3469097-17-alex.bennee@linaro.org>
In-Reply-To: <20230710153522.3469097-1-alex.bennee@linaro.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH v3 16/20] hw/virtio: move virtq
 initialisation into internal helper
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

This will be useful if we end up having to consider initialising the
virtqs at a seperate time.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/virtio/vhost.c | 60 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 19 deletions(-)

diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 82394331bf..971df8ccc5 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1382,12 +1382,47 @@ static void vhost_virtqueue_cleanup(struct vhost_virtqueue *vq)
     }
 }
 
+/*
+ * Initialise the virtqs. This can happen soon after the initial
+ * connection if we have all the details we need or be deferred until
+ * later.
+ */
+static bool vhost_init_virtqs(struct vhost_dev *hdev, uint32_t busyloop_timeout,
+                              Error **errp)
+{
+    int i, r, n_initialized_vqs = 0;
+
+    for (i = 0; i < hdev->nvqs; ++i, ++n_initialized_vqs) {
+        r = vhost_virtqueue_init(hdev, hdev->vqs + i, hdev->vq_index + i);
+        if (r < 0) {
+            error_setg_errno(errp, -r, "Failed to initialize virtqueue %d", i);
+            /* not sure what the point of this is if we have failed... */
+            hdev->nvqs = n_initialized_vqs;
+            return false;
+        }
+    }
+
+    if (busyloop_timeout) {
+        for (i = 0; i < hdev->nvqs; ++i) {
+            r = vhost_virtqueue_set_busyloop_timeout(hdev, hdev->vq_index + i,
+                                                     busyloop_timeout);
+            if (r < 0) {
+                error_setg_errno(errp, -r, "Failed to set busyloop timeout");
+                return false;
+            }
+        }
+    }
+
+    g_assert(hdev->nvqs == n_initialized_vqs);
+    return true;
+}
+
 int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
                    Error **errp)
 {
     uint64_t features;
-    int i, r, n_initialized_vqs = 0;
+    int i, r;
 
     hdev->vdev = NULL;
     hdev->migration_blocker = NULL;
@@ -1412,22 +1447,10 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
         goto fail;
     }
 
-    for (i = 0; i < hdev->nvqs; ++i, ++n_initialized_vqs) {
-        r = vhost_virtqueue_init(hdev, hdev->vqs + i, hdev->vq_index + i);
-        if (r < 0) {
-            error_setg_errno(errp, -r, "Failed to initialize virtqueue %d", i);
-            goto fail;
-        }
-    }
-
-    if (busyloop_timeout) {
-        for (i = 0; i < hdev->nvqs; ++i) {
-            r = vhost_virtqueue_set_busyloop_timeout(hdev, hdev->vq_index + i,
-                                                     busyloop_timeout);
-            if (r < 0) {
-                error_setg_errno(errp, -r, "Failed to set busyloop timeout");
-                goto fail_busyloop;
-            }
+    /* Skip if we don't yet have number of vqs */
+    if (hdev->vqs && hdev->nvqs) {
+        if (!vhost_init_virtqs(hdev, busyloop_timeout, errp)) {
+            goto fail_busyloop;
         }
     }
 
@@ -1492,12 +1515,11 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
 
 fail_busyloop:
     if (busyloop_timeout) {
-        while (--i >= 0) {
+        for (i = 0; i < hdev->nvqs; ++i) {
             vhost_virtqueue_set_busyloop_timeout(hdev, hdev->vq_index + i, 0);
         }
     }
 fail:
-    hdev->nvqs = n_initialized_vqs;
     vhost_dev_cleanup(hdev);
     return r;
 }
-- 
2.39.2

