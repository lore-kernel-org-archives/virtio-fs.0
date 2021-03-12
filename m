From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:11 +0100
Message-Id: <20210312092212.782255-7-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 6/7] vhost-user: Monitor slave channel in
	vhost_user_read()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>

Now that everything is in place, have the nested event loop to monitor
the slave channel. The source in the main event loop is destroyed and
recreated to ensure any pending even for the slave channel that was
previously detected is purged. This guarantees that the main loop
wont invoke slave_read() based on an event that was already handled
by the nested loop.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
v2: - also monitor G_IO_HUP (Stefan)
    - refactored the code a bit
---
 hw/virtio/vhost-user.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 00256fa318a6..ded0c1045309 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -345,6 +345,35 @@ end:
     return G_SOURCE_REMOVE;
 }
 
+static gboolean slave_read(QIOChannel *ioc, GIOCondition condition,
+                           gpointer opaque);
+
+/*
+ * This updates the read handler to use a new event loop context.
+ * Event sources are removed from the previous context : this ensures
+ * that events detected in the previous context are purged. They will
+ * be re-detected and processed in the new context.
+ */
+static void slave_update_read_handler(struct vhost_dev *dev,
+                                      GMainContext *ctxt)
+{
+    struct vhost_user *u = dev->opaque;
+
+    if (!u->slave_ioc) {
+        return;
+    }
+
+    if (u->slave_src) {
+        g_source_destroy(u->slave_src);
+        g_source_unref(u->slave_src);
+    }
+
+    u->slave_src = qio_channel_add_watch_source(u->slave_ioc,
+                                                G_IO_IN | G_IO_HUP,
+                                                slave_read, dev, NULL,
+                                                ctxt);
+}
+
 static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
 {
     struct vhost_user *u = dev->opaque;
@@ -366,6 +395,7 @@ static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
      * be prepared for re-entrancy. So we create a new one and switch chr
      * to use it.
      */
+    slave_update_read_handler(dev, ctxt);
     qemu_chr_be_update_read_handlers(chr->chr, ctxt);
     qemu_chr_fe_add_watch(chr, G_IO_IN | G_IO_HUP, vhost_user_read_cb, &data);
 
@@ -377,6 +407,7 @@ static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
      * context that have been processed by the nested loop are purged.
      */
     qemu_chr_be_update_read_handlers(chr->chr, prev_ctxt);
+    slave_update_read_handler(dev, NULL);
 
     g_main_loop_unref(loop);
     g_main_context_unref(ctxt);
@@ -1580,9 +1611,7 @@ static int vhost_setup_slave_channel(struct vhost_dev *dev)
         return -1;
     }
     u->slave_ioc = ioc;
-    u->slave_src = qio_channel_add_watch_source(u->slave_ioc,
-                                                G_IO_IN | G_IO_HUP,
-                                                slave_read, dev, NULL, NULL);
+    slave_update_read_handler(dev, NULL);
 
     if (reply_supported) {
         msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
-- 
2.26.2

