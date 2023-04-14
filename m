Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681488274; x=1684080274;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=upwamrFOWbXpB0LRg3OycRh6xKp0neSg/Tq8ON+G04o=;
 b=HnHCUASrDHmRpFdQnH/kC4fg1J2tS2b3xMJEHXFblVbTy9J5pJ55BSNL882fCPJ8gY
 e/CTewZXgr7dzO7+Rsr9zF+wnuI1yzLrflv6zkz/2owUK+69L8FH/mJKXQFCALXVsSgS
 XnA4FGy8ciRF5Kdy6gdtpkukRGhhdhKJCKZgdMY2zgMlcSPrYf0JhKukHSFKd2UTmn+o
 vNBaykoigtEb1bCLlIn6Jdg1rG2qV1WxfgUxtZaNkwqEvYvTDy3vzyF0vwJWbUfj88D6
 ixTlxutXKhEb44W4Oo30xKEegTtiLJ+eEX09AvfeLJeTs9zCqvYNVOej8ufg61m6miOn
 Mm1A==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 14 Apr 2023 17:04:21 +0100
Message-Id: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 00/12] virtio: add vhost-user-generic and reduce
 copy and paste
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

A lot of our vhost-user stubs are large chunks of boilerplate that do
(mostly) the same thing. This series attempts to fix that by defining
a new base class for vhost-user devices and then converting the rng
and gpio devices to be based off them. You can even use
vhost-user-device directly if you supply it with the right magic
numbers (which is helpful for development).

However the final patch runs into the weeds because I don't yet have a
clean way to represent in QOM the fixing of certain properties for the
specialised classes.

The series is a net reduction in code and an increase in
documentation but obviously needs to iron out a few more warts. I'm
open to suggestions on the best way to tweak the QOM stuff.

Alex.

Alex Bennée (12):
  hw/virtio: fix typo in VIRTIO_CONFIG_IRQ_IDX comments
  include/hw/virtio: document virtio_notify_config
  include/hw/virtio: add kerneldoc for virtio_init
  include/hw/virtio: document some more usage of notifiers
  virtio: add generic vhost-user-device
  virtio: add PCI stub for vhost-user-device
  include: attempt to document device_class_set_props
  qom: allow for properties to become "fixed"
  hw/virtio: derive vhost-user-rng from vhost-user-device
  hw/virtio: add config support to vhost-user-device
  hw/virtio: derive vhost-user-gpio from vhost-user-device (!BROKEN)
  docs/system: add a basic enumeration of vhost-user devices

 docs/system/devices/vhost-user-rng.rst |   2 +
 docs/system/devices/vhost-user.rst     |  41 +++
 qapi/qom.json                          |   2 +
 include/hw/qdev-core.h                 |   9 +
 include/hw/virtio/vhost-user-device.h  |  33 ++
 include/hw/virtio/vhost-user-gpio.h    |  23 +-
 include/hw/virtio/vhost-user-rng.h     |  11 +-
 include/hw/virtio/virtio.h             |  21 ++
 include/qom/object.h                   |  16 +-
 hw/display/vhost-user-gpu.c            |   4 +-
 hw/net/virtio-net.c                    |   4 +-
 hw/virtio/vhost-user-device-pci.c      |  71 +++++
 hw/virtio/vhost-user-device.c          | 359 ++++++++++++++++++++++
 hw/virtio/vhost-user-fs.c              |   4 +-
 hw/virtio/vhost-user-gpio.c            | 405 +------------------------
 hw/virtio/vhost-user-rng.c             | 264 +---------------
 hw/virtio/vhost-vsock-common.c         |   4 +-
 hw/virtio/virtio-crypto.c              |   4 +-
 qom/object.c                           |  14 +
 qom/object_interfaces.c                |   9 +-
 qom/qom-qmp-cmds.c                     |   1 +
 softmmu/qdev-monitor.c                 |   1 +
 hw/virtio/meson.build                  |   3 +
 23 files changed, 613 insertions(+), 692 deletions(-)
 create mode 100644 include/hw/virtio/vhost-user-device.h
 create mode 100644 hw/virtio/vhost-user-device-pci.c
 create mode 100644 hw/virtio/vhost-user-device.c

-- 
2.39.2

