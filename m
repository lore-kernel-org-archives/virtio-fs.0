MIME-Version: 1.0
References: <20200727190223.422280-1-stefanha@redhat.com>
	<20200727190223.422280-4-stefanha@redhat.com>
	<OSBPR01MB45826073E5A54CF869E56721E5730@OSBPR01MB4582.jpnprd01.prod.outlook.com>
	<CALDPj7syG0KPhtZEma5n403=YFZ2ptcD4MtP=GdrY9n1eUs5Eg@mail.gmail.com>
	<20200728131250.GB78409@redhat.com>
	<CALDPj7uvquu=YWX_Ve7ROdj=LZWjkgPOm+wvEAynGvjeF4Xivg@mail.gmail.com>
	<20200729144027.GF52286@stefanha-x1.localdomain>
	<ad75a25c-0343-5c57-1933-e3c88f76df1c@redhat.com>
	<20200731082638.GA173083@stefanha-x1.localdomain>
In-Reply-To: <20200731082638.GA173083@stefanha-x1.localdomain>
From: Roman Mohr <rmohr@redhat.com>
Date: Fri, 31 Jul 2020 10:39:37 +0200
Message-ID: <CALDPj7s-UjrvgD4-mhEwisetz7PtAO-RCmKvH+=1UTM8K8oLPw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000005880c605abb8bb38"
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "vromanso@redhat.com" <vromanso@redhat.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "mpatel@redhat.com" <mpatel@redhat.com>, Vivek Goyal <vgoyal@redhat.com>

--0000000000005880c605abb8bb38
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 31, 2020 at 10:26 AM Stefan Hajnoczi <stefanha@redhat.com>
wrote:

> On Thu, Jul 30, 2020 at 06:21:34PM -0400, Daniel Walsh wrote:
> > On 7/29/20 10:40, Stefan Hajnoczi wrote:
> > > On Wed, Jul 29, 2020 at 09:59:01AM +0200, Roman Mohr wrote:
> > >> On Tue, Jul 28, 2020 at 3:13 PM Vivek Goyal <vgoyal@redhat.com>
> wrote:
> > >>
> > >>> On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrote:
> > >>>> On Tue, Jul 28, 2020 at 3:07 AM misono.tomohiro@fujitsu.com <
> > >>>> misono.tomohiro@fujitsu.com> wrote:
> > >>>>
> > >>>>>> Subject: [PATCH v2 3/3] virtiofsd: probe unshare(CLONE_FS) and
> print
> > >>> an
> > >>>>> error
> > >> Yes they can run as root. I can tell you what we plan to do with the
> > >> containerized virtiofsd: We run it as part of the user-owned pod (a
> set of
> > >> containers).
> > >> One of our main goals at the moment is to run VMs in a user-owned pod
> > >> without additional privileges.
> > >> So that in case the user (VM-creator/owner) enters the pod or
> something
> > >> breaks out of the VM they are just in the unprivileged container
> sandbox.
> > >> As part of that we try to get also rid of running containers in the
> > >> user-context with the root user.
> > >>
> > >> One possible scenario which I could think of as being desirable from a
> > >> kubevirt perspective:
> > >> We would run the VM in one container and have an unprivileged
> > >> virtiofsd container in parallel.
> > >> This container already has its own mount namespace and it is not that
> > >> critical if something manages to enter this sandbox.
> > >>
> > >> But we are not as far yet as getting completely rid of root right now
> in
> > >> kubevirt, so if as a temporary step it needs root, the current
> proposed
> > >> changes would still be very useful for us.
> > > What is the issue with root in user namespaces?
> > >
> > > I remember a few years ago it was seen as a major security issue but
> > > don't remember if container runtimes were already using user namespaces
> > > back then.
> > >
> > > I guess the goal might be simply to minimize Linux capabilities as much
> > > as possible?
> > >
> > > virtiofsd could nominally run with an arbitrary uid/gid but it still
> > > needs the Linux capabilities that allow it to change uid/gid and
> > > override file system permission checks just like the root user. Not
> sure
> > > if there is any advantage to running with uid 1000 when you still have
> > > these Linux capabilities.
> > >
> > > Stefan
> >
> > When you run in a user namespace, virtiofsd would only have
> > setuid/setgid over the range of UIDs mapped into the user namespace.  So
> > if UID=0 on the host is not mapped, then the container can not create
> > real UID=0 files on disk.
> >
> > Similarly you can protect the user directories and any content by
> > running the containers in a really high UID Mapping.
>
> Roman, do user namespaces address your concerns about uid 0 in
> containers?
>

