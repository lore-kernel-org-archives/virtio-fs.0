From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:11:04 +0100
Message-Id: <20201216211125.19496-28-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 27/48] OvmfPkg/VirtioFsDxe: erase the dir.
	entry in EFI_FILE_PROTOCOL.Delete()
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

At this point, the infrastructure is available for looking up the directly
containing directory of the file in EFI_FILE_PROTOCOL.Delete(), and to
remove the file in that directory by last pathname component. Do so.

The "RM" UEFI shell command will start working only later in the series;
the shell needs more EFI_FILE_PROTOCOL members to function before it calls
Delete().

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c | 44 ++++++++++++++++++--
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
index e2fc2d72dfeb..76cfee5bceb1 100644
--- a/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
@@ -41,19 +41,57 @@ VirtioFsSimpleFileDelete (
   VirtioFsFuseReleaseFileOrDir (VirtioFs, VirtioFsFile->NodeId,
     VirtioFsFile->FuseHandle, VirtioFsFile->IsDirectory);
 
   //
   // VirtioFsFile->FuseHandle is gone at this point, but VirtioFsFile->NodeId
   // is still valid. Continue with removing the file or directory. The result
   // of this operation determines the return status of the function.
   //
-  // TODO
-  //
-  Status = EFI_WARN_DELETE_FAILURE;
+  if (VirtioFsFile->IsOpenForWriting) {
+    UINT64 ParentNodeId;
+    CHAR8  *LastComponent;
+
+    //
+    // Split our canonical pathname into most specific parent directory
+    // (identified by NodeId), and single-component filename within that
+    // directory. If This stands for the root directory "/", then the following
+    // function call will gracefully fail.
+    //
+    Status = VirtioFsLookupMostSpecificParentDir (
+               VirtioFs,
+               VirtioFsFile->CanonicalPathname,
+               &ParentNodeId,
+               &LastComponent
+               );
+    if (!EFI_ERROR (Status)) {
+      //
+      // Attempt the actual removal. Regardless of the outcome, ParentNodeId
+      // must be forgotten right after (unless it stands for the root
+      // directory).
+      //
+      Status = VirtioFsFuseRemoveFileOrDir (
+                 VirtioFs,
+                 ParentNodeId,
+                 LastComponent,
+                 VirtioFsFile->IsDirectory
+                 );
+      if (ParentNodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
+        VirtioFsFuseForget (VirtioFs, ParentNodeId);
+      }
+    }
+    if (EFI_ERROR (Status)) {
+      //
+      // Map any failure to the spec-mandated warning code.
+      //
+      Status = EFI_WARN_DELETE_FAILURE;
+    }
+  } else {
+    Status = EFI_WARN_DELETE_FAILURE;
+  }
 
   //
   // Finally, if we've known VirtioFsFile->NodeId from a lookup, then we should
   // also ask the server to forget it *once*.
   //
   if (VirtioFsFile->NodeId != VIRTIO_FS_FUSE_ROOT_DIR_NODE_ID) {
     VirtioFsFuseForget (VirtioFs, VirtioFsFile->NodeId);
   }
-- 
2.19.1.3.g30247aa5d201



