Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BB42D9484
	for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 20:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445145; cv=none; b=VAbhvMjed5IYG02JURmXRJ9fWxHLt4igF7JDqkKWTNoX3+pDkfTYhIjy88/g8s0rw7bklGPxQbKEwA8UUw73odTxNbbu9qMml6UUI3NMGjCESf/jJsdl8ApkNDaToagdihTMu/yq56PCg+FSJihDm0ZlFgrK4/9HlWXg29mLG9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445145; c=relaxed/simple;
	bh=01t0t9mNhCIa3IAZ4iN6+fkZAD3jzEnsXNgmI0TG2yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=B1O9Lzh3xa6bB1JwT1ey6S6Q93A0siLFRshgHDah1T3QPa63S3z/XQp7oi2FsTCUh+0ZR7wYIAm8lhJ2goQCY6aoC7BEWPS7ZaoyeYnBHqbtceiLZEcVzx4DjWrfDDMkLyZe+GVyx7kXfkX1ZRDdwWWVSUEkSvou0GaAsR5Dypc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QvZeUcwA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QvZeUcwA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785445142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7gYp6EhF/T5yhBObhf4x7TEVsSLXgFskf2GVWMx3fyM=;
	b=QvZeUcwAPkhEPP7he/b/GIvOhOYTrW8GK7AJFMA7uqHe+k1m03lhmyfD4TjwELxBlfecYp
	X16yE9MNffMT4gbFQMrEgsRt9mXjqiCFNQfEfUprMorl8W+cXa5piQO2yWdxmjiwxz6Yce
	p+lCC09Y5A/rKrGRvNcXjiNEVtgrBuM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-347-6IKxBnnaOFGhNyLKVpE1YQ-1; Thu,
 30 Jul 2026 16:59:00 -0400
X-MC-Unique: 6IKxBnnaOFGhNyLKVpE1YQ-1
X-Mimecast-MFC-AGG-ID: 6IKxBnnaOFGhNyLKVpE1YQ_1785445137
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3ABA1956043;
	Thu, 30 Jul 2026 20:58:56 +0000 (UTC)
Received: from localhost (unknown [10.2.16.217])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A50A18004AD;
	Thu, 30 Jul 2026 20:58:56 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	virtio-fs@lists.linux.dev,
	Hanna Reitz <hreitz@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Christian Schoenebeck <qemu_oss@crudebyte.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Dorjoy Chowdhury <dorjoychy111@gmail.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Laurent Vivier <lvivier@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	qemu-block@nongnu.org,
	Greg Kurz <groug@kaod.org>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Amit Shah <amit@kernel.org>
Subject: [PATCH v2 2/2] virtio: use Error for queue size validation in virtio_add_queue()
Date: Thu, 30 Jul 2026 16:58:46 -0400
Message-ID: <20260730205846.19479-3-stefanha@redhat.com>
In-Reply-To: <20260730205846.19479-1-stefanha@redhat.com>
References: <20260730205846.19479-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 5jCMnTYA2c6hkF7ewj_usu5wj6Kf6GsBv5L_oXCnAhk_1785445137
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Coverity is unhappy with the code path where the x-override-queue-size
property value is passed to g_new0() since it is a signed int rather
than an unsigned int:

      *** CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
      /builds/qemu-project/qemu/hw/virtio/virtio.c: 2595             in virtio_add_queue()
      2589         }
      2590
      2591         vdev->vq[i].vring.num = queue_size;
      2592         vdev->vq[i].vring.num_default = queue_size;
      2593         vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
      2594         vdev->vq[i].handle_output = handle_output;
      >>>     CID 1664271:         Error handling issues  (NEGATIVE_RETURNS)
      >>>     "__n" is passed to a parameter that cannot be negative.
      2595         vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);

Introduce an Error **errp argument to virtio_add_queue() and set it when
the queue_size argument or the x-override-queue-size property value are
invalid.

