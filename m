Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509B54D1784
	for <virtio-fs@lists.linux.dev>; Mon, 28 Sep 2026 13:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603274; cv=pass; b=hZFouIYszJ6BgkA4nkypDiOgcL7Gi76Q8r4ZnObpXBN/tW9t5OqKnyfrHowGvvUB9NIIuz+O/rU+jfrIoADjVBdVDfn5AxKcpExKCFsb5/x+hpcwGxUjS3a4AZuFypI867/HqZt+b/9cUB6d2OeC+wd/+LYiLobwxWb5gvAI8YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603274; c=relaxed/simple;
	bh=Bz7R+AnuzS0h9+NyzcXfyCPb7n53nbtmJa6ULxi56Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WqeCEqcKmMj89dLQd1O7fbLT5Zre1h01WTf7Zq9gt8+qpfq4dfARUnY94yvQLM3KqdUneGWmhkNs3BUtpnd5QyZZiyIOn0bu1L2MFikM9mjPsuasJdBBQ88NAwGb1l04AM8gGqNvTgewdSSsSkN+AOkrp2tL9yRlE8+bK8+ZkHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adacore.com; spf=pass smtp.mailfrom=adacore.com; dkim=pass (2048-bit key) header.d=adacore.com header.i=@adacore.com header.b=EI54lL7F; arc=pass smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=adacore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=adacore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=adacore.com header.i=@adacore.com header.b="EI54lL7F"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aae7b7fe22so5195892a12.2
        for <virtio-fs@lists.linux.dev>; Mon, 28 Sep 2026 06:47:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790603270; cv=none;
        d=google.com; s=arc-20260327;
        b=MIAggj/UMlu7hDX9HF+9jrbv+wMo/LC94TLwu47A1dg0U/y/jvBQreZNUbr+8gFNxS
         55lDlgH60dfTDO38MuYgcqjdMqxpYJOFquPWrhnDg6vLg5ey2OkazsIUyG1Qxb/1A1Ov
         b3nlpMaainoDqfUbIzWizJQrKFH/IGnCtP6TB32DwMY6dkv9qwH59Ji+ExRf3AAISStf
         hDlXm3uO1BqNNZ24RNSFd+hedwUgnZ5ktTQIdcxVYE7N3Dr6TDCt69OnMuNnKaYufetX
         9L4E8K5IYTWf5X7ckpq/HaL7c4Bm3jxTMWVh53YksAdQ2LGvtt3hYPqmhAurE8k2PqA1
         bEnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=90TS4/HohSKsclD3ZOBgHeLX3Hm2WU4o4xP+PIiuVu4=;
        fh=ykJwE3SV+bpFoKiwVk8hLJfo9ddtzXnda5pyFFDQYsY=;
        b=bqMlgWJw/vndQ7eZ6ysjSL0z3iBEpblEV+0VZg3OOioAmx+XV9OSE9z3EdjIBEE7H3
         6khMxwCTrWwHYq3c7mFmL/yKV/n/9XJyPZ+3jkYFBoOhmT7u4K6N/iwajdKF2xWqbml7
         ksfZwiBVl7TSJksOu4e8tKvXEzQd8SdkwMHE6A6iKbpEIvZH0uvTktWp16EgSkJUo/3d
         yv0ujB/RsSmYE4vkXKxWAsYuL8qVZKD4mHtAAp7GGs50ICpkcwJ5Om1vDD5aDTN2f7la
         ze24Up2ylYp5Lkg+hZIzIQxHLyhRe9vjFZUkin5Jy5J9NpfFjCTS4oJ8efiS88HAhQ2m
         cl0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adacore.com; s=google; t=1790603270; x=1791208070; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=90TS4/HohSKsclD3ZOBgHeLX3Hm2WU4o4xP+PIiuVu4=;
        b=EI54lL7FpYo4qMCytvU/vbcieXi9p+2t9csBDKEpudbyl1z/1fzSlfPz3SfI/QFr32
         SVZHZNKgOr5IQsN6mLrrPIZHX8Ctkt5muPAyvGTnvvkjCNPtUSpc1nu5szUf1UqhowPW
         Ag1FD7u0s4U/lFDEa73kwfzsK5eOJkakO5paCt7QNqakKRPvFi9a8QR8jfjCxKsb7YfI
         8F4DUHVJbaevlO6+1MH0iAgIUNmfcRPHR4pVCppAZlxSGCAYkf9sYGWhuC64DKn+dCR1
         ML53neuLMCFOsHrEG8je3Wo9nVs8S/EhKwDcR7ImPov9PU6f+pcfPwda6TH5hOJ/7ROP
         1z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790603270; x=1791208070;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=90TS4/HohSKsclD3ZOBgHeLX3Hm2WU4o4xP+PIiuVu4=;
        b=s/c0Ac/GiIQv1Q+NDCMn8ms1+l0EM5er0zwqBwP+e58VpPnDoPMWd1USc2IOX9bFHH
         PjNwg61ScDO3kWw+NhA9DFnc03wqc9M0/6AePys3SzHI2hcAnD0C7KTMTUHX8R1SEpCZ
         LEi+u/0sw9c/jM/CVUkct4Zy2myfAuT9Yyjj5jRm84KgR/P79AGvlLwfgW8bnPDK13Na
         xP4UWLFOEmE8SYxI7L2hcBVgI2DbGZy/l8XES742kwaPSMgeFWn+RggfVebpUM9JkNhR
         HEGtF9nWfclFgEyNmTIZZbUzCtBW742mfiob/fWM134XkKhqSIpEGW05FgwMMcUMSBM4
         5S2Q==
