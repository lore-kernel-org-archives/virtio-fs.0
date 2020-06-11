MIME-Version: 1.0
From: David Lomas <dl3@pale-eds.co.uk>
Date: Thu, 11 Jun 2020 20:01:57 +0100
Message-ID: <CALjEBWTnYLtVfJV_KnEv6oqdcWhU-dzoR_pB+C84u798oAw1Vw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000701f8205a7d39ab2"
Subject: [Virtio-fs] Getting help setting up virtiofs guest
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000701f8205a7d39ab2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies if this isn't the correct place for this kind or request.

I've been following these instructions to set up host and guest:
https://virtio-fs.gitlab.io/howto-qemu.html and
https://libvirt.org/kbase/virtiofs.html

On the host, I've built the latest version of libvirt (6.4.0) and qemu
(5.0.0), and added sections to the domain definition. All appears well (no
errors at least). This is the relevant section:

    <filesystem type=3D'mount' accessmode=3D'passthrough'>
      <driver type=3D'virtiofs'/>
      <binary path=3D'/usr/libexec/virtiofsd'/>
      <source dir=3D'/fast_data/test'/>
      <target dir=3D'test'/>
      <address type=3D'pci' domain=3D'0x0000' bus=3D'0x00' slot=3D'0x06'
function=3D'0x0'/>
    </filesystem>

On the guest, I've build the kernel (4.19.28), booted it, and confirmed
virtio_fs.ko is a built-in module.

But on running mount -t virtio_fs test /mnt/test/ I get the following error=
:

mount: /mnt/test: wrong fs type, bad option, bad superblock on qube-server,
missing codepage or helper program, or other error.

Note both those web pages above suggest using mount -t virtiofs, but that
gives unknown filesystem type 'virtiofs'

I'm at a loss to find more detailed information on how to configure
this=E2=80=94are there other resources online, or can anyone suggest what t=
o try
next?

Thanks!

--000000000000701f8205a7d39ab2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Apologies if this isn&#39;t the correct place for thi=
s kind or request.</div><div><br></div><div>I&#39;ve been following these i=
nstructions to set up host and guest: <a href=3D"https://virtio-fs.gitlab.i=
o/howto-qemu.html">https://virtio-fs.gitlab.io/howto-qemu.html</a> and <a h=
ref=3D"https://libvirt.org/kbase/virtiofs.html">https://libvirt.org/kbase/v=
irtiofs.html</a></div><div><br></div><div>On the host, I&#39;ve built the l=
atest version of libvirt (6.4.0) and qemu (5.0.0), and added sections to th=
e domain definition. All appears well (no errors at least). This is the rel=
evant section:</div><div><br></div><div>=C2=A0 =C2=A0 &lt;filesystem type=
=3D&#39;mount&#39; accessmode=3D&#39;passthrough&#39;&gt;<br>=C2=A0 =C2=A0 =
=C2=A0 &lt;driver type=3D&#39;virtiofs&#39;/&gt;<br>=C2=A0 =C2=A0 =C2=A0 &l=
t;binary path=3D&#39;/usr/libexec/virtiofsd&#39;/&gt;<br>=C2=A0 =C2=A0 =C2=
=A0 &lt;source dir=3D&#39;/fast_data/test&#39;/&gt;<br>=C2=A0 =C2=A0 =C2=A0=
 &lt;target dir=3D&#39;test&#39;/&gt;<br>=C2=A0 =C2=A0 =C2=A0 &lt;address t=
ype=3D&#39;pci&#39; domain=3D&#39;0x0000&#39; bus=3D&#39;0x00&#39; slot=3D&=
#39;0x06&#39; function=3D&#39;0x0&#39;/&gt;<br>=C2=A0 =C2=A0 &lt;/filesyste=
m&gt;<br></div><div><br></div><div>On the guest, I&#39;ve build the kernel =
(4.19.28), booted it, and confirmed virtio_fs.ko is a built-in module.</div=
><div><br></div><div>But on running mount -t virtio_fs test /mnt/test/ I ge=
t the following error:</div><div><br></div><div>mount: /mnt/test: wrong fs =
type, bad option, bad superblock on qube-server, missing codepage or helper=
 program, or other error.</div><div><br></div><div>Note both those web page=
s above suggest using mount -t virtiofs, but that gives unknown filesystem =
type &#39;virtiofs&#39;</div><div><br></div><div>I&#39;m at a loss to find =
more detailed information on how to configure this=E2=80=94are there other =
resources online, or can anyone suggest what to try next?</div><div><br></d=
iv><div>Thanks!<br></div><div><br></div><div><br></div></div>

--000000000000701f8205a7d39ab2--

