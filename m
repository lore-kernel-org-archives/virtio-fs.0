From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:10 +0100
Message-Id: <20210312092212.782255-6-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 5/7] vhost-user: Introduce nested event loop
	in vhost_user_read()
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

A deadlock condition potentially exists if a vhost-user process needs
to request something to QEMU on the slave channel while processing a
vhost-user message.

This doesn't seem to affect any vhost-user implementation so far, but
this is currently biting the upcoming enablement of DAX with virtio-fs.
The issue is being observed when the guest does an emergency reboot while
a mapping still exits in the DAX window, which is very easy to get with
a busy enough workload (e.g. as simulated by blogbench [1]) :

- QEMU sends VHOST_USER_GET_VRING_BASE to virtiofsd.

- In order to complete the request, virtiofsd then asks QEMU to remove
  the mapping on the slave channel.

All these dialogs are synchronous, hence the deadlock.

As pointed out by Stefan Hajnoczi:

When QEMU's vhost-user master implementation sends a vhost-user protocol
message, vhost_user_read() does a "blocking" read during which slave_fd
is not monitored by QEMU.

The natural solution for this issue is an event loop. The main event
loop cannot be nested though since we have no guarantees that its
fd handlers are prepared for re-entrancy.

Introduce a new event loop that only monitors the chardev I/O for now
in vhost_user_read() and push the actual reading to a one-shot handler.
A subsequent patch will teach the loop to monitor and process messages
from the slave channel as well.

[1] https://github.com/jedisct1/Blogbench

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Greg Kurz <groug@kaod.org>
---
v2: - Document why a nested loop is needed in vhost_user_read() (Stefan)
---
 hw/virtio/vhost-user.c | 65 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 3c1e1611b087..00256fa318a6 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -296,15 +296,27 @@ static int vhost_user_read_header(struct vhost_dev *dev, VhostUserMsg *msg)
     return 0;
 }
 
-static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
+struct vhost_user_read_cb_data {
+    struct vhost_dev *dev;
+    VhostUserMsg *msg;
+    GMainLoop *loop;
+    int ret;
+};
+
+static gboolean vhost_user_read_cb(GIOChannel *source, GIOCondition condition,
+                                   gpointer opaque)
 {
+    struct vhost_user_read_cb_data *data = opaque;
+    struct vhost_dev *dev = data->dev;
+    VhostUserMsg *msg = data->msg;
     struct vhost_user *u = dev->opaque;
     CharBackend *chr = u->user->chr;
     uint8_t *p = (uint8_t *) msg;
     int r, size;
 
     if (vhost_user_read_header(dev, msg) < 0) {
-        return -1;
+        data->ret = -1;
+        goto end;
     }
 
     /* validate message size is sane */
@@ -312,7 +324,8 @@ static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
         error_report("Failed to read msg header."
                 " Size %d exceeds the maximum %zu.", msg->hdr.size,
                 VHOST_USER_PAYLOAD_SIZE);
-        return -1;
+        data->ret = -1;
+        goto end;
     }
 
     if (msg->hdr.size) {
@@ -322,11 +335,53 @@ static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
         if (r != size) {
             error_report("Failed to read msg payload."
                          " Read %d instead of %d.", r, msg->hdr.size);
-            return -1;
+            data->ret = -1;
+            goto end;
         }
     }
 
-    return 0;
+end:
+    g_main_loop_quit(data->loop);
+    return G_SOURCE_REMOVE;
+}
+
+static int vhost_user_read(struct vhost_dev *dev, VhostUserMsg *msg)
+{
+    struct vhost_user *u = dev->opaque;
+    CharBackend *chr = u->user->chr;
+    GMainContext *prev_ctxt = chr->chr->gcontext;
+    GMainContext *ctxt = g_main_context_new();
+    GMainLoop *loop = g_main_loop_new(ctxt, FALSE);
+    struct vhost_user_read_cb_data data = {
+        .dev = dev,
+        .loop = loop,
+        .msg = msg,
+        .ret = 0
+    };
+
+    /*
+     * We want to be able to monitor the slave channel fd while waiting
+     * for chr I/O. This requires an event loop, but we can't nest the
+     * one to which chr is currently attached : its fd handlers might not
+     * be prepared for re-entrancy. So we create a new one and switch chr
+     * to use it.
+     */
+    qemu_chr_be_update_read_handlers(chr->chr, ctxt);
+    qemu_chr_fe_add_watch(chr, G_IO_IN | G_IO_HUP, vhost_user_read_cb, &data);
+
+    g_main_loop_run(loop);
+
+    /*
+     * Restore the previous event loop context. This also destroys/recreates
+     * event sources : this guarantees that all pending events in the original
+     * context that have been processed by the nested loop are purged.
+     */
+    qemu_chr_be_update_read_handlers(chr->chr, prev_ctxt);
+
+    g_main_loop_unref(loop);
+    g_main_context_unref(ctxt);
+
+    return data.ret;
 }
 
 static int process_message_reply(struct vhost_dev *dev,
-- 
2.26.2

