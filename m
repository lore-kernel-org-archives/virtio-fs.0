Return-Path: <stefanha@redhat.com>
Date: Tue, 23 May 2023 16:30:50 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230523203050.GA140337@fedora>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-2-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="PC9Bjrkp6WHWj9an"
Content-Disposition: inline
In-Reply-To: <20230418162140.373219-2-alex.bennee@linaro.org>
Subject: Re: [Virtio-fs] [PATCH v2 01/13] include: attempt to document
 device_class_set_props
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Eric Blake <eblake@redhat.com>


--PC9Bjrkp6WHWj9an
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 05:21:28PM +0100, Alex Benn=E9e wrote:
> I'm still not sure how I achieve by use case of the parent class
> defining the following properties:
>=20
>   static Property vud_properties[] =3D {
>       DEFINE_PROP_CHR("chardev", VHostUserDevice, chardev),
>       DEFINE_PROP_UINT16("id", VHostUserDevice, id, 0),
>       DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>=20
> But for the specialisation of the class I want the id to default to
> the actual device id, e.g.:
>=20
>   static Property vu_rng_properties[] =3D {
>       DEFINE_PROP_UINT16("id", VHostUserDevice, id, VIRTIO_ID_RNG),
>       DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>=20
> And so far the API for doing that isn't super clear.

Does this mean this patch is an RFC and this patch is not intended to be
merged?

>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  include/hw/qdev-core.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
> index bd50ad5ee1..d4bbc30c92 100644
> --- a/include/hw/qdev-core.h
> +++ b/include/hw/qdev-core.h
> @@ -776,6 +776,15 @@ BusState *sysbus_get_default(void);
>  char *qdev_get_fw_dev_path(DeviceState *dev);
>  char *qdev_get_own_fw_dev_path_from_handler(BusState *bus, DeviceState *=
dev);
> =20
> +/**
> + * device_class_set_props(): add a set of properties to an device
> + * @dc: the parent DeviceClass all devices inherit
> + * @props: an array of properties, terminate by DEFINE_PROP_END_OF_LIST()
> + *
> + * This will add a set of properties to the object. It will fault if
> + * you attempt to add an existing property defined by a parent class.
> + * To modify an inherited property you need to use????
> + */
>  void device_class_set_props(DeviceClass *dc, Property *props);

I don't know the answer. There doesn't seem to be a way for child
classes to override parent DeviceClass properties. The assumption is the
sets of properties are disjoint (no property name collisions).

Here is a workaround in the vhost-user-rng code:

  /* Set our default if the user didn't specify the id */
  if (vud->id =3D=3D 0) {
      vud->id =3D VIRTIO_ID_RNG;
  }

This could be a problem because the value 0 may be valid and there is no
way to distinguish between a user setting 0 and the default 0 value.

Stefan

--PC9Bjrkp6WHWj9an
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRtInkACgkQnKSrs4Gr
c8ideAf/fY7NwL741baRcg8dmKRgnkLPgbeN77W6nL0T1wZOsClqaLyL5W8/O7ay
07mljSqgRitIoelleLtXDwqm7W3g6iaJoR9fa/SV4Hy5IbdZ/bwg3oZh7wHdQJer
fAkklvVfo62j2aAs6fwPCWVW5cTv/QqbpdxNs8wWkBWTG1yaJ8l3EvJHCeAQdJIY
xh5dM7yNszqqzRt71xfrYOG8AykBMhcRpQJjEl5QMRVhmJiAtdNXjr/KXkiecYCH
ijfzs45RliLTF5sWlMZlFrnPrfs4B7PXcy9IysOgyAJeKekUgCSu+GwWgBc85vLy
lzFkKNbhv+7Nv9Kl/UXA8pdtVL8JGA==
=/Ufy
-----END PGP SIGNATURE-----

--PC9Bjrkp6WHWj9an--
