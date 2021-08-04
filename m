MIME-Version: 1.0
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
	<CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
	<ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
	<CAA2ifQxiTa5nuGc=u00qaeOyXsqpro_gFpjLxpbbHdaoGXYJ-w@mail.gmail.com>
	<854b3e0c-9140-4f9f-93f8-1fe93d061be7@redhat.com>
	<YQhgfZNfgANlrExk@redhat.com>
In-Reply-To: <YQhgfZNfgANlrExk@redhat.com>
From: Gal Hammer <ghammer@redhat.com>
Date: Wed, 4 Aug 2021 12:08:38 +0300
Message-ID: <CAA2ifQwfZKOYCHaaqqHxL1FraEwm3mrNqiUfMTwYr4VvDTHUUQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000a718f705c8b826ec"
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, Max Reitz <mreitz@redhat.com>

--000000000000a718f705c8b826ec
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vivek,

On Tue, 3 Aug 2021 at 00:15, Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Aug 02, 2021 at 06:34:17PM +0200, Max Reitz wrote:
> > On 02.08.21 13:30, Gal Hammer wrote:
> > >
> > >
> > > On Mon, 2 Aug 2021 at 13:49, Max Reitz <mreitz@redhat.com
> > > <mailto:mreitz@redhat.com>> wrote:
> > >
> > >     On 02.08.21 12:44, Gal Hammer wrote:
> > >     >
> > >     >
> > >     > On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert
> > >     > <dgilbert@redhat.com <mailto:dgilbert@redhat.com>
> > >     <mailto:dgilbert@redhat.com <mailto:dgilbert@redhat.com>>> wrote:
> > >     >
> > >     >     * Gal Hammer (ghammer@redhat.com <mailto:ghammer@redhat.com=
>
> > >     <mailto:ghammer@redhat.com <mailto:ghammer@redhat.com>>) wrote:
> > >     >     > Hello,
> > >     >     >
> > >     >     > When using NFS as a shared folder (mount type nfs4) with =
a
> > >     Linux
> > >     >     guest I
> > >     >     > have the following issue:
> > >     >     >
> > >     >     > Guest:
> > >     >     > $ ls -la /mnt/shared
> > >     >     > total 8
> > >     >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
> > >     >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> > >     >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
> > >     >     >
> > >     >     > Host:
> > >     >     > $ rm readme.txt
> > >     >     >
> > >     >     > Guest:
> > >     >     > $ ls -la /mnt/shared
> > >     >     > total 8
> > >     >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
> > >     >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> > >     >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07
> > >     >     .nfs0000000001b600d000000005
> > >     >     >
> > >     >     > Guest:
> > >     >     > $ cat /mnt/shared/readme.txt
> > >     >     > This is a readme.txt file.
> > >     >     >
> > >     >     > So it seems that the virtiofsd has a reference to the fil=
e
> > >     which
> > >     >     the guest
> > >     >     > is not aware of and is unable to send a FUSE_FORGET
> message.
> > >     >     This results
> > >     >     > in a file not actually deleted (renamed to .nfsXXX) and i=
s
> > >     still
> > >     >     accessible
> > >     >     > by the guest.
> > >     >     >
> > >     >     > I have a similar problem when deleting a file from a
> Windows
> > >     >     guest side.
> > >     >     > The FUSE_READDIR(PLUS) commands add a reference count to
> files
> > >     >     which the OS
> > >     >     > doesn't have a file context for. However I was able to
> > >     solve it
> > >     >     (for now?)
> > >     >     > by keeping track of returned files' inodes.
> > >     >     >
> > >     >     > Is this behaviour current and by design?
> > >     >
> > >     >     Current problem, not really by design; the problem is the
> > >     O_PATH files
> > >     >     that we have open for the inodes.  I thought if the guest
> > >     sent the
> > >     >     forget for the file then it got closed.
> > >     >
> > >     >
> > >     > So if I understand then sending forget message for each inode
> > >     returned
> > >     > by readdir won't solve the problem because you need the open
> > >     files for
> > >     > inodes?
> > >
> > >     virtiofsd internally keeps an lo_inode object for every inode tha=
t
> > >     has
> > >     been looked up at some point, and every such lo_inode contains an
> > >     O_PATH
> > >     fd referencing that inode.  I don=E2=80=99t know by heart what th=
e
> conditions
> > >     for dropping those lo_inode objects are.
> > >
> > >
> > > I think it depends on the guest's forget message.
> >
> > Yes, it looks like it.
> >
> > >     However, once it=E2=80=99s possible to use file handles to refere=
nce inodes
> > >     instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd
> there=E2=80=99s
> > >     this series:
> > >
> https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html
> > >     <
> https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html>),
> > >
> > >     then giving the appropriate options (-o inode_file_handles -o
> > >     modcaps=3D+dac_read_search) should result in no O_PATH fds being =
kept
> > >     around anymore, so that deleting an inode on the host will result
> > >     in the
> > >     inode being truly deleted (unless the guest still has it open).
> > >
> > >
> > > Will the guest will still need to send forget messages with this new
> > > feature?
> >
> > I don=E2=80=99t think so.  With file handles, FDs should only be opened=
 (and kept
> > open) when the guest actually opens some file.  (Aside from temporary
> O_PATH
> > FDs e.g. during a lookup.)
>
> I guess FORGET messages will still have to be sent so that virtiofsd can
> free lo_inode() and associated data structrues when reference count
> reaches zero. So FORGET message is more like a dropping guest's reference
> count on lo_inode.
>

