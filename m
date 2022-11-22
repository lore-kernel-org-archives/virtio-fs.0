Return-Path: <raphael.norwitz@nutanix.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=7BFK3S5sCKK6ERyllcHh76eGRzcvh5tyUrB8Ywwd0WQ=;
 b=TbMjkxrVrzaNGuTsDKY8f1MwH0bQKihyxPKpdrd2p3dv0QUp5zM/2sXUD1MG+d6PENjM
 sOrcEsZNFLXnfHff7Xmtb6YM8xis4S8pNFMHQEgOOGqMGeK3vsjKBH0t406f9rbOtvlk
 QZTQiusN4swZIA5+sJkGjYcaUGlIzONvx7OD51dweEGQDY2zpAWyGpfBsOr9jgiY6jO2
 JTdIKIGLEXNBDdTwFXMKbWTjeePyoXFYFwDjTv1t0xZzRdgRneq532vKIgWGYXQ3j3P/
 EgHftMrqms6ZSoHWoBREVwycqC362zHYyZW5Pi9tMNllwlb7OW6NuGT1xyy/AkUq0/QZ OA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BFK3S5sCKK6ERyllcHh76eGRzcvh5tyUrB8Ywwd0WQ=;
 b=a/HC7JQc24jZjvqaeoPGlrs+KpzES9ME1mL94NJ3GLU+CDvhTsSdDRcy6OR5lBEsv/x9hlbb8dTfExP2ntk2wa+T2dZJ46LTu5oVhffrnCoOGGW/s8bAaPh9FKaDsfPoU6NXK37ITjaCJZgAiC6TVBrN5zaY90xW2OIROLMGMRCqA7CHE8bYRmeqSBmnMeZ5w2Qek9fON62hAHpQOFQ9H+d108R4hpdBjwl1GUZkaYlqaaUzopNyWLJls6LjJ9ZMvM6SiQX2/4fzN+zLRP55P2CIX3LhMNJ+NBbhwv3VhgejtAPivTtZCVOCedt+DkXvDejhhBceDh3X7/WN0Wif6A==
From: Raphael Norwitz <raphael.norwitz@nutanix.com>
Date: Tue, 22 Nov 2022 04:27:18 +0000
Message-ID: <287332EC-DDF6-4D2D-BFBC-34BE65C3AE8E@nutanix.com>
References: <20221121101101.29400-1-sgarzare@redhat.com>
In-Reply-To: <20221121101101.29400-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <C5DD2EA36525C34FB45249A8B6ADD50C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [Virtio-fs] [PATCH] vhost: mask VIRTIO_F_RING_RESET for vhost
 and vhost-user devices
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/virtio-fs/>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
 <mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>, "virtio-fs@redhat.com" <virtio-fs@redhat.com>, =?iso-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>, Mathieu Poirier <mathieu.poirier@linaro.org>, Kevin Wolf <kwolf@redhat.com>, "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Hanna Reitz <hreitz@redhat.com>, "kangjie.xu@linux.alibaba.com" <kangjie.xu@linux.alibaba.com>, Jason Wang <jasowang@redhat.com>



> On Nov 21, 2022, at 5:11 AM, Stefano Garzarella <sgarzare@redhat.com> wro=
te:
>=20
> Commit 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> enabled VIRTIO_F_RING_RESET by default for all virtio devices.
>=20
> This feature is not currently emulated by QEMU, so for vhost and
> vhost-user devices we need to make sure it is supported by the offloaded
> device emulation (in-kernel or in another process).
> To do this we need to add VIRTIO_F_RING_RESET to the features bitmap
> passed to vhost_get_features(). This way it will be masked if the device
> does not support it.
>=20
> This issue was initially discovered with vhost-vsock and vhost-user-vsock=
,
> and then also tested with vhost-user-rng which confirmed the same issue.
> They fail when sending features through VHOST_SET_FEATURES ioctl or
> VHOST_USER_SET_FEATURES message, since VIRTIO_F_RING_RESET is negotiated
> by the guest (Linux >=3D v6.0), but not supported by the device.
>=20
> Fixes: 69e1c14aa2 ("virtio: core: vq reset feature negotation support")
> Resolves: https://gitlab.com/qemu-project/qemu/-/issues/1318
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>

Looks good. For vhost-user-blk and vhost-user-scsi:

Acked-by: Raphael Norwitz <raphael.norwitz@nutanix.com>

