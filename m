MIME-Version: 1.0
References: <CALjEBWTnYLtVfJV_KnEv6oqdcWhU-dzoR_pB+C84u798oAw1Vw@mail.gmail.com>
	<20200611191154.GI2968@work-vm>
In-Reply-To: <20200611191154.GI2968@work-vm>
From: David Lomas <dl3@pale-eds.co.uk>
Date: Fri, 12 Jun 2020 12:42:17 +0100
Message-ID: <CALjEBWRR24OnJ9dUFFDWaungNONQLZM0J2dzUg-gOepTKAxttw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f645dc05a7e19375"
Subject: Re: [Virtio-fs] Getting help setting up virtiofs guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000f645dc05a7e19375
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just to say thanks to Dave (all the best people are called Dave) for the
pointer to use kernel 5.7. That just worked on the guest, and I can now see
the host filesystem.

Perhaps this page <https://virtio-fs.gitlab.io/howto-qemu.html> should just
link to the mainline kernel rather than the virtio-fs one?



On Thu, Jun 11, 2020 at 8:11 PM Dr. David Alan Gilbert <dgilbert@redhat.com=
>
wrote:

> * David Lomas (dl3@pale-eds.co.uk) wrote:
> > Apologies if this isn't the correct place for this kind or request.
>
> It's the right place to ask.
>
> > I've been following these instructions to set up host and guest:
> > https://virtio-fs.gitlab.io/howto-qemu.html and
> > https://libvirt.org/kbase/virtiofs.html
> >
> > On the host, I've built the latest version of libvirt (6.4.0) and qemu
> > (5.0.0), and added sections to the domain definition. All appears well
> (no
> > errors at least). This is the relevant section:
> >
> >     <filesystem type=3D'mount' accessmode=3D'passthrough'>
> >       <driver type=3D'virtiofs'/>
> >       <binary path=3D'/usr/libexec/virtiofsd'/>
> >       <source dir=3D'/fast_data/test'/>
> >       <target dir=3D'test'/>
> >       <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x06=
'
> > function=3D'0x0'/>
> >     </filesystem>
>
> I think that's OK.
>
> > On the guest, I've build the kernel (4.19.28), booted it, and confirmed
> > virtio_fs.ko is a built-in module.
>
> Where did you get that kernel?  It sounds rather old;  the main part of
> virtiofs is now in the upstream kernel; so if your distro has a recent
> 5.x kernel, you can just use it.
>
> > But on running mount -t virtio_fs test /mnt/test/ I get the following
> error:
> >
> > mount: /mnt/test: wrong fs type, bad option, bad superblock on
> qube-server,
> > missing codepage or helper program, or other error.
> >
> > Note both those web pages above suggest using mount -t virtiofs, but th=
at
> > gives unknown filesystem type 'virtiofs'
>
> It changed in the newer kernels to the 'virtiofs'.
>
> > I'm at a loss to find more detailed information on how to configure
> > this=E2=80=94are there other resources online, or can anyone suggest wh=
at to try
> > next?
>
> I suspect you're suffering from the older kernel here.  Try a nice
> shiny new one.
>
> Dave
>
> > Thanks!
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://www.redhat.com/mailman/listinfo/virtio-fs
>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>

--000000000000f645dc05a7e19375
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Just to say thanks to Dave (all the best people are c=
alled Dave) for the pointer to use kernel 5.7. That just worked on the gues=
t, and I can now see the host filesystem.</div><div><br></div><div>Perhaps =
<a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html" target=3D"_blank">t=
his page</a> should just link to the mainline kernel rather than the virtio=
-fs one?</div><div><br></div><div><br></div></div><br><div class=3D"gmail_q=
uote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Jun 11, 2020 at 8:11 PM=
 Dr. David Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com" target=
=3D"_blank">dgilbert@redhat.com</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">* David Lomas (<a href=3D"mailto:dl3@pale-=
eds.co.uk" target=3D"_blank">dl3@pale-eds.co.uk</a>) wrote:<br>
&gt; Apologies if this isn&#39;t the correct place for this kind or request=
.<br>
<br>
It&#39;s the right place to ask.<br>
<br>
&gt; I&#39;ve been following these instructions to set up host and guest:<b=
r>
&gt; <a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html" rel=3D"norefer=
rer" target=3D"_blank">https://virtio-fs.gitlab.io/howto-qemu.html</a> and<=
br>
&gt; <a href=3D"https://libvirt.org/kbase/virtiofs.html" rel=3D"noreferrer"=
 target=3D"_blank">https://libvirt.org/kbase/virtiofs.html</a><br>
&gt; <br>
&gt; On the host, I&#39;ve built the latest version of libvirt (6.4.0) and =
qemu<br>
&gt; (5.0.0), and added sections to the domain definition. All appears well=
 (no<br>
&gt; errors at least). This is the relevant section:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;filesystem type=3D&#39;mount&#39; accessmode=3D=
&#39;passthrough&#39;&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;driver type=3D&#39;virtiofs&#39;/&gt;<br=
>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;binary path=3D&#39;/usr/libexec/virtiofs=
d&#39;/&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;source dir=3D&#39;/fast_data/test&#39;/&=
gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;target dir=3D&#39;test&#39;/&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&lt;address type=3D&#39;pci&#39; domain=3D&#=
39;0x0000&#39; bus=3D&#39;0x00&#39; slot=3D&#39;0x06&#39;<br>
&gt; function=3D&#39;0x0&#39;/&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&lt;/filesystem&gt;<br>
<br>
I think that&#39;s OK.<br>
<br>
&gt; On the guest, I&#39;ve build the kernel (4.19.28), booted it, and conf=
irmed<br>
&gt; virtio_fs.ko is a built-in module.<br>
<br>
Where did you get that kernel?=C2=A0 It sounds rather old;=C2=A0 the main p=
art of<br>
virtiofs is now in the upstream kernel; so if your distro has a recent<br>
5.x kernel, you can just use it.<br>
<br>
&gt; But on running mount -t virtio_fs test /mnt/test/ I get the following =
error:<br>
&gt; <br>
&gt; mount: /mnt/test: wrong fs type, bad option, bad superblock on qube-se=
rver,<br>
&gt; missing codepage or helper program, or other error.<br>
&gt; <br>
&gt; Note both those web pages above suggest using mount -t virtiofs, but t=
hat<br>
&gt; gives unknown filesystem type &#39;virtiofs&#39;<br>
<br>
It changed in the newer kernels to the &#39;virtiofs&#39;.<br>
<br>
&gt; I&#39;m at a loss to find more detailed information on how to configur=
e<br>
&gt; this=E2=80=94are there other resources online, or can anyone suggest w=
hat to try<br>
&gt; next?<br>
<br>
I suspect you&#39;re suffering from the older kernel here.=C2=A0 Try a nice=
<br>
shiny new one.<br>
<br>
Dave<br>
<br>
&gt; Thanks!<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; <a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@re=
dhat.com</a><br>
&gt; <a href=3D"https://www.redhat.com/mailman/listinfo/virtio-fs" rel=3D"n=
oreferrer" target=3D"_blank">https://www.redhat.com/mailman/listinfo/virtio=
-fs</a><br>
<br>
--<br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br>
</blockquote></div>

--000000000000f645dc05a7e19375--

