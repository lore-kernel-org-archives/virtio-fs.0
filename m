Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F393A7837
	for <virtio-fs@lists.linux.dev>; Wed, 15 Apr 2026 15:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266507; cv=fail; b=qyZOF5srgyEA0sDU4VSpJY4Lwo7vmRSy31ddHYRb5P0MD++tu89edVPmlWtPl+hItfSWAONS/DGTF60eE+LiLgNVSj5NR2i7WfzGPWq6EQ+CtZw5d55cpVIbupBlF2IafcnKuw+hPCaMbfui3XoHp09JPxsdUrKu+BqcpVFN5X8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266507; c=relaxed/simple;
	bh=RgksbtXdrTDTTK9zk/PkoDSNYnXRuD3E1d0xo7FgQio=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gx1Si0iI19hj5rLqAFYv1z9zSNdj8dqOj0k8AYommYJtzSSKTYoYBNLqYXZf+q30MsD8xft8+0zev//HcvKfdRObxAKgj5P0NIj0dztS5JZVzF4hgatDtvRiIrXD8pJEwDdh5Bb8pTMvsBQNNztHSkATF+StYV+M9wfdZQx+rT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iZNghOV8; arc=fail smtp.client-ip=52.101.46.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iZNghOV8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nw/JMYzb6PJ26erK618ZW78tqWiKgNFMW0P80jx8UUoZxQfMI1c9NwppHAaoAwHTFGTFElwOsUT0cfAitxutybYHQ58uIkbYbXsslFvC1mWQItF1GsQdHHjRjIer+jHI29hm4jyVd8KA24DafoSULCR2qbtVGG4BYvwjjFdG1dwA9IWDMxwca7VodtoTSoZAtf1JNFj4k+6QjFgHEzWpS2QC9XaYUmL/r5HOel7tGafPOBH5nRRNblU8ltUxMkjxPq7I3Q8G3LnByde4g1atVz2dlAnA9IrHxUe1fO5+PdzG7dISuh5Mr9lgmzTgsDUEu6QEprM4lbMjfuZGViwpZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnIJJKy0LcXBq+Q35jTrh+f7QbF+2JJ5wG/yZLDO0VE=;
 b=pipM9y393+tls1Wx/dEtu8ZTI0X//95kEahtjxWiyrw4cHYjB3PM4wo0caLks3QKR++kZVxBgCRbZc17K9m8tkdyGEaB9zQyX294LjX/detdh4RRsJ4Tsr5Z/LNOY6txXUR1riBGS1eAvnt1eYep2Wsh1VfYscZdKK6qxjugoDYb3fvZbp589oUZJGh1Ftq2SnvFUF4PqPVEDFtHxCzFm5IOy8Js/6Y3RPkiD1QFklL334a++F1dbY1n6ZYrWTGRjsB3o8CspMsKxXRJYVdjX+V2mlrjCDfMY1dF5wsc2pE3cOKvHM+NWt7nQ70Tp3+Iulj2G7fZyABF13dv3KQV6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnIJJKy0LcXBq+Q35jTrh+f7QbF+2JJ5wG/yZLDO0VE=;
 b=iZNghOV8o/QXEPigSJig533KrmfonyN3hgUYJScArLrn73JjKljNS/e81b9UbmMiCRb9TtEnLdU7DPqQorxT7ppl7vHFI0WbQjr9jAN3z0nzRgxLt8GmwS6IG4KaaB5RI8H+sy1GVge6MSkFi6QGz+G7Ekap1tqcM8tz1siw+zsBvgiFrWQShJeGPd3I5u2DNbmKwLZQHiB2CqgJMczmPqbrCpigxldKnhY5tUrvVRLhd+Jv8Sa+5kdto9yZIpIhy9MCAOhOdFimh3LqU2pF8RPLEJyn30XBWacg1QSfsxJ4Hd40dtrPdAsrmrguRoPhxScI8IKgvJdqBJd1AvvmPw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by CH3PR12MB7740.namprd12.prod.outlook.com (2603:10b6:610:145::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 15:21:33 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 15:21:33 +0000
Message-ID: <613f140f-de27-4f83-8a02-5370833dd659@nvidia.com>
Date: Wed, 15 Apr 2026 17:21:22 +0200
User-Agent: Mozilla Thunderbird
From: Raphael Norwitz <rnorwitz@nvidia.com>
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
Content-Language: en-US
In-Reply-To: <20260330095226.158386-6-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0157.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:347::8) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|CH3PR12MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: f44680f4-3238-4ce1-189e-08de9b02ad13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	KbvtopAITvhQUN6Z8PlJK8x+bdyqNJ7b0x87n95uLhl/ZRmOMeX9DVLEwZL5pasENYNahchMy3Gf1s5OUmFZTVFYHmogfCXzs2Tc1U46H2M575l5IBjIB7PmURm7/LQs2jkXxKghGZ3r58ZVzGqKCBdN8MGQxJWZwNVnrjPFDDiAVob1+ayNP8PONhla/cwuz6MHePLtWU0L6JhdxomkpmWxJfCMbbbR3jPrvv4I10xSKx02qGgh5c7eNQVGDuJIccS87UOxqadbjduR3+PIXZL5aUakz5Z/CL3jR2KdtVe7jVFOrHYLuPfgKpAWepR4M4NC6Z3uMy+EUX9Jab9qg0Sbn4IBr87iIGv/VjeuErUtAMZumnYejz2WfdCfzKUlEzqWheKV9/crVY7xlLFgvtYKDFifuGR5jc+irkBztEySfggepOsQIzY+T99g8ZhYV+o2vWAN3ekJGBnLq90w1Oc9N2Gw1nCoBGibReF6lRs33fQnMqk8Q8C6ltrC61WJ95+AGOF54xdv4fdIswdFr8nb1/oYC2HEQbig7S1DKC9+spQ1FZhj0GBSxpuW9bF1C+yd7NgnoJbzj7iPHu5Xrg0XTpSR3HNylmmXT1eRDoCOKsDQr7KnbJd29OJMm98guvVLksEdTDCQBp7Uw8glGWIi6Wp05ZwOsXF/kw/3s0wOI2q+MXL3nZdq7rEeVUltDnYjEr03F130q3m/xTlVmBuBGMPLTTLJFj1SebWjj84=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzZxK0QxL1NpUy9EMTRQUzdLalJZQ2k5Sk50MFpSNkJmM0NVL2xQc2Qvek9W?=
 =?utf-8?B?UmNJc1RVckhyZm1VTExrUnNmWGpNY21vQjh2QUVkQVJyNFVyNmhxRmR2NGRM?=
 =?utf-8?B?Q1IwTndFbEc2NUpVSi9kbVpJeGRVRG0yUHUvTm1sRWpBZEJwa0cyZmE1WlJQ?=
 =?utf-8?B?R0dIUUpMVi8wWmpjOFFSWVpaanRxK1FlS3BKN1dKZTVtamticDJWNVl0VVJE?=
 =?utf-8?B?U1VTQXk5WHk5d3FHd3huOWNPNEVUZWpQK0NFdFNrUStBM2ZHMXg0UFl5dkhG?=
 =?utf-8?B?S2R2ZFU2Smx2RkI3WEF5bzhpYmkvaklQOXNUNWV5SjF1anRyVkM3VlBBSU5B?=
 =?utf-8?B?Nkh0NFRqaTk0Q0QyYlBka3BIbk9wZ0xYMi84c2dHeldNb1hDWXdtSVJwSVBR?=
 =?utf-8?B?T1ZoL3BXUzVOUWxvbXFKaU40dGJzcWV0Q1Njc1B5OWJJbUJHMUFoZ2daRzBx?=
 =?utf-8?B?aEw2M3hEZENaR254NUEyUTd5Z2hWQ3ZDMGM5UlFILy90YTV4cXdWWnl1Ui9s?=
 =?utf-8?B?aEh5cHEydHhKTzRxdXNuQmd6ekFIVytYVkEzZ21TTmNtaElPaDFUSlhYalJj?=
 =?utf-8?B?VGVpOXZ4TGtQeGFrd0FNYU9Cb1NBY1o3US80L2lYaVJQUFhZczlqRFRDZGd0?=
 =?utf-8?B?bGJxSXcxcGxXdHlOMmllNGpRSG5SeVFjcVBBc2d6RVhjTUUvam1RQTlha2dM?=
 =?utf-8?B?QzQvci9OaWVsNnJQVVBLckpHV3Z3cVBWc1llTjlMcVZzaU05U25xbjM4ZXZG?=
 =?utf-8?B?eUIvOVNyNmg5U1VxWU02dHhLeU04a1NkREJTeldmVmhJaFUrSm5CZGd4dXN1?=
 =?utf-8?B?L1NQUnFKNWNneC93WW5VUTZ3WWhZRXNkRmRvZmNMa2lzNjdFM0dVRHlHeTdq?=
 =?utf-8?B?TUdmN25SWnQ4eWl1VXowdlprNDh6M2o3QVUrdjlpdTBXS25NOXkxWjFXdDRP?=
 =?utf-8?B?K0VqeE5HZmgyaEhzTGswS092aFdFeGZzQzIwSGVFL3NMWmh0cHRUWEthS1li?=
 =?utf-8?B?aVpjN1FMTUU4MGlBZnR3NmlYeHhheVZka0RaaGE4U2JTamh5UFlJaVdWQ2h2?=
 =?utf-8?B?SU5yaWxlZXMvaVRGdVYyemlWQW9uTk9EQzZ3Z2Q2L2tHT3VUYzdMUkl3eWR2?=
 =?utf-8?B?NTZ5aUlpTzF5Sk1iNnJZdUN5K2VtdUhDcHRrbGlhZUQ4K0Zza3JFV292MTl2?=
 =?utf-8?B?ck1BQXZLaExIb0NXd2w2Z1RobEFnWnpCVmIzT2Rxem56S1hlaU9HWEVNYXIx?=
 =?utf-8?B?R2I5UUY5aGR1c2phdHZmZTNhR00zRGJnY3NDMGxIalNGS01pcDhqOXFyc1gy?=
 =?utf-8?B?Rk53TnU3RXI2QkszVktXKzMvT1hiWDlQcE5zVW4wL2RSTThnOWc0V3hKY3pq?=
 =?utf-8?B?d1RxcmtJVHcwczl6Zm1JZE9IUDZVZzlaelV5cnhhazdnajNyRlNMZTN2cE1I?=
 =?utf-8?B?QnF2QTYvbERFZmZna2N5VzVlbCs5R2EwWmdRQkhuZjJ6c2QrNzlvelR0RFpM?=
 =?utf-8?B?R3NXbnJFVWlGL1pYMEVKZm5MYlExNno2bS8vMnVrVzIxcnQ0Z0lYUmtNS2VT?=
 =?utf-8?B?YXJSUS9sMnFVdmUwTjdCcXRycnRMNUxieTd1SjFKT0Rhdk5IV0VrY3IxYURS?=
 =?utf-8?B?c0pBMjZKVW9Iazd3UEVGaGZkQWMrWnc0QWFBdTdYUkoxK29lWWRKMFlCS3di?=
 =?utf-8?B?NnRmbjhoKzJHaHZ5ZnIxR0Y3V09uQmxRbTVmZ09pbWxIeWovOEUxendJbUF1?=
 =?utf-8?B?UkVBSjJsMk5GcFFPQVp0SkNhSFREcHN3ZEcvNUtacE5DRTZNL1ZFS3dGV2Jq?=
 =?utf-8?B?OVd4RHFNVzBIa2ZZSXEwUHJ6ajBJcGJMdU4vMm5XMVd4aUk1K0podU5POGZN?=
 =?utf-8?B?bFpkeUZ5YmhxWXkzTStSaERldHg4c2t1bVNvUGt0RGNpZUJES2RIZXhOSUZR?=
 =?utf-8?B?UHUvUUVIeEt2N1FXMEI4UlZzSy92UkhWcE5hL3Y1MklpZEcwU1dFZVBZZWJi?=
 =?utf-8?B?YVdyRCthWEJwME8ySkhLK0lIMGIxb2NEbDZ0WHBCQmQ5NVR6Q1ZUSVROSVk1?=
 =?utf-8?B?Y0N5VmNvMEx6dTlwb1A1ejNyelZ2NDEvdEtMZkdUdmI4N1pmYk03UFlyWXA5?=
 =?utf-8?B?ME1DYmxzNVdOYUtXS1JGU3lVY2EwU0lsRTJQVElzTHN6OHBmMVFOMFJ1RGls?=
 =?utf-8?B?cWpBNjNHa3FGbzN3YUlEbnFLT2NKdW1Cb0VDTklWWXNWdlY2aVhDVDdTYVY2?=
 =?utf-8?B?N0E5MlI5TDlVSDVWUWprSUhIYXhRcVlCNFdHajA3Q1ZNSVBhTkRPRmgvSk1w?=
 =?utf-8?B?WDNFeVVVbCthK1NZb1lrRWtwU05rT0VzVDcxa0s0YjJ6NDk2TGhhUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44680f4-3238-4ce1-189e-08de9b02ad13
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 15:21:33.0216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSW9a3WhJ5GKHeR7e57ifwzQqqpEXYEkmFJE8i7mQqsXKFYHDEVMu9bHLEF85j9nxAs/jjP/XB+WZ323JhpcKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7740

