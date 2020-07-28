MIME-Version: 1.0
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
In-Reply-To: <OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
From: Roman Mohr <rmohr@redhat.com>
Date: Tue, 28 Jul 2020 12:00:20 +0200
Message-ID: <CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000006eab2505ab7d8245"
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
To: "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "mpatel@redhat.com" <mpatel@redhat.com>, "vgoyal@redhat.com" <vgoyal@redhat.com>

--0000000000006eab2505ab7d8245
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
misono.tomohiro@fujitsu.com> wrote:

> > Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print an
> error
> >
> > An assertion failure is raised during request processing if
> > unshare(CLONE_FS) fails. Implement a probe at startup so the problem can
> > be detected right away.
> >
> > Unfortunately Docker/Moby does not include unshare in the seccomp.json
> > list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always
> > include unshare (e.g. podman is unaffected):
> >
> https://raw.githubusercontent.com/seccomp/containers-golang/master/seccomp.json
> >
> > Use "docker run --security-opt seccomp=path/to/seccomp.json ..." if the
> > default seccomp.json is missing unshare.
>
> Hi, sorry for a bit late.
>
> unshare() was added to fix xattr problem:
>
> https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#
> In theory we don't need to call unshare if xattr is disabled, but it is
> hard to get to know
> if xattr is enabled or disabled in fv_queue_worker(), right?
>
>
In kubevirt we want to run virtiofsd in containers. We would already not
have xattr support for e.g. overlayfs in the VM after this patch series (an
acceptable con at least for us right now).
If we can get rid of the unshare (and potentially of needing root) that
would be great. We always assume that everything which we run in containers
should work for cri-o and docker.

"Just" pointing docker to a different seccomp.json file is something which
k8s users/admin in many cases can't do.

Best Regards,
Roman


