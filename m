MIME-Version: 1.0
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
In-Reply-To: <20200728131250.GB78409@redhat.com>
From: Roman Mohr <rmohr@redhat.com>
Date: Wed, 29 Jul 2020 09:59:01 +0200
Message-ID: <CALDPj7uvquu=YWX_Ve7ROdj=LZWjkgPOm+wvEAynGvjeF4Xivg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000078858c05ab8fee64"
Subject: Re: [Virtio-fs] [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS)
	and print an error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>

--00000000000078858c05ab8fee64
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 28, 2020 at 3:13 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> > On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> > misono.tomohiro@fujitsu.com> wrote:
> >
> > > > Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print
> an
> > > error
> > > >
> > > > An assertion failure is raised during request processing if
> > > > unshare(CLONE_FS) fails. Implement a probe at startup so the problem
> can
> > > > be detected right away.
> > > >
> > > > Unfortunately Docker/Moby does not include unshare in the
> seccomp.json
> > > > list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
> > > > include unshare (e.g. podman is unaffected):
> > > >
> > >
> https://raw.githubusercontent.com/seccomp/containers-golang/master/seccomp.json
> > > >
> > > > Use "docker run --security-opt seccomp=path/to/seccomp.json ..." if
> the
> > > > default seccomp.json is missing unshare.
> > >
> > > Hi, sorry for a bit late.
> > >
> > > unshare() was added to fix xattr problem:
> > >
> > >
> https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#
> > > In theory we don't need to call unshare if xattr is disabled, but it is
> > > hard to get to know
> > > if xattr is enabled or disabled in fv_queue_worker(), right?
> > >
> > >
> > In kubevirt we want to run virtiofsd in containers. We would already not
> > have xattr support for e.g. overlayfs in the VM after this patch series
> (an
> > acceptable con at least for us right now).
> > If we can get rid of the unshare (and potentially of needing root) that
> > would be great. We always assume that everything which we run in
> containers
> > should work for cri-o and docker.
>
> But cri-o and docker containers run as root, isn't it? (or atleast have
> the capability to run as root). Havind said that, it will be nice to be
> able
> to run virtiofsd without root.
>

Yes they can run as root. I can tell you what we plan to do with the
containerized virtiofsd: We run it as part of the user-owned pod (a set of
containers).
One of our main goals at the moment is to run VMs in a user-owned pod
without additional privileges.
So that in case the user (VM-creator/owner) enters the pod or something
breaks out of the VM they are just in the unprivileged container sandbox.
As part of that we try to get also rid of running containers in the
user-context with the root user.

One possible scenario which I could think of as being desirable from a
kubevirt perspective:
We would run the VM in one container and have an unprivileged
virtiofsd container in parallel.
This container already has its own mount namespace and it is not that
critical if something manages to enter this sandbox.

But we are not as far yet as getting completely rid of root right now in
kubevirt, so if as a temporary step it needs root, the current proposed
changes would still be very useful for us.

Best Regards,
Roman

There are few hurdles though.
>
> - For file creation, we switch uid/gid (seteuid/setegid) and that seems
>   to require root. If we were to run unpriviliged, probably all files
>   on host will have to be owned by unpriviliged user and guest visible
>   uid/gid will have to be stored in xattrs. I think virtfs supports
>   something similar.


