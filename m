From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:15 -0300
Message-Id: <20191210145119.329731-2-farosas@linux.ibm.com>
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 1/5] build-qemu: Add support for ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Allow running the script on a ppc64le machine to build a ppc64le QEMU
binary.

The configuration differs from x86 in the following:

--enable-fdt:
We need to build with device-tree support because ppc relies on it.

--enable-tcg:
The ppc build without TCG is currently broken.

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 build-qemu.sh | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/build-qemu.sh b/build-qemu.sh
index 2dc0580..ff78df9 100755
--- a/build-qemu.sh
+++ b/build-qemu.sh
@@ -7,6 +7,8 @@
 
 set -e
 
+arch=$(uname -m)
+
 if [ ! -f vl.c ]; then
 	echo 'This script must be run from a QEMU source tree.'
 	exit 1
@@ -15,8 +17,23 @@ fi
 rm -rf qemu
 mkdir qemu
 
-./configure --target-list=x86_64-softmmu \
-	--disable-fdt \
+case ${arch} in
+	ppc64le)
+		arch=${arch/le/}
+		arch_config_opts=(
+			--enable-fdt
+			--enable-tcg
+		)
+		;;
+	*)
+		arch_config_opts=(
+			--disable-fdt
+			--disable-tcg
+		)
+		;;
+esac
+
+./configure --target-list=${arch}-softmmu \
 	--disable-glusterfs \
 	--disable-guest-agent \
 	--disable-numa \
@@ -89,13 +106,13 @@ mkdir qemu
 	--disable-mpath \
 	--disable-virglrenderer \
 	--disable-xen-pci-passthrough \
-	--disable-tcg \
 	--disable-sanitizers \
 	--disable-hvf \
 	--disable-whpx \
 	--enable-malloc-trim \
 	--disable-membarrier \
-	--disable-vhost-crypto
+	--disable-vhost-crypto \
+	${arch_config_opts[@]}
 
 make "DESTDIR=$PWD/qemu" -j$(nproc) install
 
-- 
2.23.0


