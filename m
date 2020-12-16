From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:24 +0100
Message-Id: <20201216211125.19496-48-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 47/48] OvmfPkg/VirtioFsDxe: add helper for
	determining file mode bits update
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

Add the VirtioFsGetFuseModeUpdate() function, for determining whether an
EFI_FILE_PROTOCOL.SetInfo() invocation requests an update to the file mode
bits.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  3 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  8 ++
 OvmfPkg/VirtioFsDxe/Helpers.c               | 95 ++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 15fb28f95a28..dee437ec0d39 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -90,22 +90,25 @@ typedef struct {
 // File mode bitmasks.
 //
 #define VIRTIO_FS_FUSE_MODE_TYPE_MASK 0170000u
 #define VIRTIO_FS_FUSE_MODE_TYPE_REG  0100000u
 #define VIRTIO_FS_FUSE_MODE_TYPE_DIR  0040000u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXU 0000700u
 #define VIRTIO_FS_FUSE_MODE_PERM_RUSR 0000400u
 #define VIRTIO_FS_FUSE_MODE_PERM_WUSR 0000200u
+#define VIRTIO_FS_FUSE_MODE_PERM_XUSR 0000100u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXG 0000070u
 #define VIRTIO_FS_FUSE_MODE_PERM_RGRP 0000040u
 #define VIRTIO_FS_FUSE_MODE_PERM_WGRP 0000020u
+#define VIRTIO_FS_FUSE_MODE_PERM_XGRP 0000010u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXO 0000007u
 #define VIRTIO_FS_FUSE_MODE_PERM_ROTH 0000004u
 #define VIRTIO_FS_FUSE_MODE_PERM_WOTH 0000002u
+#define VIRTIO_FS_FUSE_MODE_PERM_XOTH 0000001u
 
 //
 // Flags for VirtioFsFuseOpSetAttr, in the VIRTIO_FS_FUSE_SETATTR_REQUEST.Valid
 // field.
 //
 #define VIRTIO_FS_FUSE_SETATTR_REQ_F_MODE  BIT0
 #define VIRTIO_FS_FUSE_SETATTR_REQ_F_SIZE  BIT3
 #define VIRTIO_FS_FUSE_SETATTR_REQ_F_ATIME BIT4
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 4331cabbd40e..3c3eb1ac9338 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -295,16 +295,24 @@ VirtioFsGetFuseTimeUpdates (
   IN     EFI_FILE_INFO *Info,
   IN     EFI_FILE_INFO *NewInfo,
      OUT BOOLEAN       *UpdateAtime,
      OUT BOOLEAN       *UpdateMtime,
      OUT UINT64        *Atime,
      OUT UINT64        *Mtime
   );
 
+EFI_STATUS
+VirtioFsGetFuseModeUpdate (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *Update,
+     OUT UINT32        *Mode
+     );
+
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseLookup (
   IN OUT VIRTIO_FS                          *VirtioFs,
   IN     UINT64                             DirNodeId,
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index c85c7400f2be..b669842a23bd 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -2314,8 +2314,103 @@ VirtioFsGetFuseTimeUpdates (
   }
   if (Change[2]) {
     *UpdateMtime = TRUE;
     *Mtime = Seconds[2];
   }
 
   return EFI_SUCCESS;
 }
+
+/**
+  Given an EFI_FILE_INFO object received in an EFI_FILE_PROTOCOL.SetInfo()
+  call, determine whether updating the file mode bits of the file is necessary,
+  relative to an EFI_FILE_INFO object describing the current state of the file.
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
+  @param[out] Update  Set to TRUE on output if the file mode bits need to be
+                      updated. Set to FALSE otherwise.
+
+  @param[out] Mode    If Update is set to TRUE, then Mode provides the file
+                      mode bits to set. Otherwise, Mode is not written to.
+
+  @retval EFI_SUCCESS        Output parameters have been set successfully.
+
+  @retval EFI_ACCESS_DENIED  NewInfo requests toggling an unknown bit in the
+                             Attribute bitmask.
+
+  @retval EFI_ACCESS_DENIED  NewInfo requests toggling EFI_FILE_DIRECTORY in
+                             the Attribute bitmask.
+**/
+EFI_STATUS
+VirtioFsGetFuseModeUpdate (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *Update,
+     OUT UINT32        *Mode
+     )
+{
+  UINT64  Toggle;
+  BOOLEAN IsDirectory;
+  BOOLEAN IsWriteable;
+  BOOLEAN WillBeWriteable;
+
+  Toggle = Info->Attribute ^ NewInfo->Attribute;
+  if ((Toggle & ~EFI_FILE_VALID_ATTR) != 0) {
+    //
+    // Unknown attribute requested.
+    //
+    return EFI_ACCESS_DENIED;
+  }
+  if ((Toggle & EFI_FILE_DIRECTORY) != 0) {
+    //
+    // EFI_FILE_DIRECTORY cannot be toggled.
+    //
+    return EFI_ACCESS_DENIED;
+  }
+
+  IsDirectory     = (BOOLEAN)((Info->Attribute    & EFI_FILE_DIRECTORY) != 0);
+  IsWriteable     = (BOOLEAN)((Info->Attribute    & EFI_FILE_READ_ONLY) == 0);
+  WillBeWriteable = (BOOLEAN)((NewInfo->Attribute & EFI_FILE_READ_ONLY) == 0);
+
+  if (IsWriteable == WillBeWriteable) {
+    *Update = FALSE;
+    return EFI_SUCCESS;
+  }
+
+  if (IsDirectory) {
+    if (WillBeWriteable) {
+      *Mode = (VIRTIO_FS_FUSE_MODE_PERM_RWXU |
+               VIRTIO_FS_FUSE_MODE_PERM_RWXG |
+               VIRTIO_FS_FUSE_MODE_PERM_RWXO);
+    } else {
+      *Mode = (VIRTIO_FS_FUSE_MODE_PERM_RUSR |
+               VIRTIO_FS_FUSE_MODE_PERM_XUSR |
+               VIRTIO_FS_FUSE_MODE_PERM_RGRP |
+               VIRTIO_FS_FUSE_MODE_PERM_XGRP |
+               VIRTIO_FS_FUSE_MODE_PERM_ROTH |
+               VIRTIO_FS_FUSE_MODE_PERM_XOTH);
+    }
+  } else {
+    if (WillBeWriteable) {
+      *Mode = (VIRTIO_FS_FUSE_MODE_PERM_RUSR |
+               VIRTIO_FS_FUSE_MODE_PERM_WUSR |
+               VIRTIO_FS_FUSE_MODE_PERM_RGRP |
+               VIRTIO_FS_FUSE_MODE_PERM_WGRP |
+               VIRTIO_FS_FUSE_MODE_PERM_ROTH |
+               VIRTIO_FS_FUSE_MODE_PERM_WOTH);
+    } else {
+      *Mode = (VIRTIO_FS_FUSE_MODE_PERM_RUSR |
+               VIRTIO_FS_FUSE_MODE_PERM_RGRP |
+               VIRTIO_FS_FUSE_MODE_PERM_ROTH);
+    }
+  }
+  *Update = TRUE;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



