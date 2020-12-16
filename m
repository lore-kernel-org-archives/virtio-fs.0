From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:05 +0100
Message-Id: <20201216211125.19496-29-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 28/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_STATFS
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

Add the VirtioFsFuseStatFs() function, for sending the FUSE_STATFS command
to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  17 ++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   7 ++
 OvmfPkg/VirtioFsDxe/FuseStatFs.c            | 102 ++++++++++++++++++++
 4 files changed, 127 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index efcf57941c59..800d3651e12b 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -114,16 +114,17 @@ typedef struct {
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpGetAttr     =  3,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpUnlink      = 10,
   VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
+  VirtioFsFuseOpStatFs      = 17,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
   VirtioFsFuseOpCreate      = 35,
@@ -228,16 +229,32 @@ typedef struct {
 } VIRTIO_FS_FUSE_OPEN_REQUEST;
 
 typedef struct {
   UINT64 FileHandle;
   UINT32 OpenFlags;
   UINT32 Padding;
 } VIRTIO_FS_FUSE_OPEN_RESPONSE;
 
+//
+// Header for VirtioFsFuseOpStatFs.
+//
+typedef struct {
+  UINT64 Blocks;
+  UINT64 Bfree;
+  UINT64 Bavail;
+  UINT64 Files;
+  UINT64 Ffree;
+  UINT32 Bsize;
+  UINT32 Namelen;
+  UINT32 Frsize;
+  UINT32 Padding;
+  UINT32 Spare[6];
+} VIRTIO_FS_FUSE_STATFS_RESPONSE;
+
 //
 // Header for VirtioFsFuseOpRelease and VirtioFsFuseOpReleaseDir.
 //
 typedef struct {
   UINT64 FileHandle;
   UINT32 Flags;
   UINT32 ReleaseFlags;
   UINT64 LockOwner;
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 233c0c5c0f9a..318449db3e63 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -89,16 +89,17 @@ [Sources]
   FuseGetAttr.c
   FuseInit.c
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRelease.c
+  FuseStatFs.c
   FuseUnlink.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
   SimpleFsGetPosition.c
   SimpleFsOpen.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 3bf64c0146fa..029c568b39c7 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -285,16 +285,23 @@ VirtioFsFuseRemoveFileOrDir (
 EFI_STATUS
 VirtioFsFuseOpen (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     BOOLEAN   ReadWrite,
      OUT UINT64    *FuseHandle
   );
 
+EFI_STATUS
+VirtioFsFuseStatFs (
+  IN OUT VIRTIO_FS                      *VirtioFs,
+  IN     UINT64                         NodeId,
+     OUT VIRTIO_FS_FUSE_STATFS_RESPONSE *FilesysAttr
+     );
+
 EFI_STATUS
 VirtioFsFuseReleaseFileOrDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseStatFs.c b/OvmfPkg/VirtioFsDxe/FuseStatFs.c
new file mode 100644
index 000000000000..e794f8977a48
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseStatFs.c
@@ -0,0 +1,102 @@
+/** @file
+  FUSE_STATFS wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send the FUSE_STATFS request to the Virtio Filesysem device, for retrieving
+  the attributes of the host-side filesystem that contains NodeId.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_STATFS
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode whose containing filesystem is to be
+                           queried for its attributes.
+
+  @param[out] FilesysAttr  The VIRTIO_FS_FUSE_STATFS_RESPONSE object describing
+                           the filesystem that underlies NodeId.
+
+  @retval EFI_SUCCESS  FilesysAttr has been filled in.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseStatFs (
+  IN OUT VIRTIO_FS                      *VirtioFs,
+  IN     UINT64                         NodeId,
+     OUT VIRTIO_FS_FUSE_STATFS_RESPONSE *FilesysAttr
+     )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[1];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = FilesysAttr;
+  RespIoVec[1].Size   = sizeof *FilesysAttr;
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
+             VirtioFsFuseOpStatFs, NodeId);
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
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu Errno=%d\n",
+      __FUNCTION__, VirtioFs->Label, NodeId, CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



