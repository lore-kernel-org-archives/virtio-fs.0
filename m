Return-Path: <linux_learner@outlook.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYzQnkB+hBSq+ESXO+MbGzhLeDx7dh/jhEVAIWHZmus=;
 b=NkZ38v8jB/fT2pZbuSHDWaYnBU+/12Tn/cZ11sMAyZ68HrCCq8CZYVx09SPqb5FuZdV0ggZqd8nnmbHNJs1+RshjOLrxTB8UnuUQHKkMai+M6l7rdwRdCnNs+FvETASYiRimgx+sFOaSbNn0yBMUvAs0S/C/xDPl3LEuIRSxz/DC0q5ElU1EdqX12rTqAowXe7bMJpmef7VvGJ4gW87gfjCUiAtyn/fkk7Nm6zgYj3MIo/jfBeSsw6gEip19elovc+I0UdXvUiaZcSedZ8WhQhhreivWyIEWMAga7WmYkWJQ3O+wdlUXFfjNKkx6kSePCscdSx2YJ/ZxKtYEKcu4Ug==
From: "Pra.. Dew.." <linux_learner@outlook.com>
Date: Tue, 12 Jul 2022 23:14:29 +0000
Message-ID: <BY5PR14MB3893F904F74C93FF851811D686869@BY5PR14MB3893.namprd14.prod.outlook.com>
References: <BY5PR14MB38930999DE81BFE799016C8C86829@BY5PR14MB3893.namprd14.prod.outlook.com>
 <Ys1rH9Mn6fKh35p7@redhat.com>
In-Reply-To: <Ys1rH9Mn6fKh35p7@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
 boundary="_000_BY5PR14MB3893F904F74C93FF851811D686869BY5PR14MB3893namp_"
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>

--_000_BY5PR14MB3893F904F74C93FF851811D686869BY5PR14MB3893namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thank you so much!!! We are using the Rust version now. I will try out the =
suggestions below. Thanks for the guidance.
________________________________
From: Vivek Goyal <vgoyal@redhat.com>
Sent: Tuesday, July 12, 2022 12:37 PM
To: Pra.. Dew.. <linux_learner@outlook.com>
Cc: virtio-fs@redhat.com <virtio-fs@redhat.com>
Subject: Re: [Virtio-fs] Ownership of a file shared between guest and host

On Fri, Jul 08, 2022 at 08:18:19PM +0000, Pra.. Dew.. wrote:
> We have been able to setup virtiofs between guest and host (QEMU 6.2/Linu=
x 5.15). We run virtiofsd as a non-root user in the host. We did not want t=
o run it as a root user in order to minimize the attack surface. We run it =
as a virtiofs user. When we create a file in the shared folder, the permiss=
ion of the file is virtiofs user and virtiofs group. When we read that file=
 from the guest it shows virtiofs user (only the uid) and nobody group. The=
 goal is to restrict the access of the file to a few services in the guest =
(not give access to all services). We tried to create a group in the guest =
and tried to move the file in the new group. However chown gives "bad descr=
iptor." Is there a better way of doing this? Any input is really appreciate=
d. Thank you so much!

Hi,

Are you using C version of virtiofsd (from qemu) or rust version of
virtiofsd found here.

https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitlab.=
com%2Fvirtio-fs%2Fvirtiofsd&amp;data=3D05%7C01%7C%7C66056c4b61b0405d2a7008d=
a640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932262768755509%7=
CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwi=
LCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DVFeOhTiZfwYU5QK4XNjRx%2F3WqfDyiI=
60v%2FV1x9UJD%2BU%3D&amp;reserved=3D0

I would recommend using rust version of virtiofsd now and as German
suggested in another email, let unprivileged user launch a user namespace
and run virtiofsd inside that. That should allow you to do arbitrary
uid/gid switching inside guest.

Thanks
Vivek

> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistm=
an.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;data=3D05%7C01%7C%7C6605=
6c4b61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C6=
37932262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luM=
zIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3Dq%2FAbKkN3lnM=
CLaOo8bO6ZCpjxes%2BJcvTnqY7y3JFFa0%3D&amp;reserved=3D0


--_000_BY5PR14MB3893F904F74C93FF851811D686869BY5PR14MB3893namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Helvetica, sans-serif; font-size: 12pt;=
 color: rgb(0, 0, 0);" class=3D"elementToProof">
