From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:00 +0100
Message-Id: <20201216211125.19496-24-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 23/48] OvmfPkg/VirtioFsDxe: split canon.
	path into last parent + last component
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

Given a canonical pathname (as defined by VirtioFsAppendPath()), different
from "/", introduce a helper function for:

- looking up the NodeId of the most specific parent directory, and

- exposing the last component stand-alone (which is therefore a direct
  child of said parent directory).

This splitting operation will be necessary in multiple subsequent patches.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |   8 ++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 131 ++++++++++++++++++++
 2 files changed, 139 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index b2e4adce098b..6ae5c36f7fd5 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -221,16 +221,24 @@ VirtioFsErrnoToEfiStatus (
 EFI_STATUS
 VirtioFsAppendPath (
   IN     CHAR8   *LhsPath8,
   IN     CHAR16  *RhsPath16,
      OUT CHAR8   **ResultPath8,
      OUT BOOLEAN *RootEscape
   );
 
+EFI_STATUS
+VirtioFsLookupMostSpecificParentDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN OUT CHAR8     *Path,
+     OUT UINT64    *DirNodeId,
+     OUT CHAR8     **LastComponent
+  );
+
 EFI_STATUS
 VirtioFsFuseAttrToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
      OUT EFI_FILE_INFO                      *FileInfo
   );
 
 //
 // Wrapper functions for FUSE commands (primitives).
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index fa656bb535b8..6adc0341dee6 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -1586,16 +1586,147 @@ VirtioFsAppendPath (
     FreePool (BufferToSanitize);
   }
 
 FreeRhsPath8:
   FreePool (RhsPath8);
   return Status;
 }
 
+/**
+  For a given canonical pathname (as defined at VirtioFsAppendPath()), look up
+  the NodeId of the most specific parent directory, plus output a pointer to
+  the last pathname component (which is therefore a direct child of said parent
+  directory).
+
+  The function may only be called after VirtioFsFuseInitSession() returns
+  successfully and before VirtioFsUninit() is called.
+
+  @param[in,out] VirtioFs    The Virtio Filesystem device to send FUSE_LOOKUP
+                             and FUSE_FORGET requests to. On output, the FUSE
+                             request counter "VirtioFs->RequestId" will have
+                             been incremented several times.
+
+  @param[in,out] Path        The canonical pathname (as defined in the
+                             description of VirtioFsAppendPath()) to split.
+                             Path is modified in-place temporarily; however, on
+                             return (successful or otherwise), Path reassumes
+                             its original contents.
+
+  @param[out] DirNodeId      The NodeId of the most specific parent directory
+                             identified by Path. The caller is responsible for
+                             sending a FUSE_FORGET request to the Virtio
+                             Filesystem device for DirNodeId -- unless
+                             DirNodeId equals VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID
+                             --, when DirNodeId's use ends.
+
+  @param[out] LastComponent  A pointer into Path, pointing at the start of the
+                             last pathname component.
+
+  @retval EFI_SUCCESS            Splitting successful.
+
+  @retval EFI_INVALID_PARAMETER  Path is "/".
+
+  @retval EFI_ACCESS_DENIED      One of the components on Path before the last
+                                 is not a directory.
+
+  @return                        Error codes propagated from
+                                 VirtioFsFuseLookup() and
+                                 VirtioFsFuseAttrToEfiFileInfo().
+**/
+EFI_STATUS
+VirtioFsLookupMostSpecificParentDir (
+  IN OUT VIRTIO_FS *VirtioFs,
+  IN OUT CHAR8     *Path,
+     OUT UINT64    *DirNodeId,
+     OUT CHAR8     **LastComponent
+  )
+{
+  UINT64     ParentDirNodeId;
+  CHAR8      *Slash;
+  EFI_STATUS Status;
+  UINT64     NextDirNodeId;
+
+  if (AsciiStrCmp (Path, "/") == 0) {
+    return EFI_INVALID_PARAMETER;
+  }
+
+  ParentDirNodeId = VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID;
+  Slash           = Path;
+  for (;;) {
+    CHAR8                              *NextSlash;
+    VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE FuseAttr;
+    EFI_FILE_INFO                      FileInfo;
+
+    //
+    // Find the slash (if any) that terminates the next pathname component.
+    //
+    NextSlash = AsciiStrStr (Slash + 1, "/");
+    if (NextSlash == NULL) {
+      break;
+    }
+
+    //
+    // Temporarily replace the found slash character with a NUL in-place, for
+    // easy construction of the single-component filename that we need to look
+    // up.
+    //
+    *NextSlash = '\0';
+    Status = VirtioFsFuseLookup (VirtioFs, ParentDirNodeId, Slash + 1,
+               &NextDirNodeId, &FuseAttr);
+    *NextSlash = '/';
+
+    //
+    // We're done with the directory inode that was the basis for the lookup.
+    //
+    if (ParentDirNodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+      VirtioFsFuseForget (VirtioFs, ParentDirNodeId);
+    }
+
+    //
+    // If we couldn't look up the next *non-final* pathname component, bail.
+    //
+    if (EFI_ERROR (Status)) {
+      return Status;
+    }
+
+    //
+    // Lookup successful; now check if the next (non-final) component is a
+    // directory. If not, bail.
+    //
+    Status = VirtioFsFuseAttrToEfiFileInfo (&FuseAttr, &FileInfo);
+    if (EFI_ERROR (Status)) {
+      goto ForgetNextDirNodeId;
+    }
+    if ((FileInfo.Attribute & EFI_FILE_DIRECTORY) == 0) {
+      Status = EFI_ACCESS_DENIED;
+      goto ForgetNextDirNodeId;
+    }
+
+    //
+    // Advance.
+    //
+    ParentDirNodeId = NextDirNodeId;
+    Slash           = NextSlash;
+  }
+
+  //
+  // ParentDirNodeId corresponds to the last containing directory. The
+  // remaining single-component filename represents a direct child under that
+  // directory. Said filename starts at (Slash + 1).
+  //
+  *DirNodeId     = ParentDirNodeId;
+  *LastComponent = Slash + 1;
+  return EFI_SUCCESS;
+
+ForgetNextDirNodeId:
+  VirtioFsFuseForget (VirtioFs, NextDirNodeId);
+  return Status;
+}
+
 /**
   Convert select fields of a VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
   corresponding fields in EFI_FILE_INFO.
 
   @param[in] FuseAttr   The VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE object to
                         convert the relevant fields from.
 
   @param[out] FileInfo  The EFI_FILE_INFO structure to modify. Importantly, the
-- 
2.19.1.3.g30247aa5d201



