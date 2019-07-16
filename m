Date: Tue, 16 Jul 2019 16:30:09 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190716153009.GC21625@stefanha-x1.localdomain>
References: <690c7f0afc449d8e843cc3b271035966628df450.1563159705.git.renzhen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <690c7f0afc449d8e843cc3b271035966628df450.1563159705.git.renzhen@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: remove SCMP_FLTATTR_CTL_TSYNC
 flag
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eric Ren <renzhen@linux.alibaba.com>
Cc: virtio-fs@redhat.com


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2019 at 11:09:51AM +0800, Eric Ren wrote:
> SCMP_FLTATTR_CTL_TSYNC flag is only available on
> Linux Kernel 3.17 or greater. Older host kernel
> fails virtiofsd, limiting virtiofsd use.
>=20
> And, confirmed from Stefan Hajnoczi:
> """
> There are no threads when setup_seccomp() is invoked so the TSYNC
> attribute is not required.
>=20
> Please remove the TSYNC call.  Then we don't need to worry about version
> or feature checks.
> """
>=20
> Signed-off-by: Eric Ren <renzhen@linux.alibaba.com>
> ---
>  contrib/virtiofsd/seccomp.c | 4 ----
>  1 file changed, 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl0t7YEACgkQnKSrs4Gr
c8gGbwgAi5Z6g9yDUmaJ+PVrFwBk3zcXbx2Ge3UToHRsra39cC6y/AiHAuyCnwey
xW4ZZWgi7j4YA5PWFCkclSuDDYMChMYS5x5R8a8utA9Oc+nERktmjWP5UqO0JiBp
Yd+9ykoWnG8ili+GcOufoGlaGM4jvLti3Ac4PbA2L47kMlcN1EhNNv011i4UV2eq
V/Uv7iDCvr3TtOlVPdPoqwsuSWMOFw3A6REyX0Qx+peRE7vI8IB/0nWRhVr1dZls
Ton4IXiyejwTwGby+aMa1eRArGnLHfuJ568Hv4bTFlYaC1yrz5a0MFA6PJhNUC/a
pNsEdae8rK4E8PDUX5N9f8klNojxaw==
=X+et
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--

