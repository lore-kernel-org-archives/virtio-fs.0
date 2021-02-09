From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:08 +0000
Message-Id: <20210209190224.62827-9-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 08/24] DAX: virtio-fs: Fill in slave commands
	for mapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Fill in definitions for map, unmap and sync commands.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
with fix by misono.tomohiro@fujitsu.com
---
 hw/virtio/vhost-user-fs.c | 115 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 111 insertions(+), 4 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 78401d2ff1..5f2fca4d82 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -37,15 +37,122 @@
 uint64_t vhost_user_fs_slave_map(struct vhost_dev *dev, VhostUserFSSlaveMsg *sm,
                                  int fd)
 {
-    /* TODO */
-    return (uint64_t)-1;
+    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
+    if (!fs) {
+        /* Shouldn't happen - but seen on error path */
+        error_report("Bad fs ptr");
+        return (uint64_t)-1;
+    }
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
+    for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES; i++) {
+        if (sm->len[i] == 0) {
+            continue;
+        }
+
+        if ((sm->c_offset[i] + sm->len[i]) < sm->len[i] ||
+            (sm->c_offset[i] + sm->len[i]) > cache_size) {
+            error_report("Bad offset/len for map [%d] %" PRIx64 "+%" PRIx64,
+                         i, sm->c_offset[i], sm->len[i]);
+            res = -1;
+            break;
+        }
+
+        if (mmap(cache_host + sm->c_offset[i], sm->len[i],
+                 ((sm->flags[i] & VHOST_USER_FS_FLAG_MAP_R) ? PROT_READ : 0) |
+                 ((sm->flags[i] & VHOST_USER_FS_FLAG_MAP_W) ? PROT_WRITE : 0),
+                 MAP_SHARED | MAP_FIXED,
+                 fd, sm->fd_offset[i]) != (cache_host + sm->c_offset[i])) {
+            res = -errno;
+            error_report("map failed err %d [%d] %" PRIx64 "+%" PRIx64 " from %"
+                         PRIx64, errno, i, sm->c_offset[i], sm->len[i],
+                         sm->fd_offset[i]);
+            break;
+        }
+    }
+
+    if (res) {
+        /* Something went wrong, unmap them all */
+        vhost_user_fs_slave_unmap(dev, sm);
+    }
+    return (uint64_t)res;
 }
 
 uint64_t vhost_user_fs_slave_unmap(struct vhost_dev *dev,
                                    VhostUserFSSlaveMsg *sm)
 {
-    /* TODO */
-    return (uint64_t)-1;
+    VHostUserFS *fs = VHOST_USER_FS(dev->vdev);
+    if (!fs) {
+        /* Shouldn't happen - but seen on error path */
+        error_report("Bad fs ptr");
+        return (uint64_t)-1;
+    }
+    size_t cache_size = fs->conf.cache_size;
+    if (!cache_size) {
+        /*
+         * Since dax cache is disabled, there should be no unmap request.
+         * Howerver we still receives whole range unmap request during umount
+         * for cleanup. Ignore it.
+         */
+        if (sm->len[0] == ~(uint64_t)0) {
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
+    for (i = 0; i < VHOST_USER_FS_SLAVE_ENTRIES; i++) {
+        void *ptr;
+        if (sm->len[i] == 0) {
+            continue;
+        }
+
+        if (sm->len[i] == ~(uint64_t)0) {
+            /* Special case meaning the whole arena */
+            sm->len[i] = cache_size;
+        }
+
+        if ((sm->c_offset[i] + sm->len[i]) < sm->len[i] ||
+            (sm->c_offset[i] + sm->len[i]) > cache_size) {
+            error_report("Bad offset/len for unmap [%d] %" PRIx64 "+%" PRIx64,
+                         i, sm->c_offset[i], sm->len[i]);
+            res = -1;
+            continue;
+        }
+
+        ptr = mmap(cache_host + sm->c_offset[i], sm->len[i], DAX_WINDOW_PROT,
+                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+        if (ptr != (cache_host + sm->c_offset[i])) {
+            res = -errno;
+            error_report("mmap failed (%s) [%d] %" PRIx64 "+%" PRIx64 " from %"
+                         PRIx64 " res: %p", strerror(errno), i, sm->c_offset[i],
+                         sm->len[i], sm->fd_offset[i], ptr);
+        }
+    }
+
+    return (uint64_t)res;
 }
 
 static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
-- 
2.29.2

