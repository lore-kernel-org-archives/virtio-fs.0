Return-Path: <xiagao@redhat.com>
MIME-Version: 1.0
References: <SA1P221MB1018DDC00E1C808EE30D19B4B5D59@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
In-Reply-To: <SA1P221MB1018DDC00E1C808EE30D19B4B5D59@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
From: Xiaoling Gao <xiagao@redhat.com>
Date: Mon, 6 Feb 2023 14:44:25 +0800
Message-ID: <CADVA6RSp90OqWpV5yJGo8_yUQ68tmKnpv_=QyXUKNnBXVsd2_Q@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000004fd08805f4025d9e"
Subject: Re: [Virtio-fs] How do I start the Windows Virtio-FS service with a
 different, permanent drive letter that isn't Z?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Ewen Chan <alpha754293@hotmail.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--0000000000004fd08805f4025d9e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The moutnpoint can be set via the registry, and then virtio-fs can parse
them from the registry.
Such as:   virtiofs.ext -m H:
reg add HKLM\Software\VirtIO-FS /v MountPoint /d H: /t REG_SZ

Ewen Chan <alpha754293@hotmail.com> =E4=BA=8E2023=E5=B9=B42=E6=9C=885=E6=97=
=A5=E5=91=A8=E6=97=A5 11:46=E5=86=99=E9=81=93=EF=BC=9A

> To Whom It May Concern:
>
> I was following the instructions in regards to getting Virtio-FS running
> on a Windows 10 VM in Proxmox 7.3-3 and that part works fine.
>
> However, at the end of those instructions, it says that I can use the "-m=
"
> in the command line to explicitly set a drive letter.
>
> I tried editing the VirtioFsSvc service in the Windows Registry Editor
> either by changing the ImagePath or trying to add the Parameters registry
> key and neither seemed to work.
>
> Is there a way for me to be able to pass the start parameters so that it
> would use those the "-m" option automatically?
>
> I even tried creating a really simple batch file, but that leaves a
> command prompt window open, where once I close said command prompt window
> (even if I run the batch file in background mode), it will close/disconne=
ct
> the Virtio-FS connection in said Windows 10 VM.
>
> Your help is greatly appreciated.
>
> Thank you.
>
> Sincerely,
> Ewen
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>


--=20
BR,
Xiaoling

--0000000000004fd08805f4025d9e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The moutnpoint=C2=A0can be set via the registry, and then =
virtio-fs can parse them from the registry.<div>Such as:=C2=A0 =C2=A0virtio=
fs.ext=C2=A0-m H:<br><div>reg add HKLM\Software\VirtIO-FS /v MountPoint /d =
H: /t REG_SZ<br></div></div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">Ewen Chan &lt;<a href=3D"mailto:alpha754293@h=
otmail.com">alpha754293@hotmail.com</a>&gt; =E4=BA=8E2023=E5=B9=B42=E6=9C=
=885=E6=97=A5=E5=91=A8=E6=97=A5 11:46=E5=86=99=E9=81=93=EF=BC=9A<br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex"><div class=3D"msg703949478=
7260358772">




<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
To Whom It May Concern:<br>
<br>
I was following the instructions in regards to getting Virtio-FS running on=
 a Windows 10 VM in Proxmox 7.3-3 and that part works fine.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
However, at the end of those instructions, it says that I can use the &quot=
;-m&quot; in the command line to explicitly set a drive letter.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I tried editing the VirtioFsSvc service in the Windows Registry Editor eith=
er by changing the ImagePath or trying to add the Parameters registry key a=
nd neither seemed to work.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Is there a way for me to be able to pass the start parameters so that it wo=
uld use those the &quot;-m&quot; option automatically?</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
I even tried creating a really simple batch file, but that leaves a command=
 prompt window open, where once I close said command prompt window (even if=
 I run the batch file in background mode), it will close/disconnect the Vir=
tio-FS connection in said Windows
 10 VM.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Your help is greatly appreciated.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Thank you.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Sincerely,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif;font-size:12pt;color=
:rgb(0,0,0);background-color:rgb(255,255,255)">
Ewen<br>
</div>
</div>

_______________________________________________<br>
Virtio-fs mailing list<br>
<a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@redhat.=
com</a><br>
<a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=3D"no=
referrer" target=3D"_blank">https://listman.redhat.com/mailman/listinfo/vir=
tio-fs</a><br>
</div></blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=
=3D"ltr" class=3D"gmail_signature"><div dir=3D"ltr">BR,<div>Xiaoling</div><=
/div></div>

--0000000000004fd08805f4025d9e--

