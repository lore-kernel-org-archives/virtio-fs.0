From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:15 +0100
Message-Id: <20201216211125.19496-39-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 38/48] OvmfPkg/VirtioFsDxe: implement the
	wrapper function for FUSE_WRITE
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

Add the VirtioFsFuseWrite() function, for sending the FUSE_WRITE command
to the Virtio Filesystem device.

(For avoiding oversized FUSE_WRITE commands, save the maximum write buffer
size that is advertized by the FUSE server, in the session init code.)

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  19 +++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  11 ++
 OvmfPkg/VirtioFsDxe/FuseInit.c              |  12 +-
 OvmfPkg/VirtioFsDxe/FuseWrite.c             | 155 ++++++++++++++++++++
 5 files changed, 196 insertions(+), 2 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index fa8c40019f4e..0b7b3ff80edd 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -148,16 +148,17 @@ typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpGetAttr     =  3,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpUnlink      = 10,
   VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
   VirtioFsFuseOpRead        = 15,
+  VirtioFsFuseOpWrite       = 16,
   VirtioFsFuseOpStatFs      = 17,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
@@ -277,16 +278,34 @@ typedef struct {
   UINT64 Offset;
   UINT32 Size;
   UINT32 ReadFlags;
   UINT64 LockOwner;
   UINT32 Flags;
   UINT32 Padding;
 } VIRTIO_FS_FUSE_READ_REQUEST;
 
