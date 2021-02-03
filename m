From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed,  3 Feb 2021 11:37:16 +0000
Message-Id: <20210203113719.83633-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v4 0/3] virtiofsd: prevent opening of special
	files (CVE-2020-35517)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: Daniel Berrange <berrange@redhat.com>, virtio-fs@redhat.com, Alex Xu <alex@alxu.ca>, P J P <ppandit@redhat.com>, Laszlo Ersek <lersek@redhat.com>, vgoyal@redhat.com

v3:
 * Restructure lo_create() to handle externally-created files (we need
   to allocate an inode for them) [Greg]
 * Patch 1 & 2 refactor the code so that Patch 3 can implement the CVE fix
v3:
 * Protect lo_create() [Greg]
v2:
 * Add doc comment clarifying that symlinks are traversed client-side
   [Daniel]

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

Reported-by: Alex Xu <alex@alxu.ca>
Fixes: CVE-2020-35517

Stefan Hajnoczi (3):
  virtiofsd: extract lo_do_open() from lo_open()
  virtiofsd: optionally return inode pointer from lo_do_lookup()
  virtiofsd: prevent opening of special files (CVE-2020-35517)

 tools/virtiofsd/passthrough_ll.c | 221 ++++++++++++++++++++-----------
 1 file changed, 145 insertions(+), 76 deletions(-)

-- 
2.29.2


