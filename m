DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=lv0Ra0npc0zDg+5huwxkNkWa85CbZn3U2/JKrcsIfuQ=;
	b=cyaby05nG/yJetF4iOIruTj0Gr5ScRcp+jYY0OFVVjpMBpkaGpRnNXs0rlqf2zuVoA
	94n16MTzXb8W7ntqROUQ6mRe1n3P55U6sWMk5pp0Eklwd/THhiqWwQOZEEZNel+5Bh8Q
	2CHyqd3gurW/Ljwxj+l3j0xk6jEXXGrWGM3UXW9YSC9yRhf3MSm3stnb/KwbIIb2jL8T
	C2jPiooq7OvcvUbb4/+B6sjMqmelMXRhRqnJdIorFc7ToMNL2T9fc/l+dQnwMNtJLzat
	biXC/gushiwhIEefdnj5xtWsH56+3T6UCaC7ke2vP5qoFqz8noTSW9B30uMxmINfsoBN
	+wZA==
MIME-Version: 1.0
References: <951c3359-f820-5c61-aa05-3419916761dc@jwatt.org>
In-Reply-To: <951c3359-f820-5c61-aa05-3419916761dc@jwatt.org>
From: Jonas Andradas <j.andradas@gmail.com>
Date: Mon, 16 Nov 2020 19:59:27 +0100
Message-ID: <CAGFMKp_nG4D7jZo=F8S=zhLUetOLF+nbN4h9teZgzSdnNp-cgQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000dd89dd05b43dfab9"
Subject: Re: [Virtio-fs] Issues with the virtio-fs Windows how-to
 (unexpected read-only file system)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Jonathan Watt <jwatt@jwatt.org>
Cc: virtio-fs@redhat.com

--000000000000dd89dd05b43dfab9
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 16, 2020 at 12:36 PM Jonathan Watt <jwatt@jwatt.org> wrote:

> Hello list,
>
> Thank you all for your work on virtio-fs. It's a very exciting step
> forward!
>
> Like others[1], I've encountered the issue where virtio-fs mounted file
> systems
> are unexpectedly read-only/inaccessible on Windows.
>
> I worked through the Windows how-to page[2], but the "Installing the
> virtio-fs
> service" instructions at the bottom did not work for me, as written. The
> instructions are to set the new `VirtioFsSvc` service to depend on both
> `WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I found that
> the new
> service would not run since `VirtioFsDrv` does not appear to exist (be a
> service).
>
>
I too did not manage this to work, and initially removed any dependencies,
thus resulting in the same behaviour you mention.


> After opening `regedit`, opening the key:
>
>   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VirtioFsSvc
>
> removing `VirtioFsDrv` from the value of `DependsOnService`, and then
> restarting
> the `VirtioFsSvc` service, the file system shared via virtio-fs appeared at
> 'Z:\' and worked as expected. However, this only works until the Windows
> VM is
> rebooted.
>
> On rebooting the Windows VM, the shared file system becomes read-only and
> its
> sub-directories cannot be opened. Manually restarting the `VirtioFsSvc`
> service
> gets the share working again (until next reboot). This seems to indicate
> that
> `VirtioFsSvc` is running too early, and that it really does need to wait
> for
> *something* else to be ready before starting.
>
> I suppose the first question is what is `VirtioFsDrv` and where is it
> supposed
>
to come from? Are there steps missing from the Windows how-to or has the
> name of
> this service changed?
>
>
I checked the Virtio FS driver, both from the Device Manager (Properties
and then checking the "Service" name associated with it) and also using the
"driverquery" command.  Based on this, I modified the service to depend
both on WinFps.Launcher and this driver ("VirtFS") by issuing the following
command:

sc.exe config VirtioFSsvc depend= WinFsp.Launcher/VirtFS

However, so far I have not had better results than you, as when I reboot I
still have the shared folder as read-only, and only restarting the service
manually fixes it.

I have tried different combinations by adding all the drivers I saw which
could be involved (although unlikely, but just in case), resulting in
dependencies such as:

sc.exe config VirtioFSsvc depend=
WinFsp.Launcher/VirtFS/vioscsi/viostor/VirtioSerial/WinFsp

But, still, to no avail.


> -Jonathan
>
> 1. For example, the comments starting here:
>
> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/473#issuecomment-658379853
>
> 2. https://virtio-fs.gitlab.io/howto-windows.html
>

--000000000000dd89dd05b43dfab9
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div di=
r=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"lt=
r"><div dir=3D"ltr"><div dir=3D"ltr"></div><br><div class=3D"gmail_quote"><=
div dir=3D"ltr" class=3D"gmail_attr">On Mon, Nov 16, 2020 at 12:36 PM Jonat=
han Watt &lt;<a href=3D"mailto:jwatt@jwatt.org">jwatt@jwatt.org</a>&gt; wro=
te:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Hello list,<=
br>
<br>
Thank you all for your work on virtio-fs. It&#39;s a very exciting step for=
ward!<br>
<br>
Like others[1], I&#39;ve encountered the issue where virtio-fs mounted file=
 systems<br>
are unexpectedly read-only/inaccessible on Windows.<br>
<br>
I worked through the Windows how-to page[2], but the &quot;Installing the v=
irtio-fs<br>
service&quot; instructions at the bottom did not work for me, as written. T=
he<br>
instructions are to set the new `VirtioFsSvc` service to depend on both<br>
`WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I found that the=
 new<br>
