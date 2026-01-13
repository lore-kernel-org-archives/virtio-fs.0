Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DF0378D96
	for <virtio-fs@lists.linux.dev>; Tue, 13 Jan 2026 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768298328; cv=none; b=L+/tmsMhT08IQMq2GHoqJEvTKZ0D3+Gc62xJnBOnvtPfiGJZZP1OHeFbvfNILlABTmkH5Yx9fh4E1oBmAf0MnqhygL8hJrpVU69iGaAq1BGY4Dm5jlDVdWaY7PVLekGLFJh4blvvFMBSW0uN9NoI0y6AgSjLI8U7F0Kf6fp/vjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768298328; c=relaxed/simple;
	bh=+lCNPZrE7G2s660MOFfr1w3nK1evbPDeKLeEpuyh8KI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AnSeisHv8DXK8orArPFIQAKyvdgzgkhhcl2SfuG1MvwbW1W5b5EsqeWa9hZX9OhOUm1S37gpMuKv9+YP9uMScEWhUdygqGw/h7+wte+MRPR74+nPgZaoR4eBHkfaGPr1y47qkIAswSQ50SS8dN/aOz4HUr5lJB2OSMSN4xbYveE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=C5cvbg1e; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="C5cvbg1e"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 3990A807E3;
	Tue, 13 Jan 2026 12:58:44 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:93c4:8e38:1f90:3c73])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id KwPsag5AAiE0-VPA0AX0f;
	Tue, 13 Jan 2026 12:58:43 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768298323;
	bh=mQlvZ/q4g+mikGzd4Pofhz2KyjP2tY8dgFy2MWKhBPc=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=C5cvbg1eoe1LKWy/X+ZNblUiz/IFOOOqv11v5ARD+Cnw8yapR/bf+aX2kMLsDcgcm
	 o3yDoWoaLQ8yQ8IthI8a4nWTS3PGk8/BZ1b4F7asdIcEjnxs5OcaRBWBXBtc/CtUen
	 ZCi3iN8CvP7H2p1vDvN59fzArWXPuHAUDfQY4rss=
Authentication-Results: mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
To: qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	mzamazal@redhat.com,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org,
	virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Subject: [PATCH v6 2/5] vhost-user: introduce protocol feature for skip drain on GET_VRING_BASE
Date: Tue, 13 Jan 2026 14:58:13 +0500
Message-Id: <20260113095813.134810-3-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add vhost-user protocol feature
VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT

Now on GET_VRING_BASE this feature can control whether to wait for
in-flight requests to complete or not.
Also we have to validate that this feature will be enabled only when
qemu and back-end supports in-flight buffer and in-flight migration

It will be helpfull in future for in-flight requests migration in
vhost-user devices.

Update docs, add ref to label for inflight-io-tracking

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst    | 59 +++++++++++++++++++++-------------
 hw/virtio/vhost-user.c         |  5 +++
 include/hw/virtio/vhost-user.h |  2 ++
 3 files changed, 44 insertions(+), 22 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 02908b48fa..dcf79de0c0 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -736,6 +736,8 @@ negotiated, back-end can send file descriptors (at most 8 descriptors in
 each message) to front-end via ancillary data using this fd communication
 channel.
 
+.. _inflight_io_tracking:
+
 Inflight I/O tracking
 ---------------------
 
@@ -1033,26 +1035,27 @@ Protocol features
 
 .. code:: c
 
