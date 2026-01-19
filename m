Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36D5242D83
	for <virtio-fs@lists.linux.dev>; Mon, 19 Jan 2026 23:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768864516; cv=pass; b=max5xRKssxIj0mBJqKK/fJ4XWgIVuOTReYHXkxx9D53AlGBLqm9KG79W8SB4tjL8diIYanFPyVOQBgRsPaBdNuzI5BKdYf8GrsQYljTqfzZSzyi6aMoaId+kD4+DaGrjF5wilrobEQJ+kHCfym6kpUm+e35N0BdcfivoTZ7U6Vk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768864516; c=relaxed/simple;
	bh=eFZIwCf77If2flfxd0cDBvQhwy3gflhjkZ8sEbYaVrU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KFy7GZ/xaRHnSvzXCUvxXgxuRqf2jT+zIxAeWtFlaknUVmRUryqbM9zeJBNZXwBcsDHmW1AVduRAuBJ0lISod0HSeiP23qh7a+X03K79O3GZ6GD1Hp/lPEshlEM8NIGllC5LTfdkSGemFXP/P5q12/AR1LmXGncioCW9eUAoU3E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d92JqzIc; arc=pass smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d92JqzIc"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4045e70f36eso2132519fac.1
        for <virtio-fs@lists.linux.dev>; Mon, 19 Jan 2026 15:15:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768864513; cv=none;
        d=google.com; s=arc-20240605;
        b=ZFRclSX6b+6yJ7/YQW+TNmafYQl0cu5dS82Y9YMIFGMF7Aj7jO82zykNo2DGXsLliG
         FrtgaE1PiJ0I1oZEX6S0rP/2PwxZ0C02rTLRQFz0HOXwlRAW0mAS3AZkqeFrFr4Si1z8
         fKYA7SRfCLh87BX3fsvM0CoMK5OuNg+nhayHbTs12+zQw9eNRwbWaOkHSLquBM+KatyK
         KI/MFG1QqHbGHHwDuiOhqo5ipKFLzCG95DCWtKcbDz8RUEkH7RezdDL6EtNBh+YOMJPz
         4Syargc9fcQNCZ4hhq1eFyBXlrbHcFrquLc31xWeLCohQdJ0/9yP3ytu6Mt7pg/xis7U
         js3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b+Hd3Asq8WC9ZEPhp/CLp9qzeOTiNgZr6eSimimG1rw=;
        fh=umbK4uKqecMgIJFW38sS0j0QUbsVxRk3UxDkXGSQfw8=;
        b=FC2mNTG2y74Yn+d5p6F5Cww5bZLqUkC6i06RQNTgew9MVKKceEf5D5psXy4umg2o5b
         yTZfxDU6P95sd/J0rbIqL5MZfNlZtcMyT//l+XLy0uzcImE4FA2dSnNCzAeqn2z7WFKB
         SNRyyEmbFOCAcJc9ss37UrCaTGmZNzsUeyxkRFfJbx0dDTG+Gnwn0aLvVJlFgXivyOya
         +DGfNslZ2mNTjhlxiJTZFG76+xDPOscPojgB0xvOXmkcomu1Pi7XtBd9D61CUiaMzwrx
         CNleCX/Wcy+p8p0NVXcwXpZL/7FRLAs21SxGKeXBL58jNdgC8tl5LNxEv99CGxVhzgsp
         f0XQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768864513; x=1769469313; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+Hd3Asq8WC9ZEPhp/CLp9qzeOTiNgZr6eSimimG1rw=;
        b=d92JqzIcFohDqC9IlcIbViQP+Z9e6BZwpF96a35okf9qyHwGmkTTjk2DUj+F4AqBDO
         VJJqPbwILT83z+ktgdYR0GwJXB5aXogb0FULaSU5POOWkGBbJBBYu9Dkc+rYuLsu1aC6
         xLSZXKgWV+ovpN+0XI0AzL4Jmnt5G0GkEcUCL/4smYR7LdkzXcLGd/WGg7+2COEp9C6u
         W1OhboB4uU+MBDYxAltHMt4kdfkb+c350CfmaPDY3XhFEf3lPCtHoLqpmqCnyT0Ny24F
         +z+CZZQQbIAmkMyMRz9GaEikPKzaZgX6KR1cq606pmNBylpf+pA+5Zw/YjenvODrjSVW
         UEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768864513; x=1769469313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b+Hd3Asq8WC9ZEPhp/CLp9qzeOTiNgZr6eSimimG1rw=;
        b=swppmZCT+1mmagWRY8I+bZV305rhi5FD+etqJXhNJQ8DObds4evjWlA9h+O4aV9ra1
         efUKNLxxDW8vNgUTbkljwEmugTRrOAHVP9YGe3c+QPBYvkB8YKU8M0JJwmhw5u74o5cD
         e3gKlwgOWr54nJZ76qSFQVZqfA3pKtKPDAffQHvniVSvuF//qW+a3hJAtNV7+GclAn9o
         p+w+rzSqmAk7QlxfW2PmA17GRyPceK6O8VtJOiNZHiYAeR+p7Iw/PRScQhJYWIxNV//+
         BLSGgGmypaz5QmrRiodwidQPYfDK3bJXmZoxOUR1fDmRaVJ8WC0wVMp6OWp+nUwkv6w0
         9cZw==
