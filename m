Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012022.outbound.protection.outlook.com [52.101.48.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F9438A714
	for <virtio-fs@lists.linux.dev>; Fri, 24 Apr 2026 12:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777035164; cv=fail; b=Al6cC4aGAS1xCxSNGARQ9W1kv6fVB3ShZBtK7ijmyNo2hohL3iBT90BjbNjNQGV49oqRgo5XpTGejs8/A9/cHohJD/jGc963lxdUR+8Eop8s5Wze2CW3Lu+CSA4uC5wkpVk3wtC9YxJbQOoIj0JzJwjKK18/kOS4OOAgl7fpQ5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777035164; c=relaxed/simple;
	bh=PwK/7Xd3sFI31TedGBapQe7OAhUemcKwFLnxcYyF6As=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qHMZ82IbicVcZA9OipMcL3jp49e688caxV48TIJOTPx3Iwg2Hy2CaHAiqI2y4i3/3DwS1S6hg1/0ZIMnzQgTcTh6fm15SnpXjPcWa4TEQYELDOwJRRQbzqeqsFRGN6nsx4WCol9jDl61RRM+cMj0qnNpE39cSNFXpe9uJXDbLzA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=m69JvWd6; arc=fail smtp.client-ip=52.101.48.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="m69JvWd6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sd7LaZYA45YHOZKZ1L4goqNnBzDujYcS+4bmAyWZc8X0dGvK+6DeRsbGvBU0xnQf9NUpvWgP6gx185ku2kGv91miQ5D0uMrIk3izlKhcskwoXovt2N3McKwnb2h26zJxQSHjEz0RIDvaLopxT63wmlL79IYBsxClT8nHPtJKtSHERejuAPdRcFxHGop5qbAFal9fJJZdmP95HyMSn1gFoPMMMaNJvE+T9/OXetX2chIc5XC4F52zePbAFa0l/uxwsrYY9G1Gr2AewGaRmvSd0zJMW9ToDO3ieHOzYFFSz4bZLaOx7G8JsMr9JXidH49vl+GPlwoBrn4O7V5/hrqmEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pgHNwDFTTI2ETqwH+CPYGnz7CmL3LV9JgX2aN2jjj1s=;
 b=k4T6cF1nqwCD6FvOr4Htvu34fI6MS9a/GsfZe/FmZhXNzclMsKetoZRW7n3rmNYQqX1jRZ6giw3MdHmTzISQN4YRFjzR4B4kZ1+CVr0OPYxOggYvPMzEh5Q2szGjZHFro42iJ53uNcUQBPkwj/onhDmi6TrNcXPAfnSwxI0K9tpL8Uaj3uENGe9UqZ+yFsXZDxO5hbIXyllmzpOdDQCa3DATtVAdxh74743NJj1EA55kr37HMC61hDeLTf+ylWjyY/Z2dHFaslxwfvbrvvJoieGXSRqszC8CH5H/qlyPOy6rexEWZ34qlEDcXZyPBdh6R5XRLhJL7OU1WtxdSk2pSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgHNwDFTTI2ETqwH+CPYGnz7CmL3LV9JgX2aN2jjj1s=;
 b=m69JvWd6gg97KXdl/jIHVtHSEnCxXsMda0S3M5xJxKSqbUjVRzSwTXqNP3pSpMFd4BcUjff04Mh1jNBViwygcu1XgsBToJrRu4dD+NV0PfYnQopeA4b4t+XeEAMqCls6AgGHr61KCEhYpEwYbWvmAR/Yy3E0zhevH1FrDKS9BtPdVd6u8d6qXBsfVW71I4V9iglCTJxHE2Msf/eiQRS4IPiTghhmboqOLm9FBVDDZ1y/7OMuDjPt18CIWH9KcrrgtQHvpC0mmCQHtP8MyCiJ2YHz2B2k282pWuWHlbgYyRmaslqDALTUn0TGfcQAc4AnnQo9n4AER7fDXgjkBQFrCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by LVUPR12MB999136.namprd12.prod.outlook.com (2603:10b6:408:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.12; Fri, 24 Apr
 2026 12:52:38 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 12:52:38 +0000
Message-ID: <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
Date: Fri, 24 Apr 2026 08:52:35 -0400
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
 <c9082536-6b4b-4e9a-a6ff-764dbbf649c9@nvidia.com>
 <19b0aa2e-90dc-4467-acc8-adc0bec7c388@yandex-team.ru>
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <19b0aa2e-90dc-4467-acc8-adc0bec7c388@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN0P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:52b::15) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|LVUPR12MB999136:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ec9adf7-3648-47fd-5763-08dea2005d26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	X64ESUxXKkcSzgHoJIWrSfKKMkzo7TY81/P1967TVMl3s/w3jFnW1KiJOi3OWm0raMBKJiCohXQCjai7CqkflQ9bg5D9SJMX80Mdll1D/orKN+x9bmlc4hRn0mj+Oo2kYubSeukDNUUHOvRjh2x43iR0m81HGXxNHtYbe4EAEWCkfpoQ0EEB2JjaNiA53AATttIVcGD31agJ/82P1bbyLuKIrJQioP4mZQODwe9jE/IvjfjZs6fs1uomz1wNzb+Dv6mQ+pljoEPM4MuB+QxCIUGU0BVeKHueBfgMgc/oEjL49d8zPmVfAAGhWoasWnR9onVjL/DUnltqqdjH2IngYQ9WtAEzpX7LGoKIKvpfRkpfpsO6S3ZMpCje/6IkPb7cAL5FJuJS3ueFGUJJsn+wskUq8kdF2gkmZeyJspW38ghQKFmDUS/csVnnbq8Ckbw17+a0kWJ1y3B2hKUXZij08eaQO5k8cuG8hVKqbHknHrR4hC5TcPbSSgr2r9ySk3tCtuSKbELMlJPRfOVvqIKuj6Fbimcw8Xbxz8bsE8GL2M7Cujj4UmmXIZ7Y53jsJm6DEy9DbOSQEfODcyVwoj3xxiRNJNzFRXNvPb1uqbKldF69vn/+avfXFLRMGiiaN9Hme2VC/EKx4KrwbIU90PD43yvwOv/V9jgIvIFEMS6SCmyliPilBaJ723YqbssrAOwa7ETk04t9ZdtAsSIdGMg7RkVnlUKZgDZgfc+vPltrpp8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUprRDQxeWtxSFNkVmttOFFJUWNheXFDb1VEYUdNQkZObkRUd2hxSFl4RnNL?=
 =?utf-8?B?cm1tODdEaFBkRXBxb3NNMDh6SVJycFpQOG40RkM2MHdhcmRKaTdueFdWbHlH?=
 =?utf-8?B?RWhMS3EwTHpTRDUreUxUSlRhemgyaTJXNXphU0tRYlhkcmpCNUt6bFBUMER6?=
 =?utf-8?B?Yk9Mb0ZTSVcwdDJwN1kxR3BWWDBGL3dXYVZ1MTVGOEE0a2EvZkxVNmFvbnhF?=
 =?utf-8?B?OTduWkJVMG1IZW9vdDhBN0xQM3VYSHRaREF4OG1vN3lseGpMRDVJVmhxcnlQ?=
 =?utf-8?B?MWcwUlFyYVRmanRGVkhWK24vTW1LSmRoSXNDWmRiSlFhZXA1N1lHY0c4QmJl?=
 =?utf-8?B?RXZudC9sMmVWVDJlczgydkRsMnlFeHY3WDU2YVpuS0dYSWpON3RxcjRkSVU5?=
 =?utf-8?B?SXluV3hTSDU1OWc4ZlVsbFJ3MlI3SjlJZW5LVmJwcFR1a0t1eFphcjV0QWpZ?=
 =?utf-8?B?YjNKSlVmQ0xkeHBHaHhYWnFjQkpacHBFeFVmUHdNRW9Ddzk0TGs0N3Z3eUg5?=
 =?utf-8?B?ZXdZcFh2STFpSG84Um44MnRXaTA2OUgyenl2a1FKcm5uUE1VQ2JKS2c3RG9J?=
 =?utf-8?B?N1BBSThVbUpyTllmY3FOUFhsWkJGR3BHWGpwcWtGRWRUazF0em9lR1ZYMkhM?=
 =?utf-8?B?M3c0RlhBZGo0cnJhVHR2ZUpVbTNIZFNLUFZ3aG9iNThjbmo3K1daOUg3MzQv?=
 =?utf-8?B?a1dGSEZQVk9HQU55QXlXSk03dHh3VlJyZFMwSHB2ckszUUswZ2duTWcxem53?=
 =?utf-8?B?US9Pc3JBOStHcHlmdXgyREhPckthelk1Zzcrdm55Z2taQjY2YVpJellTZ25C?=
 =?utf-8?B?VExzOWpBWmxZMnZpbnhZMzNkc0hScWtDdDNsNEFDTm5mNWQwQXRjNGxxTTdk?=
 =?utf-8?B?elduYkUvZ0EreUY5YWRyaXZuZ2J6L1R2MHZDUUM5dVFHaTIweXM1c0xvY09I?=
 =?utf-8?B?V29WL3ZOaW4xNHdvcW8xdm1mYmYweXEzdHd2bTUyV3o2dXdEa0gxRXptaSth?=
 =?utf-8?B?dFBJM25kZ1ZMQVRDWGZGQmg5cUZMb0RYdHdqazluNlBkT1V5bkd2azZWVlNG?=
 =?utf-8?B?YUhKdmlxOFBOZFREWkwzWFEwUVltaEdkMkFYbGxsN0lVelBBRzRDSTVYKy9N?=
 =?utf-8?B?SDZEMDRuUHdienE4dlRlbUF6dm9OSTVmZnh3VWs1VFc3ZVdKV1AwdWZzTEli?=
 =?utf-8?B?dzFzbWh2Y3B5UlBRSnRrbE9ScmRwS0JHckRuUElmVU92aktNZDdsYzk1Q1dJ?=
 =?utf-8?B?WjM3UFVBc0ZXbFJLaXBpeGNYQ3RCMUhRZmFMTUdwSnRFMC9rUW5FUEwvWFZO?=
 =?utf-8?B?RzNlQW5xdUpIeGxENmFsSjFPTjlYbzdEdHhsOHR5WExiclF6TjNVbWhqNlo2?=
 =?utf-8?B?dXVkdVB2Tm5jR3hTSVp0U2JsQ29ncncxUlI2aUgrSDFscmloZUFvcHNHZVJL?=
 =?utf-8?B?K2owcG5GbndNTllWTVBkWllNMnc4UFhlUHB3RExmTVR5bEUveTNlZDlBcDc5?=
 =?utf-8?B?UktRemFYRmFhYmhoQm1xaFd2NlV6VmNWTzJDT1NnbDJjY3pOT2U1M0h5Tno1?=
 =?utf-8?B?WnIxUTJ3UUI0K0NXRHZUKzgyc2xvc2FhVGtadmM2L1pOWUZHdXh6ZmZ2cnRO?=
 =?utf-8?B?NDhyS3R4c3ZkaXR2SC9NYklqZkFGcU1Nd3NKc3k2d2hTQWcxTDU4RGwwU0E2?=
 =?utf-8?B?bWF3aTR3WUdxY2tIMm1heFN6NTZYNjkzNzdNVHlER1JQcUJ5TnhhNHdjU2d5?=
 =?utf-8?B?MCtCUHo2WnNSaHdJZjhJWm5KaGI2VEFVVUNKU3plQXdKaElEVUV5RGRTUXlP?=
 =?utf-8?B?RGNEeTJNRnpGZW5Fd1BURnd5eDZZR3hOd09JUHNlUklheWhkQktIbDlua3gx?=
 =?utf-8?B?ZGxUVW85Nmlvd0JNZWN4ZzJNSVQyQ2N1WEI0MmhhcFJHcVF2VXhISDZBQlRV?=
 =?utf-8?B?UFhUdnIwaU9OYUNLbzdwamZQQ0xWV3pTY2oyY2h0M1VlWDdqckhuMHhDY05J?=
 =?utf-8?B?eVFjclcwK2lvN2hLb254bUd0Rm85RWg5OGhGM1hMUmhjVnJPdHpEVTJaWkNQ?=
 =?utf-8?B?VTRFU1AyemFscFRwQll4QmVhMms3anlCdUd2NWFJdVo2TnBBY2RaWWVjZjVq?=
 =?utf-8?B?c2ZZMWFSRHRjRjF1NGFoTzBWQUhaTFVoQ0ZONjZJMHZkcGhIZURVU1Ewb2cw?=
 =?utf-8?B?WTZIcEx0elpkcWNTeCs4TTZzQzAzRm1URGZFRWxsZlZ5VUE2UnhxbjYxbkIv?=
 =?utf-8?B?YXV0WTUzL250TWFYWXFpZzFWMEtHWStkOE5Telluak1VTjZpWW1yMGw3dVB6?=
 =?utf-8?B?bm5JMDFmRXR2Q3RydmxrRmc2b2hGbW5EbkF0VVVKTTNWcTdEMjNzZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec9adf7-3648-47fd-5763-08dea2005d26
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 12:52:38.1673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kK9J2bnHhu6wzX1YA+Vr0zaoTbjlzjqDTwcx3kkSVAMgbifxtIE2OQl4c5VeWCCuO9ENxsTThmKVMPYlO4Y7XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999136



On 4/24/26 4:57 AM, Alexandr Moshkov wrote:
> Thanks for reply!
> 
> On 4/23/26 19:15, Raphael Norwitz wrote:
>>
>>
>> On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
>>> Greetings! Thanks for reply!
>>>
>>>
>>> On 4/15/26 20:21, Raphael Norwitz wrote:
>>>> I’m not sure I like using the num field in vhost_vring_state to set 
>>>> magic values which affect protocol behavior for GET_VRING_BASE. It 
>>>> feels like a hack to me. I would think the proper solution if we 
>>>> want to support migration from new to old would be to have new use a 
>>>> different new message entirely. Can we do that?
>>>
>>> I think we can, but I thought at first that this will be almost a 
>>> complete copy of GET_VRING_BASE message, with the exception of 
>>> waiting for drain of requests, so I choose to expand existing message.
>>>
>>
>> I think a new message would be cleaner. Anyone else have thoughts?
>>
>>> If this is not an appropriate approach, is it better to make a new 
>>> message like GET_VRING_BASE or a separate message used together with 
>>> default GET_VRING_BASE message (for example, message for setting some 
>>> kind of status on the server)? What should I name this new message?
>>>
>>
>> Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate message used 
>> together with default GET_VRING_BASE message work? 
> 
> I was thinking about a message something like SET_VRING_ENABLE - for 
> example SET_SKIP_DRAIN_ENABLE, that would enable/disable some state 
> (skip_drain) in the backend.

I'd need to see the flow in more detail but sounds promising.

> 
>>
>>> I also fix other comments, thanks!
>>>
>>>>
>>>> On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
>>>>> In case of migration of QEMU from the new version (where the
>>>>> inllight-migration parameter is present), to the old one (where it is
>>>>
>>>> nit: spelling inllight-migration
>>>>
>>>>> absent) there is no way to disable this feature on the backend during
>>>>> runtime.
>>>>>
>>>>> This commit slightly changes the semantics of the protocol feature
>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this feature
>>>>> adds a new parameter for GET_VRING_BASE, which allows to control the
>>>>> drain in-flight requests on the backend.
>>>>> Thus, QEMU will be able to turn this feature on GET_VRING_BASE off and
>>>>> on anytime.
>>>>>
>>>>> In vhost-user-blk use inflight_migration param to enable skip_drain to
>>>>> suspend in-flight I/O requests, and then migrate them throught 
>>>>> inflight
>>>>> subsection.
>>>>>
>>>>> Also now QEMU will always try to setup
>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
>>>>> backend. This will allow to use skip_drain parameter on GET_VRING_BASE
>>>>> message.
>>>>>
>>>>> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>
>>>>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>>>>> ---
>>>>>   docs/interop/vhost-user.rst    |  6 ++----
>>>>>   hw/block/vhost-user-blk.c      | 30 ++++++++++++++++++++++++------
>>>>>   hw/virtio/vhost-user.c         |  3 +--
>>>>>   hw/virtio/vhost.c              |  1 +
>>>>>   include/hw/virtio/vhost-user.h |  1 -
>>>>>   5 files changed, 28 insertions(+), 13 deletions(-)
>>>>>
>>>>> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost-user.rst
>>>>> index bfa75ff9a3..63efc87264 100644
>>>>> --- a/docs/interop/vhost-user.rst
>>>>> +++ b/docs/interop/vhost-user.rst
>>>>> @@ -1255,14 +1255,12 @@ Front-end message types
>>>>>     *suspended*, see :ref:`Suspended device state
>>>>>     <suspended_device_state>`.
>>>>>   -  The request payload's *num* field is currently reserved and 
>>>>> must be
>>>>> -  set to 0.
>>>>> -
>>>>>     By default, the back-end must complete all inflight I/O 
>>>>> requests for the
>>>>>     specified vring before stopping it.
>>>>>       If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` 
>>>>> protocol
>>>>> -  feature has been negotiated, the back-end may suspend in-flight I/O
>>>>> +  feature has been negotiated, using request payload's *num* field,
>>>>> +  when *num* is set to 1, QEMU can tell the back-end to suspend 
>>>>> in- flight I/O
>>>>>     requests and record them as described in :ref:`Inflight I/O 
>>>>> tracking
>>>>>     <inflight_io_tracking>` instead of completing them before 
>>>>> stopping the vring.
>>>>>     How to suspend an in-flight request depends on the 
>>>>> implementation of the back-end
>>>>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>>>> index a3ecd83f54..522e9d34b5 100644
>>>>> --- a/hw/block/vhost-user-blk.c
>>>>> +++ b/hw/block/vhost-user-blk.c
>>>>> @@ -134,10 +134,7 @@ static bool 
>>>>> vhost_user_blk_inflight_needed(void *opaque)
>>>>>   {
>>>>>       struct VHostUserBlk *s = opaque;
>>>>>   -    bool inflight_migration = virtio_has_feature(s- 
>>>>> >dev.protocol_features,
>>>>> - VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>> -
>>>>> -    return inflight_migration;
>>>>> +    return s->inflight_migration;
>>>>>   }
>>>>>     @@ -232,11 +229,14 @@ static int 
>>>>> vhost_user_blk_stop(VirtIODevice *vdev)
>>>>>           return 0;
>>>>>       }
>>>>>   +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
>>>>
>>>> nit: declarations on top
>>>>
>>>>> + runstate_check(RUN_STATE_FINISH_MIGRATE);
>>>>> +
>>>>>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>>>>>                    qemu_force_shutdown_requested();
>>>>>         ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, true) :
>>>>> -                       vhost_dev_stop(&s->dev, vdev, true, false);
>>>>> +                       vhost_dev_stop(&s->dev, vdev, true, 
>>>>> skip_drain);
>>>>>         if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, 
>>>>> false) < 0) {
>>>>>           error_report("vhost guest notifier cleanup failed: %d", 
>>>>> ret);
>>>>> @@ -364,7 +364,6 @@ static int vhost_user_blk_connect(DeviceState 
>>>>> *dev, Error **errp)
>>>>>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>>>>>         s->vhost_user.supports_config = true;
>>>>> -    s->vhost_user.supports_inflight_migration = s- 
>>>>> >inflight_migration;
>>>>>       ret = vhost_dev_init(&s->dev, &s->vhost_user, 
>>>>> VHOST_BACKEND_TYPE_USER, 0,
>>>>>                            errp);
>>>>>       if (ret < 0) {
>>>>> @@ -580,10 +579,29 @@ static struct vhost_dev 
>>>>> *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>>>>       return &s->dev;
>>>>>   }
>>>>>   +static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
>>>>> +{
>>>>> +    VHostUserBlk *s = VHOST_USER_BLK(opaque);
>>>>> +
>>>>> +    bool inflight_migration_enabled = virtio_has_feature(
>>>>> +        s->dev.protocol_features,
>>>>> +        VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>> +    if (vhost_user_blk_inflight_needed(s) && ! 
>>>>> inflight_migration_enabled) {
>>>>> +        error_setg(errp, "can't migrate vhost-user-blk device: "
>>>>> +                         "backend doesn't support "
>>>>> + "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
>>>>> +                         "protocol feature");
>>>>> +        return false;
>>>>> +    }
>>>>> +
>>>>> +    return true;
>>>>> +}
>>>>> +
>>>>>   static const VMStateDescription vmstate_vhost_user_blk_inflight = {
>>>>>       .name = "vhost-user-blk/inflight",
>>>>>       .version_id = 1,
>>>>>       .needed = vhost_user_blk_inflight_needed,
>>>>> +    .pre_save_errp = vhost_user_blk_pre_save,
>>>>>       .fields = (const VMStateField[]) {
>>>>>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>>>>>           VMSTATE_END_OF_LIST()
>>>>> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
>>>>> index bb8f8eab77..ed95ec7523 100644
>>>>> --- a/hw/virtio/vhost-user.c
>>>>> +++ b/hw/virtio/vhost-user.c
>>>>> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct 
>>>>> vhost_dev *dev, void *opaque,
>>>>>               }
>>>>>           }
>>>>>   -        if (!u->user->supports_inflight_migration ||
>>>>> -            !virtio_has_feature(protocol_features,
>>>>> +        if (!virtio_has_feature(protocol_features,
>>>>> VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>>>>>               protocol_features &= ~(1ULL <<
>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>>>>> index ac4d6fca73..54e4ce2660 100644
>>>>> --- a/hw/virtio/vhost.c
>>>>> +++ b/hw/virtio/vhost.c
>>>>> @@ -1398,6 +1398,7 @@ static int do_vhost_virtqueue_stop(struct 
>>>>> vhost_dev *dev,
>>>>>       int vhost_vq_index = dev->vhost_ops->vhost_get_vq_index(dev, 
>>>>> idx);
>>>>>       struct vhost_vring_state state = {
>>>>>           .index = vhost_vq_index,
>>>>> +        .num = skip_drain,
>>>>>       };
>>>>>       int r = 0;
>>>>>   diff --git a/include/hw/virtio/vhost-user.h b/include/hw/virtio/ 
>>>>> vhost-user.h
>>>>> index 53fe996686..c95bad5ddc 100644
>>>>> --- a/include/hw/virtio/vhost-user.h
>>>>> +++ b/include/hw/virtio/vhost-user.h
>>>>> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>>>>>       GPtrArray *notifiers;
>>>>>       int memory_slots;
>>>>>       bool supports_config;
>>>>> -    bool supports_inflight_migration;
>>>>>   } VhostUserState;
>>>>>     /**
>>>>
>>

