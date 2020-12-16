From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:09 +0100
Message-Id: <20201216211125.19496-33-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 32/48] OvmfPkg/VirtioFsDxe: add a shared
	wrapper for FUSE_READ / FUSE_READDIRPLUS
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

Add the VirtioFsFuseReadFileOrDir() function, for sending the FUSE_READ or
FUSE_READDIRPLUS command to the Virtio Filesystem device.

Parsing the structured FUSE_READDIRPLUS output is complex, and cannot be
integrated into the wrapper function. Given that fact, FUSE_READ and
FUSE_READDIRPLUS turn out to need identical low-level handling, except for
the opcode. Hence the shared wrapper function.

(It's prudent to verify whether the FUSE server supports FUSE_READDIRPLUS,
so update the session init code accordingly.)

This is the first FUSE request wrapper function that deals with a variable
size tail buffer.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  67 +++++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  11 ++
 OvmfPkg/VirtioFsDxe/FuseInit.c              |  10 +-
 OvmfPkg/VirtioFsDxe/FuseRead.c              | 191 ++++++++++++++++++++
 5 files changed, 276 insertions(+), 4 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
index 800d3651e12b..fa8c40019f4e 100644
--- a/OvmfPkg/Include/IndustryStandard/VirtioFs.h
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -103,36 +103,71 @@ typedef struct {
 #define VIRTIO_FS_FUSE_MODE_PERM_WOTH 0000002u
 
 //
 // Flags for VirtioFsFuseOpOpen.
 //
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDONLY 0
 #define VIRTIO_FS_FUSE_OPEN_REQ_F_RDWR   2
 
+//
+// Flags for VirtioFsFuseOpInit.
+//
+#define VIRTIO_FS_FUSE_INIT_REQ_F_DO_READDIRPLUS BIT13
+
+/**
+  Macro for calculating the size of a directory stream entry.
+
+  The macro may evaluate Namelen multiple times.
+
+  The macro evaluates to a UINTN value that is safe to cast to UINT32.
+
+  @param[in] Namelen  The size of the filename byte array that follows
+                      VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE in the directory
+                      stream, as reported by
+                      VIRTIO_FS_FUSE_STATFS_RESPONSE.Namelen or
+                      VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE.Namelen. The filename
+                      byte array is not NUL-terminated.
+
+  @retval 0  Namelen was zero or greater than SIZE_4KB.
+
+  @return    The number of bytes in the directory entry, including the
+             VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE header.
+**/
+#define VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE_SIZE(Namelen)             \
+  ((Namelen) == 0 || (Namelen) > SIZE_4KB ?                          \
+   (UINTN)0 :                                                        \
+   ALIGN_VALUE (                                                     \
+     sizeof (VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE) + (UINTN)(Namelen), \
+     sizeof (UINT64)                                                 \
+     )                                                               \
+   )
+
 //
 // FUSE operation codes.
 //
 typedef enum {
   VirtioFsFuseOpLookup      =  1,
   VirtioFsFuseOpForget      =  2,
   VirtioFsFuseOpGetAttr     =  3,
   VirtioFsFuseOpMkDir       =  9,
   VirtioFsFuseOpUnlink      = 10,
   VirtioFsFuseOpRmDir       = 11,
   VirtioFsFuseOpOpen        = 14,
+  VirtioFsFuseOpRead        = 15,
   VirtioFsFuseOpStatFs      = 17,
   VirtioFsFuseOpRelease     = 18,
   VirtioFsFuseOpFsync       = 20,
   VirtioFsFuseOpFlush       = 25,
   VirtioFsFuseOpInit        = 26,
   VirtioFsFuseOpOpenDir     = 27,
   VirtioFsFuseOpReleaseDir  = 29,
   VirtioFsFuseOpFsyncDir    = 30,
   VirtioFsFuseOpCreate      = 35,
+  VirtioFsFuseOpReadDirPlus = 44,
 } VIRTIO_FS_FUSE_OPCODE;
 
 #pragma pack (1)
 //
 // Request-response headers common to all request types.
 //
 typedef struct {
   UINT32 Len;
@@ -229,16 +264,29 @@ typedef struct {
 } VIRTIO_FS_FUSE_OPEN_REQUEST;
 
 typedef struct {
   UINT64 FileHandle;
   UINT32 OpenFlags;
   UINT32 Padding;
 } VIRTIO_FS_FUSE_OPEN_RESPONSE;
 
+//
+// Header for VirtioFsFuseOpRead and VirtioFsFuseOpReadDirPlus.
+//
+typedef struct {
+  UINT64 FileHandle;
+  UINT64 Offset;
+  UINT32 Size;
+  UINT32 ReadFlags;
+  UINT64 LockOwner;
+  UINT32 Flags;
+  UINT32 Padding;
+} VIRTIO_FS_FUSE_READ_REQUEST;
+
 //
 // Header for VirtioFsFuseOpStatFs.
 //
 typedef struct {
   UINT64 Blocks;
   UINT64 Bfree;
   UINT64 Bavail;
   UINT64 Files;
@@ -307,11 +355,30 @@ typedef struct {
 // Header for VirtioFsFuseOpCreate.
 //
 typedef struct {
   UINT32 Flags;
   UINT32 Mode;
   UINT32 Umask;
   UINT32 Padding;
 } VIRTIO_FS_FUSE_CREATE_REQUEST;
+
+//
+// Header for VirtioFsFuseOpReadDirPlus.
+//
+// Diverging from the rest of the headers, this structure embeds other
+// structures. The reason is that a scatter list cannot be used to receive
+// NodeResp and AttrResp separately; the record below is followed by a variable
+// size filename byte array, and then such pairs are repeated a number of
+// times. Thus, later header start offsets depend on earlier filename array
+// sizes.
+//
+typedef struct {
+  VIRTIO_FS_FUSE_NODE_RESPONSE       NodeResp;
+  VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE AttrResp;
+  UINT64                             NodeId;
+  UINT64                             CookieForNextEntry;
+  UINT32                             Namelen;
+  UINT32                             Type;
+} VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE;
 #pragma pack ()
 
 #endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 3cb5c101c3a6..39c77c7c4ee9 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -88,16 +88,17 @@ [Sources]
   FuseFsync.c
   FuseGetAttr.c
   FuseInit.c
   FuseLookup.c
   FuseMkDir.c
   FuseOpen.c
   FuseOpenDir.c
   FuseOpenOrCreate.c
+  FuseRead.c
   FuseRelease.c
   FuseStatFs.c
   FuseUnlink.c
   Helpers.c
   SimpleFsClose.c
   SimpleFsDelete.c
   SimpleFsFlush.c
   SimpleFsGetInfo.c
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 948fcfb6b6f3..f5501af7d0a4 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -293,16 +293,27 @@ VirtioFsFuseRemoveFileOrDir (
 EFI_STATUS
 VirtioFsFuseOpen (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId,
   IN     BOOLEAN   ReadWrite,
      OUT UINT64    *FuseHandle
   );
 
+EFI_STATUS
+VirtioFsFuseReadFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     BOOLEAN   IsDir,
+  IN     UINT64    Offset,
+  IN OUT UINT32    *Size,
+     OUT VOID      *Data
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
index aa19dbdc05cb..7aa6ee75caf6 100644
--- a/OvmfPkg/VirtioFsDxe/FuseInit.c
+++ b/OvmfPkg/VirtioFsDxe/FuseInit.c
@@ -21,17 +21,18 @@
   before VirtioFsUninit() is called.
 
   @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_INIT
                            request to. The FUSE request counter
                            "VirtioFs->RequestId" is set to 1 on output.
 
   @retval EFI_SUCCESS      The FUSE session has been started.
 
-  @retval EFI_UNSUPPORTED  FUSE interface version negotiation failed.
+  @retval EFI_UNSUPPORTED  FUSE interface version or feature negotiation
+                           failed.
 
   @return                  The "errno" value mapped to an EFI_STATUS code, if
                            the Virtio Filesystem device explicitly reported an
                            error.
 
   @return                  Error codes propagated from
                            VirtioFsSgListsValidate(), VirtioFsFuseNewRequest(),
                            VirtioFsSgListsSubmit(),
@@ -92,17 +93,17 @@ VirtioFsFuseInitSession (
   }
 
   //
   // Populate the FUSE_INIT-specific fields.
   //
   InitReq.Major        = VIRTIO_FS_FUSE_MAJOR;
   InitReq.Minor        = VIRTIO_FS_FUSE_MINOR;
   InitReq.MaxReadahead = 0;
-  InitReq.Flags        = 0;
+  InitReq.Flags        = VIRTIO_FS_FUSE_INIT_REQ_F_DO_READDIRPLUS;
 
   //
   // Submit the request.
   //
   Status = VirtioFsSgListsSubmit (VirtioFs, &ReqSgList, &RespSgList);
   if (EFI_ERROR (Status)) {
     return Status;
   }
@@ -116,17 +117,18 @@ VirtioFsFuseInitSession (
       DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" Errno=%d\n", __FUNCTION__,
         VirtioFs->Label, CommonResp.Error));
       Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
     }
     return Status;
   }
 
   //
-  // Check FUSE interface version compatibility.
+  // Check FUSE interface version / feature compatibility.
   //
   if (InitResp.Major < InitReq.Major ||
-      (InitResp.Major == InitReq.Major && InitResp.Minor < InitReq.Minor)) {
+      (InitResp.Major == InitReq.Major && InitResp.Minor < InitReq.Minor) ||
+      (InitResp.Flags & VIRTIO_FS_FUSE_INIT_REQ_F_DO_READDIRPLUS) == 0) {
     return EFI_UNSUPPORTED;
   }
 
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/FuseRead.c b/OvmfPkg/VirtioFsDxe/FuseRead.c
new file mode 100644
index 000000000000..1611e298b90d
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/FuseRead.c
@@ -0,0 +1,191 @@
+/** @file
+  FUSE_READ / FUSE_READDIRPLUS wrapper for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Read a chunk from a regular file or a directory stream, by sending the
+  FUSE_READ / FUSE_READDIRPLUS request to the Virtio Filesystem device.
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs  The Virtio Filesystem device to send the FUSE_READ
+                           or FUSE_READDIRPLUS request to. On output, the FUSE
+                           request counter "VirtioFs->RequestId" will have been
+                           incremented.
+
+  @param[in] NodeId        The inode number of the regular file or directory
+                           stream to read from.
+
+  @param[in] FuseHandle    The open handle to the regular file or directory
+                           stream to read from.
+
+  @param[in] IsDir         TRUE if NodeId and FuseHandle refer to a directory,
+                           FALSE if NodeId and FuseHandle refer to a regular
+                           file.
+
+  @param[in] Offset        If IsDir is FALSE: the absolute file position at
+                           which to start reading.
+
+                           If IsDir is TRUE: the directory stream cookie at
+                           which to start or continue reading. The zero-valued
+                           cookie identifies the start of the directory stream.
+                           Further positions in the directory stream can be
+                           passed in from the CookieForNextEntry field of
+                           VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE.
+
+  @param[in,out] Size      On input, the number of bytes to read. On successful
+                           return, the number of bytes actually read, which may
+                           be smaller than the value on input.
+
+                           When reading a regular file (i.e., when IsDir is
+                           FALSE), EOF can be detected by passing in a nonzero
+                           Size, and finding a zero Size on output.
+
+                           When reading a directory stream (i.e., when IsDir is
+                           TRUE), Data consists of a sequence of variably-sized
+                           records (directory entries). A read operation
+                           returns the maximal sequence of records that fits in
+                           Size, without having to truncate a record. In order
+                           to guarantee progress, call
+
+                             VirtioFsFuseStatFs (VirtioFs, NodeId,
+                               &FilesysAttr)
+
+                           first, to learn the maximum Namelen for the
+                           directory stream. Then assign Size at least
+
+                             VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE_SIZE (
+                               FilesysAttr.Namelen)
+
+                           on input. (Remember that
+                           VIRTIO_FS_FUSE_DIRENTPLUS_RESPONSE_SIZE() may return
+                           0 if its Namelen argument is invalid.) EOF can be
+                           detected if Size is set on input like described
+                           above, and Size is zero on output.
+
+  @param[out] Data         Buffer to read the bytes from the regular file or
+                           the directory stream into. The caller is responsible
+                           for providing room for (at least) as many bytes in
+                           Data as Size is on input.
+
+  @retval EFI_SUCCESS  Read successful. The caller is responsible for checking
+                       Size to learn the actual byte count transferred.
+
+  @return              The "errno" value mapped to an EFI_STATUS code, if the
+                       Virtio Filesystem device explicitly reported an error.
+
+  @return              Error codes propagated from VirtioFsSgListsValidate(),
+                       VirtioFsFuseNewRequest(), VirtioFsSgListsSubmit(),
+                       VirtioFsFuseCheckResponse().
+**/
+EFI_STATUS
+VirtioFsFuseReadFileOrDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN     UINT64    NodeId,
+  IN     UINT64    FuseHandle,
+  IN     BOOLEAN   IsDir,
+  IN     UINT64    Offset,
+  IN OUT UINT32    *Size,
+     OUT VOID      *Data
+  )
+{
+  VIRTIO_FS_FUSE_REQUEST        CommonReq;
+  VIRTIO_FS_FUSE_READ_REQUEST   ReadReq;
+  VIRTIO_FS_IO_VECTOR           ReqIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST ReqSgList;
+  VIRTIO_FS_FUSE_RESPONSE       CommonResp;
+  VIRTIO_FS_IO_VECTOR           RespIoVec[2];
+  VIRTIO_FS_SCATTER_GATHER_LIST RespSgList;
+  EFI_STATUS                    Status;
+  UINTN                         TailBufferFill;
+
+  //
+  // Set up the scatter-gather lists.
+  //
+  ReqIoVec[0].Buffer = &CommonReq;
+  ReqIoVec[0].Size   = sizeof CommonReq;
+  ReqIoVec[1].Buffer = &ReadReq;
+  ReqIoVec[1].Size   = sizeof ReadReq;
+  ReqSgList.IoVec    = ReqIoVec;
+  ReqSgList.NumVec   = ARRAY_SIZE (ReqIoVec);
+
+  RespIoVec[0].Buffer = &CommonResp;
+  RespIoVec[0].Size   = sizeof CommonResp;
+  RespIoVec[1].Buffer = Data;
+  RespIoVec[1].Size   = *Size;
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
+             IsDir ? VirtioFsFuseOpReadDirPlus : VirtioFsFuseOpRead,
+             NodeId
+             );
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  //
+  // Populate the FUSE_READ- / FUSE_READDIRPLUS-specific fields.
+  //
+  ReadReq.FileHandle = FuseHandle;
+  ReadReq.Offset     = Offset;
+  ReadReq.Size       = *Size;
+  ReadReq.ReadFlags  = 0;
+  ReadReq.LockOwner  = 0;
+  ReadReq.Flags      = 0;
+  ReadReq.Padding    = 0;
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
+  // Verify the response. Note that TailBufferFill is variable.
+  //
+  Status = VirtioFsFuseCheckResponse (&RespSgList, CommonReq.Unique,
+             &TailBufferFill);
+  if (EFI_ERROR (Status)) {
+    if (Status == EFI_DEVICE_ERROR) {
+      DEBUG ((DEBUG_ERROR, "%a: Label=\"%s\" NodeId=%Lu FuseHandle=%Lu "
+        "IsDir=%d Offset=0x%Lx Size=0x%x Data@%p Errno=%d\n", __FUNCTION__,
+        VirtioFs->Label, NodeId, FuseHandle, IsDir, Offset, *Size, Data,
+        CommonResp.Error));
+      Status = VirtioFsErrnoToEfiStatus (CommonResp.Error);
+    }
+    return Status;
+  }
+
+  //
+  // Report the actual transfer size.
+  //
+  // Integer overflow in the (UINT32) cast below is not possible; the
+  // VIRTIO_FS_SCATTER_GATHER_LIST functions would have caught that.
+  //
+  *Size = (UINT32)TailBufferFill;
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



