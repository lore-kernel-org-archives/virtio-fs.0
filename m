From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:19 +0100
Message-Id: <20201216211125.19496-43-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 42/48] OvmfPkg/VirtioFsDxe: add helper for
	composing rename/move destination path
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

The EFI_FILE_PROTOCOL.SetInfo() member is somewhat under-specified; one of
its modes of operation is renaming/moving the file.

In order to create the destination pathname in canonical format, 2*2=4
cases have to be considered. For the sake of discussion, assume the
current canonical pathname of a VIRTIO_FS_FILE is "/home/user/f1.txt".
Then, consider the following rename/move requests from
EFI_FILE_PROTOCOL.SetInfo():

  Destination requested  Destination  Move into   Destination in
  by SetInfo()           relative?    directory?  canonical format
  ---------------------  -----------  ----------  -----------------------
  L"\\dir\\f2.txt"       no           no          "/dir/f2.txt"
  L"\\dir\\"             no           yes         "/dir/f1.txt"
  L"dir\\f2.txt"         yes          no          "/home/user/dir/f2.txt"
  L"dir\\"               yes          yes         "/home/user/dir/f1.txt"

Add the VirtioFsComposeRenameDestination() function, for composing the
last column from the current canonical pathname and the SetInfo() input.

The function works on the following principles:

- The prefix of the destination path is "/", if the SetInfo() rename
  request is absolute.

  Otherwise, the dest prefix is the "current directory" (the most specific
  parent directory) of the original pathname (in the above example,
  "/home/user").

- The suffix of the destination path is precisely the SetInfo() request
  string, if the "move into directory" convenience format -- the trailing
  backslash -- is not used. (In the above example, L"\\dir\\f2.txt" and
  L"dir\\f2.txt".)

  Otherwise, the suffix is the SetInfo() request, plus the original
  basename (in the above example, L"\\dir\\f1.txt" and L"dir\\f1.txt").

