DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=+uNrF5ROsVGyfgjVQg6D0M6p6VKL0g3W1Rldcy14BRs=;
	b=jbBzbzwsMrTc4C1EXvpESjLYRmVGYmoY/jKnWbOb9We5mM2WaXj4Aw+lBGKldvokXU
	PFQEYX07mms8CW9mXGmCC2ztjUWpLnr7YrHlET4kcM9OpmQAO2clkcvq6DXLf2SkRQEs
	jL5WiTmbnyZT7hJOV0Ec9zBEO5hm82+SukKpU4IhDvyj7HRuJWgdk5ad2Whod7zOf5lS
	OIVCvpgHlwVeggUvCj8XYCAzi/zl3JwT3cYWsCx5pBHfPqqZ++nVBrRPe8I1HW86+bzP
	IHrrAdjasbcyGL5DeKU5dBnfZ2RykAcdHr1ntUJ9Fb8hf4UmpXKR9Thu5EFA1K+zJzl9
	qrOA==
MIME-Version: 1.0
References: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
	<20200609125040.GG92564@stefanha-x1.localdomain>
In-Reply-To: <20200609125040.GG92564@stefanha-x1.localdomain>
From: Boris Ebwanga <bbebwanga@gmail.com>
Date: Thu, 11 Jun 2020 18:04:58 +0100
Message-ID: <CALfysxpKT0C1Eu8whTr-i4YdUp93sNBPSdriH-L68Qx03HE_jQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000918c1905a7d1f69e"
Subject: Re: [Virtio-fs] How to setup virtiofs for file sharing between host
 and VM
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

--000000000000918c1905a7d1f69e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!
I was able to modify the XML domain without errors.

Now, the guest failed to start. It shows this error message:
erreur :internal error: process exited while connecting to monitor:
2020-06-11T16:53:58.809703Z qemu-system-x86_64: -chardev
socket,id=3Dchar0,path=3D/home/deharteloos/tmp/vhost-fs.sock: Failed to con=
nect
socket /home/deharteloos/tmp/vhost-fs.sock: Permission denied

I don't know how to solve this problem.


Le mar. 9 juin 2020 =C3=A0 13:50, Stefan Hajnoczi <stefanha@redhat.com> a =
=C3=A9crit :

> On Fri, Jun 05, 2020 at 11:50:06AM +0100, Boris Ebwanga wrote:
> > Hello everyone.
> >
> > It's been a while now, I am trying to use virtio-fs. Everything I do en=
d
> up
> > with an error.
> >
> > First I was on fedora 31 and I tried to run manually qemu with virtio-f=
s
> > https://virtio-fs.gitlab.io/howto-qemu.html. But I was not able to "mak=
e
> > virtiofsd".
> >
> > Then, I upgraded to fedora 32 which has virtiofsd at /usr/libexec. I
> > followed the steps describe at
> > https://libvirt.org/kbase/virtiofs.html
> > I could not modify the XML domain of my VM. The error message is
> "*unsupported
> > configuration: unknown fs virtiofs =C2=BB driver type".*
> >
> > I wrote to Stefan Hajnoczi <stefanha@redhat.com> describing this
> problem.
> > He answers with the following:
> >
> > Hi Boris,
> > > You can pass command-line options to the guest like this:
> > >
> > >   <domain type=3D'kvm' xmlns:qemu=3D'
> > > http://libvirt.org/schemas/domain/qemu/1.0'>
> > >     ...
> > >     <qemu:commandline>
> > >       <qemu:arg value=3D'-chardev'/>
> > >       <qemu:arg value=3D'socket,id=3Dchar0,path=3D/tmp/vhost-fs.sock'=
/>
> > >       <qemu:arg value=3D'-device'/>
> > >       <qemu:arg
> > > value=3D'vhost-user-fs-pci,chardev=3Dvirtio-fs-chardev,tag=3Dmyfs'/>
> > >     </qemu:commandline>
> > >   </domain>
> > >
> > > Note that the xmlns in the <domain> tag is required.
> > >
> > > If you pass these options manually then you need to launch virtiofsd
> > > yourself before launching the guest:
> > >
> > >   # /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-fs.sock -o
> > > source=3D/path/to/share/dir -o no_posix_lock -o xattr
> > >
> > > Hope this helps! Please email virtio-fs@redhat.com if you have any
> more
> > > questions, it's the virtio-fs mailing list and others will be able to
> > > participate in the discussion.
> > >
> >
> > I am still getting the same error after applying the change above.
> >
> > Can anyone help me with this ? Thank you in advance for your help.
>
> Hi Boris,
> The "unknown fs virtiofs" error shouldn't happen if you the
> <qemu:commandline> syntax. Could it be that there is still a <filesystem
> type=3D'mount' accessmode=3D'passthrough'> XML tag from a previous attemp=
t?
>
> Please post the full domain XML (virsh dumpxml <domain>) so we can
> suggest how to fix it.
>
> Stefan
>

