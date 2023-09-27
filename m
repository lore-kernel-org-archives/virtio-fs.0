Return-Path: <stefanha@redhat.com>
Date: Wed, 27 Sep 2023 16:19:22 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230927201922.GB529043@fedora>
References: <20230915102531.55894-1-hreitz@redhat.com>
 <20230925204852.GG323580@fedora>
 <fc005d50-03ba-0b8f-d9af-64a5297395a3@redhat.com>
 <CAJSP0QWwo6rqwY7F-OZgXBnRCLbF4C=66zLf35Jy43jKHebjDw@mail.gmail.com>
 <CAJSP0QWC1VsAr6k745cumQ7zehEYWRqY_0+gdj9ZtNuwZDNtAQ@mail.gmail.com>
 <07282c72-7a83-70c5-395d-454281663eb1@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="kjMssMK4IWHFEABh"
Content-Disposition: inline
In-Reply-To: <07282c72-7a83-70c5-395d-454281663eb1@redhat.com>
Subject: Re: [Virtio-fs] [PATCH v3 0/5] vhost-user: Back-end state migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, "open list:virtiofs" <virtio-fs@redhat.com>, Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, qemu-devel <qemu-devel@nongnu.org>, "Michael S . Tsirkin" <mst@redhat.com>


--kjMssMK4IWHFEABh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 27, 2023 at 10:32:14AM +0200, Hanna Czenczek wrote:
> On 26.09.23 22:10, Stefan Hajnoczi wrote:
> > Hi Hanna,
> > I was thinking about how this could work without SUSPEND/RESUME. What
> > do you think of the following?
> >=20
> > 1. The front-end sends VHOST_USER_RESET_DEVICE (or
> > VHOST_USER_RESET_OWNER, when necessary) when the guest driver resets
> > the device but not on vhost_dev_start()/vhost_dev_stop().
>=20
> This is half the work of SUSPEND/RESUME.=C2=A0 It isn=E2=80=99t easy to d=
o.

I sent a patch series to bring VHOST_USER_RESET_DEVICE to all vhost-user
devices:
https://lore.kernel.org/qemu-devel/20230927192737.528280-1-stefanha@redhat.=
com/T/#t

>=20
> > 2. Suspend the device when all virtqueues are stopped via
> > VHOST_USER_GET_VRING_BASE. Resume the device after at least one
> > virtqueue is started and enabled.
> > 3. Ignore VHOST_USER_SET_STATUS.
> >=20
> > Reset would work. The device would suspend and resume without losing
> > state. Existing vhost-user backends already behave like this in
> > practice (they often don't implement RESET_DEVICE).
>=20
> I don=E2=80=99t understand the point, though.=C2=A0 Today, reset in pract=
ice is a no-op
> anyway, precisely because we only send SET_STATUS 0, don=E2=80=99t fall b=
ack to
> RESET_OWNER/RESET_DEVICE, and no back-end implements SET_STATUS 0 as a
> reset.=C2=A0 By sending RESET_* in case of a guest-initiated reset and no=
thing in
> case of stop/cont, we effectively don=E2=80=99t change anything about the=
 latter
> (which is what SUSPEND/RESUME would be for), but only fix the former case=
=2E=C2=A0
> While I agree that it=E2=80=99s wrong that we don=E2=80=99t really reset =
the back-end in
> case of a guest-initiated reset, this is the first time in this whole
> discussion that that part has been presented as a problem that needs fixi=
ng
> now.
>=20
> So the proposal effectively changes nothing for the vhost_dev_stop()/star=
t()
> case where we=E2=80=99d want to make use of SUSPEND/RESUME, but only for =
the case
> where we would not use it.

We discussed this on a call today. 2 & 3 are additions to the spec that
Hanna has agreed to work on.

Stefan

--kjMssMK4IWHFEABh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUUjkoACgkQnKSrs4Gr
c8j1Rwf+P5HoMSLa9EGAF8upIl91VlYs2rf3f1VzRUdwl7cHM4kNim4Xs9uBnwad
DBPJhnzkf6597F91IAaZLPP8JmwKUxt38NtxwSjWM3CCLZd0Ace6NGfTO1qjTU1L
6i5Oib4k1F/4Jjzb868ureKyInfeIFeASRC1gUnlLMT5pKHbDcpO4oVm7HE7x2+i
xROTR/wXZ1pc6GZHUF2WlzdcqJ2HrbtMqpsjvi5JIK09+lwNjzopgscbw2Il4Fia
/W9wMyq8GyPtIf9elWgMzK3HkPyUyrWcSMC8ptnR318pgQnDnYLqSNbiryQplGo6
Gs6XdgB+CM21imIQTtqNJRovF3HeTA==
=VtOc
-----END PGP SIGNATURE-----

--kjMssMK4IWHFEABh--