At the moment none of the callers propagate the Error object. Instead
they are all modified to pass &error_abort so that the error message is
printed and the program terminates (it also terminated before). Further
work, especially in new device emulation code, could actually propagate
the Error object but is left for the future.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/hw/virtio/virtio.h     |  2 +-
 hw/9pfs/virtio-9p-device.c     |  2 +-
 hw/audio/virtio-snd.c          |  8 ++++----
 hw/block/vhost-user-blk.c      |  3 ++-
 hw/block/virtio-blk.c          |  3 ++-
 hw/char/virtio-serial-bus.c    | 14 +++++++------
 hw/display/virtio-gpu-base.c   |  8 ++++----
 hw/input/virtio-input.c        |  6 ++++--
 hw/net/virtio-net.c            | 15 +++++++++-----
 hw/scsi/virtio-scsi.c          |  9 ++++++---
 hw/virtio/vdpa-dev.c           |  3 ++-
 hw/virtio/vhost-user-base.c    |  3 ++-
 hw/virtio/vhost-user-fs.c      |  8 ++++++--
 hw/virtio/vhost-user-scmi.c    |  6 ++++--
 hw/virtio/vhost-vsock-common.c |  9 ++++++---
 hw/virtio/virtio-balloon.c     | 15 +++++++++-----
 hw/virtio/virtio-crypto.c      |  6 ++++--
 hw/virtio/virtio-iommu.c       |  6 ++++--
 hw/virtio/virtio-mem.c         |  3 ++-
 hw/virtio/virtio-nsm.c         |  2 +-
 hw/virtio/virtio-pmem.c        |  2 +-
 hw/virtio/virtio-rng.c         |  2 +-
 hw/virtio/virtio-rtc.c         |  3 ++-
 hw/virtio/virtio.c             | 37 ++++++++++++++++++++++++++++++----
 24 files changed, 120 insertions(+), 55 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index ff7f837fb92..a5d4264cd42 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -303,7 +303,7 @@ void virtio_device_set_child_bus_name(VirtIODevice *vdev, char *bus_name);
 typedef void (*VirtIOHandleOutput)(VirtIODevice *, VirtQueue *);
 
 VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
-                            VirtIOHandleOutput handle_output);
+                            VirtIOHandleOutput handle_output, Error **errp);
 
 void virtio_del_queue(VirtIODevice *vdev, int n);
 
diff --git a/hw/9pfs/virtio-9p-device.c b/hw/9pfs/virtio-9p-device.c
index 2774fc2290a..6b96ca77621 100644
--- a/hw/9pfs/virtio-9p-device.c
+++ b/hw/9pfs/virtio-9p-device.c
@@ -236,7 +236,7 @@ static void virtio_9p_device_realize(DeviceState *dev, Error **errp)
 
     v->config_size = sizeof(struct virtio_9p_config) + strlen(s->fsconf.tag);
     virtio_init(vdev, VIRTIO_ID_9P, v->config_size);
-    v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
+    v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output, &error_abort);
 }
 
 static void virtio_9p_device_unrealize(DeviceState *dev)
diff --git a/hw/audio/virtio-snd.c b/hw/audio/virtio-snd.c
index 694bcebb60f..bfd9abecd13 100644
--- a/hw/audio/virtio-snd.c
+++ b/hw/audio/virtio-snd.c
@@ -1089,13 +1089,13 @@ static void virtio_snd_realize(DeviceState *dev, Error **errp)
     default_params.format = VIRTIO_SND_PCM_FMT_S16;
     default_params.rate = VIRTIO_SND_PCM_RATE_48000;
     vsnd->queues[VIRTIO_SND_VQ_CONTROL] =
-        virtio_add_queue(vdev, 64, virtio_snd_handle_ctrl);
+        virtio_add_queue(vdev, 64, virtio_snd_handle_ctrl, &error_abort);
     vsnd->queues[VIRTIO_SND_VQ_EVENT] =
-        virtio_add_queue(vdev, 64, virtio_snd_handle_event);
+        virtio_add_queue(vdev, 64, virtio_snd_handle_event, &error_abort);
     vsnd->queues[VIRTIO_SND_VQ_TX] =
-        virtio_add_queue(vdev, 64, virtio_snd_handle_tx_xfer);
+        virtio_add_queue(vdev, 64, virtio_snd_handle_tx_xfer, &error_abort);
     vsnd->queues[VIRTIO_SND_VQ_RX] =
