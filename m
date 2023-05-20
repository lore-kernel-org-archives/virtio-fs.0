Return-Path: <daggs@gmx.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com; s=s31663417;
 t=1684577730; i=daggs@gmx.com;
 bh=BPi351b3cEAO/9mABW7kY33YkxUeYeae9znHW1FHnT8=;
 h=X-UI-Sender-Class:From:To:Subject:Date;
 b=mXfYks1XP6vMcvqhycfXUHCwiKCqF+rsVGlTgN87jxKsaya7l5QKZZszHqUMXb/Bg
 9sPUpGJRXstl+TjSdua7eojg31bkv/hSemE8gLLOabPG6j2zm7wRkxD5hmD/TYiP4E
 J48GbPyj+jCaI7Nuj0EnLsG6hYiM8Xm7a9hPfCCtPE/ec73bg8MyAoRaFvP4QO9HHm
 IgnGCr5d/AuAb+s4Lta6mf31X5WFpnk7jDMuHdQ1xkKkQIYWj5Y2LBm96kfKzcq8CE
 xvyqyPa2Drp6sNntyDdbl8H/02WsGbmKUibSQsJ33PZVlp0qejoZBjD4z2atJTDeuG
 WVbX/7nwvWemA==
MIME-Version: 1.0
Message-ID: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
From: daggs <daggs@gmx.com>
Date: Sat, 20 May 2023 12:10:28 +0200
Content-Type: text/plain; charset=UTF-8
Subject: [Virtio-fs] vm hangs when booting with virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Greetings,

I'm trying to boot a win11 vm with a virtiofs fs and the system just hangs on boot, I'd like some incites on what is the issue.
here is what I'm using:
- kernel 6.3.3
- libvirt 9.3.0
- qemu 8.0.0
- virtiofsd 1.5.1

I'm using the following cmd to run virtiofsd using socket: virtiofsd --socket-path=/var/lib/libvirt/helpers_state/windows/linux_home.socket --shared-dir /home/daggs --cache auto
where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K (tried with 1M too, same behavior)
the virtiofsd invocation is issued inside the prepare and begin qemu hook on libvirt.
I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO virtiofsd] Waiting for vhost-user socket connection...
and I call it like this: nohup <virtiofsd cmd> &

the vm's relevant config is this:
<domain type='kvm'>
...
<memory unit='KiB'>24582144</memory>
<currentMemory unit='KiB'>24582144</currentMemory>
<memoryBacking>
<source type='memfd'/>
<access mode='shared'/>
</memoryBacking>
<vcpu placement='static'>12</vcpu>
<cputune>
<vcpupin vcpu='0' cpuset='4'/>
<vcpupin vcpu='1' cpuset='5'/>
<vcpupin vcpu='2' cpuset='6'/>
<vcpupin vcpu='3' cpuset='7'/>
<vcpupin vcpu='4' cpuset='8'/>
<vcpupin vcpu='5' cpuset='9'/>
<vcpupin vcpu='6' cpuset='10'/>
<vcpupin vcpu='7' cpuset='11'/>
<vcpupin vcpu='8' cpuset='12'/>
<vcpupin vcpu='9' cpuset='13'/>
<vcpupin vcpu='10' cpuset='14'/>
<vcpupin vcpu='11' cpuset='15'/>
<emulatorpin cpuset='0-1'/>
</cputune>

...
<cpu mode='host-passthrough' check='none' migratable='on'>
<topology sockets='1' dies='1' cores='6' threads='2'/>
<cache mode='passthrough'/>
<feature policy='require' name='topoext'/>
</cpu>
...
<filesystem type='mount' accessmode='passthrough'>
<driver type='virtiofs' queue='1024'/>
<binary path='/usr/bin/virtiofsd'/>
<source socket='/var/lib/libvirt/helpers_state/windows/linux_home.socket'/>
<target dir='linux_home'/>
<address type='pci' domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
</filesystem>
...
</domain>

I'm running it via virsh, added -d 4, no errors in the log
when it is stuck, I get a black screen (using gpu pt to guest which work without it), ps shows both virsh start cmd running and stuck, two virtiofsd instances are up.
any ideas how to solve this?

Thanks,

Dagg

