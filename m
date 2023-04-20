Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=qnUAxBfDwZjwdHH8OBqbLXj9cU97J1p3ec7utv51Llk=; b=b+Iurvh2P5voLr+j8C4J1aD1Ky
 gLzYlgIjSaY4ANbrX3m8Wn/AfdCb260D2+hc+34xWsdx7ii31L+jY6DiKKF7064D4DoQ9OV2WQZBg
 cCIr3Xy0Juu8WJqH3vWoduXhMyLP6r7Qk7AnqMgE2PU/dqf7VTfHZt1wGycmMQF4DX6beG67NqpwK
 HsVGYDueiUtwX/l/4SrZOGIbKQ3aNV6HCbiIFWhpUhEEUsmoJhzagCYD2RjSKAywh1K4e983fiX+j
 11YDLUzvNR4FK0gZ370r7fEtldjVedHgPlN/jooV56gnXtIQfxF4J4RFM9LPvPrEMPD14SfDNHUgV
 HHIjmC32uozML5trAE7TldbOtG3RZyLuoCjhDFcHvuh1n+7ryNovL0v2sNMk2iYAdRHEqmIPtfsYD
 kXvSipXQhOWygHKzASo8xFrf5+hUdMrfA8hvBdm52Usxt1GPs9BS2l1FbP0ycBIJNTlM4E5q+JsGO
 KadX1VlFRaN29d6g9ZhpCxYJl1BlWy9VA5Hku2tEzJ7T+bOIE1YhIqv//M4bp+fRxXc05D1YIh1ds
 oNGNCALZLsWiFPDJZjtW9tlz6526oyVhMsJ94DMa3d+DesqsphuJSdDFNarWRFJNykYxXb8sX4AU4
 +71Np4gDdommcONkAEAErcAS6SoubFG7p5z8J/zhI=
Message-ID: <0f77841f-c40a-8bad-4955-75aada8cd13e@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:32:04 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-7-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-7-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 06/13] include/hw/virtio: document some
 more usage of notifiers
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

> Lets document some more of the core VirtIODevice structure.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/virtio/virtio.h | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 1ba7a9dd74..ef77e9ef0e 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -150,10 +150,18 @@ struct VirtIODevice
>       VMChangeStateEntry *vmstate;
>       char *bus_name;
>       uint8_t device_endian;
> +    /**
> +     * @user_guest_notifier_mask: gate usage of ->guest_notifier_mask() callback.

Typo: @use_guest_notifier_mask

> +     * This is used to suppress the masking of guest updates for
> +     * vhost-user devices which are asynchronous by design.
> +     */
>       bool use_guest_notifier_mask;
>       AddressSpace *dma_as;
>       QLIST_HEAD(, VirtQueue) *vector_queues;
>       QTAILQ_ENTRY(VirtIODevice) next;
> +    /**
> +     * @config_notifier: the event notifier that handles config events
> +     */
>       EventNotifier config_notifier;e 
>   };

As before, I'm not overly familiar with the virtio code but the description makes 
sense to me so:

Acked-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>


ATB,

Mark.

