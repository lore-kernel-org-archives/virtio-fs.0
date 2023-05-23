Return-Path: <stefanha@redhat.com>
Date: Tue, 23 May 2023 16:40:24 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230523204024.GC140337@fedora>
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-5-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="n+4RkN+DFQIpOtH2"
Content-Disposition: inline
In-Reply-To: <20230418162140.373219-5-alex.bennee@linaro.org>
Subject: Re: [Virtio-fs] [PATCH v2 04/13] include/hw/virtio: document
 virtio_notify_config
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


--n+4RkN+DFQIpOtH2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 05:21:31PM +0100, Alex Benn=E9e wrote:
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> ---
>  include/hw/virtio/virtio.h | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index f236e94ca6..22ec098462 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -274,6 +274,13 @@ extern const VMStateInfo virtio_vmstate_info;
> =20
>  int virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id);
> =20
> +/**
> + * virtio_notify_config() - signal a change to device config
> + * @vdev: the virtio device

The spec calls this sending a Configuration Change Notification
(https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd01.htm=
l#x1-1110001).
I suggest using VIRTIO specification terminology, otherwise every person
paraphrases the spec and you have to guess how QEMU code/comments map to
the spec.

--n+4RkN+DFQIpOtH2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRtJLgACgkQnKSrs4Gr
c8j5gAgAk2asKwBxr19D07pYrcggJWhzcY1bdjNYAYyKLHQxAS7Z3iRW+5gI3MHj
6jF4OwmDC+SGaxCmHFiJ01nipfnEF8lksQlupqxmABr9Ql+Hg+HCl1ph8PP4YaCg
6twnx6ohKPZAM1A4od6ZhSa1rGEENJ+c/PY/KUY0nJ5bDx7wDbSLNyoHqZ4107R5
FXR4fthY9FuEb/3vVkXcvX4bKQj3qSa/09BXCcuJbX9HJaGbI0rP2/Pf1AvK+RDK
9VBzpMPjRFO7bdcyalohC32A/9FjXh+gyw8wY32WE5qWm5QVCJCldSnVczeAlMUe
lGS2dqmSrs0YR+J4MNzSP5dw9L5MvA==
=bKZx
-----END PGP SIGNATURE-----

--n+4RkN+DFQIpOtH2--
