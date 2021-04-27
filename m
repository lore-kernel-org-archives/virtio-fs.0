Date: Tue, 27 Apr 2021 11:11:19 -0400
From: virtiofs-bot@sinrega.org
Message-Id: <51474.121042711111400101@us-mta-207.us.mimecast.lan>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5hhHUXBOEaL27way0
	I3A+nCclQWFn/xm0orVZ+Gcj1o=; b=WL1kvN1GDY3BeBVyaquAnHqGI6Sa45qji
	xcKTOLaH4Rt6K4vXF4Wb0RhAW0vtmvMzc7jQYmSAuw5chJhj/z5gsC4TWo1O3DwL
	SjCOaItrhS6FKSKEso7CA9mGjn+Su6zEPBsKnZsR2Bsri3xBcCYjC7L1KrZj9VQr
	meaQ+6JnOVjp4rE0pEE53mOK/tdj1fx7+m7bymgxcuADKcGAiPiv8oafQgTy1z1C
	LSjRk3k0WgLcWPUVG92jtcZRr5wu49WhsMozGmcZassROSNdCghgSfA43vlHeLgD
	iwEiLGwRH+9KpsPa1XhhfzNuYLnYdnP/PdtF5XKayhIFn22eUJ6SQ==
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [virtiofsd-rs] MR merged: Avoid using libc::statx()
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

