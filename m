Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=oKIaaA43LEdto76cISwdT3W7LZPO4XuM1D50BhjLAoQ=; b=e2GCXLejeu4UWeS3e2wHrt8fcU
 mWAY8LOhVoKS3L4wijZNH1KUTNZc5/DV+MMAzb9sVh+rv97qthJWBKsP89kSQHAPJFqfCeNf94778
 76TXVHiDy41t5zzU6LmztwjD7KcPw/Z7Cp/UolBJ3jgef5PZu5ETBQEUfMsqdTifjzsoMBAz2ByhB
 RQkv9lIGlTq0YvI0gFcieJPwISfcY7HiXCEm3nFAqZqegiTk2GWAszXWkGzMF3ep19qQvP8RImwMG
 Hnz4z+2lfsxIXE1KN9l9OM0ORPRRvqLQS7q6xd8aBu/sVgLXhupcg81frNCJlQfMDoVH2DzXSP/dH
 fbpucoQsMsRWYYdTwSjnKkSCpYOIU4qxh2lAl1K22/Y8jrMDiqk6AkglXhuLDOQS2I+0i4hGX25LG
 p//QFScM+JN2jd8A5+nnbDCx1zHfJ8dUhJJuNcP1LQ98LE46Ye4Oer1zLjnVKGiYNoXig0RpTumpM
 u4aVFzYHVAkv/fWzQ9YhEeRUfv2m53ubXVUe1ihfd792g9dUBUH56cpwnhSGbmYwfB9Nr5hukzhss
 XKjEX49ZWnkl3iD80dYo+VH4nx6G66pfnrAIlZhPRBo6Apsarc30fnOkHIjAXtE1/WkAayhfPl1sA
 lc3CCJYoVbds6gb9GTEHC5V5Su1Gy8QymKtpgiqFQ=
Message-ID: <2e1767b9-c171-40df-1bc9-2c4c14d5292b@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:21:02 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-2-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-2-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 01/13] include: attempt to document
 device_class_set_props
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

> I'm still not sure how I achieve by use case of the parent class
> defining the following properties:
> 
>    static Property vud_properties[] = {
>        DEFINE_PROP_CHR("chardev", VHostUserDevice, chardev),
>        DEFINE_PROP_UINT16("id", VHostUserDevice, id, 0),
>        DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
>        DEFINE_PROP_END_OF_LIST(),
>    };
> 
> But for the specialisation of the class I want the id to default to
> the actual device id, e.g.:
> 
>    static Property vu_rng_properties[] = {
>        DEFINE_PROP_UINT16("id", VHostUserDevice, id, VIRTIO_ID_RNG),
>        DEFINE_PROP_UINT32("num_vqs", VHostUserDevice, num_vqs, 1),
>        DEFINE_PROP_END_OF_LIST(),
>    };
> 
> And so far the API for doing that isn't super clear.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/qdev-core.h | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
> index bd50ad5ee1..d4bbc30c92 100644
> --- a/include/hw/qdev-core.h
> +++ b/include/hw/qdev-core.h
> @@ -776,6 +776,15 @@ BusState *sysbus_get_default(void);
>   char *qdev_get_fw_dev_path(DeviceState *dev);
>   char *qdev_get_own_fw_dev_path_from_handler(BusState *bus, DeviceState *dev);
>   
> +/**
> + * device_class_set_props(): add a set of properties to an device
> + * @dc: the parent DeviceClass all devices inherit
> + * @props: an array of properties, terminate by DEFINE_PROP_END_OF_LIST()
> + *
> + * This will add a set of properties to the object. It will fault if
> + * you attempt to add an existing property defined by a parent class.
> + * To modify an inherited property you need to use????
> + */
>   void device_class_set_props(DeviceClass *dc, Property *props);
>   
>   /**

Can we say that the use case description above is now obsolete with the introduction 
of the abstract VHOST_USER_BASE class (i.e. it was a modelling issue)? If so, I think 
the comment is good, except that the last sentence can be removed.


ATB,

Mark.