> I am sure there are other restrictions but this probably is the biggest
> one to overcome.
>
>  >
> > "Just" pointing docker to a different seccomp.json file is something
> which
> > k8s users/admin in many cases can't do.
>
> Or may be issue is that standard seccomp.json does not allow unshare()
> and hence you are forced to use a non-standar seccomp.json.
>
> Vivek
>
> >
> > Best Regards,
> > Roman
> >
> >
> > > So, it looks good to me.
> > > Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > >
> > > Regards,
> > > Misono
> > >
> > > >
> > > > Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > > > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > ---
> > > >  tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++
> > > >  1 file changed, 16 insertions(+)
> > > >
> > > > diff --git a/tools/virtiofsd/fuse_virtio.c
> > > b/tools/virtiofsd/fuse_virtio.c
> > > > index 3b6d16a041..9e5537506c 100644
> > > > --- a/tools/virtiofsd/fuse_virtio.c
> > > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > > @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_session
> *se)
> > > >  {
> > > >      int ret;
> > > >
> > > > +    /*
> > > > +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will
> need
> > > it. It's
> > > > +     * an unprivileged system call but some Docker/Moby versions are
> > > known to
> > > > +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
> > > > +     *
> > > > +     * Note that the program is single-threaded here so this syscall
> > > has no
> > > > +     * visible effect and is safe to make.
> > > > +     */
> > > > +    ret = unshare(CLONE_FS);
> > > > +    if (ret == -1 && errno == EPERM) {
> > > > +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with
> EPERM. If
> > > "
> > > > +                "running in a container please check that the
> container
> > > "
> > > > +                "runtime seccomp policy allows unshare.\n");
> > > > +        return -1;
> > > > +    }
> > > > +
> > > >      ret = fv_create_listen_socket(se);
> > > >      if (ret < 0) {
> > > >          return ret;
> > > > --
> > > > 2.26.2
> > >
> > >
>
>

--00000000000078858c05ab8fee64
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jul 28, 2020 at 3:13 PM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; w=
rote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Tue, Ju=
l 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:<br>
&gt; On Tue, Jul 28, 2020 at 3:07 AM <a href=3D"mailto:misono.tomohiro@fuji=
tsu.com" target=3D"_blank">misono.tomohiro@fujitsu.com</a> &lt;<br>
&gt; <a href=3D"mailto:misono.tomohiro@fujitsu.com" target=3D"_blank">mison=
o.tomohiro@fujitsu.com</a>&gt; wrote:<br>
&gt; <br>
&gt; &gt; &gt; Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) a=
nd print an<br>
&gt; &gt; error<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; An assertion failure is raised during request processing if<=
br>
&gt; &gt; &gt; unshare(CLONE_FS) fails. Implement a probe at startup so the=
 problem can<br>
&gt; &gt; &gt; be detected right away.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Unfortunately Docker/Moby does not include unshare in the se=
ccomp.json<br>
&gt; &gt; &gt; list unless CAP_SYS_ADMIN is given. Other seccomp.json lists=
 always<br>
&gt; &gt; &gt; include unshare (e.g. podman is unaffected):<br>
&gt; &gt; &gt;<br>
&gt; &gt; <a href=3D"https://raw.githubusercontent.com/seccomp/containers-g=
olang/master/seccomp.json" rel=3D"noreferrer" target=3D"_blank">https://raw=
.githubusercontent.com/seccomp/containers-golang/master/seccomp.json</a><br=
>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Use &quot;docker run --security-opt seccomp=3Dpath/to/seccom=
p.json ...&quot; if the<br>
&gt; &gt; &gt; default seccomp.json is missing unshare.<br>
&gt; &gt;<br>
&gt; &gt; Hi, sorry for a bit late.<br>
&gt; &gt;<br>
&gt; &gt; unshare() was added to fix xattr problem:<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"https://github.com/qemu/qemu/commit/bdfd66788349acc43c=
d3f1298718ad491663cfcc#" rel=3D"noreferrer" target=3D"_blank">https://githu=
b.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#</a><br>
&gt; &gt; In theory we don&#39;t need to call unshare if xattr is disabled,=
 but it is<br>
&gt; &gt; hard to get to know<br>
&gt; &gt; if xattr is enabled or disabled in fv_queue_worker(), right?<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; In kubevirt we want to run virtiofsd in containers. We would already n=
ot<br>
&gt; have xattr support for e.g. overlayfs in the VM after this patch serie=
s (an<br>
&gt; acceptable con at least for us right now).<br>
&gt; If we can get rid of the unshare (and potentially of needing root) tha=
t<br>
&gt; would be great. We always assume that everything which we run in conta=
iners<br>
&gt; should work for cri-o and docker.<br>
<br>
But cri-o and docker containers run as root, isn&#39;t it? (or atleast have=
<br>
the capability to run as root). Havind said that, it will be nice to be abl=
e<br>
to run virtiofsd without root. <br></blockquote><div><br></div><div>Yes the=
y can run as root. I can tell you what we plan to do with the containerized=
 virtiofsd: We run it as part of the user-owned pod (a set of containers).<=
br>One of our main goals at the moment is to run VMs in a user-owned pod wi=
thout additional privileges.</div><div>So that in case the user (VM-creator=
/owner) enters the pod or something breaks out of the VM they are just in t=
he unprivileged container sandbox.</div><div>As part of that we try to get =
also rid of running containers in the user-context with the root user.<br><=
br>One possible scenario which I could think of as being desirable from a k=
ubevirt perspective:=C2=A0</div><div>We would run the VM in one container a=
nd have an=C2=A0unprivileged virtiofsd=C2=A0container in parallel.<br>This =
container already has its own mount namespace and it is not that critical i=
f something manages to enter this sandbox.<br><br>But we are not as far yet=
 as getting completely rid of root right now in kubevirt, so if as a tempor=
