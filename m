Return-Path: <stefanha@redhat.com>
Date: Mon, 17 Apr 2023 11:12:50 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230417151250.GC3852722@fedora>
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <d9d67f07-3d4c-9bdb-052b-28e21fa27dd6@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="ETs0/9kgvfmqN2Oo"
Content-Disposition: inline
In-Reply-To: <d9d67f07-3d4c-9bdb-052b-28e21fa27dd6@redhat.com>
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
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--ETs0/9kgvfmqN2Oo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2023 at 07:31:57PM +0200, Hanna Czenczek wrote:
> On 13.04.23 12:14, Eugenio Perez Martin wrote:
> > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > > So-called "internal" virtio-fs migration refers to transporting the
> > > > back-end's (virtiofsd's) state through qemu's migration stream.  To=
 do
> > > > this, we need to be able to transfer virtiofsd's internal state to =
and
> > > > from virtiofsd.
> > > >=20
> > > > Because virtiofsd's internal state will not be too large, we believ=
e it
> > > > is best to transfer it as a single binary blob after the streaming
> > > > phase.  Because this method should be useful to other vhost-user
> > > > implementations, too, it is introduced as a general-purpose additio=
n to
> > > > the protocol, not limited to vhost-user-fs.
> > > >=20
> > > > These are the additions to the protocol:
> > > > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_S=
TATE:
> > > >    This feature signals support for transferring state, and is adde=
d so
> > > >    that migration can fail early when the back-end has no support.
> > > >=20
> > > > - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a =
pipe
> > > >    over which to transfer the state.  The front-end sends an FD to =
the
> > > >    back-end into/from which it can write/read its state, and the ba=
ck-end
> > > >    can decide to either use it, or reply with a different FD for the
> > > >    front-end to override the front-end's choice.
> > > >    The front-end creates a simple pipe to transfer the state, but m=
aybe
> > > >    the back-end already has an FD into/from which it has to write/r=
ead
> > > >    its state, in which case it will want to override the simple pip=
e.
> > > >    Conversely, maybe in the future we find a way to have the front-=
end
> > > >    get an immediate FD for the migration stream (in some cases), in=
 which
> > > >    case we will want to send this to the back-end instead of creati=
ng a
> > > >    pipe.
> > > >    Hence the negotiation: If one side has a better idea than a plain
> > > >    pipe, we will want to use that.
> > > >=20
> > > > - CHECK_DEVICE_STATE: After the state has been transferred through =
the
> > > >    pipe (the end indicated by EOF), the front-end invokes this func=
tion
> > > >    to verify success.  There is no in-band way (through the pipe) to
> > > >    indicate failure, so we need to check explicitly.
> > > >=20
> > > > Once the transfer pipe has been established via SET_DEVICE_STATE_FD
> > > > (which includes establishing the direction of transfer and migration
> > > > phase), the sending side writes its data into the pipe, and the rea=
ding
> > > > side reads it until it sees an EOF.  Then, the front-end will check=
 for
> > > > success via CHECK_DEVICE_STATE, which on the destination side inclu=
des
> > > > checking for integrity (i.e. errors during deserialization).
> > > >=20
> > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > ---
> > > >   include/hw/virtio/vhost-backend.h |  24 +++++
> > > >   include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > >   hw/virtio/vhost-user.c            | 147 +++++++++++++++++++++++++=
+++++
> > > >   hw/virtio/vhost.c                 |  37 ++++++++
> > > >   4 files changed, 287 insertions(+)
> > > >=20
> > > > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/=
vhost-backend.h
> > > > index ec3fbae58d..5935b32fe3 100644
> > > > --- a/include/hw/virtio/vhost-backend.h
> > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > >       VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > >   } VhostSetConfigType;
> > > >=20
> > > > +typedef enum VhostDeviceStateDirection {
> > > > +    /* Transfer state from back-end (device) to front-end */
> > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > +    /* Transfer state from front-end to back-end (device) */
> > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > +} VhostDeviceStateDirection;
> > > > +
> > > > +typedef enum VhostDeviceStatePhase {
> > > > +    /* The device (and all its vrings) is stopped */
> > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > +} VhostDeviceStatePhase;
> > > vDPA has:
> > >=20
> > >    /* Suspend a device so it does not process virtqueue requests anym=
ore
> > >     *
> > >     * After the return of ioctl the device must preserve all the nece=
ssary state
> > >     * (the virtqueue vring base plus the possible device specific sta=
tes) that is
> > >     * required for restoring in the future. The device must not chang=
e its
> > >     * configuration after that point.
> > >     */
> > >    #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > >=20
> > >    /* Resume a device so it can resume processing virtqueue requests
> > >     *
> > >     * After the return of this ioctl the device will have restored al=
l the
> > >     * necessary states and it is fully operational to continue proces=
sing the
> > >     * virtqueue descriptors.
> > >     */
> > >    #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > >=20
> > > I wonder if it makes sense to import these into vhost-user so that the
> > > difference between kernel vhost and vhost-user is minimized. It's okay
> > > if one of them is ahead of the other, but it would be nice to avoid
> > > overlapping/duplicated functionality.
> > >=20
> > That's what I had in mind in the first versions. I proposed VHOST_STOP
> > instead of VHOST_VDPA_STOP for this very reason. Later it did change
> > to SUSPEND.
> >=20
> > Generally it is better if we make the interface less parametrized and
> > we trust in the messages and its semantics in my opinion. In other
> > words, instead of
> > vhost_set_device_state_fd_op(VHOST_TRANSFER_STATE_PHASE_STOPPED), send
> > individually the equivalent of VHOST_VDPA_SUSPEND vhost-user command.
>=20
> I.e. you mean that this should simply be stateful instead of
> re-affirming the current state with a parameter?
>=20
> The problem I see is that transferring states in different phases of
> migration will require specialized implementations.=C2=A0 So running
> SET_DEVICE_STATE_FD in a different phase will require support from the
> back-end.=C2=A0 Same in the front-end, the exact protocol and thus
> implementation will (probably, difficult to say at this point) depend on
> the migration phase.=C2=A0 I would therefore prefer to have an explicit
> distinction in the command itself that affirms the phase we=E2=80=99re
> targeting.
>=20
> On the other hand, I don=E2=80=99t see the parameter complicating anythin=
g. The
> front-end must supply it, but it will know the phase anyway, so this is
> easy.=C2=A0 The back-end can just choose to ignore it, if it doesn=E2=80=
=99t feel the
> need to verify that the phase is what it thinks it is.
>=20
> > Another way to apply this is with the "direction" parameter. Maybe it
> > is better to split it into "set_state_fd" and "get_state_fd"?
>=20
> Well, it would rather be `set_state_send_fd` and `set_state_receive_fd`.
> We always negotiate a pipe between front-end and back-end, the question
> is just whether the back-end gets the receiving (load) or the sending
> (save) end.
>=20
> Technically, one can make it fully stateful and say that if the device
> hasn=E2=80=99t been started already, it=E2=80=99s always a LOAD, and othe=
rwise always a
> SAVE.=C2=A0 But as above, I=E2=80=99d prefer to keep the parameter becaus=
e the
> implementations are different, so I=E2=80=99d prefer there to be a
> re-affirmation that front-end and back-end are in sync about what should
> be done.
>=20
> Personally, I don=E2=80=99t really see the advantage of having two functi=
ons
> instead of one function with an enum with two values.=C2=A0 The thing abo=
ut
> SET_DEVICE_STATE_FD is that it itself won=E2=80=99t differ much regardles=
s of
> whether we=E2=80=99re loading or saving, it just negotiates the pipe =E2=
=80=93 the
> difference is what happens after the pipe has been negotiated.=C2=A0 So i=
f we
> split the function into two, both implementations will share most of
> their code anyway, which makes me think it should be a single function.

