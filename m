Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482F2381B8
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709905165; cv=fail; b=Ni0ekRdwWs1Wl93gX7nZpj/sUV4ffN4oa7h1YNgYwgD7kjwChUN2s2VqaSPegTx4evsGdR6S2yq0xd10Sgi98Wn9a3+NphinjH69hLL6VLoUTOMrIfKbgAqrmF09rx7Lar6Sy26qe9RKi+o2kKsXUAdxmLDc5V8oqmBKSMMcR40=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709905165; c=relaxed/simple;
	bh=zsCYUZqZchT8gm/oe4z5hakoQn6rEJVwOd5HGStdbZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rlTAbo/DWAf02Unrmw9xua+rHlw+YJcrLOa7VzKRJVBOiGoVwagu2hu0VF/PA3tTF9Oy4WFs7f6xW49AWjLN+L5XzBH2ikIkp/JitLZrG/osrAaGEqcBt4HkdrVOS6012p0Rb5bjlRU/omHYIZBVUGNjqX+vDx7GlnEHEWlyEgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=R2fgKhfm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sHTMG7ge; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2fgKhfm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sHTMG7ge"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428DT1TC012370;
	Fri, 8 Mar 2024 13:39:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=d0T/vpFMEQD57U7ODoLZEA0AdS5KELHmKekGRZ6Tkgg=;
 b=R2fgKhfmH3kWShnj/Fv12E92uU41kHy9wOhN7IeCu6FQ/c9nT9y0AnO6gZoofEAtNMCh
 KC23uV3s9BgwUqrSNv+2BI6eZRP0VXr2JqBtGNR4njhcXFmd0B82kqZZ+zKK3JrzbCKz
 G9t/0OAiIg15KKz/1vPogpSxiNQGVh1HH36PKAortyI6Shpl2bvfSFRJ9q9Z77q10O25
 3zPL/XqNZ8Z+x6mBgHkHGQn2zt1wytTRBxAwX6PSHGZ8pmJe5mR8gZiam1hm6KHv74ys
 1rqNVvr0o+KIDrqRlq1A5uzkNwLiCy55ZX6A/4rY3KQBiqOBEM8B1SnIarTsvy7peZ4Z Wg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkuqvprrg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 13:39:08 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428C1FsC013856;
	Fri, 8 Mar 2024 13:39:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjcju45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 13:39:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTqIkt42H78T1mLqfcio9F2N+wW3MnKcRHfZ69y+2TWtdKk3oQ5AUB+fZ4VKr/blm/UGuVFILTMRwU5LiUUMtf1t/2S+/eEnzn02zEGS6Ivu9G9ueQtkI7mitHSGzzBMzWLPGSrU/PwTfrLPqd3ff+NNKtL2vLcBfZX2VURNFXHjdYQPhI/3xq52fw3biPw/DjJ/UwhgycSlkjnYoCoZvTD0fTkEz0snj2zjwARtssh9DR6WVfR1s36kZ9HNuaXrcwXef7q6djyf/q3jDNTbrkkYyzviyuJ+1a332fd0KG2UGCmDv3nM1EMICHhmyyLnMOFKFzcbMLcWGVfO3xBwow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d0T/vpFMEQD57U7ODoLZEA0AdS5KELHmKekGRZ6Tkgg=;
 b=LFyMw4ZEM91+90mS0EpEYDNflLy1N7wj8ZEi7YxJUP8be2FqWZzJ0WHWcI/14fbBH+XunejFSkkwny3rCi1THAJtCKtwEu8ElcmrddYbXGTD8mgOwHVscDQua3wLBKS7yo49DAm/hb5K9kOuj0arBI7yA0et/rlocXICpaAsAty8Q2EvOzCL7rCW/B/83qUb+Ep8IP6jeETECDEwb9+za/JxO8z34nq+0PiFKDLLOnS/3N8P0XLOTNE/2hSVZ1SxcfsMiPBS7Poi7VDtdQTd5SxEvGzUp4bhuDZM3Oi3l9Nx6mmLdWnCR9uLkfpPkivJUyUI5A+Ppp7y12BVqqRofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d0T/vpFMEQD57U7ODoLZEA0AdS5KELHmKekGRZ6Tkgg=;
 b=sHTMG7ge8em6KnUpcaNtmFs+mTjKTZtge2m9JRMUrZKft+faAiVvO4hcrtxpbW2nSoeC0ruS0R2d6K7TsqqOXcKzpugcfMXxf2xC/NjKvxc/4YlmIIhvADVgvkL8MWPAnki7AqHT60EMabNyC3NN5Vm3y7L0AHq7T0LZN7BIqhQ=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by MW6PR10MB7639.namprd10.prod.outlook.com (2603:10b6:303:244::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.27; Fri, 8 Mar
 2024 13:39:05 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 13:39:04 +0000
Message-ID: <701ec0a8-0af0-4cad-af18-c5b66b955a6d@oracle.com>
Date: Fri, 8 Mar 2024 08:39:00 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/8] virtio, vhost: Add VIRTIO_F_NOTIFICATION_DATA
 support
