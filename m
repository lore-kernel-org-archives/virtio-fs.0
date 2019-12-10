From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:14 -0300
Message-Id: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 0/5] virtio-fs-ci: Add support for ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This series adds support for building a ppc64le qemu, kernel and rootfs
in a ppc64le machine in both Fedora (untested) and Ubuntu.

For QEMU:
- change the QEMU target name based on the architecture;
- alter configure options because ppc depends on fdt and the no-tcg
  build is currently broken.

For linux:
- change the kernel image name (ppc does not build bzImage);
- build the kernel config dynamically by adding the virtio-fs options
  and turning modules to =y.

For rootfs:
- add a more recent config.guess to blogbench otherwise it doesn't
  build on ppc.

For run-test:
- change qemu binary name based on architecture;
- change the serial console name (ppc uses hvc0);
- change the kernel image name to match what was built (vmlinux).


Fabiano Rosas (5):
  build-qemu: Add support for ppc64le
  Add virtio-fs kernel config snippet
  build-linux: Add support for ppc64le
  build-rootfs: Download latest config.guess for blogbench
  run-test: Add support for ppc64le

 build-linux.sh                                | 26 ++++++++++++++++---
 build-qemu.sh                                 | 25 +++++++++++++++---
 build-rootfs.sh                               |  2 +-
 configs/virtio-fs                             |  8 ++++++
 ...-virtio-fs => x86_64-monolithic-virtio-fs} |  0
 run-test.sh                                   | 23 ++++++++++++----
 6 files changed, 71 insertions(+), 13 deletions(-)
 create mode 100644 configs/virtio-fs
 rename configs/{config-monolithic-virtio-fs => x86_64-monolithic-virtio-fs} (100%)

-- 
2.23.0


