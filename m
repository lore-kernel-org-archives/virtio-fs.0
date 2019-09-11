DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=mime-version:from:date:message-id:subject:to;
	bh=t9wex4ppwb4MvvZgbmPrgoFIGt0YijxXwzCXhtAY9xY=;
	b=n93VMKgUUFedBB/Zh1cNenmW8zK3SLZbSj8bUHfiagajnNuSZt+ScnowdQbPzBeOrm
	UEete9RogXDwuxJpwlmQ7PSBOjc5vq4t+aQwgS6Ci4oAOB9P7tuqMyVH86JsKlM0zFxl
	piN8ZT4SETVS1vOyaDR8W0oDH26bXEgt6BOQyU4Tv+JMDORyfbSsEOfL/CR7iWGFdOB8
	8xVP8ffQ6328Dd3zgmvAA0mVqr1bacIl3NmLYhr0uCFUqzeDeJJNY5pokm1kK17WOTGN
	/1TM5jLaQXDkTDq32WSQCH3zUdzTeVRCwlhGyE1f9JzGSvqqpLzxK1pQkPQwZ2wQgNxw
	fy2g==
MIME-Version: 1.0
From: Nitesh Konkar <niteshkonkar007@gmail.com>
Date: Wed, 11 Sep 2019 22:18:49 +0530
Message-ID: <CAGX0RaLdFCsyczqw25fX2CahvTa=fg-qM=bFcAoJhVUGmsptKQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="0000000000003d7f76059249cc72"
Subject: [Virtio-fs] virtio-fs on IBM Power ppc64le arch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

--0000000000003d7f76059249cc72
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Team,

I am trying out virtio-fs on IBM POWER systems by following the steps
mentioned here: https://virtio-fs.gitlab.io/howto-qemu.html However,
building qemu and virtiofsd fails on Power.



root@s:/home/nitesh/virtio-fs/qemu/build# make -j 64
...
...
  CC      qapi/qapi-commands-run-state.o
  CC      qapi/qapi-commands-rocker.o
  CC      qapi/qapi-commands-sockets.o
/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c: In function
=E2=80=98usb_xhci_realize=E2=80=99:
/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3340:66: error: =E2=80=98%d=
=E2=80=99
directive output may be truncated writing between 1 and 11 bytes into a
region of size 5 [-Werror=3Dformat-truncation=3D]
             snprintf(port->name, sizeof(port->name), "usb2 port #%d", i+1)=
;
                                                                  ^~
/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3340:54: note: directive
argument in the range [-2147483647, 30]
             snprintf(port->name, sizeof(port->name), "usb2 port #%d", i+1)=
;
                                                      ^~~~~~~~~~~~~~~
In file included from /usr/include/stdio.h:862:0,
                 from /home/nitesh/virtio-fs/qemu/include/qemu/osdep.h:99,
                 from /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:
/usr/include/powerpc64le-linux-gnu/bits/stdio2.h:64:10: note:
=E2=80=98__builtin___snprintf_chk=E2=80=99 output between 13 and 23 bytes i=
nto a
destination of size 16
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:66: error: =E2=80=98%d=
=E2=80=99
directive output may be truncated writing between 1 and 11 bytes into a
region of size 5 [-Werror=3Dformat-truncation=3D]
             snprintf(port->name, sizeof(port->name), "usb3 port #%d", i+1)=
;
                                                                  ^~
/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:54: note: directive
argument in the range [-2147483647, 30]
             snprintf(port->name, sizeof(port->name), "usb3 port #%d", i+1)=
;
                                                      ^~~~~~~~~~~~~~~
In file included from /usr/include/stdio.h:862:0,
                 from /home/nitesh/virtio-fs/qemu/include/qemu/osdep.h:99,
                 from /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:
