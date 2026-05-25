Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010004.outbound.protection.outlook.com [40.93.198.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E28126D4E5
	for <virtio-fs@lists.linux.dev>; Mon, 25 May 2026 21:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779744886; cv=fail; b=LAMQJvGILZlibDL0CQtX4w9mg8KktKKe2gj8TGNV7u9usEPGz1heu3obLJ7rNrmxoZVPZYyB6vohs6gPZLieKwV3rqdG8rmHckn2VOcg6xY6fHXu7Vdzq6mdAT/3/EP+uRGeNwRwGdF56/+Utl9K2m3pnnAii+zJ1kH4wGmkthI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779744886; c=relaxed/simple;
	bh=k07WlEcppqcxomenSeBH33srdadZBjoQ7bkit+0+b00=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IVMDZAaTG2hvJ0b/m6tHt/xPq2Qrwf3qs/u6ISMhBM/zBkc5B+XcmORaMxw/lY9fv34dTOxva31kxyFCp9m7t+NqOF79XV+Mfb+udkun+SaujpWnInc4OV9TUonVr+ANoqyAB0VkzVrxaL/yZYilDG5bZ2Pzw5YpfXKIcVUqxAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eN1wCS19; arc=fail smtp.client-ip=40.93.198.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eN1wCS19"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nTXrH4S+o9USPU+A7BdeQE3K+PZkbo4KQOGPV6NLuKfMLhyydUQzuVOaZuDXIrhkLIWen/nmnEXNVIRLfGCXX/aqzCuzJj95IEwNLcEXHTfswhfkEdwmVqn0D8ZBep8/RJjxBkJ7s4wKlI0TFlkBQIpxVep9T0nMltGBQ+J0HnfQS48oCURogZtxhCGwr/w9iwreKgnU8qoVzwXY9nJWhadmgAUjQKPc2Da59Vx5WMC7Nl4ZaY1YhYTLPLE/APvZvX4d4XEy2GzWjAaJK7d8/FUaCBhVhYYyUqzg5QBkshXFhN76OvUr63SwOhiptha3JUw7QA29zSpxs1T7qVpvcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X3LYre1DWpanFJfPxMqpheeX498GL741fh5e0zXwUdM=;
 b=IfWS95VS3Ns2swCOCxu5lk+/xlLG56YQpFXe/hdv3ndQRsr+V7xHGIiqXcOu34hARZccs8+f5oU7IibkKrl+6enUvtCUBsGNnRHPUUfdhO0ese6jQrPj8yPB1UafX/hWmEglQcvpRtpy3Dk9RTzoFc0KZ2XabOJKHmu1zo8hCxoBRBaDr0bE+5a7NojZWnw5s23EGCR3HEvNb/GE9V9Qgx2+Cl6MXKOVvuIJFcOdf9pZh93paX92LLy1Ww9kl2hZDzxGG7XW7Ik3PLa8OhVaWkokgb0d1/BvTUb6hi7jBp3WWZ4SvFcik+Yzbp+SY89hM08wypcDF6XSbdpX1VHLEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3LYre1DWpanFJfPxMqpheeX498GL741fh5e0zXwUdM=;
 b=eN1wCS1959rNzIbsaa4iuDzkhN/oT/4t/Pkn569UoxR8hhB/znucSq75uhkFOi/JecJXF6Ec+6JK95fZ4b3JPeKh2Xtttowrzg/ZI4KETpBP5Q4AWmcEVt7nvM9/LGvviHqkz7LFUZboGa6hv18rIDPFS25wH9p0sd8Ul2LhPM/D4+xYMOMv9IXJHzfSUggylk2ym7WKlOHW1MMlGz/Kva9mWzoN+GxDzBCymGTdNawOYVVv0lNV8I4NyUiNdaVmFk8/DHzQ/XUoGoEuk3iIUkl+BGsX/6idH2Btg6/oRCL8poXwPA5R0Pe30HgFruNEGxuMQWON01WJKSXRk1zOaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN7PR12MB7226.namprd12.prod.outlook.com (2603:10b6:806:2a9::18)
 by MN0PR12MB6055.namprd12.prod.outlook.com (2603:10b6:208:3cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Mon, 25 May
 2026 21:34:39 +0000
Received: from SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807]) by SN7PR12MB7226.namprd12.prod.outlook.com
 ([fe80::c07d:130a:7def:6807%5]) with mapi id 15.21.0048.016; Mon, 25 May 2026
 21:34:39 +0000
