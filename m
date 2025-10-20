Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA2A2DEA67
	for <virtio-fs@lists.linux.dev>; Mon, 20 Oct 2025 23:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761002420; cv=none; b=Y3tcGYCS3HdxvtQnmyDt0rTmdZhMm/l8vIOy6G7ZSzJWjLF8yXe0vf+LPr7a4GJeXui7PykD37cc1tzyqnmrT/oSutDS2OJnzEGJ7WkyUNfkFXLVCQTbZRkS7p2xKxIT/tJmYOW2Jc19bHsSFb2t77mHkuJlSuVpnGG6IMi3RsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761002420; c=relaxed/simple;
	bh=PKEZ/N8OO5+hkH5FyopHDc+wVUZ331IAFJOl1o55zao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tKEEfAX0VUDX9lyD+eFmoKeOoCFe07fB5R7Ej7s74rhR+f240A7UA0rD88IQARLV4CKU6pCVi0Ynxo0K4B2h/nTYb80+KI+24vsk5F9hiF184uui4NvSYZXT4ZxpGry7z/++bZQckGvkfWZ33skPB8btIqtDvfohallXzMtNXNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmylCX/y; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmylCX/y"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-424da17e309so52924425ab.2
        for <virtio-fs@lists.linux.dev>; Mon, 20 Oct 2025 16:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761002417; x=1761607217; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TcRuxB7BFbTkuNwyukQvNeIqPVv/XDCFAmnD9HuVGf8=;
        b=UmylCX/y/AmM4KdbTYQFZWLMSPPpQGb/c3UHVvKrM61SIThGgXXH8F4lHpSYxJ6G4j
         PnOWhavtqOOpcLqzvcXB1ZOl5T8PYav+Xq9iF/E+/SO73IoCuxhIxc4vo/ZwIQHubw44
         tE3Zkh2OuA0ygNu8A1ZI2LssmZw8aljv/ToID7Kqbnl+yVG6kuqA9Y+eZpeyaZ1VFwAr
         LNls84+wGfX62qcU4ldfWLnfKioq17sB3pdq1UKDu4zk7yVXSXCb3RheZ4z5sFijfT7O
         MaOP8aG2S6lOGPb2+CRB9wjPm6jZOQOn5OD9RcqNN58TV5ICAXPuTTJ9OylxM6Ha0K7E
         At4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761002417; x=1761607217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TcRuxB7BFbTkuNwyukQvNeIqPVv/XDCFAmnD9HuVGf8=;
        b=TO8JkkZ1z+KHkIasz4tzEy8VDlun3PF6VRtgErs/jNUpdO2/FbdV3Ow3jXkDj2YHEz
         G1ozLbsb6sCOjtyaXGAIuBaupHmejGorek5WsaiAKE4vLVQHEBrgBSP3aAbtdbUuXJcC
         qVLDddQziD/P7DiPuxP+rXgH5Tw2l3+tQbFWaqgjirOjnYrZKTgSuyJ/UMCk+VMf49VC
         v4zmsgRFmndcez+xsy0bOoQF143Plvy6gfn1lV0p9tiqsTjOOTE0oTz9nkRNi2jpOeq/
         Vx/eADnGMOSIxHlYgpU2k8rSGNl+Anf0HluzD5arE//FzBx/2NwA3OKxA0CQXXelXvqQ
         pdoQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/qyNuqDyz0aaVy8qQ60c+bRooDZqYvnlfVKJSvQDCrFRRuMGdhS5jDqf0WJujoc4eS2VepxYevIc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy4HXiEB2ZZXEnBPNCJPahKruAJvYePv6k1IGqoNPP3HZS0ULiF
	bgvDfdCNfPOdikxEq3iRtgK+G3AyxyIuFcCaytMelSfMkTL0wBp3Dykq+upZnhL8pvV2wjz95z5
	ZHFvoVbTM69Cfo0AFo9mCsoIOqWyhyRk=
