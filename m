Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1698167713; x=1698772513; darn=redhat.com;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=rohQWxVwWTGxxrSiola3bwmXiJJ+17R1oWlnzR2/H38=;
 b=vdeFUbs14tre7awfhe0McpuBWBzc2ek7LRaK9rrCzN9vUKkOVL/Wx8qgVZcQZdRJcP
 OqHI2311Aw9uC1YNcJNrrBMQMW+94Gb25Lcy6axlRbH/F/YgS6VRGaTRNl698QIlP8RN
 RGKxsfDWl1e/zBmlyzp3inwusOi8ZnMx08xgL3z2IzOwrvKKU5stW2OCLO5Abm7Gl1NZ
 tfCkzp6atl67EpeXUBqAfzSK+rEVWDHHfNEymrvUe+SXST+HWhx2WykVZ3gfgjNSYF3O
 l2ynh0doEhmHoIl8ncVZAl9b6nUDoo++2uBq+1FqgOuFCDXuyM/kMupn70EEz4r9neOe
 Iqzw==
References: <20231019095610.2818087-1-alex.bennee@linaro.org>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Tue, 24 Oct 2023 18:14:36 +0100
In-reply-to: <20231019095610.2818087-1-alex.bennee@linaro.org>
Message-ID: <878r7s0wnz.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH v5 0/6] virtio: cleanup vhost-user-generic
 and reduce c&p
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, virtio-fs@redhat.com, Eduardo Habkost <eduardo@habkost.net>, Fam Zheng <fam@euphon.net>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>, qemu-block@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Erik Schilling <erik.schilling@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Eric Blake <eblake@redhat.com>, Kevin Wolf <kwolf@redhat.com>, Jason Wang <jasowang@redhat.com>, Raphael Norwitz <raphael.norwitz@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Markus Armbruster <armbru@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Gonglei (Arei)" <arei.gonglei@huawei.com>


Alex Benn=C3=A9e <alex.bennee@linaro.org> writes:

> A lot of our vhost-user stubs are large chunks of boilerplate that do
> (mostly) the same thing. This series continues the cleanups by
> splitting the vhost-user-base and vhost-user-generic implementations.
> After adding a new vq_size property the rng, gpio and i2c vhost-user
> devices become simple specialisations of the common base defining the
> ID, number of queues and potentially the config handling.
>
> I've also added Manos' vhost-user-sound while I was at it.

Ping MST. Any more comments or happy to take as is?

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

