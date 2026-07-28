Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D268420E98
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 10:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785233447; cv=none; b=Ks3Ls/PkIeAQTZBr1XyB3NRg7AloxffPWJS7/sA55Rn08vExOZiWeV7x2d39h0tKwfwcy/yicJzy4vFjm85taLhIya3MX0Ldmh6ry0JcCIYS+PMjV7zlpbdZGc28L0xI6xAFdREnVPql7EL44wJ0X1JW0jkoIYc7mVql/J9VXyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785233447; c=relaxed/simple;
	bh=4cP+giig872HCQeQyrodmOhHy6fFx78UE2JxOx7XDNM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kmt2FK18XsST5ubue5cjuR9UPapWbOiZUojBy+b3dWG2nkSw0X8YCELF7y9Jsrt37PlyeiQGhRrBtEs76vtH3D7HoucxSZLhGy2bxyKHYJgVf1UuaXpseGt+3b4W/YlLeQ1n/tp0sOfH8Qrn7LDP/d/XK+XeBK1wRUAqLupjXmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=kpRlJkp0; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="kpRlJkp0"
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id 5B10EC09A0;
	Tue, 28 Jul 2026 13:08:52 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:803e:400:f26c:359c:adc2:62a4])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id f8aui7IXWGk0-mETG2frB;
	Tue, 28 Jul 2026 13:08:51 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785233331;
	bh=2ofHAlBRqUw86v+y3/fUKnHqiDrlLNFwkDvsZs0prGA=;
	h=Cc:Message-Id:References:Date:In-Reply-To:Subject:To:From;
	b=kpRlJkp0U8fNvE1HHOyDNgq/yoGiJUtQA6wf5gi6WzaqEwrgbBoAffQ75wZGJIQ7Y
	 ylRJWTum1oBmppoCCJ2jzoRjTZ5abu8N/y60DdYJt0HKK1oBrcyw1atT0NwCEgSHzk
	 pcofPAIGl7iXx00ICdIrc0SLtik3FrZsAtZLBXug=
Authentication-Results: mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	qemu-block@nongnu.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	virtio-fs@lists.linux.dev,
	Kevin Wolf <kwolf@redhat.com>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v5 2/6] vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
Date: Tue, 28 Jul 2026 15:08:37 +0500
Message-Id: <20260728100841.3475774-3-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT was introduced to allow
the back-end to suspend in-flight I/O during GET_VRING_BASE instead of
draining it, enabling live migration of in-flight requests. However,
this behaviour is tied to the protocol feature itself — once negotiated,
there is no way for the front-end to tell the back-end to fall back to
the normal drain behaviour on a per-stop basis. This makes it impossible
to selectively use suspend semantics only during live migration while
keeping drain semantics in other cases.

Introduce a separate message VHOST_USER_GET_VRING_BASE_SKIP_DRAIN (id=45)
guarded by a new protocol feature
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN. The message is identical
to GET_VRING_BASE except that the back-end must immediately suspend all
in-flight I/O and record it in the inflight region. This way the front-end
has explicit per-call control: send GET_VRING_BASE for normal drain, send
GET_VRING_BASE_SKIP_DRAIN when immediate suspend is needed.

The new feature requires both VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT
and VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD to be negotiated.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst       | 88 +++++++++++++++++++------------
 hw/virtio/vhost-user.c            | 44 ++++++++++++++--
 hw/virtio/vhost.c                 |  2 +-
 include/hw/virtio/vhost-backend.h |  1 +
 include/hw/virtio/vhost-user.h    |  1 +
 5 files changed, 95 insertions(+), 41 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index c83ae2accb..d2e0efaeaa 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -445,6 +445,7 @@ replies, except for the following requests:
 * ``VHOST_USER_GET_FEATURES``
 * ``VHOST_USER_GET_PROTOCOL_FEATURES``
 * ``VHOST_USER_GET_VRING_BASE``
+* ``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN``
 * ``VHOST_USER_SET_LOG_BASE`` (if ``VHOST_USER_PROTOCOL_F_LOG_SHMFD``)
 * ``VHOST_USER_GET_INFLIGHT_FD`` (if ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD``)
 
@@ -523,7 +524,7 @@ must start a ring upon receiving a kick (that is, detecting that file
 descriptor is readable) on the descriptor specified by
 ``VHOST_USER_SET_VRING_KICK`` or receiving the in-band message
 ``VHOST_USER_VRING_KICK`` if negotiated, and stop a ring upon receiving
-``VHOST_USER_GET_VRING_BASE``.
+``VHOST_USER_GET_VRING_BASE`` or ``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN``.
 
 Rings can be enabled or disabled by ``VHOST_USER_SET_VRING_ENABLE``.
 
@@ -1101,29 +1102,30 @@ Protocol features
 
 .. code:: c
 
