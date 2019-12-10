From: Fabiano Rosas <farosas@linux.ibm.com>
Date: Tue, 10 Dec 2019 11:51:16 -0300
Message-Id: <20191210145119.329731-3-farosas@linux.ibm.com>
In-Reply-To: <20191210145119.329731-1-farosas@linux.ibm.com>
References: <20191210145119.329731-1-farosas@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 2/5] Add virtio-fs kernel config snippet
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

This facilitates the (re)generation of the kernel config:

$ cd linux
$ make defconfig
$ ./scripts/kconfig/merge_config.sh .config ${configs}/virtio-fs
$ make LSMOD=$(mktemp) localyesconfig

Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 configs/virtio-fs | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 configs/virtio-fs

diff --git a/configs/virtio-fs b/configs/virtio-fs
new file mode 100644
index 0000000..bdaea03
--- /dev/null
+++ b/configs/virtio-fs
@@ -0,0 +1,8 @@
+CONFIG_DAX=y
+CONFIG_DAX_DRIVER=y
+CONFIG_FS_DAX=y
+CONFIG_FUSE_FS=y
+CONFIG_VIRTIO=y
+CONFIG_VIRTIO_FS=y
+CONFIG_VIRTIO_PCI=y
+CONFIG_ZONE_DEVICE=y
-- 
2.23.0


