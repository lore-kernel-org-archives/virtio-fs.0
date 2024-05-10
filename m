Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81841127E01
	for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 13:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715346470; cv=fail; b=M1UV2t/OdCx4uvMHnbuoDD7sMuhW46m5SxENqbjvNq0TWUQIxvqC/ZzLxK/jenbIGpbaSFHictUVZE4S0Mx3w1FlDSfvBuEhE3V0rl8+Kfp6NcgyA87KeXTHYjQKvxkpq25+SGKjh41V50feaSN2zGBItx1AmNlVV6AZcXJx+sM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715346470; c=relaxed/simple;
	bh=hT8vT7M4g3UZhHPz/VeaDhGCXYAIrvqQoMg9+g/2+QE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sDeOjyz90wzJovr95L7Y1y3cZvW2RfFaXP7TyUFiqaHdl1BXuXjixhzlpx80I404pieODyk1GEF/J1Mhmcb/fYC4XlqzKcPBe8FzbQ9ONfRoDjoh1xc8wwL0Bet/CNVZ/FojTkXbeZphG5YF2+jrF5RAdPClZmFZ71Sr/WUlOeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gbAH/gzv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=H4mWmE02; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gbAH/gzv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="H4mWmE02"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44ACRNXX030069;
	Fri, 10 May 2024 13:07:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=fd8byzjvxfGxApwvtLkgdminigeKUH9nRpuL6dsXBQk=;
 b=gbAH/gzvRtaRFD0MfGfKZb9/2VFaVSkCFVjW1vJOeY1TmYuInj7cQB9PNjnmcaSn9u0n
 n3WOET/k+yCdbqAvP1XP4zjtCvM+Onbp9/41nICuo9yVyEp6c7DUg9GIWStdj7E5dOCq
 TVFNdFbqnJTD2oxYiMF2QM7yXSRmwusYS5/iwxwL0U9Ey1NYSf3F1pr6TBC4Oucgb5+d
 Htt4Jdp/UNfk5wjYoptmlEIxPgG5yEKMmBcGxp4P/OK73RKPqURLVBuk8lxmF3RyLWLx
 LycU9pkxSb58faffC/PL8qJMuAxfQxW7DzzfoueDRh65Q/JJrCBYR0YuY3XRqoQ0IeFt JQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y1kk283cu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 13:07:39 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44ACjsqT024328;
	Fri, 10 May 2024 13:07:39 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfr4743-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 13:07:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I57/JJCKxL2x/JQ3M17UEKl2IBkYTeGGmP5T31Q0imdJJ+x1zEo8jGevVRKWZBdxZ+FlY0qfOoDywVLMQQS76F+w3IfTe3WvbR9DbVivOmfzsEmakubBL3SK0/SVLcIWZOQFMrWOyBiNFmW6CJjoiA9+YmXutG0Bp7H4ysuo64upKz+Pi7N48McVwE6q7arXNufR8rF9M2IMDXGM4jsjPJv8VsJhNtosZnMfeflW+WL/3hqkNZR5rXw5kvH5PAqkDPHeK0dE8pejFyx+Pp8R2QMKw2kF3+z66BR2WkkF9TYAcgNJAcbdzbaIuXQRNhOzmFsAZub29XOLRT1MhG+aVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fd8byzjvxfGxApwvtLkgdminigeKUH9nRpuL6dsXBQk=;
 b=bVY1l1CEch1xXjHqJvwqywXRSXPqm9aUxuFAS1aWk18anfZpnRaA8DJAbz6uD66H6PUG0Ue/4DyVvF3shEkym6xJ8hE4xIeizAZV44c4ipB37IGrFTmZHMjUZH6UfwDGJ7uFMhyGdTjF+ZvNX6ca8tf1q2Chyq5kN9UN7oJMPrpulD4gKGWtbKVsBA2GCkvcwuFT8mqzTjIPouRvf1oMS9IA0e7bqrTq+r76HUqp8RLIUAM2IjyHcH3TC0Mqm9vU1ofK0f7M2VR2R1OIQ2K2vWqrhdyCcCGb3yxIcsIJBKdwP5AdsgfqydLKiRfy5/c6hp/gZxDi8nubddjP4eIFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fd8byzjvxfGxApwvtLkgdminigeKUH9nRpuL6dsXBQk=;
 b=H4mWmE02uHFOQqYdmyFt/6ZvYfJI9y8JLTve0HjbsgvdbZDh1rv249Vosb63gBEMxgxT8TY25SaIByqmDZzjlxLZdUltG08XUKu5hBYSCQ6tQ3xOnd5uuIj1N0LCCf3jsozdTmFAtRlwClcLoLtPp/ieWsY2BjfO1xzHKk3gaOY=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by DS7PR10MB5056.namprd10.prod.outlook.com (2603:10b6:5:3aa::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51; Fri, 10 May
 2024 13:07:36 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 13:07:36 +0000
Message-ID: <db452030-2ff3-42e6-94b7-175169123ac4@oracle.com>
Date: Fri, 10 May 2024 09:07:31 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER
 support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
 <20240506150428.1203387-5-jonah.palmer@oracle.com>
 <CAJaqyWd8ALnpr5BVOFpWo1ndUu9Y3XHO0UKtHFzEOFW3FsmWpA@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWd8ALnpr5BVOFpWo1ndUu9Y3XHO0UKtHFzEOFW3FsmWpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0145.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::30) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|DS7PR10MB5056:EE_
