DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
	s=selector2-intel-onmicrosoft-com;
	h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
	bh=Hfj2Lf2GyTY4ZYLyYyJ9PlMh5Z/g2REg0TFmzTYclOo=;
	b=D3C2jbnbd7zfLVfHsLiNoUgE8coLjLv6IymyEqgnmNJijo0gldCOjmcHC1vctB5ksm8uhi8snXbZoT6HvqvO7pnVqEEoX2ENE/+MM5gsaWpSDRdZQ5/SnySn3NKMaJ9/m4PpXl5Gv0RhLRIDStGJGCT3PMGmS2rwZ+kKKtkxNp0=
From: "Boeuf, Sebastien" <sebastien.boeuf@intel.com>
Date: Tue, 11 May 2021 15:00:05 +0000
Message-ID: <BY5PR11MB44018CADDC7A5C04F3D32BC4EA539@BY5PR11MB4401.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BY5PR11MB44018CADDC7A5C04F3D32BC4EA539BY5PR11MB4401namp_"
Subject: Re: [Virtio-fs] vhost-user reconnection and crash recovery
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>

--_000_BY5PR11MB44018CADDC7A5C04F3D32BC4EA539BY5PR11MB4401namp_
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

Thanks for the explanation.

So reconnection for vhost-user is not a well defined behavior,
and QEMU is doing its best to retry when possible, depending
on each device.

The guest does not know about it, so it's never notified that
the device needs to be reset.

But what about the vhost-user backend initialization? Does
QEMU go again through initializing memory table, vrings, etc...
since it can't assume anything from the backend?

Thanks,
Sebastien

________________________________
From: Stefan Hajnoczi
Sent: Tuesday, May 11, 2021 2:45 PM
To: Boeuf, Sebastien
Cc: virtio-fs@redhat.com; qemu-devel@nongnu.org
Subject: vhost-user reconnection and crash recovery

Hi Sebastien,
On #virtio-fs IRC you asked:

 I have a vhost-user question regarding disconnection/reconnection. How
 should this be handled? Let's say the vhost-user backend disconnects,
 and reconnects later on, does QEMU reset the virtio device by notifying
 the guest? Or does it simply reconnects to the backend without letting
 the guest know about what happened?

The vhost-user protocol does not have a generic reconnection solution.
Reconnection is handled on a case-by-case basis because device-specific
and implementation-specific state is involved.

The vhost-user-fs-pci device in QEMU has not been tested with
reconnection as far as I know.

The ideal reconnection behavior is to resume the device from its
previous state without disrupting the guest. Device state must survive
reconnection in order for this to work. Neither QEMU virtiofsd nor
virtiofsd-rs implement this today.

