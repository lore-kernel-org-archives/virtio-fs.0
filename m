Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed, 12 Jul 2023 13:16:58 +0200
Message-ID: <20230712111703.28031-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 0/4] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, German Maglione <gmaglione@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>

RFC:
https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html

v1:
https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html

Based-on: <20230711155230.64277-1-hreitz@redhat.com>
          (“[PATCH 0/6] vhost-user: Add suspend/resume”)
https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02450.html


Hi,

Most of the feedback on v1 focused on how to properly stop a device that
has internal state, both for the purpose of migration and just plainly
for VM stop/cont.  I hope this is resolved by my vhost-user
suspend/resume series, which this series here is based on (linked
above).

Therefore, these patches here for the actual state transfer have changed
only little since v1:

- I’ve removed the original patch 1 that would explicitly re-enable all
  vrings every time after using SET_FEATURES with
  VHOST_USER_F_PROTOCOL_FEATURES, replacing it with the stand-alone
  patch “[PATCH] vhost-user.rst: Clarify enabling/disabling vrings”
  (20230712091704.15589-1-hreitz@redhat.com), which does not change
  behavior but only documentation

- In its place, I’ve added a patch that adds documentation on the
  protocol additions.

- Patch 2: Drastically shortened the commit message, this documentation
  is now where it should be, namely in vhost-user.rst (added by patch
  1).  Also rebased on the “Add suspend/resume” series, which adds
  feature bits and vhost-user operations of its own.

- Patch 3: Instead of checking dev->started to see that the device is
  stopped, we might now want to check dev->suspended instead.  However,
  this is only set if the device actually supports suspending, so in
  fact we cannot use it.  Added documentation on this fact.
  (Dropped checking enable_vqs, because this variable had been added
  only by the old patch 1, which I dropped.)


Hanna Czenczek (4):
  vhost-user.rst: Migrating back-end-internal state
  vhost-user: Interface for migration state transfer
  vhost: Add high-level state save/load functions
  vhost-user-fs: Implement internal migration

 docs/interop/vhost-user.rst       |  87 +++++++++++
 include/hw/virtio/vhost-backend.h |  24 +++
 include/hw/virtio/vhost.h         | 114 ++++++++++++++
 hw/virtio/vhost-user-fs.c         | 101 ++++++++++++-
 hw/virtio/vhost-user.c            | 147 ++++++++++++++++++
 hw/virtio/vhost.c                 | 241 ++++++++++++++++++++++++++++++
 6 files changed, 713 insertions(+), 1 deletion(-)

-- 
2.41.0