Message-ID: <7fc11fc4-4bc7-46b3-8d83-1ab5a8198cda@nvidia.com>
Date: Mon, 25 May 2026 17:34:37 -0400
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
 <1c6af04b-9efd-4d07-ab5c-e6d616818c2c@nvidia.com>
 <9fb43ec4-7825-4382-991f-a2cc17142138@yandex-team.ru>
 <be99a7b5-1575-4da0-93dd-8460a77ddf77@yandex-team.ru>
Content-Language: en-US
From: Raphael Norwitz <rnorwitz@nvidia.com>
In-Reply-To: <be99a7b5-1575-4da0-93dd-8460a77ddf77@yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::21) To SN7PR12MB7226.namprd12.prod.outlook.com
 (2603:10b6:806:2a9::18)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB7226:EE_|MN0PR12MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 64f54721-7e19-4b99-7dc0-08debaa56d15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799006|4143699003|3023799007|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PN0E/C+GTHRtqM+lkFs3brBeqzy/5wUQ6E2pyHeihh5bt/u9kFMKzRIT2oxjfjr9Gz1OefDd97UNDoo70y9LQqOoI/Qc18M5F8RpzPNDKkFIudxfxcs6HkRgHT2t3f7al/b3vFC2sk6FU5kbAdztK0Ejsx4wCxcg65CPB9OYgl0tA3IaTz7pP+afUq2lOQ026iOFNF5wcM1zjJa8UIObzur2LW3fyPujPKNRL5WWdja2dOWB/G+bqJN1IUwn2gmdIJNgFsq0emJdbdboEXMd5fopwudEvO/kCe5dI8ygS0zJgAt435LDEN8eGLIH2Ddgr1wHp32RK09XvdSKzUwY25yFGkugWQiEUzFINXr6jP0O7GAfX3FOgwXd279z6CX37bldHNJzB7XABEO2XLPDmJRp9CR4BxM+lNnZgF/aKwQJ1eKDxpzpJgY17OL/5m2X0TGZu3cMhRLKxaD6DxuKcC9YNmbesLM9J/C6VGunSO2mzm1gwF68ILRxDiOMGcIXYVcTVDFp58Eg8rZOBy9deCycK4I+vM6YoQigjd1XeNUjy4cLPTZ1eOQH97l841fa5n2xZrbTCXsD7hoQuyN409hoLra9+oseeVMAh0zKRQx0T4t2ByZ8HXyQBTxoQ0BvKt/lbpJ7MNisCx284HoBc3Kjdos+TtkWG3hTj4s5OJJue7m56mvwQt9pR0P1aEOo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB7226.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799006)(4143699003)(3023799007)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dERBbnU2VG9GZCthQlJCNllIUG5QWm9oMGNjOUtlZ3IvWmdwSkY5dmNqK1Aw?=
 =?utf-8?B?OXh4R2VFa0RvdGNSMi9uTFhZdTlldjVZZXdrV3JSdWRZbmV6bVhQZjVqREFG?=
 =?utf-8?B?QVBLWU9CbmlYejJsV2pLUnVINlhuOWVDWmtuRy9XYzBYeU02UG9RVmo4dThz?=
 =?utf-8?B?T2xOM1luM1NpYTVWTi9PQW8yYmdUWk42a0NrSXdPTitwTzdUcFRMLzkzOUhO?=
 =?utf-8?B?WTdjdkhHcGgrSG9FeVcrdFJaV1ErdXhkSWNEcmE1MmJXSENlWkpZczlMdFVR?=
 =?utf-8?B?clY0Uzg0b0VHQlBaUVNocE9HdnlkeG5lQlU0ZXZJZDJOVXp3dDhRZU5qZkVV?=
 =?utf-8?B?cEIvRWR2YnBtbnhvTnhtZk41MUJpYXB4RVNhQ3ZFT2hkL2hySjh4RjVkcTZa?=
 =?utf-8?B?SmkwbW9FVXJCcFNtd2l5bXZuYXpiNVVlVllCcDN4VGdIMi9kaEJUNmM3d1BX?=
 =?utf-8?B?NEZOVFJYWitwdDlqVm1iOFFGMFZNYzJpZStNWGZyVUc0WVd0bFh3WGtBV2Fo?=
 =?utf-8?B?azJYUktjMDNkSnpUaWRFa3Z0ZnI5Rzl1dEhobXFXZUZVa09wc25ONHJ2akhB?=
 =?utf-8?B?WXpENDF3aCtTM29qOVd5Vzh1WVpWVFM2WXdjbTJsKzVxRmVVOHZaL1dvSS9l?=
 =?utf-8?B?dUdFNFpGYStHc294MmNKanlUWER2TGtkdTU1WkdEVVlFQnVCVlpSOVRPbGJm?=
 =?utf-8?B?Yno2VEJZeFVCam5vaTZVamZiTllBU0R2eWs4OGdRM09FT2JZaVhtZEVLcFFJ?=
 =?utf-8?B?SGVSN0NnWnpibUFRVzBudVk2OUl6YVNjME81MzI2dS80R2thczlKV2JlRnRy?=
 =?utf-8?B?cDBPZ3BOaXZyNFZESGZlTXhlakNaZkwycjN4c21HQytmZnVOWm1LQ0s0TFBs?=
 =?utf-8?B?ZHhEYjN0eFpsK0tuRHB4aElKVkFXOFIxQ1BkTnRVVDZHSGtyTi9MNXIzMXdT?=
 =?utf-8?B?SzIvVXdWcXpNNWV2UUlCNWFhUkNJMHI4dDhxTHZqSDdNdytYaUw0a05jZE1o?=
 =?utf-8?B?eXRYbG1DR2YrV0NlYVFJeHVMZXFWemk3aEZ5aHJ6VTB2dGhnckE5SEViZnJ0?=
 =?utf-8?B?emdHQlZISzJYbHFDSlVUZjk4eXVGQXlpSWNwT2RwYUNhbVNkVTl5MHhGMTda?=
 =?utf-8?B?eEpNZDVIdGw0amVMYlVhRlJkRDg3by81bmU0SVVoOFNqbzJTVmczanJHVE4y?=
 =?utf-8?B?NnhFcnovU3RrU0xEWmFhVUkzclNGS3pONGs0cW9tUy9VRVNtQTByV1Jrd0dW?=
 =?utf-8?B?YTZXVUE4ZzhBTlEwUTRyVUtVeVVhK1JibmpBSVlhL3JtZWs4VGJGR3B2YkRv?=
 =?utf-8?B?OStsZnJSeUkzbHlGaU5kVVZlYjZLY0pQU2VXMGhwcGJ5NksxQTVkNTNBT2l4?=
 =?utf-8?B?WkkzTmxUTE8vU3lVNWFray9lb1B2clBaZy91YlIyZVFRV3dDTVR3YTU4ZTVQ?=
 =?utf-8?B?YlpPZGtCNHpKR2Y4MWwrR1Q3TnM2bDY4UFZITzY4cEo0VVpjTmM0d3g2ZElh?=
 =?utf-8?B?Rlk0aURKT3lwY0Nacytma1F2Y2Zka1hOMmtUOFlpSVZZYmJBcUpqUU8xSXNP?=
 =?utf-8?B?S1hkTEZya2taREJ3UmhMaHk1Z0k4QkZWSjlicEIxMERVT2xmR0VOUXZVT3NJ?=
 =?utf-8?B?VERQN1FKMml4aVNZaUFrRG5aM29lYm9jcDg4S1BnYWpqS3hLM1RISnNwendI?=
 =?utf-8?B?RG04VGdjcmZVVjhLR0Z6aCtrSGtmU0VmeXpETW9vb0tHc2JHY1FXUGhOVkg3?=
 =?utf-8?B?c3NUVXlCczVoSmt3eEYyRDV6eEtZUVhkMWE2RWtQKzJZOGxHandyNGxZZS96?=
 =?utf-8?B?VllQZUxTQ0JubGJtUHdPN1B2RHVQV05IN0RuaHEvdStrZkMrWWRPb2d1UmV3?=
 =?utf-8?B?dFlQYTBicWI0VGZ2ak0wWklta0ZVaWt4ZG9UczVqR0dwWGhjV0Z6NFVvWllj?=
 =?utf-8?B?Q214OWwrQmxCWWtmamljYjZKMC85dXhmRUJvYUk5RFgrN01nbURUcnk0K3BB?=
 =?utf-8?B?MmRFNTlHMThnRHhRUVBNOHNwQ2JYSDIyU1FpaURZdGhVazE1aGthclVQMGpo?=
 =?utf-8?B?dUFTc3lHVmlHZU8xR0pyRTZrb1hjdklIU0pMMUozT1hhSWh6Uy9nSnhVaElB?=
 =?utf-8?B?bTZ5Y0NibVBVQm5wSk4yU0l6T251UUhDREZab3BxRG1SekdmcUhhMjYxVVVK?=
 =?utf-8?B?TUxaWHMxRnZHbWxYc2RrK3M5SUtXVTF4aElubGhnWSt2dEVJNGpsTHBZamNN?=
 =?utf-8?B?ME1QN1lXUXl3ZnB6QUZ5NDlOclcwNjhPVmlwVFZuU25zWDFkMXBhZEpiSDE0?=
 =?utf-8?B?elpMMXZyUFJVRlg4QWhtWnRxRFdDTkliWG9qUVd3d0ZyZ1c1SVZUdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64f54721-7e19-4b99-7dc0-08debaa56d15
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB7226.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2026 21:34:39.6557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iPRb7l8PgRTRofx6r+CsA1EVNTcT4gWF+QDFnkcrS5CVXdjyqzWsTlTMpGwWbgh5cuHddGIWc8qaJzc6lzhf7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6055

