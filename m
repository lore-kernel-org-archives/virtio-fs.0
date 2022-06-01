Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzIlSB3oFCPG/c5Gwwy9WpJfHe1YEQ92r9c7kohvyaI=;
 b=Q26uXGqHQ5OXoK2AqJe1qdYuBAB2eQUsI+OLCfmIp1ulk2bgGq4qiJyivghg5T03o+X7+XD2hZ+wxz502cTjKie6NffITOt2lzrEUs38qj3Zlxx0tJhXnGbOY9DSsEEve3oTJVGAaO+Nf1NXWhOJ6+bFZGNxYfURNWkV+CRCAMo5rr3N2kLhLw+NsUHaaTvLrhaSHYZQCHjDoEMuiF1W+zIQNEnJmEiNtbVIaiDDG7W+TZ457haolJ8XJXBZutIzFVRM/a9rgssTS88okCq6Is90UDOKwfLOFgCDDcIUxUPel6t+ErQyJnEA7jsjFTCX/UKgxw19WDREmtYAXuv1Dg==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Wed, 1 Jun 2022 19:12:20 +0000
Message-ID: <BY5PR14MB38931D7111BD36AFD0FE79AA86DF9@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB38931D7111BD36AFD0FE79AA86DF9BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB38931D7111BD36AFD0FE79AA86DF9BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Thank you Sergio. When I applied the patch, I got stuck  here. The header s=
ize is correct (40 bytes).

vhost-user.c
 390     ret =3D qemu_chr_fe_write_all(chr, (const uint8_t *) msg, size);
 391     if (ret !=3D size) {
 392         error_report("Failed to write msg."
 393                      " Wrote %d instead of %d.", ret, size);
 394         return -1;
 395     }


----
Jun 01 19:01:52 device-d1fe4f98f7091676 systemd[1]: Started Application Run=
time Environment VMM.
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device usb-phy@29910000:
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 0000000029910000 size: 0000000000010000
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         IRQ: 104
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device gpio@2d010000:
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 000000002d010000 size: 0000000000002000
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         IRQ: 131
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device ram:
Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 00000000b0000000 size: 0000000050000000
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device uio@298c0000:
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 00000000298c0000 size: 0000000000010000
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device uio@29800000:
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 0000000029800000 size: 0000000000010000
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Passing through UIO device usb@29900000:
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         Region: base: 0000000029900000 size: 0000000000001000
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info:         IRQ: 103
Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: info: Successfully realized 6 UIO devices
Jun 01 19:01:57 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: warning: Could not locate arm,scmi-shmem node
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: AS_DEBUG: hdr_si=
ze=3D0x28
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Failed to write msg. Wrote -1 instead of 52.
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: vhost_set_vring_addr failed: Invalid argument (22)
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Failed to set msg fds.
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: vhost VQ 0 ring restore failed: -1: Invalid argument (22)
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Error starting vhost: 22
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Failed to set msg fds.
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: vhost_set_vring_call failed: Resource temporarily unavailable (11)
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Failed to set msg fds.
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: vhost_set_vring_call failed: Resource temporarily unavailable (11)
Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system-devi=
ce: Failed to read from slave.
device-d1fe4f98f7091676:~$

________________________________
From: Sergio Lopez
Sent: Wednesday, June 1, 2022 6:01 AM
To: Pra.. Dew..
Cc: Vivek Goyal; Stefan Hajnoczi; virtio-fs@redhat.com
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed

On Tue, May 31, 2022 at 10:25:12PM +0000, Pra.. Dew.. wrote:
> Thank you so much Vivek. I enabled the trace in the code itself and
> ran it. The only message I got was InvalidParam message below. I did
> not get any other message.  We are going to try changing the
> structure [VhostUserMemRegMsg]  padding to see if that fixes the
> problem. Is there anything else we should try?

Applying 3009edff81 to qemu-5.1.0 should do the trick. I'm attaching
the patch to this email, so you can simply apply it with something
like:

patch -p1 < 0001-vhost-user-fix-VHOST_USER_ADD-REM_MEM_REG-truncation.patch

Sergio.

