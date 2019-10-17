Date: Thu, 17 Oct 2019 17:11:50 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191017161150.GD1266@stefanha-x1.localdomain>
References: <20191016160157.12414-1-stefanha@redhat.com>
	<20191016160157.12414-3-stefanha@redhat.com>
	<20191017144553.GA12588@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <20191017144553.GA12588@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/2] virtiofsd: move to a new pid namespace
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2019 at 10:45:53AM -0400, Vivek Goyal wrote:
> On Wed, Oct 16, 2019 at 05:01:57PM +0100, Stefan Hajnoczi wrote:
>=20
> [..]
> > +	/*
> > +	 * If the mounts have shared propagation then we want to opt out so o=
ur
> > +	 * mount changes don't affect the parent mount namespace.
> > +	 */
> > +	if (mount(NULL, "/", NULL, MS_REC|MS_SLAVE, NULL) < 0) {
> > +		fuse_log(FUSE_LOG_ERR, "mount(/, MS_REC|MS_SLAVE): %m\n");
> > +		exit(1);
> > +	}
>=20
> So we will get mount propogation form parent but our mounts will not
> propagate back. Sounds reasonable.
>=20
> Can we take away CAP_SYS_ADMIN from virtiofsd? That way it will not be=20
> able to do mount at all.=20
>=20
> I am wondering are we dependent on daemon having CAP_SYS_ADMIN.=20

I don't know the answer.  Additional patches to reduce the capability
set as much as possible would be great, but are a separate task.

Stefan

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2oksYACgkQnKSrs4Gr
c8gRPAf/WjlSHNmLI310xJzO+cYRNz6NrPw79qoYflQ98baGOpkUsQ2rKn7pT76M
g/aPiAYEWwydbnlQvcOoPuVjWVVn7eDuhyUza5ezu6iT5DEqmCVIk284sClJdWXv
CRpPxOeRc1wkJwkIE2qyAKCfjt/gKy5cXfQ56vudM64YKOxoyN31xNUlvk9i+R5i
M90QW4jpqb0rTlV7S4C/I6JVI2NGYy/uqm7qWIJ7umst+/G9Mi91JjQ+3zOK9yd6
TI2Wj+Eguv672sIGHLgmzdLgo0NI1fEL2jOmu4crijOfYEwJ2MpwZtZYeP6UN6zR
h93HcxFa7H2DRSU/CqRicj1rIQrhIg==
=pNX6
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--

