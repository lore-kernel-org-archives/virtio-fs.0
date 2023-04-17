Return-Path: <stefanha@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1681734790; x=1684326790;
 h=content-transfer-encoding:cc:to:subject:message-id:date:from
 :in-reply-to:references:mime-version:from:to:cc:subject:date
 :message-id:reply-to;
 bh=KKil25CaD1GefOuSJ7he1KxtJ2MGvC2v1/qQerrKU50=;
 b=sdwwxJXNqnNAWox4T4jiQ/n2PiwvpescAPS9jtShVlT9CM0UGX0deS+WLyF+m37SIb
 MQoT3C+QBG1ZbucYoDxShZgggB1HMXXpa8N7hdsXvZT8f7w/zFbN0/xUaO/6wBqEVLGY
 dGHqDCjNNzRx9RPbyQf4pXlLkcywZnpvnOS+QyFLypLYTSRIvdcj1+7MyRbL52WmIjfR
 hcosWi3VJp9ed2YKjfTa8Vj3kFh/3LP33UEzW1p+XjLOvY2VW7RI7CEyINQnmBYV+A5t
 sIrWQVztUoW+iwwprCPjwYpuUSHnQdx9YsGCD+8p/hzr4VbSzeV2B0DPAmSjjg9aHJXb
 8EFQ==
MIME-Version: 1.0
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
From: Stefan Hajnoczi <stefanha@gmail.com>
Date: Mon, 17 Apr 2023 08:32:58 -0400
Message-ID: <CAJSP0QURbJrEoFY8FhMnq_B6tx-qYspfu-OB6=6hz5=qAwE=6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 00/12] virtio: add vhost-user-generic and
 reduce copy and paste
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

On Fri, 14 Apr 2023 at 12:06, Alex Benn=C3=A9e <alex.bennee@linaro.org> wro=
te:
>
> A lot of our vhost-user stubs are large chunks of boilerplate that do
> (mostly) the same thing. This series attempts to fix that by defining
> a new base class for vhost-user devices and then converting the rng
> and gpio devices to be based off them. You can even use
> vhost-user-device directly if you supply it with the right magic
> numbers (which is helpful for development).
>
> However the final patch runs into the weeds because I don't yet have a
> clean way to represent in QOM the fixing of certain properties for the
> specialised classes.
>
> The series is a net reduction in code and an increase in
> documentation but obviously needs to iron out a few more warts. I'm
> open to suggestions on the best way to tweak the QOM stuff.

--device vhost-user-device is not really possible because vhost-user
devices are not full VIRTIO devices. vhost-user devices depend on
device-specific code in the VMM by design.

The "subset of a VIRTIO device" design made sense for vhost_net.
Nowadays there are other device types that are close to full VIRTIO
devices, although the vhost-user protocol doesn't support the full
VIRTIO device lifecycle.

I think a user-creatable --device vhost-user-device is not a good idea
today. It creates confusion. Many people aren't aware of the
architectural difference between vhost-user and VIRTIO devices. The
result is that VMMs and vhost-user backends implement increasingly
brittle VIRTIO configuration space and feature bit logic as they
knowingly or unknowingly try to paper over the fact that a traditional
vhost-user device isn't a full VIRTIO device.

It is possible to resolve this difference and make --device
vhost-user-device work properly for devices that want to be full
VIRTIO devices. See "Making VMM device shims optional" here:
https://blog.vmsplice.net/2020/09/on-unifying-vhost-user-and-virtio.html

Even after extending the vhost-user protocol to solve the current
limitations, existing backends would still only be partial VIRTIO
devices that wouldn't work with --device vhost-user-device.

Reducing boilerplate is helpful, but I think --device
vhost-user-device should not be user-creatable.

Stefan

>
> Alex.
>
> Alex Benn=C3=A9e (12):
>   hw/virtio: fix typo in VIRTIO_CONFIG_IRQ_IDX comments
>   include/hw/virtio: document virtio_notify_config
>   include/hw/virtio: add kerneldoc for virtio_init
>   include/hw/virtio: document some more usage of notifiers
>   virtio: add generic vhost-user-device
>   virtio: add PCI stub for vhost-user-device
>   include: attempt to document device_class_set_props
>   qom: allow for properties to become "fixed"
>   hw/virtio: derive vhost-user-rng from vhost-user-device
>   hw/virtio: add config support to vhost-user-device
>   hw/virtio: derive vhost-user-gpio from vhost-user-device (!BROKEN)
>   docs/system: add a basic enumeration of vhost-user devices
>
>  docs/system/devices/vhost-user-rng.rst |   2 +
>  docs/system/devices/vhost-user.rst     |  41 +++
>  qapi/qom.json                          |   2 +
>  include/hw/qdev-core.h                 |   9 +
>  include/hw/virtio/vhost-user-device.h  |  33 ++
>  include/hw/virtio/vhost-user-gpio.h    |  23 +-
>  include/hw/virtio/vhost-user-rng.h     |  11 +-
>  include/hw/virtio/virtio.h             |  21 ++
>  include/qom/object.h                   |  16 +-
>  hw/display/vhost-user-gpu.c            |   4 +-
>  hw/net/virtio-net.c                    |   4 +-
>  hw/virtio/vhost-user-device-pci.c      |  71 +++++
>  hw/virtio/vhost-user-device.c          | 359 ++++++++++++++++++++++
>  hw/virtio/vhost-user-fs.c              |   4 +-
>  hw/virtio/vhost-user-gpio.c            | 405 +------------------------
>  hw/virtio/vhost-user-rng.c             | 264 +---------------
>  hw/virtio/vhost-vsock-common.c         |   4 +-
>  hw/virtio/virtio-crypto.c              |   4 +-
>  qom/object.c                           |  14 +
>  qom/object_interfaces.c                |   9 +-
>  qom/qom-qmp-cmds.c                     |   1 +
>  softmmu/qdev-monitor.c                 |   1 +
>  hw/virtio/meson.build                  |   3 +
>  23 files changed, 613 insertions(+), 692 deletions(-)
>  create mode 100644 include/hw/virtio/vhost-user-device.h
>  create mode 100644 hw/virtio/vhost-user-device-pci.c
>  create mode 100644 hw/virtio/vhost-user-device.c
>
> --
> 2.39.2
>
>

