Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44416316189
	for <virtio-fs@lists.linux.dev>; Thu, 23 Apr 2026 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776953760; cv=fail; b=Kce4OvKODJoHzxG5uf6mUkMP6PrdXoFQKnkJtbm9S4ma/0yF/AyeVqfDInZs+Am6CIe3xlEfC4pjI+osgPuTV8DRMxmQB54JbWL3lRgYr1jUNDvNecboULVBz6Wnpk8B6oMC+m/bKC71q0QAIB7ZllXZ5wFVfnyDJmUZfgXFLYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776953760; c=relaxed/simple;
	bh=JoRAJUoeeHsWy2gSbOYMKA3SPisfYeIS6K42YJy5jx8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=taoFdVso9/RDbAUMd1e/FVGpLxWlZBiNZ01lm9tFYjLZbf4dDdxuLv0jdP9SUn9aAF+7aWWAwkSEcihBc6oWkfF32vbXjaVDXtLkLRWh3MnNQj39W2n/12FEbH+n+kDRnlWUx85avDirzpRSbjWfhXuk1mlKgT/AFq9w8aEiOjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RbgsCyYE; arc=fail smtp.client-ip=52.101.48.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RbgsCyYE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAPE74i9Gnwub0m/yuVEpHU6u2Tn0RXVR1e+gNzPTTX4ZarxViN7uyx2Zufl1QXabkr28ySGRYU/irl6vNzpufXCOY4f5a6b3Rbpt/LcC9w9Mb7LaQOMtr8g3iDgz3AwqQlN62LtSQpNc5OgFrMNxgZ0J7cJfSPaEVglcJpERHtoBfubRmU67ZINSJskXIlHn4UoK7e0vvBV7EsYAwdMWuUUomUhKzAaTYL9yUUt0dfmYvmzbUM1bqyA75/voiDRjVZWQGyv137ntPoFucFWNbaAEnm7HYBLB3TsZEfg3hdVviLi4PVUl99wCSi9t42rrysj5QqyAuukeu7hDd+WdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TWjnrs6gMiaSEZmXh1touQ1+0Jh7dc4+Y8Io2S6QQ/g=;
 b=iZ9OKGoxJ1RZYA4rqfdjpxorWCjOWfkMaYv3qXCfudlWN3Sl0sE3sM16tNo4A9bb+gE279ac+t9x1pnbvRXAKSOaoJwQKGBTxy1SUtrSnWZRHMI5/dsTeIOW4dG3/CycReRe0VSCnWASXfU9lsehbdZr8bTb2bjN/+4aWsLmy65HskJOvj6S3smlpjauEtysVN1s9qslRIblh7pheNZTWP8PGgCZ6NoHaATb/J0on6H5XiSHzt93IRASIbTsizQkMH4pPHMa6xICHO4GN2hCQcfAyVqmsqIjE3QCFB73As/rB9Jbx7mHi6BJngM4Qu9RZvRzbAUPgRIQcZaza+HFBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TWjnrs6gMiaSEZmXh1touQ1+0Jh7dc4+Y8Io2S6QQ/g=;
 b=RbgsCyYEn0dGEQ8ZPiO9sUq03gigVg7KFnL1N6SOFvjFjoRda7pENogbucplBBOfrY3vNUd8PoAy5L7jY/W7fSAFibm9fHDUIh6BQnHAN6PaJ/FRa7gKLA9YYkgIhL3eXDm0g5+GctGCmWL54vvE+5QVk8Ic13gQcdgIMrospsYM1a+Aeprz0qzdUcDiC4E8+Z7yg1OyRvy1ba5mkGepI79koMC1rJTrlKzGXcPp9HmDSECCMZkR31d2Ipci0EwTgSl2TZBFARBJ3EjQh7VfAVEtb0sN6N/uCqStAF+PdWrzLL+qSal44GSPywutZuTdYmiqBEha/6vECk/2E7Lszg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by BN7PPFCE25C719B.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.21; Thu, 23 Apr
 2026 14:15:49 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.20.9846.021; Thu, 23 Apr 2026
 14:15:49 +0000
