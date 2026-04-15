Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013004.outbound.protection.outlook.com [40.93.196.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93433A7837
	for <virtio-fs@lists.linux.dev>; Wed, 15 Apr 2026 15:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776266612; cv=fail; b=aXDERJhYwCUZvjoHxxSGgISRMO4qCWrOahW2RBJtqfbrHRUTGwwB1j4YbMjOYnW0jxXgSJqoEVCZ7rCaL4edk5U14aitQ9N+yS4rRoX0IzjHy+Yq2Cyz0Y6fFFADyNJWi3+T1cXP21pDdoz/SJyS8/UIgI1xYMFAqsxLp9Lt47c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776266612; c=relaxed/simple;
	bh=enZb5/gHsLeBLK8q8XIRNLgr4rOSqSBZ8+TpGJX3pBA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fU6g0lVZzx32J18sO4SQj3DV5RNWKacn+FOWvOaBIfoD/sLoVuPLkVV5VFzKXIBkYtNvhhKh3Mmy6qpBN07pZy/SKdSrVbyv/xWvPdIVL5Gu9NqEfEtwIifn89liW/koG9O7dSOWRI+rsv++U/Ll5NOrNKYZ+10zn0xE1kr2ZUI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bxKp4HER; arc=fail smtp.client-ip=40.93.196.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bxKp4HER"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JDzK7WWkEbNx/kDksOmf/1T0orGgUG2/DbxTQbeNFtaHar/4QVRMHq2lxiYz4EllM/o0IpV4pQzX24YwnjOSv1ETiUgD07R+7cH9x0RqZTeixPhf24bKEIYjaHlmSwWbIZHWGchUDJCAFYcZkdyQAGprGU8FeIz+aJpj8IArs0Mlw8LRQoSUEAVq4WYqbH5XTm27l9k1rdwwWOu0Mo0+bSCF0Kyr71wwOj1ZpWTOGK8R0d61aleimhX8egqK2FlruP0WGm5a+dXcZYIr5tyElAQ0KNpxIj7bXXfQIjOyqPpiYSDbxrG/9Ltz0eEP+EiwKz8qTQrUFBo2hfwhN8eP6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWeFXn8BGHksdZCkJZgiwu8FehmaZIkXS8akSzGFp78=;
 b=SWHop90BYgzQ5K5n2cz30jbtIoyY8ZBBIwNoOzEY6RJKUaI0YCONb3aRyJW3ks47P62N4UVUi7DMyiGMJ6MPSc8rudWYVlbIEOTy0fycP4ZpSI0tSBGbiDWF4cLWPRFcbICB/VWPHD2HSaIykDj6gXkh99pow9PIZTREMKsj6z9w6Bccc8jEn22gPcNtNf/qRXvbZjvT4dCnjA96Hx6pLAW8WXLMX7lfDix24hMuNnVa1LhS+KQTjWaE9CIMsgTMUcDcJsQ7dS73D6UINMgvcEUTdWoGJdLWOdaPU1RA48Tany+a8AHc4MIS2JUduW6HEcRf6sBlT09Wp9rCkiyoeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWeFXn8BGHksdZCkJZgiwu8FehmaZIkXS8akSzGFp78=;
 b=bxKp4HERmPwH8YkLE/yEF13yFdcO9IRDYmpBL5E2reRr3WlRY94SkHN2yEjDRh6M/qw4IYsg2RH9oLT1xPJsZdi9U0t9L22OMYTPgP5Vp/O05zAxPfC+hh8oIcPa0YNIY/LSjKTYFDws8yryX+NeugnEbNOj+EcPtN3W87iZPbJFAt5KPTTwS94DiZts5TcEDCcqZ1pkuE+jVphHvR63UU5xAhWEhUDP+Iaz4rlgcmiHR2qFmUHGQpMKhamfMmVQEyxBFmESKZja+4Ww58aNks9ryfxw8/DLoWqlB1qXDqrdTJJW8zy2Oy1cLrLu+zlin7tMJkdLvYinNR4JLUagCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by CH3PR12MB7740.namprd12.prod.outlook.com (2603:10b6:610:145::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 15:23:26 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.20.9818.017; Wed, 15 Apr 2026
 15:23:25 +0000
Message-ID: <4c6a57cc-5174-4678-95fe-8578096074ef@nvidia.com>
Date: Wed, 15 Apr 2026 17:23:11 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] vhost-user-blk: make inflight-migration prop
 mutable
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
 Kevin Wolf <kwolf@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
References: <20260330095226.158386-1-dtalexundeer@yandex-team.ru>
 <20260330095226.158386-3-dtalexundeer@yandex-team.ru>
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <20260330095226.158386-3-dtalexundeer@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3PR09CA0028.eurprd09.prod.outlook.com
 (2603:10a6:102:b7::33) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|CH3PR12MB7740:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a539c8d-18cb-4575-5c50-08de9b02f055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	ukEGK6aNPoLPn1HfF6v3mQQTZjKYHNqtlCJWH66jTNBnZHE0SEdWZCv+U5/54SY8CSMvrak2aMvZ4bAQtG9j2J1Z8Ht0MhhlhEC9+ujJ9Ludy2oIFqaOUn+IKn+A+w3XrqIAvdC3ddCUcMrSYz1cnfBN9ZLshGoLoOIj5tVymsRr5QwACJoSzTeEaFDQrM2XNEn7oJRX0OUDD9DbHkTD9z+4aQxg4EY8RoD9CObmPWCn3xsM4vOJ5+zHq05/atv3LUGOsMvfzHd9n77J8KHgFso4hGUHUPfEClX2vwZWFEcWZDVz0Ig67m1I2e2lZo6RBVfKiBxuWlgFL1zPoRDlk53MMPM83QXlHk70qojde/2C+R/rretEnkZ2iAgKnZATtVrhshim2WEtZ52/O8hmalECkdz7hbkhlx3ueGkwBw3w6oPTHcAxOsSshljPTAC0AWrGAL4SLvZsIToUZGNdPoeOLBT+3IkyQvCMj6Kg8ozKv2kCyyJH1agnCPkR+aAOSgBWDidHiBftiBgYLZr7LZN5R66AdLA8erVsQO6rwZ2p4s4047F05HFcK/1jrQE+raeGgt1H2j8xJ0EqXKrKRZX/XYWqH96QWxNMiowCIsl/kMOB4lSEVeKiWpl82GfCzaKc6XYSQ32WAS6BCRCNtO8g5c82GISBxtu0AJTH2TjpQY8dj/OH6XmYendRLKF29JPtvVeN5JUQdKGgPGgkJKwbiMwevXcZ5Kdgo0hBeSQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXBrcEdWVWp0N21LUGY2UFYzTkJINzJ4aW9maENrcGNNVzNTeGJyMGlhK0x1?=
 =?utf-8?B?SGE3Z3ZTT0RWM3RZL29JdjhnYlYxSy80Wk5YeGV3Mnd4OHgwUng2M09SY3lt?=
 =?utf-8?B?NFliMnVqSGZOdFR0QzZSTzZFczQwYWNtUHdodUhtR2daRGsrTEU0YStHNUxC?=
 =?utf-8?B?TFZBZGFPUFNDUmErWHYxMU5JRkhsSTc3QVpSTHZHZUxlRE1OR3oydENsckVG?=
 =?utf-8?B?RGJEQm45bG1FMXJTZXFmUWJBdEZYT1BKMjBSVUpkREx0alhINFdaYldkMmYy?=
 =?utf-8?B?THFWS2pJa1o2bjdtNllNa1hvMzRhK2doRmhMdVlGaWNwKzlueGVkSmo1MnM2?=
 =?utf-8?B?R2IxbnBtdmljSUxCWWwxS0xVSU1uY2VkcFpXOHliVGkwZk1ZZHpSVXVmTUpa?=
 =?utf-8?B?bmZiRDZibjVraCswMlZ5SzEyV0g3WEU4QThBMktaaDBsS2dONUxJZGJCa2xl?=
 =?utf-8?B?dnFNUmI2TUdmNTZmNURDZ2xjcndXajVLMUxhQkQyRlZLUndiM3hWLzJyNzFY?=
 =?utf-8?B?Uk1Dd2RPdEpwcDlyVkdnUytqM1RRSmRGTm1JUVhrcVJ5NVVtNnNMRWhhY1NI?=
 =?utf-8?B?SCtwUlB3MzZ1cWgxNGJBc0dvZ3gvcHhIcFJadzF4NWRYZXBvUFY1VlJ0TGt3?=
 =?utf-8?B?dnB1MUZuTVdYaGZNNzRINm83QTBLSWY2b1dYSVlSbDRxQjB3MEhwbFJ2ZThJ?=
 =?utf-8?B?TE5RK0VUaEJRdjNWaTl1eGo4eXpiK2Q4aXlWUWhzMDVyVHZSaWN2UkNOanpj?=
 =?utf-8?B?MHZxdXdRbEJaejFSM0xKbUlQS2N5cVhldnBDT293cVlqdkZ1NjRvTUtXUUw0?=
 =?utf-8?B?aW1vcHg3dWlndzhVNFhsK3pBSDZQUWlUanlzalRzRm5lZ0ExdThqTEVwR0dz?=
 =?utf-8?B?U0VzNEdOOTBHekhQVDBVck5rN3BleGxtd1VxQVRCR2U0RU1Uejl3cXlxL1pJ?=
 =?utf-8?B?bjVyVjNQV21VcUVaaFl0clpjcktOQlZRWTMrVmtkU3I4NkFocUc0U3FFZU40?=
 =?utf-8?B?em1XZkY3QmlqRWN6UFAvTG9Lc1J5dWxWNHJnMFB0UzlVbjNnTGxXS3gvMW12?=
 =?utf-8?B?NHMzbDhTcEFXQkRwOGJvUmx0YktpT0VVaGg2UFFGWGpCK2ZqSDUrS0RaN0Ew?=
 =?utf-8?B?Mm5TODlRcURBSFZxRWNvQm9yanZONmJrNW41VTYrVDMyZk52K2ZteVZ5Sm1J?=
 =?utf-8?B?ZmZWbVlTTURXd0FJZFlQT3h1WlV4QTVHOEtvMG9XZ0dNb2FmenZJYmVHdENH?=
 =?utf-8?B?WFhnWXlyRGJGYUJzanhGME1HaGlmN1JVZ0IyNVQ1d3Q3d3YzQUJIL0tHTjNC?=
 =?utf-8?B?OGRSVW9EcG1uc1RCaHFKQTZ5azNGOHlKNFJjdjluVWw2VW5EWlN3amRwdHcw?=
 =?utf-8?B?bW82M1ltbTc0NzNUeW0reUNiUTJTalFDdFZQRWNGblpiS1VsUHkzY2s2NjR6?=
 =?utf-8?B?SEdjSGZ6emk5cEhKK1BXRTV5MDN2WE5xNnphdnZNRmxaRmo3TUxEQ2p3UkE2?=
 =?utf-8?B?R1dMTE4rSCtpMkdLQXJicWxBYlV4d0NQZStrOW9kbFZ3dXVWc2VPOEJwNnpM?=
 =?utf-8?B?RlZGajBJZHJpVXNMMzJ1M2tJbzZOYnlMM1Zzek5MYkp1T2hKQ3lFY1JyT1I0?=
 =?utf-8?B?VUo5SU5rOFVXaDRUSG1yamFEeCsxcWd0Y1ZNSUJSRFIvZFprTk1oeURWL2lD?=
 =?utf-8?B?MDZVQjcvTlBlWWZqdmJvRlp0REgvSHZPRmlvVnp4SlViMjV3dng2K25kZkx1?=
 =?utf-8?B?WnRoczhXaXdoeTlFSWRoblo4N3k5VlhIM2NlcUZVMm1zaUwzVFljU2cvU2VK?=
 =?utf-8?B?VkhLaW1ETWhCbHRNOUNtQ3d3NDV2TGJNSzN6N1A2Qyt0c2I3TXI2ZW9RY2RU?=
 =?utf-8?B?bGh2d2ppd21RMm9tUitudmVYQ1VLUDNoOUQ0TTVMUDcrZWJrcjljKzB4QUd4?=
 =?utf-8?B?OS83aTcrald2eFFhZ0hQSU5LMGJwTk9kVlk1dkEvS29OUUZZMnoyOXQxU1Zx?=
 =?utf-8?B?ZmgvcXFzWWpwWndubjVRMGJLNFZmNXFKNDFZR1diNUo4RFArcWJpV3ZsZkNW?=
 =?utf-8?B?K1ZERWxZTWt0dGVpQlFndXFRSE53OFFNbFhLaGtCeWlKa1NaQmpFNnFnY1Z0?=
 =?utf-8?B?MGNuQVJYdGQ5ckh4a3VWTDBCMW5SZ3MzRlJpb0tDNlVMb3dWWllRSFpJcStQ?=
 =?utf-8?B?dHZxZFhCKzlXU1ZSMjVWRlBCcXNTODVpSXVmalBhUmpHY0trNkphSS9aWDVs?=
 =?utf-8?B?OGlQZXIydjZQVXlrRFl6MS9JRUJuOFB3TTZjNHJtdmhuUDFiVE5ONnB6SDJC?=
 =?utf-8?B?SVlLVTN4WlhGdkRJZU9zZWpBVkxxMWg3ejRZWUhtN0YzWUl6MGtEUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a539c8d-18cb-4575-5c50-08de9b02f055
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 15:23:25.8462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jzbCzn0qOXlsw2PdkdWLo1Mbvn2SlDe280KyhgW1HVMfXALy273xidID6j2iT+I6yEJ79w6mwXc2hj2fOKdg4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7740

Acked-by: Raphael Norwitz <rnorwitz@nvidia.com>

On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
> Now this property can be turned on or off using the qom-set
> 
> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> ---
>   hw/block/vhost-user-blk.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
> index c151e83677..179f027cb4 100644
> --- a/hw/block/vhost-user-blk.c
> +++ b/hw/block/vhost-user-blk.c
> @@ -603,6 +603,8 @@ static const VMStateDescription vmstate_vhost_user_blk = {
>       }
>   };
>   
> +static PropertyInfo vhost_user_blk_inflight_migration_prop;
> +
>   static const Property vhost_user_blk_properties[] = {
>       DEFINE_PROP_CHR("chardev", VHostUserBlk, chardev),
>       DEFINE_PROP_UINT16("num-queues", VHostUserBlk, num_queues,
> @@ -616,8 +618,9 @@ static const Property vhost_user_blk_properties[] = {
>                         VIRTIO_BLK_F_WRITE_ZEROES, true),
>       DEFINE_PROP_BOOL("skip-get-vring-base-on-force-shutdown", VHostUserBlk,
>                        skip_get_vring_base_on_force_shutdown, false),
> -    DEFINE_PROP_BOOL("inflight-migration", VHostUserBlk,
> -                     inflight_migration, false),
> +    DEFINE_PROP("inflight-migration", VHostUserBlk, inflight_migration,
> +                vhost_user_blk_inflight_migration_prop, bool,
> +                .set_default = true, .defval.u = false),
>   };
>   
>   static void vhost_user_blk_class_init(ObjectClass *klass, const void *data)
> @@ -649,6 +652,9 @@ static const TypeInfo vhost_user_blk_info = {
>   
>   static void virtio_register_types(void)
>   {
> +    vhost_user_blk_inflight_migration_prop = qdev_prop_bool;
> +    vhost_user_blk_inflight_migration_prop.realized_set_allowed = true;
> +
>       type_register_static(&vhost_user_blk_info);
>   }
>   

