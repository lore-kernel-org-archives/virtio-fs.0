MIME-Version: 1.0
From: Gal Hammer <ghammer@redhat.com>
Date: Mon, 2 Aug 2021 13:18:13 +0300
Message-ID: <CAA2ifQwwtNQwChMKUSM=6B+XEtdcf+Y--a0OxSwE2pmnd+6TAg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000b589e305c890e368"
Subject: [Virtio-fs] Deleting files when using NFS as a shared folder
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000b589e305c890e368
Content-Type: text/plain; charset="UTF-8"

Hello,

When using NFS as a shared folder (mount type nfs4) with a Linux guest I
have the following issue:

Guest:
$ ls -la /mnt/shared
total 8
drwxr-xrwx.  2  135  135 4096 Aug  2 13:08 .
dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
-rw-r--rw-.  1  135  135   27 Aug  2 13:07 readme.txt

Host:
$ rm readme.txt

Guest:
$ ls -la /mnt/shared
total 8
drwxr-xrwx.  2  135  135 4096 Aug  2 13:10 .
dr-xr-xr-x. 17 root   root    224 May 23 10:58 ..
-rw-r--rw-.  1  135  135   27 Aug  2 13:07 .nfs0000000001b600d000000005

Guest:
$ cat /mnt/shared/readme.txt
This is a readme.txt file.

So it seems that the virtiofsd has a reference to the file which the guest
is not aware of and is unable to send a FUSE_FORGET message. This results
in a file not actually deleted (renamed to .nfsXXX) and is still accessible
by the guest.

I have a similar problem when deleting a file from a Windows guest side.
The FUSE_READDIR(PLUS) commands add a reference count to files which the OS
doesn't have a file context for. However I was able to solve it (for now?)
by keeping track of returned files' inodes.

Is this behaviour current and by design?

Thanks,

    Gal.

--000000000000b589e305c890e368
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-family:verdana,=
sans-serif">Hello,</div><div class=3D"gmail_default" style=3D"font-family:v=
erdana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fam=
ily:verdana,sans-serif">When using NFS as a shared folder (mount type nfs4)=
 with a Linux guest I have the following issue:</div><div class=3D"gmail_de=
fault" style=3D"font-family:verdana,sans-serif"><br></div><div class=3D"gma=
il_default" style=3D"font-family:verdana,sans-serif">Guest:</div><div class=
=3D"gmail_default" style=3D"font-family:verdana,sans-serif">$ ls -la /mnt/s=
hared</div><div class=3D"gmail_default" style=3D"font-family:verdana,sans-s=
erif">total 8<br>drwxr-xrwx. =C2=A02 =C2=A0135=C2=A0 135 4096 Aug =C2=A02 1=
3:08 .<br>dr-xr-xr-x. 17 root =C2=A0 root =C2=A0 =C2=A0224 May 23 10:58 ..<=
br>-rw-r--rw-. =C2=A01 =C2=A0135=C2=A0 135 =C2=A0 27 Aug =C2=A02 13:07 read=
me.txt</div><div class=3D"gmail_default" style=3D"font-family:verdana,sans-=
serif"><br></div><div class=3D"gmail_default" style=3D"font-family:verdana,=
sans-serif">Host:</div><div class=3D"gmail_default" style=3D"font-family:ve=
rdana,sans-serif">$ rm readme.txt</div><div class=3D"gmail_default" style=
=3D"font-family:verdana,sans-serif"><br></div><div class=3D"gmail_default" =
style=3D"font-family:verdana,sans-serif">Guest: <br></div><div class=3D"gma=
il_default" style=3D"font-family:verdana,sans-serif"></div><div class=3D"gm=
ail_default" style=3D"font-family:verdana,sans-serif"></div><div class=3D"g=
mail_default" style=3D"font-family:verdana,sans-serif">$ ls -la /mnt/shared=
</div><div class=3D"gmail_default" style=3D"font-family:verdana,sans-serif"=
>total 8<br></div><div class=3D"gmail_default" style=3D"font-family:verdana=
,sans-serif">drwxr-xrwx. =C2=A02 =C2=A0135=C2=A0 135 4096 Aug =C2=A02 13:10=
 .<br>dr-xr-xr-x. 17 root =C2=A0 root =C2=A0 =C2=A0224 May 23 10:58 ..<br>-=
rw-r--rw-. =C2=A01 =C2=A0135=C2=A0 135 =C2=A0 27 Aug =C2=A02 13:07 .nfs0000=
000001b600d000000005<br></div><div class=3D"gmail_default" style=3D"font-fa=
mily:verdana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"fo=
nt-family:verdana,sans-serif">Guest:</div><div class=3D"gmail_default" styl=
e=3D"font-family:verdana,sans-serif">$ cat /mnt/shared/readme.txt</div><div=
 class=3D"gmail_default" style=3D"font-family:verdana,sans-serif">This is a=
 readme.txt file.</div><div class=3D"gmail_default" style=3D"font-family:ve=
rdana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fami=
ly:verdana,sans-serif">So it seems that the virtiofsd has a reference to th=
e file which the guest is not aware of and is unable to send a FUSE_FORGET =
message. This results in a file not actually deleted (renamed to .nfsXXX) a=
nd is still accessible by the guest.</div><div class=3D"gmail_default" styl=
e=3D"font-family:verdana,sans-serif"><br></div><div class=3D"gmail_default"=
 style=3D"font-family:verdana,sans-serif">I have a similar problem when del=
eting a file from a Windows guest side. The FUSE_READDIR(PLUS) commands add=
 a reference count to files which the OS doesn&#39;t have a file context fo=
r. However I was able to solve it (for now?) by keeping track of returned f=
iles&#39; inodes.</div><div class=3D"gmail_default" style=3D"font-family:ve=
rdana,sans-serif"><br></div><div class=3D"gmail_default" style=3D"font-fami=
ly:verdana,sans-serif">Is this behaviour current and by design?</div><div c=
lass=3D"gmail_default" style=3D"font-family:verdana,sans-serif"><br></div><=
div class=3D"gmail_default" style=3D"font-family:verdana,sans-serif">Thanks=
,</div><div class=3D"gmail_default" style=3D"font-family:verdana,sans-serif=
"><br></div><div class=3D"gmail_default" style=3D"font-family:verdana,sans-=
serif">=C2=A0=C2=A0=C2=A0 Gal.</div><div class=3D"gmail_default" style=3D"f=
ont-family:verdana,sans-serif"><br></div></div>

--000000000000b589e305c890e368--

