Return-Path: <erik.schilling@linaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=linaro.org; s=google; t=1681806538; x=1684398538;
 h=content-transfer-encoding:in-reply-to:from:content-language
 :references:cc:to:subject:user-agent:mime-version:date:message-id
 :from:to:cc:subject:date:message-id:reply-to;
 bh=6LvL0HsH/Rp4XNBniooL+fT0q3eCcuW4TJf74hsB+UU=;
 b=tpvHp4P3i1pNUlJOM+WWz8eSl1PGnh64bSGuafTYqIe5fCaoVel09SiviDC3EsvNAF
 U269F/12iiR7a7hmdOsrP8TVNc33A7gAhczSGTdYvRRDJfNL3VhY8VQrQnLqzxJE7p4f
 8SWU+zCJPrkfmCkiV3qJWrDWprXoSzKdzGLRbkcs70cKjGbPRouH098Xan7r1uxngq0Q
 kPKu9F2r5NnjQy9EzY61/ItudGo9w28vjZdm65PC8i7ZWPNdx16O8uupg6y9ArIIlaD3
 1uUmB1jQit2LpZjOE7QCQt6NDNUV2falvY/eNyxSg8UKj+5gFdSiLN9hjOKdsy1tvyTL
 TQ4A==
Message-ID: <650bf2ae-20b9-a5fa-3342-c069f680ddd7@linaro.org>
Date: Tue, 18 Apr 2023 10:28:56 +0200
MIME-Version: 1.0
References: <20230414160433.2096866-1-alex.bennee@linaro.org>
 <20230414160433.2096866-7-alex.bennee@linaro.org>
From: Erik Schilling <erik.schilling@linaro.org>
In-Reply-To: <20230414160433.2096866-7-alex.bennee@linaro.org>
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Subject: Re: [Virtio-fs] [PATCH 06/12] virtio: add PCI stub for
 vhost-user-device
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@redhat.com, =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Stefan Hajnoczi <stefanha@redhat.com>, Eric Blake <eblake@redhat.com>, =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>, Jason Wang <jasowang@redhat.com>, Viresh Kumar <viresh.kumar@linaro.org>, Mathieu Poirier <mathieu.poirier@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, Markus Armbruster <armbru@redhat.com>



On 4/14/23 18:04, Alex Bennée wrote:
> This is all pretty much boilerplate.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Tested-by: Erik Schilling <erik.schilling@linaro.org>

Tested with d6f9fb0 of a rust-vmm SCSI device [1] and -device 
vhost-user-device-pci,virtio-id=8,num_vqs=3,config_size=36,chardev=vus

[1] https://github.com/rust-vmm/vhost-device/pull/301

- Erik