-  #define VHOST_USER_PROTOCOL_F_MQ                    0
-  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD             1
-  #define VHOST_USER_PROTOCOL_F_RARP                  2
-  #define VHOST_USER_PROTOCOL_F_REPLY_ACK             3
-  #define VHOST_USER_PROTOCOL_F_MTU                   4
-  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ           5
-  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN          6
-  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION        7
-  #define VHOST_USER_PROTOCOL_F_PAGEFAULT             8
-  #define VHOST_USER_PROTOCOL_F_CONFIG                9
-  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD      10
-  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER        11
-  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD       12
-  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE         13
-  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS 14
-  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS  15
-  #define VHOST_USER_PROTOCOL_F_STATUS               16
-  #define VHOST_USER_PROTOCOL_F_XEN_MMAP             17
-  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT        18
-  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE         19
+  #define VHOST_USER_PROTOCOL_F_MQ                       0
+  #define VHOST_USER_PROTOCOL_F_LOG_SHMFD                1
+  #define VHOST_USER_PROTOCOL_F_RARP                     2
+  #define VHOST_USER_PROTOCOL_F_REPLY_ACK                3
+  #define VHOST_USER_PROTOCOL_F_MTU                      4
+  #define VHOST_USER_PROTOCOL_F_BACKEND_REQ              5
+  #define VHOST_USER_PROTOCOL_F_CROSS_ENDIAN             6
+  #define VHOST_USER_PROTOCOL_F_CRYPTO_SESSION           7
+  #define VHOST_USER_PROTOCOL_F_PAGEFAULT                8
+  #define VHOST_USER_PROTOCOL_F_CONFIG                   9
+  #define VHOST_USER_PROTOCOL_F_BACKEND_SEND_FD         10
+  #define VHOST_USER_PROTOCOL_F_HOST_NOTIFIER           11
+  #define VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD          12
+  #define VHOST_USER_PROTOCOL_F_RESET_DEVICE            13
+  #define VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATIONS    14
+  #define VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS     15
+  #define VHOST_USER_PROTOCOL_F_STATUS                  16
+  #define VHOST_USER_PROTOCOL_F_XEN_MMAP                17
+  #define VHOST_USER_PROTOCOL_F_SHARED_OBJECT           18
+  #define VHOST_USER_PROTOCOL_F_DEVICE_STATE            19
+  #define VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT 20
 
 Front-end message types
 -----------------------
@@ -1243,12 +1246,24 @@ Front-end message types
 
   When and as long as all of a device's vrings are stopped, it is
   *suspended*, see :ref:`Suspended device state
-  <suspended_device_state>`. The back-end must complete all inflight I/O
-  requests for the specified vring before stopping it.
+  <suspended_device_state>`.
 
   The request payload's *num* field is currently reserved and must be
   set to 0.
 
+  By default, the back-end must complete all inflight I/O requests for the
+  specified vring before stopping it.
+
+  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
+  feature has been negotiated, the back-end may suspend in-flight I/O
+  requests and record them as described in :ref:`Inflight I/O tracking
+  <inflight_io_tracking>` instead of completing them before stopping the vring.
+  How to suspend an in-flight request depends on the implementation of the back-end
+  but it typically can be done by aborting or cancelling the underlying I/O
+  request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
+  protocol feature must only be neogotiated if
+  ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.
+
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
   :equivalent ioctl: ``VHOST_SET_VRING_KICK``
diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
index a820214188..793d1b36d8 100644
--- a/hw/virtio/vhost-user.c
+++ b/hw/virtio/vhost-user.c
@@ -2320,6 +2320,11 @@ static int vhost_user_backend_connect(struct vhost_dev *dev, Error **errp)
             }
         }
 
+        if (!u->user->supports_inflight_migration ||
+            !virtio_has_feature(VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
+            protocol_features &= ~(1ULL <<
+                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
+        }
+
         /* final set of protocol features */
         u->protocol_features = protocol_features;
         err = vhost_user_set_protocol_features(dev, u->protocol_features);
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index fb89268de2..f30c1792e4 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -33,6 +33,7 @@ enum VhostUserProtocolFeature {
     /* Feature 17 reserved for VHOST_USER_PROTOCOL_F_XEN_MMAP. */
     VHOST_USER_PROTOCOL_F_SHARED_OBJECT = 18,
     VHOST_USER_PROTOCOL_F_DEVICE_STATE = 19,
+    VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT = 20,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
@@ -69,6 +70,7 @@ typedef struct VhostUserState {
     GPtrArray *notifiers;
     int memory_slots;
     bool supports_config;
+    bool supports_inflight_migration;
 } VhostUserState;
 
 /**
-- 
2.34.1

