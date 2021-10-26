MIME-Version: 1.0
References: <20211025204634.2517-1-iangelak@redhat.com>
	<20211025204634.2517-2-iangelak@redhat.com>
	<CAOQ4uxinGYb0QtgE8To5wc2iijT9VpTgDiXEp-9YXz=t_6eMbA@mail.gmail.com>
In-Reply-To: <CAOQ4uxinGYb0QtgE8To5wc2iijT9VpTgDiXEp-9YXz=t_6eMbA@mail.gmail.com>
From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Tue, 26 Oct 2021 16:47:56 -0400
Message-ID: <CAO17o20+jiij64y7b3eKoCjG5b_mLZj6o1LSnZ7+8exN3dFYEg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000bef64b05cf47998d"
Subject: Re: [Virtio-fs] [RFC PATCH 1/7] FUSE: Add the fsnotify opcode and
 in/out structs to FUSE
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel <linux-kernel@vger.kernel.org>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

--000000000000bef64b05cf47998d
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 26, 2021 at 10:56 AM Amir Goldstein <amir73il@gmail.com> wrote:

> On Mon, Oct 25, 2021 at 11:47 PM Ioannis Angelakopoulos
> <iangelak@redhat.com> wrote:
> >
> > Since fsnotify is the backend for the inotify subsystem all the backend
> > code implementation we add is related to fsnotify.
> >
> > To support an fsnotify request in FUSE and specifically virtiofs we add a
> > new opcode for the FSNOTIFY (51) operation request in the "fuse.h"
> header.
> >
> > Also add the "fuse_notify_fsnotify_in" and "fuse_notify_fsnotify_out"
> > structs that are responsible for passing the fsnotify/inotify related
> data
> > to and from the FUSE server.
> >
> > Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> > ---
> >  include/uapi/linux/fuse.h | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> > index 46838551ea84..418b7fc72417 100644
> > --- a/include/uapi/linux/fuse.h
> > +++ b/include/uapi/linux/fuse.h
> > @@ -186,6 +186,9 @@
> >   *  - add FUSE_SYNCFS
> >   *  7.35
> >   *  - add FUSE_NOTIFY_LOCK
> > + *  7.36
> > + *  - add FUSE_HAVE_FSNOTIFY
> > + *  - add fuse_notify_fsnotify_(in,out)
> >   */
> >
> >  #ifndef _LINUX_FUSE_H
> > @@ -221,7 +224,7 @@
> >  #define FUSE_KERNEL_VERSION 7
> >
> >  /** Minor version number of this interface */
> > -#define FUSE_KERNEL_MINOR_VERSION 35
> > +#define FUSE_KERNEL_MINOR_VERSION 36
> >
> >  /** The node ID of the root inode */
> >  #define FUSE_ROOT_ID 1
> > @@ -338,6 +341,7 @@ struct fuse_file_lock {
> >   *                     write/truncate sgid is killed only if file has
> group
> >   *                     execute permission. (Same as Linux VFS behavior).
> >   * FUSE_SETXATTR_EXT:  Server supports extended struct fuse_setxattr_in
> > + * FUSE_HAVE_FSNOTIFY: remote fsnotify/inotify event subsystem support
> >   */
> >  #define FUSE_ASYNC_READ                (1 << 0)
> >  #define FUSE_POSIX_LOCKS       (1 << 1)
> > @@ -369,6 +373,7 @@ struct fuse_file_lock {
> >  #define FUSE_SUBMOUNTS         (1 << 27)
> >  #define FUSE_HANDLE_KILLPRIV_V2        (1 << 28)
> >  #define FUSE_SETXATTR_EXT      (1 << 29)
> > +#define FUSE_HAVE_FSNOTIFY     (1 << 30)
> >
> >  /**
> >   * CUSE INIT request/reply flags
> > @@ -515,6 +520,7 @@ enum fuse_opcode {
> >         FUSE_SETUPMAPPING       = 48,
> >         FUSE_REMOVEMAPPING      = 49,
> >         FUSE_SYNCFS             = 50,
> > +       FUSE_FSNOTIFY           = 51,
> >
> >         /* CUSE specific operations */
> >         CUSE_INIT               = 4096,
> > @@ -532,6 +538,7 @@ enum fuse_notify_code {
> >         FUSE_NOTIFY_RETRIEVE = 5,
> >         FUSE_NOTIFY_DELETE = 6,
> >         FUSE_NOTIFY_LOCK = 7,
> > +       FUSE_NOTIFY_FSNOTIFY = 8,
> >         FUSE_NOTIFY_CODE_MAX,
> >  };
> >
> > @@ -571,6 +578,20 @@ struct fuse_getattr_in {
> >         uint64_t        fh;
> >  };
> >
> > +struct fuse_notify_fsnotify_out {
> > +       uint64_t inode;
>
> 64bit inode is not a good unique identifier of the object.
> you need to either include the generation in object identifier
> or much better use the object's nfs file handle, the same way
> that fanotify stores object identifiers.
>

Ok thank you for pointing that out. I will change this implementation to
include either the generation or use the object's nfs file handle.

> > +       uint64_t mask;
> > +       uint32_t namelen;
> > +       uint32_t cookie;
>
> I object to persisting with the two-events-joined-by-cookie design.
> Any new design should include a single event for rename
> with information about src and dst.
>
> I know this is inconvenient, but we are NOT going to create a "remote
> inotify"
> interface, we need to create a "remote fsnotify" interface and if server
> wants
> to use inotify, it will need to join the disjoined MOVE_FROM/TO event into
> a single "remote event", that FUSE will use to call fsnotify_move().
>
> I do not fully understand this. Should we define a new "remote" event
that corresponds to the merged MOVE_FROM/TO events and send that to the
guest instead?
If that is the case, wouldn't that require that user space processes be
aware of this newly added "remote"
event? Also in the inotify man page there is a limitations case that states
that it is possible for one of these events
to be missing. What should the server do in this case?

Thanks,
Ioannis

> Thanks,
> Amir.
>
>

-- 
Ioannis Angelakopoulos
Software Engineer Intern at Red Hat

--000000000000bef64b05cf47998d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Oct 26, 2021 at 10:56 AM Amir=
 Goldstein &lt;<a href=3D"mailto:amir73il@gmail.com">amir73il@gmail.com</a>=
&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On M=
on, Oct 25, 2021 at 11:47 PM Ioannis Angelakopoulos<br>
&lt;<a href=3D"mailto:iangelak@redhat.com" target=3D"_blank">iangelak@redha=
t.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Since fsnotify is the backend for the inotify subsystem all the backen=
d<br>
&gt; code implementation we add is related to fsnotify.<br>
&gt;<br>
&gt; To support an fsnotify request in FUSE and specifically virtiofs we ad=
d a<br>
&gt; new opcode for the FSNOTIFY (51) operation request in the &quot;fuse.h=
&quot; header.<br>
&gt;<br>
&gt; Also add the &quot;fuse_notify_fsnotify_in&quot; and &quot;fuse_notify=
_fsnotify_out&quot;<br>
&gt; structs that are responsible for passing the fsnotify/inotify related =
data<br>
&gt; to and from the FUSE server.<br>
&gt;<br>
&gt; Signed-off-by: Ioannis Angelakopoulos &lt;<a href=3D"mailto:iangelak@r=
edhat.com" target=3D"_blank">iangelak@redhat.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 include/uapi/linux/fuse.h | 23 ++++++++++++++++++++++-<br>
&gt;=C2=A0 1 file changed, 22 insertions(+), 1 deletion(-)<br>
&gt;<br>
&gt; diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h<br>
&gt; index 46838551ea84..418b7fc72417 100644<br>
&gt; --- a/include/uapi/linux/fuse.h<br>
&gt; +++ b/include/uapi/linux/fuse.h<br>
&gt; @@ -186,6 +186,9 @@<br>
&gt;=C2=A0 =C2=A0*=C2=A0 - add FUSE_SYNCFS<br>
&gt;=C2=A0 =C2=A0*=C2=A0 7.35<br>
&gt;=C2=A0 =C2=A0*=C2=A0 - add FUSE_NOTIFY_LOCK<br>
&gt; + *=C2=A0 7.36<br>
&gt; + *=C2=A0 - add FUSE_HAVE_FSNOTIFY<br>
&gt; + *=C2=A0 - add fuse_notify_fsnotify_(in,out)<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;<br>
&gt;=C2=A0 #ifndef _LINUX_FUSE_H<br>
&gt; @@ -221,7 +224,7 @@<br>
&gt;=C2=A0 #define FUSE_KERNEL_VERSION 7<br>
&gt;<br>
&gt;=C2=A0 /** Minor version number of this interface */<br>
&gt; -#define FUSE_KERNEL_MINOR_VERSION 35<br>
&gt; +#define FUSE_KERNEL_MINOR_VERSION 36<br>
&gt;<br>
&gt;=C2=A0 /** The node ID of the root inode */<br>
&gt;=C2=A0 #define FUSE_ROOT_ID 1<br>
&gt; @@ -338,6 +341,7 @@ struct fuse_file_lock {<br>
&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0write/truncate sgid is killed only if file has group<br=
>
&gt;=C2=A0 =C2=A0*=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0execute permission. (Same as Linux VFS behavior).<br>
&gt;=C2=A0 =C2=A0* FUSE_SETXATTR_EXT:=C2=A0 Server supports extended struct=
 fuse_setxattr_in<br>
&gt; + * FUSE_HAVE_FSNOTIFY: remote fsnotify/inotify event subsystem suppor=
t<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 #define FUSE_ASYNC_READ=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 (1 &lt;&lt; 0)<br>
&gt;=C2=A0 #define FUSE_POSIX_LOCKS=C2=A0 =C2=A0 =C2=A0 =C2=A0(1 &lt;&lt; 1=
)<br>
&gt; @@ -369,6 +373,7 @@ struct fuse_file_lock {<br>
&gt;=C2=A0 #define FUSE_SUBMOUNTS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(1 &lt;&=
lt; 27)<br>
&gt;=C2=A0 #define FUSE_HANDLE_KILLPRIV_V2=C2=A0 =C2=A0 =C2=A0 =C2=A0 (1 &l=
t;&lt; 28)<br>
&gt;=C2=A0 #define FUSE_SETXATTR_EXT=C2=A0 =C2=A0 =C2=A0 (1 &lt;&lt; 29)<br=
>
&gt; +#define FUSE_HAVE_FSNOTIFY=C2=A0 =C2=A0 =C2=A0(1 &lt;&lt; 30)<br>
&gt;<br>
&gt;=C2=A0 /**<br>
&gt;=C2=A0 =C2=A0* CUSE INIT request/reply flags<br>
&gt; @@ -515,6 +520,7 @@ enum fuse_opcode {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_SETUPMAPPING=C2=A0 =C2=A0 =C2=A0=
 =C2=A0=3D 48,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_REMOVEMAPPING=C2=A0 =C2=A0 =C2=
=A0 =3D 49,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_SYNCFS=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0=3D 50,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_FSNOTIFY=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0=3D 51,<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* CUSE specific operations */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0CUSE_INIT=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0=3D 4096,<br>
&gt; @@ -532,6 +538,7 @@ enum fuse_notify_code {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_NOTIFY_RETRIEVE =3D 5,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_NOTIFY_DELETE =3D 6,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_NOTIFY_LOCK =3D 7,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_NOTIFY_FSNOTIFY =3D 8,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FUSE_NOTIFY_CODE_MAX,<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt; @@ -571,6 +578,20 @@ struct fuse_getattr_in {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t=C2=A0 =C2=A0 =C2=A0 =C2=A0 f=
h;<br>
&gt;=C2=A0 };<br>
&gt;<br>
&gt; +struct fuse_notify_fsnotify_out {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t inode;<br>
<br>
64bit inode is not a good unique identifier of the object.<br>
you need to either include the generation in object identifier<br>
or much better use the object&#39;s nfs file handle, the same way<br>
that fanotify stores object identifiers.<br></blockquote><div><br></div><di=
v>Ok thank you for pointing that out. I will change this implementation to=
=C2=A0</div><div>include either the generation or use the object&#39;s nfs =
file handle.=C2=A0=C2=A0<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint64_t mask;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t namelen;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0uint32_t cookie;<br>
<br>
I object to persisting with the two-events-joined-by-cookie design.<br>
Any new design should include a single event for rename<br>
with information about src and dst.<br>
<br>
I know this is inconvenient, but we are NOT going to create a &quot;remote =
inotify&quot;<br>
interface, we need to create a &quot;remote fsnotify&quot; interface and if=
 server wants<br>
to use inotify, it will need to join the disjoined MOVE_FROM/TO event into<=
br>
a single &quot;remote event&quot;, that FUSE will use to call fsnotify_move=
().<br>
<br></blockquote><div>I do not fully understand this. Should we define a ne=
w &quot;remote&quot; event</div><div>that corresponds to the merged MOVE_FR=
OM/TO events and send that to the guest instead?</div><div>If that is the c=
ase, wouldn&#39;t that require that user space processes be aware of this n=
ewly added &quot;remote&quot;</div><div>event? Also in the inotify man page=
 there is a limitations case that states that it is possible for one of the=
se events</div><div>to be missing. What should the server do in this case?<=
/div><div><br></div><div>Thanks,</div><div>Ioannis=C2=A0</div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
Thanks,<br>
Amir.<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr">Ioannis Angelakopoulos<div>Soft=
ware Engineer Intern at Red Hat</div></div></div></div>

--000000000000bef64b05cf47998d--

