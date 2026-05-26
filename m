Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27D13E1209
	for <virtio-fs@lists.linux.dev>; Tue, 26 May 2026 23:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779839484; cv=fail; b=m2FctP8S0j5SfyjZ1VpZAcavxDo6ElcWGcHzL09oaPfd12/XFTPqyVb/QuyBL1PsK1XhFrkXrqndSydf0PeTIDd0Q8GNw1MlZnvi6mrzP5kjcBgA4fzu9adYNAbSrA2FEslKoJdIKBRUSQFKxBLQxw1efjA5R97/hURmLjpbpcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779839484; c=relaxed/simple;
	bh=G5eU9NchvkwaaTmllx2PWJFSaVCLrESnZFKGt+ZulUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h3bWA3F7rFmF1GqEYV5IKzc1GD9juT37QHa2Xy8fEvS7Mz0THLvP6uPt48wBtnh9UlLsXNfVr7zn7CMsdbz+yDXGYdUKFTkF6aqQaqYdY6UTtxKgDF9YOUCDbq8Bu6cXVYluUb9cwXmL/gZs1sAnAxfGoMbv3ho88OGVOd8OfaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cJzcdlJG; arc=fail smtp.client-ip=52.101.193.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cJzcdlJG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BglTHDGEWLEPaQJ4yQlxSu44SLiel/HtX7D/xbc3GlIlSeXW235mf3o19+zbfNNk4p20joYSDkhnrKiV73JmN4pn1OkdGn7NNyhW5pzh3628UQoJg83H7J9vWFHHgmIOgUu92JSsMbHRGdmDMvnkiaZ9a29/OVVaOOM9xhvofM94uSpet1CWs0bHwVjtBkRsOqxU6DGpNzwXNkhHBh53KDEH9pml4M0Vcsg2V95rH4DH5wQJ6zGrtFKOw14YeMcZtPJabs1W+d8ddciIP/lj6cRNo2fuzGPOvbQ4ANFSzz2l2ZHa7SicXlGseZ2hjHDASDxGToXuShdo3pOGiMuNjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3gPIbho5ti3jq98VtkbUAwN4kiokIUp/KoQua/ZF/DA=;
 b=YZaJFyvvzpun4PaejdwEJedeHuUB6yqmErkL5CTboIZiG/tL36TjG5TYBhmJFhoj9W8/zDPJTkdLX9NGwL3KaDnPclMOVX2CnEUaeS9dQeFYF5mSJeOp+a2LAE6WBqNf3TwvmsoBcvEnx6en0SgGlxoaJyYFWtJoPt5FqD4u1tyJBr4Qo0ObWLBVxI7r0YlVkY4qV4SwRHYA2Z2hAO84vtgfvJHfP9W8IU0s5suMGu8HxPPkKGk2aL9K9o7ORu8rKWR8aNFSvqf6lWhMHCEk1bcVBTDPMd92U2R0uM7CB3XodwA3CglTadvyptuuZbPJMM0GYjnRgkeN+CMNDRO5sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3gPIbho5ti3jq98VtkbUAwN4kiokIUp/KoQua/ZF/DA=;
 b=cJzcdlJGxzkV8Soyez/4KEFAsOMCjTkOpGjJY981+L/2q0FBFe3A05FH2bAyscsj4pH+BzGBW+Zkv1PDaIfZag77eRTLSKxMPYbVD4lrX8vhkFsRrBedd9eMdzLdaWU9oXwhG+CvRod7mcPIDJ5am65cyIJ6xhX0say/Fefp+j6EjIJy4FdQ1O532RDqo6t5jEXvuCdPC6K6pxkVvv8cuxFkfSz5b+XKOufEPPM3xGDgeLEsbhJZ+rxhBesz/qVkdUmHBMaOwuXOQ2f0LfU+XS+oBzHmxXKf02kYKKaEqUaHmhI4RfTNyyWCEEZjJC2nHvwjfDTefxFOnv22IQwFbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by DS7PR12MB6239.namprd12.prod.outlook.com (2603:10b6:8:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 23:51:05 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.21.0071.010; Tue, 26 May 2026
 23:51:05 +0000
Message-ID: <cc805bc1-a623-413d-bae8-508ab8ef0c8f@nvidia.com>
Date: Tue, 26 May 2026 19:51:02 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] vhost-user: add skip_drain param to GET_VRING_BASE
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
 "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Milan Zamazal <mzamazal@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Jason Wang <jasowang@redhat.com>, qemu-block@nongnu.org,
 Fam Zheng <fam@euphon.net>, zhenwei pi <zhenwei.pi@linux.dev>,
 Hanna Reitz <hreitz@redhat.com>, virtio-fs@lists.linux.dev,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, "yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
 Kevin Wolf <kwolf@redhat.com>,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
 <20260330095226.158386-6-dtalexundeer@yandex-team.ru>
 <613f140f-de27-4f83-8a02-5370833dd659@nvidia.com>
 <965db8ae-b44a-4b29-b006-56e8474d52b5@yandex-team.ru>
 <c9082536-6b4b-4e9a-a6ff-764dbbf649c9@nvidia.com>
 <19b0aa2e-90dc-4467-acc8-adc0bec7c388@yandex-team.ru>
 <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
 <9fb43ec4-7825-4382-991f-a2cc17142138@yandex-team.ru>
 <be99a7b5-1575-4da0-93dd-8460a77ddf77@yandex-team.ru>
 <7fc11fc4-4bc7-46b3-8d83-1ab5a8198cda@nvidia.com>
 <20260526184855.GA1762453@fedora>
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <20260526184855.GA1762453@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:52a::29) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|DS7PR12MB6239:EE_
X-MS-Office365-Filtering-Correlation-Id: 9854e063-73cd-470d-b8b1-08debb81a665
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|4143699003|3023799007|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	7lntjewuwZ715qCd3U7HRE4nYwiunPSkvRI8cRZ1/91RdxA8cztZFcuHjWZTfsMXlJNmAeSsiGJp8zOx5LkKpHg/bITU4VuX78p3T2jTXvWmMMNbQduTZwvKYZ8TNGInX41fnU8QY/OxnqiVBMU8FaR5BBOV3KvKUKo+Iix/qwMWrSO7A73NRAgeYZHBM9u9FozM/KNBYVtSlTOGeDXR+cbmIQrVPrSk3FEt7XzktxPresK2KbZfh5KhJYZY/76QNWdjifdkwYgc8zyjuhoBtm+FKJm32bZjencsyU0u2F4GSzXlKC48vUSiYV4Kzi0WdorC1RRWPqAA5e43PVfXD8VJFRA0YjknYOofrut6niXwVai/9+gJvuvRUXivm15XT7FFC2hut7NsNsPSh6dNASl8MmAkDpdKaWUdxq7IGtRW9La6yB2g5nu0ZE9HBBmQy6/ovFkzZuuGkgSvFMkM7j45UAl2Ztl+ivmDy4LogbCTQyAwrClD1bpbLbess2w6FqAYL3QbFTRddEfUE8Dk5R3YfmUY7dgJGQYaQ0WeU6/JrphocoklsXisGqV/TNX0SZsuLvuAHxVwc8EnbWUawupDCs/TwXdfSSt3UDVZeyoBv2DcMeq/7Q+Q2sk+bWfrP0lsAUPAJoBwBykLPWS/RhXholocISDr/O22/a+QY/9iUjHQ4/PFd/O3eQlcr7JK
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(4143699003)(3023799007)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjZlQ2YvUEFtTm9PWXNyVGttbS9DN05YWmR5S1pxRzJURzZENjhkbnJzY3lJ?=
 =?utf-8?B?WEtUaXY0L1ZGZGNFMjI4K2MwN09NTXBFRXVYTzdtME1IUUVRa0VDU2NMeWpt?=
 =?utf-8?B?bzlLcGgzaUkrWmQrUy85TWt3YXVBVFUwdnNORHdmZHZwNnBzM2pxZlU1OU5r?=
 =?utf-8?B?NUJvb1NpZVByV3ByVFgzcUdJdzEwZjBOWkFvZjhvYVdhcU81bEFValkwc1dK?=
 =?utf-8?B?a3RmRTJqaERlSld6N01QSEZQb01pbDJUUTZpRGw5MkdHa3NFRWtZaDViREhN?=
 =?utf-8?B?QjVWWHJPbU5hQlF2MTJMaTg2UUxjbGt2aVJoMjVpYjRTWWFFV1lSdzI0NHhQ?=
 =?utf-8?B?dFM0L3Y5OENHMkVoK3pxSklMRWJMVHdCOGRsbUhMdFpHem9xNjIxQlNYa3dI?=
 =?utf-8?B?THR4L050d0JLOHoxMGZGRGVSbjdYT0s5ZlJ4Y1ZUbnVtakliUktEc1NuOVdx?=
 =?utf-8?B?NktyRlZEZkl6WDFrbEpUYUQxZkxZNUd0TWFTaHFtb1VubnN2bk1PZFZsaTVB?=
 =?utf-8?B?eUkwVjMvVytDUlV6WVFsUWEvYXFlSzRmNEwvSDdJRTArTW1wbEhKZ2VCSkZ6?=
 =?utf-8?B?b2hKVGNzbmVheUo3ZnkwemxsRHU3TXdlOExZRzgybEs3OENoeHNmc2RpZDBr?=
 =?utf-8?B?TGIxbmhkZjRtYTVCcTZOcFRtZVJQMlhacDJtdDVjMm44Q3BTTjBPSDhZTkxW?=
 =?utf-8?B?ZFFXdkVCdVovM2V1d3F2ZVgwQVBrWk9reHpsSHRHbUF2enRGajk4Y25Sd0o4?=
 =?utf-8?B?NmZYKzVWM2FIcmpzVHFVQ0k3bVBVcHZrTlVCekpoWmJwTzV6NmxiamxPRnBZ?=
 =?utf-8?B?ZDJnclIwd2lJLzJDbG5OZzMyWExvc1dzRXNhU1pLSUFUdU5idVgyT1FzN2pB?=
 =?utf-8?B?emtReHNRMFZwUERybkIzMG10OHFlWjRHSnV0RUlRYVExQ0pxVUNQR1V0Y3Ex?=
 =?utf-8?B?RnJQUXZjZGpydGZqMFJhYjIvMjV3QzlYc0QxRktsTWplcHlwOFpmOUk4SEN1?=
 =?utf-8?B?K0dEcVFYSzcrWDZyZm9haHgwcGYwQi90MG55MFdqZ1ZXYUlzQ0t1amtoWjhy?=
 =?utf-8?B?dmxsNUdna0REWFh6ZUpsMitLaXQwRUoxOU8xQ2RBNmlWTGJkYnlicnlla0NH?=
 =?utf-8?B?ZlFEZVRyd3JrMk95THo1Zk02MHR1Y0xDWVZoV04xdk9haUszbWtXLzRjL1po?=
 =?utf-8?B?UkhzZ2p3WVpYMDBTUTc3OG5CdTBVR1ByUk9sRTRBdVhFVmdMRTFlZ0dtTDQy?=
 =?utf-8?B?Ulk4eS9ORDJlWnhMQ2lmSWs0alBUZUYveFAvUEdUcWZQZUxLUUJRWDczNlVP?=
 =?utf-8?B?QUMzSnhIN2VUZ0hPdHlWL2wrcXJpd2M1aWVyZ0c2VDZ3Z3RZQzlqVW9meHhP?=
 =?utf-8?B?Z1dxb3JpbERzQTFHQVZUVHBtdm5UUGUwc0E2MGJFK1BjOEFFSmtjU2p2ak5o?=
 =?utf-8?B?RWdQaWIxOERrczhNVStTL0ZYdkxscDkrcnAva09RQWRpUTl6L1NKa2ExaXV5?=
 =?utf-8?B?TnpRcDlTUmd5OCtJN0IrNWR6ZXU3d2RXMkgrVjFxTHZxRlNYMGFBZVcvNTht?=
 =?utf-8?B?NytPV0Vwby9vS2d6eTFoQzJOT1h0bHFZeGpkK1Uwcm1qQjRBalhHdytjaEQ5?=
 =?utf-8?B?VkVPSGkycGgzb0pteFk5bmNkUys5bkRTOXBZbFZNRVJDc0V2U2JuUXkvQ09q?=
 =?utf-8?B?ODVXYXhWL3VBcjgrK2pIY1I2WEZoOVVidkxGSnowS0piRGVSL1QzQU9hWGxT?=
 =?utf-8?B?M3pPVVJRQnBOUlJNdHBKVjVzZmtlWXJ3RzN6d2QxSHBKOVVqekREYnFJekV2?=
 =?utf-8?B?T29XdHVOUGFVeXEzeU9aZmcwWjFOcUJwS2V6Vk1FMXFLcHIvQjdwS1dFSFJK?=
 =?utf-8?B?VlhNYlJuZ2FTZWJBYS9CUG9BMnhzSnNFVHVBMWFKWVBQY2lKaytnS3dSWlNU?=
 =?utf-8?B?emxHZkJiZTUzaWU0eSt5RmFvUkw4TzlheW9iK3kzVnBFdEFDYVJCcVRHeFl4?=
 =?utf-8?B?LzJ4MERXQmMxK1F5MEtQQzZxTklha3NGN2xNRUpNSkV4SGw3U2I5QUlyeTBo?=
 =?utf-8?B?YnNIOVpsV3NIcysxTGpCNGFXVnM4Z2VycmlPenliejlaMkR3SE5udDBxVmxS?=
 =?utf-8?B?Z1Zac2NxWnBhR201bjdudERvd21xQXgwQVpRRXl2S2IxSTRNbGgrcEt5ZXZv?=
 =?utf-8?B?WGJ3dWRYYUpSRzdpS1pvOEVxYmdtRlFPNzFpZktpSWdtVWFqRlRleU5VcWU3?=
 =?utf-8?B?eEZYNUVETTduZUt1aUJCYkZaMFh4azc0TlFkU1lid0IzR2EvWUxNU1JJR0Ez?=
 =?utf-8?B?SGRTYVVaZlhoZk8zR1c1V1JyMDVqN2FIcWtUS2N1UWZZclRTQ1h3UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9854e063-73cd-470d-b8b1-08debb81a665
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2026 23:51:05.2912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NHlNm831FiYbfxkeEX/DDdaIR8IGmg2US1hCo1ITJd9j7oqGlM+XPv2+O6WJxEgQ4Q8UOfVGZ0ETqs8z3UFaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6239



