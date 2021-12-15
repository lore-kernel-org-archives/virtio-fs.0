MIME-Version: 1.0
From: German Maglione <gmaglione@redhat.com>
Date: Wed, 15 Dec 2021 11:54:17 +0100
Message-ID: <CAJh=p+7fvS5ZJh0wK16yN1VHbKfX=1ZFfPjEx9hZpcg5hvAamw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000b9ff7605d32d223b"
Subject: [Virtio-fs] [virtiofsd-rs] user namespace progress report
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>

--000000000000b9ff7605d32d223b
Content-Type: text/plain; charset="UTF-8"

Hi,

I have been performing several tests to see if it is possible to run the
virtiofs-rs daemon inside a user namespace. It works with both 'none' and
'chroot' sandbox modes. But, file handles don't work.

I tested it using 'unshare', 'podman unshare' and 'lxc-usernsexec'
(the lxc one give us more flexibility when mapping [g|u]ids)

I also ran pjdfstests and only tests that run 'mknod' fails(*), expected
when
executed as a non-privileged user.
(*) I've not finished checking all failed test.

Next step is to get it to run in libvirt session mode.

Cheers,

-- 
German

--000000000000b9ff7605d32d223b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>I have been performing several tests to see if =
it is possible to run the<br>virtiofs-rs daemon inside a user namespace. It=
 works with both &#39;none&#39; and<br>&#39;chroot&#39; sandbox modes. But,=
 file handles don&#39;t work.<br><br>I tested it using &#39;unshare&#39;, &=
#39;podman unshare&#39; and &#39;lxc-usernsexec&#39;<br>(the lxc one give u=
s more flexibility when mapping [g|u]ids)<br><br>I also ran pjdfstests and =
only tests that run &#39;mknod&#39; fails(*), expected when<br>executed as =
a non-privileged user.<br>(*) I&#39;ve not finished checking all failed tes=
t.<br><br>Next step is to get it to run in libvirt session mode.<br><br>Che=
ers,<br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"gmail_signature"=
 data-smartmail=3D"gmail_signature"><div dir=3D"ltr">German<br></div></div>=
</div>

--000000000000b9ff7605d32d223b--

