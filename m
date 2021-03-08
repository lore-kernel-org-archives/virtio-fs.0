Date: Mon, 8 Mar 2021 10:06:50 +0100
From: Sergio Lopez <slp@redhat.com>
Message-ID: <20210308090650.i5ow6pq23asygrod@mhamilton>
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="v4ogi4of45kvar7b"
Content-Disposition: inline
In-Reply-To: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Max Reitz <mreitz@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>


--v4ogi4of45kvar7b
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 05, 2021 at 05:22:56PM +0100, Max Reitz wrote:
> =3D=3D Summary =3D=3D
>=20
> So, my current position is:
>=20
> - Bind mounts don=E2=80=99t help with restricting file handles to the exp=
orted
>   directory.
>=20
> - A MAC is not very elegant, and we might encounter problems where a
>   file may be moved outside of the shared directory, but remains
>   accessible (because moving a file doesn=E2=80=99t change its handle).
>   (If we consider that a problem.  NFS evidently doesn=E2=80=99t, because
>   without subtree_check, it has absolutely no protection against
>   arbitrary file handles being opened (on the FS where the export
>   resides), so valid file handles always remain valid.)
>=20
> - A solution such as NFS=E2=80=99s subtree_check (i.e., storing the file=
=E2=80=99s
>   parent=E2=80=99s handle in addition to the file=E2=80=99s handle itself=
, then
>   verifying that the file does still reside in that directory when the
>   handle is opened, and then going up the tree to see whether we can
>   trace it back to the shared directory) is interesting and can perhaps
>   be considered elegant, but it requires iterating the directory the
>   file resides in when it is opened, and it will result in file handles
>   being invalidated whenever a file is moved (outside of its directory).
>   Perhaps also other issues.  In any case, there are reasons why NFS has
>   basically deprecated this.
>=20
> Opinions? :)

While the MAC option doesn't look too bad to me, I can't help but feel
that we're working around a kernel (mis)feature, which is something
that's risky and tends to backfire. It also worries me the fact that
we'd need to run virtiofsd with CAP_DAC_READ_SEARCH.

IIUC, we need this to avoid the need to keep an FD open for each entry
that's in the Guest's lookup cache, which is something that's probably
going to become a problem once we have dozens of virtiofsd instances
servicing VMs on the same Host (BTW, this is already a problem on
macOS, where the default *system-wide* NOFILE limit is a little over
10,000).

Perhaps we should try to aim higher and propose some kernel
extensions that would fit better our needs?

Thanks,
Sergio.


--v4ogi4of45kvar7b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEvtX891EthoCRQuii9GknjS8MAjUFAmBF6SkACgkQ9GknjS8M
AjWx9w//TtJ5ACE8qFCH5REHbp3Vo2A1cdWDKvZPR01qo9iiqyX5sVg1y4RZ4RkJ
BHOA85fpopjytGrWYhNNnih56gPO9+pJBPFkCjR5NwlkDzBu5uqIsTW2re45+LqH
CtbCmi3JiTx+R8U5bSh4ogc3yQLkmPsm0XD5dIY7UIcbqSI3roPZTh7eBrPJ/nnK
QkOpYazGqPA5u6I/gOKv+oKh4RLe97yqip4zF0bEZm4IIkY2OLVoDgVhw9x2SX/U
NMkmm8G+/lbA55R15Hbhr5KJjBf+eEGaVfYO9xgP1waaKsQroIhHDaKA8tmSUPqi
Yb/i7K6vK1rjEzN8FPj45DqAxfDLUSuif8idLEVmBWpJWKLM40olEtY2TeDxjjLH
O5Zj6Ib8ccnbdnfHwP7YOow5ux9JOR3gfF1jFlidAebmhFE4Z8JlzyANEtYgfmJ5
YVlSmSWa4fyBhnmshknrzzDhGcZkxpClZNDHUFOSz1bDgPhLavu4tHFnztJjR7cV
9/Zbjnh9g/mw7547T7YmNxOYaAQc/QOn37375aOvFfXQXieh6Bil9gLutxpNa2Ac
ZFjWFfmS4ZxmxMhMog2kKLQyYqPCxDVswLIvhz1sZhxyeGhOMFa00W04kAnTT10w
IsOqKzHas3pc6ZPrhPBOPfM78xE63qZgkMzmki7UzZTyBBHvwsU=
=9VAJ
-----END PGP SIGNATURE-----

--v4ogi4of45kvar7b--

