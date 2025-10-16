Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C85732861C
	for <virtio-fs@lists.linux.dev>; Thu, 16 Oct 2025 11:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760614992; cv=none; b=GgytPoO+RmVboocs5h4+7jzaJCqOOFoJ61K6kj0Y6ibwH8ekl9+n2giBOiw9apdQsD1Bynb/OeIVXe0Wfp5XrIRJJkIXvynfDvBntN/V8jtIMEFP17UFk3eI99GTmJSlMfkF3GLhF9HPFLexrhNBPhMg6cLIWddvO2AeRdjLI20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760614992; c=relaxed/simple;
	bh=d+lJ2rEjDda3LBZ04GaZXgcuyrQvSdaT5Ecb9oUZ1Ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eEFS0avZAQCdBHrHNKikQUqMJr2vIpkGp8Mnh0suyTzGr4XSWezfIO7dOaAbsdrumhu5W44oBa3C3Oq6C0tfE3U3n3G999aWNoXyNzNDSZz21dj3+Yr9ywTfrEbUROwyuQ8onSNZ0lWPoQnPjRBEF625bOlx/FRAPhWyvRSk9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=Z+mybsH6; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="Z+mybsH6"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 5F8F4C01C4;
	Thu, 16 Oct 2025 14:41:27 +0300 (MSK)
Received: from vsementsov-lin.. (unknown [2a02:6bf:8080:a8c::1:19])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id LfP2M73FEmI0-YwdwMwTh;
	Thu, 16 Oct 2025 14:41:26 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1760614886;
	bh=1XLVUveyIaEDAIm+7CqDo71QUDU3u/IS07Ut6dYodbI=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=Z+mybsH6zZVmhLLxSCPAlHvzL9hbLIu9a7IErhUe8ADqmNJqrOudDLiV/pojAGX9l
	 hhgVwHqTsRX00/475BHRumbxPXjaGwNx0i5GMnIc5OD17BFvh8qi59WT3bsHup1/zV
	 X9aWv3gJfd3FJkqqv58tdfUD3jmisC5UR0a6L7/M=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
To: raphael@enfabrica.net,
	pbonzini@redhat.com,
	farosas@suse.de
Cc: mst@redhat.com,
	sgarzare@redhat.com,
	marcandre.lureau@redhat.com,
	kwolf@redhat.com,
	hreitz@redhat.com,
	berrange@redhat.com,
	eblake@redhat.com,
	armbru@redhat.com,
	qemu-devel@nongnu.org,
	qemu-block@nongnu.org,
	steven.sistare@oracle.com,
	vsementsov@yandex-team.ru,
	yc-core@yandex-team.ru,
	d-tatianin@yandex-team.ru,
	jasowang@redhat.com,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	Fam Zheng <fam@euphon.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	mzamazal@redhat.com (reviewer:vhost-user-scmi),
	virtio-fs@lists.linux.dev (open list:virtiofs)
Subject: [PATCH v2 04/25] vhost: add connect parameter to vhost_dev_init()
Date: Thu, 16 Oct 2025 14:40:41 +0300
Message-ID: <20251016114104.1384675-5-vsementsov@yandex-team.ru>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251016114104.1384675-1-vsementsov@yandex-team.ru>
References: <20251016114104.1384675-1-vsementsov@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We are going to split vhost_dev_init() so that the first part will do
early initialization of QEMU structures, but don't communicate with
backend, and the second part will do backend communication. We need
this for future support for backend-transfer migration support for
vhost-user-blk (backend will not be available in the early
initialization point).

With this commit we introduce boolean parameter for vhost_dev_init(),
so callers may chose, do they want "init + connect" (which is current
behavior, so all callers pass true), or caller may want "only init",
and call vhost_dev_connect() later. vhost_dev_connect(), as well
as support for connect=false will be added in further commits.

Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
---
 backends/cryptodev-vhost.c        |  2 +-
 backends/vhost-user.c             |  2 +-
 hw/block/vhost-user-blk.c         |  2 +-
 hw/net/vhost_net.c                |  2 +-
 hw/scsi/vhost-scsi.c              |  2 +-
 hw/scsi/vhost-user-scsi.c         |  2 +-
 hw/virtio/vdpa-dev.c              |  3 ++-
 hw/virtio/vhost-user-base.c       |  2 +-
 hw/virtio/vhost-user-fs.c         |  2 +-
 hw/virtio/vhost-user-scmi.c       |  2 +-
 hw/virtio/vhost-user-vsock.c      |  2 +-
 hw/virtio/vhost-vsock.c           |  2 +-
 hw/virtio/vhost.c                 | 11 ++++++++++-
 include/hw/virtio/vhost-backend.h |  2 ++
 include/hw/virtio/vhost.h         |  3 ++-
 15 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