They may eventually solve it. I would not let us hang up on this right now,
since as said at least in kubevirt we can't get rid right now of root
anyway.
Even if it is at some point in the future save and supported on
bleeding-edge managed k8s clusters to allow ordinary users to run with uid
0, from my perspective it is right now common to restrict namespaces with
PodSecurityPolicies or SecurityContexts to not allow running pods as root
for normal users.
It is also common that a significant part of the community users run docker
and/or run on managed k8s clusters where they can not influence if
user-namespaces are enabled, if they can run pods as root, if the runtime
points to a seccomp file they like or if the runtime they prefer is used.

But let me repeat again that we require root right now anyway and that we
don't run the pods right now with the user privileges (but we should and we
aim for that). Right now PSPs and SCCs restrict access to these pods by the
users.
So for our use case, at this exact moment root is acceptable, the unshare
call is a little bit more problematic.

Best Regards,
Roman



>
> Stefan
>

--0000000000005880c605abb8bb38
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Fri, Jul 31, 2020 at 10:26 AM Stef=
an Hajnoczi &lt;<a href=3D"mailto:stefanha@redhat.com">stefanha@redhat.com<=
/a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0=
px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">O=
n Thu, Jul 30, 2020 at 06:21:34PM -0400, Daniel Walsh wrote:<br>
&gt; On 7/29/20 10:40, Stefan Hajnoczi wrote:<br>
&gt; &gt; On Wed, Jul 29, 2020 at 09:59:01AM +0200, Roman Mohr wrote:<br>
&gt; &gt;&gt; On Tue, Jul 28, 2020 at 3:13 PM Vivek Goyal &lt;<a href=3D"ma=
ilto:vgoyal@redhat.com" target=3D"_blank">vgoyal@redhat.com</a>&gt; wrote:<=
br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt;&gt; On Tue, Jul 28, 2020 at 12:00:20PM +0200, Roman Mohr wrot=
e:<br>
&gt; &gt;&gt;&gt;&gt; On Tue, Jul 28, 2020 at 3:07 AM <a href=3D"mailto:mis=
ono.tomohiro@fujitsu.com" target=3D"_blank">misono.tomohiro@fujitsu.com</a>=
 &lt;<br>
&gt; &gt;&gt;&gt;&gt; <a href=3D"mailto:misono.tomohiro@fujitsu.com" target=
=3D"_blank">misono.tomohiro@fujitsu.com</a>&gt; wrote:<br>
&gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt;&gt;&gt;&gt;&gt;&gt; Subject: [PATCH v2 3/3] virtiofsd: probe unsh=
are(CLONE_FS) and print<br>
&gt; &gt;&gt;&gt; an<br>
&gt; &gt;&gt;&gt;&gt;&gt; error<br>
&gt; &gt;&gt; Yes they can run as root. I can tell you what we plan to do w=
ith the<br>
&gt; &gt;&gt; containerized virtiofsd: We run it as part of the user-owned =
pod (a set of<br>
&gt; &gt;&gt; containers).<br>
&gt; &gt;&gt; One of our main goals at the moment is to run VMs in a user-o=
wned pod<br>
&gt; &gt;&gt; without additional privileges.<br>
&gt; &gt;&gt; So that in case the user (VM-creator/owner) enters the pod or=
 something<br>
