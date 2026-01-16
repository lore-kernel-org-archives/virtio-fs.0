Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E2229A9C9
	for <virtio-fs@lists.linux.dev>; Fri, 16 Jan 2026 19:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768593058; cv=pass; b=uzMNWc/BETxOXYtcIsvflZiJdDh3/pGiTMBb+WK/AbzOL6WKqq7tuhE9lIymGSxLJLavRTVl1sHfyiTB6zteM0AwFAQHUI90rSGV+WyyYjGaegG1KfkSTJCtDUJDgjYQoyy7AInTW/9qp5wpPkcG/2w56pAwOjd3vcQnckheis0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768593058; c=relaxed/simple;
	bh=MSOvt3C4S9YqtmMDRBthcUWP1pPAo5gHCqlBJ8nPqSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gSUSKqEpKdcQ9nx0OHJ6eVfxd/bj0C2q7gJUMd9jxAaGY0gzCLX/XXTpguaDwCnXhapLNahKwVhvX75rLpgolJCyQgWFMM+cgaFvOgzxdYdWe7S9HwYzyVvQZApzpw0wHttD3lheO1Eq66Hx1Te+z4ow0BT7e78AfrYm+iNczfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mJXdFboA; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mJXdFboA"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-65f59501dacso1779239eaf.0
        for <virtio-fs@lists.linux.dev>; Fri, 16 Jan 2026 11:50:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768593056; cv=none;
        d=google.com; s=arc-20240605;
        b=QBqm2hBpf9w0pmHqYo+b/JeGE/Wwy/KphUj6P2ztmM6CwQYTbuwK+YWwrCjRzKYBWE
         x09LewCspJ93gyUWKsRVNWjAAyhgDyxmbA0FA3NNsUOS/Fl96QESvqPgOMcmVTl5AwkA
         K/+AZMfi9gi5JiDPKWcE2PDa9r3ZpwrRbwmtQN7ZV391bUeFI5JtcDBZaH6ZSvJtGl+B
         FJRHsKhP//pE3gUh6ys6t3VWuvSZ6zrQPYRYOqzE9ykCQdvwbZT0GeubWTq264TUgyC3
         5RC5nDuVlvYDT05eUkOzsxkd2wJlYCx9vGNnuZEVFMQmr57blvOai/ntmupFwB+wjdaU
         QumA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=teDDPgMWHLMcsEK7YMG91On4831FNcIesgnPi/nB9tM=;
        fh=RfqPH14tyzz0+HRLAnk0+NVlygzVXKr/pbE2heinTd0=;
        b=RntbJxIthNE0iNHn1kIwIfo/5bg1vpSDejupdSoKqei1i4Q9fsSpMsR8yfH/jKKhWg
         d04oVhStgjA76gVtr/Bb5hcZOpj81JSVhA4WmPuRKTF2SKQxyt0SPBAvZHnkiiUiGlT1
         7UIxGwB+ViZdlN/51iILdt/GeMrtT3OGHscK2mJRlWNY6+bhr0KBqNgmd5PHtvLcgqtL
         +TvtLSKui6mSwp9tAEorHIUlkW+FAAu9Gttng4ksqIGR0zGl+N/8/BdXJtXGw1ZShCXB
         JNt8kqz7XKS/MqxnPM/M0WkQhIsibRY/mzNeFRsSJgXZ+u4QLDVzptgL7KDAWYvAxN/E
         uzbg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768593056; x=1769197856; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teDDPgMWHLMcsEK7YMG91On4831FNcIesgnPi/nB9tM=;
        b=mJXdFboA3Uyxb0EWSBwEj9GvIfc7qJNa0W2yIFAgY6H6iOo/38Ns66YVX7gtVjijJt
         NoT0rpAEK4jrctb9JeLUBwKZAVm1mdKLy5mM6VhRNzBYlgSR663QZq4DRsddcPCAG8SD
         nC85fAfwiz3wUsgRBqy5qJL5TWnH99UiNc7mgtrUxMqoXD54ukEJYaZNOHX879EIx0C5
         nB0SDdAIy+ij25+tfRX6KaUgQ7kDgtVy9ROqOKFhq+0a1TTgpnrYD3bcPcDqm77/jCPf
         26bYASjeOWz/r0cqbUie376+gnZzN81neW+h7jO9Cx2SkbnMjefhKmOKoSQfbVW7u8lv
         YQ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768593056; x=1769197856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=teDDPgMWHLMcsEK7YMG91On4831FNcIesgnPi/nB9tM=;
        b=AVrnbzABPf/lFy2ws5MccJMlxy7DOzC0O/aPerVe/j7HSz9fQsqy72FfEDOn16vXKb
         EK2G2i6XI1y745rXczFPGN72HQYG6itU22LJf3lhH4NVep78JW0kEMjz5W+sUzQksegO
         qOk7QAorbXt3TW4FzjShHQEavGFHasEXg6DAGnKgLzPdOKuaY1be3fHPlA6dM800XtIx
         FpPCaRi3TcDttSq3qaVLUUIX+CNm7Fu4ppvBSYyrwn3lFTs9Egzl0EFBjyIDNTZmzaQ/
         7xv2R9wvPuZv9NLDnu2Ao0vjc+hkh9UQ9GLqF7bHyIio+/RjeB9qG8J3fg7CflKe5dgJ
         2/rw==
