Date: Mon, 6 Jan 2020 15:47:10 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20200106154710.GA350142@stefanha-x1.localdomain>
References: <20191220031213.119553-1-eguan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <20191220031213.119553-1-eguan@linux.alibaba.com>
Subject: Re: [Virtio-fs] [PATCH v2] virtiofsd: cancel all queue threads on
 exit in virtio_loop()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eryu Guan <eguan@linux.alibaba.com>
Cc: virtio-fs@redhat.com, qingming.su@linux.alibaba.com


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2019 at 11:12:13AM +0800, Eryu Guan wrote:
> On guest graceful shutdown, virtiofsd receives VHOST_USER_GET_VRING_BASE
> request from VMM and shuts down virtqueues by calling fv_set_started(),
> which joins fv_queue_thread() threads. So when virtio_loop() returns,
> there should be no thread is still accessing data in fuse session and/or
> virtio dev.
>=20
> But on abnormal exit, e.g. guest got killed for whatever reason,
> vhost-user socket is closed and virtio_loop() breaks out the main loop
> and returns to main(). But it's possible fv_queue_worker()s are still
> working and accessing fuse session and virtio dev, which results in
> crash or use-after-free.
>=20
> Fix it by cancelling fv_queue_thread()s before virtio_loop() returns,
> to make sure there's no-one could access fuse session and virtio dev.

Why use pthread_cancel(3) instead of writing 1 to the thread's kill_fd?

I'm concerned about pthread_cancel(3) because the threads access
rwlocks, which may be leaked when pthread_cancel(3) terminates the
thread.

It would be safer to reuse the following code to get full thread
cleanup:

  static void fv_queue_set_started(VuDev *dev, int qidx, bool started)
  {
        ...
        int ret;
        assert(qidx < vud->nqueues);
        ourqi =3D vud->qi[qidx];

        /* Kill the thread */
        if (eventfd_write(ourqi->kill_fd, 1)) {
            fuse_log(FUSE_LOG_ERR, "Eventfd_read for queue: %m\n");
        }
        ret =3D pthread_join(ourqi->thread, NULL);
        if (ret) {
            fuse_log(FUSE_LOG_ERR, "%s: Failed to join thread idx %d err %d=
\n",
                     __func__, qidx, ret);
        }
        pthread_mutex_destroy(&ourqi->vq_lock);
        close(ourqi->kill_fd);
        ourqi->kick_fd =3D -1;
        free(vud->qi[qidx]);
        vud->qi[qidx] =3D NULL;
	...
  }

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl4TVn0ACgkQnKSrs4Gr
c8jYMwgAm+UDb5x9k55jviKvlnUbuVSmek1Q+Vzlr4qUJS5m5TG0LCqJgSPANyIF
ARQV4HX7x6Up6Fb3R4sYyfLt0HZl5KMP7tit4drGmVo1I9O8jFcwazFm00Rq+ZRn
Xa1EtWqS5n4X0RwvzN3Xqn98o+ggg0YsRfbIYCGQom3rIyKB9uzuKEz9mipPeRTX
Y3NqkNGoVskXPT38G/CaoWTfhPEz2QfDmieN2TFEJyNkmuT4r3uPrazJOIB9BZAe
bbNzOUvyum01jYToesZ9p4yFLIB8HFzLVG8YLeOo5WJ+Yu9qStJgFj4udmDMs2ex
pXh9O3t2yGLr6XY8zHD7EIuUF4mn6g==
=l2lY
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

