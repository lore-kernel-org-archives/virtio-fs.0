Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=9Rp4pXqrqBxqrjyT8Er3156X38qoB0KtAgmbhPvuofE=; b=J35jEi9v9XhkDbV0xVPG/J8bjx
 6XWNt7xZaVS1l9KRwa9ZzjlfbD5SiSPdTM9lAoRSgekc0DetN2tu43UTg3hNf4PhQLeh2X3aTgyzv
 eAJ8KfDfdeiplXD9dhQIB6cLHaqC6Y353n8G2aNRzsIF/hAPX60u9EuMiFSXPCa8FrIGuwT6nduSm
 7Gr7yfM6PcNUvN7oYjhPuUwOx/KFYoS6Lcn8pme7i3kyEGSJvao9WyxV1QGOgvTcRx51DQ0HjiANz
 iUi8WP+ek7gdHB+PFgLhRRiq2aznM7uWlZhS7p+3M+qAx3NWZPaO1OCPsEeefCJUMXExVNgwe8HTI
 x4VFEztO7SbZs6EEzCUECEjv5obtoJd8U3770qc+JDTyuRgpwZvREhyczoiBAThypZ/NqcRzSqbWm
 CWp2VYn3uyzek9HHYbP6+d1D4BWMd9OaappH471ypB9ampndNKg51VAZLqrkNNXaSut4ViY/oScdQ
 I/HuZNlk1SNWDEfuPplR6H0deNF/Mce+2Qw1w43dlLb7TJKWqBcnu9TH2jJKl7QUIrVQs5ubHgg2J
 kAXHYQeLhfLjUOlJvPoh4IU60Qvk+6pLpY1mTLNFSu1JXgpfmwAcewRZbXpIaIj9S/yTzWcYEzywI
 Vqkg8G9IMZdACkEwXSLgZOp5BA3NNd8+7hBVRF5Vk=
Message-ID: <55bf17e5-9875-f193-e1d7-ee688333bc78@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:25:24 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-4-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-4-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 03/13] hw/virtio: fix typo in
 VIRTIO_CONFIG_IRQ_IDX comments
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Jason Wang <jasowang@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, virtio-fs@redhat.com, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>

On 18/04/2023 17:21, Alex Bennée wrote:

> Fixes: 544f0278af (virtio: introduce macro VIRTIO_CONFIG_IRQ_IDX)
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   hw/display/vhost-user-gpu.c    | 4 ++--
>   hw/net/virtio-net.c            | 4 ++--
>   hw/virtio/vhost-user-fs.c      | 4 ++--
>   hw/virtio/vhost-user-gpio.c    | 2 +-
>   hw/virtio/vhost-vsock-common.c | 4 ++--
>   hw/virtio/virtio-crypto.c      | 4 ++--
>   6 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/display/vhost-user-gpu.c b/hw/display/vhost-user-gpu.c
> index 71dfd956b8..7c61a7c3ac 100644
> --- a/hw/display/vhost-user-gpu.c
> +++ b/hw/display/vhost-user-gpu.c
> @@ -489,7 +489,7 @@ vhost_user_gpu_guest_notifier_pending(VirtIODevice *vdev, int idx)
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> @@ -506,7 +506,7 @@ vhost_user_gpu_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> diff --git a/hw/net/virtio-net.c b/hw/net/virtio-net.c
> index 53e1c32643..c53616a080 100644
> --- a/hw/net/virtio-net.c
> +++ b/hw/net/virtio-net.c
> @@ -3359,7 +3359,7 @@ static bool virtio_net_guest_notifier_pending(VirtIODevice *vdev, int idx)
>       }
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return false
>        */
>   
> @@ -3391,7 +3391,7 @@ static void virtio_net_guest_notifier_mask(VirtIODevice *vdev, int idx,
>       }
>       /*
>        *Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 83fc20e49e..49d699ffc2 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -161,7 +161,7 @@ static void vuf_guest_notifier_mask(VirtIODevice *vdev, int idx,
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> @@ -177,7 +177,7 @@ static bool vuf_guest_notifier_pending(VirtIODevice *vdev, int idx)
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> diff --git a/hw/virtio/vhost-user-gpio.c b/hw/virtio/vhost-user-gpio.c
> index d6927b610a..3b013f2d0f 100644
> --- a/hw/virtio/vhost-user-gpio.c
> +++ b/hw/virtio/vhost-user-gpio.c
> @@ -194,7 +194,7 @@ static void vu_gpio_guest_notifier_mask(VirtIODevice *vdev, int idx, bool mask)
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-common.c
> index d2b5519d5a..623bdf91cc 100644
> --- a/hw/virtio/vhost-vsock-common.c
> +++ b/hw/virtio/vhost-vsock-common.c
> @@ -129,7 +129,7 @@ static void vhost_vsock_common_guest_notifier_mask(VirtIODevice *vdev, int idx,
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> @@ -146,7 +146,7 @@ static bool vhost_vsock_common_guest_notifier_pending(VirtIODevice *vdev,
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> diff --git a/hw/virtio/virtio-crypto.c b/hw/virtio/virtio-crypto.c
> index 802e1b9659..6b3e607329 100644
> --- a/hw/virtio/virtio-crypto.c
> +++ b/hw/virtio/virtio-crypto.c
> @@ -1208,7 +1208,7 @@ static void virtio_crypto_guest_notifier_mask(VirtIODevice *vdev, int idx,
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */
>   
> @@ -1227,7 +1227,7 @@ static bool virtio_crypto_guest_notifier_pending(VirtIODevice *vdev, int idx)
>   
>       /*
>        * Add the check for configure interrupt, Use VIRTIO_CONFIG_IRQ_IDX -1
> -     * as the Marco of configure interrupt's IDX, If this driver does not
> +     * as the macro of configure interrupt's IDX, If this driver does not
>        * support, the function will return
>        */

Reviewed-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>


ATB,

Mark.

