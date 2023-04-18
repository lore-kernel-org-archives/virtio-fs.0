Return-Path: <stefanha@redhat.com>
Date: Tue, 18 Apr 2023 13:59:24 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230418175924.GB4041499@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417153810.GE3852722@fedora>
 <CAJaqyWePM_a7AafP9qS40hmYXKHDyMsvn5g24zk=cH8L6s-kUw@mail.gmail.com>
 <CAJSP0QWUfxzad3EmT3r1hhaWmXDQt9Nj1LRPhPs_w79S9GAb1A@mail.gmail.com>
 <CAJaqyWfaDVZDJtMvPUhdRE283e80rB3WFd3RF9i=buaBYG=PKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="f4K8DwKKP2BtL63k"
Content-Disposition: inline
In-Reply-To: <CAJaqyWfaDVZDJtMvPUhdRE283e80rB3WFd3RF9i=buaBYG=PKA@mail.gmail.com>
Subject: Re: [Virtio-fs] [PATCH 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--f4K8DwKKP2BtL63k
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 10:09:30AM +0200, Eugenio Perez Martin wrote:
> On Mon, Apr 17, 2023 at 9:33=E2=80=AFPM Stefan Hajnoczi <stefanha@gmail.c=
om> wrote:
> >
> > On Mon, 17 Apr 2023 at 15:10, Eugenio Perez Martin <eperezma@redhat.com=
> wrote:
> > >
> > > On Mon, Apr 17, 2023 at 5:38=E2=80=AFPM Stefan Hajnoczi <stefanha@red=
hat.com> wrote:
> > > >
> > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin wrot=
e:
> > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanh=
a@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > > > > So-called "internal" virtio-fs migration refers to transporti=
ng the
> > > > > > > back-end's (virtiofsd's) state through qemu's migration strea=
m.  To do
> > > > > > > this, we need to be able to transfer virtiofsd's internal sta=
te to and
> > > > > > > from virtiofsd.
> > > > > > >
> > > > > > > Because virtiofsd's internal state will not be too large, we =
believe it
> > > > > > > is best to transfer it as a single binary blob after the stre=
aming
> > > > > > > phase.  Because this method should be useful to other vhost-u=
ser
> > > > > > > implementations, too, it is introduced as a general-purpose a=
ddition to
> > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > >
> > > > > > > These are the additions to the protocol:
> > > > > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRA=
TORY_STATE:
> > > > > > >   This feature signals support for transferring state, and is=
 added so
> > > > > > >   that migration can fail early when the back-end has no supp=
ort.
> > > > > > >
> > > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end negoti=
ate a pipe
> > > > > > >   over which to transfer the state.  The front-end sends an F=
D to the
> > > > > > >   back-end into/from which it can write/read its state, and t=
he back-end
> > > > > > >   can decide to either use it, or reply with a different FD f=
or the
> > > > > > >   front-end to override the front-end's choice.
> > > > > > >   The front-end creates a simple pipe to transfer the state, =
but maybe
> > > > > > >   the back-end already has an FD into/from which it has to wr=
ite/read
> > > > > > >   its state, in which case it will want to override the simpl=
e pipe.
> > > > > > >   Conversely, maybe in the future we find a way to have the f=
ront-end
> > > > > > >   get an immediate FD for the migration stream (in some cases=
), in which
> > > > > > >   case we will want to send this to the back-end instead of c=
reating a
> > > > > > >   pipe.
> > > > > > >   Hence the negotiation: If one side has a better idea than a=
 plain
> > > > > > >   pipe, we will want to use that.
> > > > > > >
> > > > > > > - CHECK_DEVICE_STATE: After the state has been transferred th=
rough the
> > > > > > >   pipe (the end indicated by EOF), the front-end invokes this=
 function
