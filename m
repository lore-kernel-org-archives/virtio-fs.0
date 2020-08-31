MIME-Version: 1.0
From: David Lomas <dl3@pale-eds.co.uk>
Date: Mon, 31 Aug 2020 12:06:16 +0100
Message-ID: <CALjEBWSn6q3G+60qZq9cPR4V84daDryrdXRH8ovCeHqSJC1H0w@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000005f725d05ae2a66ed"
Subject: [Virtio-fs] Can't start guest after rebuilding qemu / libvirt
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--0000000000005f725d05ae2a66ed
Content-Type: text/plain; charset="UTF-8"

I had to rebuild some parts of a host, so decided to recompile / reinstall
libvirt & qemu (as I had done before), but using the latest 'stable'
versions. The host is Ubuntu 18.04, and I downloaded libvirt 6.6.0 and qemu
5.1.0, configured them to install in /usr (rather than /usr/local, as I was
having some other issues when they weren't installed in the usual location)
and built both.

Apart from some wrinkles with apparmor (just set it to 'complain' for now,
until I can figure that out), I've hit this error as soon as I try to add a
virtiofs disk to a guest:

libvirtd[22847]: Unable to read from monitor: Connection reset by peer
libvirtd[22847]: internal error: qemu unexpectedly closed the monitor:
2020-08-31T10:29:23.161478Z qemu-system-x86_64: -device
vhost-user-fs-pci,chardev=chr-vu-fs0,tag=realms,bus=pci.0,addr=0x6: Failed
to read msg header. Read 0 instead of 12. Original request
1301467040.#0122020-08-31T10:29:23.161560Z qemu-system-x86_64: -device
vhost-user-fs-pci,chardev=chr-vu-fs0,tag=realms,bus=pci.0,addr=0x6:
vhost_dev_init failed: Operation not permitted

Googling for 'vhost_dev_init failed: Operation not permitted' led to a
couple of errors regarding kata containers, and a mention of needing to run
virtiofsd with elevated privileges. I don't have SELinuex enforcing, and
vhost-vsock looks like this:

# ls -lZ /dev/vhost-vsock
crw------- 1 root root ? 10, 241 Aug 27 14:37 /dev/vhost-vsock

and virtiofsd:

# ls -l /usr/libexec/virtiofsd
-rwxr-xr-x 1 root root 358032 Aug 27 15:52 /usr/libexec/virtiofsd
# /usr/libexec/virtiofsd --version
using FUSE kernel interface version 7.31

Any ideas how to progress?

Tx

--0000000000005f725d05ae2a66ed
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I had to rebuild some parts of a host, so decided to =
recompile / reinstall libvirt &amp; qemu (as I had done before), but using =
the latest &#39;stable&#39; versions. The host is Ubuntu 18.04, and I downl=
oaded libvirt 6.6.0 and qemu 5.1.0, configured them to install in /usr (rat=
her than /usr/local, as I was having some other issues when they weren&#39;=
t installed in the usual location) and built both.</div><div><br></div><div=
>Apart from some wrinkles with apparmor (just set it to &#39;complain&#39; =
for now, until I can figure that out), I&#39;ve hit this error as soon as I=
 try to add a virtiofs disk to a guest:</div><div><span style=3D"font-famil=
y:monospace"><br></span></div><div><span style=3D"font-family:monospace">li=
bvirtd[22847]: Unable to read from monitor: Connection reset by peer<br>lib=
virtd[22847]: internal error: qemu unexpectedly closed the monitor: 2020-08=
-31T10:29:23.161478Z qemu-system-x86_64: -device vhost-user-fs-pci,chardev=
=3Dchr-vu-fs0,tag=3Drealms,bus=3Dpci.0,addr=3D0x6: Failed to read msg heade=
r. Read 0 instead of 12. Original request 1301467040.#0122020-08-31T10:29:2=
3.161560Z qemu-system-x86_64: -device vhost-user-fs-pci,chardev=3Dchr-vu-fs=
0,tag=3Drealms,bus=3Dpci.0,addr=3D0x6: vhost_dev_init failed: Operation not=
 permitted</span></div><div><br></div><div>Googling for &#39;<span style=3D=
"font-family:monospace">vhost_dev_init failed: Operation not permitted</spa=
n>&#39; led to a couple of errors regarding kata containers, and a mention =
of needing to run virtiofsd with elevated privileges. I don&#39;t have SELi=
nuex enforcing, and vhost-vsock looks like this:</div><div><br></div><div><=
span style=3D"font-family:monospace"># ls -lZ /dev/vhost-vsock<br>crw------=
- 1 root root ? 10, 241 Aug 27 14:37 /dev/vhost-vsock</span></div><div><br>=
</div><div>and virtiofsd:</div><div><br></div><div><span style=3D"font-fami=
ly:monospace"># ls -l /usr/libexec/virtiofsd<br>-rwxr-xr-x 1 root root 3580=
32 Aug 27 15:52 /usr/libexec/virtiofsd<br># /usr/libexec/virtiofsd --versio=
n<br>using FUSE kernel interface version 7.31</span><br></div><div><br></di=
v><div>Any ideas how to progress?</div><div><br></div><div>Tx<br></div></di=
v>

--0000000000005f725d05ae2a66ed--

