DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; 
	t=1617911741; bh=0cXgFcT8xOU8p8L5hm9l9js6IafAhuGK/tDoLr3mTbs=;
	h=Message-Id:Date:Subject:To:From:Cc;
	b=yVHPMQp91xARDoul5+Ta0953hh4ZgUd7DyH1VYHnbkSWpid9sc2q4HHKrgxMNE3W8
	IywF/MoYdcKptMGKqM+HQuNB52PH9u9pwYB4S1puzvv6mEYEbMaHxkelYV/yTYFIWJ
	vlEPfDY5IRdB46JOkHAjQlWtxAZKSExrwEUQZX7s=
From: Anton Kuchin <antonkuchin@yandex-team.ru>
Date: Thu,  8 Apr 2021 22:55:34 +0300
Message-Id: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Anton Kuchin <antonkuchin@yandex-team.ru>, "Michael S. Tsirkin" <mst@redhat.com>

Make virtio-fs take into account server capabilities.

Just returning requested features assumes they all of then are implemented
by server and results in setting unsupported configuration if some of them
are absent.

Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
---
 hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ac4fc34b36..6cf983ba0e 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -24,6 +24,14 @@
 #include "monitor/monitor.h"
 #include "sysemu/sysemu.h"
 
+static const int user_feature_bits[] = {
+    VIRTIO_F_VERSION_1,
+    VIRTIO_RING_F_INDIRECT_DESC,
+    VIRTIO_RING_F_EVENT_IDX,
+    VIRTIO_F_NOTIFY_ON_EMPTY,
+    VHOST_INVALID_FEATURE_BIT
+};
+
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
 {
     VHostUserFS *fs = VHOST_USER_FS(vdev);
@@ -129,11 +137,12 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
 }
 
 static uint64_t vuf_get_features(VirtIODevice *vdev,
-                                      uint64_t requested_features,
-                                      Error **errp)
+                                 uint64_t features,
+                                 Error **errp)
 {
-    /* No feature bits used yet */
-    return requested_features;
+    VHostUserFS *fs = VHOST_USER_FS(vdev);
+
+    return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
 }
 
 static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
-- 
2.25.1


