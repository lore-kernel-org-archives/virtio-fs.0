MIME-Version: 1.0
References: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
	<Yafy7hF56oPn9h4/@redhat.com>
	<CAJh=p+6RYEHVCVdqFg8+zZJ=bBy_De7v=-mCqa5k5_g0qih1gg@mail.gmail.com>
	<YajrnsEFa+Zkcke3@redhat.com>
	<ec0c3568-e22f-f7c7-c6fb-ca8b1f221407@redhat.com>
	<YakpJHe1iPPwCC+k@redhat.com>
	<63e98412-6f64-94a8-9863-dbb4cb5d6e62@redhat.com>
	<YaolAqwFWKahMJqy@redhat.com>
In-Reply-To: <YaolAqwFWKahMJqy@redhat.com>
From: German Maglione <gmaglione@redhat.com>
Date: Tue, 7 Dec 2021 16:41:17 +0100
Message-ID: <CAJh=p+4DDgr7ZS2fqx3PZMvh3fD9XfuGMGaqoNYrVA5jWsvL_Q@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000006e966f05d29036c8"
Subject: Re: [Virtio-fs] [virtiofsd][virtiofsd-rs] unlink an openfile over
	NFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>

--0000000000006e966f05d29036c8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I just want to add the link to the issue, since part of the discussion is
being held there:
https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/17


