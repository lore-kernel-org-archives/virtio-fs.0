Date: Wed, 5 May 2021 13:12:01 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJKLkQA2s6sgF587@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-9-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="VF0eZzRa3+i2nN3h"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-9-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 08/26] DAX: virtio-fs: Add cache BAR
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


--VF0eZzRa3+i2nN3h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:42PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
>=20
> Add a cache BAR into which files will be directly mapped.
> The size can be set with the cache-size=3D property, e.g.
>    -device vhost-user-fs-pci,chardev=3Dchar0,tag=3Dmyfs,cache-size=3D16G
>=20
> The default is no cache.
>=20
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> with PPC fixes by:
> Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
> ---
>  hw/virtio/vhost-user-fs-pci.c     | 32 +++++++++++++++++++++++++++++++
>  hw/virtio/vhost-user-fs.c         | 32 +++++++++++++++++++++++++++++++
>  include/hw/virtio/vhost-user-fs.h |  2 ++
>  3 files changed, 66 insertions(+)
>=20
> diff --git a/hw/virtio/vhost-user-fs-pci.c b/hw/virtio/vhost-user-fs-pci.c
> index 2ed8492b3f..20e447631f 100644
> --- a/hw/virtio/vhost-user-fs-pci.c
> +++ b/hw/virtio/vhost-user-fs-pci.c
> @@ -12,14 +12,19 @@
>   */
> =20
>  #include "qemu/osdep.h"
> +#include "qapi/error.h"
>  #include "hw/qdev-properties.h"
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "virtio-pci.h"
>  #include "qom/object.h"
> +#include "standard-headers/linux/virtio_fs.h"
> +
> +#define VIRTIO_FS_PCI_CACHE_BAR 2
> =20
>  struct VHostUserFSPCI {
>      VirtIOPCIProxy parent_obj;
>      VHostUserFS vdev;
> +    MemoryRegion cachebar;
>  };
> =20
>  typedef struct VHostUserFSPCI VHostUserFSPCI;
> @@ -38,7 +43,9 @@ static Property vhost_user_fs_pci_properties[] =3D {
>  static void vhost_user_fs_pci_realize(VirtIOPCIProxy *vpci_dev, Error **=
errp)
>  {
>      VHostUserFSPCI *dev =3D VHOST_USER_FS_PCI(vpci_dev);
> +    bool modern_pio =3D vpci_dev->flags & VIRTIO_PCI_FLAG_MODERN_PIO_NOT=
IFY;
>      DeviceState *vdev =3D DEVICE(&dev->vdev);
> +    uint64_t cachesize;
> =20
>      if (vpci_dev->nvectors =3D=3D DEV_NVECTORS_UNSPECIFIED) {
>          /* Also reserve config change and hiprio queue vectors */
> @@ -46,6 +53,31 @@ static void vhost_user_fs_pci_realize(VirtIOPCIProxy *=
vpci_dev, Error **errp)
>      }
> =20
>      qdev_realize(vdev, BUS(&vpci_dev->bus), errp);
> +    cachesize =3D dev->vdev.conf.cache_size;
> +
> +    if (cachesize && modern_pio) {
> +        error_setg(errp, "DAX Cache can not be used together with modern=
_pio");

It's not necessary to respin but it would help to capture the reason for
this limitation either in the error message or at least in a comment.

The problem is that PCI BARs are limited resources and enabling modern
PIO notify conflicts with the DAX Window BAR usage.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--VF0eZzRa3+i2nN3h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCSi5EACgkQnKSrs4Gr
c8ipBwf/dbWQcc1rtFMlUWSUUI8GtWI9VGtA+0cmpc49WP9Tj3Zfd0JFD3CO56S3
TAE08mhCu4qh6vgwtdTYdxapo17k6l64WLMd2/XhgbTw25ic8liTSTmpbezlCHgU
pkYJzrs+VbYvaMWUS05XnHLi9+CRdAmHq5XRVV+D0uVTNDo6kABWnTny8yC4F2bh
hmCmB5y5tpkqZYFzjOEayKE3ny00Rnsz53stvW8S13/OhbXDZDlVkcTwT3h9pN53
5IJnES9JtK81H07carmQvsFtteLqBGzWoGK3/FIwqlKSD3aCcuVy2UHP1R+I866n
3CAqw9ATEcAm1cWqyfeUzAmO0o6kOg==
=Glh0
-----END PGP SIGNATURE-----

--VF0eZzRa3+i2nN3h--

