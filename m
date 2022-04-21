Return-Path: <stefanha@redhat.com>
Date: Thu, 21 Apr 2022 12:06:44 +0200
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YmEstOJPikLygK6U@stefanha-x1.localdomain>
References: <20220421095151.2231099-1-liuyd.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="nkXtqSJxTRNAk59B"
Content-Disposition: inline
In-Reply-To: <20220421095151.2231099-1-liuyd.fnst@fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Add docs/helper for
 killpriv_v2/no_killpriv_v2 option
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Yiding <liuyd.fnst@fujitsu.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com


--nkXtqSJxTRNAk59B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 21, 2022 at 05:51:51PM +0800, Liu Yiding wrote:
> virtiofsd has introduced killpriv_v2/no_killpriv_v2 for a while. Add
> description of it to docs/helper.
>=20
> Signed-off-by: Liu Yiding <liuyd.fnst@fujitsu.com>
> ---
>  docs/tools/virtiofsd.rst | 5 +++++
>  tools/virtiofsd/helper.c | 3 +++
>  2 files changed, 8 insertions(+)

Thanks, applied to my block tree:
https://gitlab.com/stefanha/qemu/commits/block

Stefan

--nkXtqSJxTRNAk59B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmJhLLQACgkQnKSrs4Gr
c8hLHAf+L90KRMGYnguz5S2mwe1lITvn0qa0e5YE7bTUNTRgTAtdfs8vmYCsoWHb
d/lxkk8dkAR5Fc6SM7mBr0TsaLxzux4VOnZWzQ9yJ1CZYrdVLNaOVwcoJxgS9KeH
5bEthwkaYC3jPRwQr2ppD0of6HYsyskq6HJrRI5XjG8A40XBdP9j2LWnIKrp7V//
SzKaL6hZ25UIAMLm+mFNIkMFOLG1a3nI3ciF7CcHEYgLxOOujqlhdm0dwr76GGpz
PGLSVJuzGY8bBg8kMixF9GGMbqctVOedg2bH/z00gET8dwppKiib3HGM+YJ12KS7
DB5pEZPETqh+/RrCIQbg+WNCBP2RmQ==
=U0i8
-----END PGP SIGNATURE-----

--nkXtqSJxTRNAk59B--
