DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=bytedance-com.20150623.gappssmtp.com; s=20150623;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=ayx4tR4YhfjCbsPSwjeEGbJ32niuENe82UzurSi722s=;
	b=dTE3JfkIA/YAvsWCM2uemDP8h5VXEiPci1Bm9dzqoMuQ4nHromi8sIee4bHDwp4TYU
	/+x1y/xbWq8UPstYNl6yf6sifPiDQwg59KkO1fxlzTtteqRukTCxtJp0RWgshb2el909
	b40zal9jXPS1t8IyVW7keLGxMMJhTqNkyvnfBdhD++UCRNcIshCHoXT0G6IzUsCk6dTn
	b7AQjO9QHcZrYJc/acZvLxQthQqTdeLkGCsAAK92CiwXkOfd1Cko9YmfcfWo2SrIhqzi
	/DStNSBN2q0mZFwhb72CWdkUvbr5u0ueYlNFON/Zh/TvWTrJEPuBdHmWCnFGGZWomQMu
	4RXQ==
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Date: Wed, 16 Dec 2020 00:21:19 +0800
Message-Id: <20201215162119.27360-10-zhangjiachen.jaycee@bytedance.com>
In-Reply-To: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
References: <20201215162119.27360-1-zhangjiachen.jaycee@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [RFC PATCH 9/9] virtiofsd: (work around) Comment qsort
	in inflight I/O tracking
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr . David Alan Gilbert" <dgilbert@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Xie Yongji <xieyongji@bytedance.com>
Cc: virtio-fs@redhat.com, Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>, qemu-devel@nongnu.org

This is a work around. The qsort function will malloc memory instead of use
stack memory when the resubmit_num is larger than 64 (total size larger than
1024 Bytes). This will cause seccomp kill virtiofsd, so we comment qsort.
This work around will not affect the correctness of inflight I/O tracking.

Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 contrib/libvhost-user/libvhost-user.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/contrib/libvhost-user/libvhost-user.c b/contrib/libvhost-user/libvhost-user.c
index 8c97013e59..c226d5d915 100644
--- a/contrib/libvhost-user/libvhost-user.c
+++ b/contrib/libvhost-user/libvhost-user.c
@@ -1167,20 +1167,6 @@ vu_check_queue_msg_file(VuDev *dev, VhostUserMsg *vmsg)
     return true;
 }
 
-static int
-inflight_desc_compare(const void *a, const void *b)
-{
-    VuVirtqInflightDesc *desc0 = (VuVirtqInflightDesc *)a,
-                        *desc1 = (VuVirtqInflightDesc *)b;
-
-    if (desc1->counter > desc0->counter &&
-        (desc1->counter - desc0->counter) < VIRTQUEUE_MAX_SIZE * 2) {
-        return 1;
-    }
-
-    return -1;
-}
-
 static int
 vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
 {
@@ -1236,10 +1222,6 @@ vu_check_queue_inflights(VuDev *dev, VuVirtq *vq)
             }
         }
 
-        if (vq->resubmit_num > 1) {
-            qsort(vq->resubmit_list, vq->resubmit_num,
-                  sizeof(VuVirtqInflightDesc), inflight_desc_compare);
-        }
         vq->counter = vq->resubmit_list[0].counter + 1;
     }
 
-- 
2.20.1

