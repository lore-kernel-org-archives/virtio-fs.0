MIME-Version: 1.0
From: "Gong Su" <gongsu@us.ibm.com>
Date: Thu, 12 Dec 2019 13:55:25 -0500
Message-Id: <OFEFF035BA.8C1142AF-ON002584CE.006405E7-852584CE.0067F3AB@notes.na.collabserv.com>
Content-Type: multipart/alternative; 
	Boundary="0__=8FBB0E5DDFF783778f9e8a93df938690918c8FBB0E5DDFF78377"
Content-Disposition: inline
Subject: [Virtio-fs] virtio-fs on zLinux (s390x)
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Cornelia Huck <cohuck@redhat.com>

--0__=8FBB0E5DDFF783778f9e8a93df938690918c8FBB0E5DDFF78377
Content-Transfer-Encoding: quoted-printable
Content-type: text/plain; charset=WINDOWS-1252



Hi Stefan, I'm resending my questions to the list per your request.

Basically, I'm trying to see if I can get virtio-fs to work on zLinux.
Following the instructions on https://virtio-fs.gitlab.io/howto-qemu.html I
was able to compile all the pieces but when I tried to run qemu I realized
that it needs -numa option which isn't supported on s390x yet.

I have talked to Christian Borntraeger (whom I worked with on other
projects before) and he indicated that he had a plan to add -numa support
for s390x but currently is busy on other things.

So I'm trying to see if there are other ways for me to go forward without
having to wait for Christian. I see two options:

1. Merge virtiofsd into qemu itself. In the "Interchangeability" section of
the virtio-fs design page (https://virtio-fs.gitlab.io/design.html), it
mentioned that "It is also possible to forego vhost-user and emulate the
virtio-fs device directly inside the hypervisor, although this may result
in poor isolation and security." Since each guest typically gets its own
qemu process, maybe this is acceptable for some use cases. In exchange, you
get the benefit of not having to carve out a chunk of memory from /dev/shm
(and maybe simpler communication between virtiofsd and qemu).
2. Use something other than -numa to share memory between virtiofsd and
qemu that's supported on zLinux. I'm not entirely familiar with qemu so I
have no idea whether this is possible or not.

Thanks.

--0__=8FBB0E5DDFF783778f9e8a93df938690918c8FBB0E5DDFF78377
Content-Transfer-Encoding: quoted-printable
Content-type: text/html; charset=WINDOWS-1252
Content-Disposition: inline

<html><body><p><font size=3D"2">Hi Stefan, I'm resending my questions to th=
e list per your request.</font><br><br><font size=3D"2">Basically, I'm tryi=
ng to see if I can get virtio-fs to work on zLinux. Following the instructi=
ons on </font><a href=3D"https://virtio-fs.gitlab.io/howto-qemu.html"><font=
 size=3D"2">https://virtio-fs.gitlab.io/howto-qemu.html</font></a><font siz=
e=3D"2"> I was able to compile all the pieces but when I tried to run qemu =
I realized that it needs -numa option which isn't supported on s390x yet.</=
font><br><br><font size=3D"2">I have talked to Christian Borntraeger (whom =
I worked with on other projects before) and he indicated that he had a plan=
 to add -numa support for s390x but currently is busy on other things.</fon=
t><br><br><font size=3D"2">So I'm trying to see if there are other ways for=
 me to go forward without having to wait for Christian. I see two options:<=
/font><br><br><font size=3D"2">1. Merge virtiofsd into qemu itself. In the =
&quot;Interchangeability&quot; section of the virtio-fs design page (</font=
><a href=3D"https://virtio-fs.gitlab.io/design.html"><font size=3D"2">https=
://virtio-fs.gitlab.io/design.html</font></a><font size=3D"2">), it mention=
ed that &quot;It is also possible to forego vhost-user and emulate the virt=
io-fs device directly inside the hypervisor, although this may result in po=
or isolation and security.&quot; Since each guest typically gets its own qe=
mu process, maybe this is acceptable for some use cases. In exchange, you g=
et the benefit of not having to carve out a chunk of memory from /dev/shm (=
and maybe simpler communication between virtiofsd and qemu).</font><br><fon=
t size=3D"2">2. Use something other than -numa to share memory between virt=
iofsd and qemu that's supported on zLinux. I'm not entirely familiar with q=
emu so I have no idea whether this is possible or not.</font><br><br><font =
size=3D"2">Thanks.</font><BR>
</body></html>

--0__=8FBB0E5DDFF783778f9e8a93df938690918c8FBB0E5DDFF78377--

