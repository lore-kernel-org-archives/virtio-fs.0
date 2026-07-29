Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F9425CF0
	for <virtio-fs@lists.linux.dev>; Wed, 29 Jul 2026 10:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321351; cv=none; b=eFHUOXiWMuHld5oNIcpn8cGaaytY+WCVlTq26IAeT26ViwfYzrjNqhp/ny79nofdu0Yx0dcDWvwgeLj6ZKO7TUvrYL0dS/WLkZ7enmFs5LwCrIdniLmCF7JjRIQ6iMinlnflOPv19kt2/x86xLQlwDijMWyXeee6EobskbdXq9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321351; c=relaxed/simple;
	bh=TuW8l3dYRwELAR1qswnKoiec/3uKQhhcjurg6HXkeUg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HiUjQJztIAcimeNsjfhwulK6QT1Xf1H1d+OFGlLY/+zZa4PDOK0RpJ0OVwdQLTQv9smgY7e3pCQLzNt8W4KLTyIeaEk8K3l9v7GWjifbZMCN4hudTyEdg7EaBumpr1aMt45iqW3gNERgwjoJ5DB3Pzmkwp3GRsvT80/yebESeSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=E0+fZAfH; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="E0+fZAfH"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:39a2:0:640:ae2d:0])
	by forwardcorp1a.mail.yandex.net (postfix) with ESMTPS id F3B55C0A60;
	Wed, 29 Jul 2026 13:35:37 +0300 (MSK)
Received: from [IPV6:2a02:6bf:803e:400:e51a:a385:bb92:6063] (unknown [2a02:6bf:803e:400:e51a:a385:bb92:6063])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp) with ESMTPSA id VZbqHo6WGOs0-FFcTO7Qr;
	Wed, 29 Jul 2026 13:35:37 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1785321337;
	bh=hCZHWj0ALXpDc+ncxQfB/yQ4Y0couGBsUnp6KOFQl1c=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=E0+fZAfHVjrBgyPyDI1WR47vVqjCeMbIqE9I/JbC0X9LRm+63Hy/X1T2hX+p4W3tp
	 rkRHmV+Dof75KtrnS+eV0dva9Iv8AWMQnLvc6NDc9h+H88Y5SchW1FGvPkw1UTXnEi
	 ZP/nRlrh3aHjMoOajatidYuazB/Kvo44sHlVbQfE=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <a4db1b40-d48c-473b-86a7-63a0c0cc5ccf@yandex-team.ru>
Date: Wed, 29 Jul 2026 15:35:31 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/6] vhost-user-blk: make inflight-migration prop
 mutable
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Jason Wang <jasowangio@gmail.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>, Jason Wang
 <jasowang@redhat.com>, Fam Zheng <fam@euphon.net>, qemu-block@nongnu.org,
 Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>,
 virtio-fs@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Milan Zamazal
 <mzamazal@redhat.com>, Raphael Norwitz <rnorwitz@nvidia.com>
References: <20260728100841.3475774-1-dtalexundeer@yandex-team.ru>
 <20260728100841.3475774-5-dtalexundeer@yandex-team.ru>
 <20260729051509-mutt-send-email-mst@kernel.org>
 <679a33d1-0f6c-4456-ac76-1f9e1251f2ec@yandex-team.ru>
 <20260729061316-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260729061316-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 7/29/26 15:14, Michael S. Tsirkin wrote:
> On Wed, Jul 29, 2026 at 03:09:57PM +0500, Alexandr Moshkov wrote:
>> On 7/29/26 14:32, Michael S. Tsirkin wrote:
>>
>>      On Tue, Jul 28, 2026 at 03:08:39PM +0500, Alexandr Moshkov wrote:
>>
>>          When migrating from a QEMU version that supports inflight-migration to
>>          an older one that does not, there is no way to disable the feature at
>>          runtime — the VM must be stopped and reconfigured. This is impractical
>>          in production environments.
>>
>>          Make the inflight-migration property mutable after device realization
>>          so it can be toggled via qom-set without restarting the VM.
>>
>>          Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>
>>          Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>>
>>
>>
>>      I think I am beginning to understand.
>>
>>
>>      You are running qemu with inflight-migration on and want to migrate
>>      to qemu without inflight-migration at all.
>>
>>
>>      Since it is guest transparent you could retrofit it like this.
>>
>>      My question is why is it worth it, we do not normally support
>>      migrating between qemu versions with different command lines.
>>
>> I think you right. Maybe I've been focusing too much on the ability to migrate
>> between versions of qemu with and without inflight migration.
>>
>> This series allows to turn off and on the inflight-migration feature at runtime
>> without recreating the VM (it was the only way to turn off the feature, since
>> the protocol feature could no longer be turned off, after initialization with
>> the backend). This is more important feature, and it leads to the fact that
>> this feature allows to migrate between different versions of qemu (with and
>> without inflight-migration support).
>>
>>      
>>
>>          ---
>>           hw/block/vhost-user-blk.c | 10 ++++++++--
>>           1 file changed, 8 insertions(+), 2 deletions(-)
>>
>>          diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>          index e3b873af7c..650c004bde 100644
>>          --- a/hw/block/vhost-user-blk.c
>>          +++ b/hw/block/vhost-user-blk.c
>>          @@ -619,6 +619,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>>               }
>>           };
>>
>>          +static PropertyInfo vhost_user_blk_inflight_migration_prop;
>>          +
>>           static const Property vhost_user_blk_properties[] = {
>>               DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
>>               DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
>>          @@ -632,8 +634,9 @@ static const Property vhost_user_blk_properties[] = {
>>                                 VIRTIO_BLK_F_WRITE_ZEROES, true),
>>               DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>>                                skip_get_vring_base_on_force_shutdown, false),
>>          -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
>>          -                     inflight_migration, false),
>>          +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
>>          +                vhost_user_blk_inflight_migration_prop, bool,
>>          +                .set_default = true, .defval.u = false),
>>           };
>>
>>           static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
>>          @@ -665,6 +668,9 @@ static const TypeInfo vhost_user_blk_info = {
>>
>>           static void virtio_register_types(void)
>>           {
>>          +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
>>          +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
>>          +
>>               type_register_static(&vhost_user_blk_info);
>>           }
>>
>>      So then,  for example, let us say I paused the VM, then set the flag,
>>      now inflight is on but GET_BASE did not drain it?
>>
>> If I understood the question correctly, this is valid behavior. Before
>> migration QEMU check protocol features to understand does the backend support
>> inflight migration. If it does, after that QEMU migrate inflight buffer to
>> other VM. If it's not, return error before migration started.
>
> I apologise i reverted the logic in the question.
>
>
> I start vm and inflight is on.
> I stop vm get base does not drain.

In case of VM stop, backend wait to drain all requests. Ability to 
perform drain or not available only during migration by skip_drain 
variable in vhost_user_blk_stop().
skip_drain true only if inflight_migration is on and runstate is 
FINISH_MIGRATION.

> i turn inflight off.
> now it looks like it will happily migrate?

So in this case, when vm migrated with inflight off, it will leads to 
using GET_VRING_BASE message, that wait all requests to be drained.

>
>>          --
>>          2.34.1
>>
