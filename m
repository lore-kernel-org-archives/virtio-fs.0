DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=szeredi.hu; s=google;
	h=mime-version:references:in-reply-to:from:date:message-id:subject:to
	:cc; bh=w1zk3N4S860pTM4e2x55L1XSkgMh5qjRuOy7Ag9dnp4=;
	b=TxG3S7Bq+549oubMaUPCzkx+vhPgamb7YMVIX2FY/inTxBA/uzovmfK8E06LW/ENJu
	6fbQq7kkl4D3+UJHIoeQ43du0IVhP52fB8BW6GVtSqndqMCAXLgjbuItuWAhFMlswkJU
	CohJPCk5UcU6F0TnadAznMPyHqNOzlQplMYFU=
MIME-Version: 1.0
References: <20200921213216.GE13362@redhat.com>
In-Reply-To: <20200921213216.GE13362@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Sep 2020 14:03:18 +0200
Message-ID: <CAJfpegujM0ygoBT5uPf4zBUDiphDTwgu97NfqaEgaa8HoSnuRw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000005577cd05afe5c1f8"
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, qemu-devel@nongnu.org

--0000000000005577cd05afe5c1f8
Content-Type: text/plain; charset="UTF-8"

On Mon, Sep 21, 2020 at 11:32 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> glib offers thread pools and it seems to support "exclusive" and "shared"
> thread pools.
>
>
> https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new
>
> Currently we use "exlusive" thread pools but its performance seems to be
> poor. I tried using "shared" thread pools and performance seems much
> better. I posted performance results here.
>
> https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
>
> So lets switch to shared thread pools. We can think of making it optional
> once somebody can show in what cases exclusive thread pools offer better
> results. For now, my simple performance tests across the board see
> better results with shared thread pools.
>

Needs this as well:

--- qemu.orig/tools/virtiofsd/passthrough_seccomp.c 2020-09-16
20:21:13.168686176 +0200
+++ qemu/tools/virtiofsd/passthrough_seccomp.c 2020-09-22
14:01:38.499164501 +0200
@@ -94,6 +94,8 @@ static const int syscall_whitelist[] = {
     SCMP_SYS(rt_sigaction),
     SCMP_SYS(rt_sigprocmask),
     SCMP_SYS(rt_sigreturn),
+    SCMP_SYS(sched_getattr),
+    SCMP_SYS(sched_setattr),
     SCMP_SYS(sendmsg),
     SCMP_SYS(setresgid),
     SCMP_SYS(setresuid),

Thanks,
Miklos

--0000000000005577cd05afe5c1f8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-size:small"><br></div></div><br><div class=3D"gmail_quote"><div dir=3D"lt=
r" class=3D"gmail_attr">On Mon, Sep 21, 2020 at 11:32 PM Vivek Goyal &lt;<a=
 href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; wrote:<br></di=
v><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;borde=
r-left:1px solid rgb(204,204,204);padding-left:1ex">glib offers thread pool=
s and it seems to support &quot;exclusive&quot; and &quot;shared&quot;<br>
thread pools.<br>
<br>
<a href=3D"https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g=
-thread-pool-new" rel=3D"noreferrer" target=3D"_blank">https://developer.gn=
ome.org/glib/stable/glib-Thread-Pools.html#g-thread-pool-new</a><br>
<br>
Currently we use &quot;exlusive&quot; thread pools but its performance seem=
s to be<br>
poor. I tried using &quot;shared&quot; thread pools and performance seems m=
uch<br>
better. I posted performance results here.<br>
<br>
<a href=3D"https://www.redhat.com/archives/virtio-fs/2020-September/msg0008=
0.html" rel=3D"noreferrer" target=3D"_blank">https://www.redhat.com/archive=
s/virtio-fs/2020-September/msg00080.html</a><br>
<br>
So lets switch to shared thread pools. We can think of making it optional<b=
r>
once somebody can show in what cases exclusive thread pools offer better<br=
>
results. For now, my simple performance tests across the board see<br>
better results with shared thread pools.<br></blockquote><div><br></div><di=
v style=3D"font-size:small" class=3D"gmail_default">Needs this as well:</di=
v><div style=3D"font-size:small" class=3D"gmail_default"><br></div><div sty=
le=3D"font-size:small" class=3D"gmail_default">--- qemu.orig/tools/virtiofs=
d/passthrough_seccomp.c=092020-09-16 20:21:13.168686176 +0200<br>+++ qemu/t=
ools/virtiofsd/passthrough_seccomp.c=092020-09-22 14:01:38.499164501 +0200<=
br>@@ -94,6 +94,8 @@ static const int syscall_whitelist[] =3D {<br>=C2=A0 =
=C2=A0 =C2=A0SCMP_SYS(rt_sigaction),<br>=C2=A0 =C2=A0 =C2=A0SCMP_SYS(rt_sig=
procmask),<br>=C2=A0 =C2=A0 =C2=A0SCMP_SYS(rt_sigreturn),<br>+ =C2=A0 =C2=
=A0SCMP_SYS(sched_getattr),<br>+ =C2=A0 =C2=A0SCMP_SYS(sched_setattr),<br>=
=C2=A0 =C2=A0 =C2=A0SCMP_SYS(sendmsg),<br>=C2=A0 =C2=A0 =C2=A0SCMP_SYS(setr=
esgid),<br>=C2=A0 =C2=A0 =C2=A0SCMP_SYS(setresuid),<br></div></div><div cla=
ss=3D"gmail_quote"><div style=3D"font-size:small" class=3D"gmail_default"><=
br></div><div style=3D"font-size:small" class=3D"gmail_default">Thanks,</di=
v><div style=3D"font-size:small" class=3D"gmail_default">Miklos</div><br></=
div></div>

--0000000000005577cd05afe5c1f8--

