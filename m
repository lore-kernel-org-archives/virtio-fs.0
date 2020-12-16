From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:59 +0100
Message-Id: <20201216211125.19496-23-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 22/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_LOOKUP
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

Add the VirtioFsFuseLookup() function, for sending the FUSE_LOOKUP command
to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |   6 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |   9 ++
 OvmfPkg/VirtioFsDxe/FuseLookup.c            | 148 ++++++++++++++++++++
 4 files changed, 164 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 5d1d990a2d83..8a07b3d2eb93 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -76,16 +76,21 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
 //
 // The inode number of the root directory.
 //
 #define VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID 1
 
+//
+// Distinguished errno values.
+//
+#define VIRTIO_FS_FUSE_ERRNO_ENOENT (-2)
+
 //
 // File mode bitmasks.
 //
 #define VIRTIO_FS_FUSE_MODE_TYPE_MASK 0170000u
 #define VIRTIO_FS_FUSE_MODE_TYPE_REG  0100000u
 #define VIRTIO_FS_FUSE_MODE_TYPE_DIR  0040000u
 #define VIRTIO_FS_FUSE_MODE_PERM_RWXU 0000700u
 #define VIRTIO_FS_FUSE_MODE_PERM_RUSR 0000400u
@@ -102,16 +107,17 @@ typedef struct {
 //
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
 //
 // FUSE operation codes.
 //
 typedef enum {
+  VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 7d7272188465..3552ece6b945 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -82,16 +82,17 @@ [Packages]
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
   FuseFlush.c
   FuseForget.c
   FuseFsync.c
   FuseInit.c
+  FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRelease.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 6cc5257bab40..b2e4adce098b 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -231,16 +231,25 @@ VirtioFsFuseAttrToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
      OUT EFI_FILE_INFO                      *FileInfo
   );
 
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
+EFI_STATUS
+VirtioFsFuseLookup (
+  IN OUT VIRTIO_FS                          *VirtioFs,
+  IN     UINT64                             DirNodeId,
+  IN     CHAR8                              *Name,
+     OUT UINT64                             *NodeId,
+     OUT VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr
+  );
+
 EFI_STATUS
 VirtioFsFuseForget (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId
   );
 
 EFI_STATUS
 VirtioFsFuseMkDir (
diff --git a/OvmfPkg/VirtioFsDxe/FuseLookup.c b/OvmfPkg/VirtioFsDxe/FuseLookup.c
new file mode 100644
index 000000000000..5c9a825e1725
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseLookup.c
@@ -0,0 +1,148 @@
+/** @file
+  FUSE_LOOKUP wrapper for the Virtio Filesystem device.
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
+  Send a FUSE_LOOKUP request to the Virtio Filesystem device, for resolving a
+  filename to an inode.
+
+  The function returns EFI_NOT_FOUND exclusively if the Virtio Filesystem
+  device explicitly responds with ENOENT -- "No such file or directory".
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_LOOKUP
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] DirNodeId     The inode number of the directory in which Name
+                           should be resolved to an inode.
+
+  @param[in] Name          The single-component filename to resolve in the
+                           directory identified by DirNodeId.
+
+  @param[out] NodeId       The inode number which Name has been resolved to.
+
+  @param[out] FuseAttr     The VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object
+                           describing the properties of the resolved inode.
+
+  @retval EFI_SUCCESS    Filename to inode resolution successful.
+
+  @retval EFI_NOT_FOUND  The Virtio Filesystem device explicitly reported
+                         ENOENT -- "No such file or directory".
+
+  @return                The "errno" value mapped to an EFI_STATUS code, if the
+                         Virtio Filesystem device explicitly reported an error
+                         different from ENOENT. If said mapping resulted in
+                         EFI_NOT_FOUND, it is remapped to EFI_DEVICE_ERROR.
+
+  @return                Error codes propagated from VirtioFsSgListsValidate(),
+                         VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                         VirtioFsFuseCheckResponse(). EFI_NOT_FOUND is remapped
+                         to EFI_DEVICE_ERROR.
+**/
+EFI_STATUS
+VirtioFsFuseLookup (
+  IN OUT VIRTIO_FS                          *VirtioFs,
+  IN     UINT64                             DirNodeId,
+  IN     CHAR8                              *Name,
+     OUT UINT64                             *NodeId,
+     OUT VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_FUSE_NODE_RESPONSE  NodeResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = Name;
+  ReqIoVec[1].Size   = AsciiStrSize (Name);
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &NodeResp;
+  RespIoVec[1].Size   = sizeof NodeResp;
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
+    goto Fail;
+  }
+
+  //
+  // Populate the common request header.
+  //
+  Status = VirtioFsFuseNewRequest (VirtioFs, &CommonReq, ReqSgList.TotalSize,
+             VirtioFsFuseOpLookup, DirNodeId);
+  if (EFI_ERROR (Status)) {
+    goto Fail;
+  }
+
+  //
+  // Submit the request.
+  //
+  Status = VirtioFsSgListsSubmit (VirtioFs, &ReqSgList, &RespSgList);
+  if (EFI_ERROR (Status)) {
+    goto Fail;
+  }
+
+  //
+  // Verify the response (all response buffers are fixed size).
+  //
+  Status = VirtioFsFuseCheckResponse (&RespSgList, CommonReq.Unique, NULL);
+  if (EFI_ERROR (Status)) {
+    if (Status == EFI_DEVICE_ERROR) {
+      DEBUG ((
+        ((CommonResp.Error == VIRTIO_FS_FUSE_ERRNO_ENOENT) ?
+         DEBUG_VERBOSE :
+         DEBUG_ERROR),
+        "%a: Label=\"%s\" DirNodeId=%Lu Name=\"%a\" Errno=%d\n",
+        __FUNCTION__,
+        VirtioFs->Label,
+        DirNodeId,
+        Name,
+        CommonResp.Error
+        ));
+      if (CommonResp.Error == VIRTIO_FS_FUSE_ERRNO_ENOENT) {
+        return EFI_NOT_FOUND;
+      }
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    goto Fail;
+  }
+
+  //
+  // Output the NodeId to which Name has been resolved to.
+  //
+  *NodeId = NodeResp.NodeId;
+  return EFI_SUCCESS;
+
+Fail:
+  return (Status == EFI_NOT_FOUND) ? EFI_DEVICE_ERROR : Status;
+}
-- 
2.19.1.3.g30247aa5d201



