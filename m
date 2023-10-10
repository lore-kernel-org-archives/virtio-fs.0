Return-Path: <stefanha@redhat.com>
Date: Tue, 10 Oct 2023 13:21:07 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20231010172107.GC1754551@fedora>
References: <20231005203030.223489-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="T8VF4ojPKKmYzx7M"
Content-Disposition: inline
In-Reply-To: <20231005203030.223489-1-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofs: Export filesystem tags through
 sysfs
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, virtio-fs@redhat.com, miklos@szeredi.hu, mzxreary@0pointer.de, gmaglione@redhat.com


--T8VF4ojPKKmYzx7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 05, 2023 at 04:30:30PM -0400, Vivek Goyal wrote:
> virtiofs filesystem is mounted using a "tag" which is exported by the
> virtiofs device. virtiofs driver knows about all the available tags but
> these are not exported to user space.
>=20
> People have asked these tags to be exported to user space. Most recently
> Lennart Poettering has asked for it as he wants to scan the tags and mount
> virtiofs automatically in certain cases.
>=20
> https://gitlab.com/virtio-fs/virtiofsd/-/issues/128
>=20
> This patch exports tags through sysfs. One tag is associated with each
> virtiofs device. A new "tag" file appears under virtiofs device dir.
> Actual filesystem tag can be obtained by reading this "tag" file.
>=20
> For example, if a virtiofs device exports tag "myfs", a new file "tag"
> will show up here.
>=20
> /sys/bus/virtio/devices/virtio<N>/tag
>=20
> # cat /sys/bus/virtio/devices/virtio<N>/tag
> myfs

If you respin this series, please mention that the tag is available at
KOBJ_BIND time, but not KOBJ_ADD. Just a sentence or two is enough to
help someone trying to figure out how to use this new sysfs attr with
udev.

>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--T8VF4ojPKKmYzx7M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUliAMACgkQnKSrs4Gr
c8gFpAf/SA1MUx5Dcoz3offMIyO0nLEn2uqzbGVkJLn15fqnoQVtsD4UfggTlOxL
8ZmSwgKqiKN3JATLyROHnNKhpzAADppA/uWMz2Bl2Jhvc0h0YGliaO5+GMgDSuOC
YqbHbKvR0oiPpn40sscxuO1XQze+gzf3TNyQWTiIW5GZE5WrEKJrzI82mTAKxaAP
cglLQugKYy/GyWvtWQAy+vbvcQ2XWdIFMhICurBV4euSj9SN2GcWjDBby8xXylaJ
ehxZsZ41OmBVvybNV1JTne3bXn2yJJM9aKdNklDbOhUIaJ9zsLdNbBQwTmTeeT7W
kgyCdy/ppZbKlVkpAZeBQ0VbLx1qMg==
=Ef0b
-----END PGP SIGNATURE-----

--T8VF4ojPKKmYzx7M--
