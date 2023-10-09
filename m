Return-Path: <viresh.kumar@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696849144; x=1697453944; darn=redhat.com;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=yd5kWI84EmbioTxJcr7Sa3qdzXv/L7GnZ6Yf4TmaOis=;
 b=yuWwfr1pkZNyQhrcsABr2y3K4IM5n/kEwMUj8aQs5zjyfyi7lM8yJag0w7H1cvshMZ
 A/GwYmVd9jGbhhN/60UYOCs+cjHa2x6Lm1LtCLO8Ybvlu9CcaGmrqMeaR3F3tGzoLtF2
 IDZMI/1FxQQKa8qUp72No/pX+8Hx/G4UsTHc01reSMy0S70tKdHDftZzCcJCZ0H05JvC
 CFvQxnxpwZgcLJ+O8ytXoFfSjXnVDnVsSqTDsF0Myk1Z1xLPW1SyFpkrOkRPTIoEcH0p
 HdXWvy6fuOZkn+ijkOxFOIWv6QTihSXl8YIQpiddVbsX8Zc80U2YAHseKi2BlsyS35sN
 wtOA==
Date: Mon, 9 Oct 2023 16:29:01 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20231009105901.lmtexbfbcf5rnvch@vireshk-i7>
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-4-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20231009095937.195728-4-alex.bennee@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v4 3/6] hw/virtio: derive vhost-user-gpio
 from vhost-user-base
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Eric Blake <eblake@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, qemu-block@nongnu.org, Eduardo Habkost <eduardo@habkost.net>, Paolo Bonzini <pbonzini@redhat.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, virtio-fs@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>

On 09-10-23, 10:59, Alex Benn=E9e wrote:
> Now the new base class supports config handling we can take advantage
> and make vhost-user-gpio a much simpler boilerplate wrapper. Also as
> this doesn't require any target specific hacks we only need to build
> the stubs once.
>=20
> Message-Id: <20230418162140.373219-12-alex.bennee@linaro.org>
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
> Acked-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
>=20
> ---
> v2
>   - use new vhost-user-base
>   - move build to common code
> v3
>   - fix inadvertent double link
> v4
>   - merge conflict
>   - update includes
> ---
>  include/hw/virtio/vhost-user-gpio.h |  23 +-
>  hw/virtio/vhost-user-gpio.c         | 407 ++--------------------------
>  hw/virtio/meson.build               |   5 +-
>  3 files changed, 22 insertions(+), 413 deletions(-)

Looks nice. Thanks.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

--=20
viresh

