From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:02 +0100
Message-Id: <20201216211125.19496-26-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 25/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_GETATTR
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

Add the VirtioFsFuseGetAttr() function, for sending the FUSE_GETATTR
command to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  16 +++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   7 ++
 OvmfPkg/VirtioFsDxe/FuseGetAttr.c           | 116 ++++++++++++++++++++
 4 files changed, 140 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index f49452830abc..efcf57941c59 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -109,16 +109,17 @@ typedef struct {
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
+  VirtioFsFuseOpGetAttr     =  3,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpUnlink      = 10,
   VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
@@ -190,16 +191,31 @@ typedef struct {
 
 //
 // Header for VirtioFsFuseOpForget.
 //
 typedef struct {
   UINT64 NumberOfLookups;
 } VIRTIO_FS_FUSE_FORGET_REQUEST;
 
+//
+// Headers for VirtioFsFuseOpGetAttr.
+//
+typedef struct {
+  UINT32 GetAttrFlags;
+  UINT32 Dummy;
+  UINT64 FileHandle;
+} VIRTIO_FS_FUSE_GETATTR_REQUEST;
+
+typedef struct {
+  UINT64 AttrValid;
+  UINT32 AttrValidNsec;
+  UINT32 Dummy;
+} VIRTIO_FS_FUSE_GETATTR_RESPONSE;
+
 //
 // Header for VirtioFsFuseOpMkDir.
 //
 typedef struct {
   UINT32 Mode;
   UINT32 Umask;
 } VIRTIO_FS_FUSE_MKDIR_REQUEST;
 
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 2332aa3ee551..233c0c5c0f9a 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -81,16 +81,17 @@ [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseFlush.c
   FuseForget.c
   FuseFsync.c
+  FuseGetAttr.c
   FuseInit.c
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRelease.c
   FuseUnlink.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 0e4f2109eb02..3bf64c0146fa 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -254,16 +254,23 @@ VirtioFsFuseLookup (
   );
 
 EFI_STATUS
 VirtioFsFuseForget (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId
   );
 
+EFI_STATUS
+VirtioFsFuseGetAttr (
+  IN OUT VIRTIO_FS                          *VirtioFs,
+  IN     UINT64                             NodeId,
+     OUT VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr
+  );
+
 EFI_STATUS
 VirtioFsFuseMkDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    ParentNodeId,
   IN     CHAR8     *Name,
      OUT UINT64    *NodeId
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseGetAttr.c b/OvmfPkg/VirtioFsDxe/FuseGetAttr.c
new file mode 100644
index 000000000000..29d8ec8190e1
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseGetAttr.c
@@ -0,0 +1,116 @@
+/** @file
+  FUSE_GETATTR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send a FUSE_GETATTR request to the Virtio Filesystem device, for fetching the
+  attributes of an inode.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the
+                           FUSE_GETATTR request to. On output, the FUSE request
+                           counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] NodeId        The inode number for which the attributes should be
+                           retrieved.
+
+  @param[out] FuseAttr     The VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object
+                           describing the properties of the inode.
+
+  @retval EFI_SUCCESS  FuseAttr has been filled in.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseGetAttr (
+  IN OUT VIRTIO_FS                          *VirtioFs,
+  IN     UINT64                             NodeId,
+     OUT VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST          CommonReq;
+  VIRTIO_FS_FUSE_GETATTR_REQUEST  GetAttrReq;
+  VIRTIO_FS_IO_VECTOR             ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST   ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE         CommonResp;
+  VIRTIO_FS_FUSE_GETATTR_RESPONSE GetAttrResp;
+  VIRTIO_FS_IO_VECTOR             RespIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST   RespSgList;
+  EFI_STATUS                      Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &GetAttrReq;
+  ReqIoVec[1].Size   = sizeof GetAttrReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &GetAttrResp;
+  RespIoVec[1].Size   = sizeof GetAttrResp;
+  RespIoVec[2].Buffer = FuseAttr;
+  RespIoVec[2].Size   = sizeof *FuseAttr;
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
+             VirtioFsFuseOpGetAttr, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_GETATTR-specific fields.
+  //
+  GetAttrReq.GetAttrFlags = 0;
+  GetAttrReq.Dummy        = 0;
+  GetAttrReq.FileHandle   = 0;
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
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu Errno=%d\n",
+      __FUNCTION__, VirtioFs->Label, NodeId, CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



