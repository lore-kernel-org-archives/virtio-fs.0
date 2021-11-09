Date: Tue, 9 Nov 2021 02:15:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=7ZDhHUzXquI1a3gfscHAhzwHZKvVyPRJiqy82
	/SovZ0=; b=ciOW2IutSStOBZpI1+Q4fjqV/vSnI0XDiwnmLKD+kSQrcduLzxDOw
	VQYUtfarC89GTpMw3+lys+LOPKmhBTJD86AWaVl8MoaK8p/dqbb8WkFoKkxsG3+N
	ZkyM/NvmRKNp97Ml4V6pCEPV+cz2h6F7pfubVaBvKDmBeN4qhj+tpt6QGF43201c
	kCulv/8nlAOivMtgPWO8H5ma/4fEb+q/NjGLcItk0DrIUVmcoPZTeW0d8f1xYuGB
	Rmeue94JfTJ6KmRxiA+m+gBhHMWtw+JZn2Co3I6nM1IjVKCg3/cP97UwrA+55eY5
	Uu/ZoUfMlcd1BOxKZuwHSoMHfOHjOMOMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=7ZDhHUzXquI1a3gfs
	cHAhzwHZKvVyPRJiqy82/SovZ0=; b=JcVPMI+KCx7tI4FU2Qo7+x1q5dro7P1pF
	2/zT8mGOjdJmANea2hYhbVmMFLS6Q0tKdQ44tcMbZNjxcrbc/vNIthC/pcRPXOMJ
	7ZIhU8M4vK7NCzvXxv9hd9yhOYvvxfKDlHrU2AAc7/mRbnRxObN4cyaN0eYBlw93
	XBXdqEoTNyrZ2vZue1cssm3J6zR6kUKAYsLQNKO3KjToUiORHV1DRXmtdcsZTa/D
	Z5ZSXfe4YLjOI7STbcLmEfOmxWMCeAH5BgZ5HMJpaPA3WVUoBNcz85SOoTamWFmo
	SAAx3cI+868Cp/HxHPOD8bCGpzLCBr4HZlRUOtdRanUq5ObDEOEsg==
From: virtiofs-bot@sinrega.org
Message-Id: <32923.121110902154400277@us-mta-553.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Replace Firecraker's seccomp
	with seccomp-sys
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Some distributions require all crate dependencies to be packaged
individually. This implies that depending on the whole Firecracker
repository would make things very hard for us to get virtiofsd-rs
packaged.

This change replaces the dependency on Firecracker's seccomp with
seccomp-sys, which is a crate providing raw bindings for
libseccomp. This means we add the latter as a both a build time and
run time dependency, but that should be fine as the C implementation
also depends on it.

I've also considered adding syscallz, which provides safe wrappers on
top of syscomp-sys, but that one also depends on strut, which we need
to drop from our dependencies due to its problematic versioning
policy.

Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/45