X-Forwarded-Encrypted: i=1; AJvYcCUAxL/tJEOTbUIHMZ8eC7HZ7+7QxTwGdH4CXqJqsGAMtfbTHXnIv9KD54V07Dnw+zXP8r5myuewoPg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPqft74EoVQiD649lbSmuUeGMBGT7Oj0EbIGwnRjdsOTJdFPDz
	JVOn46sRjkW76Pfgi4CckA5SRgM4PXkcoKdDq6M3euwaDnxebb7QMw5pD6E1xbKzZcEt+LoUoDh
	67MBCzxAXD6xHyvCOKTPQD6qNtgl4WAY=
X-Gm-Gg: AY/fxX7rt9n6r4KFJJTo6R7S1YlwgYDJ8BIJUgqIszPXph8SnV2UJIo7318oYi74/13
	OR855W/DohZ/e1lVv0mqKMsNhxu8i5uwTqjGgz8R5Re5NPp2wbrH3FResSwpxcRtAkVM1JImlsi
	anA2B+KlNH011pYhmg28Y6anY73a1h9NQ58jwsXeX2yyHecBFd5QQXGBe50hKODcqp8/HHbj4NJ
	zv2M25oQU+xt89OyzpJpNTIPwtppeV1YBi7cjaH5JFt8XYMm5HGxmcSoZW2ztplQ/b3huV1BsyT
	sfJChl7i3aMB20Rr4XWAZBjRkfE=
X-Received: by 2002:a4a:dc0b:0:b0:65f:5bc0:7b2f with SMTP id
 006d021491bc7-662b00414afmr2947eaf.46.1768864513559; Mon, 19 Jan 2026
 15:15:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260115081103.655749-1-dtalexundeer@yandex-team.ru>
 <20260115081103.655749-6-dtalexundeer@yandex-team.ru> <CAFubqFtKrsPn++kMPEAOO2LdygY9BZyDmzb0nU7YbK1on2GNCw@mail.gmail.com>
 <947c2ef9-dbd8-46ea-b61d-1817fb4c33aa@yandex-team.ru>
In-Reply-To: <947c2ef9-dbd8-46ea-b61d-1817fb4c33aa@yandex-team.ru>
From: Raphael Norwitz <raphael.s.norwitz@gmail.com>
Date: Mon, 19 Jan 2026 18:15:02 -0500
X-Gm-Features: AZwV_Qh8KYBBkrQiABxnWQx3jgc2uhAUOJxN0j2UCDiP1lqDbBfjpRSSaBdlLX8
Message-ID: <CAFubqFuNAMVsVn47AjUGDi6mRCxKRwvnchmCHbZSEY7HgtG54w@mail.gmail.com>
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

ACK on your explanation. Then for the series:

Reviewed-by: Raphael Norwitz <raphael.s.norwitz@gmail.com>

On Mon, Jan 19, 2026 at 1:44=E2=80=AFAM Alexandr Moshkov
<dtalexundeer@yandex-team.ru> wrote:
>
>
> On 1/17/26 00:50, Raphael Norwitz wrote:
>
> Apologies if I've missed something obvious here - what actually skips
> the GET_VRING_BASE operation here? I was expecting something like:
>
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -221,8 +221,9 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>          return 0;
>      }
>
> -    force_stop =3D s->skip_get_vring_base_on_force_shutdown &&
> -                 qemu_force_shutdown_requested();
> +    force_stop =3D (s->skip_get_vring_base_on_force_shutdown &&
> +                 qemu_force_shutdown_requested()) ||
> +                 s->inflight_migration; // FIXME: runstate check?
>
> Without setting force_stop in vhost_user_blk_stop() I don't see how
> the GET_VRING_BASE operation would be skipped.
>
> Nothing skip GET_VRING_BASE) In the first versions of the patch, this was=
 done, but then I realized that this was the wrong way, because the last_av=
ail_idx and avail_idx counters may be incorrect after migration.
>
> Therefore, it is now implemented that on GET_VRING_BASE the backend needs=
 to either wait for all in-flight requests or not (depending on protocol_fe=
ature).
>
> On Thu, Jan 15, 2026 at 3:13=E2=80=AFAM Alexandr Moshkov
> <dtalexundeer@yandex-team.ru> wrote:
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