I also don't really see an advantage to defining separate messages as
long as SET_DEVICE_STATE_FD just sets up the pipe. If there are other
arguments that differ depending on the state/direction, then it's nicer
to have separate messages so that argument type remains simple (not a
union).

This brings to mind how iterative migration will work. The interface for
iterative migration is basically the same as non-iterative migration
plus a method to query the number of bytes remaining. When the number of
bytes falls below a threshold, the vCPUs are stopped and the remainder
of the data is read.

Some details from VFIO migration:
- The VMM must explicitly change the state when transitioning from
  iterative and non-iterative migration, but the data transfer fd
  remains the same.
- The state of the device (running, stopped, resuming, etc) doesn't
  change asynchronously, it's always driven by the VMM. However, setting
  the state can fail and then the new state may be an error state.

Mapping this to SET_DEVICE_STATE_FD:
- VhostDeviceStatePhase is extended with
  VHOST_TRANSFER_STATE_PHASE_RUNNING =3D 1 for iterative migration. The
  frontend sends SET_DEVICE_STATE_FD again with
  VHOST_TRANSFER_STATE_PHASE_STOPPED when entering non-iterative
  migration and the frontend sends the iterative fd from the previous
  SET_DEVICE_STATE_FD call to the backend. The backend may reply with
  another fd, if necessary. If the backend changes the fd, then the
  contents of the previous fd must be fully read and transferred before
  the contents of the new fd are migrated. (Maybe this is too complex
  and we should forbid changing the fd when going from RUNNING ->
  STOPPED.)
- CHECK_DEVICE_STATE can be extended to report the number of bytes
  remaining. The semantics change so that CHECK_DEVICE_STATE can be
  called while the VMM is still reading from the fd. It becomes:

    enum CheckDeviceStateResult {
        Saving(bytes_remaining : usize),
	Failed(error_code : u64),
    }

> > In that case, reusing the ioctls as vhost-user messages would be ok.
> > But that puts this proposal further from the VFIO code, which uses
> > "migration_set_state(state)", and maybe it is better when the number
> > of states is high.
>=20
> I=E2=80=99m not sure what you mean (because I don=E2=80=99t know the VFIO=
 code, I
> assume).=C2=A0 Are you saying that using a more finely grained
> migration_set_state() model would conflict with the rather coarse
> suspend/resume?

I think VFIO is already different because vDPA has SUSPEND/RESUME,
whereas VFIO controls the state via VFIO_DEVICE_FEATURE
VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE (which is similar but not identical
to SET_DEVICE_STATE_FD in this patch series).

Stefan

--ETs0/9kgvfmqN2Oo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQ9YfIACgkQnKSrs4Gr
c8jdtAf+KPOxQ9hVsQB6emGsWR5f2ARqgYTdvn3qLaXUqXKHnm75BdPI5qK65VJO
vsZ66Si1wmwZbeX1KgVT5KmwCjGP++ZB7g+xKekuQgRZ8UMOb8Z3UHkK2hAoWJ/4
3DE7xBLlLZMrlKr43HTjxCkwWgrm5DtXBt+Bd9a4fuob/io/p5MsLRbyYMSjwpxf
/QsthWOlK1qwJIbQspRW36/cQ6+OXQLU0V7SSGIIq5yY98njT2230il+GjDyFNCy
+h17RvULL8/LBMUEpmVIYU4Bp0FcUhe/u1Mw6lFQ7KAGdKP3NhdCJwaypHnVopZr
FS0uCIqaw5rRoiOMKCMCQJO3cmaiuA==
=iKYQ
-----END PGP SIGNATURE-----

--ETs0/9kgvfmqN2Oo--
