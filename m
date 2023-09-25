Return-Path: <stefanha@redhat.com>
Date: Mon, 25 Sep 2023 16:26:42 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230925202642.GF323580@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230915102531.55894-6-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="d5khHiGNigsVFP+D"
Content-Disposition: inline
In-Reply-To: <20230915102531.55894-6-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 5/5] vhost-user-fs: Implement internal
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>


--d5khHiGNigsVFP+D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 12:25:30PM +0200, Hanna Czenczek wrote:
> A virtio-fs device's VM state consists of:
> - the virtio device (vring) state (VMSTATE_VIRTIO_DEVICE)
> - the back-end's (virtiofsd's) internal state
>=20
> We get/set the latter via the new vhost operations to transfer migratory
> state.  It is its own dedicated subsection, so that for external
> migration, it can be disabled.
>=20
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 101 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)

CCing Anton so he is aware that internal migration is being added.

>=20
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 49d699ffc2..eb91723855 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -298,9 +298,108 @@ static struct vhost_dev *vuf_get_vhost(VirtIODevice=
 *vdev)
>      return &fs->vhost_dev;
>  }
> =20
> +/**
> + * Fetch the internal state from virtiofsd and save it to `f`.
> + */
> +static int vuf_save_state(QEMUFile *f, void *pv, size_t size,
> +                          const VMStateField *field, JSONWriter *vmdesc)
> +{
> +    VirtIODevice *vdev =3D pv;
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +    Error *local_error =3D NULL;
> +    int ret;
> +
> +    ret =3D vhost_save_backend_state(&fs->vhost_dev, f, &local_error);
> +    if (ret < 0) {
> +        error_reportf_err(local_error,
> +                          "Error saving back-end state of %s device %s "
> +                          "(tag: \"%s\"): ",
> +                          vdev->name, vdev->parent_obj.canonical_path,
> +                          fs->conf.tag ?: "<none>");
> +        return ret;
> +    }
> +
> +    return 0;
> +}
> +
> +/**
> + * Load virtiofsd's internal state from `f` and send it over to virtiofs=
d.
> + */
> +static int vuf_load_state(QEMUFile *f, void *pv, size_t size,
> +                          const VMStateField *field)
> +{
> +    VirtIODevice *vdev =3D pv;
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +    Error *local_error =3D NULL;
> +    int ret;
> +
> +    ret =3D vhost_load_backend_state(&fs->vhost_dev, f, &local_error);
> +    if (ret < 0) {
> +        error_reportf_err(local_error,
> +                          "Error loading back-end state of %s device %s "
> +                          "(tag: \"%s\"): ",
> +                          vdev->name, vdev->parent_obj.canonical_path,
> +                          fs->conf.tag ?: "<none>");
> +        return ret;
> +    }
> +
> +    return 0;
> +}
> +
> +static bool vuf_is_internal_migration(void *opaque)
> +{
> +    /* TODO: Return false when an external migration is requested */
> +    return true;
> +}
> +
> +static int vuf_check_migration_support(void *opaque)
> +{
> +    VirtIODevice *vdev =3D opaque;
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +
> +    if (!vhost_supports_device_state(&fs->vhost_dev)) {
> +        error_report("Back-end of %s device %s (tag: \"%s\") does not su=
pport "
> +                     "migration through qemu",
> +                     vdev->name, vdev->parent_obj.canonical_path,
> +                     fs->conf.tag ?: "<none>");
> +        return -ENOTSUP;
> +    }
> +
> +    return 0;
> +}
> +
> +static const VMStateDescription vuf_backend_vmstate;
> +
>  static const VMStateDescription vuf_vmstate =3D {
>      .name =3D "vhost-user-fs",
> -    .unmigratable =3D 1,
> +    .version_id =3D 0,
> +    .fields =3D (VMStateField[]) {
> +        VMSTATE_VIRTIO_DEVICE,
> +        VMSTATE_END_OF_LIST()
> +    },
> +    .subsections =3D (const VMStateDescription * []) {
> +        &vuf_backend_vmstate,
> +        NULL,
> +    }
> +};
> +
> +static const VMStateDescription vuf_backend_vmstate =3D {
> +    .name =3D "vhost-user-fs-backend",
> +    .version_id =3D 0,
> +    .needed =3D vuf_is_internal_migration,
> +    .pre_load =3D vuf_check_migration_support,
> +    .pre_save =3D vuf_check_migration_support,
> +    .fields =3D (VMStateField[]) {
> +        {
> +            .name =3D "back-end",
> +            .info =3D &(const VMStateInfo) {
> +                .name =3D "virtio-fs back-end state",
> +                .get =3D vuf_load_state,
> +                .put =3D vuf_save_state,
> +            },
> +        },
> +        VMSTATE_END_OF_LIST()
> +    },
>  };
> =20
>  static Property vuf_properties[] =3D {
> --=20
> 2.41.0
>=20

--d5khHiGNigsVFP+D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR7QIACgkQnKSrs4Gr
c8hWOQf4lTXUOU2gOOGvvnfaMIpciHn+yEYaANnHB9OYIGqW2lIrhEJhX79nL0/H
dRU+oduy+zya4lZd1Dt/Hmr/hecYo4IYRIIIp01RU7x9/QEk35BJalOcPlXTxx1K
xEWQt6zLjip7XP8w3uenYqBS3aAQnzkcHCF78HVtYvrDR458Xq0d+slTfhgUTxch
kqdH9Lzllle5tYzVWmnUB2df5J91NtbN6Kq7APpdY3VD0wRNAF7j8G9RJEyAZVDh
Q68Cy1vIH+qdTo+wWaJYjSD5qYMAjJx1OpBif4iGMhzgjUgI+dTlZPG3xrK6jq4U
pWW/+YfS/E+03GeWofilxJ2leBfH
=D7XB
-----END PGP SIGNATURE-----

--d5khHiGNigsVFP+D--
