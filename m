DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=IB+k29zP6M9ZuhdJ/l7Jim5BnTeNatYhCvVUNikRT68=;
	b=pcihtQV+33xGQ7k8w8sI4Ck9P5nbKk6pGh1Dyp/av240t1M7Thz0p/8XjQiK9X/1wu
	Lam4BdOGUrGEqj+d/WO6u61ceFaeOW/CpYqsJD4smECikXHDyr7sDGdGB6j/aiABK1K6
	XH+W0zeoM1X1YYBciONIsE97JuU9ly6rkBANLV9rE49GqlAUsXjCWixnDaAfKBdTjTn7
	uQJbQamoD8dYm0XIVkxyukLqrtDdUiqTtBgr6psnwk6hgzgdeCtluhObh0euyvNyRHnj
	2ywqbq8vHHtoy4+vsGoM+NqELmLimrIsUqtVnDnO6aQpPhINFZyfW9M6Vy6bA+3ewRPp
	jQbw==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:13 +0800
Message-Id: <20201215162119.27360-4-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC PATCH 3/9] vhost-user-fs: Support virtiofsd crash
	reconnection
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

This commit adds vhost-user-fs device-end support for the virtio-fs crash
reconnection, mainly the vhost-user callbacks. The VhostUserFSPersist
structure is also added to save the virtiofsd status at QEMU-side:

    typedef struct {
        bool need_restore;

        /* for persistent of lo_maps */
        VhostUserShm maps[MAP_TYPE_NUM];
        int map_fds[MAP_TYPE_NUM];

        /* for persistent of fds */
        GHashTable *fd_ht;
    } VhostUserFSPersist;

The fd_ht GHashTable is to save the opened file descriptors sent from
virtiofsd, the maps and map_fds are to save the shared memory related
status sent from virtiofsd.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 hw/virtio/vhost-user-fs.c         | 118 +++++++++++++++++++++++++++++-
 include/hw/virtio/vhost-user-fs.h |  14 +++-
 2 files changed, 130 insertions(+), 2 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index ce343101d4..a4f58821b3 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -72,6 +72,18 @@ static int vuf_start(VirtIODevice *vdev)
         }
     }
 
+    ret = vhost_dev_set_shm(&fs->vhost_dev);
+    if (ret < 0) {
+        error_report("Error set fs maps: %d", -ret);
+        goto err_guest_notifiers;
+    }
+
+    ret = vhost_dev_set_fd(&fs->vhost_dev);
+    if (ret < 0) {
+        error_report("Error set fs proc fds: %d", -ret);
+        goto err_guest_notifiers;
+    }
+
     ret = vhost_dev_set_inflight(&fs->vhost_dev, fs->inflight);
     if (ret < 0) {
         error_report("Error set inflight: %d", -ret);
@@ -220,6 +232,102 @@ static void vuf_reset(VirtIODevice *vdev)
     vhost_dev_free_inflight(fs->inflight);
 }
 
