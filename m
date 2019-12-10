From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:05 -0300
Message-Id: <20191210145105.329680-3-farosas@linux.ibm.com>
In-Reply-To: <20191210145105.329680-1-farosas@linux.ibm.com>
References: <20191210145105.329680-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/2] build-rootfs: Select bootstrap command
	based on build machine distro
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Read the distro id from /etc/os-release and use the correct bootstrap
command.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 build-rootfs.sh | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/build-rootfs.sh b/build-rootfs.sh
index f616981..3b109a8 100755
--- a/build-rootfs.sh
+++ b/build-rootfs.sh
@@ -24,9 +24,15 @@ run_in_rootfs() {
 umask 022
 rm -rf rootfs
 mkdir rootfs
-#dnf "--installroot=$PWD/rootfs" "--releasever=$FEDORA_RELEASE" --assumeyes install $FEDORA_PACKAGES
-#install -D -m 0644 /etc/resolv.conf "$PWD/rootfs/etc/"
-debootstrap --include="$DEBIAN_PACKAGES" stable "$PWD/rootfs"
+
+source /etc/os-release
+if [[ "$ID $ID_LIKE" =~ "fedora" ]]; then
+	dnf "--installroot=$PWD/rootfs" "--releasever=$FEDORA_RELEASE" --assumeyes install $FEDORA_PACKAGES
+	install -D -m 0644 /etc/resolv.conf "$PWD/rootfs/etc/"
+elif [[ "$ID $ID_LIKE" =~ "debian" ]]; then
+	debootstrap --include="$DEBIAN_PACKAGES" stable "$PWD/rootfs"
+fi
+
 install -D -m 0755 run-test-in-guest.sh "$PWD/rootfs/root/"
 install -D -m 0644 run-test.service "$PWD/rootfs/etc/systemd/system/"
 run_in_rootfs /bin/bash -c "cd /root && git clone https://github.com/pjd/pjdfstest && cd pjdfstest && autoreconf -ifs && ./configure && make pjdfstest"
-- 
2.23.0


