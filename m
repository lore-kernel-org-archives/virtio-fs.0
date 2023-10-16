Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Mon, 16 Oct 2023 15:42:38 +0200
Message-ID: <20231016134243.68248-3-hreitz@redhat.com>
In-Reply-To: <20231016134243.68248-1-hreitz@redhat.com>
References: <20231016134243.68248-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v5 2/7] vhost-user.rst: Clarify
 enabling/disabling vrings
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

Currently, the vhost-user documentation says that rings are to be
initialized in a disabled state when VHOST_USER_F_PROTOCOL_FEATURES is
negotiated.  However, by the time of feature negotiation, all rings have
already been initialized, so it is not entirely clear what this means.

At least the vhost-user-backend Rust crate's implementation interpreted
it to mean that whenever this feature is negotiated, all rings are to
put into a disabled state, which means that every SET_FEATURES call
would disable all rings, effectively halting the device.  This is
problematic because the VHOST_F_LOG_ALL feature is also set or cleared
this way, which happens during migration.  Doing so should not halt the
device.

Other implementations have interpreted this to mean that the device is
to be initialized with all rings disabled, and a subsequent SET_FEATURES
call that does not set VHOST_USER_F_PROTOCOL_FEATURES will enable all of
them.  Here, SET_FEATURES will never disable any ring.

This interpretation does not suffer the problem of unintentionally
halting the device whenever features are set or cleared, so it seems
better and more reasonable.

We can clarify this in the documentation by making it explicit that the
enabled/disabled state is tracked even while the vring is stopped.
Every vring is initialized in a disabled state, and SET_FEATURES without
VHOST_USER_F_PROTOCOL_FEATURES simply becomes one way to enable all
vrings.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 9202b167dd..e5a04c04ed 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -411,31 +411,33 @@ negotiation.
 Ring states
 -----------
 
-Rings can be in one of three states:
+Rings have two independent states: started/stopped, and enabled/disabled.
 
-* stopped: the back-end must not process the ring at all.
+* While a ring is stopped, the back-end must not process the ring at
+  all, regardless of whether it is enabled or disabled.  The
+  enabled/disabled state should still be tracked, though, so it can come
+  into effect once the ring is started.
 
-* started but disabled: the back-end must process the ring without
+* started and disabled: The back-end must process the ring without
   causing any side effects.  For example, for a networking device,
   in the disabled state the back-end must not supply any new RX packets,
   but must process and discard any TX packets.
 
-* started and enabled.
+* started and enabled: The back-end must process the ring normally, i.e.
+  process all requests and execute them.
 
-Each ring is initialized in a stopped state.  The back-end must start
-ring upon receiving a kick (that is, detecting that file descriptor is
-readable) on the descriptor specified by ``VHOST_USER_SET_VRING_KICK``
-or receiving the in-band message ``VHOST_USER_VRING_KICK`` if negotiated,
-and stop ring upon receiving ``VHOST_USER_GET_VRING_BASE``.
+Each ring is initialized in a stopped and disabled state.  The back-end
+must start a ring upon receiving a kick (that is, detecting that file
+descriptor is readable) on the descriptor specified by
+``VHOST_USER_SET_VRING_KICK`` or receiving the in-band message
+``VHOST_USER_VRING_KICK`` if negotiated, and stop a ring upon receiving
+``VHOST_USER_GET_VRING_BASE``.
 
 Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
 
-If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
-ring starts directly in the enabled state.
-
-If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
-initialized in a disabled state and is enabled by
-``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
+In addition, upon receiving a ``VHOST_USER_SET_FEATURES`` message from
+the front-end without ``VHOST_USER_F_PROTOCOL_FEATURES`` set, the
+back-end must enable all rings immediately.
 
 While processing the rings (whether they are enabled or not), the back-end
 must support changing some configuration aspects on the fly.
-- 
2.41.0

