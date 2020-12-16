From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:43 +0100
Message-Id: <20201216211125.19496-7-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 06/48] OvmfPkg/VirtioFsDxe: introduce the
	basic FUSE request/response headers
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

Introduce the VIRTIO_FS_FUSE_REQUEST and VIRTIO_FS_FUSE_RESPONSE
structures, which are the common headers for the various FUSE
request/response structures.

Introduce the VirtioFsFuseNewRequest() helper function for populating
VIRTIO_FS_FUSE_REQUEST, from parameters and from a VIRTIO_FS-level request
counter.

Introduce the VirtioFsFuseCheckResponse() helper function for verifying
most FUSE response types that begin with the VIRTIO_FS_FUSE_RESPONSE
header.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  49 +++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  17 ++
 OvmfPkg/VirtioFsDxe/DriverBinding.c         |   5 +
 OvmfPkg/VirtioFsDxe/Helpers.c               | 216 ++++++++++++++++++++
 4 files changed, 287 insertions(+)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index ea7d80d15d0b..521288b03f1c 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -44,9 +44,58 @@ typedef struct {
   //
   // The total number of request virtqueues exposed by the device (i.e.,
   // excluding the "hiprio" queue).
   //
   UINT32 NumReqQueues;
 } VIRTIO_FS_CONFIG;
 #pragma pack ()
 
