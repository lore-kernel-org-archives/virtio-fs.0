From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:06 +0100
Message-Id: <20201216211125.19496-30-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 29/48] OvmfPkg/VirtioFsDxe: add helper for
	formatting UEFI basenames
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

The EFI_FILE_INFO structure, which is output by
EFI_FILE_PROTOCOL.GetInfo(), ends with a flexible CHAR16 array called
"FileName". Add the VirtioFsGetBasename() function, for determining the
required array size, and for filling the array as well.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |  7 +++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 61 ++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 029c568b39c7..d1b746c0d8cf 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -229,16 +229,23 @@ VirtioFsAppendPath (
 EFI_STATUS
 VirtioFsLookupMostSpecificParentDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN OUT CHAR8     *Path,
      OUT UINT64    *DirNodeId,
      OUT CHAR8     **LastComponent
   );
 
+EFI_STATUS
+VirtioFsGetBasename (
+  IN     CHAR8  *Path,
+     OUT CHAR16 *Basename     OPTIONAL,
+  IN OUT UINTN  *BasenameSize
+  );
+
 EFI_STATUS
 VirtioFsFuseAttrToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
      OUT EFI_FILE_INFO                      *FileInfo
   );
 
 //
 // Wrapper functions for FUSE commands (primitives).
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 6adc0341dee6..77f718e91233 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -1717,16 +1717,77 @@ VirtioFsLookupMostSpecificParentDir (
   *LastComponent = Slash + 1;
   return EFI_SUCCESS;
 
 ForgetNextDirNodeId:
   VirtioFsFuseForget (VirtioFs, NextDirNodeId);
   return Status;
 }
 
+/**
+  Format the last component of a canonical pathname into a caller-provided
+  CHAR16 array.
+
+  @param[in] Path              The canonical pathname (as defined in the
+                               description of VirtioFsAppendPath()) to format
+                               the last component of.
+
+  @param[out] Basename         If BasenameSize is zero on input, Basename may
+                               be NULL. Otherwise, Basename is allocated by the
+                               caller. On successful return, Basename contains
+                               the last component of Path, formatted as a
+                               NUL-terminated CHAR16 string. When Path is "/"
+                               on input, Basename is L"" on output.
+
+  @param[in,out] BasenameSize  On input, the number of bytes the caller
+                               provides in Basename. On output, regardless of
+                               return value, the number of bytes required for
+                               formatting Basename, including the terminating
+                               L'\0'.
+
+  @retval EFI_SUCCESS           Basename has been filled in.
+
+  @retval EFI_BUFFER_TOO_SMALL  BasenameSize was too small on input; Basename
+                                has not been modified.
+**/
+EFI_STATUS
+VirtioFsGetBasename (
+  IN     CHAR8  *Path,
+     OUT CHAR16 *Basename     OPTIONAL,
+  IN OUT UINTN  *BasenameSize
+  )
+{
+  UINTN AllocSize;
+  UINTN LastComponent;
+  UINTN Idx;
+  UINTN PathSize;
+
+  AllocSize = *BasenameSize;
+
+  LastComponent = MAX_UINTN;
+  for (Idx = 0; Path[Idx] != '\0'; Idx++) {
+    if (Path[Idx] == '/') {
+      LastComponent = Idx;
+    }
+  }
+  PathSize = Idx + 1;
+  ASSERT (LastComponent < MAX_UINTN);
+  LastComponent++;
+  *BasenameSize = (PathSize - LastComponent) * sizeof Basename[0];
+
+  if (*BasenameSize > AllocSize) {
+    return EFI_BUFFER_TOO_SMALL;
+  }
+
+  for (Idx = LastComponent; Idx < PathSize; Idx++) {
+    Basename[Idx - LastComponent] = Path[Idx];
+  }
+  return EFI_SUCCESS;
+}
+
 /**
   Convert select fields of a VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
   corresponding fields in EFI_FILE_INFO.
 
   @param[in] FuseAttr   The VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
                         convert the relevant fields from.
 
   @param[out] FileInfo  The EFI_FILE_INFO structure to modify. Importantly, the
-- 
2.19.1.3.g30247aa5d201