- The complete destination is created by fusing the dest prefix and the
  dest suffix, using the VirtioFsAppendPath() function.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |   8 +
 OvmfPkg/VirtioFsDxe/Helpers.c     | 194 ++++++++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 9334e5434c51..a6dfac71f4a7 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -257,16 +257,24 @@ VirtioFsLookupMostSpecificParentDir (
 
 EFI_STATUS
 VirtioFsGetBasename (
   IN     CHAR8  *Path,
      OUT CHAR16 *Basename     OPTIONAL,
   IN OUT UINTN  *BasenameSize
   );
 
+EFI_STATUS
+VirtioFsComposeRenameDestination (
+  IN     CHAR8   *LhsPath8,
+  IN     CHAR16  *RhsPath16,
+     OUT CHAR8   **ResultPath8,
+     OUT BOOLEAN *RootEscape
+  );
+
 EFI_STATUS
 VirtioFsFuseAttrToEfiFileInfo (
   IN     VIRTIO_FS_FUSE_ATTRIBUTES_RESPONSE *FuseAttr,
      OUT EFI_FILE_INFO                      *FileInfo
   );
 
 EFI_STATUS
 VirtioFsFuseDirentPlusToEfiFileInfo (
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index cdaa8557a17b..b741cf753495 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -1778,16 +1778,210 @@ VirtioFsGetBasename (
   }
 
   for (Idx = LastComponent; Idx < PathSize; Idx++) {
     Basename[Idx - LastComponent] = Path[Idx];
   }
   return EFI_SUCCESS;
 }
 
+/**
+  Format the destination of a rename/move operation as a dynamically allocated
+  canonical pathname.
+
+  Any dot-dot in RhsPath16 that would remove the root directory is dropped, and
+  reported through RootEscape, without failing the function call.
+
+  @param[in] LhsPath8     The source pathname operand of the rename/move
+                          operation, expressed as a canonical pathname (as
+                          defined in the description of VirtioFsAppendPath()).
+                          The root directory "/" cannot be renamed/moved, and
+                          will be rejected.
+
+  @param[in] RhsPath16    The destination pathname operand expressed as a
+                          UEFI-style CHAR16 pathname.
+
+                          If RhsPath16 starts with a backslash, then RhsPath16
+                          is considered absolute. Otherwise, RhsPath16 is
+                          interpreted relative to the most specific parent
+                          directory found in LhsPath8.
+
+                          Independently, if RhsPath16 ends with a backslash
+                          (i.e., RhsPath16 is given in the "move into
+                          directory" convenience form), then RhsPath16 is
+                          interpreted with the basename of LhsPath8 appended.
+                          Otherwise, the last pathname component of RhsPath16
+                          is taken as the last pathname component of the
+                          rename/move destination.
+
+                          An empty RhsPath16 is rejected.
+
+  @param[out] ResultPath8  The POSIX-style, canonical format pathname that
+                           leads to the renamed/moved file. After use, the
+                           caller is responsible for freeing ResultPath8.
+
+  @param[out] RootEscape   Set to TRUE if at least one dot-dot component in
+                           RhsPath16 attempted to escape the root directory;
+                           set to FALSE otherwise.
+
+  @retval EFI_SUCCESS            ResultPath8 has been produced. RootEscape has
+                                 been output.
+
+  @retval EFI_INVALID_PARAMETER  LhsPath8 is "/".
+
+  @retval EFI_INVALID_PARAMETER  RhsPath16 is zero-length.
+
+  @retval EFI_INVALID_PARAMETER  RhsPath16 failed the
+                                 VIRTIO_FS_MAX_PATHNAME_LENGTH check.
+
+  @retval EFI_OUT_OF_RESOURCES   Memory allocation failed.
+
+  @retval EFI_OUT_OF_RESOURCES   ResultPath8 would have failed the
+                                 VIRTIO_FS_MAX_PATHNAME_LENGTH check.
+
+  @retval EFI_UNSUPPORTED        RhsPath16 contains a character that either
+                                 falls outside of the printable ASCII set, or
+                                 is a forward slash.
+**/
+EFI_STATUS
+VirtioFsComposeRenameDestination (
+  IN     CHAR8   *LhsPath8,
+  IN     CHAR16  *RhsPath16,
+     OUT CHAR8   **ResultPath8,
+     OUT BOOLEAN *RootEscape
+  )
+{
+  //
+  // Lengths are expressed as numbers of characters (CHAR8 or CHAR16),
+  // excluding terminating NULs. Sizes are expressed as byte counts, including
+  // the bytes taken up by terminating NULs.
+  //
+  UINTN      RhsLen;
+  UINTN      LhsBasename16Size;
+  EFI_STATUS Status;
+  UINTN      LhsBasenameLen;
+  UINTN      DestSuffix16Size;
+  CHAR16     *DestSuffix16;
+  CHAR8      *DestPrefix8;
+
+  //
+  // An empty destination operand for the rename/move operation is not allowed.
+  //
+  RhsLen = StrLen (RhsPath16);
+  if (RhsLen == 0) {
+    return EFI_INVALID_PARAMETER;
+  }
+  //
+  // Enforce length restriction on RhsPath16.
+  //
+  if (RhsLen > VIRTIO_FS_MAX_PATHNAME_LENGTH) {
+    return EFI_INVALID_PARAMETER;
+  }
+
+  //
+  // Determine the length of the basename of LhsPath8.
+  //
+  LhsBasename16Size = 0;
+  Status = VirtioFsGetBasename (LhsPath8, NULL, &LhsBasename16Size);
+  ASSERT (Status == EFI_BUFFER_TOO_SMALL);
+  ASSERT (LhsBasename16Size >= sizeof (CHAR16));
+  ASSERT (LhsBasename16Size % sizeof (CHAR16) == 0);
+  LhsBasenameLen = LhsBasename16Size / sizeof (CHAR16) - 1;
+  if (LhsBasenameLen == 0) {
+    //
+    // The root directory cannot be renamed/moved.
+    //
+    return EFI_INVALID_PARAMETER;
+  }
+
+  //
+  // Resolve the "move into directory" convenience form in RhsPath16.
+  //
+  if (RhsPath16[RhsLen - 1] == L'\\') {
+    //
+    // Append the basename of LhsPath8 as a CHAR16 string to RhsPath16.
+    //
+    DestSuffix16Size = RhsLen * sizeof (CHAR16) + LhsBasename16Size;
+    DestSuffix16 = AllocatePool (DestSuffix16Size);
+    if (DestSuffix16 == NULL) {
+      return EFI_OUT_OF_RESOURCES;
+    }
+    CopyMem (DestSuffix16, RhsPath16, RhsLen * sizeof (CHAR16));
+    Status = VirtioFsGetBasename (LhsPath8, DestSuffix16 + RhsLen,
+               &LhsBasename16Size);
+    ASSERT_EFI_ERROR (Status);
+  } else {
+    //
+    // Just create a copy of RhsPath16.
+    //
+    DestSuffix16Size = (RhsLen + 1) * sizeof (CHAR16);
+    DestSuffix16 = AllocateCopyPool (DestSuffix16Size, RhsPath16);
+    if (DestSuffix16 == NULL) {
+      return EFI_OUT_OF_RESOURCES;
+    }
+  }
+
+  //
+  // If the destination operand is absolute, it will be interpreted relative to
+  // the root directory.
+  //
+  // Otherwise (i.e., if the destination operand is relative), then create the
+  // canonical pathname that the destination operand is interpreted relatively
+  // to; that is, the canonical pathname of the most specific parent directory
+  // found in LhsPath8.
+  //
+  if (DestSuffix16[0] == L'\\') {
+    DestPrefix8 = AllocateCopyPool (sizeof "/", "/");
+    if (DestPrefix8 == NULL) {
+      Status = EFI_OUT_OF_RESOURCES;
+      goto FreeDestSuffix16;
+    }
+  } else {
+    UINTN LhsLen;
+    UINTN DestPrefixLen;
+
+    //
+    // Strip the basename of LhsPath8.
+    //
+    LhsLen = AsciiStrLen (LhsPath8);
+    ASSERT (LhsBasenameLen < LhsLen);
+    DestPrefixLen = LhsLen - LhsBasenameLen;
+    ASSERT (LhsPath8[DestPrefixLen - 1] == '/');
+    //
+    // If we're not at the root directory, strip the slash too.
+    //
+    if (DestPrefixLen > 1) {
+      DestPrefixLen--;
+    }
+    DestPrefix8 = AllocatePool (DestPrefixLen + 1);
+    if (DestPrefix8 == NULL) {
+      Status = EFI_OUT_OF_RESOURCES;
+      goto FreeDestSuffix16;
+    }
+    CopyMem (DestPrefix8, LhsPath8, DestPrefixLen);
+    DestPrefix8[DestPrefixLen] = '\0';
+  }
+
+  //
+  // Now combine DestPrefix8 and DestSuffix16 into the final canonical
+  // pathname.
+  //
+  Status = VirtioFsAppendPath (DestPrefix8, DestSuffix16, ResultPath8,
+             RootEscape);
+
+  FreePool (DestPrefix8);
+  //
+  // Fall through.
+  //
+FreeDestSuffix16:
+  FreePool (DestSuffix16);
+
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



