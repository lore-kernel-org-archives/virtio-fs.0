Return-Path: <manos.pitsidianakis@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696857050; x=1697461850; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to
 :references:user-agent:subject:cc:to:from:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=b3CGzq2N9bRGbRcWI3hWghCnKaONhewEtm+3ihpADCA=;
 b=JhoQ+z/EG/B7vhJaQD2Ajk7iws2T+O71vY57CCnzdvSZQix1wqFOzEhMWopW5ViQDJ
 vZqc+2WwcjFUpdN7lEZtS/d1h4CqN7rmPCFlH1JEmJxBk0ZuoyZL6LJ3rCVt+g6l4mRo
 JuHn2EnDLP399i1b4381AsI2HvyRv9Vcq1v9vW7gLVZJI8qtMyDifyb8L/eTO3H44HhX
 voNh2hR5skQacnxVZOkVaaLkfcgkDhSEJIPOfJK2tvxdXzNwvMGVWKoPwmuxlxJtHDJg
 c1QsL9jIC3XCEGDBG4ookqyFkVtseRU7ciGGLfZf2ikKr2QOaKklCWMS98mZ7f0Op0md
 pWtA==
Date: Mon, 09 Oct 2023 16:07:08 +0300
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-3-alex.bennee@linaro.org>
In-Reply-To: <20231009095937.195728-3-alex.bennee@linaro.org>
Message-ID: <29j9y.3s4zl7gjb21@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"; format="flowed"
Subject: Re: [Virtio-fs] [PATCH v4 2/6] hw/virtio: derive vhost-user-rng
 from vhost-user-base
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, Alex Benn=?UTF-8?B?w6k=?= e <alex.bennee@linaro.org>
Cc: Marc-Andr=?UTF-8?B?w6kg?=Lureau <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Alex Benn=?UTF-8?B?w6k=?= e <alex.bennee@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, "Daniel P. Berrang=?UTF-8?B?w6k=?= " <berrange@redhat.com>

On Mon, 09 Oct 2023 12:59, Alex Bennée <alex.bennee@linaro.org> wrote:
>diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
>index 51c3f97c2d..d0b963199c 100644
>--- a/hw/virtio/meson.build
>+++ b/hw/virtio/meson.build
>@@ -18,8 +18,15 @@ if have_vhost
>     # fixme - this really should be generic
>     specific_virtio_ss.add(files('vhost-user.c'))
>     system_virtio_ss.add(files('vhost-user-base.c'))
>+
>+    # MMIO Stubs
>     system_virtio_ss.add(files('vhost-user-device.c'))
>+    system_virtio_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('vhost-user-rng.c'))
>+
>+    # PCI Stubs
>     system_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhost-user-device-pci.c'))
>+    system_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_RNG'],
>+                         if_true: files('vhost-user-rng-pci.c'))

Is there a reason why the target was moved to system_virtio_ss from 
virtio_pci_ss?

>   endif
>   if have_vhost_vdpa
>     system_virtio_ss.add(files('vhost-vdpa.c'))
>@@ -34,10 +41,8 @@ specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_FS', if_true: files('vhost-user-
> specific_virtio_ss.add(when: 'CONFIG_VIRTIO_PMEM', if_true: files('virtio-pmem.c'))
> specific_virtio_ss.add(when: 'CONFIG_VHOST_VSOCK', if_true: files('vhost-vsock.c'))
> specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('vhost-user-vsock.c'))
>-specific_virtio_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng.c'))

Was this accidental? It's not added anywhere else, only deleted.

>@@ -57,7 +61,6 @@ virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_FS', 
> if_true: files('vhost-user-fs-pc
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_CRYPTO', if_true: files('virtio-crypto-pci.c'))
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_INPUT_HOST', if_true: files('virtio-input-host-pci.c'))
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_INPUT', if_true: files('virtio-input-pci.c'))
>-virtio_pci_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng-pci.c'))
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_BALLOON', if_true: files('virtio-balloon-pci.c'))
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_9P', if_true: files('virtio-9p-pci.c'))
> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_SCSI', if_true: files('virtio-scsi-pci.c'))

Same here

Manos

