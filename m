Date: Mon, 21 Jun 2021 14:31:44 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YNCUwHn0zfmDEWBN@stefanha-x1.localdomain>
References: <20210621062657.3641879-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="H1YdTb2mTDFGvvnD"
Content-Disposition: inline
In-Reply-To: <20210621062657.3641879-1-hch@lst.de>
Subject: Re: [Virtio-fs] support booting of arbitrary non-blockdevice file
 systems v2
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org


--H1YdTb2mTDFGvvnD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 21, 2021 at 08:26:55AM +0200, Christoph Hellwig wrote:
> Hi all,
>=20
> this series adds support to boot off arbitrary non-blockdevice root file
> systems, based off an earlier patch from Vivek.
>=20
> Chances since v1:
>  - don't try to mount every registered file system if none is specified
>  - fix various null pointer dereferences when certain kernel paramters are
>    not set
>  - general refactoring.
>=20
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs
>=20

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--H1YdTb2mTDFGvvnD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDQlMAACgkQnKSrs4Gr
c8ganQf/dsU6iKVjBTVUSkTJmH1WTbSid1kpQaMUGfq7OVc3uPC8blsmfBdRwlqv
e8rCiAH7mdtjXCVYEKB4q7+m9Yf6cKMYnGJ/yd0hgEnSxFEhYhoBWpOdRx/mj5Sy
JP1xUW110BheBPQrdD786/OHo0plrX7mKOvDA6txgn7sMAmrAtVyjd1dmqqbU/Nu
mYEf5YDcrqpmHFk8H9LHjK471p6pWUeDNwe687dnRaxvONAmg2stGXihP9Ycd4PM
avhMfaReTGAzo+ezyOEqtc6YTnKZrmU3TRcIg5MPpfR42yKGOIvazW6lKXpTiUmt
C8FEVeGCoSRA/kNi4zse1bhi4KpeQw==
=XrUf
-----END PGP SIGNATURE-----

--H1YdTb2mTDFGvvnD--

