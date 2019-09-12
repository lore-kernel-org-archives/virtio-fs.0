Date: Thu, 12 Sep 2019 18:09:18 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190912160918.GP23174@stefanha-x1.localdomain>
References: <CAGX0RaLdFCsyczqw25fX2CahvTa=fg-qM=bFcAoJhVUGmsptKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HrsILUyxNtiOryfc"
Content-Disposition: inline
In-Reply-To: <CAGX0RaLdFCsyczqw25fX2CahvTa=fg-qM=bFcAoJhVUGmsptKQ@mail.gmail.com>
Subject: Re: [Virtio-fs] virtio-fs on IBM Power ppc64le arch
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Nitesh Konkar <niteshkonkar007@gmail.com>
Cc: virtio-fs@redhat.com


--HrsILUyxNtiOryfc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2019 at 10:18:49PM +0530, Nitesh Konkar wrote:
> Hello Team,
>=20
> I am trying out virtio-fs on IBM POWER systems by following the steps
> mentioned here: https://virtio-fs.gitlab.io/howto-qemu.html However,
> building qemu and virtiofsd fails on Power.
>=20
>=20
>=20
> root@s:/home/nitesh/virtio-fs/qemu/build# make -j 64
> ...
> ...
>   CC      qapi/qapi-commands-run-state.o
>   CC      qapi/qapi-commands-rocker.o
>   CC      qapi/qapi-commands-sockets.o
> /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c: In function
> =E2=80=98usb_xhci_realize=E2=80=99:
> /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3340:66: error: =E2=80=98%d=
=E2=80=99
> directive output may be truncated writing between 1 and 11 bytes into a
> region of size 5 [-Werror=3Dformat-truncation=3D]
>              snprintf(port->name, sizeof(port->name), "usb2 port #%d", i+=
1);
>                                                                   ^~
> /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3340:54: note: directive
> argument in the range [-2147483647, 30]
>              snprintf(port->name, sizeof(port->name), "usb2 port #%d", i+=
1);
>                                                       ^~~~~~~~~~~~~~~
> In file included from /usr/include/stdio.h:862:0,
>                  from /home/nitesh/virtio-fs/qemu/include/qemu/osdep.h:99,
>                  from /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:
> /usr/include/powerpc64le-linux-gnu/bits/stdio2.h:64:10: note:
> =E2=80=98__builtin___snprintf_chk=E2=80=99 output between 13 and 23 bytes=
 into a
> destination of size 16
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:66: error: =E2=80=98%d=
=E2=80=99
> directive output may be truncated writing between 1 and 11 bytes into a
> region of size 5 [-Werror=3Dformat-truncation=3D]
>              snprintf(port->name, sizeof(port->name), "usb3 port #%d", i+=
1);
>                                                                   ^~
> /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:3354:54: note: directive
> argument in the range [-2147483647, 30]
>              snprintf(port->name, sizeof(port->name), "usb3 port #%d", i+=
1);
>                                                       ^~~~~~~~~~~~~~~
> In file included from /usr/include/stdio.h:862:0,
>                  from /home/nitesh/virtio-fs/qemu/include/qemu/osdep.h:99,
>                  from /home/nitesh/virtio-fs/qemu/hw/usb/hcd-xhci.c:21:
> /usr/include/powerpc64le-linux-gnu/bits/stdio2.h:64:10: note:
> =E2=80=98__builtin___snprintf_chk=E2=80=99 output between 13 and 23 bytes=
 into a
> destination of size 16
>    return __builtin___snprintf_chk (__s, __n, __USE_FORTIFY_LEVEL - 1,
>           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>         __bos (__s), __fmt, __va_arg_pack ());
>         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can get around this using:

  ./configure --disable-werror ...

This is unrelated to virtio-fs, it's an xHCI USB emulation issue.

You could check if qemu.git/master has the same issue and send a patch
upstream to fix it.

