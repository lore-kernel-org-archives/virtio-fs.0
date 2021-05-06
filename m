Date: Thu, 6 May 2021 16:12:07 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YJQHRwkUhXT+PLtT@stefanha-x1.localdomain>
References: <20210428110100.27757-1-dgilbert@redhat.com>
	<20210428110100.27757-19-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="zBYl7lu5d6PCY1UM"
Content-Disposition: inline
In-Reply-To: <20210428110100.27757-19-dgilbert@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 18/26] DAX/unmap: virtiofsd: Add
	VHOST_USER_SLAVE_FS_IO
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


--zBYl7lu5d6PCY1UM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 28, 2021 at 12:00:52PM +0100, Dr. David Alan Gilbert (git) wrot=
e:
> @@ -220,6 +222,99 @@ uint64_t vhost_user_fs_slave_unmap(struct vhost_dev =
*dev, int message_size,
>      return (uint64_t)res;
>  }
> =20
> +uint64_t vhost_user_fs_slave_io(struct vhost_dev *dev, int message_size,
> +                                VhostUserFSSlaveMsg *sm, int fd)
> +{
> +    VHostUserFS *fs =3D (VHostUserFS *)object_dynamic_cast(OBJECT(dev->v=
dev),
> +                          TYPE_VHOST_USER_FS);
> +    if (!fs) {
> +        error_report("%s: Bad fs ptr", __func__);
> +        return (uint64_t)-1;
> +    }
> +    if (!check_slave_message_entries(sm, message_size)) {
> +        return (uint64_t)-1;
> +    }

These early error returns don't close(fd).

> +
> +    unsigned int i;
> +    int res =3D 0;
> +    size_t done =3D 0;
> +
> +    if (fd < 0) {
> +        error_report("Bad fd for io");
> +        return (uint64_t)-1;
> +    }
> +
> +    for (i =3D 0; i < sm->count && !res; i++) {
> +        VhostUserFSSlaveMsgEntry *e =3D &sm->entries[i];
> +        if (e->len =3D=3D 0) {
> +            continue;
> +        }
> +
> +        size_t len =3D e->len;
> +        uint64_t fd_offset =3D e->fd_offset;
> +        hwaddr gpa =3D e->c_offset;
> +
> +        while (len && !res) {
> +            hwaddr xlat, xlat_len;
> +            bool is_write =3D e->flags & VHOST_USER_FS_FLAG_MAP_W;
> +            MemoryRegion *mr =3D address_space_translate(dev->vdev->dma_=
as, gpa,
> +                                                       &xlat, &xlat_len,
> +                                                       is_write,
> +                                                       MEMTXATTRS_UNSPEC=
IFIED);
> +            if (!mr || !xlat_len) {
> +                error_report("No guest region found for 0x%" HWADDR_PRIx=
, gpa);
> +                res =3D -EFAULT;
> +                break;
> +            }
> +
> +            trace_vhost_user_fs_slave_io_loop(mr->name,
> +                                          (uint64_t)xlat,
> +                                          memory_region_is_ram(mr),
> +                                          memory_region_is_romd(mr),
> +                                          (size_t)xlat_len);
> +
> +            void *hostptr =3D qemu_map_ram_ptr(mr->ram_block,
> +                                             xlat);
> +            ssize_t transferred;

What happens when the MemoryRegion is not backed by RAM?

> +            if (e->flags & VHOST_USER_FS_FLAG_MAP_R) {
> +                /* Read from file into RAM */
> +                if (mr->readonly) {
> +                    res =3D -EFAULT;
> +                    break;
> +                }
> +                transferred =3D pread(fd, hostptr, xlat_len, fd_offset);
> +            } else if (e->flags & VHOST_USER_FS_FLAG_MAP_W) {
> +                /* Write into file from RAM */
> +                transferred =3D pwrite(fd, hostptr, xlat_len, fd_offset);
> +            } else {
> +                transferred =3D EINVAL;

I don't see how this is handled below by the error checking code. Should
this be:

  errno =3D EINVAL;
  transferred =3D -1;

?

> +            }
> +
> +            trace_vhost_user_fs_slave_io_loop_res(transferred);
> +            if (transferred < 0) {
> +                res =3D -errno;
> +                break;
> +            }
> +            if (!transferred) {
> +                /* EOF */
> +                break;
> +            }
> +
> +            done +=3D transferred;
> +            fd_offset +=3D transferred;
> +            gpa +=3D transferred;
> +            len -=3D transferred;
> +        }
> +    }
> +    close(fd);
> +
> +    trace_vhost_user_fs_slave_io_exit(res, done);
> +    if (res < 0) {
> +        return (uint64_t)res;
> +    }
> +    return (uint64_t)done;
> +}

--zBYl7lu5d6PCY1UM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCUB0cACgkQnKSrs4Gr
c8iZ5wf/ZQOaGftr7HIQpHnZ4wuFclA73AXhUikkrArkY9zDyv6dOTtQp5n2w59y
nKR5UNyhoxfywNAqA6CyxIh1ApG6AwQ2AC7XI0Bcf+snVQyWTtJOPa2LMFcviQr+
VAxvXZFnTHWezqzJCQDJd2MBy5MEgGSseJti+QFC5K4xR/hqB9KptXkFdeGlQZVw
MAy9nDYZRHrIiW2p4b8HGTtHaz31cBtF9SLOBbLsiCoTwuV0rp4FeRKUCaiPjery
Xl2qgpj8mGngRYEtXX00PMK1sV7YpBHf2vKGT1OpLIL4TKxfrHwwZ38kl+fnl6J7
aq1sTkgRD4SHDeVy2KWHsD23phFgkw==
=0c8x
-----END PGP SIGNATURE-----

--zBYl7lu5d6PCY1UM--