X-Forwarded-Encrypted: i=1; AKwUvBzTpjFTZuUi/OcxGxVemjhufRr4ZCPN6Q+ZeKM+MTSKCCDxJy8y/cRxJDL5Y2powUF+S9IR1FaW9bU=@lists.linux.dev
X-Gm-Message-State: AFq9FYLEvhnTlnoG9SprHALTCRHqr0L4KsimCGdkdJi6Vm+i6fzacEWy
	zHbRexzdcId8T0DIgOlb/biNzxd5rA0lfR08tgvl7JwIUg6wNKbldp4S1+WoSkow9eGx/BhJiqN
	GdGg/BkF6L0IY8V/hNeFT/MUKMltdXucX58U9GCrL
X-Gm-Gg: AYBFou2kuPWGu3PeyRRyFkIOll20A/iUsmZl1gG8PQE5TvcLaUGRRiHNb8fUCxGNohW
	RgKZfIk+sBrkX0x3lU8ZvgrC86+77w5Sw6/l9Pw0XDgIveWqv1QwJEXko7FSIVkF9gpLYU1ig71
	HhQ7gabUvpJThGvDcViQeCXyUKzuFtWY9LvR5SReM/WqCtSdYFAWeXKXp4KIUCPg3vkdbklnCas
	i6xPQHia4vJ+ygA+Zh9JKaJC1xYIi6fA7gumvFxpCaBKGPUMMS5VljzhDyi8dz1SnxYCKYCSNBK
	On/DHkoL/YoNOXm2EE1Vjn4rcrOhBbd3bvDAAc0Gu2niH1xy6SVMfCA=
X-Received: by 2002:a05:6402:4588:b0:6aa:13c1:2c88 with SMTP id
 4fb4d7f45d1cf-6aae8f7690cmr7002818a12.44.1790603270201; Mon, 28 Sep 2026
 06:47:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260803072853.2920007-1-dtalexundeer@yandex-team.ru> <20260803072853.2920007-2-dtalexundeer@yandex-team.ru>
