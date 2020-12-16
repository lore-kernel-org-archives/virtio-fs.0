From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:25 +0100
Message-Id: <20201216211125.19496-49-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 48/48] OvmfPkg/VirtioFsDxe: handle
	attribute updates in EFI_FILE_PROTOCOL.SetInfo
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

Using the functions introduced previously, we can now update file
attributes in VirtioFsSimpleFileSetInfo().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c | 107 +++++++++++++++++++-
 1 file changed, 106 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
index 55169dde78b7..e7cc3d5dc399 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
@@ -303,16 +303,121 @@ Rename (
 
 FreeDestination:
   if (Destination != NULL) {
     FreePool (Destination);
   }
   return Status;
 }
 
+/**
+  Update the attributes of a VIRTIO_FS_FILE as requested in EFI_FILE_INFO.
+
+  @param[in,out] VirtioFsFile  The VIRTIO_FS_FILE to update the attributes of.
+
+  @param[in] NewFileInfo       The new attributes requested by
+                               EFI_FILE_PROTOCOL.SetInfo(). NewFileInfo->Size
+                               and NewFileInfo->FileName are ignored.
+
+  @retval EFI_SUCCESS        No attributes had to be updated.
+
+  @retval EFI_SUCCESS        The required set of attribute updates has been
+                             determined and performed successfully.
+
+  @retval EFI_ACCESS_DENIED  NewFileInfo requests an update to a property
+                             different from the EFI_FILE_READ_ONLY bit in the
+                             Attribute field, but VirtioFsFile is not open for
+                             writing.
+
+  @return                    Error codes propagated from underlying functions.
+**/
+STATIC
+EFI_STATUS
+UpdateAttributes (
+  IN OUT VIRTIO_FS_FILE *VirtioFsFile,
+  IN     EFI_FILE_INFO  *NewFileInfo
+  )
+{
+  VIRTIO_FS                          *VirtioFs;
+  EFI_STATUS                         Status;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE FuseAttr;
+  EFI_FILE_INFO                      FileInfo;
+  BOOLEAN                            UpdateFileSize;
+  UINT64                             FileSize;
+  BOOLEAN                            UpdateAtime;
+  BOOLEAN                            UpdateMtime;
+  UINT64                             Atime;
+  UINT64                             Mtime;
+  BOOLEAN                            UpdateMode;
+  UINT32                             Mode;
+
+  VirtioFs = VirtioFsFile->OwnerFs;
+
+  //
+  // Fetch the current attributes first, so we can build the difference between
+  // them and NewFileInfo.
+  //
+  Status = VirtioFsFuseGetAttr (VirtioFs, VirtioFsFile->NodeId, &FuseAttr);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  Status = VirtioFsFuseAttrToEfiFileInfo (&FuseAttr, &FileInfo);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+  //
+  // Collect the updates.
+  //
+  if (VirtioFsFile->IsDirectory) {
+    UpdateFileSize = FALSE;
+  } else {
+    VirtioFsGetFuseSizeUpdate (&FileInfo, NewFileInfo, &UpdateFileSize,
+      &FileSize);
+  }
+
+  Status = VirtioFsGetFuseTimeUpdates (&FileInfo, NewFileInfo, &UpdateAtime,
+             &UpdateMtime, &Atime, &Mtime);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  Status = VirtioFsGetFuseModeUpdate (&FileInfo, NewFileInfo, &UpdateMode,
+             &Mode);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // If no attribute updates are necessary, we're done.
+  //
+  if (!UpdateFileSize && !UpdateAtime && !UpdateMtime && !UpdateMode) {
+    return EFI_SUCCESS;
+  }
+  //
+  // If the file is not open for writing, then only Mode may be updated (for
+  // toggling EFI_FILE_READ_ONLY).
+  //
+  if (!VirtioFsFile->IsOpenForWriting &&
+      (UpdateFileSize || UpdateAtime || UpdateMtime)) {
+    return EFI_ACCESS_DENIED;
+  }
+  //
+  // Send the FUSE_SETATTR request now.
+  //
+  Status = VirtioFsFuseSetAttr (
+             VirtioFs,
+             VirtioFsFile->NodeId,
+             UpdateFileSize ? &FileSize : NULL,
+             UpdateAtime    ? &Atime    : NULL,
+             UpdateMtime    ? &Mtime    : NULL,
+             UpdateMode     ? &Mode     : NULL
+             );
+  return Status;
+}
+
 /**
   Process an EFI_FILE_INFO setting request.
 **/
 STATIC
 EFI_STATUS
 SetFileInfo (
   IN EFI_FILE_PROTOCOL *This,
   IN UINTN             BufferSize,
@@ -345,17 +450,17 @@ SetFileInfo (
   //
   Status = Rename (VirtioFsFile, FileInfo->FileName);
   if (EFI_ERROR (Status)) {
     return Status;
   }
   //
   // Update any attributes requested.
   //
-  Status = EFI_UNSUPPORTED;
+  Status = UpdateAttributes (VirtioFsFile, FileInfo);
   //
   // The UEFI spec does not speak about partial failure in
   // EFI_FILE_PROTOCOL.SetInfo(); we won't try to roll back the rename (if
   // there was one) in case the attribute updates fail.
   //
   return Status;
 }
 
-- 
2.19.1.3.g30247aa5d201


