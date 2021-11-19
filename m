Date: Fri, 19 Nov 2021 08:55:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=4HWrMdKhD4LhdSzMF1sPEHdY9+ZNgBuEpme3i
	lbGOhE=; b=ykWoLfE5nR0vvb1OTC/HnDH/Utf2E9aDW5T/95wz9veOL7l13SozV
	22GR3pjBrYZcFtuUGGQeHGE0tvrspUFzlVQFrx/IlrdKPhKZFH9GvI+WItMu8+ic
	5+53UnUefHj/bPqcRAPrAQoBAkFeQjeQl1RFeL2JqwQNV3SEhlwibfQjiFu3GUU2
	2cDaT6vnO4kWRnZ7plTrtZA7S8InRIIK686/fuWneSf4qnCO9Jx9tVYuDq+Berdp
	VxbC4nOwSHaT8g4Ncmbzp2FeWf0JwKLsWHgAdNmLoy4HimKpJefxBHAYOJ9jWXIb
	FGAQTA0TUJqWY7pcKmXrki7bL1mHT0ZPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=4HWrMdKhD4LhdSzMF
	1sPEHdY9+ZNgBuEpme3ilbGOhE=; b=OxasWxkVjeEHKNQP3fGlpFK8g0zbTB4uc
	npWB8IuWlOPew2uqGptBwXEQ85Dt8/Gt7GXxPZPvZquYu7EdNp2WY32A9OZoFBkm
	fhmCujvZ2ANNZx3r7Q6xtUUTlqnMijGYFkwBl+Fvbd1XhoyVeKaYzjKXOR7FpHed
	kDksu30p7aU0ApKkIFqXebkJrSdQ/gnKon7luCz3nATPeffxtpeNWjdnp/Y97eXk
	tCL338cs5Q6teuLUo+j8UsnvGG31ubMI1E36codbix+pYn5wcu24sGut6Qr5HHZe
	LwFn//oBZeD6ZTvs2jA76Mc6kAV3SG+PwDPFlZxS+jaaEcKHjHNig==
From: virtiofs-bot@sinrega.org
Message-Id: <00669.121111908550500135@us-mta-300.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: descriptor-utils: fix
	split_at()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

split_at() doesn't correctly handle the front part of the splitted
buffer, which should be truncated to [0, rem].

Fixes: https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/6
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/51

