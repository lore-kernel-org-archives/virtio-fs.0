Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=OaHt6vlahyHKBqr2IIc9kKlpuFMPo/c6t2yVwlwsNgc=; b=SZvnWMVD6IO2bTRzUgZ/4zvIdW
 vfHTO0tfwgYP6aVw7BdoUI77VIacUjQj/tR6CTsRwJdEWHi2RT+K5p4Q+dlao9+x4Rby7CcLvhXTu
 vf4BCcXPljs8rNeTvYz5Ku/FrFM5Ql+ka8cMJfWuXf7afMEy5HcYkipyygnfy8Ks8fiTpn5lPVhAy
 hbVASBvFrxrwRblaJGCLSw41sy+2D/glm2aCVq3lwNz425EhnoBwYPKRNFb1EDbraeN4vwG3YKsOo
 ryIZdqeBaBUpCP5K+PKKBtiefqKEBAA6k1QJKmJ8jkpsI08+inqV+piny/dr/zrV4R1fnacI0AK3v
 S/V5d70F2oWXRkAm52zLH2J6a2fSP41gIbebtBly2sE1xPvK1oMvbrHTIaWRTZ8EybwiWXeBDDfrE
 UR1QP3BBu6PW+v0XW8pcx3NTqdBT/ehHgcZeq8jPnQUnUdtS2g07ps1lsk1HCVTKq8mxORPdWyY1R
 Uz03EtJqxKgQ1SXxucRvq+0O4yazHs0amaT5dFTquygLiEChfXba4U6Gh05qtLRBJnkze4KInqj+y
 V2XKzejK8YCVBS1FNRKpj/9BIN8IuBejDytAzkzce9fzG14G0k0PoTE5dBim2LZNfSfX5d1jthBZG
 9Rk22Bh5K/4GR+QU5rGkuqm/zH2o+ufWLwyLog4HY=
Message-ID: <c17da9d6-2f47-cd7a-be9b-fa582429b59a@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:29:10 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-6-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-6-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 05/13] include/hw/virtio: add kerneldoc
 for virtio_init
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

> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/virtio/virtio.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 22ec098462..1ba7a9dd74 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -217,6 +217,12 @@ struct VirtioDeviceClass {
>   void virtio_instance_init_common(Object *proxy_obj, void *data,
>                                    size_t vdev_size, const char *vdev_name);
>   
> +/**
> + * virtio_init() - initialise the common VirtIODevice structure
> + * @vdev: pointer to VirtIODevice
> + * @device_id: the VirtIO device ID (see virtio_ids.h)
> + * @config_size: size of the config space
> + */
>   void virtio_init(VirtIODevice *vdev, uint16_t device_id, size_t config_size);
>   
>   void virtio_cleanup(VirtIODevice *vdev);

Reviewed-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>


ATB,

Mark.

