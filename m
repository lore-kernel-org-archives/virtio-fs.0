References: <5f49cefd-a051-8af4-86a2-3ea94acd9eee@redhat.com>
	<20190827130207.GC4290@stefanha-x1.localdomain>
	<b2d18411-d518-788a-0783-1d55a11407c6@redhat.com>
	<20190828113639.GI5573@stefanha-x1.localdomain>
	<bf9d73ed-0533-1cc1-9884-3c08281dd961@redhat.com>
	<20190902102149.GH9069@stefanha-x1.localdomain>
From: Laszlo Ersek <lersek@redhat.com>
Message-ID: <def8239b-94b3-10d2-ccfa-4e71e80c8a17@redhat.com>
Date: Mon, 2 Sep 2019 19:27:35 +0200
MIME-Version: 1.0
In-Reply-To: <20190902102149.GH9069@stefanha-x1.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] basic questions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

On 09/02/19 12:21, Stefan Hajnoczi wrote:

> Another topic:
> Does UEFI have a standard interface for configuring and storing boot
> devices and information

Yes; UEFI (the spec) defines the BootOrder and Boot#### UEFI variables.

For example, Boot0003 could point to the boot loader of an installed OS,
Boot0004 could point to the boot loader of another installed OS,
Boot0001 could point to a NIC (for PXE or HTTP(S) booting), and then
BootOrder (an array of uint16_t objects) would collect these into an
arbitrary sequence. (The numbers in the Boot#### variable names do not
dictate ordering, they just make variable names unique.)

With OVMF, the question becomes tricky. Things revolve around QEMU's
"bootorder" fw_cfg file, which contains OpenFirmware (OFW) device paths
that identify boot devices. QEMU generates this fw_cfg file based on the
"bootindex" device properties.

The OFW device paths in the "bootorder" fw_cfg file are not as
expressive as UEFI boot options (not to mention the entirely different
representation). OVMF has some quite complex platform code that does the
following:

(a) It translates the entries in the "bootorder" fw_cfg file, from OFW
notation, to UEFI device path notation. Importantly, such a translated
UEFI device path cannot contain a filesystem pathname -- it unavoidably
stops at the device granularity where the information content from the
OFW entry ends.

(b) The translated UEFI device paths are used as *prefixes*, and OVMF
connects all devices in the devpath *subtrees* that are rooted at the
prefixes. (This roughly means that OVMF makes UEFI drivers bind such
devices that are selected directly, or indirectly as a part of a
sub-hierarchy, by the translated UEFI device path prefixes.)

(c) We now have a set of "bound" devices in the system. OVMF invokes
some core edk2 code for auto-generating boot options for these devices.
If a boot option (Boot#### variable) for such a device exists already,
no new option is added. Otherwise, a new Boot#### variable (boot option)
is created, and appended to the end of the UEFI boot order (= referenced
from the end of the BootOrder variable). This may happen e.g. if you add
the "bootindex" property to an otherwise bootable device (such as
virtio-blk or virtio-net) which did not to have that property
previously.

(d) Finally, OVMF filters and reorders the above augmented set of UEFI
boot options, against the translated UEFI device path prefixes. For
example, this step will erase the boot option for such a device that you
have removed from the QEMU command line, or for which you removed the
"bootindex" property (while some other devices still have the property).
And reordering is useful e.g. if you have an installed UEFI image, but
for once, you prioritize netboot for some reason.

(e) If no device has the bootindex property (because the "bootorder"
fw_cfg file is nonexistent or empty), then OVMF doesn't touch the
Boot#### / BootOrder variables.

(f) Universal (platform-independent) logic in edk2 takes control, for
processing (booting) the UEFI boot order.


To give you an example (from
"OvmfPkg/Library/QemuBootOrderLib/QemuBootOrderLib.c"), an OFW device
path in the "bootorder" fw_cfg file, for a virtio-scsi disk, might look
like

    //   /pci@i0cf8/scsi@7[,3]/channel@0/disk@2,3
    //        ^          ^             ^      ^ ^
    //        |          |             |      | LUN
    //        |          |             |      target
    //        |          |             channel (unused, fixed 0)
    //        |          PCI slot[, function] holding SCSI controller
    //        PCI root at system bus port, PIO

and the translated UEFI device path prefix would be

    //   PciRoot(0x0)/Pci(0x7,0x0)/Scsi(0x2,0x3)
    //                                        -- if PCI function is 0 or absent
    //   PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)
    //                                -- if PCI function is present and nonzero

Step (c) would generate a UEFI boot option with just this UEFI device
path, and append it to the end of the UEFI boot order (unless it already
existed somewhere in the UEFI boot order).


Typically, following a UEFI guest installation to the same virtio-scsi
disk, this auto-generated boot option would be *preceded* by another,
namely of the form

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)/HD(1,GPT,7CFAA999-DFF7-441E-A73A-7C596A600DDF,0x800,0x40000)/\EFI\fedora\shimx64.efi

