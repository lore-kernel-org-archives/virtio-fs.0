Date: Fri, 26 Nov 2021 06:32:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=732KAdVt4UaZuLnrxveRSSEmqu9A9HnCVavlQ
	vNOv9c=; b=axjEtr+JTUbK2npX6OEkukRPrkrxa2gLNLbcxyBw51o8gQC4XBtfU
	+VoNTyXRxVQ8XXvm02+zN9GdQ5Etq6ybcDxtgy1D1sKHvQ90+xujOdcOTPs/Ub66
	BDlZrkV5K9jiPzKsSqo4Lb6qF2kVLAl6yqr/Gf9UO4r+wUaEkZO21UZw6e/un0SI
	DppJi6p7ER1l9PO7djnCx+hgKOEupj6e6869RqyvU89y115BjF5OAnuA5uVEnjV9
	iiqozyVs1kL2pGkA6K21mbUxL6lmIuovmyp7Yn82zEU9mDFPfUId8u9IIXWuv/NN
	L2sWsl/hSkujfc5F9Id3oxdio+SBcYwcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=732KAdVt4UaZuLnrx
	veRSSEmqu9A9HnCVavlQvNOv9c=; b=DkI5CV0znI4liSasy8BB3rBaFPwnmj0Kl
	T+V+bx6Q9hp6eXf8XykMrNQDDpQxdwW6FK+ZQYfJSeCdlDH9PsNA9eAdGVbdFlmZ
	10smo0cM59c7f/DQYmSs2zjrLbYf1U/gFeKIrkiffU25flNSJxy6W7y69f61MdxY
	ttFfMrcCbvS07ZEBeYapDZs5ey9wL4l7D0oFu/nMP+JXwPD4fdwX/hD6uc7Xvk3Z
	KJwiJdC5qOrkmtq+LjRArV3XcLeG4qDANE+ckiAtOoViIK35EBRHaOYZMb0GN6qQ
	mJyDtZdOeh7vy24HUS6cj2uy8dGzQYZV/pplz2UOqZICZsON4GMhA==
From: virtiofs-bot@sinrega.org
Message-Id: <29415.121112606324100812@us-mta-583.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Enable back descriptor-utils
	tests
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Create a temporary Queue with an avail ring added at the end of the
descriptors table to avoid using an internal vm-virtio API.

Fixes: https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/1
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/50

