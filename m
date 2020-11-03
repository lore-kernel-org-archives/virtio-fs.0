DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=s/4gX9OwU2E5YjAfEVzbc1kKrXAUQUySaBcIec5DRFE=;
	b=GRwkHeAFGE/Ipyr+0XL6ZO5xDIKh0sw9HYviU1IoHlQW0JF2PaZMe1id9voOq73Ewr
	fjeDjvOHv39oF7YakZn4wVt5hXwaelmmA6pHuIcOYj4Du+DlKL2c29IV2ozAvfacGu2x
	P7cbSpgg8Bqi75WZIwH5QTvze/1W9WskjROYTiNqB20a3hpPItra6sinEPq9nEbwoAvz
	j/w7U/x1KUQC92MZxJc6NidWt7xX4Wg97f/POhiBvYHw5FT9+j8+OlJx+3sa1KqK5Xmb
	zClIHNgcu6rOKUFIVShpSbXf3rFcNiJDM9uQJXkO7m+qfukgf8V0dtToFgRUryyd8UYC
	Wm8g==
MIME-Version: 1.0
References: <CAGFMKp_Q=pN6aKMRQWvSLY8HV6Z_977kTXiRAr=28RzTWeW8Fg@mail.gmail.com>
	<CAA2ifQx7=8xr2v449JG_Z-6TPwAsBesk5btLqiaf3yoaWFbYJA@mail.gmail.com>
	<CAGFMKp_i3uSpoKCeB=zfk9hwzqzC52C5K8GrE_2xvyH7NJt2SA@mail.gmail.com>
In-Reply-To: <CAGFMKp_i3uSpoKCeB=zfk9hwzqzC52C5K8GrE_2xvyH7NJt2SA@mail.gmail.com>
From: Jonas Andradas <j.andradas@gmail.com>
Date: Tue, 3 Nov 2020 18:42:17 +0100
Message-ID: <CAGFMKp8jytSOZGEbFDyKdWry2g1Y4sfUmeauOaXuB46pagZ38g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f9212e05b337629a"
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

--000000000000f9212e05b337629a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 3, 2020 at 5:50 PM Jonas Andradas <j.andradas@gmail.com> wrote:

> Hi Gal,
>
> On Tue, Nov 3, 2020 at 5:32 PM Gal Hammer <ghammer@redhat.com> wrote:
>
>> Hi Jonas,
>>
>> On Tue, 3 Nov 2020 at 18:15, Jonas Andradas <j.andradas@gmail.com> wrote=
:
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
>
>> I didn't implement (yet?) the code to track all the instances of PCI
>> devices and mount a folder or a drive for each one.
>>
>>
> For the moment, I will mount a temporary folder from the host and copy
> to/from it the files as needed.  My first approach to work around this wa=
s
> to create symbolic links within this shared folder, to the directories I
> wanted to share, but Windows sees the symbolic links (1 KB files) rather
> than following the link and thus being able to access the 2 or 3 differen=
t
> host directories by mounting just one.
>

It is possible to use a bind mount to "attach" the desired directories to
another directory that is then shared to the Windows guest, and Windows
will happily allow browsing through the files, which is a nice workaround.

For example, create the 'shares' directory, and the two example directories
'software' and 'documents' in the host:

mkdir -p /home/user/shares/software
mkdir -p /home/user/shares/documents

sudo mount -o bind /home/user/software /home/user/shares/software
sudo mount -o bind /home/user/documents /home/user/shares/documents


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
>>> '/home/user/software' and 'documents' for '/home/user/documents').  Win=
dows
>>> shows 2 "Virtio FS Devices" in the device manager, so this looks promis=
ing.
>>>
>>> However, when I run 'virtiofs.exe' within Windows (or the service [1]
>>> suggests starts), I get a "Z:" mount (or whichever letter I specify wit=
h
>>> '-m <DRIVE>') with the first filesystem I specified ('software' in the
>>> example above).  If I then run 'virtiofs.exe' for a second time, I get =
a
>>> new mount (e.g. Y:), but with the same filesystem ('software', and not
>>> 'documents').
>>>
>>> I tried adding the mount_tag to the virtiofs.exe command line, or even
>>> the PCI path Windows sees the devices on, but this fails (understandabl=
y
>>> so, since the help does not indicate how to specify which filesystem sh=
ould
>>> be mounted).
>>>
>>> My question was whether (and if so, how) it is actually possible to
>>> mount more than one directory from the host inside a Windows guest usin=
g
>>> VirtioFS (as can be done in Linux guests).
>>>
>>> [1] https://virtio-fs.gitlab.io/howto-windows.html
>>> [2]
>>> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issu=
ecomment-667432487
>>> [3]
>>> https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plus_=
how_i_set_it_up/g12o5qt/
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


