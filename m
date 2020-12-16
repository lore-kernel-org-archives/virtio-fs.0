From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:48 +0100
Message-Id: <20201216211125.19496-12-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 11/48] OvmfPkg/VirtioFsDxe: implement
	EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume()
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

With the help of the VirtioFsFuseOpenDir() and
VirtioFsFuseReleaseFileOrDir() functions introduced previously, we can now
open and close the root directory. So let's implement
EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume().

OpenVolume() creates a new EFI_FILE_PROTOCOL object -- a reference to the
root directory of the filesystem. Thus, we have to start tracking
references to EFI_SIMPLE_FILE_SYSTEM_PROTOCOL, lest we unbind the
virtio-fs device while files are open.

There are two methods that release an EFI_FILE_PROTOCOL object: the
Close() and the Delete() member functions. In particular, they are not
allowed to fail with regard to resource management -- they must release
resources unconditionally. Thus, for rolling back the resource accounting
that we do in EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume(), we have to
implement the first versions of EFI_FILE_PROTOCOL.Close() and
EFI_FILE_PROTOCOL.Delete() in this patch as well.

With this patch applied, the UEFI shell can enter the root directory of
the Virtio Filesystem (such as with the "FS3:" shell command), and the
"DIR" shell command exercises FUSE_OPENDIR and FUSE_RELEASEDIR, according
to the virtiofsd log. The "DIR" command reports the root directory as if
it were empty; probably because at this time, we only allow the shell to
open and to close the root directory, but not to read it.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |   5 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |  10 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           | 117 ++++++++++++++++++++
 OvmfPkg/VirtioFsDxe/DriverBinding.c         |   5 +
 OvmfPkg/VirtioFsDxe/SimpleFsClose.c         |  48 ++++++++
 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c        |  29 +++++
 OvmfPkg/VirtioFsDxe/SimpleFsFlush.c         |  18 +++
 OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c       |  21 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c   |  20 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsOpen.c          |  22 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c    |  57 +++++++++-
 OvmfPkg/VirtioFsDxe/SimpleFsRead.c          |  20 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c       |  21 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c   |  20 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsWrite.c         |  20 ++++
 15 files changed, 432 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index c17a43c160e3..67fcf975e8b2 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -71,16 +71,21 @@ typedef struct {
 // out at commit (c6ff213fe5b8^) = d78092e4937d ("fuse: fix page dereference
 // after free", 2020-09-18); that is, right before commit c6ff213fe5b8 ("fuse:
 // add submount support to <uapi/linux/fuse.h>", 2020-09-18) introduces FUSE
 // interface version 7.32.
 //
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
+//
+// The inode number of the root directory.
+//
+#define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
+
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 95b1a5a8f60a..28e66082ecfe 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -81,17 +81,27 @@ [Packages]
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseInit.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
+  SimpleFsClose.c
+  SimpleFsDelete.c
+  SimpleFsFlush.c
+  SimpleFsGetInfo.c
+  SimpleFsGetPosition.c
+  SimpleFsOpen.c
   SimpleFsOpenVolume.c
+  SimpleFsRead.c
+  SimpleFsSetInfo.c
+  SimpleFsSetPosition.c
+  SimpleFsWrite.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   DebugLib
   MemoryAllocationLib
   UefiBootServicesTableLib
   UefiDriverEntryPoint
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index a99625d0473a..34574d0596fc 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -14,16 +14,19 @@
 #include <IndustryStandard/VirtioFs.h> // VIRTIO_FS_TAG_BYTES
 #include <Library/DebugLib.h>          // CR()
 #include <Protocol/SimpleFileSystem.h> // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
 #include <Protocol/VirtioDevice.h>     // VIRTIO_DEVICE_PROTOCOL
 #include <Uefi/UefiBaseType.h>         // EFI_EVENT
 
 #define VIRTIO_FS_SIG SIGNATURE_64 ('V', 'I', 'R', 'T', 'I', 'O', 'F', 'S')
 
+#define VIRTIO_FS_FILE_SIG \
+  SIGNATURE_64 ('V', 'I', 'O', 'F', 'S', 'F', 'I', 'L')
+
 //
 // Filesystem label encoded in UCS-2, transformed from the UTF-8 representation
 // in "VIRTIO_FS_CONFIG.Tag", and NUL-terminated. Only the printable ASCII code
 // points (U+0020 through U+007E) are supported.
 //
 typedef CHAR16 VIRTIO_FS_LABEL[VIRTIO_FS_TAG_BYTES + 1];
 
 //
@@ -41,16 +44,17 @@ typedef struct {
   UINT64                          Signature; // DriverBindingStart  0
   VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
   VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
   UINT16                          QueueSize; // VirtioFsInit        1
   VRING                           Ring;      // VirtioRingInit      2
   VOID                            *RingMap;  // VirtioRingMap       2
   UINT64                          RequestId; // FuseInitSession     1
   EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
+  LIST_ENTRY                      OpenFiles; // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
 //
 // Structure for describing a contiguous buffer, potentially mapped for Virtio
@@ -93,16 +97,49 @@ typedef struct {
   UINTN               NumVec;
   //
   // TotalSize is calculated when the scatter-gather list is initially
   // validated.
   //
   UINT32 TotalSize;
 } VIRTIO_FS_SCATTER_GATHER_LIST;
 
+//
+// Private context structure that exposes EFI_FILE_PROTOCOL on top of an open
+// FUSE file reference.
+//
+typedef struct {
+  UINT64            Signature;
+  EFI_FILE_PROTOCOL SimpleFile;
+  BOOLEAN           IsDirectory;
+  VIRTIO_FS         *OwnerFs;
+  LIST_ENTRY        OpenFilesEntry;
+  //
+  // In the FUSE wire protocol, every request except FUSE_INIT refers to a
+  // file, namely by the "VIRTIO_FS_FUSE_REQUEST.NodeId" field; that is, by the
+  // inode number of the file. However, some of the FUSE requests that we need
+  // for some of the EFI_FILE_PROTOCOL member functions require an open file
+  // handle *in addition* to the inode number. For simplicity, whenever a
+  // VIRTIO_FS_FILE object is created, primarily defined by its NodeId field,
+  // we also *open* the referenced file at once, and save the returned file
+  // handle in the FuseHandle field. This way, when an EFI_FILE_PROTOCOL member
+  // function must send a FUSE request that needs the file handle *in addition*
+  // to the inode number, FuseHandle will be at our disposal at once.
+  //
+  UINT64 NodeId;
+  UINT64 FuseHandle;
+} VIRTIO_FS_FILE;
+
+#define VIRTIO_FS_FILE_FROM_SIMPLE_FILE(SimpleFileReference) \
+  CR (SimpleFileReference, VIRTIO_FS_FILE, SimpleFile, VIRTIO_FS_FILE_SIG);
+
+#define VIRTIO_FS_FILE_FROM_OPEN_FILES_ENTRY(OpenFilesEntryReference) \
+  CR (OpenFilesEntryReference, VIRTIO_FS_FILE, OpenFilesEntry, \
+    VIRTIO_FS_FILE_SIG);
+
 //
 // Initialization and helper routines for the Virtio Filesystem device.
 //
 
 EFI_STATUS
 VirtioFsInit (
   IN OUT VIRTIO_FS *VirtioFs
   );
@@ -185,9 +222,89 @@ VirtioFsFuseOpenDir (
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
   IN  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *This,
   OUT EFI_FILE_PROTOCOL               **Root
   );
 
+//
+// EFI_FILE_PROTOCOL member functions for the Virtio Filesystem driver.
+//
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileClose (
+  IN EFI_FILE_PROTOCOL *This
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileDelete (
+  IN EFI_FILE_PROTOCOL *This
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileFlush (
+  IN EFI_FILE_PROTOCOL *This
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileGetInfo (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN     EFI_GUID          *InformationType,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileGetPosition (
+  IN     EFI_FILE_PROTOCOL *This,
+     OUT UINT64            *Position
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileOpen (
+  IN     EFI_FILE_PROTOCOL *This,
+     OUT EFI_FILE_PROTOCOL **NewHandle,
+  IN     CHAR16            *FileName,
+  IN     UINT64            OpenMode,
+  IN     UINT64            Attributes
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileRead (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileSetInfo (
+  IN EFI_FILE_PROTOCOL *This,
+  IN EFI_GUID          *InformationType,
+  IN UINTN             BufferSize,
+  IN VOID              *Buffer
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileSetPosition (
+  IN EFI_FILE_PROTOCOL *This,
+  IN UINT64            Position
+  );
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileWrite (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+  IN     VOID              *Buffer
+  );
+
 #endif // VIRTIO_FS_DXE_H_
diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/DriverBinding.c
index 4f77ffaa9953..e273c9f362eb 100644
--- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -90,16 +90,17 @@ VirtioFsBindingStart (
   }
 
   Status = gBS->CreateEvent (EVT_SIGNAL_EXIT_BOOT_SERVICES, TPL_CALLBACK,
                   VirtioFsExitBoot, VirtioFs, &VirtioFs->ExitBoot);
   if (EFI_ERROR (Status)) {
     goto UninitVirtioFs;
   }
 
+  InitializeListHead (&VirtioFs->OpenFiles);
   VirtioFs->SimpleFs.Revision   = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVISION;
   VirtioFs->SimpleFs.OpenVolume = VirtioFsOpenVolume;
 
   Status = gBS->InstallProtocolInterface (&ControllerHandle,
                   &gEfiSimpleFileSystemProtocolGuid, EFI_NATIVE_INTERFACE,
                   &VirtioFs->SimpleFs);
   if (EFI_ERROR (Status)) {
     goto CloseExitBoot;
@@ -144,16 +145,20 @@ VirtioFsBindingStop (
                   This->DriverBindingHandle, ControllerHandle,
                   EFI_OPEN_PROTOCOL_GET_PROTOCOL);
   if (EFI_ERROR (Status)) {
     return Status;
   }
 
   VirtioFs = VIRTIO_FS_FROM_SIMPLE_FS (SimpleFs);
 
+  if (!IsListEmpty (&VirtioFs->OpenFiles)) {
+    return EFI_ACCESS_DENIED;
+  }
+
   Status = gBS->UninstallProtocolInterface (ControllerHandle,
                   &gEfiSimpleFileSystemProtocolGuid, SimpleFs);
   if (EFI_ERROR (Status)) {
     return Status;
   }
 
   Status = gBS->CloseEvent (VirtioFs->ExitBoot);
   ASSERT_EFI_ERROR (Status);
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
new file mode 100644
index 000000000000..01bbeae21473
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
@@ -0,0 +1,48 @@
+/** @file
+  EFI_FILE_PROTOCOL.Close() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include <Library/BaseLib.h>             // RemoveEntryList()
+#include <Library/MemoryAllocationLib.h> // FreePool()
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileClose (
+  IN EFI_FILE_PROTOCOL *This
+  )
+{
+  VIRTIO_FS_FILE *VirtioFsFile;
+  VIRTIO_FS      *VirtioFs;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  //
+  // At this point, the implementation is only suitable for closing the
+  // VIRTIO_FS_FILE that was created by VirtioFsOpenVolume().
+  //
+  ASSERT (VirtioFsFile->IsDirectory);
+  ASSERT (VirtioFsFile->NodeId == VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID);
+  //
+  // Close the root directory.
+  //
+  // Ignore any errors, because EFI_FILE_PROTOCOL.Close() is required to
+  // release the EFI_FILE_PROTOCOL object unconditionally.
+  //
+  VirtioFsFuseReleaseFileOrDir (VirtioFs, VirtioFsFile->NodeId,
+    VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
+
+  //
+  // One fewer file left open for the owner filesystem.
+  //
+  RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
+
+  FreePool (VirtioFsFile);
+  return EFI_SUCCESS;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
new file mode 100644
index 000000000000..3209923d1e49
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
@@ -0,0 +1,29 @@
+/** @file
+  EFI_FILE_PROTOCOL.Delete() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileDelete (
+  IN EFI_FILE_PROTOCOL *This
+  )
+{
+  //
+  // At this point, the implementation is only suitable for closing the
+  // VIRTIO_FS_FILE that was created by VirtioFsOpenVolume().
+  //
+  // Actually deleting the root directory is not possible, so we're only going
+  // to release resources, and return EFI_WARN_DELETE_FAILURE.
+  //
+  // In order to release resources, VirtioFsSimpleFileClose() is just right
+  // here.
+  //
+  VirtioFsSimpleFileClose (This);
+  return EFI_WARN_DELETE_FAILURE;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c b/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
new file mode 100644
index 000000000000..e48d92140f64
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
@@ -0,0 +1,18 @@
+/** @file
+  EFI_FILE_PROTOCOL.Flush() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileFlush (
+  IN EFI_FILE_PROTOCOL *This
+  )
+{
+  return EFI_NO_MEDIA;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c b/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
new file mode 100644
index 000000000000..6e870460c014
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
@@ -0,0 +1,21 @@
+/** @file
+  EFI_FILE_PROTOCOL.GetInfo() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileGetInfo (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN     EFI_GUID          *InformationType,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  )
+{
+  return EFI_NO_MEDIA;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c b/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
new file mode 100644
index 000000000000..2f40d2be2693
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
@@ -0,0 +1,20 @@
+/** @file
+  EFI_FILE_PROTOCOL.GetPosition() member function for the Virtio Filesystem
+  driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileGetPosition (
+  IN     EFI_FILE_PROTOCOL *This,
+     OUT UINT64            *Position
+  )
+{
+  return EFI_DEVICE_ERROR;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
new file mode 100644
index 000000000000..f0e249184079
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
@@ -0,0 +1,22 @@
+/** @file
+  EFI_FILE_PROTOCOL.Open() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileOpen (
+  IN     EFI_FILE_PROTOCOL *This,
+     OUT EFI_FILE_PROTOCOL **NewHandle,
+  IN     CHAR16            *FileName,
+  IN     UINT64            OpenMode,
+  IN     UINT64            Attributes
+  )
+{
+  return EFI_NO_MEDIA;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
index a5a66a27d84c..8c1457a68aad 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -2,25 +2,80 @@
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume() member function for the Virtio
   Filesystem driver.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <Library/BaseLib.h>             // InsertTailList()
+#include <Library/MemoryAllocationLib.h> // AllocatePool()
+
 #include "VirtioFsDxe.h"
 
 /**
   Open the root directory on the Virtio Filesystem.
 
   Refer to EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_OPEN_VOLUME for the interface
   contract.
 **/
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
   IN  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *This,
   OUT EFI_FILE_PROTOCOL               **Root
   )
 {
-  return EFI_NO_MEDIA;
+  VIRTIO_FS      *VirtioFs;
+  VIRTIO_FS_FILE *VirtioFsFile;
+  EFI_STATUS     Status;
+  UINT64         RootDirHandle;
+
+  VirtioFs = VIRTIO_FS_FROM_SIMPLE_FS (This);
+
+  VirtioFsFile = AllocatePool (sizeof *VirtioFsFile);
+  if (VirtioFsFile == NULL) {
+    return EFI_OUT_OF_RESOURCES;
+  }
+
+  //
+  // Open the root directory.
+  //
+  Status = VirtioFsFuseOpenDir (VirtioFs, VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID,
+             &RootDirHandle);
+  if (EFI_ERROR (Status)) {
+    goto FreeVirtioFsFile;
+  }
+
+  //
+  // Populate the new VIRTIO_FS_FILE object.
+  //
+  VirtioFsFile->Signature              = VIRTIO_FS_FILE_SIG;
+  VirtioFsFile->SimpleFile.Revision    = EFI_FILE_PROTOCOL_REVISION;
+  VirtioFsFile->SimpleFile.Open        = VirtioFsSimpleFileOpen;
+  VirtioFsFile->SimpleFile.Close       = VirtioFsSimpleFileClose;
+  VirtioFsFile->SimpleFile.Delete      = VirtioFsSimpleFileDelete;
+  VirtioFsFile->SimpleFile.Read        = VirtioFsSimpleFileRead;
+  VirtioFsFile->SimpleFile.Write       = VirtioFsSimpleFileWrite;
+  VirtioFsFile->SimpleFile.GetPosition = VirtioFsSimpleFileGetPosition;
+  VirtioFsFile->SimpleFile.SetPosition = VirtioFsSimpleFileSetPosition;
+  VirtioFsFile->SimpleFile.GetInfo     = VirtioFsSimpleFileGetInfo;
+  VirtioFsFile->SimpleFile.SetInfo     = VirtioFsSimpleFileSetInfo;
+  VirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
+  VirtioFsFile->IsDirectory            = TRUE;
+  VirtioFsFile->OwnerFs                = VirtioFs;
+  VirtioFsFile->NodeId                 = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
+  VirtioFsFile->FuseHandle             = RootDirHandle;
+
+  //
+  // One more file open for the filesystem.
+  //
+  InsertTailList (&VirtioFs->OpenFiles, &VirtioFsFile->OpenFilesEntry);
+
+  *Root = &VirtioFsFile->SimpleFile;
+  return EFI_SUCCESS;
+
+FreeVirtioFsFile:
+  FreePool (VirtioFsFile);
+
+  return Status;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsRead.c b/OvmfPkg/VirtioFsDxe/SimpleFsRead.c
new file mode 100644
index 000000000000..e737d5e33204
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsRead.c
@@ -0,0 +1,20 @@
+/** @file
+  EFI_FILE_PROTOCOL.Read() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileRead (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+     OUT VOID              *Buffer
+  )
+{
+  return EFI_NO_MEDIA;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
new file mode 100644
index 000000000000..200b7a1bcd20
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
@@ -0,0 +1,21 @@
+/** @file
+  EFI_FILE_PROTOCOL.SetInfo() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileSetInfo (
+  IN EFI_FILE_PROTOCOL *This,
+  IN EFI_GUID          *InformationType,
+  IN UINTN             BufferSize,
+  IN VOID              *Buffer
+  )
+{
+  return EFI_NO_MEDIA;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
new file mode 100644
index 000000000000..ee8cb1f4e465
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
@@ -0,0 +1,20 @@
+/** @file
+  EFI_FILE_PROTOCOL.SetPosition() member function for the Virtio Filesystem
+  driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileSetPosition (
+  IN EFI_FILE_PROTOCOL *This,
+  IN UINT64            Position
+  )
+{
+  return EFI_DEVICE_ERROR;
+}
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c b/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
new file mode 100644
index 000000000000..90d82bd722b1
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
@@ -0,0 +1,20 @@
+/** @file
+  EFI_FILE_PROTOCOL.Write() member function for the Virtio Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+EFI_STATUS
+EFIAPI
+VirtioFsSimpleFileWrite (
+  IN     EFI_FILE_PROTOCOL *This,
+  IN OUT UINTN             *BufferSize,
+  IN     VOID              *Buffer
+  )
+{
+  return EFI_NO_MEDIA;
+}
-- 
2.19.1.3.g30247aa5d201



