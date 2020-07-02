MIME-Version: 1.0
From: David Lomas <dl3@pale-eds.co.uk>
Date: Thu, 2 Jul 2020 16:20:15 +0100
Message-ID: <CALjEBWSmL_1s8n4WEMQS9_6At2B24sXysEkiWiUA867hcLbD5g@mail.gmail.com>
Content-Type: multipart/alternative; boundary="000000000000259adc05a976f4e4"
Subject: [Virtio-fs] Mount error
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--000000000000259adc05a976f4e4
Content-Type: text/plain; charset="UTF-8"

I've compiled and installed kernel 5.7, and have virtiofs mostly working,
but I'm still being caught by something which leads to an error. I've
defined the filesystem on the host like this:

<filesystem type='mount' accessmode='passthrough'>
  <driver type='virtiofs'/>
  <binary path='/usr/libexec/virtiofsd'/>
  <source dir='/data/hosts/VMHOSTNAME/users'/>
  <target dir='users'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x09'
function='0x0'/>
</filesystem>

and on the host I've put this in /etc/fstab:

users           /appdata/users            virtiofs

On boot, the /appdata/users folder is correctly mounted, but if I ever try
to manually unmount / remount, or if I boot up without an entry in
/etc/fstab and try to mount manually with something like:

# mount -t virtiofs users /appdata/users

I get this rather opaque error:

mount: /appdata/users : wrong fs type, bad option, bad superblock on /
appdata/users, missing codepage or helper program, or other error.

Are there more options I should be specifying which for some reason aren't
needed on boot?

--000000000000259adc05a976f4e4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I&#39;ve compiled and installed kernel 5.7, and have =
virtiofs mostly working, but I&#39;m still being caught by something which =
leads to an error. I&#39;ve defined the filesystem on the host like this:</=
div><div><br></div><div><span style=3D"font-family:monospace">&lt;filesyste=
m type=3D&#39;mount&#39; accessmode=3D&#39;passthrough&#39;&gt;<br>=C2=A0 &=
lt;driver type=3D&#39;virtiofs&#39;/&gt;<br>=C2=A0 &lt;binary path=3D&#39;/=
usr/libexec/virtiofsd&#39;/&gt;<br>=C2=A0 &lt;source dir=3D&#39;/data/hosts=
/VMHOSTNAME/users&#39;/&gt;<br>=C2=A0 &lt;target dir=3D&#39;users&#39;/&gt;=
<br>=C2=A0 &lt;address type=3D&#39;pci&#39; domain=3D&#39;0x0000&#39; bus=
=3D&#39;0x00&#39; slot=3D&#39;0x09&#39; function=3D&#39;0x0&#39;/&gt;<br>&l=
t;/filesystem&gt;</span></div><div><br></div><div>and on the host I&#39;ve =
put this in /etc/fstab:</div><div><br></div><div><span style=3D"font-family=
:monospace">users =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /appdata/users =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0virtiofs</span></div><div><span style=3D"=
font-family:monospace"><br></span></div><div><span style=3D"font-family:mon=
ospace"><font face=3D"arial,sans-serif">On boot, the /appdata/users folder =
is correctly mounted, but if I ever try to manually unmount / remount, or i=
f I boot up without an entry in /etc/fstab and try to mount manually with s=
omething like:</font></span></div><div><span style=3D"font-family:monospace=
"><font face=3D"arial,sans-serif"><br></font></span></div><div><span style=
=3D"font-family:monospace"># mount -t virtiofs users /appdata/users</span><=
/div><div><span style=3D"font-family:monospace"><font face=3D"arial,sans-se=
rif"><br></font></span></div><div><span style=3D"font-family:monospace"><fo=
nt face=3D"arial,sans-serif">I get this rather opaque error:</font></span><=
/div><div><span style=3D"font-family:monospace"><font face=3D"arial,sans-se=
rif"><br></font></span></div><div><span style=3D"font-family:monospace"><fo=
nt face=3D"arial,sans-serif"><span style=3D"font-family:monospace">mount: /=
appdata/users

: wrong fs type, bad option, bad superblock on /
appdata/users, missing codepage or helper program, or other error.</span></=
font></span></div><div><span style=3D"font-family:monospace"><font face=3D"=
arial,sans-serif"><span style=3D"font-family:monospace"><br></span></font><=
/span></div><div><span style=3D"font-family:monospace"><font face=3D"arial,=
sans-serif"><span style=3D"font-family:monospace"><font face=3D"arial,sans-=
serif">Are there more options I should be specifying which for some reason =
aren&#39;t needed on boot?</font><br></span></font></span></div></div>

--000000000000259adc05a976f4e4--

