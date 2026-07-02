Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD51F42E8DA
	for <virtio-fs@lists.linux.dev>; Thu,  2 Jul 2026 09:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782983546; cv=none; b=SSCpZL60J0kyOGHe8b88fKI71z6NdK+HJhTvAN7tuP3PbQEaVSeeklDZfE6N70HGak7f0m/VZeCVt2p4xZ8ah7wZshOgVfHPuAwULncZ3IeHeRu9soIcTD5ol9QddmbiiYhjWXcGn/psQY27T7oCH5j+Lmylj13TWcElwUfbc1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782983546; c=relaxed/simple;
	bh=pghVvEkXUUJE8h2nnJJm2LIXWJoIvkxtkwdjT1O1fRE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QqPZbo06uQQEJAbpR1sG+xC1rFmS/kKAHWu0yAEsbw3gxkeUTQ8W2bHYLy65ltODOTqgb2h3xIQWE54KNbLhUVytvJ0HphGCJzEjVqUZoTbjOa8tVi51TIa95fU90qFQc6VvAEfa0lvQwG/QpnAuR8ljZpCuxoK+oukTlPPYgog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=j/01m5Ou; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="j/01m5Ou"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (postfix) with ESMTPS id 874618087D;
	Thu, 02 Jul 2026 12:10:49 +0300 (MSK)
Received: from dtalexundeer-nx.yandex-team.ru (unknown [2a02:6bf:8080:43d::1:15])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp) with ESMTPSA id NAc7BT0aDa60-ezx5JdH6;
	Thu, 02 Jul 2026 12:10:48 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1782983448;
	bh=lj0fFK5AhG9LHkzhPaiC8w4sWVpibJuTZ9SZRklkXqU=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=j/01m5OuZUxzsUsbXM3GgtVbhMWn/AK15r9HyHYPem6eR+CuZm8FZOzxQyUHgRHI0
	 pH5RPgygsSw9mSEUfA6hk8OVHjz6mwTJJugNfi8sHKzamraUYnwxsG4AGo0Z5EISy1
	 Sp5kjmy6JXRvRNakyZkgcMyuY8gETrxtTL39umNU=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowangio@gmail.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	zhenwei pi <zhenwei.pi@linux.dev>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	virtio-fs@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	qemu-block@nongnu.org,
	Raphael Norwitz <rnorwitz@nvidia.com>,
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v4 2/6] vhost-user: add GET_VRING_BASE_SKIP_DRAIN message
Date: Thu,  2 Jul 2026 14:10:19 +0500
Message-Id: <20260702091023.3306378-3-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
References: <20260702091023.3306378-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add VHOST_USER_GET_VRING_BASE_SKIP_DRAIN protocol message that's tell backend to stops
vring immediately without waiting for inflight I/O to complete.
This new message can be used only with protocol feature
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHGT.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst       | 38 +++++++++++++++++++++----------
 hw/virtio/vhost-user.c            | 37 ++++++++++++++++++++++++++----
 include/hw/virtio/vhost-backend.h |  1 +
 3 files changed, 59 insertions(+), 17 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index c83ae2accb..27a80ae53b 100644
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
 
@@ -1320,17 +1321,8 @@ Front-end message types
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
+  specified vring before stopping it. In other case use,
+  ``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN`` message.
 
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
@@ -1833,6 +1825,28 @@ Front-end message types
 
   * The size may be 0 if the region is unused.
 
+``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN``
+  :id: 45
+  :equivalent ioctl: ``VHOST_USER_GET_VRING_BASE_SKIP_DRAIN``
+  :request payload: vring state description
+  :reply payload: vring descriptor index/indices
+
+  This message requires the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
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
+  The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol feature
+  must only be negotiated if ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is
+  also negotiated.
+
 Back-end message types
 ----------------------
 
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index d627351f45..2f71ede599 100644
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
 
@@ -1440,6 +1448,24 @@ static int vhost_user_get_vring_base(struct vhost_dev *dev,
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
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
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
@@ -3409,6 +3435,7 @@ const VhostOps user_ops = {
         .vhost_set_vring_num = vhost_user_set_vring_num,
         .vhost_set_vring_base = vhost_user_set_vring_base,
         .vhost_get_vring_base = vhost_user_get_vring_base,
+        .vhost_get_vring_base_skip_drain = vhost_user_get_vring_base_skip_drain,
         .vhost_set_vring_kick = vhost_user_set_vring_kick,
         .vhost_set_vring_call = vhost_user_set_vring_call,
         .vhost_set_vring_err = vhost_user_set_vring_err,
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
-- 
2.34.1

