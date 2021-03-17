Date: Wed, 17 Mar 2021 09:36:47 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YFHNr/Sqgo6QnoGV@stefanha-x1.localdomain>
References: <20210317084443.22657-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Ut6GBzXLkDIRjWkj"
Content-Disposition: inline
In-Reply-To: <20210317084443.22657-1-lhenriques@suse.de>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofs: fix memory leak in
	virtio_fs_probe()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Luis Henriques <lhenriques@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, virtualization@lists.linux-foundation.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>


--Ut6GBzXLkDIRjWkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2021 at 08:44:43AM +0000, Luis Henriques wrote:
> When accidentally passing twice the same tag to qemu, kmemleak ended up
> reporting a memory leak in virtiofs.  Also, looking at the log I saw the
> following error (that's when I realised the duplicated tag):
>=20
>   virtiofs: probe of virtio5 failed with error -17
>=20
> Here's the kmemleak log for reference:
>=20
> unreferenced object 0xffff888103d47800 (size 1024):
>   comm "systemd-udevd", pid 118, jiffies 4294893780 (age 18.340s)
>   hex dump (first 32 bytes):
>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>     ff ff ff ff ff ff ff ff 80 90 02 a0 ff ff ff ff  ................
>   backtrace:
>     [<000000000ebb87c1>] virtio_fs_probe+0x171/0x7ae [virtiofs]
>     [<00000000f8aca419>] virtio_dev_probe+0x15f/0x210
>     [<000000004d6baf3c>] really_probe+0xea/0x430
>     [<00000000a6ceeac8>] device_driver_attach+0xa8/0xb0
>     [<00000000196f47a7>] __driver_attach+0x98/0x140
>     [<000000000b20601d>] bus_for_each_dev+0x7b/0xc0
>     [<00000000399c7b7f>] bus_add_driver+0x11b/0x1f0
>     [<0000000032b09ba7>] driver_register+0x8f/0xe0
>     [<00000000cdd55998>] 0xffffffffa002c013
>     [<000000000ea196a2>] do_one_initcall+0x64/0x2e0
>     [<0000000008f727ce>] do_init_module+0x5c/0x260
>     [<000000003cdedab6>] __do_sys_finit_module+0xb5/0x120
>     [<00000000ad2f48c6>] do_syscall_64+0x33/0x40
>     [<00000000809526b5>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis Henriques <lhenriques@suse.de>
> ---
> Changes since v1:
> - Use kfree() to free fs->vqs instead of calling virtio_fs_put()
>=20
>  fs/fuse/virtio_fs.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Ut6GBzXLkDIRjWkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBRza8ACgkQnKSrs4Gr
c8jnxQgArLrpuXxh9hc3EbwX0Cb5eLWUCOMDFF3Nd6fM4WjDFDc/ZBYzk2W8iZIj
S8uH8ZpSF1RTgM327Zo+XqkFFfuSgdjqCrmW9z6iR7gSpnqOuSD2HReZcu3XxRln
gfW+XA3v0IB97Xpm6mDgdJFnZaowJVPiGafLQsc6VZiv3UtkHI4FXwYJzM7pWknS
HX/lMfSAi1TRkkJEY4zAkZKPVV3Jmgx5MOsMLbjjIa8griE4FnHQ7q5FlU3xDXla
ooBxfh2hqUb/p9SAlNh6zxg8VCgQTRMo6a5kZupcH9PhVorr8Ki2tYvZUpmKwEwm
y/8FuXXLTWEGnuX27koOOzoGvcl1Ag==
=3lq4
-----END PGP SIGNATURE-----

--Ut6GBzXLkDIRjWkj--

