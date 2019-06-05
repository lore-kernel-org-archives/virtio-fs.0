From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:34 +0800
Message-Id: <1559695356-75503-4-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 3/5] virtiofsd: fix memory leak on lo.inodes
	hashmap
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

lo.inodes hashmap was not unref/destroy 'd on quiting, which was caught by valgrind.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index f348b16..e7e19dc 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -2324,6 +2324,8 @@ err_out2:
 err_out1:
 	fuse_opt_free_args(&args);
 
+        if (lo.inodes)
+                g_hash_table_destroy(lo.inodes);
 	lo_map_destroy(&lo.fd_map);
 	lo_map_destroy(&lo.dirp_map);
 	lo_map_destroy(&lo.ino_map);
-- 
1.8.3.1