X-MS-Office365-Filtering-Correlation-Id: 5178c4a6-9e08-4b8c-976d-08dc70f2298d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?QjFRRnRNRlZxNkVtVGZTcE9ZNmZBQ29nelF5MUtPRU1jNk1BbjFDMXRNc2Iw?=
 =?utf-8?B?b0x5dmV4dDRvOTYyMTZ0NkxJV2hQLzA2bFFjY2hPajdnbXo2cVlmV2g3Tld0?=
 =?utf-8?B?eGQrdkJySUlWK0NrY3hScU4yOGVuL21vQlNNU2srQjI0cWxiUFFDYTMyRzh3?=
 =?utf-8?B?QlhiUnJGczJObmJWcVhBNGc4VWNnQVR2b3lmd2FHbnNhdFljTUdtQzJnN3I0?=
 =?utf-8?B?dXpYR0FHL3NycDVMekh2TnUwZjRsK1pnODZvbGRVQnVoUUdKNG0xOWI4bHQ3?=
 =?utf-8?B?YjFDc25oUUF4L3FvNE9NbWYwMVg3TU1CbnRIdFRGQlhlRVJkMUhtZG4vTXAz?=
 =?utf-8?B?aGlKTDkzSW5FV0F5MnNJQ29JVmVKTkE1T1BCUUdaWTc4ODBIOGY1MWhvYnFC?=
 =?utf-8?B?ejNqczUwTTJTbnd2RnlSUjIxeUpHMUJlRFU5MDdVYzZKZVFXODIwMHZ3TStj?=
 =?utf-8?B?YXF6TXh2U0NkMlBZN1JCSGJoL0tCQ0dyUkpVcnpxQVovbitQenBvUDFERzJO?=
 =?utf-8?B?cjdmdEd3VlBER3VwVXNHUjM3SDBvRVNpV0w1T2lEQTVuRk9NUDYwMEg2YjVC?=
 =?utf-8?B?dXNZeDY0cWsvWXdkdUlvTEF5a2hkLzR1akRNL1U0YUhIWW9nZlhvTFNtOWlM?=
 =?utf-8?B?TTduMFJWOThDSVozZHdxelp0dFRFZFJ6bXZGVkFZd3YvUmx1b1RyYzlRQjhX?=
 =?utf-8?B?RTNjMDdEblhleTgxb3Q5WU9rSzF5T0ZqdGNsMisyZVNReERIOXpIVTZUbmdj?=
 =?utf-8?B?YjNhV3FDT0ZXV09RRmgxazR6NkdIbGtuUkp1VS9CR2ZPNG5kOFVyWXNiR1pi?=
 =?utf-8?B?MDhZeCtlenNuUlplRE1Qbjc0M3Y4NWhWcjFjODY2bldRMFBadGJtZGlqUHN0?=
 =?utf-8?B?TDdUSXZnWHo0OWNYR1krYVZ6c0hNVENRdnlma0s2c3BJSmk0VkhnRHU5a0xi?=
 =?utf-8?B?QnJvempNZUxYN0VEcFlrMVJEV3QyVktsTHBXMlMyMU41ZzFlbUtBV0NXV0Jk?=
 =?utf-8?B?NmlyaEFOdk8wWEVMcXl6ZUhmTytMVDJQOUZ4N2JJLzE3TnB4L2JwVDQ4dWZ3?=
 =?utf-8?B?RWNqN3NzUG9oaVFUYjdWczVvUHNFcEp1NkkrTUZLUHRWcEJTTFlSOWJTVEgy?=
 =?utf-8?B?U2IreTJGNFlCSEk4T2R6RzFqUnBkbzluTEVzb2R6MEFZTXpLVk5xdk1NbDVM?=
 =?utf-8?B?b2ZSU3BPZGdSR3o4MWpGZzBJaDBHUHNMOXFsQkYvbDVYb2c0djVWNkNrVlNI?=
 =?utf-8?B?UXgrZ0dZMU53UXQrUFE0TkxuY01OOS9ZV3lTUGh2eGx0OGp6RjFVSDdyTFls?=
 =?utf-8?B?Yk5oamNnVlRpbkFyd1REaDhaK0ZXbUR2ZnMrdWpYaFV5TFRTdk1OMHROdWwr?=
 =?utf-8?B?dUNxb25mMS81TmMwWVY5MCt6MTEzOEJ2SzJJczZMdWRHSm54cHgrUTlVVVZO?=
 =?utf-8?B?cnl4N2FwMXluVU9HK2h6ZEtYUkQ5N0xCektHazhiRzNPd2ZQMUdsQ3JXMURh?=
 =?utf-8?B?ZTc3ZUY4bENDS2p3bTU5SlR2UUVFTUJ0Zm1hSXdKWjg0cjllRVFFc3cwazQ2?=
 =?utf-8?B?cFFYSCs3dWNBRURuc0J4Y3RtRFBpVU4ydzZ2QkJsRVRRVHh2anRJaHlaK255?=
 =?utf-8?B?a2VsYnZJS25NeWFnMUlIWTNvYTdBazg1dWRKNUdQMlZLK21tQ0xQWjdlM3M2?=
 =?utf-8?B?ZEVuQUIyQjZ4dWpuVHNrRTQyZFRiSEQxSzNSMjZ1U0RmMUtGUTF3UFdnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y2wwd3lJRGdaTk9kQjFNVVhocTJVSDU0N0dxR0dIbVdSZ2t2dWdONXhpUy9H?=
 =?utf-8?B?Zk5UK2R0SXJUUGVpeFlLRGozN2hSRlROM3NjWDRKS2ZZbEM3c3NMS1V6VHR3?=
 =?utf-8?B?TlBwYWp4SUVRbTdmNDQrbTdiOEhrYldqS3hRSU5ZZDAxNy9FSWd1UDBDWCsr?=
 =?utf-8?B?WnBKU3ltOWxQd09vNjlRbmVPM2FHTUhYQ0lDRmpLVlBiNXhkV1VHQXhGeGVs?=
 =?utf-8?B?M1U2NDNvWmt6d0YrQkxaZnlZaENtbm4zMDNGUnlhUWtPcHMwQjJpU2trby9s?=
 =?utf-8?B?aWN1MGEvVHBWSVppN3J3bTV5MzJGUUVLajBRS3k2YmJZSG9kWThnbjJDUHNM?=
 =?utf-8?B?VkprV2dKNWFyWXZyMFdFYWJUK2dsdUxCV0hYUUI3V094b3J0ZG1MUnhyUmh3?=
 =?utf-8?B?LzczbFdMbEk5Uy9zdXN2YjQxMjZReXBGUXk1Sm4yN0xOcTM4c1BIb21jMUc2?=
 =?utf-8?B?Yy9NaXltQ3VZNjNNcXhoU1M0NUxDN3JuMnc2K0RTeFptUHNDV2o2dG94Zkty?=
 =?utf-8?B?NWtBaUMyMGhZa1lyTU1ZMWRONUUzdFp6R3ROTnJNUVc5MDhuRnByQVV3d1pr?=
 =?utf-8?B?TGN5blYwVXhTZmZIRExudTRvOEtvSUdDTmxDaDdmUGptS2dNRVpMZFVsQjJm?=
 =?utf-8?B?MW93aVI5ZUtSWU9aWFRwdi8vWWltNDVGS1VkV2FEWGxzRG8vSjJ6dFJ1bTlU?=
 =?utf-8?B?dXRtTzlMZnpoTkIzK2R5Q25XTDlhK3lJV3dqQVpLUzJQcDduQzdNSUxkcFlY?=
 =?utf-8?B?V25neWUyYjNZMlArQnEwQTNNRWtMZXhJSmFvQmQrSWpJMW1Ua0p6MWo4OUFV?=
 =?utf-8?B?N25yUjJmRG9qOXEvSHdyTE80T3BQdy9sbkVSeE5tUWdzT1lqTmtNQy9udzAr?=
 =?utf-8?B?cmFlY0tPUktzRWdMNzBkTzc0UjdYaWREUC96dDlzYnJwNHFlNE9nM0tRMEZ1?=
 =?utf-8?B?azY3elRGcERxMHRuRC9RYlZ6WjJRQ0MzR3BsU25hK2YrdVc5azU4Z3Z3TFNB?=
 =?utf-8?B?YTFXTmJyOW84UjdSMWkzREFROUVtWlJtbGN5Z2JrV0JkZW9rSHhmUEJ3bi9F?=
 =?utf-8?B?TjZRcnFkTXJMWHVTMHRUQXJ0M1VjWFF6VXNSNFZOdHFKb0E3dGJmV2g5eHQy?=
 =?utf-8?B?Z3NrTGhFVHBTSWNNOHZ0NkYzdjdZSjAyZEVKVDZLNDBaRzgyTU9vcWVrSUx5?=
 =?utf-8?B?aTR5Y1A3MjhTR0NHUGhzSThlU05JNnZkQmEzRTNJYnhyeEVBYklUYWNYaXJp?=
 =?utf-8?B?TE45cmxoTVJsamFPZzRzVHBDNytEYVNVcjZISWd5MzBTYkNGc3BWL3RaNnlt?=
 =?utf-8?B?ZmxlTVpGcXE3cVdwNGx6Tm1iaGJnUTN0T0JhY2dLUUJpSWYvc0VrSDB3cUp4?=
 =?utf-8?B?QUN6VTRNQTdOTUFuUnk2QkUvYlBhcTkydWdJNWZZblFmTDhzRVpSWkV5bERH?=
 =?utf-8?B?WUhWMVlpZFBEcThGZks1QThNbmVCMjExdFR3NmhBTnE3bVJGRG9sMHY1VkJF?=
 =?utf-8?B?b3EwYmV1WmdkWTNoWHliTXRzTVlqNlE5NWNVdlAyZFlPdWhYZUEzdVh3UE9W?=
 =?utf-8?B?a2ppS0RVbmhIWTJiQWZJUTJncVQ0UlpJTTN0bGRJYnVTOTloMWRyZWp5L3c2?=
 =?utf-8?B?T1Q3VWpad0NUeUVWZFk3YVRQYVl5OGRtT0FCWHJTVmtOR2R3dUNjMU10dFVX?=
 =?utf-8?B?ckVzNW5SY216RHVyejhza3NXenhJWkV5eGtYNkhWWGxuVGY1OWdHZTRjQU9B?=
 =?utf-8?B?Njdtak9WYTE1Z0ZZQWJpTXJyRXpJc0RCRmxpNCt5dGY5TTh4ZVZzVk5VU0lo?=
 =?utf-8?B?VWhWNEZ6ZTZqd2ZJRHpFaWJtMUhMV2ZiMEl0Zk00Z0MyUElzTGdYck4xd2JE?=
 =?utf-8?B?dUprUUNFV3ZTTjQvSzdjeDBxdXB3cGtHakNzb2Q5NmRlWmNzbjVXVGl5M1Nw?=
 =?utf-8?B?VEdvbnFRUE41cThDWlJSdWxsYnNORDUyd1MxcVZ1bWFRc1M2b0hFZ2JLb3Ex?=
 =?utf-8?B?SkxvK3lsYWFVQWVHcm81RG41K3BwaUV0Tys4ZzJ4UDVCU01pOFdMMnUvR3hH?=
 =?utf-8?B?a0hwT1lRYUp6UFRMbnZtQkt5V2E3VFRJczV3Q3U3amlZVU5IWERJK2I2L1hK?=
 =?utf-8?B?a2ZqS2tUOCtsVmlEU1VvWnVGT0ZIUVNGY0RsbXNJZWZhRCtTNVFNak5YSEJm?=
 =?utf-8?Q?SXSMQDfxl/k3XJhZFClJmNE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jFcaWc7KaDy/p70gTKa096+AzSndNewHhvH/19npI84fv4coaQwcCkXdbxAHq2GoXHg5wBkvD4pez4JC6pKkmL0h/wGsJLmZfw+9cGGPm5MGpsCEDpZXJYF6psNXBsf5Ep9FfZdSv/KAd+SuWmbf75tMxndkVsoOVxTKHTazPFUbLWPqgSMr2qr05Y2pR9V31vyfZOWIU3S5eZXiuL9ENrVkGv2mZZ4pygZCr8XgG+xy9rG/POSbmVxm4nCMr+o3QUduCcSgGYHujNiVr3T9oW8d/O8PsuOW+U6KFBXEkOZ8r1D1gahk/+3yrddJKNGLMXPn1WSUz5g9C5Z8N0tVS9KQ+6kDD/mmY1v3wMUZDdfxh3921v1t/i6rJS5JHARy34yrqNvqawRWNNgUfK+Tgj8Cx8VTcBGfRv/OEy79b8P0Tfh9gyQDrWrTLSO8gncF/wemHvWtxiurqngR9cIexWBybyhur/siRYudrQJnryXWPi4w2L2YiVMPRY0rpV90SdEvSnQ7GsAOUKZCOL1fJdTGj5HevG8AyQ476mpyPssi1zBID8nXQvwPmE37chNUfOuvW7GTNmYn6e3XdP4aO07gLrJ/y5AXmg90iAilVjk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5178c4a6-9e08-4b8c-976d-08dc70f2298d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 13:07:36.2750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ztu0It0ne1PFVjHUlaYm/RRVwoNu+0IqtytvhLZ9HXR5mWVVC9e1MagzT+nZdAheNDhOjVQ+x4QCPZnF0EwQDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5056
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_08,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405100093
X-Proofpoint-GUID: YUB0kMLnmYslf6p_sFfygro9WAPkmRyz
X-Proofpoint-ORIG-GUID: YUB0kMLnmYslf6p_sFfygro9WAPkmRyz



