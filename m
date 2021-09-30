From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:27 -0400
Message-Id: <20210930153037.1194279-4-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 03/13] virtiofsd: Remove unused virtio_fs_config
	definition
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com, stefanha@redhat.com
Cc: vgoyal@redhat.com, miklos@szeredi.hu

"struct virtio_fs_config" definition seems to be unused in fuse_virtio.c.
Remove it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 tools/virtiofsd/fuse_virtio.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
index 8f4fd165b9..da7b6a76bf 100644
--- a/tools/virtiofsd/fuse_virtio.c
+++ b/tools/virtiofsd/fuse_virtio.c
@@ -82,12 +82,6 @@ struct fv_VuDev {
     struct fv_QueueInfo **qi;
 };
 
-/* From spec */
-struct virtio_fs_config {
-    char tag[36];
-    uint32_t num_queues;
-};
-
 /* Callback from libvhost-user */
 static uint64_t fv_get_features(VuDev *dev)
 {
-- 
2.31.1

