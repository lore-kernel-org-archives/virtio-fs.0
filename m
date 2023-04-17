Return-Path: <viresh.kumar@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681705594; x=1684297594;
 h=in-reply-to:content-transfer-encoding:content-disposition
 :mime-version:references:message-id:subject:cc:to:from:date:from:to
 :cc:subject:date:message-id:reply-to;
 bh=WZHQWGl6747Vai1AIq5xHpSSl1CMLCZ/BhWzL2hYS9Y=;
 b=jkKl9+uUqmdLtuzFNAw3vU82AWRpf+uSuLDfQ9tWTwtu/rBIjCjDOqvxiDedpnp66S
 pEGjkZ12qum8sBAL4ASoGUryUitJqK474t9trmC7PTNaf2t+3yhyIlcEFP7UyqguRzrU
 L9ijzIKFi564c+N6Wl/2EjwsdcTzq1xRDy0IBSA5wmYqojAUqrC3WihGTAixQ+JjxINd
 Qews5P4z5O47ar66BMeTfPkT0nLKvWArxqRRLIdHKUd8TymbvaAOQ8nJAMNrkIIZDJHF
 lKNDkwCOAH1k8xOkn0FkzKoCp3d1vs1OiFbEiAMWFnDlA+pme6sYshh616Y1mhTP/bHm
 dBgw==
Date: Mon, 17 Apr 2023 09:56:31 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
Message-ID: <20230417042631.ncmvabezvzloxksl@vireshk-i7>
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20230414160433.2096866-1-alex.bennee@linaro.org>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
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
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, Erik Schilling <erik.schilling@linaro.org>, =?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>

On 14-04-23, 17:04, Alex Benn=E9e wrote:
>  hw/virtio/vhost-user-device-pci.c      |  71 +++++
>  hw/virtio/vhost-user-device.c          | 359 ++++++++++++++++++++++
>  hw/virtio/vhost-user-fs.c              |   4 +-
>  hw/virtio/vhost-user-gpio.c            | 405 +------------------------
>  hw/virtio/vhost-user-rng.c             | 264 +---------------

I wonder why isn't i2c removed as well ?

--=20
viresh

