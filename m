From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 25 Jan 2021 13:01:13 -0500
Message-Id: <20210125180115.22936-5-vgoyal@redhat.com>
In-Reply-To: <20210125180115.22936-1-vgoyal@redhat.com>
References: <20210125180115.22936-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 4/6] qemu,
	vhost-user: Extend protocol to start/stop/flush slave channel
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

Currently we don't have a mechanism to flush slave channel while shutting
down vhost-user device and that can result a deadlock. Consider following
scenario.

1. Slave gets a request from guest on virtqueue (say index 1, vq1), to map
   a portion of file in qemu address space.

2. Thread serving vq1 receives this request and sends a message to qemu on
   slave channel/fd and gets blocked in waiting for a response from qemu.

3. In the mean time, user does "echo b > /proc/sysrq-trigger" in guest. This
   leads to qemu reset and ultimately in main thread we end up in
   vhost_dev_stop() which is trying to shutdown virtqueues for the device.

4. Slave gets VHOST_USER_GET_VRING_BASE message to shutdown a virtqueue on
   unix socket being used for communication.

5. Slave tries to shutdown the thread serving vq1 and waits for it to
   terminate. But vq1 thread can't terminate because it is waiting for
   a response from qemu on slave_fd. And qemu is not processing slave_fd
   anymore as qemu is ressing (and not running main event loop anymore)
   and is waiting for a response to VHOST_USER_GET_VRING_BASE.

So we have a deadlock. Qemu is waiting on slave to response to
VHOST_USER_GET_VRING_BASE message and slave is waiting on qemu to
respond to request it sent on slave_fd.

I can reliably reproduce this race with virtio-fs.

Hence here is the proposal to solve this problem. Enhance vhost-user
protocol to properly shutdown slave_fd channel. And if there are pending
requests, flush the channel completely before sending the request to
shutdown virtqueues.

New workflow to shutdown slave channel is.

- Qemu sends VHOST_USER_STOP_SLAVE_CHANNEL request to slave. It waits
  for an reply from guest.

- Then qemu sits in a tight loop waiting for
  VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message from slave on slave_fd.
  And while waiting for this message, qemu continues to process requests
  on slave_fd to flush any pending requests. This will unblock threads
  in slave and allow slave to shutdown slave channel.

- Once qemu gets VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE message, it knows
  no more requests will come on slave_fd and it can continue to shutdown
  virtqueues now.

- Once device starts again, qemu will send VHOST_USER_START_SLAVE_CHANNEL
  message to slave to open the slave channel and receive requests.

