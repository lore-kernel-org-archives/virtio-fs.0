Date: Tue, 10 Nov 2020 11:53:07 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201110115307.GB1084668@stefanha-x1.localdomain>
References: <20201109143548.GA1479853@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <20201109143548.GA1479853@redhat.com>
Subject: Re: [Virtio-fs] [PATCH V2] virtiofsd: Use --thread-pool-size=0 to
 mean no thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, jose.carlos.venegas.munoz@intel.com, qemu-devel@nongnu.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2020 at 09:35:48AM -0500, Vivek Goyal wrote:
> Right now we create a thread pool and main thread hands over the request
> to thread in thread pool to process. Number of threads in thread pool
> can be managed by option --thread-pool-size.
>=20
> In tests we have noted that many of the workloads are getting better
> performance if we don't use a thread pool at all and process all
> the requests in the context of a thread receiving the request.
>=20
> Hence give user an option to be able to run virtiofsd without using
> a thread pool.
>=20
> To implement this, I have used existing option --thread-pool-size. This
> option defines how many maximum threads can be in the thread pool.
> Thread pool size zero freezes thead pool. I can't see why will one
> start virtiofsd with a frozen thread pool (hence frozen file system).
> So I am redefining --thread-pool-size=3D0 to mean, don't use a thread poo=
l.
> Instead process the request in the context of thread receiving request
> from the queue.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 36 ++++++++++++++++++++++++++---------
>  1 file changed, 27 insertions(+), 9 deletions(-)

This is useful for benchmarking. For production we need to understand
the cause of the performance difference so that virtiofsd can adapt to
the workload without setting a specific thread-pool-size value.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+qfyMACgkQnKSrs4Gr
c8jGPggAmvkTZSheip0oT7WhLt3KNTPHHLHrKYD5wkXyfEmzlLx4Z8anSysw7BED
2TXxJKXVtZOsEyrHPre3W6dgfDYCOrUPILQxCvMwPXWKvspvmMaWmlfqDlOk+gAE
V0EvngtJJQtmyn2My5T35ys6q/AHCGCgDA6PR0WU+e05vxV6vrZR+rWK/U9V4TUe
jAaoabvA43ETJJyxLiNDyfqylhFpKnPMItsWcyvPd8FcnVIHE6wDncA2tl9stxZT
YsF46tnSgaWZ2/lUULCRVquDim0ptMj1ZxRUVu2enpg9R9Qbl+OggPfEY9I5++CW
qIPL2a73H/aYvi10ZbpE1YhcfRkizw==
=kgED
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--

