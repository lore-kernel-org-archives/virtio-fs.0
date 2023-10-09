Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696859416; x=1697464216; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=TIXU1tIQfEO5O4jUROwjakCAV+8cGPWt76AAUbUDMJI=;
 b=znecLhA3S72PneyWeQkJF/YXFpicMdcjuUhITbq2koL14IEtnUMUvWm4DZkZBurbPr
 sMlQ3Bw3ukjzolte937SFerXe40DCKVU7fkONq880npNgc95PJVrVR6IjKU6ikXRwNCy
 fTJW372ul/mcsKXW5RvOYqwRL0MswjhX7lag7wF7bHDz4lk54fe8H3nRT+nXduA6I5PN
 xjZxV6Q6n3scS10ENyU93XRu/WYZIjxvd/em+ZP5Vghp5anp7l/tr39esMYZBMKLp182
 XLmxg96/2upyhmE8AKLLN23ezNbN4ZDGKO1qMM2ho/DEfpluF0EH4IVeSM0ZJfLTyTMV
 BHZw==
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-3-alex.bennee@linaro.org>
 <29j9y.3s4zl7gjb21@linaro.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 09 Oct 2023 14:48:50 +0100
In-reply-to: <29j9y.3s4zl7gjb21@linaro.org>
Message-ID: <87y1gbq50p.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
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
To: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Cc: qemu-devel@nongnu.org, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, Gonglei <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>


Manos Pitsidianakis <manos.pitsidianakis@linaro.org> writes:

> On Mon, 09 Oct 2023 12:59, Alex Benn=C3=A9e <alex.bennee@linaro.org> wrot=
e:
>>diff --git a/hw/virtio/meson.build b/hw/virtio/meson.build
>>index 51c3f97c2d..d0b963199c 100644
>>--- a/hw/virtio/meson.build
>>+++ b/hw/virtio/meson.build
>>@@ -18,8 +18,15 @@ if have_vhost
>>     # fixme - this really should be generic
>>     specific_virtio_ss.add(files('vhost-user.c'))
>>     system_virtio_ss.add(files('vhost-user-base.c'))
>>+
>>+    # MMIO Stubs
>>     system_virtio_ss.add(files('vhost-user-device.c'))
>>+    system_virtio_ss.add(when: 'CONFIG_VHOST_USER_RNG', if_true: files('=
vhost-user-rng.c'))
>>+
>>+    # PCI Stubs
>>     system_virtio_ss.add(when: 'CONFIG_VIRTIO_PCI', if_true: files('vhos=
t-user-device-pci.c'))
>>+    system_virtio_ss.add(when: ['CONFIG_VIRTIO_PCI', 'CONFIG_VHOST_USER_=
RNG'],
>>+                         if_true: files('vhost-user-rng-pci.c'))
>
> Is there a reason why the target was moved to system_virtio_ss from
> virtio_pci_ss?

So we build it once, virtio_pci_ss is still:

  specific_virtio_ss.add_all(when: 'CONFIG_VIRTIO_PCI', if_true: virtio_pci=
_ss)

which means we build it once for every target which is overkill.

>
>>   endif
>>   if have_vhost_vdpa
>>     system_virtio_ss.add(files('vhost-vdpa.c'))
>>@@ -34,10 +41,8 @@ specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_FS', i=
f_true: files('vhost-user-
>> specific_virtio_ss.add(when: 'CONFIG_VIRTIO_PMEM', if_true: files('virti=
o-pmem.c'))
>> specific_virtio_ss.add(when: 'CONFIG_VHOST_VSOCK', if_true: files('vhost=
-vsock.c'))
>> specific_virtio_ss.add(when: 'CONFIG_VHOST_USER_VSOCK', if_true: files('=
vhost-user-vsock.c'))
>>-specific_virtio_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio=
-rng.c'))
>
> Was this accidental? It's not added anywhere else, only deleted.

Oops yes. Didn't mean to delete the in-tree emulation. Will fix.

>
>> @@ -57,7 +61,6 @@ virtio_pci_ss.add(when: 'CONFIG_VHOST_USER_FS',
>> if_true: files('vhost-user-fs-pc
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_CRYPTO', if_true: files('virtio-c=
rypto-pci.c'))
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_INPUT_HOST', if_true: files('virt=
io-input-host-pci.c'))
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_INPUT', if_true: files('virtio-in=
put-pci.c'))
>>-virtio_pci_ss.add(when: 'CONFIG_VIRTIO_RNG', if_true: files('virtio-rng-=
pci.c'))
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_BALLOON', if_true: files('virtio-=
balloon-pci.c'))
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_9P', if_true: files('virtio-9p-pc=
i.c'))
>> virtio_pci_ss.add(when: 'CONFIG_VIRTIO_SCSI', if_true: files('virtio-scs=
i-pci.c'))
>
> Same here
>
> Manos


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

