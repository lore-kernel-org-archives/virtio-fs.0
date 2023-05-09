Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <20230417171405.GA3890522@fedora>
 <CAJaqyWePywgd11mA5D=SqSyGOjzdhj1kjNHVkjG1iWv9Ox0ytg@mail.gmail.com>
 <CAJSP0QUriW5D9QNX+=YHYepXVAzOKjL6Dc93zSYihTTZhif0ig@mail.gmail.com>
 <CAJaqyWc_59dhPcXOQDYh3vpMfV_4uZooYpQnRrcCkBBu1QO8tw@mail.gmail.com>
 <5620d5c8-a9fb-a65b-74ab-16a1ae12c8e3@redhat.com>
 <CAJSP0QWbGQ9BaXDGMgasfk=qWt1DKHxcE=rK9BeuotQvQUuomw@mail.gmail.com>
 <eec2061d62958f3e7872d43b9cb802dfaebbdde4.camel@redhat.com>
 <20230508201036.GB926999@fedora>
 <CAJaqyWcQ1kQvkBpUpHMg7BYFxt76W6b4smPAFVbAixj-vBWhYQ@mail.gmail.com>
 <20230509150933.GE926999@fedora>
In-Reply-To: <20230509150933.GE926999@fedora>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Tue, 9 May 2023 17:35:17 +0200
Message-ID: <CAJaqyWcWmyZYVf5bbqhc1U19RfXTTgPQVsP5mvoi_sqrgQ439g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Tue, May 9, 2023 at 5:09=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.com=
> wrote:
>
> On Tue, May 09, 2023 at 08:45:33AM +0200, Eugenio Perez Martin wrote:
> > On Mon, May 8, 2023 at 10:10=E2=80=AFPM Stefan Hajnoczi <stefanha@redha=
t.com> wrote:
> > >
> > > On Thu, Apr 20, 2023 at 03:29:44PM +0200, Eugenio P=C3=A9rez wrote:
> > > > On Wed, 2023-04-19 at 07:21 -0400, Stefan Hajnoczi wrote:
> > > > > On Wed, 19 Apr 2023 at 07:10, Hanna Czenczek <hreitz@redhat.com> =
wrote:
> > > > > > On 18.04.23 09:54, Eugenio Perez Martin wrote:
> > > > > > > On Mon, Apr 17, 2023 at 9:21=E2=80=AFPM Stefan Hajnoczi <stef=
anha@gmail.com>
> > > > > > > wrote:
> > > > > > > > On Mon, 17 Apr 2023 at 15:08, Eugenio Perez Martin <eperezm=
a@redhat.com>
> > > > > > > > wrote:
> > > > > > > > > On Mon, Apr 17, 2023 at 7:14=E2=80=AFPM Stefan Hajnoczi <=
stefanha@redhat.com>
> > > > > > > > > wrote:
> > > > > > > > > > On Thu, Apr 13, 2023 at 12:14:24PM +0200, Eugenio Perez=
 Martin
> > > > > > > > > > wrote:
> > > > > > > > > > > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajno=
czi <
> > > > > > > > > > > stefanha@redhat.com> wrote:
> > > > > > > > > > > > On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Cze=
nczek wrote:
> > > > > > > > > > > > > So-called "internal" virtio-fs migration refers t=
o
> > > > > > > > > > > > > transporting the
> > > > > > > > > > > > > back-end's (virtiofsd's) state through qemu's mig=
ration
> > > > > > > > > > > > > stream.  To do
> > > > > > > > > > > > > this, we need to be able to transfer virtiofsd's =
internal
> > > > > > > > > > > > > state to and
> > > > > > > > > > > > > from virtiofsd.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Because virtiofsd's internal state will not be to=
o large, we
> > > > > > > > > > > > > believe it
> > > > > > > > > > > > > is best to transfer it as a single binary blob af=
ter the
> > > > > > > > > > > > > streaming
> > > > > > > > > > > > > phase.  Because this method should be useful to o=
ther vhost-
> > > > > > > > > > > > > user
> > > > > > > > > > > > > implementations, too, it is introduced as a gener=
al-purpose
> > > > > > > > > > > > > addition to
> > > > > > > > > > > > > the protocol, not limited to vhost-user-fs.
> > > > > > > > > > > > >
> > > > > > > > > > > > > These are the additions to the protocol:
> > > > > > > > > > > > > - New vhost-user protocol feature
> > > > > > > > > > > > > VHOST_USER_PROTOCOL_F_MIGRATORY_STATE:
> > > > > > > > > > > > >    This feature signals support for transferring =
state, and is
> > > > > > > > > > > > > added so
> > > > > > > > > > > > >    that migration can fail early when the back-en=
d has no
> > > > > > > > > > > > > support.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - SET_DEVICE_STATE_FD function: Front-end and bac=
k-end
> > > > > > > > > > > > > negotiate a pipe
> > > > > > > > > > > > >    over which to transfer the state.  The front-e=
nd sends an
> > > > > > > > > > > > > FD to the
> > > > > > > > > > > > >    back-end into/from which it can write/read its=
 state, and
