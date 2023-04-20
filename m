Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=VdToYCRQRWV2q04RDuIVArscNYAnaceS+1AH0D4hEgE=; b=dtURD7rfMPjaVx271BFe3NcHrz
 TLomN1ac/3V2Mh3V8G4Tvru9FfoJbVwLJUOOMKdoMZqVckDcbbwS1d8VQ7bjFVWd3llzM8FIdOntM
 OdOIXnSYSj6IzO61adI8W9uYzXOcpB7gII/0Yfbugib61epbBoP7IC5FU89VEXYte0IPtFCplFc9V
 gaACoxdW2IeVSL7tyw2gpaSAOuTTY/N1gHGFx/Ip80F7lRzRteBIT4ZK6OAbwl42nQGsuGsfNmlpO
 Tsux96h94VFA+VYf/h/2yhRTczh42zXrd7aMyJ1yERw+OkL4pfJopo6vyJEdta48tfemtACI4xMzO
 Sac3ijbbWEPv5sFhUtQMKXRXSmoNhZhR+RN5697Hkl8zMUB5995zLP+Waa657U2vQ7ClDv+FjgAxS
 qBAlcujNJnlBfPJhwm02zqyBk61oxQcGHg159kr/hyegzX8A1CMy1Q24WNN0GvEAr5DpThQZ68MyD
 viuMWvU/E7yGJzxzwUJ+QBVF9hiyPcKLM8Yv4Xe1HD+ZkBCJb8B2UyZ6/2YeHUR1RIVoGIN91YCqk
 yKvt0hsuOQVHqxV7J11+7RIlOU3PyI6OrAmdDebcGhZgYrKP+tDjNfhZqAfGuOHcBbFLhTV+vVxBE
 njwW3wJjFvc62WDvxpq2T2LiXGR82Gt82bWCnRaZA=
Message-ID: <3f9c31ae-5434-0d93-7f01-fe483491e58d@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:27:55 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-5-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-5-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 04/13] include/hw/virtio: document
 virtio_notify_config
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
>   include/hw/virtio/virtio.h | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index f236e94ca6..22ec098462 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -274,6 +274,13 @@ extern const VMStateInfo virtio_vmstate_info;
>   
>   int virtio_load(VirtIODevice *vdev, QEMUFile *f, int version_id);
>   
> +/**
> + * virtio_notify_config() - signal a change to device config
> + * @vdev: the virtio device
> + *
> + * Assuming the virtio device is up (VIRTIO_CONFIG_S_DRIVER_OK) this
> + * will trigger a guest interrupt and update the config version.
> + */
>   void virtio_notify_config(VirtIODevice *vdev);
>   
>   bool virtio_queue_get_notification(VirtQueue *vq);

I can't 100% vouch for the correctness of the description, however it makes sense to 
me so:

Acked-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>


ATB,

Mark.

