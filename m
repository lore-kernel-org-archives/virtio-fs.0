Return-Path: <alpha754293@hotmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvKzDVziDhKUsZV4Z2AEe7zl5W7YKaIOZU9NbnULWDg=;
 b=azjnSyx3hSRowlxWeoRvi9lLY9jnB6ARUUMETEhtEL1hYVHeMX2HUL/SqoF8losPt52xrSdhQr/J2ZWW6Ec4kp5fbemx78SugFMHEcPAWMY80DEy+j5iQBfAvI3WV9q6EWDIdFeOaY6pIKQPbTreIE9px1Sq3qI4cwcq+zEhnFZfc/xAv01v7KUmj6SeCaw8sS3JbOqtJie9wRRtghxr4NrQeKglB1jSjhqFPZVlm7tFenBOXps1UjymXNoeirh859O6QksLWgojhepG35Lerp8Z0bOZej6fYFAMaaXk9ZWUGu7xsMBPuHvsizGxsLq6goJdrcIIuxFQrTbmxo0gAQ==
From: Ewen Chan <alpha754293@hotmail.com>
Date: Sun, 14 May 2023 07:48:57 +0000
Message-ID: <SA1P221MB1018666909025F9520B3A960B57B9@SA1P221MB1018.NAMP221.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Language: en-CA
Content-Type: multipart/alternative;
 boundary="_000_SA1P221MB1018666909025F9520B3A960B57B9SA1P221MB1018NAMP_"
Subject: [Virtio-fs] Is there a way to get NFS and/or NFSoRDMA to play nice
 with Virtio-FS?
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_SA1P221MB1018666909025F9520B3A960B57B9SA1P221MB1018NAMP_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

To Whom It May Concern:

I'm using Proxmox 7.3-4 and I have a CentOS 7.7.1908 VM that's able to shar=
e data/files via Virtio-FS. That part is working fine.

However, if I try to export that VirtIO-FS "target" as a NFS export, whenev=
er my other computers connect to that NFS share, it will say that the folde=
rs have stale NFS handles.

Is there a way to fix/resolve this?

Here is the output for /etc/exports:

/export *(rw,async,no_root_squash,no_all_squash,no_subtree_check,fsid=3D4)

I have tried rebooting the clients multiple times, along with mounting/unmo=
unting said NFS share and it doesn't appear to make any difference.

Your help is greatly appreciated.

Thank you.

Sincerely,
Ewen

--_000_SA1P221MB1018666909025F9520B3A960B57B9SA1P221MB1018NAMP_
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
 color: rgb(0, 0, 0);" class=3D"elementToProof">
To Whom It May Concern:<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
I'm using Proxmox 7.3-4 and I have a CentOS 7.7.1908 VM that's able to shar=
e data/files via Virtio-FS. That part is working fine.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
However, if I try to export that VirtIO-FS &quot;target&quot; as a NFS expo=
rt, whenever my other computers connect to that NFS share, it will say that=
 the folders have stale NFS handles.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Is there a way to fix/resolve this?</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Here is the output for /etc/exports:</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
/export *(rw,async,no_root_squash,no_all_squash,no_subtree_check,fsid=3D4)<=
/div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
I have tried rebooting the clients multiple times, along with mounting/unmo=
unting said NFS share and it doesn't appear to make any difference.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Your help is greatly appreciated.<br>
<br>
Thank you.<br>
<br>
Sincerely,<br>
Ewen<br>
</div>
</body>
</html>

--_000_SA1P221MB1018666909025F9520B3A960B57B9SA1P221MB1018NAMP_--

