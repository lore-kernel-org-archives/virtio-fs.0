From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:20 +0100
Message-Id: <20201216211125.19496-44-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 43/48] OvmfPkg/VirtioFsDxe: handle file
	rename/move in EFI_FILE_PROTOCOL.SetInfo
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

Using the functions introduced previously, we can now implement the rename
operation in VirtioFsSimpleFileSetInfo().

Attribute updates come later.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c | 234 +++++++++++++++++++-
 1 file changed, 233 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
index 895b5c029a9e..55169dde78b7 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
@@ -5,16 +5,17 @@
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
 #include <Guid/FileSystemInfo.h>            // gEfiFileSystemInfoGuid
 #include <Guid/FileSystemVolumeLabelInfo.h> // gEfiFileSystemVolumeLabelInfo...
 #include <Library/BaseLib.h>                // StrCmp()
 #include <Library/BaseMemoryLib.h>          // CompareGuid()
+#include <Library/MemoryAllocationLib.h>    // FreePool()
 
 #include "VirtioFsDxe.h"
 
 /**
   Validate a buffer that the EFI_FILE_PROTOCOL.SetInfo() caller passes in for a
   particular InformationType GUID.
 
   The structure to be validated is supposed to end with a variable-length,
@@ -122,16 +123,247 @@ ValidateInfoStructure (
   NameField = (CHAR16 *)((UINT8 *)Buffer + NameFieldByteOffset);
   if (NameField[NameFieldChar16s - 1] != L'\0') {
     return EFI_INVALID_PARAMETER;
   }
 
   return EFI_SUCCESS;
 }
 
+/**
+  Rename a VIRTIO_FS_FILE as requested in EFI_FILE_INFO.FileName.
+
+  @param[in,out] VirtioFsFile  The VIRTIO_FS_FILE to rename.
+
+  @param[in] NewFileName       The new file name requested by
+                               EFI_FILE_PROTOCOL.SetInfo().
+
+  @retval EFI_SUCCESS        The canonical format destination path that is
+                             determined from the input value of
+                             VirtioFsFile->CanonicalPathname and from
+                             NewFileName is identical to the input value of
+                             VirtioFsFile->CanonicalPathname. This means that
+                             EFI_FILE_INFO does not constitute a rename
+                             request. VirtioFsFile has not been changed.
+
+  @retval EFI_SUCCESS        VirtioFsFile has been renamed.
+                             VirtioFsFile->CanonicalPathname has assumed the
+                             destination pathname in canonical format.
+
+  @retval EFI_ACCESS_DENIED  VirtioFsFile refers to the root directory, and
+                             NewFileName expresses an actual rename/move
+                             request.
+
+  @retval EFI_ACCESS_DENIED  VirtioFsFile is the (possibly indirect) parent
+                             directory of at least one other VIRTIO_FS_FILE
+                             that is open for the same Virtio Filesystem
+                             (identified by VirtioFsFile->OwnerFs). Renaming
+                             VirtioFsFile would invalidate the canonical
+                             pathnames of those VIRTIO_FS_FILE instances;
+                             therefore the request has been rejected.
+
+  @retval EFI_ACCESS_DENIED  VirtioFsFile is not open for writing, but
+                             NewFileName expresses an actual rename/move
+                             request.
+
+  @retval EFI_NOT_FOUND      At least one dot-dot component in NewFileName
+                             attempted to escape the root directory.
+
+  @return                    Error codes propagated from underlying functions.
+**/
+STATIC
+EFI_STATUS
+Rename (
+  IN OUT VIRTIO_FS_FILE *VirtioFsFile,
+  IN     CHAR16         *NewFileName
+  )
+{
+
+  VIRTIO_FS  *VirtioFs;
+  EFI_STATUS Status;
+  CHAR8      *Destination;
+  BOOLEAN    RootEscape;
+  UINT64     OldParentDirNodeId;
+  CHAR8      *OldLastComponent;
+  UINT64     NewParentDirNodeId;
+  CHAR8      *NewLastComponent;
+
+  VirtioFs = VirtioFsFile->OwnerFs;
+
+  //
+  // The root directory cannot be renamed.
+  //
+  if (AsciiStrCmp (VirtioFsFile->CanonicalPathname, "/") == 0) {
+    if (StrCmp (NewFileName, L"") == 0) {
+      //
+      // Not a rename request anyway.
+      //
+      return EFI_SUCCESS;
+    }
+    return EFI_ACCESS_DENIED;
+  }
+
+  //
+  // Compose the canonical pathname for the destination.
+  //
+  Status = VirtioFsComposeRenameDestination (VirtioFsFile->CanonicalPathname,
+             NewFileName, &Destination, &RootEscape);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  if (RootEscape) {
+    Status = EFI_NOT_FOUND;
+    goto FreeDestination;
+  }
+  //
+  // If the rename would leave VirtioFsFile->CanonicalPathname unchanged, then
+  // EFI_FILE_PROTOCOL.SetInfo() isn't asking for a rename actually.
+  //
+  if (AsciiStrCmp (VirtioFsFile->CanonicalPathname, Destination) == 0) {
+    Status = EFI_SUCCESS;
+    goto FreeDestination;
+  }
+  //
+  // Check if the rename would break the canonical pathnames of other
+  // VIRTIO_FS_FILE instances of the same VIRTIO_FS.
+  //
+  if (VirtioFsFile->IsDirectory) {
+    UINTN      PathLen;
+    LIST_ENTRY *OpenFilesEntry;
+
+    PathLen = AsciiStrLen (VirtioFsFile->CanonicalPathname);
+    BASE_LIST_FOR_EACH (OpenFilesEntry, &VirtioFs->OpenFiles) {
+      VIRTIO_FS_FILE *OtherFile;
+
+      OtherFile = VIRTIO_FS_FILE_FROM_OPEN_FILES_ENTRY (OpenFilesEntry);
+      if (OtherFile != VirtioFsFile &&
+          AsciiStrnCmp (VirtioFsFile->CanonicalPathname,
+            OtherFile->CanonicalPathname, PathLen) == 0 &&
+          (OtherFile->CanonicalPathname[PathLen] == '\0' ||
+           OtherFile->CanonicalPathname[PathLen] == '/')) {
+        //
+        // OtherFile refers to the same directory as VirtioFsFile, or is a
+        // (possibly indirect) child of the directory referred to by
+        // VirtioFsFile.
+        //
+        Status = EFI_ACCESS_DENIED;
+        goto FreeDestination;
+      }
+    }
+  }
+  //
+  // From this point on, the file needs to be open for writing.
+  //
+  if (!VirtioFsFile->IsOpenForWriting) {
+    Status = EFI_ACCESS_DENIED;
+    goto FreeDestination;
+  }
+  //
+  // Split both source and destination canonical pathnames into (most specific
+  // parent directory, last component) pairs.
+  //
+  Status = VirtioFsLookupMostSpecificParentDir (VirtioFs,
+             VirtioFsFile->CanonicalPathname, &OldParentDirNodeId,
+             &OldLastComponent);
+  if (EFI_ERROR (Status)) {
+    goto FreeDestination;
+  }
+  Status = VirtioFsLookupMostSpecificParentDir (VirtioFs, Destination,
+             &NewParentDirNodeId, &NewLastComponent);
+  if (EFI_ERROR (Status)) {
+    goto ForgetOldParentDirNodeId;
+  }
+  //
+  // Perform the rename. If the destination path exists, the rename will fail.
+  //
+  Status = VirtioFsFuseRename (VirtioFs, OldParentDirNodeId, OldLastComponent,
+             NewParentDirNodeId, NewLastComponent);
+  if (EFI_ERROR (Status)) {
+    goto ForgetNewParentDirNodeId;
+  }
+
+  //
+  // Swap in the new canonical pathname.
+  //
+  FreePool (VirtioFsFile->CanonicalPathname);
+  VirtioFsFile->CanonicalPathname = Destination;
+  Destination = NULL;
+  Status = EFI_SUCCESS;
+
+  //
+  // Fall through.
+  //
+ForgetNewParentDirNodeId:
+  if (NewParentDirNodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+    VirtioFsFuseForget (VirtioFs, NewParentDirNodeId);
+  }
+
+ForgetOldParentDirNodeId:
+  if (OldParentDirNodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+    VirtioFsFuseForget (VirtioFs, OldParentDirNodeId);
+  }
+
+FreeDestination:
+  if (Destination != NULL) {
+    FreePool (Destination);
+  }
+  return Status;
+}
+
+/**
+  Process an EFI_FILE_INFO setting request.
+**/
+STATIC
+EFI_STATUS
+SetFileInfo (
+  IN EFI_FILE_PROTOCOL *This,
+  IN UINTN             BufferSize,
+  IN VOID              *Buffer
+  )
+{
+  VIRTIO_FS_FILE *VirtioFsFile;
+  EFI_STATUS     Status;
+  EFI_FILE_INFO  *FileInfo;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+
+  //
+  // Validate if Buffer passes as EFI_FILE_INFO.
+  //
+  Status = ValidateInfoStructure (
+             BufferSize,                    // SizeByProtocolCaller
+             OFFSET_OF (EFI_FILE_INFO,
+               FileName) + sizeof (CHAR16), // MinimumStructSize
+             TRUE,                          // IsSizeByInfoPresent
+             Buffer
+             );
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  FileInfo = Buffer;
+
+  //
+  // Perform the rename/move request, if any.
+  //
+  Status = Rename (VirtioFsFile, FileInfo->FileName);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  //
+  // Update any attributes requested.
+  //
+  Status = EFI_UNSUPPORTED;
+  //
+  // The UEFI spec does not speak about partial failure in
+  // EFI_FILE_PROTOCOL.SetInfo(); we won't try to roll back the rename (if
+  // there was one) in case the attribute updates fail.
+  //
+  return Status;
+}
+
 /**
   Process an EFI_FILE_SYSTEM_INFO setting request.
 **/
 STATIC
 EFI_STATUS
 SetFileSystemInfo (
   IN EFI_FILE_PROTOCOL *This,
   IN UINTN             BufferSize,
@@ -225,17 +457,17 @@ EFIAPI
 VirtioFsSimpleFileSetInfo (
   IN EFI_FILE_PROTOCOL *This,
   IN EFI_GUID          *InformationType,
   IN UINTN             BufferSize,
   IN VOID              *Buffer
   )
 {
   if (CompareGuid (InformationType, &gEfiFileInfoGuid)) {
-    return EFI_UNSUPPORTED;
+    return SetFileInfo (This, BufferSize, Buffer);
   }
 
   if (CompareGuid (InformationType, &gEfiFileSystemInfoGuid)) {
     return SetFileSystemInfo (This, BufferSize, Buffer);
   }
 
   if (CompareGuid (InformationType, &gEfiFileSystemVolumeLabelInfoIdGuid)) {
     return SetFileSystemVolumeLabelInfo (This, BufferSize, Buffer);
-- 
2.19.1.3.g30247aa5d201



