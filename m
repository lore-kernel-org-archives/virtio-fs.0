DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:cc:references:from:subject:message-id:date:user-agent
	:mime-version:in-reply-to:content-transfer-encoding:content-language;
	bh=XCDRjBo7+or4DbdVef9bsSjFrUSkym1d0pyf9zQ1HUU=;
	b=KjOR1WNfqiBJtMRuZV/ii8wrFQYCMR+OreMVFvlowD2tYr5eh9QChGl9vhm1Gez9Of
	X8N6SuhexOADMR7CEUmcmaoVsnGlbn5RIWh3/FQ631PJlwfnrmhDtsOttlFE/1xLCwyT
	fy/9itQJa2EmvYrCyJ1aio19AXqqx5PuhHBRXjxSlOpLi6vbOE9n91s7LDmQxD5DAfR1
	OVbSrSQZ6YUw1otfZ96hfjxlVq5yWgNRsJJStaOINuXI8S83dzVSPP7yiTphxmp4XOTs
	1C4fBfKFr7h6cfziyrSSqWWu0LHhaZi8aDxK7Za4/33uE9FdWgUJUaC/DTtCnyBcfzc5
	whWg==
References: <20210518213538.693422-1-vgoyal@redhat.com>
	<20210518213538.693422-8-vgoyal@redhat.com>
	<41df4f6a-6d40-745d-aacd-9c4b66a31f3e@gmail.com>
	<YKU/UD9SycU62WSn@work-vm>
From: "Harry G. Coin" <hgcoin@gmail.com>
Message-ID: <62ea3990-0145-5168-7b96-68480b25f0f6@gmail.com>
Date: Wed, 19 May 2021 16:36:20 -0500
MIME-Version: 1.0
In-Reply-To: <YKU/UD9SycU62WSn@work-vm>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] Regression: Docker in vms broken.
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com


On 5/19/21 11:39 AM, Dr. David Alan Gilbert wrote:
> * Harry G. Coin (hgcoin@gmail.com) wrote:
>> Something changed in virtiofs, likely to do with overlay support? 
> Hmm I don't think we have any explicit support in for overlayfs though.
>
>> Docker in a vm with virtiofs as root running with kernel 
>> 5.8.0-53-generic works normally.  However, later 5.8 versions and also
>> 5.11 versions fail with:
> Hmm, so what's your last working & first failing version of 5.8 ?


