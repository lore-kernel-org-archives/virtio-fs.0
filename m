Received: from forwardcorp1d.mail.yandex.net (forwardcorp1d.mail.yandex.net [178.154.239.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A1A1DF25C
	for <virtio-fs@lists.linux.dev>; Fri, 27 Mar 2026 09:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774602867; cv=none; b=d6tYKMT+kMGypLIaKs+7z8f1t6PG27Xxm1fbsMCKcv/ZP75NyzStYfc653jqNUsSs9cc0kjukuToW9t+ae9g0VrS60lmKa/PLK1MYL26EoMjAbzJrM7gjsG0/ogTmeaiWbWbD71MwTjva/TochgJt5US82PzivGc85a2UZRjKkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774602867; c=relaxed/simple;
	bh=d28fEssNnGt5795J9zm44NGlAVts60k20chtCje/4hA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M78k0fbWmN6FwD9RpSkSo2zyF383Nlqime7MOvEELVmTYGGNdjnUx1hb0aEv0F/XmliToOYBvzyczl0wv8/jUZf8f/sQMeRJN1s/gv/LbI3R+BqMEOvJA8/1T//pJxUXfwIkl9tTul5lq7UuK2mKYInINcz94SDynBr8QyBu5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=QtI3h6H6; arc=none smtp.client-ip=178.154.239.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="QtI3h6H6"
Received: from mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net [IPv6:2a02:6b8:c0c:bf1f:0:640:c739:0])
	by forwardcorp1d.mail.yandex.net (Yandex) with ESMTPS id 1CC2780635;
	Fri, 27 Mar 2026 12:14:12 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:b75::1:32] (unknown [2a02:6bf:8080:b75::1:32])
	by mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 8ESXxH0ARW20-eiPc3mEF;
	Fri, 27 Mar 2026 12:14:10 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1774602850;
	bh=TOrGueS5ldHbjfsLLxnHQUxVgrfK5gdEBWidE+OThFM=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=QtI3h6H6mbnHaG0aQ8CNGYg5i3zfciSItRsVy+ZHwLANUVkCEgCyz7/EVg6Nu5ml8
	 ZzhQQkKSrFqXgl/vJW1mXcsj6CKJzMeJRCg/xuAb/EsaIlMLe3oyJwV+jrWYdZa2PK
	 13hzd7YsNKBtUabClYz+q1dNPEiCMC90sgoedUiM=
Authentication-Results: mail-nwsmtp-smtp-corp-main-66.iva.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <2428258b-663d-4b16-b6d7-80fdbe0b29fc@yandex-team.ru>
Date: Fri, 27 Mar 2026 14:14:10 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] vhost-user: add skip_drain param to GET_VRING_BASE
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, virtio-fs@lists.linux.dev,
 zhenwei pi <zhenwei.pi@linux.dev>, Hanna Reitz <hreitz@redhat.com>,
 "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 Raphael Norwitz <rnorwitz@nvidia.com>, Milan Zamazal <mzamazal@redhat.com>,
 Jason Wang <jasowang@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, qemu-block@nongnu.org,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Fam Zheng <fam@euphon.net>,
 Kevin Wolf <kwolf@redhat.com>
References: <20260311084728.751169-1-dtalexundeer@yandex-team.ru>
 <20260311084728.751169-5-dtalexundeer@yandex-team.ru>
 <20260326155241.GE758087@fedora>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <20260326155241.GE758087@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/26/26 20:52, Stefan Hajnoczi wrote:
