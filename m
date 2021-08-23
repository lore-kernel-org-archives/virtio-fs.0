Date: Mon, 23 Aug 2021 11:31:07 +0200
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210823093107.okqkowakgwwwvvzv@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wr3l5qy55srmglkq"
Content-Disposition: inline
Subject: [Virtio-fs] Problem using gdb/lldb on a binary residing on a
	DAX-enabled volume
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs-list <virtio-fs@redhat.com>


--wr3l5qy55srmglkq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've noticed that trying to use gdb/lldb on any binary residing on a
DAX-enabled virtio-fs volume leads to a SIGSEGV in userspace...

[root@fedora ~]# mount -t virtiofs -o dax,context=3Dsystem_u:object_r:root_=
t:s0 /dev/root /mnt/virtio-fs
[root@fedora ~]# gdb /mnt/virtio-fs/true=20
GNU gdb (GDB) Fedora 10.2-3.fc34
Copyright (C) 2021 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.htm=
l>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.
Type "show copying" and "show warranty" for details.
This GDB was configured as "x86_64-redhat-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<https://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
    <http://www.gnu.org/software/gdb/documentation/>.

For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from /mnt/virtio-fs/true...
Missing separate debuginfo for /mnt/virtio-fs/true
Try: dnf --enablerepo=3D'*debug*' install /usr/lib/debug/.build-id/25/47d5e=
7307ccc0f5a75e5990afdc5e15293ccc1.debug
Reading symbols from .gnu_debugdata for /mnt/virtio-fs/true...
(No debugging symbols found in .gnu_debugdata for /mnt/virtio-fs/true)
(gdb) break main
Breakpoint 1 at 0x14c0
(gdb) r
Starting program: /mnt/virtio-fs/true=20
Missing separate debuginfos, use: dnf debuginfo-install glibc-2.33-5.fc34.x=
86_64

Program received signal SIGSEGV, Segmentation fault.
0x0000555555555960 in _start ()


=2E.. while the kernel drops a warning:


[   39.962629] ------------[ cut here ]------------
[   39.963854] WARNING: CPU: 1 PID: 718 at mm/memory.c:2666 wp_page_copy+0x=
565/0x5d0
[   39.965736] Modules linked in: virtio_net net_failover i2c_i801 failover=
 i2c_smbus joydev drm ip_tablew
[   39.969040] CPU: 1 PID: 718 Comm: gdb Not tainted 5.11.12-300.fc34.x86_6=
4 #1
[   39.970800] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel=
-1.13.0-0-gf21b5a4aeb02-prebui4
[   39.973535] RIP: 0010:wp_page_copy+0x565/0x5d0
[   39.974675] Code: 89 7b 48 48 8b 43 30 49 39 07 75 76 48 8b 7c 24 08 48 =
8b 74 24 10 ba 00 10 00 00 e8 5
[   39.979165] RSP: 0018:ffffa3aa40cb7bc0 EFLAGS: 00010206
[   39.980483] RAX: 0000000000001000 RBX: ffffa3aa40cb7c60 RCX: 00000000000=
01000
[   39.982244] RDX: 0000000000001000 RSI: 0000555555555000 RDI: ffff898117a=
9f000
[   39.984015] RBP: ffffe934045ea7c0 R08: ffffe934041c7f68 R09: 00000000000=
00001
[   39.985780] R10: 0000000000117a9f R11: ffff89810825dd20 R12: ffff8981058=
29770
[   39.987552] R13: 0000000000000000 R14: ffff898106c11dc0 R15: 00000000000=
00001
[   39.989324] FS:  00007f9691a91080(0000) GS:ffff898763a40000(0000) knlGS:=
0000000000000000
[   39.991319] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   39.992760] CR2: 0000555555555000 CR3: 000000010422a000 CR4: 00000000000=
006e0
[   39.994535] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   39.996312] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   39.998086] Call Trace:
[   39.998766]  handle_mm_fault+0x113f/0x1970
[   39.999828]  __get_user_pages+0x28c/0x7f0
[   40.000868]  __get_user_pages_remote+0xd4/0x320
[   40.002028]  __access_remote_vm+0x106/0x370
[   40.003099]  ptrace_access_vm+0x9d/0xd0
[   40.004100]  ptrace_request+0x560/0x620
[   40.005097]  arch_ptrace+0x13d/0x3b0
[   40.006039]  __x64_sys_ptrace+0x82/0x120
[   40.007050]  do_syscall_64+0x33/0x40
[   40.008002]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   40.009283] RIP: 0033:0x7f9694ce2aae
[   40.010220] Code: 70 41 83 f8 03 c7 44 24 10 08 00 00 00 48 89 44 24 18 =
48 8d 44 24 30 8b 70 08 4c 0f 4
[   40.014714] RSP: 002b:00007ffe0cffb4e0 EFLAGS: 00000202 ORIG_RAX: 000000=
0000000065
[   40.016577] RAX: ffffffffffffffda RBX: 00005555555554c0 RCX: 00007f9694c=
e2aae
[   40.018331] RDX: 00005555555554c0 RSI: 00000000000002ef RDI: 00000000000=
00005
[   40.020092] RBP: 0000000000000001 R08: 0000000000000004 R09: 00005555555=
554c0
[   40.021855] R10: 55415641fa1e0fcc R11: 0000000000000202 R12: 00000000000=
00001
[   40.023612] R13: 00007f9691a90848 R14: 00000000000002ef R15: 00000000000=
00000
[   40.025364] ---[ end trace 2273d62ee1978eb4 ]---


Seems like DAX breaks something in the ptrace_access_vm path. On a
volume without DAX works fine.

The guest is a Fedora with a 5.11.12-300.fc34.x86_64 kernel.

Sergio.

--wr3l5qy55srmglkq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmEjatsACgkQ9GknjS8M
AjUWRA//cZEieBDXObnhl5dl3D2i/lja4EWMsVMPKbJvC7+gOMcVIyvv7LXOc8TS
UPgGz1z0LGAG4fSXmIO7ibaUDklTZnpi2Pz31OO/r6p6idqiMNj9curLn5e/dGZH
PlZBsV9ukbp+T//Y4TFlcKolx6aG1abEMxaqm8GOoSQWfGczWVJbCpXB0caqxqNA
TaQuTmUIwC69iiu6ebN2T0Vb2Pe3Bibfj3ZF5J7OwZkwzClAlQup9LiJbzBZZdqt
iZZvmxf6+JDut6xTdx1QRqoZQqvJmWwDMLr5Bmr/eF+4q7DmA3+J35QwIzQrux0P
WyqgrELchG8ASENwySSrukqZIEa7tNOUL3PJbG+Q8qhbztFnGa7VDlpmM4zzEsge
I2Eg0xWFiQOuRVDqgGnoPGZi6Vwz7ugHYvl9OMigM18GJYgsHBByxmQ+aUh0FDPo
Msrzci+SPIaO5/IKspF5ArlrktP6/yiViGZA14ibulGPliYatgjAMdeeAgE/x9YD
rtFjhn+ql3OiZqef5DhZsEW1dhpQxkCHOgr9eI7DpJQxL3zHKyNAPNP2EMUEJTqq
cMrBVhkkiy7ji3fwIJAZiLmRzGk/Xn4KRbXLYw40h1NVVm2BlS95UphcXiV/wVSV
VA01d13OHqewsDoCBdJZlIf1jevhqlrv4+Ru8TViGAGBazpAcr4=
=z0RH
-----END PGP SIGNATURE-----

--wr3l5qy55srmglkq--

