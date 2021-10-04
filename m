Date: Mon, 4 Oct 2021 14:54:17 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsHifrJdRtVyERb@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-7-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CWiKzr2oM9sJPKTF"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-7-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 06/13] vhost-user-fs: Use helpers to
 create/cleanup virtqueue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, qemu-devel@nongnu.org, virtio-fs@redhat.com


--CWiKzr2oM9sJPKTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:30AM -0400, Vivek Goyal wrote:
> Add helpers to create/cleanup virtuqueues and use those helpers. I will

s/virtuqueues/virtqueues/

> need to reconfigure queues in later patches and using helpers will allow
> reusing the code.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 87 +++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 35 deletions(-)
>=20
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index c595957983..d1efbc5b18 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -139,6 +139,55 @@ static void vuf_set_status(VirtIODevice *vdev, uint8=
_t status)
>      }
>  }
> =20
> +static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    /*
> +     * Not normally called; it's the daemon that handles the queue;
> +     * however virtio's cleanup path can call this.
> +     */
> +}
> +
> +static void vuf_create_vqs(VirtIODevice *vdev)
> +{
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +    unsigned int i;
> +
> +    /* Hiprio queue */
> +    fs->hiprio_vq =3D virtio_add_queue(vdev, fs->conf.queue_size,
> +                                     vuf_handle_output);
> +
> +    /* Request queues */
> +    fs->req_vqs =3D g_new(VirtQueue *, fs->conf.num_request_queues);
> +    for (i =3D 0; i < fs->conf.num_request_queues; i++) {
> +        fs->req_vqs[i] =3D virtio_add_queue(vdev, fs->conf.queue_size,
> +                                          vuf_handle_output);
> +    }
> +
> +    /* 1 high prio queue, plus the number configured */
> +    fs->vhost_dev.nvqs =3D 1 + fs->conf.num_request_queues;
> +    fs->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, fs->vhost_dev.n=
vqs);

These two lines prepare for vhost_dev_init(), so moving them here is
debatable. If a caller is going to use this function again in the future
then they need to be sure to also call vhost_dev_init(). For now it
looks safe, so I guess it's okay.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--CWiKzr2oM9sJPKTF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbB4kACgkQnKSrs4Gr
c8hGlAgAwmM9a8sFrj+13RbkfOirZZX1fbsCv8nLOQLAxgIvluvq6AGf8aXsvmsW
I74wKaz05bQVw9hXBONNyiKRvytwPh1ybhXmolEkwE97vVRUq6REGwknLTEHf4EL
UX8azUs7mVvDl0zBCTb29ThkJuYouy6+jYE9xYJLt5fRyzbfIdi87XKZ/nywm/Fq
yCPpNUlSll7D/Sp7NqkjRXQB/gw8edbkx5H7DjFx8I1sigQ/2c5qFQ04OV2iNCSj
/NaaC5Xwm7gt6M5h8cE2LkgznzoavqTmoYVw2/ZIE/pwGkC4B1vYsL9fUJpyddER
dRTzy96Dcp+pL8fbZ5wzEBaVd2QJxA==
=RyaR
-----END PGP SIGNATURE-----

--CWiKzr2oM9sJPKTF--

