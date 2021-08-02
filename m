MIME-Version: 1.0
References: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
	<YQfKtddIodKSx7NZ@work-vm>
In-Reply-To: <YQfKtddIodKSx7NZ@work-vm>
From: Gal Hammer <ghammer@redhat.com>
Date: Mon, 2 Aug 2021 13:44:19 +0300
Message-ID: <CAA2ifQxv5VE-w5SUBmKeggAhx7VuCH5MEMttJRrF2ej0_6r8Xw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="00000000000009d7fe05c89141ac"
Subject: Re: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com

--00000000000009d7fe05c89141ac
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Aug 2021 at 13:36, Dr. David Alan Gilbert <dgilbert@redhat.com>
wrote:

> * Gal Hammer (ghammer@redhat.com) wrote:
> > Hello,
> >
> > When using NFS as a shared folder (mount type nfs4) with a Linux guest I
> > have the following issue:
> >
> > Guest:
> > $ ls -la /mnt/shared
> > total 8
> > drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
> > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt
> >
> > Host:
> > $ rm readme.txt
> >
> > Guest:
> > $ ls -la /mnt/shared
> > total 8
> > drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
> > dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
> > -rw-r--rw-.  1  135  135   27 Aug  2 13:07 .nfs0000000001b600d000000005
> >
> > Guest:
> > $ cat /mnt/shared/readme.txt
> > This is a readme.txt file.
> >
> > So it seems that the virtiofsd has a reference to the file which the
> guest
> > is not aware of and is unable to send a FUSE_FORGET message. This results
> > in a file not actually deleted (renamed to .nfsXXX) and is still
> accessible
> > by the guest.
> >
> > I have a similar problem when deleting a file from a Windows guest side.
> > The FUSE_READDIR(PLUS) commands add a reference count to files which the
> OS
> > doesn't have a file context for. However I was able to solve it (for
> now?)
> > by keeping track of returned files' inodes.
> >
> > Is this behaviour current and by design?
>
> Current problem, not really by design; the problem is the O_PATH files
> that we have open for the inodes.  I thought if the guest sent the
> forget for the file then it got closed.
>

So if I understand then sending forget message for each inode returned by
readdir won't solve the problem because you need the open files for inodes?

Thanks,

    Gal.


>
> Dave
>
>
> > Thanks,
> >
> >     Gal.
>
> > _______________________________________________
> > Virtio-fs mailing list
> > Virtio-fs@redhat.com
> > https://listman.redhat.com/mailman/listinfo/virtio-fs
>
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
>
>

--00000000000009d7fe05c89141ac
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div class=3D"gmail_default" style=3D"fon=
t-family:verdana,sans-serif"><br></div></div><br><div class=3D"gmail_quote"=
><div dir=3D"ltr" class=3D"gmail_attr">On Mon, 2 Aug 2021 at 13:36, Dr. Dav=
id Alan Gilbert &lt;<a href=3D"mailto:dgilbert@redhat.com">dgilbert@redhat.=
com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"marg=
in:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1e=
x">* Gal Hammer (<a href=3D"mailto:ghammer@redhat.com" target=3D"_blank">gh=
ammer@redhat.com</a>) wrote:<br>
&gt; Hello,<br>
&gt; <br>
&gt; When using NFS as a shared folder (mount type nfs4) with a Linux guest=
 I<br>
&gt; have the following issue:<br>
&gt; <br>
&gt; Guest:<br>
&gt; $ ls -la /mnt/shared<br>
&gt; total 8<br>
&gt; drwxr-xrwx.=C2=A0 2=C2=A0 135=C2=A0 135 4096 Aug=C2=A0 2 13:08 .<br>
&gt; dr-xr-xr-x. 17 root=C2=A0 =C2=A0root=C2=A0 =C2=A0 224 May 23 10:58 ..<=
br>
&gt; -rw-r--rw-.=C2=A0 1=C2=A0 135=C2=A0 135=C2=A0 =C2=A027 Aug=C2=A0 2 13:=
07 readme.txt<br>
&gt; <br>
&gt; Host:<br>
&gt; $ rm readme.txt<br>
&gt; <br>
&gt; Guest:<br>
&gt; $ ls -la /mnt/shared<br>
&gt; total 8<br>
&gt; drwxr-xrwx.=C2=A0 2=C2=A0 135=C2=A0 135 4096 Aug=C2=A0 2 13:10 .<br>
&gt; dr-xr-xr-x. 17 root=C2=A0 =C2=A0root=C2=A0 =C2=A0 224 May 23 10:58 ..<=
br>
&gt; -rw-r--rw-.=C2=A0 1=C2=A0 135=C2=A0 135=C2=A0 =C2=A027 Aug=C2=A0 2 13:=
07 .nfs0000000001b600d000000005<br>
&gt; <br>
&gt; Guest:<br>
&gt; $ cat /mnt/shared/readme.txt<br>
&gt; This is a readme.txt file.<br>
&gt; <br>
&gt; So it seems that the virtiofsd has a reference to the file which the g=
uest<br>
&gt; is not aware of and is unable to send a FUSE_FORGET message. This resu=
lts<br>
&gt; in a file not actually deleted (renamed to .nfsXXX) and is still acces=
sible<br>
&gt; by the guest.<br>
&gt; <br>
&gt; I have a similar problem when deleting a file from a Windows guest sid=
e.<br>
&gt; The FUSE_READDIR(PLUS) commands add a reference count to files which t=
he OS<br>
&gt; doesn&#39;t have a file context for. However I was able to solve it (f=
or now?)<br>
&gt; by keeping track of returned files&#39; inodes.<br>
&gt; <br>
&gt; Is this behaviour current and by design?<br>
<br>
Current problem, not really by design; the problem is the O_PATH files<br>
that we have open for the inodes.=C2=A0 I thought if the guest sent the<br>
forget for the file then it got closed.<br></blockquote><div><br></div><div=
><div style=3D"font-family:verdana,sans-serif" class=3D"gmail_default">So i=
f I understand then sending forget message for each inode returned by readd=
ir won&#39;t solve the problem because you need the open files for inodes?<=
/div></div><div><br></div><div><div style=3D"font-family:verdana,sans-serif=
" class=3D"gmail_default">Thanks,</div><br></div><div><div style=3D"font-fa=
mily:verdana,sans-serif" class=3D"gmail_default">=C2=A0=C2=A0=C2=A0 Gal.</d=
iv>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0p=
x 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
Dave<br>
<br>
<br>
&gt; Thanks,<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0Gal.<br>
<br>
&gt; _______________________________________________<br>
&gt; Virtio-fs mailing list<br>
&gt; <a href=3D"mailto:Virtio-fs@redhat.com" target=3D"_blank">Virtio-fs@re=
dhat.com</a><br>
&gt; <a href=3D"https://listman.redhat.com/mailman/listinfo/virtio-fs" rel=
=3D"noreferrer" target=3D"_blank">https://listman.redhat.com/mailman/listin=
fo/virtio-fs</a><br>
<br>
-- <br>
Dr. David Alan Gilbert / <a href=3D"mailto:dgilbert@redhat.com" target=3D"_=
blank">dgilbert@redhat.com</a> / Manchester, UK<br>
<br>
</blockquote></div></div>

--00000000000009d7fe05c89141ac--

