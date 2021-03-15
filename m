Date: Mon, 15 Mar 2021 10:36:10 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YE84mp9zLcGthhDg@stefanha-x1.localdomain>
References: <20210312092212.782255-1-groug@kaod.org>
	<20210312092212.782255-3-groug@kaod.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="mZrQjOpYGClovNAv"
Content-Disposition: inline
In-Reply-To: <20210312092212.782255-3-groug@kaod.org>
Subject: Re: [Virtio-fs] [PATCH v2 2/7] vhost-user: Fix double-close on
 slave_read() error path
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Greg Kurz <groug@kaod.org>
Cc: Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--mZrQjOpYGClovNAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 12, 2021 at 10:22:07AM +0100, Greg Kurz wrote:
> Some message types, e.g. VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG,
> can convey file descriptors. These must be closed before returning
> from slave_read() to avoid being leaked. This can currently be done
> in two different places:
>=20
> [1] just after the request has been processed
>=20
> [2] on the error path, under the goto label err:
>=20
> These path are supposed to be mutually exclusive but they are not
> actually. If the VHOST_USER_NEED_REPLY_MASK flag was passed and the
> sending of the reply fails, both [1] and [2] are performed with the
> same descriptor values. This can potentially cause subtle bugs if one
> of the descriptor was recycled by some other thread in the meantime.
>=20
> This code duplication complicates rollback for no real good benefit.
> Do the closing in a unique place, under a new fdcleanup: goto label
> at the end of the function.
>=20
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>  hw/virtio/vhost-user.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--mZrQjOpYGClovNAv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBPOJoACgkQnKSrs4Gr
c8i6uwf+JwmQhn/F/YcxZJKo1B0eaXq7LNzPWlWuAkMTo6UKxobGYWbE3Mp5rpPm
4+VirdQ58yz7nyhEBwlVG5O+Nk6ddFVSizWK6BEifgebahfCMGRLIqTY1K44hjon
T5eyc9Qd7SZE1velPFapxSr6ydybn7895bB48dysAM3MF9NC+I//qPhh0J/ZtbI6
w0t+Nm47URhsYZlljJZP3Wt4T5oQfWTY9D5ycfriDwDey5tnZLJHsSI0x90jLyVd
YpynF4ibsLMEjXEH2O0fzAPelF/YGG1wqpp5eroPzZbaURmyypuuNhywi3m1SCoX
7LQ33ra2Z6frm6/iMmvVy4Cnogf83g==
=Y75D
-----END PGP SIGNATURE-----

--mZrQjOpYGClovNAv--

