From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:22 +0100
Message-Id: <20201216211125.19496-46-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 45/48] OvmfPkg/VirtioFsDxe: add helper for
	determining file size update
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

Add the VirtioFsGetFuseSizeUpdate() function, for determining whether an
EFI_FILE_PROTOCOL.SetInfo() invocation requests a file size update.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |  8 ++++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 40 ++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 9e6348f9386e..096756302942 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -277,16 +277,24 @@ VirtioFsFuseAttrToEfiFileInfo (
   );
 
 EFI_STATUS
 VirtioFsFuseDirentPlusToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE *FuseDirent,
   IN OUT EFI_FILE_INFO                      *FileInfo
   );
 
+VOID
+VirtioFsGetFuseSizeUpdate (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *Update,
+     OUT UINT64        *Size
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
index b741cf753495..838971bd2c85 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -2168,8 +2168,48 @@ VirtioFsFuseDirentPlusToEfiFileInfo (
   FileInfo->FileName[Idx++] = L'\0';
   //
   // Set the (possibly reduced) size.
   //
   FileInfo->Size = FileInfoSize;
 
   return EFI_SUCCESS;
 }
+
+/**
+  Given an EFI_FILE_INFO object received in an EFI_FILE_PROTOCOL.SetInfo()
+  call, determine whether updating the size of the file is necessary, relative
+  to an EFI_FILE_INFO object describing the current state of the file.
+
+  @param[in] Info     The EFI_FILE_INFO describing the current state of the
+                      file. The caller is responsible for populating Info on
+                      input with VirtioFsFuseAttrToEfiFileInfo(), from the
+                      current FUSE attributes of the file. The Info->Size and
+                      Info->FileName members are ignored.
+
+  @param[in] NewInfo  The EFI_FILE_INFO object received in the
+                      EFI_FILE_PROTOCOL.SetInfo() call.
+
+  @param[out] Update  Set to TRUE on output if the file size needs to be
+                      updated. Set to FALSE otherwise.
+
+  @param[out] Size    If Update is set to TRUE, then Size provides the new file
+                      size to set. Otherwise, Size is not written to.
+**/
+VOID
+VirtioFsGetFuseSizeUpdate (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *Update,
+     OUT UINT64        *Size
+  )
+{
+  BOOLEAN IsDirectory;
+
+  IsDirectory = (BOOLEAN)((Info->Attribute & EFI_FILE_DIRECTORY) != 0);
+
+  if (IsDirectory || Info->FileSize == NewInfo->FileSize) {
+    *Update = FALSE;
+    return;
+  }
+  *Update = TRUE;
+  *Size = NewInfo->FileSize;
+}
-- 
2.19.1.3.g30247aa5d201



