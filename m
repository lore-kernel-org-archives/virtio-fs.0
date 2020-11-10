From: Haotian Li <lihaotian9@huawei.com>
References: <eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com>
Message-ID: <98f164b6-2c73-6d79-30c5-9cc12393822c@huawei.com>
Date: Tue, 10 Nov 2020 09:11:32 +0800
MIME-Version: 1.0
In-Reply-To: <eeb2fd1d-a53d-eae6-4727-7f1a6b20ac9e@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Subject: [Virtio-fs] [PATCH 2/2] virtiofsd: check whether lo_map_reserve
 returns NULL in main func
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: linfeilong@huawei.com

In main func, func lo_map_reserve is called without NULL check.
If reallocing new_elems fails in func lo_map_grow, the func
lo_map_reserve may return NULL. We should check whether
lo_map_reserve returns NULL before using it.

Signed-off-by: Haotian Li <lihaotian9@huawei.com>
Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
---
 tools/virtiofsd/passthrough_ll.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index ec1008bceb..147c5381e9 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3433,6 +3433,7 @@ int main(int argc, char *argv[])
         .proc_self_fd = -1,
     };
     struct lo_map_elem *root_elem;
+    struct lo_map_elem *reserve_elem;
     int ret = -1;

     /* Don't mask creation mode, kernel already did that */
@@ -3452,8 +3453,13 @@ int main(int argc, char *argv[])
      * [1] Root inode
      */
     lo_map_init(&lo.ino_map);
-    lo_map_reserve(&lo.ino_map, 0)->in_use = false;
+    reserve_elem = lo_map_reserve(&lo.ino_map, 0);
+    if (!reserve_elem)
+        goto err_out1;
+    reserve_elem->in_use = false;
     root_elem = lo_map_reserve(&lo.ino_map, lo.root.fuse_ino);
+    if (!root_elem)
+        goto err_out1;
     root_elem->inode = &lo.root;

     lo_map_init(&lo.dirp_map);
-- 

