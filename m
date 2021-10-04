Date: Mon, 4 Oct 2021 16:07:04 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsYmHhbjPs/LEUc@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-13-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9XQL1jyIUILLHsZa"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-13-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 12/13] virtiofsd: Implement blocking posix
	locks
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--9XQL1jyIUILLHsZa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:36AM -0400, Vivek Goyal wrote:
> As of now we don't support fcntl(F_SETLKW) and if we see one, we return
> -EOPNOTSUPP.
>=20
> Change that by accepting these requests and returning a reply
> immediately asking caller to wait. Once lock is available, send a
> notification to the waiter indicating lock is available.
>=20
> In response to lock request, we are returning error value as "1", which
> signals to client to queue the lock request internally and later client
> will get a notification which will signal lock is taken (or error). And
> then fuse client should wake up the guest process.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c  | 37 ++++++++++++++++-
>  tools/virtiofsd/fuse_lowlevel.h  | 26 ++++++++++++
>  tools/virtiofsd/fuse_virtio.c    | 50 ++++++++++++++++++++---
>  tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++----
>  4 files changed, 167 insertions(+), 16 deletions(-)
>=20
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowle=
vel.c
> index e4679c73ab..2e7f4b786d 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -179,8 +179,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int er=
ror, struct iovec *iov,
>          .unique =3D req->unique,
>          .error =3D error,
>      };
> -
> -    if (error <=3D -1000 || error > 0) {
> +    /* error =3D 1 has been used to signal client to wait for notificait=
on */

s/notificaiton/notification/

> +    if (error <=3D -1000 || error > 1) {
>          fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n", error);
>          out.error =3D -ERANGE;
>      }
> @@ -290,6 +290,11 @@ int fuse_reply_err(fuse_req_t req, int err)
>      return send_reply(req, -err, NULL, 0);
>  }
> =20
> +int fuse_reply_wait(fuse_req_t req)
> +{
> +    return send_reply(req, 1, NULL, 0);
> +}
> +
>  void fuse_reply_none(fuse_req_t req)
>  {
>      fuse_free_req(req);
> @@ -2165,6 +2170,34 @@ static void do_destroy(fuse_req_t req, fuse_ino_t =
nodeid,
>      send_reply_ok(req, NULL, 0);
>  }
> =20
> +static int send_notify_iov(struct fuse_session *se, int notify_code,
> +                           struct iovec *iov, int count)
> +{
> +    struct fuse_out_header out;
> +    if (!se->got_init) {
> +        return -ENOTCONN;
> +    }
> +    out.unique =3D 0;
> +    out.error =3D notify_code;

Please fully initialize all fuse_out_header fields so it's obvious that
there is no accidental information leak from virtiofsd to the guest:

  struct fuse_out_header out =3D {
      .error =3D notify_code,
  };

The host must not expose uninitialized memory to the guest (just like
the kernel vs userspace). fuse_send_msg() initializes out.len later, but
to be on the safe side I think we should be explicit here.

--9XQL1jyIUILLHsZa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbGJgACgkQnKSrs4Gr
c8gAUAgAvKDRFORyxWItqCrupt3TuNF1j42PbZw3YAp6dd0LGK8JGi8e7JetfzWF
3k/9hhV1KsXY9ik2b78Eh1jeiJEy6zu2NlxY4FiTHKraziQaGHk0u1QOEDZUYapb
jmwddAVwkZne52ybbe62u2FKjIKYkUBUEdjXrlAFjmQVmDjQip6xvbQ58dorhL1n
PYc/nO3vJAWsMx+RFfVCFlZ7t7HTHYlZlgvKfcd3c1s3/O7mMi97DUWoqhfRvuka
fmz5QUidmg4goBBShWObBqpDnePlk6sAPB8AAdnBS6UgAKQaTAWIarjz9tHQqev6
9Dk0Wu+MAsHLI8j7CKv0ukbGgMGWig==
=1e2d
-----END PGP SIGNATURE-----

--9XQL1jyIUILLHsZa--