> > > > > > > > > > > > > the back-end
> > > > > > > > > > > > >    can decide to either use it, or reply with a d=
ifferent FD
> > > > > > > > > > > > > for the
> > > > > > > > > > > > >    front-end to override the front-end's choice.
> > > > > > > > > > > > >    The front-end creates a simple pipe to transfe=
r the state,
> > > > > > > > > > > > > but maybe
> > > > > > > > > > > > >    the back-end already has an FD into/from which=
 it has to
> > > > > > > > > > > > > write/read
> > > > > > > > > > > > >    its state, in which case it will want to overr=
ide the
> > > > > > > > > > > > > simple pipe.
> > > > > > > > > > > > >    Conversely, maybe in the future we find a way =
to have the
> > > > > > > > > > > > > front-end
> > > > > > > > > > > > >    get an immediate FD for the migration stream (=
in some
> > > > > > > > > > > > > cases), in which
> > > > > > > > > > > > >    case we will want to send this to the back-end=
 instead of
> > > > > > > > > > > > > creating a
> > > > > > > > > > > > >    pipe.
> > > > > > > > > > > > >    Hence the negotiation: If one side has a bette=
r idea than a
> > > > > > > > > > > > > plain
> > > > > > > > > > > > >    pipe, we will want to use that.
> > > > > > > > > > > > >
> > > > > > > > > > > > > - CHECK_DEVICE_STATE: After the state has been tr=
ansferred
> > > > > > > > > > > > > through the
> > > > > > > > > > > > >    pipe (the end indicated by EOF), the front-end=
 invokes this
> > > > > > > > > > > > > function
> > > > > > > > > > > > >    to verify success.  There is no in-band way (t=
hrough the
> > > > > > > > > > > > > pipe) to
> > > > > > > > > > > > >    indicate failure, so we need to check explicit=
ly.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Once the transfer pipe has been established via
> > > > > > > > > > > > > SET_DEVICE_STATE_FD
> > > > > > > > > > > > > (which includes establishing the direction of tra=
nsfer and
> > > > > > > > > > > > > migration
> > > > > > > > > > > > > phase), the sending side writes its data into the=
 pipe, and
