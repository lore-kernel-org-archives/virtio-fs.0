References: <20201216211125.19496-1-lersek@redhat.com>
From: Ard Biesheuvel <ard.biesheuvel@arm.com>
Message-ID: <f307b0a1-a885-4379-15f3-a3ac1a5f2a5d@arm.com>
Date: Fri, 18 Dec 2020 18:44:20 +0100
MIME-Version: 1.0
In-Reply-To: <20201216211125.19496-1-lersek@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [edk2 PATCH 00/48] ArmVirtPkg,
	OvmfPkg: virtio filesystem driver
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Laszlo Ersek <lersek@redhat.com>, devel@edk2.groups.io, virtio-fs@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, Leif Lindholm <leif@nuviainc.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>

On 12/16/20 10:10 PM, Laszlo Ersek wrote:
> Ref:    https://bugzilla.tianocore.org/show_bug.cgi?id=3097
> Repo:   https://pagure.io/lersek/edk2.git
> Branch: virtio-fs (@ b8fd76d649d2)
> 
> The first commit and the bugzilla ticket state the use case.
> 
> References, including setup instructions:
> - https://libvirt.org/kbase/virtiofs.html
> - https://virtio-fs.gitlab.io/
> 
> Useful UEFI shell commands for testing: output redirections, attrib,
> connect, cp, disconnect, edit, eficompress, efidecompress, hexedit, ls,
> map, mkdir, mv, rm, setsize, timezone, touch, type, vol.
> 
> The series is largely structured as follows:
> - helper functions and FUSE command wrappers are implemented as required
>   by the next EFI_FILE_PROTOCOL interface,
> - said EFI_FILE_PROTOCOL interface is implemented,
> - lather, rinse, repeat.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
> Cc: Jordan Justen <jordan.l.justen@intel.com>
> Cc: Leif Lindholm <leif@nuviainc.com>
> Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
> 
> Thanks,
> Laszlo
> 
> Laszlo Ersek (48):
>   OvmfPkg: introduce VirtioFsDxe
>   ArmVirtPkg: include VirtioFsDxe in the ArmVirtQemu* platforms
>   OvmfPkg/VirtioFsDxe: DriverBinding: open VirtioDevice, install
>     SimpleFs
>   OvmfPkg/VirtioFsDxe: implement virtio device (un)initialization
>   OvmfPkg/VirtioFsDxe: add a scatter-gather list data type
>   OvmfPkg/VirtioFsDxe: introduce the basic FUSE request/response headers
>   OvmfPkg/VirtioFsDxe: map "errno" values to EFI_STATUS
>   OvmfPkg/VirtioFsDxe: submit the FUSE_INIT request to the device
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_OPENDIR
>   OvmfPkg/VirtioFsDxe: add shared wrapper for FUSE_RELEASE /
>     FUSE_RELEASEDIR
>   OvmfPkg/VirtioFsDxe: implement
>     EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume()
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_FORGET
>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_FSYNC /
>     FUSE_FSYNCDIR
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_FLUSH
>   OvmfPkg/VirtioFsDxe: flush, sync, release and forget in Close() /
>     Delete()
>   OvmfPkg/VirtioFsDxe: add helper for appending and sanitizing paths
>   OvmfPkg/VirtioFsDxe: manage path lifecycle in OpenVolume, Close,
>     Delete
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_OPEN
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_MKDIR
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_CREATE
>   OvmfPkg/VirtioFsDxe: convert FUSE inode attributes to EFI_FILE_INFO
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_LOOKUP
>   OvmfPkg/VirtioFsDxe: split canon. path into last parent + last
>     component
>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_UNLINK / FUSE_RMDIR
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_GETATTR
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Open()
>   OvmfPkg/VirtioFsDxe: erase the dir. entry in
>     EFI_FILE_PROTOCOL.Delete()
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_STATFS
>   OvmfPkg/VirtioFsDxe: add helper for formatting UEFI basenames
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.GetInfo()
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.GetPosition,
>     .SetPosition
>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_READ /
>     FUSE_READDIRPLUS
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Read() for regular
>     files
>   OvmfPkg/VirtioFsDxe: convert FUSE dirent filename to EFI_FILE_INFO
>   OvmfPkg/VirtioFsDxe: add EFI_FILE_INFO cache fields to VIRTIO_FS_FILE
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Read() for
>     directories
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Flush()
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_WRITE
>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Write()
>   OvmfPkg/VirtioFsDxe: handle the volume label in
>     EFI_FILE_PROTOCOL.SetInfo
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_RENAME2
>   OvmfPkg/VirtioFsDxe: add helper for composing rename/move destination
>     path
>   OvmfPkg/VirtioFsDxe: handle file rename/move in
>     EFI_FILE_PROTOCOL.SetInfo
>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_SETATTR
>   OvmfPkg/VirtioFsDxe: add helper for determining file size update
>   OvmfPkg/VirtioFsDxe: add helper for determining access time updates
>   OvmfPkg/VirtioFsDxe: add helper for determining file mode bits update
>   OvmfPkg/VirtioFsDxe: handle attribute updates in
>     EFI_FILE_PROTOCOL.SetInfo
> 

