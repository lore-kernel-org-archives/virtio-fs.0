From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:53 +0100
Message-Id: <20201216211125.19496-17-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 16/48] OvmfPkg/VirtioFsDxe: add helper for
	appending and sanitizing paths
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

EFI_FILE_PROTOCOL.Open() -- for opening files -- and
EFI_FILE_PROTOCOL.SetInfo() --  for renaming files -- will require us to
append a relative UEFI pathname to an absolute base pathname. In turn,
components of the resultant pathnames will have to be sent to virtiofsd,
which does not consume UEFI-style pathnames.

We're going to maintain the base pathnames in canonical POSIX format:
- absolute (starts with "/"),
- dot (.) and dot-dot (..) components resolved/removed,
- uses forward slashes,
- sequences of slashes collapsed,
- printable ASCII character set,
- CHAR8 encoding,
- no trailing slash except for the root directory itself,
- length at most VIRTIO_FS_MAX_PATHNAME_LENGTH.

Add a helper function that can append a UEFI pathname to such a base
pathname, and produce the result in conformance with the same invariants.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h   |  32 ++
 OvmfPkg/VirtioFsDxe/Helpers.c       | 474 ++++++++++++++++++++
 3 files changed, 507 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 15e21772c8ac..0c92bccdac86 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -99,16 +99,17 @@ [Sources]
   SimpleFsRead.c
   SimpleFsSetInfo.c
   SimpleFsSetPosition.c
   SimpleFsWrite.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
+  BaseMemoryLib
   DebugLib
   MemoryAllocationLib
   UefiBootServicesTableLib
   UefiDriverEntryPoint
   VirtioLib
 
 [Protocols]
   gEfiComponentName2ProtocolGuid        ## PRODUCES
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 1cbd27d8fb52..f4fed64c7217 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -17,16 +17,40 @@
 #include <Protocol/VirtioDevice.h>     // VIRTIO_DEVICE_PROTOCOL
 #include <Uefi/UefiBaseType.h>         // EFI_EVENT
 
 #define VIRTIO_FS_SIG SIGNATURE_64 ('V', 'I', 'R', 'T', 'I', 'O', 'F', 'S')
 
 #define VIRTIO_FS_FILE_SIG \
   SIGNATURE_64 ('V', 'I', 'O', 'F', 'S', 'F', 'I', 'L')
 
+//
+// The following limit applies to two kinds of pathnames.
+//
+// - The length of a POSIX-style, canonical pathname *at rest* never exceeds
+//   VIRTIO_FS_MAX_PATHNAME_LENGTH. (Length is defined as the number of CHAR8
+//   elements in the canonical pathname, excluding the terminating '\0'.) This
+//   is an invariant that is ensured for canonical pathnames created, and that
+//   is assumed about canonical pathname inputs (which all originate
+//   internally).
+//
+// - If the length of a UEFI-style pathname *argument*, originating directly or
+//   indirectly from the EFI_FILE_PROTOCOL caller, exceeds
+//   VIRTIO_FS_MAX_PATHNAME_LENGTH, then the argument is rejected. (Length is
+//   defined as the number of CHAR16 elements in the UEFI-style pathname,
+//   excluding the terminating L'\0'.) This is a restriction that's checked on
+//   external UEFI-style pathname inputs.
+//
+// The limit is not expected to be a practical limitation; it's only supposed
+// to prevent attempts at overflowing size calculations. For both kinds of
+// pathnames, separate limits could be used; a common limit is used purely for
+// simplicity.
+//
+#define VIRTIO_FS_MAX_PATHNAME_LENGTH ((UINTN)65535)
+
 //
 // Filesystem label encoded in UCS-2, transformed from the UTF-8 representation
 // in "VIRTIO_FS_CONFIG.Tag", and NUL-terminated. Only the printable ASCII code
 // points (U+0020 through U+007E) are supported.
 //
 typedef CHAR16 VIRTIO_FS_LABEL[VIRTIO_FS_TAG_BYTES + 1];
 
 //
