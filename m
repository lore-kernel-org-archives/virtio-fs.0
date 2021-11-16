MIME-Version: 1.0
References: <20211027132319.GA7873@quack2.suse.cz>
	<YXm2tAMYwFFVR8g/@redhat.com>
	<20211102110931.GD12774@quack2.suse.cz>
	<CAOQ4uxiYQYG8Ta=MNJKpa_0pAPd0MS9PL2r_0ZRD+_TKOw6C7g@mail.gmail.com>
	<20211103100900.GB20482@quack2.suse.cz>
	<CAOQ4uxjsULgLuOFUYkEePySx6iPXRczgCZMxx8E5ncw=oarLPg@mail.gmail.com>
	<YYMO1ip9ynXFXc8f@redhat.com> <20211104100316.GA10060@quack2.suse.cz>
	<YYU/7269JX2neLjz@redhat.com>
	<CAOQ4uxiM_i+6Zs+ewg8mfA5aKs-gY7yj3kdrmPLO8Zn+bz4DbA@mail.gmail.com>
	<20211111173043.GB25491@quack2.suse.cz>
	<CAOQ4uxiOUM6=190w4018w4nJRnqi+9gzzfQTsLh5gGwbQH_HgQ@mail.gmail.com>
	<CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
In-Reply-To: <CANXojcy9JzXeLQ6bz9+UOekkpqo8NkgQbhugmGmPE+x3+_=h3Q@mail.gmail.com>
From: Ioannis Angelakopoulos <iangelak@redhat.com>
Date: Tue, 16 Nov 2021 17:12:08 -0500
Message-ID: <CAO17o21YVczE2-BTAVg-0HJU6gjSUkzUSqJVs9k-_t7mYFNHaA@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000008f5d5705d0ef39f0"
Subject: Re: [Virtio-fs] [RFC PATCH 0/7] Inotify support in FUSE and virtiofs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stef Bon <stefbon@gmail.com>
Cc: Steve French <sfrench@samba.org>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, virtio-fs-list <virtio-fs@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

--0000000000008f5d5705d0ef39f0
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 16, 2021 at 12:10 AM Stef Bon <stefbon@gmail.com> wrote:

> Hi Ioannis,
>
> I see that you have been working on making fsnotify work on virtiofs.
> Earlier you contacted me since I've written this:
>
> https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE
>
> and send you my patches on 23 june.
> I want to mention first that I would have appreciated it if you would
> have reacted to me after I've sent you my patches. I did not get any
> reaction from you. Maybe these patches (which differ from what you
> propose now, but there is also a lot in common) have been an
> inspiration for you.
>
> Second, what I've written about is that with network filesystems (eg a
> backend shared with other systems) fsnotify support in FUSE has some
> drawbacks.
> In a network environment, where a network fs is part of making people
> collaborate, it's very useful to have information on who did what on
> which host, and also when. Simply a message "a file has been created
> in the folder you watch" is not enough. For example, if you are part
> of a team, and assigned to your team is a directory on a server where
> you can work on some shared documents. Now in this example there is a
> planning, and some documents have to be written. In that case you want
> to be informed that someone in your team has started a document (by
> creating it) by the system.
>
> I agree that the out of band approach you propose is actually more
powerful, since it can
provide the client with more information than remote fsnotify. However, in
the virtiofs setup
your approach might not be as efficient.

Specifically, the information on who did what might not make sense to the
guest within QEMU, since all the
virtiofs filesystem operations are handled by viritofsd on the host and the
guest does not know about the
server or any other guests. Vivek, correct me here if I am wrong.

Thus, for now at least, it might be sufficient for the guest to know that
just a remote event
occurred.

