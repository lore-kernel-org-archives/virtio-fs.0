Date: Sat, 12 Oct 2019 11:23:47 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191012102347.GB17940@stefanha-x1.localdomain>
References: <20191011181826.GA13861@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20191011181826.GA13861@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtio_fs: Change module name to virtiofs.ko
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, Miklos Szeredi <miklos@szeredi.hu>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2019 at 02:18:26PM -0400, Vivek Goyal wrote:
> We have been calling it virtio_fs and even file name is virtio_fs.c. Modu=
le
> name is virtio_fs.ko but when registering file system user is supposed to
> specify filesystem type as "virtiofs".
>=20
> Masayoshi Mizuma reported that he specified filesytem type as "virtio_fs"=
 and
> got this warning on console.
>=20
>   ------------[ cut here ]------------
>   request_module fs-virtio_fs succeeded, but still no fs?
>   WARNING: CPU: 1 PID: 1234 at fs/filesystems.c:274 get_fs_type+0x12c/0x1=
38
>   Modules linked in: ... virtio_fs fuse virtio_net net_failover ...
>   CPU: 1 PID: 1234 Comm: mount Not tainted 5.4.0-rc1 #1
>=20
> So looks like kernel could find the module virtio_fs.ko but could not find
> filesystem type after that.
>=20
> It probably is better to rename module name to virtiofs.ko so that above
> warning goes away in case user ends up specifying wrong fs name.
>=20
> Reported-by: Masayoshi Mizuma <msys.mizuma@gmail.com>
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/Makefile |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> Index: rhvgoyal-linux/fs/fuse/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- rhvgoyal-linux.orig/fs/fuse/Makefile	2019-10-11 13:53:43.905757435 -0=
400
> +++ rhvgoyal-linux/fs/fuse/Makefile	2019-10-11 13:54:24.147757435 -0400
> @@ -5,6 +5,7 @@
> =20
>  obj-$(CONFIG_FUSE_FS) +=3D fuse.o
>  obj-$(CONFIG_CUSE) +=3D cuse.o
> -obj-$(CONFIG_VIRTIO_FS) +=3D virtio_fs.o
> +obj-$(CONFIG_VIRTIO_FS) +=3D virtiofs.o
> =20
>  fuse-objs :=3D dev.o dir.o file.o inode.o control.o xattr.o acl.o readdi=
r.o
> +virtiofs-y +=3D virtio_fs.o

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2hqbMACgkQnKSrs4Gr
c8hzPwf9EGq7n78zLI7WXmZzLq+aRRmqpXomJeVpspfpdsQp2HXEEWqxK/IbDysk
VKjiZJnyTQLGujvxy5+rSs2evsgEc1MMcpFAzqK/iXK5HqhH43XBsfbNa/ojQeZL
WBC8y7hallEQjJZbxo0eL9KvGjCPw7PgfXyVXp31CSgdtX/HnFZITpcEk5D0FcE0
9MJs6vGNnrto7oKGuQdnAMDeL6B/OwDeAz/GJ9tUsZyNjWIfxLGBRroqiLY1jAcP
t7IrCuLDxpE3lLPApfQLHuSHuuhCaQSeVPWk13+0KQWGRyWk6/qvIoaQxU5eevT1
ckHZ5lcucX2cJlkNn/6w1wkSaE//+g==
=hmmz
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--

