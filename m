Date: Mon, 9 Mar 2020 11:20:03 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200309112003.GF7668@stefanha-x1.localdomain>
References: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Content-Disposition: inline
In-Reply-To: <1583270111-76859-1-git-send-email-bo.liu@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH] fuse: make written data persistent after
 writing
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, vgoyal@redhat.com


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 05:15:11AM +0800, Liu Bo wrote:
> If this is a DSYNC write, make sure we push it to stable storage now
> that we've written data.
>=20
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
> This patch is based on 5.5-rc5.
>=20
>  fs/fuse/file.c | 2 ++
>  1 file changed, 2 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5mJmMACgkQnKSrs4Gr
c8gF4wf/dq14AeiyjEeDwv785+ZycspoYOw1vPEcBu0sLtwsTAGG78PiPS4SUfuX
4mWTo4V8Cn0KzWTyMaWjCeYw0YMeju5BjTqzWZHByGr97iNbKI+LK4PloiheePDZ
Lbn5gGL5qhvFRSWj7Fani87PeO9dpI1MQL6m/NmEeHZ1UMbNyS1d4Qb9rWhIkSub
iomsvrHL1Ub2qw/K7NkG6Jtoz9P/UE+Herr/U0nAIVCBIPSjZ+Zvf1uavc72ygkF
7mfG6wxXf0ZrRDVdaiRKxgCKxchVRIh0zCWqTrrCrk5aoWUZQ5aPzV2pG8obDvT5
FMaFXxWFmVezO2rIeBpH7vbU/ydlUg==
=ePRU
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--

