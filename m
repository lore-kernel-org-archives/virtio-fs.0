References: <20210930153037.1194279-1-vgoyal@redhat.com>
	<20210930153037.1194279-7-vgoyal@redhat.com>
From: Christophe de Dinechin <dinechin@redhat.com>
Date: Wed, 06 Oct 2021 15:35:30 +0200
In-reply-to: <20210930153037.1194279-7-vgoyal@redhat.com>
Message-ID: <lywnmqi89e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [Virtio-fs] [PATCH 06/13] vhost-user-fs: Use helpers to
 create/cleanup virtqueue
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, miklos@szeredi.hu


On 2021-09-30 at 11:30 -04, Vivek Goyal <vgoyal@redhat.com> wrote...
> Add helpers to create/cleanup virtuqueues and use those helpers. I will

Typo, virtuqueues -> virtqueues

Also, while I'm nitpicking, virtqueue could be plural in commit description ;-)

> need to reconfigure queues in later patches and using helpers will allow
> reusing the code.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  hw/virtio/vhost-user-fs.c | 87 +++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 35 deletions(-)
>
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index c595957983..d1efbc5b18 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -139,6 +139,55 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
>      }
>  }
>
> +static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> +{
> +    /*
> +     * Not normally called; it's the daemon that handles the queue;
> +     * however virtio's cleanup path can call this.
> +     */
> +}
> +
> +static void vuf_create_vqs(VirtIODevice *vdev)
> +{
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +    unsigned int i;
> +
> +    /* Hiprio queue */
> +    fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size,
> +                                     vuf_handle_output);
> +
> +    /* Request queues */
> +    fs->req_vqs = g_new(VirtQueue *, fs->conf.num_request_queues);
> +    for (i = 0; i < fs->conf.num_request_queues; i++) {
> +        fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size,
> +                                          vuf_handle_output);
> +    }
> +
> +    /* 1 high prio queue, plus the number configured */
> +    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
> +    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
> +}
> +
> +static void vuf_cleanup_vqs(VirtIODevice *vdev)
> +{
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +    unsigned int i;
> +
> +    virtio_delete_queue(fs->hiprio_vq);
> +    fs->hiprio_vq = NULL;
> +
> +    for (i = 0; i < fs->conf.num_request_queues; i++) {
> +        virtio_delete_queue(fs->req_vqs[i]);
> +    }
> +
> +    g_free(fs->req_vqs);
> +    fs->req_vqs = NULL;
> +
> +    fs->vhost_dev.nvqs = 0;
> +    g_free(fs->vhost_dev.vqs);
> +    fs->vhost_dev.vqs = NULL;
> +}
> +
>  static uint64_t vuf_get_features(VirtIODevice *vdev,
>                                   uint64_t features,
>                                   Error **errp)
> @@ -148,14 +197,6 @@ static uint64_t vuf_get_features(VirtIODevice *vdev,
>      return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
>  }
>
> -static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> -{
> -    /*
> -     * Not normally called; it's the daemon that handles the queue;
> -     * however virtio's cleanup path can call this.
> -     */
> -}
> -
>  static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
>                                              bool mask)
>  {
> @@ -175,7 +216,6 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
>  {
>      VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>      VHostUserFS *fs = VHOST_USER_FS(dev);
> -    unsigned int i;
>      size_t len;
>      int ret;
>
> @@ -222,18 +262,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
>      virtio_init(vdev, "vhost-user-fs", VIRTIO_ID_FS,
>                  sizeof(struct virtio_fs_config));
>
> -    /* Hiprio queue */
> -    fs->hiprio_vq = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
> -
> -    /* Request queues */
> -    fs->req_vqs = g_new(VirtQueue *, fs->conf.num_request_queues);
> -    for (i = 0; i < fs->conf.num_request_queues; i++) {
> -        fs->req_vqs[i] = virtio_add_queue(vdev, fs->conf.queue_size, vuf_handle_output);
> -    }
> -
> -    /* 1 high prio queue, plus the number configured */
> -    fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
> -    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
> +    vuf_create_vqs(vdev);
>      ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
>                           VHOST_BACKEND_TYPE_USER, 0, errp);
>      if (ret < 0) {
> @@ -244,13 +273,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
>
>  err_virtio:
>      vhost_user_cleanup(&fs->vhost_user);
> -    virtio_delete_queue(fs->hiprio_vq);
> -    for (i = 0; i < fs->conf.num_request_queues; i++) {
> -        virtio_delete_queue(fs->req_vqs[i]);
> -    }
> -    g_free(fs->req_vqs);
> +    vuf_cleanup_vqs(vdev);
>      virtio_cleanup(vdev);
> -    g_free(fs->vhost_dev.vqs);
>      return;
>  }
>
> @@ -258,7 +282,6 @@ static void vuf_device_unrealize(DeviceState *dev)
>  {
>      VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>      VHostUserFS *fs = VHOST_USER_FS(dev);
> -    int i;
>
>      /* This will stop vhost backend if appropriate. */
>      vuf_set_status(vdev, 0);
> @@ -267,14 +290,8 @@ static void vuf_device_unrealize(DeviceState *dev)
>
>      vhost_user_cleanup(&fs->vhost_user);
>
> -    virtio_delete_queue(fs->hiprio_vq);
> -    for (i = 0; i < fs->conf.num_request_queues; i++) {
> -        virtio_delete_queue(fs->req_vqs[i]);
> -    }
> -    g_free(fs->req_vqs);
> +    vuf_cleanup_vqs(vdev);
>      virtio_cleanup(vdev);
> -    g_free(fs->vhost_dev.vqs);
> -    fs->vhost_dev.vqs = NULL;
>  }
>
>  static const VMStateDescription vuf_vmstate = {


--
Cheers,
Christophe de Dinechin (IRC c3d)

