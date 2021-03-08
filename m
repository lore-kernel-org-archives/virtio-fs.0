Date: Mon, 8 Mar 2021 15:01:08 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YEY8NNfHOp0h3HSB@stefanha-x1.localdomain>
References: <34a26a91-c73d-18cb-95ad-9b2c6192091c@redhat.com>
	<20210308090650.i5ow6pq23asygrod@mhamilton>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5kgQqYRt9Pc7xLYq"
Content-Disposition: inline
In-Reply-To: <20210308090650.i5ow6pq23asygrod@mhamilton>
Subject: Re: [Virtio-fs] Securing file handles
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Sergio Lopez <slp@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Max Reitz <mreitz@redhat.com>


--5kgQqYRt9Pc7xLYq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 08, 2021 at 10:06:50AM +0100, Sergio Lopez wrote:
> On Fri, Mar 05, 2021 at 05:22:56PM +0100, Max Reitz wrote:
> > =3D=3D Summary =3D=3D
> >=20
> > So, my current position is:
> >=20
> > - Bind mounts don=E2=80=99t help with restricting file handles to the e=
xported
> >   directory.
> >=20
> > - A MAC is not very elegant, and we might encounter problems where a
> >   file may be moved outside of the shared directory, but remains
> >   accessible (because moving a file doesn=E2=80=99t change its handle).
> >   (If we consider that a problem.  NFS evidently doesn=E2=80=99t, becau=
se
> >   without subtree_check, it has absolutely no protection against
> >   arbitrary file handles being opened (on the FS where the export
> >   resides), so valid file handles always remain valid.)
> >=20
> > - A solution such as NFS=E2=80=99s subtree_check (i.e., storing the fil=
e=E2=80=99s
> >   parent=E2=80=99s handle in addition to the file=E2=80=99s handle itse=
lf, then
> >   verifying that the file does still reside in that directory when the
> >   handle is opened, and then going up the tree to see whether we can
> >   trace it back to the shared directory) is interesting and can perhaps
> >   be considered elegant, but it requires iterating the directory the
> >   file resides in when it is opened, and it will result in file handles
> >   being invalidated whenever a file is moved (outside of its directory).
> >   Perhaps also other issues.  In any case, there are reasons why NFS has
> >   basically deprecated this.
> >=20
> > Opinions? :)
>=20
> While the MAC option doesn't look too bad to me, I can't help but feel
> that we're working around a kernel (mis)feature, which is something
> that's risky and tends to backfire. It also worries me the fact that
> we'd need to run virtiofsd with CAP_DAC_READ_SEARCH.
>=20
> IIUC, we need this to avoid the need to keep an FD open for each entry
> that's in the Guest's lookup cache, which is something that's probably
> going to become a problem once we have dozens of virtiofsd instances
> servicing VMs on the same Host (BTW, this is already a problem on
> macOS, where the default *system-wide* NOFILE limit is a little over
> 10,000).
>=20
> Perhaps we should try to aim higher and propose some kernel
> extensions that would fit better our needs?

Another option is to aim lower than everything that has been discussed
here:

Only support handle operations when the shared directory is the root of
a file system. That way the security issues are mostly eliminated.

The rationale is that most applications don't need file handles. If you
require file handles then you'll need to go through the effort of
creating a dedicated file system for the shared directory. For all other
cases, we'll disable file handle operations and not worry about it.

There is one security issue I can think of: if the host administrator
creates a mount inside the shared directory intended to "hide" access to
the files beneath, then I guess file handles could still access those
files.

Stefan

--5kgQqYRt9Pc7xLYq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmBGPDQACgkQnKSrs4Gr
c8ix3Af8CY2sr+5ox3Xi1G+kn9sZanSoEKKqpBQ4OVd9lAh1TbIlzVjsU9dBEdMk
Y/ujVZqjr9gVUxYOixF9cQRbKxEQX9Qe4zKJQGFPRH3LHBaVBEpti/tQoAyWgBFO
EOvteYJlZe2lfddyK4I7rmQeIHCRg9LuzvfuV5Suw6JvDM+sTPCJEygwlzpJ11dq
0X9hAxm+0627p21mWdnKHexHcY0zn7v7N/6GAT6Fuo0dCNTqCt06rMJkq6kDsGj8
QVAsBk3nTsUElQVcklM6ZH0ZJvDTVcqYJFGT0TNELryhMcdCf+sRG9ZQGxN4we2r
FDuG1puFd/on9GRLZItF/P4xvRRN+w==
=R7q0
-----END PGP SIGNATURE-----

--5kgQqYRt9Pc7xLYq--

