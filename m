Return-Path: <mst@redhat.com>
Date: Mon, 10 Jul 2023 16:15:36 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230710161447-mutt-send-email-mst@kernel.org>
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-8-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20230710153522.3469097-8-alex.bennee@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH v3 07/20] virtio: add vhost-user-base and a
 generic vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

> +static const TypeInfo vud_info = {
> +    .name = TYPE_VHOST_USER_DEVICE,
> +    .parent = TYPE_VHOST_USER_BASE,
> +    .instance_size = sizeof(VHostUserBase),
> +    .class_init = vud_class_init,
> +    .class_size = sizeof(VHostUserBaseClass),

I wish you didn't tie the refactoring in with new functionality.
I applied but blocked creating these for now with:

Subject: [PATCH] vhost-user-device: block creating instances
Message-Id: <b10d1e585adf8a5348bd886333a8c55dcdef6048.1689020067.git.mst@redhat.com>

block this until we are ready to commit to this command line.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 hw/virtio/vhost-user-device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/hw/virtio/vhost-user-device.c b/hw/virtio/vhost-user-device.c
index 2b028cae08..ded97b6d70 100644
--- a/hw/virtio/vhost-user-device.c
+++ b/hw/virtio/vhost-user-device.c
@@ -369,6 +369,7 @@ static const TypeInfo vud_info = {
     .instance_size = sizeof(VHostUserBase),
     .class_init = vud_class_init,
     .class_size = sizeof(VHostUserBaseClass),
+    .abstract = true
 };

 static void vu_register_types(void)

-- 
MST

