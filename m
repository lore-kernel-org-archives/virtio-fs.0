DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	to:subject:message-id:date:from; s=fm3; bh=AohTzW2iCf55qgyXthxu7
	Ovk3LfKU/RdHANWV8j1GbU=; b=dZs4IWzLGLiFeaPFLvKyRkY+XPb4pF6AuT8wE
	f6VypmFAALjUbUNqc4Yem4XmiGNATUhoSbG/iTnI4JQpHMHi33V96mmjwUTD1sg0
	etqSgGZMZYUd+4GKhlO4eZOY4ZMjrndTM/9/9h0UcM2bvVpSfsoy81E4Z2Xfsr0J
	ciQrMOg0xOaEl1vdOA0GeDrUw3T2Tywcapn3hvYeY0rWGXX+TNqgGMCoHMPh1wsy
	uwcomGHvYMACaGdJzNUxseTw50QMpfU2eNIW3X332jRijCHNCf4RPodmUeRSuI9F
	vdbdo4kKRy2smz+uqzo7erhF9G+QkUJpzV7arhq7jA1+o2i5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=date:from:message-id:subject:to
	:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; bh=AohTzW2iCf55qgyXthxu7Ovk3LfKU/RdHANWV8j1GbU=; b=GeS3Ykfj
	ZROXul9XXF4vFPc8hm9A6nsDXsXVKJUk2KcrXF0VwxuH9cTT6Xv4goMNcBQafyga
	Pp/aSGPxdUIBiJNovod8YLM8WH1l9O0mcUHzukCGQysvjn49wdd3qQb7j9QRBMGg
	8pwPV7K1F2/NbADZ7TaulrpxZawJgbDkHjWdElI8EKVwJflPmKNgpB+Q/W8SUeas
	7tpRY+v/c7ZHvz7aRmd+DZftyVtkrOexOQ39fcQ/T86MhsLLgZRKkmtbIqiEzQxd
	ikOKZF9YsOvLGPBXDtS3OQpmoPrkTl8I9D5D6ilS9OKQACzshWU/ovao0hjKeW4N
	MFGITbUDR36aSg==
Message-Id: <20210412114647.A03EE1080057@mailuser.nyi.internal>
Date: Mon, 12 Apr 2021 07:46:47 -0400 (EDT)
From: virtiofs-bot@sinrega.org
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Add statx() (so we can use
	mount IDs)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This series of commits adds support for `statx()` (if available) as the preferred alternative over `fstatat64()`. The advantage of `statx()` is that it gives us a mount ID to identify a mount, which is better than the device ID, because a single filesystem (same device ID) may be mounted multiple times (different mount IDs), and every tree may be different (because of submounts in those trees).

Then we use this mount ID as an additional field in `InodeAltKey` so that inodes on the same filesystem but on different mounts are treated separately. Furthermore, when checking for submounts, we have to consider the mount ID in addition to the device ID.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/18

