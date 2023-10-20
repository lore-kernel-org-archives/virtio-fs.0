Return-Path: <viresh.kumar@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697771652; x=1698376452; darn=redhat.com;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=SmIOwafm690ltH7DS0hp8tl/3mX+luN9DZkRrNK/BHc=;
 b=ZBGYcUQxPqCNeQikOB1fGCzBlyBvpir7r69Q+8vF6susMUtCJ0iuYkm9BGLpOD/gUO
 PBg02V+kaGAQBnX3BmLlCRCTkDCh7/KbTtY/gUcv2jm8as9ePCwmcd7jW/XFFehJAkPe
 tEEZovIbu9bWjzv2VboYiNwYB7D/w8DwjBuJE8eLIiUotA77yGqjxrNgt5v6YMIHpQf4
 Sh0DvnfLPPNfOUaKwB/3WunjoXnhYHsn2gMGKBuTeYjXMVrKgZxtldyX9ib+YHvm7Lel
 yqMDuVPe6OBDWz2l55oLT1Li3U6dFtn9QBCPkn0I+x1gcX2jKxknriSuGHnbpPEYLAL2
 E1lA==
Date: Fri, 20 Oct 2023 08:44:07 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20231020031407.xd4ykc4msfdmoav5@vireshk-i7>
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
 <20231019095610.2818087-6-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20231019095610.2818087-6-alex.bennee@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v5 5/6] hw/virtio: add vhost-user-snd and
 virtio-snd-pci devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

On 19-10-23, 10:56, Alex Benn=E9e wrote:
> From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
>=20
> Tested with rust-vmm vhost-user-sound daemon:
>=20
>     RUST_LOG=3Dtrace cargo run --bin vhost-user-sound -- --socket /tmp/sn=
d.sock --backend null
>=20
> Invocation:
>=20
>     qemu-system-x86_64  \
>             -qmp unix:./qmp-sock,server,wait=3Doff  \
>             -m 4096 \
>             -numa node,memdev=3Dmem \
>             -object memory-backend-file,id=3Dmem,size=3D4G,mem-path=3D/de=
v/shm,share=3Don \
>             -D qemu.log \
>             -d guest_errors,trace:\*snd\*,trace:\*sound\*,trace:\*vhost\*=
 \
>             -chardev socket,id=3Dvsnd,path=3D/tmp/snd.sock \
>             -device vhost-user-snd-pci,chardev=3Dvsnd,id=3Dsnd \
>             /path/to/disk
>=20
> [AJB: imported from https://github.com/epilys/qemu-virtio-snd/commit/54ae=
1cdd15fef2d88e9e387a175f099a38c636f4.patch]
>=20
> Signed-off-by: Alex Benn=E9e <alex.bennee@linaro.org>

Missing SOB from Manos ?

> Message-Id: <20231009095937.195728-6-alex.bennee@linaro.org>

--=20
viresh