Apologies for the late reply.

On 5/12/26 1:55 AM, Alexandr Moshkov wrote:
> Gentle ping :)
> 

[...]

>>>>> On 4/16/26 5:26 AM, Alexandr Moshkov wrote:
>>>>>> Greetings! Thanks for reply!
>>>>>>
>>>>>>
>>>>>> On 4/15/26 20:21, Raphael Norwitz wrote:
>>>>>>> I’m not sure I like using the num field in vhost_vring_state to 
>>>>>>> set magic values which affect protocol behavior for 
>>>>>>> GET_VRING_BASE. It feels like a hack to me. I would think the 
>>>>>>> proper solution if we want to support migration from new to old 
>>>>>>> would be to have new use a different new message entirely. Can we 
>>>>>>> do that?
>>>>>>
>>>>>> I think we can, but I thought at first that this will be almost a 
>>>>>> complete copy of GET_VRING_BASE message, with the exception of 
>>>>>> waiting for drain of requests, so I choose to expand existing 
>>>>>> message.
>>>>>>
>>>>>
>>>>> I think a new message would be cleaner. Anyone else have thoughts?
>>>>>
>>>>>> If this is not an appropriate approach, is it better to make a new 
>>>>>> message like GET_VRING_BASE or a separate message used together 
>>>>>> with default GET_VRING_BASE message (for example, message for 
>>>>>> setting some kind of status on the server)? What should I name 
>>>>>> this new message?
>>>>>>
>>>>>
>>>>> Maybe GET_VRING_BASE_SKIP_DRAIN? How would a separate message used 
>>>>> together with default GET_VRING_BASE message work? 
>>>>
>>>> I was thinking about a message something like SET_VRING_ENABLE - for 
>>>> example SET_SKIP_DRAIN_ENABLE, that would enable/disable some state 
>>>> (skip_drain) in the backend.
>>>
>>> I'd need to see the flow in more detail but sounds promising.
>>
>> On migration vhost-user-blk firstly send SET_SKIP_DRAIN_ENABLE with 
>> num = 1 message if `inflight-migration` device parameter 
>> and VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT enabled. Then send 
>> GET_VRING_BASE and continue work as usual.
>>
>> On SET_SKIP_DRAIN_ENABLE backend sets inner state (skip_drain) so when 
>> GET_VRING_BASE is called and skip_drain is true the drain will skipped.
>>
>> What do you think?
>>

