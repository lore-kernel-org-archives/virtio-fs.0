Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
In-Reply-To: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 24 May 2023 16:47:28 +0200
Message-ID: <CAJh=p+7CMxn8KWZUREtKt=asZSJu+8W=YA=tmQdObngJmp9RSQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000005db76205fc71971f"
Subject: Re: [Virtio-fs] vm hangs when booting with virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: daggs <daggs@gmx.com>
Cc: virtio-fs@redhat.com

--0000000000005db76205fc71971f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, May 20, 2023 at 12:15=E2=80=AFPM daggs <daggs@gmx.com> wrote:

> Greetings,
>
> I'm trying to boot a win11 vm with a virtiofs fs and the system just hang=
s
> on boot, I'd like some incites on what is the issue.
> here is what I'm using:
> - kernel 6.3.3
> - libvirt 9.3.0
> - qemu 8.0.0
> - virtiofsd 1.5.1
>

If you swap your win11 for a linux guest (using the same libvirt xml) are
you able to reproduce the error?


>
> I'm using the following cmd to run virtiofsd using socket: virtiofsd
> --socket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.socket
> --shared-dir /home/daggs --cache auto
> where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K
> (tried with 1M too, same behavior)
> the virtiofsd invocation is issued inside the prepare and begin qemu hook
> on libvirt.
> I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO
> virtiofsd] Waiting for vhost-user socket connection...
> and I call it like this: nohup <virtiofsd cmd> &
>
> the vm's relevant config is this:
> <domain type=3D'kvm'>
> ...
> <memory unit=3D'KiB'>24582144</memory>
> <currentMemory unit=3D'KiB'>24582144</currentMemory>
> <memoryBacking>
> <source type=3D'memfd'/>
> <access mode=3D'shared'/>
> </memoryBacking>
> <vcpu placement=3D'static'>12</vcpu>
> <cputune>
> <vcpupin vcpu=3D'0' cpuset=3D'4'/>
> <vcpupin vcpu=3D'1' cpuset=3D'5'/>
> <vcpupin vcpu=3D'2' cpuset=3D'6'/>
> <vcpupin vcpu=3D'3' cpuset=3D'7'/>
> <vcpupin vcpu=3D'4' cpuset=3D'8'/>
> <vcpupin vcpu=3D'5' cpuset=3D'9'/>
> <vcpupin vcpu=3D'6' cpuset=3D'10'/>
> <vcpupin vcpu=3D'7' cpuset=3D'11'/>
> <vcpupin vcpu=3D'8' cpuset=3D'12'/>
> <vcpupin vcpu=3D'9' cpuset=3D'13'/>
> <vcpupin vcpu=3D'10' cpuset=3D'14'/>
> <vcpupin vcpu=3D'11' cpuset=3D'15'/>
> <emulatorpin cpuset=3D'0-1'/>
> </cputune>
>
> ...
> <cpu mode=3D'host-passthrough' check=3D'none' migratable=3D'on'>
> <topology sockets=3D'1' dies=3D'1' cores=3D'6' threads=3D'2'/>
> <cache mode=3D'passthrough'/>
> <feature policy=3D'require' name=3D'topoext'/>
> </cpu>
> ...
> <filesystem type=3D'mount' accessmode=3D'passthrough'>
> <driver type=3D'virtiofs' queue=3D'1024'/>
> <binary path=3D'/usr/bin/virtiofsd'/>
> <source socket=3D'/var/lib/libvirt/helpers_state/windows/linux_home.socke=
t'/>
> <target dir=3D'linux_home'/>
> <address type=3D'pci' domain=3D'0x0000' bus=3D'0x07' slot=3D'0x00' functi=
on=3D'0x0'/>
> </filesystem>
> ...
> </domain>
>
> I'm running it via virsh, added -d 4, no errors in the log
> when it is stuck, I get a black screen (using gpu pt to guest which work
> without it), ps shows both virsh start cmd running and stuck, two virtiof=
sd
> instances are up.
> any ideas how to solve this?
>
> Thanks,
>
> Dagg
>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>
>

--=20
German