/usr/include/powerpc64le-linux-gnu/bits/stdio2.h:64:10: note:
=E2=80=98__builtin___snprintf_chk=E2=80=99 output between 13 and 23 bytes i=
nto a
destination of size 16
   return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        __bos (__s), __fmt, __va_arg_pack ());
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  CC      qapi/qapi-commands-trace.o
  CC      qapi/qapi-commands-tpm.o
  CC      qapi/qapi-commands-ui.o
  CC      qapi/qapi-commands-transaction.o
  CC      qom/cpu.o
  CC      replay/replay.o
  CC      replay/replay-internal.o
  CC      replay/replay-events.o
  CC      replay/replay-time.o
  CC      replay/replay-input.o
  CC      replay/replay-char.o
  CC      replay/replay-snapshot.o
  CC      replay/replay-audio.o
  CC      replay/replay-net.o
  CC      ui/console.o
  CC      ui/cursor.o
  CC      ui/keymaps.o
  CC      ui/qemu-pixman.o
  CC      ui/input.o
  CC      ui/input-keymap.o
  CC      ui/input-legacy.o
  CC      ui/kbd-state.o
  CC      ui/input-linux.o
  CC      ui/vnc.o
  CC      ui/vnc-enc-zlib.o
  CC      ui/vnc-enc-hextile.o
  CC      ui/vnc-enc-tight.o
  CC      ui/vnc-palette.o
  CC      ui/vnc-ws.o
  CC      ui/vnc-enc-zrle.o
  CC      ui/vnc-auth-vencrypt.o
  CC      ui/vnc-jobs.o
  CC      audio/ossaudio.o
  CC      chardev/char.o
  CC      chardev/char-fe.o
  CC      chardev/char-fd.o
  CC      chardev/char-file.o
  CC      chardev/char-io.o
  CC      chardev/char-mux.o
  CC      chardev/char-null.o
  CC      chardev/char-parallel.o
  CC      chardev/char-pipe.o
  CC      chardev/char-pty.o
  CC      chardev/char-socket.o
  CC      chardev/char-serial.o
  CC      chardev/char-ringbuf.o
  CC      chardev/char-stdio.o
  CC      chardev/char-udp.o
  CC      qga/commands.o
  CC      qga/qapi-generated/qga-qapi-types.o
  CC      qga/channel-posix.o
  CC      qga/qapi-generated/qga-qapi-visit.o
  CC      qga/guest-agent-command-state.o
  CC      qga/commands-posix.o
  LINK    tests/qemu-iotests/socket_scm_helper
  CC      qga/qapi-generated/qga-qapi-commands.o
  CC      qga/main.o
  CCAS    spapr-rtas/spapr-rtas.o
  AR      libqemuutil.a
  LINK    elf2dmp
  CC      qemu-img.o
  Building spapr-rtas/spapr-rtas.img
  Building spapr-rtas/spapr-rtas.bin
  LINK    ivshmem-client
  LINK    ivshmem-server
  LINK    qemu-nbd
  LINK    qemu-io
  LINK    qemu-edid
  LINK    fsdev/virtfs-proxy-helper
  LINK    scsi/qemu-pr-helper
  LINK    qemu-bridge-helper
cc1: all warnings being treated as errors
/home/nitesh/virtio-fs/qemu/rules.mak:69: recipe for target
'hw/usb/hcd-xhci.o' failed
make: *** [hw/usb/hcd-xhci.o] Error 1
make: *** Waiting for unfinished jobs....



root@s:/home/nitesh/virtio-fs/qemu/build# make -j 64 virtiofsd
make[1]: Entering directory '/home/nitesh/virtio-fs/qemu/slirp'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/home/nitesh/virtio-fs/qemu/slirp'
  CC      contrib/virtiofsd/buffer.o
  CC      contrib/virtiofsd/fuse_opt.o
  CC      contrib/virtiofsd/fuse_loop_mt.o
  CC      contrib/virtiofsd/fuse_lowlevel.o
  CC      contrib/virtiofsd/fuse_signals.o
  CC      contrib/virtiofsd/fuse_virtio.o
  CC      contrib/virtiofsd/helper.o
  CC      contrib/virtiofsd/seccomp.o
  CC      contrib/libvhost-user/libvhost-user.o
  CC      contrib/virtiofsd/passthrough_ll.o
  CC      contrib/libvhost-user/libvhost-user-glib.o
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c: In
function =E2=80=98vu_set_mem_table_exec_postcopy=E2=80=99:
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:677:16:
error: format =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98long=
 long unsigned int=E2=80=99, but
argument 5 has type =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Werro=
r=3Dformat=3D]
         DPRINT("%s: region %d: Registered userfault for %llx + %llx\n",
                ^
                 __func__, i, reg_struct.range.start, reg_struct.range.len)=
;
                              ~~~~~~~~~~~~~~~~~~
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:79:29:
note: in definition of macro =E2=80=98DPRINT=E2=80=99
             fprintf(stderr, __VA_ARGS__);        \
                             ^~~~~~~~~~~
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:677:16:
error: format =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98long=
 long unsigned int=E2=80=99, but
