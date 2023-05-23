Return-Path: <stefanha@redhat.com>
Date: Tue, 23 May 2023 16:35:01 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230523203501.GB140337@fedora>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-4-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="JA4+quDfuMdiE1Nu"
Content-Disposition: inline
In-Reply-To: <20230418162140.373219-4-alex.bennee@linaro.org>
Subject: Re: [Virtio-fs] [PATCH v2 03/13] hw/virtio: fix typo in
 VIRTIO_CONFIG_IRQ_IDX comments
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


--JA4+quDfuMdiE1Nu
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 05:21:30PM +0100, Alex Benn=E9e wrote:
> Fixes: 544f0278af (virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX)
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  hw/display/vhost-user-gpu.c    | 4 ++--
>  hw/net/virtio-net.c            | 4 ++--
>  hw/virtio/vhost-user-fs.c      | 4 ++--
>  hw/virtio/vhost-user-gpio.c    | 2 +-
>  hw/virtio/vhost-vsock-common.c | 4 ++--
>  hw/virtio/virtio-crypto.c      | 4 ++--
>  6 files changed, 11 insertions(+), 11 deletions(-)
>=20
> diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
> index 71dfd956b8..7c61a7c3ac 100644
> --- a/hw/display/vhost-user-gpu.c
> +++ b/hw/display/vhost-user-gpu.c
> @@ -489,7 +489,7 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *v=
dev, int idx)
> =20
>      /*
>       * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX =
-1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>       * support, the function will return
>       */

The entire comment could be rewritten to make the punctuation and
grammar correct, if you want.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--JA4+quDfuMdiE1Nu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRtI3UACgkQnKSrs4Gr
c8jahAgAjNJL7hdL0me7Krt5f48JEWKVlbfdPmI5YsuNOD2rK9wUPekqO14fMTGG
SweDE5VEvQfMEHxfB1Blk20yRbk5sb09K2bO0FOnvvgzNdqGXxpQqQs/qv3Py+WB
MzAvyNWG8oTGRS/9n8iOosrueQTeXJ7hwstKGA9TVW9nbX2za5+TIPi1MDNxL8nO
ax/dzHey5HXCJCVamyP0lQDlYq/8EWfsoY4rwXQkgvr/bExzQV/HCuIIjzpQSfXl
4HOE9ps/HaOghhB26uiOjO8pCGgBaMBfVR3oHOqJNtBrOJPRSaU6ChjTPRjTH3Ab
hRwIHK2d8V1TnX4LimyqVUy9hBzmeQ==
=ZMIo
-----END PGP SIGNATURE-----

--JA4+quDfuMdiE1Nu--