+//
+// Headers for VirtioFsFuseOpWrite.
+//
+typedef struct {
+  UINT64 FileHandle;
+  UINT64 Offset;
+  UINT32 Size;
+  UINT32 WriteFlags;
+  UINT64 LockOwner;
+  UINT32 Flags;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_WRITE_REQUEST;
+
+typedef struct {
+  UINT32 Size;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_WRITE_RESPONSE;
+
 //
 // Header for VirtioFsFuseOpStatFs.
 //
 typedef struct {
   UINT64 Blocks;
   UINT64 Bfree;
   UINT64 Bavail;
   UINT64 Files;
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 39c77c7c4ee9..2c145da5f5ae 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -92,16 +92,17 @@ [Sources]
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
   FuseRead.c
   FuseRelease.c
   FuseStatFs.c
   FuseUnlink.c
+  FuseWrite.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
   SimpleFsGetPosition.c
   SimpleFsOpen.c
   SimpleFsOpenVolume.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index a704acdd520e..132a63400527 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -73,16 +73,17 @@ typedef struct {
   //                              -----------   ------------------  ----------
   UINT64                          Signature; // DriverBindingStart  0
   VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
   VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
   UINT16                          QueueSize; // VirtioFsInit        1
   VRING                           Ring;      // VirtioRingInit      2
   VOID                            *RingMap;  // VirtioRingMap       2
   UINT64                          RequestId; // FuseInitSession     1
+  UINT32                          MaxWrite;  // FuseInitSession     1
   EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
   LIST_ENTRY                      OpenFiles; // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
@@ -329,16 +330,26 @@ VirtioFsFuseReadFileOrDir (
   IN     UINT64    NodeId,
   IN     UINT64    FuseHandle,
   IN     BOOLEAN   IsDir,
   IN     UINT64    Offset,
   IN OUT UINT32    *Size,
      OUT VOID      *Data
   );
 
+EFI_STATUS
+VirtioFsFuseWrite (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     UINT64    Offset,
+  IN OUT UINT32    *Size,
+  IN     VOID      *Data
+  );
+
 EFI_STATUS
 VirtioFsFuseStatFs (
   IN OUT VIRTIO_FS                      *VirtioFs,
   IN     UINT64                         NodeId,
      OUT VIRTIO_FS_FUSE_STATFS_RESPONSE *FilesysAttr
      );
 
 EFI_STATUS
diff --git a/OvmfPkg/VirtioFsDxe/FuseInit.c b/OvmfPkg/VirtioFsDxe/FuseInit.c
index 7aa6ee75caf6..431842804912 100644
--- a/OvmfPkg/VirtioFsDxe/FuseInit.c
+++ b/OvmfPkg/VirtioFsDxe/FuseInit.c
@@ -17,17 +17,20 @@
   session is started by sending a FUSE_INIT request as defined by the FUSE
   protocol on one request virtqueue."
 
   The function may only be called after VirtioFsInit() returns successfully and
   before VirtioFsUninit() is called.
 
   @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_INIT
                            request to. The FUSE request counter
-                           "VirtioFs->RequestId" is set to 1 on output.
+                           "VirtioFs->RequestId" is set to 1 on output. The
+                           maximum write buffer size exposed in the FUSE_INIT
+                           response is saved in "VirtioFs->MaxWrite", on
+                           output.
 
   @retval EFI_SUCCESS      The FUSE session has been started.
 
   @retval EFI_UNSUPPORTED  FUSE interface version or feature negotiation
                            failed.
 
   @return                  The "errno" value mapped to an EFI_STATUS code, if
                            the Virtio Filesystem device explicitly reported an
@@ -121,14 +124,19 @@ VirtioFsFuseInitSession (
     return Status;
   }
 
   //
   // Check FUSE interface version / feature compatibility.
   //
   if (InitResp.Major < InitReq.Major ||
       (InitResp.Major == InitReq.Major && InitResp.Minor < InitReq.Minor) ||
-      (InitResp.Flags & VIRTIO_FS_FUSE_INIT_REQ_F_DO_READDIRPLUS) == 0) {
+      (InitResp.Flags & VIRTIO_FS_FUSE_INIT_REQ_F_DO_READDIRPLUS) == 0 ||
+      InitResp.MaxWrite < SIZE_4KB) {
     return EFI_UNSUPPORTED;
   }
 
+  //
+  // Save the maximum write buffer size for FUSE_WRITE requests.
+  //
+  VirtioFs->MaxWrite = InitResp.MaxWrite;
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/FuseWrite.c b/OvmfPkg/VirtioFsDxe/FuseWrite.c
new file mode 100644
index 000000000000..cc552bd667ba
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseWrite.c
@@ -0,0 +1,155 @@
+/** @file
+  FUSE_WRITE wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Write a chunk to a regular file, by sending the FUSE_WRITE request to the
+  Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_WRITE
+                           request to. On output, the FUSE request counter
+                           "VirtioFs->RequestId" will have been incremented.
+
+  @param[in] NodeId        The inode number of the regular file to write to.
+
+  @param[in] FuseHandle    The open handle to the regular file to write to.
+
+  @param[in] Offset        The absolute file position at which to start
+                           writing.
+
+  @param[in,out] Size      On input, the number of bytes to write. On
+                           successful return, the number of bytes actually
+                           written, which may be smaller than the value on
+                           input.
+
+  @param[in] Data          The buffer to write to the regular file.
+
+  @retval EFI_SUCCESS          Write successful. The caller is responsible for
+                               checking Size to learn the actual byte count
+                               transferred.
+
+  @retval EFI_BAD_BUFFER_SIZE  On input, Size is larger than
+                               "VirtioFs->MaxWrite".
+
+  @return                      The "errno" value mapped to an EFI_STATUS code,
+                               if the Virtio Filesystem device explicitly
+                               reported an error.
+
+  @return                      Error codes propagated from
+                               VirtioFsSgListsValidate(),
+                               VirtioFsFuseNewRequest(),
+                               VirtioFsSgListsSubmit(),
+                               VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseWrite (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     UINT64    Offset,
+  IN OUT UINT32    *Size,
+  IN     VOID      *Data
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_WRITE_REQUEST  WriteReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[3];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_FUSE_WRITE_RESPONSE WriteResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Honor the write buffer size limit of the Virtio Filesystem device.
+  //
+  if (*Size > VirtioFs->MaxWrite) {
+    return EFI_BAD_BUFFER_SIZE;
+  }
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &WriteReq;
+  ReqIoVec[1].Size   = sizeof WriteReq;
+  ReqIoVec[2].Buffer = Data;
+  ReqIoVec[2].Size   = *Size;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &WriteResp;
+  RespIoVec[1].Size   = sizeof WriteResp;
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
+             VirtioFsFuseOpWrite, NodeId);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_WRITE-specific fields.
+  //
+  WriteReq.FileHandle = FuseHandle;
+  WriteReq.Offset     = Offset;
+  WriteReq.Size       = *Size;
+  WriteReq.WriteFlags = 0;
+  WriteReq.LockOwner  = 0;
+  WriteReq.Flags      = 0;
+  WriteReq.Padding    = 0;
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
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu FuseHandle=%Lu "
+        "Offset=0x%Lx Size=0x%x Data@%p Errno=%d\n", __FUNCTION__,
+        VirtioFs->Label, NodeId, FuseHandle, Offset, *Size, Data,
+        CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Report the actual transfer size.
+  //
+  *Size = WriteResp.Size;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



