Date: Mon, 4 Oct 2021 16:01:02 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVsXLhZOUOI0Ubha@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-12-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rAauOsZfXI+2P2RT"
Content-Disposition: inline
In-Reply-To: <20210930153037.1194279-12-vgoyal@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 11/13] virtiofsd: Shutdown notification
	queue in the end
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


--rAauOsZfXI+2P2RT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 30, 2021 at 11:30:35AM -0400, Vivek Goyal wrote:
> So far we did not have the notion of cross queue traffic. That is, we
> get request on a queue and send back response on same queue. So if a
> request be being processed and at the same time a stop queue request
> comes in, we wait for all pending requests to finish and then queue
> is stopped and associated data structure cleaned.
>=20
> But with notification queue, now it is possible that we get a locking
> request on request queue and send the notification back on a different
> queue (notificaiton queue). This means, we need to make sure that

s/notificaiton/notification/

> notifiation queue has not already been shutdown or is not being

s/notifiation/notification/

> shutdown in parallel while we are trying to send a notification back.
> Otherwise bad things are bound to happen.
>=20
> One way to solve this problem is that stop notification queue in the
> end. First stop hiprio and all request queues. That means by the
> time we are trying to stop notification queue, we know no other
> request can be in progress which can try to send something on
> notification queue.
>=20
> But problem is that currently we don't have any control on in what
> order queues should be stopped. If there was a notion of whole device
> being stopped, then we could decide in what order queues should be
> stopped.
>=20
> Stefan mentioned that there is a command to stop whole device
> VHOST_USER_SET_STATUS but it is not implemented in libvhost-user
> yet. Also we probably could not move away from per queue stop
> logic we have as of now.
>=20
> As an alternative, he said if we stop all queue when qidx 0 is
> being stopped, it should be fine and we can solve the issue of
> notification queue shutdown order.
>=20
> So in this patch I am shutting down all queues when queue 0
> is being shutdown. And also changed shutdown order in such a
> way that notification queue is shutdown last.
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  tools/virtiofsd/fuse_virtio.c | 27 ++++++++++++++++++++++++++-
>  1 file changed, 26 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/virtiofsd/fuse_virtio.c b/tools/virtiofsd/fuse_virtio.c
> index c67c2e0e7a..a87e88e286 100644
> --- a/tools/virtiofsd/fuse_virtio.c
> +++ b/tools/virtiofsd/fuse_virtio.c
> @@ -826,6 +826,11 @@ static void fv_queue_cleanup_thread(struct fv_VuDev =
*vud, int qidx)
>      assert(qidx < vud->nqueues);
>      ourqi =3D vud->qi[qidx];
> =20
> +    /* Queue is already stopped */
> +    if (!ourqi) {
> +        return;
> +    }
> +
>      /* qidx =3D=3D 1 is the notification queue if notifications are enab=
led */
>      if (!se->notify_enabled || qidx !=3D 1) {
>          /* Kill the thread */
> @@ -847,14 +852,25 @@ static void fv_queue_cleanup_thread(struct fv_VuDev=
 *vud, int qidx)
> =20
>  static void stop_all_queues(struct fv_VuDev *vud)
>  {
> +    struct fuse_session *se =3D vud->se;
> +
>      for (int i =3D 0; i < vud->nqueues; i++) {
>          if (!vud->qi[i]) {
>              continue;
>          }
> =20
> +        /* Shutdown notification queue in the end */
> +        if (se->notify_enabled && i =3D=3D 1) {
> +            continue;
> +        }
>          fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func=
__, i);
>          fv_queue_cleanup_thread(vud, i);
>      }
> +
> +    if (se->notify_enabled) {
> +        fuse_log(FUSE_LOG_INFO, "%s: Stopping queue %d thread\n", __func=
__, 1);
> +        fv_queue_cleanup_thread(vud, 1);
> +    }
>  }
> =20
>  /* Callback from libvhost-user on start or stop of a queue */
> @@ -934,7 +950,16 @@ static void fv_queue_set_started(VuDev *dev, int qid=
x, bool started)
>           * the queue thread doesn't block in virtio_send_msg().
>           */
>          vu_dispatch_unlock(vud);
> -        fv_queue_cleanup_thread(vud, qidx);
> +
> +        /*
> +         * If queue 0 is being shutdown, treat it as if device is being
> +         * shutdown and stop all queues.
> +         */

Please expand this comment so it's clear why we do this.

--rAauOsZfXI+2P2RT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFbFy4ACgkQnKSrs4Gr
c8h9QAgAo2xf7s3y6KB+tuUW/hFmF5tu1An3P8nwC0b5G4u/PmmuTLDx2DA4981U
0r40ZfA8JJ/6AXTua48TUehuM97qBP1TtNDwdBsJXoobNJaf662n/YWht+snv/2m
ZPecZf+zAI7Jg3qfNBoOGBpFD+I6z1Fx5Vwcz2YLRdIhIu2M3KRUlUtpFLzE5q/j
1K2e0Q1S4tqVzj0hPaDMSiL61ww9vG7F1sngJWU/Ne48AemvBcCOPFqPLrLMJ58B
6H+vRLJCeyDmZ+GnrkfLAul5uIJQiKWPdeUUvRCXA0UPxZovf0aTIVOm0lIBfRuL
aADJzU8FPqjrg/PnG76qgSVY39ypVg==
=PVbP
-----END PGP SIGNATURE-----

--rAauOsZfXI+2P2RT--

