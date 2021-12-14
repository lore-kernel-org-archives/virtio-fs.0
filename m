MIME-Version: 1.0
References: <CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
	<CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
	<CAOQ4uxjpGMYZrq74S=EaSO2nvss4hm1WZ_k+Xxgrj2k9pngJgg@mail.gmail.com>
	<YaZC+R7xpGimBrD1@redhat.com>
In-Reply-To: <YaZC+R7xpGimBrD1@redhat.com>
From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Tue, 14 Dec 2021 18:21:43 -0500
Message-ID: <CAO17o21uh3fJHd0gMu-SmZei5et6HJo91DiLk_YyfUqrtHy2pQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000f15e5c05d32375e2"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Nathan Youngman <git@nathany.com>, Amir Goldstein <amir73il@gmail.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Stef Bon <stefbon@gmail.com>

--000000000000f15e5c05d32375e2
Content-Type: text/plain; charset="UTF-8"

Hello Amir and Jan,

After testing some of your proposals, related to extending the remote
notification to fanotify as well, we came across some issues that are not
straightforward to overcome:

1) Currently fuse does not support persistent file handles.  This means
that file handles become stale if an inode is flushed out of the cache. The
file handle support is very limited at the moment in fuse. Thus, the only
option left is to implement fanotify both in server and guest with file
descriptors.

2) Since we can only use file descriptors, to support fanotify in viritofsd
we need CAP_SYS_ADMIN enabled. The virtiofs developers are not
very positive about the idea of using CAP_SYS_ADMIN for security reasons.
Thus we attempted to support some basic fanotify functionality on the
client/guest by modifying our existing implementation with inotify/fsnotify.

3) Basically, we continue to use inotify on the virtiofsd/fuse server but
we add support on the client/guest kernel to be able to support simple
fanotify events (i.e., for now the same events as inotify). However, two
important problems arise from the use of the fanotify file descriptor mode
in a guest process:

3a) First, to be able to support fanotify in the file descriptor mode we
need to pass to a "struct path" to the fsnotify call (within the guest
kernel) that corresponds to the inode that we are monitoring.
Unfortunately, when the guest receives the remote event from the server it
only has information about the target inode. Since there is more than one
mapping of "struct path" to a "struct inode" we do not know which path
information to pass to the fsnotify call.

