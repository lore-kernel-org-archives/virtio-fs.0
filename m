Return-Path: <akihiko.odaki@daynix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=daynix-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=U1sxs2b9gsg+jkzUv1onLcvKq812qwoR1X54ZLz9htA=;
 b=cdkBWimROqxaE1KGR9gK+aLaSfJT2UQMOaG5mV+fs40xECMnrVyNO7S7uVOvtYAbkP
 NWvRT0JNeT8eMx/ub95Blc7U33BgrwPHJkbpble5Oq+731qkd/df55WIARf8/l/xFCKd
 aTV/rgGF3zPsZ1JpjfRDXffcCE6qF7sL45IkR8W/hwvkUK+MEWiSnpFyTr2T5AuoXZcv
 eF3v8+UGCnJTJhRCPJeUc44CjZN/QNbF10WXn8D7yXlVPKUJOpcQTSVUro2MxM2/gqgz
 GZR8Io9xHEMLEE1F0e6prDtJO6r0/VbaGR6VuDbE6AolyifO+QJLSvcJTkJzuX4oYUQo
 grXg==
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Mon, 30 Jan 2023 23:02:25 +0900
Message-Id: <20230130140225.77964-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true
Subject: [Virtio-fs] [PATCH] vhost-user-fs: Back up vqs before cleaning up
 vhost_dev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org, Akihiko Odaki <akihiko.odaki@daynix.com>

vhost_dev_cleanup() clears vhost_dev so back up its vqs member to free
the memory pointed by the member.

Fixes: 98fc1ada4c ("virtio: add vhost-user-fs base device")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 hw/virtio/vhost-user-fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index f5049735ac..83fc20e49e 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -273,6 +273,7 @@ static void vuf_device_unrealize(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
     VHostUserFS *fs = VHOST_USER_FS(dev);
+    struct vhost_virtqueue *vhost_vqs = fs->vhost_dev.vqs;
     int i;
 
     /* This will stop vhost backend if appropriate. */
@@ -288,8 +289,7 @@ static void vuf_device_unrealize(DeviceState *dev)
     }
     g_free(fs->req_vqs);
     virtio_cleanup(vdev);
-    g_free(fs->vhost_dev.vqs);
-    fs->vhost_dev.vqs = NULL;
+    g_free(vhost_vqs);
 }
 
 static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
-- 
2.39.1

