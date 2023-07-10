Return-Path: <philmd@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1689026203; x=1691618203;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=L4q7wMSsasZwArnf0grnmtRUbjmGYHOlhFhUwDDujEY=;
 b=JEa2pY6WTaAQHamte52sBL/ZJboNAHmIUMYb+VKIQrvD5AQtu0vx+m3N1blQrTeD+j
 NF5EzSEMDVSnTW/FNHNWSEvD79mbYqI9HqTmUamrrALyEa3Kw690zLhDVLH0vuJQff+h
 WcxLTgc6vNsqLORZ/TR5neVG1LO+U9JNU+mTxAoDyYFi+PaRdvUGFbcCJRhWLCV7U1Hq
 Vy8iiD4hRFkiEGv04UU2toWJfgG1x46Rrd5vHHaaEurxayo9hogFXafd6ACEgpPzdvBO
 0Ajma5MY5NgXpIGrTjSU1xLvLSwzrD1qknjHKyvcI88yQ2+zyLGmfc5kCi8vKZSh7P/+
 3/Bg==
Message-ID: <f1b0e780-b3b3-0592-b3da-f7295a0ef800@linaro.org>
Date: Mon, 10 Jul 2023 23:56:38 +0200
MIME-Version: 1.0
References: <20230710153522.3469097-1-alex.bennee@linaro.org>
 <20230710153522.3469097-4-alex.bennee@linaro.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@linaro.org>
In-Reply-To: <20230710153522.3469097-4-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH v3 03/20] hw/virtio: fix typo in
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
Cc: =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, qemu-block@nongnu.org, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, Kevin Wolf <kwolf@redhat.com>, Markus Armbruster <armbru@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Hanna Reitz <hreitz@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, virtio-fs@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>

On 10/7/23 17:35, Alex Bennée wrote:
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

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

