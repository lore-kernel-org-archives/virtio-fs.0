From: Connor Kuehl <ckuehl@redhat.com>
Date: Thu, 18 Mar 2021 08:52:21 -0500
Message-Id: <20210318135223.1342795-2-ckuehl@redhat.com>
In-Reply-To: <20210318135223.1342795-1-ckuehl@redhat.com>
References: <20210318135223.1342795-1-ckuehl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH 1/3] virtio_ring: always warn when descriptor
	chain exceeds queue size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: miklos@szeredi.hu, jasowang@redhat.com, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com

>From section 2.6.5.3.1 (Driver Requirements: Indirect Descriptors)
of the virtio spec:

  "A driver MUST NOT create a descriptor chain longer than the Queue
  Size of the device."

This text suggests that the warning should trigger even if
indirect descriptors are in use.

Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Connor Kuehl <ckuehl@redhat.com>
---
 drivers/virtio/virtio_ring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..1bc290f9ba13 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -444,11 +444,12 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 
 	head = vq->free_head;
 
+	WARN_ON_ONCE(total_sg > vq->split.vring.num);
+
 	if (virtqueue_use_indirect(_vq, total_sg))
 		desc = alloc_indirect_split(_vq, total_sg, gfp);
 	else {
 		desc = NULL;
-		WARN_ON_ONCE(total_sg > vq->split.vring.num && !vq->indirect);
 	}
 
 	if (desc) {
@@ -1118,6 +1119,8 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 
 	BUG_ON(total_sg == 0);
 
+	WARN_ON_ONCE(total_sg > vq->packed.vring.num);
+
 	if (virtqueue_use_indirect(_vq, total_sg))
 		return virtqueue_add_indirect_packed(vq, sgs, total_sg,
 				out_sgs, in_sgs, data, gfp);
@@ -1125,8 +1128,6 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 	head = vq->packed.next_avail_idx;
 	avail_used_flags = vq->packed.avail_used_flags;
 
-	WARN_ON_ONCE(total_sg > vq->packed.vring.num && !vq->indirect);
-
 	desc = vq->packed.vring.desc;
 	i = head;
 	descs_used = total_sg;
-- 
2.30.2