X-Forwarded-Encrypted: i=1; AJvYcCXpruifT+et/IAuzeiUO4vlaC9WZvf2DTZEX0BBZuFE3l7osrJdGLg6iRra3cR2pq/5oErvINeAcnM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIHHXLHOaqTvKmfe3mnOXzxBC+llcra0A+EhgdNxm2JYzozzg7
	UEZ3sXRuBcB0MUBj4dPkRHoU+c6HvSt4p3DMYg74JfLYLN0KuPzXpPMUeamsb69J/3mEOewCkhf
	PKpn4eCO1mlqxbjkTYWiyfXr4eCeIwnw=
X-Gm-Gg: AY/fxX5Wj3o0WoHKu2trvijhH5EmTS9I0dKfidRGzIznDsoZgLQpI2ClDVYgcTzifrS
	bdIKLvRZ0HCUtWI/0Zwn0lfsHIVDHj6KxoZOwMzMRfnqJ39kPvV0qAhj2meEHlj2qRxHD4H1WTn
	Xm6cnK4da5pnaIpfZcHmLMv14s/yESMxnIhQIPXB0hJAR8PUIBJXK0dooqMFjnPETx3FZw3V/JG
	qJwSeuYR9ticdRKh1ukiE/+k+3M3aiPrLDkJVO9UoBp1VLaiSHB0tRGxk+VopHS+ob7hAzFD+mI
	sZF0DkPLXF/NlIsHGZ6yR4XYDA==
X-Received: by 2002:a05:6820:174a:b0:65e:f37f:93a4 with SMTP id
 006d021491bc7-66117959c64mr1764198eaf.8.1768593056108; Fri, 16 Jan 2026
 11:50:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115081103.655749-1-dtalexundeer@yandex-team.ru> <20260115081103.655749-6-dtalexundeer@yandex-team.ru>
In-Reply-To: <20260115081103.655749-6-dtalexundeer@yandex-team.ru>
From: Raphael Norwitz <raphael.s.norwitz@gmail.com>
Date: Fri, 16 Jan 2026 14:50:45 -0500
X-Gm-Features: AZwV_QiMN4DGVtzxgAKEZgmhbOBLU-3A6_s5nR0j38K8nCOVb7nHf8zJ0wBplr8
Message-ID: <CAFubqFtKrsPn++kMPEAOO2LdygY9BZyDmzb0nU7YbK1on2GNCw@mail.gmail.com>
Subject: Re: [PATCH v7 5/5] vhost-user-blk: support inter-host inflight migration
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	Zhenwei Pi <pizhenwei@bytedance.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Raphael Norwitz <raphael@enfabrica.net>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, mzamazal@redhat.com, Peter Xu <peterx@redhat.com>, 
	Fabiano Rosas <farosas@suse.de>, qemu-block@nongnu.org, virtio-fs@lists.linux.dev, 
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, Eric Blake <eblake@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Apologies if I've missed something obvious here - what actually skips
the GET_VRING_BASE operation here? I was expecting something like:

--- a/hw/block/vhost-user-blk.c
+++ b/hw/block/vhost-user-blk.c
@@ -221,8 +221,9 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
         return 0;
     }

-    force_stop =3D s->skip_get_vring_base_on_force_shutdown &&
-                 qemu_force_shutdown_requested();
+    force_stop =3D (s->skip_get_vring_base_on_force_shutdown &&
+                 qemu_force_shutdown_requested()) ||
+                 s->inflight_migration; // FIXME: runstate check?

Without setting force_stop in vhost_user_blk_stop() I don't see how
the GET_VRING_BASE operation would be skipped.

