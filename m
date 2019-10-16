Date: Wed, 16 Oct 2019 15:09:59 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20191016140959.GA5487@stefanha-x1.localdomain>
References: <7331fd60-10c6-6076-4cf5-f5cce7bc6ef1@jp.fujitsu.com>
	<20191007143444.GA174343@work-vm> <20191009165116.GJ2893@work-vm>
	<27035e4a-bd12-e5d8-30d0-0df45e75457c@jp.fujitsu.com>
	<CAJFHJrr5Esq=cjZNW4qZRABtCCh_vpkFJEQO9kYb=Pg62O+weQ@mail.gmail.com>
	<20191011195935.GB13861@redhat.com>
	<CAJFHJrq6bQo=yvO0tAxH7RWg=U=ftpsePs3c7y-AcE90Wh4afg@mail.gmail.com>
	<20191011203647.GC13861@redhat.com>
	<20191014091108.GH22963@stefanha-x1.localdomain>
	<CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <CAJFHJrrqfjQqMu-K99DiBYNmD1=hB710wRZ88w--SQ0GxQv9Tw@mail.gmail.com>
Subject: Re: [Virtio-fs] xfstest results for virtio-fs on aarch64
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Chirantan Ekbote <chirantan@chromium.org>
Cc: "virtio-fs@redhat.com" <virtio-fs@redhat.com>, "misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>, "masayoshi.mizuma@fujitsu.com" <masayoshi.mizuma@fujitsu.com>, Vivek Goyal <vgoyal@redhat.com>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2019 at 11:58:46PM +0900, Chirantan Ekbote wrote:
> On Mon, Oct 14, 2019 at 6:11 PM Stefan Hajnoczi <stefanha@redhat.com> wro=
te:
> >
> > On Fri, Oct 11, 2019 at 04:36:47PM -0400, Vivek Goyal wrote:
> > > On Sat, Oct 12, 2019 at 05:13:51AM +0900, Chirantan Ekbote wrote:
> > > > On Sat, Oct 12, 2019 at 4:59 AM Vivek Goyal <vgoyal@redhat.com> wro=
te:
> > > > @@ -922,7 +990,8 @@ static int virtio_fs_enqueue_req(struct virtque=
ue
> > > > *vq, struct fuse_req *req)
> > > >  static void virtio_fs_wake_pending_and_unlock(struct fuse_iqueue *=
fiq)
> > > >  __releases(fiq->waitq.lock)
> > > >  {
> > > > -       unsigned queue_id =3D VQ_REQUEST; /* TODO multiqueue */
> > > > +       /* unsigned queue_id =3D VQ_REQUEST; /\* TODO multiqueue *\=
/ */
> > > > +       unsigned queue_id;
> > > >         struct virtio_fs *fs;
> > > >         struct fuse_conn *fc;
> > > >         struct fuse_req *req;
> > > > @@ -937,6 +1006,7 @@ __releases(fiq->waitq.lock)
> > > >         spin_unlock(&fiq->waitq.lock);
> > > >
> > > >         fs =3D fiq->priv;
> > > > +       queue_id =3D (req->in.h.unique % (fs->nvqs - 1)) + 1;
> > > >         fc =3D fs->vqs[queue_id].fud->fc;
> > > >
> > > >         dev_dbg(&fs->vqs[queue_id].vq->vdev->dev,
> > > >
> > > >
> > > > This is simply round-robin scheduling but even going from one to two
> > > > queues gives a significant performance improvement (especially beca=
use
> > > > crosvm doesn't support shared memory regions yet).
> > >
> > > Interesting. I thought virtiofsd is hard coded right now to support
> > > only one queue. Did you modify virtiofsd to support more than one
> > > request queue?
> >
> > Right, virtiofsd currently refuses to bring up more than 1 request
> > queue.  The code can actually handle multiqueue now but there is no
> > command-line support for it yet.  The ability to set CPU affinity for
> > virtqueue threads could be introduced at the same time as enabling
> > multiqueue.
> >
>=20
> I'm not using virtiofsd.  We have our own server for crosvm, which
> supports multiple queues.
>=20
> As for the performance numbers, I don't have my test device with me
> but if I remember correctly the blogbench scores almost doubled when
> going from one queue to two queues.

If I understand the code correctly each virtqueue is processed by a
worker and the number of virtqueues is the vcpu count.  This means that
requests are processed in a blocking fashion and the disk is unlikely to
reach its maximum queue depth (e.g. often 64 requests).

Going from 1 virtqueue to 2 virtqueues will improve performance, but
it's still a far cry from the maximum queue depth that the host kernel
and hardware supports.  This is why virtiofsd processes multiple
requests in parallel on a single virtqueue using a thread pool.

Stefan

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl2nJLIACgkQnKSrs4Gr
c8jLtAf/amIuPdbjgRsUhOq9kYmNT3y8z2qd5AAXBIUlu15xBjWZJSA2Gee1wJBo
O89M16+ULYvLT/+aF5stWpNpJesozLgFECcdORhBUP9Ai6T2QVGYoAnqRkOWzw8y
92LWZ4nhA/MPnTMF2M4vfEx/a22DN9cZ6VDj1Te6oy0yR7r6tqK0ticFLOtAn1nG
sDvDDUlNUh2J8nLn24DVeB0GVTKOVl6rxOXDMQD1gX4Eng4qpV1hIx/mMV/MILgN
6wyExP+MdTqGyR6Y4jdmh4IcMeCBR6zPuY41m5dSo4NqxKZ/XF48fqtEckoVniJh
KT7Y7kZR6JITlti4YOwMUjkKaWzKLA==
=RRpT
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--