On Fri, Dec 3, 2021 at 3:09 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Fri, Dec 03, 2021 at 10:39:25AM +0100, Hanna Reitz wrote:
> > On 02.12.21 21:14, Vivek Goyal wrote:
> > > On Thu, Dec 02, 2021 at 06:52:17PM +0100, Hanna Reitz wrote:
> > > > On 02.12.21 16:51, Vivek Goyal wrote:
> > > > > On Thu, Dec 02, 2021 at 04:03:20PM +0100, German Maglione wrote:
> > > > > > On Wed, Dec 1, 2021 at 11:10 PM Vivek Goyal <vgoyal@redhat.com>
> wrote:
> > > > > >
> > > > > > > On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione
> wrote:
> > > > > > > > Hi,
> > > > > > > >
> > > > > > > > I was working on [1] (related to [2]), and I saw that both
> versions
> > > > > > > > (C and rust) of virtiofsd make the NFs client to "silly
> rename" an open
> > > > > > > > file that were unlinked, because we keep each file open as
> O_PATH in the
> > > > > > > > lo_do_lookup/do_lookup function. David pointed me to this
> problem, and I
> > > > > > > > confirmed that this is the case.
> > > > > > > >
> > > > > > > > This fires the silly rename in the nfs client. I'm talking
> with
> > > > > > > > Bruce Fields (nfs team) to see how to move the silly rename
> functionality
> > > > > > > > to the nfs server and outside the directory tree [4], to
> avoid having
> > > > > > > > non-really-empty
> > > > > > > > dirs full of .nfsxxx files. But it is not an easy task.
> > > > > > > > Also, this will not solve some potential issues with the
> resource usage:
> > > > > > > > disk space and open file limits (I hit this limit a couple
> of times
> > > > > > > during
> > > > > > > > my
> > > > > > > > tests). And, in some cases could be worst, more than one
> guest sharing
> > > > > > > the
> > > > > > > > same
> > > > > > > > exported dir, one guest just 'ls' or 'find' while the other
> 'rm' some
> > > > > > > files.
> > > > > > > > (The 'find' command will open all files, btw)
> > > > > > > >
> > > > > > > > Vivek, I saw in [5] that you mentioned that this could be
> fixed
> > > > > > > introducing
> > > > > > > > synchronous, could you elaborate a bit or point me to some
> code?
> > > > > > > Hi German,
> > > > > > >
> > > > > > > Right now forget messages are asynchronous. They are sent to
> server and
> > > > > > > client does not wait for any reply. That means when unlink()
> returns,
> > > > > > > it is possible that a FORGET message is in progress and has
> not finished
> > > > > > > yet.
> > > > > > >
> > > > > > > Idea behind synchronous FORGET messages is that it will
> generate a reply
> > > > > > > and client will wait for it. Given inode on server should be
> gone,
> > > > > > > I am not sure how much sense does it make. But anyway
> conceputaully
> > > > > > > that's the idea. If we want for FORGET message to finish, tha=
t
> will
> > > > > > > mean that O_PATH fd opened by virtiofsd is closed and we will
> not
> > > > > > > have NFS silly rename issue (atleast due to virtiofsd). If
> virtiofs
> > > > > > > client has file open, then issue will still happen.
> > > > > > >
> > > > > > > I think using file handles in virtiofsd_rs
> (--inode-file-handles) is
> > > > > > > a reasonable solution for this problem. Trying to add
> synchronous
> > > > > > > FORGET might be overkill.
> > > > > > >
> > > > > > >
> > > > > > Hi Vivek,
> > > > > >
> > > > > > Yes, as you said the solution is using --inode-file-hanldes,
> turns out
> > > > > > the problem was the --inode-file-handles failed silently when
> > > > > > choosing a sandbox other than namespace (now fixed by Hanna).
> > > > > >
> > > > > > So now the thing is, what we do if it fails? Hanna posted an
> Issue about
> > > > > > that:
> > > > > > "[RFE] Reporting failure to generate file handles".
> > > > > My take from the beginning has been that if file handle generatio=
n
> fails,
> > > > > then report it back to user (instead of falling back to O_PATH fd
> > > > > silently). That way user atleast knows that file handles can't be
> used.
> > > > I remember that we had a discussion about whether to introduce a
> mandatory
> > > > mode where this would be the behavior.  I thought we agreed that a
> > > > best-effort mode always made sense, for example for the situation y=
ou
> > > > describe below, where you have mixed filesystems, with some perhaps
> > > > supporting file handles, and others not.
> > > I think my primary objection was falling back to O_PATH fd for
> temporary
> > > failures. So file systems supports file handle but if we could not
> > > generate one due to lack of resources, I would rather return error. I=
n
> > > viritofsd C version, we identified a case where it could lead to two
> > > inodes in hash table using different keys. I am not sure if
> virtiofsd_rs
> > > version suffers from same issue or not.
> >
> > No (I hope not), I=E2=80=99ve tried to incorporate your feedback on tha=
t, and so
> the
> > Rust version does distinguish between temporary and persistent
> > name_to_handle_at() failures.  (The former returns `Err(_)`, the latter
> > `Ok(None)`.  `Err(_)`s are returned to the guest.)
>
> Sounds good. Temporary failures should be returned to client.
>
> >
> > (All errors for making a file handle openable, i.e. opening a mount FD,
> are
> > still not returned to the guest and only lead to a fallback.
>
> I would return error the moment you encounter one. That seems to be theme
> of all of the virtiofsd code. While trying to perform any operation, if
> it encounters an error, it immediately returns it to caller. So opening a
> mount FD should be no different and there should not be any need for
> fallback.
>
> > I remember at
> > one point I tried looking into this code to find out where it would be
> > reasonable to return an error, and where we should fall back, and I jus=
t
> > found it very difficult to decide. It also (luckily? :)) didn=E2=80=99t=
 have
> > anything to do with the bug you describe, because that was about whethe=
r
> we
> > have a handle for the lookup, and that=E2=80=99s now independent of the=
 whole