> > > > > > >   to verify success.  There is no in-band way (through the pi=
pe) to
> > > > > > >   indicate failure, so we need to check explicitly.
> > > > > > >
> > > > > > > Once the transfer pipe has been established via SET_DEVICE_ST=
ATE_FD
> > > > > > > (which includes establishing the direction of transfer and mi=
gration
> > > > > > > phase), the sending side writes its data into the pipe, and t=
he reading
> > > > > > > side reads it until it sees an EOF.  Then, the front-end will=
 check for
> > > > > > > success via CHECK_DEVICE_STATE, which on the destination side=
 includes
> > > > > > > checking for integrity (i.e. errors during deserialization).
> > > > > > >
> > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > ---
> > > > > > >  include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > > > > >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++=
++++++++++
> > > > > > >  hw/virtio/vhost.c                 |  37 ++++++++
> > > > > > >  4 files changed, 287 insertions(+)
> > > > > > >
> > > > > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/v=
irtio/vhost-backend.h
> > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > > > >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > >  } VhostSetConfigType;
> > > > > > >
> > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > +    /* Transfer state from back-end (device) to front-end */
> > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > +    /* Transfer state from front-end to back-end (device) */
> > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > +} VhostDeviceStateDirection;
> > > > > > > +
> > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > +    /* The device (and all its vrings) is stopped */
> > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > +} VhostDeviceStatePhase;
> > > > > >
> > > > > > vDPA has:
> > > > > >
> > > > > >   /* Suspend a device so it does not process virtqueue requests=
 anymore
> > > > > >    *
> > > > > >    * After the return of ioctl the device must preserve all the=
 necessary state
> > > > > >    * (the virtqueue vring base plus the possible device specifi=
c states) that is
> > > > > >    * required for restoring in the future. The device must not =
change its
> > > > > >    * configuration after that point.
> > > > > >    */
> > > > > >   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > > > >
> > > > > >   /* Resume a device so it can resume processing virtqueue requ=
ests
> > > > > >    *
> > > > > >    * After the return of this ioctl the device will have restor=
ed all the
> > > > > >    * necessary states and it is fully operational to continue p=
rocessing the
> > > > > >    * virtqueue descriptors.
> > > > > >    */
> > > > > >   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > > > >
> > > > > > I wonder if it makes sense to import these into vhost-user so t=
hat the
> > > > > > difference between kernel vhost and vhost-user is minimized. It=
's okay
> > > > > > if one of them is ahead of the other, but it would be nice to a=
void
> > > > > > overlapping/duplicated functionality.
> > > > > >
> > > > >
> > > > > That's what I had in mind in the first versions. I proposed VHOST=
_STOP
> > > > > instead of VHOST_VDPA_STOP for this very reason. Later it did cha=
nge
> > > > > to SUSPEND.
> > > >
> > > > I noticed QEMU only calls ioctl(VHOST_VDPA_SUSPEND) and not
> > > > ioctl(VHOST_VDPA_RESUME).
> > > >
> > > > The doc comments in <linux/vdpa.h> don't explain how the device can
> > > > leave the suspended state. Can you clarify this?
> > > >
> > >
> > > Do you mean in what situations or regarding the semantics of _RESUME?
> > >
> > > To me resume is an operation mainly to resume the device in the event
> > > of a VM suspension, not a migration. It can be used as a fallback code
> > > in some cases of migration failure though, but it is not currently
> > > used in qemu.
> >
> > Is a "VM suspension" the QEMU HMP 'stop' command?
> >
> > I guess the reason why QEMU doesn't call RESUME anywhere is that it
> > resets the device in vhost_dev_stop()?
> >
>=20
> The actual reason for not using RESUME is that the ioctl was added
> after the SUSPEND design in qemu. Same as this proposal, it is was not
> needed at the time.
>=20
> In the case of vhost-vdpa net, the only usage of suspend is to fetch
> the vq indexes, and in case of error vhost already fetches them from
> guest's used ring way before vDPA, so it has little usage.
>=20
> > Does it make sense to combine SUSPEND and RESUME with Hanna's
> > SET_DEVICE_STATE_FD? For example, non-iterative migration works like
> > this:
> > - Saving the device's state is done by SUSPEND followed by
> > SET_DEVICE_STATE_FD. If the guest needs to continue executing (e.g.
> > savevm command or migration failed), then RESUME is called to
> > continue.
>=20
> I think the previous steps make sense at vhost_dev_stop, not virtio
> savevm handlers. To start spreading this logic to more places of qemu
> can bring confusion.

