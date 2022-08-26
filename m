Return-Path: <dehghani.e@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc;
 bh=LYHhKMLeRAFxy7ekEXNtR/zy1GYL4pMpmKIBz7mw/fA=;
 b=AARLv0AEAQnGxfvYIGhgF1k1O8zQX2fMj/WXJqnp89hy4kddEChUPlVzR4wZHkXL7X
 tcaQcetGJ5tZSClu8yqxJm3c+oIjv/PXEGz1wJGNTWQNjmoRfxTnmlb4JWn3mzwZVhjd
 ViUfAT5uIRNbFYo+shf4B/FBs21+GrTGI39wgbluaUptJvbOUB2wX1YgIZzPIrU3z45X
 BlX0uzpqXf1oVSRDK3aZurNFP/8SVOebR8hnOP9n1Qpc7hw2qBSWBD/ezxBOb2a/5rF5
 VsgMoCFsn5f37eDpKiHvoUYcGhSpy76Q55XsxjPhIidL4woNZ0ahJGULAN+XD0ZMhw4C
 VH8A==
MIME-Version: 1.0
References: <CAH7xS_XHPenR9STmr7MNaHoGLr-Ks_FiFUYu482ntd1ftVsPfQ@mail.gmail.com>
 <CAJh=p+6JOz2irMLhtSE8zA0wvQKUYEHg53J4jTnqBXe=Q24LWQ@mail.gmail.com>
 <CAJh=p+6R3cSHBkreNbL7-7xCfRyG9LeY8NJwBGZaDOaN=zia=A@mail.gmail.com>
In-Reply-To: <CAJh=p+6R3cSHBkreNbL7-7xCfRyG9LeY8NJwBGZaDOaN=zia=A@mail.gmail.com>
From: Elaheh Dehghani <dehghani.e@gmail.com>
Date: Fri, 26 Aug 2022 10:38:20 -0700
Message-ID: <CAH7xS_Usm3PK8TX9qFVUs=c+BZuh1tSoAS-17mU3r8T9ad01kQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000ee92f705e7286181"
Subject: Re: [Virtio-fs] Map more than one uid/gid when running virtiofsd
 with unprivileged user
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: German Maglione <gmaglione@redhat.com>
Cc: virtio-fs@redhat.com

--000000000000ee92f705e7286181
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks German!

We have been able to patch the virtiofsd code to map a range of IDs. We are
using systemd service to run virtiofsd as a non-privilege user and its
AmbientCapabilities
<https://www.freedesktop.org/software/systemd/man/systemd.exec.html#Ambient=
Capabilities=3D>
set
to SETUID and SETGID. We've defined two new parameters for --uid-map and
--gid-map. The patch sets temporary caps for the running process
(SETUID/SETGID), writes the mapping according to the input parameters and
at the end it drops those temporary capabilities.

Do you see any value in upstreaming this patch?


Thanks!

On Fri, Aug 26, 2022 at 8:47 AM German Maglione <gmaglione@redhat.com>
wrote:

