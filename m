Date: Fri, 9 Apr 2021 11:56:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Message-ID: <20210409155657.GE1111800@redhat.com>
References: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210408195534.647895-1-antonkuchin@yandex-team.ru>
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: fix features handling
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Anton Kuchin <antonkuchin@yandex-team.ru>
Cc: virtio-fs@redhat.com, qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>

On Thu, Apr 08, 2021 at 10:55:34PM +0300, Anton Kuchin wrote:
> Make virtio-fs take into account server capabilities.
> 
> Just returning requested features assumes they all of then are implemented
> by server and results in setting unsupported configuration if some of them
> are absent.
> 
> Signed-off-by: Anton Kuchin <antonkuchin@yandex-team.ru>

[CC stefan and qemu-devel.]

Can you give more details of what problem exactly you are facing. Or
this fix is about avoiding a future problem where device can refuse
to support a feature qemu is requesting for.

IIUC, this patch is preparing a list of features vhost-user-fs device
can support. Then it calls vhost_get_features() which makes sure that
all these features are support by real vhost-user device (hdev->features).
If not, then corresponding feature is reset and remaining features
are returned to caller.

This feature negotion bit is called in so many places that I am kind of
lost that who should be doing what. Will leave it to Stefan who
understands it much better.


> ---
>  hw/virtio/vhost-user-fs.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index ac4fc34b36..6cf983ba0e 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -24,6 +24,14 @@
>  #include "monitor/monitor.h"
>  #include "sysemu/sysemu.h"
>  
> +static const int user_feature_bits[] = {
> +    VIRTIO_F_VERSION_1,
> +    VIRTIO_RING_F_INDIRECT_DESC,
> +    VIRTIO_RING_F_EVENT_IDX,
> +    VIRTIO_F_NOTIFY_ON_EMPTY,
> +    VHOST_INVALID_FEATURE_BIT
> +};
> +
>  static void vuf_get_config(VirtIODevice *vdev, uint8_t *config)
>  {
>      VHostUserFS *fs = VHOST_USER_FS(vdev);
> @@ -129,11 +137,12 @@ static void vuf_set_status(VirtIODevice *vdev, uint8_t status)
>  }
>  
>  static uint64_t vuf_get_features(VirtIODevice *vdev,
> -                                      uint64_t requested_features,
> -                                      Error **errp)
> +                                 uint64_t features,

Will it make sense to keep the name requested_features. This kind of
makes it clear that caller is requesting these features.

I feel there should be few lines of comments also to make it clear
what this function is actually doing.

Vivek

> +                                 Error **errp)
>  {
> -    /* No feature bits used yet */
> -    return requested_features;
> +    VHostUserFS *fs = VHOST_USER_FS(vdev);
> +
> +    return vhost_get_features(&fs->vhost_dev, user_feature_bits, features);
>  }
>  
>  static void vuf_handle_output(VirtIODevice *vdev, VirtQueue *vq)
> -- 
> 2.25.1
> 
> 
> _______________________________________________
> Virtio-fs mailing list
> Virtio-fs@redhat.com
> https://listman.redhat.com/mailman/listinfo/virtio-fs

