From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Sat,  3 Aug 2019 13:28:28 +0800
Message-Id: <1564810108-34852-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] Virtiofsd: fix segfault when quit before dev
	init
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

From: Eric Ren <renzhen@linux.alibaba.com>

The daemon may bail out early on errors(e.g. in fuse_session_mount), where
it ends up a segfault error.

Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
---
 contrib/virtiofsd/fuse_virtio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/contrib/virtiofsd/fuse_virtio.c b/contrib/virtiofsd/fuse_virtio.c
index aa94b66..6292e87 100644
--- a/contrib/virtiofsd/fuse_virtio.c
+++ b/contrib/virtiofsd/fuse_virtio.c
@@ -891,6 +891,10 @@ int virtio_session_mount(struct fuse_session *se)
 void virtio_session_close(struct fuse_session *se)
 {
         close(se->vu_socketfd);
+
+        if (!se->virtio_dev)
+                return;
+
         free(se->virtio_dev->qi);
         free(se->virtio_dev);
         se->virtio_dev = NULL;
-- 
1.8.3.1

