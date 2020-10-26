Date: Mon, 26 Oct 2020 15:55:07 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20201026155507.GH52035@stefanha-x1.localdomain>
References: <20201023165812.36028-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="0XhtP95kHFp3KGBe"
Content-Disposition: inline
In-Reply-To: <20201023165812.36028-1-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v4 0/5] virtiofsd xattr name mappings
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: dinechin@redhat.com, virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--0XhtP95kHFp3KGBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 05:58:07PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> This is the 4th cut of an xattr name mapping option for virtiofsd.
> It allows the user of virtiofsd to define a fairly flexible mapping
> from the view of the xattr names the host fs has and the ones that the
> guest sees.
>=20
>   The hope is this allows things like:
>     a) Different selinux attributes on host/guest
>     b) separation of trusted. attributes that clash on overlayfs
>     c) support for privileged xattr's in guests running with an
>        unprivileged virtiofsd.
>=20
> There's no apparent standard for this kind of mapping, so I made
> it flexible by specifying a mapping rule in the option.
>=20
> Prefix's can be added (selectively or globally), xattr's can be
> dropped in either direction or passed through.
>=20
> v4
>   cleanups from Stefan and Vivek's reviews
>=20
> Dave
>=20
>=20
> Dr. David Alan Gilbert (5):
>   tools/virtiofsd: xattr name mappings: Add option
>   tools/virtiofsd: xattr name mappings: Map client xattr names
>   tools/virtiofsd: xattr name mappings: Map server xattr names
>   tools/virtiofsd: xattr name mapping examples
>   tools/virtiofsd: xattr name mappings: Simple 'map'
>=20
>  docs/tools/virtiofsd.rst         | 161 +++++++++++
>  tools/virtiofsd/passthrough_ll.c | 474 ++++++++++++++++++++++++++++++-
>  2 files changed, 632 insertions(+), 3 deletions(-)
>=20
> --=20
> 2.28.0
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--0XhtP95kHFp3KGBe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+W8VsACgkQnKSrs4Gr
c8gSDQgAvoLJAzqUAZWE3ZAPKZQ4CxxMbubcbZmw7ayb4k77FlxwYxJNcxJ1Z3as
ngcZY3KVCxcm9ra7fpxttaegIhdAb3p6r5lliABfltlIMlopjqRnEg5QhgVmmGoP
wfn+OvL06ST886JUSAUcnSRHz4WFG8JEF6vL6rwQySx0HFhNnP+CVcJDb/AQ/go5
CmEOoeTn18eZKty29q2EsIp+EgQuO1tWI4IXZzYeF9xMOTJkml4T5DTcbY4n+x6u
fqSLTGZa+pQlhl7gWBCUYWKfi2Xk2fxsetAIQuqYg7I8sIvIry6130mzerXfnF0H
Gh+TXTddfBABSWlftNTGvZCmQ74nEQ==
=+dAG
-----END PGP SIGNATURE-----

--0XhtP95kHFp3KGBe--

