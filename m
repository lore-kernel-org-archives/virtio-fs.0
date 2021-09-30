From: Vivek Goyal <vgoyal@redhat.com>
Date: Thu, 30 Sep 2021 11:30:25 -0400
Message-Id: <20210930153037.1194279-2-vgoyal@redhat.com>
In-Reply-To: <20210930153037.1194279-1-vgoyal@redhat.com>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 01/13] virtio_fs.h: Add notification queue
	feature bit
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

This change will ultimately come from kernel as kernel header file update
when kernel patches get merged.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/standard-headers/linux/virtio_fs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index a32fe8a64c..b7f015186e 100644
--- a/include/standard-headers/linux/virtio_fs.h
+++ b/include/standard-headers/linux/virtio_fs.h
@@ -8,6 +8,9 @@
 #include "standard-headers/linux/virtio_config.h"
 #include "standard-headers/linux/virtio_types.h"
 
+/* Feature bits. Notification queue supported */
+#define VIRTIO_FS_F_NOTIFICATION	0
+
 struct virtio_fs_config {
 	/* Filesystem name (UTF-8, not NUL-terminated, padded with NULs) */
 	uint8_t tag[36];
-- 
2.31.1