-        virtio_add_queue(vdev, 64, virtio_snd_handle_rx_xfer);
+        virtio_add_queue(vdev, 64, virtio_snd_handle_rx_xfer, &error_abort);
     qemu_mutex_init(&vsnd->cmdq_mutex);
     QTAILQ_INIT(&vsnd->cmdq);
     QSIMPLEQ_INIT(&vsnd->invalid);
diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
index 2e5b3ae1b14..77fc53ee681 100644
--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -516,7 +516,8 @@ static void vhost_user_blk_device_realize(DeviceState *dev, Error **errp)
     s->virtqs = g_new(VirtQueue *, s->num_queues);
     for (i = 0; i < s->num_queues; i++) {
         s->virtqs[i] = virtio_add_queue(vdev, s->queue_size,
-                                        vhost_user_blk_handle_output);
+                                        vhost_user_blk_handle_output,
+                                        &error_abort);
     }
 
     s->inflight = g_new0(struct vhost_inflight, 1);
diff --git a/hw/block/virtio-blk.c b/hw/block/virtio-blk.c
index 6b92066aff4..5b978e357ee 100644
--- a/hw/block/virtio-blk.c
+++ b/hw/block/virtio-blk.c
@@ -1815,7 +1815,8 @@ static void virtio_blk_device_realize(DeviceState *dev, Error **errp)
     s->sector_mask = (s->conf.conf.logical_block_size / BDRV_SECTOR_SIZE) - 1;
 
     for (i = 0; i < conf->num_queues; i++) {
-        virtio_add_queue(vdev, conf->queue_size, virtio_blk_handle_output);
+        virtio_add_queue(vdev, conf->queue_size, virtio_blk_handle_output,
+                         &error_abort);
     }
     qemu_coroutine_inc_pool_size(conf->num_queues * conf->queue_size / 2);
 
diff --git a/hw/char/virtio-serial-bus.c b/hw/char/virtio-serial-bus.c
index c1973f0248f..7e1d74c988c 100644
--- a/hw/char/virtio-serial-bus.c
+++ b/hw/char/virtio-serial-bus.c
@@ -1033,9 +1033,9 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
     vser->ovqs = g_new(VirtQueue *, vser->serial.max_virtserial_ports);
 
     /* Add a queue for host to guest transfers for port 0 (backward compat) */
-    vser->ivqs[0] = virtio_add_queue(vdev, 128, handle_input);
+    vser->ivqs[0] = virtio_add_queue(vdev, 128, handle_input, &error_abort);
     /* Add a queue for guest to host transfers for port 0 (backward compat) */
-    vser->ovqs[0] = virtio_add_queue(vdev, 128, handle_output);
+    vser->ovqs[0] = virtio_add_queue(vdev, 128, handle_output, &error_abort);
 
     /* TODO: host to guest notifications can get dropped
      * if the queue fills up. Implement queueing in host,
@@ -1044,15 +1044,17 @@ static void virtio_serial_device_realize(DeviceState *dev, Error **errp)
      * this will save 4Kbyte of guest memory per entry. */
 
     /* control queue: host to guest */
-    vser->c_ivq = virtio_add_queue(vdev, 32, control_in);
+    vser->c_ivq = virtio_add_queue(vdev, 32, control_in, &error_abort);
     /* control queue: guest to host */
