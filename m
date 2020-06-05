DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:from:date:message-id:subject:to;
	bh=OeV365OumJiTqsOR0+vCfe/jo5ZlzScnJC8FyCpB0VE=;
	b=T6gPuOfVqagkdO+NmR5fSzQzGDhsKnA9KslZd2I7A2jByjL45w42qm0X00P8SGZEAS
	kFP7iHKWTYFom88JQM0oUJUoOmfvJBNOKygH/FCnoongdjit6Ir4FCnMXZqb61yKw3RE
	1sMs38chNaLHDXRPNF2A9GSqHgwmWmBfG2S+oILXHtTIG8HjmB/TxeF4VjWC8hCkvUoX
	LmBkrvD4teMO1W50vz8rCj2HbkoAEvtqBXn0oAnQ3s5zIZ3P+L5YxBaACR2IJvdfvn2G
	t384PQEu7YIPE/AlpwosHuna5ZtkC60/v/MwJ8R7LvjDzeTZ/MUaqOv+CufWfwiUuOJQ
	icNA==
MIME-Version: 1.0
From: Boris Ebwanga <bbebwanga@gmail.com>
Date: Fri, 5 Jun 2020 11:50:06 +0100
Message-ID: <CALfysxrU1WNcWhzRUXboMSjZLsOz_J=BC1y_heye8juk+L-fSA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000e17a0405a7540658"
Subject: [Virtio-fs] How to setup virtiofs for file sharing between host and
	VM
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000e17a0405a7540658
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello everyone.

It's been a while now, I am trying to use virtio-fs. Everything I do end up
with an error.

First I was on fedora 31 and I tried to run manually qemu with virtio-fs
https://virtio-fs.gitlab.io/howto-qemu.html. But I was not able to "make
virtiofsd".

Then, I upgraded to fedora 32 which has virtiofsd at /usr/libexec. I
followed the steps describe at
https://libvirt.org/kbase/virtiofs.html
I could not modify the XML domain of my VM. The error message is "*unsuppor=
ted
configuration: unknown fs virtiofs =C2=BB driver type".*

I wrote to Stefan Hajnoczi <stefanha@redhat.com> describing this problem.
He answers with the following:

Hi Boris,
> You can pass command-line options to the guest like this:
>
>   <domain type=3D'kvm' xmlns:qemu=3D'
> http://libvirt.org/schemas/domain/qemu/1.0'>
>     ...
>     <qemu:commandline>
>       <qemu:arg value=3D'-chardev'/>
>       <qemu:arg value=3D'socket,id=3Dchar0,path=3D/tmp/vhost-fs.sock'/>
>       <qemu:arg value=3D'-device'/>
>       <qemu:arg
> value=3D'vhost-user-fs-pci,chardev=3Dvirtio-fs-chardev,tag=3Dmyfs'/>
>     </qemu:commandline>
>   </domain>
>
> Note that the xmlns in the <domain> tag is required.
>
> If you pass these options manually then you need to launch virtiofsd
> yourself before launching the guest:
>
>   # /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-fs.sock -o
> source=3D/path/to/share/dir -o no_posix_lock -o xattr
>
> Hope this helps! Please email virtio-fs@redhat.com if you have any more
> questions, it's the virtio-fs mailing list and others will be able to
> participate in the discussion.
>

I am still getting the same error after applying the change above.

Can anyone help me with this ? Thank you in advance for your help.

--000000000000e17a0405a7540658
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br>Hello everyone.<div><br></div><div>It&#39;s been a whi=
le now, I am trying=C2=A0to use virtio-fs. Everything I do end up with an e=
rror.</div><div><br></div><div>First I was on fedora 31 and I tried to run =
manually qemu with virtio-fs=C2=A0=C2=A0<a href=3D"https://virtio-fs.gitlab=
.io/howto-qemu.html">https://virtio-fs.gitlab.io/howto-qemu.html</a>. But I=
 was not able to &quot;make virtiofsd&quot;.</div><div><br></div><div>Then,=
 I upgraded to fedora 32 which has virtiofsd=C2=A0at /usr/libexec. I=C2=A0<=
