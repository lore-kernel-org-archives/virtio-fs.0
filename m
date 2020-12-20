References: <20201216211125.19496-1-lersek@redhat.com>
	<f307b0a1-a885-4379-15f3-a3ac1a5f2a5d@arm.com>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <5f75d127-a110-f256-19ad-4aa120332d6c@redhat.com>
Date: Sun, 20 Dec 2020 01:09:48 +0100
MIME-Version: 1.0
In-Reply-To: <f307b0a1-a885-4379-15f3-a3ac1a5f2a5d@arm.com>
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
To: Ard Biesheuvel <ard.biesheuvel@arm.com>, devel@edk2.groups.io, virtio-fs@redhat.com
Cc: Jordan Justen <jordan.l.justen@intel.com>, Leif Lindholm <leif@nuviainc.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>

On 12/18/20 18:44, Ard Biesheuvel wrote:
> On 12/16/20 10:10 PM, Laszlo Ersek wrote:
>> Ref:    https://bugzilla.tianocore.org/show_bug.cgi?id=3097
>> Repo:   https://pagure.io/lersek/edk2.git
>> Branch: virtio-fs (@ b8fd76d649d2)
>>
>> The first commit and the bugzilla ticket state the use case.
>>
>> References, including setup instructions:
>> - https://libvirt.org/kbase/virtiofs.html
>> - https://virtio-fs.gitlab.io/
>>
>> Useful UEFI shell commands for testing: output redirections, attrib,
>> connect, cp, disconnect, edit, eficompress, efidecompress, hexedit, ls,
>> map, mkdir, mv, rm, setsize, timezone, touch, type, vol.
>>
>> The series is largely structured as follows:
>> - helper functions and FUSE command wrappers are implemented as required
>>   by the next EFI_FILE_PROTOCOL interface,
>> - said EFI_FILE_PROTOCOL interface is implemented,
>> - lather, rinse, repeat.
>>
>> Cc: Ard Biesheuvel <ard.biesheuvel@arm.com>
>> Cc: Jordan Justen <jordan.l.justen@intel.com>
>> Cc: Leif Lindholm <leif@nuviainc.com>
>> Cc: Philippe Mathieu-Daudé <philmd@redhat.com>
>>
>> Thanks,
>> Laszlo
>>
>> Laszlo Ersek (48):
>>   OvmfPkg: introduce VirtioFsDxe
>>   ArmVirtPkg: include VirtioFsDxe in the ArmVirtQemu* platforms
>>   OvmfPkg/VirtioFsDxe: DriverBinding: open VirtioDevice, install
>>     SimpleFs
>>   OvmfPkg/VirtioFsDxe: implement virtio device (un)initialization
>>   OvmfPkg/VirtioFsDxe: add a scatter-gather list data type
>>   OvmfPkg/VirtioFsDxe: introduce the basic FUSE request/response headers
>>   OvmfPkg/VirtioFsDxe: map "errno" values to EFI_STATUS
>>   OvmfPkg/VirtioFsDxe: submit the FUSE_INIT request to the device
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_OPENDIR
>>   OvmfPkg/VirtioFsDxe: add shared wrapper for FUSE_RELEASE /
>>     FUSE_RELEASEDIR
>>   OvmfPkg/VirtioFsDxe: implement
>>     EFI_SIMPLE_FILE_SYSTEM_PROTOCOL.OpenVolume()
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_FORGET
>>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_FSYNC /
>>     FUSE_FSYNCDIR
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_FLUSH
>>   OvmfPkg/VirtioFsDxe: flush, sync, release and forget in Close() /
>>     Delete()
>>   OvmfPkg/VirtioFsDxe: add helper for appending and sanitizing paths
>>   OvmfPkg/VirtioFsDxe: manage path lifecycle in OpenVolume, Close,
>>     Delete
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_OPEN
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_MKDIR
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_CREATE
>>   OvmfPkg/VirtioFsDxe: convert FUSE inode attributes to EFI_FILE_INFO
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_LOOKUP
>>   OvmfPkg/VirtioFsDxe: split canon. path into last parent + last
>>     component
>>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_UNLINK / FUSE_RMDIR
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_GETATTR
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Open()
>>   OvmfPkg/VirtioFsDxe: erase the dir. entry in
>>     EFI_FILE_PROTOCOL.Delete()
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_STATFS
>>   OvmfPkg/VirtioFsDxe: add helper for formatting UEFI basenames
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.GetInfo()
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.GetPosition,
>>     .SetPosition
>>   OvmfPkg/VirtioFsDxe: add a shared wrapper for FUSE_READ /
>>     FUSE_READDIRPLUS
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Read() for regular
>>     files
>>   OvmfPkg/VirtioFsDxe: convert FUSE dirent filename to EFI_FILE_INFO
>>   OvmfPkg/VirtioFsDxe: add EFI_FILE_INFO cache fields to VIRTIO_FS_FILE
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Read() for
>>     directories
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Flush()
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_WRITE
>>   OvmfPkg/VirtioFsDxe: implement EFI_FILE_PROTOCOL.Write()
>>   OvmfPkg/VirtioFsDxe: handle the volume label in
>>     EFI_FILE_PROTOCOL.SetInfo
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_RENAME2
>>   OvmfPkg/VirtioFsDxe: add helper for composing rename/move destination
>>     path
>>   OvmfPkg/VirtioFsDxe: handle file rename/move in
>>     EFI_FILE_PROTOCOL.SetInfo
>>   OvmfPkg/VirtioFsDxe: implement the wrapper function for FUSE_SETATTR
>>   OvmfPkg/VirtioFsDxe: add helper for determining file size update
>>   OvmfPkg/VirtioFsDxe: add helper for determining access time updates
>>   OvmfPkg/VirtioFsDxe: add helper for determining file mode bits update
>>   OvmfPkg/VirtioFsDxe: handle attribute updates in
>>     EFI_FILE_PROTOCOL.SetInfo
>>
>
> This looks carefully crafted, and modulo my two questions, I won't be
> able to spend more time on this than I have going through these
> patches today.
>
> So please feel free to merge this whenever you feel it's ready.
>
> For the series,
>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@arm.com>

