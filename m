From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:15 +0100
Message-Id: <20210414155137.46522-4-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 03/25] DAX: libvhost-user: Route slave
	message payload
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Route the uint64 payload from message replies on the slave back up
through vu_process_message_reply and to the callers.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 subprojects/libvhost-user/libvhost-user.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
index fab7ca17ee..937f64480d 100644
--- a/subprojects/libvhost-user/libvhost-user.c
+++ b/subprojects/libvhost-user/libvhost-user.c
@@ -403,9 +403,11 @@ vu_send_reply(VuDev *dev, int conn_fd, VhostUserMsg *vmsg)
  * Processes a reply on the slave channel.
  * Entered with slave_mutex held and releases it before exit.
  * Returns true on success.
+ * *payload is written on success
  */
 static bool
-vu_process_message_reply(VuDev *dev, const VhostUserMsg *vmsg)
+vu_process_message_reply(VuDev *dev, const VhostUserMsg *vmsg,
+                         uint64_t *payload)
 {
     VhostUserMsg msg_reply;
     bool result = false;
@@ -425,7 +427,8 @@ vu_process_message_reply(VuDev *dev, const VhostUserMsg *vmsg)
         goto out;
     }
 
-    result = msg_reply.payload.u64 == 0;
+    *payload = msg_reply.payload.u64;
+    result = true;
 
 out:
     pthread_mutex_unlock(&dev->slave_mutex);
@@ -1312,6 +1315,8 @@ bool vu_set_queue_host_notifier(VuDev *dev, VuVirtq *vq, int fd,
 {
     int qidx = vq - dev->vq;
     int fd_num = 0;
+    bool res;
+    uint64_t payload = 0;
     VhostUserMsg vmsg = {
         .request = VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG,
         .flags = VHOST_USER_VERSION | VHOST_USER_NEED_REPLY_MASK,
@@ -1342,7 +1347,10 @@ bool vu_set_queue_host_notifier(VuDev *dev, VuVirtq *vq, int fd,
     }
 
     /* Also unlocks the slave_mutex */
-    return vu_process_message_reply(dev, &vmsg);
+    res = vu_process_message_reply(dev, &vmsg, &payload);
+    res = res && (payload == 0);
+
+    return res;
 }
 
 static bool
-- 
2.31.1

