From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:11 +0100
Message-Id: <20201216211125.19496-35-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 34/48] OvmfPkg/VirtioFsDxe: convert FUSE
	dirent filename to EFI_FILE_INFO
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

Introduce the VirtioFsFuseDirentPlusToEfiFileInfo() function, for
converting the VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE filename byte array to
EFI_FILE_INFO.

This new function updates those EFI_FILE_INFO fields (Size, FileName) that
the earlier helper function VirtioFsFuseAttrToEfiFileInfo() does not set.

Both functions together will be able to fill in EFI_FILE_INFO completely,
from FUSE_READDIRPLUS.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |  6 ++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 79 ++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index f5501af7d0a4..2b419048c232 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -243,16 +243,22 @@ VirtioFsGetBasename (
   );
 
 EFI_STATUS
 VirtioFsFuseAttrToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
      OUT EFI_FILE_INFO                      *FileInfo
   );
 
+EFI_STATUS
+VirtioFsFuseDirentPlusToEfiFileInfo (
+  IN     VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE *FuseDirent,
+  IN OUT EFI_FILE_INFO                      *FileInfo
+  );
+
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseLookup (
   IN OUT VIRTIO_FS                          *VirtioFs,
   IN     UINT64                             DirNodeId,
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 77f718e91233..cdaa8557a17b 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -1895,8 +1895,87 @@ VirtioFsFuseAttrToEfiFileInfo (
   // A hard link count greater than 1 is not supported for regular files.
   //
   if ((FileInfo->Attribute & EFI_FILE_DIRECTORY) == 0 && FuseAttr->Nlink > 1) {
     return EFI_UNSUPPORTED;
   }
 
   return EFI_SUCCESS;
 }
+
+/**
+  Convert a VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE filename to an EFI_FILE_INFO
+  filename.
+
+  @param[in] FuseDirent    The VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE object to
+                           convert the filename byte array from. The caller is
+                           responsible for ensuring that FuseDirent->Namelen
+                           describe valid storage.
+
+  @param[in,out] FileInfo  The EFI_FILE_INFO structure to modify. On input, the
+                           caller is responsible for setting FileInfo->Size
+                           according to the allocated size. On successful
+                           return, FileInfo->Size is reduced to reflect the
+                           filename converted into FileInfo->FileName.
+                           FileInfo->FileName is set from the filename byte
+                           array that directly follows the FuseDirent header
+                           object. Fields other than FileInfo->Size and
+                           FileInfo->FileName are not modified.
+
+  @retval EFI_SUCCESS            Conversion successful.
+
+  @retval EFI_INVALID_PARAMETER  VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE_SIZE()
+                                 returns zero for FuseDirent->Namelen.
+
+  @retval EFI_BUFFER_TOO_SMALL   On input, FileInfo->Size does not provide
+                                 enough room for converting the filename byte
+                                 array from FuseDirent.
+
+  @retval EFI_UNSUPPORTED        The FuseDirent filename byte array contains a
+                                 byte that falls outside of the printable ASCII
+                                 range, or is a forward slash or a backslash.
+**/
+EFI_STATUS
+VirtioFsFuseDirentPlusToEfiFileInfo (
+  IN     VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE *FuseDirent,
+  IN OUT EFI_FILE_INFO                      *FileInfo
+  )
+{
+  UINTN  DirentSize;
+  UINTN  FileInfoSize;
+  UINT8  *DirentName;
+  UINT32 Idx;
+
+  DirentSize = VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE_SIZE (FuseDirent->Namelen);
+  if (DirentSize == 0) {
+    return EFI_INVALID_PARAMETER;
+  }
+  //
+  // We're now safe from overflow in the calculation below.
+  //
+  FileInfoSize = (OFFSET_OF (EFI_FILE_INFO, FileName) +
+                  ((UINTN)FuseDirent->Namelen + 1) * sizeof (CHAR16));
+  if (FileInfoSize > FileInfo->Size) {
+    return EFI_BUFFER_TOO_SMALL;
+  }
+
+  //
+  // Convert the name.
+  //
+  DirentName = (UINT8 *)(FuseDirent + 1);
+  for (Idx = 0; Idx < FuseDirent->Namelen; Idx++) {
+    UINT8 NameByte;
+
+    NameByte = DirentName[Idx];
+    if (NameByte < 0x20 || NameByte > 0x7E ||
+        NameByte == '/' || NameByte == '\\') {
+      return EFI_UNSUPPORTED;
+    }
+    FileInfo->FileName[Idx] = (CHAR16)NameByte;
+  }
+  FileInfo->FileName[Idx++] = L'\0';
+  //
+  // Set the (possibly reduced) size.
+  //
+  FileInfo->Size = FileInfoSize;
+
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



