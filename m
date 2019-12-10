From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:19 -0300
Message-Id: <20191210145119.329731-6-farosas@linux.ibm.com>
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 5/5] run-test: Add support for ppc64le
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 run-test.sh | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/run-test.sh b/run-test.sh
index 65168df..2d16284 100755
--- a/run-test.sh
+++ b/run-test.sh
@@ -24,11 +24,24 @@ if [ ! -f qemu.tar.xz ]; then
 	exit 1
 fi
 
-if [ ! -f bzImage ]; then
-	echo 'A bzImage Linux kernel is required'
+if [ ! -f bzImage -a ! -f vmlinux ]; then
+	echo 'A Linux kernel image is required'
 	exit 1
 fi
 
+arch=$(uname -m)
+case ${arch} in
+	x86_64)
+		kernel_image=bzImage
+		serial_console=ttyS0
+		;;
+	ppc64le)
+		arch=${arch/le/}
+		kernel_image=vmlinux
+		serial_console=hvc0
+		;;
+esac
+
 log "Unpacking rootfs..."
 rm -rf rootfs
 tar xf rootfs.tar.xz
@@ -54,9 +67,9 @@ done
 log "Starting QEMU..."
 rm -f qmp.sock
 rm -f serial.log
-qemu/usr/local/bin/qemu-system-x86_64 \
-	-kernel bzImage \
-	-append 'rootfstype=virtio_fs rootflags=default_permissions,allow_other,user_id=0,group_id=0,rootmode=040000,tag=myfs,dax root=none rw console=ttyS0 systemd.unit=run-test.service' \
+qemu/usr/local/bin/qemu-system-${arch} \
+	-kernel ${kernel_image} \
+	-append 'rootfstype=virtio_fs rootflags=default_permissions,allow_other,user_id=0,group_id=0,rootmode=040000,tag=myfs,dax root=none rw console=${serial_console} systemd.unit=run-test.service' \
 	-M accel=kvm \
 	-cpu host \
 	-m 1G,maxmem=4G \
-- 
2.23.0