-    vser->c_ovq = virtio_add_queue(vdev, 32, control_out);
+    vser->c_ovq = virtio_add_queue(vdev, 32, control_out, &error_abort);
 
     for (i = 1; i < vser->bus.max_nr_ports; i++) {
         /* Add a per-port queue for host to guest transfers */
-        vser->ivqs[i] = virtio_add_queue(vdev, 128, handle_input);
+        vser->ivqs[i] = virtio_add_queue(vdev, 128, handle_input,
+                                         &error_abort);
         /* Add a per-per queue for guest to host transfers */
-        vser->ovqs[i] = virtio_add_queue(vdev, 128, handle_output);
+        vser->ovqs[i] = virtio_add_queue(vdev, 128, handle_output,
+                                         &error_abort);
     }
 
     vser->ports_map = g_malloc0((DIV_ROUND_UP(vser->serial.max_virtserial_ports, 32))
diff --git a/hw/display/virtio-gpu-base.c b/hw/display/virtio-gpu-base.c
index 946e56b42f6..f808d1f6743 100644
--- a/hw/display/virtio-gpu-base.c
+++ b/hw/display/virtio-gpu-base.c
@@ -238,11 +238,11 @@ virtio_gpu_base_device_realize(DeviceState *qdev,
 
     if (virtio_gpu_virgl_enabled(g->conf)) {
         /* use larger control queue in 3d mode */
-        virtio_add_queue(vdev, 256, ctrl_cb);
-        virtio_add_queue(vdev, 16, cursor_cb);
+        virtio_add_queue(vdev, 256, ctrl_cb, &error_abort);
+        virtio_add_queue(vdev, 16, cursor_cb, &error_abort);
     } else {
-        virtio_add_queue(vdev, 64, ctrl_cb);
-        virtio_add_queue(vdev, 16, cursor_cb);
+        virtio_add_queue(vdev, 64, ctrl_cb, &error_abort);
+        virtio_add_queue(vdev, 16, cursor_cb, &error_abort);
     }
 
     g->hw_ops = &virtio_gpu_ops;
diff --git a/hw/input/virtio-input.c b/hw/input/virtio-input.c
index 6494cfbbe82..192b1ea8c61 100644
--- a/hw/input/virtio-input.c
+++ b/hw/input/virtio-input.c
@@ -259,8 +259,10 @@ static void virtio_input_device_realize(DeviceState *dev, Error **errp)
     assert(vinput->cfg_size <= sizeof(virtio_input_config));
 
     virtio_init(vdev, VIRTIO_ID_INPUT, vinput->cfg_size);
-    vinput->evt = virtio_add_queue(vdev, 64, virtio_input_handle_evt);
-    vinput->sts = virtio_add_queue(vdev, 64, virtio_input_handle_sts);
+    vinput->evt = virtio_add_queue(vdev, 64, virtio_input_handle_evt,
+                                   &error_abort);
+    vinput->sts = virtio_add_queue(vdev, 64, virtio_input_handle_sts,
+                                   &error_abort);
 }
 
 static void virtio_input_finalize(Object *obj)
diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
index 814b99a43d2..ab7611274a7 100644
--- a/hw/net/virtio-net.c
+++ b/hw/net/virtio-net.c
@@ -2996,19 +2996,22 @@ static void virtio_net_add_queue(VirtIONet *n, int index)
     VirtIODevice *vdev = VIRTIO_DEVICE(n);
 
     n->vqs[index].rx_vq = virtio_add_queue(vdev, n->net_conf.rx_queue_size,
-                                           virtio_net_handle_rx);
+                                           virtio_net_handle_rx,
+                                           &error_abort);
 
     if (n->net_conf.tx && !strcmp(n->net_conf.tx, "timer")) {
         n->vqs[index].tx_vq =
             virtio_add_queue(vdev, n->net_conf.tx_queue_size,
-                             virtio_net_handle_tx_timer);
+                             virtio_net_handle_tx_timer,
+                             &error_abort);
         n->vqs[index].tx_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL,
                                               virtio_net_tx_timer,
                                               &n->vqs[index]);
     } else {
         n->vqs[index].tx_vq =
             virtio_add_queue(vdev, n->net_conf.tx_queue_size,
-                             virtio_net_handle_tx_bh);
+                             virtio_net_handle_tx_bh,
+                             &error_abort);
         n->vqs[index].tx_bh = virtio_bh_new_guarded(DEVICE(vdev),
                                                     virtio_net_tx_bh,
                                                     &n->vqs[index]);
@@ -3069,7 +3072,8 @@ static void virtio_net_change_num_queues(VirtIONet *n, int new_num_queues)
     }
 
     /* add ctrl_vq last */
