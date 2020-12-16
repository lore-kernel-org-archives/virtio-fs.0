From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:18 +0100
Message-Id: <20201216211125.19496-42-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 41/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_RENAME2
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

Add the VirtioFsFuseRename() function, for sending the FUSE_RENAME2
command to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  15 +++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   9 ++
 OvmfPkg/VirtioFsDxe/FuseRename.c            | 131 ++++++++++++++++++++
 4 files changed, 156 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 0b7b3ff80edd..0b2ed7010046 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -136,16 +136,21 @@ typedef struct {
   ((Namelen) == 0 || (Namelen) > SIZE_4KB ?                          \
    (UINTN)0 :                                                        \
    ALIGN_VALUE (                                                     \
      sizeof (VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE) + (UINTN)(Namelen), \
      sizeof (UINT64)                                                 \
      )                                                               \
    )
 
+//
+// Flags for VirtioFsFuseOpRename2.
+//
+#define VIRTIO_FS_FUSE_RENAME2_REQ_F_NOREPLACE BIT0
+
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpGetAttr     =  3,
   VirtioFsFuseOpMkDir       =  9,
@@ -159,16 +164,17 @@ typedef enum {
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
   VirtioFsFuseOpCreate      = 35,
   VirtioFsFuseOpReadDirPlus = 44,
+  VirtioFsFuseOpRename2     = 45,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -393,11 +399,20 @@ typedef struct {
 typedef struct {
   VIRTIO_FS_FUSE_NODE_RESPONSE       NodeResp;
   VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE AttrResp;
   UINT64                             NodeId;
   UINT64                             CookieForNextEntry;
   UINT32                             Namelen;
   UINT32                             Type;
 } VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE;
+
+//
+// Header for VirtioFsFuseOpRename2.
+//
+typedef struct {
+  UINT64 NewDir;
+  UINT32 Flags;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_RENAME2_REQUEST;
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 2c145da5f5ae..9dccd7d6a9ef 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -90,16 +90,17 @@ [Sources]
   FuseInit.c
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRead.c
   FuseRelease.c
+  FuseRename.c
   FuseStatFs.c
   FuseUnlink.c
   FuseWrite.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 132a63400527..9334e5434c51 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -391,16 +391,25 @@ EFI_STATUS
 VirtioFsFuseOpenOrCreate (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    ParentNodeId,
   IN     CHAR8     *Name,
      OUT UINT64    *NodeId,
      OUT UINT64    *FuseHandle
   );
 
+EFI_STATUS
+VirtioFsFuseRename (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    OldParentNodeId,
+  IN     CHAR8     *OldName,
+  IN     UINT64    NewParentNodeId,
+  IN     CHAR8     *NewName
+  );
+
 //
 // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
 // driver.
 //
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
diff --git a/OvmfPkg/VirtioFsDxe/FuseRename.c b/OvmfPkg/VirtioFsDxe/FuseRename.c
new file mode 100644
index 000000000000..fc9b27ccf6d4
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseRename.c
@@ -0,0 +1,131 @@
+/** @file
+  FUSE_RENAME2 wrapper for the Virtio Filesystem device.
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
+  Rename a regular file or a directory, by sending the FUSE_RENAME2 request to
+  the Virtio Filesystem device. If the new filename exists, the request will
+  fail.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs     The Virtio Filesystem device to send the
+                              FUSE_RENAME2 request to. On output, the FUSE
+                              request counter "VirtioFs->RequestId" will have
+                              been incremented.
+
+  @param[in] OldParentNodeId  The inode number of the directory in which
+                              OldName should be removed.
+
+  @param[in] OldName          The single-component filename to remove in the
+                              directory identified by OldParentNodeId.
+
+  @param[in] NewParentNodeId  The inode number of the directory in which
+                              NewName should be created, such that on
+                              successful return, (NewParentNodeId, NewName)
+                              refer to the same inode as (OldParentNodeId,
+                              OldName) did on entry.
+
+  @param[in] NewName          The single-component filename to create in the
+                              directory identified by NewParentNodeId.
+
+  @retval EFI_SUCCESS  The file or directory has been renamed.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseRename (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    OldParentNodeId,
+  IN     CHAR8     *OldName,
+  IN     UINT64    NewParentNodeId,
+  IN     CHAR8     *NewName
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST         CommonReq;
+  VIRTIO_FS_FUSE_RENAME2_REQUEST Rename2Req;
+  VIRTIO_FS_IO_VECTOR            ReqIoVec[4];
+  VIRTIO_FS_SCATTER_GATHER_LIST  ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE        CommonResp;
+  VIRTIO_FS_IO_VECTOR            RespIoVec[1];
+  VIRTIO_FS_SCATTER_GATHER_LIST  RespSgList;
+  EFI_STATUS                     Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &Rename2Req;
+  ReqIoVec[1].Size   = sizeof Rename2Req;
+  ReqIoVec[2].Buffer = OldName;
+  ReqIoVec[2].Size   = AsciiStrSize (OldName);
+  ReqIoVec[3].Buffer = NewName;
+  ReqIoVec[3].Size   = AsciiStrSize (NewName);
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
+  Status = VirtioFsFuseNewRequest (VirtioFs, &CommonReq, ReqSgList.TotalSize,
+             VirtioFsFuseOpRename2, OldParentNodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_RENAME2-specific fields.
+  //
+  Rename2Req.NewDir  = NewParentNodeId;
+  Rename2Req.Flags   = VIRTIO_FS_FUSE_RENAME2_REQ_F_NOREPLACE;
+  Rename2Req.Padding = 0;
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
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" OldParentNodeId=%Lu OldName=\"%a\" "
+      "NewParentNodeId=%Lu NewName=\"%a\" Errno=%d\n", __FUNCTION__,
+      VirtioFs->Label, OldParentNodeId, OldName, NewParentNodeId, NewName,
+      CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



