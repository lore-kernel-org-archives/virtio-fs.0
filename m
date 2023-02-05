Return-Path: <alpha754293@hotmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kvBgFk4dHSdPl15EuHoHgAxBFb7M4f/SOpOlT6eMgxo=;
 b=JfGQN3vY3lUn4M9DUuDV3ytNNXbl9NiwFqsZTRDvL8hYVCWb6S/BSKu1bkYN9aJRzzJXz/UWk1AOMbtNE0BBa7V0yjCkN5cIjs9hC4Y1QlPgLVYkQbArBk1zLCdLwdLE9yzcmij9ofNcXtE+vnVCQwJxI+8FRI2PUqUSgAgmIsZ1/CvcOG4TL6xCQuet8tLkmmhWqtQjsaI78hBPqVCyagix++J7KXJKu6cv3JTxprqsRzCjR0cVGdgbqyVirZbm0IvcwMaTv4MpJUSx/Fj05DpjmcZ1ZbKQnUvyFMTK8XEx/68AXbdsLjPqW77S/eEVJwZa7HSBNSsFkw+h/l6rOA==
From: Ewen Chan <alpha754293@hotmail.com>
Date: Sun, 5 Feb 2023 03:46:02 +0000
Message-ID: <SA1P221MB1018DDC00E1C808EE30D19B4B5D59@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Language: en-CA
Content-Type: multipart/alternative;
 boundary="_000_SA1P221MB1018DDC00E1C808EE30D19B4B5D59SA1P221MB1018NAMP_"
Subject: [Virtio-fs] How do I start the Windows Virtio-FS service with a
 different, permanent drive letter that isn't Z?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_SA1P221MB1018DDC00E1C808EE30D19B4B5D59SA1P221MB1018NAMP_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

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

--_000_SA1P221MB1018DDC00E1C808EE30D19B4B5D59SA1P221MB1018NAMP_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
To Whom It May Concern:<br>
<br>
I was following the instructions in regards to getting Virtio-FS running on=
 a Windows 10 VM in Proxmox 7.3-3 and that part works fine.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
However, at the end of those instructions, it says that I can use the &quot=
;-m&quot; in the command line to explicitly set a drive letter.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
I tried editing the VirtioFsSvc service in the Windows Registry Editor eith=
er by changing the ImagePath or trying to add the Parameters registry key a=
nd neither seemed to work.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Is there a way for me to be able to pass the start parameters so that it wo=
uld use those the &quot;-m&quot; option automatically?</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
I even tried creating a really simple batch file, but that leaves a command=
 prompt window open, where once I close said command prompt window (even if=
 I run the batch file in background mode), it will close/disconnect the Vir=
tio-FS connection in said Windows
 10 VM.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Your help is greatly appreciated.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);" class=3D"eleme=
ntToProof">
Thank you.</div>
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
</body>
</html>

--_000_SA1P221MB1018DDC00E1C808EE30D19B4B5D59SA1P221MB1018NAMP_--

