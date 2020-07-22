From: Stefan Hajnoczi <stefanha@redhat.com>
Date: Wed, 22 Jul 2020 14:02:03 +0100
Message-Id: <20200722130206.224898-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH for-5.1 0/3] virtiofsd: allow virtiofsd to run
	in a container
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: virtio-fs@redhat.com, rmohr@redhat.com, vromanso@redhat.com

Container runtimes handle namespace setup and remove privileges needed by
virtiofsd to perform sandboxing. Luckily the container environment already
provides most of the sandbox that virtiofsd needs for security.

Introduce a new "virtiofsd -o chroot" option that uses chroot(2) instead of
namespaces. This option allows virtiofsd to work inside a container.

Please see the individual patches for details on the changes and security
implications.

Given that people are starting to attempt running virtiofsd in containers I
think this should go into QEMU 5.1.

Stefan Hajnoczi (3):
  virtiofsd: drop CAP_DAC_READ_SEARCH
  virtiofsd: add container-friendly -o chroot sandboxing option
  virtiofsd: probe unshare(CLONE_FS) and print an error

 tools/virtiofsd/fuse_virtio.c    | 13 +++++++++
 tools/virtiofsd/helper.c         |  3 +++
 tools/virtiofsd/passthrough_ll.c | 45 +++++++++++++++++++++++++++++---
 3 files changed, 58 insertions(+), 3 deletions(-)

-- 
2.26.2


