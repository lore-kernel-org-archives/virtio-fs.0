Return-Path: <alex.bennee@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681720961; x=1684312961;
 h=content-transfer-encoding:mime-version:message-id:in-reply-to:date
 :subject:cc:to:from:user-agent:references:from:to:cc:subject:date
 :message-id:reply-to;
 bh=oDogvV/KbDOc2pu5zy/l3hr2DNuh3AepOl08MTTKnHY=;
 b=u3kqZVs+dR+1JG/AH4XjgvjrBFlhwqYlDMd3djN1qHMTkh0YgAghEkHww8hwMVZFOW
 R/p/G50yuHoUT/CqEW5ffg30mMay8iDU3TIQRaxh3lRdtna+nPTxZ6B4wDGMEazzkwlQ
 P/VyGpGlyMP3jtCyfaBPe8rcAcYhn5zx+YBwRDhsJT+CtDk5hG7VLAeRw877rw1m6ZQY
 Mr5r7G3UOy4OrB30hJBY2BPAG32A69gxj0XTRKM/UGp3DKFA/VoiTa6NR/5LjG3a6IvK
 a5RU1d4o0eS7SO6WG9oPpPmt0t+X4SByeqxQkiZ9Ugw6R/amQcsWjkME1T7TRerTAdrV
 t7Sw==
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <20230417042631.ncmvabezvzloxksl@vireshk-i7>
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Date: Mon, 17 Apr 2023 09:42:04 +0100
In-reply-to: <20230417042631.ncmvabezvzloxksl@vireshk-i7>
Message-ID: <87leiq99xc.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH 00/12] virtio: add vhost-user-generic and
 reduce copy and paste
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?utf-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>


Viresh Kumar <viresh.kumar@linaro.org> writes:

> On 14-04-23, 17:04, Alex Benn=C3=A9e wrote:
>>  hw/virtio/vhost-user-device-pci.c      |  71 +++++
>>  hw/virtio/vhost-user-device.c          | 359 ++++++++++++++++++++++
>>  hw/virtio/vhost-user-fs.c              |   4 +-
>>  hw/virtio/vhost-user-gpio.c            | 405 +------------------------
>>  hw/virtio/vhost-user-rng.c             | 264 +---------------
>
> I wonder why isn't i2c removed as well ?

I will do - mainly I want to do a similar dummy device addition to the
i2c daemon for testing.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

