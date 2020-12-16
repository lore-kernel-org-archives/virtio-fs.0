From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:47 +0100
Message-Id: <20201216211125.19496-11-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 10/48] OvmfPkg/VirtioFsDxe: add shared
	wrapper for FUSE_RELEASE / FUSE_RELEASEDIR
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

The FUSE_RELEASE and FUSE_RELEASEDIR commands only differ in the opcode.
Add a common function called VirtioFsFuseReleaseFileOrDir() for sending
either command.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  12 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   8 ++
 OvmfPkg/VirtioFsDxe/FuseRelease.c           | 121 ++++++++++++++++++++
 4 files changed, 142 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index c48105325515..c17a43c160e3 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -75,18 +75,20 @@ typedef struct {
 //
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
 //
 // FUSE operation codes.
 //
 typedef enum {
+  VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
+  VirtioFsFuseOpReleaseDir  = 29,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -100,16 +102,26 @@ typedef struct {
 } VIRTIO_FS_FUSE_REQUEST;
 
 typedef struct {
   UINT32 Len;
   INT32  Error;
   UINT64 Unique;
 } VIRTIO_FS_FUSE_RESPONSE;
 
+//
+// Header for VirtioFsFuseOpRelease and VirtioFsFuseOpReleaseDir.
+//
+typedef struct {
+  UINT64 FileHandle;
+  UINT32 Flags;
+  UINT32 ReleaseFlags;
+  UINT64 LockOwner;
+} VIRTIO_FS_FUSE_RELEASE_REQUEST;
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
index 051acbdd7199..95b1a5a8f60a 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -79,16 +79,17 @@ [Defines]
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseInit.c
   FuseOpenDir.c
+  FuseRelease.c
   Helpers.c
   SimpleFsOpenVolume.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   DebugLib
   MemoryAllocationLib
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 9c47454435ae..a99625d0473a 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -153,16 +153,24 @@ EFI_STATUS
 VirtioFsErrnoToEfiStatus (
   IN INT32 Errno
   );
 
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
+EFI_STATUS
+VirtioFsFuseReleaseFileOrDir (
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
diff --git a/OvmfPkg/VirtioFsDxe/FuseRelease.c b/OvmfPkg/VirtioFsDxe/FuseRelease.c
new file mode 100644
index 000000000000..dd45c7864fc8
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseRelease.c
@@ -0,0 +1,121 @@
+/** @file
+  FUSE_RELEASE / FUSE_RELEASEDIR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Close a regular file or a directory that is open, by sending the FUSE_RELEASE
+  or FUSE_RELEASEDIR request to the Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the
+                           FUSE_RELEASE / FUSE_RELEASEDIR request to. On
+                           output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode number of the file or directory to close.
+
+  @param[in] FuseHandle    The open handle to the file or directory to close.
+
+  @param[in] IsDir         TRUE if NodeId and FuseHandle refer to a directory,
+                           FALSE if NodeId and FuseHandle refer to a regular
+                           file.
+
+  @retval EFI_SUCCESS  The file or directory has been closed.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseReleaseFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     BOOLEAN   IsDir
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST         CommonReq;
+  VIRTIO_FS_FUSE_RELEASE_REQUEST ReleaseReq;
+  VIRTIO_FS_IO_VECTOR            ReqIoVec[2];
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
+  ReqIoVec[1].Buffer = &ReleaseReq;
+  ReqIoVec[1].Size   = sizeof ReleaseReq;
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
+             IsDir ? VirtioFsFuseOpReleaseDir : VirtioFsFuseOpRelease,
+             NodeId
+             );
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_RELEASE- / FUSE_RELEASEDIR-specific fields.
+  //
+  ReleaseReq.FileHandle   = FuseHandle;
+  ReleaseReq.Flags        = 0;
+  ReleaseReq.ReleaseFlags = 0;
+  ReleaseReq.LockOwner    = 0;
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



