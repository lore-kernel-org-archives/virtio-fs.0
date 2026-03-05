Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1F331D372
	for <virtio-fs@lists.linux.dev>; Thu,  5 Mar 2026 09:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703934; cv=none; b=WC3uf9U3HfAznhmKcnsDEb+JWkzN7iNkE7pwVQOkjp8aiyqU/jJYwqcwcHu37h8rKcHl1x0tBFTuimLxl4WiGsIOhXw18lkp0zpYuqt71RgyY2qxbZv0k4I2YUJgzl6tlV7IdB8I/puTiE0nUxA8ohSFM/Z/o83TMaNST3X1wJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703934; c=relaxed/simple;
	bh=YOsBVuhdvNeA5cF/Z2U1j2bBQFfqD3LYMM5uLcpL90I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bU113/vSqYPzlCj8Y8dh3uUbJEYFjsrbY7oLrLAkpCaxda9wg+wYr99ziHSlzDXMylfSvceNOmmavk3bQwUp5QYmlNHjZKM3SNwiu9PjfV+ELn/hW2wjXlfeL+5fZSG2c4nPC3z8w8XVAGvHYotMtrto+Eyx63Oda1yFzBszKkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=qy8OV1T8; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="qy8OV1T8"
Received: from mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:a189:0:640:4da6:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 1BA8FC01B0;
	Thu, 05 Mar 2026 12:45:28 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:b93::1:1] (unknown [2a02:6bf:8080:b93::1:1])
	by mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id PjllvG0At8c0-zpk0k6zx;
	Thu, 05 Mar 2026 12:45:27 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1772703927;
	bh=nRbzsVLviU62jAx81Tto2IrgtyHPLrPaIaiRveKh32I=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=qy8OV1T8ATGZ2sCpdBeR8OEoCFSeuWwkxPPNCfhn/FKwjn2OaMzIA6xr1KEQda/gw
	 pdlErkv7wR0cEBc4yEuJSsg2BTwgH3YRlXrCcGT2meknJOBdkUoDLAUsdX6PzDIV2s
	 mfFT1meB8Z315LMTD/iivs7YVJVTROSZyyCijQtY=
Authentication-Results: mail-nwsmtp-smtp-corp-main-80.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <55b17e00-88cd-44f5-b6c1-2d45db4665ad@yandex-team.ru>
Date: Thu, 5 Mar 2026 12:45:25 +0300
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] vhost-user-blk: make inflight migration throught
 skip_drain
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org
Cc: Raphael Norwitz <rnorwitz@nvidia.com>, virtio-fs@lists.linux.dev,
 Milan Zamazal <mzamazal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, "Gonglei (Arei)"
 <arei.gonglei@huawei.com>, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org
References: <20260224075055.863068-1-dtalexundeer@yandex-team.ru>
 <20260224075055.863068-5-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
In-Reply-To: <20260224075055.863068-5-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24.02.26 10:50, Alexandr Moshkov wrote:
> Use skip_drain on GET_VRING_BASE to suspend in-flight I/O requests, and
> then migrate them throught inflight subsection.
> 
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>   hw/block/vhost-user-blk.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index 3421145f23..4e606fd0fc 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -130,6 +130,17 @@ const VhostDevConfigOps blk_ops = {
>       .vhost_dev_config_notifier = vhost_user_blk_handle_config_change,
>   };
>   
> +static bool vhost_user_blk_inflight_needed(void *opaque)
> +{
> +    struct VHostUserBlk *s = opaque;
> +
> +    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
> +                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> +
> +    return inflight_migration && s->inflight_migration;
> +}

hmm, unrelated code movement

> +
> +
>   static int vhost_user_blk_start(VirtIODevice *vdev, Error **errp)
>   {
>       VHostUserBlk *s = VHOST_USER_BLK(vdev);
> @@ -221,11 +232,13 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>           return 0;
>       }
>   
> +    bool skip_drain = vhost_user_blk_inflight_needed(s);
> +
>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>                    qemu_force_shutdown_requested();
>   
>       ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
> -                       vhost_dev_stop(&s->dev, vdev, true, false);
> +                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
>   
>       if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
>           error_report("vhost guest notifier cleanup failed: %d", ret);
> @@ -568,16 +581,6 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>       return &s->dev;
>   }
>   
> -static bool vhost_user_blk_inflight_needed(void *opaque)
> -{
> -    struct VHostUserBlk *s = opaque;
> -
> -    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
> -                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> -
> -    return inflight_migration;
> -}
> -
>   static const VMStateDescription vmstate_vhost_user_blk_inflight = {
>       .name = "vhost-user-blk/inflight",
>       .version_id = 1,


-- 
Best regards,
Vladimir
