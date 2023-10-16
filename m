Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 16 Oct 2023 15:42:37 +0200
Message-ID: <20231016134243.68248-2-hreitz@redhat.com>
In-Reply-To: <20231016134243.68248-1-hreitz@redhat.com>
References: <20231016134243.68248-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 1/7] vhost-user.rst: Improve
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
 docs/interop/vhost-user.rst | 77 +++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 4 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 768fb5c28c..9202b167dd 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -108,6 +108,43 @@ A vring state description
 
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
+  - Bits 0–15: Index of the next *Available Ring* descriptor that the
+    back-end will process.  This is a free-running index that is not
+    wrapped by the ring size.
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
+  - Bits 0–14: Index of the next *Available Ring* descriptor that the
+    back-end will process.  This is a free-running index that is not
+    wrapped by the ring size.
+  - Bit 15: Driver (Available) Ring Wrap Counter
+  - Bits 16–30: Index of the entry in the *Used Ring* where the back-end
+    will place the next descriptor.  This is a free-running index that
+    is not wrapped by the ring size.
+  - Bit 31: Device (Used) Ring Wrap Counter
+
 A vring address description
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
@@ -1042,18 +1079,50 @@ Front-end message types
 ``VHOST_USER_SET_VRING_BASE``
   :id: 10
   :equivalent ioctl: ``VHOST_SET_VRING_BASE``
-  :request payload: vring state description
+  :request payload: vring descriptor index/indices
   :reply payload: N/A
 
-  Sets the base offset in the available vring.
+  Sets the next index to use for descriptors in this vring:
+
+  * For a split virtqueue, sets only the next descriptor index to
+    process in the *Available Ring*.  The device is supposed to read the
+    next index in the *Used Ring* from the respective vring structure in
+    guest memory.
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
+      index to process in the *Available Ring*.  Note that this may
+      differ from the available ring index in the vring structure in
+      memory, which points to where the driver will put new available
+      descriptors.  For the *Used Ring*, the device only needs the next
+      descriptor index at which to put new descriptors, which is the
+      value in the vring structure in memory, so this value is not
+      covered by this message.
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

