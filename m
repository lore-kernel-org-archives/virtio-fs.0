Return-Path: <gmaglion@redhat.com>
MIME-Version: 1.0
References: <trinity-69fb6e2a-760f-4a3b-9a40-c7472c34dab5-1684577428128@3c-app-mailcom-bs08>
 <CAJh=p+42T8VRkdE5citVFbgUCXF10vf-c3589c-JBbWQ0Yq2Nw@mail.gmail.com>
 <trinity-bd64299a-0573-4343-afa2-b6071eb7d7b0-1684996695218@3c-app-mailcom-bs11>
In-Reply-To: <trinity-bd64299a-0573-4343-afa2-b6071eb7d7b0-1684996695218@3c-app-mailcom-bs11>
From: German Maglione <gmaglione@redhat.com>
Date: Thu, 25 May 2023 15:57:06 +0200
Message-ID: <CAJh=p+71zuPObZNf0-kYo-hviw0jYODfVczOFZuaRr4gvFvQ-Q@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000001c014c05fc8501bb"
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

--0000000000001c014c05fc8501bb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm copying your response to this email

> >If you swap your win11 for a linux guest (using the same libvirt xml)
are you able to reproduce the error?
> do you think the guest type matters much?

Yes, because the windows guest uses a different driver. So the problem
could be virtiofsd daemon,
the linux kernel or the windows drivers


On Thu, May 25, 2023 at 8:38=E2=80=AFAM daggs <daggs@gmx.com> wrote:

> Greetings German,
> >
> >Sent: Wednesday, May 24, 2023 at 5:51 PM
> >From: "German Maglione" <gmaglione@redhat.com>
> >To: "daggs" <daggs@gmx.com>
> >Cc: virtio-fs@redhat.com
> >Subject: Re: [Virtio-fs] vm hangs when booting with virtiofs
> >
> >
> >
> >>On Sat, May 20, 2023 at 12:15=E2=80=AFPM daggs <daggs@gmx.com[mailto:
> daggs@gmx.com]> wrote:Greetings,
> >>
> >>I'm trying to boot a win11 vm with a virtiofs fs and the system just
> hangs on boot, I'd like some incites on what is the issue.
> >>here is what I'm using:
> >>- kernel 6.3.3
> >>- libvirt 9.3.0
> >>- qemu 8.0.0
> >>- virtiofsd 1.5.1
> >>
> >>I'm using the following cmd to run virtiofsd using socket: virtiofsd
> --socket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.socket
> --shared-dir /home/daggs --cache auto
> >>where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 16K
> (tried with 1M too, same behavior)
> >>the virtiofsd invocation is issued inside the prepare and begin qemu
> hook on libvirt.
> >>I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO
> virtiofsd] Waiting for vhost-user socket connection...
> >>and I call it like this: nohup <virtiofsd cmd> &
> >>
> >>the vm's relevant config is this:
> >><domain type=3D'kvm'>
> >>...
> >><memory unit=3D'KiB'>24582144</memory>
> >><currentMemory unit=3D'KiB'>24582144</currentMemory>
> >><memoryBacking>
> >><source type=3D'memfd'/>
> >><access mode=3D'shared'/>
> >></memoryBacking>
> >><vcpu placement=3D'static'>12</vcpu>
> >><cputune>
> >><vcpupin vcpu=3D'0' cpuset=3D'4'/>
> >><vcpupin vcpu=3D'1' cpuset=3D'5'/>
> >><vcpupin vcpu=3D'2' cpuset=3D'6'/>
> >><vcpupin vcpu=3D'3' cpuset=3D'7'/>
> >><vcpupin vcpu=3D'4' cpuset=3D'8'/>
> >><vcpupin vcpu=3D'5' cpuset=3D'9'/>
> >><vcpupin vcpu=3D'6' cpuset=3D'10'/>
> >><vcpupin vcpu=3D'7' cpuset=3D'11'/>
> >><vcpupin vcpu=3D'8' cpuset=3D'12'/>
> >><vcpupin vcpu=3D'9' cpuset=3D'13'/>
> >><vcpupin vcpu=3D'10' cpuset=3D'14'/>
> >><vcpupin vcpu=3D'11' cpuset=3D'15'/>
> >><emulatorpin cpuset=3D'0-1'/>
> >></cputune>
> >>
> >>...
> >><cpu mode=3D'host-passthrough' check=3D'none' migratable=3D'on'>
> >><topology sockets=3D'1' dies=3D'1' cores=3D'6' threads=3D'2'/>
> >><cache mode=3D'passthrough'/>
> >><feature policy=3D'require' name=3D'topoext'/>
> >></cpu>
> >>...
> >><filesystem type=3D'mount' accessmode=3D'passthrough'>
> >><driver type=3D'virtiofs' queue=3D'1024'/>
> >><binary path=3D'/usr/bin/virtiofsd'/>
> >><source
> socket=3D'/var/lib/libvirt/helpers_state/windows/linux_home.socket'/>
> >><target dir=3D'linux_home'/>
> >><address type=3D'pci' domain=3D'0x0000' bus=3D'0x07' slot=3D'0x00'
> function=3D'0x0'/>
> >></filesystem>
> >>...
> >></domain>
> >>
> >>I'm running it via virsh, added -d 4, no errors in the log
> >>when it is stuck, I get a black screen (using gpu pt to guest which wor=
k
> without it), ps shows both virsh start cmd running and stuck, two virtiof=
sd
> instances are up.
> >>any ideas how to solve this?
> >>
> >>
> >I forgot, could you replace your '/usr/bin/virtiofsd' with a shell scrip=
t
> that runs `virtiofsd --log-level=3Ddebug ...` and post the log output
> >
> >If you want, you can open an issue here:
> >
> https://gitlab.com/virtio-fs/virtiofsd/-/issues[https://gitlab.com/virtio=
-fs/virtiofsd/-/issues]
> do you mean run it from inside libvirt?
> I tried that, seems like virtiofsd fails because libvirt uses deprecated
> cli params
> that is why I'm using sockets and running it from outside libvirt
>
>
Oh great, I didn't realize you were calling virtiofsd directly, easier
then, just call
virtiofsd --log-level=3Ddebug

