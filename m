Return-Path: <hao.xu@linux.dev>
Message-ID: <d5fc7e82-3bd5-deeb-b506-5a8d10bd7112@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1689855229;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2bakeTI+gagck4M5EUwFUmezf10gmavqKh68Ty1NQA0=;
 b=WBhlvziJ4KXgLnRJ4OhFDCTrpqYthD1WAPPsZbpUaUuE89bkwhipSbID9iOunIrjT9r8Hx
 Rm3Mti9fb3qfrALyJiEn1pjZsvqEyZg161nlMBQRDFyLyYKIMaa5gvU2IkVUHwaNqavGMA
 ZNeAkRIbqbPCeDpzzyksZqt1dDq97No=
Date: Thu, 20 Jul 2023 20:13:42 +0800
MIME-Version: 1.0
References: <20230712111703.28031-1-hreitz@redhat.com>
 <20230712111703.28031-3-hreitz@redhat.com>
From: Hao Xu <hao.xu@linux.dev>
In-Reply-To: <20230712111703.28031-3-hreitz@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [PATCH v2 2/4] vhost-user: Interface for migration
 state transfer
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>, qemu-devel@nongnu.org, virtio-fs@redhat.com
Cc: =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>


On 7/12/23 19:17, Hanna Czenczek wrote:
> Add the interface for transferring the back-end's state during migration
> as defined previously in vhost-user.rst.
>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>   include/hw/virtio/vhost-backend.h |  24 +++++
>   include/hw/virtio/vhost.h         |  79 ++++++++++++++++
>   hw/virtio/vhost-user.c            | 147 ++++++++++++++++++++++++++++++
>   hw/virtio/vhost.c                 |  37 ++++++++
>   4 files changed, 287 insertions(+)
>
> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
> index 31a251a9f5..e59d0b53f8 100644
> --- a/include/hw/virtio/vhost-backend.h
> +++ b/include/hw/virtio/vhost-backend.h
> @@ -26,6 +26,18 @@ typedef enum VhostSetConfigType {
>       VHOST_SET_CONFIG_TYPE_MIGRATION = 1,
>   } VhostSetConfigType;
>   
> +typedef enum VhostDeviceStateDirection {
> +    /* Transfer state from back-end (device) to front-end */
> +    VHOST_TRANSFER_STATE_DIRECTION_SAVE = 0,
> +    /* Transfer state from front-end to back-end (device) */
> +    VHOST_TRANSFER_STATE_DIRECTION_LOAD = 1,
> +} VhostDeviceStateDirection;
> +
> +typedef enum VhostDeviceStatePhase {
> +    /* The device (and all its vrings) is stopped */
> +    VHOST_TRANSFER_STATE_PHASE_STOPPED = 0,
> +} VhostDeviceStatePhase;
> +
>   struct vhost_inflight;
>   struct vhost_dev;
>   struct vhost_log;
> @@ -133,6 +145,15 @@ typedef int (*vhost_set_config_call_op)(struct vhost_dev *dev,
>   
>   typedef void (*vhost_reset_status_op)(struct vhost_dev *dev);
>   
> +typedef bool (*vhost_supports_migratory_state_op)(struct vhost_dev *dev);
> +typedef int (*vhost_set_device_state_fd_op)(struct vhost_dev *dev,
> +                                            VhostDeviceStateDirection direction,
> +                                            VhostDeviceStatePhase phase,
> +                                            int fd,
> +                                            int *reply_fd,
> +                                            Error **errp);
> +typedef int (*vhost_check_device_state_op)(struct vhost_dev *dev, Error **errp);
> +
>   typedef struct VhostOps {
>       VhostBackendType backend_type;
>       vhost_backend_init vhost_backend_init;
> @@ -181,6 +202,9 @@ typedef struct VhostOps {
>       vhost_force_iommu_op vhost_force_iommu;
>       vhost_set_config_call_op vhost_set_config_call;
>       vhost_reset_status_op vhost_reset_status;
> +    vhost_supports_migratory_state_op vhost_supports_migratory_state;
> +    vhost_set_device_state_fd_op vhost_set_device_state_fd;
> +    vhost_check_device_state_op vhost_check_device_state;
>   } VhostOps;
>   
>   int vhost_backend_update_device_iotlb(struct vhost_dev *dev,
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 69bf59d630..d8877496e5 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -346,4 +346,83 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
>   int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
>                              struct vhost_inflight *inflight);
>   bool vhost_dev_has_iommu(struct vhost_dev *dev);
> +
> +/**
> + * vhost_supports_migratory_state(): Checks whether the back-end
> + * supports transferring internal state for the purpose of migration.
> + * Support for this feature is required for vhost_set_device_state_fd()
> + * and vhost_check_device_state().
> + *
> + * @dev: The vhost device
> + *
> + * Returns true if the device supports these commands, and false if it
> + * does not.
> + */
> +bool vhost_supports_migratory_state(struct vhost_dev *dev);
> +
> +/**
> + * vhost_set_device_state_fd(): Begin transfer of internal state from/to
> + * the back-end for the purpose of migration.  Data is to be transferred
> + * over a pipe according to @direction and @phase.  The sending end must
> + * only write to the pipe, and the receiving end must only read from it.
> + * Once the sending end is done, it closes its FD.  The receiving end
> + * must take this as the end-of-transfer signal and close its FD, too.
> + *
> + * @fd is the back-end's end of the pipe: The write FD for SAVE, and the
> + * read FD for LOAD.  This function transfers ownership of @fd to the
> + * back-end, i.e. closes it in the front-end.
> + *
> + * The back-end may optionally reply with an FD of its own, if this
> + * improves efficiency on its end.  In this case, the returned FD is


Hi Hanna,

In what case/situation, the back-end will have a more efficient fd?

Here my understanding of this "FD of its own" is as same type as

the given fd(e.g. both pipe files), why the fd from back-end makes

difference? Do I miss anything here?


Regards,

Hao


> + * stored in *reply_fd.  The back-end will discard the FD sent to it,
> + * and the front-end must use *reply_fd for transferring state to/from
> + * the back-end.
> + *
> + * @dev: The vhost device
> + * @direction: The direction in which the state is to be transferred.
> + *             For outgoing migrations, this is SAVE, and data is read
> + *             from the back-end and stored by the front-end in the
> + *             migration stream.
> + *             For incoming migrations, this is LOAD, and data is read
> + *             by the front-end from the migration stream and sent to
> + *             the back-end to restore the saved state.
> + * @phase: Which migration phase we are in.  Currently, there is only
> + *         STOPPED (device and all vrings are stopped), in the future,
> + *         more phases such as PRE_COPY or POST_COPY may be added.
> + * @fd: Back-end's end of the pipe through which to transfer state; note
> + *      that ownership is transferred to the back-end, so this function
> + *      closes @fd in the front-end.
> + * @reply_fd: If the back-end wishes to use a different pipe for state
> + *            transfer, this will contain an FD for the front-end to
> + *            use.  Otherwise, -1 is stored here.
> + * @errp: Potential error description
> + *
> + * Returns 0 on success, and -errno on failure.
> + */
> +int vhost_set_device_state_fd(struct vhost_dev *dev,
> +                              VhostDeviceStateDirection direction,
> +                              VhostDeviceStatePhase phase,
> +                              int fd,
> +                              int *reply_fd,
> +                              Error **errp);
> +
> +/**
> + * vhost_set_device_state_fd(): After transferring state from/to the
> + * back-end via vhost_set_device_state_fd(), i.e. once the sending end
> + * has closed the pipe, inquire the back-end to report any potential
> + * errors that have occurred on its side.  This allows to sense errors
> + * like:
> + * - During outgoing migration, when the source side had already started
> + *   to produce its state, something went wrong and it failed to finish
> + * - During incoming migration, when the received state is somehow
> + *   invalid and cannot be processed by the back-end
> + *
> + * @dev: The vhost device
> + * @errp: Potential error description
> + *
> + * Returns 0 when the back-end reports successful state transfer and
> + * processing, and -errno when an error occurred somewhere.
> + */
> +int vhost_check_device_state(struct vhost_dev *dev, Error **errp);
> +
>   #endif
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index 53a881ec2a..8e6b5485e8 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -76,6 +76,7 @@ enum VhostUserProtocolFeature {
>       VHOST_USER_PROTOCOL_F_STATUS = 16,
>       /* Feature 17 reserved for VHOST_USER_PROTOCOL_F_XEN_MMAP. */
>       VHOST_USER_PROTOCOL_F_SUSPEND = 18,
> +    VHOST_USER_PROTOCOL_F_MIGRATORY_STATE = 19,
>       VHOST_USER_PROTOCOL_F_MAX
>   };
>   
> @@ -125,6 +126,8 @@ typedef enum VhostUserRequest {
>       VHOST_USER_GET_STATUS = 40,
>       VHOST_USER_SUSPEND = 41,
>       VHOST_USER_RESUME = 42,
> +    VHOST_USER_SET_DEVICE_STATE_FD = 43,
> +    VHOST_USER_CHECK_DEVICE_STATE = 44,
>       VHOST_USER_MAX
>   } VhostUserRequest;
>   
> @@ -216,6 +219,12 @@ typedef struct {
>       uint32_t size; /* the following payload size */
>   } QEMU_PACKED VhostUserHeader;
>   
> +/* Request payload of VHOST_USER_SET_DEVICE_STATE_FD */
> +typedef struct VhostUserTransferDeviceState {
> +    uint32_t direction;
> +    uint32_t phase;
> +} VhostUserTransferDeviceState;
> +
>   typedef union {
>   #define VHOST_USER_VRING_IDX_MASK   (0xff)
>   #define VHOST_USER_VRING_NOFD_MASK  (0x1 << 8)
> @@ -230,6 +239,7 @@ typedef union {
>           VhostUserCryptoSession session;
>           VhostUserVringArea area;
>           VhostUserInflight inflight;
> +        VhostUserTransferDeviceState transfer_state;
>   } VhostUserPayload;
>   
>   typedef struct VhostUserMsg {
> @@ -2838,6 +2848,140 @@ static void vhost_user_reset_status(struct vhost_dev *dev)
>       }
>   }
>   
> +static bool vhost_user_supports_migratory_state(struct vhost_dev *dev)
> +{
> +    return virtio_has_feature(dev->protocol_features,
> +                              VHOST_USER_PROTOCOL_F_MIGRATORY_STATE);
> +}
> +
> +static int vhost_user_set_device_state_fd(struct vhost_dev *dev,
> +                                          VhostDeviceStateDirection direction,
> +                                          VhostDeviceStatePhase phase,
> +                                          int fd,
> +                                          int *reply_fd,
> +                                          Error **errp)
> +{
> +    int ret;
> +    struct vhost_user *vu = dev->opaque;
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_SET_DEVICE_STATE_FD,
> +            .flags = VHOST_USER_VERSION,
> +            .size = sizeof(msg.payload.transfer_state),
> +        },
> +        .payload.transfer_state = {
> +            .direction = direction,
> +            .phase = phase,
> +        },
> +    };
> +
> +    *reply_fd = -1;
> +
> +    if (!vhost_user_supports_migratory_state(dev)) {
> +        close(fd);
> +        error_setg(errp, "Back-end does not support migration state transfer");
> +        return -ENOTSUP;
> +    }
> +
> +    ret = vhost_user_write(dev, &msg, &fd, 1);
> +    close(fd);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to send SET_DEVICE_STATE_FD message");
> +        return ret;
> +    }
> +
> +    ret = vhost_user_read(dev, &msg);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to receive SET_DEVICE_STATE_FD reply");
> +        return ret;
> +    }
> +
> +    if (msg.hdr.request != VHOST_USER_SET_DEVICE_STATE_FD) {
> +        error_setg(errp,
> +                   "Received unexpected message type, expected %d, received %d",
> +                   VHOST_USER_SET_DEVICE_STATE_FD, msg.hdr.request);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.hdr.size != sizeof(msg.payload.u64)) {
> +        error_setg(errp,
> +                   "Received bad message size, expected %zu, received %" PRIu32,
> +                   sizeof(msg.payload.u64), msg.hdr.size);
> +        return -EPROTO;
> +    }
> +
> +    if ((msg.payload.u64 & 0xff) != 0) {
> +        error_setg(errp, "Back-end did not accept migration state transfer");
> +        return -EIO;
> +    }
> +
> +    if (!(msg.payload.u64 & VHOST_USER_VRING_NOFD_MASK)) {
> +        *reply_fd = qemu_chr_fe_get_msgfd(vu->user->chr);
> +        if (*reply_fd < 0) {
> +            error_setg(errp,
> +                       "Failed to get back-end-provided transfer pipe FD");
> +            *reply_fd = -1;
> +            return -EIO;
> +        }
> +    }
> +
> +    return 0;
> +}
> +
> +static int vhost_user_check_device_state(struct vhost_dev *dev, Error **errp)
> +{
> +    int ret;
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_CHECK_DEVICE_STATE,
> +            .flags = VHOST_USER_VERSION,
> +            .size = 0,
> +        },
> +    };
> +
> +    if (!vhost_user_supports_migratory_state(dev)) {
> +        error_setg(errp, "Back-end does not support migration state transfer");
> +        return -ENOTSUP;
> +    }
> +
> +    ret = vhost_user_write(dev, &msg, NULL, 0);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to send CHECK_DEVICE_STATE message");
> +        return ret;
> +    }
> +
> +    ret = vhost_user_read(dev, &msg);
> +    if (ret < 0) {
> +        error_setg_errno(errp, -ret,
> +                         "Failed to receive CHECK_DEVICE_STATE reply");
> +        return ret;
> +    }
> +
> +    if (msg.hdr.request != VHOST_USER_CHECK_DEVICE_STATE) {
> +        error_setg(errp,
> +                   "Received unexpected message type, expected %d, received %d",
> +                   VHOST_USER_CHECK_DEVICE_STATE, msg.hdr.request);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.hdr.size != sizeof(msg.payload.u64)) {
> +        error_setg(errp,
> +                   "Received bad message size, expected %zu, received %" PRIu32,
> +                   sizeof(msg.payload.u64), msg.hdr.size);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.payload.u64 != 0) {
> +        error_setg(errp, "Back-end failed to process its internal state");
> +        return -EIO;
> +    }
> +
> +    return 0;
> +}
> +
>   const VhostOps user_ops = {
>           .backend_type = VHOST_BACKEND_TYPE_USER,
>           .vhost_backend_init = vhost_user_backend_init,
> @@ -2874,4 +3018,7 @@ const VhostOps user_ops = {
>           .vhost_set_inflight_fd = vhost_user_set_inflight_fd,
>           .vhost_dev_start = vhost_user_dev_start,
>           .vhost_reset_status = vhost_user_reset_status,
> +        .vhost_supports_migratory_state = vhost_user_supports_migratory_state,
> +        .vhost_set_device_state_fd = vhost_user_set_device_state_fd,
> +        .vhost_check_device_state = vhost_user_check_device_state,
>   };
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 2e28e58da7..756b6d55a8 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2091,3 +2091,40 @@ int vhost_net_set_backend(struct vhost_dev *hdev,
>   
>       return -ENOSYS;
>   }
> +
> +bool vhost_supports_migratory_state(struct vhost_dev *dev)
> +{
> +    if (dev->vhost_ops->vhost_supports_migratory_state) {
> +        return dev->vhost_ops->vhost_supports_migratory_state(dev);
> +    }
> +
> +    return false;
> +}
> +
> +int vhost_set_device_state_fd(struct vhost_dev *dev,
> +                              VhostDeviceStateDirection direction,
> +                              VhostDeviceStatePhase phase,
> +                              int fd,
> +                              int *reply_fd,
> +                              Error **errp)
> +{
> +    if (dev->vhost_ops->vhost_set_device_state_fd) {
> +        return dev->vhost_ops->vhost_set_device_state_fd(dev, direction, phase,
> +                                                         fd, reply_fd, errp);
> +    }
> +
> +    error_setg(errp,
> +               "vhost transport does not support migration state transfer");
> +    return -ENOSYS;
> +}
> +
> +int vhost_check_device_state(struct vhost_dev *dev, Error **errp)
> +{
> +    if (dev->vhost_ops->vhost_check_device_state) {
> +        return dev->vhost_ops->vhost_check_device_state(dev, errp);
> +    }
> +
> +    error_setg(errp,
> +               "vhost transport does not support migration state transfer");
> +    return -ENOSYS;
> +}

