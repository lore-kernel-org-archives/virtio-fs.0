From: Laszlo Ersek <lersek@redhat.com>
Date: Wed, 16 Dec 2020 22:10:38 +0100
Message-Id: <20201216211125.19496-2-lersek@redhat.com>
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
References: <20201216211125.19496-1-lersek@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [edk2 PATCH 01/48] OvmfPkg: introduce VirtioFsDxe
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

The purpose of the driver is to ease file exchange (file sharing) between
the guest firmware and the virtualization host. The driver is supposed to
interoperate with QEMU's "virtiofsd" (Virtio Filesystem Daemon).

References:
- https://virtio-fs.gitlab.io/
- https://libvirt.org/kbase/virtiofs.html

VirtioFsDxe will bind virtio-fs devices, and produce
EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on them.

In the longer term, assuming QEMU will create "bootorder" fw_cfg file
entries for virtio-fs devices, booting guest OSes from host-side
directories should become possible (dependent on the matching
QemuBootOrderLib enhancement).

Add the skeleton of the driver. Install EFI_DRIVER_BINDING_PROTOCOL with
stub member functions. Install EFI_COMPONENT_NAME2_PROTOCOL with final
member functions. This suffices for the DRIVERS command in the UEFI Shell
to list the driver with a human-readable name.

The file permission model is described immediately in the INF file as a
comment block, for future reference.

Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: Jordan Justen <jordan.l.justen@intel.com>
Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3097
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
---
 OvmfPkg/OvmfPkgIa32.dsc             |   1 +
 OvmfPkg/OvmfPkgIa32X64.dsc          |   1 +
 OvmfPkg/OvmfPkgX64.dsc              |   1 +
 OvmfPkg/OvmfPkgIa32.fdf             |   1 +
 OvmfPkg/OvmfPkgIa32X64.fdf          |   1 +
 OvmfPkg/OvmfPkgX64.fdf              |   1 +
 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf |  92 ++++++++++++++++
 OvmfPkg/VirtioFsDxe/DriverBinding.c | 112 ++++++++++++++++++++
 8 files changed, 210 insertions(+)

diff --git a/OvmfPkg/OvmfPkgIa32.dsc b/OvmfPkg/OvmfPkgIa32.dsc
index 8eede796a8bd..4ff70674fb6e 100644
--- a/OvmfPkg/OvmfPkgIa32.dsc
+++ b/OvmfPkg/OvmfPkgIa32.dsc
@@ -807,16 +807,17 @@ [Components]
   }
   MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
   MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
   MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   FatPkg/EnhancedFatDxe/Fat.inf
   MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
   OvmfPkg/SataControllerDxe/SataControllerDxe.inf
   MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
   MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
   MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
   MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
   MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
diff --git a/OvmfPkg/OvmfPkgIa32X64.dsc b/OvmfPkg/OvmfPkgIa32X64.dsc
index f9f82a48f4b9..d40a59183c79 100644
--- a/OvmfPkg/OvmfPkgIa32X64.dsc
+++ b/OvmfPkg/OvmfPkgIa32X64.dsc
@@ -821,16 +821,17 @@ [Components.X64]
   }
   MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
   MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
   MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   FatPkg/EnhancedFatDxe/Fat.inf
   MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
   OvmfPkg/SataControllerDxe/SataControllerDxe.inf
   MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
   MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
   MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
   MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
   MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
diff --git a/OvmfPkg/OvmfPkgX64.dsc b/OvmfPkg/OvmfPkgX64.dsc
index e59ae05b73aa..ec7886235acf 100644
--- a/OvmfPkg/OvmfPkgX64.dsc
+++ b/OvmfPkg/OvmfPkgX64.dsc
@@ -817,16 +817,17 @@ [Components]
   }
   MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
   MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
   MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
   MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
   MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.inf
   FatPkg/EnhancedFatDxe/Fat.inf
   MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
   MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
   OvmfPkg/SataControllerDxe/SataControllerDxe.inf
   MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
   MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
   MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
   MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
   MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
diff --git a/OvmfPkg/OvmfPkgIa32.fdf b/OvmfPkg/OvmfPkgIa32.fdf
index c07b775d0a2d..f400c845b9c9 100644
--- a/OvmfPkg/OvmfPkgIa32.fdf
+++ b/OvmfPkg/OvmfPkgIa32.fdf
@@ -285,16 +285,17 @@ [FV.DXEFV]
 INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
 INF  RuleOverride=ACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
 INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecutorDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
 
 INF  FatPkg/EnhancedFatDxe/Fat.inf
 INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
 !if $(TOOL_CHAIN_TAG) != "XCODE5"
 INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
 INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
 INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCommand.inf
 !endif
 INF  ShellPkg/Application/Shell/Shell.inf
 
