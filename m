From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:06 +0100
Message-Id: <20210312092212.782255-2-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 1/7] vhost-user: Drop misleading EAGAIN
	checks in slave_read()
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

slave_read() checks EAGAIN when reading or writing to the socket
fails. This gives the impression that the slave channel is in
non-blocking mode, which is certainly not the case with the current
code base. And the rest of the code isn't actually ready to cope
with non-blocking I/O.

Just drop the checks everywhere in this function for the sake of
clarity.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 hw/virtio/vhost-user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 2fdd5daf74bb..6af9b43a7232 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1420,7 +1420,7 @@ static void slave_read(void *opaque)
 
     do {
         size = recvmsg(u->slave_fd, &msgh, 0);
-    } while (size < 0 && (errno == EINTR || errno == EAGAIN));
+    } while (size < 0 && errno == EINTR);
 
     if (size != VHOST_USER_HDR_SIZE) {
         error_report("Failed to read from slave.");
@@ -1452,7 +1452,7 @@ static void slave_read(void *opaque)
     /* Read payload */
     do {
         size = read(u->slave_fd, &payload, hdr.size);
-    } while (size < 0 && (errno == EINTR || errno == EAGAIN));
+    } while (size < 0 && errno == EINTR);
 
     if (size != hdr.size) {
         error_report("Failed to read payload from slave.");
@@ -1503,7 +1503,7 @@ static void slave_read(void *opaque)
 
         do {
             size = writev(u->slave_fd, iovec, ARRAY_SIZE(iovec));
-        } while (size < 0 && (errno == EINTR || errno == EAGAIN));
+        } while (size < 0 && errno == EINTR);
 
         if (size != VHOST_USER_HDR_SIZE + hdr.size) {
             error_report("Failed to send msg reply to slave.");
-- 
2.26.2

