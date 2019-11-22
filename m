Date: Fri, 22 Nov 2019 10:53:24 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191122105324.GE464656@stefanha-x1.localdomain>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Content-Disposition: inline
In-Reply-To: <20191115205543.1816-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofsd: Implement blocking posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:55:43PM -0500, Vivek Goyal wrote:
> diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_l=
owlevel.c
> index d4a42d9804..f706e440bf 100644
> --- a/contrib/virtiofsd/fuse_lowlevel.c
> +++ b/contrib/virtiofsd/fuse_lowlevel.c
> @@ -183,7 +183,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int er=
ror, struct iovec *iov,
>  {
>  	struct fuse_out_header out;
> =20
> -	if (error <=3D -1000 || error > 0) {
> +	/* error =3D 1 has been used to signal client to wait for notificaiton =
*/
> +	if (error <=3D -1000 || error > 1) {
>  		fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n",	error);
>  		error =3D -ERANGE;
>  	}

What is this?

> +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t req_id,
> +			      int32_t error)
> +{
> +	struct fuse_notify_lock_out outarg;

Missing =3D {} initialization to avoid information leaks to the guest.

> @@ -1704,6 +1720,15 @@ int fuse_lowlevel_notify_delete(struct fuse_sessio=
n *se,
>  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
>  			       off_t offset, struct fuse_bufvec *bufv,
>  			       enum fuse_buf_copy_flags flags);
> +/**
> + * Notify event related to previous lock request
> + *
> + * @param se the session object
> + * @param req_id the id of the request which requested setlkw

The rest of the code calls this id "unique":

  + * @param req_unique the unique id of the setlkw request

> +    /* Pop an element from queue */
> +    req =3D vu_queue_pop(dev, q, sizeof(FVRequest), &bad_in_num, &bad_ou=
t_num);
> +    if (!req) {
> +        /* TODO: Implement some sort of ring buffer and queue notificati=
ons
> +	 * on that and send these later when notification queue has space
> +	 * available.
> +	 */
> +        return -ENOSPC;

Ah, I thought the point of the notifications processing thread was
exactly this case.  It could wake any threads waiting for buffers.

This wakeup could be implemented with a condvar - no ring buffer
necessary.

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3XviQACgkQnKSrs4Gr
c8g5LQf+N8ESaD28Mf2cGPPZObPij/PeF22lT7FxU2vFcdg4vgUtR8dZ34jgJYrs
vPZe4V2KVGzWaO9beRGnh7XcCFRGaG3aFcJePYVcPddqdcvnxBRdSTPF0gGrGooZ
2pphDCRfhJmGdB/heRUX3pKy/t++2boypXCLBMos0hbQSbmF52Bbdyo7wvtkU/Sl
2UKMUxmI4REf0UVZ6MHuGbH3GmCxD/8KquCTGZK/+KKnPlgQtYB7AMuvtGiIlVhY
3tYuGLNzysF3M/sTYS0n+KeAdpQDe5MyVJw7b3vOb8tYV6uehNcGxg/7odzJ/OI5
e3h7UHbUqFQrAHkOgVnT91fD0AuQuQ==
=UkZX
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--

