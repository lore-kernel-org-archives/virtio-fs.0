Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810B23998A4
	for <virtio-fs@lists.linux.dev>; Thu, 10 Sep 2026 20:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789071350; cv=none; b=rQAOsd5oBLMrolZvGrep8Tz+kZWFWNF78ww8lSx5IlfYwVLtwM3OB+ldJK7Wwr2A0SjoNOmqdMOGgwD9lahCTmeMWxgaVsxdPrQSejVJoBB/Ff12Ld/Zuv3tNsxvf3awFYWMHcVZETliPb0XqpixdFe42rE2RO8hJJyq6iZ00XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789071350; c=relaxed/simple;
	bh=j0SuyajHdBsyF6spN/2bZYaJ8GEUwRuTG3KSiEE7AbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=nJjD8x1VEQSz0ykm2IOLOG1VMKBYjdPL8UBU8Ciin3n2AFBipSNwTCah1zyakVy518FfqTlWsynvCYygDEZgKl9rweKwVoi/fa4Jo5FqGxsA2S1VL3OPyUqz7Lc+4dxX9e5VhCL0Ng3y67y5pBHFlzN3s9pYFGDfFITfd7UAQe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bc6HpCZc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bc6HpCZc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789071343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VqjojGjFi5nUGCc20Drm+8VeWMIFynXWAu4/zax0fR0=;
	b=Bc6HpCZciw7ehDtKXCIofv+yHKdUkxuf2f0o3sJ0a53isvzqRU9ejhim8W9NBZ1sFgjxBM
	sbltX1ndQp5Nfw2o4iSV3O+Cnm88xIE0oMk6VXB9PF+rELh7QMp/hLrFIolC1MuMoSmpcb
	xKGHFsOH8+puHXOaSZ8iv1oVOKdsL9Y=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-mp1HKQwNP5epJsWQ22NeYg-1; Thu, 10 Sep 2026 16:15:42 -0400
X-MC-Unique: mp1HKQwNP5epJsWQ22NeYg-1
X-Mimecast-MFC-AGG-ID: mp1HKQwNP5epJsWQ22NeYg_1789071341
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-485f6788029so103097f8f.1
        for <virtio-fs@lists.linux.dev>; Thu, 10 Sep 2026 13:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789071341; x=1789676141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VqjojGjFi5nUGCc20Drm+8VeWMIFynXWAu4/zax0fR0=;
        b=Y6xPZ8rk0g2COyP+7eoCfSHvnSy8UDCjmoTXybP6aGs0Jy2+oCmy+u3IZ7mhUBfFAN
         +ZkzrqtZeKtAvc88A3ubqz0vLNQo8iO04FOx3snOp0t+SUDiWXPTJZbGWZ0IQcv0Ls1W
         yuIksKmptAPlYsn4sciI+sOg8BhqdxkV9nCsZkujhD3oy8nDnDyGiWEddPCP/i7eQY+H
         7g36GYh3lqPmxWK/89DQ63Uu1iubh3z8mR1zC7Bt1zUd1tfiNdlCdJ5tin0Q7RpZ3Qwr
         TX6IYRBSAID8NsKiaZxQxO9Z8pubm2D5x4jQxKPHRQ4JtniRwV1sDD5xT5JVJACVouIc
         du9g==
X-Forwarded-Encrypted: i=1; AKwUvBxg+xWnUUGFjetd5msMQccKxCSDfaizdrG785ThQtKmhLHI6WkmQljDx0Uxu89JhqUbndtTnvi3nvI=@lists.linux.dev
X-Gm-Message-State: AFuF++lfyu1ZtixaqqGrXTLYhvrSwvl8Q6v+LMQo/SXz2sLjM7R7XlTH
	FpweUrD/S2cPZa5KOMFcDbTzI0e07ZqqQoZ3u8KhEDD+i4l+j0CcAhvJpxpuiM+YWDgkUWQE3Dt
	ACuRLpjn8h8MpRE5frgr/eZ5ii4+/BHYzDyZAoI+ty6XpFH4B0ynnNy0u9KwAYg==
X-Gm-Gg: AYBFou13biJZR4SJ82APplwlxTXXgM1Gw48fSy/2PsjuaxRf6WDEKOJGvjjAE7xvdpm
	psQvUf32DFNrttYmCLez3oDgX1W2jIN89hjun6KV/+5WWVKxHxjALBgkzTcxct0t8xgLyjIRmJF
	PqYZhjBwkHuTInwHUYCgdm5IbBYGTsTXsATlT6T77rUaffE49Xa9hCaPNci9oGpSfp6SQHSFSkf
	hyIl8HVYMb0c4p4IKEahIdHb+B/EJ+xvLF3K90ctqFAQbNjwCusr4F57J75NpUxAvyfdwiFn2j5
	pdG5j6Vn1Ke3emJbE+KYMegaZPd0zWxZOXqIr67g62ZurOfn07CPIuHPulKVjFdbyJ/EPPKFkGT
	QS++cIQUI3RGIkHfcc2djFfA=