--0000000000005db76205fc71971f
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi,<br></div><br><div class=3D"gmail_quot=
e"><div dir=3D"ltr" class=3D"gmail_attr">On Sat, May 20, 2023 at 12:15=E2=
=80=AFPM daggs &lt;<a href=3D"mailto:daggs@gmx.com">daggs@gmx.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Greetings,=
<br>
<br>
I&#39;m trying to boot a win11 vm with a virtiofs fs and the system just ha=
ngs on boot, I&#39;d like some incites on what is the issue.<br>
here is what I&#39;m using:<br>
- kernel 6.3.3<br>
- libvirt 9.3.0<br>
- qemu 8.0.0<br>
- virtiofsd 1.5.1<br></blockquote><div><br></div><div>If you swap your win1=
1 for a linux guest (using the same libvirt xml) are you able to reproduce =
the error?<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" styl=
e=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddin=
g-left:1ex">
<br>
I&#39;m using the following cmd to run virtiofsd using socket: virtiofsd --=
socket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.socket --sh=
ared-dir /home/daggs --cache auto<br>
where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K (trie=
d with 1M too, same behavior)<br>
the virtiofsd invocation is issued inside the prepare and begin qemu hook o=
n libvirt.<br>
I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO virtiofsd=
] Waiting for vhost-user socket connection...<br>
and I call it like this: nohup &lt;virtiofsd cmd&gt; &amp;<br>
<br>
the vm&#39;s relevant config is this:<br>
&lt;domain type=3D&#39;kvm&#39;&gt;<br>
...<br>
&lt;memory unit=3D&#39;KiB&#39;&gt;24582144&lt;/memory&gt;<br>
&lt;currentMemory unit=3D&#39;KiB&#39;&gt;24582144&lt;/currentMemory&gt;<br=
>
&lt;memoryBacking&gt;<br>
&lt;source type=3D&#39;memfd&#39;/&gt;<br>
&lt;access mode=3D&#39;shared&#39;/&gt;<br>
&lt;/memoryBacking&gt;<br>
&lt;vcpu placement=3D&#39;static&#39;&gt;12&lt;/vcpu&gt;<br>
&lt;cputune&gt;<br>
&lt;vcpupin vcpu=3D&#39;0&#39; cpuset=3D&#39;4&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;1&#39; cpuset=3D&#39;5&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;2&#39; cpuset=3D&#39;6&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;3&#39; cpuset=3D&#39;7&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;4&#39; cpuset=3D&#39;8&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;5&#39; cpuset=3D&#39;9&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;6&#39; cpuset=3D&#39;10&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;7&#39; cpuset=3D&#39;11&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;8&#39; cpuset=3D&#39;12&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;9&#39; cpuset=3D&#39;13&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;10&#39; cpuset=3D&#39;14&#39;/&gt;<br>
&lt;vcpupin vcpu=3D&#39;11&#39; cpuset=3D&#39;15&#39;/&gt;<br>
&lt;emulatorpin cpuset=3D&#39;0-1&#39;/&gt;<br>
&lt;/cputune&gt;<br>
<br>
...<br>
&lt;cpu mode=3D&#39;host-passthrough&#39; check=3D&#39;none&#39; migratable=
=3D&#39;on&#39;&gt;<br>
&lt;topology sockets=3D&#39;1&#39; dies=3D&#39;1&#39; cores=3D&#39;6&#39; t=
hreads=3D&#39;2&#39;/&gt;<br>
&lt;cache mode=3D&#39;passthrough&#39;/&gt;<br>
&lt;feature policy=3D&#39;require&#39; name=3D&#39;topoext&#39;/&gt;<br>
&lt;/cpu&gt;<br>
...<br>
&lt;filesystem type=3D&#39;mount&#39; accessmode=3D&#39;passthrough&#39;&gt=
;<br>
&lt;driver type=3D&#39;virtiofs&#39; queue=3D&#39;1024&#39;/&gt;<br>
&lt;binary path=3D&#39;/usr/bin/virtiofsd&#39;/&gt;<br>
&lt;source socket=3D&#39;/var/lib/libvirt/helpers_state/windows/linux_home.=
socket&#39;/&gt;<br>
&lt;target dir=3D&#39;linux_home&#39;/&gt;<br>
&lt;address type=3D&#39;pci&#39; domain=3D&#39;0x0000&#39; bus=3D&#39;0x07&=
#39; slot=3D&#39;0x00&#39; function=3D&#39;0x0&#39;/&gt;<br>
&lt;/filesystem&gt;<br>
...<br>
&lt;/domain&gt;<br>
<br>
I&#39;m running it via virsh, added -d 4, no errors in the log<br>
when it is stuck, I get a black screen (using gpu pt to guest which work wi=
thout it), ps shows both virsh start cmd running and stuck, two virtiofsd i=
nstances are up.<br>
any ideas how to solve this?<br>
<br>
Thanks,<br>
<br>
Dagg<br>
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
<br>
</blockquote></div><br clear=3D"all"><br><span class=3D"gmail_signature_pre=
fix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"l=
tr">German<br></div></div></div>

--0000000000005db76205fc71971f--

