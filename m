Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
 <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
 <d9d67f07-3d4c-9bdb-052b-28e21fa27dd6@redhat.com>
In-Reply-To: <d9d67f07-3d4c-9bdb-052b-28e21fa27dd6@redhat.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Mon, 17 Apr 2023 20:37:36 +0200
Message-ID: <CAJaqyWd9=4BEY5urge2e1qwyFTisjXijnqr762Y-aDAh5WPiWA@mail.gmail.com>
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
To: Hanna Czenczek <hreitz@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Thu, Apr 13, 2023 at 7:32=E2=80=AFPM Hanna Czenczek <hreitz@redhat.com> =
wrote:
>
> On 13.04.23 12:14, Eugenio Perez Martin wrote:
> > On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redh=
at.com> wrote:
> >> On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> >>> So-called "internal" virtio-fs migration refers to transporting the
> >>> back-end's (virtiofsd's) state through qemu's migration stream.  To d=
o
> >>> this, we need to be able to transfer virtiofsd's internal state to an=
d
> >>> from virtiofsd.
> >>>
> >>> Because virtiofsd's internal state will not be too large, we believe =
it
> >>> is best to transfer it as a single binary blob after the streaming
> >>> phase.  Because this method should be useful to other vhost-user
> >>> implementations, too, it is introduced as a general-purpose addition =
to
> >>> the protocol, not limited to vhost-user-fs.
> >>>
> >>> These are the additions to the protocol:
> >>> - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_STA=
TE:
> >>>    This feature signals support for transferring state, and is added =
so
> >>>    that migration can fail early when the back-end has no support.
> >>>
> >>> - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a pi=
pe
> >>>    over which to transfer the state.  The front-end sends an FD to th=
e
> >>>    back-end into/from which it can write/read its state, and the back=
-end
> >>>    can decide to either use it, or reply with a different FD for the
> >>>    front-end to override the front-end's choice.
> >>>    The front-end creates a simple pipe to transfer the state, but may=
be
> >>>    the back-end already has an FD into/from which it has to write/rea=
d
> >>>    its state, in which case it will want to override the simple pipe.
> >>>    Conversely, maybe in the future we find a way to have the front-en=
d
> >>>    get an immediate FD for the migration stream (in some cases), in w=
hich
> >>>    case we will want to send this to the back-end instead of creating=
 a
> >>>    pipe.
> >>>    Hence the negotiation: If one side has a better idea than a plain
> >>>    pipe, we will want to use that.
> >>>
> >>> - CHECK_DEVICE_STATE: After the state has been transferred through th=
e
> >>>    pipe (the end indicated by EOF), the front-end invokes this functi=
on
> >>>    to verify success.  There is no in-band way (through the pipe) to
> >>>    indicate failure, so we need to check explicitly.
> >>>
> >>> Once the transfer pipe has been established via SET_DEVICE_STATE_FD
> >>> (which includes establishing the direction of transfer and migration
> >>> phase), the sending side writes its data into the pipe, and the readi=
ng
> >>> side reads it until it sees an EOF.  Then, the front-end will check f=
or
> >>> success via CHECK_DEVICE_STATE, which on the destination side include=
s
> >>> checking for integrity (i.e. errors during deserialization).
> >>>
> >>> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> >>> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> >>> ---
> >>>   include/hw/virtio/vhost-backend.h |  24 +++++
> >>>   include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> >>>   hw/virtio/vhost-user.c            | 147 +++++++++++++++++++++++++++=
+++
> >>>   hw/virtio/vhost.c                 |  37 ++++++++
> >>>   4 files changed, 287 insertions(+)
> >>>
> >>> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vh=
ost-backend.h
> >>> index ec3fbae58d..5935b32fe3 100644
> >>> --- a/include/hw/virtio/vhost-backend.h
> >>> +++ b/include/hw/virtio/vhost-backend.h
> >>> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> >>>       VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> >>>   } VhostSetConfigType;
> >>>
> >>> +typedef enum VhostDeviceStateDirection {
> >>> +    /* Transfer state from back-end (device) to front-end */
> >>> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> >>> +    /* Transfer state from front-end to back-end (device) */
> >>> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> >>> +} VhostDeviceStateDirection;
> >>> +
> >>> +typedef enum VhostDeviceStatePhase {
> >>> +    /* The device (and all its vrings) is stopped */
> >>> +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> >>> +} VhostDeviceStatePhase;
> >> vDPA has:
> >>
> >>    /* Suspend a device so it does not process virtqueue requests anymo=
re
> >>     *
> >>     * After the return of ioctl the device must preserve all the neces=
sary state
> >>     * (the virtqueue vring base plus the possible device specific stat=
es) that is
> >>     * required for restoring in the future. The device must not change=
 its
> >>     * configuration after that point.
> >>     */
> >>    #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
> >>
> >>    /* Resume a device so it can resume processing virtqueue requests
> >>     *
> >>     * After the return of this ioctl the device will have restored all=
 the
> >>     * necessary states and it is fully operational to continue process=
ing the
> >>     * virtqueue descriptors.
> >>     */
> >>    #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
> >>
> >> I wonder if it makes sense to import these into vhost-user so that the
> >> difference between kernel vhost and vhost-user is minimized. It's okay
> >> if one of them is ahead of the other, but it would be nice to avoid
> >> overlapping/duplicated functionality.
> >>
> > That's what I had in mind in the first versions. I proposed VHOST_STOP
> > instead of VHOST_VDPA_STOP for this very reason. Later it did change
> > to SUSPEND.
> >
> > Generally it is better if we make the interface less parametrized and
> > we trust in the messages and its semantics in my opinion. In other
> > words, instead of
> > vhost_set_device_state_fd_op(VHOST_TRANSFER_STATE_PHASE_STOPPED), send
> > individually the equivalent of VHOST_VDPA_SUSPEND vhost-user command.
>
> I.e. you mean that this should simply be stateful instead of
> re-affirming the current state with a parameter?
>
> The problem I see is that transferring states in different phases of
> migration will require specialized implementations.  So running
> SET_DEVICE_STATE_FD in a different phase will require support from the
> back-end.  Same in the front-end, the exact protocol and thus
> implementation will (probably, difficult to say at this point) depend on
> the migration phase.  I would therefore prefer to have an explicit
> distinction in the command itself that affirms the phase we=E2=80=99re
> targeting.
>