index c6069f4e5b..b4dafb4062 100644
--- a/backends/cryptodev-vhost.c
+++ b/backends/cryptodev-vhost.c
@@ -66,7 +66,7 @@ cryptodev_vhost_init(
     crypto->dev.vq_index = crypto->cc->queue_index * crypto->dev.nvqs;
 
     r = vhost_dev_init(&crypto->dev, options->opaque, options->backend_type, 0,
-                       &local_err);
+                       true, &local_err);
     if (r < 0) {
         error_report_err(local_err);
         goto fail;
diff --git a/backends/vhost-user.c b/backends/vhost-user.c
index 42845329e7..e65ba7b648 100644
--- a/backends/vhost-user.c
+++ b/backends/vhost-user.c
@@ -37,7 +37,7 @@ vhost_user_backend_dev_init(VhostUserBackend *b, VirtIODevice *vdev,
     b->dev.vqs = g_new0(struct vhost_virtqueue, nvqs);
 
     ret = vhost_dev_init(&b->dev, &b->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
-                         errp);
+                         true, errp);
     if (ret < 0) {
         return -1;
     }
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index a5daed4346..a92426f18c 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -365,7 +365,7 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
 
     s->vhost_user.supports_config = true;
     ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
-                         errp);
+                         true, errp);
     if (ret < 0) {
         return ret;
     }
diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
index 323d117735..c4526974fb 100644
--- a/hw/net/vhost_net.c
+++ b/hw/net/vhost_net.c
@@ -274,7 +274,7 @@ struct vhost_net *vhost_net_init(VhostNetOptions *options)
 
     r = vhost_dev_init(&net->dev, options->opaque,
                        options->backend_type, options->busyloop_timeout,
-                       &local_err);
+                       true, &local_err);
     if (r < 0) {
         error_report_err(local_err);
         goto fail;
diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
index d694a25fe2..d187c705d8 100644
--- a/hw/scsi/vhost-scsi.c
+++ b/hw/scsi/vhost-scsi.c
@@ -278,7 +278,7 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
     vsc->dev.vq_index = 0;
 
     ret = vhost_dev_init(&vsc->dev, (void *)(uintptr_t)vhostfd,
-                         VHOST_BACKEND_TYPE_KERNEL, 0, errp);
+                         VHOST_BACKEND_TYPE_KERNEL, 0, true, errp);
     if (ret < 0) {
         /*
          * vhost_dev_init calls vhost_dev_cleanup on error, which closes
diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
index 0c80a271d8..e121f2e259 100644
--- a/hw/scsi/vhost-user-scsi.c
+++ b/hw/scsi/vhost-user-scsi.c
@@ -161,7 +161,7 @@ static int vhost_user_scsi_connect(DeviceState *dev, Error **errp)
     vsc->dev.vq_index = 0;
 
     ret = vhost_dev_init(&vsc->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
-                         errp);
+                         true, errp);
     if (ret < 0) {
         return ret;
     }
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index e1a2ff433d..b6b4ee7d38 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -116,7 +116,8 @@ static void vhost_vdpa_device_realize(DeviceState *dev, Error **errp)
     v->vdpa.shared->device_fd = v->vhostfd;
     v->vdpa.shared->iova_range = iova_range;
 
-    ret = vhost_dev_init(&v->dev, &v->vdpa, VHOST_BACKEND_TYPE_VDPA, 0, NULL);
+    ret = vhost_dev_init(&v->dev, &v->vdpa, VHOST_BACKEND_TYPE_VDPA, 0, true,
+                         NULL);
     if (ret < 0) {
         error_setg(errp, "vhost-vdpa-device: vhost initialization failed: %s",
                    strerror(-ret));
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index cf311c3bfc..0768231a88 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -334,7 +334,7 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
 
     /* connect to backend */
     ret = vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
+                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
 
     if (ret < 0) {
         do_vhost_user_cleanup(vdev, vub);
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index e77c69eb12..2a8eead90b 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -256,7 +256,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
     fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
+                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
     if (ret < 0) {
         goto err_virtio;
     }
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index f9264c4374..40e567c18a 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -253,7 +253,7 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
     scmi->vhost_dev.vqs = g_new0(struct vhost_virtqueue, scmi->vhost_dev.nvqs);
 
     ret = vhost_dev_init(&scmi->vhost_dev, &scmi->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
+                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
     if (ret < 0) {
         error_setg_errno(errp, -ret,
                          "vhost-user-scmi: vhost_dev_init() failed");
diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
index 993c287348..b630af0fe7 100644
--- a/hw/virtio/vhost-user-vsock.c
+++ b/hw/virtio/vhost-user-vsock.c
@@ -115,7 +115,7 @@ static void vuv_device_realize(DeviceState *dev, Error **errp)
     vhost_dev_set_config_notifier(&vvc->vhost_dev, &vsock_ops);
 
     ret = vhost_dev_init(&vvc->vhost_dev, &vsock->vhost_user,
-                         VHOST_BACKEND_TYPE_USER, 0, errp);
+                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
     if (ret < 0) {
         goto err_virtio;
     }
diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
index 107d88babe..3a4b2d924d 100644
--- a/hw/virtio/vhost-vsock.c
+++ b/hw/virtio/vhost-vsock.c
@@ -166,7 +166,7 @@ static void vhost_vsock_device_realize(DeviceState *dev, Error **errp)
     vhost_vsock_common_realize(vdev);
 
     ret = vhost_dev_init(&vvc->vhost_dev, (void *)(uintptr_t)vhostfd,
-                         VHOST_BACKEND_TYPE_KERNEL, 0, errp);
+                         VHOST_BACKEND_TYPE_KERNEL, 0, true, errp);
     if (ret < 0) {
         /*
          * vhostfd is closed by vhost_dev_cleanup, which is called
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 1998663461..f733e98b4a 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1617,7 +1617,7 @@ static bool check_memslots(struct vhost_dev *hdev, Error **errp)
 
 int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type, uint32_t busyloop_timeout,
-                   Error **errp)
+                   bool connect, Error **errp)
 {
     int i, r, n_initialized_vqs = 0;
 
@@ -1634,6 +1634,15 @@ int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
     r = vhost_set_backend_type(hdev, backend_type);
     assert(r >= 0);
 
+    /*
+     * Postponed connect only supported for devices with
+     * .vhost_backend_connect handler
+     */
+    assert(connect || hdev->vhost_ops->vhost_backend_connect);
+
+    /* TDDO: support connect=false */
+    assert(connect);
+
     r = hdev->vhost_ops->vhost_backend_init(hdev, opaque, errp);
     if (r < 0) {
         goto fail;
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index ff94fa1734..d3f055f95e 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -53,6 +53,7 @@ struct vhost_virtqueue;
 
 typedef int (*vhost_backend_init)(struct vhost_dev *dev, void *opaque,
                                   Error **errp);
+typedef int (*vhost_backend_connect)(struct vhost_dev *dev, Error **errp);
 typedef int (*vhost_backend_cleanup)(struct vhost_dev *dev);
 typedef int (*vhost_backend_memslots_limit)(struct vhost_dev *dev);
 
@@ -167,6 +168,7 @@ typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev, Error **errp);
 typedef struct VhostOps {
     VhostBackendType backend_type;
     vhost_backend_init vhost_backend_init;
+    vhost_backend_connect vhost_backend_connect;
     vhost_backend_cleanup vhost_backend_cleanup;
     vhost_backend_memslots_limit vhost_backend_memslots_limit;
     vhost_backend_no_private_memslots_op vhost_backend_no_private_memslots;
diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
index f1a7e7b971..74ed24232e 100644
--- a/include/hw/virtio/vhost.h
+++ b/include/hw/virtio/vhost.h
@@ -155,7 +155,8 @@ struct vhost_net {
  */
 int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
                    VhostBackendType backend_type,
-                   uint32_t busyloop_timeout, Error **errp);
+                   uint32_t busyloop_timeout,
+                   bool connect, Error **errp);
 
 /**
  * vhost_dev_cleanup() - tear down and cleanup vhost interface
-- 
2.48.1

