Return-Path: <stefanha@redhat.com>
Date: Mon, 8 May 2023 16:10:36 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
Message-ID: <20230508201036.GB926999@fedora>
References: <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417171405.GA3890522@fedora>
 <CAJaqyWePywgd11mA5D=SqSyGOjzdhj1kjNHVkjG1iWv9Ox0ytg@mail.gmail.com>
 <CAJSP0QUriW5D9QNX+=YHYepXVAzOKjL6Dc93zSYihTTZhif0ig@mail.gmail.com>
 <CAJaqyWc_59dhPcXOQDYh3vpMfV_4uZooYpQnRrcCkBBu1QO8tw@mail.gmail.com>
 <5620d5c8-a9fb-a65b-74ab-16a1ae12c8e3@redhat.com>
 <CAJSP0QWbGQ9BaXDGMgasfk=qWt1DKHxcE=rK9BeuotQvQUuomw@mail.gmail.com>
 <eec2061d62958f3e7872d43b9cb802dfaebbdde4.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature"; boundary="2vlrdci32WJakQ94"
Content-Disposition: inline
In-Reply-To: <eec2061d62958f3e7872d43b9cb802dfaebbdde4.camel@redhat.com>
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
To: Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>


--2vlrdci32WJakQ94
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 20, 2023 at 03:29:44PM +0200, Eugenio P=C3=A9rez wrote:
> On Wed, 2023-04-19 at 07:21 -0400, Stefan Hajnoczi wrote:
> > On Wed, 19 Apr 2023 at 07:10, Hanna Czenczek <hreitz@redhat.com> wrote:
> > > On 18.04.23 09:54, Eugenio Perez Martin wrote:
> > > > On Mon, Apr 17, 2023 at 9:21=E2=80=AFPM Stefan Hajnoczi <stefanha@g=
mail.com>
> > > > wrote:
> > > > > On Mon, 17 Apr 2023 at 15:08, Eugenio Perez Martin <eperezma@redh=
at.com>
> > > > > wrote:
> > > > > > On Mon, Apr 17, 2023 at 7:14=E2=80=AFPM Stefan Hajnoczi <stefan=
ha@redhat.com>
> > > > > > wrote:
> > > > > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez Martin
> > > > > > > wrote:
> > > > > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <
> > > > > > > > stefanha@redhat.com> wrote:
> > > > > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek =
wrote:
> > > > > > > > > > So-called "internal" virtio-fs migration refers to
> > > > > > > > > > transporting the
> > > > > > > > > > back-end's (virtiofsd's) state through qemu's migration
> > > > > > > > > > stream.  To do
> > > > > > > > > > this, we need to be able to transfer virtiofsd's intern=
al
> > > > > > > > > > state to and
> > > > > > > > > > from virtiofsd.
> > > > > > > > > >=20
> > > > > > > > > > Because virtiofsd's internal state will not be too larg=
e, we
> > > > > > > > > > believe it
> > > > > > > > > > is best to transfer it as a single binary blob after the
> > > > > > > > > > streaming
> > > > > > > > > > phase.  Because this method should be useful to other v=
host-
> > > > > > > > > > user
> > > > > > > > > > implementations, too, it is introduced as a general-pur=
pose
> > > > > > > > > > addition to
> > > > > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > > > > >=20
> > > > > > > > > > These are the additions to the protocol:
> > > > > > > > > > - New vhost-user protocol feature
> > > > > > > > > > VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
> > > > > > > > > >    This feature signals support for transferring state,=
 and is
> > > > > > > > > > added so
> > > > > > > > > >    that migration can fail early when the back-end has =
no
> > > > > > > > > > support.
> > > > > > > > > >=20
> > > > > > > > > > - SET_DEVICE_STATE_FD function: Front-end and back-end
> > > > > > > > > > negotiate a pipe
> > > > > > > > > >    over which to transfer the state.  The front-end sen=
ds an
> > > > > > > > > > FD to the
> > > > > > > > > >    back-end into/from which it can write/read its state=
, and
> > > > > > > > > > the back-end
> > > > > > > > > >    can decide to either use it, or reply with a differe=
nt FD
> > > > > > > > > > for the
> > > > > > > > > >    front-end to override the front-end's choice.
> > > > > > > > > >    The front-end creates a simple pipe to transfer the =
state,
> > > > > > > > > > but maybe
> > > > > > > > > >    the back-end already has an FD into/from which it ha=
s to
> > > > > > > > > > write/read
> > > > > > > > > >    its state, in which case it will want to override the
> > > > > > > > > > simple pipe.
> > > > > > > > > >    Conversely, maybe in the future we find a way to hav=
e the
> > > > > > > > > > front-end
> > > > > > > > > >    get an immediate FD for the migration stream (in some
> > > > > > > > > > cases), in which
> > > > > > > > > >    case we will want to send this to the back-end inste=
ad of
> > > > > > > > > > creating a
> > > > > > > > > >    pipe.
> > > > > > > > > >    Hence the negotiation: If one side has a better idea=
 than a
