Date: Wed, 9 Sep 2020 13:16:49 +0200
From: =?iso-8859-1?B?SuFu?= Tomko <jtomko@redhat.com>
Message-ID: <20200909111649.GC1377607@lpt>
References: <20200827153657.111098-1-dgilbert@redhat.com>
	<20200827153657.111098-2-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="V88s5gaDVPzZ0KCq"
Content-Disposition: inline
In-Reply-To: <20200827153657.111098-2-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 1/6] virtiofsd: Silence gcc warning
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--V88s5gaDVPzZ0KCq
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On a Thursday in 2020, Dr. David Alan Gilbert (git) wrote:
>From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>
>Gcc worries fd might be used unset, in reality it's always set if
>fi is set, and only used if fi is set so it's safe.  Initialise it to -1
>just to keep gcc happy for now.
>
>Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>---
> tools/virtiofsd/passthrough_ll.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>

Reviewed-by: J=E1n Tomko <jtomko@redhat.com>

Jano

--V88s5gaDVPzZ0KCq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEE7DTm0WabvfIr7YZ4Ak1z5KIMl5QFAl9YuZ0ACgkQAk1z5KIM
l5S4MAf/dm2VM2eVZnN8FydhcFUE4anDIpf1cAcLpFXmSBcFXae4OEZAP6miQxlf
q0an22nLJKcMsOJhajx0BEZ3lKlydSVr2Nj7YA2eAQ1psf7zZVdb9nBJuNh7lyBV
ZqKmfPCZdDZDwfJplon7cclU/o0tf1yhOwZ4HmBlf3gaU3tren9p4PB4jrkla/gI
zTi1n8C5kVjrY710ThEMzgN4cmESJ1sEr9jY9ywuRcTsNXjV61HDCqkTW6WlPn0Q
nEeAixVk9kk0d15xWQx0xRJ2Y+zgdVWEn/wtQ8lJmCAnTvDNGm+SOYZDrcfM/0mz
VSUVd7RxUExwsfeToX8qs/RgOYnYDg==
=xftR
-----END PGP SIGNATURE-----

--V88s5gaDVPzZ0KCq--

