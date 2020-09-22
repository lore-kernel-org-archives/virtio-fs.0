Date: Tue, 22 Sep 2020 13:42:55 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20200922174255.GC57620@redhat.com>
References: <20200921213216.GE13362@redhat.com>
	<20200922125957.GN1989025@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200922125957.GN1989025@redhat.com>
Subject: Re: [Virtio-fs] [PATCH] virtiofsd: Used glib "shared" thread pool
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>
Cc: virtio-fs-list <virtio-fs@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, qemu-devel@nongnu.org

On Tue, Sep 22, 2020 at 01:59:57PM +0100, Daniel P. Berrang=E9 wrote:
> On Mon, Sep 21, 2020 at 05:32:16PM -0400, Vivek Goyal wrote:
> > glib offers thread pools and it seems to support "exclusive" and "share=
d"
> > thread pools.
> >=20
> > https://developer.gnome.org/glib/stable/glib-Thread-Pools.html#g-thread=
-pool-new
> >=20
> > Currently we use "exlusive" thread pools but its performance seems to be
> > poor. I tried using "shared" thread pools and performance seems much
> > better. I posted performance results here.
> >=20
> > https://www.redhat.com/archives/virtio-fs/2020-September/msg00080.html
> >=20
> > So lets switch to shared thread pools. We can think of making it option=
al
> > once somebody can show in what cases exclusive thread pools offer better
> > results. For now, my simple performance tests across the board see
> > better results with shared thread pools.
>=20
> I'm really curious why  there's any perf difference between shared and
> exclusive thread pools in the GLib impl.
>=20
> Looking at the code the main difference between the two is appears to
> be around the way threads are spawned, specifically around the scheduler
> attributes assigned.
>=20
> In the shared case, the threads in the pool will have their scheduler
> attributes copied from the very first thread that calls g_thread_pool_new.
>=20
> In the exclusive case, the threads in the pool will inherit their
> scheduler attributes from the thread which pushs the job that
> causes the worker thread to be created.
>=20
> By schedular attributes, I mean all the items in the 'struct schedattr'
> filled by sched_getattr()
>=20
> IOW, if threads in virtiofsd have varying schedular attributes this
> could possibly explain the difference in performance you see between
> the two setups.

Hi Daniel,

Few things.

- I think scheduler attributes are same for the thread creating
  pool as well as for thread pushing the job for virtiofsd.

- My glib2 is old (2.58.3) and I think that did not have sched_getattr()
  stuff.

- One difference I noticed is that in case of shared pool, it does not
  create extra threads if client is doing one request at a time. While
  exclusive pool seemed to push every request to a new thread in pool
  in sort of round robin fashion. It feels keeping requests being served
  from same thread helps in this particilar workload case.

Thanks
Vivek

>=20
> >=20
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  tools/virtiofsd/fuse_virtio.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > Index: qemu/tools/virtiofsd/fuse_virtio.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- qemu.orig/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:27.4444380=
15 -0400
> > +++ qemu/tools/virtiofsd/fuse_virtio.c	2020-09-21 17:28:30.584568910 -0=
400
> > @@ -695,7 +695,7 @@ static void *fv_queue_thread(void *opaqu
> >      struct fuse_session *se =3D qi->virtio_dev->se;
> >      GThreadPool *pool;
> > =20
> > -    pool =3D g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_si=
ze, TRUE,
> > +    pool =3D g_thread_pool_new(fv_queue_worker, qi, se->thread_pool_si=
ze, FALSE,
> >                               NULL);
> >      if (!pool) {
> >          fuse_log(FUSE_LOG_ERR, "%s: g_thread_pool_new failed\n", __fun=
c__);
> >=20
> >=20
>=20
> Regards,
> Daniel
> --=20
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberran=
ge :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.c=
om :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberran=
ge :|

