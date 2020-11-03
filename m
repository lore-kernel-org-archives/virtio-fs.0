DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=0C0nBdoioxNj6zf8TUcJ/It7oIjNeSzlBt722Py9idQ=;
	b=VFJjEooNuQ4q9ZqfsYE8x4v0ogZhYQLVwUsCeITxlX6UeYIJw+LVKWulV41GC3CPXB
	+kKPKoKceRAVWDqfM+5IEuhPPfkZfRqvfCx6pYiBnfhMPF/7hkG/Eb3JRFmZNpOQ+bMT
	lXXWi7uFxJFpi3Pi5Hi9DnqjBVHxpHt3tt05h1GLnl11p39y4F6QFnQJjw/IYCKlYTbN
	owUcoNt61P1rWo+Q5fAx3pb3heXrBN5WVcjw6xGTQ7pgwSNdJMS3sToZlrD1wtVV1PgC
	1+vXpOCKolySYKkvWJb7l/00Nrf2iXSsjIJ94NXwQyUeZt5WRtmQDwQcULq4/gPWrTUn
	htEA==
MIME-Version: 1.0
References: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
	<CAA2ifQx7=8xr2v449JG_Z-6TPwAsBesk5btLqiaf3yoaWFbYJA@mail.gmail.com>
In-Reply-To: <CAA2ifQx7=8xr2v449JG_Z-6TPwAsBesk5btLqiaf3yoaWFbYJA@mail.gmail.com>
From: Jonas Andradas <j.andradas@gmail.com>
Date: Tue, 3 Nov 2020 17:50:44 +0100
Message-ID: <CAGFMKp_i3uSpoKCeB=zfk9hwzqzC52C5K8GrE_2xvyH7NJt2SA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000009a77d505b336aa64"
Subject: Re: [Virtio-fs] Mount several mount tags in Windows using VirtioFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Gal Hammer <ghammer@redhat.com>
Cc: virtio-fs@redhat.com

--0000000000009a77d505b336aa64
Content-Type: text/plain; charset="UTF-8"

Hi Gal,

On Tue, Nov 3, 2020 at 5:32 PM Gal Hammer <ghammer@redhat.com> wrote:

> Hi Jonas,
>
> On Tue, 3 Nov 2020 at 18:15, Jonas Andradas <j.andradas@gmail.com> wrote:
>
>> Hello,
>>
>> TL;DR - Is there a way to mount more than one filesystem from a Linux
>> host inside a Windows guest using VirtioFS?
>>
>
> TL;DR No.
>
>
Thanks for the information/confirmation!


> I didn't implement (yet?) the code to track all the instances of PCI
> devices and mount a folder or a drive for each one.
>
>
For the moment, I will mount a temporary folder from the host and copy
to/from it the files as needed.  My first approach to work around this was
to create symbolic links within this shared folder, to the directories I
wanted to share, but Windows sees the symbolic links (1 KB files) rather
than following the link and thus being able to access the 2 or 3 different
host directories by mounting just one.

I have a Windows guest running on a Linux host, and I wanted to share
>> several directories from the host inside the guest using VirtioFS.
>>
>> I followed the instructions I found in several places [1][2][3], and have
>> installed the VirtioFS drivers and WinFPS. I first tried with one
>> filesystem, and I can mount it and browse it fine.
>>
>> I then configured my Windows guest XML definition so it has 2
>> 'filesystems' to, each with its own mount_tag (e.g. 'software' for
>> '/home/user/software' and 'documents' for '/home/user/documents').  Windows
>> shows 2 "Virtio FS Devices" in the device manager, so this looks promising.
>>
>> However, when I run 'virtiofs.exe' within Windows (or the service [1]
>> suggests starts), I get a "Z:" mount (or whichever letter I specify with
>> '-m <DRIVE>') with the first filesystem I specified ('software' in the
>> example above).  If I then run 'virtiofs.exe' for a second time, I get a
>> new mount (e.g. Y:), but with the same filesystem ('software', and not
>> 'documents').
>>
>> I tried adding the mount_tag to the virtiofs.exe command line, or even
>> the PCI path Windows sees the devices on, but this fails (understandably
>> so, since the help does not indicate how to specify which filesystem should
>> be mounted).
>>
>> My question was whether (and if so, how) it is actually possible to mount
>> more than one directory from the host inside a Windows guest using VirtioFS
>> (as can be done in Linux guests).
>>
>> [1] https://virtio-fs.gitlab.io/howto-windows.html
>> [2]
>> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecomment-667432487
>> [3]
>> https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/
>>
>> (...)
>>
>>
>     Gal.
>

Cheers,
Jonas.

