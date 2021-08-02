MIME-Version: 1.0
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
	<CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
	<ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
In-Reply-To: <ee1653e6-dac1-916d-dfd8-3a5271aac79f@redhat.com>
From: Gal Hammer <ghammer@redhat.com>
Date: Mon, 2 Aug 2021 14:30:22 +0300
Message-ID: <CAA2ifQxiTa5nuGc=u00qaeOyXsqpro_gFpjLxpbbHdaoGXYJ-w@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000c329e205c891e5fe"
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs@redhat.com

--000000000000c329e205c891e5fe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Aug 2021 at 13:49, Max Reitz <mreitz@redhat.com> wrote:

> On 02.08.21 12:44, Gal Hammer wrote:
> >
> >
> > On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert
> > <dgilbert@redhat.com <mailto:dgilbert@redhat.com>> wrote:
> >
> >     * Gal Hammer (ghammer@redhat.com <mailto:ghammer@redhat.com>) wrote=
:
> >     > Hello,
> >     >
> >     > When using NFS as a shared folder (mount type nfs4) with a Linux
> >     guest I
> >     > have the following issue:
> >     >
> >     > Guest:
> >     > $ ls -la /mnt/shared
> >     > total 8
> >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
> >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
> >     >
> >     > Host:
> >     > $ rm readme.txt
> >     >
> >     > Guest:
> >     > $ ls -la /mnt/shared
> >     > total 8
> >     > drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
> >     > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> >     > -rw-r--rw-.  1  135  135   27 Aug  2 13:07
> >     .nfs0000000001b600d000000005
> >     >
> >     > Guest:
> >     > $ cat /mnt/shared/readme.txt
> >     > This is a readme.txt file.
> >     >
> >     > So it seems that the virtiofsd has a reference to the file which
> >     the guest
> >     > is not aware of and is unable to send a FUSE_FORGET message.
> >     This results
> >     > in a file not actually deleted (renamed to .nfsXXX) and is still
> >     accessible
> >     > by the guest.
> >     >
> >     > I have a similar problem when deleting a file from a Windows
> >     guest side.
> >     > The FUSE_READDIR(PLUS) commands add a reference count to files
> >     which the OS
> >     > doesn't have a file context for. However I was able to solve it
> >     (for now?)
> >     > by keeping track of returned files' inodes.
> >     >
> >     > Is this behaviour current and by design?
> >
> >     Current problem, not really by design; the problem is the O_PATH
> files
> >     that we have open for the inodes.  I thought if the guest sent the
> >     forget for the file then it got closed.
> >
> >
> > So if I understand then sending forget message for each inode returned
> > by readdir won't solve the problem because you need the open files for
> > inodes?
>
> virtiofsd internally keeps an lo_inode object for every inode that has
> been looked up at some point, and every such lo_inode contains an O_PATH
> fd referencing that inode.  I don=E2=80=99t know by heart what the condit=
ions
> for dropping those lo_inode objects are.
>

I think it depends on the guest's forget message.


> However, once it=E2=80=99s possible to use file handles to reference inod=
es
> instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd there=E2=80=
=99s
> this series:
> https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050.html),
> then giving the appropriate options (-o inode_file_handles -o
> modcaps=3D+dac_read_search) should result in no O_PATH fds being kept
> around anymore, so that deleting an inode on the host will result in the
> inode being truly deleted (unless the guest still has it open).
>

Will the guest will still need to send forget messages with this new
feature?


>
> But with O_PATH fds, it=E2=80=99s kind of by design, I would say.
>

Thanks for the clarification.

    Gal.


>
> Max
>
>

--000000000000c329e205c891e5fe
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif"><br></div></div><br><div class=3D"gmail_quote"=
><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 2 Aug 2021 at 13:49, Max Rei=
tz &lt;<a href=3D"mailto:mreitz@redhat.com">mreitz@redhat.com</a>&gt; wrote=
:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On 02.08.21 12=
:44, Gal Hammer wrote:<br>
&gt;<br>
&gt;<br>
&gt; On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert <br>
&gt; &lt;<a href=3D"mailto:dgilbert@redhat.com" target=3D"_blank">dgilbert@=
redhat.com</a> &lt;mailto:<a href=3D"mailto:dgilbert@redhat.com" target=3D"=
_blank">dgilbert@redhat.com</a>&gt;&gt; wrote:<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0* Gal Hammer (<a href=3D"mailto:ghammer@redhat.com"=
 target=3D"_blank">ghammer@redhat.com</a> &lt;mailto:<a href=3D"mailto:gham=