X-Received: by 2002:adf:ec86:0:b0:47f:7129:6e2d with SMTP id ffacd0b85a97d-486eb325de3mr1103444f8f.17.1789071340980;
        Thu, 10 Sep 2026 13:15:40 -0700 (PDT)
X-Received: by 2002:adf:ec86:0:b0:47f:7129:6e2d with SMTP id ffacd0b85a97d-486eb325de3mr1103352f8f.17.1789071340413;
        Thu, 10 Sep 2026 13:15:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-79-236.inter.net.il. [80.230.79.236])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32e6f1sm821976f8f.6.2026.09.10.13.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 13:15:39 -0700 (PDT)
Date: Thu, 10 Sep 2026 16:15:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Albert Esteve <aesteve@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>, qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev
Subject: [PULL 84/90] vhost-user: add skip_drain param to
 do_vhost_virtqueue_stop
Message-ID: <e8e592c07cec60abce1c406913b8a65312b574e9.1789071043.git.mst@redhat.com>
References: <cover.1789071042.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <cover.1789071042.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aA5_vT-uDGPDdYA-Di9NwA4MkgQdk8rS6crOWyVCIWo_1789071341
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>

Currently do_vhost_virtqueue_stop always sends GET_VRING_BASE to the
back-end, which requires the back-end to drain all in-flight I/O before
stopping the vring.

Add a skip_drain parameter to do_vhost_virtqueue_stop and propagate it
up through vhost_virtqueue_stop, vhost_dev_stop and their callers.
The parameter will be used in a follow-up commit to send a new protocol
message that instructs the back-end to suspend in-flight I/O immediately
instead of draining it.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260803072853.2920007-2-dtalexundeer@yandex-team.ru>
---
 include/hw/virtio/vhost.h      |  7 +++++--
 backends/cryptodev-vhost.c     |  2 +-
 backends/vhost-user.c          |  2 +-
 hw/block/vhost-user-blk.c      |  2 +-
 hw/display/vhost-user-media.c  |  2 +-
 hw/net/vhost_net.c             |  9 +++++----
 hw/scsi/vhost-scsi-common.c    |  2 +-
 hw/virtio/vdpa-dev.c           |  2 +-
 hw/virtio/vhost-user-base.c    |  2 +-
 hw/virtio/vhost-user-fs.c      |  2 +-
 hw/virtio/vhost-user-scmi.c    |  2 +-
 hw/virtio/vhost-vsock-common.c |  2 +-
 hw/virtio/vhost.c              | 28 +++++++++++++++++++---------
 13 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index cd012b99a2..cd6e200538 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -277,6 +277,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  * @hdev: common vhost_dev structure
  * @vdev: the VirtIODevice structure
  * @vrings: true to have vrings disabled in this call
+ * @skip_drain: true to notice back-end to skip draining all in-flight requests
  *
  * Stop the vhost device. After the device is stopped the notifiers
  * can be disabled (@vhost_dev_disable_notifiers) and the device can
