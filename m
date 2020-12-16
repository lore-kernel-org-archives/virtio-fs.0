From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:01 +0100
Message-Id: <20201216211125.19496-25-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 24/48] OvmfPkg/VirtioFsDxe: add a shared
	wrapper for FUSE_UNLINK / FUSE_RMDIR
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

The FUSE_UNLINK and FUSE_RMDIR commands only differ in the opcode. Add a
common function for wrapping both.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |   2 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   8 ++
 OvmfPkg/VirtioFsDxe/FuseUnlink.c            | 114 ++++++++++++++++++++
 4 files changed, 125 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 8a07b3d2eb93..f49452830abc 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -110,16 +110,18 @@ typedef struct {
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpMkDir       =  9,
+  VirtioFsFuseOpUnlink      = 10,
+  VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 3552ece6b945..2332aa3ee551 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -88,16 +88,17 @@ [Sources]
   FuseFsync.c
   FuseInit.c
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRelease.c
+  FuseUnlink.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
   SimpleFsGetPosition.c
   SimpleFsOpen.c
   SimpleFsOpenVolume.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 6ae5c36f7fd5..0e4f2109eb02 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -262,16 +262,24 @@ VirtioFsFuseForget (
 EFI_STATUS
 VirtioFsFuseMkDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    ParentNodeId,
   IN     CHAR8     *Name,
      OUT UINT64    *NodeId
   );
 
+EFI_STATUS
+VirtioFsFuseRemoveFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+  IN     BOOLEAN   IsDir
+  );
+
 EFI_STATUS
 VirtioFsFuseOpen (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     BOOLEAN   ReadWrite,
      OUT UINT64    *FuseHandle
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseUnlink.c b/OvmfPkg/VirtioFsDxe/FuseUnlink.c
new file mode 100644
index 000000000000..8f84edbe9431
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseUnlink.c
@@ -0,0 +1,114 @@
+/** @file
+  FUSE_UNLINK / FUSE_RMDIR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include <Library/BaseLib.h> // AsciiStrSize()
+
+#include "VirtioFsDxe.h"
+
+/**
+  Remove a regular file or a directory, by sending the FUSE_UNLINK or
+  FUSE_RMDIR request to the Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_UNLINK
+                           / FUSE_RMDIR request to. On output, the FUSE request
+                           counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] ParentNodeId  The inode number of the directory in which Name
+                           should be removed.
+
+  @param[in] Name          The single-component filename to remove in the
+                           directory identified by ParentNodeId.
+
+  @param[in] IsDir         TRUE if Name refers to a directory, FALSE otherwise.
+
+  @retval EFI_SUCCESS  The file or directory has been removed.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseRemoveFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+  IN     BOOLEAN   IsDir
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[1];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = Name;
+  ReqIoVec[1].Size   = AsciiStrSize (Name);
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespSgList.IoVec    = RespIoVec;
+  RespSgList.NumVec   = ARRAY_SIZE (RespIoVec);
+
+  //
+  // Validate the scatter-gather lists; calculate the total transfer sizes.
+  //
+  Status = VirtioFsSgListsValidate (VirtioFs, &ReqSgList, &RespSgList);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the common request header.
+  //
+  Status = VirtioFsFuseNewRequest (
+             VirtioFs,
+             &CommonReq,
+             ReqSgList.TotalSize,
+             IsDir ? VirtioFsFuseOpRmDir : VirtioFsFuseOpUnlink,
+             ParentNodeId
+             );
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Submit the request.
+  //
+  Status = VirtioFsSgListsSubmit (VirtioFs, &ReqSgList, &RespSgList);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Verify the response (all response buffers are fixed size).
+  //
+  Status = VirtioFsFuseCheckResponse (&RespSgList, CommonReq.Unique, NULL);
+  if (Status == EFI_DEVICE_ERROR) {
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" ParentNodeId=%Lu Name=\"%a\" "
+      "IsDir=%d Errno=%d\n", __FUNCTION__, VirtioFs->Label, ParentNodeId, Name,
+      IsDir, CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



