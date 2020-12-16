From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:58 +0100
Message-Id: <20201216211125.19496-22-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 21/48] OvmfPkg/VirtioFsDxe: convert FUSE
	inode attributes to EFI_FILE_INFO
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

Introduce the VirtioFsFuseAttrToEfiFileInfo() function, for converting
FUSE inode attributes to EFI_FILE_INFO.

The EpochToEfiTime() function from EmbeddedPkg's TimeBaseLib proves
invaluable for converting the file access times.

This is the first time we consume TimeBaseLib in OvmfPkg, so add the
necessary lib class resolution. We need not modify any ArmVirtPkg DSC
files: see commit af5fed90bfbf ("ArmPlatformPkg,ArmVirtPkg: delete
redundant PL031 functions", 2017-05-10).

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/OvmfPkgIa32.dsc                     |   1 +
 OvmfPkg/OvmfPkgIa32X64.dsc                  |   1 +
 OvmfPkg/OvmfPkgX64.dsc                      |   1 +
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |   3 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   2 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   7 ++
 OvmfPkg/VirtioFsDxe/Helpers.c               | 119 ++++++++++++++++++++
 7 files changed, 134 insertions(+)

diff --git a/OvmfPkg/OvmfPkgIa32.dsc b/OvmfPkg/OvmfPkgIa32.dsc
index 4ff70674fb6e..26a013ec353e 100644
--- a/OvmfPkg/OvmfPkgIa32.dsc
+++ b/OvmfPkg/OvmfPkgIa32.dsc
@@ -120,16 +120,17 @@ [SkuIds]
 [LibraryClasses]
   PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
   TimerLib|OvmfPkg/Library/AcpiTimerLib/BaseAcpiTimerLib.inf
   ResetSystemLib|OvmfPkg/Library/ResetSystemLib/BaseResetSystemLib.inf
   PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
   BaseMemoryLib|MdePkg/Library/BaseMemoryLibRepStr/BaseMemoryLibRepStr.inf
   BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
   SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
+  TimeBaseLib|EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.inf
   BmpSupportLib|MdeModulePkg/Library/BaseBmpSupportLib/BaseBmpSupportLib.inf
   SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
   CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
   PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
   PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
   CacheMaintenanceLib|MdePkg/Library/BaseCacheMaintenanceLib/BaseCacheMaintenanceLib.inf
   UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
   UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
diff --git a/OvmfPkg/OvmfPkgIa32X64.dsc b/OvmfPkg/OvmfPkgIa32X64.dsc
index d40a59183c79..10579fe46c5b 100644
--- a/OvmfPkg/OvmfPkgIa32X64.dsc
+++ b/OvmfPkg/OvmfPkgIa32X64.dsc
@@ -124,16 +124,17 @@ [SkuIds]
 [LibraryClasses]
   PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
   TimerLib|OvmfPkg/Library/AcpiTimerLib/BaseAcpiTimerLib.inf
   ResetSystemLib|OvmfPkg/Library/ResetSystemLib/BaseResetSystemLib.inf
   PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
   BaseMemoryLib|MdePkg/Library/BaseMemoryLibRepStr/BaseMemoryLibRepStr.inf
   BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
   SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
+  TimeBaseLib|EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.inf
   BmpSupportLib|MdeModulePkg/Library/BaseBmpSupportLib/BaseBmpSupportLib.inf
   SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
   CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
   PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
   PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
   CacheMaintenanceLib|MdePkg/Library/BaseCacheMaintenanceLib/BaseCacheMaintenanceLib.inf
   UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
   UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
diff --git a/OvmfPkg/OvmfPkgX64.dsc b/OvmfPkg/OvmfPkgX64.dsc
index ec7886235acf..c9235e48ad62 100644
--- a/OvmfPkg/OvmfPkgX64.dsc
+++ b/OvmfPkg/OvmfPkgX64.dsc
@@ -124,16 +124,17 @@ [SkuIds]
 [LibraryClasses]
   PcdLib|MdePkg/Library/BasePcdLibNull/BasePcdLibNull.inf
   TimerLib|OvmfPkg/Library/AcpiTimerLib/BaseAcpiTimerLib.inf
   ResetSystemLib|OvmfPkg/Library/ResetSystemLib/BaseResetSystemLib.inf
   PrintLib|MdePkg/Library/BasePrintLib/BasePrintLib.inf
   BaseMemoryLib|MdePkg/Library/BaseMemoryLibRepStr/BaseMemoryLibRepStr.inf
   BaseLib|MdePkg/Library/BaseLib/BaseLib.inf
   SafeIntLib|MdePkg/Library/BaseSafeIntLib/BaseSafeIntLib.inf
+  TimeBaseLib|EmbeddedPkg/Library/TimeBaseLib/TimeBaseLib.inf
   BmpSupportLib|MdeModulePkg/Library/BaseBmpSupportLib/BaseBmpSupportLib.inf
   SynchronizationLib|MdePkg/Library/BaseSynchronizationLib/BaseSynchronizationLib.inf
   CpuLib|MdePkg/Library/BaseCpuLib/BaseCpuLib.inf
   PerformanceLib|MdePkg/Library/BasePerformanceLibNull/BasePerformanceLibNull.inf
   PeCoffLib|MdePkg/Library/BasePeCoffLib/BasePeCoffLib.inf
   CacheMaintenanceLib|MdePkg/Library/BaseCacheMaintenanceLib/BaseCacheMaintenanceLib.inf
   UefiDecompressLib|MdePkg/Library/BaseUefiDecompressLib/BaseUefiDecompressLib.inf
   UefiHiiServicesLib|MdeModulePkg/Library/UefiHiiServicesLib/UefiHiiServicesLib.inf
diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 63aced229e9b..5d1d990a2d83 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -79,16 +79,19 @@ typedef struct {
 //
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
 //
 // File mode bitmasks.
 //
+#define VIRTIO_FS_FUSE_MODE_TYPE_MASK 0170000u
+#define VIRTIO_FS_FUSE_MODE_TYPE_REG  0100000u
+#define VIRTIO_FS_FUSE_MODE_TYPE_DIR  0040000u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXU 0000700u
 #define VIRTIO_FS_FUSE_MODE_PERM_RUSR 0000400u
 #define VIRTIO_FS_FUSE_MODE_PERM_WUSR 0000200u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXG 0000070u
 #define VIRTIO_FS_FUSE_MODE_PERM_RGRP 0000040u
 #define VIRTIO_FS_FUSE_MODE_PERM_WGRP 0000020u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXO 0000007u
 #define VIRTIO_FS_FUSE_MODE_PERM_ROTH 0000004u
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index b942baa4a772..7d7272188465 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -72,16 +72,17 @@
 [Defines]
   INF_VERSION                           = 1.29
   BASE_NAME                             = VirtioFsDxe
   FILE_GUID                             = 7BD9DDF7-8B83-488E-AEC9-24C78610289C
   MODULE_TYPE                           = UEFI_DRIVER
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
+  EmbeddedPkg/EmbeddedPkg.dec
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseFlush.c
   FuseForget.c
   FuseFsync.c
@@ -105,16 +106,17 @@ [Sources]
   SimpleFsWrite.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   BaseMemoryLib
   DebugLib
   MemoryAllocationLib
+  TimeBaseLib
   UefiBootServicesTableLib
   UefiDriverEntryPoint
   VirtioLib
 
 [Protocols]
   gEfiComponentName2ProtocolGuid        ## PRODUCES
   gEfiDriverBindingProtocolGuid         ## PRODUCES
   gEfiSimpleFileSystemProtocolGuid      ## BY_START
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 795cf4ee5d7d..6cc5257bab40 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -6,16 +6,17 @@
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
 #ifndef VIRTIO_FS_DXE_H_
 #define VIRTIO_FS_DXE_H_
 
 #include <Base.h>                      // SIGNATURE_64()
+#include <Guid/FileInfo.h>             // EFI_FILE_INFO
 #include <IndustryStandard/VirtioFs.h> // VIRTIO_FS_TAG_BYTES
 #include <Library/DebugLib.h>          // CR()
 #include <Protocol/SimpleFileSystem.h> // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
 #include <Protocol/VirtioDevice.h>     // VIRTIO_DEVICE_PROTOCOL
 #include <Uefi/UefiBaseType.h>         // EFI_EVENT
 
 #define VIRTIO_FS_SIG SIGNATURE_64 ('V', 'I', 'R', 'T', 'I', 'O', 'F', 'S')
 
@@ -220,16 +221,22 @@ VirtioFsErrnoToEfiStatus (
 EFI_STATUS
 VirtioFsAppendPath (
   IN     CHAR8   *LhsPath8,
   IN     CHAR16  *RhsPath16,
      OUT CHAR8   **ResultPath8,
      OUT BOOLEAN *RootEscape
   );
 
+EFI_STATUS
+VirtioFsFuseAttrToEfiFileInfo (
+  IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
+     OUT EFI_FILE_INFO                      *FileInfo
+  );
+
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseForget (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 4a7b59332ca9..fa656bb535b8 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -4,16 +4,17 @@
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
 #include <Library/BaseLib.h>             // StrLen()
 #include <Library/BaseMemoryLib.h>       // CopyMem()
 #include <Library/MemoryAllocationLib.h> // AllocatePool()
+#include <Library/TimeBaseLib.h>         // EpochToEfiTime()
 #include <Library/VirtioLib.h>           // Virtio10WriteFeatures()
 
 #include "VirtioFsDxe.h"
 
 /**
   Read the Virtio Filesystem device configuration structure in full.
 
   @param[in] Virtio   The Virtio protocol underlying the VIRTIO_FS object.
@@ -1584,8 +1585,126 @@ VirtioFsAppendPath (
   if (RhsPath8[0] != '/') {
     FreePool (BufferToSanitize);
   }
 
 FreeRhsPath8:
   FreePool (RhsPath8);
   return Status;
 }
+
+/**
+  Convert select fields of a VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
+  corresponding fields in EFI_FILE_INFO.
+
+  @param[in] FuseAttr   The VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
+                        convert the relevant fields from.
+
+  @param[out] FileInfo  The EFI_FILE_INFO structure to modify. Importantly, the
+                        FileInfo->Size and FileInfo->FileName fields are not
+                        overwritten.
+
+  @retval EFI_SUCCESS      Conversion successful.
+
+  @retval EFI_UNSUPPORTED  The allocated size of the file is inexpressible in
+                           EFI_FILE_INFO.
+
+  @retval EFI_UNSUPPORTED  One of the file access times is inexpressible in
+                           EFI_FILE_INFO.
+
+  @retval EFI_UNSUPPORTED  The file type is inexpressible in EFI_FILE_INFO.
+
+  @retval EFI_UNSUPPORTED  The file is a regular file that has multiple names
+                           on the host side (i.e., its hard link count is
+                           greater than one).
+**/
+EFI_STATUS
+VirtioFsFuseAttrToEfiFileInfo (
+  IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
+     OUT EFI_FILE_INFO                      *FileInfo
+  )
+{
+  UINT64   EpochTime[3];
+  EFI_TIME *ConvertedTime[ARRAY_SIZE (EpochTime)];
+  UINTN    Idx;
+
+  FileInfo->FileSize = FuseAttr->Size;
+
+  //
+  // The unit for FuseAttr->Blocks is 512B.
+  //
+  if (FuseAttr->Blocks >= BIT55) {
+    return EFI_UNSUPPORTED;
+  }
+  FileInfo->PhysicalSize = LShiftU64 (FuseAttr->Blocks, 9);
+
+  //
+  // Convert the timestamps. File creation time is not tracked by the Virtio
+  // Filesystem device, so set FileInfo->CreateTime from FuseAttr->Mtime as
+  // well.
+  //
+  EpochTime[0]     = FuseAttr->Mtime;
+  EpochTime[1]     = FuseAttr->Atime;
+  EpochTime[2]     = FuseAttr->Mtime;
+  ConvertedTime[0] = &FileInfo->CreateTime;
+  ConvertedTime[1] = &FileInfo->LastAccessTime;
+  ConvertedTime[2] = &FileInfo->ModificationTime;
+
+  for (Idx = 0; Idx < ARRAY_SIZE (EpochTime); Idx++) {
+    //
+    // EpochToEfiTime() takes a UINTN for seconds.
+    //
+    if (EpochTime[Idx] > MAX_UINTN) {
+      return EFI_UNSUPPORTED;
+    }
+    //
+    // Set the following fields in the converted time: Year, Month, Day, Hour,
+    // Minute, Second, Nanosecond.
+    //
+    EpochToEfiTime ((UINTN)EpochTime[Idx], ConvertedTime[Idx]);
+    //
+    // The times are all expressed in UTC. Consequently, they are not affected
+    // by daylight saving.
+    //
+    ConvertedTime[Idx]->TimeZone = 0;
+    ConvertedTime[Idx]->Daylight = 0;
+    //
+    // Clear the padding fields.
+    //
+    ConvertedTime[Idx]->Pad1 = 0;
+    ConvertedTime[Idx]->Pad2 = 0;
+  }
+
+  //
+  // Set the attributes.
+  //
+  switch (FuseAttr->Mode & VIRTIO_FS_FUSE_MODE_TYPE_MASK) {
+  case VIRTIO_FS_FUSE_MODE_TYPE_DIR:
+    FileInfo->Attribute = EFI_FILE_DIRECTORY;
+    break;
+  case VIRTIO_FS_FUSE_MODE_TYPE_REG:
+    FileInfo->Attribute = 0;
+    break;
+  default:
+    //
+    // Other file types are not supported.
+    //
+    return EFI_UNSUPPORTED;
+  }
+  //
+  // Report the regular file or directory as read-only if all classes lack
+  // write permission.
+  //
+  if ((FuseAttr->Mode & (VIRTIO_FS_FUSE_MODE_PERM_WUSR |
+                         VIRTIO_FS_FUSE_MODE_PERM_WGRP |
+                         VIRTIO_FS_FUSE_MODE_PERM_WOTH)) == 0) {
+    FileInfo->Attribute |= EFI_FILE_READ_ONLY;
+  }
+
+  //
+  // A hard link count greater than 1 is not supported for regular files.
+  //
+  if ((FileInfo->Attribute & EFI_FILE_DIRECTORY) == 0 && FuseAttr->Nlink > 1) {
+    return EFI_UNSUPPORTED;
+  }
+
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



