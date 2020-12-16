From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:21 +0100
Message-Id: <20201216211125.19496-45-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 44/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_SETATTR
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

Add the VirtioFsFuseSetAttr() function, for sending the FUSE_SETATTR
command to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  35 +++-
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  10 ++
 OvmfPkg/VirtioFsDxe/FuseSetAttr.c           | 174 ++++++++++++++++++++
 4 files changed, 219 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 0b2ed7010046..15fb28f95a28 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -97,16 +97,25 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MODE_PERM_WUSR 0000200u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXG 0000070u
 #define VIRTIO_FS_FUSE_MODE_PERM_RGRP 0000040u
 #define VIRTIO_FS_FUSE_MODE_PERM_WGRP 0000020u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXO 0000007u
 #define VIRTIO_FS_FUSE_MODE_PERM_ROTH 0000004u
 #define VIRTIO_FS_FUSE_MODE_PERM_WOTH 0000002u
 
+//
+// Flags for VirtioFsFuseOpSetAttr, in the VIRTIO_FS_FUSE_SETATTR_REQUEST.Valid
+// field.
+//
+#define VIRTIO_FS_FUSE_SETATTR_REQ_F_MODE  BIT0
+#define VIRTIO_FS_FUSE_SETATTR_REQ_F_SIZE  BIT3
+#define VIRTIO_FS_FUSE_SETATTR_REQ_F_ATIME BIT4
+#define VIRTIO_FS_FUSE_SETATTR_REQ_F_MTIME BIT5
+
 //
 // Flags for VirtioFsFuseOpOpen.
 //
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
 //
 // Flags for VirtioFsFuseOpInit.
