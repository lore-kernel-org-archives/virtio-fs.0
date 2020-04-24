From: Max Reitz <mreitz@redhat.com>
Date: Fri, 24 Apr 2020 15:35:16 +0200
Message-Id: <20200424133516.73077-1-mreitz@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: Show submounts
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

Currently, setup_mounts() bind-mounts the shared directory without
MS_REC.  This makes all submounts disappear.

Pass MS_REC so that the guest can see submounts again.

Fixes: 3ca8a2b1c83eb185c232a4e87abbb65495263756
Signed-off-by: Max Reitz <mreitz@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 4c35c95b25..9d7f863e66 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2643,7 +2643,7 @@ static void setup_mounts(const char *source)
     int oldroot;
     int newroot;
 
-    if (mount(source, source, NULL, MS_BIND, NULL) < 0) {
+    if (mount(source, source, NULL, MS_BIND | MS_REC, NULL) < 0) {
         fuse_log(FUSE_LOG_ERR, "mount(%s, %s, MS_BIND): %m\n", source, source);
         exit(1);
     }
-- 
2.25.3