Message-ID: <c9082536-6b4b-4e9a-a6ff-764dbbf649c9@nvidia.com>
Date: Thu, 23 Apr 2026 10:15:46 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/5] vhost-user: add skip_drain param to GET_VRING_BASE
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org
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
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <965db8ae-b44a-4b29-b006-56e8474d52b5@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0307.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::12) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|BN7PPFCE25C719B:EE_
X-MS-Office365-Filtering-Correlation-Id: 731e6be4-62dc-4bbd-f583-08dea142d1d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	Vpauahl9Vj9UF+o8UbPqzkLG9yy7vO06jHB9UoV9djAeDdF06GELxGBsPWU1wbM2oforkPNcL/zRvTKJ2wzYtAkxW/RNGC0JQejsVwkKTwHy38xP8xUxrxnoRHG7xLUJc6Je38ybExjTTS6+hmw20EC4rL9vjnxgtbx+s7Eo8LdL0wewgr9B7I86Ustqwf1pgpXcJ5AWoIuYC7TfpKBIOgkAx9AZtiunR/uNYQj8zvYZCOwWNEjM+Bd1RPka8ELlzPBuYw7rkyns35klTfw2nc6Ucq1otH2L8fXXiNH9Dtf1z7RT7zAATmvjihF9dbyKNuDmq+ffPyEnr0kO0geJG1wyroyYqmbhvFr/UBD28+2V2khiqESvSXZoYNShfEcqsqBamxnFSPlYdmILFAquKOjfk5jg3O6WRqcWZG6pU9C6bwn420IVJFDc0YVEhiTtnmmeXHGL4KG0jDcc3s2Pp8MY9vxc8JcccpR5LopsOqLCmhKeUE/fyKoG/59grv/W8jloDVA/CCgq1I0SuWkwrtVQ+6hwskp36R790d19UfJ7zZMhU+jhZb6ymCv/9Wo+dXXBKT0IuGva8UHMtUtMpFwUvzHo1Muohs9jQT1fNQ9OhZe2qkTkOKKl3LXrjPOrS/iHu6knaj9fj5NpD5O8DrQYBkU9KTDskBbTlhvTmGH7b1xrt77V0q7jCkPwmGtwHZI3C4BGPS9MSZw8CwS6FzF0VWaSG0Car5CCebBzv14=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SU1GMmc0WEtZZHNpb01OMUZ0bWJkRHJ5YXl5VHE1aXZheTNnWXFjSURLRUx2?=
 =?utf-8?B?UUdsdCt0dHpaaWlFYUE5elZsRkpYc3Nqdy9YNXprcE9FeWJ0cXgzOUR6VTZ2?=
 =?utf-8?B?d2wwMzBUZlhFZEl6dEhHZjlMdktXWnB3ZFR4bVFxTkJrY3Z2NjI5SmpUWGFT?=
 =?utf-8?B?ZU8yL0sxbU9kVmI3MVBtbUxFeStQVksycy85Q0V1UDRWeWNGNTlERnExNWs5?=
 =?utf-8?B?SFpOTElaWGR4WDY4QjZhZkE3ZmFOUnREc1FDcUJwSmY1RG16amYzOFFZU2I1?=
 =?utf-8?B?Wk1zS1VQNytBd0F1U0c1UnFETTFtM3dacWZQanBVWFM4L1BseVpvdEt5RFFO?=
 =?utf-8?B?cDRPS2lKeHVqTEJpZ3VaTnF2VEJCbzNPRUowaEJHREUzTDd4Q3NaQysvWm9X?=
 =?utf-8?B?elRQSGw0b2k4NGlsbFNLcEpQZXY4TDJiOWRhem42dDV5bUdhK0tMM3RNb0JB?=
 =?utf-8?B?cmI1bnR2MWg4eFlIWlBFSTNPbzJQNGhnM1JBRjZUQ0dVdkJXdG1vSldWREhL?=
 =?utf-8?B?cUh5M01VdVY3c25FSVR1QXdlWmg1bE9VOTk3OXcxYTNIakFQeVJkeTBMaGRO?=
 =?utf-8?B?ekdiVGdpazBVcFZmWWVTM1V6N2UramRDVTF3SDlDLzFvWE4vRjdQekRTazN1?=
 =?utf-8?B?WTJKY2wyTDFscGE5ZGVzaHVDZ21maDhma010Y0kzbkJFMmlxWE1GZEhSaTNj?=
 =?utf-8?B?WUJBcnIwbDZaUWVxWGNERlQxdiswUVRQMlpXVGtCSGZrT1RybnhoTFUxa3Vw?=
 =?utf-8?B?QnJLVjZBa3ZXOERwV0MwSGdaK2FJVWIwQXAxTGRIRmw5NGZlSVAyZHh6REw4?=
 =?utf-8?B?Rnd5Y1lsamRzZnZheUtwQzVpZ29RV1R3dFZTNXZmTDl2R29NMW9kdnNqQ1RW?=
 =?utf-8?B?U2lrWWhZdGlQRmhRcDZNMnFKREd3K1dBMUpEK05VZGp4RmtLNHNwWE1RZTU4?=
 =?utf-8?B?ZGRTUkRlUGw0cE9yRUdieExKU2N5bWU0SHFkU2pDRXo0VndkdGRDRW1rdXRs?=
 =?utf-8?B?OGt3ZEorMXR6WTJkSFIvZ21lSFoycjZrcHNoUkxiL2lqN29pZUJBTTRXVzNY?=
 =?utf-8?B?K1grS2ovSWc0UEtxa0hycFI2bFpVQVord2p3RE41bmxiaWZKMWhncXg1eHdC?=
 =?utf-8?B?ZkN2azFhSmlraFdoN3BkRTVLYjZRaDlvbGp2dTZ1RFFtekdjKzF1V0Y3T0w3?=
 =?utf-8?B?TXpzNTI2T29xeUxEVXdGbytwZ1hHWFJBNW55TjI2V1puZDQzZTBINm1mVGxN?=
 =?utf-8?B?dEovSHZXV2RVeVhxajFpeHNoK3pOUlphVkRySjM4Z2tIR0YyZ1MvNGYxSEl0?=
 =?utf-8?B?YmJ3by9TR0g1WE1CejRiY2pLL3ljUVFLdG1MRjlXRTFZaC9QL3JWa21ibENs?=
 =?utf-8?B?ZWRwdW9VQmJ6c0Y2SXZucG9iMTRScTh5M0VCYXBQQzcrakhwWW5kSnMwM2lW?=
 =?utf-8?B?YjdzSTNSQ3pTTEZUazlHZnJSZ1V3NGgzb3FtMFdJdVR5RkJZay9icTJWc2xC?=
 =?utf-8?B?VXgzcllFWGc3SGtPWmt6WEVkRGtoYWx6MVJpYmJqUkxXOVRoMi9lbzNZRUtx?=
 =?utf-8?B?VUZBeXUrOG94eDR1b2Q5bTBTMFV0VEN5OE5SQUJxZEg3VzhzZEhkMmZrN1g0?=
 =?utf-8?B?V0xGYzNtS2k4eS9CSlFXdkVTQzJwN2JQK3Y1RHRITkJrWWtPbE1hcEEvOE1x?=
 =?utf-8?B?K1FLMnZUU3lrSFVYU0NZTDEvd2tKbTEzbzJNVythSzZyNlZZVFNvMEFYa1B3?=
 =?utf-8?B?cjdiemdXRU9VYUJpZE05ZEREUkFxY2xkNm5PMTR2dkRXQjdVaG80dDcvTUtG?=
 =?utf-8?B?Z3dGeWRXcGcrbklrL29iaEdJRkEvLzZGSk1rbmFacFdGY3NFa01PSUxTWEho?=
 =?utf-8?B?Y1RPeTloRVpqMzdOMHhjRDRaSGduWGlYWm9aRzd6WHFubVFZWFJWeE5aUjFL?=
 =?utf-8?B?MXlQTjZpT2lDMTU2N0JBNGpHQmJ3c0lHVjJIT1h2cHR6Q0FleXNlZG5EVTZt?=
 =?utf-8?B?WFd2VHp3OTRUamJ2YmNSdmMxR1BEVlNycFBFSnBjZUtZOFdsN001MFNNbjJo?=
 =?utf-8?B?ZENJSHd5Z25zVEFxTnJaanVSaVZsUlRMMGV1QTRMN0RpRUpVQ2VscnRwTWxa?=
 =?utf-8?B?K1luS0FNYWdBZUpmZ1pmZ2hPZGxhRGwyL2lkU0pWUFdYZDF6UUhQRWwwZ21I?=
 =?utf-8?B?TjJhbmZlZHFINjBHdjFhMFBTd3drb1QrR1NTK3J5Vlg0Zk5Hczc2TytqVFNS?=
 =?utf-8?B?cXo5c3EyNitQd3FSdXdhUC96YmsxZkx5ZC9xRzY2b3MyTHlDVmpnOUhsc01T?=
 =?utf-8?B?NWlML21nZHNRRC9mMzVoSjlzem94NXhkSzB2OVMzMGVUTURoZkVmdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 731e6be4-62dc-4bbd-f583-08dea142d1d4
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 14:15:49.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jkLl/tHr3EbqnlRqJiuCIzXZhZIEJK33i8uipgHn5wmFAE4ofwdvQYiRmkVwxhoIxycBPuDjo+O5pvjGkM7Yyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFCE25C719B