> mount
> > FD mess.)
> >
> > > W.r.t what to do if filesystem does not support file handles, should
> > > we fall back to O_PATH fd (and just emit a warning), I am fine with
> > > falling back to O_PATH fd and just log it so that users know.
> > >
> > > I have both the kind of users. Some users prefer fallback and other
> > > users prefer to get an error if a certain feature can't be enabled.
> > > I guess this will slowly evolve depending what users are asking for.
> > > But logging a warning if file handles can't be enabled, sounds ok.
> > >
> > > > As for a mandatory mode, I couldn=E2=80=99t imagine how exactly it =
would be
> useful,
> > > > though.  I think my argument was: =E2=80=9CWhat would a user do aft=
er
> launching
> > > > virtiofsd with file handles forced on, and then noticing they don=
=E2=80=99t
> work?=E2=80=9D
> > > I guess they will relaunch without --inodes-file-handle.
> >
> > Yes, that=E2=80=99s what I thought, too, and so it mostly sounded like =
an
> > inconvenience to me, and not really helpful. :/
>
> Alternatively, If there is anything configurable in underlying filesystem
> (to enable file handle support), they could take an action to fix it and
> restart virtiofsd with --inodes-file-handle.
>
> >
> > > > And I still don=E2=80=99t really know, even though I=E2=80=99m prop=
osing such a mode
> in said
> > > > virtiofsd-rs gitlab issue for the NFS case.
> > > Can you please provide a link to that issue.
> >
> > Ah, sure: https://gitlab.com/virtio-fs/virtiofsd-rs/-/issues/17
> >
> > > So why are you proposing this
> > > mode for NFS?
> >
> > Because it looks like with NFS, not using file handles may cause real
> > problems, and so I feel like failing early (failure to generate file
> > handles) is nicer than later (recursively deleting directories).
>
> Ok. One could argue that even regular file systems could cause problem
> by running into open file descriptor limit. So not sure NFS should be
> an exception.
>
> >
> > > > I suppose the answer is, check
> > > > every configuration and find out why it doesn=E2=80=99t work; but y=
ou don=E2=80=99t
> need a
> > > > mandatory file handle mode for this, logging errors whenever we nee=
d
> to fall
> > > > back to O_PATH FDs would be completely sufficient.
> > > Logging warnings should probably be good enough for lot of use cases.
> > >
> > > > (I=E2=80=99m mostly proposing it for NFS, because non-working file =
handles
> are
> > > > something that seems likely to cause other problems later. Emitting=
 a
> > > > warning would technically be completely fine in order to inform the
> user of
> > > > this, but I feel like in this case it=E2=80=99d be better to nag th=
em even
> more.)
> > > So why NFS is special? Due to silly renames issue?
> >
> > Yes.
> >
> > > So argument will be
> > > if there is a hard failure, then user can try to fix underlying
> filesystem
> > > configuration to support file handles?
> >
> > The argument is that the silly renames issue is kind of likely to produ=
ce
> > real tangible problems when file handles don=E2=80=99t work.  I feel li=
ke that
> > warrants more than just logging the error.
> >
> > > This will be true for other
> > > filesystems too.
> >
> > Yes, but for other filesystems, using or not using file handles seems
> like a
> > tuning thing, and not really anything that could produce tangible
> errors.
> > So to me, logging errors seems more appropriate then.
>
> Hmm..., open file descriptor limit is around 1M, IIRC. So if guest has
> cached enough inodes, one can run into it and that's the core problem
> file handle support solves.
>
> IMHO, NFS is not an exception. If we could not enable file handle support=
,
> both NFS and regular file systems can run into issues later.
>
> I would say I like the idea of adding argument to --inodes-file-handle an=
d
> let user choose if they want hard failures or a fallback. By default we
> could choose "fallback" if user just says --inodes-file-handle.
>
> >
> > > In fact, that will be the argument for hard failure (instead of
> fallback).
> > > Some users will say, I can fix underlying filesystem configuration if
> > > I know virtiofsd can't use file handles. Falling back to O_PATH fd wi=
ll
> > > give them false impression that configuration is alright and file
> > > handles are being used.
> > >
> > > So I can imagine both kind of users. One will prefer hard failure and
> > > other will be happy with fallback.
> >
> > Agreed!  (Which is why I=E2=80=99m proposing a switch to let the user d=
ecide.)
>
> Sounds good.
>
> >
> > > > > If file handles can't be generated due to lack of resources in
> system,
> > > > > then error should be returned to caller as well.
> > > > >
> > > > > > There is any problem to use file handles as default?
> > > > > It gives CAP_DAC_READ_SEARCH in init_user_ns. So enabling it by
> default
> > > > > might not be desirable. Especially given the fact that we want to
> move
> > > > > towards user namespaces and run virtiofsd with least priviliges. =
So
> > > > > I will think user needs to enable it if they need it.
> > > > >
> > > > > > I mean without
> > > > > > --inode-file-handles so let them fail and force the user to use
> something
> > > > > > like
> > > > > > --no-file-handles/--force-no-file-handles with a warning.
> > > > > If we were to enable it by default, we probably should test if fi=
le
> > > > > handles are supported on shared dir. If yes, then enable it by
> default
> > > > > otherwise continue to use O_PATH fd. But this will be mode switch
> for
> > > > > the whole shared filesystem.
> > > > >
> > > > > I think given we have notion of submounts and some of the
> submounted
> > > > > filesystems might not support file handles, so key question will =
be
> > > > > what do we do here. Do we return error in this case or fallback t=
o
> > > > > O_PATH fd for that submount. If we stick to our design philosophy=
,
> > > > > then I would say return error. But some people might object becau=
se
> > > > > they might want a mode where there is mix of filesystems in share=
d
> > > > > dir and they want to use file handles where supported. So I am
> sitting
> > > > > on the fence on this one.
> > > > I think at this point I prefer making --inode-file-handles take an
> optional
> > > > argument:
> > > > - no: Default, don=E2=80=99t use file handles.
> > > > - best-effort: Try to generate file handles, fall back to FDs on
> error.
> > > Will be nice if we fallback only if filesystem does not support file
> > > handles. For temporary failures, we should return errors to callers.
> There
> > > is no good reason to fallback to O_PATH fd in that case.
> > >
> > > > - mandatory: Always use file handles, return errors to the guest.
> > > This sounds reasonable. Another naming scheme could be "no, fallback,
> > > always".
> >
> > Naming things is hard :)
>
> Agreed. I am fine with the naming scheme you have proposed. Not sure what
> will you do with "mandatory" when rootfs supports file handles but one of
> the submounts does not. You will not come to know about it at startup
> time and hard failures are better detected at startup time.
>
> Vivek
>
>