I can live with that as long as I won't need to send FORGET messages for
files that the guest didn't open or create.


>
> Gal, I think we had discussed this nfs issue in the past. And problem
> probably is that dentry/inode is cached in guest. And that's why
> lo_inode is around hence O_PATH fd is around. If you do drop caches
> in guest, that might lead to removal of this temp file (sync; echo 3 >
> /proc/sys/vm/drop_caches).
>

Even though I wrote the driver and implemented an inodes' cache, I can't be
sure that Windows or WinFSP (the user-space file system library that I use)
is having some kind of internal cache. Saying that, the problem that I have
is that virtiofsd is increasing its own reference count on READDIR when the
guest doesn't hold a files' context for.

Oh... and I don't have /proc on Windows ;-).


>
> Max, interesting point that using file handles should help with this
> situation.
>
> Vivek
>
>
    Gal.

--000000000000a718f705c8b826ec
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif">Hi Vivek,<br></div></div><br><div class=3D"gma=
il_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, 3 Aug 2021 at 00:15=
, Vivek Goyal &lt;<a href=3D"mailto:vgoyal@redhat.com">vgoyal@redhat.com</a=
>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On =
Mon, Aug 02, 2021 at 06:34:17PM +0200, Max Reitz wrote:<br>
&gt; On 02.08.21 13:30, Gal Hammer wrote:<br>
&gt; &gt; <br>
&gt; &gt; <br>
&gt; &gt; On Mon, 2 Aug 2021 at 13:49, Max Reitz &lt;<a href=3D"mailto:mrei=
tz@redhat.com" target=3D"_blank">mreitz@redhat.com</a><br>
&gt; &gt; &lt;mailto:<a href=3D"mailto:mreitz@redhat.com" target=3D"_blank"=
>mreitz@redhat.com</a>&gt;&gt; wrote:<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0On 02.08.21 12:44, Gal Hammer wrote:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt; On Mon, 2 Aug 2021 at 13:36, Dr. David Al=
an Gilbert<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt; &lt;<a href=3D"mailto:dgilbert@redhat.com=
" target=3D"_blank">dgilbert@redhat.com</a> &lt;mailto:<a href=3D"mailto:dg=
ilbert@redhat.com" target=3D"_blank">dgilbert@redhat.com</a>&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:dgilbert@redhat.c=
om" target=3D"_blank">dgilbert@redhat.com</a> &lt;mailto:<a href=3D"mailto:=
dgilbert@redhat.com" target=3D"_blank">dgilbert@redhat.com</a>&gt;&gt;&gt; =
wrote:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0* Gal Hammer (<a href=
=3D"mailto:ghammer@redhat.com" target=3D"_blank">ghammer@redhat.com</a> &lt=
;mailto:<a href=3D"mailto:ghammer@redhat.com" target=3D"_blank">ghammer@red=
hat.com</a>&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&lt;mailto:<a href=3D"mailto:ghammer@redhat.co=
m" target=3D"_blank">ghammer@redhat.com</a> &lt;mailto:<a href=3D"mailto:gh=
ammer@redhat.com" target=3D"_blank">ghammer@redhat.com</a>&gt;&gt;) wrote:<=
br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Hello,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; When using NFS as=
 a shared folder (mount type nfs4) with a<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0Linux<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0guest I<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; have the followin=
g issue:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ ls -la /mnt/sha=
red<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; total 8<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; drwxr-xrwx.=C2=A0=
 2=C2=A0 135=C2=A0 135 4096 Aug=C2=A0 2 13:08 .<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; dr-xr-xr-x. 17 ro=
ot=C2=A0 =C2=A0root=C2=A0 =C2=A0 224 May 23 10:58 ..<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; -rw-r--rw-.=C2=A0=
 1=C2=A0 135=C2=A0 135=C2=A0 =C2=A027 Aug=C2=A0 2 13:07 readme.txt<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Host:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ rm readme.txt<b=
r>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ ls -la /mnt/sha=
red<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; total 8<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; drwxr-xrwx.=C2=A0=
 2=C2=A0 135=C2=A0 135 4096 Aug=C2=A0 2 13:10 .<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; dr-xr-xr-x. 17 ro=
ot=C2=A0 =C2=A0root=C2=A0 =C2=A0 224 May 23 10:58 ..<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; -rw-r--rw-.=C2=A0=
 1=C2=A0 135=C2=A0 135=C2=A0 =C2=A027 Aug=C2=A0 2 13:07<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0.nfs0000000001b600d000=
000005<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ cat /mnt/shared=
/readme.txt<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; This is a readme.=
txt file.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; So it seems that =
the virtiofsd has a reference to the file<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0which<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0the guest<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; is not aware of a=
nd is unable to send a FUSE_FORGET message.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0This results<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; in a file not act=
ually deleted (renamed to .nfsXXX) and is<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0still<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0accessible<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; by the guest.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; I have a similar =
problem when deleting a file from a Windows<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0guest side.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; The FUSE_READDIR(=
PLUS) commands add a reference count to files<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0which the OS<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; doesn&#39;t have =
a file context for. However I was able to<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0solve it<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0(for now?)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; by keeping track =
of returned files&#39; inodes.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0&gt; Is this behaviour=
 current and by design?<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0Current problem, not r=
eally by design; the problem is the<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0O_PATH files<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0that we have open for =
the inodes.=C2=A0 I thought if the guest<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0sent the<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;=C2=A0 =C2=A0 =C2=A0forget for the file th=
en it got closed.<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt; So if I understand then sending forget me=
ssage for each inode<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0returned<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt; by readdir won&#39;t solve the problem be=
cause you need the open<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0files for<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&gt; inodes?<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0virtiofsd internally keeps an lo_inode object =
for every inode that<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0has<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0been looked up at some point, and every such l=
o_inode contains an<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0O_PATH<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0fd referencing that inode.=C2=A0 I don=E2=80=
=99t know by heart what the conditions<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0for dropping those lo_inode objects are.<br>
&gt; &gt; <br>
&gt; &gt; <br>
&gt; &gt; I think it depends on the guest&#39;s forget message.<br>
&gt; <br>
&gt; Yes, it looks like it.<br>
&gt; <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0However, once it=E2=80=99s possible to use fil=
e handles to reference inodes<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0instead of O_PATH fds (already in virtiofsd-rs=
, for virtiofsd there=E2=80=99s<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0this series:<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0<a href=3D"https://listman.redhat.com/archives=
/virtio-fs/2021-July/msg00050.html" rel=3D"noreferrer" target=3D"_blank">ht=
tps://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html</a><br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0&lt;<a href=3D"https://listman.redhat.com/arch=
ives/virtio-fs/2021-July/msg00050.html" rel=3D"noreferrer" target=3D"_blank=
">https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html</a>=
&gt;),<br>
&gt; &gt; <br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0then giving the appropriate options (-o inode_=
file_handles -o<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0modcaps=3D+dac_read_search) should result in n=
o O_PATH fds being kept<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0around anymore, so that deleting an inode on t=
he host will result<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0in the<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0inode being truly deleted (unless the guest st=
ill has it open).<br>
&gt; &gt; <br>
&gt; &gt; <br>
&gt; &gt; Will the guest will still need to send forget messages with this =
new<br>
&gt; &gt; feature?<br>
&gt; <br>
&gt; I don=E2=80=99t think so.=C2=A0 With file handles, FDs should only be =
opened (and kept<br>
&gt; open) when the guest actually opens some file.=C2=A0 (Aside from tempo=
rary O_PATH<br>
&gt; FDs e.g. during a lookup.)<br>
<br>
I guess FORGET messages will still have to be sent so that virtiofsd can<br=
>
free lo_inode() and associated data structrues when reference count<br>
reaches zero. So FORGET message is more like a dropping guest&#39;s referen=
ce<br>
count on lo_inode.<br></blockquote><div><br></div><div><div style=3D"font-f=
amily:verdana,sans-serif" class=3D"gmail_default">I can live with that as l=
ong as I won&#39;t need to send FORGET messages for files that the guest di=
dn&#39;t open or create.<br></div></div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
<br>
Gal, I think we had discussed this nfs issue in the past. And problem<br>
probably is that dentry/inode is cached in guest. And that&#39;s why<br>
lo_inode is around hence O_PATH fd is around. If you do drop caches<br>
in guest, that might lead to removal of this temp file (sync; echo 3 &gt;<b=
r>
/proc/sys/vm/drop_caches).<br></blockquote><div><br></div><div><div style=
=3D"font-family:verdana,sans-serif" class=3D"gmail_default">Even though I w=
rote the driver and implemented an inodes&#39; cache, I can&#39;t be sure t=
hat Windows or WinFSP (the user-space file system library that I use) is ha=
ving some kind of internal cache. Saying that, the problem that I have is t=
hat virtiofsd is increasing its own reference count on READDIR when the gue=
st doesn&#39;t hold a files&#39; context for.<br></div><div style=3D"font-f=
amily:verdana,sans-serif" class=3D"gmail_default"><br></div><div style=3D"f=
ont-family:verdana,sans-serif" class=3D"gmail_default">Oh... and I don&#39;=
t have /proc on Windows ;-).<br></div></div><div>=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">
<br>
Max, interesting point that using file handles should help with this<br>
situation.<br>
<br>
Vivek<br>
<br></blockquote><div><br></div><div style=3D"font-family:verdana,sans-seri=
f" class=3D"gmail_default">=C2=A0=C2=A0=C2=A0 Gal.</div><div style=3D"font-=
family:verdana,sans-serif" class=3D"gmail_default"></div></div></div>

--000000000000a718f705c8b826ec--

