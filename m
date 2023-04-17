Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681748671; x=1684340671;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=QZwKumCvepBHfmdhF6N8J7XAEcNA1IrJD+sNrVEorvw=;
 b=t0FjjqAAevVxEwHSOTAQMMmbIvJQZ+qzehj1jhD/3IqflZwy8ovSxFNutwV6i3W/5G
 M528Os5PWgYv534qzt7/g4pXUij8xWV1BSocR3IiduJPiRFlty0stGPc5am6o34FA/pF
 DkZ8G/htDQm1KPa1YHzOkvEZzxVNKX/mwL+vg53HS5QJFnC57nk1ie/LjOSSYGYHYJah
 3HbitW9KWK6lMCCKBkY5fMdMVPaPfgPh2B7846x3Y6jsb+zOi7og4ygSwTH4O6WsMoBT
 q30mdNIq5QYohKmpJGn1S+HPjwETtlK1b/34EUVeIHm/AfgJltyZuiwBd/SU12iJWzWv
 oR9Q==
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <CAJSP0QURbJrEoFY8FhMnq_B6tx-qYspfu-OB6=6hz5=qAwE=6A@mail.gmail.com>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 17 Apr 2023 17:14:59 +0100
In-reply-to: <CAJSP0QURbJrEoFY8FhMnq_B6tx-qYspfu-OB6=6hz5=qAwE=6A@mail.gmail.com>
Message-ID: <87ttxeeatd.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>


Stefan Hajnoczi <stefanha@gmail.com> writes:

> On Fri, 14 Apr 2023 at 12:06, Alex Benn=C3=A9e <alex.bennee@linaro.org> w=
rote:
>>
>> A lot of our vhost-user stubs are large chunks of boilerplate that do
>> (mostly) the same thing. This series attempts to fix that by defining
>> a new base class for vhost-user devices and then converting the rng
>> and gpio devices to be based off them. You can even use
>> vhost-user-device directly if you supply it with the right magic
>> numbers (which is helpful for development).
>>
>> However the final patch runs into the weeds because I don't yet have a
>> clean way to represent in QOM the fixing of certain properties for the
>> specialised classes.
>>
>> The series is a net reduction in code and an increase in
>> documentation but obviously needs to iron out a few more warts. I'm
>> open to suggestions on the best way to tweak the QOM stuff.
>
> --device vhost-user-device is not really possible because vhost-user
> devices are not full VIRTIO devices. vhost-user devices depend on
> device-specific code in the VMM by design.

What device specific code? You certainly need to instantiate stuff in
the DTB/ACPI tables for -M virt but everything else can be handed off to
the vhost-user daemon.

Indeed the split brain is a bit silly in some places. For example is
QEMU really the best arbiter of a block device config when the actual
backend is a separate process. We have config passing in the vhost-user
spec.

> The "subset of a VIRTIO device" design made sense for vhost_net.
> Nowadays there are other device types that are close to full VIRTIO
> devices, although the vhost-user protocol doesn't support the full
> VIRTIO device lifecycle.

What are we missing?

> I think a user-creatable --device vhost-user-device is not a good idea
> today. It creates confusion. Many people aren't aware of the
> architectural difference between vhost-user and VIRTIO devices. The
> result is that VMMs and vhost-user backends implement increasingly
> brittle VIRTIO configuration space and feature bit logic as they
> knowingly or unknowingly try to paper over the fact that a traditional
> vhost-user device isn't a full VIRTIO device.

I've always found the device feature gating in QEMU confusing. Surely we
can rely on the daemon to properly enumerate the features it supports?

> It is possible to resolve this difference and make --device
> vhost-user-device work properly for devices that want to be full
> VIRTIO devices. See "Making VMM device shims optional" here:
> https://blog.vmsplice.net/2020/09/on-unifying-vhost-user-and-virtio.html
>
> Even after extending the vhost-user protocol to solve the current
> limitations, existing backends would still only be partial VIRTIO
> devices that wouldn't work with --device vhost-user-device.

It works for RNG, GPIO (and soon I'll be testing i2c and SCSI). All we
need is the virtioid and the number of virtio queues.

> Reducing boilerplate is helpful, but I think --device
> vhost-user-device should not be user-creatable.

After this series lands it will certainly make adding new shims easier
but having a vhost-user-device will make testing of new backends easier.
Can we not simply document it as an advanced feature for those who know
what they are doing? I'm not intending to deprecate the existing shims.

>
> Stefan
>
>>
>> Alex.
>>
>> Alex Benn=C3=A9e (12):
>>   hw/virtio: fix typo in VIRTIO_CONFIG_IRQ_IDX comments
>>   include/hw/virtio: document virtio_notify_config
>>   include/hw/virtio: add kerneldoc for virtio_init
>>   include/hw/virtio: document some more usage of notifiers
>>   virtio: add generic vhost-user-device
>>   virtio: add PCI stub for vhost-user-device
>>   include: attempt to document device_class_set_props
>>   qom: allow for properties to become "fixed"
>>   hw/virtio: derive vhost-user-rng from vhost-user-device
>>   hw/virtio: add config support to vhost-user-device
>>   hw/virtio: derive vhost-user-gpio from vhost-user-device (!BROKEN)
>>   docs/system: add a basic enumeration of vhost-user devices
>>
>>  docs/system/devices/vhost-user-rng.rst |   2 +
>>  docs/system/devices/vhost-user.rst     |  41 +++
>>  qapi/qom.json                          |   2 +
>>  include/hw/qdev-core.h                 |   9 +
>>  include/hw/virtio/vhost-user-device.h  |  33 ++
>>  include/hw/virtio/vhost-user-gpio.h    |  23 +-
>>  include/hw/virtio/vhost-user-rng.h     |  11 +-
>>  include/hw/virtio/virtio.h             |  21 ++
>>  include/qom/object.h                   |  16 +-
>>  hw/display/vhost-user-gpu.c            |   4 +-
>>  hw/net/virtio-net.c                    |   4 +-
>>  hw/virtio/vhost-user-device-pci.c      |  71 +++++
>>  hw/virtio/vhost-user-device.c          | 359 ++++++++++++++++++++++
>>  hw/virtio/vhost-user-fs.c              |   4 +-
>>  hw/virtio/vhost-user-gpio.c            | 405 +------------------------
>>  hw/virtio/vhost-user-rng.c             | 264 +---------------
>>  hw/virtio/vhost-vsock-common.c         |   4 +-
>>  hw/virtio/virtio-crypto.c              |   4 +-
>>  qom/object.c                           |  14 +
>>  qom/object_interfaces.c                |   9 +-
>>  qom/qom-qmp-cmds.c                     |   1 +
>>  softmmu/qdev-monitor.c                 |   1 +
>>  hw/virtio/meson.build                  |   3 +
>>  23 files changed, 613 insertions(+), 692 deletions(-)
>>  create mode 100644 include/hw/virtio/vhost-user-device.h
>>  create mode 100644 hw/virtio/vhost-user-device-pci.c
>>  create mode 100644 hw/virtio/vhost-user-device.c
>>
>> --
>> 2.39.2
>>
>>


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