because this more specific UEFI device path -- including a filesystem
pathname -- would have been established earlier by Anaconda /
efibootmgr, with highest priority, at guest installation time. In that
case, after step (d), the boot option

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)/HD(1,GPT,7CFAA999-DFF7-441E-A73A-7C596A600DDF,0x800,0x40000)/\EFI\fedora\shimx64.efi

would take priority over the auto-generated

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)

because the reordering in step (d) is "stable".


In the atypical case however, it's possible that you only have the
auto-generated UEFI boot option for

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)

When processing that option, UEFI silently attempts to boot

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)/.../\EFI\BOOT\BOOTX64.EFI

(note the fallback filesystem pathname '\EFI\BOOT\BOOTX64.EFI').

This applies when:

- you are booting removable media (for example an installer ISO)

- you have an installed system but you lost the UEFI Boot#### /
BootOrder variables for some reason, including the one pointing at
"shimx64.efi".


What's furthermore relevant is that the last device path node, just
before the filesystem pathname node (such as '\EFI\fedora\shimx64.efi'
or '\EFI\BOOT\BOOTX64.EFI'), identifies a UEFI handle that carries an
EFI_SIMPLE_FILE_SYSTEM_PROTOCOL instance. In the above case,

  PciRoot(0x0)/Pci(0x7,0x3)/Scsi(0x2,0x3)/HD(1,GPT,7CFAA999-DFF7-441E-A73A-7C596A600DDF,0x800,0x40000)

is a hard disk partition with a FAT filesystem, and so the handle
underlying the HD() node carries an EFI_SIMPLE_FILE_SYSTEM_PROTOCOL
instance.


When using virtio-fs with OVMF, the OFW device path in the "bootorder"
fw_cfg file would be expected to look something like

  /pci@i0cf8/virtio-fs@7[,3]

(The "driver-name" component in the OFW node would be "virtio-fs".)

The translated UEFI devpath prefix would simply be

  PciRoot(0x0)/Pci(0x7,0x3)

in OVMF. OVMF's driver for virtio-fs would install
EFI_SIMPLE_FILE_SYSTEM_PROTOCOL directly on the Pci() node -- no need
for HD(), there are no partitions --, so ultimately the following would
be the "full" device path examples:

  PciRoot(0x0)/Pci(0x7,0x3)/\EFI\fedora\shimx64.efi [from Anaconda / efibootmgr]
  PciRoot(0x0)/Pci(0x7,0x3)/\EFI\BOOT\BOOTX64.EFI   [fallback, per spec]


In short, the filesystem exposed with virtio-fs to the OVMF guest, for
the purposes of UEFI booting, should look like a bootable UEFI system
partition -- namely, it should include an \EFI directory tree. In other
words, the "only" thing that virtio-fs abstracted away, in this regard,
would be the block device layer (such as IDE, AHCI, virtio-blk or
virtio-scsi), from between the "PCI" and "filesystem" layers.

> (e.g. kernel filename, initramfs, command-line)? This information is
> necessary when booting directly from virtio-fs.

In the described scenario, the kernel, initramfs, and kernel command
line would be handled by the UEFI boot loader, namely grub2. (Grub2
itself would exist as part of the \EFI directory tree.)

Of course the question is what we *want* here. The above targets the
case when a user specifically wants to access virtio-fs *from within*
UEFI (including the UEFI boot manager, the UEFI shell, and UEFI
applications, such as grub2-efi).


Other goals can be imagined. For example, the following goal is slightly
different: "I want a guest kernel running on virtio-fs, and that guest
kernel should find a UEFI environment underneath itself". This use case
should be covered right now, because OVMF supports kernel / initramfs /
cmdline via fw_cfg already. You would launch OVMF from pflash (like
always), and instruct QEMU to load the kernel / initramfs / cmdline into
fw_cfg from files located within the virtio-fs directory tree. OVMF
would fetch the kernel / initramfs / cmdline from fw_cfg -- note: *no*
firmware-level access to virtio-fs --, OVMF would launch the kernel, and
the kernel would use its own smart driver for talking to virtio-fs. The
kernel would also find a UEFI environment.

This would eliminate shim/grub2 from the picture. For some cases, that
could be seen as a benefit. For other cases, as a limitation; for
example, if you needed Secure Boot with the Machine Owner Key management
that shim implements.

Thanks
Laszlo