This "extended" information will never get through fsnotify.
>
> Other info useful to you as team member:
>
> -  you have become member of another team: sbon@anotherteam.example.org
> -  diskspace and/or quota shortage reported by networksystem
> -  new teammember, teammember left
> -  your "rights" or role in the network/team have been changed (for
> example from reader to reader and writer to some documents)
>
> What I want to say is that in a network where lots of people work
> together in teams/projects, (and I want Linux to play a role there, as
> desktop/workstation) communication is very important, and all these
> messages should be supported by the system. My idea is the support of
> watching fs events with FUSE filesystems should go through userspace,
> and not via the kernel (cause fs events are part of your setup in the
> network, together with all other tools to make people collaborate like
> chat/call/text, and because mentioned above extended info about the
> who on what host etc is not supported by fsnotify).
> There should be a fs event watcher which takes care of all watches on
> behalf of applications during a session, similar to gamin and FAM once
> did (not used anymore?).
> When receiving a request from one of the applications this fsevent
> watcher will use inotify and/or fanotify for local fs's only. With a
> FUSE fs, it should contact (via a socket) this fs that a watch has
> been set on an inode with a certain mask.
> If the FUSE fs does not support this, fallback on normal inotify/fanotify.
> This way extended info is possible.
>
> Is this extended information also useful for virtiofs?
>
> Also based on your explanation, your out of band approach is specific to
FUSE filesystems.
Granted, with your approach there is less complexity in the kernel and more
flexibility since
the event notification occurs solely in user-space.
However, during the discussion with Amir and Jan about potential routes we
could take to support the remote
fanotify/inotify/fsnotify one important concern was that the API should be
able to support other
network/remote filesystems if needed and not only FUSE filesystems.
It seems that your approach would require a lot of work (correct me if I am
wrong) to be adopted
by other network filesystems.

Finally, user-space applications should also be aware of your new
API, which will probably result in a non-negligible effort by
app developers to adopt it or change their existing apps. The remote
inotify/fsnotify ( the current implementation) even though it has many
limitations, relies on the existing API and should require less
modifications in user space apps. That is why we chose the remote
inotify/fsnotify route.

That said, I do not see a reason why both implementations cannot co-exist
and have the user-space applications choose which approach they want.

Thanks,
Ioannis

> Stef Bon
>
>

-- 
Ioannis Angelakopoulos
Software Engineer Intern at Red Hat

--0000000000008f5d5705d0ef39f0
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Tue, Nov 16, 2021 at 12:10 AM Stef=
 Bon &lt;<a href=3D"mailto:stefbon@gmail.com" target=3D"_blank">stefbon@gma=
il.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"m=
argin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left=
:1ex">Hi Ioannis,<br>
<br>
I see that you have been working on making fsnotify work on virtiofs.<br>
Earlier you contacted me since I&#39;ve written this:<br>
<br>
<a href=3D"https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/libfuse/libfuse/wiki/F=
snotify-and-FUSE</a><br>
<br>
and send you my patches on 23 june.<br>
I want to mention first that I would have appreciated it if you would<br>
have reacted to me after I&#39;ve sent you my patches. I did not get any<br=
>
reaction from you. Maybe these patches (which differ from what you<br>
propose now, but there is also a lot in common) have been an<br>
inspiration for you.<br>
<br>
Second, what I&#39;ve written about is that with network filesystems (eg a<=
br>
backend shared with other systems) fsnotify support in FUSE has some<br>
drawbacks.<br>
In a network environment, where a network fs is part of making people<br>
collaborate, it&#39;s very useful to have information on who did what on<br=
>
which host, and also when. Simply a message &quot;a file has been created<b=
r>
in the folder you watch&quot; is not enough. For example, if you are part<b=
r>
of a team, and assigned to your team is a directory on a server where<br>
you can work on some shared documents. Now in this example there is a<br>
planning, and some documents have to be written. In that case you want<br>
to be informed that someone in your team has started a document (by<br>
creating it) by the system.<br>
<br></blockquote><div>I agree that the out of band approach you propose is =
actually more powerful, since it can</div><div>provide the client with more=
 information than remote fsnotify. However, in the virtiofs=C2=A0setup=C2=
