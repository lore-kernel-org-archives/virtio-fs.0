From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:55 +0100
Message-Id: <20201216211125.19496-19-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 18/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_OPEN
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

Add the VirtioFsFuseOpen() function, for sending the FUSE_OPEN command to
the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  35 +++---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   8 ++
 OvmfPkg/VirtioFsDxe/FuseOpen.c              | 126 ++++++++++++++++++++
 4 files changed, 156 insertions(+), 14 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index fec2f4be531f..7b6f30335577 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -76,21 +76,28 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
 //
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
+//
+// Flags for VirtioFsFuseOpOpen.
+//
+#define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
+#define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
+
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpForget      =  2,
+  VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
 } VIRTIO_FS_FUSE_OPCODE;
@@ -118,16 +125,30 @@ typedef struct {
 
 //
 // Header for VirtioFsFuseOpForget.
 //
 typedef struct {
   UINT64 NumberOfLookups;
 } VIRTIO_FS_FUSE_FORGET_REQUEST;
 
+//
+// Headers for VirtioFsFuseOpOpen and VirtioFsFuseOpOpenDir.
+//
+typedef struct {
+  UINT32 Flags;
+  UINT32 Unused;
+} VIRTIO_FS_FUSE_OPEN_REQUEST;
+
+typedef struct {
+  UINT64 FileHandle;
+  UINT32 OpenFlags;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_OPEN_RESPONSE;
+
 //
 // Header for VirtioFsFuseOpRelease and VirtioFsFuseOpReleaseDir.
 //
 typedef struct {
   UINT64 FileHandle;
   UINT32 Flags;
   UINT32 ReleaseFlags;
   UINT64 LockOwner;
@@ -170,25 +191,11 @@ typedef struct {
   UINT16 MaxBackground;
   UINT16 CongestionThreshold;
   UINT32 MaxWrite;
   UINT32 TimeGran;
   UINT16 MaxPages;
   UINT16 MapAlignment;
   UINT32 Unused[8];
 } VIRTIO_FS_FUSE_INIT_RESPONSE;
-
-//
-// Headers for VirtioFsFuseOpOpenDir.
-//
-typedef struct {
-  UINT32 Flags;
-  UINT32 Unused;
-} VIRTIO_FS_FUSE_OPEN_REQUEST;
-
-typedef struct {
-  UINT64 FileHandle;
-  UINT32 OpenFlags;
-  UINT32 Padding;
-} VIRTIO_FS_FUSE_OPEN_RESPONSE;
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 0c92bccdac86..dc9a12820f3d 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -81,16 +81,17 @@ [Packages]
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseFlush.c
   FuseForget.c
   FuseFsync.c
   FuseInit.c
+  FuseOpen.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
   SimpleFsGetPosition.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 487d215c7f38..c13258a2e08f 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -230,16 +230,24 @@ VirtioFsAppendPath (
 //
 
 EFI_STATUS
 VirtioFsFuseForget (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId
   );
 
+EFI_STATUS
+VirtioFsFuseOpen (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     BOOLEAN   ReadWrite,
+     OUT UINT64    *FuseHandle
+  );
+
 EFI_STATUS
 VirtioFsFuseReleaseFileOrDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseOpen.c b/OvmfPkg/VirtioFsDxe/FuseOpen.c
new file mode 100644
index 000000000000..b731580729b6
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseOpen.c
@@ -0,0 +1,126 @@
+/** @file
+  FUSE_OPEN wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send a FUSE_OPEN request to the Virtio Filesystem device, for opening a
+  regular file.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_OPEN
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode number of the regular file to open.
+
+  @param[in] ReadWrite     If TRUE, open the regular file in read-write mode.
+                           If FALSE, open the regular file in read-only mode.
+
+  @param[out] FuseHandle   The open handle to the regular file, returned by the
+                           Virtio Filesystem device.
+
+  @retval EFI_SUCCESS  The regular file has been opened.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseOpen (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     BOOLEAN   ReadWrite,
+     OUT UINT64    *FuseHandle
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_OPEN_REQUEST   OpenReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_FUSE_OPEN_RESPONSE  OpenResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &OpenReq;
+  ReqIoVec[1].Size   = sizeof OpenReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &OpenResp;
+  RespIoVec[1].Size   = sizeof OpenResp;
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
+             VirtioFsFuseOpOpen, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_OPEN-specific fields.
+  //
+  OpenReq.Flags  = (ReadWrite ?
+                    VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR :
+                    VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY);
+  OpenReq.Unused = 0;
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
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu ReadWrite=%d "
+        "Errno=%d\n", __FUNCTION__, VirtioFs->Label, NodeId, ReadWrite,
+        CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Output the open handle.
+  //
+  *FuseHandle = OpenResp.FileHandle;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



