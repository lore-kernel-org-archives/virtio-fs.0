DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version
	:content-transfer-encoding:content-language;
	bh=datSRoS4F3Ncq8d+fQ5ao0NRMN2iiWIm0aYclWTVmxs=;
	b=lJ68xmCnJrtMzen42LESd7kdYxH2L7h47mE+Qpy/GI3eEpVOKzZukmE81LMWSjxjYx
	k6gAZr8Y8cFZHKPcBWHulqPLJLvRsaf/1KZy629Orwv8vBdcrOMRPCwIR+LIJ25UCoAC
	E4hTs+ty5c5mHET1fJ94ULcqB0s22bcfcmoExunyPFk/PzorSQXcMZeOHv05gI3+1MeG
	9vIBZkl8MRcPOzKHj29cf9HBPrJvQnUni5w7zJjeYg6eg0aqjBOzclLADbuJCY6q1whL
	XO5A5fe9YkkgM1+OC2ZL/Uv/uzaVMpRAnM6hyLjKuA1Ve6edP2OZTVaeinmnb6XQZPBS
	d19A==
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <756d5044-e567-b403-b4b2-784b3c284ed6@gmail.com>
Date: Fri, 4 Jun 2021 11:28:42 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] Virtiofs Kernel Boot howto
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

Mentioned up-list, here's a further little helper to allow virtio-fs root.

The instructions here lead to a known bootable guest as of this writing.

The best way to launch virtio-fs root in the guest is via
qemu/libvirt/virt-manager's "Direct Kernel Boot" facility under "Boot
Options".

That requires the user provide a kernel path, and initrd path, and
kernel args.

There are two challenges to overcome.  First, to avoid forcing the user
to update the entries to boot the host every time the guest upgrades the
kernel via normal use of 'dnf upgrade'.   The second is to make sure
dracut/initramfs includes the modules necessary for virtiofs to boot.

Notice: The virtio-fs developers 'roll their own' custom kernels and as
such avoid the need for initrd's.  Which is fine in the lab, but limits
the diverse needs of production.

If you create this file: /etc/kernel/postinst.d/update_vmlinuz_initrd_links

#!/bin/bash
#Used by vm host to boot latest kernel without having to update kernel
spec in the host.
KERNEL_VERSION="$1"
#KERNEL_IMAGE="$2"

cd /boot
ln -sf vmlinuz-$KERNEL_VERSION /boot/vmlinuz
ln -sf initramfs-$KERNEL_VERSION.img /boot/initrd.img

---

Then as the kernel path in libvirt's xml or 'virt manager':

<path to guest root on host>/boot/vmlinuz

and as the initrd path:

<path to guest root on host>/boot/initrd.img

and as 'kernel args' (presuming you've built dracut with the added conf
files I published on this list previously):

root=virtiofs:myfs rd.shell rd.fstab

and in the 'filesystem' entry in 'virt-manager' or by hand in the xml
something like:

<filesystem type="mount" accessmode="passthrough">
  <driver type="virtiofs" queue="1024"/>
  <binary path="/vmsystems/custom_virtiofsd" xattr="on">
    <lock posix="off" flock="on"/>
  </binary>
  <source dir="<path to guest root on the host"/>
  <target dir="myfs"/>
</filesystem>

----

Notice, the 'path=...' is optional, but without it the libvirt xml
rejects as parse errors many of the current virtiofsd options necessary
for success.

My custom_virtiofsd looks like this:

#!/bin/bash
#Provide a way to add arguments libvirt doesn't know about.
set -o allexport
/usr/lib/qemu/virtiofsd $@
#/usr/lib/qemu/virtiofsd $@,xattrmap=":ok:all:::",log_level=debug -d
--syslog

and something like this in the guest /etc/fstab

myfs / virtiofs seclabel 0 0


Then your guest will boot with virtio-fs as the root file system, and
will need no other filesystem.

To put everything in one place, here are the dracut.conf additions
necessary for virtiofs root.  These are all in the guest image:


/etc/dracut.conf.d/addvirtiofs.conf:

add_dracutmodules+=" virtiofs "
filesystems+=" virtiofs "

---

/usr/lib/dracut/modules.d/95virtiofs/module-setup.sh :

#!/usr/bin/bash