X-Gm-Gg: ASbGncsd4SRyLwwYNTwvgR2Ttc+auNO+tPmFGK0bq6DfUcyP6l9F5laqIivJqrOD5XN
	okE+zd3jdm4oC/gWM9xeMXsl/7gj6PYvKcBp6C6drgyv8sk0X5wh/vps54fs6BshgEaYjzDGji4
	QFj0iPLLqM7uArwFBFyiGsr3Bs5V+Oz8CvzA+WecGDLRyBDtt3pkiPvNoErjkncuZI+HF8FSi+o
	PkWf4csKu2/bAtlqyJNRAHXJmHti+gz2b3asMxFr0sfE6RDxrTe654VwsMqlrVKdc5CaCM=
X-Google-Smtp-Source: AGHT+IHnKbGUCf+XFp7VspVAeNdoU/G15aC6ghBVr+XwZ6SWri0iXskyRlADb4YVAMEJuB7qftj+joEAJewZUrWMCvc=
X-Received: by 2002:a05:6e02:1a66:b0:42d:8acf:a6e2 with SMTP id
 e9e14a558f8ab-430c5269283mr247280615ab.15.1761002417353; Mon, 20 Oct 2025
 16:20:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251016114104.1384675-1-vsementsov@yandex-team.ru> <20251016114104.1384675-5-vsementsov@yandex-team.ru>
In-Reply-To: <20251016114104.1384675-5-vsementsov@yandex-team.ru>
From: Raphael Norwitz <raphael.s.norwitz@gmail.com>
Date: Mon, 20 Oct 2025 19:20:05 -0400
X-Gm-Features: AS18NWCPpz2Hv9lG-gko4pjj75d6WpU2AjulZdk3cbbWB_AIHWvUySv2hLZnIIo
Message-ID: <CAFubqFuFkxWM5PNuX_p3=j-K6fXvhRWhvo7tr3yWL=HAyhY0pg@mail.gmail.com>
Subject: Re: [PATCH v2 04/25] vhost: add connect parameter to vhost_dev_init()
To: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
Cc: raphael@enfabrica.net, pbonzini@redhat.com, farosas@suse.de, 
	mst@redhat.com, sgarzare@redhat.com, marcandre.lureau@redhat.com, 
	kwolf@redhat.com, hreitz@redhat.com, berrange@redhat.com, eblake@redhat.com, 
	armbru@redhat.com, qemu-devel@nongnu.org, qemu-block@nongnu.org, 
	steven.sistare@oracle.com, yc-core@yandex-team.ru, d-tatianin@yandex-team.ru, 
	jasowang@redhat.com, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	Zhenwei Pi <pizhenwei@bytedance.com>, Fam Zheng <fam@euphon.net>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "reviewer:vhost-user-scmi" <mzamazal@redhat.com>, 
	"open list:virtiofs" <virtio-fs@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks ok, just a comment typo which is deleted in a subsequent commit.

Reviewed-by: Raphael Norwitz <raphael.s.norwitz@gmail.com>

