Return-Path: <marcandre.lureau@gmail.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=PX+abyLRgex0ZCup+U2IHWin43JleGLa7AfCaKpwdYo=;
 b=XVBQZZHku1X19otb56BveeA5ffLLXAC2/bAZrRCNGTFH35aqvVRvbVuJLiF+PnmXuj
 Fy0+WeJJ7QIYc7r0kD9lGclh6/crPoc5HuSlwU8VoKMVgvKqVYyuWfmbOgo7TTwAb0cJ
 WaGI6+m83huIEUDkj7D7Xj/HeVeFRboJI0hlDs4Fy3wWa6qBTdGkQ42fEu9hbBHgeuqP
 6d8PntK/2j1FnAMnC/fdw26GqPBmDdd2cb2FER4iIo18c5/AEHx1eb47ysUB0BNvJ45r
 MOnnXcPAk/5OAwB/t53B/0y32a0KS1MwkC4rgMvokW+M2EYubQkX6NuE1fRAUV9fOm7+
 7O4A==
MIME-Version: 1.0
References: <20220420132624.2439741-1-marcandre.lureau@redhat.com>
 <20220420132624.2439741-7-marcandre.lureau@redhat.com>
 <YmAg+9GExN7wn6Yb@redhat.com>
In-Reply-To: <YmAg+9GExN7wn6Yb@redhat.com>
From: =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@gmail.com>
Date: Wed, 20 Apr 2022 19:21:33 +0400
Message-ID: <CAJ+F1C+vr+gfm0b+GjrLKKbRhMUDtq2R6o+3fK2JNMy_za5HSw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000001a8f5b05dd178d99"
Subject: Re: [Virtio-fs] [PATCH 06/41] include: rename qemu-common.h
 qemu/copyright.h
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Peter Maydell <peter.maydell@linaro.org>
Cc: Kevin Wolf <kwolf@redhat.com>, Fam Zheng <fam@euphon.net>, Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>, Stefan Hajnoczi <stefanha@redhat.com>, "open list:Block layer core" <qemu-block@nongnu.org>, Kyle Evans <kevans@freebsd.org>, QEMU <qemu-devel@nongnu.org>, Laurent Vivier <laurent@vivier.eu>, "open list:virtiofs" <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Akihiko Odaki <akihiko.odaki@gmail.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>, Warner Losh <imp@bsdimp.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>

--0000000000001a8f5b05dd178d99
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Wed, Apr 20, 2022 at 7:17 PM Daniel P. Berrang=C3=A9 <berrange@redhat.co=
m>
wrote:

> On Wed, Apr 20, 2022 at 05:25:49PM +0400, marcandre.lureau@redhat.com
> wrote:
> > From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>
> Could use a commit message explaining why this is a good
> idea.
>
> I see it contains QEMU_COPYRIGHT macro, but it also then
> contains QEMU_HELP_BOTTOM which is about bug reporting
> not copyright.
>
> IMHO something like 'qemu-cli.h' could be a better match
>

That was Peter's suggestion:
https://patchew.org/QEMU/20220323155743.1585078-1-marcandre.lureau@redhat.c=
om/20220323155743.1585078-33-marcandre.lureau@redhat.com/#CAFEAcA9kYweS2zMH=
jWDuV_y2AxKbgJ5UYNHLK3sASCLVD=3DyEqg@mail.gmail.com

I don't mind qemu-cli.h or elsewhere

Peter?


