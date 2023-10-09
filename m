Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696845579; x=1697450379; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:from:to:cc:subject:date:message-id:reply-to;
 bh=1XLFDaMHZCEg2LGyweqzWt7sDWsIdqiMwYyFkHjOtX4=;
 b=BH10Q1P4j1Qv0ShmjZj0ctFYiFnuAzgLQmWANpa+mcwKEX1yc0Z/2NOXqkOsDbb7NT
 z8L6aY9S8h2U8QkCOB0aC8eXxALnvNQyun33SHWuNcaHCjFNl8O4XgUmLMdxS8q3TLZL
 apFmO9JraV/9QgNAhN+8wR9quRN5E0MYr6oliMQWJpgImx+ODuzz13vMWdTwviOWv/2a
 Yhw6lK7zO8gLAzdEmy2nmrK+BODUHd0SUO51LDfIeIQLKj26VSC6ILzOZeVgfCS2+Dl6
 2N0AqCua0J6fK+bOmyW5tQHq8NEyXeLx8xh7NrwPuC6HgxfAcG5RWztDqKdFMIqQlTbN
 3QYQ==
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon,  9 Oct 2023 10:59:31 +0100
Message-Id: <20231009095937.195728-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/6] virtio: cleanup vhost-user-generic and
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
Cc: =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Viresh Kumar <viresh.kumar@linaro.org>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>

A lot of our vhost-user stubs are large chunks of boilerplate that do
(mostly) the same thing. This series continues the cleanups by
splitting the vhost-user-base and vhost-user-generic implementations.
After adding a new vq_size property the rng, gpio and i2c vhost-user
devices become simple specialisations of the common base defining the
ID, number of queues and potentially the config handling.

I've also added Manos' vhost-user-sound while I was at it.

Changes
-------

I've dropped the F_TRANSPORT work from this series to keep this small
and ready to merge. The changes for F_TRANSPORT are a bit more
invasive and still need a bit of debugging but I wanted to get this
stuff merged now.

Alex Bennée (5):
  virtio: split into vhost-user-base and vhost-user-device
  hw/virtio: derive vhost-user-rng from vhost-user-base
  hw/virtio: derive vhost-user-gpio from vhost-user-base
  hw/virtio: derive vhost-user-i2c from vhost-user-base
  docs/system: add a basic enumeration of vhost-user devices

Manos Pitsidianakis (1):
  hw/virtio: add vhost-user-snd and virtio-snd-pci devices

 docs/system/devices/vhost-user-rng.rst |   2 +
 docs/system/devices/vhost-user.rst     |  41 +++
 include/hw/virtio/vhost-user-base.h    |  49 +++
 include/hw/virtio/vhost-user-gpio.h    |  23 +-
 include/hw/virtio/vhost-user-i2c.h     |  14 +-
 include/hw/virtio/vhost-user-rng.h     |  11 +-
 include/hw/virtio/vhost-user-snd.h     |  26 ++
 hw/virtio/vhost-user-base.c            | 348 +++++++++++++++++++++
 hw/virtio/vhost-user-device-pci.c      |  10 +-
 hw/virtio/vhost-user-device.c          | 335 +-------------------
 hw/virtio/vhost-user-gpio.c            | 407 ++-----------------------
 hw/virtio/vhost-user-i2c.c             | 272 +----------------
 hw/virtio/vhost-user-rng.c             | 278 ++---------------
 hw/virtio/vhost-user-snd-pci.c         |  75 +++++
 hw/virtio/vhost-user-snd.c             |  67 ++++
 hw/virtio/Kconfig                      |   5 +
 hw/virtio/meson.build                  |  25 +-
 17 files changed, 705 insertions(+), 1283 deletions(-)
 create mode 100644 include/hw/virtio/vhost-user-base.h
 create mode 100644 include/hw/virtio/vhost-user-snd.h
 create mode 100644 hw/virtio/vhost-user-base.c
 create mode 100644 hw/virtio/vhost-user-snd-pci.c
 create mode 100644 hw/virtio/vhost-user-snd.c

-- 
2.39.2