and please also using strace, like:
strace -f -o vfsd.strace.log  virtiofsd ...



> >>
> >>Thanks,
> >> Thanks,
> >>
> >>Dagg
> >>
> >>_______________________________________________
> >>Virtio-fs mailing list
> >>Virtio-fs@redhat.com[mailto:Virtio-fs@redhat.com]
> >>https://listman.redhat.com/mailman/listinfo/virtio-fs
> >
> >
> >--
> >
> >German
>
> Thanks,
>
> Dagg
>
>

--=20
German

--0000000000001c014c05fc8501bb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div>I&#39;m copying your response to thi=
s email</div><div><br></div><div>&gt;<span class=3D"gmail-im">
&gt;If you swap your win11 for a linux guest (using the same libvirt xml) a=
re you able to reproduce the error?</span></div><div>&gt; do you think the =
guest type matters much?<br></div><div><br></div><div>Yes, because the wind=
ows guest uses a different driver. So the problem could be virtiofsd daemon=
,</div><div>the linux kernel or the windows drivers<br></div><div><br></div=
></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr"=
>On Thu, May 25, 2023 at 8:38=E2=80=AFAM daggs &lt;<a href=3D"mailto:daggs@=
gmx.com">daggs@gmx.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">Greetings German,<br>
&gt;<br>
&gt;Sent:=C2=A0Wednesday, May 24, 2023 at 5:51 PM<br>
&gt;From:=C2=A0&quot;German Maglione&quot; &lt;<a href=3D"mailto:gmaglione@=
redhat.com" target=3D"_blank">gmaglione@redhat.com</a>&gt;<br>
&gt;To:=C2=A0&quot;daggs&quot; &lt;<a href=3D"mailto:daggs@gmx.com" target=
=3D"_blank">daggs@gmx.com</a>&gt;<br>
&gt;Cc:=C2=A0<a href=3D"mailto:virtio-fs@redhat.com" target=3D"_blank">virt=
io-fs@redhat.com</a><br>
&gt;Subject:=C2=A0Re: [Virtio-fs] vm hangs when booting with virtiofs<br>
&gt;<br>
&gt;=C2=A0=C2=A0<br>
&gt;<br>
&gt;&gt;On Sat, May 20, 2023 at 12:15=E2=80=AFPM daggs &lt;<a href=3D"mailt=
o:daggs@gmx.com" target=3D"_blank">daggs@gmx.com</a>[mailto:<a href=3D"mail=
to:daggs@gmx.com" target=3D"_blank">daggs@gmx.com</a>]&gt; wrote:Greetings,=
<br>
&gt;&gt;<br>
&gt;&gt;I&#39;m trying to boot a win11 vm with a virtiofs fs and the system=
 just hangs on boot, I&#39;d like some incites on what is the issue.<br>
