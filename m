MIME-Version: 1.0
References: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
	<CAA2ifQx7=8xr2v449JG_Z-6TPwAsBesk5btLqiaf3yoaWFbYJA@mail.gmail.com>
	<CAGFMKp_i3uSpoKCeB=zfk9hwzqzC52C5K8GrE_2xvyH7NJt2SA@mail.gmail.com>
In-Reply-To: <CAGFMKp_i3uSpoKCeB=zfk9hwzqzC52C5K8GrE_2xvyH7NJt2SA@mail.gmail.com>
From: Gal Hammer <ghammer@redhat.com>
Date: Wed, 4 Nov 2020 08:33:27 +0200
Message-ID: <CAA2ifQxNpXAH6+6fiAC0gxOLXdjSckbXb3d62rC4wu2Ge584MQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000e9180705b34228b7"
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

--000000000000e9180705b34228b7
Content-Type: text/plain; charset="UTF-8"

Hi Jonas,

On Tue, 3 Nov 2020 at 18:51, Jonas Andradas <j.andradas@gmail.com> wrote:

> Hi Gal,
>
> On Tue, Nov 3, 2020 at 5:32 PM Gal Hammer <ghammer@redhat.com> wrote:
>
>> Hi Jonas,
>>
>> On Tue, 3 Nov 2020 at 18:15, Jonas Andradas <j.andradas@gmail.com> wrote:
>>
>>> Hello,
>>>
>>> TL;DR - Is there a way to mount more than one filesystem from a Linux
>>> host inside a Windows guest using VirtioFS?
>>>
>>
>> TL;DR No.
>>
>>
> Thanks for the information/confirmation!
>

You're welcome. ;-)


>
>
>> I didn't implement (yet?) the code to track all the instances of PCI
>> devices and mount a folder or a drive for each one.
>>
>>
> For the moment, I will mount a temporary folder from the host and copy
> to/from it the files as needed.  My first approach to work around this was
> to create symbolic links within this shared folder, to the directories I
> wanted to share, but Windows sees the symbolic links (1 KB files) rather
> than following the link and thus being able to access the 2 or 3 different
> host directories by mounting just one.
>

Yeah, I'm aware of that as well. The symbolic link support is not
implemented.


>
> I have a Windows guest running on a Linux host, and I wanted to share
>>> several directories from the host inside the guest using VirtioFS.
>>>
>>> I followed the instructions I found in several places [1][2][3], and
>>> have installed the VirtioFS drivers and WinFPS. I first tried with one
>>> filesystem, and I can mount it and browse it fine.
>>>
>>> I then configured my Windows guest XML definition so it has 2
>>> 'filesystems' to, each with its own mount_tag (e.g. 'software' for
>>> '/home/user/software' and 'documents' for '/home/user/documents').  Windows
>>> shows 2 "Virtio FS Devices" in the device manager, so this looks promising.
>>>
>>> However, when I run 'virtiofs.exe' within Windows (or the service [1]
>>> suggests starts), I get a "Z:" mount (or whichever letter I specify with
>>> '-m <DRIVE>') with the first filesystem I specified ('software' in the
>>> example above).  If I then run 'virtiofs.exe' for a second time, I get a
>>> new mount (e.g. Y:), but with the same filesystem ('software', and not
>>> 'documents').
>>>
>>> I tried adding the mount_tag to the virtiofs.exe command line, or even
>>> the PCI path Windows sees the devices on, but this fails (understandably
>>> so, since the help does not indicate how to specify which filesystem should
>>> be mounted).
>>>
>>> My question was whether (and if so, how) it is actually possible to
>>> mount more than one directory from the host inside a Windows guest using
>>> VirtioFS (as can be done in Linux guests).
>>>
>>> [1] https://virtio-fs.gitlab.io/howto-windows.html
>>> [2]
>>> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecomment-667432487
>>> [3]
>>> https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/
>>>
>>> (...)
>>>
>>>
>>     Gal.
>>
>
> Cheers,
> Jonas.
>

    Gal.

