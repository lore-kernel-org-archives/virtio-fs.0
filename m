Return-Path: <daggs@gmx.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.com; s=s31663417;
 t=1684996695; i=daggs@gmx.com;
 bh=f12WxO8FUOhhBoldN449LIxQ0QnIcEZ6ltGSraCx46w=;
 h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
 b=Bey5I82ChLwoGMdueGgXzsNT2aYgXuDu+evPA0V+svVaNOI1/Quycch1B6SAR4YqA
 H1q9paD4aR6pKoYXRNfEVE8+VPs1wRDKYvoW1ytTvA5te+6C6VB53GUDpBILYd19Rd
 UHYm2OkL58yYZm10bLTGT+k/f/9S2NzXhaG1MqE91Wl33uvQPJyGSpit92qgah3mLc
 4+5IxfpLMi2sRDp7SOAWa7KnXSTs9ENQeV8D3nmtN96ydJNMtz4IvcFve2YBD+Bxbx
 x7dXU5OL1BjWZRLBLFEjXLdr4oY5kir2HTj9JngVkCb8X6fDhVUv2vixmXorVlrxKG
 ktVxPsFThUODQ==
MIME-Version: 1.0
Message-ID: <trinity-bd64299a-0573-4343-afa2-b6071eb7d7b0-1684996695218@3c-app-mailcom-bs11>
From: daggs <daggs@gmx.com>
Date: Thu, 25 May 2023 08:38:15 +0200
In-Reply-To: <CAJh=p+42T8VRkdE5citVFbgUCXF10vf-c3589c-JBbWQ0Yq2Nw@mail.gmail.com>
References: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
 <CAJh=p+42T8VRkdE5citVFbgUCXF10vf-c3589c-JBbWQ0Yq2Nw@mail.gmail.com>
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
>Sent:=C2=A0Wednesday, May 24, 2023 at 5:51 PM
>From:=C2=A0"German Maglione" <gmaglione@redhat.com>
>To:=C2=A0"daggs" <daggs@gmx.com>
>Cc:=C2=A0virtio-fs@redhat.com
>Subject:=C2=A0Re: [Virtio-fs] vm hangs when booting with virtiofs
>
>=C2=A0=C2=A0
>
>>On Sat, May 20, 2023 at 12:15=E2=80=AFPM daggs <daggs@gmx.com[mailto:dagg=
s@gmx.com]> wrote:Greetings,
>>
>>I'm trying to boot a win11 vm with a virtiofs fs and the system just hang=
s on boot, I'd like some incites on what is the issue.
>>here is what I'm using:
>>- kernel 6.3.3
>>- libvirt 9.3.0
>>- qemu 8.0.0
>>- virtiofsd 1.5.1
>>
>>I'm using the following cmd to run virtiofsd using socket: virtiofsd --so=
cket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.socket --shar=
ed-dir /home/daggs --cache auto
>>where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K (tr=
ied with 1M too, same behavior)
>>the virtiofsd invocation is issued inside the prepare and begin qemu hook=
 on libvirt.
>>I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO virtiof=
sd] Waiting for vhost-user socket connection...
>>and I call it like this: nohup <virtiofsd cmd> &
>>
>>the vm's relevant config is this:
>><domain type=3D'kvm'>
>>...
>><memory unit=3D'KiB'>24582144</memory>
>><currentMemory unit=3D'KiB'>24582144</currentMemory>
>><memoryBacking>
>><source type=3D'memfd'/>
>><access mode=3D'shared'/>
>></memoryBacking>
>><vcpu placement=3D'static'>12</vcpu>
>><cputune>
>><vcpupin vcpu=3D'0' cpuset=3D'4'/>
>><vcpupin vcpu=3D'1' cpuset=3D'5'/>
>><vcpupin vcpu=3D'2' cpuset=3D'6'/>
>><vcpupin vcpu=3D'3' cpuset=3D'7'/>
>><vcpupin vcpu=3D'4' cpuset=3D'8'/>
>><vcpupin vcpu=3D'5' cpuset=3D'9'/>
>><vcpupin vcpu=3D'6' cpuset=3D'10'/>
>><vcpupin vcpu=3D'7' cpuset=3D'11'/>
>><vcpupin vcpu=3D'8' cpuset=3D'12'/>
>><vcpupin vcpu=3D'9' cpuset=3D'13'/>
>><vcpupin vcpu=3D'10' cpuset=3D'14'/>
>><vcpupin vcpu=3D'11' cpuset=3D'15'/>
>><emulatorpin cpuset=3D'0-1'/>
>></cputune>
>>
>>...
>><cpu mode=3D'host-passthrough' check=3D'none' migratable=3D'on'>
>><topology sockets=3D'1' dies=3D'1' cores=3D'6' threads=3D'2'/>
>><cache mode=3D'passthrough'/>
>><feature policy=3D'require' name=3D'topoext'/>
>></cpu>
>>...
>><filesystem type=3D'mount' accessmode=3D'passthrough'>
>><driver type=3D'virtiofs' queue=3D'1024'/>
>><binary path=3D'/usr/bin/virtiofsd'/>
>><source socket=3D'/var/lib/libvirt/helpers_state/windows/linux_home.socke=
t'/>
>><target dir=3D'linux_home'/>
>><address type=3D'pci' domain=3D'0x0000' bus=3D'0x07' slot=3D'0x00' functi=
on=3D'0x0'/>
>></filesystem>
>>...
>></domain>
>>
>>I'm running it via virsh, added -d 4, no errors in the log
>>when it is stuck, I get a black screen (using gpu pt to guest which work =
without it), ps shows both virsh start cmd running and stuck, two virtiofsd=
 instances are up.
>>any ideas how to solve this?
>>=C2=A0
>>=C2=A0
>I forgot, could you replace your '/usr/bin/virtiofsd' with a shell script =
that runs `virtiofsd --log-level=3Ddebug ...` and post the log output
>=C2=A0
>If you want, you can open an issue here:
>https://gitlab.com/virtio-fs/virtiofsd/-/issues[https://gitlab.com/virtio-=
fs/virtiofsd/-/issues]
do you mean run it from inside libvirt?
I tried that, seems like virtiofsd fails because libvirt uses deprecated cl=
i params
that is why I'm using sockets and running it from outside libvirt

>>=C2=A0
>>Thanks,
>>=C2=A0Thanks,
>>
>>Dagg
>>
>>_______________________________________________
>>Virtio-fs mailing list
>>Virtio-fs@redhat.com[mailto:Virtio-fs@redhat.com]
>>https://listman.redhat.com/mailman/listinfo/virtio-fs
>=C2=A0
>
>--
>
>German

Thanks,

Dagg

