From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:14 +0100
Message-Id: <20201216211125.19496-38-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 37/48] OvmfPkg/VirtioFsDxe: implement
	EFI_FILE_PROTOCOL.Flush()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: devel@edk2.groups.io, virtio-fs@redhat.com, lersek@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>, Ard Biesheuvel <ard.biesheuvel@arm.com>

For directories, implement EFI_FILE_PROTOCOL.Flush() by sending the
FUSE_FSYNCDIR command to the Virtio Filesystem device.

For regular files, send FUSE_FLUSH, followed by FUSE_FSYNC.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsFlush.c | 26 +++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c b/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
index e48d92140f64..ba4a611e5a21 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
@@ -9,10 +9,34 @@
 #include "VirtioFsDxe.h"
 
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileFlush (
   IN EFI_FILE_PROTOCOL *This
   )
 {
-  return EFI_NO_MEDIA;
+  VIRTIO_FS_FILE *VirtioFsFile;
+  VIRTIO_FS      *VirtioFs;
+  EFI_STATUS     Status;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  if (!VirtioFsFile->IsOpenForWriting) {
+    return EFI_ACCESS_DENIED;
+  }
+
+  //
+  // FUSE_FLUSH is for regular files only.
+  //
+  if (!VirtioFsFile->IsDirectory) {
+    Status = VirtioFsFuseFlush (VirtioFs, VirtioFsFile->NodeId,
+               VirtioFsFile->FuseHandle);
+    if (EFI_ERROR (Status)) {
+      return Status;
+    }
+  }
+
+  Status = VirtioFsFuseFsyncFileOrDir (VirtioFs, VirtioFsFile->NodeId,
+             VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
+  return Status;
 }
-- 
2.19.1.3.g30247aa5d201



