Date: Tue, 5 Oct 2021 09:09:35 +0100
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <YVwIPxELo8PSoE2B@stefanha-x1.localdomain>
References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-7-vgoyal@redhat.com>
	<YVsHifrJdRtVyERb@stefanha-x1.localdomain>
	<YVtc0UMWQtAaCNog@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="+iqnBC8z7q5gu8r7"
Content-Disposition: inline
In-Reply-To: <YVtc0UMWQtAaCNog@redhat.com>
Subject: Re: [Virtio-fs] [PATCH 06/13] vhost-user-fs: Use helpers to
 create/cleanup virtqueue
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


--+iqnBC8z7q5gu8r7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 03:58:09PM -0400, Vivek Goyal wrote:
> On Mon, Oct 04, 2021 at 02:54:17PM +0100, Stefan Hajnoczi wrote:
> > On Thu, Sep 30, 2021 at 11:30:30AM -0400, Vivek Goyal wrote:
> > > Add helpers to create/cleanup virtuqueues and use those helpers. I wi=
ll
> >=20
> > s/virtuqueues/virtqueues/
> >=20
> > > need to reconfigure queues in later patches and using helpers will al=
low
> > > reusing the code.
> > >=20
> > > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > > ---
> > >  hw/virtio/vhost-user-fs.c | 87 +++++++++++++++++++++++--------------=
--
> > >  1 file changed, 52 insertions(+), 35 deletions(-)
> > >=20
> > > diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> > > index c595957983..d1efbc5b18 100644
> > > --- a/hw/virtio/vhost-user-fs.c
> > > +++ b/hw/virtio/vhost-user-fs.c
> > > @@ -139,6 +139,55 @@ static void vuf_set_status(VirtIODevice *vdev, u=
int8_t status)
> > >      }
> > >  }
> > > =20
> > > +static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> > > +{
> > > +    /*
> > > +     * Not normally called; it's the daemon that handles the queue;
> > > +     * however virtio's cleanup path can call this.
> > > +     */
> > > +}
> > > +
> > > +static void vuf_create_vqs(VirtIODevice *vdev)
> > > +{
> > > +    VHostUserFS *fs =3D VHOST_USER_FS(vdev);
> > > +    unsigned int i;
> > > +
> > > +    /* Hiprio queue */
> > > +    fs->hiprio_vq =3D virtio_add_queue(vdev, fs->conf.queue_size,
> > > +                                     vuf_handle_output);
> > > +
> > > +    /* Request queues */
> > > +    fs->req_vqs =3D g_new(VirtQueue *, fs->conf.num_request_queues);
> > > +    for (i =3D 0; i < fs->conf.num_request_queues; i++) {
> > > +        fs->req_vqs[i] =3D virtio_add_queue(vdev, fs->conf.queue_siz=
e,
> > > +                                          vuf_handle_output);
> > > +    }
> > > +
> > > +    /* 1 high prio queue, plus the number configured */
> > > +    fs->vhost_dev.nvqs =3D 1 + fs->conf.num_request_queues;
> > > +    fs->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, fs->vhost_d=
ev.nvqs);
> >=20
> > These two lines prepare for vhost_dev_init(), so moving them here is
> > debatable. If a caller is going to use this function again in the future
> > then they need to be sure to also call vhost_dev_init(). For now it
> > looks safe, so I guess it's okay.
>=20
> Hmm..., I do call this function later from vuf_set_features() and
> reconfigure the queues. I see that I don't call vhost_dev_init()
> in that path. I am not even sure if I should be calling
> vhost_dev_init() from inside vuf_set_features().
>=20
> So core reuirement is that at the time of first creating device
> I have no idea if driver supports notification queue or not. So
> I do create device with notification queue. But later if driver
> (and possibly vhost device) does not support notifiation queue,
> then we need to reconfigure queues. What's the correct way to
> do that?

Ah, I see. The simplest approach is to always allocate the maximum
number of virtqueues. QEMU's vhost-user-fs device shouldn't need to
worry about which virtqueues are actually in use. Let virtiofsd (the
vhost-user backend) worry about that.

I posted ideas about how to do that in a reply to another patch in this
series. I can't guarantee it will work, but I think it's worth
exploring.

Stefan

--+iqnBC8z7q5gu8r7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmFcCD8ACgkQnKSrs4Gr
c8jdjgf/e1SGpQd5MmZoaTevqKLpWjV3OK81VQtwN4FSZSjYCxyj5PVrp7c31bIR
da/751eNaluxZR3EcOH+0J8FmPbkWuLTlNeCvBl+h1jkbg6h6jztDs1tXIIiUTBW
ZApCIgBr4LdfsvBZ/3m2072V9zcUQGnhERVrhvJ7Nx5/TbLwP/LpxLHLYcD0VGfJ
KtvYcTouN9VlTvgeT2zDhcqlsuy74t/4Xpu/0dmIgozNj1RHYRg04ew7tIgFLUOz
kz3RYYxvr0h/A1SxokRP2W565kgU/IYLZ0m+Fgzp2tmeR9+iCk8UJ3rG+h2lqPoK
YWLtzEC4sLDbn48B3nzkzuYo9vpU5w==
=DUE7
-----END PGP SIGNATURE-----

--+iqnBC8z7q5gu8r7--

