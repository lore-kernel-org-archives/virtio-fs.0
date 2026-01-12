Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2435770C
	for <virtio-fs@lists.linux.dev>; Mon, 12 Jan 2026 11:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768218329; cv=none; b=XEYQKFuHce1O0nSTIcXA/Ie8Ti7DMThiH678ynsJ8uT//+u4o5Vqt/6pX7jg9mOjBNWebz/QfCkksgLjifCyh5azewkupgGNbCbuxsbv0p421fuA6Q+mAWDsZ4a06UdURllJrfExgjG+sumUj88spCAalGmHp8hha1oRHvKJPBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768218329; c=relaxed/simple;
	bh=ThnG+l0g+RCbfmpw2SxEpD1EfLowj01RgYpvPMvyQZQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xvk92YE8zdQ/O8uDqgm6yqjof71f05R0mpppzciO9X/LJBMO/vVqkd1C+rrFcCAF4+itUIdGnlTFvQOF6kijDc/xdLNXZCoVVo++B2bhjiPdXfRMEhrGiM9rrKallWr2C0+7lMYqu1HV4QwBSrl5hXp1q9xo/elLOlHxkJkHj8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=fCdTPJj9; arc=none smtp.client-ip=178.154.239.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="fCdTPJj9"
Received: from mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net [IPv6:2a02:6b8:c24:fa2:0:640:41ee:0])
	by forwardcorp1b.mail.yandex.net (Yandex) with ESMTPS id 05DC98080A;
	Mon, 12 Jan 2026 14:45:26 +0300 (MSK)
Received: from dtalexundeer-nx.yandex.net (unknown [2a02:6bf:803e:400:6fcf:dbb2:9b0:d80b])
	by mail-nwsmtp-smtp-corp-main-34.sas.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 6jQQPI5AAW20-fY8FuAQa;
	Mon, 12 Jan 2026 14:45:25 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1768218325;
	bh=HdyqLoPPJV/dgq0szMV+tcZby7MpNxKn6fP7roWRik8=;
	h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=fCdTPJj9fOlUtsIKT3WZhBQwxpotlgCAxOKLv6+yI8OPHIgyDaJ/4sw++Y4E9Iskt
	 566S08oGZ2fw9jtuGxREsvELOg6LrEekYQ7D388d76FyeJv3guRBmW5G7nb4WJJgBg
	 ecVqjuCBuU5g3C6XMCdKRNua2uz+VDBYgyrrvXXo=
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
Subject: [PATCH v5 2/5] vhost-user: introduce protocol feature for skip drain on GET_VRING_BASE
Date: Mon, 12 Jan 2026 16:45:00 +0500
Message-Id: <20260112114503.1174330-3-dtalexundeer@yandex-team.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
References: <20260112114503.1174330-1-dtalexundeer@yandex-team.ru>
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

It will be helpfull in future for in-flight requests migration in
vhost-user devices.

Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
---
 docs/interop/vhost-user.rst    | 52 ++++++++++++++++++----------------
 include/hw/virtio/vhost-user.h |  1 +
 2 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
index 02908b48fa..80c80aada5 100644
--- a/docs/interop/vhost-user.rst
+++ b/docs/interop/vhost-user.rst
@@ -1033,26 +1033,27 @@ Protocol features
 
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
@@ -1243,11 +1244,14 @@ Front-end message types
 
   When and as long as all of a device's vrings are stopped, it is
   *suspended*, see :ref:`Suspended device state
-  <suspended_device_state>`. The back-end must complete all inflight I/O
-  requests for the specified vring before stopping it.
+  <suspended_device_state>`.
 
-  The request payload's *num* field is currently reserved and must be
-  set to 0.
+  By default, the back-end must complete all inflight I/O requests for the
+  specified vring before stopping it.
+
+  If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol feature
+  has been negotiated, the back-end may stop the vring immediately without
+  waiting for inflight I/O requests to complete.
 
 ``VHOST_USER_SET_VRING_KICK``
   :id: 12
diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
index fb89268de2..493fbce8b1 100644
--- a/include/hw/virtio/vhost-user.h
+++ b/include/hw/virtio/vhost-user.h
@@ -33,6 +33,7 @@ enum VhostUserProtocolFeature {
     /* Feature 17 reserved for VHOST_USER_PROTOCOL_F_XEN_MMAP. */
     VHOST_USER_PROTOCOL_F_SHARED_OBJECT = 18,
     VHOST_USER_PROTOCOL_F_DEVICE_STATE = 19,
+    VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT = 20,
     VHOST_USER_PROTOCOL_F_MAX
 };
 
-- 
2.34.1