On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
> Greetings! Thanks for reply!
> 
> 
> On 4/15/26 20:21, Raphael Norwitz wrote:
>> I’m not sure I like using the num field in vhost_vring_state to set 
>> magic values which affect protocol behavior for GET_VRING_BASE. It 
>> feels like a hack to me. I would think the proper solution if we want 
>> to support migration from new to old would be to have new use a 
>> different new message entirely. Can we do that?
> 
> I think we can, but I thought at first that this will be almost a 
> complete copy of GET_VRING_BASE message, with the exception of waiting 
> for drain of requests, so I choose to expand existing message.
> 

I think a new message would be cleaner. Anyone else have thoughts?

> If this is not an appropriate approach, is it better to make a new 
> message like GET_VRING_BASE or a separate message used together with 
> default GET_VRING_BASE message (for example, message for setting some 
> kind of status on the server)? What should I name this new message?
> 

Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate message used 
together with default GET_VRING_BASE message work?

> I also fix other comments, thanks!
> 
>>
>> On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
>>> In case of migration of QEMU from the new version (where the
>>> inllight-migration parameter is present), to the old one (where it is
>>
>> nit: spelling inllight-migration
>>
>>> absent) there is no way to disable this feature on the backend during
>>> runtime.
>>>
>>> This commit slightly changes the semantics of the protocol feature
>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
>>> adds a new parameter for GET_VRING_BASE, which allows to control the
>>> drain in-flight requests on the backend.
>>> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
>>> on anytime.
>>>
>>> In vhost-user-blk use inflight_migration param to enable skip_drain to
>>> suspend in-flight I/O requests, and then migrate them throught inflight
>>> subsection.
>>>
>>> Also now QEMU will always try to setup
>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
>>> backend. This will allow to use skip_drain parameter on GET_VRING_BASE
>>> message.
>>>
>>> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
>>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>>> ---
>>>   docs/interop/vhost-user.rst    |  6 ++----
>>>   hw/block/vhost-user-blk.c      | 30 ++++++++++++++++++++++++------
>>>   hw/virtio/vhost-user.c         |  3 +--
>>>   hw/virtio/vhost.c              |  1 +
>>>   include/hw/virtio/vhost-user.h |  1 -
>>>   5 files changed, 28 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
>>> index bfa75ff9a3..63efc87264 100644
>>> --- a/docs/interop/vhost-user.rst
>>> +++ b/docs/interop/vhost-user.rst
>>> @@ -1255,14 +1255,12 @@ Front-end message types
>>>     *suspended*, see :ref:`Suspended device state
>>>     <suspended_device_state>`.
>>>   -  The request payload's *num* field is currently reserved and must be
>>> -  set to 0.
>>> -
>>>     By default, the back-end must complete all inflight I/O requests 
>>> for the
>>>     specified vring before stopping it.
>>>       If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
>>> -  feature has been negotiated, the back-end may suspend in-flight I/O
>>> +  feature has been negotiated, using request payload's *num* field,
>>> +  when *num* is set to 1, QEMU can tell the back-end to suspend in- 
>>> flight I/O
>>>     requests and record them as described in :ref:`Inflight I/O tracking
>>>     <inflight_io_tracking>` instead of completing them before 
>>> stopping the vring.
>>>     How to suspend an in-flight request depends on the implementation 
>>> of the back-end
>>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>> index a3ecd83f54..522e9d34b5 100644
>>> --- a/hw/block/vhost-user-blk.c
>>> +++ b/hw/block/vhost-user-blk.c
>>> @@ -134,10 +134,7 @@ static bool vhost_user_blk_inflight_needed(void 
>>> *opaque)
>>>   {
>>>       struct VHostUserBlk *s = opaque;
>>>   -    bool inflight_migration = virtio_has_feature(s- 
>>> >dev.protocol_features,
>>> - VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>> -
>>> -    return inflight_migration;
>>> +    return s->inflight_migration;
>>>   }
>>>     @@ -232,11 +229,14 @@ static int vhost_user_blk_stop(VirtIODevice 
>>> *vdev)
>>>           return 0;
>>>       }
>>>   +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
>>
>> nit: declarations on top
>>
>>> + runstate_check(RUN_STATE_FINISH_MIGRATE);
>>> +
>>>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>>>                    qemu_force_shutdown_requested();
>>>         ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
>>> -                       vhost_dev_stop(&s->dev, vdev, true, false);
>>> +                       vhost_dev_stop(&s->dev, vdev, true, skip_drain);
>>>         if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, false) 
>>> < 0) {
>>>           error_report("vhost guest notifier cleanup failed: %d", ret);
>>> @@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState 
>>> *dev, Error **errp)
>>>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>>>         s->vhost_user.supports_config = true;
>>> -    s->vhost_user.supports_inflight_migration = s->inflight_migration;
>>>       ret = vhost_dev_init(&s->dev, &s->vhost_user, 
>>> VHOST_BACKEND_TYPE_USER, 0,
>>>                            errp);
>>>       if (ret < 0) {
>>> @@ -580,10 +579,29 @@ static struct vhost_dev 
>>> *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>>       return &s->dev;
>>>   }
>>>   +static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
>>> +{
>>> +    VHostUserBlk *s = VHOST_USER_BLK(opaque);
>>> +
>>> +    bool inflight_migration_enabled = virtio_has_feature(
>>> +        s->dev.protocol_features,
>>> +        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>> +    if (vhost_user_blk_inflight_needed(s) && ! 
>>> inflight_migration_enabled) {
>>> +        error_setg(errp, "can't migrate vhost-user-blk device: "
>>> +                         "backend doesn't support "
>>> + "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
>>> +                         "protocol feature");
>>> +        return false;
>>> +    }
>>> +
>>> +    return true;
>>> +}
>>> +
>>>   static const VMStateDescription vmstate_vhost_user_blk_inflight = {
>>>       .name = "vhost-user-blk/inflight",
>>>       .version_id = 1,
>>>       .needed = vhost_user_blk_inflight_needed,
>>> +    .pre_save_errp = vhost_user_blk_pre_save,
>>>       .fields = (const VMStateField[]) {
>>>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>>>           VMSTATE_END_OF_LIST()
>>> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
>>> index bb8f8eab77..ed95ec7523 100644
>>> --- a/hw/virtio/vhost-user.c
>>> +++ b/hw/virtio/vhost-user.c
>>> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct 
>>> vhost_dev *dev, void *opaque,
>>>               }
>>>           }
>>>   -        if (!u->user->supports_inflight_migration ||
>>> -            !virtio_has_feature(protocol_features,
>>> +        if (!virtio_has_feature(protocol_features,
>>> VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>>>               protocol_features &= ~(1ULL <<
>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>>> index ac4d6fca73..54e4ce2660 100644
>>> --- a/hw/virtio/vhost.c
>>> +++ b/hw/virtio/vhost.c
>>> @@ -1398,6 +1398,7 @@ static int do_vhost_virtqueue_stop(struct 
>>> vhost_dev *dev,
>>>       int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
>>>       struct vhost_vring_state state = {
>>>           .index = vhost_vq_index,
>>> +        .num = skip_drain,
>>>       };
>>>       int r = 0;
>>>   diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/ 
>>> vhost-user.h
>>> index 53fe996686..c95bad5ddc 100644
>>> --- a/include/hw/virtio/vhost-user.h
>>> +++ b/include/hw/virtio/vhost-user.h
>>> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>>>       GPtrArray *notifiers;
>>>       int memory_slots;
>>>       bool supports_config;
>>> -    bool supports_inflight_migration;
>>>   } VhostUserState;
>>>     /**
>>