On Thu, Oct 16, 2025 at 7:47=E2=80=AFAM Vladimir Sementsov-Ogievskiy
<vsementsov@yandex-team.ru> wrote:
>
> We are going to split vhost_dev_init() so that the first part will do
> early initialization of QEMU structures, but don't communicate with
> backend, and the second part will do backend communication. We need
> this for future support for backend-transfer migration support for
> vhost-user-blk (backend will not be available in the early
> initialization point).
>
> With this commit we introduce boolean parameter for vhost_dev_init(),
> so callers may chose, do they want "init + connect" (which is current
> behavior, so all callers pass true), or caller may want "only init",
> and call vhost_dev_connect() later. vhost_dev_connect(), as well
> as support for connect=3Dfalse will be added in further commits.
>
> Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
> ---
>  backends/cryptodev-vhost.c        |  2 +-
>  backends/vhost-user.c             |  2 +-
>  hw/block/vhost-user-blk.c         |  2 +-
>  hw/net/vhost_net.c                |  2 +-
>  hw/scsi/vhost-scsi.c              |  2 +-
>  hw/scsi/vhost-user-scsi.c         |  2 +-
>  hw/virtio/vdpa-dev.c              |  3 ++-
>  hw/virtio/vhost-user-base.c       |  2 +-
>  hw/virtio/vhost-user-fs.c         |  2 +-
>  hw/virtio/vhost-user-scmi.c       |  2 +-
>  hw/virtio/vhost-user-vsock.c      |  2 +-
>  hw/virtio/vhost-vsock.c           |  2 +-
>  hw/virtio/vhost.c                 | 11 ++++++++++-
>  include/hw/virtio/vhost-backend.h |  2 ++
>  include/hw/virtio/vhost.h         |  3 ++-
>  15 files changed, 27 insertions(+), 14 deletions(-)
>
> diff --git a/backends/cryptodev-vhost.c b/backends/cryptodev-vhost.c
> index c6069f4e5b..b4dafb4062 100644
> --- a/backends/cryptodev-vhost.c
> +++ b/backends/cryptodev-vhost.c
> @@ -66,7 +66,7 @@ cryptodev_vhost_init(
>      crypto->dev.vq_index =3D crypto->cc->queue_index * crypto->dev.nvqs;
>
>      r =3D vhost_dev_init(&crypto->dev, options->opaque, options->backend=
_type, 0,
> -                       &local_err);
> +                       true, &local_err);
>      if (r < 0) {
>          error_report_err(local_err);
>          goto fail;
> diff --git a/backends/vhost-user.c b/backends/vhost-user.c
> index 42845329e7..e65ba7b648 100644
> --- a/backends/vhost-user.c
> +++ b/backends/vhost-user.c
> @@ -37,7 +37,7 @@ vhost_user_backend_dev_init(VhostUserBackend *b, VirtIO=
Device *vdev,
>      b->dev.vqs =3D g_new0(struct vhost_virtqueue, nvqs);
>
>      ret =3D vhost_dev_init(&b->dev, &b->vhost_user, VHOST_BACKEND_TYPE_U=
SER, 0,
> -                         errp);
> +                         true, errp);
>      if (ret < 0) {
>          return -1;
>      }
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index a5daed4346..a92426f18c 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -365,7 +365,7 @@ static int vhost_user_blk_connect(DeviceState *dev, E=
rror **errp)
>
>      s->vhost_user.supports_config =3D true;
>      ret =3D vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_U=
SER, 0,
> -                         errp);
> +                         true, errp);
>      if (ret < 0) {
>          return ret;
>      }
> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
> index 323d117735..c4526974fb 100644
> --- a/hw/net/vhost_net.c
> +++ b/hw/net/vhost_net.c
> @@ -274,7 +274,7 @@ struct vhost_net *vhost_net_init(VhostNetOptions *opt=
ions)
>
>      r =3D vhost_dev_init(&net->dev, options->opaque,
>                         options->backend_type, options->busyloop_timeout,
> -                       &local_err);
> +                       true, &local_err);
>      if (r < 0) {
>          error_report_err(local_err);
>          goto fail;
> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> index d694a25fe2..d187c705d8 100644
> --- a/hw/scsi/vhost-scsi.c
> +++ b/hw/scsi/vhost-scsi.c
> @@ -278,7 +278,7 @@ static void vhost_scsi_realize(DeviceState *dev, Erro=
r **errp)
>      vsc->dev.vq_index =3D 0;
>
>      ret =3D vhost_dev_init(&vsc->dev, (void *)(uintptr_t)vhostfd,
> -                         VHOST_BACKEND_TYPE_KERNEL, 0, errp);
> +                         VHOST_BACKEND_TYPE_KERNEL, 0, true, errp);
>      if (ret < 0) {
>          /*
>           * vhost_dev_init calls vhost_dev_cleanup on error, which closes
> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
> index 0c80a271d8..e121f2e259 100644
> --- a/hw/scsi/vhost-user-scsi.c
> +++ b/hw/scsi/vhost-user-scsi.c
> @@ -161,7 +161,7 @@ static int vhost_user_scsi_connect(DeviceState *dev, =
Error **errp)
>      vsc->dev.vq_index =3D 0;
>
>      ret =3D vhost_dev_init(&vsc->dev, &s->vhost_user, VHOST_BACKEND_TYPE=
_USER, 0,
> -                         errp);
> +                         true, errp);
>      if (ret < 0) {
>          return ret;
>      }
> diff --git a/hw/virtio/vdpa-dev.c b/hw/virtio/vdpa-dev.c
> index e1a2ff433d..b6b4ee7d38 100644
> --- a/hw/virtio/vdpa-dev.c
> +++ b/hw/virtio/vdpa-dev.c
> @@ -116,7 +116,8 @@ static void vhost_vdpa_device_realize(DeviceState *de=
v, Error **errp)
>      v->vdpa.shared->device_fd =3D v->vhostfd;
>      v->vdpa.shared->iova_range =3D iova_range;
>
> -    ret =3D vhost_dev_init(&v->dev, &v->vdpa, VHOST_BACKEND_TYPE_VDPA, 0=
, NULL);
> +    ret =3D vhost_dev_init(&v->dev, &v->vdpa, VHOST_BACKEND_TYPE_VDPA, 0=
, true,
> +                         NULL);
>      if (ret < 0) {
>          error_setg(errp, "vhost-vdpa-device: vhost initialization failed=
: %s",
>                     strerror(-ret));
> diff --git a/hw/virtio/vhost-user-base.c b/hw/virtio/vhost-user-base.c
> index cf311c3bfc..0768231a88 100644
> --- a/hw/virtio/vhost-user-base.c
> +++ b/hw/virtio/vhost-user-base.c
> @@ -334,7 +334,7 @@ static void vub_device_realize(DeviceState *dev, Erro=
r **errp)
>
>      /* connect to backend */
>      ret =3D vhost_dev_init(&vub->vhost_dev, &vub->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> +                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
>
>      if (ret < 0) {
>          do_vhost_user_cleanup(vdev, vub);
> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> index e77c69eb12..2a8eead90b 100644
> --- a/hw/virtio/vhost-user-fs.c
> +++ b/hw/virtio/vhost-user-fs.c
> @@ -256,7 +256,7 @@ static void vuf_device_realize(DeviceState *dev, Erro=
r **errp)
>      fs->vhost_dev.nvqs =3D 1 + fs->conf.num_request_queues;
>      fs->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, fs->vhost_dev.n=
vqs);
>      ret =3D vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> +                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
>      if (ret < 0) {
>          goto err_virtio;
>      }
> diff --git a/hw/virtio/vhost-user-scmi.c b/hw/virtio/vhost-user-scmi.c
> index f9264c4374..40e567c18a 100644
> --- a/hw/virtio/vhost-user-scmi.c
> +++ b/hw/virtio/vhost-user-scmi.c
> @@ -253,7 +253,7 @@ static void vu_scmi_device_realize(DeviceState *dev, =
Error **errp)
>      scmi->vhost_dev.vqs =3D g_new0(struct vhost_virtqueue, scmi->vhost_d=
ev.nvqs);
>
>      ret =3D vhost_dev_init(&scmi->vhost_dev, &scmi->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> +                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
>      if (ret < 0) {
>          error_setg_errno(errp, -ret,
>                           "vhost-user-scmi: vhost_dev_init() failed");
> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
> index 993c287348..b630af0fe7 100644
> --- a/hw/virtio/vhost-user-vsock.c
> +++ b/hw/virtio/vhost-user-vsock.c
> @@ -115,7 +115,7 @@ static void vuv_device_realize(DeviceState *dev, Erro=
r **errp)
>      vhost_dev_set_config_notifier(&vvc->vhost_dev, &vsock_ops);
>
>      ret =3D vhost_dev_init(&vvc->vhost_dev, &vsock->vhost_user,
> -                         VHOST_BACKEND_TYPE_USER, 0, errp);
> +                         VHOST_BACKEND_TYPE_USER, 0, true, errp);
>      if (ret < 0) {
>          goto err_virtio;
>      }
> diff --git a/hw/virtio/vhost-vsock.c b/hw/virtio/vhost-vsock.c
> index 107d88babe..3a4b2d924d 100644
> --- a/hw/virtio/vhost-vsock.c
> +++ b/hw/virtio/vhost-vsock.c
> @@ -166,7 +166,7 @@ static void vhost_vsock_device_realize(DeviceState *d=
ev, Error **errp)
>      vhost_vsock_common_realize(vdev);
>
>      ret =3D vhost_dev_init(&vvc->vhost_dev, (void *)(uintptr_t)vhostfd,
> -                         VHOST_BACKEND_TYPE_KERNEL, 0, errp);
> +                         VHOST_BACKEND_TYPE_KERNEL, 0, true, errp);
>      if (ret < 0) {
>          /*
>           * vhostfd is closed by vhost_dev_cleanup, which is called
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index 1998663461..f733e98b4a 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1617,7 +1617,7 @@ static bool check_memslots(struct vhost_dev *hdev, =
Error **errp)
>
>  int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
>                     VhostBackendType backend_type, uint32_t busyloop_time=
out,
> -                   Error **errp)
> +                   bool connect, Error **errp)
>  {
>      int i, r, n_initialized_vqs =3D 0;
>
> @@ -1634,6 +1634,15 @@ int vhost_dev_init(struct vhost_dev *hdev, void *o=
paque,
>      r =3D vhost_set_backend_type(hdev, backend_type);
>      assert(r >=3D 0);
>
> +    /*
> +     * Postponed connect only supported for devices with
> +     * .vhost_backend_connect handler
> +     */
> +    assert(connect || hdev->vhost_ops->vhost_backend_connect);
> +

nit: TODO

> +    /* TDDO: support connect=3Dfalse */
> +    assert(connect);
> +
>      r =3D hdev->vhost_ops->vhost_backend_init(hdev, opaque, errp);
>      if (r < 0) {
>          goto fail;
> diff --git a/include/hw/virtio/vhost-backend.h b/include/hw/virtio/vhost-=
backend.h
> index ff94fa1734..d3f055f95e 100644
> --- a/include/hw/virtio/vhost-backend.h
> +++ b/include/hw/virtio/vhost-backend.h
> @@ -53,6 +53,7 @@ struct vhost_virtqueue;
>
>  typedef int (*vhost_backend_init)(struct vhost_dev *dev, void *opaque,
>                                    Error **errp);
> +typedef int (*vhost_backend_connect)(struct vhost_dev *dev, Error **errp=
);
>  typedef int (*vhost_backend_cleanup)(struct vhost_dev *dev);
>  typedef int (*vhost_backend_memslots_limit)(struct vhost_dev *dev);
>
> @@ -167,6 +168,7 @@ typedef int (*vhost_check_device_state_op)(struct vho=
st_dev *dev, Error **errp);
>  typedef struct VhostOps {
>      VhostBackendType backend_type;
>      vhost_backend_init vhost_backend_init;
> +    vhost_backend_connect vhost_backend_connect;
>      vhost_backend_cleanup vhost_backend_cleanup;
>      vhost_backend_memslots_limit vhost_backend_memslots_limit;
>      vhost_backend_no_private_memslots_op vhost_backend_no_private_memslo=
ts;
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index f1a7e7b971..74ed24232e 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -155,7 +155,8 @@ struct vhost_net {
>   */
>  int vhost_dev_init(struct vhost_dev *hdev, void *opaque,
>                     VhostBackendType backend_type,
> -                   uint32_t busyloop_timeout, Error **errp);
> +                   uint32_t busyloop_timeout,
> +                   bool connect, Error **errp);
>
>  /**
>   * vhost_dev_cleanup() - tear down and cleanup vhost interface
> --
> 2.48.1
>
>
