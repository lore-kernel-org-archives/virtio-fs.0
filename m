Return-Path: <eperezma@redhat.com>
MIME-Version: 1.0
References: <20230411150515.14020-1-hreitz@redhat.com>
 <20230411150515.14020-3-hreitz@redhat.com>
 <20230412210641.GC2813183@fedora>
In-Reply-To: <20230412210641.GC2813183@fedora>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 13 Apr 2023 12:14:24 +0200
Message-ID: <CAJaqyWfm=g_hr9=WpsnwJ4hdpVb7K7p5rirWjvx=PxKYUp8trA@mail.gmail.com>
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
To: Hanna Czenczek <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, German Maglione <gmaglione@redhat.com>, Anton Kuchin <antonkuchin@yandex-team.ru>, Juan Quintela <quintela@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>

On Wed, Apr 12, 2023 at 11:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> On Tue, Apr 11, 2023 at 05:05:13PM +0200, Hanna Czenczek wrote:
> > So-called "internal" virtio-fs migration refers to transporting the
> > back-end's (virtiofsd's) state through qemu's migration stream.  To do
> > this, we need to be able to transfer virtiofsd's internal state to and
> > from virtiofsd.
> >
> > Because virtiofsd's internal state will not be too large, we believe it
> > is best to transfer it as a single binary blob after the streaming
> > phase.  Because this method should be useful to other vhost-user
> > implementations, too, it is introduced as a general-purpose addition to
> > the protocol, not limited to vhost-user-fs.
> >
> > These are the additions to the protocol:
> > - New vhost-user protocol feature VHOST_USER_PROTOCOL_F_MIGRATORY_STATE=
:
> >   This feature signals support for transferring state, and is added so
> >   that migration can fail early when the back-end has no support.
> >
> > - SET_DEVICE_STATE_FD function: Front-end and back-end negotiate a pipe
> >   over which to transfer the state.  The front-end sends an FD to the
> >   back-end into/from which it can write/read its state, and the back-en=
d
> >   can decide to either use it, or reply with a different FD for the
> >   front-end to override the front-end's choice.
> >   The front-end creates a simple pipe to transfer the state, but maybe
> >   the back-end already has an FD into/from which it has to write/read
> >   its state, in which case it will want to override the simple pipe.
> >   Conversely, maybe in the future we find a way to have the front-end
> >   get an immediate FD for the migration stream (in some cases), in whic=
h
> >   case we will want to send this to the back-end instead of creating a
> >   pipe.
> >   Hence the negotiation: If one side has a better idea than a plain
> >   pipe, we will want to use that.
> >
> > - CHECK_DEVICE_STATE: After the state has been transferred through the
> >   pipe (the end indicated by EOF), the front-end invokes this function
> >   to verify success.  There is no in-band way (through the pipe) to
> >   indicate failure, so we need to check explicitly.
> >
> > Once the transfer pipe has been established via SET_DEVICE_STATE_FD
> > (which includes establishing the direction of transfer and migration
> > phase), the sending side writes its data into the pipe, and the reading
> > side reads it until it sees an EOF.  Then, the front-end will check for
> > success via CHECK_DEVICE_STATE, which on the destination side includes
> > checking for integrity (i.e. errors during deserialization).
> >
> > Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> > ---
> >  include/hw/virtio/vhost-backend.h |  24 +++++
> >  include/hw/virtio/vhost.h         |  79 ++++++++++++++++
> >  hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++++++
> >  hw/virtio/vhost.c                 |  37 ++++++++
> >  4 files changed, 287 insertions(+)
> >
> > diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhos=
t-backend.h
> > index ec3fbae58d..5935b32fe3 100644
> > --- a/include/hw/virtio/vhost-backend.h
> > +++ b/include/hw/virtio/vhost-backend.h
> > @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
> >      VHOST_SET_CONFIG_TYPE_MIGRATION =3D 1,
> >  } VhostSetConfigType;
> >
> > +typedef enum VhostDeviceStateDirection {
> > +    /* Transfer state from back-end (device) to front-end */
> > +    VHOST_TRANSFER_STATE_DIRECTION_SAVE =3D 0,
> > +    /* Transfer state from front-end to back-end (device) */
> > +    VHOST_TRANSFER_STATE_DIRECTION_LOAD =3D 1,
> > +} VhostDeviceStateDirection;
> > +
> > +typedef enum VhostDeviceStatePhase {
> > +    /* The device (and all its vrings) is stopped */
> > +    VHOST_TRANSFER_STATE_PHASE_STOPPED =3D 0,
> > +} VhostDeviceStatePhase;
>
> vDPA has:
>
>   /* Suspend a device so it does not process virtqueue requests anymore
>    *
>    * After the return of ioctl the device must preserve all the necessary=
 state
>    * (the virtqueue vring base plus the possible device specific states) =
that is
>    * required for restoring in the future. The device must not change its
>    * configuration after that point.
>    */
>   #define VHOST_VDPA_SUSPEND      _IO(VHOST_VIRTIO, 0x7D)
>
>   /* Resume a device so it can resume processing virtqueue requests
>    *
>    * After the return of this ioctl the device will have restored all the
>    * necessary states and it is fully operational to continue processing =
the
>    * virtqueue descriptors.
>    */
>   #define VHOST_VDPA_RESUME       _IO(VHOST_VIRTIO, 0x7E)
>
> I wonder if it makes sense to import these into vhost-user so that the
> difference between kernel vhost and vhost-user is minimized. It's okay
> if one of them is ahead of the other, but it would be nice to avoid
> overlapping/duplicated functionality.
>

