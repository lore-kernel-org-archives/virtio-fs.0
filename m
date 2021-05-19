Date: Wed, 19 May 2021 17:39:44 +0100
From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Message-ID: <YKU/UD9SycU62WSn@work-vm>
References: <20210518213538.693422-1-vgoyal@redhat.com>
	<20210518213538.693422-8-vgoyal@redhat.com>
	<41df4f6a-6d40-745d-aacd-9c4b66a31f3e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <41df4f6a-6d40-745d-aacd-9c4b66a31f3e@gmail.com>
Subject: Re: [Virtio-fs] Regression: Docker in vms broken.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Harry G. Coin" <hgcoin@gmail.com>
Cc: virtio-fs@redhat.com

* Harry G. Coin (hgcoin@gmail.com) wrote:
> Something changed in virtiofs, likely to do with overlay support?=A0

Hmm I don't think we have any explicit support in for overlayfs though.

> Docker in a vm with virtiofs as root running with kernel=A0
> 5.8.0-53-generic works normally.=A0 However, later 5.8 versions and also
> 5.11 versions fail with:

Hmm, so what's your last working & first failing version of 5.8 ?

Dave

>=20
> May 18 22:00:07 nocsupport4 systemd[1]: docker.service: Scheduled
> restart job, restart counter is at 2.
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.061661124-05:00" level=3Dinfo msg=3D"Starting=
 up"
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.109655841-05:00" level=3Dinfo msg=3D"detected
> 127.0.0.53 nameserver, assuming systemd-resolved, so using resolv.conf:
> /run/systemd/resolve/resolv.conf"
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.253580688-05:00" level=3Dinfo msg=3D"parsed
> scheme: \"unix\"" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.253663917-05:00" level=3Dinfo msg=3D"scheme
> \"unix\" not registered, fallback to default scheme" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.253737208-05:00" level=3Dinfo
> msg=3D"ccResolverWrapper: sending update to cc:
> {[{unix:///run/containerd/containerd.sock=A0 <nil> 0 <nil>}] <nil> <nil>}"
> module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.253777767-05:00" level=3Dinfo msg=3D"ClientCo=
nn
> switching balancer to \"pick_first\"" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.272602278-05:00" level=3Dinfo msg=3D"parsed
> scheme: \"unix\"" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.272713227-05:00" level=3Dinfo msg=3D"scheme
> \"unix\" not registered, fallback to default scheme" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.272778900-05:00" level=3Dinfo
> msg=3D"ccResolverWrapper: sending update to cc:
> {[{unix:///run/containerd/containerd.sock=A0 <nil> 0 <nil>}] <nil> <nil>}"
> module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.272816740-05:00" level=3Dinfo msg=3D"ClientCo=
nn
> switching balancer to \"pick_first\"" module=3Dgrpc
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.367601799-05:00" level=3Derror msg=3D"failed =
to
> mount overlay: invalid argument" storage-driver=3Doverlay2
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.367792469-05:00" level=3Derror
> msg=3D"[graphdriver] prior storage driver overlay2 failed: driver not
> supported"
> May 18 22:00:10 nocsupport4 dockerd[1104]:
> time=3D"2021-05-18T22:00:10.370914131-05:00" level=3Dinfo msg=3D"stopping
> event stream following graceful shutdown" error=3D"context canceled"
> module=3Dlibcontainerd namespace=3Dplugins.moby
> May 18 22:00:10 nocsupport4 dockerd[1104]: failed to start daemon: error
> initializing graphdriver: driver not supported
> May 18 22:00:10 nocsupport4 systemd[1]: docker.service: Main process
> exited, code=3Dexited, status=3D1/FAILURE
> May 18 22:00:10 nocsupport4 systemd[1]: docker.service: Failed with
> result 'exit-code'.
>=20
> root@nocsupport4:~# cat /etc/fstab
> myfs / virtiofs defaults 0 0
>=20
> On the host:
>=20
> root@noc4:/vmsystems# uname -a
> Linux noc4.xxxx 5.11.0-17-generic
>=20
> root=A0=A0=A0=A0=A0 225434=A0 0.0=A0 0.0=A0 80068=A0 3544 ?=A0=A0=A0=A0=
=A0=A0=A0 Sl=A0=A0 21:32=A0=A0 0:00
> /usr/lib/qemu/virtiofsd --fd=3D32 -o
> source=3D/vmsystems/nocsupport4,xattr,flock,no_posix_lock -o writeback
> libvirt+=A0 225458 85.5=A0 0.7 4366196 236724 ?=A0=A0=A0=A0=A0 Sl=A0=A0 2=
1:32=A0=A0 7:34
> /usr/bin/qemu-system-x86_64 -name guest=3Dnocsupport4,debug-threads=3Don =
-S
> -object
> secret,id=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/domain-6=
-nocsupport4/master-key.aes
> -machine pc-q35-5.0,accel=3Dkvm,usb=3Doff,vmport=3Doff,dump-guest-core=3D=
off
> -cpu
> Conroe,vme=3Don,vmx=3Don,cx16=3Don,pdcm=3Don,x2apic=3Don,tsc-deadline=3Do=
n,hypervisor=3Don,arat=3Don,tsc-adjust=3Don,arch-capabilities=3Don,pdpe1gb=
=3Don,skip-l1dfl-vmentry=3Don,pschange-mc-no=3Don
> -m 3584 -overcommit mem-lock=3Doff -smp 2,sockets=3D2,cores=3D1,threads=
=3D1
> -object
> memory-backend-file,id=3Dram-node0,mem-path=3D/dev/hugepages/libvirt/qemu=
/6-nocsupport4,share=3Dyes,prealloc=3Dyes,size=3D3758096384
> -numa node,nodeid=3D0,cpus=3D0-1,memdev=3Dram-node0 -uuid
> c7b055aa-1874-4ba9-9302-26fad866e749 -no-user-config -nodefaults
> -chardev socket,id=3Dcharmonitor,fd=3D32,server,nowait -mon
> chardev=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol -rtc base=3Dutc,driftfi=
x=3Dslew
> -global kvm-pit.lost_tick_policy=3Ddelay -no-hpet -no-shutdown -global
> ICH9-LPC.disable_s3=3D1 -global ICH9-LPC.disable_s4=3D1 -boot strict=3Don
> -kernel /vmsystems/nocsupport4/boot/vmlinuz -initrd
> /vmsystems/nocsupport4/boot/initrd.img -append rootfstype=3Dvirtiofs
> root=3Dmyfs=A0 rw -device
> pcie-root-port,port=3D0x10,chassis=3D1,id=3Dpci.1,bus=3Dpcie.0,multifunct=
ion=3Don,addr=3D0x2
> -device
> pcie-root-port,port=3D0x11,chassis=3D2,id=3Dpci.2,bus=3Dpcie.0,addr=3D0x2=
.0x1
> -device
> pcie-root-port,port=3D0x12,chassis=3D3,id=3Dpci.3,bus=3Dpcie.0,addr=3D0x2=
.0x2
> -device
> pcie-root-port,port=3D0x13,chassis=3D4,id=3Dpci.4,bus=3Dpcie.0,addr=3D0x2=
.0x3
> -device
> pcie-root-port,port=3D0x14,chassis=3D5,id=3Dpci.5,bus=3Dpcie.0,addr=3D0x2=
.0x4
> -device
> pcie-root-port,port=3D0x15,chassis=3D6,id=3Dpci.6,bus=3Dpcie.0,addr=3D0x2=
.0x5
> -device
> pcie-root-port,port=3D0x16,chassis=3D7,id=3Dpci.7,bus=3Dpcie.0,addr=3D0x2=
.0x6
> -device
> pcie-root-port,port=3D0x17,chassis=3D8,id=3Dpci.8,bus=3Dpcie.0,addr=3D0x2=
.0x7
> -device pcie-pci-bridge,id=3Dpci.9,bus=3Dpci.4,addr=3D0x0 -device
> ich9-usb-ehci1,id=3Dusb,bus=3Dpcie.0,addr=3D0x1d.0x7 -device
> ich9-usb-uhci1,masterbus=3Dusb.0,firstport=3D0,bus=3Dpcie.0,multifunction=
=3Don,addr=3D0x1d
> -device
> ich9-usb-uhci2,masterbus=3Dusb.0,firstport=3D2,bus=3Dpcie.0,addr=3D0x1d.0=
x1
> -device
> ich9-usb-uhci3,masterbus=3Dusb.0,firstport=3D4,bus=3Dpcie.0,addr=3D0x1d.0=
x2
> -device virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.3,addr=3D0x0 -cha=
rdev
> socket,id=3Dchr-vu-fs0,path=3D/var/lib/libvirt/qemu/domain-6-nocsupport4/=
fs0-fs.sock
> -device
> vhost-user-fs-pci,chardev=3Dchr-vu-fs0,queue-size=3D1024,tag=3Dmyfs,bus=
=3Dpci.1,addr=3D0x0
> -netdev tap,fd=3D46,id=3Dhostnet0,vhost=3Don,vhostfd=3D47 -device
> virtio-net-pci,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:30:4d:ca,bus=3D=
pci.2,addr=3D0x0
> -chardev pty,id=3Dcharserial0 -device
> isa-serial,chardev=3Dcharserial0,id=3Dserial0 -chardev
> socket,id=3Dcharchannel0,fd=3D48,server,nowait -device
> virtserialport,bus=3Dvirtio-serial0.0,nr=3D1,chardev=3Dcharchannel0,id=3D=
channel0,name=3Dorg.qemu.guest_agent.0
> -chardev spicevmc,id=3Dcharchannel1,name=3Dvdagent -device
> virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,chardev=3Dcharchannel1,id=3D=
channel1,name=3Dcom.redhat.spice.0
> -device usb-tablet,id=3Dinput0,bus=3Dusb.0,port=3D1 -spice
> port=3D5900,addr=3D127.0.0.1,disable-ticketing,seamless-migration=3Don -d=
evice
> qxl-vga,id=3Dvideo0,ram_size=3D67108864,vram_size=3D67108864,vram64_size_=
mb=3D0,vgamem_mb=3D16,max_outputs=3D1,bus=3Dpcie.0,addr=3D0x1
> -device ich9-intel-hda,id=3Dsound0,bus=3Dpcie.0,addr=3D0x1b -device
> hda-duplex,id=3Dsound0-codec0,bus=3Dsound0.0,cad=3D0 -device
> i6300esb,id=3Dwatchdog0,bus=3Dpci.9,addr=3D0x1 -watchdog-action reset -ch=
ardev
> spicevmc,id=3Dcharredir0,name=3Dusbredir -device
> usb-redir,chardev=3Dcharredir0,id=3Dredir0,bus=3Dusb.0,port=3D2 -chardev
> spicevmc,id=3Dcharredir1,name=3Dusbredir -device
> usb-redir,chardev=3Dcharredir1,id=3Dredir1,bus=3Dusb.0,port=3D3 -device
> virtio-balloon-pci,id=3Dballoon0,bus=3Dpci.5,addr=3D0x0 -object
> rng-random,id=3Dobjrng0,filename=3D/dev/urandom -device
> virtio-rng-pci,rng=3Dobjrng0,id=3Drng0,bus=3Dpci.6,addr=3D0x0 -sandbox
> on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=3Ddeny,resourcecontrol=
=3Ddeny
> -msg timestamp=3Don
> root=A0=A0=A0=A0=A0 225472 11.0=A0 0.0 6889960 10848 ?=A0=A0=A0=A0=A0=A0 =
Sl=A0=A0 21:32=A0=A0 0:58
> /usr/lib/qemu/virtiofsd --fd=3D32 -o
> source=3D/vmsystems/nocsupport4,xattr,flock,no_posix_lock -o writeback
>=20
>=20
>=20
>=20
>=20
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
--=20
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

