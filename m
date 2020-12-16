From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:57 +0100
Message-Id: <20201216211125.19496-21-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 20/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_CREATE
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

Add the VirtioFsFuseOpenOrCreate() function, for sending the FUSE_CREATE
command to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  17 +++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   9 ++
 OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c      | 155 ++++++++++++++++++++
 4 files changed, 182 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 9ffeb9c8c954..63aced229e9b 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -80,18 +80,24 @@ typedef struct {
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
 //
 // File mode bitmasks.
 //
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXU 0000700u
+#define VIRTIO_FS_FUSE_MODE_PERM_RUSR 0000400u
+#define VIRTIO_FS_FUSE_MODE_PERM_WUSR 0000200u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXG 0000070u
+#define VIRTIO_FS_FUSE_MODE_PERM_RGRP 0000040u
+#define VIRTIO_FS_FUSE_MODE_PERM_WGRP 0000020u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXO 0000007u
+#define VIRTIO_FS_FUSE_MODE_PERM_ROTH 0000004u
+#define VIRTIO_FS_FUSE_MODE_PERM_WOTH 0000002u
 
 //
 // Flags for VirtioFsFuseOpOpen.
 //
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
 //
@@ -103,16 +109,17 @@ typedef enum {
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
+  VirtioFsFuseOpCreate      = 35,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -246,11 +253,21 @@ typedef struct {
   UINT16 MaxBackground;
   UINT16 CongestionThreshold;
   UINT32 MaxWrite;
   UINT32 TimeGran;
   UINT16 MaxPages;
   UINT16 MapAlignment;
   UINT32 Unused[8];
 } VIRTIO_FS_FUSE_INIT_RESPONSE;
+
+//
+// Header for VirtioFsFuseOpCreate.
+//
+typedef struct {
+  UINT32 Flags;
+  UINT32 Mode;
+  UINT32 Umask;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_CREATE_REQUEST;
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index eebb86f7c275..b942baa4a772 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -84,16 +84,17 @@ [Sources]
   DriverBinding.c
   FuseFlush.c
   FuseForget.c
   FuseFsync.c
   FuseInit.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
+  FuseOpenOrCreate.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
   SimpleFsGetPosition.c
   SimpleFsOpen.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 8fd56bdbf6e1..795cf4ee5d7d 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -281,16 +281,25 @@ VirtioFsFuseInitSession (
 
 EFI_STATUS
 VirtioFsFuseOpenDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
      OUT UINT64    *FuseHandle
   );
 
+EFI_STATUS
+VirtioFsFuseOpenOrCreate (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+     OUT UINT64    *NodeId,
+     OUT UINT64    *FuseHandle
+  );
+
 //
 // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
 // driver.
 //
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
diff --git a/OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c b/OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c
new file mode 100644
index 000000000000..60ab002bcd99
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c
@@ -0,0 +1,155 @@
+/** @file
+  FUSE_CREATE wrapper for the Virtio Filesystem device.
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
+  Send a FUSE_CREATE request to the Virtio Filesystem device, for opening a
+  regular file with (O_RDWR | O_CREAT) semantics.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_CREATE
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] ParentNodeId  The inode number of the direct parent directory of
+                           the regular file to open or create.
+
+  @param[in] Name          The single-component filename of the regular file to
+                           open or create, under the parent directory
+                           identified by ParentNodeId.
+
+  @param[out] NodeId       The inode number of the regular file, returned by
+                           the Virtio Filesystem device.
+
+  @param[out] FuseHandle   The open file handle returned by the Virtio
+                           Filesystem device.
+
+  @retval EFI_SUCCESS  The regular file has been opened, and (if necessary)
+                       created.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseOpenOrCreate (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+     OUT UINT64    *NodeId,
+     OUT UINT64    *FuseHandle
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST             CommonReq;
+  VIRTIO_FS_FUSE_CREATE_REQUEST      CreateReq;
+  VIRTIO_FS_IO_VECTOR                ReqIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST      ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE            CommonResp;
+  VIRTIO_FS_FUSE_NODE_RESPONSE       NodeResp;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE AttrResp;
+  VIRTIO_FS_FUSE_OPEN_RESPONSE       OpenResp;
+  VIRTIO_FS_IO_VECTOR                RespIoVec[4];
+  VIRTIO_FS_SCATTER_GATHER_LIST      RespSgList;
+  EFI_STATUS                         Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &CreateReq;
+  ReqIoVec[1].Size   = sizeof CreateReq;
+  ReqIoVec[2].Buffer = Name;
+  ReqIoVec[2].Size   = AsciiStrSize (Name);
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &NodeResp;
+  RespIoVec[1].Size   = sizeof NodeResp;
+  RespIoVec[2].Buffer = &AttrResp;
+  RespIoVec[2].Size   = sizeof AttrResp;
+  RespIoVec[3].Buffer = &OpenResp;
+  RespIoVec[3].Size   = sizeof OpenResp;
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
+  Status = VirtioFsFuseNewRequest (VirtioFs, &CommonReq, ReqSgList.TotalSize,
+             VirtioFsFuseOpCreate, ParentNodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_CREATE-specific fields.
+  //
+  // VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR is why this request can never open a
+  // directory (EISDIR). And VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR is consistent with
+  // the only OpenMode of EFI_FILE_PROTOCOL.Open() that enables filesystem
+  // object creation -- that is, Create/Read/Write.
+  //
+  CreateReq.Flags   = VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR;
+  CreateReq.Mode    = (VIRTIO_FS_FUSE_MODE_PERM_RUSR |
+                       VIRTIO_FS_FUSE_MODE_PERM_WUSR |
+                       VIRTIO_FS_FUSE_MODE_PERM_RGRP |
+                       VIRTIO_FS_FUSE_MODE_PERM_WGRP |
+                       VIRTIO_FS_FUSE_MODE_PERM_ROTH |
+                       VIRTIO_FS_FUSE_MODE_PERM_WOTH);
+  CreateReq.Umask   = 0;
+  CreateReq.Padding = 0;
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
+  if (EFI_ERROR (Status)) {
+    if (Status == EFI_DEVICE_ERROR) {
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" ParentNodeId=%Lu Name=\"%a\" "
+        "Errno=%d\n", __FUNCTION__, VirtioFs->Label, ParentNodeId, Name,
+        CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Output the NodeId of the (possibly new) regular file. Also output the open
+  // file handle.
+  //
+  *NodeId     = NodeResp.NodeId;
+  *FuseHandle = OpenResp.FileHandle;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



