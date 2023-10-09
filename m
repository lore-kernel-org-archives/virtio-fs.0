Return-Path: <viresh.kumar@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1696849161; x=1697453961; darn=redhat.com;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=nAOqsSFr3jk7+N7ZTVaXa68g9aRWhZNiRtd02Vd5zi4=;
 b=gbjL4aisa0iEFr9ysuropHefeLIBWVpOgYy3mSXQR7Qrx7KwtU8kEca0csXZX9tnyX
 kE5X6ToUnu22NomRFPNejw3ctA1JK7fwIfv83t2P4K/OjZerJhE/pqsUOEIL2RHrmnfQ
 N4fX5t9dSU5uDePc49yVs7a/X3z5NGaiDAxVJE2YeS/LlH5ABF1Etq2+FhakkK+jjEEi
 sUXQCcIY/cZkrRl8ZSuboGc+6O9ViaR4cpyX4asIt66CoR3+8DFBxkgpWTDXdedLQ4CN
 xF5wXE4zS1X15bkSP1JvmX6XzOZfmS3JpMotgBfwzg6PS3ul1jQDQykOJegfJNK81gSZ
 OKKQ==
Date: Mon, 9 Oct 2023 16:29:18 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20231009105918.tvji5lsw5jrt4gur@vireshk-i7>
References: <20231009095937.195728-1-alex.bennee@linaro.org>
 <20231009095937.195728-5-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20231009095937.195728-5-alex.bennee@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v4 4/6] hw/virtio: derive vhost-user-i2c
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
> Now we can take advantage of the new base class and make
> vhost-user-i2c a much simpler boilerplate wrapper. Also as this
> doesn't require any target specific hacks we only need to build the
> stubs once.
>=20
> Message-Id: <20230418162140.373219-13-alex.bennee@linaro.org>
> Acked-by: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>
>=20
> ---
> v2
>   - update to new inheritance scheme
>   - move build to common code
> v3
>   - fix merge conflict in meson
>   - style updates, remove duplicate includes
> v4
>   - use vqsize
> ---
>  include/hw/virtio/vhost-user-i2c.h |  14 +-
>  hw/virtio/vhost-user-i2c.c         | 272 ++---------------------------
>  hw/virtio/meson.build              |   5 +-
>  3 files changed, 23 insertions(+), 268 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

--=20
viresh