> > > > > > > > > > > > > the reading
> > > > > > > > > > > > > side reads it until it sees an EOF.  Then, the fr=
ont-end will
> > > > > > > > > > > > > check for
> > > > > > > > > > > > > success via CHECK_DEVICE_STATE, which on the dest=
ination side
> > > > > > > > > > > > > includes
> > > > > > > > > > > > > checking for integrity (i.e. errors during deseri=
alization).
> > > > > > > > > > > > >
> > > > > > > > > > > > > Suggested-by: Stefan Hajnoczi <stefanha@redhat.co=
m>
> > > > > > > > > > > > > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > > > > > > > > > > > ---
> > > > > > > > > > > > >   include/hw/virtio/vhost-backend.h |  24 +++++
> > > > > > > > > > > > >   include/hw/virtio/vhost.h         |  79 +++++++=
+++++++++
> > > > > > > > > > > > >   hw/virtio/vhost-user.c            | 147
> > > > > > > > > > > > > ++++++++++++++++++++++++++++++
> > > > > > > > > > > > >   hw/virtio/vhost.c                 |  37 +++++++=
+
> > > > > > > > > > > > >   4 files changed, 287 insertions(+)
> > > > > > > > > > > > >
> > > > > > > > > > > > > diff --git a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > > b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > > index ec3fbae58d..5935b32fe3 100644
> > > > > > > > > > > > > --- a/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > > +++ b/include/hw/virtio/vhost-backend.h
> > > > > > > > > > > > > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigTyp=
e {
> > > > > > > > > > > > >       VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > > > > > > > > > > >   } VhostSetConfigType;
> > > > > > > > > > > > >
> > > > > > > > > > > > > +typedef enum VhostDeviceStateDirection {
> > > > > > > > > > > > > +    /* Transfer state from back-end (device) to =
front-end */
> > > > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > > > > > > > > > > > +    /* Transfer state from front-end to back-end=
 (device) */
> > > > > > > > > > > > > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > > > > > > > > > > > +} VhostDeviceStateDirection;
> > > > > > > > > > > > > +
> > > > > > > > > > > > > +typedef enum VhostDeviceStatePhase {
> > > > > > > > > > > > > +    /* The device (and all its vrings) is stoppe=
d */
> > > > > > > > > > > > > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > > > > > > > > > > > +} VhostDeviceStatePhase;
> > > > > > > > > > > > vDPA has:
> > > > > > > > > > > >
> > > > > > > > > > > >    /* Suspend a device so it does not process virtq=
ueue requests
> > > > > > > > > > > > anymore
> > > > > > > > > > > >     *
> > > > > > > > > > > >     * After the return of ioctl the device must pre=
serve all the
> > > > > > > > > > > > necessary state
> > > > > > > > > > > >     * (the virtqueue vring base plus the possible d=
evice
> > > > > > > > > > > > specific states) that is
> > > > > > > > > > > >     * required for restoring in the future. The dev=
ice must not
> > > > > > > > > > > > change its
> > > > > > > > > > > >     * configuration after that point.
> > > > > > > > > > > >     */
> > > > > > > > > > > >    #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO=
, 0x7D)
> > > > > > > > > > > >
> > > > > > > > > > > >    /* Resume a device so it can resume processing v=
irtqueue
> > > > > > > > > > > > requests
> > > > > > > > > > > >     *
> > > > > > > > > > > >     * After the return of this ioctl the device wil=
l have
> > > > > > > > > > > > restored all the
> > > > > > > > > > > >     * necessary states and it is fully operational =
to continue
> > > > > > > > > > > > processing the
> > > > > > > > > > > >     * virtqueue descriptors.
> > > > > > > > > > > >     */
> > > > > > > > > > > >    #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO=
, 0x7E)
> > > > > > > > > > > >
> > > > > > > > > > > > I wonder if it makes sense to import these into vho=
st-user so
> > > > > > > > > > > > that the
> > > > > > > > > > > > difference between kernel vhost and vhost-user is m=
inimized.
> > > > > > > > > > > > It's okay
> > > > > > > > > > > > if one of them is ahead of the other, but it would =
be nice to
> > > > > > > > > > > > avoid
> > > > > > > > > > > > overlapping/duplicated functionality.
> > > > > > > > > > > >
> > > > > > > > > > > That's what I had in mind in the first versions. I pr=
oposed
> > > > > > > > > > > VHOST_STOP
> > > > > > > > > > > instead of VHOST_VDPA_STOP for this very reason. Late=
r it did
> > > > > > > > > > > change
> > > > > > > > > > > to SUSPEND.
> > > > > > > > > > >
> > > > > > > > > > > Generally it is better if we make the interface less =
parametrized
> > > > > > > > > > > and
> > > > > > > > > > > we trust in the messages and its semantics in my opin=
ion. In other
> > > > > > > > > > > words, instead of
> > > > > > > > > > > vhost_set_device_state_fd_op(VHOST_TRANSFER_STATE_PHA=
SE_STOPPED),
> > > > > > > > > > > send
> > > > > > > > > > > individually the equivalent of VHOST_VDPA_SUSPEND vho=
st-user
> > > > > > > > > > > command.
> > > > > > > > > > >
> > > > > > > > > > > Another way to apply this is with the "direction" par=
ameter. Maybe
> > > > > > > > > > > it
> > > > > > > > > > > is better to split it into "set_state_fd" and "get_st=
ate_fd"?
> > > > > > > > > > >
> > > > > > > > > > > In that case, reusing the ioctls as vhost-user messag=
es would be
> > > > > > > > > > > ok.
> > > > > > > > > > > But that puts this proposal further from the VFIO cod=
e, which uses
> > > > > > > > > > > "migration_set_state(state)", and maybe it is better =
when the
> > > > > > > > > > > number
> > > > > > > > > > > of states is high.
> > > > > > > > > > Hi Eugenio,
> > > > > > > > > > Another question about vDPA suspend/resume:
> > > > > > > > > >
> > > > > > > > > >    /* Host notifiers must be enabled at this point. */
> > > > > > > > > >    void vhost_dev_stop(struct vhost_dev *hdev, VirtIODe=
vice *vdev,
> > > > > > > > > > bool vrings)
> > > > > > > > > >    {
> > > > > > > > > >        int i;
> > > > > > > > > >
> > > > > > > > > >        /* should only be called after backend is connec=
ted */
> > > > > > > > > >        assert(hdev->vhost_ops);
> > > > > > > > > >        event_notifier_test_and_clear(
> > > > > > > > > >            &hdev-
> > > > > > > > > > >vqs[VHOST_QUEUE_NUM_CONFIG_INR].masked_config_notifier=
);
> > > > > > > > > >        event_notifier_test_and_clear(&vdev->config_noti=
fier);
> > > > > > > > > >
> > > > > > > > > >        trace_vhost_dev_stop(hdev, vdev->name, vrings);
> > > > > > > > > >
> > > > > > > > > >        if (hdev->vhost_ops->vhost_dev_start) {
> > > > > > > > > >            hdev->vhost_ops->vhost_dev_start(hdev, false=
);
> > > > > > > > > >            ^^^ SUSPEND ^^^
> > > > > > > > > >        }
> > > > > > > > > >        if (vrings) {
> > > > > > > > > >            vhost_dev_set_vring_enable(hdev, false);
> > > > > > > > > >        }
> > > > > > > > > >        for (i =3D 0; i < hdev->nvqs; ++i) {
> > > > > > > > > >            vhost_virtqueue_stop(hdev,
> > > > > > > > > >                                 vdev,
> > > > > > > > > >                                 hdev->vqs + i,
> > > > > > > > > >                                 hdev->vq_index + i);
> > > > > > > > > >          ^^^ fetch virtqueue state from kernel ^^^
> > > > > > > > > >        }
> > > > > > > > > >        if (hdev->vhost_ops->vhost_reset_status) {
> > > > > > > > > >            hdev->vhost_ops->vhost_reset_status(hdev);
> > > > > > > > > >            ^^^ reset device^^^
> > > > > > > > > >
> > > > > > > > > > I noticed the QEMU vDPA code resets the device in vhost=
_dev_stop()
> > > > > > > > > > ->
> > > > > > > > > > vhost_reset_status(). The device's migration code runs =
after
> > > > > > > > > > vhost_dev_stop() and the state will have been lost.
> > > > > > > > > >
> > > > > > > > > vhost_virtqueue_stop saves the vq state (indexes, vring b=
ase) in the
> > > > > > > > > qemu VirtIONet device model. This is for all vhost backen=
ds.
> > > > > > > > >
> > > > > > > > > Regarding the state like mac or mq configuration, SVQ run=
s for all the
> > > > > > > > > VM run in the CVQ. So it can track all of that status in =
the device
> > > > > > > > > model too.
> > > > > > > > >
> > > > > > > > > When a migration effectively occurs, all the frontend sta=
te is
> > > > > > > > > migrated as a regular emulated device. To route all of th=
e state in a
> > > > > > > > > normalized way for qemu is what leaves open the possibili=
ty to do
> > > > > > > > > cross-backends migrations, etc.
> > > > > > > > >
> > > > > > > > > Does that answer your question?
> > > > > > > > I think you're confirming that changes would be necessary i=
n order for
> > > > > > > > vDPA to support the save/load operation that Hanna is intro=
ducing.
> > > > > > > >
> > > > > > > Yes, this first iteration was centered on net, with an eye on=
 block,
> > > > > > > where state can be routed through classical emulated devices.=
 This is
> > > > > > > how vhost-kernel and vhost-user do classically. And it allows
> > > > > > > cross-backend, to not modify qemu migration state, etc.
> > > > > > >
> > > > > > > To introduce this opaque state to qemu, that must be fetched =
after the
> > > > > > > suspend and not before, requires changes in vhost protocol, a=
s
> > > > > > > discussed previously.
> > > > > > >
> > > > > > > > > > It looks like vDPA changes are necessary in order to su=
pport
> > > > > > > > > > stateful
> > > > > > > > > > devices even though QEMU already uses SUSPEND. Is my un=
derstanding
> > > > > > > > > > correct?
> > > > > > > > > >
> > > > > > > > > Changes are required elsewhere, as the code to restore th=
e state
> > > > > > > > > properly in the destination has not been merged.
> > > > > > > > I'm not sure what you mean by elsewhere?
> > > > > > > >
> > > > > > > I meant for vdpa *net* devices the changes are not required i=
n vdpa
> > > > > > > ioctls, but mostly in qemu.
> > > > > > >
> > > > > > > If you meant stateful as "it must have a state blob that it m=
ust be
> > > > > > > opaque to qemu", then I think the straightforward action is t=
o fetch
> > > > > > > state blob about the same time as vq indexes. But yes, change=
s (at
> > > > > > > least a new ioctl) is needed for that.
> > > > > > >
> > > > > > > > I'm asking about vDPA ioctls. Right now the sequence is SUS=
PEND and
> > > > > > > > then VHOST_VDPA_SET_STATUS 0.
> > > > > > > >
> > > > > > > > In order to save device state from the vDPA device in the f=
uture, it
> > > > > > > > will be necessary to defer the VHOST_VDPA_SET_STATUS 0 call=
 so that
> > > > > > > > the device state can be saved before the device is reset.
> > > > > > > >
> > > > > > > > Does that sound right?
> > > > > > > >
> > > > > > > The split between suspend and reset was added recently for th=
at very
> > > > > > > reason. In all the virtio devices, the frontend is initialize=
d before
> > > > > > > the backend, so I don't think it is a good idea to defer the =
backend
> > > > > > > cleanup. Especially if we have already set the state is small=
 enough
> > > > > > > to not needing iterative migration from virtiofsd point of vi=
ew.
> > > > > > >
> > > > > > > If fetching that state at the same time as vq indexes is not =
valid,
> > > > > > > could it follow the same model as the "in-flight descriptors"=
?
> > > > > > > vhost-user follows them by using a shared memory region where=
 their
> > > > > > > state is tracked [1]. This allows qemu to survive vhost-user =
SW
> > > > > > > backend crashes, and does not forbid the cross-backends live =
migration
> > > > > > > as all the information is there to recover them.
> > > > > > >
> > > > > > > For hw devices this is not convenient as it occupies PCI band=
width. So
> > > > > > > a possibility is to synchronize this memory region after a
> > > > > > > synchronization point, being the SUSPEND call or GET_VRING_BA=
SE. HW
> > > > > > > devices are not going to crash in the software sense, so all =
use cases
> > > > > > > remain the same to qemu. And that shared memory information i=
s
> > > > > > > recoverable after vhost_dev_stop.
> > > > > > >
> > > > > > > Does that sound reasonable to virtiofsd? To offer a shared me=
mory
> > > > > > > region where it dumps the state, maybe only after the
> > > > > > > set_state(STATE_PHASE_STOPPED)?
> > > > > >
> > > > > > I don=E2=80=99t think we need the set_state() call, necessarily=
, if SUSPEND is
> > > > > > mandatory anyway.
> > > > > >
> > > > > > As for the shared memory, the RFC before this series used share=
d memory,
> > > > > > so it=E2=80=99s possible, yes.  But =E2=80=9Cshared memory regi=
on=E2=80=9D can mean a lot of
> > > > > > things =E2=80=93 it sounds like you=E2=80=99re saying the back-=
end (virtiofsd) should
> > > > > > provide it to the front-end, is that right?  That could work li=
ke this:
> > > > > >
> > > > > > On the source side:
> > > > > >
> > > > > > S1. SUSPEND goes to virtiofsd
> > > > > > S2. virtiofsd maybe double-checks that the device is stopped, t=
hen
> > > > > > serializes its state into a newly allocated shared memory area[=
1]
> > > > > > S3. virtiofsd responds to SUSPEND
> > > > > > S4. front-end requests shared memory, virtiofsd responds with a=
 handle,
> > > > > > maybe already closes its reference
> > > > > > S5. front-end saves state, closes its handle, freeing the SHM
> > > > > >
> > > > > > [1] Maybe virtiofsd can correctly size the serialized state=E2=
=80=99s size, then
> > > > > > it can immediately allocate this area and serialize directly in=
to it;
> > > > > > maybe it can=E2=80=99t, then we=E2=80=99ll need a bounce buffer=
.  Not really a
> > > > > > fundamental problem, but there are limitations around what you =
can do
> > > > > > with serde implementations in Rust=E2=80=A6
> > > > > >
> > > > > > On the destination side:
> > > > > >
> > > > > > D1. Optional SUSPEND goes to virtiofsd that hasn=E2=80=99t yet =
done much;
> > > > > > virtiofsd would serialize its empty state into an SHM area, and=
 respond
> > > > > > to SUSPEND
> > > > > > D2. front-end reads state from migration stream into an SHM it =
has allocated
> > > > > > D3. front-end supplies this SHM to virtiofsd, which discards it=
s
> > > > > > previous area, and now uses this one
> > > > > > D4. RESUME goes to virtiofsd, which deserializes the state from=
 the SHM
> > > > > >
> > > > > > Couple of questions:
> > > > > >
> > > > > > A. Stefan suggested D1, but it does seem wasteful now.  But if =
SUSPEND
> > > > > > would imply to deserialize a state, and the state is to be tran=
sferred
> > > > > > through SHM, this is what would need to be done.  So maybe we s=
hould
> > > > > > skip SUSPEND on the destination?
> > > > > > B. You described that the back-end should supply the SHM, which=
 works
> > > > > > well on the source.  On the destination, only the front-end kno=
ws how
> > > > > > big the state is, so I=E2=80=99ve decided above that it should =
allocate the SHM
> > > > > > (D2) and provide it to the back-end.  Is that feasible or is it
> > > > > > important (e.g. for real hardware) that the back-end supplies t=
he SHM?
> > > > > > (In which case the front-end would need to tell the back-end ho=
w big the
> > > > > > state SHM needs to be.)
> > > > >
> > > > > How does this work for iterative live migration?
> > > > >
> > > >
> > > > A pipe will always fit better for iterative from qemu POV, that's f=
or sure.
> > > > Especially if we want to keep that opaqueness.
> > > >
> > > > But  we will need to communicate with the HW device using shared me=
mory sooner
> > > > or later for big states.  If we don't transform it in qemu, we will=
 need to do
> > > > it in the kernel.  Also, the pipe will not support daemon crashes.
> > > >
> > > > Again I'm just putting this on the table, just in case it fits bett=
er or it is
> > > > convenient.  I missed the previous patch where SHM was proposed too=
, so maybe I
> > > > missed some feedback useful here.  I think the pipe is a better sol=
ution in the
> > > > long run because of the iterative part.
> > >
> > > Pipes and shared memory are conceptually equivalent for building
> > > streaming interfaces. It's just more complex to design a shared memor=
y
> > > interface and it reinvents what file descriptors already offer.
> > >
> > > I have no doubt we could design iterative migration over a shared mem=
ory
> > > interface if we needed to, but I'm not sure why? When you mention
> > > hardware, are you suggesting defining a standard memory/register layo=
ut
> > > that hardware implements and mapping it to userspace (QEMU)?
> >
> > Right.
> >
> > > Is there a
> > > big advantage to exposing memory versus a file descriptor?
> > >
> >
> > For hardware it allows to retrieve and set the device state without
> > intervention of the kernel, saving context switches. For virtiofsd
> > this may not make a lot of sense, but I'm thinking on devices with big
> > states (virtio gpu, maybe?).
>
> A streaming interface implemented using shared memory involves consuming
> chunks of bytes. Each time data has been read, an action must be
> performed to notify the device and receive a notification when more data
> becomes available.
>
> That notification involves the kernel (e.g. an eventfd that is triggered
> by a hardware interrupt) and a read(2) syscall to reset the eventfd.
>
> Unless userspace disables notifications and polls (busy waits) the
> hardware registers, there is still going to be kernel involvement and a
> context switch. For this reason, I think that shared memory vs pipes
> will not be significantly different.
>

Yes, for big states that's right. I was thinking of not-so-big states,
where all of it can be asked in one shot, but it may be problematic
with iterative migration for sure. In that regard pipes are way
better.

> > For software it allows the backend to survive a crash, as the old
> > state can be set directly to a fresh backend instance.
>
> Can you explain by describing the steps involved?

It's how vhost-user inflight I/O tracking works [1]: QEMU and the
backend shares a memory region where the backend dump states
continuously. In the event of a crash, this state can be dumped
directly to a new vhost-user backend.

> Are you sure it can only be done with shared memory and not pipes?
>

Sorry for the confusion, but I never intended to say that :).

[1] https://qemu.readthedocs.io/en/latest/interop/vhost-user.html#inflight-=
i-o-tracking

