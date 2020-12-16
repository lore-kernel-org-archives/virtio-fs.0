From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:41 +0100
Message-Id: <20201216211125.19496-5-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 04/48] OvmfPkg/VirtioFsDxe: implement
	virtio device (un)initialization
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

Add the VirtioFsInit(), VirtioFsUninit(), and VirtioFsExitBoot()
functions.

In VirtioFsInit():

- Verify the host-side config of the virtio-fs device.

- Save the filesystem label ("tag") for later, from the configuration area
  of the virtio-fs device.

- Save the virtio queue size for later as well.

- Set up the virtio ring for sending requests.

In VirtioFsUninit():

- Reset the device.

- Tear down the virtio ring.

In VirtioFsExitBoot():

- Reset the device.

With this patch, the UEFI connect / disconnect controller operations
involve virtio setup / teardown; they are visible in the virtio-fs
daemon's log file. The virtiofsd log also confirms the device reset in
VirtioFsExitBoot(), when an OS is booted while the virtio-fs device is
bound.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/Include/IndustryStandard/VirtioFs.h |  52 ++++
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |   2 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  35 +++
 OvmfPkg/VirtioFsDxe/DriverBinding.c         |  26 +-
 OvmfPkg/VirtioFsDxe/Helpers.c               | 299 ++++++++++++++++++++
 5 files changed, 412 insertions(+), 2 deletions(-)

