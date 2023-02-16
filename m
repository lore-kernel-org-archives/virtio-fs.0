Return-Path: <stefanha@redhat.com>
Date: Thu, 16 Feb 2023 16:09:02 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <Y+6bbqsZZ4OPo63M@fedora>
References: <20230216140003.1103681-1-antonkuchin@yandex-team.ru>
 <20230216140003.1103681-2-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="8kkvnftaTFtj+oiX"
Content-Disposition: inline
In-Reply-To: <20230216140003.1103681-2-antonkuchin@yandex-team.ru>
Subject: Re: [Virtio-fs] [PATCH v2 1/1] vhost-user-fs: add property to allow
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Markus Armbruster <armbru@redhat.com>, yc-core@yandex-team.ru, virtio-fs@redhat.com, Eric Blake <eblake@redhat.com>, Juan Quintela <quintela@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>


--8kkvnftaTFtj+oiX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 16, 2023 at 04:00:03PM +0200, Anton Kuchin wrote:
> Now any vhost-user-fs device makes VM unmigratable, that also prevents
> qemu update without stopping the VM. In most cases that makes sense
> because qemu has no way to transfer FUSE session state.
>=20
> But it is good to have an option for orchestrator to tune this according =
to
> backend capabilities and migration configuration.
>=20
> This patch adds device property 'migration' that is 'none' by default
> to keep old behaviour but can be set to 'external' to explicitly allow
> migration with minimal virtio device state in migration stream if daemon
> has some way to sync FUSE state on src and dst without help from qemu.
>=20
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>
> ---
>  hw/core/qdev-properties-system.c    | 10 +++++++++
>  hw/virtio/vhost-user-fs.c           | 34 ++++++++++++++++++++++++++++-
>  include/hw/qdev-properties-system.h |  1 +
>  include/hw/virtio/vhost-user-fs.h   |  1 +
>  qapi/migration.json                 | 16 ++++++++++++++
>  5 files changed, 61 insertions(+), 1 deletion(-)

Looks okay to me. Comments below.

> diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-s=
ystem.c
> index d42493f630..d9b1aa2a5d 100644
> --- a/hw/core/qdev-properties-system.c
> +++ b/hw/core/qdev-properties-system.c
> @@ -1143,3 +1143,13 @@ const PropertyInfo qdev_prop_uuid =3D {
>      .set   =3D set_uuid,
>      .set_default_value =3D set_default_uuid_auto,
>  };
> +
> +const PropertyInfo qdev_prop_vhost_user_migration_type =3D {
> +    .name =3D "VhostUserMigrationType",
> +    .description =3D "none/external",
> +    .enum_table =3D &VhostUserMigrationType_lookup,
> +    .get =3D qdev_propinfo_get_enum,
> +    .set =3D qdev_propinfo_set_enum,
> +    .set_default_value =3D qdev_propinfo_set_default_value_enum,
> +    .realized_set_allowed =3D true,
> +};
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 83fc20e49e..e2a5b6cfdf 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -24,6 +24,7 @@
>  #include "hw/virtio/vhost-user-fs.h"
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
> +#include "qapi/qapi-types-migration.h"
> =20
>  static const int user_feature_bits[] =3D {
>      VIRTIO_F_VERSION_1,
> @@ -298,9 +299,36 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice =
*vdev)
>      return &fs->vhost_dev;
>  }
> =20
> +static int vhost_user_fs_pre_save(void *opaque)
> +{
> +    VHostUserFS *fs =3D (VHostUserFS *)opaque;
> +    g_autofree char *path =3D object_get_canonical_path(OBJECT(fs));
> +
> +    switch (fs->migration_type) {
> +    case VHOST_USER_MIGRATION_TYPE_NONE:
> +        error_report("Migration is blocked by device %s", path);
> +        break;
> +    case VHOST_USER_MIGRATION_TYPE_EXTERNAL:
> +        return 0;
> +    default:
> +        error_report("Migration type '%s' is not supported by device %s",
> +                     VhostUserMigrationType_str(fs->migration_type), pat=
h);
> +        break;
> +    }
> +
> +    return -1;
> +}
> +
>  static const VMStateDescription vuf_vmstate =3D {
>      .name =3D "vhost-user-fs",
> -    .unmigratable =3D 1,
> +    .minimum_version_id =3D 0,
> +    .version_id =3D 0,
> +    .fields =3D (VMStateField[]) {
> +        VMSTATE_VIRTIO_DEVICE,
> +        VMSTATE_UINT8(migration_type, VHostUserFS),

Maybe add a comment since Michael asked what the purpose of this field
is:

  /* For verifying that source/destination migration=3D properties match */
  VMSTATE_UINT8(migration_type, VHostUserFS),

Come to think of it...where is the code that checks the vmstate
migration_type field matches the destination device's migration=3D
property?

> +        VMSTATE_END_OF_LIST()
> +    },
> +   .pre_save =3D vhost_user_fs_pre_save,
>  };
> =20
>  static Property vuf_properties[] =3D {
> @@ -309,6 +337,10 @@ static Property vuf_properties[] =3D {
>      DEFINE_PROP_UINT16("num-request-queues", VHostUserFS,
>                         conf.num_request_queues, 1),
>      DEFINE_PROP_UINT16("queue-size", VHostUserFS, conf.queue_size, 128),
> +    DEFINE_PROP_UNSIGNED("migration", VHostUserFS, migration_type,
> +                         VHOST_USER_MIGRATION_TYPE_NONE,
> +                         qdev_prop_vhost_user_migration_type,
> +                         uint8_t),
>      DEFINE_PROP_END_OF_LIST(),
>  };
> =20
> diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-proper=
ties-system.h
> index 0ac327ae60..1a67591590 100644
> --- a/include/hw/qdev-properties-system.h
> +++ b/include/hw/qdev-properties-system.h
> @@ -22,6 +22,7 @@ extern const PropertyInfo qdev_prop_audiodev;
>  extern const PropertyInfo qdev_prop_off_auto_pcibar;
>  extern const PropertyInfo qdev_prop_pcie_link_speed;
>  extern const PropertyInfo qdev_prop_pcie_link_width;
> +extern const PropertyInfo qdev_prop_vhost_user_migration_type;
> =20
>  #define DEFINE_PROP_PCI_DEVFN(_n, _s, _f, _d)                   \
>      DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_pci_devfn, int32_t)
> diff --git a/include/hw/virtio/vhost-user-fs.h b/include/hw/virtio/vhost-=
user-fs.h
> index 94c3aaa84e..3ebce77be5 100644
> --- a/include/hw/virtio/vhost-user-fs.h
> +++ b/include/hw/virtio/vhost-user-fs.h
> @@ -40,6 +40,7 @@ struct VHostUserFS {
>      VirtQueue **req_vqs;
>      VirtQueue *hiprio_vq;
>      int32_t bootindex;
> +    uint8_t migration_type;
> =20
>      /*< public >*/
>  };
> diff --git a/qapi/migration.json b/qapi/migration.json
> index c84fa10e86..ababd605a2 100644
> --- a/qapi/migration.json
> +++ b/qapi/migration.json
> @@ -2178,3 +2178,19 @@
>    'data': { 'job-id': 'str',
>              'tag': 'str',
>              'devices': ['str'] } }
> +
> +##
> +# @VhostUserMigrationType:
> +#
> +# Type of vhost-user device migration.
> +#
> +# @none: Migration is not supported, attempts to migrate with this device
> +#        will be blocked.
> +#
> +# @external: Migration stream contains only virtio device state,
> +#            deamon state should be transfered externally by orchestrato=
r.

s/deamon/daemon/
s/transfered/transferred/

> +#
> +# Since: 8.0
> +##
> +{ 'enum': 'VhostUserMigrationType',
> +  'data': [ 'none', 'external' ] }
> --=20
> 2.37.2
>=20

--8kkvnftaTFtj+oiX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmPum24ACgkQnKSrs4Gr
c8iL5wgAysnzdJrABCwwfHbpww87nBwQCpGDdfPrQLsLXA41kDAlFG4lYWTgu0Gh
nEcXnoruOV0kPwugF5fXeA/gLuxIZgQcxHuO+pxOxGo3+y+cIUMYsZwSezMfMKmp
nHO8apG8avvQM+H0yacHYbu4lK1plpHNKRDXdqdoA6mZnNDZijhjslPceYfhiLcW
AL6U7nT96MYeLk1tug2Mh/cr/MBGhWJiVABNFTraesatxQVWG2MS226s06HRVj6E
MTkRbcShz1QN5GM5ywNAmwUMkVNY9ujB77zM+B2KwGsnNe6eQqItkIYgxo+e0+6N
mvgK8Ev5GxJdnziAaELSOP55ktFiLQ==
=+Il4
-----END PGP SIGNATURE-----

--8kkvnftaTFtj+oiX--
