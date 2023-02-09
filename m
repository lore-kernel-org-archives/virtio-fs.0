Return-Path: <stefanha@redhat.com>
From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Thu,  9 Feb 2023 10:25:14 -0500
Message-Id: <20230209152520.434183-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PULL 0/6] Block patches
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>

The following changes since commit 417296c8d8588f782018d01a317f88957e9786d6:

  tests/qtest/netdev-socket: Raise connection timeout to 60 seconds (2023-02-09 11:23:53 +0000)

are available in the Git repository at:

  https://gitlab.com/stefanha/qemu.git tags/block-pull-request

for you to fetch changes up to acbc8aee5b09222dc6a5cb88306b67bcbe37e30b:

  iotests/detect-zeroes-registered-buf: add new test (2023-02-09 10:22:30 -0500)

----------------------------------------------------------------
Pull request

A few fixes that I've picked up.

----------------------------------------------------------------

Akihiko Odaki (1):
  vhost-user-fs: Back up vqs before cleaning up vhost_dev

Emanuele Giuseppe Esposito (1):
  virtio-blk: add missing AioContext lock

Stefan Hajnoczi (4):
  block: fix detect-zeroes= with BDRV_REQ_REGISTERED_BUF
  qemu-io: use BdrvRequestFlags instead of int
  qemu-io: add -r option to register I/O buffer
  iotests/detect-zeroes-registered-buf: add new test

 block/io.c                                    |   3 +
 hw/block/virtio-blk.c                         |   5 +
 hw/virtio/vhost-user-fs.c                     |   4 +-
 qemu-io-cmds.c                                | 215 +++++++++++-------
 .../tests/detect-zeroes-registered-buf        |  58 +++++
 .../tests/detect-zeroes-registered-buf.out    |   7 +
 6 files changed, 210 insertions(+), 82 deletions(-)
 create mode 100755 tests/qemu-iotests/tests/detect-zeroes-registered-buf
 create mode 100644 tests/qemu-iotests/tests/detect-zeroes-registered-buf.out

-- 
2.39.1