> >
> > Suggested-by: Peter Maydell <peter.maydell@linaro.org>
> > Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
> > ---
> >  include/{qemu-common.h =3D> qemu/copyright.h} | 0
> >  bsd-user/main.c                             | 2 +-
> >  linux-user/main.c                           | 2 +-
> >  qemu-img.c                                  | 2 +-
> >  qemu-io.c                                   | 2 +-
> >  qemu-nbd.c                                  | 2 +-
> >  qga/main.c                                  | 2 +-
> >  scsi/qemu-pr-helper.c                       | 2 +-
> >  softmmu/vl.c                                | 2 +-
> >  storage-daemon/qemu-storage-daemon.c        | 2 +-
> >  tools/virtiofsd/passthrough_ll.c            | 2 +-
> >  ui/cocoa.m                                  | 2 +-
> >  12 files changed, 11 insertions(+), 11 deletions(-)
> >  rename include/{qemu-common.h =3D> qemu/copyright.h} (100%)
> >
> > diff --git a/include/qemu-common.h b/include/qemu/copyright.h
> > similarity index 100%
> > rename from include/qemu-common.h
> > rename to include/qemu/copyright.h
> > diff --git a/bsd-user/main.c b/bsd-user/main.c
> > index 88d347d05ebf..aaab3f278534 100644
> > --- a/bsd-user/main.c
> > +++ b/bsd-user/main.c
> > @@ -24,7 +24,7 @@
> >  #include <sys/sysctl.h>
> >
> >  #include "qemu/osdep.h"
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu/units.h"
> >  #include "qemu/accel.h"
> >  #include "sysemu/tcg.h"
> > diff --git a/linux-user/main.c b/linux-user/main.c
> > index fbc9bcfd5f5f..744d216b1e8e 100644
> > --- a/linux-user/main.c
> > +++ b/linux-user/main.c
> > @@ -18,7 +18,7 @@
> >   */
> >
> >  #include "qemu/osdep.h"
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu/units.h"
> >  #include "qemu/accel.h"
> >  #include "sysemu/tcg.h"
> > diff --git a/qemu-img.c b/qemu-img.c
> > index 116e05867558..a2b1d3653a1e 100644
> > --- a/qemu-img.c
> > +++ b/qemu-img.c
> > @@ -25,7 +25,7 @@
> >  #include "qemu/osdep.h"
> >  #include <getopt.h>
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu/qemu-progress.h"
> >  #include "qemu-version.h"
> >  #include "qapi/error.h"
> > diff --git a/qemu-io.c b/qemu-io.c
> > index eb8afc8b413b..952a36643b0c 100644
> > --- a/qemu-io.c
> > +++ b/qemu-io.c
> > @@ -15,7 +15,7 @@
> >  #include <termios.h>
> >  #endif
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qapi/error.h"
> >  #include "qemu-io.h"
> >  #include "qemu/error-report.h"
> > diff --git a/qemu-nbd.c b/qemu-nbd.c
> > index 713e7557a9eb..f4d121c0c40e 100644
> > --- a/qemu-nbd.c
> > +++ b/qemu-nbd.c
> > @@ -21,7 +21,7 @@
> >  #include <libgen.h>
> >  #include <pthread.h>
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qapi/error.h"
> >  #include "qemu/cutils.h"
> >  #include "sysemu/block-backend.h"
> > diff --git a/qga/main.c b/qga/main.c
> > index ac63d8e47802..8994f73e4735 100644
> > --- a/qga/main.c
> > +++ b/qga/main.c
> > @@ -18,7 +18,7 @@
> >  #include <syslog.h>
> >  #include <sys/wait.h>
> >  #endif
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qapi/qmp/json-parser.h"
> >  #include "qapi/qmp/qdict.h"
> >  #include "qapi/qmp/qjson.h"
> > diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c
> > index f281daeced8d..e7549ffb3bc9 100644
> > --- a/scsi/qemu-pr-helper.c
> > +++ b/scsi/qemu-pr-helper.c
> > @@ -36,7 +36,7 @@
> >  #include <mpath_persist.h>
> >  #endif
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qapi/error.h"
> >  #include "qemu/cutils.h"
> >  #include "qemu/main-loop.h"
> > diff --git a/softmmu/vl.c b/softmmu/vl.c
> > index 46aba6a039c4..b0bf16e16aaa 100644
> > --- a/softmmu/vl.c
> > +++ b/softmmu/vl.c
> > @@ -23,7 +23,7 @@
> >   */
> >
> >  #include "qemu/osdep.h"
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu/datadir.h"
> >  #include "qemu/units.h"
> >  #include "exec/cpu-common.h"
> > diff --git a/storage-daemon/qemu-storage-daemon.c
> b/storage-daemon/qemu-storage-daemon.c
> > index eb724072579a..a4415e8c995b 100644
> > --- a/storage-daemon/qemu-storage-daemon.c
> > +++ b/storage-daemon/qemu-storage-daemon.c
> > @@ -42,7 +42,7 @@
> >  #include "qapi/qmp/qstring.h"
> >  #include "qapi/qobject-input-visitor.h"
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu-version.h"
> >  #include "qemu/config-file.h"
> >  #include "qemu/error-report.h"
> > diff --git a/tools/virtiofsd/passthrough_ll.c
> b/tools/virtiofsd/passthrough_ll.c
> > index 028dacdd8f5a..8af28f5fb823 100644
> > --- a/tools/virtiofsd/passthrough_ll.c
> > +++ b/tools/virtiofsd/passthrough_ll.c
> > @@ -38,7 +38,7 @@
> >  #include "qemu/osdep.h"
> >  #include "qemu/timer.h"
> >  #include "qemu-version.h"
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "fuse_virtio.h"
> >  #include "fuse_log.h"
> >  #include "fuse_lowlevel.h"
> > diff --git a/ui/cocoa.m b/ui/cocoa.m
> > index 839ae4f58a69..a2a74656fabf 100644
> > --- a/ui/cocoa.m
> > +++ b/ui/cocoa.m
> > @@ -27,7 +27,7 @@
> >  #import <Cocoa/Cocoa.h>
> >  #include <crt_externs.h>
> >
> > -#include "qemu-common.h"
> > +#include "qemu/copyright.h"
> >  #include "qemu-main.h"
> >  #include "ui/clipboard.h"
> >  #include "ui/console.h"
> > --
> > 2.35.1.693.g805e0a68082a
> >
> >
>
> With regards,
> Daniel
> --
> |: https://berrange.com      -o-
> https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-
> https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-
> https://www.instagram.com/dberrange :|
>
>
>

