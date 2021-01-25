From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 25 Jan 2021 13:01:14 -0500
Message-Id: <20210125180115.22936-6-vgoyal@redhat.com>
In-Reply-To: <20210125180115.22936-1-vgoyal@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/6] libvhost-user: Add support to
	start/stop/flush slave channel
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: marcandre.lureau@redhat.com, vgoyal@redhat.com, mst@redhat.com

This patch adds support to start/stop/flush slave channel functionality.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 subprojects/libvhost-user/libvhost-user.c | 103 ++++++++++++++++++++--
 subprojects/libvhost-user/libvhost-user.h |   8 +-
 2 files changed, 105 insertions(+), 6 deletions(-)

diff --git a/subprojects/libvhost-user/libvhost-user.c b/subprojects/libvhost-user/libvhost-user.c
index 7a56c56dc8..b4c795c63e 100644
--- a/subprojects/libvhost-user/libvhost-user.c
+++ b/subprojects/libvhost-user/libvhost-user.c
@@ -140,6 +140,8 @@ vu_request_to_string(unsigned int req)
         REQ(VHOST_USER_GET_MAX_MEM_SLOTS),
         REQ(VHOST_USER_ADD_MEM_REG),
         REQ(VHOST_USER_REM_MEM_REG),
+        REQ(VHOST_USER_START_SLAVE_CHANNEL),
+        REQ(VHOST_USER_STOP_SLAVE_CHANNEL),
         REQ(VHOST_USER_MAX),
     };
 #undef REQ
@@ -437,11 +439,11 @@ out:
     return result;
 }
 
-/* Returns true on success, false otherwise */
+/* slave mutex should be held. Will be unlocked upon return */
 static bool
-vu_message_slave_send_receive(VuDev *dev, VhostUserMsg *vmsg, uint64_t *payload)
+vu_message_slave_send_receive_locked(VuDev *dev, VhostUserMsg *vmsg,
+                                     uint64_t *payload)
 {
-    pthread_mutex_lock(&dev->slave_mutex);
     if (!vu_message_write(dev, dev->slave_fd, vmsg)) {
         pthread_mutex_unlock(&dev->slave_mutex);
         return false;
@@ -456,6 +458,46 @@ vu_message_slave_send_receive(VuDev *dev, VhostUserMsg *vmsg, uint64_t *payload)
     return vu_process_message_reply(dev, vmsg, payload);
 }
 
+/* Returns true on success, false otherwise */
+static bool
+vu_message_slave_send_receive(VuDev *dev, VhostUserMsg *vmsg,
+                                          uint64_t *payload)
+{
+    pthread_mutex_lock(&dev->slave_mutex);
+    if (!dev->slave_channel_open) {
+        pthread_mutex_unlock(&dev->slave_mutex);
+        return false;
+    }
+    return vu_message_slave_send_receive_locked(dev, vmsg, payload);
+}
+
+static bool
+vu_finish_stop_slave(VuDev *dev)
+{
+    bool res;
+    uint64_t payload = 0;
+    VhostUserMsg vmsg = {
+        .request = VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE,
+        .flags = VHOST_USER_VERSION | VHOST_USER_NEED_REPLY_MASK,
+        .size = sizeof(vmsg.payload.u64),
+        .payload.u64 = 0,
+    };
+
+    /*
+     * Once we get slave_mutex, this should make sure no other caller is
+     * currently in the process of sending or receiving message on slave_fd.
+     * And setting slave_channel_open to false now will make sure any new
+     * callers will not send message and instead get error back. So it
+     * is now safe to send stop finished message to master.
+     */
+    pthread_mutex_lock(&dev->slave_mutex);
+    dev->slave_channel_open = false;
+    /* This also drops slave_mutex */
+    res = vu_message_slave_send_receive_locked(dev, &vmsg, &payload);
+    res = res && (payload == 0);
+    return res;
+}
+
 /* Kick the log_call_fd if required. */
 static void
 vu_log_kick(VuDev *dev)
@@ -1529,6 +1571,35 @@ vu_set_slave_req_fd(VuDev *dev, VhostUserMsg *vmsg)
     return false;
 }
 
+static bool
+vu_slave_channel_start(VuDev *dev, VhostUserMsg *vmsg)
+{
+    pthread_mutex_lock(&dev->slave_mutex);
+        dev->slave_channel_open = true;
+    pthread_mutex_unlock(&dev->slave_mutex);
+    /* Caller (vu_dispatch()) will send a reply */
+    return false;
+}
+
+static bool
+vu_slave_channel_stop(VuDev *dev, VhostUserMsg *vmsg, bool *reply_sent,
+                      bool *reply_status)
+{
+    vmsg_set_reply_u64(vmsg, 0);
+    *reply_sent = true;
+    *reply_status = false;
+    if (!vu_send_reply(dev, dev->sock, vmsg)) {
+        return false;
+    }
+
+    if (!vu_finish_stop_slave(dev)) {
+        return false;
+    }
+
+    *reply_status = true;
+    return false;
+}
+
 static bool
 vu_get_config(VuDev *dev, VhostUserMsg *vmsg)
 {
@@ -1823,7 +1894,8 @@ static bool vu_handle_get_max_memslots(VuDev *dev, VhostUserMsg *vmsg)
 }
 
 static bool