That's what I had in mind in the first versions. I proposed VHOST_STOP
instead of VHOST_VDPA_STOP for this very reason. Later it did change
to SUSPEND.

Generally it is better if we make the interface less parametrized and
we trust in the messages and its semantics in my opinion. In other
words, instead of
vhost_set_device_state_fd_op(VHOST_TRANSFER_STATE_PHASE_STOPPED), send
individually the equivalent of VHOST_VDPA_SUSPEND vhost-user command.

Another way to apply this is with the "direction" parameter. Maybe it
is better to split it into "set_state_fd" and "get_state_fd"?

In that case, reusing the ioctls as vhost-user messages would be ok.
But that puts this proposal further from the VFIO code, which uses
"migration_set_state(state)", and maybe it is better when the number
of states is high.

BTW, is there any usage for *reply_fd at this moment from the backend?

> (And I hope vDPA will import the device state vhost-user messages
> introduced in this series.)
>

I guess they will be needed for vdpa-fs devices? Is there any emulated
virtio-fs in qemu?

Thanks!

> > +
> >  struct vhost_inflight;
> >  struct vhost_dev;
> >  struct vhost_log;
> > @@ -133,6 +145,15 @@ typedef int (*vhost_set_config_call_op)(struct vho=
st_dev *dev,
> >
> >  typedef void (*vhost_reset_status_op)(struct vhost_dev *dev);
> >
> > +typedef bool (*vhost_supports_migratory_state_op)(struct vhost_dev *de=
v);
> > +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
> > +                                            VhostDeviceStateDirection =
direction,
> > +                                            VhostDeviceStatePhase phas=
e,
> > +                                            int fd,
> > +                                            int *reply_fd,
> > +                                            Error **errp);
> > +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev, Erro=
r **errp);
> > +
> >  typedef struct VhostOps {
> >      VhostBackendType backend_type;
> >      vhost_backend_init vhost_backend_init;
> > @@ -181,6 +202,9 @@ typedef struct VhostOps {
> >      vhost_force_iommu_op vhost_force_iommu;
> >      vhost_set_config_call_op vhost_set_config_call;
> >      vhost_reset_status_op vhost_reset_status;
> > +    vhost_supports_migratory_state_op vhost_supports_migratory_state;
> > +    vhost_set_device_state_fd_op vhost_set_device_state_fd;
> > +    vhost_check_device_state_op vhost_check_device_state;
> >  } VhostOps;
> >
> >  int vhost_backend_update_device_iotlb(struct vhost_dev *dev,
> > diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> > index 2fe02ed5d4..29449e0fe2 100644
> > --- a/include/hw/virtio/vhost.h
> > +++ b/include/hw/virtio/vhost.h
> > @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
> >                             struct vhost_inflight *inflight);
> >  int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
> >                             struct vhost_inflight *inflight);
> > +
> > +/**
> > + * vhost_supports_migratory_state(): Checks whether the back-end
> > + * supports transferring internal state for the purpose of migration.
> > + * Support for this feature is required for vhost_set_device_state_fd(=
)
> > + * and vhost_check_device_state().
> > + *
> > + * @dev: The vhost device
> > + *
> > + * Returns true if the device supports these commands, and false if it
> > + * does not.
> > + */
> > +bool vhost_supports_migratory_state(struct vhost_dev *dev);
> > +
> > +/**
> > + * vhost_set_device_state_fd(): Begin transfer of internal state from/=
to
> > + * the back-end for the purpose of migration.  Data is to be transferr=
ed
> > + * over a pipe according to @direction and @phase.  The sending end mu=
st
> > + * only write to the pipe, and the receiving end must only read from i=
t.
> > + * Once the sending end is done, it closes its FD.  The receiving end
> > + * must take this as the end-of-transfer signal and close its FD, too.
> > + *
> > + * @fd is the back-end's end of the pipe: The write FD for SAVE, and t=
he
> > + * read FD for LOAD.  This function transfers ownership of @fd to the
> > + * back-end, i.e. closes it in the front-end.
> > + *
> > + * The back-end may optionally reply with an FD of its own, if this
> > + * improves efficiency on its end.  In this case, the returned FD is
> > + * stored in *reply_fd.  The back-end will discard the FD sent to it,
> > + * and the front-end must use *reply_fd for transferring state to/from
> > + * the back-end.
> > + *
> > + * @dev: The vhost device
> > + * @direction: The direction in which the state is to be transferred.
> > + *             For outgoing migrations, this is SAVE, and data is read
> > + *             from the back-end and stored by the front-end in the
> > + *             migration stream.
> > + *             For incoming migrations, this is LOAD, and data is read
> > + *             by the front-end from the migration stream and sent to
> > + *             the back-end to restore the saved state.
> > + * @phase: Which migration phase we are in.  Currently, there is only
> > + *         STOPPED (device and all vrings are stopped), in the future,
> > + *         more phases such as PRE_COPY or POST_COPY may be added.
> > + * @fd: Back-end's end of the pipe through which to transfer state; no=
te
> > + *      that ownership is transferred to the back-end, so this functio=
n
> > + *      closes @fd in the front-end.
> > + * @reply_fd: If the back-end wishes to use a different pipe for state
> > + *            transfer, this will contain an FD for the front-end to
> > + *            use.  Otherwise, -1 is stored here.
> > + * @errp: Potential error description
> > + *
> > + * Returns 0 on success, and -errno on failure.
> > + */
> > +int vhost_set_device_state_fd(struct vhost_dev *dev,
> > +                              VhostDeviceStateDirection direction,
> > +                              VhostDeviceStatePhase phase,
> > +                              int fd,
> > +                              int *reply_fd,
> > +                              Error **errp);
> > +
> > +/**
> > + * vhost_set_device_state_fd(): After transferring state from/to the
> > + * back-end via vhost_set_device_state_fd(), i.e. once the sending end
> > + * has closed the pipe, inquire the back-end to report any potential
> > + * errors that have occurred on its side.  This allows to sense errors
> > + * like:
> > + * - During outgoing migration, when the source side had already start=
ed
> > + *   to produce its state, something went wrong and it failed to finis=
h
> > + * - During incoming migration, when the received state is somehow
> > + *   invalid and cannot be processed by the back-end
> > + *
> > + * @dev: The vhost device
> > + * @errp: Potential error description
> > + *
> > + * Returns 0 when the back-end reports successful state transfer and
> > + * processing, and -errno when an error occurred somewhere.
> > + */
> > +int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
> > +
> >  #endif
> > diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> > index e5285df4ba..93d8f2494a 100644
> > --- a/hw/virtio/vhost-user.c
> > +++ b/hw/virtio/vhost-user.c
> > @@ -83,6 +83,7 @@ enum VhostUserProtocolFeature {
> >      /* Feature 14 reserved for VHOST_USER_PROTOCOL_F_INBAND_NOTIFICATI=
ONS. */
> >      VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS =3D 15,
> >      VHOST_USER_PROTOCOL_F_STATUS =3D 16,
> > +    VHOST_USER_PROTOCOL_F_MIGRATORY_STATE =3D 17,
> >      VHOST_USER_PROTOCOL_F_MAX
> >  };
> >
> > @@ -130,6 +131,8 @@ typedef enum VhostUserRequest {
> >      VHOST_USER_REM_MEM_REG =3D 38,
> >      VHOST_USER_SET_STATUS =3D 39,
> >      VHOST_USER_GET_STATUS =3D 40,
> > +    VHOST_USER_SET_DEVICE_STATE_FD =3D 41,
> > +    VHOST_USER_CHECK_DEVICE_STATE =3D 42,
> >      VHOST_USER_MAX
> >  } VhostUserRequest;
> >
> > @@ -210,6 +213,12 @@ typedef struct {
> >      uint32_t size; /* the following payload size */
> >  } QEMU_PACKED VhostUserHeader;
> >
> > +/* Request payload of VHOST_USER_SET_DEVICE_STATE_FD */
> > +typedef struct VhostUserTransferDeviceState {
> > +    uint32_t direction;
> > +    uint32_t phase;
> > +} VhostUserTransferDeviceState;
> > +
> >  typedef union {
> >  #define VHOST_USER_VRING_IDX_MASK   (0xff)
> >  #define VHOST_USER_VRING_NOFD_MASK  (0x1 << 8)
> > @@ -224,6 +233,7 @@ typedef union {
> >          VhostUserCryptoSession session;
> >          VhostUserVringArea area;
> >          VhostUserInflight inflight;
> > +        VhostUserTransferDeviceState transfer_state;
> >  } VhostUserPayload;
> >
> >  typedef struct VhostUserMsg {
> > @@ -2681,6 +2691,140 @@ static int vhost_user_dev_start(struct vhost_de=
v *dev, bool started)
> >      }
> >  }
> >
> > +static bool vhost_user_supports_migratory_state(struct vhost_dev *dev)
> > +{
> > +    return virtio_has_feature(dev->protocol_features,
> > +                              VHOST_USER_PROTOCOL_F_MIGRATORY_STATE);
> > +}
> > +
> > +static int vhost_user_set_device_state_fd(struct vhost_dev *dev,
> > +                                          VhostDeviceStateDirection di=
rection,
> > +                                          VhostDeviceStatePhase phase,
> > +                                          int fd,
> > +                                          int *reply_fd,
> > +                                          Error **errp)
> > +{
> > +    int ret;
> > +    struct vhost_user *vu =3D dev->opaque;
> > +    VhostUserMsg msg =3D {
> > +        .hdr =3D {
> > +            .request =3D VHOST_USER_SET_DEVICE_STATE_FD,
> > +            .flags =3D VHOST_USER_VERSION,
> > +            .size =3D sizeof(msg.payload.transfer_state),
> > +        },
> > +        .payload.transfer_state =3D {
> > +            .direction =3D direction,
> > +            .phase =3D phase,
> > +        },
> > +    };
> > +
> > +    *reply_fd =3D -1;
> > +
> > +    if (!vhost_user_supports_migratory_state(dev)) {
> > +        close(fd);
> > +        error_setg(errp, "Back-end does not support migration state tr=
ansfer");
> > +        return -ENOTSUP;
> > +    }
> > +
> > +    ret =3D vhost_user_write(dev, &msg, &fd, 1);
> > +    close(fd);
> > +    if (ret < 0) {
> > +        error_setg_errno(errp, -ret,
> > +                         "Failed to send SET_DEVICE_STATE_FD message")=
;
> > +        return ret;
> > +    }
> > +
> > +    ret =3D vhost_user_read(dev, &msg);
> > +    if (ret < 0) {
> > +        error_setg_errno(errp, -ret,
> > +                         "Failed to receive SET_DEVICE_STATE_FD reply"=
);
> > +        return ret;
> > +    }
> > +
> > +    if (msg.hdr.request !=3D VHOST_USER_SET_DEVICE_STATE_FD) {
> > +        error_setg(errp,
> > +                   "Received unexpected message type, expected %d, rec=
eived %d",
> > +                   VHOST_USER_SET_DEVICE_STATE_FD, msg.hdr.request);
> > +        return -EPROTO;
> > +    }
> > +
> > +    if (msg.hdr.size !=3D sizeof(msg.payload.u64)) {
> > +        error_setg(errp,
> > +                   "Received bad message size, expected %zu, received =
%" PRIu32,
> > +                   sizeof(msg.payload.u64), msg.hdr.size);
> > +        return -EPROTO;
> > +    }
> > +
> > +    if ((msg.payload.u64 & 0xff) !=3D 0) {
> > +        error_setg(errp, "Back-end did not accept migration state tran=
sfer");
> > +        return -EIO;
> > +    }
> > +
> > +    if (!(msg.payload.u64 & VHOST_USER_VRING_NOFD_MASK)) {
> > +        *reply_fd =3D qemu_chr_fe_get_msgfd(vu->user->chr);
> > +        if (*reply_fd < 0) {
> > +            error_setg(errp,
> > +                       "Failed to get back-end-provided transfer pipe =
FD");
> > +            *reply_fd =3D -1;
> > +            return -EIO;
> > +        }
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> > +static int vhost_user_check_device_state(struct vhost_dev *dev, Error =
**errp)
> > +{
> > +    int ret;
> > +    VhostUserMsg msg =3D {
> > +        .hdr =3D {
> > +            .request =3D VHOST_USER_CHECK_DEVICE_STATE,
> > +            .flags =3D VHOST_USER_VERSION,
> > +            .size =3D 0,
> > +        },
> > +    };
> > +
> > +    if (!vhost_user_supports_migratory_state(dev)) {
> > +        error_setg(errp, "Back-end does not support migration state tr=
ansfer");
> > +        return -ENOTSUP;
> > +    }
> > +
> > +    ret =3D vhost_user_write(dev, &msg, NULL, 0);
> > +    if (ret < 0) {
> > +        error_setg_errno(errp, -ret,
> > +                         "Failed to send CHECK_DEVICE_STATE message");
> > +        return ret;
> > +    }
> > +
> > +    ret =3D vhost_user_read(dev, &msg);
> > +    if (ret < 0) {
> > +        error_setg_errno(errp, -ret,
> > +                         "Failed to receive CHECK_DEVICE_STATE reply")=
;
> > +        return ret;
> > +    }
> > +
> > +    if (msg.hdr.request !=3D VHOST_USER_CHECK_DEVICE_STATE) {
> > +        error_setg(errp,
> > +                   "Received unexpected message type, expected %d, rec=
eived %d",
> > +                   VHOST_USER_CHECK_DEVICE_STATE, msg.hdr.request);
> > +        return -EPROTO;
> > +    }
> > +
> > +    if (msg.hdr.size !=3D sizeof(msg.payload.u64)) {
> > +        error_setg(errp,
> > +                   "Received bad message size, expected %zu, received =
%" PRIu32,
> > +                   sizeof(msg.payload.u64), msg.hdr.size);
> > +        return -EPROTO;
> > +    }
> > +
> > +    if (msg.payload.u64 !=3D 0) {
> > +        error_setg(errp, "Back-end failed to process its internal stat=
e");
> > +        return -EIO;
> > +    }
> > +
> > +    return 0;
> > +}
> > +
> >  const VhostOps user_ops =3D {
> >          .backend_type =3D VHOST_BACKEND_TYPE_USER,
> >          .vhost_backend_init =3D vhost_user_backend_init,
> > @@ -2716,4 +2860,7 @@ const VhostOps user_ops =3D {
> >          .vhost_get_inflight_fd =3D vhost_user_get_inflight_fd,
> >          .vhost_set_inflight_fd =3D vhost_user_set_inflight_fd,
> >          .vhost_dev_start =3D vhost_user_dev_start,
> > +        .vhost_supports_migratory_state =3D vhost_user_supports_migrat=
ory_state,
> > +        .vhost_set_device_state_fd =3D vhost_user_set_device_state_fd,
> > +        .vhost_check_device_state =3D vhost_user_check_device_state,
> >  };
> > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > index cbff589efa..90099d8f6a 100644
> > --- a/hw/virtio/vhost.c
> > +++ b/hw/virtio/vhost.c
> > @@ -2088,3 +2088,40 @@ int vhost_net_set_backend(struct vhost_dev *hdev=
,
> >
> >      return -ENOSYS;
> >  }
> > +
> > +bool vhost_supports_migratory_state(struct vhost_dev *dev)
> > +{
> > +    if (dev->vhost_ops->vhost_supports_migratory_state) {
> > +        return dev->vhost_ops->vhost_supports_migratory_state(dev);
> > +    }
> > +
> > +    return false;
> > +}
> > +
> > +int vhost_set_device_state_fd(struct vhost_dev *dev,
> > +                              VhostDeviceStateDirection direction,
> > +                              VhostDeviceStatePhase phase,
> > +                              int fd,
> > +                              int *reply_fd,
> > +                              Error **errp)
> > +{
> > +    if (dev->vhost_ops->vhost_set_device_state_fd) {
> > +        return dev->vhost_ops->vhost_set_device_state_fd(dev, directio=
n, phase,
> > +                                                         fd, reply_fd,=
 errp);
> > +    }
> > +
> > +    error_setg(errp,
> > +               "vhost transport does not support migration state trans=
fer");
> > +    return -ENOSYS;
> > +}
> > +
> > +int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
> > +{
> > +    if (dev->vhost_ops->vhost_check_device_state) {
> > +        return dev->vhost_ops->vhost_check_device_state(dev, errp);
> > +    }
> > +
> > +    error_setg(errp,
> > +               "vhost transport does not support migration state trans=
fer");
> > +    return -ENOSYS;
> > +}
> > --
> > 2.39.1
> >