-    n->ctrl_vq = virtio_add_queue(vdev, 64, virtio_net_handle_ctrl);
+    n->ctrl_vq = virtio_add_queue(vdev, 64, virtio_net_handle_ctrl,
+                                  &error_abort);
 }
 
 static void virtio_net_set_multiqueue(VirtIONet *n, int multiqueue)
@@ -4001,7 +4005,8 @@ static void virtio_net_device_realize(DeviceState *dev, Error **errp)
 
     virtio_net_add_queue(n, 0);
 
-    n->ctrl_vq = virtio_add_queue(vdev, 64, virtio_net_handle_ctrl);
+    n->ctrl_vq = virtio_add_queue(vdev, 64, virtio_net_handle_ctrl,
+                                  &error_abort);
     qemu_macaddr_default_if_unset(&n->nic_conf.macaddr);
     memcpy(&n->mac[0], &n->nic_conf.macaddr, sizeof(n->mac));
     n->status = VIRTIO_NET_S_LINK_UP;
diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index bf64d1231a8..4045414cd2f 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -1317,10 +1317,13 @@ void virtio_scsi_common_realize(DeviceState *dev,
     s->sense_size = VIRTIO_SCSI_SENSE_DEFAULT_SIZE;
     s->cdb_size = VIRTIO_SCSI_CDB_DEFAULT_SIZE;
 
-    s->ctrl_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, ctrl);
-    s->event_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, evt);
+    s->ctrl_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, ctrl,
+                                  &error_abort);
+    s->event_vq = virtio_add_queue(vdev, s->conf.virtqueue_size, evt,
+                                   &error_abort);
     for (i = 0; i < s->conf.num_queues; i++) {
-        s->cmd_vqs[i] = virtio_add_queue(vdev, s->conf.virtqueue_size, cmd);
+        s->cmd_vqs[i] = virtio_add_queue(vdev, s->conf.virtqueue_size, cmd,
+                                         &error_abort);
     }
 }
 
diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
index 6dc684ab096..1f96985056b 100644
--- a/hw/virtio/vdpa-dev.c
+++ b/hw/virtio/vdpa-dev.c
@@ -151,7 +151,8 @@ static void vhost_vdpa_device_realize(DeviceState *dev, Error **errp)
     v->virtqs = g_new0(VirtQueue *, v->dev.nvqs);
     for (i = 0; i < v->dev.nvqs; i++) {
         v->virtqs[i] = virtio_add_queue(vdev, v->queue_size,
-                                        vhost_vdpa_device_dummy_handle_output);
+                                        vhost_vdpa_device_dummy_handle_output,
+                                        &error_abort);
     }
 
     return;
diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
index 478ec68f093..fe14718fba3 100644
--- a/hw/virtio/vhost-user-base.c
+++ b/hw/virtio/vhost-user-base.c
@@ -334,7 +334,8 @@ static void vub_device_realize(DeviceState *dev, Error **errp)
     for (i = 0; i < vub->num_vqs; i++) {
         g_ptr_array_add(vub->vqs,
                         virtio_add_queue(vdev, vub->vq_size,
-                                         vub_handle_output));
+                                         vub_handle_output,
+                                         &error_abort));
     }
 
     vub->vhost_dev.nvqs = vub->num_vqs;
diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
index 209993918a3..57100ba2c4c 100644
--- a/hw/virtio/vhost-user-fs.c
+++ b/hw/virtio/vhost-user-fs.c
@@ -245,12 +245,16 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
     virtio_init(vdev, VIRTIO_ID_FS, sizeof(struct virtio_fs_config));
 
     /* Hiprio queue */
-    fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
+    fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size,
+                                     vuf_handle_output,
+                                     &error_abort);
 
     /* Request queues */
     fs->req_vqs = g_new(VirtQueue *, fs->conf.num_request_queues);
     for (i = 0; i < fs->conf.num_request_queues; i++) {
-        fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
+        fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size,
+                                          vuf_handle_output,
+                                          &error_abort);
     }
 
     /* 1 high prio queue, plus the number configured */
diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
index 02dc088ea98..1da916585aa 100644
--- a/hw/virtio/vhost-user-scmi.c
+++ b/hw/virtio/vhost-user-scmi.c
@@ -250,8 +250,10 @@ static void vu_scmi_device_realize(DeviceState *dev, Error **errp)
 
     virtio_init(vdev, VIRTIO_ID_SCMI, 0);
 
-    scmi->cmd_vq = virtio_add_queue(vdev, 256, vu_scmi_handle_output);
-    scmi->event_vq = virtio_add_queue(vdev, 256, vu_scmi_handle_output);
+    scmi->cmd_vq = virtio_add_queue(vdev, 256, vu_scmi_handle_output,
+                                    &error_abort);
+    scmi->event_vq = virtio_add_queue(vdev, 256, vu_scmi_handle_output,
+                                      &error_abort);
     scmi->vhost_dev.nvqs = 2;
     scmi->vhost_dev.vqs = g_new0(struct vhost_virtqueue, scmi->vhost_dev.nvqs);
     vhost_vqs = scmi->vhost_dev.vqs;
diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
index b79f4c9ce66..584891ff005 100644
--- a/hw/virtio/vhost-vsock-common.c
+++ b/hw/virtio/vhost-vsock-common.c
@@ -254,13 +254,16 @@ void vhost_vsock_common_realize(VirtIODevice *vdev)
 
     /* Receive and transmit queues belong to vhost */
     vvc->recv_vq = virtio_add_queue(vdev, VHOST_VSOCK_QUEUE_SIZE,
-                                      vhost_vsock_common_handle_output);
+                                    vhost_vsock_common_handle_output,
+                                    &error_abort);
     vvc->trans_vq = virtio_add_queue(vdev, VHOST_VSOCK_QUEUE_SIZE,
-                                       vhost_vsock_common_handle_output);
+                                     vhost_vsock_common_handle_output,
+                                     &error_abort);
 
     /* The event queue belongs to QEMU */
     vvc->event_vq = virtio_add_queue(vdev, VHOST_VSOCK_QUEUE_SIZE,
-                                       vhost_vsock_common_handle_output);
+                                     vhost_vsock_common_handle_output,
+                                     &error_abort);
 
     vvc->vhost_dev.nvqs = ARRAY_SIZE(vvc->vhost_vqs);
     vvc->vhost_dev.vqs = vvc->vhost_vqs;
diff --git a/hw/virtio/virtio-balloon.c b/hw/virtio/virtio-balloon.c
index 4c5f486ba23..3aca375d5c6 100644
--- a/hw/virtio/virtio-balloon.c
+++ b/hw/virtio/virtio-balloon.c
@@ -887,13 +887,17 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
         return;
     }
 
-    s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
-    s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output);
-    s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats);
+    s->ivq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output,
+                              &error_abort);
+    s->dvq = virtio_add_queue(vdev, 128, virtio_balloon_handle_output,
+                              &error_abort);
+    s->svq = virtio_add_queue(vdev, 128, virtio_balloon_receive_stats,
+                              &error_abort);
 
     if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_FREE_PAGE_HINT)) {
         s->free_page_vq = virtio_add_queue(vdev, VIRTQUEUE_MAX_SIZE,
-                                           virtio_balloon_handle_free_page_vq);
+                                           virtio_balloon_handle_free_page_vq,
+                                           &error_abort);
         precopy_add_notifier(&s->free_page_hint_notify);
 
         object_ref(OBJECT(s->iothread));
@@ -904,7 +908,8 @@ static void virtio_balloon_device_realize(DeviceState *dev, Error **errp)
 
     if (virtio_has_feature(s->host_features, VIRTIO_BALLOON_F_REPORTING)) {
         s->reporting_vq = virtio_add_queue(vdev, 32,
-                                           virtio_balloon_handle_report);
+                                           virtio_balloon_handle_report,
+                                           &error_abort);
     }
 
     reset_stats(s);
diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
index 79e2acb56cc..b65ec611163 100644
--- a/hw/virtio/virtio-crypto.c
+++ b/hw/virtio/virtio-crypto.c
@@ -1091,14 +1091,16 @@ static void virtio_crypto_device_realize(DeviceState *dev, Error **errp)
     vcrypto->vqs = g_new0(VirtIOCryptoQueue, vcrypto->max_queues);
     for (i = 0; i < vcrypto->max_queues; i++) {
         vcrypto->vqs[i].dataq =
-                 virtio_add_queue(vdev, 1024, virtio_crypto_handle_dataq_bh);
+                 virtio_add_queue(vdev, 1024, virtio_crypto_handle_dataq_bh,
+                                  &error_abort);
         vcrypto->vqs[i].dataq_bh =
                  virtio_bh_new_guarded(dev, virtio_crypto_dataq_bh,
                                        &vcrypto->vqs[i]);
         vcrypto->vqs[i].vcrypto = vcrypto;
     }
 
-    vcrypto->ctrl_vq = virtio_add_queue(vdev, 1024, virtio_crypto_handle_ctrl);
+    vcrypto->ctrl_vq = virtio_add_queue(vdev, 1024, virtio_crypto_handle_ctrl,
+                                        &error_abort);
     if (!cryptodev_backend_is_ready(vcrypto->cryptodev)) {
         vcrypto->status &= ~VIRTIO_CRYPTO_S_HW_READY;
     } else {
diff --git a/hw/virtio/virtio-iommu.c b/hw/virtio/virtio-iommu.c
index 533bd5073f2..c2ccdd87889 100644
--- a/hw/virtio/virtio-iommu.c
+++ b/hw/virtio/virtio-iommu.c
@@ -1433,8 +1433,10 @@ static void virtio_iommu_device_realize(DeviceState *dev, Error **errp)
     virtio_init(vdev, VIRTIO_ID_IOMMU, sizeof(struct virtio_iommu_config));
 
     s->req_vq = virtio_add_queue(vdev, VIOMMU_DEFAULT_QUEUE_SIZE,
-                             virtio_iommu_handle_command);
-    s->event_vq = virtio_add_queue(vdev, VIOMMU_DEFAULT_QUEUE_SIZE, NULL);
+                                 virtio_iommu_handle_command,
+                                 &error_abort);
+    s->event_vq = virtio_add_queue(vdev, VIOMMU_DEFAULT_QUEUE_SIZE, NULL,
+                                   &error_abort);
     s->cmd_timer = timer_new_ns(QEMU_CLOCK_VIRTUAL_RT,
                                 virtio_iommu_handle_command_timer, s);
 
diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
index 35e03ed7599..1c79bc75c13 100644
--- a/hw/virtio/virtio-mem.c
+++ b/hw/virtio/virtio-mem.c
@@ -966,7 +966,8 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
     vmem->bitmap = bitmap_new(vmem->bitmap_size);
 
     virtio_init(vdev, VIRTIO_ID_MEM, sizeof(struct virtio_mem_config));