> > > > > > > > > > plain
> > > > > > > > > >    pipe, we will want to use that.
> > > > > > > > > >=20
> > > > > > > > > > - CHECK_DEVICE_STATE: After the state has been transfer=
red
> > > > > > > > > > through the
> > > > > > > > > >    pipe (the end indicated by EOF), the front-end invok=
es this
> > > > > > > > > > function
> > > > > > > > > >    to verify success.  There is no in-band way (through=
 the
> > > > > > > > > > pipe) to
> > > > > > > > > >    indicate failure, so we need to check explicitly.
> > > > > > > > > >=20
> > > > > > > > > > Once the transfer pipe has been established via
> > > > > > > > > > SET_DEVICE_STATE_FD
> > > > > > > > > > (which includes establishing the direction of transfer =
and
> > > > > > > > > > migration
> > > > > > > > > > phase), the sending side writes its data into the pipe,=
 and
> > > > > > > > > > the reading
> > > > > > > > > > side reads it until it sees an EOF.  Then, the front-en=
d will
> > > > > > > > > > check for
> > > > > > > > > > success via CHECK_DEVICE_STATE, which on the destinatio=
n side
> > > > > > > > > > includes
> > > > > > > > > > checking for integrity (i.e. errors during deserializat=
ion).
> > > > > > > > > >=20
> > > > > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > > > > ---
> > > > > > > > > >   include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > > > > >   include/hw/virtio/vhost.h         |  79 +++++++++++++=
+++
> > > > > > > > > >   hw/virtio/vhost-user.c            | 147
> > > > > > > > > > ++++++++++++++++++++++++++++++
> > > > > > > > > >   hw/virtio/vhost.c                 |  37 ++++++++
> > > > > > > > > >   4 files changed, 287 insertions(+)
> > > > > > > > > >=20
> > > > > > > > > > diff --git a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > > > > > > > >       VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > > > > >   } VhostSetConfigType;
> > > > > > > > > >=20
> > > > > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > > > > +    /* Transfer state from back-end (device) to front-=
end */
> > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > > > > +    /* Transfer state from front-end to back-end (devi=
ce) */
> > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > > > > +} VhostDeviceStateDirection;
> > > > > > > > > > +
> > > > > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > > > > +    /* The device (and all its vrings) is stopped */
> > > > > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > > > > +} VhostDeviceStatePhase;
> > > > > > > > > vDPA has:
> > > > > > > > >=20
> > > > > > > > >    /* Suspend a device so it does not process virtqueue r=
equests
> > > > > > > > > anymore
> > > > > > > > >     *
> > > > > > > > >     * After the return of ioctl the device must preserve =
all the
> > > > > > > > > necessary state
> > > > > > > > >     * (the virtqueue vring base plus the possible device
> > > > > > > > > specific states) that is
> > > > > > > > >     * required for restoring in the future. The device mu=
st not
> > > > > > > > > change its
> > > > > > > > >     * configuration after that point.
> > > > > > > > >     */
> > > > > > > > >    #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > > > > > > >=20
> > > > > > > > >    /* Resume a device so it can resume processing virtque=
ue
> > > > > > > > > requests
> > > > > > > > >     *
> > > > > > > > >     * After the return of this ioctl the device will have
> > > > > > > > > restored all the
> > > > > > > > >     * necessary states and it is fully operational to con=
tinue
> > > > > > > > > processing the
> > > > > > > > >     * virtqueue descriptors.
> > > > > > > > >     */
> > > > > > > > >    #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > > > > > > >=20
> > > > > > > > > I wonder if it makes sense to import these into vhost-use=
r so
> > > > > > > > > that the
> > > > > > > > > difference between kernel vhost and vhost-user is minimiz=
ed.
> > > > > > > > > It's okay
> > > > > > > > > if one of them is ahead of the other, but it would be nic=
e to
> > > > > > > > > avoid
> > > > > > > > > overlapping/duplicated functionality.
> > > > > > > > >=20
> > > > > > > > That's what I had in mind in the first versions. I proposed
> > > > > > > > VHOST_STOP
> > > > > > > > instead of VHOST_VDPA_STOP for this very reason. Later it d=
id
> > > > > > > > change
> > > > > > > > to SUSPEND.
> > > > > > > >=20
> > > > > > > > Generally it is better if we make the interface less parame=
trized
> > > > > > > > and
> > > > > > > > we trust in the messages and its semantics in my opinion. I=
n other
> > > > > > > > words, instead of
> > > > > > > > vhost_set_device_state_fd_op(VHOST_TRANSFER_STATE_PHASE_STO=
PPED),
> > > > > > > > send
> > > > > > > > individually the equivalent of VHOST_VDPA_SUSPEND vhost-user
> > > > > > > > command.
> > > > > > > >=20
> > > > > > > > Another way to apply this is with the "direction" parameter=
=2E Maybe
> > > > > > > > it
> > > > > > > > is better to split it into "set_state_fd" and "get_state_fd=
"?
> > > > > > > >=20
> > > > > > > > In that case, reusing the ioctls as vhost-user messages wou=
ld be
> > > > > > > > ok.
> > > > > > > > But that puts this proposal further from the VFIO code, whi=
ch uses
> > > > > > > > "migration_set_state(state)", and maybe it is better when t=
he
> > > > > > > > number
> > > > > > > > of states is high.
> > > > > > > Hi Eugenio,
> > > > > > > Another question about vDPA suspend/resume:
> > > > > > >=20
> > > > > > >    /* Host notifiers must be enabled at this point. */
> > > > > > >    void vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *=
vdev,
> > > > > > > bool vrings)
> > > > > > >    {
> > > > > > >        int i;
> > > > > > >=20
> > > > > > >        /* should only be called after backend is connected */
> > > > > > >        assert(hdev->vhost_ops);
> > > > > > >        event_notifier_test_and_clear(
> > > > > > >            &hdev-
> > > > > > > >vqs[VHOST_QUEUE_NUM_CONFIG_INR].masked_config_notifier);
> > > > > > >        event_notifier_test_and_clear(&vdev->config_notifier);
> > > > > > >=20
> > > > > > >        trace_vhost_dev_stop(hdev, vdev->name, vrings);
> > > > > > >=20
> > > > > > >        if (hdev->vhost_ops->vhost_dev_start) {
> > > > > > >            hdev->vhost_ops->vhost_dev_start(hdev, false);
> > > > > > >            ^^^ SUSPEND ^^^
> > > > > > >        }
> > > > > > >        if (vrings) {
> > > > > > >            vhost_dev_set_vring_enable(hdev, false);
> > > > > > >        }
> > > > > > >        for (i =3D 0; i < hdev->nvqs; ++i) {
> > > > > > >            vhost_virtqueue_stop(hdev,
> > > > > > >                                 vdev,
> > > > > > >                                 hdev->vqs + i,
> > > > > > >                                 hdev->vq_index + i);
> > > > > > >          ^^^ fetch virtqueue state from kernel ^^^
> > > > > > >        }
> > > > > > >        if (hdev->vhost_ops->vhost_reset_status) {
> > > > > > >            hdev->vhost_ops->vhost_reset_status(hdev);
> > > > > > >            ^^^ reset device^^^
> > > > > > >=20
> > > > > > > I noticed the QEMU vDPA code resets the device in vhost_dev_s=
top()
> > > > > > > ->
> > > > > > > vhost_reset_status(). The device's migration code runs after
> > > > > > > vhost_dev_stop() and the state will have been lost.
> > > > > > >=20
> > > > > > vhost_virtqueue_stop saves the vq state (indexes, vring base) i=
n the
> > > > > > qemu VirtIONet device model. This is for all vhost backends.
> > > > > >=20
> > > > > > Regarding the state like mac or mq configuration, SVQ runs for =
all the
> > > > > > VM run in the CVQ. So it can track all of that status in the de=
vice
> > > > > > model too.
> > > > > >=20
> > > > > > When a migration effectively occurs, all the frontend state is
> > > > > > migrated as a regular emulated device. To route all of the stat=
e in a
> > > > > > normalized way for qemu is what leaves open the possibility to =
do
> > > > > > cross-backends migrations, etc.
> > > > > >=20
> > > > > > Does that answer your question?
> > > > > I think you're confirming that changes would be necessary in orde=
r for
> > > > > vDPA to support the save/load operation that Hanna is introducing.
> > > > >=20
> > > > Yes, this first iteration was centered on net, with an eye on block,
> > > > where state can be routed through classical emulated devices. This =
is
> > > > how vhost-kernel and vhost-user do classically. And it allows
> > > > cross-backend, to not modify qemu migration state, etc.
> > > >=20
> > > > To introduce this opaque state to qemu, that must be fetched after =
the
> > > > suspend and not before, requires changes in vhost protocol, as
> > > > discussed previously.
> > > >=20
> > > > > > > It looks like vDPA changes are necessary in order to support
> > > > > > > stateful
> > > > > > > devices even though QEMU already uses SUSPEND. Is my understa=
nding
> > > > > > > correct?
> > > > > > >=20
> > > > > > Changes are required elsewhere, as the code to restore the state
> > > > > > properly in the destination has not been merged.
> > > > > I'm not sure what you mean by elsewhere?
> > > > >=20
> > > > I meant for vdpa *net* devices the changes are not required in vdpa
> > > > ioctls, but mostly in qemu.
> > > >=20
> > > > If you meant stateful as "it must have a state blob that it must be
> > > > opaque to qemu", then I think the straightforward action is to fetch
> > > > state blob about the same time as vq indexes. But yes, changes (at
> > > > least a new ioctl) is needed for that.
> > > >=20
> > > > > I'm asking about vDPA ioctls. Right now the sequence is SUSPEND a=
nd
> > > > > then VHOST_VDPA_SET_STATUS 0.
> > > > >=20
> > > > > In order to save device state from the vDPA device in the future,=
 it
> > > > > will be necessary to defer the VHOST_VDPA_SET_STATUS 0 call so th=
at
> > > > > the device state can be saved before the device is reset.
> > > > >=20
> > > > > Does that sound right?
> > > > >=20
> > > > The split between suspend and reset was added recently for that very
> > > > reason. In all the virtio devices, the frontend is initialized befo=
re
> > > > the backend, so I don't think it is a good idea to defer the backend
> > > > cleanup. Especially if we have already set the state is small enough
> > > > to not needing iterative migration from virtiofsd point of view.
> > > >=20
> > > > If fetching that state at the same time as vq indexes is not valid,
> > > > could it follow the same model as the "in-flight descriptors"?
> > > > vhost-user follows them by using a shared memory region where their
> > > > state is tracked [1]. This allows qemu to survive vhost-user SW
> > > > backend crashes, and does not forbid the cross-backends live migrat=
ion
> > > > as all the information is there to recover them.
> > > >=20
> > > > For hw devices this is not convenient as it occupies PCI bandwidth.=
 So
> > > > a possibility is to synchronize this memory region after a
> > > > synchronization point, being the SUSPEND call or GET_VRING_BASE. HW
> > > > devices are not going to crash in the software sense, so all use ca=
ses
> > > > remain the same to qemu. And that shared memory information is
> > > > recoverable after vhost_dev_stop.
> > > >=20
> > > > Does that sound reasonable to virtiofsd? To offer a shared memory
> > > > region where it dumps the state, maybe only after the
> > > > set_state(STATE_PHASE_STOPPED)?
> > >=20
> > > I don=E2=80=99t think we need the set_state() call, necessarily, if S=
USPEND is
> > > mandatory anyway.
> > >=20
> > > As for the shared memory, the RFC before this series used shared memo=
ry,
> > > so it=E2=80=99s possible, yes.  But =E2=80=9Cshared memory region=E2=
=80=9D can mean a lot of
> > > things =E2=80=93 it sounds like you=E2=80=99re saying the back-end (v=
irtiofsd) should
> > > provide it to the front-end, is that right?  That could work like thi=
s:
> > >=20
> > > On the source side:
> > >=20
> > > S1. SUSPEND goes to virtiofsd
> > > S2. virtiofsd maybe double-checks that the device is stopped, then
> > > serializes its state into a newly allocated shared memory area[1]
> > > S3. virtiofsd responds to SUSPEND
> > > S4. front-end requests shared memory, virtiofsd responds with a handl=
e,
> > > maybe already closes its reference
> > > S5. front-end saves state, closes its handle, freeing the SHM
> > >=20
> > > [1] Maybe virtiofsd can correctly size the serialized state=E2=80=99s=
 size, then
> > > it can immediately allocate this area and serialize directly into it;
> > > maybe it can=E2=80=99t, then we=E2=80=99ll need a bounce buffer.  Not=
 really a
> > > fundamental problem, but there are limitations around what you can do
> > > with serde implementations in Rust=E2=80=A6
> > >=20
> > > On the destination side:
> > >=20
> > > D1. Optional SUSPEND goes to virtiofsd that hasn=E2=80=99t yet done m=
uch;
> > > virtiofsd would serialize its empty state into an SHM area, and respo=
nd
> > > to SUSPEND
> > > D2. front-end reads state from migration stream into an SHM it has al=
located
> > > D3. front-end supplies this SHM to virtiofsd, which discards its
> > > previous area, and now uses this one
> > > D4. RESUME goes to virtiofsd, which deserializes the state from the S=
HM
> > >=20
> > > Couple of questions:
> > >=20
> > > A. Stefan suggested D1, but it does seem wasteful now.  But if SUSPEND
> > > would imply to deserialize a state, and the state is to be transferred
> > > through SHM, this is what would need to be done.  So maybe we should
> > > skip SUSPEND on the destination?
> > > B. You described that the back-end should supply the SHM, which works
> > > well on the source.  On the destination, only the front-end knows how
> > > big the state is, so I=E2=80=99ve decided above that it should alloca=
te the SHM
> > > (D2) and provide it to the back-end.  Is that feasible or is it
> > > important (e.g. for real hardware) that the back-end supplies the SHM?
> > > (In which case the front-end would need to tell the back-end how big =
the
> > > state SHM needs to be.)
> >=20
> > How does this work for iterative live migration?
> >=20
>=20
> A pipe will always fit better for iterative from qemu POV, that's for sur=
e.=20
> Especially if we want to keep that opaqueness.
>=20
> But  we will need to communicate with the HW device using shared memory s=
ooner
> or later for big states.  If we don't transform it in qemu, we will need =
to do
> it in the kernel.  Also, the pipe will not support daemon crashes.
>
> Again I'm just putting this on the table, just in case it fits better or =
it is
> convenient.  I missed the previous patch where SHM was proposed too, so m=
aybe I
> missed some feedback useful here.  I think the pipe is a better solution =
in the
> long run because of the iterative part.

Pipes and shared memory are conceptually equivalent for building
streaming interfaces. It's just more complex to design a shared memory
interface and it reinvents what file descriptors already offer.

I have no doubt we could design iterative migration over a shared memory
interface if we needed to, but I'm not sure why? When you mention
hardware, are you suggesting defining a standard memory/register layout
that hardware implements and mapping it to userspace (QEMU)? Is there a
big advantage to exposing memory versus a file descriptor?

Stefan

--2vlrdci32WJakQ94
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmRZVzwACgkQnKSrs4Gr
c8ie9gf+K/fHnq/CWY+8glpO22o2OFV9ItXVPyB7hRbLnzZR05N+RLUX3+VLGGWv
vMpVbb25KDim/xOPXs4TBK6D1yj4reDIS+R6MQIWTRR1G4q93Kz+BmDqP3ckFaVp
LMusb2zZH0tOur5C+asLBnmSKY+DNyZkx0H7OpUPoULERSvTo+4UiU9FVPVoGVP4
kQzqc5SqJlI5nInbkPXn6h5TjjG7iXpjU1N4sajWuIVLGHkK0BjjPS9CjjSRBNkE
dVxJN9R+jwQ7EXClQoSOtX68rd33oserftuHnXEaRsGA4hAXSDF6m9U6QobjaICV
Nk1kYrVNXkz/qD1Ct+0mn136+aHgHg==
=YT3Y
-----END PGP SIGNATURE-----

--2vlrdci32WJakQ94--
