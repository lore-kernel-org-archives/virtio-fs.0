From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:40 +0100
Message-Id: <20201216211125.19496-4-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 03/48] OvmfPkg/VirtioFsDxe: DriverBinding:
	open VirtioDevice, install SimpleFs
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

Complete the Supported, Start, and Stop member functions of
EFI_DRIVER_BINDING_PROTOCOL sufficiently for exercising the UEFI driver
model:

- bind virtio-fs devices,

- produce placeholder EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on them.

On the "TO_START" (= Virtio) side, the VirtioFsBindingSupported() function
verifies the Virtio subsystem ID for the virtio-fs device (decimal 26 --
see
<https://github.com/oasis-tcs/virtio-spec/blob/87fa6b5d8155/virtio-fs.tex>).
Beyond that, no actual Virtio setup is performed for now. Those bits are
going to be implemented later in this series.

On the "BY_START" (= UEFI filesystem) side, the VirtioFsOpenVolume()
function -- which is the sole EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member
function -- is a stub; it always returns EFI_NO_MEDIA, for now.

The "CONNECT", "DISCONNECT", and "MAP -R" UEFI Shell commands can be used
to test this patch.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/Virtio10.h |  5 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |  7 ++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           | 52 +++++++++++
 OvmfPkg/VirtioFsDxe/DriverBinding.c         | 94 +++++++++++++++++++-
 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c    | 26 ++++++
 5 files changed, 181 insertions(+), 3 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/Virtio10.h b/OvmfPkg/Include/IndustryStandard/Virtio10.h
index 3c1592d1fdea..2c60be2b7c0c 100644
--- a/OvmfPkg/Include/IndustryStandard/Virtio10.h
+++ b/OvmfPkg/Include/IndustryStandard/Virtio10.h
@@ -12,16 +12,21 @@
 
 #include <IndustryStandard/Pci23.h>
 #include <IndustryStandard/Virtio095.h>
 
 //
 // Subsystem Device IDs (to be) introduced in VirtIo 1.0
 //
 #define VIRTIO_SUBSYSTEM_GPU_DEVICE         16
+//
+// Subsystem Device IDs from the VirtIo spec at git commit 87fa6b5d8155;
+// <https://github.com/oasis-tcs/virtio-spec/tree/87fa6b5d8155>.
+//
+#define VIRTIO_SUBSYSTEM_FILESYSTEM         26
 
 //
 // Structures for parsing the VirtIo 1.0 specific PCI capabilities from the
 // config space
 //
 #pragma pack (1)
 typedef struct {
   EFI_PCI_CAPABILITY_VENDOR_HDR VendorHdr;
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index 69cb44bc7c96..ff9b1c6178bc 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -73,20 +73,27 @@ [Defines]
   INF_VERSION                           = 1.29
   BASE_NAME                             = VirtioFsDxe
   FILE_GUID                             = 7BD9DDF7-8B83-488E-AEC9-24C78610289C
   MODULE_TYPE                           = UEFI_DRIVER
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
   MdePkg/MdePkg.dec
+  OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
+  SimpleFsOpenVolume.c
+  VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
+  DebugLib
+  MemoryAllocationLib
   UefiBootServicesTableLib
   UefiDriverEntryPoint
 
 [Protocols]
   gEfiComponentName2ProtocolGuid        ## PRODUCES
   gEfiDriverBindingProtocolGuid         ## PRODUCES
+  gEfiSimpleFileSystemProtocolGuid      ## BY_START
+  gVirtioDeviceProtocolGuid             ## TO_START
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
new file mode 100644
index 000000000000..287defd21f23
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -0,0 +1,52 @@
+/** @file
+  Internal macro definitions, type definitions, and function declarations for
+  the Virtio Filesystem device driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#ifndef VIRTIO_FS_DXE_H_
+#define VIRTIO_FS_DXE_H_
+
+#include <Base.h>                      // SIGNATURE_64()
+#include <Library/DebugLib.h>          // CR()
+#include <Protocol/SimpleFileSystem.h> // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
+#include <Protocol/VirtioDevice.h>     // VIRTIO_DEVICE_PROTOCOL
+
+#define VIRTIO_FS_SIG SIGNATURE_64 ('V', 'I', 'R', 'T', 'I', 'O', 'F', 'S')
+
+//
+// Main context structure, expressing an EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
+// interface on top of the Virtio Filesystem device.
+//
+typedef struct {
+  //
+  // Parts of this structure are initialized / torn down in various functions
+  // at various call depths. The table to the right should make it easier to
+  // track them.
+  //
+  //                              field         init function       init depth
+  //                              -----------   ------------------  ----------
+  UINT64                          Signature; // DriverBindingStart  0
+  VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
+  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
+} VIRTIO_FS;
+
+#define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
+  CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
+
+//
+// EFI_SIMPLE_FILE_SYSTEM_PROTOCOL member functions for the Virtio Filesystem
+// driver.
+//
+
+EFI_STATUS
+EFIAPI
+VirtioFsOpenVolume (
+  IN  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *This,
+  OUT EFI_FILE_PROTOCOL               **Root
+  );
+
+#endif // VIRTIO_FS_DXE_H_
diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/DriverBinding.c
index ac0a6330f01b..65e45b5c4bf7 100644
--- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -1,21 +1,25 @@
 /** @file
   Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devices.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
+#include <IndustryStandard/Virtio.h>          // VIRTIO_SUBSYSTEM_FILESYSTEM
 #include <Library/BaseLib.h>                  // AsciiStrCmp()
+#include <Library/MemoryAllocationLib.h>      // AllocatePool()
 #include <Library/UefiBootServicesTableLib.h> // gBS
 #include <Protocol/ComponentName2.h>          // EFI_COMPONENT_NAME2_PROTOCOL
 #include <Protocol/DriverBinding.h>           // EFI_DRIVER_BINDING_PROTOCOL
 
+#include "VirtioFsDxe.h"
+
 //
 // UEFI Driver Model protocol instances.
 //
 STATIC EFI_DRIVER_BINDING_PROTOCOL  mDriverBinding;
 STATIC EFI_COMPONENT_NAME2_PROTOCOL mComponentName2;
 
 //
 // UEFI Driver Model protocol member functions.
@@ -23,40 +27,124 @@ STATIC EFI_COMPONENT_NAME2_PROTOCOL mComponentName2;
 EFI_STATUS
 EFIAPI
 VirtioFsBindingSupported (
   IN EFI_DRIVER_BINDING_PROTOCOL *This,
   IN EFI_HANDLE                  ControllerHandle,
   IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
   )
 {
-  return EFI_UNSUPPORTED;
+  EFI_STATUS             Status;
+  VIRTIO_DEVICE_PROTOCOL *Virtio;
+  EFI_STATUS             CloseStatus;
+
+  Status = gBS->OpenProtocol (ControllerHandle, &gVirtioDeviceProtocolGuid,
+                  (VOID **)&Virtio, This->DriverBindingHandle,
+                  ControllerHandle, EFI_OPEN_PROTOCOL_BY_DRIVER);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  if (Virtio->SubSystemDeviceId != VIRTIO_SUBSYSTEM_FILESYSTEM) {
+    Status = EFI_UNSUPPORTED;
+  }
+
+  CloseStatus = gBS->CloseProtocol (ControllerHandle,
+                       &gVirtioDeviceProtocolGuid, This->DriverBindingHandle,
+                       ControllerHandle);
+  ASSERT_EFI_ERROR (CloseStatus);
+
+  return Status;
 }
 
 EFI_STATUS
 EFIAPI
 VirtioFsBindingStart (
   IN EFI_DRIVER_BINDING_PROTOCOL *This,
   IN EFI_HANDLE                  ControllerHandle,
   IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
   )
 {
-  return EFI_DEVICE_ERROR;
+  VIRTIO_FS  *VirtioFs;
+  EFI_STATUS Status;
+  EFI_STATUS CloseStatus;
+
+  VirtioFs = AllocatePool (sizeof *VirtioFs);
+  if (VirtioFs == NULL) {
+    return EFI_OUT_OF_RESOURCES;
+  }
+  VirtioFs->Signature = VIRTIO_FS_SIG;
+
+  Status = gBS->OpenProtocol (ControllerHandle, &gVirtioDeviceProtocolGuid,
+                  (VOID **)&VirtioFs->Virtio, This->DriverBindingHandle,
+                  ControllerHandle, EFI_OPEN_PROTOCOL_BY_DRIVER);
+  if (EFI_ERROR (Status)) {
+    goto FreeVirtioFs;
+  }
+
+  VirtioFs->SimpleFs.Revision   = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVISION;
+  VirtioFs->SimpleFs.OpenVolume = VirtioFsOpenVolume;
+
+  Status = gBS->InstallProtocolInterface (&ControllerHandle,
+                  &gEfiSimpleFileSystemProtocolGuid, EFI_NATIVE_INTERFACE,
+                  &VirtioFs->SimpleFs);
+  if (EFI_ERROR (Status)) {
+    goto CloseVirtio;
+  }
+
+  return EFI_SUCCESS;
+
+CloseVirtio:
+  CloseStatus = gBS->CloseProtocol (ControllerHandle,
+                       &gVirtioDeviceProtocolGuid, This->DriverBindingHandle,
+                       ControllerHandle);
+  ASSERT_EFI_ERROR (CloseStatus);
+
+FreeVirtioFs:
+  FreePool (VirtioFs);
+
+  return Status;
 }
 
 EFI_STATUS
 EFIAPI
 VirtioFsBindingStop (
   IN EFI_DRIVER_BINDING_PROTOCOL *This,
   IN EFI_HANDLE                  ControllerHandle,
   IN UINTN                       NumberOfChildren,
   IN EFI_HANDLE                  *ChildHandleBuffer OPTIONAL
   )
 {
-  return EFI_DEVICE_ERROR;
+  EFI_STATUS                      Status;
+  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *SimpleFs;
+  VIRTIO_FS                       *VirtioFs;
+
+  Status = gBS->OpenProtocol (ControllerHandle,
+                  &gEfiSimpleFileSystemProtocolGuid, (VOID **)&SimpleFs,
+                  This->DriverBindingHandle, ControllerHandle,
+                  EFI_OPEN_PROTOCOL_GET_PROTOCOL);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  VirtioFs = VIRTIO_FS_FROM_SIMPLE_FS (SimpleFs);
+
+  Status = gBS->UninstallProtocolInterface (ControllerHandle,
+                  &gEfiSimpleFileSystemProtocolGuid, SimpleFs);
+  if (EFI_ERROR (Status)) {
+    return Status;
+  }
+
+  Status = gBS->CloseProtocol (ControllerHandle, &gVirtioDeviceProtocolGuid,
+                  This->DriverBindingHandle, ControllerHandle);
+  ASSERT_EFI_ERROR (Status);
+
+  FreePool (VirtioFs);
+
+  return EFI_SUCCESS;
 }
 
 EFI_STATUS
 EFIAPI
 VirtioFsGetDriverName (
   IN  EFI_COMPONENT_NAME2_PROTOCOL *This,
   IN  CHAR8                        *Language,
   OUT CHAR16                       **DriverName
diff --git a/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
new file mode 100644
index 000000000000..a5a66a27d84c
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
@@ -0,0 +1,26 @@
+/** @file
+  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume() member function for the Virtio
+  Filesystem driver.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include "VirtioFsDxe.h"
+
+/**
+  Open the root directory on the Virtio Filesystem.
+
+  Refer to EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_OPEN_VOLUME for the interface
+  contract.
+**/
+EFI_STATUS
+EFIAPI
+VirtioFsOpenVolume (
+  IN  EFI_SIMPLE_FILE_SYSTEM_PROTOCOL *This,
+  OUT EFI_FILE_PROTOCOL               **Root
+  )
+{
+  return EFI_NO_MEDIA;
+}
-- 
2.19.1.3.g30247aa5d201