--=20
German

--0000000000006e966f05d29036c8
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I just want to add the link to the issue, since part =
of the discussion is being held there:</div><div><a href=3D"https://gitlab.=
com/virtio-fs/virtiofsd-rs/-/issues/17">https://gitlab.com/virtio-fs/virtio=
fsd-rs/-/issues/17</a></div><div><br></div></div><br><div class=3D"gmail_qu=
ote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Dec 3, 2021 at 3:09 PM V=
ivek Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&g=
t; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0p=
x 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri=
, Dec 03, 2021 at 10:39:25AM +0100, Hanna Reitz wrote:<br>
&gt; On 02.12.21 21:14, Vivek Goyal wrote:<br>
&gt; &gt; On Thu, Dec 02, 2021 at 06:52:17PM +0100, Hanna Reitz wrote:<br>
&gt; &gt; &gt; On 02.12.21 16:51, Vivek Goyal wrote:<br>
&gt; &gt; &gt; &gt; On Thu, Dec 02, 2021 at 04:03:20PM +0100, German Maglio=
ne wrote:<br>
&gt; &gt; &gt; &gt; &gt; On Wed, Dec 1, 2021 at 11:10 PM Vivek Goyal &lt;<a=
 href=3D"mailto:vgoyal@redhat.com" target=3D"_blank">vgoyal@redhat.com</a>&=
gt; wrote:<br>
&gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; On Wed, Dec 01, 2021 at 01:06:23PM +0100, Ger=
man Maglione wrote:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Hi,<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; I was working on [1] (related to [2]), a=
nd I saw that both versions<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; (C and rust) of virtiofsd make the NFs c=
lient to &quot;silly rename&quot; an open<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; file that were unlinked, because we keep=
 each file open as O_PATH in the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; lo_do_lookup/do_lookup function. David p=