In-Reply-To: <20260803072853.2920007-2-dtalexundeer@yandex-team.ru>
From: =?UTF-8?Q?Cl=C3=A9ment_Chigot?= <chigot@adacore.com>
Date: Mon, 28 Sep 2026 15:47:39 +0200
X-Gm-Features: AclHuK_6mZnFAdrL08_eUQ1NOgUZoTHvSagXzvzVgNbWK2CHJ9nVrFDbnTdFXBk
Message-ID: <CAJ307Eg_8167wGsjDnGoy08tnCe9SVwP9XSHwRSvFa7nCd4rYw@mail.gmail.com>
Subject: Re: [PATCH v6 1/6] vhost-user: add skip_drain param to do_vhost_virtqueue_stop
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, zhenwei pi <zhenwei.pi@linux.dev>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Jason Wang <jasowangio@gmail.com>, 
	Kevin Wolf <kwolf@redhat.com>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, 
	Milan Zamazal <mzamazal@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org, 
	Hanna Reitz <hreitz@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Fam Zheng <fam@euphon.net>, 
	virtio-fs@lists.linux.dev, 
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>, 
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 3, 2026 at 9:30=E2=80=AFAM Alexandr Moshkov
<dtalexundeer@yandex-team.ru> wrote:
>
> Currently do_vhost_virtqueue_stop always sends GET_VRING_BASE to the
> back-end, which requires the back-end to drain all in-flight I/O before
> stopping the vring.
>
> Add a skip_drain parameter to do_vhost_virtqueue_stop and propagate it
> up through vhost_virtqueue_stop, vhost_dev_stop and their callers.
> The parameter will be used in a follow-up commit to send a new protocol
> message that instructs the back-end to suspend in-flight I/O immediately
> instead of draining it.
>
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>  backends/cryptodev-vhost.c     |  2 +-
>  backends/vhost-user.c          |  2 +-
>  hw/block/vhost-user-blk.c      |  2 +-
>  hw/net/vhost_net.c             |  9 +++++----
>  hw/scsi/vhost-scsi-common.c    |  2 +-
>  hw/virtio/vdpa-dev.c           |  2 +-
>  hw/virtio/vhost-user-base.c    |  2 +-
>  hw/virtio/vhost-user-fs.c      |  2 +-
>  hw/virtio/vhost-user-scmi.c    |  2 +-
>  hw/virtio/vhost-vsock-common.c |  2 +-
>  hw/virtio/vhost.c              | 28 +++++++++++++++++++---------
>  include/hw/virtio/vhost.h      |  7 +++++--
>  12 files changed, 38 insertions(+), 24 deletions(-)
>
> diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
> index c6069f4e5b..f1ca6bcd4e 100644
> --- a/backends/cryptodev-vhost.c
> +++ b/backends/cryptodev-vhost.c
> @@ -109,7 +109,7 @@ static void
>  cryptodev_vhost_stop_one(CryptoDevBackendVhost *crypto,
>                                   VirtIODevice *dev)
>  {
> -    vhost_dev_stop(&crypto->dev, dev, false);
> +    vhost_dev_stop(&crypto->dev, dev, false, false);
>      vhost_dev_disable_notifiers(&crypto->dev, dev);
>  }
>
> diff --git a/backends/vhost-user.c b/backends/vhost-user.c
> index 380d825023..0423c2d4ec 100644
> --- a/backends/vhost-user.c
> +++ b/backends/vhost-user.c
> @@ -108,7 +108,7 @@ vhost_user_backend_stop(VhostUserBackend *b)
>          return 0;
>      }
>
> -    ret =3D vhost_dev_stop(&b->dev, b->vdev, true);
> +    ret =3D vhost_dev_stop(&b->dev, b->vdev, true, false);
>
>      if (k->set_guest_notifiers &&
>          (err =3D k->set_guest_notifiers(qbus->parent, b->dev.nvqs, false=
)) < 0) {
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index b2e46eb3f9..e3b873af7c 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -232,7 +232,7 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>                   qemu_force_shutdown_requested();
>
>      ret =3D force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
> -                       vhost_dev_stop(&s->dev, vdev, true);
> +                       vhost_dev_stop(&s->dev, vdev, true, false);
>
>      err =3D k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
>      if (err < 0) {
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index 323d117735..6e05c995f1 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -384,7 +384,7 @@ fail:
>      if (net->nc->info->poll) {
>          net->nc->info->poll(net->nc, true);
>      }
> -    vhost_dev_stop(&net->dev, dev, false);
> +    vhost_dev_stop(&net->dev, dev, false, false);
>  fail_start:
>      return r;
>  }
> @@ -403,7 +403,7 @@ static void vhost_net_stop_one(struct vhost_net *net,
>      if (net->nc->info->poll) {
>          net->nc->info->poll(net->nc, true);
>      }
> -    vhost_dev_stop(&net->dev, dev, false);
> +    vhost_dev_stop(&net->dev, dev, false, false);
>      if (net->nc->info->stop) {
>          net->nc->info->stop(net->nc);
>      }
> @@ -636,7 +636,8 @@ void vhost_net_virtqueue_reset(VirtIODevice *vdev, Ne=
tClientState *nc,
>      vhost_virtqueue_stop(&net->dev,
>                           vdev,
>                           net->dev.vqs + idx,
> -                         net->dev.vq_index + idx);
> +                         net->dev.vq_index + idx,
> +                         false);
>  }
>
>  int vhost_net_virtqueue_restart(VirtIODevice *vdev, NetClientState *nc,
> @@ -686,7 +687,7 @@ err_start:
>          assert(ret >=3D 0);
>      }
>
> -    vhost_dev_stop(&net->dev, vdev, false);
> +    vhost_dev_stop(&net->dev, vdev, false, false);
>
>      return r;
>  }
> diff --git a/hw/scsi/vhost-scsi-common.c b/hw/scsi/vhost-scsi-common.c
> index e19800a0bc..e546a6dc75 100644
> --- a/hw/scsi/vhost-scsi-common.c
> +++ b/hw/scsi/vhost-scsi-common.c
> @@ -108,7 +108,7 @@ int vhost_scsi_common_stop(VHostSCSICommon *vsc)
>      VirtioBusClass *k =3D VIRTIO_BUS_GET_CLASS(qbus);
>      int ret =3D 0;
>
> -    ret =3D vhost_dev_stop(&vsc->dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vsc->dev, vdev, true, false);
>
>      if (k->set_guest_notifiers) {
>          int r =3D k->set_guest_notifiers(qbus->parent, vsc->dev.nvqs, fa=
lse);
> diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
> index 94188d37bb..b86d0b664a 100644
> --- a/hw/virtio/vdpa-dev.c
> +++ b/hw/virtio/vdpa-dev.c
> @@ -300,7 +300,7 @@ static void vhost_vdpa_device_stop(VirtIODevice *vdev=
)
>          return;
>      }
>
> -    vhost_dev_stop(&s->dev, vdev, false);
> +    vhost_dev_stop(&s->dev, vdev, false, false);
>
>      ret =3D k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false);
>      if (ret < 0) {
> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> index 39b5e637fc..abeae1a064 100644
> --- a/hw/virtio/vhost-user-base.c
> +++ b/hw/virtio/vhost-user-base.c
> @@ -78,7 +78,7 @@ static int vub_stop(VirtIODevice *vdev)
>          return 0;
>      }
>
> -    ret =3D vhost_dev_stop(&vub->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vub->vhost_dev, vdev, true, false);
>
>      err =3D k->set_guest_notifiers(qbus->parent, vub->vhost_dev.nvqs, fa=
lse);
>      if (err < 0) {
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index 209993918a..0d8842817a 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -111,7 +111,7 @@ static int vuf_stop(VirtIODevice *vdev)
>          return 0;
>      }
>
> -    ret =3D vhost_dev_stop(&fs->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&fs->vhost_dev, vdev, true, false);
>
>      err =3D k->set_guest_notifiers(qbus->parent, fs->vhost_dev.nvqs, fal=
se);
>      if (err < 0) {
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index 9470f68c1f..9fa65d7d8b 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -101,7 +101,7 @@ static int vu_scmi_stop(VirtIODevice *vdev)
>          return 0;
>      }
>
> -    ret =3D vhost_dev_stop(vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(vhost_dev, vdev, true, false);
>
>      err =3D k->set_guest_notifiers(qbus->parent, vhost_dev->nvqs, false)=
;
>      if (err < 0) {
> diff --git a/hw/virtio/vhost-vsock-common.c b/hw/virtio/vhost-vsock-commo=
n.c
> index b79f4c9ce6..4ef037627b 100644
> --- a/hw/virtio/vhost-vsock-common.c
> +++ b/hw/virtio/vhost-vsock-common.c
> @@ -106,7 +106,7 @@ int vhost_vsock_common_stop(VirtIODevice *vdev)
>          return 0;
>      }
>
> -    ret =3D vhost_dev_stop(&vvc->vhost_dev, vdev, true);
> +    ret =3D vhost_dev_stop(&vvc->vhost_dev, vdev, true, false);
>
>      err =3D k->set_guest_notifiers(qbus->parent, vvc->vhost_dev.nvqs, fa=
lse);
>      if (err < 0) {
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index af41841b52..2a62550222 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -23,6 +23,7 @@
>  #include "qemu/log.h"
>  #include "standard-headers/linux/vhost_types.h"
>  #include "hw/virtio/virtio-bus.h"
> +#include "hw/virtio/vhost-user.h"
>  #include "hw/mem/memory-device.h"
>  #include "migration/blocker.h"
>  #include "migration/qemu-file-types.h"
> @@ -1496,8 +1497,13 @@ fail:
>  static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
>                                     struct VirtIODevice *vdev,
>                                     struct vhost_virtqueue *vq,
> -                                   unsigned idx, bool force)
> +                                   unsigned idx, bool force,
> +                                   bool skip_drain)
>  {
> +    if (skip_drain) {
> +        assert(vhost_user_has_protocol_feature(dev,
> +               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
> +    }

FYI, with only `--disable-vhost-user` configuration, this line
triggers a link error:
  | undefined reference to `vhost_user_has_protocol_feature'

Disabling all vhosts (so vhost-user, vhost-vdpa and vhost-kernel) was
enough to fix it.

Cl=C3=A9ment

>      int vhost_vq_index =3D dev->vhost_ops->vhost_get_vq_index(dev, idx);
>      struct vhost_vring_state state =3D {
>          .index =3D vhost_vq_index,
> @@ -1547,9 +1553,10 @@ static int do_vhost_virtqueue_stop(struct vhost_de=
v *dev,
>  int vhost_virtqueue_stop(struct vhost_dev *dev,
>                           struct VirtIODevice *vdev,
>                           struct vhost_virtqueue *vq,
> -                         unsigned idx)
> +                         unsigned idx,
> +                         bool skip_drain)
>  {
> -    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false);
> +    return do_vhost_virtqueue_stop(dev, vdev, vq, idx, false, skip_drain=
);
>  }
>
>  static int vhost_virtqueue_set_busyloop_timeout(struct vhost_dev *dev,
> @@ -2302,7 +2309,8 @@ fail_vq:
>          vhost_virtqueue_stop(hdev,
>                               vdev,
>                               hdev->vqs + i,
> -                             hdev->vq_index + i);
> +                             hdev->vq_index + i,
> +                             false);
>      }
>
>  fail_mem:
> @@ -2317,7 +2325,7 @@ fail_features:
>
>  /* Host notifiers must be enabled at this point. */
>  static int do_vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
> -                             bool vrings, bool force)
> +                             bool vrings, bool force, bool skip_drain)
>  {
>      int i;
>      int rc =3D 0;
> @@ -2344,7 +2352,8 @@ static int do_vhost_dev_stop(struct vhost_dev *hdev=
, VirtIODevice *vdev,
>                                        vdev,
>                                        hdev->vqs + i,
>                                        hdev->vq_index + i,
> -                                      force);
> +                                      force,
> +                                      skip_drain);
>      }
>      if (hdev->vhost_ops->vhost_reset_status) {
>          hdev->vhost_ops->vhost_reset_status(hdev);
> @@ -2366,15 +2375,16 @@ static int do_vhost_dev_stop(struct vhost_dev *hd=
ev, VirtIODevice *vdev,
>      return rc;
>  }
>
> -int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs)
> +int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs,
> +                   bool skip_drain)
>  {
> -    return do_vhost_dev_stop(hdev, vdev, vrings, false);
> +    return do_vhost_dev_stop(hdev, vdev, vrings, false, skip_drain);
>  }
>
>  int vhost_dev_force_stop(struct vhost_dev *hdev, VirtIODevice *vdev,
>                           bool vrings)
>  {
> -    return do_vhost_dev_stop(hdev, vdev, vrings, true);
> +    return do_vhost_dev_stop(hdev, vdev, vrings, true, false);
>  }
>
>  int vhost_net_set_backend(struct vhost_dev *hdev,
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 684bafcaad..33b88f95ea 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -228,6 +228,7 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODev=
ice *vdev, bool vrings);
>   * @hdev: common vhost_dev structure
>   * @vdev: the VirtIODevice structure
>   * @vrings: true to have vrings disabled in this call
> + * @skip_drain: true to notice back-end to skip draining all in-flight r=
equests
>   *
>   * Stop the vhost device. After the device is stopped the notifiers
>   * can be disabled (@vhost_dev_disable_notifiers) and the device can
> @@ -235,7 +236,8 @@ int vhost_dev_start(struct vhost_dev *hdev, VirtIODev=
ice *vdev, bool vrings);
>   *
>   * Return: 0 on success, !=3D 0 on error when stopping dev.
>   */
> -int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs);
> +int vhost_dev_stop(struct vhost_dev *hdev, VirtIODevice *vdev, bool vrin=
gs,
> +                   bool skip_drain);
>
>  /**
>   * vhost_dev_force_stop() - force stop the vhost device
> @@ -393,7 +395,8 @@ int vhost_device_iotlb_miss(struct vhost_dev *dev, ui=
nt64_t iova, int write);
>  int vhost_virtqueue_start(struct vhost_dev *dev, struct VirtIODevice *vd=
ev,
>                            struct vhost_virtqueue *vq, unsigned idx);
>  int vhost_virtqueue_stop(struct vhost_dev *dev, struct VirtIODevice *vde=
v,
> -                         struct vhost_virtqueue *vq, unsigned idx);
> +                         struct vhost_virtqueue *vq, unsigned idx,
> +                         bool skip_drain);
>
>  void vhost_dev_reset_inflight(struct vhost_inflight *inflight);
>  void vhost_dev_free_inflight(struct vhost_inflight *inflight);
> --
> 2.34.1
>
>
