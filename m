Return-Path: <antonkuchin@yandex-team.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
 s=default; 
 t=1679074768; bh=I/GHiPsXRoRGgF9IphXwCY8oTFvQrDo7RnVQXZzJn3A=;
 h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
 b=OCMoEw10WVv6ixHsVznesFSo9tUtojo7YJYD2qLslZa/Q/RCM1rzvWEXavQJLMss+
 kuPrwnPYmQdL+mgR5wakpbnbCuL4ueplBGiVgBkuL64jT/Kssm1BPrapT/P03RGQiD
 lEc509NxNF4xRE3FkendKf2BhmxFvcLukTIDBQeo=
Message-ID: <8dc9cba8-b6fa-f0e7-8ec8-3d4152ad7a5e@yandex-team.ru>
Date: Fri, 17 Mar 2023 19:39:24 +0200
MIME-Version: 1.0
References: <20230313174833.28790-1-hreitz@redhat.com>
 <20230313174833.28790-2-hreitz@redhat.com>
From: Anton Kuchin <antonkuchin@yandex-team.ru>
In-Reply-To: <20230313174833.28790-2-hreitz@redhat.com>
Content-Language: en-US, ru-RU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [Virtio-fs] [RFC 1/2] vhost-user: Add interface for virtio-fs
 migration
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@redhat.com, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, Juan Quintela <quintela@redhat.com>