-vu_process_message(VuDev *dev, VhostUserMsg *vmsg)
+vu_process_message(VuDev *dev, VhostUserMsg *vmsg, bool *reply_sent,
+                   bool *reply_status)
 {
     int do_reply = 0;
 
@@ -1843,6 +1915,14 @@ vu_process_message(VuDev *dev, VhostUserMsg *vmsg)
         DPRINT("\n");
     }
 
+    if (reply_sent) {
+        *reply_sent = false;
+    }
+
+    if (reply_status) {
+        *reply_status = false;
+    }
+
     if (dev->iface->process_msg &&
         dev->iface->process_msg(dev, vmsg, &do_reply)) {
         return do_reply;
@@ -1912,6 +1992,10 @@ vu_process_message(VuDev *dev, VhostUserMsg *vmsg)
         return vu_add_mem_reg(dev, vmsg);
     case VHOST_USER_REM_MEM_REG:
         return vu_rem_mem_reg(dev, vmsg);
+    case VHOST_USER_START_SLAVE_CHANNEL:
+        return vu_slave_channel_start(dev, vmsg);
+    case VHOST_USER_STOP_SLAVE_CHANNEL:
+        return vu_slave_channel_stop(dev, vmsg, reply_sent, reply_status);
     default:
         vmsg_close_fds(vmsg);
         vu_panic(dev, "Unhandled request: %d", vmsg->request);
@@ -1926,6 +2010,7 @@ vu_dispatch(VuDev *dev)
     VhostUserMsg vmsg = { 0, };
     int reply_requested;
     bool need_reply, success = false;
+    bool reply_sent = false, reply_status = false;
 
     if (!dev->read_msg(dev, dev->sock, &vmsg)) {
         goto end;
@@ -1933,7 +2018,14 @@ vu_dispatch(VuDev *dev)
 
     need_reply = vmsg.flags & VHOST_USER_NEED_REPLY_MASK;
 
-    reply_requested = vu_process_message(dev, &vmsg);
+    reply_requested = vu_process_message(dev, &vmsg, &reply_sent,
+                                         &reply_status);
+    /* reply has already been sent, if needed */
+    if (reply_sent) {
+        success = reply_status;
+        goto end;
+    }
+
     if (!reply_requested && need_reply) {
         vmsg_set_reply_u64(&vmsg, 0);
         reply_requested = 1;
@@ -2051,6 +2143,7 @@ vu_init(VuDev *dev,
     dev->log_call_fd = -1;
     pthread_mutex_init(&dev->slave_mutex, NULL);
     dev->slave_fd = -1;
+    dev->slave_channel_open = false;
     dev->max_queues = max_queues;
 
     dev->vq = malloc(max_queues * sizeof(dev->vq[0]));
diff --git a/subprojects/libvhost-user/libvhost-user.h b/subprojects/libvhost-user/libvhost-user.h
index ee75d4931f..1d0ef54f69 100644
--- a/subprojects/libvhost-user/libvhost-user.h
+++ b/subprojects/libvhost-user/libvhost-user.h
@@ -64,6 +64,7 @@ enum VhostUserProtocolFeature {
     VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD = 12,
     VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS = 14,
     VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
+    VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP = 16,
 
     VHOST_USER_PROTOCOL_F_MAX
 };
@@ -109,6 +110,8 @@ typedef enum VhostUserRequest {
     VHOST_USER_GET_MAX_MEM_SLOTS = 36,
     VHOST_USER_ADD_MEM_REG = 37,
     VHOST_USER_REM_MEM_REG = 38,
+    VHOST_USER_START_SLAVE_CHANNEL = 39,
+    VHOST_USER_STOP_SLAVE_CHANNEL = 40,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -123,6 +126,7 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_FS_UNMAP = 7,
     VHOST_USER_SLAVE_FS_SYNC = 8,
     VHOST_USER_SLAVE_FS_IO = 9,
+    VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE = 10,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -405,9 +409,11 @@ struct VuDev {
     VuVirtq *vq;
     VuDevInflightInfo inflight_info;
     int log_call_fd;
-    /* Must be held while using slave_fd */
+    /* Must be held while using slave_fd, slave_channel_open */
     pthread_mutex_t slave_mutex;
     int slave_fd;
+    /* If not set, do not send more requests on slave fd. */
+    bool slave_channel_open;
     uint64_t log_size;
     uint8_t *log_table;
     uint64_t features;
-- 
2.25.4

