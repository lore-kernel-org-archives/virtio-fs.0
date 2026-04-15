Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012026.outbound.protection.outlook.com [52.101.48.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836CF21FF2A
	for <virtio-fs@lists.linux.dev>; Wed, 15 Apr 2026 15:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266581; cv=fail; b=r0P5zHBZHbpYMakf9SCfCEXc1w9oWeNb1oY96WvA+pVAxUOmwwgszb2ahHCpgCZi1H+2s98DtAO5t/MECFKSEFNzpRFisptVMgVOz7TArubdJVHkfbGm1IMp6yTvWJzyw3ZsiJ6JVEb1sTpritS7bzA5xZM2q3aZLkRimxMDVyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266581; c=relaxed/simple;
	bh=VUX7c2uU5lGGtIKPJgvwTF6th7Z8NeVeJyRhR0wgyPA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e+a4VnFG+T/piKo+qSdNijm+xbF9+HG03dcNW97l4Fa/j3ORCEd/OVYttoUOWsHwhHh4++qBji6CXWAkp8MkUeiV5+0UjDNlUNnLXOV+YIH/NCyGKfXzyWzNN6KS4evrFn4kaU0HiUMpsAK7KsIvjdemFB+5tQrhsfIwKoZatr4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ooSRYZGl; arc=fail smtp.client-ip=52.101.48.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ooSRYZGl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3sKqAaNhGHJdNQBYah3RpohwR4oBwhND9MNI96Sh+lKMlw2lz64l3dLkXcMq2avEXZct1EbADGfvpz3Z/LLln+p0PABqv0mnfqTebpaY9MqQZTHPGABalSV7pYfkk7dQBTWIU+PQc1UaO1Hx7olFs8LikYlVeo6X0rfEhafk17b5e5xvriCPG9Kwxvn3YTUP1vfdf6077TpVwomjn4xJesoNkJAxV8c/wsOZA48bH1G1pYoUWMT5LmSt3+O6TJ8qNuLMozO708Qto5KPs4kspaI4F+ggaUTdylOyGLjshXOT+cgdw/z9qMzFQm4hsML/LNYvh9n6QkY0OB3lVbcaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AYTURDiXfnOTiU1Q8VaEUCu6nkDBThA40TrMwNQ4y4=;
 b=WfcPb6c3uFZzzYzjp7nJN0A7NrR6WJ3eYdPXTXZMgd8XhRRnamqCxwfURCiBeYeQA4GKELcxzU/5JVrNBg/whPyn1wbxwSDrb9tztsovHD5a9b2rwk4Xy/MN5bX1pbHjQ1h92PUIOSmKvSMh61jWtJB/2pOOhPOp/UCIMDJuAYrMaczEVPY+ThoSuWGAeCHomh72dEYzTLRZNpZ+MNtyg042Pqog6ZLq/kUrg5m96iHYYo0zI1ocQ8og7sr8a5RsOciSTzhLtMZgmDQddXKBt0S0f0Q42Gx7P3DGOyj4zvjERP/DOVc4mwg4uXijKQypo/dKnA4JEJQRgxh9FdaXnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AYTURDiXfnOTiU1Q8VaEUCu6nkDBThA40TrMwNQ4y4=;
 b=ooSRYZGlCZ8AW/lDbklB06lLrkuG32gHrogUGESBcXyHuZqxAYxpcP17ggcg4NSvYdWxk8hHjuEZ7fUdcjCQ5E90PK6tGIErzSNbBlCnOkSgRb6lOxqo1Z4PHyzV43oStkeI3W+VP8Lg3b+S8LxTaErhk3bsnrL3kVRNsaesw651fNcSpI4N/RtIFHqGzQVsOiskcslwlOiKinxNhUcez8eGEyVutVseQY2qTOQht0zJxzEy0vwUUxtfpVfwc67hUaMYiYHNZnX7o3SI1dUqS2RSsBdFod8eOD+Ah0eggxKwReJBkqEI59HWX3pcDfeNqAdqhh8AKySAqSw5V1+NyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by CH3PR12MB7740.namprd12.prod.outlook.com (2603:10b6:610:145::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 15:22:49 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 15:22:49 +0000
Message-ID: <37d37c84-4457-46ff-bfe6-9f5e2b66f459@nvidia.com>
Date: Wed, 15 Apr 2026 17:22:26 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] vhost-user.rst: fix typo
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
 <20260330095226.158386-2-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <20260330095226.158386-2-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0166.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:347::12) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|CH3PR12MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: d959d384-d894-4501-76f9-08de9b02da75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	cK2V+4cZeE/1vH/rt1PfUvy7ty9OAhtWsdMUMpeJMCKm+au4oQTaX8aeP1PpsMLtCNhAHZExuJUYnSGCl9OlxS++TqL4noYmPj1FWvx9nBH2zo3KxK6R5gUxw/vE1M7icLYp4Ugf3CQVpanL84niq0+8vyhCH86gEUAb4HyiyyhZHzeHjwphZaPYE34O9LCdOovLNOTi9UHSH0POScit5Dc50QqUdhPjGwasj9LSYdd3gR8vC6UoJnapuVTWfQ5V9qoFC4peaBSGbbuFJHpIoJRTQCkIa+a1MUJpQBkdORcGkIfmDnmExWH/JBqHa9IkuGp89PWqOmJO19aIks5m20HVMhoQ/6dVky7fGBS6gwDqAIGI8Zd9NLJb1DZNJ3tSfoiPdAPiOLMzokPashyGlXMd4W0+329jKIef/ojha3Xpkf1EVdWm+hMabl2OmOKxw9QfHctqS5D5/8kdtE1c32QqZ3obSsOpT1doVC13qftJHkK/apk4t/3pG/dwheAzldeqoNBpVzUyRczcfU2FJruh9wSyms0oIwRpi81wWu/RPyn4BQPs6rtruqOh3nW22sxfEXGw24FnR0j8asiGgucAc0MaQLTD3UnVr3MJXvN+dSF2RHaT1MeBupNHFZpOArqfI8R+Vy0H2gJwp/gzgILZ8zpAWW5ZhJJR0d2OtSf6+RsPjEPdTMqJ5SLxjtx3otgg2rssLbKnZMBRQjep06LPacyFaDC0FXBAjhQci8U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTRsU242bmFYVms4WEpxd0ZqK0dHdzJYZmpXNEE1aE0vNzhVN1dKeW5KaXcr?=
 =?utf-8?B?RUtvRkNvV210MGtuTHRTbjN1b1M0N0dySWRCT1U2c0FaSnFhV3JiZmpQWUY2?=
 =?utf-8?B?SFVFTTRVVTFlK0NjRkljVGJQSWZtRjl5QUd4alRIUHV4TG81UVNxRUJjUlJB?=
 =?utf-8?B?NmVTK0c1dEdhS3VaakdqNVF4WHkxVDlNRjBVVGNyVEMrdDVCNmRrRTJPVlln?=
 =?utf-8?B?UFM0dzloVjFaQWgxcmM0VElnSWVQbE9CY3hENEYzS1lHa1ZrZEhMY0hXbGdW?=
 =?utf-8?B?aXZ1a1Q2ek5waUNlYmRZZmE5dSt5akQ1U2VjR3UxdmtuVWFhcC85UUcxNm9Q?=
 =?utf-8?B?bC9XNmVDekNXZ1pvcTFUaFd1WkRvYkhVMXlUZ2pIK05LbGM5VE9lM2NPRVpq?=
 =?utf-8?B?bHZZTjViaFBRSGh0Q0ZXY1ZjY0FXTDJiaWhiV281cWxyVkZXUWxOVFllOHM0?=
 =?utf-8?B?VzJlMW1EYjJsd3dRTFNlVGhHNE9EaGE5QW1ueFExSDdpbWJzSFlIOThwelZU?=
 =?utf-8?B?RGRLa3E2blZFVEdQWEdqc1haR2dxMDFIVkVlMHExRmkrWFZkTVFCMzJ4ajRI?=
 =?utf-8?B?ZTUzRG04K3BTMFR4UVBqZDhMeXdEWWQ1NEFJU0JtQkgzTjVDcGo0YVVwVEo1?=
 =?utf-8?B?RVArSFhkMTd6MkozeTd6ZU5zZFF0aW43bytINmR1dC9HcUs4cVVuMlJxQ0Rk?=
 =?utf-8?B?a05EcFRjdDYyeVFFRldpQ21BczVmVjB5RzZkOVpTNjBTdkVxTklvb0dDazJQ?=
 =?utf-8?B?L1VPYUQyN3A4allJcTB6b0trdjBoRGtxcld4c2s4L2wyU2VXTTVnSVdpWVYx?=
 =?utf-8?B?U1JYYXp1Kys3QUU4NWd5YjNXQnNYQWY0TGdtZHdRdlFxSWoyc2VMRUFWdE05?=
 =?utf-8?B?REovSGZ1WE96SmwxalYxQnBkWTg2dWV3d3hMZGF6SHpFNzhIYkdmNmc1bnB4?=
 =?utf-8?B?T3pFV3R2Ykc2SHBiUWIrT2E3ZGN3VzkzN2h5MmEwM1hhSjJLb1VrcXU4MTNa?=
 =?utf-8?B?VG1EUXlzTDBqaTllZXJmMFZTQ1lBMXcrODNXMGlFVFVJNkxub2d5YkcyS1Uv?=
 =?utf-8?B?bDBwZ1d3T0hWL2dpbDA2WUw0aDNOTDFmSU9nVHJBMFJ0eUFvUTBZZ1lZVjkv?=
 =?utf-8?B?UllZSS9qRDRqZU5lbi85TlB1MkFWK2FrKzFIL2p4UE9XUTdOeERNVk5wZWNk?=
 =?utf-8?B?Mnp6QXpXU3Iwa2FlaGZmNTFTcTBzbTV4cncxVExlbEdjRWlHeVhFbmFMRUpq?=
 =?utf-8?B?U0lWZ0pRSlk2ZXFMMEE0cHo5LzdVZG96cFBtODE1NWVKYXhlaU1GeU1DRjNq?=
 =?utf-8?B?UUJ4YkpiWmtIYmtMUDZuRzJWOEhuN0FrR3FZQnV5QVdjejJBNGFZSE1vWXBP?=
 =?utf-8?B?YkZSdXlra0E2RjNIcDlhdUFpQmp3M2F5NDJwd1JqRC9RWXQ1elJHbXdsZzVj?=
 =?utf-8?B?b2xDd0h5WFMvU1VLejRKc2phWmVRN29CVlVrUEUxZGJaQmVIODBhNjhsaWlP?=
 =?utf-8?B?VzY2TU1LbTRFaW14c0orcFBiSW5wNVppd0FZOXMxdVNNb3J6T3JaYjQ4Q1lP?=
 =?utf-8?B?Z3ZNVS9TUTNESm5zRU1QdDZQQWFhcmVJVm5Vb3pPVFh4dFFna2RIRlg5YU4z?=
 =?utf-8?B?S1gvcHkvUFNmTXpvWTMxMGRmNjZ3c01xWXFiZE5nUEJmMzVmWE82MS9iMU5R?=
 =?utf-8?B?WGs0V1hKaUdZeFBxRVRQejQ2cGpzd1JCVmYvWnM0bUxUQlR3alFxR1c1U1pH?=
 =?utf-8?B?ZkxkNm8xekpwc1BGQnlBSHRLU1NENU16YkY5ODJsRkIyRzlzN2xLdjFYUzR4?=
 =?utf-8?B?akRZSEtPSzRib1pMRDVoeVBSbzFOaVRxZnh3RVJhcEF2ZGpXSU5pV3h5Ympp?=
 =?utf-8?B?bUcveUhEb1lvWUhFOGo4NDNLNW1ZbjA3SExrZkQrUTF6dDFZaXhISVIyTUYv?=
 =?utf-8?B?NHExS0kxcmtBNEpYbjBOVFkzRC9VUXIzYVo3U3lPWm1UelF2YlJZbFhScG1y?=
 =?utf-8?B?Tms5ZFpOTTFCUkVBeHdKVzBMV2RSRmVkdzRROUNwb3NvS1JiSWtIT2txUnBh?=
 =?utf-8?B?V0Vyd1dEYkpoOGNqdXVhTzhodysxZ3NvT2JEM0lKK09UaWFVc3VQZHZleFhk?=
 =?utf-8?B?U3pBU3ZQZEM3by9scVNndGcyQWlkMGRCOFJML3BjZFBJNGhWNmVNWU4vcmpN?=
 =?utf-8?B?K2J5a0Y2bit5NTl1R1pjbXRNdEFGblVYUjdreEVPVW5ENnFsQ0wvSWdIbDBh?=
 =?utf-8?B?bElvMnpCNUpCMUcrQlk1dDVZeUFCYm1ZL25qR3dNY25NNnFxenlmM1dHU3g3?=
 =?utf-8?B?WlpBZXRjMC9XQTJoc2JoSHIwYk16QUc1OVZGaHo5dWRnbkRlaDAvQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d959d384-d894-4501-76f9-08de9b02da75
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 15:22:49.1391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ftX3LfAI8qZTJimPuUWkT1W4z3k/GpNFkjt+B/AlEqkI5gjMtb9RpAdJbBpHADKQGmQ0DDbbBoJNvOKWWMrB5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7740

Reviewed-by: Raphael Norwitz <rnorwitz@nvidia.com>

On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>   docs/interop/vhost-user.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index 137c9f3669..bfa75ff9a3 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1268,7 +1268,7 @@ Front-end message types
>     How to suspend an in-flight request depends on the implementation of the back-end
>     but it typically can be done by aborting or cancelling the underlying I/O
>     request. The ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT``
> -  protocol feature must only be neogotiated if
> +  protocol feature must only be negotiated if
>     ``VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD`` is also negotiated.
>   
>   ``VHOST_USER_SET_VRING_KICK``