--000000000000e9180705b34228b7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">Hi Jonas,<br></div></div><br><div class=3D"gma=
il_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 3 Nov 2020 at 18:51=
, Jonas Andradas &lt;<a href=3D"mailto:j.andradas@gmail.com">j.andradas@gma=
il.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><div dir=3D"ltr"><div>Hi Gal,</div><br><div class=3D"gmail_quote"><di=
v dir=3D"ltr" class=3D"gmail_attr">On Tue, Nov 3, 2020 at 5:32 PM Gal Hamme=
r &lt;<a href=3D"mailto:ghammer@redhat.com" target=3D"_blank">ghammer@redha=
t.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex"><div dir=3D"ltr"><div dir=3D"ltr"><div style=3D"font-family:verdana,sa=
ns-serif">Hi Jonas,<br></div></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr" class=3D"gmail_attr">On Tue, 3 Nov 2020 at 18:15, Jonas Andradas &=
lt;<a href=3D"mailto:j.andradas@gmail.com" target=3D"_blank">j.andradas@gma=
il.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><div dir=3D"ltr">Hello,=C2=A0<div><br></div><div>TL;DR - Is there a w=
ay to mount more than one filesystem from a Linux host inside a Windows gue=
st using VirtioFS?</div></div></blockquote><div><br></div><div><div style=
=3D"font-family:verdana,sans-serif">TL;DR No.</div></div><div><br></div></d=
iv></div></blockquote><div><br></div><div>Thanks for the information/confir=
mation!</div></div></div></blockquote><div><br></div><div><div style=3D"fon=
t-family:verdana,sans-serif" class=3D"gmail_default">You&#39;re welcome. ;-=
) </div></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex"><div dir=3D"ltr"><div class=3D"gmail_quote"><div>=C2=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div class=3D"gm=
ail_quote"><div></div><div><div style=3D"font-family:verdana,sans-serif">I =
didn&#39;t implement (yet?) the code to track all the instances of PCI devi=
ces and mount a folder or a drive for each one.</div><div style=3D"font-fam=
ily:verdana,sans-serif"></div></div><div><br></div></div></div></blockquote=
><div><br></div><div>For the moment, I will mount a temporary folder from t=
he host and copy to/from it the files as needed.=C2=A0 My first approach to=
 work around this was to create symbolic links within this shared folder, t=
o the directories I wanted to share, but Windows sees the symbolic links (1=
 KB files) rather than following the link and thus being able to access the=
 2 or 3 different host directories by mounting just one.</div></div></div><=
/blockquote><div><br></div><div><div style=3D"font-family:verdana,sans-seri=
f" class=3D"gmail_default">Yeah, I&#39;m aware of that as well. The symboli=
c link support is not implemented. <br></div></div><div>=C2=A0</div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div class=3D"g=
mail_quote"><div><br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
"><div dir=3D"ltr"><div class=3D"gmail_quote"><div></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div>I have a Windows gue=
st running on a Linux host, and I wanted to share several directories from =
the host inside the guest using VirtioFS.=C2=A0</div><div><br></div><div>I =
followed the instructions I found in several places [1][2][3], and have ins=
talled the VirtioFS drivers and WinFPS. I first tried with one filesystem, =
and I can mount it and browse it fine.</div><div><br></div><div>I then conf=
igured my=C2=A0Windows guest XML definition so it has=C2=A02 &#39;filesyste=
ms&#39; to, each with its own mount_tag (e.g. &#39;software&#39; for &#39;/=
home/user/software&#39; and &#39;documents&#39; for &#39;/home/user/documen=
ts&#39;).=C2=A0 Windows shows 2 &quot;Virtio FS Devices&quot; in the device=
 manager, so this looks promising.=C2=A0</div><div><br></div><div>However, =
when I run &#39;virtiofs.exe&#39; within Windows (or the service [1] sugges=
ts starts), I get a &quot;Z:&quot; mount (or whichever letter I specify wit=
h &#39;-m &lt;DRIVE&gt;&#39;) with the first filesystem I specified (&#39;s=
oftware&#39; in the example above).=C2=A0 If I then run &#39;virtiofs.exe&#=
39; for a second time, I get a new mount (e.g. Y:), but with the same files=
ystem (&#39;software&#39;, and not &#39;documents&#39;).=C2=A0=C2=A0</div><=
div><br></div><div>I tried adding the mount_tag to the virtiofs.exe command=
 line, or even the=C2=A0PCI path Windows sees the devices on, but this fail=
s (understandably so, since the help does not indicate how to specify which=
 filesystem=C2=A0should be mounted).</div><div><br></div><div>My question w=
as whether (and if so, how) it is actually possible to mount more than one =
directory from the host inside a Windows guest using VirtioFS (as can be do=
ne in Linux guests).</div><div><br></div><div>[1]=C2=A0<a href=3D"https://v=
irtio-fs.gitlab.io/howto-windows.html" target=3D"_blank">https://virtio-fs.=
gitlab.io/howto-windows.html</a></div><div>[2]=C2=A0<a href=3D"https://gith=
ub.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecomment-6674324=
87" target=3D"_blank">https://github.com/virtio-win/kvm-guest-drivers-windo=
ws/issues/126#issuecomment-667432487</a></div><div>[3]=C2=A0<a href=3D"http=
s://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_how_i_se=
t_it_up/g12o5qt/" target=3D"_blank">https://www.reddit.com/r/VFIO/comments/=
i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/</a><br clear=3D"al=
l"><div><br></div><div>(...)</div><div dir=3D"ltr"><div dir=3D"ltr"><div><b=
r></div></div></div></div></div></blockquote><div><br></div><div style=3D"f=
ont-family:verdana,sans-serif">=C2=A0=C2=A0=C2=A0 Gal.<br></div></div></div=
>
</blockquote></div><br clear=3D"all"><div>Cheers,</div><div>Jonas.</div></d=
iv></blockquote><div><br></div><div style=3D"font-family:verdana,sans-serif=
" class=3D"gmail_default">=C2=A0=C2=A0=C2=A0 Gal.</div><div style=3D"font-f=
amily:verdana,sans-serif" class=3D"gmail_default"><br></div></div></div>

--000000000000e9180705b34228b7--

