From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:08 +0100
Message-Id: <20210312092212.782255-4-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 3/7] vhost-user: Factor out duplicated
	slave_fd teardown code
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

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 hw/virtio/vhost-user.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index acde1d293684..cb0c98f30a8d 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1392,6 +1392,13 @@ static int vhost_user_slave_handle_vring_host_notifier(struct vhost_dev *dev,
     return 0;
 }
 
+static void close_slave_channel(struct vhost_user *u)
+{
+    qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
+    close(u->slave_fd);
+    u->slave_fd = -1;
+}
+
 static void slave_read(void *opaque)
 {
     struct vhost_dev *dev = opaque;
@@ -1507,9 +1514,7 @@ static void slave_read(void *opaque)
     goto fdcleanup;
 
 err:
-    qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
-    close(u->slave_fd);
-    u->slave_fd = -1;
+    close_slave_channel(u);
 
 fdcleanup:
     for (i = 0; i < fdsize; i++) {
@@ -1560,9 +1565,7 @@ static int vhost_setup_slave_channel(struct vhost_dev *dev)
 out:
     close(sv[1]);
     if (ret) {
-        qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
-        close(u->slave_fd);
-        u->slave_fd = -1;
+        close_slave_channel(u);
     }
 
     return ret;
@@ -1915,9 +1918,7 @@ static int vhost_user_backend_cleanup(struct vhost_dev *dev)
         u->postcopy_fd.handler = NULL;
     }
     if (u->slave_fd >= 0) {
-        qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
-        close(u->slave_fd);
-        u->slave_fd = -1;
+        close_slave_channel(u);
     }
     g_free(u->region_rb);
     u->region_rb = NULL;
-- 
2.26.2

