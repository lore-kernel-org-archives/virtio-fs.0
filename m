MIME-Version: 1.0
References: <951c3359-f820-5c61-aa05-3419916761dc@jwatt.org>
	<CAGFMKp_nG4D7jZo=F8S=zhLUetOLF+nbN4h9teZgzSdnNp-cgQ@mail.gmail.com>
	<20201117095509.GA131917@stefanha-x1.localdomain>
In-Reply-To: <20201117095509.GA131917@stefanha-x1.localdomain>
From: Gal Hammer <ghammer@redhat.com>
Date: Sun, 22 Nov 2020 11:01:54 +0200
Message-ID: <CAA2ifQzPHFpauPPwJ-Q-kQcZ-e6rgMtuFqayyR+fbL5BJ7NuoQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000054571f05b4ae55a1"
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: virtio-fs@redhat.com

--00000000000054571f05b4ae55a1
Content-Type: text/plain; charset="UTF-8"

Hello,

On Tue, 17 Nov 2020 at 11:55, Stefan Hajnoczi <stefanha@redhat.com> wrote:

> On Mon, Nov 16, 2020 at 07:59:27PM +0100, Jonas Andradas wrote:
> > On Mon, Nov 16, 2020 at 12:36 PM Jonathan Watt <jwatt@jwatt.org> wrote:
>
> CCing Gal Hammer regarding the Windows virtio-fs drivers.
>
> When you find a solution we can update the howto. Pull requests for
> making changes to the website can be sent here:
> https://gitlab.com/virtio-fs/virtio-fs.gitlab.io
>
> >
> > > Hello list,
> > >
> > > Thank you all for your work on virtio-fs. It's a very exciting step
> > > forward!
> > >
> > > Like others[1], I've encountered the issue where virtio-fs mounted file
> > > systems
> > > are unexpectedly read-only/inaccessible on Windows.
> > >
> > > I worked through the Windows how-to page[2], but the "Installing the
> > > virtio-fs
> > > service" instructions at the bottom did not work for me, as written.
> The
> > > instructions are to set the new `VirtioFsSvc` service to depend on both
> > > `WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I found that
> > > the new
> > > service would not run since `VirtioFsDrv` does not appear to exist (be
> a
> > > service).
>

You can run "sc query type=driver" to locate the "VirtIO FS Driver"
(DISPLAY_NAME) and see what is the SERVICE_NAME for the driver that is
installed on your computer. It was renamed a few patches ago in order to
resolve another dependency issue.

I was able to reproduce the restart problem and I'll work to resolve it.

> I too did not manage this to work, and initially removed any dependencies,
> > thus resulting in the same behaviour you mention.
> >
> >
> > > After opening `regedit`, opening the key:
> > >
> > >   HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\VirtioFsSvc
> > >
> > > removing `VirtioFsDrv` from the value of `DependsOnService`, and then
> > > restarting
> > > the `VirtioFsSvc` service, the file system shared via virtio-fs
> appeared at
> > > 'Z:\' and worked as expected. However, this only works until the
> Windows
> > > VM is
> > > rebooted.
> > >
> > > On rebooting the Windows VM, the shared file system becomes read-only
> and
> > > its
> > > sub-directories cannot be opened. Manually restarting the `VirtioFsSvc`
> > > service
> > > gets the share working again (until next reboot). This seems to
> indicate
> > > that
> > > `VirtioFsSvc` is running too early, and that it really does need to
> wait
> > > for
> > > *something* else to be ready before starting.
> > >
> > > I suppose the first question is what is `VirtioFsDrv` and where is it
> > > supposed
> > >
> > to come from? Are there steps missing from the Windows how-to or has the
> > > name of
> > > this service changed?
> > >
> > >
> > I checked the Virtio FS driver, both from the Device Manager (Properties
> > and then checking the "Service" name associated with it) and also using
> the
> > "driverquery" command.  Based on this, I modified the service to depend
> > both on WinFps.Launcher and this driver ("VirtFS") by issuing the
> following
> > command:
> >
> > sc.exe config VirtioFSsvc depend= WinFsp.Launcher/VirtFS
> >
> > However, so far I have not had better results than you, as when I reboot
> I
> > still have the shared folder as read-only, and only restarting the
> service
> > manually fixes it.
> >
> > I have tried different combinations by adding all the drivers I saw which
> > could be involved (although unlikely, but just in case), resulting in
> > dependencies such as:
> >
> > sc.exe config VirtioFSsvc depend=
> > WinFsp.Launcher/VirtFS/vioscsi/viostor/VirtioSerial/WinFsp
>

This is "a bit" overkill. The service only uses the WinFsp and the virtiofs
driver.

Thanks for spotting the problem.

    Gal.


> >
> > But, still, to no avail.
>


> >
> > > -Jonathan
> > >
> > > 1. For example, the comments starting here:
> > >
> > >
> https://github.com/virtio-win/kvm-guest-drivers-windows/issues/473#issuecomment-658379853
> > >
> > > 2. https://virtio-fs.gitlab.io/howto-windows.html
> > >
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
>
>

--00000000000054571f05b4ae55a1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">Hello,<br></div></div><br><div class=3D"gmail_=
quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 17 Nov 2020 at 11:55, =
Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com">stefanha@redhat.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">On Mon, Nov 16, 2020 at 07:59:27PM +0100, Jonas Andradas wrote:<br>
&gt; On Mon, Nov 16, 2020 at 12:36 PM Jonathan Watt &lt;<a href=3D"mailto:j=
watt@jwatt.org" target=3D"_blank">jwatt@jwatt.org</a>&gt; wrote:<br>
<br>
CCing Gal Hammer regarding the Windows virtio-fs drivers.<br>
<br>
When you find a solution we can update the howto. Pull requests for<br>
making changes to the website can be sent here:<br>
<a href=3D"https://gitlab.com/virtio-fs/virtio-fs.gitlab.io" rel=3D"norefer=
rer" target=3D"_blank">https://gitlab.com/virtio-fs/virtio-fs.gitlab.io</a>=
<br>
<br>
&gt; <br>
&gt; &gt; Hello list,<br>
&gt; &gt;<br>
&gt; &gt; Thank you all for your work on virtio-fs. It&#39;s a very excitin=
g step<br>
&gt; &gt; forward!<br>
&gt; &gt;<br>
&gt; &gt; Like others[1], I&#39;ve encountered the issue where virtio-fs mo=
unted file<br>
&gt; &gt; systems<br>
&gt; &gt; are unexpectedly read-only/inaccessible on Windows.<br>
&gt; &gt;<br>
&gt; &gt; I worked through the Windows how-to page[2], but the &quot;Instal=
ling the<br>
&gt; &gt; virtio-fs<br>
&gt; &gt; service&quot; instructions at the bottom did not work for me, as =
written. The<br>
&gt; &gt; instructions are to set the new `VirtioFsSvc` service to depend o=
n both<br>
&gt; &gt; `WinFsp.Launcher` and `VirtioFsDrv`. However, like others, I foun=
d that<br>
&gt; &gt; the new<br>
&gt; &gt; service would not run since `VirtioFsDrv` does not appear to exis=
t (be a<br>
&gt; &gt; service).<br>
<span class=3D"gmail_default" style=3D"font-family:verdana,sans-serif"></sp=
an></blockquote><div><br></div><div><div style=3D"font-family:verdana,sans-=
serif" class=3D"gmail_default">You can run &quot;sc query type=3Ddriver&quo=
t; to locate the &quot;VirtIO FS Driver&quot; (DISPLAY_NAME) and see what i=
s the SERVICE_NAME for the driver that is installed on your computer. It wa=
s renamed a few patches ago in order to resolve another dependency issue.</=
div><div style=3D"font-family:verdana,sans-serif" class=3D"gmail_default"><=
br></div><div style=3D"font-family:verdana,sans-serif" class=3D"gmail_defau=
lt">I was able to reproduce the restart problem and I&#39;ll work to resolv=
e it.<br></div><div style=3D"font-family:verdana,sans-serif" class=3D"gmail=
_default"><br></div></div><blockquote class=3D"gmail_quote" style=3D"margin=
:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"=
>&gt; I too did not manage this to work, and initially removed any dependen=
cies,<br>
&gt; thus resulting in the same behaviour you mention.<br>
&gt; <br>
&gt; <br>
&gt; &gt; After opening `regedit`, opening the key:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\=
VirtioFsSvc<br>
&gt; &gt;<br>
&gt; &gt; removing `VirtioFsDrv` from the value of `DependsOnService`, and =
then<br>
&gt; &gt; restarting<br>
&gt; &gt; the `VirtioFsSvc` service, the file system shared via virtio-fs a=
ppeared at<br>
&gt; &gt; &#39;Z:\&#39; and worked as expected. However, this only works un=
til the Windows<br>
&gt; &gt; VM is<br>
&gt; &gt; rebooted.<br>
&gt; &gt;<br>
&gt; &gt; On rebooting the Windows VM, the shared file system becomes read-=
only and<br>
&gt; &gt; its<br>
&gt; &gt; sub-directories cannot be opened. Manually restarting the `Virtio=
FsSvc`<br>
&gt; &gt; service<br>
&gt; &gt; gets the share working again (until next reboot). This seems to i=
ndicate<br>
&gt; &gt; that<br>
&gt; &gt; `VirtioFsSvc` is running too early, and that it really does need =
to wait<br>
&gt; &gt; for<br>
&gt; &gt; *something* else to be ready before starting.<br>
&gt; &gt;<br>
&gt; &gt; I suppose the first question is what is `VirtioFsDrv` and where i=
s it<br>
&gt; &gt; supposed<br>
&gt; &gt;<br>
&gt; to come from? Are there steps missing from the Windows how-to or has t=
he<br>
&gt; &gt; name of<br>
&gt; &gt; this service changed?<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; I checked the Virtio FS driver, both from the Device Manager (Properti=
es<br>
&gt; and then checking the &quot;Service&quot; name associated with it) and=
 also using the<br>
&gt; &quot;driverquery&quot; command.=C2=A0 Based on this, I modified the s=
ervice to depend<br>
&gt; both on WinFps.Launcher and this driver (&quot;VirtFS&quot;) by issuin=
g the following<br>
&gt; command:<br>
&gt; <br>
&gt; sc.exe config VirtioFSsvc depend=3D WinFsp.Launcher/VirtFS<br>
&gt; <br>
&gt; However, so far I have not had better results than you, as when I rebo=
ot I<br>
&gt; still have the shared folder as read-only, and only restarting the ser=
vice<br>
&gt; manually fixes it.<br>
&gt; <br>
&gt; I have tried different combinations by adding all the drivers I saw wh=
ich<br>
&gt; could be involved (although unlikely, but just in case), resulting in<=
br>
&gt; dependencies such as:<br>
&gt; <br>
&gt; sc.exe config VirtioFSsvc depend=3D<br>
&gt; WinFsp.Launcher/VirtFS/vioscsi/viostor/VirtioSerial/WinFsp<br></blockq=
uote><div><br></div><div><div style=3D"font-family:verdana,sans-serif" clas=
s=3D"gmail_default">This is &quot;a bit&quot; overkill. The service only us=
es the WinFsp and the virtiofs driver.<br></div></div><div><br><div style=
=3D"font-family:verdana,sans-serif" class=3D"gmail_default">Thanks for spot=
ting the problem.</div><div style=3D"font-family:verdana,sans-serif" class=
=3D"gmail_default"><br></div><div style=3D"font-family:verdana,sans-serif" =
class=3D"gmail_default">=C2=A0=C2=A0=C2=A0 Gal.</div>=C2=A0</div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px s=
olid rgb(204,204,204);padding-left:1ex">
&gt; <br>
&gt; But, still, to no avail.<br>=C2=A0</blockquote><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex"> <br>
&gt; <br>
&gt; &gt; -Jonathan<br>
&gt; &gt;<br>
&gt; &gt; 1. For example, the comments starting here:<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"https://github.com/virtio-win/kvm-guest-drivers-window=
s/issues/473#issuecomment-658379853" rel=3D"noreferrer" target=3D"_blank">h=
ttps://github.com/virtio-win/kvm-guest-drivers-windows/issues/473#issuecomm=
ent-658379853</a><br>
&gt; &gt;<br>
&gt; &gt; 2. <a href=3D"https://virtio-fs.gitlab.io/howto-windows.html" rel=
=3D"noreferrer" target=3D"_blank">https://virtio-fs.gitlab.io/howto-windows=
.html</a><br>
&gt; &gt;<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; <a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@re=
dhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/virtio-fs" rel=3D"n=
oreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/virtio=
-fs</a><br>
<br>
</blockquote></div></div>

--00000000000054571f05b4ae55a1--