--=20
Jon=C3=A1s Andradas

GPG Fingerprint:  678F 7BD0 83C3 28CE 9E8F
                           3F7F 4D87 9996 E0C6 9372
Keyservers:  pgp.mit.edu | pgp.rediris.es

--000000000000f9212e05b337629a
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><div class=3D"gmail_quote"><div=
 dir=3D"ltr" class=3D"gmail_attr">On Tue, Nov 3, 2020 at 5:50 PM Jonas Andr=
adas &lt;<a href=3D"mailto:j.andradas@gmail.com">j.andradas@gmail.com</a>&g=
t; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div d=
ir=3D"ltr"><div>Hi Gal,</div><br><div class=3D"gmail_quote"><div dir=3D"ltr=
" class=3D"gmail_attr">On Tue, Nov 3, 2020 at 5:32 PM Gal Hammer &lt;<a hre=
f=3D"mailto:ghammer@redhat.com" target=3D"_blank">ghammer@redhat.com</a>&gt=
; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div di=
r=3D"ltr"><div dir=3D"ltr"><div style=3D"font-family:verdana,sans-serif">Hi=
 Jonas,<br></div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" clas=
s=3D"gmail_attr">On Tue, 3 Nov 2020 at 18:15, Jonas Andradas &lt;<a href=3D=
"mailto:j.andradas@gmail.com" target=3D"_blank">j.andradas@gmail.com</a>&gt=
; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div di=
r=3D"ltr">Hello,=C2=A0<div><br></div><div>TL;DR - Is there a way to mount m=
ore than one filesystem from a Linux host inside a Windows guest using Virt=
ioFS?</div></div></blockquote><div><br></div><div><div style=3D"font-family=
:verdana,sans-serif">TL;DR No.</div></div><div><br></div></div></div></bloc=
kquote><div><br></div><div>Thanks for the information/confirmation!</div><d=
iv>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=
=3D"ltr"><div class=3D"gmail_quote"><div></div><div><div style=3D"font-fami=
ly:verdana,sans-serif">I didn&#39;t implement (yet?) the code to track all =
the instances of PCI devices and mount a folder or a drive for each one.</d=
iv><div style=3D"font-family:verdana,sans-serif"></div></div><div><br></div=
></div></div></blockquote><div><br></div><div>For the moment, I will mount =
a temporary folder from the host and copy to/from it the files as needed.=
=C2=A0 My first approach to work around this was to create symbolic links w=
ithin this shared folder, to the directories I wanted to share, but Windows=
 sees the symbolic links (1 KB files) rather than following the link and th=
us being able to access the 2 or 3 different host directories by mounting j=
ust one.</div></div></div></blockquote><div><br></div><div>It is possible t=
o use a bind mount to &quot;attach&quot; the desired directories to another=
 directory that is then shared to the Windows guest, and Windows will happi=
ly allow browsing through the files, which is a nice workaround.</div><div>=
<br></div><div>For example, create the &#39;shares&#39; directory, and the =
two example directories &#39;software&#39; and &#39;documents&#39; in the h=
ost:</div><div><br></div><div>mkdir -p /home/user/shares/software</div><div=
>mkdir -p /home/user/shares/documents</div><div><br></div><div>sudo mount -=
o bind /home/user/software /home/user/shares/software</div><div>sudo mount =
-o bind /home/user/documents /home/user/shares/documents</div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div=
 class=3D"gmail_quote"><div><br></div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex"><div dir=3D"ltr"><div class=3D"gmail_quote"><div></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1p=
