Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 15 Jun 2022 16:51:11 +0100
Message-Id: <20220615155129.1025811-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 00/18] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Thomas Huth <thuth@redhat.com>, Jagannathan Raman <jag.raman@oracle.com>, Aarushi Mehta <mehta.aaru20@gmail.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>, Elena Ufimtseva <elena.ufimtseva@oracle.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Stefan Hajnoczi <stefanha@redhat.com>, Laurent Vivier <lvivier@redhat.com>, qemu-block@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Richard Henderson <richard.henderson@linaro.org>, virtio-fs@redhat.com, Hanna Reitz <hreitz@redhat.com>, David Hildenbrand <david@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>, Beraldo Leal <bleal@redhat.com>, Peter Xu <peterx@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Qiuhao Li <Qiuhao.Li@outlook.com>, Paolo Bonzini <pbonzini@redhat.com>, Markus Armbruster <armbru@redhat.com>, Bandan Das <bsd@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Alexander Bulekov <alxndr@bu.edu>, Julia Suvorova <jusual@redhat.com>, Darren Kenny <darren.kenny@oracle.com>, Wainer dos Santos Moschetta <wainersm@redhat.com>, John G Johnson <john.g.johnson@oracle.com>

The following changes since commit 8e6c70b9d4a1b1f3011805947925cfdb31642f7f:

  Merge tag 'kraxel-20220614-pull-request' of git://git.kraxel.org/qemu into staging (2022-06-14 06:21:46 -0700)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to 99b969fbe105117f5af6060d3afef40ca39cc9c1:

  linux-aio: explain why max batch is checked in laio_io_unplug() (2022-06-15 16:43:42 +0100)

----------------------------------------------------------------
Pull request

This pull request includes an important aio=native I/O stall fix, the
experimental vifo-user server, the io_uring_register_ring_fd() optimization for
aio=io_uring, and an update to Vladimir Sementsov-Ogievskiy's maintainership
details.

----------------------------------------------------------------

Jagannathan Raman (14):
  qdev: unplug blocker for devices
  remote/machine: add HotplugHandler for remote machine
  remote/machine: add vfio-user property
  vfio-user: build library
  vfio-user: define vfio-user-server object
  vfio-user: instantiate vfio-user context
  vfio-user: find and init PCI device
  vfio-user: run vfio-user context
  vfio-user: handle PCI config space accesses
  vfio-user: IOMMU support for remote device
  vfio-user: handle DMA mappings
  vfio-user: handle PCI BAR accesses
  vfio-user: handle device interrupts
  vfio-user: handle reset of remote device

Sam Li (1):
  Use io_uring_register_ring_fd() to skip fd operations

Stefan Hajnoczi (2):
  linux-aio: fix unbalanced plugged counter in laio_io_unplug()
  linux-aio: explain why max batch is checked in laio_io_unplug()

Vladimir Sementsov-Ogievskiy (1):
  MAINTAINERS: update Vladimir's address and repositories

 MAINTAINERS                             |  27 +-
 meson_options.txt                       |   2 +
 qapi/misc.json                          |  31 +
 qapi/qom.json                           |  20 +-
 configure                               |  17 +
 meson.build                             |  24 +-
 include/exec/memory.h                   |   3 +
 include/hw/pci/msi.h                    |   1 +
 include/hw/pci/msix.h                   |   1 +
 include/hw/pci/pci.h                    |  13 +
 include/hw/qdev-core.h                  |  29 +
 include/hw/remote/iommu.h               |  40 +
 include/hw/remote/machine.h             |   4 +
 include/hw/remote/vfio-user-obj.h       |   6 +
 block/io_uring.c                        |  12 +-
 block/linux-aio.c                       |  10 +-
 hw/core/qdev.c                          |  24 +
 hw/pci/msi.c                            |  49 +-
 hw/pci/msix.c                           |  35 +-
 hw/pci/pci.c                            |  13 +
 hw/remote/iommu.c                       | 131 ++++
 hw/remote/machine.c                     |  88 ++-
 hw/remote/vfio-user-obj.c               | 958 ++++++++++++++++++++++++
 softmmu/physmem.c                       |   4 +-
 softmmu/qdev-monitor.c                  |   4 +
 stubs/vfio-user-obj.c                   |   6 +
 tests/qtest/fuzz/generic_fuzz.c         |   9 +-
 .gitlab-ci.d/buildtest.yml              |   1 +
 .gitmodules                             |   3 +
 Kconfig.host                            |   4 +
 hw/remote/Kconfig                       |   4 +
 hw/remote/meson.build                   |   4 +
 hw/remote/trace-events                  |  11 +
 scripts/meson-buildoptions.sh           |   4 +
 stubs/meson.build                       |   1 +
 subprojects/libvfio-user                |   1 +
 tests/docker/dockerfiles/centos8.docker |   2 +
 37 files changed, 1565 insertions(+), 31 deletions(-)
 create mode 100644 include/hw/remote/iommu.h
 create mode 100644 include/hw/remote/vfio-user-obj.h
 create mode 100644 hw/remote/iommu.c
 create mode 100644 hw/remote/vfio-user-obj.c
 create mode 100644 stubs/vfio-user-obj.c
 create mode 160000 subprojects/libvfio-user

-- 
2.36.1

