DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=H52nasZ7BGuO7xuet/cKD9fD7bI69Ap/AdAM6/fVCZw=;
	b=NFIVQ3wJXi5NLtPFuJI2waRd/OCk6kjCZNMuCp/jtzS7y2g0Xu7FBO8jwFk7KJI3uK
	FtkNXy7GhedijGdnYi5DpB+1oa2HTsACMVa1LWIN27f2IaW0NxUd4VYwvz9WaWrziRbt
	+Rl1+jZuxvIbjbEovFxHYi4/XY/TU1NFzFlSZxnE9sW/tZboW1Qn6OUgVUIZDi3sLSUV
	fDyHP1LialgB6cLFdKKlKZzk39NHRUC0Z4BgYy/Vfi+Ec+ojTgE4JW3hyJMvOKfZfb2l
	zPjGNd7geimd3BGSXdMpAxH4BfBjjL4IrKfqddHp7aGfW1ziHEDaxm3oA12t5pHxgDUN
	WJIw==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:14 +0800
Message-Id: <20201215162119.27360-5-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 4/9] libvhost-user: Add vhost-user message
	types for sending shared memory and file fds
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

Add libvhost-user support for the 4 new vhost-user messages types:

    VHOST_USER_SET_SHM
    VHOST_USER_SET_FD
    VHOST_USER_SLAVE_SHM
    VHOST_USER_SLAVE_FD

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 contrib/libvhost-user/libvhost-user.c | 88 +++++++++++++++++++++++++++
 contrib/libvhost-user/libvhost-user.h | 70 +++++++++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/contrib/libvhost-user/libvhost-user.c b/contrib/libvhost-user/libvhost-user.c
index bfec8a881a..8c97013e59 100644
--- a/contrib/libvhost-user/libvhost-user.c
+++ b/contrib/libvhost-user/libvhost-user.c
@@ -140,6 +140,8 @@ vu_request_to_string(unsigned int req)
         REQ(VHOST_USER_ADD_MEM_REG),
         REQ(VHOST_USER_REM_MEM_REG),
         REQ(VHOST_USER_MAX),
+        REQ(VHOST_USER_SET_SHM),
+        REQ(VHOST_USER_SET_FD),
     };
 #undef REQ
 
@@ -1718,6 +1720,77 @@ vu_set_inflight_fd(VuDev *dev, VhostUserMsg *vmsg)
     return false;
 }
 
+bool vu_slave_send_shm(VuDev *dev, int memfd, uint64_t size, int map_type)
+{
+    VhostUserMsg vmsg = {
+        .request = VHOST_USER_SLAVE_SHM,
+        .flags = VHOST_USER_VERSION,
+        .size = sizeof(VhostUserShm),
+        .payload.shm = {
+            .id = map_type,
+            .size = size,
+            .offset = 0,
+        },
+    };
+
+    vmsg.fd_num = 1;
+    vmsg.fds[0] = memfd;
+
+    if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_SLAVE_SEND_FD)) {
+        return false;
+    }
+
+    pthread_mutex_lock(&dev->slave_mutex);
+    if (!vu_message_write(dev, dev->slave_fd, &vmsg)) {
+        pthread_mutex_unlock(&dev->slave_mutex);
+        return false;
+    }
+
+    /* Also unlocks the slave_mutex */
+    return vu_process_message_reply(dev, &vmsg);
+}
+
+static bool vu_slave_send_fd(VuDev *dev, int fd, int fd_key, int flag)
+{
+    VhostUserMsg vmsg = {
+        .request = VHOST_USER_SLAVE_FD,
+        .flags = VHOST_USER_VERSION,
+        .size = sizeof(vmsg.payload.fdinfo),
+    };
+
+    vmsg.payload.fdinfo.key = fd_key;
+    vmsg.payload.fdinfo.flag = flag;
+    if (flag == VU_FD_FLAG_ADD) {
+        vmsg.fds[0] = fd;
+    }
+    vmsg.fd_num = 1;
+
+    if (!vu_has_protocol_feature(dev, VHOST_USER_PROTOCOL_F_SLAVE_SEND_FD)) {
+        return false;
+    }
+
+    pthread_mutex_lock(&dev->slave_mutex);
+    if (!vu_message_write(dev, dev->slave_fd, &vmsg)) {
+        pthread_mutex_unlock(&dev->slave_mutex);
+        return false;
+    }
+
+    /* Also unlocks the slave_mutex */
+    bool ret =
+    vu_process_message_reply(dev, &vmsg);
+    return ret;
+}
+
+bool vu_slave_send_fd_add(VuDev *dev, int fd, int fd_key)
+{
+    return vu_slave_send_fd(dev, fd, fd_key, VU_FD_FLAG_ADD);
+}
+
+bool vu_slave_send_fd_del(VuDev *dev, int fd_key)
+{
+    return vu_slave_send_fd(dev, -1, fd_key, VU_FD_FLAG_DEL);
+}
+
 static bool
 vu_handle_vring_kick(VuDev *dev, VhostUserMsg *vmsg)
 {
@@ -1762,6 +1835,9 @@ static bool vu_handle_get_max_memslots(VuDev *dev, VhostUserMsg *vmsg)
     return false;
 }
 
