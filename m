From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:12 +0100
Message-Id: <20201216211125.19496-36-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 35/48] OvmfPkg/VirtioFsDxe: add
	EFI_FILE_INFO cache fields to VIRTIO_FS_FILE
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

For reading through a directory stream with tolerable performance, we'll
have to call FUSE_READDIRPLUS each time with such a buffer that can
deliver a good number of variable size records
(VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE elements). Every time we'll do that,
we'll turn the whole bunch into an array of EFI_FILE_INFOs immediately.
EFI_FILE_PROTOCOL.Read() invocations (on directories) will be served from
this EFI_FILE_INFO cache.

Add the fields for the EFI_FILE_INFO cache to VIRTIO_FS_FILE:
- initialize them in Open() and OpenVolume(),
- release the cache in Close() and Delete(),
- also release the cache when the directory is rewound, in SetPosition().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h         | 19 +++++++++++++++++++
 OvmfPkg/VirtioFsDxe/SimpleFsClose.c       |  3 +++
 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c      |  3 +++
 OvmfPkg/VirtioFsDxe/SimpleFsOpen.c        |  4 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c  |  4 ++++
 OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c |  9 +++++++++
 6 files changed, 42 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 2b419048c232..a704acdd520e 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -42,16 +42,21 @@
 //
 // The limit is not expected to be a practical limitation; it's only supposed
 // to prevent attempts at overflowing size calculations. For both kinds of
 // pathnames, separate limits could be used; a common limit is used purely for
 // simplicity.
 //
 #define VIRTIO_FS_MAX_PATHNAME_LENGTH ((UINTN)65535)
 
+//
+// Maximum value for VIRTIO_FS_FILE.NumFileInfo.
+//
+#define VIRTIO_FS_FILE_MAX_FILE_INFO 256
+
 //
 // Filesystem label encoded in UCS-2, transformed from the UTF-8 representation
 // in "VIRTIO_FS_CONFIG.Tag", and NUL-terminated. Only the printable ASCII code
 // points (U+0020 through U+007E) are supported.
 //
 typedef CHAR16 VIRTIO_FS_LABEL[VIRTIO_FS_TAG_BYTES + 1];
 
 //
@@ -149,16 +154,30 @@ typedef struct {
   // VIRTIO_FS_FILE object is created, primarily defined by its NodeId field,
   // we also *open* the referenced file at once, and save the returned file
   // handle in the FuseHandle field. This way, when an EFI_FILE_PROTOCOL member
   // function must send a FUSE request that needs the file handle *in addition*
   // to the inode number, FuseHandle will be at our disposal at once.
   //
   UINT64 NodeId;
   UINT64 FuseHandle;
+  //
+  // EFI_FILE_INFO objects cached for an in-flight directory read.
+  //
+  // For reading through a directory stream with tolerable performance, we have
+  // to call FUSE_READDIRPLUS each time with such a buffer that can deliver a
+  // good number of variable size records (VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE
+  // elements). Every time we do that, we turn the whole bunch into an array of
+  // EFI_FILE_INFOs immediately. EFI_FILE_PROTOCOL.Read() invocations (on
+  // directories) will be served from this EFI_FILE_INFO cache.
+  //
+  UINT8 *FileInfoArray;
+  UINTN SingleFileInfoSize;
+  UINTN NumFileInfo;
+  UINTN NextFileInfo;
 } VIRTIO_FS_FILE;
 
 #define VIRTIO_FS_FILE_FROM_SIMPLE_FILE(SimpleFileReference) \
   CR (SimpleFileReference, VIRTIO_FS_FILE, SimpleFile, VIRTIO_FS_FILE_SIG);
 
 #define VIRTIO_FS_FILE_FROM_OPEN_FILES_ENTRY(OpenFilesEntryReference) \
   CR (OpenFilesEntryReference, VIRTIO_FS_FILE, OpenFilesEntry, \
     VIRTIO_FS_FILE_SIG);
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
index 04b4f2c382d7..4c1cf52112ce 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
@@ -55,11 +55,14 @@ VirtioFsSimpleFileClose (
   }
 
   //
   // One fewer file left open for the owner filesystem.
   //
   RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
 
   FreePool (VirtioFsFile->CanonicalPathname);
