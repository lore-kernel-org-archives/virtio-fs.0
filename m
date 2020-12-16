From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:52 +0100
Message-Id: <20201216211125.19496-16-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 15/48] OvmfPkg/VirtioFsDxe: flush, sync,
	release and forget in Close() / Delete()
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

The two member functions that free the EFI_FILE_PROTOCOL object are
Close() and Delete(). Before we create VIRTIO_FS_FILE objects with
EFI_FILE_PROTOCOL.Open() later in this patch series, extend each of these
"destructor" functions to get rid of the FuseHandle and NodeId resources
properly -- in a way that matches each function's own purpose.

For the time being, VirtioFsSimpleFileDelete() only gets a reminder about
its core task (namely, removing the file), as the needed machinery will
become only later. But we can already outline the "task list", and deal
with the FuseHandle and NodeId resources. The "task list" of
VirtioFsSimpleFileDelete() is different from that of
VirtioFsSimpleFileClose(), thus both destructors diverge at this point.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h        |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsClose.c      | 34 ++++++++----
 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c     | 55 +++++++++++++++++---
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c |  1 +
 4 files changed, 74 insertions(+), 17 deletions(-)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 7151a62bb42b..1cbd27d8fb52 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -105,16 +105,17 @@ typedef struct {
 //
 // Private context structure that exposes EFI_FILE_PROTOCOL on top of an open
 // FUSE file reference.
 //
 typedef struct {
   UINT64            Signature;
   EFI_FILE_PROTOCOL SimpleFile;
   BOOLEAN           IsDirectory;
+  BOOLEAN           IsOpenForWriting;
   VIRTIO_FS         *OwnerFs;
   LIST_ENTRY        OpenFilesEntry;
   //
   // In the FUSE wire protocol, every request except FUSE_INIT refers to a
   // file, namely by the "VIRTIO_FS_FUSE_REQUEST.NodeId" field; that is, by the
   // inode number of the file. However, some of the FUSE requests that we need
   // for some of the EFI_FILE_PROTOCOL member functions require an open file
   // handle *in addition* to the inode number. For simplicity, whenever a
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
index 01bbeae21473..bc91ad726b2c 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
@@ -19,30 +19,46 @@ VirtioFsSimpleFileClose (
 {
   VIRTIO_FS_FILE *VirtioFsFile;
   VIRTIO_FS      *VirtioFs;
 
   VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
   VirtioFs     = VirtioFsFile->OwnerFs;
 
   //
-  // At this point, the implementation is only suitable for closing the
-  // VIRTIO_FS_FILE that was created by VirtioFsOpenVolume().
+  // All actions in this function are "best effort"; the UEFI spec requires
+  // EFI_FILE_PROTOCOL.Close() to sync all data to the device, but it also
+  // requires EFI_FILE_PROTOCOL.Close() to release resources unconditionally,
+  // and to return EFI_SUCCESS unconditionally.
   //
-  ASSERT (VirtioFsFile->IsDirectory);
-  ASSERT (VirtioFsFile->NodeId == VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID);
-  //
-  // Close the root directory.
-  //
-  // Ignore any errors, because EFI_FILE_PROTOCOL.Close() is required to
-  // release the EFI_FILE_PROTOCOL object unconditionally.
+  // Flush, sync, release, and (if needed) forget. If any action fails, we
+  // still try the others.
   //
+  if (VirtioFsFile->IsOpenForWriting) {
+    if (!VirtioFsFile->IsDirectory) {
+      VirtioFsFuseFlush (VirtioFs, VirtioFsFile->NodeId,
+        VirtioFsFile->FuseHandle);
+    }
+
+    VirtioFsFuseFsyncFileOrDir (VirtioFs, VirtioFsFile->NodeId,
+      VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
+  }
+
   VirtioFsFuseReleaseFileOrDir (VirtioFs, VirtioFsFile->NodeId,
     VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
 
+  //
+  // VirtioFsFile->FuseHandle is gone at this point, but VirtioFsFile->NodeId
+  // is still valid. If we've known VirtioFsFile->NodeId from a lookup, then
+  // now we should ask the server to forget it *once*.
+  //
+  if (VirtioFsFile->NodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+    VirtioFsFuseForget (VirtioFs, VirtioFsFile->NodeId);
+  }
+
   //
   // One fewer file left open for the owner filesystem.
   //
   RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
 
   FreePool (VirtioFsFile);
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
index 3209923d1e49..bbad64bf7886 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
@@ -1,29 +1,68 @@
 /** @file
   EFI_FILE_PROTOCOL.Delete() member function for the Virtio Filesystem driver.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <Library/BaseLib.h>             // RemoveEntryList()
+#include <Library/MemoryAllocationLib.h> // FreePool()
+
 #include "VirtioFsDxe.h"
 
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileDelete (
   IN EFI_FILE_PROTOCOL *This
   )
 {
+  VIRTIO_FS_FILE *VirtioFsFile;
+  VIRTIO_FS      *VirtioFs;
+  EFI_STATUS     Status;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
   //
-  // At this point, the implementation is only suitable for closing the
-  // VIRTIO_FS_FILE that was created by VirtioFsOpenVolume().
+  // All actions in this function are "best effort"; the UEFI spec requires
+  // EFI_FILE_PROTOCOL.Delete() to release resources unconditionally. If a step
+  // related to removing the file fails, it's only reflected in the return
+  // status (EFI_WARN_DELETE_FAILURE rather than EFI_SUCCESS).
   //
-  // Actually deleting the root directory is not possible, so we're only going
-  // to release resources, and return EFI_WARN_DELETE_FAILURE.
+  // Release, remove, and (if needed) forget. We don't waste time flushing and
+  // syncing; if the EFI_FILE_PROTOCOL user cares enough, they should keep the
+  // parent directory open until after this function call returns, and then
+  // force a sync on *that* EFI_FILE_PROTOCOL instance, using either the
+  // Flush() member function, or the Close() member function.
   //
-  // In order to release resources, VirtioFsSimpleFileClose() is just right
-  // here.
+  // If any action fails below, we still try the others.
   //
-  VirtioFsSimpleFileClose (This);
-  return EFI_WARN_DELETE_FAILURE;
+  VirtioFsFuseReleaseFileOrDir (VirtioFs, VirtioFsFile->NodeId,
+    VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
+
+  //
+  // VirtioFsFile->FuseHandle is gone at this point, but VirtioFsFile->NodeId
+  // is still valid. Continue with removing the file or directory. The result
+  // of this operation determines the return status of the function.
+  //
+  // TODO
+  //
+  Status = EFI_WARN_DELETE_FAILURE;
+
+  //
+  // Finally, if we've known VirtioFsFile->NodeId from a lookup, then we should
+  // also ask the server to forget it *once*.
+  //
+  if (VirtioFsFile->NodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+    VirtioFsFuseForget (VirtioFs, VirtioFsFile->NodeId);
+  }
+
+  //
+  // One fewer file left open for the owner filesystem.
+  //
+  RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
+
+  FreePool (VirtioFsFile);
+  return Status;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
index 8c1457a68aad..67d2deb6bdf2 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -57,16 +57,17 @@ VirtioFsOpenVolume (
   VirtioFsFile->SimpleFile.Read        = VirtioFsSimpleFileRead;
   VirtioFsFile->SimpleFile.Write       = VirtioFsSimpleFileWrite;
   VirtioFsFile->SimpleFile.GetPosition = VirtioFsSimpleFileGetPosition;
   VirtioFsFile->SimpleFile.SetPosition = VirtioFsSimpleFileSetPosition;
   VirtioFsFile->SimpleFile.GetInfo     = VirtioFsSimpleFileGetInfo;
   VirtioFsFile->SimpleFile.SetInfo     = VirtioFsSimpleFileSetInfo;
   VirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   VirtioFsFile->IsDirectory            = TRUE;
+  VirtioFsFile->IsOpenForWriting       = FALSE;
   VirtioFsFile->OwnerFs                = VirtioFs;
   VirtioFsFile->NodeId                 = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
   VirtioFsFile->FuseHandle             = RootDirHandle;
 
   //
   // One more file open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &VirtioFsFile->OpenFilesEntry);
-- 
2.19.1.3.g30247aa5d201