+bool (*vu_set_shm_cb)(VuDev *dev, VhostUserMsg *vmsg);
+bool (*vu_set_fd_cb)(VuDev *dev, VhostUserMsg *vmsg);
+
 static bool
 vu_process_message(VuDev *dev, VhostUserMsg *vmsg)
 {
@@ -1852,6 +1928,18 @@ vu_process_message(VuDev *dev, VhostUserMsg *vmsg)
         return vu_add_mem_reg(dev, vmsg);
     case VHOST_USER_REM_MEM_REG:
         return vu_rem_mem_reg(dev, vmsg);
+    case VHOST_USER_SET_SHM:
+        if (vu_set_shm_cb) {
+            return vu_set_shm_cb(dev, vmsg);
+        } else  {
+            return false;
+        }
+    case VHOST_USER_SET_FD:
+        if (vu_set_fd_cb) {
+            return vu_set_fd_cb(dev, vmsg);
+        } else  {
+            return false;
+        }
     default:
         vmsg_close_fds(vmsg);
         vu_panic(dev, "Unhandled request: %d", vmsg->request);
diff --git a/contrib/libvhost-user/libvhost-user.h b/contrib/libvhost-user/libvhost-user.h
index a1539dbb69..5448dc5818 100644
--- a/contrib/libvhost-user/libvhost-user.h
+++ b/contrib/libvhost-user/libvhost-user.h
@@ -64,6 +64,7 @@ enum VhostUserProtocolFeature {
     VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD = 12,
     VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS = 14,
     VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS = 15,
+    VHOST_USER_PROTOCOL_F_MAP_SHMFD = 17,
 
     VHOST_USER_PROTOCOL_F_MAX
 };
@@ -109,6 +110,8 @@ typedef enum VhostUserRequest {
     VHOST_USER_GET_MAX_MEM_SLOTS = 36,
     VHOST_USER_ADD_MEM_REG = 37,
     VHOST_USER_REM_MEM_REG = 38,
+    VHOST_USER_SET_SHM = 41,
+    VHOST_USER_SET_FD = 42,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -119,6 +122,8 @@ typedef enum VhostUserSlaveRequest {
     VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG = 3,
     VHOST_USER_SLAVE_VRING_CALL = 4,
     VHOST_USER_SLAVE_VRING_ERR = 5,
+    VHOST_USER_SLAVE_SHM = 6,
+    VHOST_USER_SLAVE_FD = 7,
     VHOST_USER_SLAVE_MAX
 }  VhostUserSlaveRequest;
 
@@ -170,6 +175,29 @@ typedef struct VhostUserInflight {
     uint16_t queue_size;
 } VhostUserInflight;
 
+#ifndef VU_PERSIST_STRUCTS
+#define VU_PERSIST_STRUCTS
+
+typedef struct VhostUserShm {
+    int id;
+    uint64_t size;
+    uint64_t offset;
+} VhostUserShm;
+
+typedef enum VhostUserFdFlag {
+    VU_FD_FLAG_ADD = 0,
+    VU_FD_FLAG_DEL = 1,
+    VU_FD_FLAG_RESTORE = 2,
+    VU_FD_FLAG_MAX
+} VhostUserFdFlag;
+
+typedef struct VhostUserFd {
+    int key;
+    VhostUserFdFlag flag;
+} VhostUserFd;
+#endif
+
+
 #if defined(_WIN32) && (defined(__x86_64__) || defined(__i386__))
 # define VU_PACKED __attribute__((gcc_struct, packed))
 #else
@@ -197,6 +225,8 @@ typedef struct VhostUserMsg {
         VhostUserConfig config;
         VhostUserVringArea area;
         VhostUserInflight inflight;
+        VhostUserShm shm;
+        VhostUserFd fdinfo;
     } payload;
 
     int fds[VHOST_MEMORY_BASELINE_NREGIONS];
@@ -687,4 +717,44 @@ void vu_queue_get_avail_bytes(VuDev *vdev, VuVirtq *vq, unsigned int *in_bytes,
 bool vu_queue_avail_bytes(VuDev *dev, VuVirtq *vq, unsigned int in_bytes,
                           unsigned int out_bytes);
 
+/**
+ * vu_slave_send_shm:
+ * @dev: a VuDev context
+ * @memfd: the shared memory fd to sync with QEMU
+ * @size: shared memory lenth
+ * @map_type: the lo_map type number
+ *
+ * Sync the map_type region that shared with QEMU when memfd or its size
+ * is changed.
+ *
+ * Returns: true on success.
+ */
+bool vu_slave_send_shm(VuDev *dev, int memfd, uint64_t size, int map_type);
+
+/**
+ * vu_slave_send_fd_add:
+ * @dev: a VuDev context
+ * @fd: the fd to send to QEMU
+ * @fd_key: the fingerprint of the fd
+ *
+ * Send a opened file fd to QEMU.
+ *
+ * Returns: true on success.
+ */
+bool vu_slave_send_fd_add(VuDev *dev, int fd, int fd_key);
+
+/**
+ * vu_slave_send_fd_del:
+ * @dev: a VuDev context
+ * @fd_key: the fingerprint of the fd
+ *
+ * Remove a file fd from QEMU.
+ *
+ * Returns: true on success.
+ */
+bool vu_slave_send_fd_del(VuDev *dev, int fd_key);
+
+extern bool (*vu_set_shm_cb)(VuDev *dev, VhostUserMsg *vmsg);
+extern bool (*vu_set_fd_cb)(VuDev *dev, VhostUserMsg *vmsg);
+
 #endif /* LIBVHOST_USER_H */
-- 
2.20.1

