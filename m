Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Wed,  4 Oct 2023 14:58:57 +0200
Message-ID: <20231004125904.110781-2-hreitz@redhat.com>
In-Reply-To: <20231004125904.110781-1-hreitz@redhat.com>
References: <20231004125904.110781-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 1/8] vhost-user.rst: Deprecate [GS]ET_STATUS
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

There is no clearly defined purpose for the virtio status byte in
vhost-user: For resetting, we already have RESET_DEVICE; and for virtio
feature negotiation, we have [GS]ET_FEATURES.  With the REPLY_ACK
protocol extension, it is possible for SET_FEATURES to return errors
(SET_PROTOCOL_FEATURES may be called before SET_FEATURES).

As for implementations, SET_STATUS is not widely implemented.  dpdk does
implement it, but only uses it to signal feature negotiation failure.
While it does log reset requests (SET_STATUS 0) as such, it effectively
ignores them, in contrast to RESET_OWNER (which is deprecated, and today
means the same thing as RESET_DEVICE).

While qemu superficially has support for [GS]ET_STATUS, it does not
forward the guest-set status byte, but instead just makes it up
internally, and actually completely ignores what the back-end returns,
only using it as the template for a subsequent SET_STATUS to add single
bits to it.  Notably, after setting FEATURES_OK, it never reads it back
to see whether the flag is still set, which is the only way in which
dpdk uses the status byte.

As-is, no front-end or back-end can rely on the other side handling this
field in a useful manner, and it also provides no practical use over
other mechanisms the vhost-user protocol has, which are more clearly
defined.  Deprecate it.

Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 5a070adbc1..2f68e67a1a 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1424,21 +1424,35 @@ Front-end message types
   :request payload: ``u64``
   :reply payload: N/A
 
-  When the ``VHOST_USER_PROTOCOL_F_STATUS`` protocol feature has been
-  successfully negotiated, this message is submitted by the front-end to
-  notify the back-end with updated device status as defined in the Virtio
+.. admonition:: Deprecated
+
+  This is no longer used. Used to be sent by the front-end to notify the
+  back-end with updated device status as defined in the Virtio
   specification.
 
+  However, its purpose in vhost-user was never well-defined; for
+  example, how or if it would replace VHOST_USER_RESET_DEVICE, or how it
+  integrates with the feature negotiation phase.  Therefore,
+  implementations in practice were less than strict in how the status
+  value was handled, which means there was actually no protocol between
+  front-end and back-end on the use of the status value.
+
+  For resetting, use VHOST_USER_RESET_DEVICE instead.  For feature
+  negotiation with acknowledgment from the device, use
+  VHOST_USER_SET_FEATURES with the :ref:`REPLY_ACK <reply_ack>` feature
+  instead.
+
 ``VHOST_USER_GET_STATUS``
   :id: 40
   :equivalent ioctl: VHOST_VDPA_GET_STATUS
   :request payload: N/A
   :reply payload: ``u64``
 
-  When the ``VHOST_USER_PROTOCOL_F_STATUS`` protocol feature has been
-  successfully negotiated, this message is submitted by the front-end to
-  query the back-end for its device status as defined in the Virtio
-  specification.
+.. admonition:: Deprecated
+
+  This is no longer used. Used to be sent by the front-end to query the
+  back-end for its device status as defined in the Virtio specification.
+  Deprecated together with VHOST_USER_SET_STATUS.
 
 
 Back-end message types
-- 
2.41.0