Content-Language: en-US
To: Lei Yang <leiyang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        qemu-devel@nongnu.org, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        Eugenio Perez Martin <eperezma@redhat.com>, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
 <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com>
 <20240306023143-mutt-send-email-mst@kernel.org>
 <CAJaqyWcDMu58H6P3FvyTM7L-GphLB1kj7fcOTBw6FC-O2DcpZA@mail.gmail.com>
 <CAPpAL=xRiVfr4tObY_MwudQ0qyhWOqMzaHQaCdx7YtMnZc7GDw@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAPpAL=xRiVfr4tObY_MwudQ0qyhWOqMzaHQaCdx7YtMnZc7GDw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0248.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::13) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|MW6PR10MB7639:EE_
X-MS-Office365-Filtering-Correlation-Id: cd62bf54-1031-42c4-c2e6-08dc3f751f3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xFAontxhxzIRP4kyo6Nd9wnmiWijY5UicrExW2Q/F3ZjYZBI021TMndfwdhRz/8qe8KYFgQ5mxHegFMqVIE3QqdA8ErjrpVrzh8q6nIQHjJU32QlQCKTB3OxmLgrjmisdEdbd9JtevDZSJOwjFsmWO0OP1qmSy62CnNfANJn1RN2uSqMX2Q+raNST8498ROPPL/QXUDc016stsH/tx96L2/kHw8v0WgcRD7LomcvitCo9Mra/DRDCreszTkvdlslMnfets+uSHJLu1CUjr6zsH0ZbqQlbrZTsdttiIg6lDwAz5KVnW+H1KIyoljtkvULvaBDJhiQQbj5J5HnzfmzeNpWh+X4V96nBZ3OrDxaUu0g28zwJ64GQfDLFwNLcTg4BlzV+8y9IR/AsQqkqafFy3W/hNKKaDNQXkVZFKzHzeuA7jvZ1Bg++jVh8GYjy2x9DXWDtaL1ighSh9hUx9I40WHq7hmpdoUOcVPhWGsSARBzYglqmKWCcSmaI3Y5MlCJXq8f02W9XXPl1MKsxEDkIZ+UJh6uMYCyyo06NWegad3mrsfsy12bOHAdySID2GhI0+0R7oqIgK0Nq0KAtG1eAuUVPsr54GIBdtoAjHfntvvw1/qitcev4IOR4jCRo12FOYG1ayYJQ7xaGUZyG0Uw525l3OrnR1cLgcWWt67prj8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?T3dTVnNNNzhpamRVWUF4ZVJiaDFzMFY3T29jbkFCbWwxWXVYRGtCbWxkVXlv?=
 =?utf-8?B?TjNUTnpZNi9CWTZFc0JCc3JaSm45TURiZWs1Uys1Qi9HYStCRk9wUCtjWVVM?=
 =?utf-8?B?ODRsT3JhS3pnRCtsbG5YcGIrc05nZUd0blR3VFRhYVFya0tLZUhiSlg3L1pP?=
 =?utf-8?B?TGFGMHRuYjNkMVkwY3AyM240aldJVmhPUFFVTTFuZEJYME8vcVdTVHN6cm9L?=
 =?utf-8?B?S2RXYi8yN1ZWYXZnQmRUeGdUazhGak5xeXBPYUpwbUp1Z3NyVmtGY25BbG5a?=
 =?utf-8?B?MWllMDZDSlpGQlNaVjZKMW5RVm1hZzF5cXVya0x5dG9jRWl0WnVkZW1TbURR?=
 =?utf-8?B?RGNBVWZ0WWJSK3EzYzNLTDJtb1dlaDdqRWJ3ZGFHMjR2U2dxdE5BTW5zRXRE?=
 =?utf-8?B?MisyNkNmYThWZWF6WXlNWGFOTkhrc1RMb0htdDBkME1ISDhPdUluU0RHdjlz?=
 =?utf-8?B?K2Z6WUM2N3RoZWQxOWQ4RDJuUGdldjFFblZEVUpXKzh5UTBBWkRXM0R5cm5R?=
 =?utf-8?B?cjJENUlkejBWeTU4UUVRcWdIN0U5M3krQy9JT0IyL1V6dWNSZU1kYXhNWUt5?=
 =?utf-8?B?OFhxTFFqYnFTTHB6d2pvRXN4ODI2VnNLd0E5UmJ5emRsMnNsMHVXZTZTN24v?=
 =?utf-8?B?Z3dFL2g3N2N0dytRcUxvL0lCWlZPRXZQUGpoa2RRVmJlblAwZjYwTEJaZi8r?=
 =?utf-8?B?UVZGbTEvLys4N2o2S3hLK0JZVUN0QXdvUlh5dEdVaVU5VEIwOTNsMjAwMGhz?=
 =?utf-8?B?a2s5ZEZLanFFVkw3WG9xSFNqUElVN2hMeVZOMUd3SDJ2Nk8wYjZuT05nbUYx?=
 =?utf-8?B?V0dEcVRCdks4T3g4NituSU9qNXVrck5SNkFKT3BmaVNDYXlKTzJWYlhoQUpl?=
 =?utf-8?B?cDRiODB1ZnlGVmdyNlBOUnFkUE1RL3ZHcm1hQ0kwd2VSZDFoSnVyamdscmxN?=
 =?utf-8?B?L2tXNU9EUTNScUUzdEtteWFqRDEyMFZFdmxFUnRtMFdDTGZvbnBEM21IcHJ1?=
 =?utf-8?B?RjVPUUFVMmFUNTViVDZuZ3NCTlBERS9IaGxnTTQ1QW9ZUkRoZjh6ZnFYa25P?=
 =?utf-8?B?Yk96eDBVbExQMC9zWlEvS2JsOE5xRHpZNmxMNFQ0Z2ZDaStvdVNFeDNTYlhh?=
 =?utf-8?B?UTcyWXAzK2ZPNXpTTndnY2lhNVEvWjdGQWVrUXVzOGp1ZUVrTUVGWFlSUjNt?=
 =?utf-8?B?QmNCTUhBNDJuajNkUmduRHR6VTh4bmh0QWQ2S1RNcVJleU5aZ3kvR3IvenpH?=
 =?utf-8?B?eWNlbFZuMldtY280ZVd5a3BPOVBGazMrK21LdG9IbExVa2kzK3o4c2I4ckMy?=
 =?utf-8?B?RXhuL2xSRFBpS1FxRnE4NXVhdFFFa1RqZWhwYk92UnRoZkVXOEhtN0YrV21m?=
 =?utf-8?B?dU44bjNjaFdMM0J5V21rbEtTNW5UeDJBanM3ZXBaWEFiL3dOczlNbFNERC9k?=
 =?utf-8?B?S0ZzOUh2cGVkRkRjM2ZKOEtZMlhKck9SUTFpOENBR2J3NXNjSDlxdmxjWmF0?=
 =?utf-8?B?a0o2cGc1NVo3d2hGUTJrem5vdElvZEVrNTdMcHNUa09kVGdQWndMK3RWOWln?=
 =?utf-8?B?WjRjNE1BTStRUmRGMUIyS2pXdlRiOFhoWU8vRTYrRGZOWlRPckcyMk1ycmxZ?=
 =?utf-8?B?QVVQS1ZFUjBLRENxZGFFbk9tNFJ0RlFuYUFwMUVzcHZuRnlVUTNxdnA2VFVt?=
 =?utf-8?B?bGc0Tmk1WkVRTHl4dWNxMmhOQmpzVXN1UDFyNWNNMGIxaXd2cHUyendXSWRR?=
 =?utf-8?B?amRJSk5lcm9LMlRWQUQ3Z1NTY254MmtzY0MwUWIwWFl4STZxbXlBRU00anVo?=
 =?utf-8?B?dHo2cVFBazNPNVhZUG1RT3dLVXVib3M4aElGRTE0ckJJeW50eUg0LzFvZXNa?=
 =?utf-8?B?UStpanA5c2swMGpIY3NvR1ZwWlNWelRyZVFmL2pZZWVjY0toVUFFYS9EZ21C?=
 =?utf-8?B?UHNoam1hK2NQVHFiVjNUSTZHZWQ1ZWg2Tll6bmwzakgyRFFsdFhVV0tSeGw5?=
 =?utf-8?B?OURZQm5xa3JwUWpZbklPeU9kTEUzRTVLVFIwSGdQSi90NTBiZDdkL1EvVUYr?=
 =?utf-8?B?cXZVUEgwOWNzUkJiVjJ3eE9Jc1pONzQvczdlSmpoRkFDOG9oSzljTG5sZjNK?=
 =?utf-8?B?cER1NGtZVVNrdTdMS2p1WDI4SEZoOTdEWldwa0szQktUWms1UE1wOFdHRGR3?=
 =?utf-8?Q?vNhPpfeoLvDZ0j+stUN3p6w=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	NP7X6XHQ+AaKHWwBVO9CMmBZwwgq4u6ZfAAQ0tqC/0r8PsiRFfV9gpJs6yKKTTTokO9kYSfPfJzVntxFQ3+nRu8TjQVGvQmHj6veFQzhVz69QIFLK3tK5bfZ/94AF5k1T+Arw46iwsdXdAYzCF2yYQBG7vew93+WdVAxn4HWPB1zI++GZ8vtDg4+d05XYQiW0Xht4cmuRdd2KmxxcJ6Xg3GVMR0qoNnD+AOgMbiRmim6jCmadcCnSlpR/yoo+dsiuaAiTvSAdl1tE9ifXaGgK/PvpdYPWCxNZ6g+c8x5fMLePW9zC+iJHqv5ntaW38d+uzdRGzDPKhHXLgxWeavfCS8Y3PjaKFVnT4bzQI/hOFY1wyKXgf+b5Wr/8wf/MkahdCYjl3SJpGASCzNmAVw7MGXh7zgpY/Gf6UuSR6OCad9Ip4uMYWZCD0NgDGx+xEeA1bOFlm04tQC6pBSWtcVk7NKf4urBixGhTUVeSiEAu7XeGiD97pSYfZmtHo1aADsg5kGj2J5QludYbx8vSDNOXc5c6Mm/4VICfBoQGTuijV0+bJbolWDtIlnJETjnNd6bGH1aoJLGoqe7f38WrDYXVGoVpI+DoPXaOm8OpmDCdGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd62bf54-1031-42c4-c2e6-08dc3f751f3a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 13:39:04.9185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSd9DK1VbZzPHXr/rsIr171xpK9INjrrjjNRecwTA62EeRUcRs9HDP6SkMMOOBRzQK55NHOBHCQP/IXFuwidmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403080109