&gt;&gt;here is what I&#39;m using:<br>
&gt;&gt;- kernel 6.3.3<br>
&gt;&gt;- libvirt 9.3.0<br>
&gt;&gt;- qemu 8.0.0<br>
&gt;&gt;- virtiofsd 1.5.1<br>
&gt;&gt;<br>
&gt;&gt;I&#39;m using the following cmd to run virtiofsd using socket: virt=
iofsd --socket-path=3D/var/lib/libvirt/helpers_state/windows/linux_home.soc=
ket --shared-dir /home/daggs --cache auto<br>
&gt;&gt;where /var/lib/libvirt/helpers_state/windows/ is a tmpfs mount of 1=
6K (tried with 1M too, same behavior)<br>
&gt;&gt;the virtiofsd invocation is issued inside the prepare and begin qem=
u hook on libvirt.<br>
&gt;&gt;I see this after virtiofsd is started: [2023-05-20T08:41:18Z INFO v=
irtiofsd] Waiting for vhost-user socket connection...<br>
&gt;&gt;and I call it like this: nohup &lt;virtiofsd cmd&gt; &amp;<br>
&gt;&gt;<br>
&gt;&gt;the vm&#39;s relevant config is this:<br>
&gt;&gt;&lt;domain type=3D&#39;kvm&#39;&gt;<br>
&gt;&gt;...<br>
&gt;&gt;&lt;memory unit=3D&#39;KiB&#39;&gt;24582144&lt;/memory&gt;<br>
&gt;&gt;&lt;currentMemory unit=3D&#39;KiB&#39;&gt;24582144&lt;/currentMemor=
y&gt;<br>
&gt;&gt;&lt;memoryBacking&gt;<br>
&gt;&gt;&lt;source type=3D&#39;memfd&#39;/&gt;<br>
&gt;&gt;&lt;access mode=3D&#39;shared&#39;/&gt;<br>
&gt;&gt;&lt;/memoryBacking&gt;<br>
&gt;&gt;&lt;vcpu placement=3D&#39;static&#39;&gt;12&lt;/vcpu&gt;<br>
&gt;&gt;&lt;cputune&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;0&#39; cpuset=3D&#39;4&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;1&#39; cpuset=3D&#39;5&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;2&#39; cpuset=3D&#39;6&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;3&#39; cpuset=3D&#39;7&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;4&#39; cpuset=3D&#39;8&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;5&#39; cpuset=3D&#39;9&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;6&#39; cpuset=3D&#39;10&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;7&#39; cpuset=3D&#39;11&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;8&#39; cpuset=3D&#39;12&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;9&#39; cpuset=3D&#39;13&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;10&#39; cpuset=3D&#39;14&#39;/&gt;<br>
&gt;&gt;&lt;vcpupin vcpu=3D&#39;11&#39; cpuset=3D&#39;15&#39;/&gt;<br>
&gt;&gt;&lt;emulatorpin cpuset=3D&#39;0-1&#39;/&gt;<br>
&gt;&gt;&lt;/cputune&gt;<br>
&gt;&gt;<br>
&gt;&gt;...<br>
&gt;&gt;&lt;cpu mode=3D&#39;host-passthrough&#39; check=3D&#39;none&#39; mi=
gratable=3D&#39;on&#39;&gt;<br>
&gt;&gt;&lt;topology sockets=3D&#39;1&#39; dies=3D&#39;1&#39; cores=3D&#39;=
6&#39; threads=3D&#39;2&#39;/&gt;<br>
&gt;&gt;&lt;cache mode=3D&#39;passthrough&#39;/&gt;<br>
&gt;&gt;&lt;feature policy=3D&#39;require&#39; name=3D&#39;topoext&#39;/&gt=
;<br>
&gt;&gt;&lt;/cpu&gt;<br>
&gt;&gt;...<br>
&gt;&gt;&lt;filesystem type=3D&#39;mount&#39; accessmode=3D&#39;passthrough=
&#39;&gt;<br>
&gt;&gt;&lt;driver type=3D&#39;virtiofs&#39; queue=3D&#39;1024&#39;/&gt;<br=
>
&gt;&gt;&lt;binary path=3D&#39;/usr/bin/virtiofsd&#39;/&gt;<br>
&gt;&gt;&lt;source socket=3D&#39;/var/lib/libvirt/helpers_state/windows/lin=
ux_home.socket&#39;/&gt;<br>
&gt;&gt;&lt;target dir=3D&#39;linux_home&#39;/&gt;<br>
&gt;&gt;&lt;address type=3D&#39;pci&#39; domain=3D&#39;0x0000&#39; bus=3D&#=
39;0x07&#39; slot=3D&#39;0x00&#39; function=3D&#39;0x0&#39;/&gt;<br>
&gt;&gt;&lt;/filesystem&gt;<br>
&gt;&gt;...<br>
&gt;&gt;&lt;/domain&gt;<br>
&gt;&gt;<br>
&gt;&gt;I&#39;m running it via virsh, added -d 4, no errors in the log<br>
&gt;&gt;when it is stuck, I get a black screen (using gpu pt to guest which=
 work without it), ps shows both virsh start cmd running and stuck, two vir=
