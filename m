Date: Tue, 5 Oct 2021 13:22:21 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVxDferEMGA3cE8D@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-13-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="y5SXQIPZT7IR+UMP"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-13-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 12/13] virtiofsd: Implement blocking posix
	locks
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


--y5SXQIPZT7IR+UMP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:36AM -0400, Vivek Goyal wrote:
> As of now we don't support fcntl(F_SETLKW) and if we see one, we return
> -EOPNOTSUPP.
>=20
> Change that by accepting these requests and returning a reply
> immediately asking caller to wait. Once lock is available, send a
> notification to the waiter indicating lock is available.
>=20
> In response to lock request, we are returning error value as "1", which
> signals to client to queue the lock request internally and later client
> will get a notification which will signal lock is taken (or error). And
> then fuse client should wake up the guest process.
>=20
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> ---
>  tools/virtiofsd/fuse_lowlevel.c  | 37 ++++++++++++++++-
>  tools/virtiofsd/fuse_lowlevel.h  | 26 ++++++++++++
>  tools/virtiofsd/fuse_virtio.c    | 50 ++++++++++++++++++++---
>  tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++----
>  4 files changed, 167 insertions(+), 16 deletions(-)
>=20
> diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowle=
vel.c
> index e4679c73ab..2e7f4b786d 100644
> --- a/tools/virtiofsd/fuse_lowlevel.c
> +++ b/tools/virtiofsd/fuse_lowlevel.c
> @@ -179,8 +179,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, int er=
ror, struct iovec *iov,
>          .unique =3D req->unique,
>          .error =3D error,
>      };
> -
> -    if (error <=3D -1000 || error > 0) {
> +    /* error =3D 1 has been used to signal client to wait for notificait=
on */
> +    if (error <=3D -1000 || error > 1) {
>          fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n", error);
>          out.error =3D -ERANGE;
>      }
> @@ -290,6 +290,11 @@ int fuse_reply_err(fuse_req_t req, int err)
>      return send_reply(req, -err, NULL, 0);
>  }
> =20
> +int fuse_reply_wait(fuse_req_t req)
> +{
> +    return send_reply(req, 1, NULL, 0);
> +}
> +
>  void fuse_reply_none(fuse_req_t req)
>  {
>      fuse_free_req(req);
> @@ -2165,6 +2170,34 @@ static void do_destroy(fuse_req_t req, fuse_ino_t =
nodeid,
>      send_reply_ok(req, NULL, 0);
>  }
> =20
> +static int send_notify_iov(struct fuse_session *se, int notify_code,
> +                           struct iovec *iov, int count)
> +{
> +    struct fuse_out_header out;
> +    if (!se->got_init) {
> +        return -ENOTCONN;
> +    }
> +    out.unique =3D 0;
> +    out.error =3D notify_code;
> +    iov[0].iov_base =3D &out;
> +    iov[0].iov_len =3D sizeof(struct fuse_out_header);
> +    return fuse_send_msg(se, NULL, iov, count);
> +}
> +
> +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t unique,
> +                  int32_t error)
> +{
> +    struct fuse_notify_lock_out outarg =3D {0};
> +    struct iovec iov[2];
> +
> +    outarg.unique =3D unique;
> +    outarg.error =3D -error;
> +
> +    iov[1].iov_base =3D &outarg;
> +    iov[1].iov_len =3D sizeof(outarg);
> +    return send_notify_iov(se, FUSE_NOTIFY_LOCK, iov, 2);
> +}
> +
>  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
>                                 off_t offset, struct fuse_bufvec *bufv)
>  {
> diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_lowle=
vel.h
> index c55c0ca2fc..64624b48dc 100644
> --- a/tools/virtiofsd/fuse_lowlevel.h
> +++ b/tools/virtiofsd/fuse_lowlevel.h
> @@ -1251,6 +1251,22 @@ struct fuse_lowlevel_ops {
>   */
>  int fuse_reply_err(fuse_req_t req, int err);
> =20
> +/**
> + * Ask caller to wait for lock.
> + *
> + * Possible requests:
> + *   setlkw
> + *
> + * If caller sends a blocking lock request (setlkw), then reply to caller
> + * that wait for lock to be available. Once lock is available caller will

I can't parse the first sentence.

s/that wait for lock to be available/that waiting for the lock is
necessary/?

> + * receive a notification with request's unique id. Notification will
> + * carry info whether lock was successfully obtained or not.
> + *
> + * @param req request handle
> + * @return zero for success, -errno for failure to send reply
> + */
> +int fuse_reply_wait(fuse_req_t req);
> +
>  /**
>   * Don't send reply
>   *
> @@ -1685,6 +1701,16 @@ int fuse_lowlevel_notify_delete(struct fuse_sessio=
n *se, fuse_ino_t parent,
>  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t ino,
>                                 off_t offset, struct fuse_bufvec *bufv);
> =20
> +/**
> + * Notify event related to previous lock request
> + *
> + * @param se the session object
> + * @param unique the unique id of the request which requested setlkw
> + * @param error zero for success, -errno for the failure
> + */
> +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t unique,
> +                              int32_t error);
> +
>  /*
>   * Utility functions
>   */
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index a87e88e286..bb2d4456fc 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -273,6 +273,23 @@ static void vq_send_element(struct fv_QueueInfo *qi,=
 VuVirtqElement *elem,
>      vu_dispatch_unlock(qi->virtio_dev);
>  }
> =20
> +/* Returns NULL if queue is empty */
> +static FVRequest *vq_pop_notify_elem(struct fv_QueueInfo *qi)
> +{
> +    struct fuse_session *se =3D qi->virtio_dev->se;
> +    VuDev *dev =3D &se->virtio_dev->dev;
> +    VuVirtq *q =3D vu_get_queue(dev, qi->qidx);
> +    FVRequest *req;
> +
> +    vu_dispatch_rdlock(qi->virtio_dev);
> +    pthread_mutex_lock(&qi->vq_lock);
> +    /* Pop an element from queue */
> +    req =3D vu_queue_pop(dev, q, sizeof(FVRequest));
> +    pthread_mutex_unlock(&qi->vq_lock);
> +    vu_dispatch_unlock(qi->virtio_dev);
> +    return req;
> +}
> +
>  /*
>   * Called back by ll whenever it wants to send a reply/message back
>   * The 1st element of the iov starts with the fuse_out_header
> @@ -281,9 +298,9 @@ static void vq_send_element(struct fv_QueueInfo *qi, =
VuVirtqElement *elem,
>  int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
>                      struct iovec *iov, int count)
>  {
> -    FVRequest *req =3D container_of(ch, FVRequest, ch);
> -    struct fv_QueueInfo *qi =3D ch->qi;
> -    VuVirtqElement *elem =3D &req->elem;
> +    FVRequest *req;
> +    struct fv_QueueInfo *qi;
> +    VuVirtqElement *elem;
>      int ret =3D 0;
> =20
>      assert(count >=3D 1);
> @@ -294,8 +311,30 @@ int virtio_send_msg(struct fuse_session *se, struct =
fuse_chan *ch,
> =20
>      size_t tosend_len =3D iov_size(iov, count);
> =20
> -    /* unique =3D=3D 0 is notification, which we don't support */
> -    assert(out->unique);
> +    /* unique =3D=3D 0 is notification */
> +    if (!out->unique) {

Is a check needed in fuse_session_process_buf_int() to reject requests
that the driver submitted to the device with req.unique =3D=3D 0? If we get
confused about the correct virtqueue to use in virtio_send_msg() then
there could be bugs.

> +        if (!se->notify_enabled) {
> +            return -EOPNOTSUPP;
> +        }
> +        /* If notifications are enabled, queue index 1 is notification q=
ueue */
> +        qi =3D se->virtio_dev->qi[1];
> +        req =3D vq_pop_notify_elem(qi);

Where is req freed?

> +        if (!req) {
> +            /*
> +             * TODO: Implement some sort of ring buffer and queue notifi=
cations
> +             * on that and send these later when notification queue has =
space
> +             * available.
> +             */
> +            return -ENOSPC;

This needs to be addressed before this patch series can be merged. The
notification vq is kicked by the guest driver when buffers are
replenished. The vq handler function can wake up waiting threads using a
condvar.

> +        }
> +        req->reply_sent =3D false;
> +    } else {
> +        assert(ch);
> +        req =3D container_of(ch, FVRequest, ch);
> +        qi =3D ch->qi;
> +    }
> +
> +    elem =3D &req->elem;
>      assert(!req->reply_sent);
> =20
>      /* The 'in' part of the elem is to qemu */
> @@ -985,6 +1024,7 @@ static int fv_get_config(VuDev *dev, uint8_t *config=
, uint32_t len)
>          struct fuse_notify_delete_out       delete_out;
>          struct fuse_notify_store_out        store_out;
>          struct fuse_notify_retrieve_out     retrieve_out;
> +        struct fuse_notify_lock_out         lock_out;
>      };
> =20
>      notify_size =3D sizeof(struct fuse_out_header) +
> diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrou=
gh_ll.c
> index 6928662e22..277f74762b 100644
> --- a/tools/virtiofsd/passthrough_ll.c
> +++ b/tools/virtiofsd/passthrough_ll.c
> @@ -2131,13 +2131,35 @@ out:
>      }
>  }
> =20
> +static void setlk_send_notification(struct fuse_session *se, uint64_t un=
ique,
> +                                    int saverr)
> +{
> +    int ret;
> +
> +    do {
> +        ret =3D fuse_lowlevel_notify_lock(se, unique, saverr);
> +        /*
> +         * Retry sending notification if notification queue does not have
> +         * free descriptor yet, otherwise break out of loop. Either we
> +         * successfully sent notifiation or some other error occurred.
> +         */
> +        if (ret !=3D -ENOSPC) {
> +            break;
> +        }
> +        usleep(10000);
> +    } while (1);

Please use the notification vq handler to wake up blocked threads
instead of usleep().

> +}
> +
>  static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_file_in=
fo *fi,
>                       struct flock *lock, int sleep)
>  {
>      struct lo_data *lo =3D lo_data(req);
>      struct lo_inode *inode;
>      struct lo_inode_plock *plock;
> -    int ret, saverr =3D 0;
> +    int ret, saverr =3D 0, ofd;
> +    uint64_t unique;
> +    struct fuse_session *se =3D req->se;
> +    bool blocking_lock =3D false;
> =20
>      fuse_log(FUSE_LOG_DEBUG,
>               "lo_setlk(ino=3D%" PRIu64 ", flags=3D%d)"
> @@ -2151,11 +2173,6 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t in=
o, struct fuse_file_info *fi,
>          return;
>      }
> =20
> -    if (sleep) {
> -        fuse_reply_err(req, EOPNOTSUPP);
> -        return;
> -    }
> -
>      inode =3D lo_inode(req, ino);
>      if (!inode) {
>          fuse_reply_err(req, EBADF);
> @@ -2168,21 +2185,56 @@ static void lo_setlk(fuse_req_t req, fuse_ino_t i=
no, struct fuse_file_info *fi,
> =20
>      if (!plock) {
>          saverr =3D ret;
> +        pthread_mutex_unlock(&inode->plock_mutex);
>          goto out;
>      }
> =20
> +    /*
> +     * plock is now released when inode is going away. We already have
> +     * a reference on inode, so it is guaranteed that plock->fd is
> +     * still around even after dropping inode->plock_mutex lock
> +     */
> +    ofd =3D plock->fd;
> +    pthread_mutex_unlock(&inode->plock_mutex);
> +
> +    /*
> +     * If this lock request can block, request caller to wait for
> +     * notification. Do not access req after this. Once lock is
> +     * available, send a notification instead.
> +     */
> +    if (sleep && lock->l_type !=3D F_UNLCK) {
> +        /*
> +         * If notification queue is not enabled, can't support async
> +         * locks.
> +         */
> +        if (!se->notify_enabled) {
> +            saverr =3D EOPNOTSUPP;
> +            goto out;
> +        }
> +        blocking_lock =3D true;
> +        unique =3D req->unique;
> +        fuse_reply_wait(req);
> +    }
> +
>      /* TODO: Is it alright to modify flock? */
>      lock->l_pid =3D 0;
> -    ret =3D fcntl(plock->fd, F_OFD_SETLK, lock);
> +    if (blocking_lock) {
> +        ret =3D fcntl(ofd, F_OFD_SETLKW, lock);

SETLKW can be interrupted by signals. Should we loop here when errno =3D=3D
EINTR?

> +    } else {
> +        ret =3D fcntl(ofd, F_OFD_SETLK, lock);
> +    }
>      if (ret =3D=3D -1) {
>          saverr =3D errno;
>      }
> =20
>  out:
> -    pthread_mutex_unlock(&inode->plock_mutex);
>      lo_inode_put(lo, &inode);
> =20
> -    fuse_reply_err(req, saverr);
> +    if (!blocking_lock) {
> +        fuse_reply_err(req, saverr);
> +    } else {
> +        setlk_send_notification(se, unique, saverr);
> +    }
>  }
> =20
>  static void lo_fsyncdir(fuse_req_t req, fuse_ino_t ino, int datasync,
> --=20
> 2.31.1
>=20

--y5SXQIPZT7IR+UMP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcQ30ACgkQnKSrs4Gr
c8iF7Qf/fa9P3ZisrNYXJx53zGXXDf5hdVx88MB4FxHjcEC/NPERQoTr8w+NcXPs
/JX6eX962WaEFXYjVCbsp2Sm3Dclt9rtL0nA+GlTX/qGCjGB4hPKW8DF+WQwuXhI
0+V0MwwHJyFyjBN1rPQdnbS8QXMt7nDx5WAnR/x1UOtRTHUx6ASpFau4Es9+RPhu
HU7aJA1zDW5ZagFHLIYAHac7Q85PUNt6l8jue0cYXu1mKNvA5DDPvne+itSShJem
1UcJ9+n6dNDPCTuAs5lr/n559ASK55LB7d3M1dNIVzD4SW0LEgi5qADD22xlxwcW
BGDrGZdvI+2CijUlc1gZR6nwc3P5qQ==
=yk+4
-----END PGP SIGNATURE-----

--y5SXQIPZT7IR+UMP--

