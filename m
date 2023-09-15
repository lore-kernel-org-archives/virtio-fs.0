Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Fri, 15 Sep 2023 12:25:25 +0200
Message-ID: <20230915102531.55894-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>

RFC:
https://lists.nongnu.org/archive/html/qemu-devel/2023-03/msg04263.html

v1:
https://lists.nongnu.org/archive/html/qemu-devel/2023-04/msg01575.html

v2:
https://lists.nongnu.org/archive/html/qemu-devel/2023-07/msg02604.html

Hi,

I’ve decided not to work on vhost-user SUSPEND/RESUME for now – it is
not technically required for virtio-fs migration, which is the actual
priority for me now.  While we do want to have SUSPEND/RESUME at some
point, the only practically existing reason for it is to be able to
implement vhost-level resetting in virtiofsd, but that is not related to
migration.

So one of the changes in v3 is that it no longer depends on the
vhost-user SUSPEND/RESUME series, and describes the migration protocol
without the device being suspended at any point, but merely that the
vrings are stopped.

Other changes include:

- Patch 1:
  - Rephrased a lot
  - Added a description for the VHOST_USER_SET_DEVICE_STATE_FD
    parameters
  - Renamed VHOST_USER_PROTOCOL_F_MIGRATORY_STATE to
    VHOST_USER_PROTOCOL_F_DEVICE_STATE
  - enum variants changed in value due to dropping the SUSPEND/RESUME
    dependency

- Patch 2:
  - Pulled in, was a stand-alone patch before
  - Dropped a sentence about ring state before feature negotiations, as
    the rings are not to be used during that period anyway
  - Bit of rephrasing

- Patch 3:
  - Renamed “migratory state” to “device state”
  - enum variants changed in value due to dropping the SUSPEND/RESUME
    dependency

- Patch 4:
  - Changed `f` to @f (referencing parameter “f”) in comments
  - Use g_autofree for the transfer buffer
  - Note SUSPEND state as a future feature, not currently existing
  - Wrap read() and write() in RETRY_ON_EINTR()

- Patch 5:
  - Renamed “migratory state” to “device state”
  - (kept R-b still)


Hanna Czenczek (5):
  vhost-user.rst: Migrating back-end-internal state
  vhost-user.rst: Clarify enabling/disabling vrings
  vhost-user: Interface for migration state transfer
  vhost: Add high-level state save/load functions
  vhost-user-fs: Implement internal migration

 docs/interop/vhost-user.rst       | 188 ++++++++++++++++++++++-
 include/hw/virtio/vhost-backend.h |  24 +++
 include/hw/virtio/vhost.h         | 114 ++++++++++++++
 hw/virtio/vhost-user-fs.c         | 101 ++++++++++++-
 hw/virtio/vhost-user.c            | 148 ++++++++++++++++++
 hw/virtio/vhost.c                 | 241 ++++++++++++++++++++++++++++++
 6 files changed, 810 insertions(+), 6 deletions(-)

-- 
2.41.0