I’m not sure I like using the num field in vhost_vring_state to set 
magic values which affect protocol behavior for GET_VRING_BASE. It feels 
like a hack to me. I would think the proper solution if we want to 
support migration from new to old would be to have new use a different 
new message entirely. Can we do that?

On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
> In case of migration of QEMU from the new version (where the
> inllight-migration parameter is present), to the old one (where it is

nit: spelling inllight-migration

> absent) there is no way to disable this feature on the backend during
> runtime.
> 
> This commit slightly changes the semantics of the protocol feature
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
> adds a new parameter for GET_VRING_BASE, which allows to control the
> drain in-flight requests on the backend.
> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
> on anytime.
> 
> In vhost-user-blk use inflight_migration param to enable skip_drain to
> suspend in-flight I/O requests, and then migrate them throught inflight
> subsection.
> 
> Also now QEMU will always try to setup
> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
> backend. This will allow to use skip_drain parameter on GET_VRING_BASE
> message.
> 
> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>   docs/interop/vhost-user.rst    |  6 ++----
>   hw/block/vhost-user-blk.c      | 30 ++++++++++++++++++++++++------
>   hw/virtio/vhost-user.c         |  3 +--
>   hw/virtio/vhost.c              |  1 +
>   include/hw/virtio/vhost-user.h |  1 -
>   5 files changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
> index bfa75ff9a3..63efc87264 100644
> --- a/docs/interop/vhost-user.rst
> +++ b/docs/interop/vhost-user.rst
> @@ -1255,14 +1255,12 @@ Front-end message types
>     *suspended*, see :ref:`Suspended device state
>     <suspended_device_state>`.
>   
> -  The request payload's *num* field is currently reserved and must be
> -  set to 0.
> -
>     By default, the back-end must complete all inflight I/O requests for the
>     specified vring before stopping it.
>   
>     If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` protocol
> -  feature has been negotiated, the back-end may suspend in-flight I/O
> +  feature has been negotiated, using request payload's *num* field,
> +  when *num* is set to 1, QEMU can tell the back-end to suspend in-flight I/O
>     requests and record them as described in :ref:`Inflight I/O tracking
>     <inflight_io_tracking>` instead of completing them before stopping the vring.
>     How to suspend an in-flight request depends on the implementation of the back-end
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index a3ecd83f54..522e9d34b5 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -134,10 +134,7 @@ static bool vhost_user_blk_inflight_needed(void *opaque)
>   {
>       struct VHostUserBlk *s = opaque;
>   
> -    bool inflight_migration = virtio_has_feature(s->dev.protocol_features,
> -                               VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> -
> -    return inflight_migration;
> +    return s->inflight_migration;
>   }
>   
>   
> @@ -232,11 +229,14 @@ static int vhost_user_blk_stop(VirtIODevice *vdev)
>           return 0;
>       }
>   
> +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&

nit: declarations on top

> +                      runstate_check(RUN_STATE_FINISH_MIGRATE);
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
> @@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState *dev, Error **errp)
>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>   
>       s->vhost_user.supports_config = true;
> -    s->vhost_user.supports_inflight_migration = s->inflight_migration;
>       ret = vhost_dev_init(&s->dev, &s->vhost_user, VHOST_BACKEND_TYPE_USER, 0,
>                            errp);
>       if (ret < 0) {
> @@ -580,10 +579,29 @@ static struct vhost_dev *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>       return &s->dev;
>   }
>   
> +static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
> +{
> +    VHostUserBlk *s = VHOST_USER_BLK(opaque);
> +
> +    bool inflight_migration_enabled = virtio_has_feature(
> +        s->dev.protocol_features,
> +        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> +    if (vhost_user_blk_inflight_needed(s) && !inflight_migration_enabled) {
> +        error_setg(errp, "can't migrate vhost-user-blk device: "
> +                         "backend doesn't support "
> +                         "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
> +                         "protocol feature");
> +        return false;
> +    }
> +
> +    return true;
> +}
> +
>   static const VMStateDescription vmstate_vhost_user_blk_inflight = {
>       .name = "vhost-user-blk/inflight",
>       .version_id = 1,
>       .needed = vhost_user_blk_inflight_needed,
> +    .pre_save_errp = vhost_user_blk_pre_save,
>       .fields = (const VMStateField[]) {
>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>           VMSTATE_END_OF_LIST()
> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
> index bb8f8eab77..ed95ec7523 100644
> --- a/hw/virtio/vhost-user.c
> +++ b/hw/virtio/vhost-user.c
> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct vhost_dev *dev, void *opaque,
>               }
>           }
>   
> -        if (!u->user->supports_inflight_migration ||
> -            !virtio_has_feature(protocol_features,
> +        if (!virtio_has_feature(protocol_features,
>                                   VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>               protocol_features &= ~(1ULL <<
>                                  VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> index ac4d6fca73..54e4ce2660 100644
> --- a/hw/virtio/vhost.c
> +++ b/hw/virtio/vhost.c
> @@ -1398,6 +1398,7 @@ static int do_vhost_virtqueue_stop(struct vhost_dev *dev,
>       int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, idx);
>       struct vhost_vring_state state = {
>           .index = vhost_vq_index,
> +        .num = skip_drain,
>       };
>       int r = 0;
>   
> diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/vhost-user.h
> index 53fe996686..c95bad5ddc 100644
> --- a/include/hw/virtio/vhost-user.h
> +++ b/include/hw/virtio/vhost-user.h
> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>       GPtrArray *notifiers;
>       int memory_slots;
>       bool supports_config;
> -    bool supports_inflight_migration;
>   } VhostUserState;
>   
>   /**

