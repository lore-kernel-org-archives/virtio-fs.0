Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6BE3BFE5A
	for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 20:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785445147; cv=none; b=tjDfveODYChTxClPLqs0B1f8Vt4snN9OUkKDN4ABe2viNXgJ5pWkyroHBEx1Kzfsf878XV241x/ThURxfnHBn76nMz+3hplUDQB1C6ndpwecQBIpW89oLi+i0R3Mz+QHMqIfy0/8VnTgIRHLCPG8FnpDd3bEp8suC3Iq60pqm2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785445147; c=relaxed/simple;
	bh=Gu9MWES3aIY2honnPDm3DukrG57oSkdfEiPHqPOQxIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=saj1MWjsw+dBrTU8aezaWfqGi/L2t734muWNIngHlhWXSaitaOYNDE5dUzaEaraTluulgtLiws5thseVaHvnpAFveGl9nUvmFUt6RvMXHKjN2ezQ1JdwZwXck3afuDqzhzVqPHMiUyiO2FGRz9kzamMpQFSykb9BjSm6+l/LeN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bfxl9J4E; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bfxl9J4E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785445144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ehi23YeRieKyGvGXbYKeXTkr+c2t975mzcTWUihMYC0=;
	b=bfxl9J4EksR/3jKhxJzKWbe37je4Knu0UtuAQSGRJws9sFTzUnpsCHdfXzr7odwWZp1vJB
	SMhfPPUwZu8FZqQ97Xa1MIUNW93w+1D8yA3E00MgnHZ3IKpdgaeqjyC0IRRh7m430ChmQG
	FFB/nDeSudJIxhAYgu0BD+gAwsUIKNQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-19-0ymgijqEPWi-TpmX_dyasg-1; Thu,
 30 Jul 2026 16:58:58 -0400
X-MC-Unique: 0ymgijqEPWi-TpmX_dyasg-1
X-Mimecast-MFC-AGG-ID: 0ymgijqEPWi-TpmX_dyasg_1785445136
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 17ECA1956094;
	Thu, 30 Jul 2026 20:58:55 +0000 (UTC)
Received: from localhost (unknown [10.2.16.217])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B676F1800480;
	Thu, 30 Jul 2026 20:58:53 +0000 (UTC)
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
Subject: [PATCH v2 1/2] virtio: make virtio_add_queue() queue_size an unsigned int
Date: Thu, 30 Jul 2026 16:58:45 -0400
Message-ID: <20260730205846.19479-2-stefanha@redhat.com>
In-Reply-To: <20260730205846.19479-1-stefanha@redhat.com>
References: <20260730205846.19479-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: ZFqdvSGimXRWfZVFDY5XMTJ3EPCXFTCrHIQFY87GR7A_1785445136
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

virtio_add_queue()'s queue_size argument is a signed int. The
vdev->vq[i].vring.num and num_default fields are already declared as
unsigned int, so change the virtio_add_queue() argument's type for
consistency.

A note on consistency: the VIRTIO specification defines queue size as an
unsigned 16-bit value. QEMU's device models variously use uint16_t,
uint32_t, and other unsigned types for queue size qdev properties.
virtio_add_queue() limits queue size to the much smaller
VIRTQUEUE_MAX_SIZE (1024) constant, so the different widths don't really
matter.

I have checked that all callers of virtio_add_queue() pass an unsigned
queue size.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/hw/virtio/virtio.h | 2 +-
 hw/virtio/virtio.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
index c99cb19d886..ff7f837fb92 100644
--- a/include/hw/virtio/virtio.h
+++ b/include/hw/virtio/virtio.h
@@ -302,7 +302,7 @@ void virtio_device_set_child_bus_name(VirtIODevice *vdev, char *bus_name);
 
 typedef void (*VirtIOHandleOutput)(VirtIODevice *, VirtQueue *);
 
-VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
+VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
                             VirtIOHandleOutput handle_output);
 
 void virtio_del_queue(VirtIODevice *vdev, int n);
diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
index daa5607338c..e1210f024c6 100644
--- a/hw/virtio/virtio.c
+++ b/hw/virtio/virtio.c
@@ -2564,7 +2564,7 @@ void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector)
     }
 }
 
-VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
+VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
                             VirtIOHandleOutput handle_output)
 {
     int i;
-- 
2.55.0

