From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:04 -0300
Message-Id: <20191210145105.329680-2-farosas@linux.ibm.com>
In-Reply-To: <20191210145105.329680-1-farosas@linux.ibm.com>
References: <20191210145105.329680-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/2] build-rootfs: Fix fedora build
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Ensure that the rootfs build in Fedora finishes without errors.

- include wget in the rootfs
- fix dnf install command line
- include a resolv.conf

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 build-rootfs.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/build-rootfs.sh b/build-rootfs.sh
index c23656c..f616981 100755
--- a/build-rootfs.sh
+++ b/build-rootfs.sh
@@ -6,7 +6,7 @@
 # Copyright (C) 2019 Red Hat, Inc.
 
 FEDORA_RELEASE=30
-FEDORA_PACKAGES="system-release vim-minimal systemd passwd dnf rootfiles autoconf automake gcc make git perl-Test-Harness tar"
+FEDORA_PACKAGES="system-release vim-minimal systemd passwd dnf rootfiles autoconf automake gcc make git perl-Test-Harness tar wget"
 
 DEBIAN_PACKAGES="vim-tiny autoconf automake gcc libc6-dev make git perl tar ca-certificates wget"
 
@@ -24,7 +24,8 @@ run_in_rootfs() {
 umask 022
 rm -rf rootfs
 mkdir rootfs
-#dnf "--installroot=$PWD/rootfs" "--releasever=$FEDORA_RELEASE" --assumeyes install $PACKAGES
+#dnf "--installroot=$PWD/rootfs" "--releasever=$FEDORA_RELEASE" --assumeyes install $FEDORA_PACKAGES
+#install -D -m 0644 /etc/resolv.conf "$PWD/rootfs/etc/"
 debootstrap --include="$DEBIAN_PACKAGES" stable "$PWD/rootfs"
 install -D -m 0755 run-test-in-guest.sh "$PWD/rootfs/root/"
 install -D -m 0644 run-test.service "$PWD/rootfs/etc/systemd/system/"
-- 
2.23.0


