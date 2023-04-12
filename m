Return-Path: <stefanha@redhat.com>
Date: Wed, 12 Apr 2023 17:14:47 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230412211447.GD2813183@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-4-hreitz@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="cWkPnFTmNbNsrwz3"
Content-Disposition: inline
In-Reply-To: <20230411150515.14020-4-hreitz@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 3/4] vhost: Add high-level state save/load
 functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--cWkPnFTmNbNsrwz3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 11, 2023 at 05:05:14PM +0200, Hanna Czenczek wrote:
> vhost_save_backend_state() and vhost_load_backend_state() can be used by
> vhost front-ends to easily save and load the back-end's state to/from
> the migration stream.
>=20
> Because we do not know the full state size ahead of time,
> vhost_save_backend_state() simply reads the data in 1 MB chunks, and
> writes each chunk consecutively into the migration stream, prefixed by
> its length.  EOF is indicated by a 0-length chunk.
>=20
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>  include/hw/virtio/vhost.h |  35 +++++++
>  hw/virtio/vhost.c         | 196 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 231 insertions(+)
>=20
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 29449e0fe2..d1f1e9e1f3 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -425,4 +425,39 @@ int vhost_set_device_state_fd(struct vhost_dev *dev,
>   */
>  int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
> =20
> +/**
> + * vhost_save_backend_state(): High-level function to receive a vhost
> + * back-end's state, and save it in `f`.  Uses
> + * `vhost_set_device_state_fd()` to get the data from the back-end, and
> + * stores it in consecutive chunks that are each prefixed by their
> + * respective length (be32).  The end is marked by a 0-length chunk.
> + *
> + * Must only be called while the device and all its vrings are stopped
> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
> + *
> + * @dev: The vhost device from which to save the state
> + * @f: Migration stream in which to save the state
> + * @errp: Potential error message
> + *
> + * Returns 0 on success, and -errno otherwise.
> + */
> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error *=
*errp);
> +
> +/**
> + * vhost_load_backend_state(): High-level function to load a vhost
> + * back-end's state from `f`, and send it over to the back-end.  Reads
> + * the data from `f` in the format used by `vhost_save_state()`, and
> + * uses `vhost_set_device_state_fd()` to transfer it to the back-end.
> + *
> + * Must only be called while the device and all its vrings are stopped
> + * (`VHOST_TRANSFER_STATE_PHASE_STOPPED`).
> + *
> + * @dev: The vhost device to which to send the sate
> + * @f: Migration stream from which to load the state
> + * @errp: Potential error message
> + *
> + * Returns 0 on success, and -errno otherwise.
> + */
> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error *=
*errp);
> +
>  #endif
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 90099d8f6a..d08849c691 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2125,3 +2125,199 @@ int vhost_check_device_state(struct vhost_dev *de=
v, Error **errp)
>                 "vhost transport does not support migration state transfe=
r");
>      return -ENOSYS;
>  }
> +
> +int vhost_save_backend_state(struct vhost_dev *dev, QEMUFile *f, Error *=
*errp)
> +{
> +    /* Maximum chunk size in which to transfer the state */
> +    const size_t chunk_size =3D 1 * 1024 * 1024;
> +    void *transfer_buf =3D NULL;
> +    g_autoptr(GError) g_err =3D NULL;
> +    int pipe_fds[2], read_fd =3D -1, write_fd =3D -1, reply_fd =3D -1;
> +    int ret;
> +
> +    /* [0] for reading (our end), [1] for writing (back-end's end) */
> +    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
> +        error_setg(errp, "Failed to set up state transfer pipe: %s",
> +                   g_err->message);
> +        ret =3D -EINVAL;
> +        goto fail;
> +    }
> +
> +    read_fd =3D pipe_fds[0];
> +    write_fd =3D pipe_fds[1];
> +
> +    /* VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopp=
ed */
> +    assert(!dev->started && !dev->enable_vqs);
> +
> +    /* Transfer ownership of write_fd to the back-end */
> +    ret =3D vhost_set_device_state_fd(dev,
> +                                    VHOST_TRANSFER_STATE_DIRECTION_SAVE,
> +                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
> +                                    write_fd,
> +                                    &reply_fd,
> +                                    errp);
> +    if (ret < 0) {
> +        error_prepend(errp, "Failed to initiate state transfer: ");
> +        goto fail;
> +    }
> +
> +    /* If the back-end wishes to use a different pipe, switch over */
> +    if (reply_fd >=3D 0) {
> +        close(read_fd);
> +        read_fd =3D reply_fd;
> +    }
> +
> +    transfer_buf =3D g_malloc(chunk_size);
> +
> +    while (true) {
> +        ssize_t read_ret;
> +
> +        read_ret =3D read(read_fd, transfer_buf, chunk_size);
> +        if (read_ret < 0) {
> +            ret =3D -errno;
> +            error_setg_errno(errp, -ret, "Failed to receive state");
> +            goto fail;
> +        }
> +
> +        assert(read_ret <=3D chunk_size);
> +        qemu_put_be32(f, read_ret);
> +
> +        if (read_ret =3D=3D 0) {
> +            /* EOF */
> +            break;
> +        }
> +
> +        qemu_put_buffer(f, transfer_buf, read_ret);
> +    }

I think this synchronous approach with a single contiguous stream of
chunks is okay for now.

Does this make the QEMU monitor unresponsive if the backend is slow?

In the future the interface could be extended to allow participating in
the iterative phase of migration. Then chunks from multiple backends
(plus guest RAM) would be interleaved and there would be some
parallelism.

