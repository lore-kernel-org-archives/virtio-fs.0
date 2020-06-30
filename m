Date: Tue, 30 Jun 2020 09:38:55 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200630083855.GA81930@stefanha-x1.localdomain>
References: <20200629115420.98443-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
In-Reply-To: <20200629115420.98443-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v2 0/3] virtiofsd capability changes and
	addition
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


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 29, 2020 at 12:54:17PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Hi,
>   This is a set of changes relating to the capability restirctions
> introduced in virtiofsd back in a59feb483b8.
> =20
> The first one is a potentially important fix; the missing terminator
> could mean extra capabilities are added based on junk on the stack;
> although that's not been seen in practice.
> =20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
>=20
> v2
>   Pass a copy of the parameter list into setup_capabilities
>=20
> Dr. David Alan Gilbert (3):
>   virtiofsd: Terminate capability list
>   virtiofsd: Check capability calls
>   virtiofsd: Allow addition or removal of capabilities
>=20
>  docs/tools/virtiofsd.rst         |  5 +++
>  tools/virtiofsd/helper.c         |  2 +
>  tools/virtiofsd/passthrough_ll.c | 71 +++++++++++++++++++++++++++++---
>  3 files changed, 73 insertions(+), 5 deletions(-)
>=20
> --=20
> 2.26.2
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl76+h8ACgkQnKSrs4Gr
c8gLwQgArIw3xavDwZLGTWzfsj7jBPmkfDBkYOacWFPI0orGa/FZDpKBH5f+O/rd
YlWz8odZFfnZWRIy9/q79jb77TNwxJztODXYJ342w1JU2RXA+ctAZvvQ41tgaGEe
xIVaBwILlJlzTP6r0S3dfXmN2s2uep3BS1RT5RIsrhatuZsjZFaKBHvhXsAgWu9h
yXX0F942J4XxSpYtAGb1uY4V+pLzFB2ikIP1y+Rje/blOkY8uZNy28I6JVwUz8gm
V7z6Iz7wIq04A8VjmNh99zzGmp1Mo0AJful88ASpdQOVF6UAgynFDST+bOgnwWIP
6cLHdC6fXhzgtuB1HNK/MbgCr0txdA==
=zVdw
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--

