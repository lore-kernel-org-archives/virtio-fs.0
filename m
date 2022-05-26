Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXnZZ5I7MI7wE6hETy432AHLU4rYu+Yodvl2mTkJ+1s=;
 b=Guon4+YBUWKG1dOlQh8WPDZNeZutnF3e/zll8Zhfn0LYtSLeBVWivzl/2zLmBWymGni+LBTnYz+HCKv0rernfQN5sh7H6ExPT+SHTs5+IsqL45Sd5cJhnF9TFful2JEKqQBEKHULv/PKruWbRm2OkB+rCTfMtGHHky8ApcZWawxrX9BbnZisjAtiZV+SYnUi21wzKfhIRgg2B2gf9d3Z9/ex6NpYpw2ZhKbVJtyOaspegCNyGRqHNpNnoPlULrxs0nTSA/UHIcRFnK2evIsCl75SmLEZH9v3R0EMPDch+r5QXu2hmOLsQBKOlJDji23TIynmtz3XNYAGY2AmnC8TkA==
From: Prashant Dewan <linux_learner@outlook.com>
Date: Thu, 26 May 2022 05:34:42 +0000
Message-ID: <BY5PR14MB3893A6AA17C5FEBE843B640286D99@BY5PR14MB3893.namprd14.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB3893A6AA17C5FEBE843B640286D99BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB3893A6AA17C5FEBE843B640286D99BY5PR14MB3893namp_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello Stefan,

Here is the output from virtofsd..

------------------------------------
- Journal begins at Thu 2022-05-26 04:23:42 UTC, ends at Thu 2022-05-26 04:=
41:57 UTC. --
May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user device d=
aemon.<<Placeholder: run this daemon as non-privileged user>>.
May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO  virti=
ofsd] Waiting for vhost-user socket connection...
May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27:1=
1Z INFO  virtiofsd] Client connected, servicing requests
May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04:27:3=
3Z ERROR virtiofsd] Waiting for daemon failed: HandleRequest(InvalidParam)
May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service: Deac=
tivated successfully.
May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service: Sche=
duled restart job, restart counter is at 1.

________________________________
From: Stefan Hajnoczi
Sent: Wednesday, May 25, 2022 4:02 PM
To: Prashant Dewan
Cc: virtio-fs@redhat.com
Subject: Re: [Virtio-fs] vhost_set_vring_kick failed

On Tue, May 24, 2022 at 02:29:12PM +0000, Pra Dew wrote:
> I am trying to setup virtfs using KVM and QEMU.
>
>
>   1.  Inside the VM, I do
>      *   mount -t virtiofs myfs /dev/myfile  --succeeds
>      *   cd /dev/myfile  -hangs
>
>
>   1.  The host logs -
>
>  qemu-system: Failed to write msg. Wrote -1 instead of 20.

Sending a vhost-user protocol message failed. It is likely that the
virtiofsd process terminated and the UNIX domain socket closed on QEMU.

Is there any output from virtiofsd?

Stefan

--_000_BY5PR14MB3893A6AA17C5FEBE843B640286D99BY5PR14MB3893namp_
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
Hello Stefan,&nbsp;</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Here is the output from virtofsd..</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
<br>
</div>
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
------------------------------------</div>
<div>
<div class=3D"elementToProof">- Journal begins at Thu 2022-05-26 04:23:42 U=
TC, ends at Thu 2022-05-26 04:41:57 UTC. --
<div>May 26 04:24:13 localhost systemd[1]: Started virtio-fs vhost-user dev=
ice daemon.&lt;&lt;Placeholder: run this daemon as non-privileged user&gt;&=
gt;.</div>
<div>May 26 04:24:13 localhost virtiofsd[505]: [2022-05-26T04:24:13Z INFO &=
nbsp;virtiofsd] Waiting for vhost-user socket connection...</div>
<div>May 26 04:27:11 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04=
:27:11Z INFO &nbsp;virtiofsd] Client connected, servicing requests</div>
<div>May 26 04:27:33 device-3e4b479e2ee9c647 virtiofsd[505]: [2022-05-26T04=
:27:33Z ERROR virtiofsd]<b> Waiting for daemon failed: HandleRequest(Invali=
dParam)</b></div>
<div>May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service:=
 Deactivated successfully.</div>
May 26 04:27:33 device-3e4b479e2ee9c647 systemd[1]: virtiofsd.service: Sche=
duled restart job, restart counter is at 1.<br>
</div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0);">
<br>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%;">
<b>From:</b> Stefan Hajnoczi<br>
<b>Sent:</b> Wednesday, May 25, 2022 4:02 PM<br>
<b>To:</b> Prashant Dewan<br>
<b>Cc:</b> virtio-fs@redhat.com<br>
<b>Subject:</b> Re: [Virtio-fs] vhost_set_vring_kick failed
<div><br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText elementToProof">On Tue, May 24, 2022 at 02:29:12PM =
+0000, Pra Dew wrote:<br>
&gt; I am trying to setup virtfs using KVM and QEMU.<br>
&gt; <br>
&gt; <br>
&gt;&nbsp;&nbsp; 1.&nbsp; Inside the VM, I do<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp; mount -t virtiofs myfs /de=
v/myfile&nbsp; --succeeds<br>
&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *&nbsp;&nbsp; cd /dev/myfile&nbsp; -hang=
s<br>
&gt; <br>
&gt; <br>
&gt;&nbsp;&nbsp; 1.&nbsp; The host logs -<br>
&gt; <br>
&gt;&nbsp; qemu-system: Failed to write msg. Wrote -1 instead of 20.<br>
<br>
Sending a vhost-user protocol message failed. It is likely that the<br>
virtiofsd process terminated and the UNIX domain socket closed on QEMU.<br>
<br>
Is there any output from virtiofsd?<br>
<br>
Stefan<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_BY5PR14MB3893A6AA17C5FEBE843B640286D99BY5PR14MB3893namp_--