mer@redhat.com" target=3D"_blank">ghammer@redhat.com</a>&gt;) wrote:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Hello,<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; When using NFS as a shared folder (mount type =
nfs4) with a Linux<br>
&gt;=C2=A0 =C2=A0 =C2=A0guest I<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; have the following issue:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ ls -la /mnt/shared<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; total 8<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; drwxr-xrwx.=C2=A0 2=C2=A0 135=C2=A0 135 4096 A=
ug=C2=A0 2 13:08 .<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; dr-xr-xr-x. 17 root=C2=A0 =C2=A0root=C2=A0 =C2=
=A0 224 May 23 10:58 ..<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -rw-r--rw-.=C2=A0 1=C2=A0 135=C2=A0 135=C2=A0 =
=C2=A027 Aug=C2=A0 2 13:07 readme.txt<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Host:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ rm readme.txt<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ ls -la /mnt/shared<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; total 8<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; drwxr-xrwx.=C2=A0 2=C2=A0 135=C2=A0 135 4096 A=
ug=C2=A0 2 13:10 .<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; dr-xr-xr-x. 17 root=C2=A0 =C2=A0root=C2=A0 =C2=
=A0 224 May 23 10:58 ..<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; -rw-r--rw-.=C2=A0 1=C2=A0 135=C2=A0 135=C2=A0 =
=C2=A027 Aug=C2=A0 2 13:07<br>
&gt;=C2=A0 =C2=A0 =C2=A0.nfs0000000001b600d000000005<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Guest:<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; $ cat /mnt/shared/readme.txt<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; This is a readme.txt file.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; So it seems that the virtiofsd has a reference=
 to the file which<br>
&gt;=C2=A0 =C2=A0 =C2=A0the guest<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; is not aware of and is unable to send a FUSE_F=
ORGET message.<br>
&gt;=C2=A0 =C2=A0 =C2=A0This results<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; in a file not actually deleted (renamed to .nf=
sXXX) and is still<br>
&gt;=C2=A0 =C2=A0 =C2=A0accessible<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; by the guest.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; I have a similar problem when deleting a file =
from a Windows<br>
&gt;=C2=A0 =C2=A0 =C2=A0guest side.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; The FUSE_READDIR(PLUS) commands add a referenc=
e count to files<br>
&gt;=C2=A0 =C2=A0 =C2=A0which the OS<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; doesn&#39;t have a file context for. However I=
 was able to solve it<br>
&gt;=C2=A0 =C2=A0 =C2=A0(for now?)<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; by keeping track of returned files&#39; inodes=
.<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0&gt; Is this behaviour current and by design?<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0Current problem, not really by design; the problem =
is the O_PATH files<br>
&gt;=C2=A0 =C2=A0 =C2=A0that we have open for the inodes.=C2=A0 I thought i=
f the guest sent the<br>
&gt;=C2=A0 =C2=A0 =C2=A0forget for the file then it got closed.<br>
&gt;<br>
&gt;<br>
&gt; So if I understand then sending forget message for each inode returned=
 <br>
&gt; by readdir won&#39;t solve the problem because you need the open files=
 for <br>
&gt; inodes?<br>
<br>
virtiofsd internally keeps an lo_inode object for every inode that has <br>
been looked up at some point, and every such lo_inode contains an O_PATH <b=
r>
fd referencing that inode.=C2=A0 I don=E2=80=99t know by heart what the con=
ditions <br>
for dropping those lo_inode objects are.<br></blockquote><div><br></div><di=
v><div style=3D"font-family:verdana,sans-serif" class=3D"gmail_default">I t=
hink it depends on the guest&#39;s forget message.<br></div></div><div>=C2=
=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8e=
x;border-left:1px solid rgb(204,204,204);padding-left:1ex">
However, once it=E2=80=99s possible to use file handles to reference inodes=
 <br>
instead of O_PATH fds (already in virtiofsd-rs, for virtiofsd there=E2=80=
=99s <br>
this series: <br>
<a href=3D"https://listman.redhat.com/archives/virtio-fs/2021-July/msg00050=
.html" rel=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/arch=
ives/virtio-fs/2021-July/msg00050.html</a>), <br>
then giving the appropriate options (-o inode_file_handles -o <br>
modcaps=3D+dac_read_search) should result in no O_PATH fds being kept <br>
around anymore, so that deleting an inode on the host will result in the <b=
r>
inode being truly deleted (unless the guest still has it open).<br></blockq=
uote><div><br></div><div><div style=3D"font-family:verdana,sans-serif" clas=
s=3D"gmail_default">Will the guest will still need to send forget messages =
with this new feature?</div></div><div>=C2=A0</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">
<br>
But with O_PATH fds, it=E2=80=99s kind of by design, I would say.<br></bloc=
kquote><div><br></div><div><div style=3D"font-family:verdana,sans-serif" cl=
ass=3D"gmail_default">Thanks for the clarification.</div><div style=3D"font=
-family:verdana,sans-serif" class=3D"gmail_default"><br></div><div style=3D=
"font-family:verdana,sans-serif" class=3D"gmail_default">=C2=A0=C2=A0=C2=A0=
 Gal.</div></div><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">
<br>
Max<br>
<br>
</blockquote></div></div>

--000000000000c329e205c891e5fe--

