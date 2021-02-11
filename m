Date: Thu, 11 Feb 2021 12:41:00 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211124100.GM247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-13-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1rguoi8KZGYj2k4L"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-13-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 12/24] DAX: virtiofsd: Wire up
 passthrough_ll's lo_setupmapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com, mst@redhat.com


--1rguoi8KZGYj2k4L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:12PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Wire up passthrough_ll's setupmapping to allocate, send to virtio
> and then reply OK.
>=20
> Guest might not pass file pointer. In that case using inode info, open
> the file again, mmap() and close fd.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> With fix from:
> Signed-off-by: Fotis Xenakis <foxen@windowslive.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c  | 13 ++++++--
>  tools/virtiofsd/passthrough_ll.c | 52 ++++++++++++++++++++++++++++++--
>  2 files changed, 61 insertions(+), 4 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--1rguoi8KZGYj2k4L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlJdwACgkQnKSrs4Gr
c8gH8QgAqAobAbMgwOGaUBEFonnTzUmoiBb3BHhpHRO47WrHNjp1uERsKoPepTiA
/wvERadsmtTyLWzwlemkBMdDiHGnX3lP2gfClKN3/zu/7HrtH+FauO3+NZjvf+Lx
BSx+bwxqXbc7wDvY3KVXOpkafgCVEZ64NuYmvFihxXinJnDy4ELpCb+9ZxwOfTiv
cgCuD4etpG4Mcvfs/3hH19mywkoAghvrRNO4dcEmX+H465Vlj9JEWeAmwurYRyoj
XUEnV0WbzpyW93ZUrQ4vFbcHuAEZlGe47hOvWGSa3sBfoCaNAAMOpqiKvcgfvRbJ
5OPPx9wSbuKBbRXlOOseKm7r7owuRw==
=c9jC
-----END PGP SIGNATURE-----

--1rguoi8KZGYj2k4L--

