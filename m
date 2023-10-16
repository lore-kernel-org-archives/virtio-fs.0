Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 16 Oct 2023 15:42:36 +0200
Message-ID: <20231016134243.68248-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 0/7] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>

v2:
https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html

v3:
https://lists.nongnu.org/archive/html/qemu-devel/2023-09/msg03750.html

v4:
https://lists.nongnu.org/archive/html/qemu-devel/2023-10/msg01046.html


Based-on: <20231004014532.1228637-1-stefanha@redhat.com>
          ([PATCH v2 0/3] vhost: clean up device reset)

Based-on: <20231016083201.23736-1-hreitz@redhat.com>
          ([PATCH] vhost-user: Fix protocol feature bit conflict)


Hi,

v5 is basically the same as v4, only that I’ve dropped the patch
deprecating F_STATUS (which doesn’t affect the rest of the series), that
I’ve amended the documentation in patch 1 as suggested by Stefan and
with help from Michael, and that I’ve rebased everything on top of the
F_SHARED_OBJECT changes that have been merged upstream.


git-backport-diff against v4:

Key:
[----] : patches are identical
[####] : number of functional differences between upstream/downstream patch
[down] : patch is downstream-only
The flags [FC] indicate (F)unctional and (C)ontextual differences, respectively

001/7:[0029] [FC] 'vhost-user.rst: Improve [GS]ET_VRING_BASE doc'
002/7:[----] [--] 'vhost-user.rst: Clarify enabling/disabling vrings'
003/7:[----] [--] 'vhost-user.rst: Introduce suspended state'
004/7:[0006] [FC] 'vhost-user.rst: Migrating back-end-internal state'
005/7:[0007] [FC] 'vhost-user: Interface for migration state transfer'
006/7:[----] [--] 'vhost: Add high-level state save/load functions'
007/7:[----] [--] 'vhost-user-fs: Implement internal migration'


Changes patch by patch:
- Patch 1: Amended documentation
- Patches 4 and 5: Bumped feature bit and command values as necessary so
  as not to conflict with F_SHARED_OBJECT


Hanna Czenczek (7):
  vhost-user.rst: Improve [GS]ET_VRING_BASE doc
  vhost-user.rst: Clarify enabling/disabling vrings
  vhost-user.rst: Introduce suspended state
  vhost-user.rst: Migrating back-end-internal state
  vhost-user: Interface for migration state transfer
  vhost: Add high-level state save/load functions
  vhost-user-fs: Implement internal migration

 docs/interop/vhost-user.rst       | 301 ++++++++++++++++++++++++++++--
 include/hw/virtio/vhost-backend.h |  24 +++
 include/hw/virtio/vhost-user.h    |   1 +
 include/hw/virtio/vhost.h         | 113 +++++++++++
 hw/virtio/vhost-user-fs.c         | 101 +++++++++-
 hw/virtio/vhost-user.c            | 146 +++++++++++++++
 hw/virtio/vhost.c                 | 241 ++++++++++++++++++++++++
 7 files changed, 906 insertions(+), 21 deletions(-)

-- 
2.41.0