On 5/10/24 3:48 AM, Eugenio Perez Martin wrote:
> On Mon, May 6, 2024 at 5:06 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add VIRTIO_F_IN_ORDER feature support for virtqueue_flush operations.
>>
>> The goal of the virtqueue_flush operation when the VIRTIO_F_IN_ORDER
>> feature has been negotiated is to write elements to the used/descriptor
>> ring in-order and then update used_idx.
>>
>> The function iterates through the VirtQueueElement used_elems array
>> in-order starting at vq->used_idx. If the element is valid (filled), the
>> element is written to the used/descriptor ring. This process continues
>> until we find an invalid (not filled) element.
>>
>> If any elements were written, the used_idx is updated.
>>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c | 75 +++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 74 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index 064046b5e2..0efed2c88e 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -1006,6 +1006,77 @@ static void virtqueue_packed_flush(VirtQueue *vq, unsigned int count)
>>       }
>>   }
>>
>> +static void virtqueue_ordered_flush(VirtQueue *vq)
>> +{
>> +    unsigned int i = vq->used_idx;
>> +    unsigned int ndescs = 0;
>> +    uint16_t old = vq->used_idx;
>> +    bool packed;
>> +    VRingUsedElem uelem;
>> +
>> +    packed = virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED);
>> +
>> +    if (packed) {
>> +        if (unlikely(!vq->vring.desc)) {
>> +            return;
>> +        }
>> +    } else if (unlikely(!vq->vring.used)) {
>> +        return;
>> +    }
>> +
>> +    /* First expected in-order element isn't ready, nothing to do */
>> +    if (!vq->used_elems[i].filled) {
>> +        return;
>> +    }
>> +
>> +    /* Write first expected in-order element to used ring (split VQs) */
>> +    if (!packed) {
>> +        uelem.id = vq->used_elems[i].index;
>> +        uelem.len = vq->used_elems[i].len;
>> +        vring_used_write(vq, &uelem, i);
>> +    }
>> +
>> +    ndescs += vq->used_elems[i].ndescs;
>> +    i += ndescs;
>> +    if (i >= vq->vring.num) {
>> +        i -= vq->vring.num;
>> +    }
>> +
>> +    /* Search for more filled elements in-order */
>> +    while (vq->used_elems[i].filled) {
>> +        if (packed) {
>> +            virtqueue_packed_fill_desc(vq, &vq->used_elems[i], ndescs, false);
>> +        } else {
>> +            uelem.id = vq->used_elems[i].index;
>> +            uelem.len = vq->used_elems[i].len;
>> +            vring_used_write(vq, &uelem, i);
>> +        }
>> +
>> +        vq->used_elems[i].filled = false;
>> +        ndescs += vq->used_elems[i].ndescs;
>> +        i += ndescs;
>> +        if (i >= vq->vring.num) {
>> +            i -= vq->vring.num;
>> +        }
>> +    }
>> +
> 
> I may be missing something, but you have split out the first case as a
> special one, totally out of the while loop. Can't it be contained in
> the loop checking !(packed && i == vq->used_idx)? That would avoid
> code duplication.
> 
> A comment can be added in the line of "first entry of packed is
> written the last so the guest does not see invalid descriptors".
> 