virtiofs has a lot of state, making it particularly difficult to support
either DEVICE_NEEDS_RESET or transparent vhost-user reconnection. We
have discussed virtiofs crash recovery on the bi-weekly virtiofs call
(https://etherpad.opendev.org/p/virtiofs-external-meeting). If you want
to work on this then joining the call would be a good starting point to
coordinate with others.

One approach for transparent crash recovery is for virtiofsd to keep its
state in tmpfs (e.g. inode/fd mappings) and open fds shared with a
clone(2) process via CLONE_FILES. This way the virtiofsd process can
terminate but its state persists in memory thanks to its clone process.
The clone can then be used to launch the new virtiofsd process from the
old state. This would allow the device to resume transparently with QEMU
only reconnecting the vhost-user UNIX domain socket. This is an idea
that we discussed in the bi-weekly virtiofs call.

You mentioned device reset. VIRTIO 1.1 has the Device Status Field
DEVICE_NEEDS_RESET flat that the device can use to tell the driver that
a reset is necessary. This feature is present in the specification but
not implemented in the Linux guest drivers. Again the reason is that
handling it requires driver-specific logic for restoring state after
reset...otherwise the device reset would be visible to userspace.

Stefan
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris,=20
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_000_BY5PR11MB44018CADDC7A5C04F3D32BC4EA539BY5PR11MB4401namp_
Content-Type: text/html; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
1">
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Hi Stefan,</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Thanks for the explanation.</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
So reconnection for vhost-user is not a well defined behavior,</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
and QEMU is doing its best to retry when possible, depending</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
on each device.</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
The guest does not know about it, so it's never notified that</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
the device needs to be reset.</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
But what about the vhost-user backend initialization? Does</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
QEMU go again through initializing memory table, vrings, etc...</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
since it can't assume anything from the backend?</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Thanks,</div>
<div style=3D"font-family: Calibri, Arial, Helvetica, sans-serif; font-size=
: 12pt; color: rgb(0, 0, 0);">
Sebastien<br>
</div>
<div>
<div style=3D"font-family:Calibri,Arial,Helvetica,sans-serif; font-size:12p=
t; color:rgb(0,0,0);">
<br>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%;">
<b>From:</b> Stefan Hajnoczi<br>
<b>Sent:</b> Tuesday, May 11, 2021 2:45 PM<br>
<b>To:</b> Boeuf, Sebastien<br>
<b>Cc:</b> virtio-fs@redhat.com; qemu-devel@nongnu.org<br>
<b>Subject:</b> vhost-user reconnection and crash recovery
<div><br>
</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">Hi Sebastien,<br>
On #virtio-fs IRC you asked:<br>
<br>
&nbsp;I have a vhost-user question regarding disconnection/reconnection. Ho=
w<br>
&nbsp;should this be handled? Let's say the vhost-user backend disconnects,=
<br>
&nbsp;and reconnects later on, does QEMU reset the virtio device by notifyi=
ng<br>
&nbsp;the guest? Or does it simply reconnects to the backend without lettin=
g<br>
&nbsp;the guest know about what happened?<br>
<br>
The vhost-user protocol does not have a generic reconnection solution.<br>
Reconnection is handled on a case-by-case basis because device-specific<br>
and implementation-specific state is involved.<br>
<br>
The vhost-user-fs-pci device in QEMU has not been tested with<br>
reconnection as far as I know.<br>
<br>
The ideal reconnection behavior is to resume the device from its<br>
previous state without disrupting the guest. Device state must survive<br>
reconnection in order for this to work. Neither QEMU virtiofsd nor<br>
virtiofsd-rs implement this today.<br>
<br>
virtiofs has a lot of state, making it particularly difficult to support<br=
>
either DEVICE_NEEDS_RESET or transparent vhost-user reconnection. We<br>
have discussed virtiofs crash recovery on the bi-weekly virtiofs call<br>
(<a href=3D"https://etherpad.opendev.org/p/virtiofs-external-meeting" targe=
t=3D"_blank" rel=3D"noopener noreferrer" data-auth=3D"NotApplicable">https:=
//etherpad.opendev.org/p/virtiofs-external-meeting</a>). If you want<br>
to work on this then joining the call would be a good starting point to<br>
coordinate with others.<br>
<br>
One approach for transparent crash recovery is for virtiofsd to keep its<br=
>
state in tmpfs (e.g. inode/fd mappings) and open fds shared with a<br>
clone(2) process via CLONE_FILES. This way the virtiofsd process can<br>
terminate but its state persists in memory thanks to its clone process.<br>
The clone can then be used to launch the new virtiofsd process from the<br>
old state. This would allow the device to resume transparently with QEMU<br=
>
only reconnecting the vhost-user UNIX domain socket. This is an idea<br>
that we discussed in the bi-weekly virtiofs call.<br>
<br>
You mentioned device reset. VIRTIO 1.1 has the Device Status Field<br>
DEVICE_NEEDS_RESET flat that the device can use to tell the driver that<br>
a reset is necessary. This feature is present in the specification but<br>
not implemented in the Linux guest drivers. Again the reason is that<br>
handling it requires driver-specific logic for restoring state after<br>
reset...otherwise the device reset would be visible to userspace.<br>
<br>
Stefan<br>
</div>
</span></font></div>
</div>
<p>---------------------------------------------------------------------<br=
>
Intel Corporation SAS (French simplified joint stock company)<br>
Registered headquarters: "Les Montalets"- 2, rue de Paris, <br>
92196 Meudon Cedex, France<br>
Registration Number:&nbsp; 302 456 199 R.C.S. NANTERRE<br>
Capital: 4,572,000 Euros</p>

<p>This e-mail and any attachments may contain confidential material for<br=
>
the sole use of the intended recipient(s). Any review or distribution<br>
by others is strictly prohibited. If you are not the intended<br>
recipient, please contact the sender and delete all copies.</p></body>
</html>

--_000_BY5PR11MB44018CADDC7A5C04F3D32BC4EA539BY5PR11MB4401namp_--