+//
+// FUSE-related definitions follow.
+//
+// From virtio-v1.1-cs01-87fa6b5d8155, 5.11 File System Device: "[...] The
+// driver acts as the FUSE client mounting the file system. The virtio file
+// system device provides the mechanism for transporting FUSE requests [...]"
+//
+// Unfortunately, the documentation of the FUSE wire protocol is lacking. The
+// Virtio spec (as of this writing) simply defers to
+// "include/uapi/linux/fuse.h" in the Linux kernel source -- see the reference
+// in virtio spec file "introduction.tex", at commit 87fa6b5d8155.
+//
+// Of course, "include/uapi/linux/fuse.h" is a moving target (the virtio spec
+// does not specify a particular FUSE interface version). The OvmfPkg code
+// targets version 7.31, because that's the lowest version that the QEMU
+// virtio-fs daemon supports at this time -- see QEMU commit 72c42e2d6551
+// ("virtiofsd: Trim out compatibility code", 2020-01-23).
+//
+// Correspondingly, Linux's "include/uapi/linux/fuse.h" is consulted as checked
+// out at commit (c6ff213fe5b8^) = d78092e4937d ("fuse: fix page dereference
+// after free", 2020-09-18); that is, right before commit c6ff213fe5b8 ("fuse:
+// add submount support to <uapi/linux/fuse.h>", 2020-09-18) introduces FUSE
+// interface version 7.32.
+//
+#define VIRTIO_FS_FUSE_MAJOR  7
+#define VIRTIO_FS_FUSE_MINOR 31
+
+#pragma pack (1)
+//
+// Request-response headers common to all request types.
+//
+typedef struct {
+  UINT32 Len;
+  UINT32 Opcode;
+  UINT64 Unique;
+  UINT64 NodeId;
+  UINT32 Uid;
+  UINT32 Gid;
+  UINT32 Pid;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_REQUEST;
+
+typedef struct {
+  UINT32 Len;
+  INT32  Error;
+  UINT64 Unique;
+} VIRTIO_FS_FUSE_RESPONSE;
+#pragma pack ()
+
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 12acbd6dc359..f7eae9a4b71a 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -39,16 +39,17 @@ typedef struct {
   //                              field         init function       init depth
   //                              -----------   ------------------  ----------
   UINT64                          Signature; // DriverBindingStart  0
   VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
   VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
   UINT16                          QueueSize; // VirtioFsInit        1
   VRING                           Ring;      // VirtioRingInit      2
   VOID                            *RingMap;  // VirtioRingMap       2
+  UINT64                          RequestId; // DriverBindingStart  0
   EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
 //
@@ -127,16 +128,32 @@ VirtioFsSgListsValidate (
 
 EFI_STATUS
 VirtioFsSgListsSubmit (
   IN OUT VIRTIO_FS                     *VirtioFs,
   IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
   IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
   );
 
+EFI_STATUS
+VirtioFsFuseNewRequest (
+  IN OUT VIRTIO_FS              *VirtioFs,
+     OUT VIRTIO_FS_FUSE_REQUEST *Request,
+  IN     UINT32                 RequestSize,
+  IN     UINT32                 Opcode,
+  IN     UINT64                 NodeId
+  );
+
+EFI_STATUS
+VirtioFsFuseCheckResponse (
+  IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
+  IN  UINT64                        RequestId,
+  OUT UINTN                         *TailBufferFill
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
index b888158a805d..4a2787a50a6e 100644
--- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -79,16 +79,21 @@ VirtioFsBindingStart (
     goto FreeVirtioFs;
   }
 
   Status = VirtioFsInit (VirtioFs);
   if (EFI_ERROR (Status)) {
     goto CloseVirtio;
   }
 
+  //
+  // Initialize the FUSE request counter.
+  //
+  VirtioFs->RequestId = 1;
+
   Status = gBS->CreateEvent (EVT_SIGNAL_EXIT_BOOT_SERVICES, TPL_CALLBACK,
                   VirtioFsExitBoot, VirtioFs, &VirtioFs->ExitBoot);
   if (EFI_ERROR (Status)) {
     goto UninitVirtioFs;
   }
 
   VirtioFs->SimpleFs.Revision   = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVISION;
   VirtioFs->SimpleFs.OpenVolume = VirtioFsOpenVolume;
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 88264d4b264c..5bd2dc641f6d 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -693,8 +693,224 @@ VirtioFsSgListsSubmit (
       if (!EFI_ERROR (Status) && EFI_ERROR (UnmapStatus)) {
         Status = UnmapStatus;
       }
     }
   }
 
   return Status;
 }
+
+/**
+  Set up the fields of a new VIRTIO_FS_FUSE_REQUEST object.
+
+  The function may only be called after VirtioFsInit() returns successfully and
+  before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs The Virtio Filesystem device that the request is
+                          being prepared for. The "VirtioFs->RequestId" field
+                          will be copied into "Request->Unique". On output (on
+                          successful return), "VirtioFs->RequestId" will be
+                          incremented.
+
+  @param[out] Request     The VIRTIO_FS_FUSE_REQUEST object whose fields are to
+                          be set.
+
+  @param[in] RequestSize  The total size of the request, including
+                          sizeof(VIRTIO_FS_FUSE_REQUEST).
+
+  @param[in] Opcode       The VIRTIO_FS_FUSE_OPCODE that identifies the command
+                          to send.
+
+  @param[in] NodeId       The inode number of the file that the request refers
+                          to.
+
+  @retval EFI_INVALID_PARAMETER  RequestSize is smaller than
+                                 sizeof(VIRTIO_FS_FUSE_REQUEST).
+
+  @retval EFI_OUT_OF_RESOURCES   "VirtioFs->RequestId" is MAX_UINT64, and can
+                                 be incremented no more.
+
+  @retval EFI_SUCCESS            Request has been populated,
+                                 "VirtioFs->RequestId" has been incremented.
+**/
+EFI_STATUS
+VirtioFsFuseNewRequest (
+  IN OUT VIRTIO_FS              *VirtioFs,
+     OUT VIRTIO_FS_FUSE_REQUEST *Request,
+  IN     UINT32                 RequestSize,
+  IN     UINT32                 Opcode,
+  IN     UINT64                 NodeId
+  )
+{
+  if (RequestSize < sizeof *Request) {
+    return EFI_INVALID_PARAMETER;
+  }
+
+  if (VirtioFs->RequestId == MAX_UINT64) {
+    return EFI_OUT_OF_RESOURCES;
+  }
+
+  Request->Len     = RequestSize;
+  Request->Opcode  = Opcode;
+  Request->Unique  = VirtioFs->RequestId++;
+  Request->NodeId  = NodeId;
+  Request->Uid     = 0;
+  Request->Gid     = 0;
+  Request->Pid     = 1;
+  Request->Padding = 0;
+
+  return EFI_SUCCESS;
+}
+
+/**
+  Check the common FUSE response format.
+
+  The first buffer in the response scatter-gather list is assumed a
+  VIRTIO_FS_FUSE_RESPONSE structure. Subsequent response buffers, if any, up to
+  and excluding the last one, are assumed fixed size. The last response buffer
+  may or may not be fixed size, as specified by the caller.
+
+  This function may only be called after VirtioFsSgListsSubmit() returns
+  successfully.
+
+  @param[in] ResponseSgList   The scatter-gather list that describes the
+                              response part of the exchange -- the buffers that
+                              the Virtio Filesystem device filled in during the
+                              virtio transfer.
+
+  @param[in] RequestId        The request identifier to which the response is
+                              expected to belong.
+
+  @param[out] TailBufferFill  If NULL, then the last buffer in ResponseSgList
+                              is considered fixed size. Otherwise, the last
+                              buffer is considered variable size, and on
+                              successful return, TailBufferFill reports the
+                              number of bytes in the last buffer.
+
+  @retval EFI_INVALID_PARAMETER  TailBufferFill is not NULL (i.e., the last
+                                 buffer is considered variable size), and
+                                 ResponseSgList->NumVec is 1.
+
+  @retval EFI_INVALID_PARAMETER  The allocated size of the first buffer does
+                                 not match sizeof(VIRTIO_FS_FUSE_RESPONSE).
+
+  @retval EFI_PROTOCOL_ERROR     The VIRTIO_FS_FUSE_RESPONSE structure in the
+                                 first buffer has not been fully populated.
+
+  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Len" in the first
+                                 buffer does not equal the sum of the
+                                 individual buffer sizes (as populated).
+
+  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Unique" in the first
+                                 buffer does not equal RequestId.
+
+  @retval EFI_PROTOCOL_ERROR     "VIRTIO_FS_FUSE_RESPONSE.Error" in the first
+                                 buffer is zero, but a subsequent fixed size
+                                 buffer has not been fully populated.
+
+  @retval EFI_DEVICE_ERROR       "VIRTIO_FS_FUSE_RESPONSE.Error" in the first
+                                 buffer is nonzero. The caller may investigate
+                                 "VIRTIO_FS_FUSE_RESPONSE.Error". Note that the
+                                 completeness of the subsequent fixed size
+                                 buffers is not verified in this case.
+
+  @retval EFI_SUCCESS            Verification successful.
+**/
+EFI_STATUS
+VirtioFsFuseCheckResponse (
+  IN  VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList,
+  IN  UINT64                        RequestId,
+  OUT UINTN                         *TailBufferFill
+  )
+{
+  UINTN                   NumFixedSizeVec;
+  VIRTIO_FS_FUSE_RESPONSE *CommonResp;
+  UINT32                  TotalTransferred;
+  UINTN                   Idx;
+
+  //
+  // Ensured by VirtioFsSgListsValidate().
+  //
+  ASSERT (ResponseSgList->NumVec > 0);
+
+  if (TailBufferFill == NULL) {
+    //
+    // All buffers are considered fixed size.
+    //
+    NumFixedSizeVec = ResponseSgList->NumVec;
+  } else {
+    //
+    // If the last buffer is variable size, then we need that buffer to be
+    // different from the first buffer, which is considered a
+    // VIRTIO_FS_FUSE_RESPONSE (fixed size) structure.
+    //
+    if (ResponseSgList->NumVec == 1) {
+      return EFI_INVALID_PARAMETER;
+    }
+    NumFixedSizeVec = ResponseSgList->NumVec - 1;
+  }
+
+  //
+  // The first buffer is supposed to carry a (fully populated)
+  // VIRTIO_FS_FUSE_RESPONSE structure.
+  //
+  if (ResponseSgList->IoVec[0].Size != sizeof *CommonResp) {
+    return EFI_INVALID_PARAMETER;
+  }
+  if (ResponseSgList->IoVec[0].Transferred != ResponseSgList->IoVec[0].Size) {
+    return EFI_PROTOCOL_ERROR;
+  }
+
+  //
+  // FUSE must report the same number of bytes, written by the Virtio
+  // Filesystem device, as the virtio transport does.
+  //
+  CommonResp = ResponseSgList->IoVec[0].Buffer;
+  TotalTransferred = 0;
+  for (Idx = 0; Idx < ResponseSgList->NumVec; Idx++) {
+    //
+    // Integer overflow and truncation are not possible, based on
+    // VirtioFsSgListsValidate() and VirtioFsSgListsSubmit().
+    //
+    TotalTransferred += (UINT32)ResponseSgList->IoVec[Idx].Transferred;
+  }
+  if (CommonResp->Len != TotalTransferred) {
+    return EFI_PROTOCOL_ERROR;
+  }
+
+  //
+  // Enforce that FUSE match our request ID in the response.
+  //
+  if (CommonResp->Unique != RequestId) {
+    return EFI_PROTOCOL_ERROR;
+  }
+
+  //
+  // If there is an explicit error report, skip checking the transfer
+  // counts for the rest of the fixed size buffers.
+  //
+  if (CommonResp->Error != 0) {
+    return EFI_DEVICE_ERROR;
+  }
+
+  //
+  // There was no error reported, so we require that the Virtio Filesystem
+  // device populate all fixed size buffers. We checked this for the very first
+  // buffer above; let's check the rest (if any).
+  //
+  ASSERT (NumFixedSizeVec >= 1);
+  for (Idx = 1; Idx < NumFixedSizeVec; Idx++) {
+    if (ResponseSgList->IoVec[Idx].Transferred !=
+        ResponseSgList->IoVec[Idx].Size) {
+      return EFI_PROTOCOL_ERROR;
+    }
+  }
+
+  //
+  // If the last buffer is considered variable size, report its filled size.
+  //
+  if (TailBufferFill != NULL) {
+    *TailBufferFill = ResponseSgList->IoVec[NumFixedSizeVec].Transferred;
+  }
+
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



