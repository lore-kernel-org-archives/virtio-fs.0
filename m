Date: Fri, 6 Sep 2019 13:03:09 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20190906120309.GW5900@stefanha-x1.localdomain>
References: <20190905194859.16219-1-vgoyal@redhat.com>
	<20190905194859.16219-16-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="fCmRXBY78W5odcVA"
Content-Disposition: inline
In-Reply-To: <20190905194859.16219-16-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 15/18] virtiofs: Make virtio_fs object
	refcounted
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: miklos@szeredi.hu, mst@redhat.com, linux-kernel@vger.kernel.org, virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, virtualization@lists.linux-foundation.org


--fCmRXBY78W5odcVA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 05, 2019 at 03:48:56PM -0400, Vivek Goyal wrote:
> This object is used both by fuse_connection as well virt device. So make
> this object reference counted and that makes it easy to define life cycle
> of the object.
>=20
> Now deivce can be removed while filesystem is still mounted. This will
> cleanup all the virtqueues but virtio_fs object will still be around and
> will be cleaned when filesystem is unmounted and sb/fc drops its referenc=
e.
>=20
> Removing a device also stops all virt queues and any new reuqest gets
> error -ENOTCONN. All existing in flight requests are drained before
> ->remove returns.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c | 52 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 43 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 01bbf2c0e144..29ec2f5bbbe2 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -37,6 +37,7 @@ struct virtio_fs_vq {
> =20
>  /* A virtio-fs device instance */
>  struct virtio_fs {
> +	struct kref refcount;
>  	struct list_head list;    /* on virtio_fs_instances */
>  	char *tag;
>  	struct virtio_fs_vq *vqs;
> @@ -63,6 +64,27 @@ static inline struct fuse_pqueue *vq_to_fpq(struct vir=
tqueue *vq)
>  	return &vq_to_fsvq(vq)->fud->pq;
>  }
> =20
> +static void release_virtiofs_obj(struct kref *ref)
> +{
> +	struct virtio_fs *vfs =3D container_of(ref, struct virtio_fs, refcount);
> +
> +	kfree(vfs->vqs);
> +	kfree(vfs);
> +}
> +
> +static void virtiofs_put(struct virtio_fs *fs)

Why do the two function names above contain "virtiofs" instead
of "virtio_fs"?  I'm not sure if this is intentional and is supposed to
mean something, but it's confusing.

> +{
> +	mutex_lock(&virtio_fs_mutex);
> +	kref_put(&fs->refcount, release_virtiofs_obj);
> +	mutex_unlock(&virtio_fs_mutex);
> +}
> +
> +static void virtio_fs_put(struct fuse_iqueue *fiq)

Minor issue: this function name is confusingly similar to
virtiofs_put().  Please rename to virtio_fs_fiq_put().

--fCmRXBY78W5odcVA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl1ySv0ACgkQnKSrs4Gr
c8gi5QgAiBUMFExTxgTgb6RrUfkYvhvR0YjuN8ik/lgPSvOOVMtT6LMM77ysQauR
LdWnlChQQCMbdamE0Z1RjdPlj461cs3RjPH7QHZtimEOeYBUQegMuOx2aPcLj55u
LCaJauSLzpxYlNKcEFKlmrfaVNAoFRFcFMsAUt5qekoK1mhtcFQ1TYwXyJdqObUY
sYK5tPk2nJvMkeRHr84V8fpI0WiyQU+6okJnEfNUYmx+p1qn7VjIPsGq+Yz4MLF8
baWiJFLjWRFvW6STaaams5Yx4VI3jNtUI7qvikpuOkYWzwQfvv6qbH/RDYk5j5d1
/yxvM1H6W/rDyI1qYOi1etkBab+HEg==
=p10d
-----END PGP SIGNATURE-----

--fCmRXBY78W5odcVA--