ointed me to this problem, and I<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; confirmed that this is the case.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; This fires the silly rename in the nfs c=
lient. I&#39;m talking with<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Bruce Fields (nfs team) to see how to mo=
ve the silly rename functionality<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; to the nfs server and outside the direct=
ory tree [4], to avoid having<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; non-really-empty<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; dirs full of .nfsxxx files. But it is no=
t an easy task.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Also, this will not solve some potential=
 issues with the resource usage:<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; disk space and open file limits (I hit t=
his limit a couple of times<br>
&gt; &gt; &gt; &gt; &gt; &gt; during<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; my<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; tests). And, in some cases could be wors=
t, more than one guest sharing<br>
&gt; &gt; &gt; &gt; &gt; &gt; the<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; same<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; exported dir, one guest just &#39;ls&#39=
; or &#39;find&#39; while the other &#39;rm&#39; some<br>
&gt; &gt; &gt; &gt; &gt; &gt; files.<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; (The &#39;find&#39; command will open al=
l files, btw)<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; Vivek, I saw in [5] that you mentioned t=
hat this could be fixed<br>
&gt; &gt; &gt; &gt; &gt; &gt; introducing<br>
&gt; &gt; &gt; &gt; &gt; &gt; &gt; synchronous, could you elaborate a bit o=
r point me to some code?<br>
&gt; &gt; &gt; &gt; &gt; &gt; Hi German,<br>
&gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; Right now forget messages are asynchronous. T=
hey are sent to server and<br>
&gt; &gt; &gt; &gt; &gt; &gt; client does not wait for any reply. That mean=
s when unlink() returns,<br>
&gt; &gt; &gt; &gt; &gt; &gt; it is possible that a FORGET message is in pr=
ogress and has not finished<br>
&gt; &gt; &gt; &gt; &gt; &gt; yet.<br>
&gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; Idea behind synchronous FORGET messages is th=
at it will generate a reply<br>
&gt; &gt; &gt; &gt; &gt; &gt; and client will wait for it. Given inode on s=
erver should be gone,<br>
&gt; &gt; &gt; &gt; &gt; &gt; I am not sure how much sense does it make. Bu=
t anyway conceputaully<br>
&gt; &gt; &gt; &gt; &gt; &gt; that&#39;s the idea. If we want for FORGET me=
ssage to finish, that will<br>
&gt; &gt; &gt; &gt; &gt; &gt; mean that O_PATH fd opened by virtiofsd is cl=
osed and we will not<br>
&gt; &gt; &gt; &gt; &gt; &gt; have NFS silly rename issue (atleast due to v=
irtiofsd). If virtiofs<br>
&gt; &gt; &gt; &gt; &gt; &gt; client has file open, then issue will still h=
appen.<br>
&gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; I think using file handles in virtiofsd_rs (-=
-inode-file-handles) is<br>
&gt; &gt; &gt; &gt; &gt; &gt; a reasonable solution for this problem. Tryin=
g to add synchronous<br>
&gt; &gt; &gt; &gt; &gt; &gt; FORGET might be overkill.<br>
&gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; Hi Vivek,<br>
&gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; Yes, as you said the solution is using --inode-fil=
e-hanldes, turns out<br>
&gt; &gt; &gt; &gt; &gt; the problem was the --inode-file-handles failed si=
lently when<br>
&gt; &gt; &gt; &gt; &gt; choosing a sandbox other than namespace (now fixed=
 by Hanna).<br>
&gt; &gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; So now the thing is, what we do if it fails? Hanna=
 posted an Issue about<br>
&gt; &gt; &gt; &gt; &gt; that:<br>
&gt; &gt; &gt; &gt; &gt; &quot;[RFE] Reporting failure to generate file han=
dles&quot;.<br>
&gt; &gt; &gt; &gt; My take from the beginning has been that if file handle=
 generation fails,<br>