br>followed the steps describe at=C2=A0<br><a href=3D"https://libvirt.org/k=
base/virtiofs.html">https://libvirt.org/kbase/virtiofs.html</a><br></div>I =
could not modify the XML domain of my VM. The error message is &quot;<b>uns=
upported configuration: unknown fs=C2=A0virtiofs=C2=A0=C2=BB driver type&qu=
ot;.</b><div><br></div><div>I wrote to Stefan Hajnoczi <span style=3D"color=
:rgb(85,85,85);font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;fo=
nt-size:14px">&lt;</span><span style=3D"color:rgb(85,85,85);font-family:Rob=
oto,RobotoDraft,Helvetica,Arial,sans-serif;font-size:14px"><a href=3D"mailt=
o:stefanha@redhat.com">stefanha@redhat.com</a></span><span style=3D"color:r=
gb(85,85,85);font-family:Roboto,RobotoDraft,Helvetica,Arial,sans-serif;font=
-size:14px">&gt;=C2=A0</span>describing this problem. He answers with the f=
ollowing:</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:=
1ex">Hi Boris,<br>You can pass command-line options to the guest like this:=
<br><br>=C2=A0 &lt;domain type=3D&#39;kvm&#39; xmlns:qemu=3D&#39;<a href=3D=
"http://libvirt.org/schemas/domain/qemu/1.0" rel=3D"noreferrer" target=3D"_=
blank">http://libvirt.org/schemas/domain/qemu/1.0</a>&#39;&gt;<br>=C2=A0 =
=C2=A0 ...<br>=C2=A0 =C2=A0 &lt;qemu:commandline&gt;<br>=C2=A0 =C2=A0 =C2=
=A0 &lt;qemu:arg value=3D&#39;-chardev&#39;/&gt;<br>=C2=A0 =C2=A0 =C2=A0 &l=
t;qemu:arg value=3D&#39;socket,id=3Dchar0,path=3D/tmp/vhost-fs.sock&#39;/&g=
t;<br>=C2=A0 =C2=A0 =C2=A0 &lt;qemu:arg value=3D&#39;-device&#39;/&gt;<br>=
=C2=A0 =C2=A0 =C2=A0 &lt;qemu:arg value=3D&#39;vhost-user-fs-pci,chardev=3D=
virtio-fs-chardev,tag=3Dmyfs&#39;/&gt;<br>=C2=A0 =C2=A0 &lt;/qemu:commandli=
ne&gt;<br>=C2=A0 &lt;/domain&gt;<br><br>Note that the xmlns in the &lt;doma=
in&gt; tag is required.<br><br>If you pass these options manually then you =
need to launch virtiofsd<br>yourself before launching the guest:<br><br>=C2=
=A0 # /usr/libexec/virtiofsd --socket-path=3D/tmp/vhost-fs.sock -o source=
=3D/path/to/share/dir -o no_posix_lock -o xattr<br><br>Hope this helps! Ple=
ase email=C2=A0<a href=3D"mailto:virtio-fs@redhat.com" target=3D"_blank">vi=
rtio-fs@redhat.com</a>=C2=A0if you have any more<br>questions, it&#39;s the=
 virtio-fs mailing list and others will be able to<br>participate in the di=
scussion.<br></blockquote><div><br></div><div>I am still getting the same e=
rror after applying the change above.</div><div><br></div><div>Can anyone h=
elp me with this ? Thank you in advance for your help.=C2=A0</div><img widt=
h=3D"0" height=3D"0" class=3D"mailtrack-img" alt=3D"" style=3D"display:flex=
" src=3D"https://mailtrack.io/trace/mail/26bf117ffcb75054c178a50055ed995447=
44ea3a.png?u=3D4017047"></div>

--000000000000e17a0405a7540658--

