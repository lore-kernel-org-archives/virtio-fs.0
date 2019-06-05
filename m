From: Liu Bo <bo.liu@linux.alibaba.com>
Date: Wed,  5 Jun 2019 08:42:32 +0800
Message-Id: <1559695356-75503-2-git-send-email-bo.liu@linux.alibaba.com>
In-Reply-To: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
References: <1559695356-75503-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH 1/5] virtiofsd: cleanup allocated resource in se
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This cleans up unfreed resources in se on quiting, including
se->virtio_dev, se->vu_socket_path, se->vu_socketfd.

Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index 0fc2880..de700ad 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -2557,6 +2557,12 @@ void fuse_session_destroy(struct fuse_session *se)
 	free(se->cuse_data);
 	if (se->fd != -1)
 		close(se->fd);
+
+        free(se->virtio_dev);
+        se->virtio_dev = NULL;
+        free(se->vu_socket_path);
+        close(se->vu_socketfd);
+
 	free(se);
 }
 
-- 
1.8.3.1

