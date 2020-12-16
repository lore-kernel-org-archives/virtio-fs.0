From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:50 +0100
Message-Id: <20201216211125.19496-14-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 13/48] OvmfPkg/VirtioFsDxe: add a shared
	wrapper for FUSE_FSYNC / FUSE_FSYNCDIR
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

The FUSE_FSYNC and FUSE_FSYNCDIR commands only differ in the opcode. Add a
common function for wrapping both.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  11 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   8 ++
 OvmfPkg/VirtioFsDxe/FuseFsync.c             | 121 ++++++++++++++++++++
 4 files changed, 141 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 0241daf1e8d6..797d94a39a39 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -82,19 +82,21 @@ typedef struct {
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpRelease     = 18,
+  VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
+  VirtioFsFuseOpFsyncDir    = 30,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -125,16 +127,25 @@ typedef struct {
 //
 typedef struct {
   UINT64 FileHandle;
   UINT32 Flags;
   UINT32 ReleaseFlags;
   UINT64 LockOwner;
 } VIRTIO_FS_FUSE_RELEASE_REQUEST;
 
+//
+// Header for VirtioFsFuseOpFsync and VirtioFsFuseOpFsyncDir.
+//
+typedef struct {
+  UINT64 FileHandle;
+  UINT32 FsyncFlags;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_FSYNC_REQUEST;
+
 //
 // Headers for VirtioFsFuseOpInit.
 //
 typedef struct {
   UINT32 Major;
   UINT32 Minor;
   UINT32 MaxReadahead;
   UINT32 Flags;
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index baeb741be18f..839660a0f904 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -78,16 +78,17 @@ [Defines]
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseForget.c
+  FuseFsync.c
   FuseInit.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 68ed6cd7e6a1..ac1fb8965472 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -204,16 +204,24 @@ VirtioFsFuseForget (
 EFI_STATUS
 VirtioFsFuseReleaseFileOrDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir
   );
 
+EFI_STATUS
+VirtioFsFuseFsyncFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     BOOLEAN   IsDir
+  );
+
 EFI_STATUS
 VirtioFsFuseInitSession (
   IN OUT VIRTIO_FS *VirtioFs
   );
 
 EFI_STATUS
 VirtioFsFuseOpenDir (
   IN OUT VIRTIO_FS *VirtioFs,
diff --git a/OvmfPkg/VirtioFsDxe/FuseFsync.c b/OvmfPkg/VirtioFsDxe/FuseFsync.c
new file mode 100644
index 000000000000..ea1463cd8073
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseFsync.c
@@ -0,0 +1,121 @@
+/** @file
+  FUSE_FSYNC / FUSE_FSYNCDIR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Synchronize the in-core state of a regular file or a directory with the
+  storage device on the host, by sending the FUSE_FSYNC or FUSE_FSYNCDIR
+  request to the Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_FSYNC
+                           / FUSE_FSYNCDIR request to. On output, the FUSE
+                           request counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] NodeId        The inode number of the file or directory to sync.
+
+  @param[in] FuseHandle    The open handle to the file or directory to sync.
+
+  @param[in] IsDir         TRUE if NodeId and FuseHandle refer to a directory,
+                           FALSE if NodeId and FuseHandle refer to a regular
+                           file.
+
+  @retval EFI_SUCCESS  The file or directory has been synchronized.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseFsyncFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     BOOLEAN   IsDir
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_FSYNC_REQUEST  FsyncReq;
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
+  ReqIoVec[1].Buffer = &FsyncReq;
+  ReqIoVec[1].Size   = sizeof FsyncReq;
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
+             IsDir ? VirtioFsFuseOpFsyncDir : VirtioFsFuseOpFsync,
+             NodeId
+             );
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_FSYNC- / FUSE_FSYNCDIR-specific fields.
+  //
+  FsyncReq.FileHandle = FuseHandle;
+  FsyncReq.FsyncFlags = 0;
+  FsyncReq.Padding    = 0;
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
+    DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu FuseHandle=%Lu "
+      "IsDir=%d Errno=%d\n", __FUNCTION__, VirtioFs->Label, NodeId, FuseHandle,
+      IsDir, CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