&gt; &gt;&gt; breaks out of the VM they are just in the unprivileged contai=
ner sandbox.<br>
&gt; &gt;&gt; As part of that we try to get also rid of running containers =
in the<br>
&gt; &gt;&gt; user-context with the root user.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; One possible scenario which I could think of as being desirab=
le from a<br>
&gt; &gt;&gt; kubevirt perspective:<br>
&gt; &gt;&gt; We would run the VM in one container and have an unprivileged=
<br>
&gt; &gt;&gt; virtiofsd container in parallel.<br>
&gt; &gt;&gt; This container already has its own mount namespace and it is =
not that<br>
&gt; &gt;&gt; critical if something manages to enter this sandbox.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; But we are not as far yet as getting completely rid of root r=
ight now in<br>
&gt; &gt;&gt; kubevirt, so if as a temporary step it needs root, the curren=
t proposed<br>
&gt; &gt;&gt; changes would still be very useful for us.<br>
&gt; &gt; What is the issue with root in user namespaces?<br>
&gt; &gt;<br>
&gt; &gt; I remember a few years ago it was seen as a major security issue =
but<br>
&gt; &gt; don&#39;t remember if container runtimes were already using user =
namespaces<br>
&gt; &gt; back then.<br>
&gt; &gt;<br>
&gt; &gt; I guess the goal might be simply to minimize Linux capabilities a=
s much<br>
&gt; &gt; as possible?<br>
&gt; &gt;<br>
&gt; &gt; virtiofsd could nominally run with an arbitrary uid/gid but it st=
ill<br>
&gt; &gt; needs the Linux capabilities that allow it to change uid/gid and<=
br>
&gt; &gt; override file system permission checks just like the root user. N=
ot sure<br>
&gt; &gt; if there is any advantage to running with uid 1000 when you still=
 have<br>
&gt; &gt; these Linux capabilities.<br>
&gt; &gt;<br>
&gt; &gt; Stefan<br>
&gt; <br>
&gt; When you run in a user namespace, virtiofsd would only have<br>
&gt; setuid/setgid over the range of UIDs mapped into the user namespace.=
=C2=A0 So<br>
&gt; if UID=3D0 on the host is not mapped, then the container can not creat=
e<br>
&gt; real UID=3D0 files on disk.<br>
&gt; <br>
&gt; Similarly you can protect the user directories and any content by<br>
&gt; running the containers in a really high UID Mapping.<br>
<br>
Roman, do user namespaces address your concerns about uid 0 in<br>
containers?<br></blockquote><div><br>They may eventually solve it. I would =
not let us hang up on this right now, since as said at least in kubevirt we=
 can&#39;t get rid right now of root anyway.<br>Even if it is at some point=
 in the future save and supported on bleeding-edge managed k8s clusters to =
allow ordinary users to run with uid 0, from my perspective it is right now=
 common to restrict namespaces with PodSecurityPolicies or SecurityContexts=
 to not allow running pods as root for normal users.</div><div>It is also c=
ommon that a significant part of the community users run docker and/or run =
on managed k8s clusters where they can not influence if user-namespaces are=
 enabled, if they can run pods as root, if the runtime points to a seccomp =
file they like or if the runtime they prefer is used.<br><br>But let me rep=
eat again that we require root right now anyway and that we don&#39;t run t=
he pods right now with the user privileges (but we should and we aim for th=
at). Right now PSPs and SCCs restrict access to these pods by the users.</d=
iv><div>So for our use case, at this exact moment root is acceptable, the u=
nshare call is a little bit more problematic.<br></div><div><br>Best Regard=
s,</div><div>Roman</div><div><br>=C2=A0</div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204=
);padding-left:1ex">
<br>
Stefan<br>
</blockquote></div></div>

--0000000000005880c605abb8bb38--