--=20
Marc-Andr=C3=A9 Lureau

--0000000000001a8f5b05dd178d99
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi<br></div><br><div class=3D"gmail_quote=
"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Apr 20, 2022 at 7:17 PM Dan=
iel P. Berrang=C3=A9 &lt;<a href=3D"mailto:berrange@redhat.com">berrange@re=
dhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-le=
ft:1ex">On Wed, Apr 20, 2022 at 05:25:49PM +0400, <a href=3D"mailto:marcand=
re.lureau@redhat.com" target=3D"_blank">marcandre.lureau@redhat.com</a> wro=
te:<br>
&gt; From: Marc-Andr=C3=A9 Lureau &lt;<a href=3D"mailto:marcandre.lureau@re=
dhat.com" target=3D"_blank">marcandre.lureau@redhat.com</a>&gt;<br>
<br>
Could use a commit message explaining why this is a good<br>
idea.<br>
<br>
I see it contains QEMU_COPYRIGHT macro, but it also then<br>
contains QEMU_HELP_BOTTOM which is about bug reporting<br>
not copyright.<br>
<br>
IMHO something like &#39;qemu-cli.h&#39; could be a better match<br></block=
quote><div><br></div><div>That was Peter&#39;s suggestion:<br></div><div><a=
 href=3D"https://patchew.org/QEMU/20220323155743.1585078-1-marcandre.lureau=
