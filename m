From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:17 -0300
Message-Id: <20191210145119.329731-4-farosas@linux.ibm.com>
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 3/5] build-linux: Add support for ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Allow running the script on a ppc64le machine to build a ppc64le
kernel.

The kernel config is generated based on the pseries defconfig +
virtio-fs config.

Note: We need to use the vmlinux kernel image for now while QEMU
upstream has not rebased on the latest SLOF which has support for the
zImage [1].

1 - https://github.com/aik/SLOF/commit/f9661a257028e49f8fcae77b7cc59d41f4983195

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 build-linux.sh                                | 26 ++++++++++++++++---
 ...-virtio-fs => x86_64-monolithic-virtio-fs} |  0
 2 files changed, 23 insertions(+), 3 deletions(-)
 rename configs/{config-monolithic-virtio-fs => x86_64-monolithic-virtio-fs} (100%)

diff --git a/build-linux.sh b/build-linux.sh
index 472bbe1..5a7e5a7 100755
--- a/build-linux.sh
+++ b/build-linux.sh
@@ -7,13 +7,33 @@
 
 set -e
 
+arch=$(uname -m)
+
 if [ ! -d include/uapi/linux ]; then
 	echo 'This script must be run from a Linux source tree.'
 	exit 1
 fi
 
+case ${arch} in
+    x86_64)
+	kernel_image=bzImage
+	;;
+    ppc64le)
+	kernel_image=vmlinux
+	defconfig=pseries_le_defconfig
+	;;
+esac
+
 scriptdir=$(dirname "$0")
-cp "$scriptdir/configs/config-monolithic-virtio-fs" .config
+arch_config="$scriptdir/configs/${arch}-monolithic-virtio-fs"
+
+if [ -f "$arch_config" ]; then
+    cp "$arch_config" .config
+    make oldconfig
+else
+    make $defconfig
+    ./scripts/kconfig/merge_config.sh .config "$scriptdir/configs/virtio-fs"
+    make LSMOD=$(mktemp) localyesconfig
+fi
 
-make -j$(nproc) oldconfig
-make -j$(nproc) bzImage
+make -j$(nproc) $kernel_image
diff --git a/configs/config-monolithic-virtio-fs b/configs/x86_64-monolithic-virtio-fs
similarity index 100%
rename from configs/config-monolithic-virtio-fs
rename to configs/x86_64-monolithic-virtio-fs
-- 
2.23.0


