Date: Thu, 6 May 2021 16:02:45 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQFFVFq5+3KhaqM@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-13-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nwvIRNPPRvStkmrY"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-13-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 12/26] DAX: virtiofsd: Add setup/remove
 mappings fuse commands
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, vgoyal@redhat.com


--nwvIRNPPRvStkmrY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:46PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add commands so that the guest kernel can ask the daemon to map file
> sections into a guest kernel visible cache.
>=20
> Note: Catherine Ho had sent a patch to fix an issue with multiple
> removemapping. It was a merge issue though.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
> Including-fixes: Catherine Ho <catherine.hecx@gmail.com>
> Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c | 69 +++++++++++++++++++++++++++++++++
>  tools/virtiofsd/fuse_lowlevel.h | 23 ++++++++++-
>  2 files changed, 91 insertions(+), 1 deletion(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--nwvIRNPPRvStkmrY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUBRUACgkQnKSrs4Gr
c8ikHwf/agBt2zxfJ9tOcLP1Tmi+UOH9EU4df1Exw2BVdK2skXtyRuGp++P+wtUM
m8If55l7Pew4EKWMRMESuqCt5v7L7Um7s2h0U+IKqG1gNHpqFBbqL6KDvHcmhWHh
a/ns/OUB9hHwY5g9chpQsEkvN/lwaXp3SfbLdBwHj9gm+J2w1L/Btc8OUsnHdcsc
ZRmGmtAmJB2clijL8wm+CqQ2B+Zuxu1Hyle/u1trSfYloHaUwfey1/Ayv2ECh0pK
V4BZ2vraLIzqWFm2zPM/VN+0O7BSWD7AEw+Jmk6Xf0T+9O63VfthPDF3rx/UU2Ka
a9wtIWC1Z1ddeTd/RGHxKex70enRvQ==
=SMKU
-----END PGP SIGNATURE-----

--nwvIRNPPRvStkmrY--

