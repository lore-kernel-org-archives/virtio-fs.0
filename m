From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:45 +0100
Message-Id: <20201216211125.19496-9-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 08/48] OvmfPkg/VirtioFsDxe: submit the
	FUSE_INIT request to the device
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

Submit the FUSE_INIT request to the Virtio Filesystem device, for starting
the FUSE session.

The FUSE_INIT request is logged by the virtio-fs daemon, with this patch
applied, when (for example) using the "CONNECT" UEFI shell command.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  31 +++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  13 +-
 OvmfPkg/VirtioFsDxe/DriverBinding.c         |   8 +-
 OvmfPkg/VirtioFsDxe/FuseInit.c              | 132 ++++++++++++++++++++
 OvmfPkg/VirtioFsDxe/Helpers.c               |   5 +-
 6 files changed, 182 insertions(+), 8 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 521288b03f1c..006e0f5debcb 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -71,16 +71,23 @@ typedef struct {
 // out at commit (c6ff213fe5b8^) = d78092e4937d ("fuse: fix page dereference
 // after free", 2020-09-18); that is, right before commit c6ff213fe5b8 ("fuse:
 // add submount support to <uapi/linux/fuse.h>", 2020-09-18) introduces FUSE
 // interface version 7.32.
 //
 #define VIRTIO_FS_FUSE_MAJOR  7
 #define VIRTIO_FS_FUSE_MINOR 31
 
+//
+// FUSE operation codes.
+//
+typedef enum {
+  VirtioFsFuseOpInit        = 26,
+} VIRTIO_FS_FUSE_OPCODE;
+
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
   UINT32 Opcode;
   UINT64 Unique;
@@ -91,11 +98,35 @@ typedef struct {
   UINT32 Padding;
 } VIRTIO_FS_FUSE_REQUEST;
 
 typedef struct {
   UINT32 Len;
   INT32  Error;
   UINT64 Unique;
 } VIRTIO_FS_FUSE_RESPONSE;
+
+//
+// Headers for VirtioFsFuseOpInit.
+//
+typedef struct {
+  UINT32 Major;
+  UINT32 Minor;
+  UINT32 MaxReadahead;
+  UINT32 Flags;
+} VIRTIO_FS_FUSE_INIT_REQUEST;
+
+typedef struct {
+  UINT32 Major;
+  UINT32 Minor;
+  UINT32 MaxReadahead;
+  UINT32 Flags;
+  UINT16 MaxBackground;
+  UINT16 CongestionThreshold;
+  UINT32 MaxWrite;
+  UINT32 TimeGran;
+  UINT16 MaxPages;
+  UINT16 MapAlignment;
+  UINT32 Unused[8];
+} VIRTIO_FS_FUSE_INIT_RESPONSE;
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index f6eebdb6bc7c..8fddc50318f1 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -77,16 +77,17 @@ [Defines]
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
+  FuseInit.c
   Helpers.c
   SimpleFsOpenVolume.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   DebugLib
   MemoryAllocationLib
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 772ab743cc8e..b8d464011843 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -39,17 +39,17 @@ typedef struct {
   //                              field         init function       init depth
   //                              -----------   ------------------  ----------
   UINT64                          Signature; // DriverBindingStart  0
   VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
   VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
   UINT16                          QueueSize; // VirtioFsInit        1
   VRING                           Ring;      // VirtioRingInit      2
   VOID                            *RingMap;  // VirtioRingMap       2
-  UINT64                          RequestId; // DriverBindingStart  0
+  UINT64                          RequestId; // FuseInitSession     1
   EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
 //
@@ -133,32 +133,41 @@ VirtioFsSgListsSubmit (
   IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
   );
 
 EFI_STATUS
 VirtioFsFuseNewRequest (
   IN OUT VIRTIO_FS              *VirtioFs,
      OUT VIRTIO_FS_FUSE_REQUEST *Request,
   IN     UINT32                 RequestSize,
-  IN     UINT32                 Opcode,
+  IN     VIRTIO_FS_FUSE_OPCODE  Opcode,
   IN     UINT64                 NodeId
   );
 
 EFI_STATUS
 VirtioFsFuseCheckResponse (
   IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
   IN  UINT64                        RequestId,
   OUT UINTN                         *TailBufferFill
   );
 
 EFI_STATUS
 VirtioFsErrnoToEfiStatus (
   IN INT32 Errno
   );
 
+//
+// Wrapper functions for FUSE commands (primitives).
+//
+
+EFI_STATUS
+VirtioFsFuseInitSession (
+  IN OUT VIRTIO_FS *VirtioFs
+  );
+
 //
 // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
 // driver.
 //
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/DriverBinding.c
index 4a2787a50a6e..4f77ffaa9953 100644
--- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -79,20 +79,20 @@ VirtioFsBindingStart (
     goto FreeVirtioFs;
   }
 
   Status = VirtioFsInit (VirtioFs);
   if (EFI_ERROR (Status)) {
     goto CloseVirtio;
   }
 
-  //
-  // Initialize the FUSE request counter.
-  //
-  VirtioFs->RequestId = 1;
+  Status = VirtioFsFuseInitSession (VirtioFs);
+  if (EFI_ERROR (Status)) {
+    goto UninitVirtioFs;
+  }
 
   Status = gBS->CreateEvent (EVT_SIGNAL_EXIT_BOOT_SERVICES, TPL_CALLBACK,
                   VirtioFsExitBoot, VirtioFs, &VirtioFs->ExitBoot);
   if (EFI_ERROR (Status)) {
     goto UninitVirtioFs;
   }
 
   VirtioFs->SimpleFs.Revision   = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVISION;
diff --git a/OvmfPkg/VirtioFsDxe/FuseInit.c b/OvmfPkg/VirtioFsDxe/FuseInit.c
new file mode 100644
index 000000000000..aa19dbdc05cb
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseInit.c
@@ -0,0 +1,132 @@
+/** @file
+  FUSE_INIT wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Send a FUSE_INIT request to the Virtio Filesystem device, for starting the
+  FUSE session.
+
+  From virtio-v1.1-cs01-87fa6b5d8155, 5.11.5 Device Initialization: "On
+  initialization the driver first discovers the device's virtqueues. The FUSE
+  session is started by sending a FUSE_INIT request as defined by the FUSE
+  protocol on one request virtqueue."
+
+  The function may only be called after VirtioFsInit() returns successfully and
+  before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_INIT
+                           request to. The FUSE request counter
+                           "VirtioFs->RequestId" is set to 1 on output.
+
+  @retval EFI_SUCCESS      The FUSE session has been started.
+
+  @retval EFI_UNSUPPORTED  FUSE interface version negotiation failed.
+
+  @return                  The "errno" value mapped to an EFI_STATUS code, if
+                           the Virtio Filesystem device explicitly reported an
+                           error.
+
+  @return                  Error codes propagated from
+                           VirtioFsSgListsValidate(), VirtioFsFuseNewRequest(),
+                           VirtioFsSgListsSubmit(),
+                           VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseInitSession (
+  IN OUT VIRTIO_FS *VirtioFs
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_INIT_REQUEST   InitReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_FUSE_INIT_RESPONSE  InitResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+
+  //
+  // Initialize the FUSE request counter.
+  //
+  VirtioFs->RequestId = 1;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &InitReq;
+  ReqIoVec[1].Size   = sizeof InitReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = &InitResp;
+  RespIoVec[1].Size   = sizeof InitResp;
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
+             VirtioFsFuseOpInit, 0);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_INIT-specific fields.
+  //
+  InitReq.Major        = VIRTIO_FS_FUSE_MAJOR;
+  InitReq.Minor        = VIRTIO_FS_FUSE_MINOR;
+  InitReq.MaxReadahead = 0;
+  InitReq.Flags        = 0;
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
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" Errno=%d\n", __FUNCTION__,
+        VirtioFs->Label, CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Check FUSE interface version compatibility.
+  //
+  if (InitResp.Major < InitReq.Major ||
+      (InitResp.Major == InitReq.Major && InitResp.Minor < InitReq.Minor)) {
+    return EFI_UNSUPPORTED;
+  }
+
+  return EFI_SUCCESS;
+}
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 334fa6c7dd26..00f762142746 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -716,33 +716,34 @@ VirtioFsSgListsSubmit (
 
   @param[in] RequestSize  The total size of the request, including
                           sizeof(VIRTIO_FS_FUSE_REQUEST).
 
   @param[in] Opcode       The VIRTIO_FS_FUSE_OPCODE that identifies the command
                           to send.
 
   @param[in] NodeId       The inode number of the file that the request refers
-                          to.
+                          to. When Opcode is VirtioFsFuseOpInit, NodeId is
+                          ignored by the Virtio Filesystem device.
 
   @retval EFI_INVALID_PARAMETER  RequestSize is smaller than
                                  sizeof(VIRTIO_FS_FUSE_REQUEST).
 
   @retval EFI_OUT_OF_RESOURCES   "VirtioFs->RequestId" is MAX_UINT64, and can
                                  be incremented no more.
 
   @retval EFI_SUCCESS            Request has been populated,
                                  "VirtioFs->RequestId" has been incremented.
 **/
 EFI_STATUS
 VirtioFsFuseNewRequest (
   IN OUT VIRTIO_FS              *VirtioFs,
      OUT VIRTIO_FS_FUSE_REQUEST *Request,
   IN     UINT32                 RequestSize,
-  IN     UINT32                 Opcode,
+  IN     VIRTIO_FS_FUSE_OPCODE  Opcode,
   IN     UINT64                 NodeId
   )
 {
   if (RequestSize < sizeof *Request) {
     return EFI_INVALID_PARAMETER;
   }
 
   if (VirtioFs->RequestId == MAX_UINT64) {
-- 
2.19.1.3.g30247aa5d201



