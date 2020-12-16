From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:16 +0100
Message-Id: <20201216211125.19496-40-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 39/48] OvmfPkg/VirtioFsDxe: implement
	EFI_FILE_PROTOCOL.Write()
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

Using the functions introduced previously, we can now implement
VirtioFsSimpleFileWrite().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsWrite.c | 63 +++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c b/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
index 90d82bd722b1..8ae317c88e43 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
@@ -11,10 +11,71 @@
 EFI_STATUS
 EFIAPI
 VirtioFsSimpleFileWrite (
   IN     EFI_FILE_PROTOCOL *This,
   IN OUT UINTN             *BufferSize,
   IN     VOID              *Buffer
   )
 {
-  return EFI_NO_MEDIA;
+  VIRTIO_FS_FILE *VirtioFsFile;
+  VIRTIO_FS      *VirtioFs;
+  EFI_STATUS     Status;
+  UINTN          Transferred;
+  UINTN          Left;
+
+  VirtioFsFile = VIRTIO_FS_FILE_FROM_SIMPLE_FILE (This);
+  VirtioFs     = VirtioFsFile->OwnerFs;
+
+  if (VirtioFsFile->IsDirectory) {
+    return EFI_UNSUPPORTED;
+  }
+  if (!VirtioFsFile->IsOpenForWriting) {
+    return EFI_ACCESS_DENIED;
+  }
+
+  Status      = EFI_SUCCESS;
+  Transferred = 0;
+  Left        = *BufferSize;
+  while (Left > 0) {
+    UINT32 WriteSize;
+
+    //
+    // Honor the write buffer size limit.
+    //
+    WriteSize = (UINT32)MIN ((UINTN)VirtioFs->MaxWrite, Left);
+    Status = VirtioFsFuseWrite (
+               VirtioFs,
+               VirtioFsFile->NodeId,
+               VirtioFsFile->FuseHandle,
+               VirtioFsFile->FilePosition + Transferred,
+               &WriteSize,
+               (UINT8 *)Buffer + Transferred
+               );
+    if (!EFI_ERROR (Status) && WriteSize == 0) {
+      //
+      // Progress should have been made.
+      //
+      Status = EFI_DEVICE_ERROR;
+    }
+    if (EFI_ERROR (Status)) {
+      break;
+    }
+    Transferred += WriteSize;
+    Left        -= WriteSize;
+  }
+
+  *BufferSize = Transferred;
+  VirtioFsFile->FilePosition += Transferred;
+  //
+  // According to the UEFI spec,
+  //
+  // - 'Partial writes only occur when there has been a data error during the
+  //    write attempt (such as "file space full")', and
+  //
+  // - (as an example) EFI_VOLUME_FULL is returned when 'The volume is full'.
+  //
+  // These together imply that after a partial write, we have to return an
+  // error. In other words, (Transferred > 0) is inconsequential for the return
+  // value.
+  //
+  return Status;
 }
-- 
2.19.1.3.g30247aa5d201



