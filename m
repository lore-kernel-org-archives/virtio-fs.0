MIME-Version: 1.0
References: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
	<Yafy7hF56oPn9h4/@redhat.com>
In-Reply-To: <Yafy7hF56oPn9h4/@redhat.com>
From: German Maglione <gmaglione@redhat.com>
Date: Thu, 2 Dec 2021 16:03:20 +0100
Message-ID: <CAJh=p+6RYEHVCVdqFg8+zZJ=bBy_De7v=-mCqa5k5_g0qih1gg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000814c8405d22b1966"
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

--000000000000814c8405d22b1966
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 1, 2021 at 11:10 PM Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione wrote:
> > Hi,
> >
> > I was working on [1] (related to [2]), and I saw that both versions
> > (C and rust) of virtiofsd make the NFs client to "silly rename" an open
> > file that were unlinked, because we keep each file open as O_PATH in the
> > lo_do_lookup/do_lookup function. David pointed me to this problem, and I
> > confirmed that this is the case.
> >
> > This fires the silly rename in the nfs client. I'm talking with
> > Bruce Fields (nfs team) to see how to move the silly rename functionality
> > to the nfs server and outside the directory tree [4], to avoid having
> > non-really-empty
> > dirs full of .nfsxxx files. But it is not an easy task.
> > Also, this will not solve some potential issues with the resource usage:
> > disk space and open file limits (I hit this limit a couple of times
> during
> > my
> > tests). And, in some cases could be worst, more than one guest sharing
> the
> > same
> > exported dir, one guest just 'ls' or 'find' while the other 'rm' some
> files.
> > (The 'find' command will open all files, btw)
> >
> > Vivek, I saw in [5] that you mentioned that this could be fixed
> introducing
> > synchronous, could you elaborate a bit or point me to some code?
>
> Hi German,
>
> Right now forget messages are asynchronous. They are sent to server and
> client does not wait for any reply. That means when unlink() returns,
> it is possible that a FORGET message is in progress and has not finished
> yet.
>
> Idea behind synchronous FORGET messages is that it will generate a reply
> and client will wait for it. Given inode on server should be gone,
> I am not sure how much sense does it make. But anyway conceputaully
> that's the idea. If we want for FORGET message to finish, that will
> mean that O_PATH fd opened by virtiofsd is closed and we will not
> have NFS silly rename issue (atleast due to virtiofsd). If virtiofs
> client has file open, then issue will still happen.
>
> I think using file handles in virtiofsd_rs (--inode-file-handles) is
> a reasonable solution for this problem. Trying to add synchronous
> FORGET might be overkill.
>
>
Hi Vivek,

Yes, as you said the solution is using --inode-file-hanldes, turns out
the problem was the --inode-file-handles failed silently when
choosing a sandbox other than namespace (now fixed by Hanna).

So now the thing is, what we do if it fails? Hanna posted an Issue about
that:
"[RFE] Reporting failure to generate file handles".

There is any problem to use file handles as default? I mean without
--inode-file-handles so let them fail and force the user to use something
like
--no-file-handles/--force-no-file-handles with a warning.


-- 
German

--000000000000814c8405d22b1966
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">On Wed, Dec 1, 2021 at 11:10 PM Vivek=
 Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com" target=3D"_blank">vgoyal@re=
dhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-le=
ft:1ex">On Wed, Dec 01, 2021 at 01:06:23PM +0100, German Maglione wrote:<br=
>
&gt; Hi,<br>
&gt; <br>
&gt; I was working on [1] (related to [2]), and I saw that both versions<br=
>
&gt; (C and rust) of virtiofsd make the NFs client to &quot;silly rename&qu=
ot; an open<br>
&gt; file that were unlinked, because we keep each file open as O_PATH in t=
he<br>
&gt; lo_do_lookup/do_lookup function. David pointed me to this problem, and=
 I<br>
&gt; confirmed that this is the case.<br>
&gt; <br>
&gt; This fires the silly rename in the nfs client. I&#39;m talking with<br=
>
&gt; Bruce Fields (nfs team) to see how to move the silly rename functional=
ity<br>
&gt; to the nfs server and outside the directory tree [4], to avoid having<=
br>
&gt; non-really-empty<br>
&gt; dirs full of .nfsxxx files. But it is not an easy task.<br>
&gt; Also, this will not solve some potential issues with the resource usag=
e:<br>
&gt; disk space and open file limits (I hit this limit a couple of times du=
ring<br>
&gt; my<br>
&gt; tests). And, in some cases could be worst, more than one guest sharing=
 the<br>
&gt; same<br>
&gt; exported dir, one guest just &#39;ls&#39; or &#39;find&#39; while the =
other &#39;rm&#39; some files.<br>
&gt; (The &#39;find&#39; command will open all files, btw)<br>
&gt; <br>
&gt; Vivek, I saw in [5] that you mentioned that this could be fixed introd=
ucing<br>
&gt; synchronous, could you elaborate a bit or point me to some code?<br>
<br>
Hi German,<br>
<br>
Right now forget messages are asynchronous. They are sent to server and<br>
client does not wait for any reply. That means when unlink() returns,<br>
it is possible that a FORGET message is in progress and has not finished<br=
>
yet.<br>
<br>
Idea behind synchronous FORGET messages is that it will generate a reply<br=
>
and client will wait for it. Given inode on server should be gone,<br>
I am not sure how much sense does it make. But anyway conceputaully<br>
that&#39;s the idea. If we want for FORGET message to finish, that will<br>
mean that O_PATH fd opened by virtiofsd is closed and we will not<br>
have NFS silly rename issue (atleast due to virtiofsd). If virtiofs<br>
client has file open, then issue will still happen.<br>
<br>
I think using file handles in virtiofsd_rs (--inode-file-handles) is<br>
a reasonable solution for this problem. Trying to add synchronous<br>
FORGET might be overkill.<br>
<br></blockquote><div><br></div><div>Hi Vivek,</div><div><br></div>Yes, as =
you said the solution is using --inode-file-hanldes, turns out</div><div cl=
ass=3D"gmail_quote">the problem was the --inode-file-handles failed silentl=
y when<br></div><div class=3D"gmail_quote">choosing a sandbox other than na=
mespace (now fixed by Hanna).</div><div class=3D"gmail_quote"><br></div><di=
v class=3D"gmail_quote">So now the thing is, what we do if it fails? Hanna =
posted an Issue about that:</div><div class=3D"gmail_quote">&quot;[RFE] Rep=
orting failure to generate file handles&quot;.</div><div class=3D"gmail_quo=
te"><br></div><div>There is any problem to use file handles as default? I m=
ean without <br></div><div>--inode-file-handles so let them fail and force =
the user to use something like</div><div> --no-file-handles/--force-no-file=
-handles with a warning.<br></div><div><br></div><div><br></div><div>-- <br=
><div dir=3D"ltr"><div dir=3D"ltr">German<br></div></div></div></div>

--000000000000814c8405d22b1966--