&gt; &gt; &gt; &gt; then report it back to user (instead of falling back to=
 O_PATH fd<br>
&gt; &gt; &gt; &gt; silently). That way user atleast knows that file handle=
s can&#39;t be used.<br>
&gt; &gt; &gt; I remember that we had a discussion about whether to introdu=
ce a mandatory<br>
&gt; &gt; &gt; mode where this would be the behavior.=C2=A0 I thought we ag=
reed that a<br>
&gt; &gt; &gt; best-effort mode always made sense, for example for the situ=
ation you<br>
&gt; &gt; &gt; describe below, where you have mixed filesystems, with some =
perhaps<br>
&gt; &gt; &gt; supporting file handles, and others not.<br>
&gt; &gt; I think my primary objection was falling back to O_PATH fd for te=
mporary<br>
&gt; &gt; failures. So file systems supports file handle but if we could no=
t<br>
&gt; &gt; generate one due to lack of resources, I would rather return erro=
r. In<br>
&gt; &gt; viritofsd C version, we identified a case where it could lead to =
two<br>
&gt; &gt; inodes in hash table using different keys. I am not sure if virti=
ofsd_rs<br>
&gt; &gt; version suffers from same issue or not.<br>
&gt; <br>
&gt; No (I hope not), I=E2=80=99ve tried to incorporate your feedback on th=
at, and so the<br>
&gt; Rust version does distinguish between temporary and persistent<br>
&gt; name_to_handle_at() failures.=C2=A0 (The former returns `Err(_)`, the =
latter<br>
&gt; `Ok(None)`.=C2=A0 `Err(_)`s are returned to the guest.)<br>
<br>
Sounds good. Temporary failures should be returned to client.<br>
<br>
&gt; <br>
&gt; (All errors for making a file handle openable, i.e. opening a mount FD=
, are<br>
&gt; still not returned to the guest and only lead to a fallback.=C2=A0<br>
<br>
I would return error the moment you encounter one. That seems to be theme<b=
r>
of all of the virtiofsd code. While trying to perform any operation, if<br>
it encounters an error, it immediately returns it to caller. So opening a<b=
r>
mount FD should be no different and there should not be any need for<br>
fallback.<br>
<br>
&gt; I remember at<br>
&gt; one point I tried looking into this code to find out where it would be=
<br>
&gt; reasonable to return an error, and where we should fall back, and I ju=
st<br>
&gt; found it very difficult to decide. It also (luckily? :)) didn=E2=80=99=
t have<br>
&gt; anything to do with the bug you describe, because that was about wheth=
er we<br>
&gt; have a handle for the lookup, and that=E2=80=99s now independent of th=
e whole mount<br>
&gt; FD mess.)<br>
&gt; <br>
&gt; &gt; W.r.t what to do if filesystem does not support file handles, sho=
uld<br>
&gt; &gt; we fall back to O_PATH fd (and just emit a warning), I am fine wi=
th<br>
&gt; &gt; falling back to O_PATH fd and just log it so that users know.<br>
&gt; &gt; <br>
&gt; &gt; I have both the kind of users. Some users prefer fallback and oth=
er<br>
&gt; &gt; users prefer to get an error if a certain feature can&#39;t be en=
abled.<br>
&gt; &gt; I guess this will slowly evolve depending what users are asking f=
or.<br>
&gt; &gt; But logging a warning if file handles can&#39;t be enabled, sound=
s ok.<br>
&gt; &gt; <br>
&gt; &gt; &gt; As for a mandatory mode, I couldn=E2=80=99t imagine how exac=
tly it would be useful,<br>
&gt; &gt; &gt; though.=C2=A0 I think my argument was: =E2=80=9CWhat would a=
 user do after launching<br>
&gt; &gt; &gt; virtiofsd with file handles forced on, and then noticing the=
y don=E2=80=99t work?=E2=80=9D<br>
&gt; &gt; I guess they will relaunch without --inodes-file-handle.<br>
&gt; <br>
&gt; Yes, that=E2=80=99s what I thought, too, and so it mostly sounded like=
 an<br>