+static int vhost_user_fs_persist_map(struct vhost_dev *dev,
+                                     struct VhostUserShm *shm, int fd)
+{
+    VHostUserFS *fs = container_of(dev, VHostUserFS, vhost_dev);
+    VhostUserFSPersist *persist = &fs->persist;
+
+    if (persist->map_fds[shm->id] != -1) {
+        close(persist->map_fds[shm->id]);
+    }
+
+    persist->need_restore = true;
+    memcpy(&persist->maps[shm->id], shm, sizeof(VhostUserShm));
+    persist->map_fds[shm->id] = dup(fd);
+
+    return 0;
+}
+
+static int vhost_user_fs_map_info(struct vhost_dev *dev, int id,
+                                  uint64_t *size, uint64_t *offset,
+                                  int *memfd)
+{
+    if (!dev) {
+        return -1;
+    }
+
+    if (id >= MAP_TYPE_NUM) {
+        return -1;
+    }
+
+    VHostUserFS *fs = container_of(dev, VHostUserFS, vhost_dev);
+    VhostUserFSPersist *persist = &fs->persist;
+    if (!persist->need_restore || (persist->map_fds[id] == -1)) {
+        return -1;
+    }
+
+    *size = persist->maps[id].size;
+    *offset = persist->maps[id].offset;
+    *memfd = persist->map_fds[id];
+
+    return 0;
+}
+
+static int vhost_user_fs_persist_fd(struct vhost_dev *dev,
+                                    struct VhostUserFd *fdinfo, int fd)
+{
+    VHostUserFS *fs = container_of(dev, VHostUserFS, vhost_dev);
+    VhostUserFSPersist *persist = &fs->persist;
+
+    persist->need_restore = true;
+
+    if (fdinfo->flag == VU_FD_FLAG_ADD) {
+        assert(persist->fd_ht != NULL);
+        int newfd = dup(fd);
+        g_hash_table_insert(persist->fd_ht, GINT_TO_POINTER(fdinfo->key),
+                                                    GINT_TO_POINTER(newfd));
+    } else if (fdinfo->flag == VU_FD_FLAG_DEL) {
+        gpointer fd_p = g_hash_table_lookup(persist->fd_ht,
+                                            GINT_TO_POINTER(fdinfo->key));
+        if (fd_p != NULL) {
+            int fd = GPOINTER_TO_INT(fd_p);
+            close(fd);
+            g_hash_table_remove(persist->fd_ht,
+                                        GINT_TO_POINTER(fdinfo->key));
+        }
+    }
+
+    return 0;
+}
+
+static int vhost_user_fs_fd_info(struct vhost_dev *dev, GHashTable **fd_ht_p)
+{
+    if (!dev) {
+        return -1;
+    }
+
+    VHostUserFS *fs = container_of(dev, VHostUserFS, vhost_dev);
+    VhostUserFSPersist *persist = &fs->persist;
+    if (!persist->need_restore) {
+        return -1;
+    }
+
+    *fd_ht_p = persist->fd_ht;
+    return 0;
+}
+
+
+const VhostDevShmOps fs_shm_ops = {
+        .vhost_dev_slave_shm = vhost_user_fs_persist_map,
+        .vhost_dev_shm_info = vhost_user_fs_map_info,
+};
+
+const VhostDevFdOps fs_fd_ops = {
+        .vhost_dev_slave_fd = vhost_user_fs_persist_fd,
+        .vhost_dev_fd_info = vhost_user_fs_fd_info,
+};
+
 static int vuf_connect(DeviceState *dev)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
@@ -242,6 +350,9 @@ static int vuf_connect(DeviceState *dev)
         return ret;
     }
 
+    vhost_dev_set_shm_ops(&fs->vhost_dev, &fs_shm_ops);
+    vhost_dev_set_fd_ops(&fs->vhost_dev, &fs_fd_ops);
+
     /* restore vhost state */
     if (vdev->started) {
         ret = vuf_start(vdev);
@@ -380,7 +491,11 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     /* init reconnection related variables */
     fs->inflight = g_new0(struct vhost_inflight, 1);
     fs->connected = false;
-
+    fs->persist.need_restore = false;
+    for (i = 0; i < MAP_TYPE_NUM; i++) {
+        fs->persist.map_fds[i] = -1;
+    }
+    fs->persist.fd_ht = g_hash_table_new(NULL, NULL);
     qemu_chr_fe_set_handlers(&fs->conf.chardev,  NULL, NULL, vuf_event,
                                  NULL, (void *)dev, NULL, true);
 
@@ -440,6 +555,7 @@ static void vuf_device_unrealize(DeviceState *dev)
     fs->vhost_dev.vqs = NULL;
     g_free(fs->inflight);
     fs->inflight = NULL;
+    g_hash_table_destroy(fs->persist.fd_ht);
 }
 
 static const VMStateDescription vuf_vmstate = {
diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-user-fs.h
index 9ef47568e7..c2b77ffc53 100644
--- a/include/hw/virtio/vhost-user-fs.h
+++ b/include/hw/virtio/vhost-user-fs.h
@@ -30,6 +30,18 @@ typedef struct {
     uint16_t queue_size;
 } VHostUserFSConf;
 
+#define MAP_TYPE_NUM 3
+typedef struct {
+    bool need_restore;
+
+    /* for persistent of lo_maps */
+    VhostUserShm maps[MAP_TYPE_NUM];
+    int map_fds[MAP_TYPE_NUM];
+
+    /* for persistent of fds */
+    GHashTable *fd_ht;
+} VhostUserFSPersist;
+
 struct VHostUserFS {
     /*< private >*/
     VirtIODevice parent;
@@ -41,7 +53,7 @@ struct VHostUserFS {
     VirtQueue *hiprio_vq;
     struct vhost_inflight *inflight;
     bool connected;
-
+    VhostUserFSPersist persist;
     /*< public >*/
 };
 
-- 
2.20.1

