Date: Mon, 13 Dec 2021 06:09:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=CgYhKTxN7ggXpiQWPATRiiIxmIp5pJMg0BhzL
	Mor09Q=; b=ZQ59ZQGAEQNOC882xUEr89pdVQ2PoCwH89VP4G6FNUYHFM0lLberh
	nJvWX25x9UgbYJmDwRC2kLITu1zKTX0PrtLJ1YEywEJgz64kIW27GEQPqYZocM/u
	yNperm36EynpkiPSb9RkXHtFwy9utuisaSC+ffi4Y9DXwkUPBelY3POF6HO3NC2q
	Ea2HvV6BfQuI85T6L2RQ0vj5LEmhxAvcRI93EeSde54SsWeILRCe2R69t66ljIRz
	OPnKG2zMsMe83zoul7dbIkxnFpNwRddL29P/fTbHm79MYRwZKfDUTz2/inSZuBDS
	V3Pz3pIYgFXA3ymMsLchm53NKpnZXz7zQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CgYhKTxN7ggXpiQWP
	ATRiiIxmIp5pJMg0BhzLMor09Q=; b=HUIivK5f9qpGaTwQaIoTuAh/+irvkBUaJ
	ip+4ZJNG/nySPre4yqD6c/rv3WmG/7A2w85uakxG8KNvrEqhIF0NdKRJXIYzbThP
	tXF8QrpZG7kJQMtYPASNz2vSngKFo9ohPxwuwz4VYOiU4/2OT/I4nPZXW0f4Ye/i
	42slgJQQIGJgjrdF1GQBbIIrDfNHIVwvYNJjiEr6RXPv/EMeu33hzejs5SQQGSVT
	iAyfI18jnW3dYUbLJUaZrEUWcRQnm42kCsqmQVx9c4cQURJbDbj104u24FNXICV2
	jCIRJX5aX8PG57yBiQTf+JFBLZtqcM159QD0MT6bTqbtBvTCtfyBg==
From: virtiofs-bot@sinrega.org
Message-Id: <36285.121121306094600189@us-mta-227.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Reject sandbox modes !=
	namespace when uid != 0
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Inside drop_child_capabilities() there is a call to capng:apply() that clears the bounding set. It causes libcap-ng to fail when calling virtiofsd-rs with '--sandbox none' by an unprivileged user, because it doesn't have the CAP_SETPCAP capability.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/49

