From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:46 +0100
Message-Id: <20201216211125.19496-10-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 09/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_OPENDIR
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

Add the VirtioFsFuseOpenDir() function, for sending the FUSE_OPENDIR
command to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  15 +++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   7 ++
 OvmfPkg/VirtioFsDxe/FuseOpenDir.c           | 120 ++++++++++++++++++++
 4 files changed, 143 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 006e0f5debcb..c48105325515 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -76,16 +76,17 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpInit        = 26,
+  VirtioFsFuseOpOpenDir     = 27,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -122,11 +123,25 @@ typedef struct {
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
+// Headers for VirtioFsFuseOpOpenDir.
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
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 8fddc50318f1..051acbdd7199 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -78,16 +78,17 @@ [Defines]
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseInit.c
+  FuseOpenDir.c
   Helpers.c
   SimpleFsOpenVolume.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   DebugLib
   MemoryAllocationLib
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index b8d464011843..9c47454435ae 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -158,16 +158,23 @@ VirtioFsErrnoToEfiStatus (
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseInitSession (
   IN OUT VIRTIO_FS *VirtioFs
   );
 
+EFI_STATUS
+VirtioFsFuseOpenDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
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
diff --git a/OvmfPkg/VirtioFsDxe/FuseOpenDir.c b/OvmfPkg/VirtioFsDxe/FuseOpenDir.c
new file mode 100644
index 000000000000..eef522693c3f
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseOpenDir.c
@@ -0,0 +1,120 @@
+/** @file
+  FUSE_OPENDIR wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send a FUSE_OPENDIR request to the Virtio Filesystem device, for opening a
+  directory.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the
+                           FUSE_OPENDIR request to. On output, the FUSE request
+                           counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] NodeId        The inode number of the directory to open.
+
+  @param[out] FuseHandle   The open file handle returned by the Virtio
+                           Filesystem device.
+
+  @retval EFI_SUCCESS  The directory has been opened.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseOpenDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
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
+             VirtioFsFuseOpOpenDir, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_OPENDIR-specific fields.
+  //
+  OpenReq.Flags  = 0;
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
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu Errno=%d\n",
+        __FUNCTION__, VirtioFs->Label, NodeId, CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Output the open file handle.
+  //
+  *FuseHandle = OpenResp.FileHandle;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