&gt; inconvenience to me, and not really helpful. :/<br>
<br>
Alternatively, If there is anything configurable in underlying filesystem<b=
r>
(to enable file handle support), they could take an action to fix it and<br=
>
restart virtiofsd with --inodes-file-handle.<br>
<br>
&gt; <br>
&gt; &gt; &gt; And I still don=E2=80=99t really know, even though I=E2=80=
=99m proposing such a mode in said<br>
&gt; &gt; &gt; virtiofsd-rs gitlab issue for the NFS case.<br>
&gt; &gt; Can you please provide a link to that issue.<br>
&gt; <br>
&gt; Ah, sure: <a href=3D"https://gitlab.com/virtio-fs/virtiofsd-rs/-/issue=
s/17" rel=3D"noreferrer" target=3D"_blank">https://gitlab.com/virtio-fs/vir=
tiofsd-rs/-/issues/17</a><br>
&gt; <br>
&gt; &gt; So why are you proposing this<br>
&gt; &gt; mode for NFS?<br>
&gt; <br>
&gt; Because it looks like with NFS, not using file handles may cause real<=
br>
&gt; problems, and so I feel like failing early (failure to generate file<b=
r>
&gt; handles) is nicer than later (recursively deleting directories).<br>
<br>
Ok. One could argue that even regular file systems could cause problem<br>
by running into open file descriptor limit. So not sure NFS should be<br>
an exception.<br>
<br>
&gt; <br>
&gt; &gt; &gt; I suppose the answer is, check<br>
&gt; &gt; &gt; every configuration and find out why it doesn=E2=80=99t work=
; but you don=E2=80=99t need a<br>
&gt; &gt; &gt; mandatory file handle mode for this, logging errors whenever=
 we need to fall<br>
&gt; &gt; &gt; back to O_PATH FDs would be completely sufficient.<br>
&gt; &gt; Logging warnings should probably be good enough for lot of use ca=
ses.<br>
&gt; &gt; <br>
&gt; &gt; &gt; (I=E2=80=99m mostly proposing it for NFS, because non-workin=
g file handles are<br>
&gt; &gt; &gt; something that seems likely to cause other problems later. E=
mitting a<br>
&gt; &gt; &gt; warning would technically be completely fine in order to inf=
orm the user of<br>
&gt; &gt; &gt; this, but I feel like in this case it=E2=80=99d be better to=
 nag them even more.)<br>
&gt; &gt; So why NFS is special? Due to silly renames issue?<br>
&gt; <br>
&gt; Yes.<br>
&gt; <br>
&gt; &gt; So argument will be<br>
&gt; &gt; if there is a hard failure, then user can try to fix underlying f=
ilesystem<br>
&gt; &gt; configuration to support file handles?<br>
&gt; <br>
&gt; The argument is that the silly renames issue is kind of likely to prod=
uce<br>
&gt; real tangible problems when file handles don=E2=80=99t work.=C2=A0 I f=
eel like that<br>
&gt; warrants more than just logging the error.<br>
&gt; <br>
&gt; &gt; This will be true for other<br>
&gt; &gt; filesystems too.<br>
&gt; <br>
&gt; Yes, but for other filesystems, using or not using file handles seems =
like a<br>
&gt; tuning thing, and not really anything that could produce tangible erro=
rs.=C2=A0<br>
&gt; So to me, logging errors seems more appropriate then.<br>
<br>
Hmm..., open file descriptor limit is around 1M, IIRC. So if guest has<br>
cached enough inodes, one can run into it and that&#39;s the core problem<b=
r>
file handle support solves. <br>
<br>
IMHO, NFS is not an exception. If we could not enable file handle support,<=
br>
both NFS and regular file systems can run into issues later.<br>
<br>
I would say I like the idea of adding argument to --inodes-file-handle and<=
br>
let user choose if they want hard failures or a fallback. By default we<br>
could choose &quot;fallback&quot; if user just says --inodes-file-handle.<b=
r>
<br>
&gt; <br>
&gt; &gt; In fact, that will be the argument for hard failure (instead of f=
allback).<br>
&gt; &gt; Some users will say, I can fix underlying filesystem configuratio=
n if<br>
&gt; &gt; I know virtiofsd can&#39;t use file handles. Falling back to O_PA=
TH fd will<br>
&gt; &gt; give them false impression that configuration is alright and file=
<br>
&gt; &gt; handles are being used.<br>
&gt; &gt; <br>
&gt; &gt; So I can imagine both kind of users. One will prefer hard failure=
 and<br>
