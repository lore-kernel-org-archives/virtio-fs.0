Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AE01E1DF0
	for <virtio-fs@lists.linux.dev>; Mon, 27 Apr 2026 11:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777288570; cv=none; b=SWroCbjJoZeluF+Rmq5Zz2lFZQQBMpxWPzVLM6hsa0izgQsxoWVjeU+xn1BfKA041zdkOOqumsY+gpCLSUbXopcyO3Ra6LOVfO9ITPE1Iuz4ChBLVJ7fGRixNWhtuqeRqdTZcw94Jp82PufqrMvLSdmD6kALMi3EXbFWxbLSuYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777288570; c=relaxed/simple;
	bh=C/MyJ1FcpLTThBV6YeKezw+bYSnz5MFhmOtH66Rcouc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m5RoX1RVLsy+Sn1F7IeMeFlJkbON+6VnnIqpxpO34PI5a5a9NpKtOYWoxoj7YG0eW+cLdFip5KD7CKmS3fJ3ylc4CyesqHfNTMsK+DQeD4uRk85CWcVLeNLUFP9ipjf310ieUc3Qmg1bDfGrT19p82F4vEbICCPAXPvs71oq5+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru; spf=pass smtp.mailfrom=yandex-team.ru; dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b=MSwZKa7d; arc=none smtp.client-ip=178.154.239.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex-team.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex-team.ru header.i=@yandex-team.ru header.b="MSwZKa7d"
Received: from mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net [IPv6:2a02:6b8:c2d:3530:0:640:eca4:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id C52B9C015B;
	Mon, 27 Apr 2026 14:15:55 +0300 (MSK)
Received: from [IPV6:2a02:6bf:8080:441::1:4] (unknown [2a02:6bf:8080:441::1:4])
	by mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net (smtpcorp) with ESMTPSA id pFW2q81MxCg0-q6uM2wzJ;
	Mon, 27 Apr 2026 14:15:54 +0300
Precedence: bulk
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru;
	s=default; t=1777288554;
	bh=6GnJ1Uatmi5chV2CJFOwC/YaD3ApSd1e+yXIFXGOatw=;
	h=From:In-Reply-To:Cc:Date:References:To:Subject:Message-ID;
	b=MSwZKa7dgYLyTXlw2XNi0BkcGG3Udg3PaWxkLtAhnGKOWhIW8qYFoUyaCY1IT+jOS
	 xjXA5eM07eVLPFX2utfT0KXclfRCJ75/EOtCDjtmtMcKdwaDhL0TLkfGl5Y9T6ua4U
	 SXM+3y1YUmvmhji5wTr3iLvS4li3ZAfil4VGe5b0=
Authentication-Results: mail-nwsmtp-smtp-corp-main-83.vla.yp-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Message-ID: <9fb43ec4-7825-4382-991f-a2cc17142138@yandex-team.ru>
Date: Mon, 27 Apr 2026 16:15:51 +0500
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] vhost-user: add skip_drain param to GET_VRING_BASE
To: Raphael Norwitz <rnorwitz@nvidia.com>, qemu-devel@nongnu.org
Cc: "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Milan Zamazal <mzamazal@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jason Wang <jasowang@redhat.com>, qemu-block@nongnu.org,
 Fam Zheng <fam@euphon.net>, zhenwei pi <zhenwei.pi@linux.dev>,
 Hanna Reitz <hreitz@redhat.com>, virtio-fs@lists.linux.dev,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 Kevin Wolf <kwolf@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
 <20260330095226.158386-6-dtalexundeer@yandex-team.ru>
 <613f140f-de27-4f83-8a02-5370833dd659@nvidia.com>
 <965db8ae-b44a-4b29-b006-56e8474d52b5@yandex-team.ru>
 <c9082536-6b4b-4e9a-a6ff-764dbbf649c9@nvidia.com>
 <19b0aa2e-90dc-4467-acc8-adc0bec7c388@yandex-team.ru>
 <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
Content-Language: en-US
From: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
In-Reply-To: <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 4/24/26 17:52, Raphael Norwitz wrote:
>
>
> On 4/24/26 4:57 AM, Alexandr Moshkov wrote:
>> Thanks for reply!
>>
>> On 4/23/26 19:15, Raphael Norwitz wrote:
>>>
>>>
>>> On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
>>>> Greetings! Thanks for reply!
>>>>
>>>>
>>>> On 4/15/26 20:21, Raphael Norwitz wrote:
>>>>> I’m not sure I like using the num field in vhost_vring_state to 
>>>>> set magic values which affect protocol behavior for 
>>>>> GET_VRING_BASE. It feels like a hack to me. I would think the 
>>>>> proper solution if we want to support migration from new to old 
>>>>> would be to have new use a different new message entirely. Can we 
>>>>> do that?
>>>>
>>>> I think we can, but I thought at first that this will be almost a 
>>>> complete copy of GET_VRING_BASE message, with the exception of 
>>>> waiting for drain of requests, so I choose to expand existing message.
>>>>
>>>
>>> I think a new message would be cleaner. Anyone else have thoughts?
>>>
>>>> If this is not an appropriate approach, is it better to make a new 
>>>> message like GET_VRING_BASE or a separate message used together 
>>>> with default GET_VRING_BASE message (for example, message for 
>>>> setting some kind of status on the server)? What should I name this 
>>>> new message?
>>>>
>>>
>>> Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate message used 
>>> together with default GET_VRING_BASE message work? 
>>
>> I was thinking about a message something like SET_VRING_ENABLE - for 
>> example SET_SKIP_DRAIN_ENABLE, that would enable/disable some state 
>> (skip_drain) in the backend.
>
> I'd need to see the flow in more detail but sounds promising.

