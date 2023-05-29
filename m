Return-Path: <daggs@gmx.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com; s=s31663417;
 t=1685395611; i=daggs@gmx.com;
 bh=VLt3RFAEDY8Gh0VZp1o40JoTXq6kB9YpEF3baXwpggc=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=U7wExk+0aoCelL1Mkxb8XXliPyVGSJz+wkfj6pxxwwmofHJQxcn0zT6MR2sy07x4v
 tg+kQlt4q2GPRRGZDPcAMPrl2w7vSZNDSNgqzCF9liIsu0QxPnMNVl0zudVRrBV1ML
 PK0NI79C5f8cy0rJVd1ysH/a4iJXVtAROg0aUobx2Zc/lwPRLInAg/TaXK/JF1tr3A
 xHtlLF9ACm3LQs8jzrWotbNONv557VUug3HBRyf0w6O19dCLBkrySUN3Kgb6vl5s4P
 ZewLzVMNkbvOTBllSd1pzMIRY0xDSjxXIVZ/aHGlNb/ghkNWUXJEiYN+ioB9De5Qv7
 Xe1nm37Y50BAA==
MIME-Version: 1.0
Message-ID: <trinity-e4a62945-4a5c-419c-874e-a2e130ffeee2-1685395611788@3c-app-mailcom-bs04>
From: daggs <daggs@gmx.com>
Date: Mon, 29 May 2023 23:26:51 +0200
In-Reply-To: <CAJh=p+71zuPObZNf0-kYo-hviw0jYODfVczOFZuaRr4gvFvQ-Q@mail.gmail.com>
References: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
 <CAJh=p+42T8VRkdE5citVFbgUCXF10vf-c3589c-JBbWQ0Yq2Nw@mail.gmail.com>
 <trinity-bd64299a-0573-4343-afa2-b6071eb7d7b0-1684996695218@3c-app-mailcom-bs11>
 <CAJh=p+71zuPObZNf0-kYo-hviw0jYODfVczOFZuaRr4gvFvQ-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] vm hangs when booting with virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs@redhat.com

Greetings German,

>
>Sent:=C2=A0Thursday, May 25, 2023 at 4:57 PM
>From:=C2=A0"German Maglione" <gmaglione@redhat.com>
>To:=C2=A0"daggs" <daggs@gmx.com>
>Cc:=C2=A0virtio-fs@redhat.com
>Subject:=C2=A0Re: [Virtio-fs] vm hangs when booting with virtiofs
>
>I'm copying your response to this email
>=C2=A0
>> >If you swap your win11 for a linux guest (using the same libvirt xml) a=
re you able to reproduce the error?
>> do you think the guest type matters much?
>=C2=A0
>Yes, because the windows guest uses a different driver. So the problem cou=
ld be virtiofsd daemon,
>the linux kernel or the windows drivers
didn't tried it yet but the behavior I'm seeing has changed, now it doesn't=
 boots, just fails without any apparent reason