&gt; &gt; other will be happy with fallback.<br>
&gt; <br>
&gt; Agreed!=C2=A0 (Which is why I=E2=80=99m proposing a switch to let the =
user decide.)<br>
<br>
Sounds good.<br>
<br>
&gt; <br>
&gt; &gt; &gt; &gt; If file handles can&#39;t be generated due to lack of r=
esources in system,<br>
&gt; &gt; &gt; &gt; then error should be returned to caller as well.<br>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; There is any problem to use file handles as defaul=
t?<br>
&gt; &gt; &gt; &gt; It gives CAP_DAC_READ_SEARCH in init_user_ns. So enabli=
ng it by default<br>
&gt; &gt; &gt; &gt; might not be desirable. Especially given the fact that =
we want to move<br>
&gt; &gt; &gt; &gt; towards user namespaces and run virtiofsd with least pr=
iviliges. So<br>
&gt; &gt; &gt; &gt; I will think user needs to enable it if they need it.<b=
r>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; &gt; I mean without<br>
&gt; &gt; &gt; &gt; &gt; --inode-file-handles so let them fail and force th=
e user to use something<br>
&gt; &gt; &gt; &gt; &gt; like<br>
&gt; &gt; &gt; &gt; &gt; --no-file-handles/--force-no-file-handles with a w=
arning.<br>
&gt; &gt; &gt; &gt; If we were to enable it by default, we probably should =
test if file<br>
&gt; &gt; &gt; &gt; handles are supported on shared dir. If yes, then enabl=
e it by default<br>
&gt; &gt; &gt; &gt; otherwise continue to use O_PATH fd. But this will be m=
ode switch for<br>
&gt; &gt; &gt; &gt; the whole shared filesystem.<br>
&gt; &gt; &gt; &gt; <br>
&gt; &gt; &gt; &gt; I think given we have notion of submounts and some of t=
he submounted<br>
&gt; &gt; &gt; &gt; filesystems might not support file handles, so key ques=
tion will be<br>
&gt; &gt; &gt; &gt; what do we do here. Do we return error in this case or =
fallback to<br>
&gt; &gt; &gt; &gt; O_PATH fd for that submount. If we stick to our design =
philosophy,<br>
&gt; &gt; &gt; &gt; then I would say return error. But some people might ob=
ject because<br>
&gt; &gt; &gt; &gt; they might want a mode where there is mix of filesystem=
s in shared<br>
&gt; &gt; &gt; &gt; dir and they want to use file handles where supported. =
So I am sitting<br>
&gt; &gt; &gt; &gt; on the fence on this one.<br>
&gt; &gt; &gt; I think at this point I prefer making --inode-file-handles t=
ake an optional<br>
&gt; &gt; &gt; argument:<br>
&gt; &gt; &gt; - no: Default, don=E2=80=99t use file handles.<br>
&gt; &gt; &gt; - best-effort: Try to generate file handles, fall back to FD=
s on error.<br>
&gt; &gt; Will be nice if we fallback only if filesystem does not support f=
ile<br>
&gt; &gt; handles. For temporary failures, we should return errors to calle=
rs. There<br>
&gt; &gt; is no good reason to fallback to O_PATH fd in that case.<br>
&gt; &gt; <br>
&gt; &gt; &gt; - mandatory: Always use file handles, return errors to the g=
uest.<br>
&gt; &gt; This sounds reasonable. Another naming scheme could be &quot;no, =
fallback,<br>
&gt; &gt; always&quot;.<br>
&gt; <br>
&gt; Naming things is hard :)<br>
<br>
Agreed. I am fine with the naming scheme you have proposed. Not sure what<b=
r>
will you do with &quot;mandatory&quot; when rootfs supports file handles bu=
t one of<br>
the submounts does not. You will not come to know about it at startup<br>
time and hard failures are better detected at startup time.<br>
<br>
Vivek<br>
<br>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature"><div dir=3D"ltr">German<br></div></div>

--0000000000006e966f05d29036c8--

