Date: Fri, 6 Sep 2019 11:40:24 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906104024.GI5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-2-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="UthUFkbMtH2ceUK2"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-2-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 01/18] virtiofs: Remove request from
 processing list before calling end
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--UthUFkbMtH2ceUK2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:42PM -0400, Vivek Goyal wrote:
> In error path we are calling fuse_request_end() but we need to clear
> FR_SENT bit as well as remove request from processing queue. Otherwise
> fuse_request_end() triggers a warning as well as other issues show up.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--UthUFkbMtH2ceUK2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1yN5gACgkQnKSrs4Gr
c8iH2Qf9FDlsSyo3aEDCwVuW5ufQrOhFl5xJgIrwu9zF7Q8xWoHeRxDRnuXqrpy0
IBO3sm8mijVdTypCJ8zrFIER28OnXnmNmRuZFPxmlDoSf1/G74BAX7qaLH8NTikF
CwJC4TUljhUvvGNKo9/jRu6qVKNcNxz8BXmxjIGBSWWGu90lmDwarFxX6arkWn+x
N8E6/S9dUi6f6jiEy0k0zNUUZ+i4bXhM3SsGXaNuoI/GzZQUG8016CUbYKDSxRxo
ov0FV+U9gy9GEDbuhy5LI5DrlYOzlpSe8OiNiw031NIlcrGmty1o75Dw4j0Bxzwr
zMlTa2f77G2tmrCucSRxbNT2u2u6xw==
=1d2m
-----END PGP SIGNATURE-----

--UthUFkbMtH2ceUK2--