I know that docker works in the VM (and has been for some months) with
guest and host running kernel 5.8.0-53-generic.  At least 3 docker
containers were running in the guest, and under conditions of heavy load
(ceph monitors, managers and filesystem gateways).   This was the case
on at least four similarly configured servers.  There is only ever one
guest vm accessing the underlying files on the hosts, and no contention
on the host for those files.  The FS on the host is btrfs, and xattr is
enabled on virtiofsd.  As the BAR on the pci device in mainline QEMU
hasn't made it into even bleeding-edge distros as yet, there is no dax. 
(And even after the pci bar makes it into qemu, I don't think dax will
find heavy adoption until it's also supported in libvirtd and virt-manager.)

root@noc3:~# /usr/lib/qemu/virtiofsd --version
using FUSE kernel interface version 7.31

When the *host*  updated to  5.11.0-17-generic (later virtiofsd), the
guest fails to run docker, erroring out as noted.

root@noc4:/vmsystems# /usr/lib/qemu/virtiofsd --version
using FUSE kernel interface version 7.32







> Dave
>
>> May 18 22:00:07 nocsupport4 systemd[1]: docker.service: Scheduled
>> restart job, restart counter is at 2.
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.061661124-05:00" level=info msg="Starting up"
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.109655841-05:00" level=info msg="detected
>> 127.0.0.53 nameserver, assuming systemd-resolved, so using resolv.conf:
>> /run/systemd/resolve/resolv.conf"
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.253580688-05:00" level=info msg="parsed
>> scheme: \"unix\"" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.253663917-05:00" level=info msg="scheme
>> \"unix\" not registered, fallback to default scheme" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.253737208-05:00" level=info
>> msg="ccResolverWrapper: sending update to cc:
>> {[{unix:///run/containerd/containerd.sock  <nil> 0 <nil>}] <nil> <nil>}"
>> module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.253777767-05:00" level=info msg="ClientConn
>> switching balancer to \"pick_first\"" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.272602278-05:00" level=info msg="parsed
>> scheme: \"unix\"" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.272713227-05:00" level=info msg="scheme
>> \"unix\" not registered, fallback to default scheme" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.272778900-05:00" level=info
>> msg="ccResolverWrapper: sending update to cc:
>> {[{unix:///run/containerd/containerd.sock  <nil> 0 <nil>}] <nil> <nil>}"
>> module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.272816740-05:00" level=info msg="ClientConn
>> switching balancer to \"pick_first\"" module=grpc
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.367601799-05:00" level=error msg="failed to
>> mount overlay: invalid argument" storage-driver=overlay2
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.367792469-05:00" level=error
>> msg="[graphdriver] prior storage driver overlay2 failed: driver not
>> supported"
>> May 18 22:00:10 nocsupport4 dockerd[1104]:
>> time="2021-05-18T22:00:10.370914131-05:00" level=info msg="stopping
>> event stream following graceful shutdown" error="context canceled"
>> module=libcontainerd namespace=plugins.moby
>> May 18 22:00:10 nocsupport4 dockerd[1104]: failed to start daemon: error
>> initializing graphdriver: driver not supported
>> May 18 22:00:10 nocsupport4 systemd[1]: docker.service: Main process
>> exited, code=exited, status=1/FAILURE
>> May 18 22:00:10 nocsupport4 systemd[1]: docker.service: Failed with
>> result 'exit-code'.
>>
>> root@nocsupport4:~# cat /etc/fstab
>> myfs / virtiofs defaults 0 0
>>
>> On the host:
>>
>> root@noc4:/vmsystems# uname -a
>> Linux noc4.xxxx 5.11.0-17-generic
>>
>> root      225434  0.0  0.0  80068  3544 ?        Sl   21:32   0:00
>> /usr/lib/qemu/virtiofsd --fd=32 -o
>> source=/vmsystems/nocsupport4,xattr,flock,no_posix_lock -o writeback
>> libvirt+  225458 85.5  0.7 4366196 236724 ?      Sl   21:32   7:34
>> /usr/bin/qemu-system-x86_64 -name guest=nocsupport4,debug-threads=on -S
>> -object
>> secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-6-nocsupport4/master-key.aes
>> -machine pc-q35-5.0,accel=kvm,usb=off,vmport=off,dump-guest-core=off
>> -cpu
>> Conroe,vme=on,vmx=on,cx16=on,pdcm=on,x2apic=on,tsc-deadline=on,hypervisor=on,arat=on,tsc-adjust=on,arch-capabilities=on,pdpe1gb=on,skip-l1dfl-vmentry=on,pschange-mc-no=on
>> -m 3584 -overcommit mem-lock=off -smp 2,sockets=2,cores=1,threads=1
>> -object
>> memory-backend-file,id=ram-node0,mem-path=/dev/hugepages/libvirt/qemu/6-nocsupport4,share=yes,prealloc=yes,size=3758096384
>> -numa node,nodeid=0,cpus=0-1,memdev=ram-node0 -uuid
>> c7b055aa-1874-4ba9-9302-26fad866e749 -no-user-config -nodefaults
>> -chardev socket,id=charmonitor,fd=32,server,nowait -mon
>> chardev=charmonitor,id=monitor,mode=control -rtc base=utc,driftfix=slew
>> -global kvm-pit.lost_tick_policy=delay -no-hpet -no-shutdown -global
>> ICH9-LPC.disable_s3=1 -global ICH9-LPC.disable_s4=1 -boot strict=on
>> -kernel /vmsystems/nocsupport4/boot/vmlinuz -initrd
>> /vmsystems/nocsupport4/boot/initrd.img -append rootfstype=virtiofs
>> root=myfs  rw -device
>> pcie-root-port,port=0x10,chassis=1,id=pci.1,bus=pcie.0,multifunction=on,addr=0x2
>> -device
>> pcie-root-port,port=0x11,chassis=2,id=pci.2,bus=pcie.0,addr=0x2.0x1
>> -device
>> pcie-root-port,port=0x12,chassis=3,id=pci.3,bus=pcie.0,addr=0x2.0x2
>> -device
>> pcie-root-port,port=0x13,chassis=4,id=pci.4,bus=pcie.0,addr=0x2.0x3
>> -device
>> pcie-root-port,port=0x14,chassis=5,id=pci.5,bus=pcie.0,addr=0x2.0x4
>> -device
>> pcie-root-port,port=0x15,chassis=6,id=pci.6,bus=pcie.0,addr=0x2.0x5
>> -device
>> pcie-root-port,port=0x16,chassis=7,id=pci.7,bus=pcie.0,addr=0x2.0x6
>> -device
>> pcie-root-port,port=0x17,chassis=8,id=pci.8,bus=pcie.0,addr=0x2.0x7
>> -device pcie-pci-bridge,id=pci.9,bus=pci.4,addr=0x0 -device
>> ich9-usb-ehci1,id=usb,bus=pcie.0,addr=0x1d.0x7 -device
>> ich9-usb-uhci1,masterbus=usb.0,firstport=0,bus=pcie.0,multifunction=on,addr=0x1d
>> -device
>> ich9-usb-uhci2,masterbus=usb.0,firstport=2,bus=pcie.0,addr=0x1d.0x1
>> -device
>> ich9-usb-uhci3,masterbus=usb.0,firstport=4,bus=pcie.0,addr=0x1d.0x2
>> -device virtio-serial-pci,id=virtio-serial0,bus=pci.3,addr=0x0 -chardev
>> socket,id=chr-vu-fs0,path=/var/lib/libvirt/qemu/domain-6-nocsupport4/fs0-fs.sock
>> -device
>> vhost-user-fs-pci,chardev=chr-vu-fs0,queue-size=1024,tag=myfs,bus=pci.1,addr=0x0
>> -netdev tap,fd=46,id=hostnet0,vhost=on,vhostfd=47 -device
>> virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:30:4d:ca,bus=pci.2,addr=0x0
>> -chardev pty,id=charserial0 -device
>> isa-serial,chardev=charserial0,id=serial0 -chardev
>> socket,id=charchannel0,fd=48,server,nowait -device
>> virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,id=channel0,name=org.qemu.guest_agent.0
>> -chardev spicevmc,id=charchannel1,name=vdagent -device
>> virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,id=channel1,name=com.redhat.spice.0
>> -device usb-tablet,id=input0,bus=usb.0,port=1 -spice
>> port=5900,addr=127.0.0.1,disable-ticketing,seamless-migration=on -device
>> qxl-vga,id=video0,ram_size=67108864,vram_size=67108864,vram64_size_mb=0,vgamem_mb=16,max_outputs=1,bus=pcie.0,addr=0x1
>> -device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b -device
>> hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 -device
>> i6300esb,id=watchdog0,bus=pci.9,addr=0x1 -watchdog-action reset -chardev
>> spicevmc,id=charredir0,name=usbredir -device
>> usb-redir,chardev=charredir0,id=redir0,bus=usb.0,port=2 -chardev
>> spicevmc,id=charredir1,name=usbredir -device
>> usb-redir,chardev=charredir1,id=redir1,bus=usb.0,port=3 -device
>> virtio-balloon-pci,id=balloon0,bus=pci.5,addr=0x0 -object
>> rng-random,id=objrng0,filename=/dev/urandom -device
>> virtio-rng-pci,rng=objrng0,id=rng0,bus=pci.6,addr=0x0 -sandbox
>> on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny
>> -msg timestamp=on
>> root      225472 11.0  0.0 6889960 10848 ?       Sl   21:32   0:58
>> /usr/lib/qemu/virtiofsd --fd=32 -o
>> source=/vmsystems/nocsupport4,xattr,flock,no_posix_lock -o writeback
>>
>>
>>
>>
>>
>>
>> _______________________________________________
>> Virtio-fs mailing list
>> Virtio-fs@redhat.com
>> https://listman.redhat.com/mailman/listinfo/virtio-fs


