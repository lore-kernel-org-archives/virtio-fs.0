From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:49 +0100
Message-Id: <20201216211125.19496-13-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 12/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_FORGET
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

Add the VirtioFsFuseForget() function, for sending the FUSE_FORGET command
to the Virtio Filesystem device.

This is an unusual command in that it doesn't generate any response from
the FUSE server.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  8 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |  1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  6 ++
 OvmfPkg/VirtioFsDxe/FuseForget.c            | 85 ++++++++++++++++++++
 4 files changed, 100 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 67fcf975e8b2..0241daf1e8d6 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -80,16 +80,17 @@ typedef struct {
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
 //
 // FUSE operation codes.
 //
 typedef enum {
+  VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
@@ -107,16 +108,23 @@ typedef struct {
 } VIRTIO_FS_FUSE_REQUEST;
 
 typedef struct {
   UINT32 Len;
   INT32  Error;
   UINT64 Unique;
 } VIRTIO_FS_FUSE_RESPONSE;
 
+//
+// Header for VirtioFsFuseOpForget.
+//
+typedef struct {
+  UINT64 NumberOfLookups;
+} VIRTIO_FS_FUSE_FORGET_REQUEST;
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
index 28e66082ecfe..baeb741be18f 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -77,16 +77,17 @@ [Defines]
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
+  FuseForget.c
   FuseInit.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 34574d0596fc..68ed6cd7e6a1 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -190,16 +190,22 @@ EFI_STATUS
 VirtioFsErrnoToEfiStatus (
   IN INT32 Errno
   );
 
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
+EFI_STATUS
+VirtioFsFuseForget (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId
+  );
+
 EFI_STATUS
 VirtioFsFuseReleaseFileOrDir (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseForget.c b/OvmfPkg/VirtioFsDxe/FuseForget.c
new file mode 100644
index 000000000000..fdee42cffbff
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseForget.c
@@ -0,0 +1,85 @@
+/** @file
+  FUSE_FORGET wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Make the Virtio Filesysem device drop one reference count from a NodeId that
+  the driver looked up by filename.
+
+  Send the FUSE_FORGET request to the Virtio Filesysem device for this. Unlike
+  most other FUSE requests, FUSE_FORGET doesn't elicit a response, not even the
+  common VIRTIO_FS_FUSE_RESPONSE header.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_FORGET
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode number that the client learned by way of
+                           lookup, and that the server should now un-reference
+                           exactly once.
+
+  @retval EFI_SUCCESS  The FUSE_FORGET request has been submitted.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit().
+**/
+EFI_STATUS
+VirtioFsFuseForget (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_FORGET_REQUEST ForgetReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Set up the scatter-gather list (note: only request).
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &ForgetReq;
+  ReqIoVec[1].Size   = sizeof ForgetReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  //
+  // Validate the scatter-gather list (request only); calculate the total
+  // transfer size.
+  //
+  Status = VirtioFsSgListsValidate (VirtioFs, &ReqSgList, NULL);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the common request header.
+  //
+  Status = VirtioFsFuseNewRequest (VirtioFs, &CommonReq, ReqSgList.TotalSize,
+             VirtioFsFuseOpForget, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_FORGET-specific fields.
+  //
+  ForgetReq.NumberOfLookups = 1;
+
+  //
+  // Submit the request. There's not going to be a response.
+  //
+  Status = VirtioFsSgListsSubmit (VirtioFs, &ReqSgList, NULL);
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



