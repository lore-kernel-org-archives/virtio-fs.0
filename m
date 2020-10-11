DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:references:from:subject:message-id:date:user-agent:mime-version
	:in-reply-to:content-transfer-encoding:content-language;
	bh=LfICx60tWN9QO3x7xn7r1r0cR3v2pmTxeBBxwhX2sK4=;
	b=MyWYjHorkO0v/taWYoRax8xn6ncHJsXjIeqZmiWAEFXX4YT21LqlDuKdr+162A58lw
	NsUJe6c0D6TAmvV/0GX6uv781LdH5koNdJXRz+0pe1iMYx7cX3czw89WGJ3bxi9sFvJI
	mSFUaNCtR/qMesnZT+SLKMxlyZ/frgjym3I84C+KyQYGZrr9st+je/7V4OfoINC7WnZ2
	iMtdczmS/TjK1+32RDLB4NhgBRNSMs/KsqkeTBp8i7N7SxCAZsDLF7CEH9g95WoltrEJ
	e//Fo8mol4SEheycOSzGX2o3CEMRvbPlbbNRtbniN/NYIXBJwOJb94ndX3BFvfRaayMU
	zk1A==
References: <20200916163553.GA39212@redhat.com>
	<20201009182424.GA44737@redhat.com>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <5419d4a1-c689-2e97-08d7-6e32ee3f9fd2@gmail.com>
Date: Sun, 11 Oct 2020 17:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <20201009182424.GA44737@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] HOWTO: direct kernel 'root=virtiofs:myfs' boot on
 'vanilla' Fedora/RHEL/Centos releases.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

To allow direct kernel booting on a non-customized or 'vanilla distro'
Fedora / RHEL /Centos system, some extensions to dracut are required. 
They are below.

Kindly consider editing the following information and replacing the
instructions for the 'direct kernel booting' advice on the virtio-fs web
page.

These steps allow the only 'kernel args' necessary to be in the same
pattern used for other root file systems.  For example,
"root=virtiofs:myfs".

These steps worked for me, feel free to incorporate them as you like.

1) Use other guides/resources to create a fedora file system tree in a
sub-directory on the host.  This was written using Fedora 33 beta.  I
mention a couple options at the end of this email.

2) Use virtio-fs existing guides/resources to set up a virtual machine
with the shared memory and other file system xml for virtiofs, with
virtiofs changes set to point to the above mentioned tree.  Do not start
the virtual machine.

3) Then, on the host:

FIRST:

cd fedora_root_on_host_system
mount --bind /proc proc
mount --bind /sys sys
mount --bind /dev dev
mount --bind /dev/pts dev/pts
mount --bind /run run
chroot .
#(later, after the all work below, exit, then umount run, dev/pts, dev,
sys, proc..)
#Do the following within the chroot
dnf upgrade  
#debug/repeat until that runs without error, so you are confident of a
minimal working setup.
#then these changes:

#A)  Changes to allow user and root logins to succeed.  In the
alternative you can set /etc/selinux/config to permissive.

cat > /root/virtiofs_kernel_boot.te << EOF

module virtiofs_kernel_boot 1.0;

require {
    type unconfined_t;
    type unlabeled_t;
    type kernel_t;
    type rpm_script_t;
    class process transition;
    class file entrypoint;
}

#============= kernel_t ==============
allow kernel_t unconfined_t:process transition;

#============= rpm_script_t ==============
allow rpm_script_t unlabeled_t:file entrypoint;

#============= unconfined_t ==============
allow unconfined_t unlabeled_t:file entrypoint;

EOF

#then
cd /root
checkmodule -M -m -o virtiofs_kernel_boot.mod virtiofs_kernel_boot.te
#then
semodule_package -o virtiofs_kernel_boot.pp -m virtiofs_kernel_boot.mod
#then
semodule -i virtiofs_kernel_boot.pp

#B) Next step, amend dracut (Patterned after 9p examples):

cat > /etc/dracut.conf.d/addvirtiofs.conf  <<EOF
add_dracutmodules+=" virtiofs "
filesystems+=" virtiofs "

EOF

