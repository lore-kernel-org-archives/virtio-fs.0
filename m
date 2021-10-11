Date: Mon, 11 Oct 2021 04:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=47ZO02YdDTuVpbon0EOyBHmRgJMB2iYiUMrNZ
	hTbQgw=; b=S5igxGGRBHL0vu0uFVrgvBmP6f5aav31My/bySVZ2mg8WCZpjp6Vq
	UszR+uXovGhyT6/kcenhwKM+z9q7y54JAE3TGh0wcDNDSFUgau7jp/W19fyy31Vf
	EZorq1kgnCCmP4R+PtUcMMiy4Vny1FrRknK+o/G2jIaJVZbiNfSwqWSrblxIGTWS
	rzX8nBjoya4g4UpqaOijdEJ66l4xYO4T7XOWQCfiSr9zrTmXqqW5RTeklD8bU/i/
	n1fq/vz3FWbWaAWpzozCYoKJS0uJQ8O+ZOednCgPAfvLQ9rPe/hRZEqbRFnIOWTd
	fEAje02XEvj3WExZ7fHq0elyG4JtFmsQQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=47ZO02YdDTuVpbon0
	EOyBHmRgJMB2iYiUMrNZhTbQgw=; b=dzYApb729WIW0hR2jni5QB2Tr2t7e5x6Q
	aW/hell+lYh6ad2ItnYHpaI49MWxuDc5TOwLghScSCkSJD6jTo6JbKqCYaHnT1S3
	YNs1J5KpZyCC5nCNOV44Fv96FVFrVUy8GxKvJth+gR+k8hmztTG/AWFBYG82a/8b
	DxTKlGsA9KMWisBsRfp9QWv6vv1Rbdbzlfp0zf1kq8d/WCO1ZLxIMl90JLDplxYM
	+azect+WbGWapzvSRkaldQmXcI4wdZgg9Qw46IPjm+1gO6SEEliESLFPSrMXhXdk
	TCZWIkH+MmOQKrhC/b5Vye6IZD5hux2LYKjH5E05sQOxHvR/cWe7Q==
From: virtiofs-bot@sinrega.org
Message-Id: <18257.121101104002501190@us-mta-522.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Prevent opening of special
	files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Implement the mitigation for CVE-2020-35517 by applying the following
changes:

- In InodeData::open_file(), return EBADF if the file we're opening
is not a regular file nor a directory.

- In PassthroughFs::create(), always pass libc::O_EXCL to
libc::openat(), to ensure we're not being used to bypass the file mode
restrictions at InodeData::open_file(). If the syscall fails with
EEXIST, and libc::O_EXCL wasn't among the flags passed by the client,
open the existing file using InodeData::open_file().

This is based on the work done by Stefan Hajnoczi and others for
QEMU/virtiofsd:

https://lists.gnu.org/archive/html/qemu-devel/2021-02/msg01582.html

This is an extract from the cover page of his patch series:

---
A well-behaved FUSE client does not attempt to open special files with
FUSE_OPEN because they are handled on the client side (e.g. device nodes
are handled by client-side device drivers).

The check to prevent virtiofsd from opening special files is missing in
a few cases, most notably FUSE_OPEN. A malicious client can cause
virtiofsd to open a device node, potentially allowing the guest to
escape. This can be exploited by a modified guest device driver. It is
not exploitable from guest userspace since the guest kernel will handle
special files inside the guest instead of sending FUSE requests.

This patch series fixes this issue by introducing the lo_inode_open() function
to check the file type before opening it. This is a short-term solution because
it does not prevent a compromised virtiofsd process from opening device nodes
on the host.

This issue was diagnosed on public IRC and is therefore already known
and not embargoed.
---

Fixes: CVE-2020-35517
Fixes: #9
Reported-by: Alex Xu <alex@alxu.ca>
Signed-off-by: Sergio Lopez <slp@redhat.com>
---
https://gitlab.com/virtio-fs/virtiofsd-rs/-/merge_requests/38

