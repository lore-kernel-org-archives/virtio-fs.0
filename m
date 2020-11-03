DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:from:date:message-id:subject:to:cc;
	bh=cxIu75+g0J4bSrH0j7Yt3TeZ3amqKVezRNgAROpWclU=;
	b=nZWippeM7Z9Gx4R8EY8y/VaB4K/IIyHjmXUJCcqv+6/5wpTtR3HFrvuqx9aLxQ8R/n
	LkdZkB4O7USelKzshrZnCEsFMDGfUwOYII+m3E3VTiHcwnyJTjVGNK7LBf+Zt4odwDjv
	WjrbNIkhz5QtQgQkQRrql9IVeWHsSZtfOcTGz9Z6EDRmu5QQIR5BNmz8gq/PUdh5t9bB
	VXXnfQwq5OLXXNFhkn4qaalxZP2urOZsiUAS6NZBBVV/3IVQWxpM8cAzu1SlF3/JtevN
	zPXs9Wx8gDuVYF7+nYEKhedDw4kKwfY8bB5efD/Bx9H1UTImRSM2riMorKL7I9HUAlod
	nWyw==
MIME-Version: 1.0
From: Jonas Andradas <j.andradas@gmail.com>
Date: Tue, 3 Nov 2020 17:14:44 +0100
Message-ID: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000d9387505b336297c"
Subject: [Virtio-fs] Mount several mount tags in Windows using VirtioFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Gal Hammer <ghammer@redhat.com>

--000000000000d9387505b336297c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

TL;DR - Is there a way to mount more than one filesystem from a Linux host
inside a Windows guest using VirtioFS?

I have a Windows guest running on a Linux host, and I wanted to share
several directories from the host inside the guest using VirtioFS.

I followed the instructions I found in several places [1][2][3], and have
installed the VirtioFS drivers and WinFPS. I first tried with one
filesystem, and I can mount it and browse it fine.

I then configured my Windows guest XML definition so it has 2 'filesystems'
to, each with its own mount_tag (e.g. 'software' for '/home/user/software'
and 'documents' for '/home/user/documents').  Windows shows 2 "Virtio FS
Devices" in the device manager, so this looks promising.

However, when I run 'virtiofs.exe' within Windows (or the service [1]
suggests starts), I get a "Z:" mount (or whichever letter I specify with
'-m <DRIVE>') with the first filesystem I specified ('software' in the
example above).  If I then run 'virtiofs.exe' for a second time, I get a
new mount (e.g. Y:), but with the same filesystem ('software', and not
'documents').

I tried adding the mount_tag to the virtiofs.exe command line, or even
the PCI path Windows sees the devices on, but this fails (understandably
so, since the help does not indicate how to specify which filesystem should
be mounted).

My question was whether (and if so, how) it is actually possible to mount
more than one directory from the host inside a Windows guest using VirtioFS
(as can be done in Linux guests).

[1] https://virtio-fs.gitlab.io/howto-windows.html
[2]
https://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecom=
ment-667432487
[3]
https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_how_=
i_set_it_up/g12o5qt/

Thank you very much in advance,

--=20
Jon=C3=A1s Andradas

--000000000000d9387505b336297c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,=C2=A0<div><br></div><div>TL;DR - Is there a way to =
mount more than one filesystem from a Linux host inside a Windows guest usi=
ng VirtioFS?</div><div><br></div><div>I have a Windows guest running on a L=
inux host, and I wanted to share several directories from the host inside t=
he guest using VirtioFS.=C2=A0</div><div><br></div><div>I followed the inst=
ructions I found in several places [1][2][3], and have installed the Virtio=
FS drivers and WinFPS. I first tried with one filesystem, and I can mount i=
t and browse it fine.</div><div><br></div><div>I then configured my=C2=A0Wi=
ndows guest XML definition so it has=C2=A02 &#39;filesystems&#39; to, each =
with its own mount_tag (e.g. &#39;software&#39; for &#39;/home/user/softwar=
e&#39; and &#39;documents&#39; for &#39;/home/user/documents&#39;).=C2=A0 W=
indows shows 2 &quot;Virtio FS Devices&quot; in the device manager, so this=
 looks promising.=C2=A0</div><div><br></div><div>However, when I run &#39;v=
irtiofs.exe&#39; within Windows (or the service [1] suggests starts), I get=
 a &quot;Z:&quot; mount (or whichever letter I specify with &#39;-m &lt;DRI=
VE&gt;&#39;) with the first filesystem I specified (&#39;software&#39; in t=
he example above).=C2=A0 If I then run &#39;virtiofs.exe&#39; for a second =
time, I get a new mount (e.g. Y:), but with the same filesystem (&#39;softw=
are&#39;, and not &#39;documents&#39;).=C2=A0=C2=A0</div><div><br></div><di=
v>I tried adding the mount_tag to the virtiofs.exe command line, or even th=
e=C2=A0PCI path Windows sees the devices on, but this fails (understandably=
 so, since the help does not indicate how to specify which filesystem=C2=A0=
should be mounted).</div><div><br></div><div>My question was whether (and i=
f so, how) it is actually possible to mount more than one directory from th=
e host inside a Windows guest using VirtioFS (as can be done in Linux guest=
s).</div><div><br></div><div>[1]=C2=A0<a href=3D"https://virtio-fs.gitlab.i=
o/howto-windows.html">https://virtio-fs.gitlab.io/howto-windows.html</a></d=
iv><div>[2]=C2=A0<a href=3D"https://github.com/virtio-win/kvm-guest-drivers=
-windows/issues/126#issuecomment-667432487">https://github.com/virtio-win/k=
vm-guest-drivers-windows/issues/126#issuecomment-667432487</a></div><div>[3=
]=C2=A0<a href=3D"https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is=
_amazing_plus_how_i_set_it_up/g12o5qt/">https://www.reddit.com/r/VFIO/comme=
nts/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/</a><br clear=
=3D"all"><div><br></div><div>Thank you very much in advance,</div><div><br>=
</div>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data-smartmail=3D"g=
mail_signature"><div dir=3D"ltr"><div>Jon=C3=A1s Andradas<br><br></div></di=
v></div></div></div>

--000000000000d9387505b336297c--

