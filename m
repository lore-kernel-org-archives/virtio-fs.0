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
Date: Tue, 16 Nov 2021 13:00:46 -0500
Message-ID: <CAO17o22E6T62H316+XTZtpzM9y72i3EOSdOrSVwuBcdRjRCL=w@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000009692ba05d0ebb66b"
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

--0000000000009692ba05d0ebb66b
Content-Type: text/plain; charset="UTF-8"

Hi Stef,

I am terribly sorry, I should have mentioned you and your contribution in
the cover letter for the patches. It was not intentional, but a mistake
from my part and I take full responsibility for it. I am very new to this
whole process and I make a lot of mistakes.

You are correct, we have been in contact with you in the past about your
"Fsnotify-and-FUSE" post
https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE
and you also kindly provided your initial patches for FUSE fsnotify and
shared some concerns/limitations of the implementation with us. We also
have stumbled upon these limitations during our implementation and
discussed them in these patch series. You also informed us then that you
were already working on an out of band notification approach.

Both the Wiki and patches have been a big inspiration for our own RFC
patches, especially in the case where we have to decide which data we
should transmit between the FUSE server (virtiofsd) and client (QEMU
guest).
I do not have an official/public link to cite your patches here so you can
reply to this email if you want and post a link to your patches.

To support inotify/fsnotify in virtiofs we had to take a slightly different
implementation route, albeit with many limitations. Our main goal with
the RFC patches was to get insights from the kernel developers on how to
proceed with our project. Our implementation will change further based on
what Amir and Jan have already proposed.

I am sorry again for not giving you the credit you deserve.

Thanks,
Ioannis

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
> This "extended" information will never get through fsnotify.
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
> Stef Bon
>
>

-- 
Ioannis Angelakopoulos
Software Engineer Intern at Red Hat

--0000000000009692ba05d0ebb66b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Stef,<div><br></div><div>I am terribly sorry, I should =
have mentioned you and your contribution in the cover letter for the patche=
s. It was not intentional, but a mistake from my part and I take full=C2=A0=
responsibility for it. I am very new to this whole process and I make a lot=
 of mistakes.</div><div><br></div><div>You are correct, we have been in con=
tact with you in the past about your &quot;Fsnotify-and-FUSE&quot; post=C2=
=A0<br><a href=3D"https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FUSE=
" target=3D"_blank">https://github.com/libfuse/libfuse/wiki/Fsnotify-and-FU=
SE</a></div><div>and you also kindly provided your initial patches for FUSE=
 fsnotify and shared some concerns/limitations of the implementation with u=
s. We also have stumbled upon these limitations during our implementation a=
nd discussed them in these patch series. You also informed us then that you=
 were already working on an out of band notification approach.</div><div>=
=C2=A0=C2=A0</div><div>Both the Wiki and patches have been a big inspiratio=
n for our own RFC patches, especially in the case where we=C2=A0have to dec=
ide which data we should transmit between the FUSE server (virtiofsd) and c=
lient (QEMU guest).=C2=A0</div><div>I do not have an official/public link t=
o cite your patches here so you can reply to this email if you want and pos=
t a link to your patches.</div><div><br></div><div>To support inotify/fsnot=
ify in virtiofs we had to take a slightly different implementation route, a=
lbeit with many limitations. Our main goal with the=C2=A0RFC patches was to=
 get insights from the kernel=C2=A0developers on how to proceed with our pr=
oject. Our implementation will change further based on what Amir and Jan ha=
ve already proposed.<br></div><div><br></div><div>I am sorry again for not =
giving you the credit you deserve.</div><div><br></div><div>Thanks,</div><d=
iv>Ioannis</div></div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=
=3D"gmail_attr">On Tue, Nov 16, 2021 at 12:10 AM Stef Bon &lt;<a href=3D"ma=
ilto:stefbon@gmail.com">stefbon@gmail.com</a>&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex">Hi Ioannis,<br>
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
<br>
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
<br>
Stef Bon<br>
<br>
</blockquote></div><br clear=3D"all"><div><br></div>-- <br><div dir=3D"ltr"=
 class=3D"gmail_signature"><div dir=3D"ltr">Ioannis Angelakopoulos<div>Soft=
ware Engineer Intern at Red Hat</div></div></div>

--0000000000009692ba05d0ebb66b--