-  #define VHOST_USER_PROTOCOL_F_MQ                       0
-  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD                1
-  #define VHOST_USER_PROTOCOL_F_RARP                     2
-  #define VHOST_USER_PROTOCOL_F_REPLY_ACK                3
-  #define VHOST_USER_PROTOCOL_F_MTU                      4
-  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ              5
-  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN             6
-  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION           7
-  #define VHOST_USER_PROTOCOL_F_PAGEFAULT                8
-  #define VHOST_USER_PROTOCOL_F_CONFIG                   9
-  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD         10
-  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER           11
-  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD          12
-  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE            13
-  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS    14
-  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS     15
-  #define VHOST_USER_PROTOCOL_F_STATUS                  16
-  #define VHOST_USER_PROTOCOL_F_XEN_MMAP                17
-  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT           18
-  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE            19
-  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT 20
-  #define VHOST_USER_PROTOCOL_F_GPA_ADDRESSES           21
-  #define VHOST_USER_PROTOCOL_F_SHMEM_MAP               22
+  #define VHOST_USER_PROTOCOL_F_MQ                         0
+  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD                  1
+  #define VHOST_USER_PROTOCOL_F_RARP                       2
+  #define VHOST_USER_PROTOCOL_F_REPLY_ACK                  3
+  #define VHOST_USER_PROTOCOL_F_MTU                        4
+  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ                5
+  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN               6
+  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION             7
+  #define VHOST_USER_PROTOCOL_F_PAGEFAULT                  8
+  #define VHOST_USER_PROTOCOL_F_CONFIG                     9
+  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD           10
+  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER             11
+  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD            12
+  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE              13
+  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS      14
+  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS       15
+  #define VHOST_USER_PROTOCOL_F_STATUS                    16
+  #define VHOST_USER_PROTOCOL_F_XEN_MMAP                  17
+  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT             18
+  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE              19
+  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT   20
+  #define VHOST_USER_PROTOCOL_F_GPA_ADDRESSES             21
+  #define VHOST_USER_PROTOCOL_F_SHMEM_MAP                 22
+  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN 23
 
 Front-end message types
 -----------------------
@@ -1320,17 +1322,11 @@ Front-end message types
   set to 0.
 
   By default, the back-end must complete all inflight I/O requests for the
-  specified vring before stopping it.
-
-  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
-  feature has been negotiated, the back-end may suspend in-flight I/O
-  requests and record them as described in :ref:`Inflight I/O tracking
-  <inflight_io_tracking>` instead of completing them before stopping the vring.
-  How to suspend an in-flight request depends on the implementation of the back-end
-  but it typically can be done by aborting or cancelling the underlying I/O
-  request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
-  protocol feature must only be negotiated if
-  ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.
+  specified vring before stopping it. If the
+  ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN`` protocol feature has
+  been negotiated, the front-end may instead use
+  ``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN`` to request the back-end to
+  suspend in-flight I/O immediately.
 
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
@@ -1833,6 +1829,28 @@ Front-end message types
 
   * The size may be 0 if the region is unused.
 
