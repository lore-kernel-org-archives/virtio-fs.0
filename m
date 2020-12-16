From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:07 +0100
Message-Id: <20201216211125.19496-31-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 30/48] OvmfPkg/VirtioFsDxe: implement
	EFI_FILE_PROTOCOL.GetInfo()
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
VirtioFsSimpleFileGetInfo().

This allows the "VOL" command to work in the UEFI shell.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf   |   5 +
 OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c | 190 +++++++++++++++++++-
 2 files changed, 194 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 318449db3e63..3cb5c101c3a6 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -120,8 +120,13 @@ [LibraryClasses]
   UefiDriverEntryPoint
   VirtioLib
 
 [Protocols]
   gEfiComponentName2ProtocolGuid        ## PRODUCES
   gEfiDriverBindingProtocolGuid         ## PRODUCES
   gEfiSimpleFileSystemProtocolGuid      ## BY_START
   gVirtioDeviceProtocolGuid             ## TO_START
+
+[Guids]
+  gEfiFileInfoGuid
+  gEfiFileSystemInfoGuid
+  gEfiFileSystemVolumeLabelInfoIdGuid
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c b/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
index 6e870460c014..c8be1d502202 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
@@ -1,21 +1,209 @@
 /** @file
   EFI_FILE_PROTOCOL.GetInfo() member function for the Virtio Filesystem driver.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <Guid/FileSystemInfo.h>            // gEfiFileSystemInfoGuid
+#include <Guid/FileSystemVolumeLabelInfo.h> // gEfiFileSystemVolumeLabelInfo...
+#include <Library/BaseLib.h>                // StrSize()
+#include <Library/BaseMemoryLib.h>          // CompareGuid()
+
 #include "VirtioFsDxe.h"
 
+/**
+  Provide EFI_FILE_INFO about this particular file.
+**/
+STATIC
+EFI_STATUS
+GetFileInfo (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  )
+{
+  VIRTIO_FS_FILE                     *VirtioFsFile;
+  VIRTIO_FS                          *VirtioFs;
+  UINTN                              AllocSize;
+  UINTN                              BasenameSize;
+  EFI_STATUS                         Status;
+  EFI_FILE_INFO                      *FileInfo;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE FuseAttr;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  AllocSize = *BufferSize;
+
+  //
+  // Calculate the needed size.
+  //
+  BasenameSize = 0;
+  Status = VirtioFsGetBasename (VirtioFsFile->CanonicalPathname, NULL,
+             &BasenameSize);
+  ASSERT (Status == EFI_BUFFER_TOO_SMALL);
+  *BufferSize = OFFSET_OF (EFI_FILE_INFO, FileName) + BasenameSize;
+
+  if (*BufferSize > AllocSize) {
+    return EFI_BUFFER_TOO_SMALL;
+  }
+
+  //
+  // Set the structure size, and store the basename.
+  //
+  FileInfo = Buffer;
+  FileInfo->Size = *BufferSize;
+  Status = VirtioFsGetBasename (VirtioFsFile->CanonicalPathname,
+             FileInfo->FileName, &BasenameSize);
+  ASSERT_EFI_ERROR (Status);
+
+  //
+  // Fetch the file attributes, and convert them into the caller's buffer.
+  //
+  Status = VirtioFsFuseGetAttr (VirtioFs, VirtioFsFile->NodeId, &FuseAttr);
+  if (!EFI_ERROR (Status)) {
+    Status = VirtioFsFuseAttrToEfiFileInfo (&FuseAttr, FileInfo);
+  }
+  return (Status == EFI_BUFFER_TOO_SMALL) ? EFI_DEVICE_ERROR : Status;
+}
+
+/**
+  Provide EFI_FILE_SYSTEM_INFO about the filesystem this file lives on.
+**/
+STATIC
+EFI_STATUS
+GetFileSystemInfo (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  )
+{
+  VIRTIO_FS_FILE                 *VirtioFsFile;
+  VIRTIO_FS                      *VirtioFs;
+  UINTN                          AllocSize;
+  UINTN                          LabelSize;
+  EFI_STATUS                     Status;
+  VIRTIO_FS_FUSE_STATFS_RESPONSE FilesysAttr;
+  UINT64                         MaxBlocks;
+  EFI_FILE_SYSTEM_INFO           *FilesysInfo;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  AllocSize = *BufferSize;
+
+  //
+  // Calculate the needed size.
+  //
+  LabelSize = StrSize (VirtioFs->Label);
+  *BufferSize = OFFSET_OF (EFI_FILE_SYSTEM_INFO, VolumeLabel) + LabelSize;
+
+  if (*BufferSize > AllocSize) {
+    return EFI_BUFFER_TOO_SMALL;
+  }
+
+  //
+  // Fetch the filesystem attributes.
+  //
+  Status = VirtioFsFuseStatFs (VirtioFs, VirtioFsFile->NodeId, &FilesysAttr);
+  if (EFI_ERROR (Status)) {
+    return (Status == EFI_BUFFER_TOO_SMALL) ? EFI_DEVICE_ERROR : Status;
+  }
+  //
+  // Sanity checks...
+  //
+  if (FilesysAttr.Frsize != FilesysAttr.Bsize) {
+    return EFI_UNSUPPORTED;
+  }
+  if (FilesysAttr.Frsize == 0 || FilesysAttr.Blocks == 0 ||
+      FilesysAttr.Bavail > FilesysAttr.Blocks) {
+    return EFI_DEVICE_ERROR;
+  }
+  MaxBlocks = DivU64x32 (MAX_UINT64, FilesysAttr.Frsize);
+  if (FilesysAttr.Blocks > MaxBlocks || FilesysAttr.Bavail > MaxBlocks) {
+    return EFI_DEVICE_ERROR;
+  }
+
+  //
+  // Fill in EFI_FILE_SYSTEM_INFO.
+  //
+  FilesysInfo             = Buffer;
+  FilesysInfo->Size       = *BufferSize;
+  FilesysInfo->ReadOnly   = FALSE;
+  FilesysInfo->VolumeSize = MultU64x32 (FilesysAttr.Blocks,
+                              FilesysAttr.Frsize);
+  FilesysInfo->FreeSpace  = MultU64x32 (FilesysAttr.Bavail,
+                              FilesysAttr.Frsize);
+  FilesysInfo->BlockSize  = FilesysAttr.Frsize;
+  CopyMem (FilesysInfo->VolumeLabel, VirtioFs->Label, LabelSize);
+
+  return EFI_SUCCESS;
+}
+
+/**
+  Return the filesystem label as EFI_FILE_SYSTEM_VOLUME_LABEL.
+**/
+STATIC
+EFI_STATUS
+GetFileSystemVolumeLabelInfo (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  )
+{
+  VIRTIO_FS_FILE               *VirtioFsFile;
+  VIRTIO_FS                    *VirtioFs;
+  UINTN                        AllocSize;
+  UINTN                        LabelSize;
+  EFI_FILE_SYSTEM_VOLUME_LABEL *FilesysVolumeLabel;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  AllocSize = *BufferSize;
+
+  //
+  // Calculate the needed size.
+  //
+  LabelSize = StrSize (VirtioFs->Label);
+  *BufferSize = (OFFSET_OF (EFI_FILE_SYSTEM_VOLUME_LABEL, VolumeLabel) +
+                 LabelSize);
+
+  if (*BufferSize > AllocSize) {
+    return EFI_BUFFER_TOO_SMALL;
+  }
+
+  //
+  // Store the label.
+  //
+  FilesysVolumeLabel = Buffer;
+  CopyMem (FilesysVolumeLabel->VolumeLabel, VirtioFs->Label, LabelSize);
+
+  return EFI_SUCCESS;
+}
+
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileGetInfo (
   IN     EFI_FILE_PROTOCOL *This,
   IN     EFI_GUID          *InformationType,
   IN OUT UINTN             *BufferSize,
      OUT VOID              *Buffer
   )
 {
-  return EFI_NO_MEDIA;
+  if (CompareGuid (InformationType, &gEfiFileInfoGuid)) {
+    return GetFileInfo (This, BufferSize, Buffer);
+  }
+
+  if (CompareGuid (InformationType, &gEfiFileSystemInfoGuid)) {
+    return GetFileSystemInfo (This, BufferSize, Buffer);
+  }
+
+  if (CompareGuid (InformationType, &gEfiFileSystemVolumeLabelInfoIdGuid)) {
+    return GetFileSystemVolumeLabelInfo (This, BufferSize, Buffer);
+  }
+
+  return EFI_UNSUPPORTED;
 }
-- 
2.19.1.3.g30247aa5d201