diff --git a/OvmfPkg/Include/IndustryStandard/VirtioFs.h b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
new file mode 100644
index 000000000000..ea7d80d15d0b
--- /dev/null
+++ b/OvmfPkg/Include/IndustryStandard/VirtioFs.h
@@ -0,0 +1,52 @@
+/** @file
+  Type and macro definitions specific to the Virtio Filesystem device.
+
+  At the time of this writing, the latest released Virtio specification (v1.1)
+  does not include the virtio-fs device. The development version of the
+  specification defines it however; see the latest version at
+  <https://github.com/oasis-tcs/virtio-spec/blob/87fa6b5d8155/virtio-fs.tex>.
+
+  This header file is minimal, and only defines the types and macros that are
+  necessary for the OvmfPkg implementation.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#ifndef VIRTIO_FS_H_
+#define VIRTIO_FS_H_
+
+#include <IndustryStandard/Virtio.h>
+
+//
+// Lowest numbered queue for sending normal priority requests.
+//
+#define VIRTIO_FS_REQUEST_QUEUE 1
+
+//
+// Number of bytes in the "VIRTIO_FS_CONFIG.Tag" field.
+//
+#define VIRTIO_FS_TAG_BYTES 36
+
+//
+// Device configuration layout.
+//
+#pragma pack (1)
+typedef struct {
+  //
+  // The Tag field can be considered the filesystem label, or a mount point
+  // hint. It is UTF-8 encoded, and padded to full size with NUL bytes. If the
+  // encoded bytes take up the entire Tag field, then there is no NUL
+  // terminator.
+  //
+  UINT8 Tag[VIRTIO_FS_TAG_BYTES];
+  //
+  // The total number of request virtqueues exposed by the device (i.e.,
+  // excluding the "hiprio" queue).
+  //
+  UINT32 NumReqQueues;
+} VIRTIO_FS_CONFIG;
+#pragma pack ()
+
+#endif // VIRTIO_FS_H_
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
index ff9b1c6178bc..f6eebdb6bc7c 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -77,23 +77,25 @@ [Defines]
   ENTRY_POINT                           = VirtioFsEntryPoint
 
 [Packages]
   MdePkg/MdePkg.dec
   OvmfPkg/OvmfPkg.dec
 
 [Sources]
   DriverBinding.c
+  Helpers.c
   SimpleFsOpenVolume.c
   VirtioFsDxe.h
 
 [LibraryClasses]
   BaseLib
   DebugLib
   MemoryAllocationLib
   UefiBootServicesTableLib
   UefiDriverEntryPoint
+  VirtioLib
 
 [Protocols]
   gEfiComponentName2ProtocolGuid        ## PRODUCES
   gEfiDriverBindingProtocolGuid         ## PRODUCES
   gEfiSimpleFileSystemProtocolGuid      ## BY_START
   gVirtioDeviceProtocolGuid             ## TO_START
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
index 287defd21f23..2aae96ecd79a 100644
--- a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
@@ -6,42 +6,77 @@
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
 #ifndef VIRTIO_FS_DXE_H_
 #define VIRTIO_FS_DXE_H_
 
 #include <Base.h>                      // SIGNATURE_64()
+#include <IndustryStandard/VirtioFs.h> // VIRTIO_FS_TAG_BYTES
 #include <Library/DebugLib.h>          // CR()
 #include <Protocol/SimpleFileSystem.h> // EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
 #include <Protocol/VirtioDevice.h>     // VIRTIO_DEVICE_PROTOCOL
+#include <Uefi/UefiBaseType.h>         // EFI_EVENT
 
 #define VIRTIO_FS_SIG SIGNATURE_64 ('V', 'I', 'R', 'T', 'I', 'O', 'F', 'S')
 
+//
+// Filesystem label encoded in UCS-2, transformed from the UTF-8 representation
+// in "VIRTIO_FS_CONFIG.Tag", and NUL-terminated. Only the printable ASCII code
+// points (U+0020 through U+007E) are supported.
+//
+typedef CHAR16 VIRTIO_FS_LABEL[VIRTIO_FS_TAG_BYTES + 1];
+
 //
 // Main context structure, expressing an EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
 // interface on top of the Virtio Filesystem device.
 //
 typedef struct {
   //
   // Parts of this structure are initialized / torn down in various functions
   // at various call depths. The table to the right should make it easier to
   // track them.
   //
   //                              field         init function       init depth
   //                              -----------   ------------------  ----------
   UINT64                          Signature; // DriverBindingStart  0
   VIRTIO_DEVICE_PROTOCOL          *Virtio;   // DriverBindingStart  0
+  VIRTIO_FS_LABEL                 Label;     // VirtioFsInit        1
+  UINT16                          QueueSize; // VirtioFsInit        1
+  VRING                           Ring;      // VirtioRingInit      2
+  VOID                            *RingMap;  // VirtioRingMap       2
+  EFI_EVENT                       ExitBoot;  // DriverBindingStart  0
   EFI_SIMPLE_FILE_SYSTEM_PROTOCOL SimpleFs;  // DriverBindingStart  0
 } VIRTIO_FS;
 
 #define VIRTIO_FS_FROM_SIMPLE_FS(SimpleFsReference) \
   CR (SimpleFsReference, VIRTIO_FS, SimpleFs, VIRTIO_FS_SIG);
 
+//
+// Initialization and helper routines for the Virtio Filesystem device.
+//
+
+EFI_STATUS
+VirtioFsInit (
+  IN OUT VIRTIO_FS *VirtioFs
+  );
+
+VOID
+VirtioFsUninit (
+  IN OUT VIRTIO_FS *VirtioFs
+  );
+
+VOID
+EFIAPI
+VirtioFsExitBoot (
+  IN EFI_EVENT ExitBootEvent,
+  IN VOID      *VirtioFsAsVoid
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
index 65e45b5c4bf7..b888158a805d 100644
--- a/OvmfPkg/VirtioFsDxe/DriverBinding.c
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -1,17 +1,16 @@
 /** @file
   Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devices.
 
   Copyright (C) 2020, Red Hat, Inc.
 
   SPDX-License-Identifier: BSD-2-Clause-Patent
 **/
 
-#include <IndustryStandard/Virtio.h>          // VIRTIO_SUBSYSTEM_FILESYSTEM
 #include <Library/BaseLib.h>                  // AsciiStrCmp()
 #include <Library/MemoryAllocationLib.h>      // AllocatePool()
 #include <Library/UefiBootServicesTableLib.h> // gBS
 #include <Protocol/ComponentName2.h>          // EFI_COMPONENT_NAME2_PROTOCOL
 #include <Protocol/DriverBinding.h>           // EFI_DRIVER_BINDING_PROTOCOL
 
 #include "VirtioFsDxe.h"
 
