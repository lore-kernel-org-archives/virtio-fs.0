Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 13 Mar 2023 18:48:31 +0100
Message-Id: <20230313174833.28790-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [RFC 0/2] vhost-user-fs: Stateful migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: Hanna Czenczek <hreitz@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

Hi,

Patch 1 of this RFC series adds virtio-fs-specific operations to vhost
for transferring a binary blob of back-end-internal state, and
implements those for vhost-user.

Patch 2 uses those operations to implement stateful migration for
vhost-user-fs devices, assuming the back-end (virtiofsd) supports it.

This is an RFC for multiple reasons, most notably:
- Patch 1 proposes yet undiscussed changes to the vhost protocol, which
  makes it RFC by default.
- Without much experience in the fields of migration or vhost (on the
  qemu side), I hope marking this as an RFC leads to extra scrutiny on
  the reviewer���s side. O:)


Hanna Czenczek (2):
  vhost-user: Add interface for virtio-fs migration
  vhost-user-fs: Implement stateful migration

 include/hw/virtio/vhost-backend.h |   9 ++
 include/hw/virtio/vhost.h         |  68 ++++++++++++
 hw/virtio/vhost-user-fs.c         | 171 +++++++++++++++++++++++++++++-
 hw/virtio/vhost-user.c            | 138 ++++++++++++++++++++++++
 hw/virtio/vhost.c                 |  29 +++++
 5 files changed, 414 insertions(+), 1 deletion(-)

-- 
2.39.1