IOW, this allows for proper shutdown of slave channel, making sure
no threads in slave are blocked on sending/receiving message. And
this in-turn allows for shutting down of virtqueues, hence resolving
the deadlock.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 hw/virtio/vhost-user.c | 108 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index 867cac034f..56be61d4e2 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -80,6 +80,7 @@ enum VhostUserProtocolFeature {
     VHOST_USER_PROTOCOL_F_RESET_DEVICE = 13,
     /* Feature 14 reserved for VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS. */
     VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
+    VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP = 16,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
@@ -125,6 +126,8 @@ typedef enum VhostUserRequest {
     VHOST_USER_GET_MAX_MEM_SLOTS = 36,
     VHOST_USER_ADD_MEM_REG = 37,
     VHOST_USER_REM_MEM_REG = 38,
+    VHOST_USER_START_SLAVE_CHANNEL = 39,
+    VHOST_USER_STOP_SLAVE_CHANNEL = 40,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -139,6 +142,7 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_FS_UNMAP = 7,
     VHOST_USER_SLAVE_FS_SYNC = 8,
     VHOST_USER_SLAVE_FS_IO = 9,
+    VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE = 10,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -246,6 +250,7 @@ struct vhost_user {
     /* Shared between vhost devs of the same virtio device */
     VhostUserState *user;
     int slave_fd;
+    bool slave_channel_open;
     NotifierWithReturn postcopy_notifier;
     struct PostCopyFD  postcopy_fd;
     uint64_t           postcopy_client_bases[VHOST_USER_MAX_RAM_SLOTS];
@@ -1511,6 +1516,10 @@ static int do_slave_read(void *opaque)
         ret = vhost_user_fs_slave_io(dev, &payload.fs, fd[0]);
         break;
 #endif
+    case VHOST_USER_SLAVE_STOP_CHANNEL_COMPLETE:
+        u->slave_channel_open = false;
+        ret = 0;
+        break;
     default:
         error_report("Received unexpected msg type: %d.", hdr.request);
         ret = (uint64_t)-EINVAL;
@@ -1580,6 +1589,70 @@ static void slave_read(void *opaque)
     do_slave_read(opaque);
 }
 
+static int vhost_start_slave_channel(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    VhostUserMsg msg = {
+        .hdr.request = VHOST_USER_START_SLAVE_CHANNEL,
+        .hdr.flags = VHOST_USER_VERSION | VHOST_USER_NEED_REPLY_MASK,
+    };
+    int ret = 0;
+
+    if (!virtio_has_feature(dev->protocol_features,
+                            VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP)) {
+        return 0;
+    }
+
+    ret = vhost_user_write(dev, &msg, NULL, 0);
+    if (ret) {
+        return ret;
+    }
+
+    ret = process_message_reply(dev, &msg);
+    if (ret)
+        return ret;
+
+    u->slave_channel_open = true;
+    return ret;
+}
+
+static int vhost_stop_slave_channel(struct vhost_dev *dev)
+{
+    struct vhost_user *u = dev->opaque;
+    VhostUserMsg msg = {
+        .hdr.request = VHOST_USER_STOP_SLAVE_CHANNEL,
+        .hdr.flags = VHOST_USER_VERSION | VHOST_USER_NEED_REPLY_MASK,
+    };
+    int ret = 0;
+
+    if (!virtio_has_feature(dev->protocol_features,
+                            VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP)) {
+        return 0;
+    }
+
+    ret = vhost_user_write(dev, &msg, NULL, 0);
+    if (ret) {
+        return ret;
+    }
+
+    ret = process_message_reply(dev, &msg);
+    if (ret) {
+        return ret;
+    }
+
+    /*
+     * Wait for flush finish message from slave. And continue to process
+     * slave messages till we get flush finish.
+     */
+    while (u->slave_channel_open) {
+        ret = do_slave_read(dev);
+        if (ret)
+            break;
+    }
+
+    return ret;
+}
+
 static int vhost_setup_slave_channel(struct vhost_dev *dev)
 {
     VhostUserMsg msg = {
@@ -1860,6 +1933,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque)
     u = g_new0(struct vhost_user, 1);
     u->user = opaque;
     u->slave_fd = -1;
+    u->slave_channel_open = false;
     u->dev = dev;
     dev->opaque = u;
 
@@ -1934,6 +2008,17 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque)
 
             u->user->memory_slots = MIN(ram_slots, VHOST_USER_MAX_RAM_SLOTS);
         }
+
+        if (virtio_has_feature(dev->protocol_features,
+                               VHOST_USER_PROTOCOL_F_SLAVE_CH_START_STOP) &&
+                !(virtio_has_feature(dev->protocol_features,
+                    VHOST_USER_PROTOCOL_F_SLAVE_REQ) &&
+                 virtio_has_feature(dev->protocol_features,
+                    VHOST_USER_PROTOCOL_F_REPLY_ACK))) {
+            error_report("Slave channel start/stop support requires reply-ack"
+                         " and slave-req protocol features.");
+            return -1;
+        }
     }
 
     if (dev->migration_blocker == NULL &&
@@ -1949,6 +2034,10 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque)
         if (err < 0) {
             return err;
         }
+        err = vhost_start_slave_channel(dev);
+        if (err < 0) {
+            return err;
+        }
     }
 
     u->postcopy_notifier.notify = vhost_user_postcopy_notifier;
@@ -2408,6 +2497,24 @@ void vhost_user_cleanup(VhostUserState *user)
     user->chr = NULL;
 }
 
+static int vhost_user_dev_start(struct vhost_dev *dev, bool started)
+{
+    int ret;
+
+    if (!started) {
+        ret = vhost_stop_slave_channel(dev);
+        if (ret < 0) {
+            return ret;
+        }
+    } else {
+        ret = vhost_start_slave_channel(dev);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+    return 0;
+}
+
 const VhostOps user_ops = {
         .backend_type = VHOST_BACKEND_TYPE_USER,
         .vhost_backend_init = vhost_user_backend_init,
@@ -2434,6 +2541,7 @@ const VhostOps user_ops = {
         .vhost_net_set_mtu = vhost_user_net_set_mtu,
         .vhost_set_iotlb_callback = vhost_user_set_iotlb_callback,
         .vhost_send_device_iotlb_msg = vhost_user_send_device_iotlb_msg,
+        .vhost_dev_start = vhost_user_dev_start,
         .vhost_get_config = vhost_user_get_config,
         .vhost_set_config = vhost_user_set_config,
         .vhost_crypto_create_session = vhost_user_crypto_create_session,
-- 
2.25.4