--000000000000918c1905a7d1f69e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div><br></div>Hello!<div>I was able to m=
odify the XML domain without errors.</div><div><br></div><div>Now, the gues=
t failed to start. It shows this error message:</div><div><font face=3D"mon=
ospace">erreur=C2=A0:internal error: process exited while connecting to mon=
itor: 2020-06-11T16:53:58.809703Z qemu-system-x86_64: -chardev socket,id=3D=
char0,path=3D/home/deharteloos/tmp/vhost-fs.sock: Failed to connect socket =
/home/deharteloos/tmp/vhost-fs.sock: Permission denied</font><br><br>I don&=
#39;t know how to solve this problem.</div><br></div><br><div class=3D"gmai=
l_quote"><div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0mar. 9 juin 2020 =C3=
=A0=C2=A013:50, Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com">=
stefanha@redhat.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">On Fri, Jun 05, 2020 at 11:50:06AM +0100, =
Boris Ebwanga wrote:<br>
&gt; Hello everyone.<br>
&gt; <br>
&gt; It&#39;s been a while now, I am trying to use virtio-fs. Everything I =
do end up<br>
&gt; with an error.<br>
&gt; <br>
&gt; First I was on fedora 31 and I tried to run manually qemu with virtio-=
fs<br>
&gt; <a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html" rel=3D"norefer=
rer" target=3D"_blank">https://virtio-fs.gitlab.io/howto-qemu.html</a>. But=
 I was not able to &quot;make<br>
&gt; virtiofsd&quot;.<br>
&gt; <br>
&gt; Then, I upgraded to fedora 32 which has virtiofsd at /usr/libexec. I<b=
r>
&gt; followed the steps describe at<br>
&gt; <a href=3D"https://libvirt.org/kbase/virtiofs.html" rel=3D"noreferrer"=
 target=3D"_blank">https://libvirt.org/kbase/virtiofs.html</a><br>
&gt; I could not modify the XML domain of my VM. The error message is &quot=
;*unsupported<br>
&gt; configuration: unknown fs virtiofs =C2=BB driver type&quot;.*<br>
&gt; <br>
&gt; I wrote to Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com" =
target=3D"_blank">stefanha@redhat.com</a>&gt; describing this problem.<br>
&gt; He answers with the following:<br>
&gt; <br>
&gt; Hi Boris,<br>
&gt; &gt; You can pass command-line options to the guest like this:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0&lt;domain type=3D&#39;kvm&#39; xmlns:qemu=3D&#39;<br=
>
&gt; &gt; <a href=3D"http://libvirt.org/schemas/domain/qemu/1.0" rel=3D"nor=
eferrer" target=3D"_blank">http://libvirt.org/schemas/domain/qemu/1.0</a>&#=
39;&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0...<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&lt;qemu:commandline&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;qemu:arg value=3D&#39;-chardev&#39;=
/&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;qemu:arg value=3D&#39;socket,id=3Dc=
har0,path=3D/tmp/vhost-fs.sock&#39;/&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;qemu:arg value=3D&#39;-device&#39;/=
&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;qemu:arg<br>
&gt; &gt; value=3D&#39;vhost-user-fs-pci,chardev=3Dvirtio-fs-chardev,tag=3D=
myfs&#39;/&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&lt;/qemu:commandline&gt;<br>
&gt; &gt;=C2=A0 =C2=A0&lt;/domain&gt;<br>
&gt; &gt;<br>
&gt; &gt; Note that the xmlns in the &lt;domain&gt; tag is required.<br>
&gt; &gt;<br>
&gt; &gt; If you pass these options manually then you need to launch virtio=
fsd<br>
&gt; &gt; yourself before launching the guest:<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0# /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-f=
s.sock -o<br>
&gt; &gt; source=3D/path/to/share/dir -o no_posix_lock -o xattr<br>
&gt; &gt;<br>
&gt; &gt; Hope this helps! Please email <a href=3D"mailto:virtio-fs@redhat.=
com" target=3D"_blank">virtio-fs@redhat.com</a> if you have any more<br>
&gt; &gt; questions, it&#39;s the virtio-fs mailing list and others will be=
 able to<br>
&gt; &gt; participate in the discussion.<br>
&gt; &gt;<br>
&gt; <br>
&gt; I am still getting the same error after applying the change above.<br>
&gt; <br>
&gt; Can anyone help me with this ? Thank you in advance for your help.<br>
<br>
Hi Boris,<br>
The &quot;unknown fs virtiofs&quot; error shouldn&#39;t happen if you the<b=
r>
&lt;qemu:commandline&gt; syntax. Could it be that there is still a &lt;file=
system<br>
type=3D&#39;mount&#39; accessmode=3D&#39;passthrough&#39;&gt; XML tag from =
a previous attempt?<br>
<br>
Please post the full domain XML (virsh dumpxml &lt;domain&gt;) so we can<br=
>
suggest how to fix it.<br>
<br>
Stefan<br>
</blockquote></div><img width=3D"0" height=3D"0" class=3D"mailtrack-img" al=
t=3D"" style=3D"display:flex" src=3D"https://mailtrack.io/trace/mail/6d524e=
43bb3d4f47c4650b9e52e9c7688b24e5b2.png?u=3D4017047"></div>

--000000000000918c1905a7d1f69e--