I'm happy with that in theory but would like more clarity on the 
details. In particular, I'm not sure what you mean by "vhost-user-blk 
firstly send SET_SKIP_DRAIN_ENABLE". To add a new message I would think 
we would have to do a vhost-user protocol feature negotiation to gate it.

Also what are the precise semantics for SET_SKIP_DRAIN_ENABLE? Would it 
be sent on backend connect or when we're about to migrate?

I was hoping others would comment but at this point I'd suggest drafting 
the code and then we can re-review.

>>>
>>>>
>>>>>
>>>>>> I also fix other comments, thanks!
>>>>>>
>>>>>>>
>>>>>>> On 3/30/26 11:52 AM, Alexandr Moshkov wrote:
>>>>>>>> In case of migration of QEMU from the new version (where the
>>>>>>>> inllight-migration parameter is present), to the old one (where 
>>>>>>>> it is
>>>>>>>
>>>>>>> nit: spelling inllight-migration
>>>>>>>
>>>>>>>> absent) there is no way to disable this feature on the backend 
>>>>>>>> during
>>>>>>>> runtime.
>>>>>>>>
>>>>>>>> This commit slightly changes the semantics of the protocol feature
>>>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT. Enabling this 
>>>>>>>> feature
>>>>>>>> adds a new parameter for GET_VRING_BASE, which allows to control 
>>>>>>>> the
>>>>>>>> drain in-flight requests on the backend.
>>>>>>>> Thus, QEMU will be able to turn this feature on GET_VRING_BASE 
>>>>>>>> off and
>>>>>>>> on anytime.
>>>>>>>>
>>>>>>>> In vhost-user-blk use inflight_migration param to enable 
>>>>>>>> skip_drain to
>>>>>>>> suspend in-flight I/O requests, and then migrate them throught 
>>>>>>>> inflight
>>>>>>>> subsection.
>>>>>>>>
>>>>>>>> Also now QEMU will always try to setup
>>>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT protocol featrue with
>>>>>>>> backend. This will allow to use skip_drain parameter on 
>>>>>>>> GET_VRING_BASE
>>>>>>>> message.
>>>>>>>>
>>>>>>>> Reviewed-by: Vladimir Sementsov-Ogievskiy <vsementsov@yandex- 
>>>>>>>> team.ru>
>>>>>>>> Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>>>>>>>> ---
>>>>>>>>   docs/interop/vhost-user.rst    |  6 ++----
>>>>>>>>   hw/block/vhost-user-blk.c      | 30 +++++++++++++++++++++++ 
>>>>>>>> +------
>>>>>>>>   hw/virtio/vhost-user.c         |  3 +--
>>>>>>>>   hw/virtio/vhost.c              |  1 +
>>>>>>>>   include/hw/virtio/vhost-user.h |  1 -
>>>>>>>>   5 files changed, 28 insertions(+), 13 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/docs/interop/vhost-user.rst b/docs/interop/vhost- 
>>>>>>>> user.rst
>>>>>>>> index bfa75ff9a3..63efc87264 100644
>>>>>>>> --- a/docs/interop/vhost-user.rst
>>>>>>>> +++ b/docs/interop/vhost-user.rst
>>>>>>>> @@ -1255,14 +1255,12 @@ Front-end message types
>>>>>>>>     *suspended*, see :ref:`Suspended device state
>>>>>>>>     <suspended_device_state>`.
>>>>>>>>   -  The request payload's *num* field is currently reserved and 
>>>>>>>> must be
>>>>>>>> -  set to 0.
>>>>>>>> -
>>>>>>>>     By default, the back-end must complete all inflight I/O 
>>>>>>>> requests for the
>>>>>>>>     specified vring before stopping it.
>>>>>>>>       If the ``VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT`` 
>>>>>>>> protocol
>>>>>>>> -  feature has been negotiated, the back-end may suspend in- 
>>>>>>>> flight I/O
>>>>>>>> +  feature has been negotiated, using request payload's *num* 
>>>>>>>> field,
>>>>>>>> +  when *num* is set to 1, QEMU can tell the back-end to suspend 
>>>>>>>> in- flight I/O
>>>>>>>>     requests and record them as described in :ref:`Inflight I/O 
>>>>>>>> tracking
>>>>>>>>     <inflight_io_tracking>` instead of completing them before 
>>>>>>>> stopping the vring.
>>>>>>>>     How to suspend an in-flight request depends on the 
>>>>>>>> implementation of the back-end
>>>>>>>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>>>>>>>> index a3ecd83f54..522e9d34b5 100644
>>>>>>>> --- a/hw/block/vhost-user-blk.c
>>>>>>>> +++ b/hw/block/vhost-user-blk.c
>>>>>>>> @@ -134,10 +134,7 @@ static bool 
>>>>>>>> vhost_user_blk_inflight_needed(void *opaque)
>>>>>>>>   {
>>>>>>>>       struct VHostUserBlk *s = opaque;
>>>>>>>>   -    bool inflight_migration = virtio_has_feature(s- 
>>>>>>>> >dev.protocol_features,
>>>>>>>> - VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>>>> -
>>>>>>>> -    return inflight_migration;
>>>>>>>> +    return s->inflight_migration;
>>>>>>>>   }
>>>>>>>>     @@ -232,11 +229,14 @@ static int 
>>>>>>>> vhost_user_blk_stop(VirtIODevice *vdev)
>>>>>>>>           return 0;
>>>>>>>>       }
>>>>>>>>   +    bool skip_drain = vhost_user_blk_inflight_needed(s) &&
>>>>>>>
>>>>>>> nit: declarations on top
>>>>>>>
>>>>>>>> + runstate_check(RUN_STATE_FINISH_MIGRATE);
>>>>>>>> +
>>>>>>>>       force_stop = s->skip_get_vring_base_on_force_shutdown &&
>>>>>>>>                    qemu_force_shutdown_requested();
>>>>>>>>         ret = force_stop ? vhost_dev_force_stop(&s->dev, vdev, 
>>>>>>>> true) :
>>>>>>>> -                       vhost_dev_stop(&s->dev, vdev, true, false);
>>>>>>>> +                       vhost_dev_stop(&s->dev, vdev, true, 
>>>>>>>> skip_drain);
>>>>>>>>         if (k->set_guest_notifiers(qbus->parent, s->dev.nvqs, 
>>>>>>>> false) < 0) {
>>>>>>>>           error_report("vhost guest notifier cleanup failed: 
>>>>>>>> %d", ret);
>>>>>>>> @@ -364,7 +364,6 @@ static int 
>>>>>>>> vhost_user_blk_connect(DeviceState *dev, Error **errp)
>>>>>>>>       vhost_dev_set_config_notifier(&s->dev, &blk_ops);
>>>>>>>>         s->vhost_user.supports_config = true;
>>>>>>>> -    s->vhost_user.supports_inflight_migration = s- 
>>>>>>>> >inflight_migration;
>>>>>>>>       ret = vhost_dev_init(&s->dev, &s->vhost_user, 
>>>>>>>> VHOST_BACKEND_TYPE_USER, 0,
>>>>>>>>                            errp);
>>>>>>>>       if (ret < 0) {
>>>>>>>> @@ -580,10 +579,29 @@ static struct vhost_dev 
>>>>>>>> *vhost_user_blk_get_vhost(VirtIODevice *vdev)
>>>>>>>>       return &s->dev;
>>>>>>>>   }
>>>>>>>>   +static bool vhost_user_blk_pre_save(void *opaque, Error **errp)
>>>>>>>> +{
>>>>>>>> +    VHostUserBlk *s = VHOST_USER_BLK(opaque);
>>>>>>>> +
>>>>>>>> +    bool inflight_migration_enabled = virtio_has_feature(
>>>>>>>> +        s->dev.protocol_features,
>>>>>>>> + VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>>>> +    if (vhost_user_blk_inflight_needed(s) && ! 
>>>>>>>> inflight_migration_enabled) {
>>>>>>>> +        error_setg(errp, "can't migrate vhost-user-blk device: "
>>>>>>>> +                         "backend doesn't support "
>>>>>>>> + "VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT "
>>>>>>>> +                         "protocol feature");
>>>>>>>> +        return false;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    return true;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>   static const VMStateDescription 
>>>>>>>> vmstate_vhost_user_blk_inflight = {
>>>>>>>>       .name = "vhost-user-blk/inflight",
>>>>>>>>       .version_id = 1,
>>>>>>>>       .needed = vhost_user_blk_inflight_needed,
>>>>>>>> +    .pre_save_errp = vhost_user_blk_pre_save,
>>>>>>>>       .fields = (const VMStateField[]) {
>>>>>>>>           VMSTATE_VHOST_INFLIGHT_REGION(inflight, VHostUserBlk),
>>>>>>>>           VMSTATE_END_OF_LIST()
>>>>>>>> diff --git a/hw/virtio/vhost-user.c b/hw/virtio/vhost-user.c
>>>>>>>> index bb8f8eab77..ed95ec7523 100644
>>>>>>>> --- a/hw/virtio/vhost-user.c
>>>>>>>> +++ b/hw/virtio/vhost-user.c
>>>>>>>> @@ -2225,8 +2225,7 @@ static int vhost_user_backend_init(struct 
>>>>>>>> vhost_dev *dev, void *opaque,
>>>>>>>>               }
>>>>>>>>           }
>>>>>>>>   -        if (!u->user->supports_inflight_migration ||
>>>>>>>> -            !virtio_has_feature(protocol_features,
>>>>>>>> +        if (!virtio_has_feature(protocol_features,
>>>>>>>> VHOST_USER_PROTOCOL_F_INFLIGHT_SHMFD)) {
>>>>>>>>               protocol_features &= ~(1ULL <<
>>>>>>>> VHOST_USER_PROTOCOL_F_GET_VRING_BASE_INFLIGHT);
>>>>>>>> diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
>>>>>>>> index ac4d6fca73..54e4ce2660 100644
>>>>>>>> --- a/hw/virtio/vhost.c
>>>>>>>> +++ b/hw/virtio/vhost.c
>>>>>>>> @@ -1398,6 +1398,7 @@ static int do_vhost_virtqueue_stop(struct 
>>>>>>>> vhost_dev *dev,
>>>>>>>>       int vhost_vq_index = dev->vhost_ops- 
>>>>>>>> >vhost_get_vq_index(dev, idx);
>>>>>>>>       struct vhost_vring_state state = {
>>>>>>>>           .index = vhost_vq_index,
>>>>>>>> +        .num = skip_drain,
>>>>>>>>       };
>>>>>>>>       int r = 0;
>>>>>>>>   diff --git a/include/hw/virtio/vhost-user.h b/include/hw/ 
>>>>>>>> virtio/ vhost-user.h
>>>>>>>> index 53fe996686..c95bad5ddc 100644
>>>>>>>> --- a/include/hw/virtio/vhost-user.h
>>>>>>>> +++ b/include/hw/virtio/vhost-user.h
>>>>>>>> @@ -69,7 +69,6 @@ typedef struct VhostUserState {
>>>>>>>>       GPtrArray *notifiers;
>>>>>>>>       int memory_slots;
>>>>>>>>       bool supports_config;
>>>>>>>> -    bool supports_inflight_migration;
>>>>>>>>   } VhostUserState;
>>>>>>>>     /**
>>>>>>>
>>>>>
>>>