@@ -148,16 +157,17 @@ typedef struct {
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpGetAttr     =  3,
+  VirtioFsFuseOpSetAttr     =  4,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpUnlink      = 10,
   VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRead        = 15,
   VirtioFsFuseOpWrite       = 16,
   VirtioFsFuseOpStatFs      = 17,
   VirtioFsFuseOpRelease     = 18,
@@ -235,30 +245,53 @@ typedef struct {
 //
 // Header for VirtioFsFuseOpForget.
 //
 typedef struct {
   UINT64 NumberOfLookups;
 } VIRTIO_FS_FUSE_FORGET_REQUEST;
 
 //
-// Headers for VirtioFsFuseOpGetAttr.
+// Headers for VirtioFsFuseOpGetAttr (VIRTIO_FS_FUSE_GETATTR_RESPONSE is also
+// for VirtioFsFuseOpSetAttr).
 //
 typedef struct {
   UINT32 GetAttrFlags;
   UINT32 Dummy;
   UINT64 FileHandle;
 } VIRTIO_FS_FUSE_GETATTR_REQUEST;
 
 typedef struct {
   UINT64 AttrValid;
   UINT32 AttrValidNsec;
   UINT32 Dummy;
 } VIRTIO_FS_FUSE_GETATTR_RESPONSE;
 
+//
+// Header for VirtioFsFuseOpSetAttr.
+//
+typedef struct {
+  UINT32 Valid;
+  UINT32 Padding;
+  UINT64 FileHandle;
+  UINT64 Size;
+  UINT64 LockOwner;
+  UINT64 Atime;
+  UINT64 Mtime;
+  UINT64 Ctime;
+  UINT32 AtimeNsec;
+  UINT32 MtimeNsec;
+  UINT32 CtimeNsec;
+  UINT32 Mode;
+  UINT32 Unused4;
+  UINT32 Uid;
+  UINT32 Gid;
+  UINT32 Unused5;
+} VIRTIO_FS_FUSE_SETATTR_REQUEST;
+
 //
 // Header for VirtioFsFuseOpMkDir.
 //
 typedef struct {
   UINT32 Mode;
   UINT32 Umask;
 } VIRTIO_FS_FUSE_MKDIR_REQUEST;
 
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 9dccd7d6a9ef..8d962bcdc18c 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -91,16 +91,17 @@ [Sources]
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRead.c
   FuseRelease.c
   FuseRename.c
+  FuseSetAttr.c
   FuseStatFs.c
   FuseUnlink.c
   FuseWrite.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index a6dfac71f4a7..9e6348f9386e 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -303,16 +303,26 @@ VirtioFsFuseForget (
 
 EFI_STATUS
 VirtioFsFuseGetAttr (
   IN OUT VIRTIO_FS                          *VirtioFs,
   IN     UINT64                             NodeId,
      OUT VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr
   );
 
+EFI_STATUS
+VirtioFsFuseSetAttr (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    *Size      OPTIONAL,
+  IN     UINT64    *Atime     OPTIONAL,
+  IN     UINT64    *Mtime     OPTIONAL,
+  IN     UINT32    *Mode      OPTIONAL
+  );
+
 EFI_STATUS
 VirtioFsFuseMkDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    ParentNodeId,
   IN     CHAR8     *Name,
      OUT UINT64    *NodeId
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseSetAttr.c b/OvmfPkg/VirtioFsDxe/FuseSetAttr.c
new file mode 100644
index 000000000000..dcd014172022
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseSetAttr.c
@@ -0,0 +1,174 @@
+/** @file
+  FUSE_SETATTR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send the FUSE_SETATTR request to the Virtio Filesystem device, for changing
+  the attributes of an inode.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the
+                           FUSE_SETATTR request to. On output, the FUSE request
+                           counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] NodeId        The inode number representing the regular file or
+                           directory whose attributes should be changed.
+
+  @param[in] Size          The new size to set for the regular file. If NULL,
+                           then the file size will not be changed. If NodeId
+                           refers to a directory, then the caller is
+                           responsible for passing NULL as Size.
+
+  @param[in] Atime         The new last access time to set for the regular file
+                           or directory (seconds since the Epoch). If NULL,
+                           then the last access time is not changed.
+
+  @param[in] Mtime         The new last modification time to set for the
+                           regular file or directory (seconds since the Epoch).
+                           If NULL, then the last modification time is not
+                           changed.
+
+  @param[in] Mode          The new file mode bits to set for the regular file
+                           or directory. If NULL, then the file mode bits are
+                           not changed.
+
+  @retval EFI_SUCCESS  The attributes have been updated.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseSetAttr (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    *Size      OPTIONAL,
+  IN     UINT64    *Atime     OPTIONAL,
+  IN     UINT64    *Mtime     OPTIONAL,
+  IN     UINT32    *Mode      OPTIONAL
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST             CommonReq;
+  VIRTIO_FS_FUSE_SETATTR_REQUEST     AttrReq;
+  VIRTIO_FS_IO_VECTOR                ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST      ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE            CommonResp;
+  VIRTIO_FS_FUSE_GETATTR_RESPONSE    GetAttrResp;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE AttrResp;
+  VIRTIO_FS_IO_VECTOR                RespIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST      RespSgList;
+  EFI_STATUS                         Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &AttrReq;
+  ReqIoVec[1].Size   = sizeof AttrReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &GetAttrResp;
+  RespIoVec[1].Size   = sizeof GetAttrResp;
+  RespIoVec[2].Buffer = &AttrResp;
+  RespIoVec[2].Size   = sizeof AttrResp;
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
+             VirtioFsFuseOpSetAttr, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_SETATTR-specific fields.
+  //
+  AttrReq.Valid      = 0;
+  AttrReq.Padding    = 0;
+  AttrReq.FileHandle = 0;
+  AttrReq.Size       = (Size == NULL) ? 0 : *Size;
+  AttrReq.LockOwner  = 0;
+  AttrReq.Atime      = (Atime == NULL) ? 0 : *Atime;
+  AttrReq.Mtime      = (Mtime == NULL) ? 0 : *Mtime;
+  AttrReq.Ctime      = 0;
+  AttrReq.AtimeNsec  = 0;
+  AttrReq.MtimeNsec  = 0;
+  AttrReq.CtimeNsec  = 0;
+  AttrReq.Mode       = (Mode == NULL) ? 0 : *Mode;
+  AttrReq.Unused4    = 0;
+  AttrReq.Uid        = 0;
+  AttrReq.Gid        = 0;
+  AttrReq.Unused5    = 0;
+
+  if (Size != NULL) {
+    AttrReq.Valid |= VIRTIO_FS_FUSE_SETATTR_REQ_F_SIZE;
+  }
+  if (Atime != NULL) {
+    AttrReq.Valid |= VIRTIO_FS_FUSE_SETATTR_REQ_F_ATIME;
+  }
+  if (Mtime != NULL) {
+    AttrReq.Valid |= VIRTIO_FS_FUSE_SETATTR_REQ_F_MTIME;
+  }
+  if (Mode != NULL) {
+    AttrReq.Valid |= VIRTIO_FS_FUSE_SETATTR_REQ_F_MODE;
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
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu", __FUNCTION__,
+      VirtioFs->Label, NodeId));
+    if (Size != NULL) {
+      DEBUG ((DEBUG_ERROR, " Size=0x%Lx", *Size));
+    }
+    if (Atime != NULL) {
+      DEBUG ((DEBUG_ERROR, " Atime=%Lu", *Atime));
+    }
+    if (Mtime != NULL) {
+      DEBUG ((DEBUG_ERROR, " Mtime=%Lu", *Mtime));
+    }
+    if (Mode != NULL) {
+      DEBUG ((DEBUG_ERROR, " Mode=0x%x", *Mode)); // no support for octal :/
+    }
+    DEBUG ((DEBUG_ERROR, " Errno=%d\n",  CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