@@ -75,28 +74,46 @@ VirtioFsBindingStart (
 
   Status = gBS->OpenProtocol (ControllerHandle, &gVirtioDeviceProtocolGuid,
                   (VOID **)&VirtioFs->Virtio, This->DriverBindingHandle,
                   ControllerHandle, EFI_OPEN_PROTOCOL_BY_DRIVER);
   if (EFI_ERROR (Status)) {
     goto FreeVirtioFs;
   }
 
+  Status = VirtioFsInit (VirtioFs);
+  if (EFI_ERROR (Status)) {
+    goto CloseVirtio;
+  }
+
+  Status = gBS->CreateEvent (EVT_SIGNAL_EXIT_BOOT_SERVICES, TPL_CALLBACK,
+                  VirtioFsExitBoot, VirtioFs, &VirtioFs->ExitBoot);
+  if (EFI_ERROR (Status)) {
+    goto UninitVirtioFs;
+  }
+
   VirtioFs->SimpleFs.Revision   = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_REVISION;
   VirtioFs->SimpleFs.OpenVolume = VirtioFsOpenVolume;
 
   Status = gBS->InstallProtocolInterface (&ControllerHandle,
                   &gEfiSimpleFileSystemProtocolGuid, EFI_NATIVE_INTERFACE,
                   &VirtioFs->SimpleFs);
   if (EFI_ERROR (Status)) {
-    goto CloseVirtio;
+    goto CloseExitBoot;
   }
 
   return EFI_SUCCESS;
 
+CloseExitBoot:
+  CloseStatus = gBS->CloseEvent (VirtioFs->ExitBoot);
+  ASSERT_EFI_ERROR (CloseStatus);
+
+UninitVirtioFs:
+  VirtioFsUninit (VirtioFs);
+
 CloseVirtio:
   CloseStatus = gBS->CloseProtocol (ControllerHandle,
                        &gVirtioDeviceProtocolGuid, This->DriverBindingHandle,
                        ControllerHandle);
   ASSERT_EFI_ERROR (CloseStatus);
 
 FreeVirtioFs:
   FreePool (VirtioFs);
@@ -128,16 +145,21 @@ VirtioFsBindingStop (
   VirtioFs = VIRTIO_FS_FROM_SIMPLE_FS (SimpleFs);
 
   Status = gBS->UninstallProtocolInterface (ControllerHandle,
                   &gEfiSimpleFileSystemProtocolGuid, SimpleFs);
   if (EFI_ERROR (Status)) {
     return Status;
   }
 
+  Status = gBS->CloseEvent (VirtioFs->ExitBoot);
+  ASSERT_EFI_ERROR (Status);
+
+  VirtioFsUninit (VirtioFs);
+
   Status = gBS->CloseProtocol (ControllerHandle, &gVirtioDeviceProtocolGuid,
                   This->DriverBindingHandle, ControllerHandle);
   ASSERT_EFI_ERROR (Status);
 
   FreePool (VirtioFs);
 
   return EFI_SUCCESS;
 }
diff --git a/OvmfPkg/VirtioFsDxe/Helpers.c b/OvmfPkg/VirtioFsDxe/Helpers.c
new file mode 100644
index 000000000000..7b4906c54184
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/Helpers.c
@@ -0,0 +1,299 @@
+/** @file
+  Initialization and helper routines for the Virtio Filesystem device.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include <Library/VirtioLib.h>           // Virtio10WriteFeatures()
+
+#include "VirtioFsDxe.h"
+
+/**
+  Read the Virtio Filesystem device configuration structure in full.
+
+  @param[in] Virtio   The Virtio protocol underlying the VIRTIO_FS object.
+
+  @param[out] Config  The fully populated VIRTIO_FS_CONFIG structure.
+
+  @retval EFI_SUCCESS  Config has been filled in.
+
+  @return              Error codes propagated from Virtio->ReadDevice(). The
+                       contents of Config are indeterminate.
+**/
+STATIC
+EFI_STATUS
+VirtioFsReadConfig (
+  IN  VIRTIO_DEVICE_PROTOCOL *Virtio,
+  OUT VIRTIO_FS_CONFIG       *Config
+  )
+{
+  UINTN      Idx;
+  EFI_STATUS Status;
+
+  for (Idx = 0; Idx < VIRTIO_FS_TAG_BYTES; Idx++) {
+    Status = Virtio->ReadDevice (
+                       Virtio,                                 // This
+                       OFFSET_OF (VIRTIO_FS_CONFIG, Tag[Idx]), // FieldOffset
+                       sizeof Config->Tag[Idx],                // FieldSize
+                       sizeof Config->Tag[Idx],                // BufferSize
+                       &Config->Tag[Idx]                       // Buffer
+                       );
+    if (EFI_ERROR (Status)) {
+      return Status;
+    }
+  }
+
+  Status = Virtio->ReadDevice (
+                     Virtio,                                     // This
+                     OFFSET_OF (VIRTIO_FS_CONFIG, NumReqQueues), // FieldOffset
+                     sizeof Config->NumReqQueues,                // FieldSize
+                     sizeof Config->NumReqQueues,                // BufferSize
+                     &Config->NumReqQueues                       // Buffer
+                     );
+  return Status;
+}
+
+/**
+  Configure the Virtio Filesystem device underlying VirtioFs.
+
+  @param[in,out] VirtioFs  The VIRTIO_FS object for which Virtio communication
+                           should be set up. On input, the caller is
+                           responsible for VirtioFs->Virtio having been
+                           initialized. On output, synchronous Virtio
+                           Filesystem commands (primitives) may be submitted to
+                           the device.
+
+  @retval EFI_SUCCESS      Virtio machinery has been set up.
+
+  @retval EFI_UNSUPPORTED  The host-side configuration of the Virtio Filesystem
+                           is not supported by this driver.
+
+  @return                  Error codes from underlying functions.
+**/
+EFI_STATUS
+VirtioFsInit (
+  IN OUT VIRTIO_FS *VirtioFs
+  )
+{
+  UINT8            NextDevStat;
+  EFI_STATUS       Status;
+  UINT64           Features;
+  VIRTIO_FS_CONFIG Config;
+  UINTN            Idx;
+  UINT64           RingBaseShift;
+
+  //
+  // Execute virtio-v1.1-cs01-87fa6b5d8155, 3.1.1 Driver Requirements: Device
+  // Initialization.
+  //
+  // 1. Reset the device.
+  //
+  NextDevStat = 0;
+  Status = VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, NextDevStat);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  //
+  // 2. Set the ACKNOWLEDGE status bit [...]
+  //
+  NextDevStat |= VSTAT_ACK;
+  Status = VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, NextDevStat);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  //
+  // 3. Set the DRIVER status bit [...]
+  //
+  NextDevStat |= VSTAT_DRIVER;
+  Status = VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, NextDevStat);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  //
+  // 4. Read device feature bits...
+  //
+  Status = VirtioFs->Virtio->GetDeviceFeatures (VirtioFs->Virtio, &Features);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+  if ((Features & VIRTIO_F_VERSION_1) == 0) {
+    Status = EFI_UNSUPPORTED;
+    goto Failed;
+  }
+  //
+  // No device-specific feature bits have been defined in file "virtio-fs.tex"
+  // of the virtio spec at <https://github.com/oasis-tcs/virtio-spec.git>, as
+  // of commit 87fa6b5d8155.
+  //
+  Features &= VIRTIO_F_VERSION_1 | VIRTIO_F_IOMMU_PLATFORM;
+
+  //
+  // ... and write the subset of feature bits understood by the [...] driver to
+  // the device. [...]
+  // 5. Set the FEATURES_OK status bit.
+  // 6. Re-read device status to ensure the FEATURES_OK bit is still set [...]
+  //
+  Status = Virtio10WriteFeatures (VirtioFs->Virtio, Features, &NextDevStat);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  //
+  // 7. Perform device-specific setup, including discovery of virtqueues for
+  // the device, [...] reading [...] the device's virtio configuration space
+  //
+  Status = VirtioFsReadConfig (VirtioFs->Virtio, &Config);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  //
+  // 7.a. Convert the filesystem label from UTF-8 to UCS-2. Only labels with
+  // printable ASCII code points (U+0020 through U+007E) are supported.
+  // NUL-terminate at either the terminator we find, or right after the
+  // original label.
+  //
+  for (Idx = 0; Idx < VIRTIO_FS_TAG_BYTES && Config.Tag[Idx] != '\0'; Idx++) {
+    if (Config.Tag[Idx] < 0x20 || Config.Tag[Idx] > 0x7E) {
+      Status = EFI_UNSUPPORTED;
+      goto Failed;
+    }
+    VirtioFs->Label[Idx] = Config.Tag[Idx];
+  }
+  VirtioFs->Label[Idx] = L'\0';
+
+  //
+  // 7.b. We need one queue for sending normal priority requests.
+  //
+  if (Config.NumReqQueues < 1) {
+    Status = EFI_UNSUPPORTED;
+    goto Failed;
+  }
+
+  //
+  // 7.c. Fetch and remember the number of descriptors we can place on the
+  // queue at once. We'll need two descriptors per request, as a minimum --
+  // request header, response header.
+  //
+  Status = VirtioFs->Virtio->SetQueueSel (VirtioFs->Virtio,
+                               VIRTIO_FS_REQUEST_QUEUE);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+  Status = VirtioFs->Virtio->GetQueueNumMax (VirtioFs->Virtio,
+                               &VirtioFs->QueueSize);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+  if (VirtioFs->QueueSize < 2) {
+    Status = EFI_UNSUPPORTED;
+    goto Failed;
+  }
+
+  //
+  // 7.d. [...] population of virtqueues [...]
+  //
+  Status = VirtioRingInit (VirtioFs->Virtio, VirtioFs->QueueSize,
+             &VirtioFs->Ring);
+  if (EFI_ERROR (Status)) {
+    goto Failed;
+  }
+
+  Status = VirtioRingMap (VirtioFs->Virtio, &VirtioFs->Ring, &RingBaseShift,
+             &VirtioFs->RingMap);
+  if (EFI_ERROR (Status)) {
+    goto ReleaseQueue;
+  }
+
+  Status = VirtioFs->Virtio->SetQueueAddress (VirtioFs->Virtio,
+                               &VirtioFs->Ring, RingBaseShift);
+  if (EFI_ERROR (Status)) {
+    goto UnmapQueue;
+  }
+
+  //
+  // 8. Set the DRIVER_OK status bit.
+  //
+  NextDevStat |= VSTAT_DRIVER_OK;
+  Status = VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, NextDevStat);
+  if (EFI_ERROR (Status)) {
+    goto UnmapQueue;
+  }
+
+  return EFI_SUCCESS;
+
+UnmapQueue:
+  VirtioFs->Virtio->UnmapSharedBuffer (VirtioFs->Virtio, VirtioFs->RingMap);
+
+ReleaseQueue:
+  VirtioRingUninit (VirtioFs->Virtio, &VirtioFs->Ring);
+
+Failed:
+  //
+  // If any of these steps go irrecoverably wrong, the driver SHOULD set the
+  // FAILED status bit to indicate that it has given up on the device (it can
+  // reset the device later to restart if desired). [...]
+  //
+  // Virtio access failure here should not mask the original error.
+  //
+  NextDevStat |= VSTAT_FAILED;
+  VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, NextDevStat);
+
+  return Status;
+}
+
+/**
+  De-configure the Virtio Filesystem device underlying VirtioFs.
+
+  @param[in] VirtioFs  The VIRTIO_FS object for which Virtio communication
+                       should be torn down. On input, the caller is responsible
+                       for having called VirtioFsInit(). On output, Virtio
+                       Filesystem commands (primitives) must no longer be
+                       submitted to the device.
+**/
+VOID
+VirtioFsUninit (
+  IN OUT VIRTIO_FS *VirtioFs
+  )
+{
+  //
+  // Resetting the Virtio device makes it release its resources and forget its
+  // configuration.
+  //
+  VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, 0);
+  VirtioFs->Virtio->UnmapSharedBuffer (VirtioFs->Virtio, VirtioFs->RingMap);
+  VirtioRingUninit (VirtioFs->Virtio, &VirtioFs->Ring);
+}
+
+/**
+  ExitBootServices event notification function for a Virtio Filesystem object.
+
+  This function resets the VIRTIO_FS.Virtio device, causing it to release all
+  references to guest-side resources. The function may only be called after
+  VirtioFsInit() returns successfully and before VirtioFsUninit() is called.
+
+  @param[in] ExitBootEvent   The VIRTIO_FS.ExitBoot event that has been
+                             signaled.
+
+  @param[in] VirtioFsAsVoid  Pointer to the VIRTIO_FS object, passed in as
+                             (VOID*).
+**/
+VOID
+EFIAPI
+VirtioFsExitBoot (
+  IN EFI_EVENT ExitBootEvent,
+  IN VOID      *VirtioFsAsVoid
+  )
+{
+  VIRTIO_FS *VirtioFs;
+
+  VirtioFs = VirtioFsAsVoid;
+  DEBUG ((DEBUG_VERBOSE, "%a: VirtioFs=0x%p Label=\"%s\"\n", __FUNCTION__,
+    VirtioFsAsVoid, VirtioFs->Label));
+  VirtioFs->Virtio->SetDeviceStatus (VirtioFs->Virtio, 0);
+}
-- 
2.19.1.3.g30247aa5d201