#When the below becomes standard in dracut, the above should

#be the only necessary change per instance. I hope some version of

#the three files below become standard in dracut releases.

cat > /usr/lib/dracut/modules.d/95virtiofs/module-setup.sh  <<EOF

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

EOF

cat > /usr/lib/dracut/modules.d/95virtiofs/parse-virtiofs.sh   <<EOF
#!/usr/bin/sh

if [ "${root%%:*}" = "virtiofs" ] ; then
   modprobe virtiofs

   rootok=1
fi

EOF

cat > /usr/lib/dracut/modules.d/95virtiofs/mount-virtiofs.sh  <<EOF
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
   mount -t ${rootfs} -o "$rflags" "${root#virtiofs:}" "$NEWROOT" 2>&1 |
vinfo

   [ -f "$NEWROOT"/forcefsck ] && rm -f -- "$NEWROOT"/forcefsck 2>/dev/null
   [ -f "$NEWROOT"/.autofsck ] && rm -f -- "$NEWROOT"/.autofsck 2>/dev/null
}

if [ -n "$root" -a -z "${root%%virtiofs:*}" ]; then
   mount_root
fi
:
EOF


#Look in /boot in the image, find the file like
vmlinuz-5.8.14-300.fc33.x86_64
#Let X be everything after vmlinuz- so in this case 5.8.14-300.fc33.x86_64
#Give the command
#dracut --force --kver X
#or in this case
dracut --force --kver 5.8.14-300.fc33.x86_64

#That should complete without error.
exit
#Don't forget to unmount dev dev/pts proc sys run

In your libvirt setup, Enable 'direct kernel boot'.
On my host, the vm root image is in /vmsystems/fedora_generic,
So change the following to fit your case.

Change the kernel path to the then current variation on:

/vmsystems/fedora_generic/boot/vmlinuz-5.8.14-300.fc33.x86_64

Change the Initrd path to the then current variation on:

/vmsystems/fedora_generic/boot/initramfs-5.8.14-300.fc33.x86_64.img

Change the kernel args to be only, or at least to include:

root=virtiofs:myfs

Where 'myfs' matches the 'target dir' setting in the libvirt xml:
<filesystem type="mount" accessmode="passthrough">
  <driver type="virtiofs" queue="1024"/>
...
  <target dir="myfs"/>
...

And.... That's it.

You should be able to boot a standard fedora/rhel/centos distro that
uses yum/dnf/dracut  directly from the underlying file system.  My
Fedora 33 beta boots reliably with exactly the setup above using a
direct kernel boot.    The underlying file system on the host is
btrfs.... and this setup is a complete rocket compared to a .qcow2 or
raw underlying image.  I think the reason for the speed is all the guest
VM's rely on just and only the host file system to manage the block
devices underneath, so you get all the benefits of the caching, the seek
optimizations, etc.   And it's 'really nice' to be able to sync or shut
down the vm, take a snapshot on the host (which is 'free' in terms of
extra space used) then be able to roll back, etc.

To get the initial file system tree I did a default 'iso' install to a
vm, then mounted the qcow2 file on the host, mounted the partitions in a
tree in tmp, then did an rsync -a to the host systems 'fedora_generic'
tree.  There are variations on

dnf -y --releasever=33 --installroot=/vmsystems/fedora_generic install
fedora-release systemd passwd rootfiles sudo dracut dracut-network
nfs-utils vim-minimal dnf
detailed at
https://fedoramagazine.org/how-to-build-a-netboot-server-part-1/ for a
more 'hands on' methods

In the 'would be nice' category:   I wish in the guest filesystem tree
there was a link named 'vmlinuz' and 'initrd.img' that pointed to the
latest installed kernel, so I wouldn't have to update where the host
looks for the boot info in the guest.

In the 'questions I have' department, I'd like the virtio-fs folks to
determine what the default flags should be for the generic kernel,
specifically whether there is a test for whether dax is available and to
use it by default if it is, etc.

Perhaps others might suggest tweaking the above files then asking dracut
maintainers to include the /usr/lib/dracut... items as standard .

Best to all

Harry Coin

Bettendorf, Iowa






