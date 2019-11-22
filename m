Date: Fri, 22 Nov 2019 10:19:03 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191122101903.GC464656@stefanha-x1.localdomain>
References: <20191115205543.1816-1-vgoyal@redhat.com>
	<20191115205543.1816-3-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="B4IIlcmfBL/1gGOG"
Content-Disposition: inline
In-Reply-To: <20191115205543.1816-3-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] virtiofd: Create a notification queue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, miklos@szeredi.hu, qemu-devel@nongnu.org


--B4IIlcmfBL/1gGOG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:55:41PM -0500, Vivek Goyal wrote:
>  /* Callback from libvhost-user */
>  static void fv_set_features(VuDev *dev, uint64_t features)
>  {
> +    struct fv_VuDev *vud =3D container_of(dev, struct fv_VuDev, dev);
> +    struct fuse_session *se =3D vud->se;
> +
> +    if ((1 << VIRTIO_FS_F_NOTIFICATION) & features) {

For consistency 1ull should be used.  That way the reader does not have
to check the bit position to verify that the bitmap isn't truncated at
32 bits.

> +        vud->notify_enabled =3D true;
> +        se->notify_enabled =3D true;

Only one copy of this field is needed.  vud has a pointer to se.

> +    }
>  }
> =20
>  /*
> @@ -662,6 +671,65 @@ static void fv_queue_worker(gpointer data, gpointer =
user_data)
>      free(req);
>  }
> =20
> +static void *fv_queue_notify_thread(void *opaque)
> +{
> +    struct fv_QueueInfo *qi =3D opaque;
> +
> +    fuse_log(FUSE_LOG_INFO, "%s: Start for queue %d kick_fd %d\n", __fun=
c__,
> +             qi->qidx, qi->kick_fd);
> +
> +    while (1) {
> +        struct pollfd pf[2];
> +
> +        pf[0].fd =3D qi->kick_fd;
> +        pf[0].events =3D POLLIN;
> +        pf[0].revents =3D 0;
> +        pf[1].fd =3D qi->kill_fd;
> +        pf[1].events =3D POLLIN;
> +        pf[1].revents =3D 0;
> +
> +        fuse_log(FUSE_LOG_DEBUG, "%s: Waiting for Queue %d event\n", __f=
unc__,
> +                 qi->qidx);
> +        int poll_res =3D ppoll(pf, 2, NULL, NULL);
> +
> +        if (poll_res =3D=3D -1) {
> +            if (errno =3D=3D EINTR) {
> +                fuse_log(FUSE_LOG_INFO, "%s: ppoll interrupted, going ar=
ound\n",
> +                         __func__);
> +                continue;
> +            }
> +            fuse_log(FUSE_LOG_ERR, "fv_queue_thread ppoll: %m\n");
> +            break;
> +        }
> +        assert(poll_res >=3D 1);
> +        if (pf[0].revents & (POLLERR | POLLHUP | POLLNVAL)) {
> +            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue=
 %d\n",
> +                     __func__, pf[0].revents, qi->qidx);
> +             break;
> +        }
> +        if (pf[1].revents & (POLLERR | POLLHUP | POLLNVAL)) {
> +            fuse_log(FUSE_LOG_ERR, "%s: Unexpected poll revents %x Queue=
 %d"
> +                     "killfd\n", __func__, pf[1].revents, qi->qidx);
> +            break;
> +        }
> +        if (pf[1].revents) {
> +            fuse_log(FUSE_LOG_INFO, "%s: kill event on queue %d - quitti=
ng\n",
> +                     __func__, qi->qidx);
> +            break;
> +        }
> +        assert(pf[0].revents & POLLIN);
> +        fuse_log(FUSE_LOG_DEBUG, "%s: Got queue event on Queue %d\n", __=
func__,
> +                 qi->qidx);
> +
> +        eventfd_t evalue;
> +        if (eventfd_read(qi->kick_fd, &evalue)) {
> +            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
> +            break;
> +        }
> +    }
> +    return NULL;
> +}

It's difficult to review function without any actual functionality using
the virtqueue.  I'm not sure a thread is even needed since the device
only needs to get a buffer when it has a notification for the driver.
I'll have to wait for the following patches to see what happens here...

> @@ -378,12 +382,23 @@ static void vuf_set_status(VirtIODevice *vdev, uint=
8_t status)
>      }
>  }
> =20
> -static uint64_t vuf_get_features(VirtIODevice *vdev,
> -                                      uint64_t requested_features,
> -                                      Error **errp)
> +static uint64_t vuf_get_features(VirtIODevice *vdev, uint64_t features,
> +                                 Error **errp)
>  {
> -    /* No feature bits used yet */
> -    return requested_features;
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +
> +    virtio_add_feature(&features, VIRTIO_FS_F_NOTIFICATION);
> +
> +    return vhost_get_features(&fs->vhost_dev, user_feature_bits, feature=
s);
> +}
> +
> +static void vuf_set_features(VirtIODevice *vdev, uint64_t features)
> +{
> +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> +
> +    if (virtio_has_feature(features, VIRTIO_FS_F_NOTIFICATION)) {
> +        fs->notify_enabled =3D true;

This field is unused, please remove it.

--B4IIlcmfBL/1gGOG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3XthcACgkQnKSrs4Gr
c8gs5Qf+LyPnQ5S6B38Cg32zP4Ue8WZjyuFmlqBTKJ46vyg7gWkF6vDxWRDt/qu1
Q1cG3ErePIynsgV1rQyWTRKY0Yx82eahfFeh0QjOJYWwgfWbcRwb+oPUgCUQutXh
slBJu7InNwyhHnVQYNgXJoltwRVHdg7GA/sUqTbf1pEuocyFoFXInGWGppEystT4
R9cpoEEtDUqxUvES0DHGZ4f67qXQyAm8WGxfRC/wPZURActXeBEryqt2aShJ7dl2
FU7OdYj6Fr8XoCSdCLLsEOl5JOEk/ECkYLai3ZBaq+LHARXF68vSlwj8u81M6ffK
vSQaMpxLrn43n16CieagYSw2XTPqEw==
=oibv
-----END PGP SIGNATURE-----

--B4IIlcmfBL/1gGOG--

