DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=crudebyte.com; s=lizzy;
	h=Cc:To:Subject:Date:From:References:In-Reply-To:
	Message-Id:Content-Type:Content-Transfer-Encoding:MIME-Version:Content-ID:
	Content-Description; bh=f4VjqFwtddhhj6avEVv72Wovsfu0a2P1y6ipMsVQxmA=;
	b=IygOj
	m3X/nSIkD2nnaQX8vUWiOXXWCOtw0SeHxoPvSZECg4Yeg9rTx+lD1LdOdl9L7NXoCA++t8jqwI8WV
	vyz59+yFPJTi9Dbj4279T5Lv3uaQLRs914I4tikhhrwEriiIbPIJcNYt5bVBG6HU3jSaRdweDrUQJ
	ScW/vbDJY9QXwo6rpeVWCdoJYjuD931OoPLRhcbMVXjNvY9GES/SOpKzX2gvIcnJ9oYBElXAMjhjK
	71en4UlA3VR/XruMdBBw7aN9yvfErHlFXIHEKYkOVaq8pEe5Ccv4DceCafHRsowEbeX0giB9vz1xb
	OJTKFPQeBJqTP0lGDJOog/GlF8knQ==
Message-Id: <ae0464f653ef20292e335ba3de0d62ab3ce8c72c.1633376313.git.qemu_oss@crudebyte.com>
In-Reply-To: <cover.1633376313.git.qemu_oss@crudebyte.com>
References: <cover.1633376313.git.qemu_oss@crudebyte.com>
From: Christian Schoenebeck <qemu_oss@crudebyte.com>
Date: Mon, 4 Oct 2021 21:38:12 +0200
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 3/3] virtio-9p-device: switch to 32k max.
	transfer size
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Amit Shah <amit@kernel.org>, David Hildenbrand <david@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, virtio-fs@redhat.com, Eric Auger <eric.auger@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Fam Zheng <fam@euphon.net>

9pfs supports the new maximum virtio queue size of 32k, so let's
switch the 9pfs virtio transport from 1k to 32k.

This will allow a maximum 'msize' option (maximum message size)
by 9p client of approximately 128M (assuming 4k page size, in
practice slightly smaller, e.g. with Linux client minus 2 pages).

Signed-off-by: Christian Schoenebeck <qemu_oss@crudebyte.com>
---
 hw/9pfs/virtio-9p-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/9pfs/virtio-9p-device.c b/hw/9pfs/virtio-9p-device.c
index 9013e7df6e..cd5d95dd51 100644
--- a/hw/9pfs/virtio-9p-device.c
+++ b/hw/9pfs/virtio-9p-device.c
@@ -217,7 +217,7 @@ static void virtio_9p_device_realize(DeviceState *dev, Error **errp)
 
     v->config_size = sizeof(struct virtio_9p_config) + strlen(s->fsconf.tag);
     virtio_init(vdev, "virtio-9p", VIRTIO_ID_9P, v->config_size,
-                VIRTQUEUE_LEGACY_MAX_SIZE);
+                VIRTQUEUE_MAX_SIZE);
     v->vq = virtio_add_queue(vdev, MAX_REQ, handle_9p_output);
 }
 
-- 
2.20.1