@@ -187,16 +211,24 @@ VirtioFsFuseCheckResponse (
   OUT UINTN                         *TailBufferFill
   );
 
 EFI_STATUS
 VirtioFsErrnoToEfiStatus (
   IN INT32 Errno
   );
 
+EFI_STATUS
+VirtioFsAppendPath (
+  IN     CHAR8   *LhsPath8,
+  IN     CHAR16  *RhsPath16,
+     OUT CHAR8   **ResultPath8,
+     OUT BOOLEAN *RootEscape
+  );
+
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseForget (
   IN OUT VIRTIO_FS *VirtioFs,
   IN     UINT64    NodeId
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 00f762142746..4a7b59332ca9 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -1,16 +1,19 @@
 /** @file
   Initialization and helper routines for the Virtio Filesystem device.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <Library/BaseLib.h>             // StrLen()
+#include <Library/BaseMemoryLib.h>       // CopyMem()
+#include <Library/MemoryAllocationLib.h> // AllocatePool()
 #include <Library/VirtioLib.h>           // Virtio10WriteFeatures()
 
 #include "VirtioFsDxe.h"
 
 /**
   Read the Virtio Filesystem device configuration structure in full.
 
   @param[in] Virtio   The Virtio protocol underlying the VIRTIO_FS object.
@@ -1110,8 +1113,479 @@ VirtioFsErrnoToEfiStatus (
     return EFI_NOT_STARTED;
 
   default:
     break;
   }
 
   return EFI_DEVICE_ERROR;
 }
+
+//
+// Parser states for canonicalizing a POSIX pathname.
+//
+typedef enum {
+  ParserInit,   // just starting
+  ParserEnd,    // finished
+  ParserSlash,  // slash(es) seen
+  ParserDot,    // one dot seen since last slash
+  ParserDotDot, // two dots seen since last slash
+  ParserNormal, // a different sequence seen
+} PARSER_STATE;
+
+/**
+  Strip the trailing slash from the parser's output buffer, unless the trailing
+  slash stands for the root directory.
+
+  @param[in] Buffer        The parser's output buffer. Only used for
+                           sanity-checking.
+
+  @param[in,out] Position  On entry, points at the next character to produce
+                           (i.e., right past the end of the output written by
+                           the parser thus far). The last character in the
+                           parser's output buffer is a slash. On return, the
+                           slash is stripped, by decrementing Position by one.
+                           If this action would remove the slash character
+                           standing for the root directory, then the function
+                           has no effect.
+**/
+STATIC
+VOID
+ParserStripSlash (
+  IN     CHAR8 *Buffer,
+  IN OUT UINTN *Position
+  )
+{
+  ASSERT (*Position >= 1);
+  ASSERT (Buffer[*Position - 1] == '/');
+  if (*Position == 1) {
+    return;
+  }
+  (*Position)--;
+}
+
+/**
+  Produce one character in the parser's output buffer.
+
+  @param[out] Buffer       The parser's output buffer. On return, Char8 will
+                           have been written.
+
+  @param[in,out] Position  On entry, points at the next character to produce
+                           (i.e., right past the end of the output written by
+                           the parser thus far). On return, Position is
+                           incremented by one.
+
+  @param[in] Size          Total allocated size of the parser's output buffer.
+                           Used for sanity-checking.
+
+  @param[in] Char8         The character to place in the output buffer.
+**/
+STATIC
+VOID
+ParserCopy (
+     OUT CHAR8 *Buffer,
+  IN OUT UINTN *Position,
+  IN     UINTN Size,
+  IN     CHAR8 Char8
+  )
+{
+  ASSERT (*Position < Size);
+  Buffer[(*Position)++] = Char8;
+}
+
+/**
+  Rewind the last single-dot in the parser's output buffer.
+
+  @param[in] Buffer        The parser's output buffer. Only used for
+                           sanity-checking.
+
+  @param[in,out] Position  On entry, points at the next character to produce
+                           (i.e., right past the end of the output written by
+                           the parser thus far); the parser's output buffer
+                           ends with the characters ('/', '.'). On return, the
+                           dot is rewound by decrementing Position by one; a
+                           slash character will reside at the new end of the
+                           parser's output buffer.
+**/
+STATIC
+VOID
+ParserRewindDot (
+  IN     CHAR8 *Buffer,
+  IN OUT UINTN *Position
+  )
+{
+  ASSERT (*Position >= 2);
+  ASSERT (Buffer[*Position - 1] == '.');
+  ASSERT (Buffer[*Position - 2] == '/');
+  (*Position)--;
+}
+
+/**
+  Rewind the last dot-dot in the parser's output buffer.
+
+  @param[in] Buffer        The parser's output buffer. Only used for
+                           sanity-checking.
+
+  @param[in,out] Position  On entry, points at the next character to produce
+                           (i.e., right past the end of the output written by
+                           the parser thus far); the parser's output buffer
+                           ends with the characters ('/', '.', '.'). On return,
+                           the ('.', '.') pair is rewound unconditionally, by
+                           decrementing Position by two; a slash character
+                           resides at the new end of the parser's output
+                           buffer.
+
+                           If this slash character stands for the root
+                           directory, then RootEscape is set to TRUE.
+
+                           Otherwise (i.e., if this slash character is not the
+                           one standing for the root directory), then the slash
+                           character, and the pathname component preceding it,
+                           are removed by decrementing Position further. In
+                           this case, the slash character preceding the removed
+                           pathname component will reside at the new end of the
+                           parser's output buffer.
+
+  @param[out] RootEscape   Set to TRUE on output if the dot-dot component tries
+                           to escape the root directory, as described above.
+                           Otherwise, RootEscape is not modified.
+**/
+STATIC
+VOID
+ParserRewindDotDot (
+  IN     CHAR8   *Buffer,
+  IN OUT UINTN   *Position,
+     OUT BOOLEAN *RootEscape
+
+  )
+{
+  ASSERT (*Position >= 3);
+  ASSERT (Buffer[*Position - 1] == '.');
+  ASSERT (Buffer[*Position - 2] == '.');
+  ASSERT (Buffer[*Position - 3] == '/');
+  (*Position) -= 2;
+
+  if (*Position == 1) {
+    //
+    // Root directory slash reached; don't try to climb higher.
+    //
+    *RootEscape = TRUE;
+    return;
+  }
+
+  //
+  // Skip slash.
+  //
+  (*Position)--;
+  //
+  // Scan until next slash to the left.
+  //
+  do {
+    ASSERT (*Position > 0);
+    (*Position)--;
+  } while (Buffer[*Position] != '/');
+  (*Position)++;
+}
+
+/**
+  Append the UEFI-style RhsPath16 to the POSIX-style, canonical format
+  LhsPath8. Output the POSIX-style, canonical format result in ResultPath, as a
+  dynamically allocated string.
+
+  Canonicalization (aka sanitization) establishes the following properties:
+  - ResultPath is absolute (starts with "/"),
+  - dot (.) and dot-dot (..) components are resolved/eliminated in ResultPath,
+    with the usual semantics,
+  - ResultPath uses forward slashes,
+  - sequences of slashes are squashed in ResultPath,
+  - the printable ASCII character set covers ResultPath,
+  - CHAR8 encoding is used in ResultPath,
+  - no trailing slash present in ResultPath except for the standalone root
+    directory,
+  - the length of ResultPath is at most VIRTIO_FS_MAX_PATHNAME_LENGTH.
+
+  Any dot-dot in RhsPath16 that would remove the root directory is dropped, and
+  reported through RootEscape, without failing the function call.
+
+  @param[in] LhsPath8      Identifies the base directory. The caller is
+                           responsible for ensuring that LhsPath8 conform to
+                           the above canonical pathname format on entry.
+
+  @param[in] RhsPath16     Identifies the desired file with a UEFI-style CHAR16
+                           pathname. If RhsPath16 starts with a backslash, then
+                           RhsPath16 is considered absolute, and LhsPath8 is
+                           ignored; RhsPath16 is sanitized in isolation, for
+                           producing ResultPath8. Otherwise (i.e., if RhsPath16
+                           is relative), RhsPath16 is transliterated to CHAR8,
+                           and naively appended to LhsPath8. The resultant
+                           fused pathname is then sanitized, to produce
+                           ResultPath8.
+
+  @param[out] ResultPath8  The POSIX-style, canonical format pathname that
+                           leads to the file desired by the caller. After use,
+                           the caller is responsible for freeing ResultPath8.
+
+  @param[out] RootEscape   Set to TRUE if at least one dot-dot component in
+                           RhsPath16 attempted to escape the root directory;
+                           set to FALSE otherwise.
+
+  @retval EFI_SUCCESS            ResultPath8 has been produced. RootEscape has
+                                 been output.
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
+VirtioFsAppendPath (
+  IN     CHAR8   *LhsPath8,
+  IN     CHAR16  *RhsPath16,
+     OUT CHAR8   **ResultPath8,
+     OUT BOOLEAN *RootEscape
+  )
+{
+  UINTN        RhsLen;
+  CHAR8        *RhsPath8;
+  UINTN        Idx;
+  EFI_STATUS   Status;
+  UINTN        SizeToSanitize;
+  CHAR8        *BufferToSanitize;
+  CHAR8        *SanitizedBuffer;
+  PARSER_STATE State;
+  UINTN        SanitizedPosition;
+
+  //
+  // Appending an empty pathname is not allowed.
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
+  // Transliterate RhsPath16 to RhsPath8 by:
+  // - rejecting RhsPath16 if a character outside of printable ASCII is seen,
+  // - rejecting RhsPath16 if a forward slash is seen,
+  // - replacing backslashes with forward slashes,
+  // - casting the characters from CHAR16 to CHAR8.
+  //
+  RhsPath8 = AllocatePool (RhsLen + 1);
+  if (RhsPath8 == NULL) {
+    return EFI_OUT_OF_RESOURCES;
+  }
+  for (Idx = 0; RhsPath16[Idx] != L'\0'; Idx++) {
+    if (RhsPath16[Idx] < 0x20 || RhsPath16[Idx] > 0x7E ||
+        RhsPath16[Idx] == L'/') {
+      Status = EFI_UNSUPPORTED;
+      goto FreeRhsPath8;
+    }
+    RhsPath8[Idx] = (CHAR8)((RhsPath16[Idx] == L'\\') ? L'/' : RhsPath16[Idx]);
+  }
+  RhsPath8[Idx++] = '\0';
+
+  //
+  // Now prepare the input for the canonicalization (squashing of sequences of
+  // forward slashes, and eliminating . (dot) and .. (dot-dot) pathname
+  // components).
+  //
+  // The sanitized path can never be longer than the naive concatenation of the
+  // left hand side and right hand side paths, so we'll use the catenated size
+  // for allocating the sanitized output too.
+  //
+  if (RhsPath8[0] == '/') {
+    //
+    // If the right hand side path is absolute, then it is not appended to the
+    // left hand side path -- it *replaces* the left hand side path.
+    //
+    SizeToSanitize = RhsLen + 1;
+    BufferToSanitize = RhsPath8;
+  } else {
+    //
+    // If the right hand side path is relative, then it is appended (naively)
+    // to the left hand side.
+    //
+    UINTN LhsLen;
+
+    LhsLen = AsciiStrLen (LhsPath8);
+    SizeToSanitize = LhsLen + 1 + RhsLen + 1;
+    BufferToSanitize = AllocatePool (SizeToSanitize);
+    if (BufferToSanitize == NULL) {
+      Status = EFI_OUT_OF_RESOURCES;
+      goto FreeRhsPath8;
+    }
+    CopyMem (BufferToSanitize, LhsPath8, LhsLen);
+    BufferToSanitize[LhsLen] = '/';
+    CopyMem (BufferToSanitize + LhsLen + 1, RhsPath8, RhsLen + 1);
+  }
+
+  //
+  // Allocate the output buffer.
+  //
+  SanitizedBuffer = AllocatePool (SizeToSanitize);
+  if (SanitizedBuffer == NULL) {
+    Status = EFI_OUT_OF_RESOURCES;
+    goto FreeBufferToSanitize;
+  }
+
+  //
+  // State machine for parsing the input and producing the canonical output
+  // follows.
+  //
+  *RootEscape       = FALSE;
+  Idx               = 0;
+  State             = ParserInit;
+  SanitizedPosition = 0;
+  do {
+    CHAR8 Chr8;
+
+    ASSERT (Idx < SizeToSanitize);
+    Chr8 = BufferToSanitize[Idx++];
+
+    switch (State) {
+    case ParserInit: // just starting
+      ASSERT (Chr8 == '/');
+      ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+      State = ParserSlash;
+      break;
+
+    case ParserSlash: // slash(es) seen
+      switch (Chr8) {
+      case '\0':
+        ParserStripSlash (SanitizedBuffer, &SanitizedPosition);
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserEnd;
+        break;
+      case '/':
+        //
+        // skip & stay in same state
+        //
+        break;
+      case '.':
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserDot;
+        break;
+      default:
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserNormal;
+        break;
+      }
+      break;
+
+    case ParserDot: // one dot seen since last slash
+      switch (Chr8) {
+      case '\0':
+        ParserRewindDot (SanitizedBuffer, &SanitizedPosition);
+        ParserStripSlash (SanitizedBuffer, &SanitizedPosition);
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserEnd;
+        break;
+      case '/':
+        ParserRewindDot (SanitizedBuffer, &SanitizedPosition);
+        State = ParserSlash;
+        break;
+      case '.':
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserDotDot;
+        break;
+      default:
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserNormal;
+        break;
+      }
+      break;
+
+    case ParserDotDot: // two dots seen since last slash
+      switch (Chr8) {
+      case '\0':
+        ParserRewindDotDot (SanitizedBuffer, &SanitizedPosition, RootEscape);
+        ParserStripSlash (SanitizedBuffer, &SanitizedPosition);
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserEnd;
+        break;
+      case '/':
+        ParserRewindDotDot (SanitizedBuffer, &SanitizedPosition, RootEscape);
+        State = ParserSlash;
+        break;
+      case '.':
+        //
+        // fall through
+        //
+      default:
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserNormal;
+        break;
+      }
+      break;
+
+    case ParserNormal: // a different sequence seen
+      switch (Chr8) {
+      case '\0':
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserEnd;
+        break;
+      case '/':
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        State = ParserSlash;
+        break;
+      case '.':
+        //
+        // fall through
+        //
+      default:
+        //
+        // copy and stay in same state
+        //
+        ParserCopy (SanitizedBuffer, &SanitizedPosition, SizeToSanitize, Chr8);
+        break;
+      }
+      break;
+
+    default:
+      ASSERT (FALSE);
+      break;
+    }
+  } while (State != ParserEnd);
+
+  //
+  // Ensure length invariant on ResultPath8.
+  //
+  ASSERT (SanitizedPosition >= 2);
+  if (SanitizedPosition - 1 > VIRTIO_FS_MAX_PATHNAME_LENGTH) {
+    Status = EFI_OUT_OF_RESOURCES;
+    goto FreeSanitizedBuffer;
+  }
+
+  *ResultPath8    = SanitizedBuffer;
+  SanitizedBuffer = NULL;
+  Status          = EFI_SUCCESS;
+  //
+  // Fall through.
+  //
+FreeSanitizedBuffer:
+  if (SanitizedBuffer != NULL) {
+    FreePool (SanitizedBuffer);
+  }
+
+FreeBufferToSanitize:
+  if (RhsPath8[0] != '/') {
+    FreePool (BufferToSanitize);
+  }
+
+FreeRhsPath8:
+  FreePool (RhsPath8);
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



