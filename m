Return-Path: <mark.cave-ayland@ilande.co.uk>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=ilande.co.uk; s=20220518; h=Subject:Content-Transfer-Encoding:Content-Type:
 In-Reply-To:From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:
 Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
 :Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ilJ8b7wm08S5cNoMRwZ7ZSj6f8FugSRGvC6Ht3a3z10=; b=ETDxgF05+SdySMi9w7rxYHTrLE
 n1JLIy8oaPIM68A71Q6B2Kd7WNYWpQ7B5ySITdQpxxAA6SOWp6Nc7JF6SEDweZCVWFnzWT4j+5nlE
 3+H0gMh0H4f9ss7D1tVNCtTdk/aP2/ozsMMYF2sN1DFjLsGwjz1v5DUI3/HE0/Mk4/kAxCkzGYRMX
 SL+K9n3B6fp2nrdmbeqO5MfyrxFxtLKd5EMA2JitPNHUdPDkC0GmpKM/jQVUfpOoYcA86iKkICjHz
 xVVrF6Kj1672ouT0Sh9/iA32sDoxGK9Y+Ajuk19DGB1bYwMqaXFktKhQbvO7Afj9JGAjsnpv/LggK
 DR2zaxBdPCYMgkW/5/+fyVLlgrPgSCZcHZdSJJZQ0BnncWM4szCJUuWWDv46x2DqRJws4/f0TrwfV
 j34KLL+bmIYhw1KtKrHHsz6ZBDkR160wAQPbx9cUKoXU/NQ8HeMfsUddIvly8lEpEPIeNGGky1sAe
 IdaJbhFUk7cHn/Jj5leiCir1BiXqr/+BqhSZ2w3WazHFuNCWS32eyKPOuf/E3VcJbtsMI/nTh55lh
 ICW6OMRrp/T0EHfkh/91tBHiZrvPJbTJWPa+QZf2vPlgXTPZXEhc9C3mcymS0Ep4paAhSJRIGvqDe
 /Rkd+MJ+CA3YCIetyMhTmMqMKnesyo+LjgNnyNCB8=
Message-ID: <ae8405c3-4c14-8e5c-8353-d1c96455c8e4@ilande.co.uk>
Date: Thu, 20 Apr 2023 10:24:34 +0100
MIME-Version: 1.0
References: <20230418162140.373219-1-alex.bennee@linaro.org>
 <20230418162140.373219-3-alex.bennee@linaro.org>
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
In-Reply-To: <20230418162140.373219-3-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v2 02/13] include/hw: document the
 device_class_set_parent_* fns
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

> These are useful functions for when you want proper inheritance of
> functionality across realize/unrealize calls.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> ---
>   include/hw/qdev-core.h | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)
> 
> diff --git a/include/hw/qdev-core.h b/include/hw/qdev-core.h
> index d4bbc30c92..b1d194b561 100644
> --- a/include/hw/qdev-core.h
> +++ b/include/hw/qdev-core.h
> @@ -795,9 +795,36 @@ void device_class_set_props(DeviceClass *dc, Property *props);
>   void device_class_set_parent_reset(DeviceClass *dc,
>                                      DeviceReset dev_reset,
>                                      DeviceReset *parent_reset);
> +
> +/**
> + * device_class_set_parent_realize(): set up for chaining realize fns
> + * @dc: The device class
> + * @dev_realize: the device realize function
> + * @parent_realize: somewhere to save the parents realize function
> + *
> + * This is intended to be used when the new realize function will
> + * eventually call its parent realization function during creation.
> + * This requires storing the function call somewhere (usually in the
> + * instance structure) so you can eventually call:

I think this should be the class structure, since it is the only possible location 
for the parent realize() function to exist given that these functions are called from 
the .class_init function.

> + *   my_dev->parent_realize(dev, errp);
> + */
>   void device_class_set_parent_realize(DeviceClass *dc,
>                                        DeviceRealize dev_realize,
>                                        DeviceRealize *parent_realize);
> +
> +
> +/**
> + * device_class_set_parent_unrealize(): set up for chaining unrealize fns
> + * @dc: The device class
> + * @dev_unrealize: the device realize function
> + * @parent_unrealize: somewhere to save the parents unrealize function
> + *
> + * This is intended to be used when the new unrealize function will
> + * eventually call its parent unrealization function during the
> + * unrealize phase. This requires storing the function call somewhere
> + * (usually in the instance structure) so you can eventually call:
> + *   my_dev->parent_unrealize(dev);

And same here of course.

> + */
>   void device_class_set_parent_unrealize(DeviceClass *dc,
>                                          DeviceUnrealize dev_unrealize,
>                                          DeviceUnrealize *parent_unrealize);


ATB,

Mark.