I think we will have this same problem when more phases are added, as
the fd and direction arguments are always  passed whatever phase you
set. Future phases may not require it, or require different arguments.

> On the other hand, I don=E2=80=99t see the parameter complicating anythin=
g. The
> front-end must supply it, but it will know the phase anyway, so this is
> easy.  The back-end can just choose to ignore it, if it doesn=E2=80=99t f=
eel the
> need to verify that the phase is what it thinks it is.
>
> > Another way to apply this is with the "direction" parameter. Maybe it
> > is better to split it into "set_state_fd" and "get_state_fd"?
>
> Well, it would rather be `set_state_send_fd` and `set_state_receive_fd`.

Right, thanks for the correction.

> We always negotiate a pipe between front-end and back-end, the question
> is just whether the back-end gets the receiving (load) or the sending
> (save) end.
>
> Technically, one can make it fully stateful and say that if the device
> hasn=E2=80=99t been started already, it=E2=80=99s always a LOAD, and othe=
rwise always a
> SAVE.  But as above, I=E2=80=99d prefer to keep the parameter because the
> implementations are different, so I=E2=80=99d prefer there to be a
> re-affirmation that front-end and back-end are in sync about what should
> be done.
>
> Personally, I don=E2=80=99t really see the advantage of having two functi=
ons
> instead of one function with an enum with two values.  The thing about
> SET_DEVICE_STATE_FD is that it itself won=E2=80=99t differ much regardles=
s of
> whether we=E2=80=99re loading or saving, it just negotiates the pipe =E2=
=80=93 the
> difference is what happens after the pipe has been negotiated.  So if we
> split the function into two, both implementations will share most of
> their code anyway, which makes me think it should be a single function.
>

Yes, all of that makes sense.

My proposal was in the line of following other commands like
VHOST_USER_SET_VRING_BASE / VHOST_USER_GET_VRING_BASE or
VHOST_USER_SET_INFLIGHT_FD and VHOST_USER_GET_INFLIGHT_FD. If that has
been considered and it is more convenient to use the arguments I'm
totally fine.

> > In that case, reusing the ioctls as vhost-user messages would be ok.
> > But that puts this proposal further from the VFIO code, which uses
> > "migration_set_state(state)", and maybe it is better when the number
> > of states is high.
>
> I=E2=80=99m not sure what you mean (because I don=E2=80=99t know the VFIO=
 code, I
> assume).  Are you saying that using a more finely grained
> migration_set_state() model would conflict with the rather coarse
> suspend/resume?
>

I don't think it exactly conflicts, as we should be able to map both
to a given set_state. They may overlap if vhost-user decides to use
them. Or if vdpa decides to use SET_DEVICE_STATE_FD.

This already happens with the different vhost backends, each one has a
different way to suspend the device in the case of a migration anyway.

Thanks!

> > BTW, is there any usage for *reply_fd at this moment from the backend?
>
> No, virtiofsd doesn=E2=80=99t plan to make use of it.
>
> Hanna
>

