Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681834901; x=1684426901;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=5lUakfgj7bHmml2pB9qRm9X+2uzhwj9Z43jrFiMKuUs=;
 b=sNwN5GM215cHic7A4Xs+MSOgmAjeHBJqnN4WsRNV6Z/nyjF5zDcSY9YqRy+vo/hubt
 GjiaK5aHQS8WYAbSLUSChebbGmImafadNYrajmfigwiEv1F9L94+5seDUqBqxrmeA382
 9822+z+rC5kWflHOsPG8G1AV23RPZjfsxuzAgfhU07CyN05scD0eLD4tbjqShCwwXbOH
 Lwt0/+nH2ynIQzlbrX82UlpXlru1qmLabISEX1sBVore2D/VJXJ3qcRyIXZJDf53OQxk
 kCYJ9asTIaE58iy+0VLSRcKpooRqh/xxX7rg3kTYiDAtgcBeV0NSQ30bq1LJnBekV5ln
 IwkQ==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 18 Apr 2023 17:21:27 +0100
Message-Id: <20230418162140.373219-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 00/13] virtio: add vhost-user-generic and
 reduce copy and paste
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

A lot of our vhost-user stubs are large chunks of boilerplate that do
(mostly) the same thing. This series attempts to fix that by defining
a new base class (vhost-user-base) which is used by a generic
vhost-user-device implementation. Then the rng, gpio and i2c
vhost-user devices become simple specialisations of the common base
defining the ID, number of queues and potentially the config handling.

In theory we could convert the rest of the vhost-user stubs but there
are complications caused by the config being split between the daemon
and QEMU. For example:

 -device vhost-user-device-pci,chardev=vus,virtio-id=8,num_vqs=3,config_size=36

works with the WIP vhost-user-scsi backend:

  https://github.com/rust-vmm/vhost-device/pull/301

but the concrete vhost-user-scsi-pci device fails because it expects
to handle config via the command line. You will see the report:

  qemu-system-aarch64: -device vhost-user-scsi-pci,chardev=vus:
  warning: vhost-user backend supports VHOST_USER_PROTOCOL_F_CONFIG
  but QEMU does not.

if you try. We could make the device a bit smarter but then we would
need to untangle the vhost_scsi_common_() logic which is shared with
the pure in kernel vhost implementation. The vhost-user-vsock stub
might be another one worth re-factoring although that has a similar
split architecture.

The overall diffstat shows a net deletion of code as well as
introducing some more documentation and moving the stubs into the
common build, further reducing redundancy.

Next Steps
----------

>From Stefan's last email to the v1 posting we need:

vhost-user needs:
- A GET_DEVICE_ID message.
- A GET_CONFIG_SIZE message. Today it is assumed that the vhost-user
  frontend already knows the configuration space size.
- A protocol feature bit indicating that the device is a full VIRTIO
  device. These devices also need to implement the SET_STATUS message,
  which is rarely implemented today.

and implementing the VHOST_USER_GET_QUEUE_NUM and SET_STATUS messages
to make the generic device "self configuring".

Alex.

Alex Bennée (13):
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

 docs/system/devices/vhost-user-rng.rst |   2 +
 docs/system/devices/vhost-user.rst     |  41 +++
 include/hw/qdev-core.h                 |  36 +++
 include/hw/virtio/vhost-user-device.h  |  46 +++
 include/hw/virtio/vhost-user-gpio.h    |  23 +-
 include/hw/virtio/vhost-user-i2c.h     |  18 +-
 include/hw/virtio/vhost-user-rng.h     |  11 +-
 include/hw/virtio/virtio.h             |  21 ++
 hw/display/vhost-user-gpu.c            |   4 +-
 hw/net/virtio-net.c                    |   4 +-
 hw/virtio/vhost-user-device-pci.c      |  71 +++++
 hw/virtio/vhost-user-device.c          | 380 +++++++++++++++++++++++
 hw/virtio/vhost-user-fs.c              |   4 +-
 hw/virtio/vhost-user-gpio.c            | 400 ++-----------------------
 hw/virtio/vhost-user-i2c.c             | 255 +---------------
 hw/virtio/vhost-user-rng.c             | 277 ++---------------
 hw/virtio/vhost-vsock-common.c         |   4 +-
 hw/virtio/virtio-crypto.c              |   4 +-
 hw/virtio/meson.build                  |  20 +-
 19 files changed, 686 insertions(+), 935 deletions(-)
 create mode 100644 include/hw/virtio/vhost-user-device.h
 create mode 100644 hw/virtio/vhost-user-device-pci.c
 create mode 100644 hw/virtio/vhost-user-device.c

-- 
2.39.2

