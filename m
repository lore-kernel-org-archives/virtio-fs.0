Return-Path: <hreitz@redhat.com>
From: Hanna Czenczek <hreitz@redhat.com>
Date: Fri, 15 Sep 2023 12:25:27 +0200
Message-ID: <20230915102531.55894-3-hreitz@redhat.com>
In-Reply-To: <20230915102531.55894-1-hreitz@redhat.com>
References: <20230915102531.55894-1-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 2/5] vhost-user.rst: Clarify
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
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>

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

We should clarify this in the documentation.

Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
---
 docs/interop/vhost-user.rst | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index bb4dd0fd60..9b9b802c60 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -409,12 +409,20 @@ and stop ring upon receiving ``VHOST_USER_GET_VRING_BASE``.
 
 Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
 
-If ``VHOST_USER_F_PROTOCOL_FEATURES`` has not been negotiated, the
-ring starts directly in the enabled state.
-
-If ``VHOST_USER_F_PROTOCOL_FEATURES`` has been negotiated, the ring is
-initialized in a disabled state and is enabled by
-``VHOST_USER_SET_VRING_ENABLE`` with parameter 1.
+If ``VHOST_USER_SET_FEATURES`` does not negotiate
+``VHOST_USER_F_PROTOCOL_FEATURES``, rings are enabled immediately when
+started.
+
+If ``VHOST_USER_SET_FEATURES`` does negotiate
+``VHOST_USER_F_PROTOCOL_FEATURES``, each ring will remain in the disabled
+state until ``VHOST_USER_SET_VRING_ENABLE`` enables it with parameter 1.
+
+Back-end implementations that support ``VHOST_USER_F_PROTOCOL_FEATURES``
+should implement this by initializing each ring in a disabled state, and
+enabling them when ``VHOST_USER_SET_FEATURES`` is used without
+negotiating ``VHOST_USER_F_PROTOCOL_FEATURES``.  Other than that, rings
+should only be enabled and disabled through
+``VHOST_USER_SET_VRING_ENABLE``.
 
 While processing the rings (whether they are enabled or not), the back-end
 must support changing some configuration aspects on the fly.
-- 
2.41.0