Thank you.

Before I posted the series, I tested it very thoroughly, including build
tests (at every patch, and a Local CI run as well). I created a test
plan and went through it meticulously (it took hours).

The only thing I couldn't test that way was (obviously) building on
Windows. So clearly now that I've tried merging the series at
<https://github.com/tianocore/edk2/pull/1248>, that's what fails.
Because, this is the first time that EmbeddedPkg/TimeBaseLib is seen by
the Visual Studio compiler, and Visual Studio complains:

> ERROR - Compiler #2220 from
> d:\a\1\s\EmbeddedPkg\Library\TimeBaseLib\TimeBaseLib.c(111):   the
> following warning is treated as an error
> WARNING - Compiler #4244 from
> d:\a\1\s\EmbeddedPkg\Library\TimeBaseLib\TimeBaseLib.c(111):   '=':
> conversion from 'UINTN' to 'UINT32', possible loss of data

It happens to be correct:

    99  /**
   100    Converts EFI_TIME to Epoch seconds (elapsed since 1970 JANUARY 01, 00:00:00 UTC)
   101   **/
   102  UINT32
   103  EFIAPI
   104  EfiTimeToEpoch (
   105    IN  EFI_TIME  *Time
   106    )
   107  {
   108    UINT32 EpochDays;   // Number of days elapsed since EPOCH_JULIAN_DAY
   109    UINT32 EpochSeconds;
   110
   111    EpochDays = EfiGetEpochDays (Time);
   112
   113    EpochSeconds = (EpochDays * SEC_PER_DAY) + ((UINTN)Time->Hour * SEC_PER_HOUR) + (Time->Minute * SEC_PER_MIN) + Time->Second;
   114
   115    return EpochSeconds;
   116  }

This was discussed on the list earlier, when the function was duplicated
for the HTTP dynamic command:

- https://edk2.groups.io/g/devel/message/64933
- https://edk2.groups.io/g/devel/message/65186

Compare EfiTimeToEpoch() in
"ShellPkg/DynamicCommand/HttpDynamicCommand/Http.c".

   430  STATIC
   431  UINTN
   432  EFIAPI
   433  EfiTimeToEpoch (
   434    IN  EFI_TIME  *Time
   435    )
   436  {
   437    //
   438    // Number of days elapsed since EPOCH_JULIAN_DAY.
   439    //
   440    UINTN EpochDays;
   441    UINTN EpochSeconds;
   442
   443    EpochDays = EfiGetEpochDays (Time);
   444
   445    EpochSeconds = (EpochDays * SEC_PER_DAY) +
   446                   ((UINTN)Time->Hour * SEC_PER_HOUR) +
   447                   (Time->Minute * SEC_PER_MIN) + Time->Second;
   448
   449    return EpochSeconds;
   450  }

So, in order to merge this series, I'll first have to fix
EfiTimeToEpoch() in EmbeddedPkg :(

I wish the fixed version in
"ShellPkg/DynamicCommand/HttpDynamicCommand/Http.c" had been contributed
back to EmbeddedPkg.

Anyway, that is for 2021.

Thank you for checking the series so quickly; I know it's a lot!
Laszlo