+``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN``
+  :id: 45
+  :equivalent ioctl: N/A
+  :request payload: vring state description
+  :reply payload: vring descriptor index/indices
+
+  This message requires the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN``
+  protocol feature to be negotiated.
+
+  Identical to ``VHOST_USER_GET_VRING_BASE`` except that the back-end
+  must not wait for inflight I/O requests to complete before stopping
+  the vring.  Instead, the back-end must immediately suspend all
+  in-flight I/O requests and record them as described in
+  :ref:`Inflight I/O tracking <inflight_io_tracking>`. How to suspend
+  an in-flight request depends on the implementation of the back-end,
+  but it typically can be done by aborting or cancelling the underlying
+  I/O request.
+
+  The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN`` protocol feature
+  must only be negotiated if both ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
+  and ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` are also negotiated.
+
 Back-end message types
 ----------------------
 
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index d627351f45..bf455daa44 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -101,6 +101,7 @@ typedef enum VhostUserRequest {
     VHOST_USER_SET_DEVICE_STATE_FD = 42,
     VHOST_USER_CHECK_DEVICE_STATE = 43,
     VHOST_USER_GET_SHMEM_CONFIG = 44,
+    VHOST_USER_GET_VRING_BASE_SKIP_DRAIN = 45,
     VHOST_USER_MAX
 } VhostUserRequest;
 
@@ -167,6 +168,7 @@ static const char *vhost_req_name(VhostUserRequest req)
     VHOST_USER_CASE(GET_SHARED_OBJECT)
     VHOST_USER_CASE(SET_DEVICE_STATE_FD)
     VHOST_USER_CASE(CHECK_DEVICE_STATE)
+    VHOST_USER_CASE(GET_VRING_BASE_SKIP_DRAIN)
     default:
         return "<unknown>";
     }
@@ -1399,12 +1401,18 @@ static VhostUserHostNotifier *fetch_notifier(VhostUserState *u,
     return g_ptr_array_index(u->notifiers, idx);
 }
 
-static int vhost_user_get_vring_base(struct vhost_dev *dev,
-                                     struct vhost_vring_state *ring)
+static int get_vring_base(struct vhost_dev *dev,
+                          struct vhost_vring_state *ring,
+                          bool skip_drain)
 {
     int ret;
+    int request = VHOST_USER_GET_VRING_BASE;
+    if (skip_drain) {
+        request = VHOST_USER_GET_VRING_BASE_SKIP_DRAIN;
+    }
+
     VhostUserMsg msg = {
-        .hdr.request = VHOST_USER_GET_VRING_BASE,
+        .hdr.request = request,
         .hdr.flags = VHOST_USER_VERSION,
         .payload.state = *ring,
         .hdr.size = sizeof(msg.payload.state),
@@ -1424,9 +1432,9 @@ static int vhost_user_get_vring_base(struct vhost_dev *dev,
         return ret;
     }
 
-    if (msg.hdr.request != VHOST_USER_GET_VRING_BASE) {
+    if (msg.hdr.request != request) {
         error_report("Received unexpected msg type. Expected %d received %d",
-                     VHOST_USER_GET_VRING_BASE, msg.hdr.request);
+                     request, msg.hdr.request);
         return -EPROTO;
     }
 
@@ -1440,6 +1448,25 @@ static int vhost_user_get_vring_base(struct vhost_dev *dev,
     return 0;
 }
 
+static int vhost_user_get_vring_base(struct vhost_dev *dev,
+                                     struct vhost_vring_state *ring)
+{
+    return get_vring_base(dev, ring, false);
+}
+
+static int vhost_user_get_vring_base_skip_drain(struct vhost_dev *dev,
+                                     struct vhost_vring_state *ring)
+{
+    bool skip_drain_supported = vhost_user_has_protocol_feature(dev,
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN);
+
+    if (!skip_drain_supported) {
+        return 0;
+    }
+
+    return get_vring_base(dev, ring, true);
+}
+
 static int vhost_set_vring_file(struct vhost_dev *dev,
                                 VhostUserRequest request,
                                 struct vhost_vring_file *file)
@@ -2551,6 +2578,12 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
         }
 
+        if (!virtio_has_feature(protocol_features,
+                                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT)) {
+            protocol_features &= ~(1ULL <<
+                             VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN);
+        }
+
         /* final set of protocol features */
         u->protocol_features = protocol_features;
         err = vhost_user_set_protocol_features(dev, u->protocol_features);
@@ -3409,6 +3442,7 @@ const VhostOps user_ops = {
         .vhost_set_vring_num = vhost_user_set_vring_num,
         .vhost_set_vring_base = vhost_user_set_vring_base,
         .vhost_get_vring_base = vhost_user_get_vring_base,
+        .vhost_get_vring_base_skip_drain = vhost_user_get_vring_base_skip_drain,
         .vhost_set_vring_kick = vhost_user_set_vring_kick,
         .vhost_set_vring_call = vhost_user_set_vring_call,
         .vhost_set_vring_err = vhost_user_set_vring_err,
diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
index 2a62550222..2c7f464d55 100644
--- a/hw/virtio/vhost.c
+++ b/hw/virtio/vhost.c
@@ -1502,7 +1502,7 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
 {
     if (skip_drain) {
         assert(vhost_user_has_protocol_feature(dev,
-               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
+               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN));
     }
     int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
     struct vhost_vring_state state = {
diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
index d878d7b733..daa979a1aa 100644
--- a/include/hw/virtio/vhost-backend.h
+++ b/include/hw/virtio/vhost-backend.h
@@ -190,6 +190,7 @@ typedef struct VhostOps {
     vhost_set_vring_num_op vhost_set_vring_num;
     vhost_set_vring_base_op vhost_set_vring_base;
     vhost_get_vring_base_op vhost_get_vring_base;
+    vhost_get_vring_base_op vhost_get_vring_base_skip_drain;
     vhost_set_vring_kick_op vhost_set_vring_kick;
     vhost_set_vring_call_op vhost_set_vring_call;
     vhost_set_vring_err_op vhost_set_vring_err;
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index 06c360af18..47c13f8677 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -36,6 +36,7 @@ enum VhostUserProtocolFeature {
     VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT = 20,
     VHOST_USER_PROTOCOL_F_GPA_ADDRESSES = 21,
     VHOST_USER_PROTOCOL_F_SHMEM = 22,
+    VHOST_USER_PROTOCOL_F_GET_VRING_BASE_SKIP_DRAIN = 23,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
-- 
2.34.1