Yea this was intentional for the reason you've given above. It was 
either the solution above or, as you suggest, handling this in the while 
loop:

if (!vq->used_elems[i].filled) {
     return;
}

while (vq->used_elems[i].filled) {
     if (packed && i != vq->used_idx) {
         virtqueue_packed_fill_desc(...);
     } else {
         ...
     }
     ...
}

I did consider this option at the time of writing this patch but I 
must've overcomplicated it in my head somehow and thought the current 
solution was the simpler one. However, after looking it over again, your 
suggestion is indeed the cleaner one.

Will adjust this in v2! Thanks for your time reviewing these!

>> +    if (packed) {
>> +        virtqueue_packed_fill_desc(vq, &vq->used_elems[vq->used_idx], 0, true);
>> +        vq->used_idx += ndescs;
>> +        if (vq->used_idx >= vq->vring.num) {
>> +            vq->used_idx -= vq->vring.num;
>> +            vq->used_wrap_counter ^= 1;
>> +            vq->signalled_used_valid = false;
>> +        }
>> +    } else {
>> +        vring_used_idx_set(vq, i);
>> +        if (unlikely((int16_t)(i - vq->signalled_used) < (uint16_t)(i - old))) {
>> +            vq->signalled_used_valid = false;
>> +        }
>> +    }
>> +    vq->inuse -= ndescs;
>> +}
>> +
>>   void virtqueue_flush(VirtQueue *vq, unsigned int count)
>>   {
>>       if (virtio_device_disabled(vq->vdev)) {
>> @@ -1013,7 +1084,9 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
>>           return;
>>       }
>>
>> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
>> +        virtqueue_ordered_flush(vq);
>> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>>           virtqueue_packed_flush(vq, count);
>>       } else {
>>           virtqueue_split_flush(vq, count);
>> --
>> 2.39.3
>>
> 