=A0</div><div>your approach might not be as=C2=A0efficient.</div><div><br><=
/div><div>Specifically, the information on who did what might not make sens=
e to the guest within QEMU, since all the</div><div>virtiofs=C2=A0filesyste=
m operations are handled by viritofsd on the host and the guest does not kn=
ow about the</div><div>server or any other guests. Vivek,=C2=A0correct me h=
ere if I am wrong.</div><div><br></div><div>Thus, for now at least, it migh=
t be sufficient for the guest to know that just a remote event</div><div>oc=
curred.=C2=A0</div><div><br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
This &quot;extended&quot; information will never get through fsnotify.<br>
<br>
Other info useful to you as team member:<br>
<br>
-=C2=A0 you have become member of another team: <a href=3D"mailto:sbon@anot=
herteam.example.org" target=3D"_blank">sbon@anotherteam.example.org</a><br>
-=C2=A0 diskspace and/or quota shortage reported by networksystem<br>
-=C2=A0 new teammember, teammember left<br>
-=C2=A0 your &quot;rights&quot; or role in the network/team have been chang=
ed (for<br>
example from reader to reader and writer to some documents)<br>
<br>
What I want to say is that in a network where lots of people work<br>
together in teams/projects, (and I want Linux to play a role there, as<br>
desktop/workstation) communication is very important, and all these<br>
messages should be supported by the system. My idea is the support of<br>
watching fs events with FUSE filesystems should go through userspace,<br>
and not via the kernel (cause fs events are part of your setup in the<br>
network, together with all other tools to make people collaborate like<br>
chat/call/text, and because mentioned above extended info about the<br>
who on what host etc is not supported by fsnotify).<br>
There should be a fs event watcher which takes care of all watches on<br>
behalf of applications during a session, similar to gamin and FAM once<br>
did (not used anymore?).<br>
When receiving a request from one of the applications this fsevent<br>
watcher will use inotify and/or fanotify for local fs&#39;s only. With a<br=
>
FUSE fs, it should contact (via a socket) this fs that a watch has<br>
been set on an inode with a certain mask.<br>
If the FUSE fs does not support this, fallback on normal inotify/fanotify.<=
br>
This way extended info is possible.<br>
<br>
Is this extended information also useful for virtiofs?<br>
<br></blockquote><div>Also based on your explanation, your out of band appr=
oach is specific to FUSE filesystems.</div><div>Granted, with your approach=
 there is less complexity in the kernel and more flexibility since=C2=A0</d=
iv><div>the event notification occurs solely in user-space.</div><div>Howev=
er, during the discussion with Amir and Jan about potential routes we could=
 take to support the remote=C2=A0</div><div>fanotify/inotify/fsnotify one i=
mportant concern was that the API should be able to support other</div><div=
>network/remote filesystems if needed and not only FUSE filesystems.</div><=
div>It seems that your approach would require a lot of work (correct me if =
I am wrong) to be adopted</div><div>by other network filesystems.</div><div=
><br></div><div>Finally, user-space applications should also be aware of yo=
ur new API,=C2=A0which will probably result in a non-negligible effort by a=
pp=C2=A0developers to=C2=A0adopt it or change their existing apps. The remo=
te inotify/fsnotify ( the current implementation) even though it has many l=
imitations, relies on the existing API and should require less modification=
s in user space apps. That is why we chose the remote inotify/fsnotify rout=
e.</div><div><br></div><div>That said, I do not see a reason why both imple=
mentations cannot co-exist and have the user-space applications choose whic=
h approach they want.=C2=A0</div><div>=C2=A0</div><div>Thanks,</div><div>Io=
annis</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Stef Bon<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
><div dir=3D"ltr">Ioannis Angelakopoulos<div>Software Engineer Intern at Re=
d Hat</div></div></div></div>

--0000000000008f5d5705d0ef39f0--