3b) Second, since the guest kernel needs to pass an open file descriptor
back to the guest user space as part of the fanotify event data, internally
the guest kernel (through fanotify's "create_fd" function) issues a
"dentry_open" which will result in an additional FUSE_OPEN call to the
server and subsequently the generation of an open event on the server (If
the server monitors for an open event). This will inevitably cause an
infinite loop of FUSE_OPEN requests and generation of open events on the
server. One idea was to modify the open syscall (on the host kernel) to
allow the use of FMODE_NONOTIFY flag from user space (currently it is used
internally in the kernel code only), to be able to suppress open events.
However, a malicious guest might be able to exploit that flag to disrupt
the event generation for a file (I am not entirely sure if this is
possible, yet).

To sum up, it seems that the support for fanotify causes some problems that
are very difficult to mitigate at the moment. The fanotify file handles
mode would probably solve most if not all of the above problems we are
facing, however as Vivek pointed out the file handle support in
virtiofs/fuse is another project altogether.

So we would like to ask you for any suggestions related to the
aforementioned problems. If there are no "easy" solutions in sight for
these fanotify issues, we would like to at least continue to support the
remote inotify in the next version of the patches and try to solve issues
around it.

Thanks,
Ioannis

On Tue, Nov 30, 2021 at 10:27 AM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Nov 17, 2021 at 08:40:57AM +0200, Amir Goldstein wrote:
> > On Wed, Nov 17, 2021 at 12:12 AM Ioannis Angelakopoulos
> > <iangelak@redhat.com> wrote:
> > >
> > >
> > >
> > > On Tue, Nov 16, 2021 at 12:10 AM Stef Bon <stefbon@gmail.com> wrote:
> > >>
> > >> Hi Ioannis,
> > >>
> > >> I see that you have been working on making fsnotify work on virtiofs.
> > >> Earlier you contacted me since I've written this:
> > >>
> > >> https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE
> > >>
> > >> and send you my patches on 23 june.
> > >> I want to mention first that I would have appreciated it if you would
> > >> have reacted to me after I've sent you my patches. I did not get any
> > >> reaction from you. Maybe these patches (which differ from what you
> > >> propose now, but there is also a lot in common) have been an
> > >> inspiration for you.
> > >>
> > >> Second, what I've written about is that with network filesystems (eg a
> > >> backend shared with other systems) fsnotify support in FUSE has some
> > >> drawbacks.
> > >> In a network environment, where a network fs is part of making people
> > >> collaborate, it's very useful to have information on who did what on
> > >> which host, and also when. Simply a message "a file has been created
> > >> in the folder you watch" is not enough. For example, if you are part
> > >> of a team, and assigned to your team is a directory on a server where
> > >> you can work on some shared documents. Now in this example there is a
> > >> planning, and some documents have to be written. In that case you want
> > >> to be informed that someone in your team has started a document (by
> > >> creating it) by the system.
> > >>
> > > I agree that the out of band approach you propose is actually more
> powerful, since it can
> > > provide the client with more information than remote fsnotify.
> However, in the virtiofs setup
> > > your approach might not be as efficient.
> > >
> > > Specifically, the information on who did what might not make sense to
> the guest within QEMU, since all the
> > > virtiofs filesystem operations are handled by viritofsd on the host
> and the guest does not know about the
> > > server or any other guests. Vivek, correct me here if I am wrong.
> > >
> > > Thus, for now at least, it might be sufficient for the guest to know
> that just a remote event
> > > occurred.
> > >
> > >> This "extended" information will never get through fsnotify.
> > >>
> > >> Other info useful to you as team member:
> > >>
> > >> -  you have become member of another team:
> sbon@anotherteam.example.org
> > >> -  diskspace and/or quota shortage reported by networksystem
> > >> -  new teammember, teammember left
> > >> -  your "rights" or role in the network/team have been changed (for
> > >> example from reader to reader and writer to some documents)
> > >>
> > >> What I want to say is that in a network where lots of people work
> > >> together in teams/projects, (and I want Linux to play a role there, as
> > >> desktop/workstation) communication is very important, and all these
> > >> messages should be supported by the system. My idea is the support of
> > >> watching fs events with FUSE filesystems should go through userspace,
> > >> and not via the kernel (cause fs events are part of your setup in the
> > >> network, together with all other tools to make people collaborate like
> > >> chat/call/text, and because mentioned above extended info about the
> > >> who on what host etc is not supported by fsnotify).
> > >> There should be a fs event watcher which takes care of all watches on
> > >> behalf of applications during a session, similar to gamin and FAM once
> > >> did (not used anymore?).
> > >> When receiving a request from one of the applications this fsevent
> > >> watcher will use inotify and/or fanotify for local fs's only. With a
> > >> FUSE fs, it should contact (via a socket) this fs that a watch has
> > >> been set on an inode with a certain mask.
> > >> If the FUSE fs does not support this, fallback on normal
> inotify/fanotify.
> > >> This way extended info is possible.
> > >>
> > >> Is this extended information also useful for virtiofs?
> > >>
> > > Also based on your explanation, your out of band approach is specific
> to FUSE filesystems.
> > > Granted, with your approach there is less complexity in the kernel and
> more flexibility since
> > > the event notification occurs solely in user-space.
> > > However, during the discussion with Amir and Jan about potential
> routes we could take to support the remote
> > > fanotify/inotify/fsnotify one important concern was that the API
> should be able to support other
> > > network/remote filesystems if needed and not only FUSE filesystems.
> > > It seems that your approach would require a lot of work (correct me if
> I am wrong) to be adopted
> > > by other network filesystems.
> > >
> > > Finally, user-space applications should also be aware of your new API,
> which will probably result in a non-negligible effort by app developers to
> adopt it or change their existing apps. The remote inotify/fsnotify ( the
> current implementation) even though it has many limitations, relies on the
> existing API and should require less modifications in user space apps. That
> is why we chose the remote inotify/fsnotify route.
> > >
> >
> > The way you depict the options seems like either applications are not
> > aware of the UAPI
> > changes or they need to be modified to adapt to the changes.
> >
> > I actually think that the much better approach would be to deal with
> > most of the UAPI
> > complexity in a library, so applications may need to be rebuilt or
> > adapted to use a new
> > library, but going forward, the library would abstract most of the
> > complexity from the
> > applications.
> >
> > The holy grail would be a portable library, such as this go library [1].
> > It is quite hard to design an API that would abstract all the
> > different capabilities
> > on Linux-inotify/Linux-fanotify/MacOS-fsevents/Win-USNJournal and more.
> >
> > The second best would be a library to abstract the ever growing
> complexity
> > of Linux inotify/fanotify UAPI from applications.
> > I had already made the first step with adapting libinotifytools to
> fanotify [2].
> > We could continue down that path or start creating/improving a
> > different library.
> >
> > The point is that abstracting different capabilities of remote fs
> notifications
> > (i.e. cifs, virtiofs, generic FUSE) is going to be challenging, so
> starting the
> > design from a user library API and deriving the needed pieces from the
> > kernel UAPI is the right way to go IMO.
> >
> > The library approach will have the advantage that some remote fs
> capabilities
> > (e.g. for cifs) will be available for old kernels as well and in
> > theory, the library
> > could also use some standardized OOB notifications channel to get changed
> > made on the host from VM guest tools as Stef proposed.
> >
> > > That said, I do not see a reason why both implementations cannot
> co-exist
> > > and have the user-space applications choose which approach they want.
> > >
> >
> > True, an OOB channel and kernel generic remote fs support can both exist,
> > but it would be best if the application was not aware of either.
> > The library would pick the facility based on the requested functionality,
> > availability of the facilities in the filesystem and sysadmin/user
> policy.
>
> Sure. A library will be nice to abstract kernel generic remote fs and OOB
> channel. This sounds like another project for somebody to work on.
>
> IIUC, it looks like that both the approaches can make progress in
> parallel. Advantange of OOB channel approach seems that it will be easier
> to
> make changes in user space and add more events and send extra information.
>
> While advantage of remote fsnotify is that its a known existing events
> API and it makes it easier for applications to use same API for remote
> fs (however limited it might be).
>
> Thanks
> Vivek
>
> > Thanks,
> > Amir.
> >
> > [1] https://github.com/fsnotify/fsnotify
> > [2] https://github.com/inotify-tools/inotify-tools/pull/134
> >
>
>

