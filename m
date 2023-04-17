Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <246691c3-2287-7472-3615-7ec0f074445c@redhat.com>
 <CAJSP0QU-iDTT+xtkZ_xRf4vX+hM0WY+H1SXSuyS+cjiogz3A_A@mail.gmail.com>
 <b0cd4f54-94ed-09a4-cec2-e81f36da4008@redhat.com>
 <CAJaqyWegMfuc8s6bKdxdM4uVixmhy-F3xUUyOCYS1yGDXoiVZA@mail.gmail.com>
 <20230417151840.GD3852722@fedora>
In-Reply-To: <20230417151840.GD3852722@fedora>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 17 Apr 2023 20:55:45 +0200
Message-ID: <CAJaqyWeTBXStyxty4G5qpiG=UoZkmOmr75hHaC3H21kJfK=idg@mail.gmail.com>
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
Cc: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Mon, Apr 17, 2023 at 5:18=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> On Fri, Apr 14, 2023 at 05:17:02PM +0200, Eugenio Perez Martin wrote:
> > On Thu, Apr 13, 2023 at 7:55=E2=80=AFPM Hanna Czenczek <hreitz@redhat.c=
om> wrote:
> > >
> > > On 13.04.23 13:38, Stefan Hajnoczi wrote:
> > > > On Thu, 13 Apr 2023 at 05:24, Hanna Czenczek <hreitz@redhat.com> wr=
ote:
> > > >> On 12.04.23 23:06, Stefan Hajnoczi wrote:
> > > >>> On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > > >>>> So-called "internal" virtio-fs migration refers to transporting =
the
> > > >>>> back-end's (virtiofsd's) state through qemu's migration stream. =
 To do
> > > >>>> this, we need to be able to transfer virtiofsd's internal state =
to and
> > > >>>> from virtiofsd.
> > > >>>>
> > > >>>> Because virtiofsd's internal state will not be too large, we bel=
ieve it
> > > >>>> is best to transfer it as a single binary blob after the streami=
ng
> > > >>>> phase.  Because this method should be useful to other vhost-user
> > > >>>> implementations, too, it is introduced as a general-purpose addi=
tion to
> > > >>>> the protocol, not limited to vhost-user-fs.
> > > >>>>
> > > >>>> These are the additions to the protocol:
> > > >>>> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATOR=
Y_STATE:
> > > >>>>     This feature signals support for transferring state, and is =
added so
> > > >>>>     that migration can fail early when the back-end has no suppo=
rt.
> > > >>>>
> > > >>>> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate=
 a pipe
> > > >>>>     over which to transfer the state.  The front-end sends an FD=
 to the
> > > >>>>     back-end into/from which it can write/read its state, and th=
e back-end
> > > >>>>     can decide to either use it, or reply with a different FD fo=
r the
> > > >>>>     front-end to override the front-end's choice.
> > > >>>>     The front-end creates a simple pipe to transfer the state, b=
ut maybe
> > > >>>>     the back-end already has an FD into/from which it has to wri=
te/read
> > > >>>>     its state, in which case it will want to override the simple=
 pipe.
