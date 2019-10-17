Date: Thu, 17 Oct 2019 11:05:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191017100528.GA24790@stefanha-x1.localdomain>
References: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20191016103754.2047-1-misono.tomohiro@jp.fujitsu.com>
Subject: Re: [Virtio-fs] [PATCH 0/2] virtiofsd: Two fix for xattr operation
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: virtio-fs@redhat.com, mszeredi@redhat.com, qemu-devel@nongnu.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2019 at 07:37:52PM +0900, Misono Tomohiro wrote:
> Hello,
>=20
> I test xattr operation on virtiofs using xfstest generic/062
> (with -o xattr option and XFS backend) and see some problems.
>=20
> These patches fixes the two of the problems.
>=20
> The remaining problems are:
>  1. we cannot xattr to block device created by mknod
>     which does not have actual device (since open in virtiofsd fails)
>  2. we cannot xattr to symbolic link
>=20
> I don't think 1 is a big problem but can we fix 2?

Sorry, I don't know the answer.  Maybe it would be necessary to add a
new O_SYMLINK open flag to open(2) so that fgetxattr()/fsetxattr()
operations can be performed.  A kernel change like that would take some
time to get accepted upstream and shipped by distros, but it might be
the only way since the current syscall interface doesn't seem to offer a
way to do this.

>=20
> Misono Tomohiro (2):
>   virtiofsd: Avoid process hang when doing xattr operation to FIFO
>   virtiofsd: Allow setxattr operation to directry
>=20
>  contrib/virtiofsd/passthrough_ll.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> --=20
> 2.21.0
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://www.redhat.com/mailman/listinfo/virtio-fs

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2oPOgACgkQnKSrs4Gr
c8jxtgf/WI9gWbbOf82Q7BK4jYeVjCxtU+4YSMk2a9IWhkctkK6irnIYUsj9Aw/X
EqQ8by0dZmAYqDV6e9rtW1gaKS0wAOEYhaf5hh+mKAi+NXT+bYyfKp00yePClObI
N0lEO9oVNnDlXag5T3BBfgN/Nrw9StUlBhY9S8eOYsl9nhBgiJJSpbpzYK6FsvMw
TtkR1MRGf90GGgDXkAeKvbUgVnT+TLEchHogS3TwUHBeKxX3+EvR0kCuw+NoUolB
VUyd9JnhSuNswXiY4ghlJfPBI1K42pohzHF8Ax39Qq0aLN573hSEV0VmM5vKWiMB
dprF3PxuPcRZt355mz5puhlUqVKoFQ==
=No4s
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--

