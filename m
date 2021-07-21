Date: Wed, 21 Jul 2021 16:46:28 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YPhBVNvubLmPyS4o@stefanha-x1.localdomain>
References: <20210714202321.59729-1-vgoyal@redhat.com>
	<20210714202321.59729-4-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="x9hm3usq3SofuOqJ"
Content-Disposition: inline
In-Reply-To: <20210714202321.59729-4-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 3/3] fs: simplify get_filesystem_list /
 get_all_fs_names
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, hch@lst.de


--x9hm3usq3SofuOqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 14, 2021 at 04:23:21PM -0400, Vivek Goyal wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> Just output the '\0' separate list of supported file systems for block
> devices directly rather than going through a pointless round of string
> manipulation.
>=20
> Based on an earlier patch from Al Viro <viro@zeniv.linux.org.uk>.
>=20
> Vivek:
> Modified list_bdev_fs_names() and split_fs_names() to return number of
> null terminted strings to caller. Callers now use that information to
> loop through all the strings instead of relying on one extra null char
> being present at the end.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/filesystems.c   | 27 +++++++++++++++----------
>  include/linux/fs.h |  2 +-
>  init/do_mounts.c   | 49 ++++++++++++++++++++--------------------------
>  3 files changed, 39 insertions(+), 39 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--x9hm3usq3SofuOqJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmD4QVQACgkQnKSrs4Gr
c8j6+wf/eCIyLjfPbaC2bDpUsd1HX+xCEm2IM/YdGOrDpW+yfjV9l8Kn7JVEN5S5
Um28SMkN3Cz4S72hwcjCCfZ652Aq81+vzDpEo83525nrnyroPwhZVBGwYh5+dH99
/8DEa2OQKRlMuq2PjxC9vGu5tIURKt6Z0LkzdeDfWyHFpHD0ygkIzKwYWVFvmyvY
a3NYpNs6wguRyrXPa6+CCPZNaxnNx6p/XXzH/3dl8BjhM903pwO1l7J++hE0+Uq6
s+HasCIofJS2GiPkgoRlMXKhDt816VCPVH9azrOHbaxc2hgTo0Z7yiXwjjq3sEhy
ZFeQhqUc/90PNjzTp4tXHS7ruEbJWw==
=NMQh
-----END PGP SIGNATURE-----

--x9hm3usq3SofuOqJ--