-- 
Ioannis Angelakopoulos
Software Engineer Intern at Red Hat

--000000000000f15e5c05d32375e2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello Amir and Jan,<div><br></div><div>After testing some =
of your proposals, related to extending the remote notification to fanotify=
 as well, we came across some issues that are not straightforward to overco=
me:</div><div><br></div><div>1) Currently fuse does not support persistent =
file handles.=C2=A0 This means that file handles become stale if an inode i=
s flushed out of the cache. The file handle support is very limited at the =
moment in fuse. Thus, the only option left is to implement fanotify both in=
 server=C2=A0and guest with file descriptors.</div><div><br></div><div>2) S=
ince we can only use file descriptors, to support fanotify in viritofsd we =
need CAP_SYS_ADMIN enabled. The virtiofs=C2=A0developers are not very=C2=A0=
positive about the idea of using CAP_SYS_ADMIN for security reasons. Thus w=
e attempted to support some basic fanotify functionality on the client/gues=
t by modifying our existing implementation with inotify/fsnotify.</div><div=
><br></div><div>3) Basically, we continue to use inotify on the virtiofsd/f=
use server but we add support on the client/guest kernel to be able to supp=
ort simple fanotify events (i.e., for now the same events as inotify). Howe=
ver, two important problems arise=C2=A0from the use of the fanotify file de=
scriptor mode in a guest process:</div><div><br></div><div>3a) First, to be=
 able to support fanotify in the file descriptor mode we need to pass to a =
&quot;struct path&quot; to the fsnotify call (within the guest kernel) that=
 corresponds to the inode that we are monitoring. Unfortunately, when the g=
