Date: Tue, 5 Oct 2021 16:49:49 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVx0HRWg1tjCgjFh@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-13-vgoyal@redhat.com>
	<YVxDferEMGA3cE8D@stefanha-x1.localdomain>
	<YVxry2jXWs2wj/Ur@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dI6jxpEjn0Qx3F/i"
Content-Disposition: inline
In-Reply-To: <YVxry2jXWs2wj/Ur@redhat.com>
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


--dI6jxpEjn0Qx3F/i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 05, 2021 at 11:14:19AM -0400, Vivek Goyal wrote:
> On Tue, Oct 05, 2021 at 01:22:21PM +0100, Stefan Hajnoczi wrote:
> > On Thu, Sep 30, 2021 at 11:30:36AM -0400, Vivek Goyal wrote:
> > > As of now we don't support fcntl(F_SETLKW) and if we see one, we retu=
rn
> > > -EOPNOTSUPP.
> > >=20
> > > Change that by accepting these requests and returning a reply
> > > immediately asking caller to wait. Once lock is available, send a
> > > notification to the waiter indicating lock is available.
> > >=20
> > > In response to lock request, we are returning error value as "1", whi=
ch
> > > signals to client to queue the lock request internally and later clie=
nt
> > > will get a notification which will signal lock is taken (or error). A=
nd
> > > then fuse client should wake up the guest process.
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > Signed-off-by: Ioannis Angelakopoulos <iangelak@redhat.com>
> > > ---
> > >  tools/virtiofsd/fuse_lowlevel.c  | 37 ++++++++++++++++-
> > >  tools/virtiofsd/fuse_lowlevel.h  | 26 ++++++++++++
> > >  tools/virtiofsd/fuse_virtio.c    | 50 ++++++++++++++++++++---
> > >  tools/virtiofsd/passthrough_ll.c | 70 ++++++++++++++++++++++++++++--=
--
> > >  4 files changed, 167 insertions(+), 16 deletions(-)
> > >=20
> > > diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_l=
owlevel.c
> > > index e4679c73ab..2e7f4b786d 100644
> > > --- a/tools/virtiofsd/fuse_lowlevel.c
> > > +++ b/tools/virtiofsd/fuse_lowlevel.c
> > > @@ -179,8 +179,8 @@ int fuse_send_reply_iov_nofree(fuse_req_t req, in=
t error, struct iovec *iov,
> > >          .unique =3D req->unique,
> > >          .error =3D error,
> > >      };
> > > -
> > > -    if (error <=3D -1000 || error > 0) {
> > > +    /* error =3D 1 has been used to signal client to wait for notifi=
caiton */
> > > +    if (error <=3D -1000 || error > 1) {
> > >          fuse_log(FUSE_LOG_ERR, "fuse: bad error value: %i\n", error);
> > >          out.error =3D -ERANGE;
> > >      }
> > > @@ -290,6 +290,11 @@ int fuse_reply_err(fuse_req_t req, int err)
> > >      return send_reply(req, -err, NULL, 0);
> > >  }
> > > =20
> > > +int fuse_reply_wait(fuse_req_t req)
> > > +{
> > > +    return send_reply(req, 1, NULL, 0);
> > > +}
> > > +
> > >  void fuse_reply_none(fuse_req_t req)
> > >  {
> > >      fuse_free_req(req);
> > > @@ -2165,6 +2170,34 @@ static void do_destroy(fuse_req_t req, fuse_in=
o_t nodeid,
> > >      send_reply_ok(req, NULL, 0);
> > >  }
> > > =20
> > > +static int send_notify_iov(struct fuse_session *se, int notify_code,
> > > +                           struct iovec *iov, int count)
> > > +{
> > > +    struct fuse_out_header out;
> > > +    if (!se->got_init) {
> > > +        return -ENOTCONN;
> > > +    }
> > > +    out.unique =3D 0;
> > > +    out.error =3D notify_code;
> > > +    iov[0].iov_base =3D &out;
> > > +    iov[0].iov_len =3D sizeof(struct fuse_out_header);
> > > +    return fuse_send_msg(se, NULL, iov, count);
> > > +}
> > > +
> > > +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t uniq=
ue,
> > > +                  int32_t error)
> > > +{
> > > +    struct fuse_notify_lock_out outarg =3D {0};
> > > +    struct iovec iov[2];
> > > +
> > > +    outarg.unique =3D unique;
> > > +    outarg.error =3D -error;
> > > +
> > > +    iov[1].iov_base =3D &outarg;
> > > +    iov[1].iov_len =3D sizeof(outarg);
> > > +    return send_notify_iov(se, FUSE_NOTIFY_LOCK, iov, 2);
> > > +}
> > > +
> > >  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t i=
no,
> > >                                 off_t offset, struct fuse_bufvec *buf=
v)
> > >  {
> > > diff --git a/tools/virtiofsd/fuse_lowlevel.h b/tools/virtiofsd/fuse_l=
owlevel.h
> > > index c55c0ca2fc..64624b48dc 100644
> > > --- a/tools/virtiofsd/fuse_lowlevel.h
> > > +++ b/tools/virtiofsd/fuse_lowlevel.h
> > > @@ -1251,6 +1251,22 @@ struct fuse_lowlevel_ops {
> > >   */
> > >  int fuse_reply_err(fuse_req_t req, int err);
> > > =20
> > > +/**
> > > + * Ask caller to wait for lock.
> > > + *
> > > + * Possible requests:
> > > + *   setlkw
> > > + *
> > > + * If caller sends a blocking lock request (setlkw), then reply to c=
aller
> > > + * that wait for lock to be available. Once lock is available caller=
 will
> >=20
> > I can't parse the first sentence.
> >=20
> > s/that wait for lock to be available/that waiting for the lock is
> > necessary/?
>=20
> Ok, will change it.
>=20
> >=20
> > > + * receive a notification with request's unique id. Notification will
> > > + * carry info whether lock was successfully obtained or not.
> > > + *
> > > + * @param req request handle
> > > + * @return zero for success, -errno for failure to send reply
> > > + */
> > > +int fuse_reply_wait(fuse_req_t req);
> > > +
> > >  /**
> > >   * Don't send reply
> > >   *
> > > @@ -1685,6 +1701,16 @@ int fuse_lowlevel_notify_delete(struct fuse_se=
ssion *se, fuse_ino_t parent,
> > >  int fuse_lowlevel_notify_store(struct fuse_session *se, fuse_ino_t i=
no,
> > >                                 off_t offset, struct fuse_bufvec *buf=
v);
> > > =20
> > > +/**
> > > + * Notify event related to previous lock request
> > > + *
> > > + * @param se the session object
> > > + * @param unique the unique id of the request which requested setlkw
> > > + * @param error zero for success, -errno for the failure
> > > + */
> > > +int fuse_lowlevel_notify_lock(struct fuse_session *se, uint64_t uniq=
ue,
> > > +                              int32_t error);
> > > +
> > >  /*
> > >   * Utility functions
> > >   */
> > > diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_vir=
tio.c
> > > index a87e88e286..bb2d4456fc 100644
> > > --- a/tools/virtiofsd/fuse_virtio.c
> > > +++ b/tools/virtiofsd/fuse_virtio.c
> > > @@ -273,6 +273,23 @@ static void vq_send_element(struct fv_QueueInfo =
*qi, VuVirtqElement *elem,
> > >      vu_dispatch_unlock(qi->virtio_dev);
> > >  }
> > > =20
> > > +/* Returns NULL if queue is empty */
> > > +static FVRequest *vq_pop_notify_elem(struct fv_QueueInfo *qi)
> > > +{
> > > +    struct fuse_session *se =3D qi->virtio_dev->se;
> > > +    VuDev *dev =3D &se->virtio_dev->dev;
> > > +    VuVirtq *q =3D vu_get_queue(dev, qi->qidx);
> > > +    FVRequest *req;
> > > +
> > > +    vu_dispatch_rdlock(qi->virtio_dev);
> > > +    pthread_mutex_lock(&qi->vq_lock);
> > > +    /* Pop an element from queue */
> > > +    req =3D vu_queue_pop(dev, q, sizeof(FVRequest));
> > > +    pthread_mutex_unlock(&qi->vq_lock);
> > > +    vu_dispatch_unlock(qi->virtio_dev);
> > > +    return req;
> > > +}
> > > +
> > >  /*
> > >   * Called back by ll whenever it wants to send a reply/message back
> > >   * The 1st element of the iov starts with the fuse_out_header
> > > @@ -281,9 +298,9 @@ static void vq_send_element(struct fv_QueueInfo *=
qi, VuVirtqElement *elem,
> > >  int virtio_send_msg(struct fuse_session *se, struct fuse_chan *ch,
> > >                      struct iovec *iov, int count)
> > >  {
> > > -    FVRequest *req =3D container_of(ch, FVRequest, ch);
> > > -    struct fv_QueueInfo *qi =3D ch->qi;
> > > -    VuVirtqElement *elem =3D &req->elem;
> > > +    FVRequest *req;
> > > +    struct fv_QueueInfo *qi;
> > > +    VuVirtqElement *elem;
> > >      int ret =3D 0;
> > > =20
> > >      assert(count >=3D 1);
> > > @@ -294,8 +311,30 @@ int virtio_send_msg(struct fuse_session *se, str=
uct fuse_chan *ch,
> > > =20
> > >      size_t tosend_len =3D iov_size(iov, count);
> > > =20
> > > -    /* unique =3D=3D 0 is notification, which we don't support */
> > > -    assert(out->unique);
> > > +    /* unique =3D=3D 0 is notification */
> > > +    if (!out->unique) {
> >=20
> > Is a check needed in fuse_session_process_buf_int() to reject requests
> > that the driver submitted to the device with req.unique =3D=3D 0? If we=
 get
> > confused about the correct virtqueue to use in virtio_send_msg() then
> > there could be bugs.
>=20
> Ok. Should we abort/exit virtiofsd if fuse_session_process_buf_int()
> gets a request with unique=3D0. If we try to reply to it instead, then
> I will have to carve out a separate path which does not interpret
> unique=3D0 as notification request instead.
>=20
> >=20
> > > +        if (!se->notify_enabled) {
> > > +            return -EOPNOTSUPP;
> > > +        }
> > > +        /* If notifications are enabled, queue index 1 is notificati=
on queue */
> > > +        qi =3D se->virtio_dev->qi[1];
> > > +        req =3D vq_pop_notify_elem(qi);
> >=20
> > Where is req freed?
>=20
> I think we are not freeing req in case of notification. Good catch.
> Will fix it.
>=20
> >=20
> > > +        if (!req) {
> > > +            /*
> > > +             * TODO: Implement some sort of ring buffer and queue no=
tifications
> > > +             * on that and send these later when notification queue =
has space
> > > +             * available.
> > > +             */
> > > +            return -ENOSPC;
> >=20
> > This needs to be addressed before this patch series can be merged. The
> > notification vq is kicked by the guest driver when buffers are
> > replenished. The vq handler function can wake up waiting threads using a
> > condvar.
>=20
> I have taken care of this using by polling in a loop (with sleep
> in between). Just that sleeping on a variable and subsequent wake
> up will be more efficient.
>=20
> >=20
> > > +        }
> > > +        req->reply_sent =3D false;
> > > +    } else {
> > > +        assert(ch);
> > > +        req =3D container_of(ch, FVRequest, ch);
> > > +        qi =3D ch->qi;
> > > +    }
> > > +
> > > +    elem =3D &req->elem;
> > >      assert(!req->reply_sent);
> > > =20
> > >      /* The 'in' part of the elem is to qemu */
> > > @@ -985,6 +1024,7 @@ static int fv_get_config(VuDev *dev, uint8_t *co=
nfig, uint32_t len)
> > >          struct fuse_notify_delete_out       delete_out;
> > >          struct fuse_notify_store_out        store_out;
> > >          struct fuse_notify_retrieve_out     retrieve_out;
> > > +        struct fuse_notify_lock_out         lock_out;
> > >      };
> > > =20
> > >      notify_size =3D sizeof(struct fuse_out_header) +
> > > diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passt=
hrough_ll.c
> > > index 6928662e22..277f74762b 100644
> > > --- a/tools/virtiofsd/passthrough_ll.c
> > > +++ b/tools/virtiofsd/passthrough_ll.c
> > > @@ -2131,13 +2131,35 @@ out:
> > >      }
> > >  }
> > > =20
> > > +static void setlk_send_notification(struct fuse_session *se, uint64_=
t unique,
> > > +                                    int saverr)
> > > +{
> > > +    int ret;
> > > +
> > > +    do {
> > > +        ret =3D fuse_lowlevel_notify_lock(se, unique, saverr);
> > > +        /*
> > > +         * Retry sending notification if notification queue does not=
 have
> > > +         * free descriptor yet, otherwise break out of loop. Either =
we
> > > +         * successfully sent notifiation or some other error occurre=
d.
> > > +         */
> > > +        if (ret !=3D -ENOSPC) {
> > > +            break;
> > > +        }
> > > +        usleep(10000);
> > > +    } while (1);
> >=20
> > Please use the notification vq handler to wake up blocked threads
> > instead of usleep().
>=20
> Ok, I will look into it. This will be more code. First thing I can
> see that I have not started a thread for notification queue. Looks
> like I will have to start one so that that thread can see queue
> kicks and if qemu is going away. And wake up waiters.

If you think creating a thread just for the notification virtqueue is
too much, there's an alternative. Call vu_set_queue_handler() to
register a virtqueue handler callback that's invoked from the same event
loop as the vhost-user protocol thread.

> >=20
> > > +}
> > > +
> > >  static void lo_setlk(fuse_req_t req, fuse_ino_t ino, struct fuse_fil=
e_info *fi,
> > >                       struct flock *lock, int sleep)
> > >  {
> > >      struct lo_data *lo =3D lo_data(req);
> > >      struct lo_inode *inode;
> > >      struct lo_inode_plock *plock;
> > > -    int ret, saverr =3D 0;
> > > +    int ret, saverr =3D 0, ofd;
> > > +    uint64_t unique;
> > > +    struct fuse_session *se =3D req->se;
> > > +    bool blocking_lock =3D false;
> > > =20
> > >      fuse_log(FUSE_LOG_DEBUG,
> > >               "lo_setlk(ino=3D%" PRIu64 ", flags=3D%d)"
> > > @@ -2151,11 +2173,6 @@ static void lo_setlk(fuse_req_t req, fuse_ino_=
t ino, struct fuse_file_info *fi,
> > >          return;
> > >      }
> > > =20
> > > -    if (sleep) {
> > > -        fuse_reply_err(req, EOPNOTSUPP);
> > > -        return;
> > > -    }
> > > -
> > >      inode =3D lo_inode(req, ino);
> > >      if (!inode) {
> > >          fuse_reply_err(req, EBADF);
> > > @@ -2168,21 +2185,56 @@ static void lo_setlk(fuse_req_t req, fuse_ino=
_t ino, struct fuse_file_info *fi,
> > > =20
> > >      if (!plock) {
> > >          saverr =3D ret;
> > > +        pthread_mutex_unlock(&inode->plock_mutex);
> > >          goto out;
> > >      }
> > > =20
> > > +    /*
> > > +     * plock is now released when inode is going away. We already ha=
ve
> > > +     * a reference on inode, so it is guaranteed that plock->fd is
> > > +     * still around even after dropping inode->plock_mutex lock
> > > +     */
> > > +    ofd =3D plock->fd;
> > > +    pthread_mutex_unlock(&inode->plock_mutex);
> > > +
> > > +    /*
> > > +     * If this lock request can block, request caller to wait for
> > > +     * notification. Do not access req after this. Once lock is
> > > +     * available, send a notification instead.
> > > +     */
> > > +    if (sleep && lock->l_type !=3D F_UNLCK) {
> > > +        /*
> > > +         * If notification queue is not enabled, can't support async
> > > +         * locks.
> > > +         */
> > > +        if (!se->notify_enabled) {
> > > +            saverr =3D EOPNOTSUPP;
> > > +            goto out;
> > > +        }
> > > +        blocking_lock =3D true;
> > > +        unique =3D req->unique;
> > > +        fuse_reply_wait(req);
> > > +    }
> > > +
> > >      /* TODO: Is it alright to modify flock? */
> > >      lock->l_pid =3D 0;
> > > -    ret =3D fcntl(plock->fd, F_OFD_SETLK, lock);
> > > +    if (blocking_lock) {
> > > +        ret =3D fcntl(ofd, F_OFD_SETLKW, lock);
> >=20
> > SETLKW can be interrupted by signals. Should we loop here when errno =
=3D=3D
> > EINTR?
>=20
> So there are two cases. In some cases we want to bail out because
> qemu has forced reboot kernel, and we have sent signal to this
> thread so that it stops waiting.
>=20
> Other use case is that some other external entity sends signal to
> virtiofsd thread. In that case we are relying sending -EINTR to
> client and let client restart the syscall and send request again.
>=20
> In future probably we can keep track of state whether we want
> to return on -EINTR or should call fcntl() again if that helps.

Returning EINTR to the client if there is a signal on the server is
strange. There is no signal on the client side and the client doesn't
care if virtiofsd was interrupted.

Bailing out to cancel a blocking operation is definitely a valid case
though.

Stefan

--dI6jxpEjn0Qx3F/i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcdB0ACgkQnKSrs4Gr
c8hT1ggAx8cKR4ebsy9JGNvvyA7X5gGbwinkflZzUQ4O4gyCgbJwXcMVmfV48btJ
iaU24VoQw0SD2heJVmgsvYGs8VdZ/aE7MvytE5zJPD1K221tqsH2yppyqtwEycI9
Rhiq4VAokKvEL0PtSh0c3ccv4aKIMMsbJC7xrmGMyiyuveSkBkUCiYTf8yW6UQNS
ElkAdRV0M5/lZJgXwRrufHl9a9vRfwSo5kOCPR6Jg4vZJXXG/A0slVgNoGaBYpvf
F4W6AG7y2UfLwj+n7GlXKeY3+srSbB04eFkYOb15QEoiZYfQkG4ncWLHf8ymkITN
b8uTDv50Ujj/kYnT4Apj3WS6Q7nTEQ==
=/+h1
-----END PGP SIGNATURE-----

--dI6jxpEjn0Qx3F/i--

