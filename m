From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:08 +0100
Message-Id: <20201216211125.19496-32-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 31/48] OvmfPkg/VirtioFsDxe: implement
	EFI_FILE_PROTOCOL.GetPosition, .SetPosition
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
VirtioFsSimpleFileGetPosition() and VirtioFsSimpleFileSetPosition().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h         |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c |  9 ++++-
 OvmfPkg/VirtioFsDxe/SimpleFsOpen.c        |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c  |  1 +
 OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c | 40 +++++++++++++++++++-
 5 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index d1b746c0d8cf..948fcfb6b6f3 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -134,16 +134,17 @@ typedef struct {
 typedef struct {
   UINT64            Signature;
   EFI_FILE_PROTOCOL SimpleFile;
   BOOLEAN           IsDirectory;
   BOOLEAN           IsOpenForWriting;
   VIRTIO_FS         *OwnerFs;
   LIST_ENTRY        OpenFilesEntry;
   CHAR8             *CanonicalPathname;
+  UINT64            FilePosition;
   //
   // In the FUSE wire protocol, every request except FUSE_INIT refers to a
   // file, namely by the "VIRTIO_FS_FUSE_REQUEST.NodeId" field; that is, by the
   // inode number of the file. However, some of the FUSE requests that we need
   // for some of the EFI_FILE_PROTOCOL member functions require an open file
   // handle *in addition* to the inode number. For simplicity, whenever a
   // VIRTIO_FS_FILE object is created, primarily defined by its NodeId field,
   // we also *open* the referenced file at once, and save the returned file
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c b/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
index 2f40d2be2693..53212621e970 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
@@ -11,10 +11,17 @@
 
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileGetPosition (
   IN     EFI_FILE_PROTOCOL *This,
      OUT UINT64            *Position
   )
 {
-  return EFI_DEVICE_ERROR;
+  VIRTIO_FS_FILE *VirtioFsFile;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  if (VirtioFsFile->IsDirectory) {
+    return EFI_UNSUPPORTED;
+  }
+  *Position = VirtioFsFile->FilePosition;
+  return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
index 2649c796ac97..7c50ce9c0e76 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
@@ -474,16 +474,17 @@ VirtioFsSimpleFileOpen (
   NewVirtioFsFile->SimpleFile.SetPosition = VirtioFsSimpleFileSetPosition;
   NewVirtioFsFile->SimpleFile.GetInfo     = VirtioFsSimpleFileGetInfo;
   NewVirtioFsFile->SimpleFile.SetInfo     = VirtioFsSimpleFileSetInfo;
   NewVirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   NewVirtioFsFile->IsDirectory            = NewNodeIsDirectory;
   NewVirtioFsFile->IsOpenForWriting       = OpenForWriting;
   NewVirtioFsFile->OwnerFs                = VirtioFs;
   NewVirtioFsFile->CanonicalPathname      = NewCanonicalPath;
+  NewVirtioFsFile->FilePosition           = 0;
   NewVirtioFsFile->NodeId                 = NewNodeId;
   NewVirtioFsFile->FuseHandle             = NewFuseHandle;
 
   //
   // One more file is now open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &NewVirtioFsFile->OpenFilesEntry);
 
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
index 9c0ab434c186..1181191d271b 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -67,16 +67,17 @@ VirtioFsOpenVolume (
   VirtioFsFile->SimpleFile.SetPosition = VirtioFsSimpleFileSetPosition;
   VirtioFsFile->SimpleFile.GetInfo     = VirtioFsSimpleFileGetInfo;
   VirtioFsFile->SimpleFile.SetInfo     = VirtioFsSimpleFileSetInfo;
   VirtioFsFile->SimpleFile.Flush       = VirtioFsSimpleFileFlush;
   VirtioFsFile->IsDirectory            = TRUE;
   VirtioFsFile->IsOpenForWriting       = FALSE;
   VirtioFsFile->OwnerFs                = VirtioFs;
   VirtioFsFile->CanonicalPathname      = CanonicalPathname;
+  VirtioFsFile->FilePosition           = 0;
   VirtioFsFile->NodeId                 = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
   VirtioFsFile->FuseHandle             = RootDirHandle;
 
   //
   // One more file open for the filesystem.
   //
   InsertTailList (&VirtioFs->OpenFiles, &VirtioFsFile->OpenFilesEntry);
 
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
index ee8cb1f4e465..ac6285302652 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
@@ -11,10 +11,48 @@
 
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileSetPosition (
   IN EFI_FILE_PROTOCOL *This,
   IN UINT64            Position
   )
 {
-  return EFI_DEVICE_ERROR;
+  VIRTIO_FS_FILE                     *VirtioFsFile;
+  VIRTIO_FS                          *VirtioFs;
+  EFI_STATUS                         Status;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE FuseAttr;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+
+  //
+  // Directories can only be rewound, per spec.
+  //
+  if (VirtioFsFile->IsDirectory) {
+    if (Position != 0) {
+      return EFI_UNSUPPORTED;
+    }
+    VirtioFsFile->FilePosition = 0;
+    return EFI_SUCCESS;
+  }
+
+  //
+  // Regular file.
+  //
+  if (Position < MAX_UINT64) {
+    //
+    // Caller is requesting absolute file position.
+    //
+    VirtioFsFile->FilePosition = Position;
+    return EFI_SUCCESS;
+  }
+
+  //
+  // Caller is requesting a seek to EOF.
+  //
+  VirtioFs = VirtioFsFile->OwnerFs;
+  Status = VirtioFsFuseGetAttr (VirtioFs, VirtioFsFile->NodeId, &FuseAttr);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  VirtioFsFile->FilePosition = FuseAttr.Size;
+  return EFI_SUCCESS;
 }
-- 
2.19.1.3.g30247aa5d201



