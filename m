Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu, 20 Apr 2023 08:09:28 -0400
Message-Id: <20230420120948.436661-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 00/20] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Raphael Norwitz <raphael.norwitz@nutanix.com>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Julia Suvorova <jusual@redhat.com>, Eric Blake <eblake@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Thomas Huth <thuth@redhat.com>, qemu-block@nongnu.org, Cornelia Huck <cohuck@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Fam Zheng <fam@euphon.net>, Aarushi Mehta <mehta.aaru20@gmail.com>

The following changes since commit c1eb2ddf0f8075faddc5f7c3d39feae3e8e9d6b4:

  Update version for v8.0.0 release (2023-04-19 17:27:13 +0100)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 36e5e9b22abe56aa00ca067851555ad8127a7966:

  tracing: install trace events file only if necessary (2023-04-20 07:39:43 -0400)

----------------------------------------------------------------
Pull request

Sam Li's zoned storage work and fixes I collected during the 8.0 freeze.

----------------------------------------------------------------

Carlos Santos (1):
  tracing: install trace events file only if necessary

Philippe Mathieu-Daudé (1):
  block/dmg: Declare a type definition for DMG uncompress function

Sam Li (17):
  block/block-common: add zoned device structs
  block/file-posix: introduce helper functions for sysfs attributes
  block/block-backend: add block layer APIs resembling Linux
    ZonedBlockDevice ioctls
  block/raw-format: add zone operations to pass through requests
  block: add zoned BlockDriver check to block layer
  iotests: test new zone operations
  block: add some trace events for new block layer APIs
  docs/zoned-storage: add zoned device documentation
  file-posix: add tracking of the zone write pointers
  block: introduce zone append write for zoned devices
  qemu-iotests: test zone append operation
  block: add some trace events for zone append
  include: update virtio_blk headers to v6.3-rc1
  virtio-blk: add zoned storage emulation for zoned devices
  block: add accounting for zone append operation
  virtio-blk: add some trace events for zoned emulation
  docs/zoned-storage:add zoned emulation use case

Thomas De Schampheleire (1):
  tracetool: use relative paths for '#line' preprocessor directives

 docs/devel/index-api.rst                     |   1 +
 docs/devel/zoned-storage.rst                 |  62 ++
 qapi/block-core.json                         |  68 +-
 qapi/block.json                              |   4 +
 meson.build                                  |   4 +
 block/dmg.h                                  |   8 +-
 include/block/accounting.h                   |   1 +
 include/block/block-common.h                 |  57 ++
 include/block/block-io.h                     |  13 +
 include/block/block_int-common.h             |  37 +
 include/block/raw-aio.h                      |   8 +-
 include/standard-headers/drm/drm_fourcc.h    |  12 +
 include/standard-headers/linux/ethtool.h     |  48 +-
 include/standard-headers/linux/fuse.h        |  45 +-
 include/standard-headers/linux/pci_regs.h    |   1 +
 include/standard-headers/linux/vhost_types.h |   2 +
 include/standard-headers/linux/virtio_blk.h  | 105 +++
 include/sysemu/block-backend-io.h            |  27 +
 linux-headers/asm-arm64/kvm.h                |   1 +
 linux-headers/asm-x86/kvm.h                  |  34 +-
 linux-headers/linux/kvm.h                    |   9 +
 linux-headers/linux/vfio.h                   |  15 +-
 linux-headers/linux/vhost.h                  |   8 +
 block.c                                      |  19 +
 block/block-backend.c                        | 193 ++++++
 block/dmg.c                                  |   7 +-
 block/file-posix.c                           | 677 +++++++++++++++++--
 block/io.c                                   |  68 ++
 block/io_uring.c                             |   4 +
 block/linux-aio.c                            |   3 +
 block/qapi-sysemu.c                          |  11 +
 block/qapi.c                                 |  18 +
 block/raw-format.c                           |  26 +
 hw/block/virtio-blk-common.c                 |   2 +
 hw/block/virtio-blk.c                        | 405 +++++++++++
 hw/virtio/virtio-qmp.c                       |   2 +
 qemu-io-cmds.c                               | 224 ++++++
 block/trace-events                           |   4 +
 docs/system/qemu-block-drivers.rst.inc       |   6 +
 hw/block/trace-events                        |   7 +
 scripts/tracetool/backend/ftrace.py          |   4 +-
 scripts/tracetool/backend/log.py             |   4 +-
 scripts/tracetool/backend/syslog.py          |   4 +-
 tests/qemu-iotests/tests/zoned               | 105 +++
 tests/qemu-iotests/tests/zoned.out           |  69 ++
 trace/meson.build                            |   2 +-
 46 files changed, 2353 insertions(+), 81 deletions(-)
 create mode 100644 docs/devel/zoned-storage.rst
 create mode 100755 tests/qemu-iotests/tests/zoned
 create mode 100644 tests/qemu-iotests/tests/zoned.out

-- 
2.39.2

