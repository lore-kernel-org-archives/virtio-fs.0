Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E4a+h8zhsQFy46ieIh6Kvn/jOEzS7Fv/bh2/6yR4ys4=;
 b=Zw5iMHq1ZDShANnKXLNPyvu//hbmyCu8HWmjidkJmbNkRMNOLCO6dQzXS2eNkgASRfxNvlk2gT94S/+QVg17uMfSTaRSZeBw46d+lToTcEalewTyHdxPq8EGVtedrc3Xac4O5JNB5bpDU0DZxe4HOYMkJfyQgtBb6jdrMcr1DDAL/fr9Nn2a57jQi9T3fMoAqe+zY+PpHcEbsM0b4LyrmuSVT0qCeNYqV1MSOHi4PpNVHOoRdfWcUC25utZA/j+C8YttW79VBK9UPpCdI7ROwG1WssORxg+iv55njnjNypPYBrShQ6sbf4hfsDKWQ8eAPwwCf3IFwlMraFdkVDo9+g==
From: Prashant Dewan <linux_learner@outlook.com>
Date: Tue, 24 May 2022 14:29:12 +0000
Message-ID: <BY5PR14MB38937584E1C443A7BB3B0BCF86D79@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB38937584E1C443A7BB3B0BCF86D79BY5PR14MB3893namp_"
Subject: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB38937584E1C443A7BB3B0BCF86D79BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I am trying to setup virtfs using KVM and QEMU.


  1.  Inside the VM, I do
     *   mount -t virtiofs myfs /dev/myfile  --succeeds
     *   cd /dev/myfile  -hangs


  1.  The host logs -

 qemu-system: Failed to write msg. Wrote -1 instead of 20.
May 24 14:01:08 device-myhost[644]: qemu-system: vhost_set_vring_kick faile=
d: Invalid argument (22)
May 24 14:01:08 device-myhost[644]: qemu-system: Failed to set msg fds.
May 24 14:01:08 device-myhost[644]: qemu-system: vhost VQ 0 ring restore fa=
iled: -1: Invalid argument (22)
May 24 14:01:08 device-myhost[644]: qemu-system: Error starting vhost: 22
May 24 14:01:08 device-myhost[644]: qemu-system: Failed to set msg fds.
May 24 14:01:08 device-myhost[644]: qemu-system: vhost_set_vring_call faile=
d: Resource temporarily unavailable (11)
May 24 14:01:08 device-myhost[644]: qemu-system: Failed to set msg fds.
May 24 14:01:08 device-myhost[644]: qemu-system: vhost_set_vring_call faile=
d: Resource temporarily unavailable (11)
May 24 14:01:08 device-myhost[644]: qemu-system: Failed to read from slave.


  1.   Qemu parameters -

 "-device",
    "vhost-user-fs-device,queue-size=3D1024,chardev=3Dchar0,tag=3Dmyfs",
    "-object",
    "memory-backend-memfd,id=3Dmem,size=3D4G,share=3Don"

Any input is appreciated...

Thanks


--_000_BY5PR14MB38937584E1C443A7BB3B0BCF86D79BY5PR14MB3893namp_
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
I am trying to setup virtfs using KVM and QEMU.</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<ol>
<li>Inside the VM, I do&nbsp;</li><ol style=3D"list-style-type: lower-alpha=
;">
<li><i>mount -t virtiofs myfs /dev/myfile&nbsp; --succeeds</i></li><li><i>c=
d /dev/myfile<b>&nbsp; -hangs</b></i></li></ol>
</ol>
<div><i><b><br>
</b></i></div>
<ol start=3D"2">
<li><b>The host logs -&nbsp;</b><br>
</li></ol>
<div><br>
</div>
<div>&nbsp;qemu-system: Failed to write msg. Wrote -1 instead of 20.
<div>May 24 14:01:08 device-myhost[644]: qemu-system: vhost_set_vring_kick =
failed: Invalid argument (22)</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: Failed to s=
et msg fds.</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: vhost VQ 0 =
ring restore failed: -1: Invalid argument (22)</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: Error start=
ing vhost: 22</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: Failed to s=
et msg fds.</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: vhost_set_v=
ring_call failed: Resource temporarily unavailable (11)</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: Failed to s=
et msg fds.</div>
<div>May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 2=
55);display:inline !important">myhost</span>[644]: qemu-system: vhost_set_v=
ring_call failed: Resource temporarily unavailable (11)</div>
May 24 14:01:08 device-<span style=3D"background-color:rgb(255, 255, 255);d=
isplay:inline !important">myhost</span>[644]: qemu-system: Failed to read f=
rom slave.<br>
</div>
<div><br>
</div>
<ol start=3D"3">
<li>&nbsp;<b>Qemu parameters -</b><br>
</li></ol>
<div><br>
</div>
<div>&nbsp;&quot;-device&quot;,
<div>&nbsp; &nbsp; &quot;vhost-user-fs-device,queue-size=3D1024,chardev=3Dc=
har0,tag=3Dmyfs&quot;,</div>
<div>&nbsp; &nbsp; &quot;-object&quot;,</div>
&nbsp; &nbsp; &quot;memory-backend-memfd,id=3Dmem,size=3D4G,share=3Don&quot=
;<br>
</div>
<div><br>
</div>
<div>Any input is appreciated...</div>
<div><br>
</div>
<div>Thanks</div>
<div><br>
</div>
</div>
</body>
</html>

--_000_BY5PR14MB38937584E1C443A7BB3B0BCF86D79BY5PR14MB3893namp_--