-    vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request);
+    vmem->vq = virtio_add_queue(vdev, 128, virtio_mem_handle_request,
+                                &error_abort);
 
     /*
      * With "dynamic-memslots=off" (old behavior) we always map the whole
diff --git a/hw/virtio/virtio-nsm.c b/hw/virtio/virtio-nsm.c
index 3bf5e7009a4..6fc3fbb5852 100644
--- a/hw/virtio/virtio-nsm.c
+++ b/hw/virtio/virtio-nsm.c
@@ -1660,7 +1660,7 @@ static void virtio_nsm_device_realize(DeviceState *dev, Error **errp)
 
     virtio_init(vdev, VIRTIO_ID_NITRO_SEC_MOD, 0);
 
-    vnsm->vq = virtio_add_queue(vdev, 2, handle_input);
+    vnsm->vq = virtio_add_queue(vdev, 2, handle_input, &error_abort);
 }
 
 static void virtio_nsm_device_unrealize(DeviceState *dev)
diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
index 6f7271c140a..ac7952bbf4f 100644
--- a/hw/virtio/virtio-pmem.c
+++ b/hw/virtio/virtio-pmem.c
@@ -129,7 +129,7 @@ static void virtio_pmem_realize(DeviceState *dev, Error **errp)
 
     host_memory_backend_set_mapped(pmem->memdev, true);
     virtio_init(vdev, VIRTIO_ID_PMEM, sizeof(struct virtio_pmem_config));
-    pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush);
+    pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush, &error_abort);
     pmem->inflight = 1;
 }
 
diff --git a/hw/virtio/virtio-rng.c b/hw/virtio/virtio-rng.c
index d68d9011953..b3136431252 100644
--- a/hw/virtio/virtio-rng.c
+++ b/hw/virtio/virtio-rng.c
@@ -219,7 +219,7 @@ static void virtio_rng_device_realize(DeviceState *dev, Error **errp)
 
     virtio_init(vdev, VIRTIO_ID_RNG, 0);
 
-    vrng->vq = virtio_add_queue(vdev, 8, handle_input);
+    vrng->vq = virtio_add_queue(vdev, 8, handle_input, &error_abort);
     vrng->quota_remaining = vrng->conf.max_bytes;
     vrng->rate_limit_timer = timer_new_ms(QEMU_CLOCK_VIRTUAL,
                                                check_rate_limit, vrng);
diff --git a/hw/virtio/virtio-rtc.c b/hw/virtio/virtio-rtc.c
index 32de9c16503..3bd488bc7ba 100644
--- a/hw/virtio/virtio-rtc.c
+++ b/hw/virtio/virtio-rtc.c
@@ -135,7 +135,8 @@ static void virtio_rtc_device_realize(DeviceState *dev, Error **errp)
     VirtIORtc *vrtc = VIRTIO_RTC(dev);
 
     virtio_init(vdev, VIRTIO_ID_CLOCK, 0);
-    vrtc->vq = virtio_add_queue(vdev, 64, virtio_rtc_handle_request);
+    vrtc->vq = virtio_add_queue(vdev, 64, virtio_rtc_handle_request,
+                                &error_abort);
 }
 
 static void virtio_rtc_device_unrealize(DeviceState *dev)
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index e1210f024c6..629eadeb74b 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2565,8 +2565,9 @@ void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector)
 }
 
 VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
-                            VirtIOHandleOutput handle_output)
+                            VirtIOHandleOutput handle_output, Error **errp)
 {
+    ERRP_GUARD();
     int i;
 
     for (i = 0; i < VIRTIO_QUEUE_MAX; i++) {
@@ -2574,15 +2575,43 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
             break;
     }
 
-    if (i == VIRTIO_QUEUE_MAX || queue_size > VIRTQUEUE_MAX_SIZE)
-        abort();
+    if (i == VIRTIO_QUEUE_MAX) {
+        error_setg(errp, "Exceeded maximum number of virtqueues (%d)", i);
+        return NULL;
+    }
+
+    if (queue_size > VIRTQUEUE_MAX_SIZE) {
+        error_setg(errp, "Virtqueue size %u exceeds the max (%u)",
+                   queue_size, VIRTQUEUE_MAX_SIZE);
+        return NULL;
+    }
 
     BusState *qbus = qdev_get_parent_bus(DEVICE(vdev));
     if (qbus && qbus->parent &&
         object_property_find(OBJECT(qbus->parent), VIRTIO_QUEUE_SIZE_OVERRIDE)) {
         int override = object_property_get_int(OBJECT(qbus->parent),
                                                VIRTIO_QUEUE_SIZE_OVERRIDE,
-                                               &error_abort);
+                                               errp);
+
+        if (*errp) {
+            return NULL;
+        }
+        if (override < 0) {
+            /*
+             * The property type should be UINT16, so this can't happen, but
+             * help out Coverity.
+             */
+            error_setg(errp, "%s (%d) cannot be negative",
+                       VIRTIO_QUEUE_SIZE_OVERRIDE, override);
+            return NULL;
+        }
+        if (override > VIRTQUEUE_MAX_SIZE) {
+            error_setg(errp, "%s (%d) exceeds the max (%d)",
+                       VIRTIO_QUEUE_SIZE_OVERRIDE, override,
+                       VIRTQUEUE_MAX_SIZE);
+            return NULL;
+        }
+
         if (override) {
             queue_size = override;
         }
-- 
2.55.0