>   CC      qapi/qapi-commands-trace.o
>   CC      qapi/qapi-commands-tpm.o
>   CC      qapi/qapi-commands-ui.o
>   CC      qapi/qapi-commands-transaction.o
>   CC      qom/cpu.o
>   CC      replay/replay.o
>   CC      replay/replay-internal.o
>   CC      replay/replay-events.o
>   CC      replay/replay-time.o
>   CC      replay/replay-input.o
>   CC      replay/replay-char.o
>   CC      replay/replay-snapshot.o
>   CC      replay/replay-audio.o
>   CC      replay/replay-net.o
>   CC      ui/console.o
>   CC      ui/cursor.o
>   CC      ui/keymaps.o
>   CC      ui/qemu-pixman.o
>   CC      ui/input.o
>   CC      ui/input-keymap.o
>   CC      ui/input-legacy.o
>   CC      ui/kbd-state.o
>   CC      ui/input-linux.o
>   CC      ui/vnc.o
>   CC      ui/vnc-enc-zlib.o
>   CC      ui/vnc-enc-hextile.o
>   CC      ui/vnc-enc-tight.o
>   CC      ui/vnc-palette.o
>   CC      ui/vnc-ws.o
>   CC      ui/vnc-enc-zrle.o
>   CC      ui/vnc-auth-vencrypt.o
>   CC      ui/vnc-jobs.o
>   CC      audio/ossaudio.o
>   CC      chardev/char.o
>   CC      chardev/char-fe.o
>   CC      chardev/char-fd.o
>   CC      chardev/char-file.o
>   CC      chardev/char-io.o
>   CC      chardev/char-mux.o
>   CC      chardev/char-null.o
>   CC      chardev/char-parallel.o
>   CC      chardev/char-pipe.o
>   CC      chardev/char-pty.o
>   CC      chardev/char-socket.o
>   CC      chardev/char-serial.o
>   CC      chardev/char-ringbuf.o
>   CC      chardev/char-stdio.o
>   CC      chardev/char-udp.o
>   CC      qga/commands.o
>   CC      qga/qapi-generated/qga-qapi-types.o
>   CC      qga/channel-posix.o
>   CC      qga/qapi-generated/qga-qapi-visit.o
>   CC      qga/guest-agent-command-state.o
>   CC      qga/commands-posix.o
>   LINK    tests/qemu-iotests/socket_scm_helper
>   CC      qga/qapi-generated/qga-qapi-commands.o
>   CC      qga/main.o
>   CCAS    spapr-rtas/spapr-rtas.o
>   AR      libqemuutil.a
>   LINK    elf2dmp
>   CC      qemu-img.o
>   Building spapr-rtas/spapr-rtas.img
>   Building spapr-rtas/spapr-rtas.bin
>   LINK    ivshmem-client
>   LINK    ivshmem-server
>   LINK    qemu-nbd
>   LINK    qemu-io
>   LINK    qemu-edid
>   LINK    fsdev/virtfs-proxy-helper
>   LINK    scsi/qemu-pr-helper
>   LINK    qemu-bridge-helper
> cc1: all warnings being treated as errors
> /home/nitesh/virtio-fs/qemu/rules.mak:69: recipe for target
> 'hw/usb/hcd-xhci.o' failed
> make: *** [hw/usb/hcd-xhci.o] Error 1
> make: *** Waiting for unfinished jobs....
>=20
>=20
>=20
> root@s:/home/nitesh/virtio-fs/qemu/build# make -j 64 virtiofsd
> make[1]: Entering directory '/home/nitesh/virtio-fs/qemu/slirp'
> make[1]: Nothing to be done for 'all'.
> make[1]: Leaving directory '/home/nitesh/virtio-fs/qemu/slirp'
>   CC      contrib/virtiofsd/buffer.o
>   CC      contrib/virtiofsd/fuse_opt.o
>   CC      contrib/virtiofsd/fuse_loop_mt.o
>   CC      contrib/virtiofsd/fuse_lowlevel.o
>   CC      contrib/virtiofsd/fuse_signals.o
>   CC      contrib/virtiofsd/fuse_virtio.o
>   CC      contrib/virtiofsd/helper.o
>   CC      contrib/virtiofsd/seccomp.o
>   CC      contrib/libvhost-user/libvhost-user.o
>   CC      contrib/virtiofsd/passthrough_ll.o
>   CC      contrib/libvhost-user/libvhost-user-glib.o
> /home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c: In
> function =E2=80=98vu_set_mem_table_exec_postcopy=E2=80=99:
> /home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:677:16:
> error: format =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98lo=
ng long unsigned int=E2=80=99, but
> argument 5 has type =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Wer=
ror=3Dformat=3D]
>          DPRINT("%s: region %d: Registered userfault for %llx + %llx\n",
>                 ^
>                  __func__, i, reg_struct.range.start, reg_struct.range.le=
n);
>                               ~~~~~~~~~~~~~~~~~~
> /home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:79:29:
> note: in definition of macro =E2=80=98DPRINT=E2=80=99
>              fprintf(stderr, __VA_ARGS__);        \
>                              ^~~~~~~~~~~
> /home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:677:16:
> error: format =E2=80=98%llx=E2=80=99 expects argument of type =E2=80=98lo=
ng long unsigned int=E2=80=99, but
> argument 6 has type =E2=80=98__u64 {aka long unsigned int}=E2=80=99 [-Wer=
ror=3Dformat=3D]
>          DPRINT("%s: region %d: Registered userfault for %llx + %llx\n",
>                 ^
>                  __func__, i, reg_struct.range.start, reg_struct.range.le=
n);
>                                                       ~~~~~~~~~~~~~~~~~~
> /home/nitesh/virtio-fs/qemu/contrib/libvhost-user/libvhost-user.c:79:29:
> note: in definition of macro =E2=80=98DPRINT=E2=80=99
>              fprintf(stderr, __VA_ARGS__);        \
>                              ^~~~~~~~~~~
> cc1: all warnings being treated as errors
> /home/nitesh/virtio-fs/qemu/rules.mak:69: recipe for target
> 'contrib/libvhost-user/libvhost-user.o' failed
> make: *** [contrib/libvhost-user/libvhost-user.o] Error 1
> make: *** Waiting for unfinished jobs....
>=20
>=20
> Do I need to make any arch-specific changes?

Fixing these warnings would be nice, but it's not necessary.
=2E/configure --disable-werror will allow you to continue despite the
compiler warnings.

> PS: Should I share such snippets next time in fedora paste bin?

There is no need to use a pastebin with email since email messages are
allowed to be very long.

Stefan

--HrsILUyxNtiOryfc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl16ba4ACgkQnKSrs4Gr
c8ghUAgAj3LrHMbrPQW1nMbT2Sncd/wA3dfC3EnoNdMFalhEl/utRKmwtV+kNBGY
ps36NKc4wOkOK9g19FOhFA1LPkI3rKRXlOYnzkpeuLSTQCquuso5ZDw2rAsE4Vvh
ojHe+kmURYTD90lzJK+55tbqAlFIaUf9SlJb4d0zMssVe+v4O1YtGBoKIC9sxwpb
fD8iv3ZG/RM5Tekd1uN3HiOoY4bN9KbEo+DKSx+j3dCaJUcwKR0rhl48qpwDxuf+
/OICOcZh+e8qDwYHEpz8pcDTvu6YX1Ll/7bLube9/AAqftsJtwlwnTEUdeeZPU/G
mpBU878yeddIFlg1PsiW1PJlkGSHuQ==
=Vtv+
-----END PGP SIGNATURE-----

--HrsILUyxNtiOryfc--