> > > >>>>     Conversely, maybe in the future we find a way to have the fr=
ont-end
> > > >>>>     get an immediate FD for the migration stream (in some cases)=
, in which
> > > >>>>     case we will want to send this to the back-end instead of cr=
eating a
> > > >>>>     pipe.
> > > >>>>     Hence the negotiation: If one side has a better idea than a =
plain
> > > >>>>     pipe, we will want to use that.
> > > >>>>
> > > >>>> - CHECK_DEVICE_STATE: After the state has been transferred throu=
gh the
> > > >>>>     pipe (the end indicated by EOF), the front-end invokes this =
function
> > > >>>>     to verify success.  There is no in-band way (through the pip=
e) to
> > > >>>>     indicate failure, so we need to check explicitly.
> > > >>>>
> > > >>>> Once the transfer pipe has been established via SET_DEVICE_STATE=
_FD
> > > >>>> (which includes establishing the direction of transfer and migra=
tion
> > > >>>> phase), the sending side writes its data into the pipe, and the =
reading
> > > >>>> side reads it until it sees an EOF.  Then, the front-end will ch=
eck for
> > > >>>> success via CHECK_DEVICE_STATE, which on the destination side in=
cludes
> > > >>>> checking for integrity (i.e. errors during deserialization).
> > > >>>>
> > > >>>> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > >>>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > > >>>> ---
> > > >>>>    include/hw/virtio/vhost-backend.h |  24 +++++
> > > >>>>    include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> > > >>>>    hw/virtio/vhost-user.c            | 147 +++++++++++++++++++++=
+++++++++
> > > >>>>    hw/virtio/vhost.c                 |  37 ++++++++
> > > >>>>    4 files changed, 287 insertions(+)
> > > >>>>
> > > >>>> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virt=
io/vhost-backend.h
> > > >>>> index ec3fbae58d..5935b32fe3 100644
> > > >>>> --- a/include/hw/virtio/vhost-backend.h
> > > >>>> +++ b/include/hw/virtio/vhost-backend.h
> > > >>>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> > > >>>>        VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> > > >>>>    } VhostSetConfigType;
> > > >>>>
> > > >>>> +typedef enum VhostDeviceStateDirection {
> > > >>>> +    /* Transfer state from back-end (device) to front-end */
> > > >>>> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > > >>>> +    /* Transfer state from front-end to back-end (device) */
> > > >>>> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > > >>>> +} VhostDeviceStateDirection;
> > > >>>> +
> > > >>>> +typedef enum VhostDeviceStatePhase {
> > > >>>> +    /* The device (and all its vrings) is stopped */
> > > >>>> +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > > >>>> +} VhostDeviceStatePhase;
> > > >>> vDPA has:
> > > >>>
> > > >>>     /* Suspend a device so it does not process virtqueue requests=
 anymore
> > > >>>      *
> > > >>>      * After the return of ioctl the device must preserve all the=
 necessary state
> > > >>>      * (the virtqueue vring base plus the possible device specifi=
c states) that is
> > > >>>      * required for restoring in the future. The device must not =
change its
> > > >>>      * configuration after that point.
> > > >>>      */
> > > >>>     #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> > > >>>
> > > >>>     /* Resume a device so it can resume processing virtqueue requ=
ests
> > > >>>      *
> > > >>>      * After the return of this ioctl the device will have restor=
ed all the
> > > >>>      * necessary states and it is fully operational to continue p=
rocessing the
> > > >>>      * virtqueue descriptors.
> > > >>>      */
> > > >>>     #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> > > >>>
> > > >>> I wonder if it makes sense to import these into vhost-user so tha=
t the
> > > >>> difference between kernel vhost and vhost-user is minimized. It's=
 okay
> > > >>> if one of them is ahead of the other, but it would be nice to avo=
id
> > > >>> overlapping/duplicated functionality.
> > > >>>
> > > >>> (And I hope vDPA will import the device state vhost-user messages
> > > >>> introduced in this series.)
> > > >> I don=E2=80=99t understand your suggestion.  (Like, I very simply =
don=E2=80=99t
> > > >> understand :))
> > > >>
> > > >> These are vhost messages, right?  What purpose do you have in mind=
 for
> > > >> them in vhost-user for internal migration?  They=E2=80=99re differ=
ent from the
> > > >> state transfer messages, because they don=E2=80=99t transfer state=
 to/from the
> > > >> front-end.  Also, the state transfer stuff is supposed to be disti=
nct
> > > >> from starting/stopping the device; right now, it just requires the
> > > >> device to be stopped beforehand (or started only afterwards).  And=
 in