tiofsd instances are up.<br>
&gt;&gt;any ideas how to solve this?<br>
&gt;&gt;=C2=A0<br>
&gt;&gt;=C2=A0<br>
&gt;I forgot, could you replace your &#39;/usr/bin/virtiofsd&#39; with a sh=
ell script that runs `virtiofsd --log-level=3Ddebug ...` and post the log o=
utput<br>
&gt;=C2=A0<br>
&gt;If you want, you can open an issue here:<br>
&gt;<a href=3D"https://gitlab.com/virtio-fs/virtiofsd/-/issues%5Bhttps://gi=
tlab.com/virtio-fs/virtiofsd/-/issues%5D" rel=3D"noreferrer" target=3D"_bla=
nk">https://gitlab.com/virtio-fs/virtiofsd/-/issues[https://gitlab.com/virt=
io-fs/virtiofsd/-/issues]</a><br>
do you mean run it from inside libvirt?<br>
I tried that, seems like virtiofsd fails because libvirt uses deprecated cl=
i params<br>
that is why I&#39;m using sockets and running it from outside libvirt<br>
<br></blockquote><div><br></div><div>Oh great, I didn&#39;t realize you wer=
e calling virtiofsd directly, easier then, just call</div><div>virtiofsd --=
log-level=3Ddebug</div><div><br></div><div>and please also using strace, li=
ke:</div><div>strace -f -o vfsd.strace.log=C2=A0 virtiofsd ...<br></div><di=
v><br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1=
ex">
&gt;&gt;=C2=A0<br>
&gt;&gt;Thanks,<br>
&gt;&gt;=C2=A0Thanks,<br>
&gt;&gt;<br>
&gt;&gt;Dagg<br>
&gt;&gt;<br>
&gt;&gt;_______________________________________________<br>
&gt;&gt;Virtio-fs mailing list<br>
&gt;&gt;<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs=
@redhat.com</a>[mailto:<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_b=
lank">Virtio-fs@redhat.com</a>]<br>
&gt;&gt;<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" r=
el=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/list=
info/virtio-fs</a><br>
&gt;=C2=A0<br>
&gt;<br>
&gt;--<br>
&gt;<br>
&gt;German<br>
<br>
Thanks,<br>
<br>
Dagg<br>
<br>
</blockquote></div><br clear=3D"all"><br><span class=3D"gmail_signature_pre=
fix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"l=
tr">German<br></div></div></div>

--0000000000001c014c05fc8501bb--