> On Wed, Mar 11, 2026 at 01:47:28PM +0500, Alexandr Moshkov wrote:
>> In case of migration of QEMU from the new version (where the
>> inllight-migration parameter is present), to the old one (where it is
>> absent) there is no way to disable this feature on the backend during
>> runtime.
>>
>> This commit slightly changes the semantics of the protocol feature
>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
>> adds a new parameter for GET_VRING_BASE, which allows to control the
>> drain in-flight requests on the backend.
>> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
>> on anytime.
>>
>> In vhost-user-blk use inflight_migration param to enable skip_drain to
>> suspend in-flight I/O requests, and then migrate them throught inflight
>> subsection.
>>
>> Also now QEMU will always try to setup
>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
>> backend. This will allow to use skip_drain parameter on GET_VRING_BASE
>> message.
>>
>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>> ---
>>   docs/interop/vhost-user.rst    |  6 ++----
>>   hw/block/vhost-user-blk.c      | 29 +++++++++++++++++++++++------
>>   hw/virtio/vhost-user.c         |  3 +--
>>   hw/virtio/vhost.c              |  4 +---
>>   include/hw/virtio/vhost-user.h |  1 -
>>   5 files changed, 27 insertions(+), 16 deletions(-)
>>
>> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
>> index bfa75ff9a3..63efc87264 100644
>> --- a/docs/interop/vhost-user.rst
>> +++ b/docs/interop/vhost-user.rst
>> @@ -1255,14 +1255,12 @@ Front-end message types
>>     *suspended*, see :ref:`Suspended device state
>>     <suspended_device_state>`.
>>   
>> -  The request payload's *num* field is currently reserved and must be
>> -  set to 0.
>> -
>>     By default, the back-end must complete all inflight I/O requests for the
>>     specified vring before stopping it.
>>   
>>     If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
>> -  feature has been negotiated, the back-end may suspend in-flight I/O
>> +  feature has been negotiated, using request payload's *num* field,
>> +  when *num* is set to 1, QEMU can tell the back-end to suspend in-flight I/O
>>     requests and record them as described in :ref:`Inflight I/O tracking
>>     <inflight_io_tracking>` instead of completing them before stopping the vring.
>>     How to suspend an in-flight request depends on the implementation of the back-end
>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>> index 1dc49c104e..8cc80eb0c3 100644
>> --- a/hw/block/vhost-user-blk.c
>> +++ b/hw/block/vhost-user-blk.c
>> @@ -134,10 +134,7 @@ static bool vhost_user_blk_inflight_needed(void *opaque)
>>   {
>>       struct VHostUserBlk *s = opaque;
>>   
>> -    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
>> -                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>> -
>> -    return inflight_migration;
>> +    return s->inflight_migration;
>>   }
>>   
>>   
>> @@ -232,11 +229,14 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>>           return 0;
>>       }
>>   
>> +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
>> +                      runstate_check(RUN_STATE_FINISH_MIGRATE);
>> +
>>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>>                    qemu_force_shutdown_requested();
>>   
>>       ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
>> -                       vhost_dev_stop(&s->dev, vdev, true, false);
>> +                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
>>   
>>       if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) < 0) {
>>           error_report("vhost guest notifier cleanup failed: %d", ret);
>> @@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
>>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>>   
>>       s->vhost_user.supports_config = true;
>> -    s->vhost_user.supports_inflight_migration = s->inflight_migration;
>>       ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
>>                            errp);
>>       if (ret < 0) {
>> @@ -580,10 +579,28 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>       return &s->dev;
>>   }
>>   
>> +static bool vhost_user_blk_pre_save(void *opaqueue, Error **errp)
>> +{
>> +    VHostUserBlk *s = VHOST_USER_BLK(vdev);
> This won't compile. "opaqueue" is unused and the vdev variable does not
> exist.
>
>> +
>> +    bool inflight_migration_enabled = vhost_user_has_protocol_feature(&s->dev,
> vhost_user_has_protocol_feature() does not exist.
>
>> +                            VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>> +    if (vhost_user_blk_inflight_needed(s) && !inflight_migration_enabled) {
>> +        error_setg(errp, "can't migrate vhost-user-blk device: "
>> +                         "backend doesn't support "
>> +                         "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
>> +                         "protocol feature");
>> +        return false;
>> +    }
>> +
>> +    return true;
>> +}
>> +
>>   static const VMStateDescription vmstate_vhost_user_blk_inflight = {
>>       .name = "vhost-user-blk/inflight",
>>       .version_id = 1,
>>       .needed = vhost_user_blk_inflight_needed,
>> +    .pre_save_errp = vhost_user_blk_pre_save,
>>       .fields = (const VMStateField[]) {
>>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>>           VMSTATE_END_OF_LIST()
>> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
>> index bb8f8eab77..ed95ec7523 100644
>> --- a/hw/virtio/vhost-user.c
>> +++ b/hw/virtio/vhost-user.c
>> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>>               }
>>           }
>>   
>> -        if (!u->user->supports_inflight_migration ||
>> -            !virtio_has_feature(protocol_features,
>> +        if (!virtio_has_feature(protocol_features,
>>                                   VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>>               protocol_features &= ~(1ULL <<
>>                                  VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>> index 4e196fc773..c04bb53159 100644
>> --- a/hw/virtio/vhost.c
>> +++ b/hw/virtio/vhost.c
>> @@ -1390,12 +1390,10 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
>>                                      unsigned idx, bool force,
>>                                      bool skip_drain)
>>   {
>> -    /* TODO: support skip drain */
>> -    assert(!skip_drain);
> The following assertion would be useful:
>
>    if (skip_drain) {
>        assert(virtio_has_feature(...protocol_features...,
>                VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT));
>    }
Thanks for reply! I'll fix it all
>> -
>>       int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
>>       struct vhost_vring_state state = {
>>           .index = vhost_vq_index,
>> +        .num = skip_drain,
>>       };
>>       int r = 0;
>>   
>> diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
>> index 53fe996686..c95bad5ddc 100644
>> --- a/include/hw/virtio/vhost-user.h
>> +++ b/include/hw/virtio/vhost-user.h
>> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>>       GPtrArray *notifiers;
>>       int memory_slots;
>>       bool supports_config;
>> -    bool supports_inflight_migration;
>>   } VhostUserState;
>>   
>>   /**
>> -- 
>> 2.34.1
>>