@redhat.com/20220323155743.1585078-33-marcandre.lureau@redhat.com/#CAFEAcA9=
kYweS2zMHjWDuV_y2AxKbgJ5UYNHLK3sASCLVD=3DyEqg@mail.gmail.com">https://patch=
ew.org/QEMU/20220323155743.1585078-1-marcandre.lureau@redhat.com/2022032315=
5743.1585078-33-marcandre.lureau@redhat.com/#CAFEAcA9kYweS2zMHjWDuV_y2AxKbg=
J5UYNHLK3sASCLVD=3DyEqg@mail.gmail.com</a></div><div><br></div><div>I don&#=
39;t mind qemu-cli.h or elsewhere<br></div><div><br></div><div>Peter?<br></=
div><div> <br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0=
px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt; <br>
&gt; Suggested-by: Peter Maydell &lt;<a href=3D"mailto:peter.maydell@linaro=
.org" target=3D"_blank">peter.maydell@linaro.org</a>&gt;<br>
&gt; Signed-off-by: Marc-Andr=C3=A9 Lureau &lt;<a href=3D"mailto:marcandre.=
lureau@redhat.com" target=3D"_blank">marcandre.lureau@redhat.com</a>&gt;<br=
>
&gt; ---<br>
&gt;=C2=A0 include/{qemu-common.h =3D&gt; qemu/copyright.h} | 0<br>
&gt;=C2=A0 bsd-user/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
&gt;=C2=A0 linux-user/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
&gt;=C2=A0 qemu-img.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<b=
r>
&gt;=C2=A0 qemu-io.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +=
-<br>
&gt;=C2=A0 qemu-nbd.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<b=
r>
&gt;=C2=A0 qga/main.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<b=
r>
&gt;=C2=A0 scsi/qemu-pr-helper.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 2 +-<br>
&gt;=C2=A0 softmmu/vl.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<br>
&gt;=C2=A0 storage-daemon/qemu-storage-daemon.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
| 2 +-<br>
&gt;=C2=A0 tools/virtiofsd/passthrough_ll.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 | 2 +-<br>
&gt;=C2=A0 ui/cocoa.m=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 2 +-<b=
r>
&gt;=C2=A0 12 files changed, 11 insertions(+), 11 deletions(-)<br>
&gt;=C2=A0 rename include/{qemu-common.h =3D&gt; qemu/copyright.h} (100%)<b=
r>
&gt; <br>
&gt; diff --git a/include/qemu-common.h b/include/qemu/copyright.h<br>
&gt; similarity index 100%<br>
&gt; rename from include/qemu-common.h<br>
&gt; rename to include/qemu/copyright.h<br>
&gt; diff --git a/bsd-user/main.c b/bsd-user/main.c<br>
&gt; index 88d347d05ebf..aaab3f278534 100644<br>
&gt; --- a/bsd-user/main.c<br>
&gt; +++ b/bsd-user/main.c<br>
&gt; @@ -24,7 +24,7 @@<br>
&gt;=C2=A0 #include &lt;sys/sysctl.h&gt;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #include &quot;qemu/osdep.h&quot;<br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/units.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/accel.h&quot;<br>
&gt;=C2=A0 #include &quot;sysemu/tcg.h&quot;<br>
&gt; diff --git a/linux-user/main.c b/linux-user/main.c<br>
&gt; index fbc9bcfd5f5f..744d216b1e8e 100644<br>
&gt; --- a/linux-user/main.c<br>
&gt; +++ b/linux-user/main.c<br>
&gt; @@ -18,7 +18,7 @@<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #include &quot;qemu/osdep.h&quot;<br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/units.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/accel.h&quot;<br>
&gt;=C2=A0 #include &quot;sysemu/tcg.h&quot;<br>
&gt; diff --git a/qemu-img.c b/qemu-img.c<br>
&gt; index 116e05867558..a2b1d3653a1e 100644<br>
&gt; --- a/qemu-img.c<br>
&gt; +++ b/qemu-img.c<br>
&gt; @@ -25,7 +25,7 @@<br>
&gt;=C2=A0 #include &quot;qemu/osdep.h&quot;<br>
&gt;=C2=A0 #include &lt;getopt.h&gt;<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/qemu-progress.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu-version.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/error.h&quot;<br>
&gt; diff --git a/qemu-io.c b/qemu-io.c<br>
&gt; index eb8afc8b413b..952a36643b0c 100644<br>
&gt; --- a/qemu-io.c<br>
&gt; +++ b/qemu-io.c<br>
&gt; @@ -15,7 +15,7 @@<br>
&gt;=C2=A0 #include &lt;termios.h&gt;<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/error.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu-io.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/error-report.h&quot;<br>
&gt; diff --git a/qemu-nbd.c b/qemu-nbd.c<br>
&gt; index 713e7557a9eb..f4d121c0c40e 100644<br>
&gt; --- a/qemu-nbd.c<br>
&gt; +++ b/qemu-nbd.c<br>
&gt; @@ -21,7 +21,7 @@<br>
&gt;=C2=A0 #include &lt;libgen.h&gt;<br>
&gt;=C2=A0 #include &lt;pthread.h&gt;<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/error.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/cutils.h&quot;<br>
&gt;=C2=A0 #include &quot;sysemu/block-backend.h&quot;<br>
&gt; diff --git a/qga/main.c b/qga/main.c<br>
&gt; index ac63d8e47802..8994f73e4735 100644<br>
&gt; --- a/qga/main.c<br>
&gt; +++ b/qga/main.c<br>
&gt; @@ -18,7 +18,7 @@<br>
&gt;=C2=A0 #include &lt;syslog.h&gt;<br>
&gt;=C2=A0 #include &lt;sys/wait.h&gt;<br>
&gt;=C2=A0 #endif<br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/qmp/json-parser.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/qmp/qdict.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/qmp/qjson.h&quot;<br>
&gt; diff --git a/scsi/qemu-pr-helper.c b/scsi/qemu-pr-helper.c<br>
&gt; index f281daeced8d..e7549ffb3bc9 100644<br>
&gt; --- a/scsi/qemu-pr-helper.c<br>
&gt; +++ b/scsi/qemu-pr-helper.c<br>
&gt; @@ -36,7 +36,7 @@<br>
&gt;=C2=A0 #include &lt;mpath_persist.h&gt;<br>
&gt;=C2=A0 #endif<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/error.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/cutils.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/main-loop.h&quot;<br>
&gt; diff --git a/softmmu/vl.c b/softmmu/vl.c<br>
&gt; index 46aba6a039c4..b0bf16e16aaa 100644<br>
&gt; --- a/softmmu/vl.c<br>
&gt; +++ b/softmmu/vl.c<br>
&gt; @@ -23,7 +23,7 @@<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 #include &quot;qemu/osdep.h&quot;<br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/datadir.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/units.h&quot;<br>
&gt;=C2=A0 #include &quot;exec/cpu-common.h&quot;<br>
&gt; diff --git a/storage-daemon/qemu-storage-daemon.c b/storage-daemon/qem=
u-storage-daemon.c<br>
&gt; index eb724072579a..a4415e8c995b 100644<br>
&gt; --- a/storage-daemon/qemu-storage-daemon.c<br>
&gt; +++ b/storage-daemon/qemu-storage-daemon.c<br>
&gt; @@ -42,7 +42,7 @@<br>
&gt;=C2=A0 #include &quot;qapi/qmp/qstring.h&quot;<br>
&gt;=C2=A0 #include &quot;qapi/qobject-input-visitor.h&quot;<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu-version.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/config-file.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/error-report.h&quot;<br>
&gt; diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passth=
rough_ll.c<br>
&gt; index 028dacdd8f5a..8af28f5fb823 100644<br>
&gt; --- a/tools/virtiofsd/passthrough_ll.c<br>
&gt; +++ b/tools/virtiofsd/passthrough_ll.c<br>
&gt; @@ -38,7 +38,7 @@<br>
&gt;=C2=A0 #include &quot;qemu/osdep.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu/timer.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu-version.h&quot;<br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;fuse_virtio.h&quot;<br>
&gt;=C2=A0 #include &quot;fuse_log.h&quot;<br>
&gt;=C2=A0 #include &quot;fuse_lowlevel.h&quot;<br>
&gt; diff --git a/ui/cocoa.m b/ui/cocoa.m<br>
&gt; index 839ae4f58a69..a2a74656fabf 100644<br>
&gt; --- a/ui/cocoa.m<br>
&gt; +++ b/ui/cocoa.m<br>
&gt; @@ -27,7 +27,7 @@<br>
&gt;=C2=A0 #import &lt;Cocoa/Cocoa.h&gt;<br>
&gt;=C2=A0 #include &lt;crt_externs.h&gt;<br>
&gt;=C2=A0 <br>
&gt; -#include &quot;qemu-common.h&quot;<br>
&gt; +#include &quot;qemu/copyright.h&quot;<br>
&gt;=C2=A0 #include &quot;qemu-main.h&quot;<br>
&gt;=C2=A0 #include &quot;ui/clipboard.h&quot;<br>
&gt;=C2=A0 #include &quot;ui/console.h&quot;<br>
&gt; -- <br>
&gt; 2.35.1.693.g805e0a68082a<br>
&gt; <br>
&gt; <br>
<br>
With regards,<br>
Daniel<br>
-- <br>
|: <a href=3D"https://berrange.com" rel=3D"noreferrer" target=3D"_blank">ht=
tps://berrange.com</a>=C2=A0 =C2=A0 =C2=A0 -o-=C2=A0 =C2=A0 <a href=3D"http=
s://www.flickr.com/photos/dberrange" rel=3D"noreferrer" target=3D"_blank">h=
ttps://www.flickr.com/photos/dberrange</a> :|<br>
|: <a href=3D"https://libvirt.org" rel=3D"noreferrer" target=3D"_blank">htt=
ps://libvirt.org</a>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-o-=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 <a href=3D"https://fstop138.berrange.com" rel=3D"n=
oreferrer" target=3D"_blank">https://fstop138.berrange.com</a> :|<br>
|: <a href=3D"https://entangle-photo.org" rel=3D"noreferrer" target=3D"_bla=
nk">https://entangle-photo.org</a>=C2=A0 =C2=A0 -o-=C2=A0 =C2=A0 <a href=3D=
"https://www.instagram.com/dberrange" rel=3D"noreferrer" target=3D"_blank">=
https://www.instagram.com/dberrange</a> :|<br>
<br>
<br>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature">Marc-Andr=C3=A9 Lureau<br></div></div>

--0000000000001a8f5b05dd178d99--