> > > >> the future, new VhostDeviceStatePhase values may allow the message=
s to
> > > >> be used on devices that aren=E2=80=99t stopped.
> > > >>
> > > >> So they seem to serve very different purposes.  I can imagine usin=
g the
> > > >> VDPA_{SUSPEND,RESUME} messages for external migration (what Anton =
is
> > > >> working on), but they don=E2=80=99t really help with internal migr=
ation
> > > >> implemented here.  If I were to add them, they=E2=80=99d just be s=
ent in
> > > >> addition to the new messages added in this patch here, i.e. SUSPEN=
D on
> > > >> the source before SET_DEVICE_STATE_FD, and RESUME on the destinati=
on
> > > >> after CHECK_DEVICE_STATE (we could use RESUME in place of
> > > >> CHECK_DEVICE_STATE on the destination, but we can=E2=80=99t do tha=
t on the
> > > >> source, so we still need CHECK_DEVICE_STATE).
> > > > Yes, they are complementary to the device state fd message. I want =
to
> > > > make sure pre-conditions about the device's state (running vs stopp=
ed)
> > > > already take into account the vDPA SUSPEND/RESUME model.
> > > >
> > > > vDPA will need device state save/load in the future. For virtiofs
> > > > devices, for example. This is why I think we should plan for vDPA a=
nd
> > > > vhost-user to share the same interface.
> > >
> > > While the paragraph below is more important, I don=E2=80=99t feel lik=
e this
> > > would be important right now.  It=E2=80=99s clear that SUSPEND must c=
ome before
> > > transferring any state, and that RESUME must come after transferring
> > > state.  I don=E2=80=99t think we need to clarify this now, it=E2=80=
=99d be obvious when
> > > implementing SUSPEND/RESUME.
> > >
> > > > Also, I think the code path you're relying on (vhost_dev_stop()) on
> > > > doesn't work for backends that implement VHOST_USER_PROTOCOL_F_STAT=
US
> > > > because stopping the backend resets the device and throws away its
> > > > state. SUSPEND/RESUME solve this. This looks like a more general
> > > > problem since vhost_dev_stop() is called any time the VM is paused.
> > > > Maybe it needs to use SUSPEND/RESUME whenever possible.
> > >
> > > That=E2=80=99s a problem.  Quite a problem, to be honest, because thi=
s sounds
> > > rather complicated with honestly absolutely no practical benefit righ=
t
> > > now.
> > >
> > > Would you require SUSPEND/RESUME for state transfer even if the back-=
end
> > > does not implement GET/SET_STATUS?  Because then this would also lead=
 to
> > > more complexity in virtiofsd.
> > >
> >
> > At this moment the vhost-user net in DPDK suspends at
> > VHOST_GET_VRING_BASE. Not the same case though, as here only the vq
> > indexes / wrap bits are transferred here.
> >
> > Vhost-vdpa implements the suspend call so it does not need to trust
> > VHOST_GET_VRING_BASE to be the last vring call done. Since virtiofsd
> > is using vhost-user maybe it is not needed to implement it actually.
>
> Careful, if we deliberately make vhost-user and vDPA diverge, then it
> will be hard to share the migration interface.
>

I don't recall the exact reasons for not following with the
VRING_GET_BASE =3D=3D suspend for vDPA, IIRC was the lack of a proper
definition back then. But vhost-kernel and vhost-user already diverged
in that regard, for example. vhost-kernel set a tap backend of -1 to
suspend the device.

> > > Basically, what I=E2=80=99m hearing is that I need to implement a dif=
ferent
> > > feature that has no practical impact right now, and also fix bugs aro=
und
> > > it along the way...
> > >
> >
> > To fix this properly requires iterative device migration in qemu as
> > far as I know, instead of using VMStates [1]. This way the state is
> > requested to virtiofsd before the device reset.
>
> I don't follow. Many devices are fine with non-iterative migration. They
> shouldn't be forced to do iterative migration.
>

Sorry I think I didn't express myself well. I didn't mean to force
virtiofsd to support the iterative migration, but to use the device
iterative migration API in QEMU to send the needed commands before
vhost_dev_stop. In that regard, the device or the vhost-user commands
would not require changes.

I think it is convenient in the long run for virtiofsd, as if the
state grows so much that it's not feasible to fetch it in one shot
there is no need to make changes in the qemu migration protocol. I
think it is not unlikely in virtiofs, but maybe I'm missing something
obvious and it's state will never grow.

> > What does virtiofsd do when the state is totally sent? Does it keep
> > processing requests and generating new state or is only a one shot
> > that will suspend the daemon? If it is the second I think it still can
> > be done in one shot at the end, always indicating "no more state" at
> > save_live_pending and sending all the state at
> > save_live_complete_precopy.
> >
> > Does that make sense to you?
> >
> > Thanks!
> >
> > [1] https://qemu.readthedocs.io/en/latest/devel/migration.html#iterativ=
e-device-migration
> >

