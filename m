Date: Mon, 3 May 2021 08:20:32 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <10450.121050308202400115@us-mta-401.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/WTd2Xkb25tn3uJbc
	DixJZR1MujxgTcqdJyDb4iGl8k=; b=LNWy7CW5tjeEujcllzjBL1fkuFSrVRWWA
	FVSDeZpUTCXueIVioB+41n32x7lDeJtMXOMH/ySG/gxC4sl/fLGP9gbSx23jVNSt
	E3+kosoUU8Do+I42bhlxeNjlEHkwBIsYEjRmAzfgnabS9nw8aQEZc8f5e9lj717p
	E7W6vrddBL+eEKWPNvI+192Forhr9jNbQVuxxH4YqEC0ZzoncvXcmppuy0imCVd0
	0YplwIq6Ph/CS8HOupU1rAiwm08Hf0NoQESVVw3mcYO53D3kvM0EedbiBL0k0WFy
	Rj4uJbQCL1dcL032IC8v1OUgzj7xiO8UKLduKiLAPi0pwWpr53R5w==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Allow using file handles
	instead of O_PATH FDs to reference inodes
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Storing an `O_PATH` file descriptor in every `InodeData` means we have a lot of FDs open, which is sometimes bad.  This series adds an option (`--inode-file-handles`) that will make virtiofsd-rs attempt to generate a file handle for new inodes and store that instead of an FD.  When an FD is needed for a given inode, we open the handle.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/26