> On Fri, Aug 26, 2022 at 5:27 PM German Maglione <gmaglione@redhat.com>
> wrote:
> >
> > On Thu, Aug 18, 2022 at 1:16 AM Elaheh Dehghani <dehghani.e@gmail.com>
> wrote:
> > >
> > > We are using an unprivileged user to run virtiofsd in its own user
> namespace. We have a guest VM running on top of QEMU with KVM. We are
> sharing files from the host to the guest and we need to make sure only
> certain users/groups in the guest can read/write those files. Currently
> there is only one uid/gid that=E2=80=99s mapped correctly (the virtiofsd =
user on
> the host is mapped to guest) and everything else is mapped to nobody.
> > >
> > > It seems the reason is that unprivileged virtiofsd only maps current
> uid/gid when it's running inside its own user namespace.
> > >
> > > Due to some resource limitations that we have in our system, we can't
> use a container-engine such as lxc-usernsexec to map a range of uids/gids=
.
> So, I'm trying to figure out if there is a way to patch the
> =E2=80=98setup_id_mappings=E2=80=99 in virtiofsd code to support our spec=
ific scenario.
> > >
> > >
> > > The additional mapping that we need is for uid/gid=3D1000. What I've
> done:
> > >
> > > -        Defined 1000:100000:65536 in both /etc/subuid and /etc/subgi=
d
> > >
> > > -        Changed this line src/sandbox.rs =C2=B7 main =C2=B7 virtio-f=
s /
> virtiofsd =C2=B7 GitLab to something like:
> > >
> > > -         let uid_mapping =3D format!("{} {} 1\n1000 1000 1\n", uid,
> uid);
> > >
> > >
> > > After running virtiofsd, I=E2=80=99m getting this error:
> > >
> > > Error entering sandbox: WriteUidMap(Os { code: 1, kind:
> PermissionDenied, message: =E2=80=9COperation not permitted=E2=80=9D })
> > >
> > >
> > > What am I missing here?
> >
> > As non-privilege user, you are only allowed to map the user UID ->
> > same NS-UID (as virtiofsd does) or user UID -> NS-UID 0,
> > by writing directly to '/proc/PID/{uid_map, gid_map}.
> >
> > Mapping a range of UIDS/GUIDS is a privileged operation, you need to
> > set the content of both '/etc/subuid' and '/etc/subgid '
> > and run newuidmap/newgidmap.
> >
> > You could "manually" create the user namespace with "unshare -U", map
> > the uids/guid using newuidmap/newgidmap, and run virtiofsd
> > --sandbox=3Dchroot
> > For instance (as user 1000):
> >
> > shell_0_$ unshare -U
> > shell_0_$ echo $$
> > 1234
> >
> > (in a different terminal)
> > shell_1_$ newuidmap 1234 0 100000 65536
> > shell_1_$ newgidmap 1234 0 100000 65536
> >
> > (now in the previous terminal)
> > shell_0_$ virtiofsd --sandbox=3Dchroot ...
> >
> > Although lxc-usernsexec is a small tool that only creates user
> > namespaces and calls newuidmap/newgidmap to do the uid/gid mapping
> >
>
> I forgot to mention, as an alternative you can patch the virtiofsd
> code removing the 'setup_id_mapping()' call. So you can run
> virtiofsd --sandbox=3Dnamesapce ...
>
> and then just call newuidmap/newgidmap with the virtiofsd PID
>
> Cheers,
>
>
> --
> German
>
>

--000000000000ee92f705e7286181
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks German! <br><br>We have been able to patch the virt=
iofsd code to map a range of IDs. We are using systemd service to run virti=
ofsd as a non-privilege user and its=C2=A0<a href=3D"https://www.freedeskto=
p.org/software/systemd/man/systemd.exec.html#AmbientCapabilities=3D">Ambien=
tCapabilities</a>=C2=A0set to SETUID and SETGID. We&#39;ve defined two new =
parameters for --uid-map and --gid-map. The patch sets temporary caps for t=
he running process (SETUID/SETGID), writes the mapping according to the inp=
ut parameters and at the end it drops those temporary capabilities.<br><br>=
Do you see any value in upstreaming this patch?<br><br><br>Thanks!</div><br=
><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, A=
ug 26, 2022 at 8:47 AM German Maglione &lt;<a href=3D"mailto:gmaglione@redh=
at.com">gmaglione@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"g=
mail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204=
,204,204);padding-left:1ex">On Fri, Aug 26, 2022 at 5:27 PM German Maglione=
 &lt;<a href=3D"mailto:gmaglione@redhat.com" target=3D"_blank">gmaglione@re=
dhat.com</a>&gt; wrote:<br>
&gt;<br>
&gt; On Thu, Aug 18, 2022 at 1:16 AM Elaheh Dehghani &lt;<a href=3D"mailto:=
dehghani.e@gmail.com" target=3D"_blank">dehghani.e@gmail.com</a>&gt; wrote:=
<br>
&gt; &gt;<br>
&gt; &gt; We are using an unprivileged user to run virtiofsd in its own use=
r namespace. We have a guest VM running on top of QEMU with KVM. We are sha=
ring files from the host to the guest and we need to make sure only certain=
 users/groups in the guest can read/write those files. Currently there is o=
