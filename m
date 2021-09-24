Date: Fri, 24 Sep 2021 00:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sinrega.org; h=
	from:to:subject; s=fm2; bh=47ZO02YdDTuVpbon0EOyBHmRgJMB2iYiUMrNZ
	hTbQgw=; b=CpbkGgtVNtoMP7CQZH/rTnfPV2mUwMtE3MDLVPMgx3CpcO/rGE7PA
	FbbyzoCIa3ryNHpsDi/NWhi2NW1qCbNI81sA0JD4Kb4hL2XRUHf95G7qOk2Trauk
	+6qHbVIvK9HIXZqc44CjU+g3r6kK8ZbgFTOJHN+0sOJzMxiek6WqO2WO3uY7cV9z
	4G6dikaiQ7xJCPtXCcf2yzeF1B9Xru/u1CGIp3E0fEJoojPGskdK6NYXB3SQ/VBJ
	PlF+pu6IyGZAwQc2n+a/IB0G7lt6tukMPT229AEd2TMPJMriNRqqrALv7e6/VExH
	YdDKuyZrYOTqelVi3jMV0nvV0PN4RSANw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=from:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=47ZO02YdDTuVpbon0
	EOyBHmRgJMB2iYiUMrNZhTbQgw=; b=sBDhn3GaSe518xu1j2WtAAfjURFE0lIf4
	74GP7AE1+Z+AF85dJHefeMk1E2gNrk1WB07eiFRIzZ3E5NyleUyfovbYk0Es1MB2
	bJxEISFvCX6eSctl84T3IoRl2ztYJQc/oLrfrqiGWi4xQTtELzbiTKFe0rFSIaQ4
	zH/hPjNF18W7Ld02+17xcOdIG9qjvoLVfz7n1bZtzHmt0DoOVVxVsBs6SzRq/xbC
	6mb/Fs/8qAbqN4yzrBUlHsFgVNuM0c+3Xa48x01r/m0eMPb2LBE50tO8F2VMUwjs
	ANVY/zYOdFRPy/FBdzg/zD63QWL+AsIGN03c6RzZT2L7Z5TBo2S5A==
From: virtiofs-bot@sinrega.org
Message-Id: <77343.121092400250700395@us-mta-305.us.mimecast.lan>
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR opened: Prevent opening of special
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