ary step it needs root, the current proposed changes would still be very us=
eful for us.<br><br>Best Regards,</div><div>Roman<br><br></div><blockquote =
class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px sol=
id rgb(204,204,204);padding-left:1ex">
There are few hurdles though.<br>
<br>
- For file creation, we switch uid/gid (seteuid/setegid) and that seems<br>
=C2=A0 to require root. If we were to run unpriviliged, probably all files<=
br>
=C2=A0 on host will have to be owned by unpriviliged user and guest visible=
<br>
=C2=A0 uid/gid will have to be stored in xattrs. I think virtfs supports<br=
>
=C2=A0 something similar.=C2=A0</blockquote><blockquote class=3D"gmail_quot=
e" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204)=
;padding-left:1ex">
<br>
I am sure there are other restrictions but this probably is the biggest<br>
one to overcome.<br>
<br>
=C2=A0&gt; <br>
&gt; &quot;Just&quot; pointing docker to a different seccomp.json file is s=
omething which<br>
&gt; k8s users/admin in many cases can&#39;t do.<br>
<br>
Or may be issue is that standard seccomp.json does not allow unshare()<br>
and hence you are forced to use a non-standar seccomp.json.<br>
<br>
Vivek<br>
<br>
&gt; <br>
&gt; Best Regards,<br>
&gt; Roman<br>
&gt; <br>
&gt; <br>
&gt; &gt; So, it looks good to me.<br>
&gt; &gt; Reviewed-by: Misono Tomohiro &lt;<a href=3D"mailto:misono.tomohir=
o@jp.fujitsu.com" target=3D"_blank">misono.tomohiro@jp.fujitsu.com</a>&gt;<=
br>
&gt; &gt;<br>
&gt; &gt; Regards,<br>
&gt; &gt; Misono<br>
&gt; &gt;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; Cc: Misono Tomohiro &lt;<a href=3D"mailto:misono.tomohiro@jp=
.fujitsu.com" target=3D"_blank">misono.tomohiro@jp.fujitsu.com</a>&gt;<br>
&gt; &gt; &gt; Signed-off-by: Stefan Hajnoczi &lt;<a href=3D"mailto:stefanh=
a@redhat.com" target=3D"_blank">stefanha@redhat.com</a>&gt;<br>
&gt; &gt; &gt; ---<br>
&gt; &gt; &gt;=C2=A0 tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++<br=
>
&gt; &gt; &gt;=C2=A0 1 file changed, 16 insertions(+)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; diff --git a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; index 3b6d16a041..9e5537506c 100644<br>
&gt; &gt; &gt; --- a/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; +++ b/tools/virtiofsd/fuse_virtio.c<br>
&gt; &gt; &gt; @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_se=
ssion *se)<br>
&gt; &gt; &gt;=C2=A0 {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 int ret;<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 /*<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0* Test that unshare(CLONE_FS) works. fv=
_queue_worker() will need<br>
&gt; &gt; it. It&#39;s<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0* an unprivileged system call but some =
Docker/Moby versions are<br>
&gt; &gt; known to<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0* reject it via seccomp when CAP_SYS_AD=
MIN is not given.<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0*<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0* Note that the program is single-threa=
ded here so this syscall<br>
&gt; &gt; has no<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0* visible effect and is safe to make.<b=
r>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0*/<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 ret =3D unshare(CLONE_FS);<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 if (ret =3D=3D -1 &amp;&amp; errno =3D=3D EPE=
RM) {<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;un=
share(CLONE_FS) failed with EPERM. If<br>
&gt; &gt; &quot;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &qu=
ot;running in a container please check that the container<br>
&gt; &gt; &quot;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &qu=
ot;runtime seccomp policy allows unshare.\n&quot;);<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
&gt; &gt; &gt; +=C2=A0 =C2=A0 }<br>
&gt; &gt; &gt; +<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 ret =3D fv_create_listen_socket(se);<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 if (ret &lt; 0) {<br>
&gt; &gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
&gt; &gt; &gt; --<br>
&gt; &gt; &gt; 2.26.2<br>
&gt; &gt;<br>
&gt; &gt;<br>
<br>
</blockquote></div></div>

--00000000000078858c05ab8fee64--