Thank you&nbsp;so much!!! We are using the Rust version now. I will try out=
 the suggestions below. Thanks for the guidance.</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> Vivek Goyal &lt;vgoya=
l@redhat.com&gt;<br>
<b>Sent:</b> Tuesday, July 12, 2022 12:37 PM<br>
<b>To:</b> Pra.. Dew.. &lt;linux_learner@outlook.com&gt;<br>
<b>Cc:</b> virtio-fs@redhat.com &lt;virtio-fs@redhat.com&gt;<br>
<b>Subject:</b> Re: [Virtio-fs] Ownership of a file shared between guest an=
d host</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On Fri, Jul 08, 2022 at 08:18:19PM +0000, Pra.. De=
w.. wrote:<br>
&gt; We have been able to setup virtiofs between guest and host (QEMU 6.2/L=
inux 5.15). We run virtiofsd as a non-root user in the host. We did not wan=
t to run it as a root user in order to minimize the attack surface. We run =
it as a virtiofs user. When we create
 a file in the shared folder, the permission of the file is virtiofs user a=
nd virtiofs group. When we read that file from the guest it shows virtiofs =
user (only the uid) and nobody group. The goal is to restrict the access of=
 the file to a few services in the
 guest (not give access to all services). We tried to create a group in the=
 guest and tried to move the file in the new group. However chown gives &qu=
ot;bad descriptor.&quot; Is there a better way of doing this? Any input is =
really appreciated. Thank you so much!<br>
<br>
Hi,<br>
<br>
Are you using C version of virtiofsd (from qemu) or rust version of<br>
virtiofsd found here.<br>
<br>
<a href=3D"https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2=
F%2Fgitlab.com%2Fvirtio-fs%2Fvirtiofsd&amp;amp;data=3D05%7C01%7C%7C66056c4b=
61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C63793=
2262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiL=
CJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;amp;sdata=3DVFeOhTiZfwYU5=
QK4XNjRx%2F3WqfDyiI60v%2FV1x9UJD%2BU%3D&amp;amp;reserved=3D0">https://nam12=
.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitlab.com%2Fvirtio-=
fs%2Fvirtiofsd&amp;amp;data=3D05%7C01%7C%7C66056c4b61b0405d2a7008da640357c8=
%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7C637932262768755509%7CUnknown%=
7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6M=
n0%3D%7C3000%7C%7C%7C&amp;amp;sdata=3DVFeOhTiZfwYU5QK4XNjRx%2F3WqfDyiI60v%2=
FV1x9UJD%2BU%3D&amp;amp;reserved=3D0</a><br>
<br>
I would recommend using rust version of virtiofsd now and as German<br>
suggested in another email, let unprivileged user launch a user namespace<b=
r>
and run virtiofsd inside that. That should allow you to do arbitrary<br>
uid/gid switching inside guest.<br>
<br>
Thanks<br>
Vivek<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; Virtio-fs@redhat.com<br>
&gt; <a href=3D"https://nam12.safelinks.protection.outlook.com/?url=3Dhttps=
%3A%2F%2Flistman.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;amp;data=
=3D05%7C01%7C%7C66056c4b61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaa=
aaaaaaaa%7C1%7C0%7C637932262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL=
jAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;a=
mp;sdata=3Dq%2FAbKkN3lnMCLaOo8bO6ZCpjxes%2BJcvTnqY7y3JFFa0%3D&amp;amp;reser=
ved=3D0">
https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flistman=
.redhat.com%2Fmailman%2Flistinfo%2Fvirtio-fs&amp;amp;data=3D05%7C01%7C%7C66=
056c4b61b0405d2a7008da640357c8%7C84df9e7fe9f640afb435aaaaaaaaaaaa%7C1%7C0%7=
C637932262768755509%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2l=
uMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;amp;sdata=3Dq%2FAbK=
kN3lnMCLaOo8bO6ZCpjxes%2BJcvTnqY7y3JFFa0%3D&amp;amp;reserved=3D0</a><br>
<br>
</div>
</span></font></div>
</body>
</html>

--_000_BY5PR14MB3893F904F74C93FF851811D686869BY5PR14MB3893namp_--