I don't think there is a way around extending the QEMU vhost's code
model. The current model in QEMU's vhost code is that the backend is
reset when the VM stops. This model worked fine for stateless devices
but it doesn't work for stateful devices.

Imagine a vdpa-gpu device: you cannot reset the device in
vhost_dev_stop() and expect the GPU to continue working when
vhost_dev_start() is called again because all its state has been lost.
The guest driver will send requests that references a virtio-gpu
resources that no longer exist.

One solution is to save the device's state in vhost_dev_stop(). I think
this is what you're suggesting. It requires keeping a copy of the state
and then loading the state again in vhost_dev_start(). I don't think
this approach should be used because it requires all stateful devices to
support live migration (otherwise they break across HMP 'stop'/'cont').
Also, the device state for some devices may be large and it would also
become more complicated when iterative migration is added.

Instead, I think the QEMU vhost code needs to be structured so that
struct vhost_dev has a suspended state:

        ,---------.
	v         |
  started ------> stopped
    \   ^
     \  |
      -> suspended

The device doesn't lose state when it enters the suspended state. It can
be resumed again.

This is why I think SUSPEND/RESUME need to be part of the solution.
(It's also an argument for not including the phase argument in
SET_DEVICE_STATE_FD because the SUSPEND message is sent during
vhost_dev_stop() separately from saving the device's state.)

> > - Loading the device's state is done by SUSPEND followed by
> > SET_DEVICE_STATE_FD, followed by RESUME.
> >
>=20
> I think the restore makes more sense after reset and before driver_ok,
> suspend does not seem a right call there. SUSPEND implies there may be
> other operations before, so the device may have processed some
> requests wrong, as it is not in the right state.

I find it more elegant to allow SUSPEND -> load -> RESUME if the device
state is saved using SUSPEND -> save -> RESUME since the operations are
symmetrical, but requiring the device to be reset works too. Here is my
understanding of your idea in more detail:

The VIRTIO Device Status Field value must be ACKNOWLEDGE | DRIVER |
FEATURES_OK, any device initialization configuration space writes must
be done, and virtqueues must be configured (Step 7 of 3.1.1 Driver
Requirements in VIRTIO 1.2).

At that point the device is able to parse the device state and set up
its internal state. Doing it any earlier (before feature negotiation or
virtqueue configuration) places the device in the awkward situation of
having to keep the device state in a buffer and defer loading it until
later, which is complex.

After device state loading is complete, the DRIVER_OK bit is set to
resume device operation.

Saving device state is only allowed when the DRIVER_OK bit has been set.

Does this sound right?

Stefan

--f4K8DwKKP2BtL63k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ+2nwACgkQnKSrs4Gr
c8jdxgf+MJ6sJdN0NcQZDgwlhiXcs96Sl1S/+LC6H89oTwqS/MFT3lldEb1WAPpK
58MWqkwQ+j2ZVhQosZtQz7KLBTwkfHYHcn04jJ101OReKEZ3ou7kkEqCJw/H9Mr0
zxK0cuW6Fi5H+6Ju4bgYcpwkYRtDOZVUv0Nwv9nVEM2bZPAeQwCMp5JEvJilwmmI
V3PR26B2PgnfKcMzqXdCv6etjTy+WuYNqwnKbZPMVF1ar+FPQkwrXO/0tLNgiekC
i2hrvDYz/JrTdTY4vWCFVfWf18lIRyIi8vQj089ZYVIVrvy2Bfm/tG/8507MvNWR
f3tDiBsPIebcMb9S7ChVZbvuKyj5fQ==
=q5r9
-----END PGP SIGNATURE-----

--f4K8DwKKP2BtL63k--
