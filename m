Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689003324; x=1691595324;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=XSMILEeS8Isq93UXfxuGWCtLXuOlbMWTCm5hqyU44q8=;
 b=p3QnVk6XCI1jjoYWAlbDymHSAu4DWDLkyu/t41kl9JmEO64qA0hcSoY3pm/oX0EcvK
 R5U6rsqyKhXHms1yeU3S9QDPaaka0tsLyZFYjuNpmYRdx0qxu+LuudT9bP7QmjST1Rtk
 WnPbfBRne/JGnMiL3RVx7vvsTBh01aSi+pGCLTdjBtGdrAzjh0uBzB6zbcxXTQK8PZZF
 BKuW05FAmVCYtnSvpmncK+luBn4mYo6FloNze/XrvirPzLYzNlCRoEhS3XYaUY5T6o5A
 VUE2GBMbixCDdzMqUcdlAh+sz7cKbWTzEXVuWm5d1MX9oVMeRVE135r0k24gBzdjsJck
 U4Wg==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 10 Jul 2023 16:35:02 +0100
Message-Id: <20230710153522.3469097-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 00/20] virtio: add vhost-user-generic,
 reduce c&p and support standalone
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

A lot of our vhost-user stubs are large chunks of boilerplate that do
(mostly) the same thing. This series attempts to fix that by defining
a new base class (vhost-user-base) which is used by a generic
vhost-user-device implementation. Then the rng, gpio and i2c
vhost-user devices become simple specialisations of the common base
defining the ID, number of queues and potentially the config handling.

However as of v3 we go a bit further and introduce a new protocol
feature called F_STANDALONE which adds some messages to vhost-user
that allow the daemon to fully advertise its capabilities.

Example
=======

Using the vhost-device-rng built from this branch (draft PR):

  https://github.com/rust-vmm/vhost-device/pull/394

You can start QEMU with an even simpler command line:

  -chardev socket,id=vus,path=/tmp/vus.sock0 \
  -device vhost-user-device-pci,chardev=vus \
  -d trace:vhost_\*,trace:vhost_user\*

which doesn't specify any queues or config space but gets it from the
daemon as it starts up. This does involve a bit of shuffling around in
the guts of the vhost code so currently it is RFC status.

Anything for 8.1?
=================

mst,

I don't know if you want to cherry pick anything up to and including:

  hw/virtio: derive vhost-user-i2c from vhost-user-base

which is at least a cleanup. However I'm on holiday for the next 3 or
so weeks so it's perfectly ok to leave this as 8.2 material if you
want.

Alex.

Alex Bennée (20):
  include: attempt to document device_class_set_props
  include/hw: document the device_class_set_parent_* fns
  hw/virtio: fix typo in VIRTIO_CONFIG_IRQ_IDX comments
  include/hw/virtio: document virtio_notify_config
  include/hw/virtio: add kerneldoc for virtio_init
  include/hw/virtio: document some more usage of notifiers
  virtio: add vhost-user-base and a generic vhost-user-device
  virtio: add PCI stub for vhost-user-device
  hw/virtio: derive vhost-user-rng from vhost-user-device
  hw/virtio: add config support to vhost-user-device
  hw/virtio: derive vhost-user-gpio from vhost-user-device
  hw/virtio: derive vhost-user-i2c from vhost-user-base
  docs/system: add a basic enumeration of vhost-user devices
  docs/interop: define STANDALONE protocol feature for vhost-user
  hw/virtio: move vhost_user_init earlier
  hw/virtio: move virtq initialisation into internal helper
  hw/virtio: push down allocation responsibility for vhost_dev->vqs
  hw/virtio: validate F_STANDALONE also supports other protocol features
  hw/virtio: probe backend for specs if it supports it
  hw/virtio: allow vhost-user-device to be driven by backend

 docs/interop/vhost-user.rst            |  39 +++
 docs/system/devices/vhost-user-rng.rst |   2 +
 docs/system/devices/vhost-user.rst     |  41 +++
 include/hw/qdev-core.h                 |  36 +++
 include/hw/virtio/vhost-user-blk.h     |   1 -
 include/hw/virtio/vhost-user-device.h  |  46 +++
 include/hw/virtio/vhost-user-gpio.h    |  23 +-
 include/hw/virtio/vhost-user-i2c.h     |  18 +-
 include/hw/virtio/vhost-user-rng.h     |  11 +-
 include/hw/virtio/vhost.h              |  21 ++
 include/hw/virtio/virtio.h             |  21 ++
 backends/vhost-user.c                  |   1 -
 hw/block/vhost-user-blk.c              |   7 +-
 hw/display/vhost-user-gpu.c            |   4 +-
 hw/net/virtio-net.c                    |   4 +-
 hw/scsi/vhost-scsi.c                   |   2 -
 hw/scsi/vhost-user-scsi.c              |   6 -
 hw/virtio/vdpa-dev.c                   |   9 +-
 hw/virtio/vhost-user-device-pci.c      |  71 +++++
 hw/virtio/vhost-user-device.c          | 396 ++++++++++++++++++++++++
 hw/virtio/vhost-user-fs.c              |   5 +-
 hw/virtio/vhost-user-gpio.c            | 400 ++-----------------------
 hw/virtio/vhost-user-i2c.c             | 271 +----------------
 hw/virtio/vhost-user-rng.c             | 277 ++---------------
 hw/virtio/vhost-user.c                 |  84 ++++++
 hw/virtio/vhost-vsock-common.c         |   4 +-
 hw/virtio/vhost.c                      |  70 +++--
 hw/virtio/virtio-crypto.c              |   4 +-
 hw/virtio/meson.build                  |  20 +-
 29 files changed, 898 insertions(+), 996 deletions(-)
 create mode 100644 include/hw/virtio/vhost-user-device.h
 create mode 100644 hw/virtio/vhost-user-device-pci.c
 create mode 100644 hw/virtio/vhost-user-device.c

-- 
2.39.2

