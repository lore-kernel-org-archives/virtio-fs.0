Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed,  4 Oct 2023 14:58:56 +0200
Message-ID: <20231004125904.110781-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/8] vhost-user: Back-end state migration
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

RFC:
https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html

v1:
https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html

v2:
https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html

v3:
https://lists.nongnu.org/archive/html/qemu-devel/2023-09/msg03750.html


Based-on: <20231004014532.1228637-1-stefanha@redhat.com>
          ([PATCH v2 0/3] vhost: clean up device reset)


Hi,

This v4 includes largely unchanged patches from v3.  The main
addition/change is what came out of the discussion between Stefan and me
around how to proceed without SUSPEND/RESUME, which is that this series
is now based on his reset fix, and it includes more documentation
changes.

Changes in detail:

- Patch 1: Fall-out from the reset fix: Currently, the status byte is
  effectively unused (qemu only uses it for resetting, which all
  back-ends ignore; DPDK uses it to announce potential feature
  negotiation failure, which qemu ignores).  It is also not defined what
  exactly front-end or back-end should do with this byte, except
  pointing at the virtio spec, which however naturally does not say how
  this integrates with vhost-user’s RESET_DEVICE or [GS]ET_FEATURES.
  Furthermore, there does not seem to be a use for this; we have
  RESET_DEVICE for resetting, and we have [GS]ET_FEATURES (and
  REPLY_ACK, which can be used on SET_FEATURES) for feature
  negotation.
  Therefore, deprecate the status byte, pointing to those other commands
  instead.

- Patch 2: Patch 4 defines a suspended state for the whole back-end if
  all vrings are stopped.  I think this should be mentioned in
  GET_VRING_BASE, but upon trying to add it, I found that it does not
  even mention that it stops the vring (mentioned only in the Ring
  States section), and remembered that the whole description of both
  GET_VRING_BASE and SET_VRING_BASE really was not helpful when trying
  to implement a vhost-user back-end.  Took the opportunity to overhaul
  both.

- Patch 3: This one’s from v3, but quite heavily modified.  Stefan
  suggested consistently defining the started/stopped and
  enabled/disabled states to be independent, and indeed doing so
  simplifies a whole lot of stuff.  Specifically, it makes the magic
  “enabled/disabled when started” go away.  Basically, I found this
  change alone is enough to remove the confusion I had with the existing
  documentation.

- Patch 4: As suggested by Stefan, just define a suspended state without
  introducing SUSPEND.  vDPA needs SUSPEND because its GET_VRING_BASE
  does not stop the vring, but vhost-user’s does, so we can define the
  suspended state to be when all vrings are stopped.

- Patch 5: Reference the suspended state.

- Patches 6 through 8: Unmodified, except for them being rebase on
  Stefan’s series.


Hanna Czenczek (8):
  vhost-user.rst: Deprecate [GS]ET_STATUS
  vhost-user.rst: Improve [GS]ET_VRING_BASE doc
  vhost-user.rst: Clarify enabling/disabling vrings
  vhost-user.rst: Introduce suspended state
  vhost-user.rst: Migrating back-end-internal state
  vhost-user: Interface for migration state transfer
  vhost: Add high-level state save/load functions
  vhost-user-fs: Implement internal migration

 docs/interop/vhost-user.rst       | 318 +++++++++++++++++++++++++++---
 include/hw/virtio/vhost-backend.h |  24 +++
 include/hw/virtio/vhost.h         | 113 +++++++++++
 hw/virtio/vhost-user-fs.c         | 101 +++++++++-
 hw/virtio/vhost-user.c            | 148 ++++++++++++++
 hw/virtio/vhost.c                 | 241 ++++++++++++++++++++++
 6 files changed, 917 insertions(+), 28 deletions(-)

-- 
2.41.0