@@ -284,7 +285,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
  *
  * Return: 0 on success, != 0 on error when stopping dev.
  */
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings);
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool skip_drain);
 
 /**
  * vhost_dev_force_stop() - force stop the vhost device
@@ -445,7 +447,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, uint64_t iova, int write);
 int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vdev,
                           struct vhost_virtqueue *vq, unsigned idx);
 int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vdev,
-                         struct vhost_virtqueue *vq, unsigned idx);
+                         struct vhost_virtqueue *vq, unsigned idx,
+                         bool skip_drain);
 
 void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
 void vhost_dev_free_inflight(struct vhost_inflight *inflight);
diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
index c6069f4e5b..f1ca6bcd4e 100644
--- a/backends/cryptodev-vhost.c
+++ b/backends/cryptodev-vhost.c
@@ -109,7 +109,7 @@ static void
 cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
                                  VirtIODevice *dev)
 {
-    vhost_dev_stop(&crypto->dev, dev, false);
+    vhost_dev_stop(&crypto->dev, dev, false, false);
     vhost_dev_disable_notifiers(&crypto->dev, dev);
 }
 
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 46dadb7480..de6b1ba267 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
         return 0;
     }
 
-    ret = vhost_dev_stop(&b->dev, b->vdev, true);
+    ret = vhost_dev_stop(&b->dev, b->vdev, true, false);
 
     if (k->set_guest_notifiers &&
         (err = k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false)) < 0) {
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 2e5b3ae1b1..c3e3c37f8c 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -238,7 +238,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
                  qemu_force_shutdown_requested();
 
     ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
-                       vhost_dev_stop(&s->dev, vdev, true);
+                       vhost_dev_stop(&s->dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/display/vhost-user-media.c b/hw/display/vhost-user-media.c
index eaf99dc6a2..851af8ddc2 100644
--- a/hw/display/vhost-user-media.c
+++ b/hw/display/vhost-user-media.c
@@ -110,7 +110,7 @@ static void vu_media_stop(VirtIODevice *vdev)
         return;
     }
 
-    vhost_dev_stop(&media->vhost_dev, vdev, true);
+    vhost_dev_stop(&media->vhost_dev, vdev, true, false);
 
     ret = k->set_guest_notifiers(qbus->parent, media->vhost_dev.nvqs, false);
     if (ret < 0) {
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 323d117735..6e05c995f1 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -384,7 +384,7 @@ fail:
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, false);
 fail_start:
     return r;
 }
@@ -403,7 +403,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
     if (net->nc->info->poll) {
         net->nc->info->poll(net->nc, true);
     }
-    vhost_dev_stop(&net->dev, dev, false);
+    vhost_dev_stop(&net->dev, dev, false, false);
     if (net->nc->info->stop) {
         net->nc->info->stop(net->nc);
     }
@@ -636,7 +636,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, NetClientState *nc,
     vhost_virtqueue_stop(&net->dev,
                          vdev,
                          net->dev.vqs + idx,
-                         net->dev.vq_index + idx);
+                         net->dev.vq_index + idx,
+                         false);
 }
 
 int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
@@ -686,7 +687,7 @@ err_start:
         assert(ret >= 0);
     }
 
-    vhost_dev_stop(&net->dev, vdev, false);
+    vhost_dev_stop(&net->dev, vdev, false, false);
 
     return r;
 }
diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
index e19800a0bc..e546a6dc75 100644
--- a/hw/scsi/vhost-scsi-common.c
+++ b/hw/scsi/vhost-scsi-common.c
@@ -108,7 +108,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
     VirtioBusClass *k = VIRTIO_BUS_GET_CLASS(qbus);
     int ret = 0;
 
-    ret = vhost_dev_stop(&vsc->dev, vdev, true);
+    ret = vhost_dev_stop(&vsc->dev, vdev, true, false);
 
     if (k->set_guest_notifiers) {
         int r = k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, false);
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index 6dc684ab09..7e5cc040e9 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -301,7 +301,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev)
         return;
     }
 
-    vhost_dev_stop(&s->dev, vdev, false);
+    vhost_dev_stop(&s->dev, vdev, false, false);
 
     ret = k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
     if (ret < 0) {
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 478ec68f09..1a377016e7 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -78,7 +78,7 @@ static int vub_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vub->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 209993918a..0d8842817a 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&fs->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 02dc088ea9..c4692bd6aa 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(vhost_dev, vdev, true);
+    ret = vhost_dev_stop(vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index b79f4c9ce6..4ef037627b 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
         return 0;
     }
 
-    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true);
+    ret = vhost_dev_stop(&vvc->vhost_dev, vdev, true, false);
 
     err = k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, false);
     if (err < 0) {
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 6c2612a1dd..17b36366dc 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -23,6 +23,7 @@
 #include "qemu/log.h"
 #include "standard-headers/linux/vhost_types.h"
 #include "hw/virtio/virtio-bus.h"
+#include "hw/virtio/vhost-user.h"
 #include "hw/mem/memory-device.h"
 #include "migration/blocker.h"
 #include "migration/qemu-file-types.h"
@@ -1509,8 +1510,13 @@ fail:
 static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
                                    struct VirtIODevice *vdev,
                                    struct vhost_virtqueue *vq,
-                                   unsigned idx, bool force)
+                                   unsigned idx, bool force,
+                                   bool skip_drain)
 {
+    if (skip_drain) {
+        assert(vhost_user_has_protocol_feature(dev,
+               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
+    }
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
         .index = vhost_vq_index,
@@ -1560,9 +1566,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
 int vhost_virtqueue_stop(struct vhost_dev *dev,
                          struct VirtIODevice *vdev,
                          struct vhost_virtqueue *vq,
-                         unsigned idx)
+                         unsigned idx,
+                         bool skip_drain)
 {
-    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false);
+    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false, skip_drain);
 }
 
 static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
@@ -2350,7 +2357,8 @@ fail_vq:
         vhost_virtqueue_stop(hdev,
                              vdev,
                              hdev->vqs + i,
-                             hdev->vq_index + i);
+                             hdev->vq_index + i,
+                             false);
     }
 
 fail_mem:
@@ -2365,7 +2373,7 @@ fail_features:
 
 /* Host notifiers must be enabled at this point. */
 static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
-                             bool vrings, bool force)
+                             bool vrings, bool force, bool skip_drain)
 {
     int i;
     int rc = 0;
@@ -2392,7 +2400,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                                       vdev,
                                       hdev->vqs + i,
                                       hdev->vq_index + i,
-                                      force);
+                                      force,
+                                      skip_drain);
     }
     if (hdev->vhost_ops->vhost_reset_status) {
         hdev->vhost_ops->vhost_reset_status(hdev);
@@ -2414,15 +2423,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
     return rc;
 }
 
-int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings)
+int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrings,
+                   bool skip_drain)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, false);
+    return do_vhost_dev_stop(hdev, vdev, vrings, false, skip_drain);
 }
 
 int vhost_dev_force_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
                          bool vrings)
 {
-    return do_vhost_dev_stop(hdev, vdev, vrings, true);
+    return do_vhost_dev_stop(hdev, vdev, vrings, true, false);
 }
 
 int vhost_net_set_backend(struct vhost_dev *hdev,
-- 
MST

