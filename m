From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:10 +0100
Message-Id: <20201216211125.19496-34-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 33/48] OvmfPkg/VirtioFsDxe: implement
	EFI_FILE_PROTOCOL.Read() for regular files
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

Using the functions introduced previously, we can now implement
VirtioFsSimpleFileRead(); for regular files at first.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsRead.c | 75 +++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsRead.c b/OvmfPkg/VirtioFsDxe/SimpleFsRead.c
index e737d5e33204..c4ad07c9aec4 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsRead.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsRead.c
@@ -3,18 +3,91 @@
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
 #include "VirtioFsDxe.h"
 
+/**
+  Read from a regular file.
+**/
+STATIC
+EFI_STATUS
+ReadRegularFile (
+  IN OUT VIRTIO_FS_FILE *VirtioFsFile,
+  IN OUT UINTN          *BufferSize,
+     OUT VOID           *Buffer
+  )
+{
+  VIRTIO_FS                          *VirtioFs;
+  EFI_STATUS                         Status;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE FuseAttr;
+  UINTN                              Transferred;
+  UINTN                              Left;
+
+  VirtioFs = VirtioFsFile->OwnerFs;
+  //
+  // The UEFI spec forbids reads that start beyond the end of the file.
+  //
+  Status = VirtioFsFuseGetAttr (VirtioFs, VirtioFsFile->NodeId, &FuseAttr);
+  if (EFI_ERROR (Status) || VirtioFsFile->FilePosition > FuseAttr.Size) {
+    return EFI_DEVICE_ERROR;
+  }
+
+  Status      = EFI_SUCCESS;
+  Transferred = 0;
+  Left        = *BufferSize;
+  while (Left > 0) {
+    UINT32 ReadSize;
+
+    //
+    // FUSE_READ cannot express a >=4GB buffer size.
+    //
+    ReadSize = (UINT32)MIN ((UINTN)MAX_UINT32, Left);
+    Status = VirtioFsFuseReadFileOrDir (
+               VirtioFs,
+               VirtioFsFile->NodeId,
+               VirtioFsFile->FuseHandle,
+               FALSE,                                    // IsDir
+               VirtioFsFile->FilePosition + Transferred,
+               &ReadSize,
+               (UINT8 *)Buffer + Transferred
+               );
+    if (EFI_ERROR (Status) || ReadSize == 0) {
+      break;
+    }
+    Transferred += ReadSize;
+    Left        -= ReadSize;
+  }
+
+  *BufferSize = Transferred;
+  VirtioFsFile->FilePosition += Transferred;
+  //
+  // If we managed to read some data, return success. If zero bytes were
+  // transferred due to zero-sized buffer on input or due to EOF on first read,
+  // return SUCCESS. Otherwise, return the error due to which zero bytes were
+  // transferred.
+  //
+  return (Transferred > 0) ? EFI_SUCCESS : Status;
+}
+
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileRead (
   IN     EFI_FILE_PROTOCOL *This,
   IN OUT UINTN             *BufferSize,
      OUT VOID              *Buffer
   )
 {
-  return EFI_NO_MEDIA;
+  VIRTIO_FS_FILE *VirtioFsFile;
+  EFI_STATUS     Status;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+
+  if (VirtioFsFile->IsDirectory) {
+    Status = EFI_NO_MEDIA;
+  } else {
+    Status = ReadRegularFile (VirtioFsFile, BufferSize, Buffer);
+  }
+  return Status;
 }
-- 
2.19.1.3.g30247aa5d201