On migration vhost-user-blk firstly send SET_SKIP_DRAIN_ENABLE with num 
= 1 message if `inflight-migration` device parameter 
and VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT enabled. Then send 
GET_VRING_BASE and continue work as usual.

On SET_SKIP_DRAIN_ENABLE backend sets inner state (skip_drain) so when 
GET_VRING_BASE is called and skip_drain is true the drain will skipped.

What do you think?

>
>>
>>>
>>>> I also fix other comments, thanks!
>>>>
>>>>>
>>>>> On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
>>>>>> In case of migration of QEMU from the new version (where the
>>>>>> inllight-migration parameter is present), to the old one (where 
>>>>>> it is
>>>>>
>>>>> nit: spelling inllight-migration
>>>>>
>>>>>> absent) there is no way to disable this feature on the backend 
>>>>>> during
>>>>>> runtime.
>>>>>>
>>>>>> This commit slightly changes the semantics of the protocol feature
>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
>>>>>> adds a new parameter for GET_VRING_BASE, which allows to control the
>>>>>> drain in-flight requests on the backend.
>>>>>> Thus, QEMU will be able to turn this feature on GET_VRING_BASE 
>>>>>> off and
>>>>>> on anytime.
>>>>>>
>>>>>> In vhost-user-blk use inflight_migration param to enable 
>>>>>> skip_drain to
>>>>>> suspend in-flight I/O requests, and then migrate them throught 
>>>>>> inflight
>>>>>> subsection.
>>>>>>
>>>>>> Also now QEMU will always try to setup
>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
>>>>>> backend. This will allow to use skip_drain parameter on 
>>>>>> GET_VRING_BASE
>>>>>> message.
>>>>>>
>>>>>> Reviewed-by: Vladimir Sementsov-Ogievskiy 
>>>>>> <vsementsov@yandex-team.ru>
>>>>>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>>>>>> ---
>>>>>>   docs/interop/vhost-user.rst    |  6 ++----
>>>>>>   hw/block/vhost-user-blk.c      | 30 ++++++++++++++++++++++++------
>>>>>>   hw/virtio/vhost-user.c         |  3 +--
>>>>>>   hw/virtio/vhost.c              |  1 +
>>>>>>   include/hw/virtio/vhost-user.h |  1 -
>>>>>>   5 files changed, 28 insertions(+), 13 deletions(-)
>>>>>>
>>>>>> diff --git a/docs/interop/vhost-user.rst 
>>>>>> b/docs/interop/vhost-user.rst
>>>>>> index bfa75ff9a3..63efc87264 100644
>>>>>> --- a/docs/interop/vhost-user.rst
>>>>>> +++ b/docs/interop/vhost-user.rst
>>>>>> @@ -1255,14 +1255,12 @@ Front-end message types
>>>>>>     *suspended*, see :ref:`Suspended device state
>>>>>>     <suspended_device_state>`.
>>>>>>   -  The request payload's *num* field is currently reserved and 
>>>>>> must be
>>>>>> -  set to 0.
>>>>>> -
>>>>>>     By default, the back-end must complete all inflight I/O 
>>>>>> requests for the
>>>>>>     specified vring before stopping it.
>>>>>>       If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` 
>>>>>> protocol
>>>>>> -  feature has been negotiated, the back-end may suspend 
>>>>>> in-flight I/O
>>>>>> +  feature has been negotiated, using request payload's *num* field,
>>>>>> +  when *num* is set to 1, QEMU can tell the back-end to suspend 
>>>>>> in- flight I/O
>>>>>>     requests and record them as described in :ref:`Inflight I/O 
>>>>>> tracking
>>>>>>     <inflight_io_tracking>` instead of completing them before 
>>>>>> stopping the vring.
>>>>>>     How to suspend an in-flight request depends on the 
>>>>>> implementation of the back-end
>>>>>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>>>>> index a3ecd83f54..522e9d34b5 100644
>>>>>> --- a/hw/block/vhost-user-blk.c
>>>>>> +++ b/hw/block/vhost-user-blk.c
>>>>>> @@ -134,10 +134,7 @@ static bool 
>>>>>> vhost_user_blk_inflight_needed(void *opaque)
>>>>>>   {
>>>>>>       struct VHostUserBlk *s = opaque;
>>>>>>   -    bool inflight_migration = virtio_has_feature(s- 
>>>>>> >dev.protocol_features,
>>>>>> - VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>> -
>>>>>> -    return inflight_migration;
>>>>>> +    return s->inflight_migration;
>>>>>>   }
>>>>>>     @@ -232,11 +229,14 @@ static int 
>>>>>> vhost_user_blk_stop(VirtIODevice *vdev)
>>>>>>           return 0;
>>>>>>       }
>>>>>>   +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
>>>>>
>>>>> nit: declarations on top
>>>>>
>>>>>> + runstate_check(RUN_STATE_FINISH_MIGRATE);
>>>>>> +
>>>>>>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>>>>>>                    qemu_force_shutdown_requested();
>>>>>>         ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, 
>>>>>> true) :
>>>>>> -                       vhost_dev_stop(&s->dev, vdev, true, false);
>>>>>> +                       vhost_dev_stop(&s->dev, vdev, true, 
>>>>>> skip_drain);
>>>>>>         if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, 
>>>>>> false) < 0) {
>>>>>>           error_report("vhost guest notifier cleanup failed: %d", 
>>>>>> ret);
>>>>>> @@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState 
>>>>>> *dev, Error **errp)
>>>>>>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>>>>>>         s->vhost_user.supports_config = true;
>>>>>> -    s->vhost_user.supports_inflight_migration = s- 
>>>>>> >inflight_migration;
>>>>>>       ret = vhost_dev_init(&s->dev, &s->vhost_user, 
>>>>>> VHOST_BACKEND_TYPE_USER, 0,
>>>>>>                            errp);
>>>>>>       if (ret < 0) {
>>>>>> @@ -580,10 +579,29 @@ static struct vhost_dev 
>>>>>> *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>>>>>       return &s->dev;
>>>>>>   }
>>>>>>   +static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
>>>>>> +{
>>>>>> +    VHostUserBlk *s = VHOST_USER_BLK(opaque);
>>>>>> +
>>>>>> +    bool inflight_migration_enabled = virtio_has_feature(
>>>>>> +        s->dev.protocol_features,
>>>>>> +        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>> +    if (vhost_user_blk_inflight_needed(s) && ! 
>>>>>> inflight_migration_enabled) {
>>>>>> +        error_setg(errp, "can't migrate vhost-user-blk device: "
>>>>>> +                         "backend doesn't support "
>>>>>> + "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
>>>>>> +                         "protocol feature");
>>>>>> +        return false;
>>>>>> +    }
>>>>>> +
>>>>>> +    return true;
>>>>>> +}
>>>>>> +
>>>>>>   static const VMStateDescription vmstate_vhost_user_blk_inflight 
>>>>>> = {
>>>>>>       .name = "vhost-user-blk/inflight",
>>>>>>       .version_id = 1,
>>>>>>       .needed = vhost_user_blk_inflight_needed,
>>>>>> +    .pre_save_errp = vhost_user_blk_pre_save,
>>>>>>       .fields = (const VMStateField[]) {
>>>>>>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>>>>>>           VMSTATE_END_OF_LIST()
>>>>>> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
>>>>>> index bb8f8eab77..ed95ec7523 100644
>>>>>> --- a/hw/virtio/vhost-user.c
>>>>>> +++ b/hw/virtio/vhost-user.c
>>>>>> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct 
>>>>>> vhost_dev *dev, void *opaque,
>>>>>>               }
>>>>>>           }
>>>>>>   -        if (!u->user->supports_inflight_migration ||
>>>>>> -            !virtio_has_feature(protocol_features,
>>>>>> +        if (!virtio_has_feature(protocol_features,
>>>>>> VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>>>>>>               protocol_features &= ~(1ULL <<
>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>>>>>> index ac4d6fca73..54e4ce2660 100644
>>>>>> --- a/hw/virtio/vhost.c
>>>>>> +++ b/hw/virtio/vhost.c
>>>>>> @@ -1398,6 +1398,7 @@ static int do_vhost_virtqueue_stop(struct 
>>>>>> vhost_dev *dev,
>>>>>>       int vhost_vq_index = 
>>>>>> dev->vhost_ops->vhost_get_vq_index(dev, idx);
>>>>>>       struct vhost_vring_state state = {
>>>>>>           .index = vhost_vq_index,
>>>>>> +        .num = skip_drain,
>>>>>>       };
>>>>>>       int r = 0;
>>>>>>   diff --git a/include/hw/virtio/vhost-user.h 
>>>>>> b/include/hw/virtio/ vhost-user.h
>>>>>> index 53fe996686..c95bad5ddc 100644
>>>>>> --- a/include/hw/virtio/vhost-user.h
>>>>>> +++ b/include/hw/virtio/vhost-user.h
>>>>>> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>>>>>>       GPtrArray *notifiers;
>>>>>>       int memory_slots;
>>>>>>       bool supports_config;
>>>>>> -    bool supports_inflight_migration;
>>>>>>   } VhostUserState;
>>>>>>     /**
>>>>>
>>>
>
