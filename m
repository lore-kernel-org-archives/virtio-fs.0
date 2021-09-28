Date: Tue, 28 Sep 2021 04:06:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=fTywt/xQ+N2E0sWo91SNKXZgSVhSGzQyhzw6b
	DSzotM=; b=NEe2bwvpuRHPG6mQ+0d2sfIbpxlC0mpNwrY0xRIm8Td6I61Szy9SV
	Vhla4+aWkEVUzZGlLI+bZSq9uYPtAvgbHigdqMQGVfDYhJROJGFW1lkTjF4pwlni
	0nD04WEmh4twHJSacYxRET8ZvQ0m1+lPCiox3gF+yep8iztc/e4Tc0z4u0k4B/fy
	0UPVP179t8RIFB0T61tET0lAvKLUKhN1JpQ48Nl1xkSoBYoqIU0sLpw4wh2LVxYs
	2Ei7EjQTxLvsjST81rePBu8PKnD6aj+YVoRksb9caENG4LVhMuvmDL8fbjCa+yD/
	Jh4KyJN7J+faNxMs/U8htb3R38maok6Sw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fTywt/xQ+N2E0sWo9
	1SNKXZgSVhSGzQyhzw6bDSzotM=; b=P1YvSxcLSgyhPHhSMTP/s0h3X8iXHm95t
	qnrEIEE6Y5R+svtJqxk2ee37bhwzzKr3Et6uKZIJD8AWJNVWxyI0HZ5IRBeaaKtP
	ByjriEE675R4AUiTV0RjmFXdevU1mujiAHNOMFMKHsfp6drv5jxVCvMcGOWMuEGT
	qwXFQF1kmDp+EOdhGi2BN4OS9cvZmx5URmxkYTMyii5dtmQCfY4cM4LzyaX/UGPy
	oTEwG5bIDtcU/ttod1wHI/I1w3j0D8futhhEq6mh19C2urGsNr4+wonAQAdF6tO4
	vz8CIblM0hte9WS/3paBhFTTthCwO5/pOz1C3yU1e3iXtqEbZFvWQ==
From: virtiofs-bot@sinrega.org
Message-Id: <95077.121092804060200533@us-mta-43.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Update vhost and
	vhost-user-backend crates
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Update vhost and vhost-user-backend crates in order to benefit from latest additions, including the support for VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS protocol feature.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/14