x solid rgb(204,204,204);padding-left:1ex"><div dir=3D"ltr"><div>I have a W=
indows guest running on a Linux host, and I wanted to share several directo=
ries from the host inside the guest using VirtioFS.=C2=A0</div><div><br></d=
iv><div>I followed the instructions I found in several places [1][2][3], an=
d have installed the VirtioFS drivers and WinFPS. I first tried with one fi=
lesystem, and I can mount it and browse it fine.</div><div><br></div><div>I=
 then configured my=C2=A0Windows guest XML definition so it has=C2=A02 &#39=
;filesystems&#39; to, each with its own mount_tag (e.g. &#39;software&#39; =
for &#39;/home/user/software&#39; and &#39;documents&#39; for &#39;/home/us=
er/documents&#39;).=C2=A0 Windows shows 2 &quot;Virtio FS Devices&quot; in =
the device manager, so this looks promising.=C2=A0</div><div><br></div><div=
>However, when I run &#39;virtiofs.exe&#39; within Windows (or the service =
[1] suggests starts), I get a &quot;Z:&quot; mount (or whichever letter I s=
pecify with &#39;-m &lt;DRIVE&gt;&#39;) with the first filesystem I specifi=
ed (&#39;software&#39; in the example above).=C2=A0 If I then run &#39;virt=
iofs.exe&#39; for a second time, I get a new mount (e.g. Y:), but with the =
same filesystem (&#39;software&#39;, and not &#39;documents&#39;).=C2=A0=C2=
=A0</div><div><br></div><div>I tried adding the mount_tag to the virtiofs.e=
xe command line, or even the=C2=A0PCI path Windows sees the devices on, but=
 this fails (understandably so, since the help does not indicate how to spe=
cify which filesystem=C2=A0should be mounted).</div><div><br></div><div>My =
question was whether (and if so, how) it is actually possible to mount more=
 than one directory from the host inside a Windows guest using VirtioFS (as=
 can be done in Linux guests).</div><div><br></div><div>[1]=C2=A0<a href=3D=
"https://virtio-fs.gitlab.io/howto-windows.html" target=3D"_blank">https://=
virtio-fs.gitlab.io/howto-windows.html</a></div><div>[2]=C2=A0<a href=3D"ht=
tps://github.com/virtio-win/kvm-guest-drivers-windows/issues/126#issuecomme=
nt-667432487" target=3D"_blank">https://github.com/virtio-win/kvm-guest-dri=
vers-windows/issues/126#issuecomment-667432487</a></div><div>[3]=C2=A0<a hr=
ef=3D"https://www.reddit.com/r/VFIO/comments/i12uyn/virtiofs_is_amazing_plu=
s_how_i_set_it_up/g12o5qt/" target=3D"_blank">https://www.reddit.com/r/VFIO=
/comments/i12uyn/virtiofs_is_amazing_plus_how_i_set_it_up/g12o5qt/</a><br c=
lear=3D"all"><div><br></div><div>(...)</div><div dir=3D"ltr"><div dir=3D"lt=
r"><div><br></div></div></div></div></div></blockquote><div><br></div><div =
style=3D"font-family:verdana,sans-serif">=C2=A0=C2=A0=C2=A0 Gal.<br></div><=
/div></div>
</blockquote></div><br clear=3D"all"><div>Cheers,</div><div>Jonas.</div></d=
iv>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr"><div>Jon=C3=A1s Andradas<br><br=
>GPG Fingerprint:=C2=A0 678F 7BD0 83C3 28CE 9E8F<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0=
 3F7F 4D87 9996 E0C6 9372<br>Keyservers:=C2=A0 <a href=3D"http://pgp.mit.ed=
u" target=3D"_blank">pgp.mit.edu</a> | <a href=3D"http://pgp.rediris.es" ta=
rget=3D"_blank">pgp.rediris.es</a><br></div></div></div></div>

--000000000000f9212e05b337629a--