# called by dracut
check() {
    [[ $hostonly ]] || [[ $mount_needs ]] && {
        for fs in "${host_fs_types[@]}"; do
            [[ "$fs" == "virtiofs" ]] && return 0
        done
        return 255
    }

    is_qemu_virtualized && return 0

    return 255
}

# called by dracut
depends() {
    return 0
}

# called by dracut
installkernel() {
    instmods virtiofs
}

# called by dracut
install() {
    inst_hook cmdline 95 "$moddir/parse-virtiofs.sh"
    inst_hook pre-mount 99 "$moddir/mount-virtiofs.sh"
}

---

/usr/lib/dracut/modules.d/95virtiofs/mount-virtiofs.sh:

#!/usr/bin/sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

filter_rootopts() {
    rootopts=$1
    # strip ro and rw options
    local OLDIFS="$IFS"
    IFS=,
    set -- $rootopts
    IFS="$OLDIFS"
    local v
    while [ $# -gt 0 ]; do
        case $1 in
            rw|ro);;
            defaults);;
            *)
                v="$v,${1}";;
        esac
        shift
    done
    rootopts=${v#,}
    echo $rootopts
}

mount_root() {
    local _ret

    rootfs="virtiofs"
    rflags="rw"

    modprobe virtiofs

    mount -t ${rootfs} -o "$rflags",ro "${root#virtiofs:}" "$NEWROOT"

    rootopts=
    if getargbool 1 rd.fstab -n rd_NO_FSTAB \
        && ! getarg rootflags \
        && [ -f "$NEWROOT/etc/fstab" ] \
        && ! [ -L "$NEWROOT/etc/fstab" ]; then
        # if $NEWROOT/etc/fstab contains special mount options for
        # the root filesystem,
        # remount it with the proper options
        rootopts="defaults"
        while read dev mp fs opts rest || [ -n "$dev" ]; do
            # skip comments
            [ "${dev%%#*}" != "$dev" ] && continue

            if [ "$mp" = "/" ]; then
                rootopts=$opts
                break
            fi
        done < "$NEWROOT/etc/fstab"

        rootopts=$(filter_rootopts $rootopts)
    fi

    # we want rootflags (rflags) to take precedence so prepend rootopts to
    # them; rflags is guaranteed to not be empty
    rflags="${rootopts:+${rootopts},}${rflags}"

    umount "$NEWROOT"

    info "Remounting ${root#virtiofs:} with -o ${rflags}"
    mount -t ${rootfs} -o "$rflags" "${root#virtiofs:}" "$NEWROOT" 2>&1
| vinfo

    [ -f "$NEWROOT"/forcefsck ] && rm -f -- "$NEWROOT"/forcefsck 2>/dev/null
    [ -f "$NEWROOT"/.autofsck ] && rm -f -- "$NEWROOT"/.autofsck 2>/dev/null
}

if [ -n "$root" -a -z "${root%%virtiofs:*}" ]; then
    mount_root
fi
:

----

And finally /usr/lib/dracut/modules.d/95virtiofs/parse-virtiofs.sh :

#!/usr/bin/sh

if [ "${root%%:*}" = "virtiofs" ] ; then
    modprobe virtiofs

    rootok=1
fi

---

chmod this as 0750: /usr/local/bin/chinto_virtiofs_guest :

#!/bin/bash
cd $1
mount --bind /proc proc
mount --bind /sys sys
mount --bind /dev dev
mount --bind /dev/pts dev/pts
mount --bind /run run
chroot .
umount dev/pts
umount dev
umount proc
umount sys
umount run

---

Once those are in place, one time, on the host run


chinto_virtiofs_guest <path to guest root on host>

dracut -f

exit

===

And from then on, even with dnf upgrades, your guest vm will have a
virtiofs root.

Which, of course, won't allow dnf upgrades at the moment until a
regression brought about in the last few weeks gets fixed.  But
otherwise has been working well for many months.  You'll want to edit
custom_virtiofsd to add dax, do debugging and so on as a 'crutch' until
libvirt/virt-manager xml parsing catches up to virtiofsd command line
options.


Or, you know, wait a year and all the above (more or less) will be
'standard' in various distros and you won't have to edit it in.

Thanks for all the virtiofs work, this is my little contribution.

Best to all

Harry Coin

Bettendorf, Iowa







