Return-Path: <stefanha@redhat.com>
Date: Thu, 21 Sep 2023 08:58:28 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230921125828.GA3860191@fedora>
References: <20221110100629.61496-1-akihiko.odaki@daynix.com>
 <20221110100629.61496-8-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="oHXNBpnbo8awhOQJ"
Content-Disposition: inline
In-Reply-To: <20221110100629.61496-8-akihiko.odaki@daynix.com>
Subject: Re: [Virtio-fs] [PATCH v2 07/10] virtiofsd: Use
 qemu_get_runtime_dir()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: qemu-devel@nongnu.org, qemu-block@nongnu.org, virtio-fs@redhat.com, Yuval Shaia <yuval.shaia.ml@gmail.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Konstantin Kostiuk <kkostiuk@redhat.com>, Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Stefan Weil <sw@weilnetz.de>, Yan Vugenfirer <yan@daynix.com>


--oHXNBpnbo8awhOQJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 10, 2022 at 07:06:26PM +0900, Akihiko Odaki wrote:
> qemu_get_runtime_dir() is used to construct the path to a lock file.
>=20
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index 9368e292e4..b9eeed85e6 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -901,12 +901,12 @@ static bool fv_socket_lock(struct fuse_session *se)
>  {
>      g_autofree gchar *sk_name =3D NULL;
>      g_autofree gchar *pidfile =3D NULL;
> -    g_autofree gchar *state =3D NULL;
> +    g_autofree gchar *run =3D NULL;
>      g_autofree gchar *dir =3D NULL;
>      Error *local_err =3D NULL;
> =20
> -    state =3D qemu_get_local_state_dir();
> -    dir =3D g_build_filename(state, "run", "virtiofsd", NULL);
> +    run =3D qemu_get_runtime_dir();
> +    dir =3D g_build_filename(run, "virtiofsd", NULL);
> =20
>      if (g_mkdir_with_parents(dir, S_IRWXU) < 0) {
>          fuse_log(FUSE_LOG_ERR, "%s: Failed to create directory %s: %s\n",

tools/virtiofsd/ no longer exists. Which version of QEMU did you develop ag=
ainst?

commit e0dc2631ec4ac718ebe22ddea0ab25524eb37b0e
Author: Dr. David Alan Gilbert <dgilbert@redhat.com>
Date:   Wed Jan 18 12:11:51 2023 +0000

    virtiofsd: Remove source

Stefan

--oHXNBpnbo8awhOQJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUMPfQACgkQnKSrs4Gr
c8hgbggArWYb7U0xzFenrEIMYnGJwINoehg+E3n1EvJ/v7yBQc22lMzEHpRHjHUY
qZl3t9E26YEbaGTrs/v0pGtaAtqnfIUkrEMa9sOt8avgr7S0MW9NzROgBLFCfyNr
7v6BSA3ygJXoNnIvUIMp7kibrnAVciXLaMsDhzfjGVuDy/P505I2PGTeJ1n1Ai5x
nFuUgU/yCRIJ8CT7ZymJh22oq8m+TIFQePDsuwDrncqagfI4VducJjZADcIITbPk
FX2ETIoaKTa10SbYpIcmamWv2nQdLJE9DY/Kj8nzIIYRfi4uA1e2maRdav1+FpJ5
z0eiauABUiI9eZ/+qgmXJPxNuuglcg==
=lygc
-----END PGP SIGNATURE-----

--oHXNBpnbo8awhOQJ--
