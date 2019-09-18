Date: Wed, 18 Sep 2019 11:51:29 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190918105129.GJ26027@stefanha-x1.localdomain>
References: <20190906100324.8492-1-stefanha@redhat.com>
	<CAFLxGvw-n2VYcYR9kei7Hu2RBhCG9PeWuW7Z+SaiyDQVBRiugw@mail.gmail.com>
	<20190909070039.GB13708@stefanha-x1.localdomain>
	<CAFLxGvw51qeifCLwhV-8DKXNwC9=_5hFf==e7h4YCvFE5_Wz0A@mail.gmail.com>
	<20190917183029.GH1131@ZenIV.linux.org.uk>
	<20190917183425.GJ3370@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Ublo+h3cBgJ33ahC"
Content-Disposition: inline
In-Reply-To: <20190917183425.GJ3370@work-vm>
Subject: Re: [Virtio-fs] [PATCH] init/do_mounts.c: add virtiofs root fs
 support
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Richard Weinberger <richard.weinberger@gmail.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, Vivek Goyal <vgoyal@redhat.com>


--Ublo+h3cBgJ33ahC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2019 at 07:34:25PM +0100, Dr. David Alan Gilbert wrote:
> * Al Viro (viro@zeniv.linux.org.uk) wrote:
> > On Tue, Sep 17, 2019 at 08:19:55PM +0200, Richard Weinberger wrote:
> >=20
> > > mtd, ubi, virtiofs and 9p have one thing in common, they are not bloc=
k devices.
> > > What about a new miscroot=3D kernel parameter?
> >=20
> > How about something like xfs!sda5 or nfs!foo.local.net/bar, etc.?  With
> > ubi et.al. covered by the same syntax...
>=20
> Would Stefan's patch work if there was just a way to test for non-block
> based fileystsmes and we replaced
>    !strcmp(root_fs_names, "virtiofs") by
>    not_block_based_fs(root_fs_names)
>=20
> Or is there some magic that the other filesystems do that's specific?

I will try this.

Stefan

--Ublo+h3cBgJ33ahC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2CDDEACgkQnKSrs4Gr
c8gs/AgAv9VxZl8i2gfmfS0gmpYs3LWPWLMmUPTkehj4ThQGdXOQj4pv/tbqZ/MV
a/AM6mwKmhrD6ZNVrIj2Ft1Z5bURwCC/r6JoueOr5t2i0FGIyHYK3sbHJ2+8cg79
cmNXlnR7Dn1IsXITjDFJzovpQrN0bywWc3Leqga04+kDF3FlsvS8NMXYoiV8425o
ifbYwd/1fwqo17UARQzQuu5oYYX0F/X3AA5GQiqu3C1pXLYexDGHtj9aE1olfP5d
ayKOLZUB7DWkZuBPITpV3QgqSx4ONqntSJURE7eJzyYntSdqQlyIWG84lfFWJi60
+lmR36W6ZCROlGcY6Mk+1OskuOGsjg==
=6PWm
-----END PGP SIGNATURE-----

--Ublo+h3cBgJ33ahC--

