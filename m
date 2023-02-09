Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  9 Feb 2023 10:25:17 -0500
Message-Id: <20230209152520.434183-4-stefanha@redhat.com>
In-Reply-To: <20230209152520.434183-1-stefanha@redhat.com>
References: <20230209152520.434183-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 3/6] block: fix detect-zeroes= with
 BDRV_REQ_REGISTERED_BUF
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Fiona Ebner <f.ebner@proxmox.com>, qemu-stable@nongnu.org, Eric Blake <eblake@redhat.com>

When a write request is converted into a write zeroes request by the
detect-zeroes= feature, it is no longer associated with an I/O buffer.
The BDRV_REQ_REGISTERED_BUF flag doesn't make sense without an I/O
buffer and must be cleared because bdrv_co_do_pwrite_zeroes() fails with
-EINVAL when it's set.

Fiona Ebner <f.ebner@proxmox.com> bisected and diagnosed this QEMU 7.2
regression where writes containing zeroes to a blockdev with
discard=unmap,detect-zeroes=unmap fail.

Buglink: https://gitlab.com/qemu-project/qemu/-/issues/1404
Fixes: e8b6535533be ("block: add BDRV_REQ_REGISTERED_BUF request flag")
Tested-by: Fiona Ebner <f.ebner@proxmox.com>
Cc: qemu-stable@nongnu.org
Reviewed-by: Eric Blake <eblake@redhat.com>
Reviewed-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20230207203719.242926-2-stefanha@redhat.com>
---
 block/io.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/io.c b/block/io.c
index 2dc0c13e41..d2be37b11e 100644
--- a/block/io.c
+++ b/block/io.c
@@ -1926,6 +1926,9 @@ static int coroutine_fn bdrv_aligned_pwritev(BdrvChild *child,
         if (bs->detect_zeroes == BLOCKDEV_DETECT_ZEROES_OPTIONS_UNMAP) {
             flags |= BDRV_REQ_MAY_UNMAP;
         }
+
+        /* Can't use optimization hint with bufferless zero write */
+        flags &= ~BDRV_REQ_REGISTERED_BUF;
     }
 
     if (ret < 0) {
-- 
2.39.1

