Return-Path: <stefanha@redhat.com>
Date: Tue, 9 May 2023 11:30:16 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230509153016.GF926999@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <e8cc4521-50a1-2e38-1fb3-8cfa7b0c967e@redhat.com>
 <CAJSP0QUFFYWwD5+8+1q41sNErJVNbkfnQ3VtB4z-HZUV8S0=zw@mail.gmail.com>
 <dfec96a1-84c3-3639-6f09-204c2d12244a@redhat.com>
 <71e47e3e-880d-38d8-c1b0-3287c60365e4@redhat.com>
 <CAJaqyWe13QxuC9BNBULJ1xu1saWE9Y3ET8eEef-7qtyL5R73SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="2EkKTlwdzUwJ7VKV"
Content-Disposition: inline
In-Reply-To: <CAJaqyWe13QxuC9BNBULJ1xu1saWE9Y3ET8eEef-7qtyL5R73SQ@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 0/4] vhost-user-fs: Internal migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--2EkKTlwdzUwJ7VKV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 05, 2023 at 04:26:08PM +0200, Eugenio Perez Martin wrote:
> On Fri, May 5, 2023 at 11:51=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com=
> wrote:
> >
> > (By the way, thanks for the explanations :))
> >
> > On 05.05.23 11:03, Hanna Czenczek wrote:
> > > On 04.05.23 23:14, Stefan Hajnoczi wrote:
> >
> > [...]
> >
> > >> I think it's better to change QEMU's vhost code
> > >> to leave stateful devices suspended (but not reset) across
> > >> vhost_dev_stop() -> vhost_dev_start(), maybe by introducing
> > >> vhost_dev_suspend() and vhost_dev_resume(). Have you thought about
> > >> this aspect?
> > >
> > > Yes and no; I mean, I haven=E2=80=99t in detail, but I thought this i=
s what=E2=80=99s
> > > meant by suspending instead of resetting when the VM is stopped.
> >
> > So, now looking at vhost_dev_stop(), one problem I can see is that
> > depending on the back-end, different operations it does will do
> > different things.
> >
> > It tries to stop the whole device via vhost_ops->vhost_dev_start(),
> > which for vDPA will suspend the device, but for vhost-user will reset it
> > (if F_STATUS is there).
> >
> > It disables all vrings, which doesn=E2=80=99t mean stopping, but may be
> > necessary, too.  (I haven=E2=80=99t yet really understood the use of di=
sabled
> > vrings, I heard that virtio-net would have a need for it.)
> >
> > It then also stops all vrings, though, so that=E2=80=99s OK.  And becau=
se this
> > will always do GET_VRING_BASE, this is actually always the same
> > regardless of transport.
> >
> > Finally (for this purpose), it resets the device status via
> > vhost_ops->vhost_reset_status().  This is only implemented on vDPA, and
> > this is what resets the device there.
> >
> >
> > So vhost-user resets the device in .vhost_dev_start, but vDPA only does
> > so in .vhost_reset_status.  It would seem better to me if vhost-user
> > would also reset the device only in .vhost_reset_status, not in
> > .vhost_dev_start.  .vhost_dev_start seems precisely like the place to
> > run SUSPEND/RESUME.
> >
>=20
> I think the same. I just saw It's been proposed at [1].
>=20
> > Another question I have (but this is basically what I wrote in my last
> > email) is why we even call .vhost_reset_status here.  If the device
> > and/or all of the vrings are already stopped, why do we need to reset
> > it?  Na=C3=AFvely, I had assumed we only really need to reset the devic=
e if
> > the guest changes, so that a new guest driver sees a freshly initialized
> > device.
> >
>=20
> I don't know why we didn't need to call it :). I'm assuming the
> previous vhost-user net did fine resetting vq indexes, using
> VHOST_USER_SET_VRING_BASE. But I don't know about more complex
> devices.

It was added so DPDK can batch rx virtqueue RSS updates:

commit 923b8921d210763359e96246a58658ac0db6c645
Author: Yajun Wu <yajunw@nvidia.com>
Date:   Mon Oct 17 14:44:52 2022 +0800

    vhost-user: Support vhost_dev_start
   =20
    The motivation of adding vhost-user vhost_dev_start support is to
    improve backend configuration speed and reduce live migration VM
    downtime.
   =20
    Today VQ configuration is issued one by one. For virtio net with
    multi-queue support, backend needs to update RSS (Receive side
    scaling) on every rx queue enable. Updating RSS is time-consuming
    (typical time like 7ms).
   =20
    Implement already defined vhost status and message in the vhost
    specification [1].
    (a) VHOST_USER_PROTOCOL_F_STATUS
    (b) VHOST_USER_SET_STATUS
    (c) VHOST_USER_GET_STATUS
   =20
    Send message VHOST_USER_SET_STATUS with VIRTIO_CONFIG_S_DRIVER_OK for
    device start and reset(0) for device stop.
   =20
    On reception of the DRIVER_OK message, backend can apply the needed set=
ting
    only once (instead of incremental) and also utilize parallelism on enab=
ling
    queues.
   =20
    This improves QEMU's live migration downtime with vhost user backend
    implementation by great margin, specially for the large number of VQs o=
f 64
    from 800 msec to 250 msec.
   =20
    [1] https://qemu-project.gitlab.io/qemu/interop/vhost-user.html
   =20
    Signed-off-by: Yajun Wu <yajunw@nvidia.com>
    Acked-by: Parav Pandit <parav@nvidia.com>
    Message-Id: <20221017064452.1226514-3-yajunw@nvidia.com>
    Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
    Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

>=20
> Thanks!
>=20
> [1] https://lore.kernel.org/qemu-devel/20230501230409.274178-1-stefanha@r=
edhat.com/
>=20

--2EkKTlwdzUwJ7VKV
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRaZwgACgkQnKSrs4Gr
c8gm+Qf/ecSeC69gNSQL1xhG9u/YOOykC6I4/VD3pBSyU/Nk9Fag4QJ3BE0D8ns1
PUzQE0tGptwjGIc29qAFbrAjz3DNI6RaXEx9MAvs9hI3xrh4lFmYM1+lp6LINGrI
GXEoXbQKoyuywVr62iSRtJYWwzWs6CoNjujdi69rpmADzKdJBK3TpcO7EXZW93kS
L09koT2pW7SWItRPcD7xh2DNN92MR6utwnfL5NDVFdBklKJjlPvkLpzSBPQGIq26
S1PP3mI1yqWeK/3CMdjekZB2e5QqM7cOJwNFOeUykDl6RrnpkfKATvtnySsLLVKx
p73lzMXxwito+FKzvCISfcr7fKe5Pg==
=v7nP
-----END PGP SIGNATURE-----

--2EkKTlwdzUwJ7VKV--