argument 6 has type =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Werro=
r=3Dformat=3D]
         DPRINT("%s: region %d: Registered userfault for %llx + %llx\n",
                ^
                 __func__, i, reg_struct.range.start, reg_struct.range.len)=
;
                                                      ~~~~~~~~~~~~~~~~~~
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:79:29:
note: in definition of macro =E2=80=98DPRINT=E2=80=99
             fprintf(stderr, __VA_ARGS__);        \
                             ^~~~~~~~~~~
cc1: all warnings being treated as errors
/home/nitesh/virtio-fs/qemu/rules.mak:69: recipe for target
'contrib/libvhost-user/libvhost-user.o' failed
make: *** [contrib/libvhost-user/libvhost-user.o] Error 1
make: *** Waiting for unfinished jobs....


Do I need to make any arch-specific changes?
PS: Should I share such snippets next time in fedora paste bin?

Thanks,
Nitesh Konkar

--0000000000003d7f76059249cc72
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hello Team,</div><div><br></div><div>I am trying out =
virtio-fs on IBM POWER systems by following the steps mentioned here: <a hr=
ef=3D"https://virtio-fs.gitlab.io/howto-qemu.html">https://virtio-fs.gitlab=
.io/howto-qemu.html</a> However, building qemu and virtiofsd fails on Power=
.</div><div><br></div><div><br></div><div><br></div><div>root@s:/home/nites=
h/virtio-fs/qemu/build# make -j 64</div><div>...</div><div>...<br></div><di=
v>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qapi/qapi-commands-run-state.o<br>=C2=A0 CC=
 =C2=A0 =C2=A0 =C2=A0qapi/qapi-commands-rocker.o<br>=C2=A0 CC =C2=A0 =C2=A0=
 =C2=A0qapi/qapi-commands-sockets.o<br>/home/nitesh/virtio-fs/qemu/hw/usb/h=