service would not run since `VirtioFsDrv` does not appear to exist (be a se=
rvice).<br>
<br></blockquote><div><br></div><div>I too did not manage this to work, and=
 initially removed any dependencies, thus resulting in the same behaviour y=
ou mention.<br></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" sty=
le=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);paddi=
ng-left:1ex">
After opening `regedit`, opening the key:<br>
<br>
=C2=A0 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VirtioFsSvc<br>
<br>
removing `VirtioFsDrv` from the value of `DependsOnService`, and then resta=
rting<br>
the `VirtioFsSvc` service, the file system shared via virtio-fs appeared at=
<br>
&#39;Z:\&#39; and worked as expected. However, this only works until the Wi=
ndows VM is<br>
rebooted.<br>
<br>
On rebooting the Windows VM, the shared file system becomes read-only and i=
ts<br>
sub-directories cannot be opened. Manually restarting the `VirtioFsSvc` ser=
vice<br>
gets the share working again (until next reboot). This seems to indicate th=
at<br>
`VirtioFsSvc` is running too early, and that it really does need to wait fo=
r<br>
*something* else to be ready before starting.<br><br></blockquote><div></di=
v><div></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
I suppose the first question is what is `VirtioFsDrv` and where is it suppo=
sed<br></blockquote><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
to come from? Are there steps missing from the Windows how-to or has the na=
me of<br>
this service changed?<br>
<br></blockquote><div><br></div><div>I checked the Virtio FS driver, both f=
rom the Device Manager (Properties and then checking the &quot;Service&quot=
; name associated with it) and also using the &quot;driverquery&quot; comma=
nd.=C2=A0 Based on this, I modified the service to depend both on WinFps.La=
uncher and this driver (&quot;VirtFS&quot;) by issuing the following comman=
d:</div><div><br></div><div>sc.exe config VirtioFSsvc depend=3D WinFsp.Laun=
cher/VirtFS</div><div><br></div><div>However, so far I have not had better =
results than you, as when I reboot I still have the shared folder as read-o=
nly, and only restarting the service manually fixes it.=C2=A0 <br></div><di=
v><br></div><div>I have tried different combinations by adding all the driv=
ers I saw which could be involved (although unlikely, but just in case), re=
sulting in dependencies such as:</div><div><br></div><div>sc.exe config Vir=
tioFSsvc depend=3D WinFsp.Launcher/VirtFS/vioscsi/viostor/VirtioSerial/WinF=
sp</div><div><br></div><div>But, still, to no avail.<br></div><div>=C2=A0</=
div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bor=
der-left:1px solid rgb(204,204,204);padding-left:1ex">
-Jonathan<br>
<br>
1. For example, the comments starting here:<br>
<a href=3D"https://github.com/virtio-win/kvm-guest-drivers-windows/issues/4=
73#issuecomment-658379853" rel=3D"noreferrer" target=3D"_blank">https://git=
hub.com/virtio-win/kvm-guest-drivers-windows/issues/473#issuecomment-658379=
853</a><br>
<br>
2. <a href=3D"https://virtio-fs.gitlab.io/howto-windows.html" rel=3D"norefe=
rrer" target=3D"_blank">https://virtio-fs.gitlab.io/howto-windows.html</a><=
br>
</blockquote></div><div><br></div><div><br></div></div></div></div></div></=
div></div></div></div></div></div>

--000000000000dd89dd05b43dfab9--

