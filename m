MIME-Version: 1.0
References: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
In-Reply-To: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
From: Gal Hammer <ghammer@redhat.com>
Date: Tue, 3 Nov 2020 18:32:36 +0200
Message-ID: <CAA2ifQx7=8xr2v449JG_Z-6TPwAsBesk5btLqiaf3yoaWFbYJA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000cc03a005b33669c4"
Subject: Re: [Virtio-fs] Mount several mount tags in Windows using VirtioFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jonas Andradas <j.andradas@gmail.com>
Cc: virtio-fs@redhat.com

--000000000000cc03a005b33669c4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jonas,

On Tue, 3 Nov 2020 at 18:15, Jonas Andradas <j.andradas@gmail.com> wrote:

> Hello,
>
> TL;DR - Is there a way to mount more than one filesystem from a Linux hos=
t
> inside a Windows guest using VirtioFS?
>

TL;DR No.

I didn't implement (yet?) the code to track all the instances of PCI
devices and mount a folder or a drive for each one.

I have a Windows guest running on a Linux host, and I wanted to share
> several directories from the host inside the guest using VirtioFS.
>
> I followed the instructions I found in several places [1][2][3], and have
> installed the VirtioFS drivers and WinFPS. I first tried with one
> filesystem, and I can mount it and browse it fine.
>
> I then configured my Windows guest XML definition so it has 2
> 'filesystems' to, each with its own mount_tag (e.g. 'software' for
> '/home/user/software' and 'documents' for '/home/user/documents').  Windo=
ws
> shows 2 "Virtio FS Devices" in the device manager, so this looks promisin=
g.
>
> However, when I run 'virtiofs.exe' within Windows (or the service [1]
> suggests starts), I get a "Z:" mount (or whichever letter I specify with
> '-m <DRIVE>') with the first filesystem I specified ('software' in the
> example above).  If I then run 'virtiofs.exe' for a second time, I get a
> new mount (e.g. Y:), but with the same filesystem ('software', and not
> 'documents').
>
> I tried adding the mount_tag to the virtiofs.exe command line, or even
> the PCI path Windows sees the devices on, but this fails (understandably
> so, since the help does not indicate how to specify which filesystem shou=
ld
> be mounted).
>
> My question was whether (and if so, how) it is actually possible to mount
> more than one directory from the host inside a Windows guest using Virtio=
FS
> (as can be done in Linux guests).
>
> [1] https://virtio-fs.gitlab.io/howto-windows.html
> [2]
> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuec=
omment-667432487
> [3]
> https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_ho=
w_i_set_it_up/g12o5qt/
>
> Thank you very much in advance,
>
> --
> Jon=C3=A1s Andradas
>
>
    Gal.

--000000000000cc03a005b33669c4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">Hi Jonas,<br></div></div><br><div class=3D"gma=
il_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 3 Nov 2020 at 18:15=
, Jonas Andradas &lt;<a href=3D"mailto:j.andradas@gmail.com">j.andradas@gma=
il.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><div dir=3D"ltr">Hello,=C2=A0<div><br></div><div>TL;DR - Is there a w=
ay to mount more than one filesystem from a Linux host inside a Windows gue=
st using VirtioFS?</div></div></blockquote><div><br></div><div><div style=
=3D"font-family:verdana,sans-serif" class=3D"gmail_default">TL;DR No.</div>=
</div><div><br></div><div><div style=3D"font-family:verdana,sans-serif" cla=
ss=3D"gmail_default">I didn&#39;t implement (yet?) the code to track all th=
e instances of PCI devices and mount a folder or a drive for each one.</div=
><div style=3D"font-family:verdana,sans-serif" class=3D"gmail_default"></di=
v></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0p=
x 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><d=
iv dir=3D"ltr"><div>I have a Windows guest running on a Linux host, and I w=
anted to share several directories from the host inside the guest using Vir=
tioFS.=C2=A0</div><div><br></div><div>I followed the instructions I found i=
n several places [1][2][3], and have installed the VirtioFS drivers and Win=
FPS. I first tried with one filesystem, and I can mount it and browse it fi=
ne.</div><div><br></div><div>I then configured my=C2=A0Windows guest XML de=
finition so it has=C2=A02 &#39;filesystems&#39; to, each with its own mount=
_tag (e.g. &#39;software&#39; for &#39;/home/user/software&#39; and &#39;do=
cuments&#39; for &#39;/home/user/documents&#39;).=C2=A0 Windows shows 2 &qu=
ot;Virtio FS Devices&quot; in the device manager, so this looks promising.=
=C2=A0</div><div><br></div><div>However, when I run &#39;virtiofs.exe&#39; =
within Windows (or the service [1] suggests starts), I get a &quot;Z:&quot;=
 mount (or whichever letter I specify with &#39;-m &lt;DRIVE&gt;&#39;) with=
 the first filesystem I specified (&#39;software&#39; in the example above)=
.=C2=A0 If I then run &#39;virtiofs.exe&#39; for a second time, I get a new=
 mount (e.g. Y:), but with the same filesystem (&#39;software&#39;, and not=
 &#39;documents&#39;).=C2=A0=C2=A0</div><div><br></div><div>I tried adding =
the mount_tag to the virtiofs.exe command line, or even the=C2=A0PCI path W=
indows sees the devices on, but this fails (understandably so, since the he=
lp does not indicate how to specify which filesystem=C2=A0should be mounted=
).</div><div><br></div><div>My question was whether (and if so, how) it is =
actually possible to mount more than one directory from the host inside a W=
indows guest using VirtioFS (as can be done in Linux guests).</div><div><br=
></div><div>[1]=C2=A0<a href=3D"https://virtio-fs.gitlab.io/howto-windows.h=
tml" target=3D"_blank">https://virtio-fs.gitlab.io/howto-windows.html</a></=
div><div>[2]=C2=A0<a href=3D"https://github.com/virtio-win/kvm-guest-driver=
s-windows/issues/126#issuecomment-667432487" target=3D"_blank">https://gith=
ub.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecomment-6674324=
87</a></div><div>[3]=C2=A0<a href=3D"https://www.reddit.com/r/VFIO/comments=
/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/" target=3D"_blank=
">https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_ho=
w_i_set_it_up/g12o5qt/</a><br clear=3D"all"><div><br></div><div>Thank you v=
ery much in advance,</div><div><br></div>-- <br><div dir=3D"ltr"><div dir=
=3D"ltr"><div>Jon=C3=A1s Andradas<br><br></div></div></div></div></div></bl=
ockquote><div><br></div><div style=3D"font-family:verdana,sans-serif" class=
=3D"gmail_default">=C2=A0=C2=A0=C2=A0 Gal.<br></div></div></div>

--000000000000cc03a005b33669c4--