On 13/03/2023 19:48, Hanna Czenczek wrote:
> Add a virtio-fs-specific vhost-user interface to facilitate migrating
> back-end-internal state.  We plan to migrate the internal state simply
> as a binary blob after the streaming phase, so all we need is a way to
> transfer such a blob from and to the back-end.  We do so by using a
> dedicated area of shared memory through which the blob is transferred in
> chunks.
>
> This patch adds the following vhost operations (and implements them for
> vhost-user):
>
> - FS_SET_STATE_FD: The front-end passes a dedicated shared memory area
>    to the back-end.  This area will be used to transfer state via the
>    other two operations.
>    (After the transfer FS_SET_STATE_FD detaches the shared memory area
>    again.)
>
> - FS_GET_STATE: The front-end asks the back-end to place a chunk of
>    internal state into the shared memory area.
>
> - FS_SET_STATE: The front-end puts a chunk of internal state into the
>    shared memory area, and asks the back-end to fetch it.
>
> On the source side, the back-end is expected to serialize its internal
> state either when FS_SET_STATE_FD is invoked, or when FS_GET_STATE is
> invoked the first time.  On subsequent FS_GET_STATE calls, it memcpy()s
> parts of that serialized state into the shared memory area.
>
> On the destination side, the back-end is expected to collect the state
> blob over all FS_SET_STATE calls, and then deserialize and apply it once
> FS_SET_STATE_FD detaches the shared memory area.
>
> Signed-off-by: Hanna Czenczek <hreitz@redhat.com>
> ---
>   include/hw/virtio/vhost-backend.h |   9 ++
>   include/hw/virtio/vhost.h         |  68 +++++++++++++++
>   hw/virtio/vhost-user.c            | 138 ++++++++++++++++++++++++++++++
>   hw/virtio/vhost.c                 |  29 +++++++
>   4 files changed, 244 insertions(+)
>
> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-backend.h
> index ec3fbae58d..fa3bd19386 100644
> --- a/include/hw/virtio/vhost-backend.h
> +++ b/include/hw/virtio/vhost-backend.h
> @@ -42,6 +42,12 @@ typedef int (*vhost_backend_init)(struct vhost_dev *dev, void *opaque,
>   typedef int (*vhost_backend_cleanup)(struct vhost_dev *dev);
>   typedef int (*vhost_backend_memslots_limit)(struct vhost_dev *dev);
>   
> +typedef ssize_t (*vhost_fs_get_state_op)(struct vhost_dev *dev,
> +                                         uint64_t state_offset, size_t size);
> +typedef int (*vhost_fs_set_state_op)(struct vhost_dev *dev,
> +                                     uint64_t state_offset, size_t size);
> +typedef int (*vhost_fs_set_state_fd_op)(struct vhost_dev *dev, int memfd,
> +                                        size_t size);
>   typedef int (*vhost_net_set_backend_op)(struct vhost_dev *dev,
>                                   struct vhost_vring_file *file);
>   typedef int (*vhost_net_set_mtu_op)(struct vhost_dev *dev, uint16_t mtu);
> @@ -138,6 +144,9 @@ typedef struct VhostOps {
>       vhost_backend_init vhost_backend_init;
>       vhost_backend_cleanup vhost_backend_cleanup;
>       vhost_backend_memslots_limit vhost_backend_memslots_limit;
> +    vhost_fs_get_state_op vhost_fs_get_state;
> +    vhost_fs_set_state_op vhost_fs_set_state;
> +    vhost_fs_set_state_fd_op vhost_fs_set_state_fd;
>       vhost_net_set_backend_op vhost_net_set_backend;
>       vhost_net_set_mtu_op vhost_net_set_mtu;
>       vhost_scsi_set_endpoint_op vhost_scsi_set_endpoint;
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index a52f273347..b1ad9785dd 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -336,4 +336,72 @@ int vhost_dev_set_inflight(struct vhost_dev *dev,
>                              struct vhost_inflight *inflight);
>   int vhost_dev_get_inflight(struct vhost_dev *dev, uint16_t queue_size,
>                              struct vhost_inflight *inflight);
> +
> +/**
> + * vhost_fs_set_state_fd(): Share memory with a virtio-fs vhost
> + * back-end for transferring internal state for the purpose of
> + * migration.  Calling this function again will have the back-end
> + * unregister (free) the previously shared memory area.
> + *
> + * @dev: The vhost device
> + * @memfd: File descriptor associated with the shared memory to share.
> + *         If negative, no memory area is shared, only releasing the
> + *         previously shared area, and announcing the end of transfer
> + *         (which, on the destination side, should lead to the
> + *         back-end deserializing and applying the received state).
> + * @size: Size of the shared memory area
> + *
> + * Returns 0 on success, and -errno on failure.
> + */
> +int vhost_fs_set_state_fd(struct vhost_dev *dev, int memfd, size_t size);
> +
> +/**
> + * vhost_fs_get_state(): Request the virtio-fs vhost back-end to place
> + * a chunk of migration state into the shared memory area negotiated
> + * through vhost_fs_set_state_fd().  May only be used for migration,
> + * and only by the source side.
> + *
> + * The back-end-internal migration state is treated as a binary blob,
> + * which is transferred in chunks to fit into the shared memory area.
> + *
> + * @dev: The vhost device
> + * @state_offset: Offset into the state blob of the first byte to be
> + *                transferred
> + * @size: Number of bytes to transfer at most; must not exceed the
> + *        size of the shared memory area
> + *
> + * On success, returns the number of bytes that remain in the full
> + * state blob from the beginning of this chunk (i.e. the full size of
> + * the blob, minus @state_offset).  When transferring the final chunk,
> + * this may be less than @size.  The shared memory will contain the
> + * requested data, starting at offset 0 into the SHM, and counting
> + * `MIN(@size, returned value)` bytes.
> + *
> + * On failure, returns -errno.
> + */
> +ssize_t vhost_fs_get_state(struct vhost_dev *dev, uint64_t state_offset,
> +                           uint64_t size);
> +
> +/**
> + * vhost_fs_set_state(): Request the virtio-fs vhost back-end to fetch
> + * a chunk of migration state from the shared memory area negotiated
> + * through vhost_fs_set_state_fd().  May only be used for migration,
> + * and only by the destination side.
> + *
> + * The back-end-internal migration state is treated as a binary blob,
> + * which is transferred in chunks to fit into the shared memory area.
> + *
> + * The front-end (i.e. the caller) must transfer the whole state to
> + * the back-end, without holes.
> + *
> + * @vdev: the VirtIODevice structure
> + * @state_offset: Offset into the state blob of the first byte to be
> + *                transferred
> + * @size: Length of the chunk to transfer; must not exceed the size of
> + *        the shared memory area
> + *
> + * Returns 0 on success, and -errno on failure.
> + */
> +int vhost_fs_set_state(struct vhost_dev *dev, uint64_t state_offset,
> +                       uint64_t size);
>   #endif
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index e5285df4ba..7fd1fb1ed3 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -130,6 +130,9 @@ typedef enum VhostUserRequest {
>       VHOST_USER_REM_MEM_REG = 38,
>       VHOST_USER_SET_STATUS = 39,
>       VHOST_USER_GET_STATUS = 40,
> +    VHOST_USER_FS_SET_STATE_FD = 41,
> +    VHOST_USER_FS_GET_STATE = 42,
> +    VHOST_USER_FS_SET_STATE = 43,
>       VHOST_USER_MAX
>   } VhostUserRequest;
>   
> @@ -210,6 +213,15 @@ typedef struct {
>       uint32_t size; /* the following payload size */
>   } QEMU_PACKED VhostUserHeader;
>   
> +/*
> + * Request and reply payloads of VHOST_USER_FS_GET_STATE, and request
> + * payload of VHOST_USER_FS_SET_STATE.
> + */
> +typedef struct VhostUserFsState {
> +    uint64_t state_offset;
> +    uint64_t size;
> +} VhostUserFsState;
> +
>   typedef union {
>   #define VHOST_USER_VRING_IDX_MASK   (0xff)
>   #define VHOST_USER_VRING_NOFD_MASK  (0x1 << 8)
> @@ -224,6 +236,7 @@ typedef union {
>           VhostUserCryptoSession session;
>           VhostUserVringArea area;
>           VhostUserInflight inflight;
> +        VhostUserFsState fs_state;
>   } VhostUserPayload;
>   
>   typedef struct VhostUserMsg {
> @@ -2240,6 +2253,128 @@ static int vhost_user_net_set_mtu(struct vhost_dev *dev, uint16_t mtu)
>       return 0;
>   }
>   
> +static int vhost_user_fs_set_state_fd(struct vhost_dev *dev, int memfd,
> +                                      size_t size)
> +{
> +    int ret;
> +    bool reply_supported = virtio_has_feature(dev->protocol_features,
> +                                              VHOST_USER_PROTOCOL_F_REPLY_ACK);
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_FS_SET_STATE_FD,
> +            .flags = VHOST_USER_VERSION,
> +            .size = sizeof(msg.payload.u64),
> +        },
> +        .payload.u64 = size,
> +    };
> +
> +    if (reply_supported) {
> +        msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
> +    }
> +
> +    if (memfd < 0) {
> +        assert(size == 0);
> +        ret = vhost_user_write(dev, &msg, NULL, 0);
> +    } else {
> +        ret = vhost_user_write(dev, &msg, &memfd, 1);
> +    }
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (reply_supported) {
> +        return process_message_reply(dev, &msg);
> +    }
> +
> +    return 0;
> +}
> +
> +static ssize_t vhost_user_fs_get_state(struct vhost_dev *dev,
> +                                       uint64_t state_offset,
> +                                       size_t size)
> +{

Am I right to assume that vrings are supposed to be stopped to get/set 
state?
If I am shouldn't we check it before sending message or do you believe it is
better to return error from backend in these cases?

> +    int ret;
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_FS_GET_STATE,
> +            .flags = VHOST_USER_VERSION,
> +            .size = sizeof(msg.payload.fs_state),
> +        },
> +        .payload.fs_state = {
> +            .state_offset = state_offset,
> +            .size = size,
> +        },
> +    };
> +
> +    ret = vhost_user_write(dev, &msg, NULL, 0);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    ret = vhost_user_read(dev, &msg);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (msg.hdr.request != VHOST_USER_FS_GET_STATE) {
> +        error_report("Received unexpected message type: "
> +                     "Expected %d, received %d",
> +                     VHOST_USER_FS_GET_STATE, msg.hdr.request);
> +        return -EPROTO;
> +    }
> +
> +    if (msg.hdr.size != sizeof(VhostUserFsState)) {
> +        error_report("Received unexpected message length: "
> +                     "Expected %" PRIu32 ", received %zu",
> +                     msg.hdr.size, sizeof(VhostUserFsState));
> +        return -EPROTO;
> +    }
> +
> +    if (msg.payload.fs_state.size > SSIZE_MAX) {
> +        error_report("Remaining state size returned by back end is too high: "
> +                     "Expected up to %zd, reported %" PRIu64,
> +                     SSIZE_MAX, msg.payload.fs_state.size);
> +        return -EPROTO;
> +    }
> +
> +    return msg.payload.fs_state.size;
> +}
> +
> +static int vhost_user_fs_set_state(struct vhost_dev *dev,
> +                                   uint64_t state_offset,
> +                                   size_t size)
> +{
> +    int ret;
> +    bool reply_supported = virtio_has_feature(dev->protocol_features,
> +                                              VHOST_USER_PROTOCOL_F_REPLY_ACK);
> +    VhostUserMsg msg = {
> +        .hdr = {
> +            .request = VHOST_USER_FS_SET_STATE,
> +            .flags = VHOST_USER_VERSION,
> +            .size = sizeof(msg.payload.fs_state),
> +        },
> +        .payload.fs_state = {
> +            .state_offset = state_offset,
> +            .size = size,
> +        },
> +    };
> +
> +    if (reply_supported) {
> +        msg.hdr.flags |= VHOST_USER_NEED_REPLY_MASK;
> +    }
> +
> +    ret = vhost_user_write(dev, &msg, NULL, 0);
> +    if (ret < 0) {
> +        return ret;
> +    }
> +
> +    if (reply_supported) {
> +        return process_message_reply(dev, &msg);
> +    }
> +
> +    return 0;
> +}
> +
>   static int vhost_user_send_device_iotlb_msg(struct vhost_dev *dev,
>                                               struct vhost_iotlb_msg *imsg)
>   {
> @@ -2716,4 +2851,7 @@ const VhostOps user_ops = {
>           .vhost_get_inflight_fd = vhost_user_get_inflight_fd,
>           .vhost_set_inflight_fd = vhost_user_set_inflight_fd,
>           .vhost_dev_start = vhost_user_dev_start,
> +        .vhost_fs_set_state_fd = vhost_user_fs_set_state_fd,
> +        .vhost_fs_get_state = vhost_user_fs_get_state,
> +        .vhost_fs_set_state = vhost_user_fs_set_state,
>   };
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index a266396576..ef8252c90e 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -2075,3 +2075,32 @@ int vhost_net_set_backend(struct vhost_dev *hdev,
>   
>       return -ENOSYS;
>   }
> +
> +int vhost_fs_set_state_fd(struct vhost_dev *dev, int memfd, size_t size)
> +{
> +    if (dev->vhost_ops->vhost_fs_set_state_fd) {
> +        return dev->vhost_ops->vhost_fs_set_state_fd(dev, memfd, size);
> +    }
> +
> +    return -ENOSYS;
> +}
> +
> +ssize_t vhost_fs_get_state(struct vhost_dev *dev, uint64_t state_offset,
> +                           uint64_t size)
> +{
> +    if (dev->vhost_ops->vhost_fs_get_state) {
> +        return dev->vhost_ops->vhost_fs_get_state(dev, state_offset, size);
> +    }
> +
> +    return -ENOSYS;
> +}
> +
> +int vhost_fs_set_state(struct vhost_dev *dev, uint64_t state_offset,
> +                       uint64_t size)
> +{
> +    if (dev->vhost_ops->vhost_fs_set_state) {
> +        return dev->vhost_ops->vhost_fs_set_state(dev, state_offset, size);
> +    }
> +
> +    return -ENOSYS;
> +}