nly one uid/gid that=E2=80=99s mapped correctly (the virtiofsd user on the =
host is mapped to guest) and everything else is mapped to nobody.<br>
&gt; &gt;<br>
&gt; &gt; It seems the reason is that unprivileged virtiofsd only maps curr=
ent uid/gid when it&#39;s running inside its own user namespace.<br>
&gt; &gt;<br>
&gt; &gt; Due to some resource limitations that we have in our system, we c=
an&#39;t use a container-engine such as lxc-usernsexec to map a range of ui=
ds/gids. So, I&#39;m trying to figure out if there is a way to patch the =
=E2=80=98setup_id_mappings=E2=80=99 in virtiofsd code to support our specif=
ic scenario.<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; The additional mapping that we need is for uid/gid=3D1000. What I=
&#39;ve done:<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 Defined 1000:100000:65536 in both /e=
tc/subuid and /etc/subgid<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 Changed this line src/<a href=3D"htt=
p://sandbox.rs" rel=3D"noreferrer" target=3D"_blank">sandbox.rs</a> =C2=B7 =
main =C2=B7 virtio-fs / virtiofsd =C2=B7 GitLab to something like:<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0let uid_mapping =3D format!(&q=
uot;{} {} 1\n1000 1000 1\n&quot;, uid, uid);<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; After running virtiofsd, I=E2=80=99m getting this error:<br>
&gt; &gt;<br>
&gt; &gt; Error entering sandbox: WriteUidMap(Os { code: 1, kind: Permissio=
nDenied, message: =E2=80=9COperation not permitted=E2=80=9D })<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; What am I missing here?<br>
&gt;<br>
&gt; As non-privilege user, you are only allowed to map the user UID -&gt;<=
br>
&gt; same NS-UID (as virtiofsd does) or user UID -&gt; NS-UID 0,<br>
&gt; by writing directly to &#39;/proc/PID/{uid_map, gid_map}.<br>
&gt;<br>
&gt; Mapping a range of UIDS/GUIDS is a privileged operation, you need to<b=
r>
&gt; set the content of both &#39;/etc/subuid&#39; and &#39;/etc/subgid &#3=
9;<br>
&gt; and run newuidmap/newgidmap.<br>
&gt;<br>
&gt; You could &quot;manually&quot; create the user namespace with &quot;un=
share -U&quot;, map<br>
&gt; the uids/guid using newuidmap/newgidmap, and run virtiofsd<br>
&gt; --sandbox=3Dchroot<br>
&gt; For instance (as user 1000):<br>
&gt;<br>
&gt; shell_0_$ unshare -U<br>
&gt; shell_0_$ echo $$<br>
&gt; 1234<br>
&gt;<br>
&gt; (in a different terminal)<br>
&gt; shell_1_$ newuidmap 1234 0 100000 65536<br>
&gt; shell_1_$ newgidmap 1234 0 100000 65536<br>
&gt;<br>
&gt; (now in the previous terminal)<br>
&gt; shell_0_$ virtiofsd --sandbox=3Dchroot ...<br>
&gt;<br>
&gt; Although lxc-usernsexec is a small tool that only creates user<br>
&gt; namespaces and calls newuidmap/newgidmap to do the uid/gid mapping<br>
&gt;<br>
<br>
I forgot to mention, as an alternative you can patch the virtiofsd<br>
code removing the &#39;setup_id_mapping()&#39; call. So you can run<br>
virtiofsd --sandbox=3Dnamesapce ...<br>
<br>
and then just call newuidmap/newgidmap with the virtiofsd PID<br>
<br>
Cheers,<br>
<br>
<br>
-- <br>
German<br>
<br>
</blockquote></div>

--000000000000ee92f705e7286181--