--_000_BY5PR14MB38931D7111BD36AFD0FE79AA86DF9BY5PR14MB3893namp_
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
Thank you&nbsp;Sergio. When I applied the patch, I got stuck&nbsp; here. Th=
e header size is correct (40 bytes).</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<b>vhost-user.c</b></div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<div>&nbsp;390 &nbsp; &nbsp; ret =3D qemu_chr_fe_write_all(chr, (const uint=
8_t *) msg, size);</div>
<div>&nbsp;391 &nbsp; &nbsp; if (ret !=3D size) {</div>
<div>&nbsp;392 &nbsp; &nbsp; &nbsp; &nbsp; error_report(&quot;Failed to wri=
te msg.&quot;</div>
<div>&nbsp;393 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbs=
p; &nbsp; &nbsp;&quot; Wrote %d instead of %d.&quot;, ret, size);</div>
<div>&nbsp;394 &nbsp; &nbsp; &nbsp; &nbsp; return -1;</div>
&nbsp;395 &nbsp; &nbsp; }<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
----</div>
<div class=3D"elementToProof" style=3D"font-family: Calibri, Helvetica, san=
s-serif; font-size: 12pt; color: rgb(0, 0, 0);">
Jun 01 19:01:52 device-d1fe4f98f7091676 systemd[1]: Started Application Run=
time Environment VMM.
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device usb-phy@29910000:</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 0000000029910000 s=
ize: 0000000000010000</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; IRQ: 104</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device gpio@2d010000:</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 000000002d010000 s=
ize: 0000000000002000</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; IRQ: 131</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device ram:</div>
<div>Jun 01 19:01:52 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 00000000b0000000 s=
ize: 0000000050000000</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device uio@298c0000:</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 00000000298c0000 s=
ize: 0000000000010000</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device uio@29800000:</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 0000000029800000 s=
ize: 0000000000010000</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Passing through UIO device usb@29900000:</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; Region: base: 0000000029900000 s=
ize: 0000000000001000</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: &nbsp; &nbsp; &nbsp; &nbsp; IRQ: 103</div>
<div>Jun 01 19:01:55 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: info: Successfully realized 6 UIO devices</div>
<div>Jun 01 19:01:57 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: warning: Could not locate arm,scmi-shmem node</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: AS_DEBUG: h=
dr_size=3D0x28</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: <b>qemu-sys=
tem-device: Failed to write msg. Wrote -1 instead of 52.</b></div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: vhost_set_vring_addr failed: Invalid argument (22)</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: Failed to set msg fds.</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: vhost VQ 0 ring restore failed: -1: Invalid argument (22)</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: Error starting vhost: 22</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: Failed to set msg fds.</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: vhost_set_vring_call failed: Resource temporarily unavailable (11)=
</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: Failed to set msg fds.</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: vhost_set_vring_call failed: Resource temporarily unavailable (11)=
</div>
<div>Jun 01 19:02:23 device-d1fe4f98f7091676 are-launcher[651]: qemu-system=
-device: Failed to read from slave.</div>
device-d1fe4f98f7091676:~$<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0);">
<br>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%;">
<b>From:</b> Sergio Lopez<br>
<b>Sent:</b> Wednesday, June 1, 2022 6:01 AM<br>
<b>To:</b> Pra.. Dew..<br>
<b>Cc:</b> Vivek Goyal; Stefan Hajnoczi; virtio-fs@redhat.com<br>
<b>Subject:</b> Re: [Virtio-fs] vhost_set_vring_kick failed
<div><br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Tue, May 31, 2022 at 10:25:12PM +0000, Pra.. De=
w.. wrote:<br>
&gt; Thank you so much Vivek. I enabled the trace in the code itself and<br=
>
&gt; ran it. The only message I got was InvalidParam message below. I did<b=
r>
&gt; not get any other message.&nbsp; We are going to try changing the<br>
&gt; structure [VhostUserMemRegMsg]&nbsp; padding to see if that fixes the<=
br>
&gt; problem. Is there anything else we should try?<br>
<br>
Applying 3009edff81 to qemu-5.1.0 should do the trick. I'm attaching<br>
the patch to this email, so you can simply apply it with something<br>
like:<br>
<br>
patch -p1 &lt; 0001-vhost-user-fix-VHOST_USER_ADD-REM_MEM_REG-truncation.pa=
tch<br>
<br>
Sergio.<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_BY5PR14MB38931D7111BD36AFD0FE79AA86DF9BY5PR14MB3893namp_--

