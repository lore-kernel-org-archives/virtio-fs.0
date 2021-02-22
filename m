Date: Mon, 22 Feb 2021 16:53:19 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YDPhf3ycwo6+2QrQ@stefanha-x1.localdomain>
References: <20210209190224.62827-1-dgilbert@redhat.com>
	<20210209190224.62827-24-dgilbert@redhat.com>
	<20210211143542.GT247031@stefanha-x1.localdomain>
	<20210211144031.GB5014@redhat.com>
	<20210215155711.GA95852@stefanha-x1.localdomain>
	<20210216155710.GB10195@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="kzj3RFwlzhzPtnxL"
Content-Disposition: inline
In-Reply-To: <20210216155710.GB10195@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 23/24] vhost-user-fs: Implement drop
 CAP_FSETID functionality
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com, qemu-devel@nongnu.org


--kzj3RFwlzhzPtnxL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 16, 2021 at 10:57:10AM -0500, Vivek Goyal wrote:
> On Mon, Feb 15, 2021 at 03:57:11PM +0000, Stefan Hajnoczi wrote:
> > On Thu, Feb 11, 2021 at 09:40:31AM -0500, Vivek Goyal wrote:
> > > On Thu, Feb 11, 2021 at 02:35:42PM +0000, Stefan Hajnoczi wrote:
> > > > On Tue, Feb 09, 2021 at 07:02:23PM +0000, Dr. David Alan Gilbert (g=
it) wrote:
> > > > > From: Vivek Goyal <vgoyal@redhat.com>
> > > > >=20
> > > > > As part of slave_io message, slave can ask to do I/O on an fd. Ad=
ditionally
> > > > > slave can ask for dropping CAP_FSETID (if master has it) before d=
oing I/O.
> > > > > Implement functionality to drop CAP_FSETID and gain it back after=
 the
> > > > > operation.
> > > > >=20
> > > > > This also creates a dependency on libcap-ng.
> > > >=20
> > > > Is this patch only for the case where QEMU is running as root?
> > > >=20
> > >=20
> > > Yes, it primarily is for the case where qemu is running as root, or
> > > somebody managed to launch it non-root but with still having capabili=
ty
> > > CAP_FSETID.
> >=20
> > Running QEMU as root is not encouraged because the security model is
> > designed around the principle of least privilege (only give QEMU access
> > to resources that belong to the guest).
> >=20
> > What happens in the case where QEMU is not root? Does that mean QEMU
> > will drop suid/guid bits even if the FUSE client wanted them to be
> > preserved?
>=20
> QEMU will drop CAP_FSETID only if vhost-user slave asked for it. There
> is no notion of gaining CAP_FSETID.
>=20
> IOW, yes, if qemu is running unpriviliged and does not have CAP_FSETID,
> then we will end up clearing setuid bit on host. Not sure how that
> problem can be fixed.

Yeah, that seems problematic since the suid bit should stay set in that
case. The host cannot set the bit again (even if it has privileges)
because that would create a race condition where the guest expects the
bit set but it's cleared.

Stefan

--kzj3RFwlzhzPtnxL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmAz4X8ACgkQnKSrs4Gr
c8hcrAf/TQ4PMBHy9o3liFFKGSxf2MZL0mBZ8h/AQhQ5FkBuNi0ooYb5H3OuUqAJ
mtdv5kpIWzAyxpW+NB/hQVLeIsh6Zx3JGldlzkd5xapfZZabwaSM3Uwb/zH5pnTd
P1u5NcbrIAgy47WwRuL3X4pigojMTmskPboq3SZni9TsjDwRrNgqGQShSD+m+nZ/
3/7v1Z8LKHYwV4NUC3BuuNfEjLiP5mM+rqKl14ecoIHHZmNppzr0sD8C70AwkaGR
0e6xHiKYHod3uongdb5378/qVi0AtZrsu4OztP951dN2mpz3dt+NusEXbG9/c0T9
6NPowwywXFY5pY5+PKJLqfin4dU3iQ==
=Ly/6
-----END PGP SIGNATURE-----

--kzj3RFwlzhzPtnxL--

