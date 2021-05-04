Date: Tue, 4 May 2021 16:23:38 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJFm+hocgArYnWAB@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-4-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="5/zrdj0q8vqjEIcX"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-4-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 03/26] DAX: vhost-user: Rework slave
	return values
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


--5/zrdj0q8vqjEIcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:37PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> All the current slave handlers on the qemu side generate an 'int'
> return value that's squashed down to a bool (!!ret) and stuffed into
> a uint64_t (field of a union) to be returned.
>=20
> Move the uint64_t type back up through the individual handlers so
> that we can make one actually return a full uint64_t.
>=20
> Note that the definition in the interop spec says most of these
> cases are defined as returning 0 on success and non-0 for failure,
> so it's OK to change from a bool to another non-0.
>=20
> Vivek:
> This is needed because upcoming patches in series will add new functions
> which want to return full error code. Existing functions continue to
> return true/false so, it should not lead to change of behavior for
> existing users.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Reviewed-by: Greg Kurz <groug@kaod.org>
> ---
>  hw/virtio/vhost-backend.c         |  6 +++---
>  hw/virtio/vhost-user.c            | 31 ++++++++++++++++---------------
>  include/hw/virtio/vhost-backend.h |  2 +-
>  3 files changed, 20 insertions(+), 19 deletions(-)
>=20
> diff --git a/hw/virtio/vhost-backend.c b/hw/virtio/vhost-backend.c
> index 31b33bde37..1686c94767 100644
> --- a/hw/virtio/vhost-backend.c
> +++ b/hw/virtio/vhost-backend.c
> @@ -401,8 +401,8 @@ int vhost_backend_invalidate_device_iotlb(struct vhos=
t_dev *dev,
>      return -ENODEV;
>  }
> =20
> -int vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
> -                                          struct vhost_iotlb_msg *imsg)
> +uint64_t vhost_backend_handle_iotlb_msg(struct vhost_dev *dev,
> +                                        struct vhost_iotlb_msg *imsg)
>  {
>      int ret =3D 0;

This patch is messy. We want uint64_t but these functions use int ret
internally. The actual return values are true/false instead of int 0 and
1.

Please use uint64_t everywhere: return 0 for success and 1 for failure
instead of bool literals and change the type of the local ret variables
to uint64_t.

--5/zrdj0q8vqjEIcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCRZvoACgkQnKSrs4Gr
c8hSxwgAhIRRgCfofoK5LR7BpWo9nxPvctmSjfFwzQ34/YadBAUgEFJ0CgFf1kpe
1FT84oUOenqvSsYsoQPityAnwchQ/VyKu1LskP3TEOiUQmFuAW1cnfrNiIal1Oie
hPnRXDWDSD/6tBKdfsOORbqU62yjS9YR4HUH6gJ38tKcRyPmV+Pb/PShsZDIYOI/
XFL7ckZyATsbY4N4SOdczrEa/m+Xo0BIqbI5s6dhJCa4yzwEmFNgYsVTYpC+3J6f
DMnShVLA1/q36hasc2SdZMQpt48VUgzGLQdptuasy7ttvJAXWk6oNraQPz39cP41
65pRj7W5dcr4w9omMEkVrRFnbhLFGw==
=l5IW
-----END PGP SIGNATURE-----

--5/zrdj0q8vqjEIcX--

