MIME-Version: 1.0
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 1 Dec 2021 13:06:23 +0100
Message-ID: <CAJh=p+6o8_2UekwO0nQ8+sjcgpcEzGhFrTsiTjN4n72R3vNAGw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000c72d9d05d21482fd"
Subject: [Virtio-fs] [virtiofsd][virtiofsd-rs] unlink an openfile over NFS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

--000000000000c72d9d05d21482fd
Content-Type: text/plain; charset="UTF-8"

Hi,

I was working on [1] (related to [2]), and I saw that both versions
(C and rust) of virtiofsd make the NFs client to "silly rename" an open
file that were unlinked, because we keep each file open as O_PATH in the
lo_do_lookup/do_lookup function. David pointed me to this problem, and I
confirmed that this is the case.

This fires the silly rename in the nfs client. I'm talking with
Bruce Fields (nfs team) to see how to move the silly rename functionality
to the nfs server and outside the directory tree [4], to avoid having
non-really-empty
dirs full of .nfsxxx files. But it is not an easy task.
Also, this will not solve some potential issues with the resource usage:
disk space and open file limits (I hit this limit a couple of times during
my
tests). And, in some cases could be worst, more than one guest sharing the
same
exported dir, one guest just 'ls' or 'find' while the other 'rm' some files.
(The 'find' command will open all files, btw)

Vivek, I saw in [5] that you mentioned that this could be fixed introducing
synchronous, could you elaborate a bit or point me to some code?

Thanks,
[1] https://bugzilla.redhat.com/show_bug.cgi?id=2018072
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1908490
[4] https://wiki.linux-nfs.org/wiki/index.php/Server-side_silly_rename
[5]
https://sourceforge.net/p/fuse/mailman/fuse-devel/?viewmonth=202101&viewday=4


-- 
German

--000000000000c72d9d05d21482fd
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>I was working on [1] (related to [2]), and I sa=
w that both versions<br>(C and rust) of virtiofsd make the NFs client to &q=
uot;silly rename&quot; an open<br>file that were unlinked, because we keep =
each file open as O_PATH in the <br>lo_do_lookup/do_lookup function. David =
pointed me to this problem, and I<br>confirmed that this is the case.<br><b=
r>This fires the silly rename in the nfs client. I&#39;m talking with<br><d=
iv>Bruce Fields (nfs team) to see how to move the silly rename functionalit=
y</div><div> to the nfs server and outside the directory tree [4], to avoid=
 having non-really-empty<br></div>dirs full of .nfsxxx files. But it is not=
 an easy task.<br>Also, this will not solve some potential issues with the =
resource usage:<br>disk space and open file limits (I hit this limit a coup=
le of times during my<br>tests). And, in some cases could be worst, more th=
an one guest sharing the same<br>exported dir, one guest just &#39;ls&#39; =
or &#39;find&#39; while the other &#39;rm&#39; some files.<br>(The &#39;fin=
d&#39; command will open all files, btw)<br><br>Vivek, I saw in [5] that yo=
u mentioned that this could be fixed introducing<br>synchronous, could you =
elaborate a bit or point me to some code?<br><br>Thanks,<br>[1] <a href=3D"=
https://bugzilla.redhat.com/show_bug.cgi?id=3D2018072">https://bugzilla.red=
hat.com/show_bug.cgi?id=3D2018072</a><br>[2] <a href=3D"https://bugzilla.re=
dhat.com/show_bug.cgi?id=3D1908490">https://bugzilla.redhat.com/show_bug.cg=
i?id=3D1908490</a><br>[4] <a href=3D"https://wiki.linux-nfs.org/wiki/index.=
php/Server-side_silly_rename">https://wiki.linux-nfs.org/wiki/index.php/Ser=
ver-side_silly_rename</a><br>[5] <a href=3D"https://sourceforge.net/p/fuse/=
mailman/fuse-devel/?viewmonth=3D202101&amp;viewday=3D4">https://sourceforge=
.net/p/fuse/mailman/fuse-devel/?viewmonth=3D202101&amp;viewday=3D4</a><br><=
br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"gmail_signature" data=
-smartmail=3D"gmail_signature"><div dir=3D"ltr">German<br></div></div></div=
>

--000000000000c72d9d05d21482fd--

