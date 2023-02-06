Return-Path: <alpha754293@hotmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QVTdvjKqDfh0WiokN+VEz6bWDZzz+c3RcN36NEioG+U=;
 b=ZKLGmCHjRasO5RI1qhiJAxYURHt/Z1+fr6vDSFVRQPjNLPwsCdhePI5NlE2w0DXtKe4f9MsT9/ysoifQLnGFUzVh3Y9my3NM4/yWSlBjf+w6u12HdKr5hitsP2MWuHH7Id51MMtHhp+C4JMN7WZbJREDzXLEhU4bHrlw5eE3BrPMtiSjTSfmvYAsIWYqMt16v0UA9xdTydo4MwHZnaemIvROnBguEj6lCxqtRQYbh3wBbAGVy4UcceSXGv8EkBGrJPFS/vIB9sTMiVQETJ+UNUt8BCX9ezY8rZjce4L0cJW2nTrqrtEU1kzZqrBmVCCkGVnjdr2ZDhJ1iPZSogFciw==
From: Ewen Chan <alpha754293@hotmail.com>
Date: Mon, 6 Feb 2023 07:20:41 +0000
Message-ID: <SA1P221MB10188745309CD7EF0C6CF44AB5DA9@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
References: <SA1P221MB1018DDC00E1C808EE30D19B4B5D59@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
 <CADVA6RSp90OqWpV5yJGo8_yUQ68tmKnpv_=QyXUKNnBXVsd2_Q@mail.gmail.com>
In-Reply-To: <CADVA6RSp90OqWpV5yJGo8_yUQ68tmKnpv_=QyXUKNnBXVsd2_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Language: en-CA
Content-Type: multipart/alternative;
 boundary="_000_SA1P221MB10188745309CD7EF0C6CF44AB5DA9SA1P221MB1018NAMP_"
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
To: Xiaoling Gao <xiagao@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_SA1P221MB10188745309CD7EF0C6CF44AB5DA9SA1P221MB1018NAMP_
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

Xiaoling:

Thank you.

I will have to try that.

Sincerely,
Ewen
________________________________
From: Xiaoling Gao <xiagao@redhat.com>
Sent: February 6, 2023 1:44 AM
To: Ewen Chan <alpha754293@hotmail.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
Subject: Re: [Virtio-fs] How do I start the Windows Virtio-FS service with =
a different, permanent drive letter that isn't Z?

The moutnpoint can be set via the registry, and then virtio-fs can parse th=
em from the registry.
Such as:   virtiofs.ext -m H:
reg add HKLM\Software\VirtIO-FS /v MountPoint /d H: /t REG_SZ

Ewen Chan <alpha754293@hotmail.com<mailto:alpha754293@hotmail.com>> =1B$BP2=
=1B(B2023=1B$BG/=1B(B2=1B$B7n=1B(B5=1B$BF|<~F|=1B(B 11:46=1B$B<LF;!'=1B(B
To Whom It May Concern:

I was following the instructions in regards to getting Virtio-FS running on=
 a Windows 10 VM in Proxmox 7.3-3 and that part works fine.

However, at the end of those instructions, it says that I can use the "-m" =
in the command line to explicitly set a drive letter.

I tried editing the VirtioFsSvc service in the Windows Registry Editor eith=
er by changing the ImagePath or trying to add the Parameters registry key a=
nd neither seemed to work.

Is there a way for me to be able to pass the start parameters so that it wo=
uld use those the "-m" option automatically?

I even tried creating a really simple batch file, but that leaves a command=
 prompt window open, where once I close said command prompt window (even if=
 I run the batch file in background mode), it will close/disconnect the Vir=
tio-FS connection in said Windows 10 VM.

Your help is greatly appreciated.

Thank you.

Sincerely,
Ewen
_______________________________________________
Virtio-fs mailing list
Virtio-fs@redhat.com<mailto:Virtio-fs@redhat.com>
https://listman.redhat.com/mailman/listinfo/virtio-fs


--
BR,
Xiaoling

--_000_SA1P221MB10188745309CD7EF0C6CF44AB5DA9SA1P221MB1018NAMP_
Content-Type: text/html; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-2022-=
jp">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Xiaoling:<br>
<br>
Thank you.<br>
<br>
I will have to try that.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Sincerely,</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Ewen<br>
</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Xiaoling Gao &lt;xiag=
ao@redhat.com&gt;<br>
<b>Sent:</b> February 6, 2023 1:44 AM<br>
<b>To:</b> Ewen Chan &lt;alpha754293@hotmail.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] How do I start the Windows Virtio-FS servic=
e with a different, permanent drive letter that isn't Z?</font>
<div>&nbsp;</div>
</div>
<div>
<div dir=3D"ltr">The moutnpoint&nbsp;can be set via the registry, and then =
virtio-fs can parse them from the registry.
<div>Such as:&nbsp; &nbsp;virtiofs.ext&nbsp;-m H:<br>
<div>reg add HKLM\Software\VirtIO-FS /v MountPoint /d H: /t REG_SZ<br>
</div>
</div>
</div>
<br>
<div class=3D"x_gmail_quote">
<div dir=3D"ltr" class=3D"x_gmail_attr">Ewen Chan &lt;<a href=3D"mailto:alp=
ha754293@hotmail.com">alpha754293@hotmail.com</a>&gt; =1B$BP2=1B(B2023=1B$B=
G/=1B(B2=1B$B7n=1B(B5=1B$BF|<~F|=1B(B 11:46=1B$B<LF;!'=1B(B<br>
</div>
<blockquote class=3D"x_gmail_quote" style=3D"margin:0px 0px 0px 0.8ex; bord=
er-left:1px solid rgb(204,204,204); padding-left:1ex">
<div class=3D"x_msg7039494787260358772">
<div dir=3D"ltr">
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
To Whom It May Concern:<br>
<br>
I was following the instructions in regards to getting Virtio-FS running on=
 a Windows 10 VM in Proxmox 7.3-3 and that part works fine.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
However, at the end of those instructions, it says that I can use the &quot=
;-m&quot; in the command line to explicitly set a drive letter.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
I tried editing the VirtioFsSvc service in the Windows Registry Editor eith=
er by changing the ImagePath or trying to add the Parameters registry key a=
nd neither seemed to work.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
Is there a way for me to be able to pass the start parameters so that it wo=
uld use those the &quot;-m&quot; option automatically?</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
I even tried creating a really simple batch file, but that leaves a command=
 prompt window open, where once I close said command prompt window (even if=
 I run the batch file in background mode), it will close/disconnect the Vir=
tio-FS connection in said Windows
 10 VM.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
Your help is greatly appreciated.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
Thank you.</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
<br>
</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
Sincerely,</div>
<div style=3D"font-family:Calibri,Helvetica,sans-serif; font-size:12pt; col=
or:rgb(0,0,0); background-color:rgb(255,255,255)">
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
</div>
</blockquote>
</div>
<br clear=3D"all">
<div><br>
</div>
-- <br>
<div dir=3D"ltr" class=3D"x_gmail_signature">
<div dir=3D"ltr">BR,
<div>Xiaoling</div>
</div>
</div>
</div>
</body>
</html>

--_000_SA1P221MB10188745309CD7EF0C6CF44AB5DA9SA1P221MB1018NAMP_--