X-Proofpoint-GUID: sALB7JYiiP4HgbalNGTc96flNMaLSvjG
X-Proofpoint-ORIG-GUID: sALB7JYiiP4HgbalNGTc96flNMaLSvjG



On 3/8/24 8:28 AM, Lei Yang wrote:
> Hi Jonah
> 
> QE tested this series v1 with a tap device with vhost=off with
> regression tests, everything works fine. And QE also add
> "notification_data=true" to the qemu command line then got "1" when
> performing the command [1] inside the guest.
> [1] cut -c39 /sys/devices/pci0000:00/0000:00:01.3/0000:05:00.0/virtio1/features
> 
> Tested-by: Lei Yang <leiyang@redhat.com>
> 

Thank you for double-checking this series for me Lei! I appreciate it :)

Jonah

> On Thu, Mar 7, 2024 at 7:18 PM Eugenio Perez Martin <eperezma@redhat.com> wrote:
>>
>> On Wed, Mar 6, 2024 at 8:34 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>
>>> On Wed, Mar 06, 2024 at 08:07:31AM +0100, Eugenio Perez Martin wrote:
>>>> On Wed, Mar 6, 2024 at 6:34 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>>
>>>>> On Tue, Mar 5, 2024 at 3:46 AM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>
>>>>>> The goal of these patches are to add support to a variety of virtio and
>>>>>> vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
>>>>>> feature indicates that a driver will pass extra data (instead of just a
>>>>>> virtqueue's index) when notifying the corresponding device.
>>>>>>
>>>>>> The data passed in by the driver when this feature is enabled varies in
>>>>>> format depending on if the device is using a split or packed virtqueue
>>>>>> layout:
>>>>>>
>>>>>>   Split VQ
>>>>>>    - Upper 16 bits: shadow_avail_idx
>>>>>>    - Lower 16 bits: virtqueue index
>>>>>>
>>>>>>   Packed VQ
>>>>>>    - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>>>>>>    - Lower 16 bits: virtqueue index
>>>>>>
>>>>>> Also, due to the limitations of ioeventfd not being able to carry the
>>>>>> extra provided by the driver, ioeventfd is left disabled for any devices
>>>>>> using this feature.
>>>>>
>>>>> Is there any method to overcome this? This might help for vhost.
>>>>>
>>>>
>>>> As a half-baked idea, read(2)ing an eventfd descriptor returns an
>>>> 8-byte integer already. The returned value of read depends on eventfd
>>>> flags, but both have to do with the number of writes of the other end.
>>>>
>>>> My proposal is to replace this value with the last value written by
>>>> the guest, so we can extract the virtio notification data from there.
>>>> The behavior of read is similar to not-EFD_SEMAPHORE, reading a value
>>>> and then blocking if read again without writes. The behavior of KVM
>>>> writes is different, as it is not a counter anymore.
>>>>
>>>> Thanks!
>>>
>>>
>>> I doubt you will be able to support this in ioeventfd...
>>
>> I agree.
>>
>>> But vhost does not really need the value at all.
>>> So why mask out ioeventfd with vhost?
>>
>> The interface should not be able to start with vhost-kernel because
>> the feature is not offered by the vhost-kernel device. So ioeventfd is
>> always enabled with vhost-kernel.
>>
>> Or do you mean we should allow it and let vhost-kernel fetch data from
>> the avail ring as usual? I'm ok with that but then the guest can place
>> any value to it, so the driver cannot be properly "validated by
>> software" that way.
>>
>>> vhost-vdpa is probably the only one that might need it...
>>
>> Right, but vhost-vdpa already supports doorbell memory regions so I
>> guess it has little use, isn't it?
>>
>> Thanks!
>>
>>>
>>>
>>>
>>>>> Thanks
>>>>>
>>>>>>
>>>>>> A significant aspect of this effort has been to maintain compatibility
>>>>>> across different backends. As such, the feature is offered by backend
>>>>>> devices only when supported, with fallback mechanisms where backend
>>>>>> support is absent.
>>>>>>
>>>>>> Jonah Palmer (8):
>>>>>>    virtio/virtio-pci: Handle extra notification data
>>>>>>    virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>>>>>>    virtio-mmio: Handle extra notification data
>>>>>>    virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>>>>>>    virtio-ccw: Handle extra notification data
>>>>>>    virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
>>>>>>    vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
>>>>>>    virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
>>>>>>
>>>>>>   hw/block/vhost-user-blk.c    |  1 +
>>>>>>   hw/net/vhost_net.c           |  2 ++
>>>>>>   hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
>>>>>>   hw/s390x/virtio-ccw.c        |  6 ++++--
>>>>>>   hw/scsi/vhost-scsi.c         |  1 +
>>>>>>   hw/scsi/vhost-user-scsi.c    |  1 +
>>>>>>   hw/virtio/vhost-user-fs.c    |  2 +-
>>>>>>   hw/virtio/vhost-user-vsock.c |  1 +
>>>>>>   hw/virtio/virtio-mmio.c      | 15 +++++++++++----
>>>>>>   hw/virtio/virtio-pci.c       | 16 +++++++++++-----
>>>>>>   hw/virtio/virtio.c           | 18 ++++++++++++++++++
>>>>>>   include/hw/virtio/virtio.h   |  5 ++++-
>>>>>>   net/vhost-vdpa.c             |  1 +
>>>>>>   13 files changed, 68 insertions(+), 17 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>>
>>>
>>
>>
> 
