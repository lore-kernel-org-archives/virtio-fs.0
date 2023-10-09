Return-Path: <manos.pitsidianakis@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696859119; x=1697463919; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to
 :references:user-agent:subject:cc:to:from:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=t1DiSb0LrC9q9htqBj6ofwydaLZ5m4RuEkq7RIb1IZk=;
 b=PR49DLsJAhdeK3DWPBF+BkSCMMqbWEjlb2cdFDUCZqiErwtFoLP5K9/vIRC6AAAbrA
 /iSm9YEFG9FJ14dLjmeBnpsiFjqLI5QIXak7sSDc+BfL8aWSidzHn0ZHvlE+CHmsJFaz
 o0LH8FyjEXt7mp09/rrSlNvMRYYy1kbpmOgpmVpS6VpctjP3Rzoui8ccF299/eZ9yDUR
 IECkGvNDr+5I6b46gMEWBgvXH9tpec2jd5F3lO7BifWbDxigdCjxtv8QrBeW50v33Tvy
 MzEkYAMOiPiiKqx5QJn2uYFyore3RU08ex6FQb38mkO8P1ugLA7Wlu2tgXwk/fQgfow/
 HedQ==
Date: Mon, 09 Oct 2023 16:38:32 +0300
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-7-alex.bennee@linaro.org>
In-Reply-To: <20231009095937.195728-7-alex.bennee@linaro.org>
Message-ID: <29kvg.2djvd962r2cx@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [Virtio-fs] [PATCH v4 6/6] docs/system: add a basic enumeration
 of vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-block@nongnu.org, Alex Benn=?UTF-8?B?w6k=?= e <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: Marc-Andr=?UTF-8?B?w6kg?=Lureau <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Alex Benn=?UTF-8?B?w6k=?= e <alex.bennee@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, "Daniel P. Berrang=?UTF-8?B?w6k=?= " <berrange@redhat.com>

On Mon, 09 Oct 2023 12:59, Alex Bennée <alex.bennee@linaro.org> wrote:
>diff --git a/docs/system/devices/vhost-user.rst 
>b/docs/system/devices/vhost-user.rst
>index a80e95a48a..0f9eec3f00 100644
>--- a/docs/system/devices/vhost-user.rst
>+++ b/docs/system/devices/vhost-user.rst
>@@ -15,6 +15,47 @@ to the guest. The code is mostly boilerplate although each device has
> a ``chardev`` option which specifies the ID of the ``--chardev``
> device that connects via a socket to the vhost-user *daemon*.
> 
>+Each device will have an virtio-mmio and virtio-pci variant. See your
>+platform details for what sort of virtio bus to use.
>+
>+.. list-table:: vhost-user devices
>+  :widths: 20 20 60
>+  :header-rows: 1
>+
>+  * - Device
>+    - Type
>+    - Notes
>+  * - vhost-user-device
>+    - Generic Development Device
>+    - You must manually specify ``virtio-id`` and the correct ``num_vqs``. Intended for expert use.

May be worth specifying they are `VHostUserBase` interface fields since 
it's not directly obvious if you come across this before reading the 
vhost-user-device code.

>+  * - vhost-user-blk
>+    - Block storage
>+    -
>+  * - vhost-user-fs
>+    - File based storage driver
>+    - See https://gitlab.com/virtio-fs/virtiofsd
>+  * - vhost-user-scsi
>+    - SCSI based storage
>+    - See contrib/vhost-user/scsi
>+  * - vhost-user-gpio
>+    - Proxy gpio pins to host
>+    - See https://github.com/rust-vmm/vhost-device
>+  * - vhost-user-i2c
>+    - Proxy i2c devices to host
>+    - See https://github.com/rust-vmm/vhost-device
>+  * - vhost-user-input
>+    - Generic input driver
>+    - See contrib/vhost-user-input
>+  * - vhost-user-rng
>+    - Entropy driver
>+    - :ref:`vhost_user_rng`
>+  * - vhost-user-gpu
>+    - GPU driver
>+    -
>+  * - vhost-user-vsock
>+    - Socket based communication
>+    - See https://github.com/rust-vmm/vhost-device
>+

There's also:

- hw/virtio/vhost-user-scmi.c
- hw/virtio/vhost-user-snd.c