diff --git a/OvmfPkg/OvmfPkgIa32X64.fdf b/OvmfPkg/OvmfPkgIa32X64.fdf
index 9adf1525c135..d055552fd09f 100644
--- a/OvmfPkg/OvmfPkgIa32X64.fdf
+++ b/OvmfPkg/OvmfPkgIa32X64.fdf
@@ -286,16 +286,17 @@ [FV.DXEFV]
 INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
 INF  RuleOverride=ACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
 INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecutorDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
 
 INF  FatPkg/EnhancedFatDxe/Fat.inf
 INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
 !if $(TOOL_CHAIN_TAG) != "XCODE5"
 INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
 INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
 INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCommand.inf
 !endif
 INF  ShellPkg/Application/Shell/Shell.inf
 
diff --git a/OvmfPkg/OvmfPkgX64.fdf b/OvmfPkg/OvmfPkgX64.fdf
index 17ba9e177ac3..1a2ef5bf2ae3 100644
--- a/OvmfPkg/OvmfPkgX64.fdf
+++ b/OvmfPkg/OvmfPkgX64.fdf
@@ -295,16 +295,17 @@ [FV.DXEFV]
 INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
 INF  RuleOverride=ACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
 INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecutorDxe.inf
 INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
 
 INF  FatPkg/EnhancedFatDxe/Fat.inf
 INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
+INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
 
 !if $(TOOL_CHAIN_TAG) != "XCODE5"
 INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
 INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
 INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCommand.inf
 !endif
 INF  ShellPkg/Application/Shell/Shell.inf
 
diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
new file mode 100644
index 000000000000..69cb44bc7c96
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
@@ -0,0 +1,92 @@
+## @file
+# Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devices.
+#
+# Copyright (C) 2020, Red Hat, Inc.
+#
+# SPDX-License-Identifier: BSD-2-Clause-Patent
+#
+#
+# Permission Model of this driver:
+#
+# Regardless of the UID and GID values this driver send in the FUSE request
+# header, the daemon (that is, the Virtio Filesystem device) always acts with
+# root privileges on the host side. The only time the daemon considers said UID
+# and GID fields is when creating a new file or directory. Thus, the guest
+# driver cannot rely on the host for enforcing any file mode permissions,
+# regardless of the "personality" that the guest driver poses as, because
+# "root" on the host side ignores all file mode bits.
+#
+# Therefore the guest driver has to do its own permission checking, and use the
+# host-side file mode bits only as a kind of "metadata storage" or "reminder"
+# -- hopefully in a way that makes some sense on the host side too.
+#
+# The complete mapping between the EFI_FILE_PROTOCOL and the host-side file
+# mode bits is described below.
+#
+# - The guest driver poses as UID 0, GID 0, PID 1.
+#
+# - If and only if all "w" bits are missing from a file on the host side, then
+#   the file or directory is reported as EFI_FILE_READ_ONLY in the guest. When
+#   setting EFI_FILE_READ_ONLY in the guest, all "w" bits (0222) are cleared on
+#   the host; when clearing EFI_FILE_READ_ONLY in the guest, all "w" bits are
+#   set on the host. Viewed from the host side, this sort of reflects that an
+#   EFI_FILE_READ_ONLY file should not be written by anyone.
+#
+# - The attributes EFI_FILE_HIDDEN, EFI_FILE_SYSTEM, EFI_FILE_RESERVED, and
+#   EFI_FILE_ARCHIVE are never reported in the guest, and they are silently
+#   ignored when a SetInfo() call or a file-creating Open() call requests them.
+#
+# - On the host, files are created with 0666 file mode bits, directories are
+#   created with 0777 file mode bits.
+#
+# - In the guest, the EFI_FILE_READ_ONLY attribute only controls the permitted
+#   open mode. In particular, on directories, the EFI_FILE_READ_ONLY attribute
+#   does not prevent the creation or deletion of entries inside the directory;
+#   EFI_FILE_READ_ONLY only prevents the renaming, deleting, flushing (syncing)
+#   and touching of the directory itself (with "touching" meaning updating the
+#   timestamps). The fact that EFI_FILE_READ_ONLY being set on a directory is
+#   irrelevant in the guest with regard to entry creation/deletion, is
+#   well-mirrored by the fact that virtiofsd -- which runs as root, regardless
+#   of guest driver personality -- ignores the absence of "w" permissions on a
+#   host-side directory, when creating or removing entries in it.
+#
+# - When an EFI_FILE_PROTOCOL is opened read-only, then the Delete(), Write()
+#   and Flush() member functions are disabled for it. Additionally, SetInfo()
+#   is restricted to flipping the EFI_FILE_READ_ONLY bit (which takes effect at
+#   the next Open()).
+#
+# - As a consequence of the above, for deleting a directory, it must be
+#   presented in the guest as openable for writing.
+#
+# - We diverge from the UEFI spec, and permit Flush() on a directory that has
+#   been opened read-write; otherwise the only way to invoke FUSE_FSYNCDIR on a
+#   directory would be to Close() it.
+#
+# - OpenVolume() opens the root directory for read-only access. The Open()
+#   member function may open it for read-write access. While the root directory
+#   cannot be renamed or deleted, opening it for read-write access is useful
+#   for calling Flush(), according to the previous paragraph, or for updating
+#   the root directory's timestamps with SetInfo().
+##
+
+[Defines]
+  INF_VERSION                           = 1.29
+  BASE_NAME                             = VirtioFsDxe
+  FILE_GUID                             = 7BD9DDF7-8B83-488E-AEC9-24C78610289C
+  MODULE_TYPE                           = UEFI_DRIVER
+  ENTRY_POINT                           = VirtioFsEntryPoint
+
+[Packages]
+  MdePkg/MdePkg.dec
+
+[Sources]
+  DriverBinding.c
+
+[LibraryClasses]
+  BaseLib
+  UefiBootServicesTableLib
+  UefiDriverEntryPoint
+
+[Protocols]
+  gEfiComponentName2ProtocolGuid        ## PRODUCES
+  gEfiDriverBindingProtocolGuid         ## PRODUCES
diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/DriverBinding.c
new file mode 100644
index 000000000000..ac0a6330f01b
--- /dev/null
+++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
@@ -0,0 +1,112 @@
+/** @file
+  Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devices.
+
+  Copyright (C) 2020, Red Hat, Inc.
+
+  SPDX-License-Identifier: BSD-2-Clause-Patent
+**/
+
+#include <Library/BaseLib.h>                  // AsciiStrCmp()
+#include <Library/UefiBootServicesTableLib.h> // gBS
+#include <Protocol/ComponentName2.h>          // EFI_COMPONENT_NAME2_PROTOCOL
+#include <Protocol/DriverBinding.h>           // EFI_DRIVER_BINDING_PROTOCOL
+
+//
+// UEFI Driver Model protocol instances.
+//
+STATIC EFI_DRIVER_BINDING_PROTOCOL  mDriverBinding;
+STATIC EFI_COMPONENT_NAME2_PROTOCOL mComponentName2;
+
+//
+// UEFI Driver Model protocol member functions.
+//
+EFI_STATUS
+EFIAPI
+VirtioFsBindingSupported (
+  IN EFI_DRIVER_BINDING_PROTOCOL *This,
+  IN EFI_HANDLE                  ControllerHandle,
+  IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
+  )
+{
+  return EFI_UNSUPPORTED;
+}
+
+EFI_STATUS
+EFIAPI
+VirtioFsBindingStart (
+  IN EFI_DRIVER_BINDING_PROTOCOL *This,
+  IN EFI_HANDLE                  ControllerHandle,
+  IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
+  )
+{
+  return EFI_DEVICE_ERROR;
+}
+
+EFI_STATUS
+EFIAPI
+VirtioFsBindingStop (
+  IN EFI_DRIVER_BINDING_PROTOCOL *This,
+  IN EFI_HANDLE                  ControllerHandle,
+  IN UINTN                       NumberOfChildren,
+  IN EFI_HANDLE                  *ChildHandleBuffer OPTIONAL
+  )
+{
+  return EFI_DEVICE_ERROR;
+}
+
+EFI_STATUS
+EFIAPI
+VirtioFsGetDriverName (
+  IN  EFI_COMPONENT_NAME2_PROTOCOL *This,
+  IN  CHAR8                        *Language,
+  OUT CHAR16                       **DriverName
+  )
+{
+  if (AsciiStrCmp (Language, "en") != 0) {
+    return EFI_UNSUPPORTED;
+  }
+  *DriverName = L"Virtio Filesystem Driver";
+  return EFI_SUCCESS;
+}
+
+EFI_STATUS
+EFIAPI
+VirtioFsGetControllerName (
+  IN  EFI_COMPONENT_NAME2_PROTOCOL *This,
+  IN  EFI_HANDLE                   ControllerHandle,
+  IN  EFI_HANDLE                   ChildHandle OPTIONAL,
+  IN  CHAR8                        *Language,
+  OUT CHAR16                       **ControllerName
+  )
+{
+  return EFI_UNSUPPORTED;
+}
+
+//
+// Entry point of this driver.
+//
+EFI_STATUS
+EFIAPI
+VirtioFsEntryPoint (
+  IN EFI_HANDLE       ImageHandle,
+  IN EFI_SYSTEM_TABLE *SystemTable
+  )
+{
+  EFI_STATUS Status;
+
+  mDriverBinding.Supported           = VirtioFsBindingSupported;
+  mDriverBinding.Start               = VirtioFsBindingStart;
+  mDriverBinding.Stop                = VirtioFsBindingStop;
+  mDriverBinding.Version             = 0x10;
+  mDriverBinding.ImageHandle         = ImageHandle;
+  mDriverBinding.DriverBindingHandle = ImageHandle;
+
+  mComponentName2.GetDriverName      = VirtioFsGetDriverName;
+  mComponentName2.GetControllerName  = VirtioFsGetControllerName;
+  mComponentName2.SupportedLanguages = "en";
+
+  Status = gBS->InstallMultipleProtocolInterfaces (&ImageHandle,
+                  &gEfiDriverBindingProtocolGuid, &mDriverBinding,
+                  &gEfiComponentName2ProtocolGuid, &mComponentName2, NULL);
+  return Status;
+}
-- 
2.19.1.3.g30247aa5d201



