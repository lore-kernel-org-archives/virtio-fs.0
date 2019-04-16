From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed, 17 Apr 2019 03:08:57 +0800
Message-Id: <20190416190858.16833-4-bo.liu@linux.alibaba.com>
In-Reply-To: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
References: <20190416190858.16833-1-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/4] virtiofsd: use file-backend memory region
	for virtiofsd's cache area
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

When running xfstests test case generic/413, we found such issue:
    1, create a file in one virtiofsd mount point with dax enabled
    2, mmap this file, get virtual addr: A
    3, write(fd, A, len), here fd comes from another file in another
       virtiofsd mount point without dax enabled, also note here write(2)
       is direct io.
    4, this direct io will hang forever, because the virtiofsd has crashed.
Here is the stack:
[  247.166276] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  247.167171] t_mmap_dio      D    0  2335   2102 0x00000000
[  247.168006] Call Trace:
[  247.169067]  ? __schedule+0x3d0/0x830
[  247.170219]  schedule+0x32/0x80
[  247.171328]  schedule_timeout+0x1e2/0x350
[  247.172416]  ? fuse_direct_io+0x2e5/0x6b0 [fuse]
[  247.173516]  wait_for_completion+0x123/0x190
[  247.174593]  ? wake_up_q+0x70/0x70
[  247.175640]  fuse_direct_IO+0x265/0x310 [fuse]
[  247.176724]  generic_file_read_iter+0xaa/0xd20
[  247.177824]  fuse_file_read_iter+0x81/0x130 [fuse]
[  247.178938]  ? fuse_simple_request+0x104/0x1b0 [fuse]
[  247.180041]  ? fuse_fsync_common+0xad/0x240 [fuse]
[  247.181136]  __vfs_read+0x108/0x190
[  247.181930]  vfs_read+0x91/0x130
[  247.182671]  ksys_read+0x52/0xc0
[  247.183454]  do_syscall_64+0x55/0x170
[  247.184200]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

And virtiofsd crashed because vu_gpa_to_va() can not handle guest physical
address correctly. For a memory mapped area in dax mode, indeed the page
for this area points virtiofsd's cache area, or rather virtio pci device's
cache bar. In qemu, currently this cache bar is implemented with an anonymous
memory and will not pass this cache bar's address info to vhost-user backend,
so vu_gpa_to_va() will fail.

To fix this issue, we create this vhost cache area with a file backend
memory area.

Reviewed-by: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 hw/virtio/vhost-user-fs.c | 59 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 10 deletions(-)

diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index a5110a9..fc2ed38 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -300,6 +300,35 @@ static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
     return vhost_virtqueue_pending(&fs->vhost_dev, idx);
 }
 
+static int vuf_get_tmpfile(size_t size)
+{
+    const char *tmpdir = g_get_tmp_dir();
+    gchar *fname;
+    int fd;
+
+    fname = g_strdup_printf("%s/virtio-fs-cache-XXXXXX", tmpdir);
+    fd = mkstemp(fname);
+    if (fd < 0) {
+        fprintf(stderr, "%s: mkstemp(%s) failed\n", __func__, fname);
+        g_free(fname);
+        return -1;
+    }
+
+    /*
+     * Note: this temp file would be deleted until file is closed or
+     * process exits.
+     */
+    unlink(fname);
+    if (ftruncate(fd, size) == -1) {
+        fprintf(stderr, "%s: ftruncate(%s) failed\n", __func__, fname);
+        close(fd);
+        fd = -1;
+    }
+
+    g_free(fname);
+    return fd;
+}
+
 static void vuf_device_realize(DeviceState *dev, Error **errp)
 {
     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
@@ -349,16 +378,26 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
                          "no smaller than the page size");
         return;
     }
-    /* We need a region with some host memory, 'ram' is the easiest */
-    memory_region_init_ram_nomigrate(&fs->cache, OBJECT(vdev),
-                       "virtio-fs-cache",
-                       fs->conf.cache_size, NULL);
-    /*
-     * But we don't actually want anyone reading/writing the raw
-     * area with no cache data.
-     */
-    mprotect(memory_region_get_ram_ptr(&fs->cache), fs->conf.cache_size,
-             PROT_NONE);
+
+    if (fs->conf.cache_size) {
+            int fd;
+
+            fd = vuf_get_tmpfile(fs->conf.cache_size);
+            if (fd < 0) {
+                    error_setg(errp, "failed to initialize virtio-fs-cache");
+                    return;
+            }
+            memory_region_init_ram_from_fd(&fs->cache, OBJECT(vdev),
+                                           "virtio-fs-cache",
+                                           fs->conf.cache_size, true, fd, NULL);
+
+            /*
+             * But we don't actually want anyone reading/writing the raw
+             * area with no cache data.
+             */
+            mprotect(memory_region_get_ram_ptr(&fs->cache),
+                     fs->conf.cache_size, PROT_NONE);
+    }
 
     if (!vhost_user_init(&fs->vhost_user, &fs->conf.chardev, errp)) {
         return;
-- 
1.8.3.1