This looks carefully crafted, and modulo my two questions, I won't be
able to spend more time on this than I have going through these patches
today.

So please feel free to merge this whenever you feel it's ready.

For the series,

Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>



>  ArmVirtPkg/ArmVirtQemu.dsc                  |    3 +-
>  ArmVirtPkg/ArmVirtQemuFvMain.fdf.inc        |    3 +-
>  ArmVirtPkg/ArmVirtQemuKernel.dsc            |    3 +-
>  OvmfPkg/Include/IndustryStandard/Virtio10.h |    5 +
>  OvmfPkg/Include/IndustryStandard/VirtioFs.h |  454 ++++
>  OvmfPkg/OvmfPkgIa32.dsc                     |    2 +
>  OvmfPkg/OvmfPkgIa32.fdf                     |    1 +
>  OvmfPkg/OvmfPkgIa32X64.dsc                  |    2 +
>  OvmfPkg/OvmfPkgIa32X64.fdf                  |    1 +
>  OvmfPkg/OvmfPkgX64.dsc                      |    2 +
>  OvmfPkg/OvmfPkgX64.fdf                      |    1 +
>  OvmfPkg/VirtioFsDxe/DriverBinding.c         |  232 ++
>  OvmfPkg/VirtioFsDxe/FuseFlush.c             |  111 +
>  OvmfPkg/VirtioFsDxe/FuseForget.c            |   85 +
>  OvmfPkg/VirtioFsDxe/FuseFsync.c             |  121 +
>  OvmfPkg/VirtioFsDxe/FuseGetAttr.c           |  116 +
>  OvmfPkg/VirtioFsDxe/FuseInit.c              |  142 ++
>  OvmfPkg/VirtioFsDxe/FuseLookup.c            |  148 ++
>  OvmfPkg/VirtioFsDxe/FuseMkDir.c             |  134 ++
>  OvmfPkg/VirtioFsDxe/FuseOpen.c              |  126 +
>  OvmfPkg/VirtioFsDxe/FuseOpenDir.c           |  120 +
>  OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c      |  155 ++
>  OvmfPkg/VirtioFsDxe/FuseRead.c              |  191 ++
>  OvmfPkg/VirtioFsDxe/FuseRelease.c           |  121 +
>  OvmfPkg/VirtioFsDxe/FuseRename.c            |  131 ++
>  OvmfPkg/VirtioFsDxe/FuseSetAttr.c           |  174 ++
>  OvmfPkg/VirtioFsDxe/FuseStatFs.c            |  102 +
>  OvmfPkg/VirtioFsDxe/FuseUnlink.c            |  114 +
>  OvmfPkg/VirtioFsDxe/FuseWrite.c             |  155 ++
>  OvmfPkg/VirtioFsDxe/Helpers.c               | 2416 ++++++++++++++++++++
>  OvmfPkg/VirtioFsDxe/SimpleFsClose.c         |   68 +
>  OvmfPkg/VirtioFsDxe/SimpleFsDelete.c        |  110 +
>  OvmfPkg/VirtioFsDxe/SimpleFsFlush.c         |   42 +
>  OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c       |  209 ++
>  OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c   |   27 +
>  OvmfPkg/VirtioFsDxe/SimpleFsOpen.c          |  505 ++++
>  OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c    |   98 +
>  OvmfPkg/VirtioFsDxe/SimpleFsRead.c          |  434 ++++
>  OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c       |  582 +++++
>  OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c   |   67 +
>  OvmfPkg/VirtioFsDxe/SimpleFsWrite.c         |   81 +
>  OvmfPkg/VirtioFsDxe/VirtioFsDxe.h           |  544 +++++
>  OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf         |  136 ++
>  43 files changed, 8271 insertions(+), 3 deletions(-)
>  create mode 100644 OvmfPkg/Include/IndustryStandard/VirtioFs.h
>  create mode 100644 OvmfPkg/VirtioFsDxe/DriverBinding.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseFlush.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseForget.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseFsync.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseGetAttr.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseInit.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseLookup.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseMkDir.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseOpen.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseOpenDir.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseOpenOrCreate.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseRead.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseRelease.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseRename.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseSetAttr.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseStatFs.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseUnlink.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/FuseWrite.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/Helpers.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsClose.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsDelete.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsFlush.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsGetInfo.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsGetPosition.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsOpen.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsOpenVolume.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsRead.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsSetInfo.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsSetPosition.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/SimpleFsWrite.c
>  create mode 100644 OvmfPkg/VirtioFsDxe/VirtioFsDxe.h
>  create mode 100644 OvmfPkg/VirtioFsDxe/VirtioFsDxe.inf
> 
> 
> base-commit: e6ae24e1d676bb2bdc0fc715b49b04908f41fc10
> 