> So, it looks good to me.
> Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
>
> Regards,
> Misono
>
> >
> > Cc: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/tools/virtiofsd/fuse_virtio.c
> b/tools/virtiofsd/fuse_virtio.c
> > index 3b6d16a041..9e5537506c 100644
> > --- a/tools/virtiofsd/fuse_virtio.c
> > +++ b/tools/virtiofsd/fuse_virtio.c
> > @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_session *se)
> >  {
> >      int ret;
> >
> > +    /*
> > +     * Test that unshare(CLONE_FS) works. fv_queue_worker() will need
> it. It's
> > +     * an unprivileged system call but some Docker/Moby versions are
> known to
> > +     * reject it via seccomp when CAP_SYS_ADMIN is not given.
> > +     *
> > +     * Note that the program is single-threaded here so this syscall
> has no
> > +     * visible effect and is safe to make.
> > +     */
> > +    ret = unshare(CLONE_FS);
> > +    if (ret == -1 && errno == EPERM) {
> > +        fuse_log(FUSE_LOG_ERR, "unshare(CLONE_FS) failed with EPERM. If
> "
> > +                "running in a container please check that the container
> "
> > +                "runtime seccomp policy allows unshare.\n");
> > +        return -1;
> > +    }
> > +
> >      ret = fv_create_listen_socket(se);
> >      if (ret < 0) {
> >          return ret;
> > --
> > 2.26.2
>
>

--0000000000006eab2505ab7d8245
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Jul 28, 2020 at 3:07 AM <a hr=
ef=3D"mailto:misono.tomohiro@fujitsu.com">misono.tomohiro@fujitsu.com</a> &=
lt;<a href=3D"mailto:misono.tomohiro@fujitsu.com">misono.tomohiro@fujitsu.c=
om</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
">&gt; Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and print=
 an error<br>
&gt; <br>
&gt; An assertion failure is raised during request processing if<br>
&gt; unshare(CLONE_FS) fails. Implement a probe at startup so the problem c=
an<br>
&gt; be detected right away.<br>
&gt; <br>
&gt; Unfortunately Docker/Moby does not include unshare in the seccomp.json=
<br>
&gt; list unless CAP_SYS_ADMIN is given. Other seccomp.json lists always<br=
>
&gt; include unshare (e.g. podman is unaffected):<br>
&gt; <a href=3D"https://raw.githubusercontent.com/seccomp/containers-golang=
/master/seccomp.json" rel=3D"noreferrer" target=3D"_blank">https://raw.gith=
ubusercontent.com/seccomp/containers-golang/master/seccomp.json</a><br>
&gt; <br>
&gt; Use &quot;docker run --security-opt seccomp=3Dpath/to/seccomp.json ...=
&quot; if the<br>
&gt; default seccomp.json is missing unshare.<br>
<br>
Hi, sorry for a bit late.<br>
<br>
unshare() was added to fix xattr problem: <br>
=C2=A0 <a href=3D"https://github.com/qemu/qemu/commit/bdfd66788349acc43cd3f=
1298718ad491663cfcc#" rel=3D"noreferrer" target=3D"_blank">https://github.c=
om/qemu/qemu/commit/bdfd66788349acc43cd3f1298718ad491663cfcc#</a><br>
In theory we don&#39;t need to call unshare if xattr is disabled, but it is=
 hard to get to know<br>
if xattr is enabled or disabled in fv_queue_worker(), right?<br>
<br></blockquote><div><br>In kubevirt we want to run virtiofsd in container=
s. We would already not have xattr support for e.g. overlayfs in the VM aft=
er this patch series (an acceptable con at least for us right now).<br>If w=
e can get rid of the unshare (and potentially of needing root) that would b=
e great. We always assume that everything which we run in containers should=
 work for cri-o and docker.<br><br></div><div>&quot;Just&quot; pointing doc=
ker to a different seccomp.json file is something which k8s users/admin in =
many cases can&#39;t do.</div><div><br></div><div>Best Regards,<br>Roman<br=
>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px =
0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
So, it looks good to me.<br>
Reviewed-by: Misono Tomohiro &lt;<a href=3D"mailto:misono.tomohiro@jp.fujit=
su.com" target=3D"_blank">misono.tomohiro@jp.fujitsu.com</a>&gt;<br>
<br>
Regards,<br>
Misono<br>
<br>
&gt; <br>
&gt; Cc: Misono Tomohiro &lt;<a href=3D"mailto:misono.tomohiro@jp.fujitsu.c=
om" target=3D"_blank">misono.tomohiro@jp.fujitsu.com</a>&gt;<br>
&gt; Signed-off-by: Stefan Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.c=
om" target=3D"_blank">stefanha@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 tools/virtiofsd/fuse_virtio.c | 16 ++++++++++++++++<br>
&gt;=C2=A0 1 file changed, 16 insertions(+)<br>
&gt; <br>
&gt; diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virt=
io.c<br>
&gt; index 3b6d16a041..9e5537506c 100644<br>
&gt; --- a/tools/virtiofsd/fuse_virtio.c<br>
&gt; +++ b/tools/virtiofsd/fuse_virtio.c<br>
&gt; @@ -949,6 +949,22 @@ int virtio_session_mount(struct fuse_session *se)=
<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 int ret;<br>
&gt; <br>
&gt; +=C2=A0 =C2=A0 /*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0* Test that unshare(CLONE_FS) works. fv_queue_wor=
ker() will need it. It&#39;s<br>
&gt; +=C2=A0 =C2=A0 =C2=A0* an unprivileged system call but some Docker/Mob=
y versions are known to<br>
&gt; +=C2=A0 =C2=A0 =C2=A0* reject it via seccomp when CAP_SYS_ADMIN is not=
 given.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0* Note that the program is single-threaded here s=
o this syscall has no<br>
&gt; +=C2=A0 =C2=A0 =C2=A0* visible effect and is safe to make.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0*/<br>
&gt; +=C2=A0 =C2=A0 ret =3D unshare(CLONE_FS);<br>
&gt; +=C2=A0 =C2=A0 if (ret =3D=3D -1 &amp;&amp; errno =3D=3D EPERM) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 fuse_log(FUSE_LOG_ERR, &quot;unshare(CLON=
E_FS) failed with EPERM. If &quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;running=
 in a container please check that the container &quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;runtime=
 seccomp policy allows unshare.\n&quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return -1;<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 ret =3D fv_create_listen_socket(se);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 if (ret &lt; 0) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;<br>
&gt; --<br>
&gt; 2.26.2<br>
<br>
</blockquote></div></div>

--0000000000006eab2505ab7d8245--

