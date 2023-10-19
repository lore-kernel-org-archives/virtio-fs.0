Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697709371; x=1698314171; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=98S7NRPtEG2gZGbwqDI/I8OEUT2IsSiJuqGaCj8Lgnk=;
 b=McQFIc8tStsw/GuORJg5cQVv1DKb04saUGwBHFJHP/I0gtTVTLlBJCaLxtIqbJ6/rY
 BF07KYw7A6VXGehHQzn5TcsHXeDmEw9ngtj35dfrnJzbtHiuZYcaZB3Ni3Oq33kJrFQ5
 706a09Mo4BI0ssY7pP8qae4MiL9S16JA5wCMIfSyr2t3nW0i+duOwT5Bs60hjYWrYqBx
 Kp+7iOt0TDGnse6gi6fVXFlGnkGvgab+0IE8Wbz2W1q//VD3f0Za117cxlRdZ8VEHnIU
 O5w8rHRxbrttcy4uYmV1taUD3kc6Et+ckwQ0CX4RXfz2vjms3ph6gsdVcPet4flQM43F
 HkHw==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Thu, 19 Oct 2023 10:56:04 +0100
Message-Id: <20231019095610.2818087-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 0/6] virtio: cleanup vhost-user-generic and
 reduce c&p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>

A lot of our vhost-user stubs are large chunks of boilerplate that do
(mostly) the same thing. This series continues the cleanups by
splitting the vhost-user-base and vhost-user-generic implementations.
After adding a new vq_size property the rng, gpio and i2c vhost-user
devices become simple specialisations of the common base defining the
ID, number of queues and potentially the config handling.

I've also added Manos' vhost-user-sound while I was at it.

Changes
-------

v5
  - addressing comments and tags
  - improved the docs

v4
  - dropped the F_TRANSPORT work for another series
  - added vhost-user-sound

Alex Bennée (5):
  virtio: split into vhost-user-base and vhost-user-device
  hw/virtio: derive vhost-user-rng from vhost-user-base
  hw/virtio: derive vhost-user-gpio from vhost-user-base
  hw/virtio: derive vhost-user-i2c from vhost-user-base
  docs/system: add a basic enumeration of vhost-user devices

Manos Pitsidianakis (1):
  hw/virtio: add vhost-user-snd and virtio-snd-pci devices

 docs/system/devices/vhost-user-rng.rst        |   2 +
 docs/system/devices/vhost-user.rst            |  60 ++-
 ...{vhost-user-device.h => vhost-user-base.h} |  21 +-
 include/hw/virtio/vhost-user-gpio.h           |  23 +-
 include/hw/virtio/vhost-user-i2c.h            |  14 +-
 include/hw/virtio/vhost-user-rng.h            |  11 +-
 include/hw/virtio/vhost-user-snd.h            |  26 ++
 hw/virtio/vhost-user-base.c                   | 345 +++++++++++++++
 hw/virtio/vhost-user-device-pci.c             |  10 +-
 hw/virtio/vhost-user-device.c                 | 335 +-------------
 hw/virtio/vhost-user-gpio.c                   | 407 +-----------------
 hw/virtio/vhost-user-i2c.c                    | 272 +-----------
 hw/virtio/vhost-user-rng.c                    | 278 +-----------
 hw/virtio/vhost-user-snd-pci.c                |  75 ++++
 hw/virtio/vhost-user-snd.c                    |  67 +++
 hw/virtio/Kconfig                             |   5 +
 hw/virtio/meson.build                         |  23 +-
 17 files changed, 683 insertions(+), 1291 deletions(-)
 rename include/hw/virtio/{vhost-user-device.h => vhost-user-base.h} (71%)
 create mode 100644 include/hw/virtio/vhost-user-snd.h
 create mode 100644 hw/virtio/vhost-user-base.c
 create mode 100644 hw/virtio/vhost-user-snd-pci.c
 create mode 100644 hw/virtio/vhost-user-snd.c

-- 
2.39.2