>=C2=A0=C2=A0
>
>On Thu, May 25, 2023 at 8:38=E2=80=AFAM daggs <daggs@gmx.com[mailto:daggs@=
gmx.com]> wrote:Greetings German,
>>
>>Sent:=C2=A0Wednesday, May 24, 2023 at 5:51 PM
>>From:=C2=A0"German Maglione" <gmaglione@redhat.com[mailto:gmaglione@redha=
t.com]>
>>To:=C2=A0"daggs" <daggs@gmx.com[mailto:daggs@gmx.com]>
>>Cc:=C2=A0virtio-fs@redhat.com[mailto:virtio-fs@redhat.com]
>>Subject:=C2=A0Re: [Virtio-fs] vm hangs when booting with virtiofs
>>
>>=C2=A0=C2=A0
>>
>>>On Sat, May 20, 2023 at 12:15=E2=80=AFPM daggs <daggs@gmx.com[mailto:dag=
gs@gmx.com][mailto:daggs@gmx.com[mailto:daggs@gmx.com]]> wrote:Greetings,
>>>
>>>I'm trying to boot a win11 vm with a virtiofs fs and the system just han=
gs on boot, I'd like some incites on what is the issue.
>>>here is what I'm using:
>>>- kernel 6.3.3
>>>- libvirt 9.3.0
>>>- qemu 8.0.0
>>>- virtiofsd 1.5.1
>>>
>>>I'm using the following cmd to run virtiofsd using socket: virtiofsd --s=
ocket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.socket --sha=
red-dir /home/daggs --cache auto
>>>where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K (t=
ried with 1M too, same behavior)
>>>the virtiofsd invocation is issued inside the prepare and begin qemu hoo=
k on libvirt.
>>>I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO virtio=
fsd] Waiting for vhost-user socket connection...
>>>and I call it like this: nohup <virtiofsd cmd> &
>>>
>>>the vm's relevant config is this:
>>><domain type=3D'kvm'>
>>>...
>>><memory unit=3D'KiB'>24582144</memory>
>>><currentMemory unit=3D'KiB'>24582144</currentMemory>
>>><memoryBacking>
>>><source type=3D'memfd'/>
>>><access mode=3D'shared'/>
>>></memoryBacking>
>>><vcpu placement=3D'static'>12</vcpu>
>>><cputune>
>>><vcpupin vcpu=3D'0' cpuset=3D'4'/>
>>><vcpupin vcpu=3D'1' cpuset=3D'5'/>
>>><vcpupin vcpu=3D'2' cpuset=3D'6'/>
>>><vcpupin vcpu=3D'3' cpuset=3D'7'/>
>>><vcpupin vcpu=3D'4' cpuset=3D'8'/>
>>><vcpupin vcpu=3D'5' cpuset=3D'9'/>
>>><vcpupin vcpu=3D'6' cpuset=3D'10'/>
>>><vcpupin vcpu=3D'7' cpuset=3D'11'/>
>>><vcpupin vcpu=3D'8' cpuset=3D'12'/>
>>><vcpupin vcpu=3D'9' cpuset=3D'13'/>
>>><vcpupin vcpu=3D'10' cpuset=3D'14'/>
>>><vcpupin vcpu=3D'11' cpuset=3D'15'/>
>>><emulatorpin cpuset=3D'0-1'/>
>>></cputune>
>>>
>>>...
>>><cpu mode=3D'host-passthrough' check=3D'none' migratable=3D'on'>
>>><topology sockets=3D'1' dies=3D'1' cores=3D'6' threads=3D'2'/>
>>><cache mode=3D'passthrough'/>
>>><feature policy=3D'require' name=3D'topoext'/>
>>></cpu>
>>>...
>>><filesystem type=3D'mount' accessmode=3D'passthrough'>
>>><driver type=3D'virtiofs' queue=3D'1024'/>
>>><binary path=3D'/usr/bin/virtiofsd'/>
>>><source socket=3D'/var/lib/libvirt/helpers_state/windows/linux_home.sock=
et'/>
>>><target dir=3D'linux_home'/>
>>><address type=3D'pci' domain=3D'0x0000' bus=3D'0x07' slot=3D'0x00' funct=
ion=3D'0x0'/>
>>></filesystem>
>>>...
>>></domain>
>>>
>>>I'm running it via virsh, added -d 4, no errors in the log
>>>when it is stuck, I get a black screen (using gpu pt to guest which work=
 without it), ps shows both virsh start cmd running and stuck, two virtiofs=
d instances are up.
>>>any ideas how to solve this?
>>>=C2=A0
>>>=C2=A0
>>I forgot, could you replace your '/usr/bin/virtiofsd' with a shell script=
 that runs `virtiofsd --log-level=3Ddebug ...` and post the log output
>>=C2=A0
>>If you want, you can open an issue here:
>>https://gitlab.com/virtio-fs/virtiofsd/-/issues[https://gitlab.com/virtio=
-fs/virtiofsd/-/issues][https://gitlab.com/virtio-fs/virtiofsd/-/issues%5Bh=
ttps://gitlab.com/virtio-fs/virtiofsd/-/issues%5D]
>do you mean run it from inside libvirt?
>I tried that, seems like virtiofsd fails because libvirt uses deprecated c=
li params
>that is why I'm using sockets and running it from outside libvirt
>=C2=A0
>=C2=A0
>Oh great, I didn't realize you were calling virtiofsd directly, easier the=
n, just call
>virtiofsd --log-level=3Ddebug
>=C2=A0
>and please also using strace, like:
>strace -f -o vfsd.strace.log=C2=A0 virtiofsd ...
here: https://bpa.st/HWCGI

btw, is it logical that after I'm taking the pid num and send term singal t=
hat there will be leftover processes?
maybe it is related to how I'm calling it (using nohup as I didn't find how=
 to demonize it)

>=C2=A0
>=C2=A0>>=C2=A0
>>>Thanks,
>>>=C2=A0Thanks,
>>>
>>>Dagg
>>>
>>>_______________________________________________
>>>Virtio-fs mailing list
>>>Virtio-fs@redhat.com[mailto:Virtio-fs@redhat.com][mailto:Virtio-fs@redha=
t.com[mailto:Virtio-fs@redhat.com]]
>>>https://listman.redhat.com/mailman/listinfo/virtio-fs[https://listman.re=
dhat.com/mailman/listinfo/virtio-fs]
>>=C2=A0
>>
>>--
>>
>>German
>
>Thanks,
>
>Dagg
>=C2=A0
>
>--
>
>German

