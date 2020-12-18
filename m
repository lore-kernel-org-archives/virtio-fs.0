Date: Fri, 18 Dec 2020 18:13:35 +0000
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <20201218181335.GG2956@work-vm>
References: <20201216211125.19496-1-lersek@redhat.com>
	<20201216211125.19496-2-lersek@redhat.com>
	<57ec49d2-1540-f693-23ef-12a0cf217a81@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <57ec49d2-1540-f693-23ef-12a0cf217a81@arm.com>
Subject: Re: [Virtio-fs] [edk2 PATCH 01/48] OvmfPkg: introduce VirtioFsDxe
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc: virtio-fs@redhat.com, Jordan Justen <jordan.l.justen@intel.com>, devel@edk2.groups.io, Laszlo Ersek <lersek@redhat.com>, Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@redhat.com>

* Ard Biesheuvel (ard.biesheuvel@arm.com) wrote:
> On 12/16/20 10:10 PM, Laszlo Ersek wrote:
> > The purpose of the driver is to ease file exchange (file sharing) betwe=
en
> > the guest firmware and the virtualization host. The driver is supposed =
to
> > interoperate with QEMU's "virtiofsd" (Virtio Filesystem Daemon).
> >=20
> > References:
> > - https://virtio-fs.gitlab.io/
> > - https://libvirt.org/kbase/virtiofs.html
> >=20
> > VirtioFsDxe will bind virtio-fs devices, and produce
> > EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on them.
> >=20
> > In the longer term, assuming QEMU will create "bootorder" fw_cfg file
> > entries for virtio-fs devices, booting guest OSes from host-side
> > directories should become possible (dependent on the matching
> > QemuBootOrderLib enhancement).
> >=20
> > Add the skeleton of the driver. Install EFI_DRIVER_BINDING_PROTOCOL with
> > stub member functions. Install EFI_COMPONENT_NAME2_PROTOCOL with final
> > member functions. This suffices for the DRIVERS command in the UEFI She=
ll
> > to list the driver with a human-readable name.
> >=20
> > The file permission model is described immediately in the INF file as a
> > comment block, for future reference.
> >=20
> > Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
> > Cc: Jordan Justen <jordan.l.justen@intel.com>
> > Cc: Philippe Mathieu-Daud=E9 <philmd@redhat.com>
> > Ref: https://bugzilla.tianocore.org/show_bug.cgi?id=3D3097
> > Signed-off-by: Laszlo Ersek <lersek@redhat.com>
> > ---
> >  OvmfPkg/OvmfPkgIa32.dsc             |   1 +
> >  OvmfPkg/OvmfPkgIa32X64.dsc          |   1 +
> >  OvmfPkg/OvmfPkgX64.dsc              |   1 +
> >  OvmfPkg/OvmfPkgIa32.fdf             |   1 +
> >  OvmfPkg/OvmfPkgIa32X64.fdf          |   1 +
> >  OvmfPkg/OvmfPkgX64.fdf              |   1 +
> >  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf |  92 ++++++++++++++++
> >  OvmfPkg/VirtioFsDxe/DriverBinding.c | 112 ++++++++++++++++++++
> >  8 files changed, 210 insertions(+)
> >=20
> > diff --git a/OvmfPkg/OvmfPkgIa32.dsc b/OvmfPkg/OvmfPkgIa32.dsc
> > index 8eede796a8bd..4ff70674fb6e 100644
> > --- a/OvmfPkg/OvmfPkgIa32.dsc
> > +++ b/OvmfPkg/OvmfPkgIa32.dsc
> > @@ -807,16 +807,17 @@ [Components]
> >    }
> >    MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
> >    MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
> >    MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
> >    MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
> >    MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.i=
nf
> >    FatPkg/EnhancedFatDxe/Fat.inf
> >    MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
> >    OvmfPkg/SataControllerDxe/SataControllerDxe.inf
> >    MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
> >    MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
> >    MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
> >    MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
> >    MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
> > diff --git a/OvmfPkg/OvmfPkgIa32X64.dsc b/OvmfPkg/OvmfPkgIa32X64.dsc
> > index f9f82a48f4b9..d40a59183c79 100644
> > --- a/OvmfPkg/OvmfPkgIa32X64.dsc
> > +++ b/OvmfPkg/OvmfPkgIa32X64.dsc
> > @@ -821,16 +821,17 @@ [Components.X64]
> >    }
> >    MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
> >    MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
> >    MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
> >    MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
> >    MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.i=
nf
> >    FatPkg/EnhancedFatDxe/Fat.inf
> >    MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
> >    OvmfPkg/SataControllerDxe/SataControllerDxe.inf
> >    MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
> >    MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
> >    MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
> >    MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
> >    MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
> > diff --git a/OvmfPkg/OvmfPkgX64.dsc b/OvmfPkg/OvmfPkgX64.dsc
> > index e59ae05b73aa..ec7886235acf 100644
> > --- a/OvmfPkg/OvmfPkgX64.dsc
> > +++ b/OvmfPkg/OvmfPkgX64.dsc
> > @@ -817,16 +817,17 @@ [Components]
> >    }
> >    MdeModulePkg/Universal/PrintDxe/PrintDxe.inf
> >    MdeModulePkg/Universal/Disk/DiskIoDxe/DiskIoDxe.inf
> >    MdeModulePkg/Universal/Disk/PartitionDxe/PartitionDxe.inf
> >    MdeModulePkg/Universal/Disk/RamDiskDxe/RamDiskDxe.inf
> >    MdeModulePkg/Universal/Disk/UnicodeCollation/EnglishDxe/EnglishDxe.i=
nf
> >    FatPkg/EnhancedFatDxe/Fat.inf
> >    MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
> >    MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf
> >    OvmfPkg/SataControllerDxe/SataControllerDxe.inf
> >    MdeModulePkg/Bus/Ata/AtaAtapiPassThru/AtaAtapiPassThru.inf
> >    MdeModulePkg/Bus/Ata/AtaBusDxe/AtaBusDxe.inf
> >    MdeModulePkg/Bus/Pci/NvmExpressDxe/NvmExpressDxe.inf
> >    MdeModulePkg/Universal/HiiDatabaseDxe/HiiDatabaseDxe.inf
> >    MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
> > diff --git a/OvmfPkg/OvmfPkgIa32.fdf b/OvmfPkg/OvmfPkgIa32.fdf
> > index c07b775d0a2d..f400c845b9c9 100644
> > --- a/OvmfPkg/OvmfPkgIa32.fdf
> > +++ b/OvmfPkg/OvmfPkgIa32.fdf
> > @@ -285,16 +285,17 @@ [FV.DXEFV]
> >  INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
> >  INF  RuleOverride=3DACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
> >  INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecu=
torDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGrap=
hicsResourceTableDxe.inf
> > =20
> >  INF  FatPkg/EnhancedFatDxe/Fat.inf
> >  INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> > =20
> >  !if $(TOOL_CHAIN_TAG) !=3D "XCODE5"
> >  INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
> >  INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
> >  INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCom=
mand.inf
> >  !endif
> >  INF  ShellPkg/Application/Shell/Shell.inf
> > =20
> > diff --git a/OvmfPkg/OvmfPkgIa32X64.fdf b/OvmfPkg/OvmfPkgIa32X64.fdf
> > index 9adf1525c135..d055552fd09f 100644
> > --- a/OvmfPkg/OvmfPkgIa32X64.fdf
> > +++ b/OvmfPkg/OvmfPkgIa32X64.fdf
> > @@ -286,16 +286,17 @@ [FV.DXEFV]
> >  INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
> >  INF  RuleOverride=3DACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
> >  INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecu=
torDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGrap=
hicsResourceTableDxe.inf
> > =20
> >  INF  FatPkg/EnhancedFatDxe/Fat.inf
> >  INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> > =20
> >  !if $(TOOL_CHAIN_TAG) !=3D "XCODE5"
> >  INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
> >  INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
> >  INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCom=
mand.inf
> >  !endif
> >  INF  ShellPkg/Application/Shell/Shell.inf
> > =20
> > diff --git a/OvmfPkg/OvmfPkgX64.fdf b/OvmfPkg/OvmfPkgX64.fdf
> > index 17ba9e177ac3..1a2ef5bf2ae3 100644
> > --- a/OvmfPkg/OvmfPkgX64.fdf
> > +++ b/OvmfPkg/OvmfPkgX64.fdf
> > @@ -295,16 +295,17 @@ [FV.DXEFV]
> >  INF  OvmfPkg/AcpiPlatformDxe/AcpiPlatformDxe.inf
> >  INF  RuleOverride=3DACPITABLE OvmfPkg/AcpiTables/AcpiTables.inf
> >  INF  MdeModulePkg/Universal/Acpi/S3SaveStateDxe/S3SaveStateDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootScriptExecutorDxe/BootScriptExecu=
torDxe.inf
> >  INF  MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGrap=
hicsResourceTableDxe.inf
> > =20
> >  INF  FatPkg/EnhancedFatDxe/Fat.inf
> >  INF  MdeModulePkg/Universal/Disk/UdfDxe/UdfDxe.inf
> > +INF  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> > =20
> >  !if $(TOOL_CHAIN_TAG) !=3D "XCODE5"
> >  INF  ShellPkg/DynamicCommand/TftpDynamicCommand/TftpDynamicCommand.inf
> >  INF  ShellPkg/DynamicCommand/HttpDynamicCommand/HttpDynamicCommand.inf
> >  INF  OvmfPkg/LinuxInitrdDynamicShellCommand/LinuxInitrdDynamicShellCom=
mand.inf
> >  !endif
> >  INF  ShellPkg/Application/Shell/Shell.inf
> > =20
> > diff --git a/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf b/OvmfPkg/VirtioFsDxe/=
VirtioFsDxe.inf
> > new file mode 100644
> > index 000000000000..69cb44bc7c96
> > --- /dev/null
> > +++ b/OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> > @@ -0,0 +1,92 @@
> > +## @file
> > +# Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devic=
es.
> > +#
> > +# Copyright (C) 2020, Red Hat, Inc.
> > +#
> > +# SPDX-License-Identifier: BSD-2-Clause-Patent
> > +#
> > +#
> > +# Permission Model of this driver:
> > +#
> > +# Regardless of the UID and GID values this driver send in the FUSE re=
quest
> > +# header, the daemon (that is, the Virtio Filesystem device) always ac=
ts with
> > +# root privileges on the host side. The only time the daemon considers=
 said UID
