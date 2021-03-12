From: Greg Kurz <groug@kaod.org>
Date: Fri, 12 Mar 2021 10:22:07 +0100
Message-Id: <20210312092212.782255-3-groug@kaod.org>
In-Reply-To: <20210312092212.782255-1-groug@kaod.org>
References: <20210312092212.782255-1-groug@kaod.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 2/7] vhost-user: Fix double-close on
	slave_read() error path
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

Some message types, e.g. VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG,
can convey file descriptors. These must be closed before returning
from slave_read() to avoid being leaked. This can currently be done
in two different places:

[1] just after the request has been processed

[2] on the error path, under the goto label err:

These path are supposed to be mutually exclusive but they are not
actually. If the VHOST_USER_NEED_REPLY_MASK flag was passed and the
sending of the reply fails, both [1] and [2] are performed with the
same descriptor values. This can potentially cause subtle bugs if one
of the descriptor was recycled by some other thread in the meantime.

This code duplication complicates rollback for no real good benefit.
Do the closing in a unique place, under a new fdcleanup: goto label
at the end of the function.

Signed-off-by: Greg Kurz <groug@kaod.org>
---
 hw/virtio/vhost-user.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 6af9b43a7232..acde1d293684 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -1475,13 +1475,6 @@ static void slave_read(void *opaque)
         ret = -EINVAL;
     }
 
-    /* Close the remaining file descriptors. */
-    for (i = 0; i < fdsize; i++) {
-        if (fd[i] != -1) {
-            close(fd[i]);
-        }
-    }
-
     /*
      * REPLY_ACK feature handling. Other reply types has to be managed
      * directly in their request handlers.
@@ -1511,12 +1504,14 @@ static void slave_read(void *opaque)
         }
     }
 
-    return;
+    goto fdcleanup;
 
 err:
     qemu_set_fd_handler(u->slave_fd, NULL, NULL, NULL);
     close(u->slave_fd);
     u->slave_fd = -1;
+
+fdcleanup:
     for (i = 0; i < fdsize; i++) {
         if (fd[i] != -1) {
             close(fd[i]);
-- 
2.26.2

