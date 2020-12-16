From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:54 +0100
Message-Id: <20201216211125.19496-18-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 17/48] OvmfPkg/VirtioFsDxe: manage path
	lifecycle in OpenVolume, Close, Delete
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

Add a canonical pathname field to VIRTIO_FS_FILE.

Initialize the new field in EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume().

Release the new field in EFI_FILE_PROTOCOL.Close() and
EFI_FILE_PROTOCOL.Delete().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h        |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsClose.c      |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c     |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c | 13 ++++++++++++-
 4 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index f4fed64c7217..487d215c7f38 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -132,16 +132,17 @@ typedef struct {
 //
 typedef struct {
   UINT64            Signature;
   EFI_FILE_PROTOCOL SimpleFile;
   BOOLEAN           IsDirectory;
   BOOLEAN           IsOpenForWriting;
   VIRTIO_FS         *OwnerFs;
   LIST_ENTRY        OpenFilesEntry;
+  CHAR8             *CanonicalPathname;
   //
   // In the FUSE wire protocol, every request except FUSE_INIT refers to a
   // file, namely by the "VIRTIO_FS_FUSE_REQUEST.NodeId" field; that is, by the
   // inode number of the file. However, some of the FUSE requests that we need
   // for some of the EFI_FILE_PROTOCOL member functions require an open file
   // handle *in addition* to the inode number. For simplicity, whenever a
   // VIRTIO_FS_FILE object is created, primarily defined by its NodeId field,
   // we also *open* the referenced file at once, and save the returned file
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
index bc91ad726b2c..04b4f2c382d7 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsClose.c
@@ -54,11 +54,12 @@ VirtioFsSimpleFileClose (
     VirtioFsFuseForget (VirtioFs, VirtioFsFile->NodeId);
   }
 
   //
   // One fewer file left open for the owner filesystem.
   //
   RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
 
+  FreePool (VirtioFsFile->CanonicalPathname);
   FreePool (VirtioFsFile);
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
index bbad64bf7886..e2fc2d72dfeb 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
@@ -58,11 +58,12 @@ VirtioFsSimpleFileDelete (
     VirtioFsFuseForget (VirtioFs, VirtioFsFile->NodeId);
   }
 
   //
   // One fewer file left open for the owner filesystem.
   //
   RemoveEntryList (&VirtioFsFile->OpenFilesEntry);
 
+  FreePool (VirtioFsFile->CanonicalPathname);
   FreePool (VirtioFsFile);
   return Status;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
index 67d2deb6bdf2..9c0ab434c186 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -23,32 +23,39 @@ EFIAPI
 VirtioFsOpenVolume (
   IN  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *This,
   OUT EFI_FILE_PROTOCOL               **Root
   )
 {
   VIRTIO_FS      *VirtioFs;
   VIRTIO_FS_FILE *VirtioFsFile;
   EFI_STATUS     Status;
+  CHAR8          *CanonicalPathname;
   UINT64         RootDirHandle;
 
   VirtioFs = VIRTIO_FS_FROM_SIMPLE_FS (This);
 
   VirtioFsFile = AllocatePool (sizeof *VirtioFsFile);
   if (VirtioFsFile == NULL) {
     return EFI_OUT_OF_RESOURCES;
   }
 
+  CanonicalPathname = AllocateCopyPool (sizeof "/", "/");
+  if (CanonicalPathname == NULL) {
+    Status = EFI_OUT_OF_RESOURCES;
+    goto FreeVirtioFsFile;
+  }
+
   //
   // Open the root directory.
   //
   Status = VirtioFsFuseOpenDir (VirtioFs, VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID,
              &RootDirHandle);
   if (EFI_ERROR (Status)) {
-    goto FreeVirtioFsFile;
+    goto FreeCanonicalPathname;
   }
 
   //
   // Populate the new VIRTIO_FS_FILE object.
   //
   VirtioFsFile->Signature              = VIRTIO_FS_FILE_SIG;
   VirtioFsFile->SimpleFile.Revision    = EFI_FILE_PROTOCOL_REVISION;
   VirtioFsFile->SimpleFile.Open        = VirtioFsSimpleFileOpen;
@@ -59,24 +66,28 @@ VirtioFsOpenVolume (
   VirtioFsFile->SimpleFile.GetPosition = VirtioFsSimpleFileGetPosition;
   VirtioFsFile->SimpleFile.SetPosition = VirtioFsSimpleFileSetPosition;
   VirtioFsFile->SimpleFile.GetInfo     = VirtioFsSimpleFileGetInfo;
   VirtioFsFile->SimpleFile.SetInfo     = VirtioFsSimpleFileSetInfo;
   VirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   VirtioFsFile->IsDirectory            = TRUE;
   VirtioFsFile->IsOpenForWriting       = FALSE;
   VirtioFsFile->OwnerFs                = VirtioFs;
+  VirtioFsFile->CanonicalPathname      = CanonicalPathname;
   VirtioFsFile->NodeId                 = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
   VirtioFsFile->FuseHandle             = RootDirHandle;
 
   //
   // One more file open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &VirtioFsFile->OpenFilesEntry);
 
   *Root = &VirtioFsFile->SimpleFile;
   return EFI_SUCCESS;
 
+FreeCanonicalPathname:
+  FreePool (CanonicalPathname);
+
 FreeVirtioFsFile:
   FreePool (VirtioFsFile);
 
   return Status;
 }
-- 
2.19.1.3.g30247aa5d201



