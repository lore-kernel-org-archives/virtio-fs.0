Return-Path: <mst@redhat.com>
Date: Mon, 30 Jan 2023 14:09:57 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
Message-ID: <20230130140947-mutt-send-email-mst@kernel.org>
References: <20230130140225.77964-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
In-Reply-To: <20230130140225.77964-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Virtio-fs] [PATCH] vhost-user-fs: Back up vqs before cleaning
 up vhost_dev
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com, qemu-devel@nongnu.org

On Mon, Jan 30, 2023 at 11:02:25PM +0900, Akihiko Odaki wrote:
> vhost_dev_cleanup() clears vhost_dev so back up its vqs member to free
> the memory pointed by the member.
> 
> Fixes: 98fc1ada4c ("virtio: add vhost-user-fs base device")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  hw/virtio/vhost-user-fs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index f5049735ac..83fc20e49e 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -273,6 +273,7 @@ static void vuf_device_unrealize(DeviceState *dev)
>  {
>      VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>      VHostUserFS *fs = VHOST_USER_FS(dev);
> +    struct vhost_virtqueue *vhost_vqs = fs->vhost_dev.vqs;
>      int i;
>  
>      /* This will stop vhost backend if appropriate. */
> @@ -288,8 +289,7 @@ static void vuf_device_unrealize(DeviceState *dev)
>      }
>      g_free(fs->req_vqs);
>      virtio_cleanup(vdev);
> -    g_free(fs->vhost_dev.vqs);
> -    fs->vhost_dev.vqs = NULL;
> +    g_free(vhost_vqs);
>  }
>  
>  static struct vhost_dev *vuf_get_vhost(VirtIODevice *vdev)
> -- 
> 2.39.1

