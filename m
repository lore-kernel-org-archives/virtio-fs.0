Return-Path: <lulu@redhat.com>
From: Cindy Lu <lulu@redhat.com>
Date: Wed, 20 Jul 2022 21:12:02 +0800
Message-Id: <20220720131204.591104-9-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v13 08/10] virtio-net: add support for configure
 interrupt
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: lulu@redhat.com, qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>

Add functions to support configure interrupt in virtio_net
Add the functions to support vhost_net_config_pending
and vhost_net_config_mask.

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 hw/net/vhost_net.c      | 9 +++++++++
 hw/net/virtio-net.c     | 4 ++--
 include/net/vhost_net.h | 2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 30379d2ca4..9c9fd0a73f 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -457,6 +457,15 @@ void vhost_net_virtqueue_mask(VHostNetState *net, VirtIODevice *dev,
     vhost_virtqueue_mask(&net->dev, dev, idx, mask);
 }
 
+bool vhost_net_config_pending(VHostNetState *net)
+{
+    return vhost_config_pending(&net->dev);
+}
+
+void vhost_net_config_mask(VHostNetState *net, VirtIODevice *dev, bool mask)
+{
+    vhost_config_mask(&net->dev, dev, mask);
+}
 VHostNetState *get_vhost_net(NetClientState *nc)
 {
     VHostNetState *vhost_net = 0;
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index a566936e5c..b6e5efed61 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -3178,7 +3178,7 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
      * support, the function will return false */
 
     if (idx == VIRTIO_CONFIG_IRQ_IDX) {
-        return false;
+        return vhost_net_config_pending(get_vhost_net(nc->peer));
     }
     return vhost_net_virtqueue_pending(get_vhost_net(nc->peer), idx);
 }
@@ -3195,9 +3195,9 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
      * support, the function will return */
 
     if (idx == VIRTIO_CONFIG_IRQ_IDX) {
+        vhost_net_config_mask(get_vhost_net(nc->peer), vdev, mask);
         return;
     }
-
     vhost_net_virtqueue_mask(get_vhost_net(nc->peer), vdev, idx, mask);
 }
 
diff --git a/include/net/vhost_net.h b/include/net/vhost_net.h
index 387e913e4e..fc37498550 100644
--- a/include/net/vhost_net.h
+++ b/include/net/vhost_net.h
@@ -39,6 +39,8 @@ int vhost_net_set_config(struct vhost_net *net, const uint8_t *data,
 bool vhost_net_virtqueue_pending(VHostNetState *net, int n);
 void vhost_net_virtqueue_mask(VHostNetState *net, VirtIODevice *dev,
                               int idx, bool mask);
+bool vhost_net_config_pending(VHostNetState *net);
+void vhost_net_config_mask(VHostNetState *net, VirtIODevice *dev, bool mask);
 int vhost_net_notify_migration_done(VHostNetState *net, char* mac_addr);
 VHostNetState *get_vhost_net(NetClientState *nc);
 
-- 
2.34.3

