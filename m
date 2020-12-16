From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:23 +0100
Message-Id: <20201216211125.19496-47-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 46/48] OvmfPkg/VirtioFsDxe: add helper for
	determining access time updates
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

Add the VirtioFsGetFuseTimeUpdates() function, for determining whether an
EFI_FILE_PROTOCOL.SetInfo() invocation requests access time updates.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h |  10 ++
 OvmfPkg/VirtioFsDxe/Helpers.c     | 106 ++++++++++++++++++++
 2 files changed, 116 insertions(+)

diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 096756302942..4331cabbd40e 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -285,16 +285,26 @@ VirtioFsFuseDirentPlusToEfiFileInfo (
 VOID
 VirtioFsGetFuseSizeUpdate (
   IN     EFI_FILE_INFO *Info,
   IN     EFI_FILE_INFO *NewInfo,
      OUT BOOLEAN       *Update,
      OUT UINT64        *Size
   );
 
+EFI_STATUS
+VirtioFsGetFuseTimeUpdates (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *UpdateAtime,
+     OUT BOOLEAN       *UpdateMtime,
+     OUT UINT64        *Atime,
+     OUT UINT64        *Mtime
+  );
+
 //
 // Wrapper functions for FUSE commands (primitives).
 //
 
 EFI_STATUS
 VirtioFsFuseLookup (
   IN OUT VIRTIO_FS                          *VirtioFs,
   IN     UINT64                             DirNodeId,
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
index 838971bd2c85..c85c7400f2be 100644
--- a/OvmfPkg/VirtioFsDxe/Helpers.c
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -2208,8 +2208,114 @@ VirtioFsGetFuseSizeUpdate (
 
   if (IsDirectory || Info->FileSize == NewInfo->FileSize) {
     *Update = FALSE;
     return;
   }
   *Update = TRUE;
   *Size = NewInfo->FileSize;
 }
+
+/**
+  Given an EFI_FILE_INFO object received in an EFI_FILE_PROTOCOL.SetInfo()
+  call, determine whether updating the last access time and/or the last
+  modification time of the file is necessary, relative to an EFI_FILE_INFO
+  object describing the current state of the file.
+
+  @param[in] Info          The EFI_FILE_INFO describing the current state of
+                           the file. The caller is responsible for populating
+                           Info on input with VirtioFsFuseAttrToEfiFileInfo(),
+                           from the current FUSE attributes of the file. The
+                           Info->Size and Info->FileName members are ignored.
+
+  @param[in] NewInfo       The EFI_FILE_INFO object received in the
+                           EFI_FILE_PROTOCOL.SetInfo() call.
+
+  @param[out] UpdateAtime  Set to TRUE on output if the last access time needs
+                           to be updated. Set to FALSE otherwise.
+
+  @param[out] UpdateMtime  Set to TRUE on output if the last modification time
+                           needs to be updated. Set to FALSE otherwise.
+
+  @param[out] Atime        If UpdateAtime is set to TRUE, then Atime provides
+                           the last access timestamp to set (as seconds since
+                           the Epoch). Otherwise, Atime is not written to.
+
+  @param[out] Mtime        If UpdateMtime is set to TRUE, then Mtime provides
+                           the last modification timestamp to set (as seconds
+                           since the Epoch). Otherwise, Mtime is not written
+                           to.
+
+  @retval EFI_SUCCESS        Output parameters have been set successfully.
+
+  @retval EFI_ACCESS_DENIED  NewInfo requests changing both CreateTime and
+                             ModificationTime, but to values that differ from
+                             each other. The Virtio Filesystem device does not
+                             support this.
+**/
+EFI_STATUS
+VirtioFsGetFuseTimeUpdates (
+  IN     EFI_FILE_INFO *Info,
+  IN     EFI_FILE_INFO *NewInfo,
+     OUT BOOLEAN       *UpdateAtime,
+     OUT BOOLEAN       *UpdateMtime,
+     OUT UINT64        *Atime,
+     OUT UINT64        *Mtime
+  )
+{
+  EFI_TIME              *Time[3];
+  EFI_TIME              *NewTime[ARRAY_SIZE (Time)];
+  UINTN                 Idx;
+  STATIC CONST EFI_TIME ZeroTime;
+  BOOLEAN               Change[ARRAY_SIZE (Time)];
+  UINT64                Seconds[ARRAY_SIZE (Time)];
+
+  Time[0]    = &Info->CreateTime;
+  Time[1]    = &Info->LastAccessTime;
+  Time[2]    = &Info->ModificationTime;
+  NewTime[0] = &NewInfo->CreateTime;
+  NewTime[1] = &NewInfo->LastAccessTime;
+  NewTime[2] = &NewInfo->ModificationTime;
+
+  //
+  // Determine which timestamps differ from the current state. (A zero time
+  // means "don't update", per UEFI spec.) For each timestamp that's being
+  // changed, calculate the seconds since the Epoch.
+  //
+  for (Idx = 0; Idx < ARRAY_SIZE (Time); Idx++) {
+    if (CompareMem (NewTime[Idx], &ZeroTime, sizeof (EFI_TIME)) == 0 ||
+        CompareMem (NewTime[Idx], Time[Idx], sizeof (EFI_TIME)) == 0) {
+      Change[Idx] = FALSE;
+    } else {
+      Change[Idx] = TRUE;
+      Seconds[Idx] = EfiTimeToEpoch (NewTime[Idx]);
+    }
+  }
+
+  //
+  // If a change is requested for exactly one of CreateTime and
+  // ModificationTime, we'll change the last modification time. If changes are
+  // requested for both, and to the same timestamp, we'll similarly update the
+  // last modification time. If changes are requested for both, but to
+  // different timestamps, we reject the request.
+  //
+  if (Change[0] && Change[2] && Seconds[0] != Seconds[2]) {
+    return EFI_ACCESS_DENIED;
+  }
+
+  *UpdateAtime = FALSE;
+  *UpdateMtime = FALSE;
+
+  if (Change[0]) {
+    *UpdateMtime = TRUE;
+    *Mtime = Seconds[0];
+  }
+  if (Change[1]) {
+    *UpdateAtime = TRUE;
+    *Atime = Seconds[1];
+  }
+  if (Change[2]) {
+    *UpdateMtime = TRUE;
+    *Mtime = Seconds[2];
+  }
+
+  return EFI_SUCCESS;
+}
-- 
2.19.1.3.g30247aa5d201



