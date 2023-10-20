Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1697789784; x=1698394584; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=knfbUmDlWDNIDCvUS/vYlItD5jDiz9MwexkEaOBISbM=;
 b=IzDhBbtysCM8vWV1hxcJN9/e0JJi63XJ7G3qRkJNsDyFXl79ps2T4PT7DbZsGjGXYI
 lUs3TcBXFkSnvhgIMie/iQsGy4pV4kJIa7KzOAz+kWXxL66fZwNPcMZvo9FqseuTOY9g
 z6qnb3kDxNBt7XqgR3GByvkMudetUl8/eKDtNtMEaMZqxRVB7RFeaKZhcgKdPMOQYl/f
 z9c4teOkzIxEVW50XjfaEeTR5anQsR6Lfc4zy/7hVizSoUx5Yzr3SAp5LfoCsfmNE/H/
 2pqDtcGB/6CSXs5fJZTEsk37dr3r9SfuF0bQbaoIIi5iOtpqstybQx6BqHKNdFjmxGgm
 2ihA==
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
 <20231019095610.2818087-6-alex.bennee@linaro.org>
 <20231020031407.xd4ykc4msfdmoav5@vireshk-i7>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Fri, 20 Oct 2023 09:16:03 +0100
In-reply-to: <20231020031407.xd4ykc4msfdmoav5@vireshk-i7>
Message-ID: <878r7x90a0.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: qemu-devel@nongnu.org, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Manos Pitsidianakis <manos.pitsidianakis@linaro.org>


Viresh Kumar <viresh.kumar@linaro.org> writes:

> On 19-10-23, 10:56, Alex Benn=C3=A9e wrote:
>> From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
>>=20
>> Tested with rust-vmm vhost-user-sound daemon:
>>=20
>>     RUST_LOG=3Dtrace cargo run --bin vhost-user-sound -- --socket /tmp/s=
nd.sock --backend null
>>=20
>> Invocation:
>>=20
>>     qemu-system-x86_64  \
>>             -qmp unix:./qmp-sock,server,wait=3Doff  \
>>             -m 4096 \
>>             -numa node,memdev=3Dmem \
>>             -object memory-backend-file,id=3Dmem,size=3D4G,mem-path=3D/d=
ev/shm,share=3Don \
>>             -D qemu.log \
>>             -d guest_errors,trace:\*snd\*,trace:\*sound\*,trace:\*vhost\=
* \
>>             -chardev socket,id=3Dvsnd,path=3D/tmp/snd.sock \
>>             -device vhost-user-snd-pci,chardev=3Dvsnd,id=3Dsnd \
>>             /path/to/disk
>>=20
>> [AJB: imported from https://github.com/epilys/qemu-virtio-snd/commit/54a=
e1cdd15fef2d88e9e387a175f099a38c636f4.patch]
>>=20
>> Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
>
> Missing SOB from Manos ?

oops, guess I need a respin then ;-)

>
>> Message-Id: <20231009095937.195728-6-alex.bennee@linaro.org>


--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

