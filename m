From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:56 +0100
Message-Id: <20201216211125.19496-20-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 19/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_MKDIR
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

Add the VirtioFsFuseMkDir() function, for sending the FUSE_MKDIR command
to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  55 ++++++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   8 ++
 OvmfPkg/VirtioFsDxe/FuseMkDir.c             | 134 ++++++++++++++++++++
 4 files changed, 198 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 7b6f30335577..9ffeb9c8c954 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -76,27 +76,35 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
 //
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
+//
+// File mode bitmasks.
+//
+#define VIRTIO_FS_FUSE_MODE_PERM_RWXU 0000700u
+#define VIRTIO_FS_FUSE_MODE_PERM_RWXG 0000070u
+#define VIRTIO_FS_FUSE_MODE_PERM_RWXO 0000007u
+
 //
 // Flags for VirtioFsFuseOpOpen.
 //
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpForget      =  2,
+  VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
@@ -118,23 +126,70 @@ typedef struct {
 } VIRTIO_FS_FUSE_REQUEST;
 
 typedef struct {
   UINT32 Len;
   INT32  Error;
   UINT64 Unique;
 } VIRTIO_FS_FUSE_RESPONSE;
 
+//
+// Structure with which the Virtio Filesystem device reports a NodeId to the
+// FUSE client (i.e., to the Virtio Filesystem driver). This structure is a
+// part of the response headers for operations that inform the FUSE client of
+// an inode.
+//
+typedef struct {
+  UINT64 NodeId;
+  UINT64 Generation;
+  UINT64 EntryValid;
+  UINT64 AttrValid;
+  UINT32 EntryValidNsec;
+  UINT32 AttrValidNsec;
+} VIRTIO_FS_FUSE_NODE_RESPONSE;
+
+//
+// Structure describing the host-side attributes of an inode. This structure is
+// a part of the response headers for operations that inform the FUSE client of
+// an inode.
+//
+typedef struct {
+  UINT64 Ino;
+  UINT64 Size;
+  UINT64 Blocks;
+  UINT64 Atime;
+  UINT64 Mtime;
+  UINT64 Ctime;
+  UINT32 AtimeNsec;
+  UINT32 MtimeNsec;
+  UINT32 CtimeNsec;
+  UINT32 Mode;
+  UINT32 Nlink;
+  UINT32 Uid;
+  UINT32 Gid;
+  UINT32 Rdev;
+  UINT32 Blksize;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE;
+
 //
 // Header for VirtioFsFuseOpForget.
 //
 typedef struct {
   UINT64 NumberOfLookups;
 } VIRTIO_FS_FUSE_FORGET_REQUEST;
 
+//
+// Header for VirtioFsFuseOpMkDir.
+//
+typedef struct {
+  UINT32 Mode;
+  UINT32 Umask;
+} VIRTIO_FS_FUSE_MKDIR_REQUEST;
+
 //
 // Headers for VirtioFsFuseOpOpen and VirtioFsFuseOpOpenDir.
 //
 typedef struct {
   UINT32 Flags;
   UINT32 Unused;
 } VIRTIO_FS_FUSE_OPEN_REQUEST;
 
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index dc9a12820f3d..eebb86f7c275 100644
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
+  FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index c13258a2e08f..8fd56bdbf6e1 100644
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
+VirtioFsFuseMkDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+     OUT UINT64    *NodeId
+  );
+
 EFI_STATUS
 VirtioFsFuseOpen (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     BOOLEAN   ReadWrite,
      OUT UINT64    *FuseHandle
   );
 
diff --git a/OvmfPkg/VirtioFsDxe/FuseMkDir.c b/OvmfPkg/VirtioFsDxe/FuseMkDir.c
new file mode 100644
index 000000000000..541ff330cd1e
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseMkDir.c
@@ -0,0 +1,134 @@
+/** @file
+  FUSE_MKDIR wrapper for the Virtio Filesystem device.
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
+  Send a FUSE_MKDIR request to the Virtio Filesystem device, for creating a
+  directory.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_MKDIR
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] ParentNodeId  The inode number of the direct parent directory of
+                           the directory to create.
+
+  @param[in] Name          The single-component filename of the directory to
+                           create, under the parent directory identified by
+                           ParentNodeId.
+
+  @param[out] NodeId       The inode number of the new directory.
+
+  @retval EFI_SUCCESS  The directory has been created.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseMkDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    ParentNodeId,
+  IN     CHAR8     *Name,
+     OUT UINT64    *NodeId
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST             CommonReq;
+  VIRTIO_FS_FUSE_MKDIR_REQUEST       MkDirReq;
+  VIRTIO_FS_IO_VECTOR                ReqIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST      ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE            CommonResp;
+  VIRTIO_FS_FUSE_NODE_RESPONSE       NodeResp;
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
+  ReqIoVec[1].Buffer = &MkDirReq;
+  ReqIoVec[1].Size   = sizeof MkDirReq;
+  ReqIoVec[2].Buffer = Name;
+  ReqIoVec[2].Size   = AsciiStrSize (Name);
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &NodeResp;
+  RespIoVec[1].Size   = sizeof NodeResp;
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
+             VirtioFsFuseOpMkDir, ParentNodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_MKDIR-specific fields.
+  //
+  MkDirReq.Mode  = (VIRTIO_FS_FUSE_MODE_PERM_RWXU |
+                    VIRTIO_FS_FUSE_MODE_PERM_RWXG |
+                    VIRTIO_FS_FUSE_MODE_PERM_RWXO);
+  MkDirReq.Umask = 0;
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
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" ParentNodeId=%Lu Name=\"%a\" "
+        "Errno=%d\n", __FUNCTION__, VirtioFs->Label, ParentNodeId, Name,
+        CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Output the NodeId of the new directory.
+  //
+  *NodeId = NodeResp.NodeId;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



