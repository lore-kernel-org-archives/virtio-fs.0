From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:51 +0100
Message-Id: <20201216211125.19496-15-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 14/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_FLUSH
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

Add the VirtioFsFuseFlush() function, for sending the FUSE_FLUSH command
to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  11 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   7 ++
 OvmfPkg/VirtioFsDxe/FuseFlush.c             | 111 ++++++++++++++++++++
 4 files changed, 130 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 797d94a39a39..fec2f4be531f 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -83,16 +83,17 @@ typedef struct {
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
+  VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
@@ -136,16 +137,26 @@ typedef struct {
 // Header for VirtioFsFuseOpFsync and VirtioFsFuseOpFsyncDir.
 //
 typedef struct {
   UINT64 FileHandle;
   UINT32 FsyncFlags;
   UINT32 Padding;
 } VIRTIO_FS_FUSE_FSYNC_REQUEST;
 
+//
+// Header for VirtioFsFuseOpFlush.
+//
+typedef struct {
+  UINT64 FileHandle;
+  UINT32 Unused;
+  UINT32 Padding;
+  UINT64 LockOwner;
+} VIRTIO_FS_FUSE_FLUSH_REQUEST;
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
index 839660a0f904..15e21772c8ac 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -77,16 +77,17 @@ [Defines]
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
+  FuseFlush.c
   FuseForget.c
   FuseFsync.c
   FuseInit.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index ac1fb8965472..7151a62bb42b 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -212,16 +212,23 @@ VirtioFsFuseReleaseFileOrDir (
 EFI_STATUS
 VirtioFsFuseFsyncFileOrDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir
   );
 
+EFI_STATUS
+VirtioFsFuseFlush (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle
+  );
+
 EFI_STATUS
 VirtioFsFuseInitSession (
   IN OUT VIRTIO_FS *VirtioFs
   );
 
 EFI_STATUS
 VirtioFsFuseOpenDir (
   IN OUT VIRTIO_FS *VirtioFs,
diff --git a/OvmfPkg/VirtioFsDxe/FuseFlush.c b/OvmfPkg/VirtioFsDxe/FuseFlush.c
new file mode 100644
index 000000000000..b689ad32910a
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseFlush.c
@@ -0,0 +1,111 @@
+/** @file
+  FUSE_FLUSH wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Flush changes queued on the local virtualization host to the remote storage
+  server's memory (not storage device), over the network, by sending the
+  FUSE_FLUSH request to the Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_FLUSH
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode number of the regular file to flush.
+
+  @param[in] FuseHandle    The open handle to the regular file to flush.
+
+  @retval EFI_SUCCESS  The regular file has been flushed.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseFlush (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_FLUSH_REQUEST  FlushReq;
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
+  ReqIoVec[1].Buffer = &FlushReq;
+  ReqIoVec[1].Size   = sizeof FlushReq;
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
+             VirtioFsFuseOpFlush, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_FLUSH-specific fields.
+  //
+  FlushReq.FileHandle = FuseHandle;
+  FlushReq.Unused     = 0;
+  FlushReq.Padding    = 0;
+  FlushReq.LockOwner  = 0;
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
+      "Errno=%d\n", __FUNCTION__, VirtioFs->Label, NodeId, FuseHandle,
+      CommonResp.Error));
+    Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+  }
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