cd-xhci.c: In function =E2=80=98usb_xhci_realize=E2=80=99:<br>/home/nitesh/=
virtio-fs/qemu/hw/usb/hcd-xhci.c:3340:66: error: =E2=80=98%d=E2=80=99 direc=
tive output may be truncated writing between 1 and 11 bytes into a region o=
f size 5 [-Werror=3Dformat-truncation=3D]<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0snprintf(port-&gt;name, sizeof(port-&gt;name), &quot;us=
b2 port #%d&quot;, i+1);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~<br>/home/nitesh/virtio-fs/qemu/hw=
/usb/hcd-xhci.c:3340:54: note: directive argument in the range [-2147483647=
, 30]<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(port-&gt;=
name, sizeof(port-&gt;name), &quot;usb2 port #%d&quot;, i+1);<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~~~~~~~~~~~~~~<br>In file included from /u=
sr/include/stdio.h:862:0,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0from /home/nitesh/virtio-fs/qemu/include/qemu/osdep.h:99,<=
br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0from /home=
/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:<br>/usr/include/powerpc64le-li=
nux-gnu/bits/stdio2.h:64:10: note: =E2=80=98__builtin___snprintf_chk=E2=80=
=99 output between 13 and 23 bytes into a destination of size 16<br>=C2=A0 =
=C2=A0return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,<b=
r>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 __bos (__s), __fmt, _=
_va_arg_pack ());<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 ~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~<br>/home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:66: error=
: =E2=80=98%d=E2=80=99 directive output may be truncated writing between 1 =
and 11 bytes into a region of size 5 [-Werror=3Dformat-truncation=3D]<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0snprintf(port-&gt;name, siz=
eof(port-&gt;name), &quot;usb3 port #%d&quot;, i+1);<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~<br>/h=
ome/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:54: note: directive argume=
nt in the range [-2147483647, 30]<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0snprintf(port-&gt;name, sizeof(port-&gt;name), &quot;usb3 port #%=
d&quot;, i+1);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~~~~~~~~~~~~~~=
<br>In file included from /usr/include/stdio.h:862:0,<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0from /home/nitesh/virtio-fs/qe=
mu/include/qemu/osdep.h:99,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0from /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:<=
br>/usr/include/powerpc64le-linux-gnu/bits/stdio2.h:64:10: note: =E2=80=98_=
_builtin___snprintf_chk=E2=80=99 output between 13 and 23 bytes into a dest=
ination of size 16<br>=C2=A0 =C2=A0return __builtin___snprintf_chk (__s, __=
n, __USE_FORTIFY_LEVEL - 1,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^~~~~~~~~=
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 __bos (__s), __fmt, __va_arg_pack ());<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0=
qapi/qapi-commands-trace.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qapi/qapi-comma=
nds-tpm.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qapi/qapi-commands-ui.o<br>=C2=
=A0 CC =C2=A0 =C2=A0 =C2=A0qapi/qapi-commands-transaction.o<br>=C2=A0 CC =
=C2=A0 =C2=A0 =C2=A0qom/cpu.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0replay/repla=
y.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0replay/replay-internal.o<br>=C2=A0 CC =
=C2=A0 =C2=A0 =C2=A0replay/replay-events.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=
=A0replay/replay-time.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0replay/replay-inpu=
t.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0replay/replay-char.o<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0replay/replay-snapshot.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0=
replay/replay-audio.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0replay/replay-net.o<=
br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/console.o<br>=C2=A0 CC =C2=A0 =C2=A0 =
=C2=A0ui/cursor.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/keymaps.o<br>=C2=A0 C=
C =C2=A0 =C2=A0 =C2=A0ui/qemu-pixman.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/=
input.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/input-keymap.o<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0ui/input-legacy.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/kbd-=
state.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/input-linux.o<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0ui/vnc.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-enc-zlib.=
o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-enc-hextile.o<br>=C2=A0 CC =C2=A0=
 =C2=A0 =C2=A0ui/vnc-enc-tight.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-pa=
lette.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-ws.o<br>=C2=A0 CC =C2=A0 =
=C2=A0 =C2=A0ui/vnc-enc-zrle.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-auth=
-vencrypt.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0ui/vnc-jobs.o<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0audio/ossaudio.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/=
char.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-fe.o<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0chardev/char-fd.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev=
/char-file.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-io.o<br>=C2=A0 C=
C =C2=A0 =C2=A0 =C2=A0chardev/char-mux.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0c=
hardev/char-null.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-parallel.o=
<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-pipe.o<br>=C2=A0 CC =C2=A0 =
=C2=A0 =C2=A0chardev/char-pty.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/ch=
ar-socket.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-serial.o<br>=C2=
=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/char-ringbuf.o<br>=C2=A0 CC =C2=A0 =C2=
=A0 =C2=A0chardev/char-stdio.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0chardev/cha=
r-udp.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qga/commands.o<br>=C2=A0 CC =C2=A0=
 =C2=A0 =C2=A0qga/qapi-generated/qga-qapi-types.o<br>=C2=A0 CC =C2=A0 =C2=
=A0 =C2=A0qga/channel-posix.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qga/qapi-gen=
erated/qga-qapi-visit.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qga/guest-agent-co=
mmand-state.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qga/commands-posix.o<br>=C2=
=A0 LINK =C2=A0 =C2=A0tests/qemu-iotests/socket_scm_helper<br>=C2=A0 CC =C2=
=A0 =C2=A0 =C2=A0qga/qapi-generated/qga-qapi-commands.o<br>=C2=A0 CC =C2=A0=
 =C2=A0 =C2=A0qga/main.o<br>=C2=A0 CCAS =C2=A0 =C2=A0spapr-rtas/spapr-rtas.=
o<br>=C2=A0 AR =C2=A0 =C2=A0 =C2=A0libqemuutil.a<br>=C2=A0 LINK =C2=A0 =C2=
=A0elf2dmp<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0qemu-img.o<br>=C2=A0 Building s=
papr-rtas/spapr-rtas.img<br>=C2=A0 Building spapr-rtas/spapr-rtas.bin<br>=
=C2=A0 LINK =C2=A0 =C2=A0ivshmem-client<br>=C2=A0 LINK =C2=A0 =C2=A0ivshmem=
-server<br>=C2=A0 LINK =C2=A0 =C2=A0qemu-nbd<br>=C2=A0 LINK =C2=A0 =C2=A0qe=
mu-io<br>=C2=A0 LINK =C2=A0 =C2=A0qemu-edid<br>=C2=A0 LINK =C2=A0 =C2=A0fsd=
ev/virtfs-proxy-helper<br>=C2=A0 LINK =C2=A0 =C2=A0scsi/qemu-pr-helper<br>=
=C2=A0 LINK =C2=A0 =C2=A0qemu-bridge-helper<br>cc1: all warnings being trea=
ted as errors<br>/home/nitesh/virtio-fs/qemu/rules.mak:69: recipe for targe=
t &#39;hw/usb/hcd-xhci.o&#39; failed<br>make: *** [hw/usb/hcd-xhci.o] Error=
 1<br>make: *** Waiting for unfinished jobs....</div><div><br></div><div><b=
r></div><div><br></div><div>root@s:/home/nitesh/virtio-fs/qemu/build# make =
-j 64 virtiofsd<br>make[1]: Entering directory &#39;/home/nitesh/virtio-fs/=
qemu/slirp&#39;<br>make[1]: Nothing to be done for &#39;all&#39;.<br>make[1=
]: Leaving directory &#39;/home/nitesh/virtio-fs/qemu/slirp&#39;<br>=C2=A0 =
CC =C2=A0 =C2=A0 =C2=A0contrib/virtiofsd/buffer.o<br>=C2=A0 CC =C2=A0 =C2=
=A0 =C2=A0contrib/virtiofsd/fuse_opt.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0con=
trib/virtiofsd/fuse_loop_mt.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0contrib/virt=
iofsd/fuse_lowlevel.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0contrib/virtiofsd/fu=
se_signals.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0contrib/virtiofsd/fuse_virtio=
.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0contrib/virtiofsd/helper.o<br>=C2=A0 CC=
 =C2=A0 =C2=A0 =C2=A0contrib/virtiofsd/seccomp.o<br>=C2=A0 CC =C2=A0 =C2=A0=
 =C2=A0contrib/libvhost-user/libvhost-user.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=
=A0contrib/virtiofsd/passthrough_ll.o<br>=C2=A0 CC =C2=A0 =C2=A0 =C2=A0cont=
rib/libvhost-user/libvhost-user-glib.o<br>/home/nitesh/virtio-fs/qemu/contr=
ib/libvhost-user/libvhost-user.c: In function =E2=80=98vu_set_mem_table_exe=
c_postcopy=E2=80=99:<br>/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/l=
ibvhost-user.c:677:16: error: format =E2=80=98%llx=E2=80=99 expects argumen=
t of type =E2=80=98long long unsigned int=E2=80=99, but argument 5 has type=
 =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Werror=3Dformat=3D]<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DPRINT(&quot;%s: region %d: Registered us=
erfault for %llx + %llx\n&quot;,<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 ^<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0__func__, i, reg_struct.range.start, reg_struct.range.len);<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ~~~~~~~~~~~~~~~~~~<br>/home/nitesh/virtio-f=
s/qemu/contrib/libvhost-user/libvhost-user.c:79:29: note: in definition of =
macro =E2=80=98DPRINT=E2=80=99<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0fprintf(stderr, __VA_ARGS__); =C2=A0 =C2=A0 =C2=A0 =C2=A0\<br>=C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~<br>/home/nitesh/virtio-fs/qemu/contrib/=
libvhost-user/libvhost-user.c:677:16: error: format =E2=80=98%llx=E2=80=99 =
expects argument of type =E2=80=98long long unsigned int=E2=80=99, but argu=
ment 6 has type =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Werror=3D=
format=3D]<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DPRINT(&quot;%s: region %d:=
 Registered userfault for %llx + %llx\n&quot;,<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0__func__, i, reg_struct.range.start, reg_struct.ran=
ge.len);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ~~~~~~~~~~~~~~~~~~<br>=
/home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:79:29: no=
te: in definition of macro =E2=80=98DPRINT=E2=80=99<br>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0fprintf(stderr, __VA_ARGS__); =C2=A0 =C2=A0 =C2=
=A0 =C2=A0\<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^~~~~~~~~~~<br>cc1: all warnin=
gs being treated as errors<br>/home/nitesh/virtio-fs/qemu/rules.mak:69: rec=
ipe for target &#39;contrib/libvhost-user/libvhost-user.o&#39; failed<br>ma=
ke: *** [contrib/libvhost-user/libvhost-user.o] Error 1<br>make: *** Waitin=
g for unfinished jobs....</div><div><br></div><div><br></div><div>Do I need=
 to make any arch-specific changes? <br></div><div>PS: Should I share such =
snippets next time in fedora paste bin?</div><div><br></div><div>Thanks,</d=
iv><div>Nitesh Konkar</div><div><br></div></div>

--0000000000003d7f76059249cc72--

