Date: Thu, 21 Nov 2019 17:00:20 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191121170020.GE445244@stefanha-x1.localdomain>
References: <20191115205705.2046-1-vgoyal@redhat.com>
	<20191115205705.2046-5-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="84ND8YJRMFlzkrP4"
Content-Disposition: inline
In-Reply-To: <20191115205705.2046-5-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 4/4] virtiofs: Support blocking posix locks
 (fcntl(F_SETLKW))
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org


--84ND8YJRMFlzkrP4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 15, 2019 at 03:57:05PM -0500, Vivek Goyal wrote:
> As of now we don't support blocking variant of posix locks and daemon ret=
urns
> -EOPNOTSUPP. Reason being that it can lead to deadlocks. Virtqueue size is
> limited and it is possible we fill virtqueue with all the requests of
> fcntl(F_SETLKW) and wait for reply. And later a subsequent unlock request
> can't make progress because virtqueue is full. And that means F_SETLKW ca=
n't
> make progress and we are deadlocked.
>=20
> Use notification queue to solve this problem. After submitting lock reque=
st
> device will send a reply asking requester to wait. Once lock is available,
> requester will get a notification saying locking is available. That way
> we don't keep the request virtueue busy while we are waiting for lock
> and further unlock requests can make progress.
>=20
> When we get a reply in response to lock request, we need a way to know if
> we need to wait for notification or not. I have overloaded the
> fuse_out_header->error field. If value is ->error is 1, that's a signal
> to caller to wait for lock notification.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/fuse/virtio_fs.c       | 78 ++++++++++++++++++++++++++++++++++++++-
>  include/uapi/linux/fuse.h |  7 ++++
>  2 files changed, 84 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 21d8d9d7d317..8aa9fc996556 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -35,6 +35,7 @@ struct virtio_fs_vq {
>  	struct work_struct done_work;
>  	struct list_head queued_reqs;
>  	struct list_head end_reqs;	/* End these requests */
> +	struct list_head wait_reqs;	/* requests waiting for notification */
>  	struct virtio_fs_notify_node *notify_nodes;
>  	struct list_head notify_reqs;	/* List for queuing notify requests */
>  	struct delayed_work dispatch_work;
> @@ -85,7 +86,6 @@ struct virtio_fs_notify_node {
> =20
>  static int virtio_fs_enqueue_all_notify(struct virtio_fs_vq *fsvq);
> =20
> -
>  static inline struct virtio_fs_vq *vq_to_fsvq(struct virtqueue *vq)
>  {
>  	struct virtio_fs *fs =3D vq->vdev->priv;
> @@ -513,13 +513,75 @@ static int virtio_fs_enqueue_all_notify(struct virt=
io_fs_vq *fsvq)
>  	return 0;
>  }
> =20
> +static int notify_complete_waiting_req(struct virtio_fs *vfs,
> +				       struct fuse_notify_lock_out *out_args)
> +{
> +	struct virtio_fs_vq *fsvq =3D &vfs->vqs[VQ_REQUEST];
> +	struct fuse_req *req, *next;
> +	bool found =3D false;
> +	struct fuse_conn *fc =3D fsvq->fud->fc;
> +
> +	/* Find waiting request with the unique number and end it */
> +	spin_lock(&fsvq->lock);
> +		list_for_each_entry_safe(req, next, &fsvq->wait_reqs, list) {
> +			if (req->in.h.unique =3D=3D out_args->id) {
> +				list_del_init(&req->list);
> +				clear_bit(FR_SENT, &req->flags);
> +				/* Transfer error code from notify */
> +				req->out.h.error =3D out_args->error;
> +				found =3D true;
> +				break;
> +			}
> +		}
> +	spin_unlock(&fsvq->lock);
> +
> +	/*
> +	 * TODO: It is possible that some re-ordering happens in notify
> +	 * comes before request is complete. Deal with it.
> +	 */
> +	if (found) {
> +		fuse_request_end(fc, req);
> +		spin_lock(&fsvq->lock);
> +		dec_in_flight_req(fsvq);
> +		spin_unlock(&fsvq->lock);
> +	} else
> +		pr_debug("virtio-fs: Did not find waiting request with"
> +		       " unique=3D0x%llx\n", out_args->id);
> +
> +	return 0;
> +}
> +
> +static int virtio_fs_handle_notify(struct virtio_fs *vfs,
> +				   struct virtio_fs_notify *notify)
> +{
> +	int ret =3D 0;
> +	struct fuse_out_header *oh =3D &notify->out_hdr;
> +	struct fuse_notify_lock_out *lo;
> +
> +	/*
> +	 * For notifications, oh.unique is 0 and oh->error contains code
> +	 * for which notification as arrived.
> +	 */
> +	switch(oh->error) {
> +	case FUSE_NOTIFY_LOCK:
> +		lo =3D (struct fuse_notify_lock_out *) &notify->outarg;
> +		notify_complete_waiting_req(vfs, lo);
> +		break;
> +	default:
> +		printk("virtio-fs: Unexpected notification %d\n", oh->error);
> +	}
> +	return ret;
> +}

Is this specific to virtio or can be it handled in common code?

> +
>  static void virtio_fs_notify_done_work(struct work_struct *work)
>  {
>  	struct virtio_fs_vq *fsvq =3D container_of(work, struct virtio_fs_vq,
>  						 done_work);
>  	struct virtqueue *vq =3D fsvq->vq;
> +	struct virtio_fs *vfs =3D vq->vdev->priv;
>  	LIST_HEAD(reqs);
>  	struct virtio_fs_notify_node *notify, *next;
> +	struct fuse_out_header *oh;
> =20
>  	spin_lock(&fsvq->lock);
>  	do {
> @@ -535,6 +597,10 @@ static void virtio_fs_notify_done_work(struct work_s=
truct *work)
> =20
>  	/* Process notify */
>  	list_for_each_entry_safe(notify, next, &reqs, list) {
> +		oh =3D &notify->notify.out_hdr;
> +		WARN_ON(oh->unique);
> +		/* Handle notification */
> +		virtio_fs_handle_notify(vfs, &notify->notify);
>  		spin_lock(&fsvq->lock);
>  		dec_in_flight_req(fsvq);
>  		list_del_init(&notify->list);
> @@ -656,6 +722,15 @@ static void virtio_fs_requests_done_work(struct work=
_struct *work)
>  		 * TODO verify that server properly follows FUSE protocol
>  		 * (oh.uniq, oh.len)
>  		 */
> +		if (req->out.h.error =3D=3D 1) {
> +			/* Wait for notification to complete request */
> +			list_del_init(&req->list);
> +			spin_lock(&fsvq->lock);
> +			list_add_tail(&req->list, &fsvq->wait_reqs);
> +			spin_unlock(&fsvq->lock);
> +			continue;
> +		}
> +
>  		args =3D req->args;
>  		copy_args_from_argbuf(args, req);
> =20
> @@ -705,6 +780,7 @@ static int virtio_fs_init_vq(struct virtio_fs *fs, st=
ruct virtio_fs_vq *fsvq,
>  	strncpy(fsvq->name, name, VQ_NAME_LEN);
>  	spin_lock_init(&fsvq->lock);
>  	INIT_LIST_HEAD(&fsvq->queued_reqs);
> +	INIT_LIST_HEAD(&fsvq->wait_reqs);
>  	INIT_LIST_HEAD(&fsvq->end_reqs);
>  	INIT_LIST_HEAD(&fsvq->notify_reqs);
>  	init_completion(&fsvq->in_flight_zero);
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index 373cada89815..45f0c4efec8e 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -481,6 +481,7 @@ enum fuse_notify_code {
>  	FUSE_NOTIFY_STORE =3D 4,
>  	FUSE_NOTIFY_RETRIEVE =3D 5,
>  	FUSE_NOTIFY_DELETE =3D 6,
> +	FUSE_NOTIFY_LOCK =3D 7,
>  	FUSE_NOTIFY_CODE_MAX,
>  };
> =20
> @@ -868,6 +869,12 @@ struct fuse_notify_retrieve_in {
>  	uint64_t	dummy4;
>  };
> =20
> +struct fuse_notify_lock_out {
> +	uint64_t	id;

Please call this field "unique" or "lock_unique" so it's clear this
identifier is the fuse_header_in->unique value of the lock request.

> +	int32_t		error;
> +	int32_t		padding;
> +};
> +
>  /* Device ioctls: */
>  #define FUSE_DEV_IOC_CLONE	_IOR(229, 0, uint32_t)
> =20
> --=20
> 2.20.1
>=20

--84ND8YJRMFlzkrP4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl3WwqQACgkQnKSrs4Gr
c8iDKgf+IaJQsBOeNmRpYFt/cBxDafpZUfqjpUomAe+/hVdOSaKdBNsJBtNNHCAJ
IMiXvZtUYMGZVWBBNbdWrEXsqmEc8suV9E2XZZ/PpDkw1TQjXUnvU6lyG3G14ZZn
Qqh/mo3BXS/sK6ep0pPxy3otbSZ19IWjAqWuA4IjKfPzz0idFYEk6YAGtTT3l4+C
/26hVeQYoj9AfshE1Jcp5XCY3QtDvaP9BbSe0S7rDLxBfaHYwLYetX5RYgSOKdBJ
+RTNgW5EBhAKKAntD6LzxJ6pPHpyiZSomaAj9N05MH4cHkAmIVwtqyq0fNYVQa7c
vdVv9PY8ZR0vqgSUZBWM+ZkXZnzhEQ==
=Ks93
-----END PGP SIGNATURE-----

--84ND8YJRMFlzkrP4--

