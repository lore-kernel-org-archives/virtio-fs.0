Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=uEDLiVVrLktznZUIRCsVgnsCI5pxyytwgpqvchTpi78=; b=Qa20PfDB/6RuG2abzxzVt42zZB
 d4NDQiQM2ujwrhec1kyahPg86O2eBM48hIuPeOIZ82NUj1fZjMTjWK50Sw8oe9z54TFl96PyqAE3U
 WCY36cOPxNGWesyPZoPIBb1fzYFT5FRT9Lgi+dpVe7KbC5r0Citscq4tRJCZIY4H1i4K9gxN13H1q
 C0q1kuEnFxcLBK5Y+o25a6FIAVkszRphGrctum5404MXh64hc2qtS5AgDoj9BHbYVIx9x1Pcf2E+O
 O4VD/Z/vrW5Ynz92gJ6iyPF4WS+QbLLA+xEbA4OH042wd3sA3cmBnTLKzWff5Trqn7fW6pDEDc/26
 OTMZmy72E0vV4sYP7TxyBDKFxHlh09PWkyKcpIeO6QuzUoVKMB+DjbIxgAW5O7CO9WFBpynA7Kz0X
 Ee4De0KvrtYxx+I2nCSJbKEXhWmkK5iy7FPipPhb8Ok9Ob+bre6e8X1a8U3qjWSP+uX1hfbyomG+s
 4zjhM5QZ2INCCx18Mr8hpD2XD9h6R3J2U6Zcd7OxARA1Rt3qN0hzSEajwgE+gylBKxh+ZQ+oSwTfr
 c2EcA4lDWfkq66HxT08zqJ0++WcXn5+79YGXAmrB+82NoNwmj9mHftray+4yugAkDcEQIWEcn4rZk
 gElFEikc3Hx6nvJaM05rKnu5FjtuRz05eMH7dgqnY=
Message-ID: <881062fe-b8c7-4437-92cf-0e9838f3708b@ilande.co.uk>
Date: Tue, 10 Oct 2023 16:14:20 +0100
MIME-Version: 1.0
References: <20231009095937.195728-1-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20231009095937.195728-1-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v4 0/6] virtio: cleanup vhost-user-generic
 and reduce c&p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>

On 09/10/2023 10:59, Alex Bennée wrote:

> A lot of our vhost-user stubs are large chunks of boilerplate that do
> (mostly) the same thing. This series continues the cleanups by
> splitting the vhost-user-base and vhost-user-generic implementations.
> After adding a new vq_size property the rng, gpio and i2c vhost-user
> devices become simple specialisations of the common base defining the
> ID, number of queues and potentially the config handling.
> 
> I've also added Manos' vhost-user-sound while I was at it.
> 
> Changes
> -------
> 
> I've dropped the F_TRANSPORT work from this series to keep this small
> and ready to merge. The changes for F_TRANSPORT are a bit more
> invasive and still need a bit of debugging but I wanted to get this
> stuff merged now.
> 
> Alex Bennée (5):
>    virtio: split into vhost-user-base and vhost-user-device
>    hw/virtio: derive vhost-user-rng from vhost-user-base
>    hw/virtio: derive vhost-user-gpio from vhost-user-base
>    hw/virtio: derive vhost-user-i2c from vhost-user-base
>    docs/system: add a basic enumeration of vhost-user devices
> 
> Manos Pitsidianakis (1):
>    hw/virtio: add vhost-user-snd and virtio-snd-pci devices
> 
>   docs/system/devices/vhost-user-rng.rst |   2 +
>   docs/system/devices/vhost-user.rst     |  41 +++
>   include/hw/virtio/vhost-user-base.h    |  49 +++
>   include/hw/virtio/vhost-user-gpio.h    |  23 +-
>   include/hw/virtio/vhost-user-i2c.h     |  14 +-
>   include/hw/virtio/vhost-user-rng.h     |  11 +-
>   include/hw/virtio/vhost-user-snd.h     |  26 ++
>   hw/virtio/vhost-user-base.c            | 348 +++++++++++++++++++++
>   hw/virtio/vhost-user-device-pci.c      |  10 +-
>   hw/virtio/vhost-user-device.c          | 335 +-------------------
>   hw/virtio/vhost-user-gpio.c            | 407 ++-----------------------
>   hw/virtio/vhost-user-i2c.c             | 272 +----------------
>   hw/virtio/vhost-user-rng.c             | 278 ++---------------
>   hw/virtio/vhost-user-snd-pci.c         |  75 +++++
>   hw/virtio/vhost-user-snd.c             |  67 ++++
>   hw/virtio/Kconfig                      |   5 +
>   hw/virtio/meson.build                  |  25 +-
>   17 files changed, 705 insertions(+), 1283 deletions(-)
>   create mode 100644 include/hw/virtio/vhost-user-base.h
>   create mode 100644 include/hw/virtio/vhost-user-snd.h
>   create mode 100644 hw/virtio/vhost-user-base.c
>   create mode 100644 hw/virtio/vhost-user-snd-pci.c
>   create mode 100644 hw/virtio/vhost-user-snd.c

Hi Alex,

 From a quick skim the QOM modelling looks good to me. The only thing I've noticed is 
that the parent object for VHostUserBase derived classes is sometimes named as 
"VHostUserBase parent" instead of "VHostUserBase parent_obj" as per the QOM naming 
guidelines.


ATB,

Mark.