> +
> +    /*
> +     * Back-end will not really care, but be clean and close our end of =
the pipe
> +     * before inquiring the back-end about whether transfer was successf=
ul
> +     */
> +    close(read_fd);
> +    read_fd =3D -1;
> +
> +    /* Also, verify that the device is still stopped */
> +    assert(!dev->started && !dev->enable_vqs);
> +
> +    ret =3D vhost_check_device_state(dev, errp);
> +    if (ret < 0) {
> +        goto fail;
> +    }
> +
> +    ret =3D 0;
> +fail:
> +    g_free(transfer_buf);
> +    if (read_fd >=3D 0) {
> +        close(read_fd);
> +    }
> +
> +    return ret;
> +}
> +
> +int vhost_load_backend_state(struct vhost_dev *dev, QEMUFile *f, Error *=
*errp)
> +{
> +    size_t transfer_buf_size =3D 0;
> +    void *transfer_buf =3D NULL;
> +    g_autoptr(GError) g_err =3D NULL;
> +    int pipe_fds[2], read_fd =3D -1, write_fd =3D -1, reply_fd =3D -1;
> +    int ret;
> +
> +    /* [0] for reading (back-end's end), [1] for writing (our end) */
> +    if (!g_unix_open_pipe(pipe_fds, FD_CLOEXEC, &g_err)) {
> +        error_setg(errp, "Failed to set up state transfer pipe: %s",
> +                   g_err->message);
> +        ret =3D -EINVAL;
> +        goto fail;
> +    }
> +
> +    read_fd =3D pipe_fds[0];
> +    write_fd =3D pipe_fds[1];
> +
> +    /* VHOST_TRANSFER_STATE_PHASE_STOPPED means the device must be stopp=
ed */
> +    assert(!dev->started && !dev->enable_vqs);
> +
> +    /* Transfer ownership of read_fd to the back-end */
> +    ret =3D vhost_set_device_state_fd(dev,
> +                                    VHOST_TRANSFER_STATE_DIRECTION_LOAD,
> +                                    VHOST_TRANSFER_STATE_PHASE_STOPPED,
> +                                    read_fd,
> +                                    &reply_fd,
> +                                    errp);
> +    if (ret < 0) {
> +        error_prepend(errp, "Failed to initiate state transfer: ");
> +        goto fail;
> +    }
> +
> +    /* If the back-end wishes to use a different pipe, switch over */
> +    if (reply_fd >=3D 0) {
> +        close(write_fd);
> +        write_fd =3D reply_fd;
> +    }
> +
> +    while (true) {
> +        size_t this_chunk_size =3D qemu_get_be32(f);
> +        ssize_t write_ret;
> +        const uint8_t *transfer_pointer;
> +
> +        if (this_chunk_size =3D=3D 0) {
> +            /* End of state */
> +            break;
> +        }
> +
> +        if (transfer_buf_size < this_chunk_size) {
> +            transfer_buf =3D g_realloc(transfer_buf, this_chunk_size);
> +            transfer_buf_size =3D this_chunk_size;
> +        }
> +
> +        if (qemu_get_buffer(f, transfer_buf, this_chunk_size) <
> +                this_chunk_size)
> +        {
> +            error_setg(errp, "Failed to read state");
> +            ret =3D -EINVAL;
> +            goto fail;
> +        }
> +
> +        transfer_pointer =3D transfer_buf;
> +        while (this_chunk_size > 0) {
> +            write_ret =3D write(write_fd, transfer_pointer, this_chunk_s=
ize);
> +            if (write_ret < 0) {
> +                ret =3D -errno;
> +                error_setg_errno(errp, -ret, "Failed to send state");
> +                goto fail;
> +            } else if (write_ret =3D=3D 0) {
> +                error_setg(errp, "Failed to send state: Connection is cl=
osed");
> +                ret =3D -ECONNRESET;
> +                goto fail;
> +            }
> +
> +            assert(write_ret <=3D this_chunk_size);
> +            this_chunk_size -=3D write_ret;
> +            transfer_pointer +=3D write_ret;
> +        }
> +    }
> +
> +    /*
> +     * Close our end, thus ending transfer, before inquiring the back-en=
d about
> +     * whether transfer was successful
> +     */
> +    close(write_fd);
> +    write_fd =3D -1;
> +
> +    /* Also, verify that the device is still stopped */
> +    assert(!dev->started && !dev->enable_vqs);
> +
> +    ret =3D vhost_check_device_state(dev, errp);
> +    if (ret < 0) {
> +        goto fail;
> +    }
> +
> +    ret =3D 0;
> +fail:
> +    g_free(transfer_buf);
> +    if (write_fd >=3D 0) {
> +        close(write_fd);
> +    }
> +
> +    return ret;
> +}
> --=20
> 2.39.1
>=20

--cWkPnFTmNbNsrwz3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ3H0cACgkQnKSrs4Gr
c8hLCQf/VwAM+f6t+Fz6g5hH489G1t5vyiYHcNVOd9skShV/2PKQh+7FmBuR2Glb
xo6bfmsR0ZaTrIgLO7MkMklPTJHgjCvi/bw5fAnaDuIIBiRhXCPRZwdnlmGQO12j
oQLmCnDeMYFEe5l6hn4dggMlboKc85dfBsjdqiKvFYm+V1ni+O8n1rx6T7qVAQD6
8W0mSyOKBz2tIuna63sYmYtDBpl3Rr/eibIN9Xz4SeE1YZOiAx8hDR8vU8W4jGkT
v2KlnVYZ4MGPcl5SuUeOA7guVs+EvW/OgAQ+GIME+4q4cMHtn2jaPwrSO60xE2V5
CJ3zS/w0fpp+eRWYo7UB3qofQ3zQ5Q==
=JDE4
-----END PGP SIGNATURE-----

--cWkPnFTmNbNsrwz3--