> > +# and GID fields is when creating a new file or directory. Thus, the g=
uest
> > +# driver cannot rely on the host for enforcing any file mode permissio=
ns,
> > +# regardless of the "personality" that the guest driver poses as, beca=
use
> > +# "root" on the host side ignores all file mode bits.
> > +#
> > +# Therefore the guest driver has to do its own permission checking, an=
d use the
> > +# host-side file mode bits only as a kind of "metadata storage" or "re=
minder"
> > +# -- hopefully in a way that makes some sense on the host side too.
> > +#
>=20
> Can you please explain why this is safe? Or should virtio-fs only be
> used with guests that can be trusted with root privileges on the host?

The daemon sandboxes itself and generally you only expose a private area
of a filesystem to the guest; i.e. a per-guest rootfs or temporary or
whatever.

Dave
> --=20
> Ard.
>=20
>=20
>=20
> > +# The complete mapping between the EFI_FILE_PROTOCOL and the host-side=
 file
> > +# mode bits is described below.
> > +#
> > +# - The guest driver poses as UID 0, GID 0, PID 1.
> > +#
> > +# - If and only if all "w" bits are missing from a file on the host si=
de, then
> > +#   the file or directory is reported as EFI_FILE_READ_ONLY in the gue=
st. When
> > +#   setting EFI_FILE_READ_ONLY in the guest, all "w" bits (0222) are c=
leared on
> > +#   the host; when clearing EFI_FILE_READ_ONLY in the guest, all "w" b=
its are
> > +#   set on the host. Viewed from the host side, this sort of reflects =
that an
> > +#   EFI_FILE_READ_ONLY file should not be written by anyone.
> > +#
> > +# - The attributes EFI_FILE_HIDDEN, EFI_FILE_SYSTEM, EFI_FILE_RESERVED=
, and
> > +#   EFI_FILE_ARCHIVE are never reported in the guest, and they are sil=
ently
> > +#   ignored when a SetInfo() call or a file-creating Open() call reque=
sts them.
> > +#
> > +# - On the host, files are created with 0666 file mode bits, directori=
es are
> > +#   created with 0777 file mode bits.
> > +#
> > +# - In the guest, the EFI_FILE_READ_ONLY attribute only controls the p=
ermitted
> > +#   open mode. In particular, on directories, the EFI_FILE_READ_ONLY a=
ttribute
> > +#   does not prevent the creation or deletion of entries inside the di=
rectory;
> > +#   EFI_FILE_READ_ONLY only prevents the renaming, deleting, flushing =
(syncing)
> > +#   and touching of the directory itself (with "touching" meaning upda=
ting the
> > +#   timestamps). The fact that EFI_FILE_READ_ONLY being set on a direc=
tory is
> > +#   irrelevant in the guest with regard to entry creation/deletion, is
> > +#   well-mirrored by the fact that virtiofsd -- which runs as root, re=
gardless
> > +#   of guest driver personality -- ignores the absence of "w" permissi=
ons on a
> > +#   host-side directory, when creating or removing entries in it.
> > +#
> > +# - When an EFI_FILE_PROTOCOL is opened read-only, then the Delete(), =
Write()
> > +#   and Flush() member functions are disabled for it. Additionally, Se=
tInfo()
> > +#   is restricted to flipping the EFI_FILE_READ_ONLY bit (which takes =
effect at
> > +#   the next Open()).
> > +#
> > +# - As a consequence of the above, for deleting a directory, it must be
> > +#   presented in the guest as openable for writing.
> > +#
> > +# - We diverge from the UEFI spec, and permit Flush() on a directory t=
hat has
> > +#   been opened read-write; otherwise the only way to invoke FUSE_FSYN=
CDIR on a
> > +#   directory would be to Close() it.
> > +#
> > +# - OpenVolume() opens the root directory for read-only access. The Op=
en()
> > +#   member function may open it for read-write access. While the root =
directory
> > +#   cannot be renamed or deleted, opening it for read-write access is =
useful
> > +#   for calling Flush(), according to the previous paragraph, or for u=
pdating
> > +#   the root directory's timestamps with SetInfo().
> > +##
> > +
> > +[Defines]
> > +  INF_VERSION                           =3D 1.29
> > +  BASE_NAME                             =3D VirtioFsDxe
> > +  FILE_GUID                             =3D 7BD9DDF7-8B83-488E-AEC9-24=
C78610289C
> > +  MODULE_TYPE                           =3D UEFI_DRIVER
> > +  ENTRY_POINT                           =3D VirtioFsEntryPoint
> > +
> > +[Packages]
> > +  MdePkg/MdePkg.dec
> > +
> > +[Sources]
> > +  DriverBinding.c
> > +
> > +[LibraryClasses]
> > +  BaseLib
> > +  UefiBootServicesTableLib
> > +  UefiDriverEntryPoint
> > +
> > +[Protocols]
> > +  gEfiComponentName2ProtocolGuid        ## PRODUCES
> > +  gEfiDriverBindingProtocolGuid         ## PRODUCES
> > diff --git a/OvmfPkg/VirtioFsDxe/DriverBinding.c b/OvmfPkg/VirtioFsDxe/=
DriverBinding.c
> > new file mode 100644
> > index 000000000000..ac0a6330f01b
> > --- /dev/null
> > +++ b/OvmfPkg/VirtioFsDxe/DriverBinding.c
> > @@ -0,0 +1,112 @@
> > +/** @file
> > +  Provide EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instances on virtio-fs devic=
es.
> > +
> > +  Copyright (C) 2020, Red Hat, Inc.
> > +
> > +  SPDX-License-Identifier: BSD-2-Clause-Patent
> > +**/
> > +
> > +#include <Library/BaseLib.h>                  // AsciiStrCmp()
> > +#include <Library/UefiBootServicesTableLib.h> // gBS
> > +#include <Protocol/ComponentName2.h>          // EFI_COMPONENT_NAME2_P=
ROTOCOL
> > +#include <Protocol/DriverBinding.h>           // EFI_DRIVER_BINDING_PR=
OTOCOL
> > +
> > +//
> > +// UEFI Driver Model protocol instances.
> > +//
> > +STATIC EFI_DRIVER_BINDING_PROTOCOL  mDriverBinding;
> > +STATIC EFI_COMPONENT_NAME2_PROTOCOL mComponentName2;
> > +
> > +//
> > +// UEFI Driver Model protocol member functions.
> > +//
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsBindingSupported (
> > +  IN EFI_DRIVER_BINDING_PROTOCOL *This,
> > +  IN EFI_HANDLE                  ControllerHandle,
> > +  IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
> > +  )
> > +{
> > +  return EFI_UNSUPPORTED;
> > +}
> > +
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsBindingStart (
> > +  IN EFI_DRIVER_BINDING_PROTOCOL *This,
> > +  IN EFI_HANDLE                  ControllerHandle,
> > +  IN EFI_DEVICE_PATH_PROTOCOL    *RemainingDevicePath OPTIONAL
> > +  )
> > +{
> > +  return EFI_DEVICE_ERROR;
> > +}
> > +
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsBindingStop (
> > +  IN EFI_DRIVER_BINDING_PROTOCOL *This,
> > +  IN EFI_HANDLE                  ControllerHandle,
> > +  IN UINTN                       NumberOfChildren,
> > +  IN EFI_HANDLE                  *ChildHandleBuffer OPTIONAL
> > +  )
> > +{
> > +  return EFI_DEVICE_ERROR;
> > +}
> > +
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsGetDriverName (
> > +  IN  EFI_COMPONENT_NAME2_PROTOCOL *This,
> > +  IN  CHAR8                        *Language,
> > +  OUT CHAR16                       **DriverName
> > +  )
> > +{
> > +  if (AsciiStrCmp (Language, "en") !=3D 0) {
> > +    return EFI_UNSUPPORTED;
> > +  }
> > +  *DriverName =3D L"Virtio Filesystem Driver";
> > +  return EFI_SUCCESS;
> > +}
> > +
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsGetControllerName (
> > +  IN  EFI_COMPONENT_NAME2_PROTOCOL *This,
> > +  IN  EFI_HANDLE                   ControllerHandle,
> > +  IN  EFI_HANDLE                   ChildHandle OPTIONAL,
> > +  IN  CHAR8                        *Language,
> > +  OUT CHAR16                       **ControllerName
> > +  )
> > +{
> > +  return EFI_UNSUPPORTED;
> > +}
> > +
> > +//
> > +// Entry point of this driver.
> > +//
> > +EFI_STATUS
> > +EFIAPI
> > +VirtioFsEntryPoint (
> > +  IN EFI_HANDLE       ImageHandle,
> > +  IN EFI_SYSTEM_TABLE *SystemTable
> > +  )
> > +{
> > +  EFI_STATUS Status;
> > +
> > +  mDriverBinding.Supported           =3D VirtioFsBindingSupported;
> > +  mDriverBinding.Start               =3D VirtioFsBindingStart;
> > +  mDriverBinding.Stop                =3D VirtioFsBindingStop;
> > +  mDriverBinding.Version             =3D 0x10;
> > +  mDriverBinding.ImageHandle         =3D ImageHandle;
> > +  mDriverBinding.DriverBindingHandle =3D ImageHandle;
> > +
> > +  mComponentName2.GetDriverName      =3D VirtioFsGetDriverName;
> > +  mComponentName2.GetControllerName  =3D VirtioFsGetControllerName;
> > +  mComponentName2.SupportedLanguages =3D "en";
> > +
> > +  Status =3D gBS->InstallMultipleProtocolInterfaces (&ImageHandle,
> > +                  &gEfiDriverBindingProtocolGuid, &mDriverBinding,
> > +                  &gEfiComponentName2ProtocolGuid, &mComponentName2, N=
ULL);
> > +  return Status;
> > +}
> >=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