uest receives the remote event from the server it only has information abou=
t the target inode. Since there is more than one mapping of &quot;struct pa=
th&quot; to a &quot;struct inode&quot; we do not know which path informatio=
n to pass to the fsnotify call.=C2=A0</div><div><br></div><div>3b) Second, =
since the guest kernel needs to pass an open file descriptor back to the gu=
est user space as part of the fanotify event data, internally the guest ker=
nel (through fanotify&#39;s=C2=A0&quot;create_fd&quot; function) issues a &=
quot;dentry_open&quot; which will result in an additional FUSE_OPEN call to=
 the server and subsequently the generation of an open event on the server =
(If the server monitors for an open event). This will inevitably cause an i=
nfinite loop of FUSE_OPEN requests and generation of open events on the ser=
ver. One idea was to modify the open syscall (on the host kernel) to allow =
the use of FMODE_NONOTIFY flag from user space (currently it is used intern=
ally in the kernel code only), to be able to suppress open events. However,=
 a malicious guest might be able to exploit that flag to disrupt the event =
generation for a file (I am not entirely sure if this is possible, yet).=C2=
=A0</div><div><br></div><div>To sum up, it seems that the support for fanot=
ify causes some problems that are very difficult to mitigate at the moment.=
 The fanotify file handles mode would probably solve most if not all of the=
 above problems we are facing, however as Vivek pointed out the file handle=
 support in virtiofs/fuse=C2=A0is=C2=A0another project altogether.=C2=A0</d=
iv><div><br></div><div>So we would like to ask you for any suggestions rela=
ted to the aforementioned problems. If there are no &quot;easy&quot; soluti=
ons in sight for these fanotify issues, we=C2=A0would like to at least cont=
inue=C2=A0to support the remote inotify in the next version of the patches =
and try to solve issues around it.</div><div><br></div><div>Thanks,</div><d=
iv>Ioannis=C2=A0</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr"=
 class=3D"gmail_attr">On Tue, Nov 30, 2021 at 10:27 AM Vivek Goyal &lt;<a h=
ref=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a>&gt; wrote:<br></div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">On Wed, Nov 17, 2021 at 0=
8:40:57AM +0200, Amir Goldstein wrote:<br>
&gt; On Wed, Nov 17, 2021 at 12:12 AM Ioannis Angelakopoulos<br>
&gt; &lt;<a href=3D"mailto:iangelak@redhat.com" target=3D"_blank">iangelak@=
redhat.com</a>&gt; wrote:<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt;<br>
&gt; &gt; On Tue, Nov 16, 2021 at 12:10 AM Stef Bon &lt;<a href=3D"mailto:s=
tefbon@gmail.com" target=3D"_blank">stefbon@gmail.com</a>&gt; wrote:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Hi Ioannis,<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; I see that you have been working on making fsnotify work on v=
irtiofs.<br>
&gt; &gt;&gt; Earlier you contacted me since I&#39;ve written this:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; <a href=3D"https://github.com/libfuse/libfuse/wiki/Fsnotify-a=
nd-FUSE" rel=3D"noreferrer" target=3D"_blank">https://github.com/libfuse/li=
bfuse/wiki/Fsnotify-and-FUSE</a><br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; and send you my patches on 23 june.<br>
&gt; &gt;&gt; I want to mention first that I would have appreciated it if y=
ou would<br>
&gt; &gt;&gt; have reacted to me after I&#39;ve sent you my patches. I did =
not get any<br>
&gt; &gt;&gt; reaction from you. Maybe these patches (which differ from wha=
t you<br>
&gt; &gt;&gt; propose now, but there is also a lot in common) have been an<=
br>
&gt; &gt;&gt; inspiration for you.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Second, what I&#39;ve written about is that with network file=
systems (eg a<br>
&gt; &gt;&gt; backend shared with other systems) fsnotify support in FUSE h=
as some<br>
&gt; &gt;&gt; drawbacks.<br>
&gt; &gt;&gt; In a network environment, where a network fs is part of makin=
g people<br>
&gt; &gt;&gt; collaborate, it&#39;s very useful to have information on who =
did what on<br>
&gt; &gt;&gt; which host, and also when. Simply a message &quot;a file has =
been created<br>
&gt; &gt;&gt; in the folder you watch&quot; is not enough. For example, if =
you are part<br>
&gt; &gt;&gt; of a team, and assigned to your team is a directory on a serv=
er where<br>
&gt; &gt;&gt; you can work on some shared documents. Now in this example th=
ere is a<br>
&gt; &gt;&gt; planning, and some documents have to be written. In that case=
 you want<br>
&gt; &gt;&gt; to be informed that someone in your team has started a docume=
nt (by<br>
&gt; &gt;&gt; creating it) by the system.<br>
&gt; &gt;&gt;<br>
&gt; &gt; I agree that the out of band approach you propose is actually mor=
e powerful, since it can<br>
&gt; &gt; provide the client with more information than remote fsnotify. Ho=
wever, in the virtiofs setup<br>
&gt; &gt; your approach might not be as efficient.<br>
&gt; &gt;<br>
&gt; &gt; Specifically, the information on who did what might not make sens=
e to the guest within QEMU, since all the<br>
&gt; &gt; virtiofs filesystem operations are handled by viritofsd on the ho=
st and the guest does not know about the<br>
&gt; &gt; server or any other guests. Vivek, correct me here if I am wrong.=
<br>
&gt; &gt;<br>
&gt; &gt; Thus, for now at least, it might be sufficient for the guest to k=
now that just a remote event<br>
&gt; &gt; occurred.<br>
&gt; &gt;<br>
&gt; &gt;&gt; This &quot;extended&quot; information will never get through =
fsnotify.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Other info useful to you as team member:<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; -=C2=A0 you have become member of another team: <a href=3D"ma=
ilto:sbon@anotherteam.example.org" target=3D"_blank">sbon@anotherteam.examp=
le.org</a><br>
&gt; &gt;&gt; -=C2=A0 diskspace and/or quota shortage reported by networksy=
stem<br>
&gt; &gt;&gt; -=C2=A0 new teammember, teammember left<br>
&gt; &gt;&gt; -=C2=A0 your &quot;rights&quot; or role in the network/team h=
ave been changed (for<br>
&gt; &gt;&gt; example from reader to reader and writer to some documents)<b=
r>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; What I want to say is that in a network where lots of people =
work<br>
&gt; &gt;&gt; together in teams/projects, (and I want Linux to play a role =
there, as<br>
&gt; &gt;&gt; desktop/workstation) communication is very important, and all=
 these<br>
&gt; &gt;&gt; messages should be supported by the system. My idea is the su=
pport of<br>
&gt; &gt;&gt; watching fs events with FUSE filesystems should go through us=
erspace,<br>
&gt; &gt;&gt; and not via the kernel (cause fs events are part of your setu=
p in the<br>
&gt; &gt;&gt; network, together with all other tools to make people collabo=
rate like<br>
&gt; &gt;&gt; chat/call/text, and because mentioned above extended info abo=
ut the<br>
&gt; &gt;&gt; who on what host etc is not supported by fsnotify).<br>
&gt; &gt;&gt; There should be a fs event watcher which takes care of all wa=
tches on<br>
&gt; &gt;&gt; behalf of applications during a session, similar to gamin and=
 FAM once<br>
&gt; &gt;&gt; did (not used anymore?).<br>
&gt; &gt;&gt; When receiving a request from one of the applications this fs=
event<br>
&gt; &gt;&gt; watcher will use inotify and/or fanotify for local fs&#39;s o=
nly. With a<br>
&gt; &gt;&gt; FUSE fs, it should contact (via a socket) this fs that a watc=
h has<br>
&gt; &gt;&gt; been set on an inode with a certain mask.<br>
&gt; &gt;&gt; If the FUSE fs does not support this, fallback on normal inot=
ify/fanotify.<br>
&gt; &gt;&gt; This way extended info is possible.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Is this extended information also useful for virtiofs?<br>
&gt; &gt;&gt;<br>
&gt; &gt; Also based on your explanation, your out of band approach is spec=
ific to FUSE filesystems.<br>
&gt; &gt; Granted, with your approach there is less complexity in the kerne=
l and more flexibility since<br>
&gt; &gt; the event notification occurs solely in user-space.<br>
&gt; &gt; However, during the discussion with Amir and Jan about potential =
routes we could take to support the remote<br>
&gt; &gt; fanotify/inotify/fsnotify one important concern was that the API =
should be able to support other<br>
&gt; &gt; network/remote filesystems if needed and not only FUSE filesystem=
s.<br>
&gt; &gt; It seems that your approach would require a lot of work (correct =
me if I am wrong) to be adopted<br>
&gt; &gt; by other network filesystems.<br>
&gt; &gt;<br>
&gt; &gt; Finally, user-space applications should also be aware of your new=
 API, which will probably result in a non-negligible effort by app develope=
rs to adopt it or change their existing apps. The remote inotify/fsnotify (=
 the current implementation) even though it has many limitations, relies on=
 the existing API and should require less modifications in user space apps.=
 That is why we chose the remote inotify/fsnotify route.<br>
&gt; &gt;<br>
&gt; <br>
&gt; The way you depict the options seems like either applications are not<=
br>
&gt; aware of the UAPI<br>
&gt; changes or they need to be modified to adapt to the changes.<br>
&gt; <br>
&gt; I actually think that the much better approach would be to deal with<b=
r>
&gt; most of the UAPI<br>
&gt; complexity in a library, so applications may need to be rebuilt or<br>
&gt; adapted to use a new<br>
&gt; library, but going forward, the library would abstract most of the<br>
&gt; complexity from the<br>
&gt; applications.<br>
&gt; <br>
&gt; The holy grail would be a portable library, such as this go library [1=
].<br>
&gt; It is quite hard to design an API that would abstract all the<br>
&gt; different capabilities<br>
&gt; on Linux-inotify/Linux-fanotify/MacOS-fsevents/Win-USNJournal and more=
.<br>
&gt; <br>
&gt; The second best would be a library to abstract the ever growing comple=
xity<br>
&gt; of Linux inotify/fanotify UAPI from applications.<br>
&gt; I had already made the first step with adapting libinotifytools to fan=
otify [2].<br>
&gt; We could continue down that path or start creating/improving a<br>
&gt; different library.<br>
&gt; <br>
&gt; The point is that abstracting different capabilities of remote fs noti=
fications<br>
&gt; (i.e. cifs, virtiofs, generic FUSE) is going to be challenging, so sta=
rting the<br>
&gt; design from a user library API and deriving the needed pieces from the=
<br>
&gt; kernel UAPI is the right way to go IMO.<br>
&gt; <br>
&gt; The library approach will have the advantage that some remote fs capab=
ilities<br>
&gt; (e.g. for cifs) will be available for old kernels as well and in<br>
&gt; theory, the library<br>
&gt; could also use some standardized OOB notifications channel to get chan=
ged<br>
&gt; made on the host from VM guest tools as Stef proposed.<br>
&gt; <br>
&gt; &gt; That said, I do not see a reason why both implementations cannot =
co-exist<br>
&gt; &gt; and have the user-space applications choose which approach they w=
ant.<br>
&gt; &gt;<br>
&gt; <br>
&gt; True, an OOB channel and kernel generic remote fs support can both exi=
st,<br>
&gt; but it would be best if the application was not aware of either.<br>
&gt; The library would pick the facility based on the requested functionali=
ty,<br>
&gt; availability of the facilities in the filesystem and sysadmin/user pol=
icy.<br>
<br>
Sure. A library will be nice to abstract kernel generic remote fs and OOB<b=
r>
channel. This sounds like another project for somebody to work on.<br>
<br>
IIUC, it looks like that both the approaches can make progress in<br>
parallel. Advantange of OOB channel approach seems that it will be easier t=
o<br>
make changes in user space and add more events and send extra information.<=
br>
<br>
While advantage of remote fsnotify is that its a known existing events<br>
API and it makes it easier for applications to use same API for remote<br>
fs (however limited it might be).<br>
<br>
Thanks<br>
Vivek<br>
<br>
&gt; Thanks,<br>
&gt; Amir.<br>
&gt; <br>
&gt; [1] <a href=3D"https://github.com/fsnotify/fsnotify" rel=3D"noreferrer=
" target=3D"_blank">https://github.com/fsnotify/fsnotify</a><br>
&gt; [2] <a href=3D"https://github.com/inotify-tools/inotify-tools/pull/134=
" rel=3D"noreferrer" target=3D"_blank">https://github.com/inotify-tools/ino=
tify-tools/pull/134</a><br>
&gt; <br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr">Ioannis Angelakopoulos<div>Soft=
ware Engineer Intern at Red Hat</div></div></div>

--000000000000f15e5c05d32375e2--

