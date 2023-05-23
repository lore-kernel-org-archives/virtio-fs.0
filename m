Return-Path: <stefanha@redhat.com>
Date: Tue, 23 May 2023 16:52:26 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230523205226.GE140337@fedora>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-7-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="pEofnJd+Ev51ey3k"
Content-Disposition: inline
In-Reply-To: <20230418162140.373219-7-alex.bennee@linaro.org>
Subject: Re: [Virtio-fs] [PATCH v2 06/13] include/hw/virtio: document some
 more usage of notifiers
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


--pEofnJd+Ev51ey3k
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 05:21:33PM +0100, Alex Benn=E9e wrote:
> Lets document some more of the core VirtIODevice structure.
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  include/hw/virtio/virtio.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 1ba7a9dd74..ef77e9ef0e 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -150,10 +150,18 @@ struct VirtIODevice
>      VMChangeStateEntry *vmstate;
>      char *bus_name;
>      uint8_t device_endian;
> +    /**
> +     * @user_guest_notifier_mask: gate usage of ->guest_notifier_mask() =
callback.

s/user_/use_/

> +     * This is used to suppress the masking of guest updates for
> +     * vhost-user devices which are asynchronous by design.

What is the exact reason why masking is not supported by vhost-user?

Only vhost-user-net and vhost-user-crypto set use_guest_notifier_mask to
false. Do the other vhost-user devices need to set it to false too?

> +     */
>      bool use_guest_notifier_mask;
>      AddressSpace *dma_as;
>      QLIST_HEAD(, VirtQueue) *vector_queues;
>      QTAILQ_ENTRY(VirtIODevice) next;
> +    /**
> +     * @config_notifier: the event notifier that handles config events

Using VIRTIO spec terminology:
"the event notifier that sends Configuration Change Notifications"

> +     */
>      EventNotifier config_notifier;
>  };
> =20
> --=20
> 2.39.2
>=20

--pEofnJd+Ev51ey3k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRtJ4oACgkQnKSrs4Gr
c8g59wgAyC/aLNruLTM1w0JWagBD1NcaOr44bvzMZQWgxcTGmewWz4H9iXRBwKjo
qZwOLXLJep5/XbgaCokCYOjBJVOG6WS1Ied43h0wQf3rNmkszL4BJlwsp31JCgyC
9/UXz18J9PxTu0tjINL9UIWYcoZsLlPO308q4ArZ0Pvy7vUAaD7F2ged044SCA2H
z0Vv2cY/Fc6woEwLULeztv3dWwl8gpMkgufSan+YLkfXlOfiAERrYvpRjubFEvIQ
sxYIM04R/jn2F4fFxpp6vgCKXp4TQ3ILoJ7a9zPv15bFM+2kVy0yb/zNQ6xBBxhi
R0+dyZCccrtD9nmW1zfkLFDfhAC/rA==
=BgtP
-----END PGP SIGNATURE-----

--pEofnJd+Ev51ey3k--