On 5/26/26 2:48 PM, Stefan Hajnoczi wrote:
> On Mon, May 25, 2026 at 05:34:37PM -0400, Raphael Norwitz wrote:
>> Apologies for the late reply.
>>
>> On 5/12/26 1:55 AM, Alexandr Moshkov wrote:
>>> Gentle ping :)
>>>
>>
>> [...]
>>
>>>>>>> On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
>>>>>>>> Greetings! Thanks for reply!
>>>>>>>>
>>>>>>>>
>>>>>>>> On 4/15/26 20:21, Raphael Norwitz wrote:
>>>>>>>>> I’m not sure I like using the num field in
>>>>>>>>> vhost_vring_state to set magic values which
>>>>>>>>> affect protocol behavior for GET_VRING_BASE. It
>>>>>>>>> feels like a hack to me. I would think the
>>>>>>>>> proper solution if we want to support migration
>>>>>>>>> from new to old would be to have new use a
>>>>>>>>> different new message entirely. Can we do that?
>>>>>>>>
>>>>>>>> I think we can, but I thought at first that this
>>>>>>>> will be almost a complete copy of GET_VRING_BASE
>>>>>>>> message, with the exception of waiting for drain of
>>>>>>>> requests, so I choose to expand existing message.
>>>>>>>>
>>>>>>>
>>>>>>> I think a new message would be cleaner. Anyone else have thoughts?
>>>>>>>
>>>>>>>> If this is not an appropriate approach, is it better
>>>>>>>> to make a new message like GET_VRING_BASE or a
>>>>>>>> separate message used together with default
>>>>>>>> GET_VRING_BASE message (for example, message for
>>>>>>>> setting some kind of status on the server)? What
>>>>>>>> should I name this new message?
>>>>>>>>
>>>>>>>
>>>>>>> Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate
>>>>>>> message used together with default GET_VRING_BASE
>>>>>>> message work?
>>>>>>
>>>>>> I was thinking about a message something like
>>>>>> SET_VRING_ENABLE - for example SET_SKIP_DRAIN_ENABLE, that
>>>>>> would enable/disable some state (skip_drain) in the backend.
>>>>>
>>>>> I'd need to see the flow in more detail but sounds promising.
>>>>
>>>> On migration vhost-user-blk firstly send SET_SKIP_DRAIN_ENABLE with
>>>> num = 1 message if `inflight-migration` device parameter
>>>> and VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT enabled. Then send
>>>> GET_VRING_BASE and continue work as usual.
>>>>
>>>> On SET_SKIP_DRAIN_ENABLE backend sets inner state (skip_drain) so
>>>> when GET_VRING_BASE is called and skip_drain is true the drain will
>>>> skipped.
>>>>
>>>> What do you think?
>>>>
>>
>> I'm happy with that in theory but would like more clarity on the details. In
>> particular, I'm not sure what you mean by "vhost-user-blk firstly send
>> SET_SKIP_DRAIN_ENABLE". To add a new message I would think we would have to
>> do a vhost-user protocol feature negotiation to gate it.
>>
>> Also what are the precise semantics for SET_SKIP_DRAIN_ENABLE? Would it be
>> sent on backend connect or when we're about to migrate?
>>
>> I was hoping others would comment but at this point I'd suggest drafting the
>> code and then we can re-review.
> 
> Adding a new GET_VRING_BASE_SKIP_DRAIN message seems simpler to me than
> a stateful SET_SKIP_DRAIN_ENABLE where the back-end needs to stash the
> enable_skip_drain state and the front-end would have to toggle the state
> if it switches between skip drain and classic behavior.

Agreed - that sounds cleaner.


> 
> Stefan

