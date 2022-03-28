Return-Path: <xiagao@redhat.com>
MIME-Version: 1.0
References: <2237527.ElGaqSPkdT@mkfssion-lpc>
In-Reply-To: <2237527.ElGaqSPkdT@mkfssion-lpc>
From: Xiaoling Gao <xiagao@redhat.com>
Date: Mon, 28 Mar 2022 18:38:59 +0800
Message-ID: <CADVA6RTOcmMHEBMeiE8rKmzn-WaydqXu-Yf6pH2PaHbTVuz7eg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000002c0bcf05db44ec04"
Subject: Re: [Virtio-fs] VirtIOFS Service stop working on Windows guest when
 reading file from shared directory
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: MkfsSion <mkfssion@mkfssion.com>
Cc: virtio-fs@redhat.com

--0000000000002c0bcf05db44ec04
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

MkfsSion <mkfssion@mkfssion.com> =E4=BA=8E2022=E5=B9=B43=E6=9C=8827=E6=97=
=A5=E5=91=A8=E6=97=A5 15:54=E5=86=99=E9=81=93=EF=BC=9A

> Hello everyone,
>         I encountered an issue when using VirtIOFS on Windows guest. Once
> I
> read files on guest, the VirtIOFS service stopped suddenly. I followed th=
e
> instruction on https://virtio-fs.gitlab.io/howto-windows.html site. The
> following is the information about my setup.
>         virtiofsd version:
>                 mkfssion@MkfsSion-LPC ~ [1]> /usr/lib/qemu/virtiofsd -V
>                 virtiofsd version 6.2.0
>                 Copyright (c) 2003-2021 Fabrice Bellard and the QEMU
> Project developers
>                 using FUSE kernel interface version 7.33
>
>         Linux version:
>                 Linux MkfsSion-LPC 5.10.108-1-lts510 #1 SMP Wed, 23 Mar
> 2022 09:50:53 +0000 x86_64 GNU/Linux
>
>         Windows guest:
>                 Version Windows 10 Enterprise LTSC
>                 Version Number  21H2
>                 OS Internal Version     19044.1586
>                 Experience      Windows Feature Experience Pack
> 120.2212.4170.0
>
>         VirtIODriver: virtio-win-0.1.215
>
>         Error code shown in Windows Explorer: 0x800703E3
>
>         Debug log from VirtIOFS service after appending -d -1 -D C:
> \virtiofs.log parameter: https://fars.ee/D0sr
>
>         Host FS: btrfs
>
>         libvirt xml:
>                 ...
>                 <memoryBacking>
>                         <hugepages/>
>                         <source type=3D"memfd"/>
>                         <access mode=3D"shared"/>
>                 </memoryBacking>
>                 ...
>                 <filesystem type=3D"mount" accessmode=3D"passthrough">
>                 <driver type=3D"virtiofs"/>
>

Could you have a try with  <driver type=3D'virtiofs' queue=3D'1024'/> ?


>                 <binary path=3D"/usr/lib/qemu/virtiofsd"/>
>                 <source dir=3D"/var/lib/libvirt/share"/>
>                 <target dir=3D"share"/>
>                 <alias name=3D"fs0"/>
>                 <address type=3D"pci" domain=3D"0x0000" bus=3D"0x0a"
> slot=3D"0x00" function=3D"0x0"/>
>                 </filesystem>
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>


--=20
BR,
Xiaoling

--0000000000002c0bcf05db44ec04
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">MkfsSion &lt;<a href=3D"mailto:mkfssi=
on@mkfssion.com">mkfssion@mkfssion.com</a>&gt; =E4=BA=8E2022=E5=B9=B43=E6=
=9C=8827=E6=97=A5=E5=91=A8=E6=97=A5 15:54=E5=86=99=E9=81=93=EF=BC=9A<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex">Hello everyone,<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 I encountered an issue when using VirtIOFS on W=
indows guest. Once I <br>
read files on guest, the VirtIOFS service stopped suddenly. I followed the =
<br>
instruction on <a href=3D"https://virtio-fs.gitlab.io/howto-windows.html" r=
el=3D"noreferrer" target=3D"_blank">https://virtio-fs.gitlab.io/howto-windo=
ws.html</a> site. The <br>
following is the information about my setup.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 virtiofsd version: <br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mkfssion@MkfsSion-L=
PC ~ [1]&gt; /usr/lib/qemu/virtiofsd -V<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 virtiofsd version 6=
.2.0<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Copyright (c) 2003-=
2021 Fabrice Bellard and the QEMU <br>
Project developers<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 using FUSE kernel i=
nterface version 7.33<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Linux version:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Linux MkfsSion-LPC =
5.10.108-1-lts510 #1 SMP Wed, 23 Mar <br>
2022 09:50:53 +0000 x86_64 GNU/Linux<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Windows guest:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version Windows 10 =
Enterprise LTSC<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Version Number=C2=
=A0 21H2<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OS Internal Version=
=C2=A0 =C2=A0 =C2=A019044.1586<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Experience=C2=A0 =
=C2=A0 =C2=A0 Windows Feature Experience Pack <br>
120.2212.4170.0<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 VirtIODriver: virtio-win-0.1.215<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Error code shown in Windows Explorer: 0x800703E=
3<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Debug log from VirtIOFS service after appending=
 -d -1 -D C:<br>
\virtiofs.log parameter: <a href=3D"https://fars.ee/D0sr" rel=3D"noreferrer=
" target=3D"_blank">https://fars.ee/D0sr</a><br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Host FS: btrfs<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 libvirt xml:<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;memoryBacking&g=
t;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &lt;hugepages/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &lt;source type=3D&quot;memfd&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 &lt;access mode=3D&quot;shared&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;/memoryBacking&=
gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;filesystem type=
=3D&quot;mount&quot; accessmode=3D&quot;passthrough&quot;&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;driver type=3D&=
quot;virtiofs&quot;/&gt;<br></blockquote><div>=C2=A0</div><div>Could you ha=
ve a try with=C2=A0 &lt;driver type=3D&#39;virtiofs&#39; queue=3D&#39;1024&=
#39;/&gt; ?</div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;binary path=3D&=
quot;/usr/lib/qemu/virtiofsd&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;source dir=3D&q=
uot;/var/lib/libvirt/share&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;target dir=3D&q=
uot;share&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;alias name=3D&q=
uot;fs0&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;address type=3D=
&quot;pci&quot; domain=3D&quot;0x0000&quot; bus=3D&quot;0x0a&quot; <br>
slot=3D&quot;0x00&quot; function=3D&quot;0x0&quot;/&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &lt;/filesystem&gt;=
<br>
_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr">BR,<div>Xiaoling</div></div></d=
iv></div>

--0000000000002c0bcf05db44ec04--