--0000000000009a77d505b336aa64
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Gal,</div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Tue, Nov 3, 2020 at 5:32 PM Gal Hammer &lt=
;<a href=3D"mailto:ghammer@redhat.com">ghammer@redhat.com</a>&gt; wrote:<br=
></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><=
div dir=3D"ltr"><div style=3D"font-family:verdana,sans-serif">Hi Jonas,<br>=
</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_=
attr">On Tue, 3 Nov 2020 at 18:15, Jonas Andradas &lt;<a href=3D"mailto:j.a=
ndradas@gmail.com" target=3D"_blank">j.andradas@gmail.com</a>&gt; wrote:<br=
></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr">H=
ello,=C2=A0<div><br></div><div>TL;DR - Is there a way to mount more than on=
e filesystem from a Linux host inside a Windows guest using VirtioFS?</div>=
</div></blockquote><div><br></div><div><div style=3D"font-family:verdana,sa=
ns-serif">TL;DR No.</div></div><div><br></div></div></div></blockquote><div=
><br></div><div>Thanks for the information/confirmation!</div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div=
 class=3D"gmail_quote"><div></div><div><div style=3D"font-family:verdana,sa=
ns-serif">I didn&#39;t implement (yet?) the code to track all the instances=
 of PCI devices and mount a folder or a drive for each one.</div><div style=
=3D"font-family:verdana,sans-serif"></div></div><div><br></div></div></div>=
</blockquote><div><br></div><div>For the moment, I will mount a temporary f=
older from the host and copy to/from it the files as needed.=C2=A0 My first=
 approach to work around this was to create symbolic links within this shar=
ed folder, to the directories I wanted to share, but Windows sees the symbo=
lic links (1 KB files) rather than following the link and thus being able t=
o access the 2 or 3 different host directories by mounting just one.</div><=
div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px=
 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D=
"ltr"><div class=3D"gmail_quote"><div></div><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex"><div dir=3D"ltr"><div>I have a Windows guest running on =
a Linux host, and I wanted to share several directories from the host insid=
e the guest using VirtioFS.=C2=A0</div><div><br></div><div>I followed the i=
nstructions I found in several places [1][2][3], and have installed the Vir=
tioFS drivers and WinFPS. I first tried with one filesystem, and I can moun=
t it and browse it fine.</div><div><br></div><div>I then configured my=C2=
=A0Windows guest XML definition so it has=C2=A02 &#39;filesystems&#39; to, =
each with its own mount_tag (e.g. &#39;software&#39; for &#39;/home/user/so=
ftware&#39; and &#39;documents&#39; for &#39;/home/user/documents&#39;).=C2=
=A0 Windows shows 2 &quot;Virtio FS Devices&quot; in the device manager, so=
 this looks promising.=C2=A0</div><div><br></div><div>However, when I run &=
#39;virtiofs.exe&#39; within Windows (or the service [1] suggests starts), =
I get a &quot;Z:&quot; mount (or whichever letter I specify with &#39;-m &l=
t;DRIVE&gt;&#39;) with the first filesystem I specified (&#39;software&#39;=
 in the example above).=C2=A0 If I then run &#39;virtiofs.exe&#39; for a se=
cond time, I get a new mount (e.g. Y:), but with the same filesystem (&#39;=
software&#39;, and not &#39;documents&#39;).=C2=A0=C2=A0</div><div><br></di=
v><div>I tried adding the mount_tag to the virtiofs.exe command line, or ev=
en the=C2=A0PCI path Windows sees the devices on, but this fails (understan=
dably so, since the help does not indicate how to specify which filesystem=
=C2=A0should be mounted).</div><div><br></div><div>My question was whether =
(and if so, how) it is actually possible to mount more than one directory f=
rom the host inside a Windows guest using VirtioFS (as can be done in Linux=
 guests).</div><div><br></div><div>[1]=C2=A0<a href=3D"https://virtio-fs.gi=
tlab.io/howto-windows.html" target=3D"_blank">https://virtio-fs.gitlab.io/h=
owto-windows.html</a></div><div>[2]=C2=A0<a href=3D"https://github.com/virt=
io-win/kvm-guest-drivers-windows/issues/126#issuecomment-667432487" target=
=3D"_blank">https://github.com/virtio-win/kvm-guest-drivers-windows/issues/=
126#issuecomment-667432487</a></div><div>[3]=C2=A0<a href=3D"https://www.re=
ddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g1=
2o5qt/" target=3D"_blank">https://www.reddit.com/r/VFIO/comments/i12uyn/vir=
tiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/</a><br clear=3D"all"><div><b=
r></div><div>(...)</div><div dir=3D"ltr"><div dir=3D"ltr"><div><br></div></=
div></div></div></div></blockquote><div><br></div><div style=3D"font-family=
:verdana,sans-serif">=C2=A0=C2=A0=C2=A0 Gal.<br></div></div></div>
</blockquote></div><br clear=3D"all"><div>Cheers,</div><div>Jonas.</div></d=
iv>

--0000000000009a77d505b336aa64--

