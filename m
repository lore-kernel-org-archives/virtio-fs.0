From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:42 +0100
Message-Id: <20201216211125.19496-6-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 05/48] OvmfPkg/VirtioFsDxe: add a
	scatter-gather list data type
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

In preparation for the variously structured FUSE request/response
exchanges that virtio-fs uses, introduce a scatter-gather list data type.
This will let us express FUSE request-response pairs flexibly.

Add a function for validating whether a (request buffer list, response
buffer list) pair is well-formed, and supported by the Virtio Filesystem
device's queue depth.

Add another function for mapping and submitting a validated pair of
scatter-gather lists to the Virtio Filesystem device.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |  60 +++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 401 ++++++++++++++++++++
 2 files changed, 461 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 2aae96ecd79a..12acbd6dc359 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -46,16 +46,62 @@ typedef struct {
   VOID                            *RingMap;  // VirtioRingMap       2
   EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
+//
+// Structure for describing a contiguous buffer, potentially mapped for Virtio
+// transfer.
+//
+typedef struct {
+  //
+  // The following fields originate from the owner of the buffer.
+  //
+  VOID  *Buffer;
+  UINTN Size;
+  //
+  // All of the fields below, until the end of the structure, are
+  // zero-initialized when the structure is initially validated.
+  //
+  // Mapped, MappedAddress and Mapping are updated when the buffer is mapped
+  // for VirtioOperationBusMasterRead or VirtioOperationBusMasterWrite. They
+  // are again updated when the buffer is unmapped.
+  //
+  BOOLEAN              Mapped;
+  EFI_PHYSICAL_ADDRESS MappedAddress;
+  VOID                 *Mapping;
+  //
+  // Transferred is updated after VirtioFlush() returns successfully:
+  // - for VirtioOperationBusMasterRead, Transferred is set to Size;
+  // - for VirtioOperationBusMasterWrite, Transferred is calculated from the
+  //   UsedLen output parameter of VirtioFlush().
+  //
+  UINTN Transferred;
+} VIRTIO_FS_IO_VECTOR;
+
+//
+// Structure for describing a list of IO Vectors.
+//
+typedef struct {
+  //
+  // The following fields originate from the owner of the buffers.
+  //
+  VIRTIO_FS_IO_VECTOR *IoVec;
+  UINTN               NumVec;
+  //
+  // TotalSize is calculated when the scatter-gather list is initially
+  // validated.
+  //
+  UINT32 TotalSize;
+} VIRTIO_FS_SCATTER_GATHER_LIST;
+
 //
 // Initialization and helper routines for the Virtio Filesystem device.
 //
 
 EFI_STATUS
 VirtioFsInit (
   IN OUT VIRTIO_FS *VirtioFs
   );
@@ -67,16 +113,30 @@ VirtioFsUninit (
 
 VOID
 EFIAPI
 VirtioFsExitBoot (
   IN EFI_EVENT ExitBootEvent,
   IN VOID      *VirtioFsAsVoid
   );
 
+EFI_STATUS
+VirtioFsSgListsValidate (
+  IN     VIRTIO_FS                     *VirtioFs,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
+  );
+
+EFI_STATUS
+VirtioFsSgListsSubmit (
+  IN OUT VIRTIO_FS                     *VirtioFs,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
+  );
+
 //
 // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
 // driver.
 //
 
 EFI_STATUS
 EFIAPI
 VirtioFsOpenVolume (
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 7b4906c54184..88264d4b264c 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -292,8 +292,409 @@ VirtioFsExitBoot (
 {
   VIRTIO_FS *VirtioFs;
 
   VirtioFs = VirtioFsAsVoid;
   DEBUG ((DEBUG_VERBOSE, "%a: VirtioFs=0x%p Label=\"%s\"\n", __FUNCTION__,
     VirtioFsAsVoid, VirtioFs->Label));
   VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, 0);
 }
+
+/**
+  Validate two VIRTIO_FS_SCATTER_GATHER_LIST objects -- list of request
+  buffers, list of response buffers -- together.
+
+  On input, the caller is required to populate the following fields:
+  - VIRTIO_FS_IO_VECTOR.Buffer,
+  - VIRTIO_FS_IO_VECTOR.Size,
+  - VIRTIO_FS_SCATTER_GATHER_LIST.IoVec,
+  - VIRTIO_FS_SCATTER_GATHER_LIST.NumVec.
+
+  On output (on successful return), the following fields will be
+  zero-initialized:
+  - VIRTIO_FS_IO_VECTOR.Mapped,
+  - VIRTIO_FS_IO_VECTOR.MappedAddress,
+  - VIRTIO_FS_IO_VECTOR.Mapping,
+  - VIRTIO_FS_IO_VECTOR.Transferred.
+
+  On output (on successful return), the following fields will be calculated:
+  - VIRTIO_FS_SCATTER_GATHER_LIST.TotalSize.
+
+  The function may only be called after VirtioFsInit() returns successfully and
+  before VirtioFsUninit() is called.
+
+  @param[in] VirtioFs            The Virtio Filesystem device that the
+                                 request-response exchange, expressed via
+                                 RequestSgList and ResponseSgList, will be
+                                 submitted to.
+
+  @param[in,out] RequestSgList   The scatter-gather list that describes the
+                                 request part of the exchange -- the buffers
+                                 that should be sent to the Virtio Filesystem
+                                 device in the virtio transfer.
+
+  @param[in,out] ResponseSgList  The scatter-gather list that describes the
+                                 response part of the exchange -- the buffers
+                                 that the Virtio Filesystem device should
+                                 populate in the virtio transfer. May be NULL
+                                 if the exchange with the Virtio Filesystem
+                                 device consists of a request only, with the
+                                 response part omitted altogether.
+
+  @retval EFI_SUCCESS            RequestSgList and ResponseSgList have been
+                                 validated, output fields have been set.
+
+  @retval EFI_INVALID_PARAMETER  RequestSgList is NULL.
+
+  @retval EFI_INVALID_PARAMETER  On input, a
+                                 VIRTIO_FS_SCATTER_GATHER_LIST.IoVec field is
+                                 NULL, or a
+                                 VIRTIO_FS_SCATTER_GATHER_LIST.NumVec field is
+                                 zero.
+
+  @retval EFI_INVALID_PARAMETER  On input, a VIRTIO_FS_IO_VECTOR.Buffer field
+                                 is NULL, or a VIRTIO_FS_IO_VECTOR.Size field
+                                 is zero.
+
+  @retval EFI_UNSUPPORTED        (RequestSgList->NumVec +
+                                 ResponseSgList->NumVec) exceeds
+                                 VirtioFs->QueueSize, meaning that the total
+                                 list of buffers cannot be placed on the virtio
+                                 queue in a single descriptor chain (with one
+                                 descriptor per buffer).
+
+  @retval EFI_UNSUPPORTED        One of the
+                                 VIRTIO_FS_SCATTER_GATHER_LIST.TotalSize fields
+                                 would exceed MAX_UINT32.
+**/
+EFI_STATUS
+VirtioFsSgListsValidate (
+  IN     VIRTIO_FS                     *VirtioFs,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
+  )
+{
+  VIRTIO_FS_SCATTER_GATHER_LIST *SgListParam[2];
+  UINT16                        DescriptorsNeeded;
+  UINTN                         ListId;
+
+  if (RequestSgList == NULL) {
+    return EFI_INVALID_PARAMETER;
+  }
+
+  SgListParam[0] = RequestSgList;
+  SgListParam[1] = ResponseSgList;
+
+  DescriptorsNeeded = 0;
+  for (ListId = 0; ListId < ARRAY_SIZE (SgListParam); ListId++) {
+    VIRTIO_FS_SCATTER_GATHER_LIST *SgList;
+    UINT32                        SgListTotalSize;
+    UINTN                         IoVecIdx;
+
+    SgList = SgListParam[ListId];
+    if (SgList == NULL) {
+      continue;
+    }
+    //
+    // Sanity-check SgList -- it must provide at least one IO Vector.
+    //
+    if (SgList->IoVec == NULL || SgList->NumVec == 0) {
+      return EFI_INVALID_PARAMETER;
+    }
+    //
+    // Make sure that, for each IO Vector in this SgList, a virtio descriptor
+    // can be added to the virtio queue, after the other descriptors added
+    // previously.
+    //
+    if (SgList->NumVec > MAX_UINT16 - DescriptorsNeeded ||
+        DescriptorsNeeded + SgList->NumVec > VirtioFs->QueueSize) {
+      return EFI_UNSUPPORTED;
+    }
+    DescriptorsNeeded += (UINT16)SgList->NumVec;
+
+    SgListTotalSize = 0;
+    for (IoVecIdx = 0; IoVecIdx < SgList->NumVec; IoVecIdx++) {
+      VIRTIO_FS_IO_VECTOR *IoVec;
+
+      IoVec = &SgList->IoVec[IoVecIdx];
+      //
+      // Sanity-check this IoVec -- it must describe a non-empty buffer.
+      //
+      if (IoVec->Buffer == NULL || IoVec->Size == 0) {
+        return EFI_INVALID_PARAMETER;
+      }
+      //
+      // Make sure the cumulative size of all IO Vectors in this SgList remains
+      // expressible as a UINT32.
+      //
+      if (IoVec->Size > MAX_UINT32 - SgListTotalSize) {
+        return EFI_UNSUPPORTED;
+      }
+      SgListTotalSize += (UINT32)IoVec->Size;
+
+      //
+      // Initialize those fields in this IO Vector that will be updated in
+      // relation to mapping / transfer.
+      //
+      IoVec->Mapped        = FALSE;
+      IoVec->MappedAddress = 0;
+      IoVec->Mapping       = NULL;
+      IoVec->Transferred   = 0;
+    }
+
+    //
+    // Store the cumulative size of all IO Vectors that we have calculated in
+    // this SgList.
+    //
+    SgList->TotalSize = SgListTotalSize;
+  }
+
+  return EFI_SUCCESS;
+}
+
+/**
+  Submit a validated pair of (request buffer list, response buffer list) to the
+  Virtio Filesystem device.
+
+  On input, the pair of VIRTIO_FS_SCATTER_GATHER_LIST objects must have been
+  validated together, using the VirtioFsSgListsValidate() function.
+
+  On output (on successful return), the following fields will be re-initialized
+  to zero (after temporarily setting them to different values):
+  - VIRTIO_FS_IO_VECTOR.Mapped,
+  - VIRTIO_FS_IO_VECTOR.MappedAddress,
+  - VIRTIO_FS_IO_VECTOR.Mapping.
+
+  On output (on successful return), the following fields will be calculated:
+  - VIRTIO_FS_IO_VECTOR.Transferred.
+
+  The function may only be called after VirtioFsInit() returns successfully and
+  before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs        The Virtio Filesystem device that the
+                                 request-response exchange, expressed via
+                                 RequestSgList and ResponseSgList, should now
+                                 be submitted to.
+
+  @param[in,out] RequestSgList   The scatter-gather list that describes the
+                                 request part of the exchange -- the buffers
+                                 that should be sent to the Virtio Filesystem
+                                 device in the virtio transfer.
+
+  @param[in,out] ResponseSgList  The scatter-gather list that describes the
+                                 response part of the exchange -- the buffers
+                                 that the Virtio Filesystem device should
+                                 populate in the virtio transfer. May be NULL
+                                 if and only if NULL was passed to
+                                 VirtioFsSgListsValidate() as ResponseSgList.
+
+  @retval EFI_SUCCESS       Transfer complete. The caller should investigate
+                            the VIRTIO_FS_IO_VECTOR.Transferred fields in
+                            ResponseSgList, to ensure coverage of the relevant
+                            response buffers. Subsequently, the caller should
+                            investigate the contents of those buffers.
+
+  @retval EFI_DEVICE_ERROR  The Virtio Filesystem device reported populating
+                            more response bytes than ResponseSgList->TotalSize.
+
+  @return                   Error codes propagated from
+                            VirtioMapAllBytesInSharedBuffer(), VirtioFlush(),
+                            or VirtioFs->Virtio->UnmapSharedBuffer().
+**/
+EFI_STATUS
+VirtioFsSgListsSubmit (
+  IN OUT VIRTIO_FS                     *VirtioFs,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *RequestSgList,
+  IN OUT VIRTIO_FS_SCATTER_GATHER_LIST *ResponseSgList OPTIONAL
+  )
+{
+  VIRTIO_FS_SCATTER_GATHER_LIST *SgListParam[2];
+  VIRTIO_MAP_OPERATION          SgListVirtioMapOp[ARRAY_SIZE (SgListParam)];
+  UINT16                        SgListDescriptorFlag[ARRAY_SIZE (SgListParam)];
+  UINTN                         ListId;
+  VIRTIO_FS_SCATTER_GATHER_LIST *SgList;
+  UINTN                         IoVecIdx;
+  VIRTIO_FS_IO_VECTOR           *IoVec;
+  EFI_STATUS                    Status;
+  DESC_INDICES                  Indices;
+  UINT32                        TotalBytesWrittenByDevice;
+  UINT32                        BytesPermittedForWrite;
+
+  SgListParam[0]          = RequestSgList;
+  SgListVirtioMapOp[0]    = VirtioOperationBusMasterRead;
+  SgListDescriptorFlag[0] = 0;
+
+  SgListParam[1]          = ResponseSgList;
+  SgListVirtioMapOp[1]    = VirtioOperationBusMasterWrite;
+  SgListDescriptorFlag[1] = VRING_DESC_F_WRITE;
+
+  //
+  // Map all IO Vectors.
+  //
+  for (ListId = 0; ListId < ARRAY_SIZE (SgListParam); ListId++) {
+    SgList = SgListParam[ListId];
+    if (SgList == NULL) {
+      continue;
+    }
+    for (IoVecIdx = 0; IoVecIdx < SgList->NumVec; IoVecIdx++) {
+      IoVec = &SgList->IoVec[IoVecIdx];
+      //
+      // Map this IO Vector.
+      //
+      Status = VirtioMapAllBytesInSharedBuffer (
+                 VirtioFs->Virtio,
+                 SgListVirtioMapOp[ListId],
+                 IoVec->Buffer,
+                 IoVec->Size,
+                 &IoVec->MappedAddress,
+                 &IoVec->Mapping
+                 );
+      if (EFI_ERROR (Status)) {
+        goto Unmap;
+      }
+      IoVec->Mapped = TRUE;
+    }
+  }
+
+  //
+  // Compose the descriptor chain.
+  //
+  VirtioPrepare (&VirtioFs->Ring, &Indices);
+  for (ListId = 0; ListId < ARRAY_SIZE (SgListParam); ListId++) {
+    SgList = SgListParam[ListId];
+    if (SgList == NULL) {
+      continue;
+    }
+    for (IoVecIdx = 0; IoVecIdx < SgList->NumVec; IoVecIdx++) {
+      UINT16 NextFlag;
+
+      IoVec = &SgList->IoVec[IoVecIdx];
+      //
+      // Set VRING_DESC_F_NEXT on all except the very last descriptor.
+      //
+      NextFlag = VRING_DESC_F_NEXT;
+      if (ListId == ARRAY_SIZE (SgListParam) - 1 &&
+          IoVecIdx == SgList->NumVec - 1) {
+        NextFlag = 0;
+      }
+      VirtioAppendDesc (
+        &VirtioFs->Ring,
+        IoVec->MappedAddress,
+        (UINT32)IoVec->Size,
+        SgListDescriptorFlag[ListId] | NextFlag,
+        &Indices
+        );
+    }
+  }
+
+  //
+  // Submit the descriptor chain.
+  //
+  Status = VirtioFlush (VirtioFs->Virtio, VIRTIO_FS_REQUEST_QUEUE,
+             &VirtioFs->Ring, &Indices, &TotalBytesWrittenByDevice);
+  if (EFI_ERROR (Status)) {
+    goto Unmap;
+  }
+
+  //
+  // Sanity-check: the Virtio Filesystem device should not have written more
+  // bytes than what we offered buffers for.
+  //
+  if (ResponseSgList == NULL) {
+    BytesPermittedForWrite = 0;
+  } else {
+    BytesPermittedForWrite = ResponseSgList->TotalSize;
+  }
+  if (TotalBytesWrittenByDevice > BytesPermittedForWrite) {
+    Status = EFI_DEVICE_ERROR;
+    goto Unmap;
+  }
+
+  //
+  // Update the transfer sizes in the IO Vectors.
+  //
+  for (ListId = 0; ListId < ARRAY_SIZE (SgListParam); ListId++) {
+    SgList = SgListParam[ListId];
+    if (SgList == NULL) {
+      continue;
+    }
+    for (IoVecIdx = 0; IoVecIdx < SgList->NumVec; IoVecIdx++) {
+      IoVec = &SgList->IoVec[IoVecIdx];
+      if (SgListVirtioMapOp[ListId] == VirtioOperationBusMasterRead) {
+        //
+        // We report that the Virtio Filesystem device has read all buffers in
+        // the request.
+        //
+        IoVec->Transferred = IoVec->Size;
+      } else {
+        //
+        // Regarding the response, calculate how much of the current IO Vector
+        // has been populated by the Virtio Filesystem device. In
+        // "TotalBytesWrittenByDevice", VirtioFlush() reported the total count
+        // across all device-writeable descriptors, in the order they were
+        // chained on the ring.
+        //
+        IoVec->Transferred = MIN ((UINTN)TotalBytesWrittenByDevice,
+                               IoVec->Size);
+        TotalBytesWrittenByDevice -= (UINT32)IoVec->Transferred;
+      }
+    }
+  }
+
+  //
+  // By now, "TotalBytesWrittenByDevice" has been exhausted.
+  //
+  ASSERT (TotalBytesWrittenByDevice == 0);
+
+  //
+  // We've succeeded; fall through.
+  //
+Unmap:
+  //
+  // Unmap all mapped IO Vectors on both the success and the error paths. The
+  // unmapping occurs in reverse order of mapping, in an attempt to avoid
+  // memory fragmentation.
+  //
+  ListId = ARRAY_SIZE (SgListParam);
+  while (ListId > 0) {
+    --ListId;
+    SgList = SgListParam[ListId];
+    if (SgList == NULL) {
+      continue;
+    }
+    IoVecIdx = SgList->NumVec;
+    while (IoVecIdx > 0) {
+      EFI_STATUS UnmapStatus;
+
+      --IoVecIdx;
+      IoVec = &SgList->IoVec[IoVecIdx];
+      //
+      // Unmap this IO Vector, if it has been mapped.
+      //
+      if (!IoVec->Mapped) {
+        continue;
+      }
+      UnmapStatus = VirtioFs->Virtio->UnmapSharedBuffer (VirtioFs->Virtio,
+                                        IoVec->Mapping);
+      //
+      // Re-set the following fields to the values they initially got from
+      // VirtioFsSgListsValidate() -- the above unmapping attempt is considered
+      // final, even if it fails.
+      //
+      IoVec->Mapped        = FALSE;
+      IoVec->MappedAddress = 0;
+      IoVec->Mapping       = NULL;
+
+      //
+      // If we are on the success path, but the unmapping failed, we need to
+      // transparently flip to the failure path -- the caller must learn they
+      // should not consult the response buffers.
+      //
+      // The branch below can be taken at most once.
+      //
+      if (!EFI_ERROR (Status) && EFI_ERROR (UnmapStatus)) {
+        Status = UnmapStatus;
+      }
+    }
+  }
+
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