+  if (VirtioFsFile->FileInfoArray != NULL) {
+    FreePool (VirtioFsFile->FileInfoArray);
+  }
   FreePool (VirtioFsFile);
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
index 76cfee5bceb1..76a868b3c24d 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
@@ -97,11 +97,14 @@ VirtioFsSimpleFileDelete (
   }
 
   //
   // One fewer file left open for the owner filesystem.
   //
   RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
 
   FreePool (VirtioFsFile->CanonicalPathname);
+  if (VirtioFsFile->FileInfoArray != NULL) {
+    FreePool (VirtioFsFile->FileInfoArray);
+  }
   FreePool (VirtioFsFile);
   return Status;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
index 7c50ce9c0e76..d73d23fe8665 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
@@ -477,16 +477,20 @@ VirtioFsSimpleFileOpen (
   NewVirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   NewVirtioFsFile->IsDirectory            = NewNodeIsDirectory;
   NewVirtioFsFile->IsOpenForWriting       = OpenForWriting;
   NewVirtioFsFile->OwnerFs                = VirtioFs;
   NewVirtioFsFile->CanonicalPathname      = NewCanonicalPath;
   NewVirtioFsFile->FilePosition           = 0;
   NewVirtioFsFile->NodeId                 = NewNodeId;
   NewVirtioFsFile->FuseHandle             = NewFuseHandle;
+  NewVirtioFsFile->FileInfoArray          = NULL;
+  NewVirtioFsFile->SingleFileInfoSize     = 0;
+  NewVirtioFsFile->NumFileInfo            = 0;
+  NewVirtioFsFile->NextFileInfo           = 0;
 
   //
   // One more file is now open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &NewVirtioFsFile->OpenFilesEntry);
 
   *NewHandle = &NewVirtioFsFile->SimpleFile;
   return EFI_SUCCESS;
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
index 1181191d271b..058e7a41ab03 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -70,16 +70,20 @@ VirtioFsOpenVolume (
   VirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   VirtioFsFile->IsDirectory            = TRUE;
   VirtioFsFile->IsOpenForWriting       = FALSE;
   VirtioFsFile->OwnerFs                = VirtioFs;
   VirtioFsFile->CanonicalPathname      = CanonicalPathname;
   VirtioFsFile->FilePosition           = 0;
   VirtioFsFile->NodeId                 = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
   VirtioFsFile->FuseHandle             = RootDirHandle;
+  VirtioFsFile->FileInfoArray          = NULL;
+  VirtioFsFile->SingleFileInfoSize     = 0;
+  VirtioFsFile->NumFileInfo            = 0;
+  VirtioFsFile->NextFileInfo           = 0;
 
   //
   // One more file open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &VirtioFsFile->OpenFilesEntry);
 
   *Root = &VirtioFsFile->SimpleFile;
   return EFI_SUCCESS;
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
index ac6285302652..a548012d9c09 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
@@ -2,16 +2,18 @@
   EFI_FILE_PROTOCOL.SetPosition() member function for the Virtio Filesystem
   driver.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <Library/MemoryAllocationLib.h> // FreePool()
+
 #include "VirtioFsDxe.h"
 
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileSetPosition (
   IN EFI_FILE_PROTOCOL *This,
   IN UINT64            Position
   )
@@ -26,16 +28,23 @@ VirtioFsSimpleFileSetPosition (
   //
   // Directories can only be rewound, per spec.
   //
   if (VirtioFsFile->IsDirectory) {
     if (Position != 0) {
       return EFI_UNSUPPORTED;
     }
     VirtioFsFile->FilePosition = 0;
+    if (VirtioFsFile->FileInfoArray != NULL) {
+      FreePool (VirtioFsFile->FileInfoArray);
+      VirtioFsFile->FileInfoArray = NULL;
+    }
+    VirtioFsFile->SingleFileInfoSize = 0;
+    VirtioFsFile->NumFileInfo        = 0;
+    VirtioFsFile->NextFileInfo       = 0;
     return EFI_SUCCESS;
   }
 
   //
   // Regular file.
   //
   if (Position < MAX_UINT64) {
     //
-- 
2.19.1.3.g30247aa5d201



