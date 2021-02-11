Date: Thu, 11 Feb 2021 14:35:42 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20210211143542.GT247031@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-24-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="tRcR9GoWqjXrt11v"
Content-Disposition: inline
In-Reply-To: <20210209190224.62827-24-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 23/24] vhost-user-fs: Implement drop
 CAP_FSETID functionality
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


--tRcR9GoWqjXrt11v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 09, 2021 at 07:02:23PM +0000, Dr. David Alan Gilbert (git) wrot=
e:
> From: Vivek Goyal <vgoyal@redhat.com>
>=20
> As part of slave_io message, slave can ask to do I/O on an fd. Additional=
ly
> slave can ask for dropping CAP_FSETID (if master has it) before doing I/O.
> Implement functionality to drop CAP_FSETID and gain it back after the
> operation.
>=20
> This also creates a dependency on libcap-ng.

Is this patch only for the case where QEMU is running as root?

I'm not sure it will have any effect on a regular QEMU (e.g. launched by
libvirt).

--tRcR9GoWqjXrt11v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAlQL4ACgkQnKSrs4Gr
c8gSLwf+MNfurIaGiYkHOIWwHCdlACeCHH9m2N0kMu3fCt17Z8lNK8gl8yb7YnuO
tLKqwznY//9SmKNR57/TOazwkIib1LCDR6n0SVNoJH0wQa0tqSzhdGtjuOYsUUEU
/nzOtt4xbvCGFxE3xHkmal9TVRTGhg4WA48XDtlKjYolCCeTK6bO/cTxeNZKgELN
cfH0FYyag53Tn5Cpe3fMXhp4tYEG3ltvcECL1MmGRaCQiXGqAqhYwMdCJ5XaKA58
EZX8FCSxJgW2XZfb2FNTXuT3jRkm9OXIBcySDXYBEEbsfZxlaqAFtLvR8BMVXR0l
C2BqNMM0Z0yPu93LdByiX2fGv+sPyw==
=1uXB
-----END PGP SIGNATURE-----

--tRcR9GoWqjXrt11v--