On Thu, Jan 15, 2026 at 3:13=E2=80=AFAM Alexandr Moshkov
<dtalexundeer@yandex-team.ru> wrote:
>
> During inter-host migration, waiting for disk requests to be drained
> in the vhost-user backend can incur significant downtime.
>
> This can be avoided if QEMU migrates the inflight region in
> vhost-user-blk.
> Thus, during the qemu migration, with feature flag the vhost-user
> back-end can immediately stop vrings, so all in-flight requests will be
> migrated to another host.
>
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>  hw/block/vhost-user-blk.c          | 27 +++++++++++++++++++++++++++
>  include/hw/virtio/vhost-user-blk.h |  1 +
>  include/hw/virtio/vhost.h          |  6 ++++++
>  3 files changed, 34 insertions(+)
>
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 4d81d2dc34..c151e83677 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -353,6 +353,7 @@ static int vhost_user_blk_connect(DeviceState *dev, E=
rror **errp)
>      vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>
>      s->vhost_user.supports_config =3D true;
> +    s->vhost_user.supports_inflight_migration =3D s->inflight_migration;
>      ret =3D vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_U=
SER, 0,
>                           errp);
>      if (ret < 0) {
> @@ -568,6 +569,26 @@ static struct vhost_dev *vhost_user_blk_get_vhost(Vi=
rtIODevice *vdev)
>      return &s->dev;
>  }
>
> +static bool vhost_user_blk_inflight_needed(void *opaque)
> +{
> +    struct VHostUserBlk *s =3D opaque;
> +
> +    bool inflight_migration =3D virtio_has_feature(s->dev.protocol_featu=
res,
> +                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFL=
IGHT);
> +
> +    return inflight_migration;
> +}
> +
> +static const VMStateDescription vmstate_vhost_user_blk_inflight =3D {
> +    .name =3D "vhost-user-blk/inflight",
> +    .version_id =3D 1,
> +    .needed =3D vhost_user_blk_inflight_needed,
> +    .fields =3D (const VMStateField[]) {
> +        VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
> +        VMSTATE_END_OF_LIST()
> +    },
> +};
> +
>  static const VMStateDescription vmstate_vhost_user_blk =3D {
>      .name =3D "vhost-user-blk",
>      .minimum_version_id =3D 1,
> @@ -576,6 +597,10 @@ static const VMStateDescription vmstate_vhost_user_b=
lk =3D {
>          VMSTATE_VIRTIO_DEVICE,
>          VMSTATE_END_OF_LIST()
>      },
> +    .subsections =3D (const VMStateDescription * const []) {
> +        &vmstate_vhost_user_blk_inflight,
> +        NULL
> +    }
>  };
>
>  static const Property vhost_user_blk_properties[] =3D {
> @@ -591,6 +616,8 @@ static const Property vhost_user_blk_properties[] =3D=
 {
>                        VIRTIO_BLK_F_WRITE_ZEROES, true),
>      DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserB=
lk,
>                       skip_get_vring_base_on_force_shutdown, false),
> +    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> +                     inflight_migration, false),
>  };
>
>  static void vhost_user_blk_class_init(ObjectClass *klass, const void *da=
ta)
> diff --git a/include/hw/virtio/vhost-user-blk.h b/include/hw/virtio/vhost=
-user-blk.h
> index 8158d4673d..1e41a2bcdf 100644
> --- a/include/hw/virtio/vhost-user-blk.h
> +++ b/include/hw/virtio/vhost-user-blk.h
> @@ -52,6 +52,7 @@ struct VHostUserBlk {
>      bool started_vu;
>
>      bool skip_get_vring_base_on_force_shutdown;
> +    bool inflight_migration;
>  };
>
>  #endif
> diff --git a/include/hw/virtio/vhost.h b/include/hw/virtio/vhost.h
> index 08bbb4dfe9..89817bd848 100644
> --- a/include/hw/virtio/vhost.h
> +++ b/include/hw/virtio/vhost.h
> @@ -554,4 +554,10 @@ static inline int vhost_load_backend_state(struct vh=
ost_dev *dev, QEMUFile *f,
>  }
>  #endif
>
> +extern const VMStateDescription vmstate_vhost_inflight_region;
> +#define VMSTATE_VHOST_INFLIGHT_REGION(_field, _state) \
> +    VMSTATE_STRUCT_POINTER(_field, _state, \
> +                           vmstate_vhost_inflight_region, \
> +                           struct vhost_inflight)
> +
>  #endif
> --
> 2.34.1
>
>
