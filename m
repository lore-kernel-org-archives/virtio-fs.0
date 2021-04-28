From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:44 +0100
Message-Id: <20210428110100.27757-11-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 10/26] DAX: virtio-fs: Fill in slave commands
	for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Fill in definitions for map, unmap and sync commands.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
with fix by misono.tomohiro@fujitsu.com
---
 hw/virtio/vhost-user-fs.c | 117 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 113 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 169a146e72..963f694435 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -92,23 +92,132 @@ static bool check_slave_message_entries(const VhostUserFSSlaveMsg *sm,
 uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, int message_size,
                                  VhostUserFSSlaveMsg *sm, int fd)
 {
+    VHostUserFS *fs = (VHostUserFS *)object_dynamic_cast(OBJECT(dev->vdev),
+                          TYPE_VHOST_USER_FS);
+    if (!fs) {
+        error_report("%s: Bad fs ptr", __func__);
+        return (uint64_t)-1;
+    }
     if (!check_slave_message_entries(sm, message_size)) {
         return (uint64_t)-1;
     }
 
-    /* TODO */
-    return (uint64_t)-1;
+    size_t cache_size = fs->conf.cache_size;
+    if (!cache_size) {
+        error_report("map called when DAX cache not present");
+        return (uint64_t)-1;
+    }
+    void *cache_host = memory_region_get_ram_ptr(&fs->cache);
+
+    unsigned int i;
+    int res = 0;
+
+    if (fd < 0) {
+        error_report("Bad fd for map");
+        return (uint64_t)-1;
+    }
+
+    for (i = 0; i < sm->count; i++) {
+        VhostUserFSSlaveMsgEntry *e = &sm->entries[i];
+        if (e->len == 0) {
+            continue;
+        }
+
+        if ((e->c_offset + e->len) < e->len ||
+            (e->c_offset + e->len) > cache_size) {
+            error_report("Bad offset/len for map [%d] %" PRIx64 "+%" PRIx64,
+                         i, e->c_offset, e->len);
+            res = -1;
+            break;
+        }
+
+        if (mmap(cache_host + e->c_offset, e->len,
+                 ((e->flags & VHOST_USER_FS_FLAG_MAP_R) ? PROT_READ : 0) |
+                 ((e->flags & VHOST_USER_FS_FLAG_MAP_W) ? PROT_WRITE : 0),
+                 MAP_SHARED | MAP_FIXED,
+                 fd, e->fd_offset) != (cache_host + e->c_offset)) {
+            res = -errno;
+            error_report("map failed err %d [%d] %" PRIx64 "+%" PRIx64 " from %"
+                         PRIx64, errno, i, e->c_offset, e->len,
+                         e->fd_offset);
+            break;
+        }
+    }
+
+    if (res) {
+        /* Something went wrong, unmap them all */
+        vhost_user_fs_slave_unmap(dev, message_size, sm);
+    }
+    return (uint64_t)res;
 }
 
 uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev, int message_size,
                                    VhostUserFSSlaveMsg *sm)
 {
+    VHostUserFS *fs = (VHostUserFS *)object_dynamic_cast(OBJECT(dev->vdev),
+                          TYPE_VHOST_USER_FS);
+    if (!fs) {
+        error_report("%s: Bad fs ptr", __func__);
+        return (uint64_t)-1;
+    }
     if (!check_slave_message_entries(sm, message_size)) {
         return (uint64_t)-1;
     }
 
-    /* TODO */
-    return (uint64_t)-1;
+    size_t cache_size = fs->conf.cache_size;
+    if (!cache_size) {
+        /*
+         * Since dax cache is disabled, there should be no unmap request.
+         * Howerver we still receives whole range unmap request during umount
+         * for cleanup. Ignore it.
+         */
+        if (sm->entries[0].len == ~(uint64_t)0) {
+            return 0;
+        }
+
+        error_report("unmap called when DAX cache not present");
+        return (uint64_t)-1;
+    }
+    void *cache_host = memory_region_get_ram_ptr(&fs->cache);
+
+    unsigned int i;
+    int res = 0;
+
+    /*
+     * Note even if one unmap fails we try the rest, since the effect
+     * is to clean up as much as possible.
+     */
+    for (i = 0; i < sm->count; i++) {
+        VhostUserFSSlaveMsgEntry *e = &sm->entries[i];
+        void *ptr;
+        if (e->len == 0) {
+            continue;
+        }
+
+        if (e->len == ~(uint64_t)0) {
+            /* Special case meaning the whole arena */
+            e->len = cache_size;
+        }
+
+        if ((e->c_offset + e->len) < e->len ||
+            (e->c_offset + e->len) > cache_size) {
+            error_report("Bad offset/len for unmap [%d] %" PRIx64 "+%" PRIx64,
+                         i, e->c_offset, e->len);
+            res = -1;
+            continue;
+        }
+
+        ptr = mmap(cache_host + e->c_offset, e->len, DAX_WINDOW_PROT,
+                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+        if (ptr != (cache_host + e->c_offset)) {
+            res = -errno;
+            error_report("mmap failed (%s) [%d] %" PRIx64 "+%" PRIx64 " from %"
+                         PRIx64 " res: %p", strerror(errno), i, e->c_offset,
+                         e->len, e->fd_offset, ptr);
+        }
+    }
+
+    return (uint64_t)res;
 }
 
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
-- 
2.31.1

