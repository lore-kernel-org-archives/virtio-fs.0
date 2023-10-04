Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed,  4 Oct 2023 14:58:58 +0200
Message-ID: <20231004125904.110781-3-hreitz@redhat.com>
In-Reply-To: <20231004125904.110781-1-hreitz@redhat.com>
References: <20231004125904.110781-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 2/8] vhost-user.rst: Improve
 [GS]ET_VRING_BASE doc
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

GET_VRING_BASE does not mention that it stops the respective ring.  Fix
that.

Furthermore, it is not fully clear what the "base offset" these
commands' documentation refers to is; an offset could be many things.
Be more precise and verbose about it, especially given that these
commands use different payload structures depending on whether the vring
is split or packed.

Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 66 ++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 2f68e67a1a..50f5acebe5 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -108,6 +108,37 @@ A vring state description
 
 :num: a 32-bit number
 
+A vring descriptor index for split virtqueues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
++-------------+---------------------+
+| vring index | index in avail ring |
++-------------+---------------------+
+
+:vring index: 32-bit index of the respective virtqueue
+
+:index in avail ring: 32-bit value, of which currently only the lower 16
+  bits are used:
+
+  - Bits 0–15: Next descriptor index in the *Available Ring*
+  - Bits 16–31: Reserved (set to zero)
+
+Vring descriptor indices for packed virtqueues
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
++-------------+--------------------+
+| vring index | descriptor indices |
++-------------+--------------------+
+
+:vring index: 32-bit index of the respective virtqueue
+
+:descriptor indices: 32-bit value:
+
+  - Bits 0–14: Index in the *Available Ring*
+  - Bit 15: Driver (Available) Ring Wrap Counter
+  - Bits 16–30: Index in the *Used Ring*
+  - Bit 31: Device (Used) Ring Wrap Counter
+
 A vring address description
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
@@ -1031,18 +1062,45 @@ Front-end message types
 ``VHOST_USER_SET_VRING_BASE``
   :id: 10
   :equivalent ioctl: ``VHOST_SET_VRING_BASE``
-  :request payload: vring state description
+  :request payload: vring descriptor index/indices
   :reply payload: N/A
 
-  Sets the base offset in the available vring.
+  Sets the next index to use for descriptors in this vring:
+
+  * For a split virtqueue, sets only the next descriptor index in the
+    *Available Ring*.  The device is supposed to read the next index in
+    the *Used Ring* from the respective vring structure in guest memory.
+
+  * For a packed virtqueue, both indices are supplied, as they are not
+    explicitly available in memory.
+
+  Consequently, the payload type is specific to the type of virt queue
+  (*a vring descriptor index for split virtqueues* vs. *vring descriptor
+  indices for packed virtqueues*).
 
 ``VHOST_USER_GET_VRING_BASE``
   :id: 11
   :equivalent ioctl: ``VHOST_USER_GET_VRING_BASE``
   :request payload: vring state description
-  :reply payload: vring state description
+  :reply payload: vring descriptor index/indices
+
+  Stops the vring and returns the current descriptor index or indices:
+
+    * For a split virtqueue, returns only the 16-bit next descriptor
+      index in the *Available Ring*.  The index in the *Used Ring* is
+      controlled by the guest driver and can be read from the vring
+      structure in memory, so is not covered.
+
+    * For a packed virtqueue, neither index is explicitly available to
+      read from memory, so both indices (as maintained by the device) are
+      returned.
+
+  Consequently, the payload type is specific to the type of virt queue
+  (*a vring descriptor index for split virtqueues* vs. *vring descriptor
+  indices for packed virtqueues*).
 
-  Get the available vring base offset.
+  The request payload’s *num* field is currently reserved and must be
+  set to 0.
 
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
-- 
2.41.0

