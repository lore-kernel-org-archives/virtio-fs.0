Date: Mon, 26 Apr 2021 11:44:33 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <81861.121042611442700585@us-mta-226.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5hhHUXBOEaL27way0
	I3A+nCclQWFn/xm0orVZ+Gcj1o=; b=VCKAzZOiP8QdOQzUEr3n6aLIa/aonQ9dr
	PbfDebWLQ+zb8sRSCbARbbOH7OA0Oo2J9Tr1AE1IWGImabqaOwkyS1pTSlALQr7s
	XSqJZdCb2ZKMOujXXAQq1QCdOaEWGemIAaC/9z/kW6hDOpJXX4uFd9YW2z+e09Fz
	5MMBahUb76ICrogZl3QKrNMza7N1u1IAlHY1LJWW59Ulhsgwenvbu9+TD5RBgKmt
	0n+XX7hDO9NEP2yOtPNfsdLBYxqwz4o1fwhGLZMBarOgvn1EMvzNkPZQfvTD8u2U
	sFv8AlgDP369w5wlnLmJOnNws0Q5PJM7ap0PQdUcMF8LSbKe6nkfg==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Avoid using libc::statx()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This patch should resolve issue #12 (in a different manner than !22, as suggested by Connor).

`libc::statx()` resolves to the system libc's `statx()` (unsurprisingly), which may or may not be present.  For example, in glibc before 2.28, it was not present (regardless of whether the kernel supports the statx system call or not), leading to 

The libc function is just a wrapper around the syscall anyway, so we might as well implement the wrapper ourselves.  This has the advantage of only relying on `libc::syscall()` (which, on Linux, is basically always there) and `libc::SYS_statx` (which is provided by the `libc` crate, so does not depend on the system libc).

This way, we do not need to check whether the system libc provides the wrapper, and our `statx()` really works whenever the kernel supports it.
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/25

