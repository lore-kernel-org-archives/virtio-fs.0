Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4B916EC06
	for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 12:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715342512; cv=fail; b=TVbvo4mwH8FxqtsvGdJkQRofucokyUm8g+0y2ayujF3Pn+MoImuNluo6tddWj9MAZ10kUIxrNd4IDUmdK8nxsxLmB2uhnaHRYNiAIfAZj1BIwb7KTxzpltOWfxtaZs4Bri6I3ATj7TpbLAkg0p+oGM+ItxtjCIBGyT/V5gGFyiU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715342512; c=relaxed/simple;
	bh=rfoGf6orqwLfu7TZ7MxZQxq/JqGs8yxYxvfo5DN63C8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GAEUagvYG00YePZFN8c8FaE6rCs0lhqiwBWlAfIY0oI6HgXFE8WJVPs1INopPMCyE0+YXEBjNnS3xcwqCNj6u2gideKCOeO7qVLkxEj69NolGwumYxVJSyIKXHNANMW4/zcn5OhPERmtWDP+9JwkDFnqkZdZq8Sa1DLC68TeuhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L1d5opSs; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bfn/6trd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L1d5opSs";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bfn/6trd"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44AB5Y4D023151;
	Fri, 10 May 2024 12:01:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=fUGIJBXf3LeM2EKUzFzZprw8aDPFgwSWrsEBjN74n6Q=;
 b=L1d5opSstbrfmmlKW1Q/p+T3iTrXo2DPmi8oFOO80TI5MXqpw6PIIdYfpRy4gsRROTjG
 EwiTaLQJF/2FeYLAS3VWWqGKIrsWe64rZVs6gD/BJHnV1HvDTa5PYayOyxW3kzlYqepA
 G4eT51fOCNaz8/KsjgNNJrJwn5IQlaN5h6Bn4gmvhy/XnFmSO0gKLQsXPCQuzmLtWzo0
 +VtiOCzlD0/Q9m5D//79KbsA9Xej2kucBUC7sgkmF7dMVH56oQORdP9rCnfiX6NILG7k
 m5Rvh+zcprd0gde1swNAPM9mFbIwkPra5hvk12fJcF7Nai6TqBsz9yECnaWKZcRA4G+F lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y1jd302nv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 12:01:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44ABPJNJ019108;
	Fri, 10 May 2024 12:01:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfpf8ev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 12:01:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8ISike0ExCtd9t1Fvb1cC8PoXoD6ZwOu9RjG38sgL4XV8BnX6oidZD/bFUr1Qq8OeG2nXvHA69rn3DOcQhvUbGnTs136tVNiGmuHXKXeaQGDv/JPZpY44tUw3b0UVwQ/qIRyfeJ1FEozijQDgNCk5KguCd+7LOQVia+rIcJvkfowLbJyf2a1tOhOjShq+XWHUDCwGlElK7TpIi89hvpib+wDMKsH9OmVS2LR+NICh4vShRivTmYnQTIlEUmkfKaBDfQeG/LeiLmLpo5TRIgvoMIC1vTvYfV5/+cyhiAVkpPSb129ckJLSVztLkACqQ/5K38E7PLfqfIT59EIpEEiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fUGIJBXf3LeM2EKUzFzZprw8aDPFgwSWrsEBjN74n6Q=;
 b=fEwoS0nSle536kjc2vDWpwaeEdz0/Ec+A5jofycnfJSpqDYVHlDxgMMdxMbb+j24WRTdiWCCpnA2oRGT7CrKto6Mkw6bXY4whCzXg3HZmDwtB4mZ3vquIYnV4QuFftWl31MYyakARiCDodar8fX5lgzuq3ClEzkGLPz3MXZJTGKdSDJ8YLlcr0wDiFxNGsW2rb/Lztuc6Fhl7B3TYvDwphww4lggogUr4acVhvdMX3RmBg1jVR8EF+eHSwdDrt08NijATGcfhrTcLIQth0FIA+1ObHylEVN07UnxOUPuSZ/SPLDBUMH3Hbf36uJUsreVlXwZ928WZfcblYFbRYGNTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUGIJBXf3LeM2EKUzFzZprw8aDPFgwSWrsEBjN74n6Q=;
 b=bfn/6trdWtS9DHStmwlqqSaCJ3dBTUallDNLDaMZIddJF0A0NWzPLvKJEmG/QfdBJes6ly96OQYZMOiKdCv6SHSrJ4Com2rl2jqwqEZbslC8mF2ko75EmXDojiJbzXCAsKQzk4B8xMuYW3oZ4s1jE+P6qMfld8/5czt6mdF3wJQ=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH0PR10MB7025.namprd10.prod.outlook.com (2603:10b6:510:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 12:01:36 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 12:01:36 +0000
Message-ID: <53a4505e-c9e3-482e-b84a-7246769b18a6@oracle.com>
Date: Fri, 10 May 2024 08:01:27 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER
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
 <20240506150428.1203387-4-jonah.palmer@oracle.com>
 <CAJaqyWcTSQ4hyzfYRENE93GnHMhgvY4X_gz3ydnpYUMz1_J8aA@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcTSQ4hyzfYRENE93GnHMhgvY4X_gz3ydnpYUMz1_J8aA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0261.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::14) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH0PR10MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 2250e68f-dea4-4d90-5037-08dc70e8f147
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?eGlnSTQ0R2NCSG9pdzNKcS9yVGlJcklyYWJ0bEZWcy9aeUNuaVRCdVZ2bEcx?=
 =?utf-8?B?WGJwSlFRUGx5OWdrdDV4RityQ2JrUTZja3NSQ3JiSXRITHMyRys5dkdGWmRK?=
 =?utf-8?B?RWJQVEhGWDc0OXp4Yi9LZER1K0o1aTVENWhSOEt0L0JLZG1pdDhNako3Zk9Q?=
 =?utf-8?B?SUhETlk4emI5Nkdsa215YmZvR0o0ZFdmTGNQZWltSWJBdnhBWTRaUSt1NVo4?=
 =?utf-8?B?TS9oQmxMYklhRm1saE9jbWIveUxvTE1qUDFkbGZGdGswemdQbXozVVYwSGl4?=
 =?utf-8?B?eTBJWnNBbVBNNkdQVkRsUmdxUG5adUFaRy9Bc1VYem1ZNTVYVWlwQzBzM3R0?=
 =?utf-8?B?U0d0dFIwWVJ0NzduekNTN0tZRkhxbzRjc3hablp3eUl4bStMbXNHMndqVTNz?=
 =?utf-8?B?aHdUWDMvSUozQ3BLMXRrV1RYaDhCNjNnZUplSGczclNXWEFmQlpydEtwbFZC?=
 =?utf-8?B?SVE1Uy9nSHNnVHUwbWJ4enc2OS9NMmZMYk5JSm13UkNkbEhRdjg2d3RNUVlO?=
 =?utf-8?B?TEVDSWlvL3JILzlmQVhRQkgvY2UyNGtoU3V4UkV2V2pJTW1TWG1XQWsyK2t5?=
 =?utf-8?B?ajN5RXRFaW9GajZuMXlRQTBEL0Z0eDl4aXl2Rk92NXhENDMzM0JnMDRvdXlK?=
 =?utf-8?B?UzJTTURIeEF4YjBJQUIzenkydDFPS1VPM3BoRlhUemRZL1Nta0NKdzEvZDYv?=
 =?utf-8?B?clpEMFp5WnZyd2dMdy9oUksyY2hrR3lXanFpKzJrMjRUZXFLdHo3Vkw2bTdi?=
 =?utf-8?B?TkYrOEZ1cFgvS1diQndHR0R4VTVwZGpHM2x2dEVNRW1KNWY5SVVON29sY2JM?=
 =?utf-8?B?QUl3ajFWQVVyTmpRQ1dyUW5RVlBWZDRlZFNjUDNtekZVSHYvRTNkeTdOcUpp?=
 =?utf-8?B?QjFKZ2Zqa21TUExhSjlHdkt3b2ZRN1RrUlFUc1U1b3BTOTlKQytoM0lDdnZ1?=
 =?utf-8?B?UGdEcFBNR0hLM3ZWVjRwcFQ2eHZxdmc3VFh2dDIxVFNpTGR5R0pWQTZxTE1M?=
 =?utf-8?B?ZHl1TVVhTVMvcXlwWURCT25rUU5oMEpYZGlpSFdRT2JHL1J3SmY4NVp1TGoy?=
 =?utf-8?B?UEhJcG44MisxWnkzc01SZ0FTMzZaS0RMakdkb1VoN0lSWEo1WVZCdnR3SGRu?=
 =?utf-8?B?NVFHNlc4c2FjN1prdnFjNDc5MzNwcXVRMVVMcW5qSXNUV1lQeU5udVUrUWNw?=
 =?utf-8?B?dHhqS3kvTVV0SmVHdDF4Rml1UmszelEwOHRWMlV0WXhJRjFKSDRqVVJSb2p1?=
 =?utf-8?B?RzZvRTlFVEkxTStIQW5YNHRRbUM5anFSSThncUxsMDF4bFc4ZXpCSHlPMTZx?=
 =?utf-8?B?b0duZzlmU3FyU1l4MytPVGlidFZoUVVFV1BwcHJhVjhwZkpZTjA0ZGtpcHph?=
 =?utf-8?B?ekcvSFU0Tk1vcTVWUnVZb2xsNDhReExQY3Iza1VhQzhZMlBjY2oyZStGYlBO?=
 =?utf-8?B?ek5xakJycVcra1E0ZHFBc2w5L1YyNi90d2NRSXl5NTdHK0Mxbzc0S3N3MFlq?=
 =?utf-8?B?QTRaSzZMMmFPek5jQllIMGhvQlBMUFI1MGdYc1ZtOE1ubmJ0MmRRZmJNNEV1?=
 =?utf-8?B?cWJUNWZBam9oSnVvQXVwY0lCOGVXRmdDVkFHaVp2SWU1M2xkMmF5SHlHK2ty?=
 =?utf-8?B?NkpiS2V2RVFQQmVkRi9Od2dtYjFqdzgwYk5uZUw0d212SmJZbXNIZ2FpRThE?=
 =?utf-8?B?eDA1MHJjTU1SRnVqRjJTZys3WElIeDd3d1QvNDBhYVBYeDlQSU05alNRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cG45YXpFZUZnT0hLQnlyTXdqbU5hdzZoL2xlN2UxZEhRV0M0NVdqS0lIY1Jh?=
 =?utf-8?B?OFVsNW5ZSzZOY2pZQy9TSjA1clJld0NLa25VKzR6QytPZ2gwYk5FSHNyWUpM?=
 =?utf-8?B?MmZZNWo3cm55dE4xSFI0aFR4NzlzaVhTUFZDZkUzc2NDRTdyNXMwazl2Rkxx?=
 =?utf-8?B?QXEveXl0QStOWXdmek1maGkwNmpoQnVEMDRDVFJrM2IxTjlkVGVRZ0YwUjc5?=
 =?utf-8?B?RTFYNTc2dFJYdFdWVzJ3TGZiT1NrbEhkaE95ZjF1eEFsN3FsWFdZYk95R0pD?=
 =?utf-8?B?TUtWNHFTNCtoTEh6UzYxSFlOb0lIcHQ1UFZsWkpycnkyeWdQNU9lWHlZZkxm?=
 =?utf-8?B?MzUwUkI3RzdGMFRsRVlUZGtXdkgwbk9ZV1RzcDdib3Qybm9kaG5aeWJVc0FG?=
 =?utf-8?B?WEYzcG5EUnRONjhINm83Zkg1N3hLZGlUTDRvb0ZxTkg3MExhRHU3NTlxVGFi?=
 =?utf-8?B?UUsrM1ErMUxQQjdWNmxuWUV6ZVJBaitLTTZCOXp5Z09aUmVHT3l3MTBTejdP?=
 =?utf-8?B?T0hFcUEwUGZLMXJNemsvUytDNFB5YXAwR1pxZ09sSHR0MWtKdFFPdnlvNm9y?=
 =?utf-8?B?ZTEvSkl5dW9kZzhibTN5cEg5ckkxVnlSV1Jad0NFaHR4SDlaN0s5dmxJQUVX?=
 =?utf-8?B?K3Z0V3VndG9aWlY4aWJRNCswNW5xYXNlUTFna3ovRld4U3hWM0NaVE0zQVpi?=
 =?utf-8?B?UDVIYmxPUENqZmxTby9obERrQ0RodXo3ai95Lzh6dWdpbnQxTk0ydnZCREp2?=
 =?utf-8?B?R2JQOUpUOXZuSUZxMUd2d0kvS29Gd2JEakE1TFZEY2kyRkN4K2txZU9yK0ov?=
 =?utf-8?B?dk1MamtnSGlUeFdzcjl1UEJ6UWh5RkhsWlI3NFN2MjRndU5zUmJlN1NYN1dQ?=
 =?utf-8?B?WUlyRjF2R0V3RS9odmpzWS9lOWR5dCs4Q2ptU0J3dlhMZ1RUUC9SMHNqam4y?=
 =?utf-8?B?SW9SVTM5ZUxjVXVYaFBjcjNiRm1CbUcyejhqK2pyblo4QVhZbXMwQmxVUUFT?=
 =?utf-8?B?UVlpSGdnMzVrUlA5ejRLNlorcE04dCtUL1AvZkZ0YUVaUEdHZS9KdlJ2SExj?=
 =?utf-8?B?YkdPNUp0bVVQc1ozZTRPekVSSTAwMmhnVGdzZ1Y0RkM5WDllWVRwTWV5SEdo?=
 =?utf-8?B?cGpQcmJ6TWZOZkw0TzEzdEcxUnArQ2dYL0dSWTRCN1lKSDJKOVp0bVRFU1dR?=
 =?utf-8?B?SGRSNjVpalo3T2cyVVV3OE1aSjlIanc1cVY0bUxnRXhZUDI2MmpYNnRaR3Zl?=
 =?utf-8?B?WmxPVnlDUURZOGZhNnZSZ25McWRsRDIzU3hUMm1IZFcvZ29iMysxN05RcWtv?=
 =?utf-8?B?UEFTaTc5RVZZVWdxRTBPV0dSM0d2ZkNZdjUrSHZGTFlHWWxuanhpL094VTgx?=
 =?utf-8?B?VzNzRmlPUWNDK3VrbWNhOHJTaXU3d2I5d2tEemRwZURmNmRUWVYzNnNJQ3pM?=
 =?utf-8?B?MUVsVVM0U2ViSmZFeFlaWXlnaHlYYzkxY2hIcjlnUFdmdThCYjRGV21WY1pz?=
 =?utf-8?B?REtSUnFBQWdzcDNrbzhFSEVYdlN3c1RSaklxTFM2M0pITEUzZjAwNWVqd2ZV?=
 =?utf-8?B?UFFkSDRDYTAzaXN3ekJ6T1JPWnM4YzlRc0Iwb2JEQXptdW01S1lpS0RpeFV6?=
 =?utf-8?B?RUFTOFZrc2VnVzZxa1B0V2U3VnRKTWFtbENtbENDdloxL01OVWNrRG8wcUk0?=
 =?utf-8?B?bHVteWRVWFNGMEhnNmR4WjQ2a1JKMG96dENLNWttbUdRdDZDVFVIMmhNTjdM?=
 =?utf-8?B?R3ZsR0F1YmduMk84REM2SnJqV0hQS0VIY0RLamlKYUc5VVFTQWZLL2Z3NFMv?=
 =?utf-8?B?Sk9SdjZiSXZBSTFaYVg5N2NacUFHeVNHMVBRYnhzQ1hrUUVXQnU1SUJQdjRy?=
 =?utf-8?B?WnJmUzQrVkROUWY1c3ZtbURSSTZ4L0VZZ2ZreUU4YzBTem9aZnNZQWhiQnN4?=
 =?utf-8?B?eDVWNEg2YTl1YzdQa1VXVmFQSVByMmxCNzI5eGJraFBFY2IwRHZSckhGRXdX?=
 =?utf-8?B?Z2JmY3BxTkttV09iSTBFdkFoY2laQy96dkhnMEtkUjdpblJJNFg1aXpwWnE1?=
 =?utf-8?B?S0N6MVZ6VWIyVXNua0xaU05Lekc5WS8yMXlTeTFzdFNGYVdZKzc3UjZhOUZI?=
 =?utf-8?B?QlkvaXhrSE5JMmZTWjhyblZDeDJiRjRaeGR1WTM4VUkxbDFMYnB0bk1SMHZJ?=
 =?utf-8?Q?b/f5Ji6zxz9R0cUw2mmAcls=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	lBXuohz2HtQ43M0KmyOL6QR7OKORnpQErgm/JB+gFNgFXtPtyZER9jpr9eB8PjFaFjzuxNGdXjU+8lUgn5duCBuoYwkdBxR2Aeld4iFL3Mh7u/+9nDZc3xu+Nuz3u1vJdG1Qk/0vnGaHB45pp7jLN/RVZB5qrX5SoU4K73/1ixdZK2wGwKKAM3DTX3eezelT8PRmZ4B2v3h9yxD7u0mbFN7XMOHaGsaoUypAZz1ffI0+SgpTxF1O3qb7uMgReUZndh102G7GJ85/ELuZZ8GsLmNXod2Onc6nebAHJxFJJpEiMU1Vn27Uqug4aR43xgaM2iq5/Gh7BZpE91mRj3K2OygQUyZdUAyhlPHh/8dKtcXckaKMpmhLIQGM0/2ypwQZI+kYS0gaK+fuReROBSFX0xR4N8XBdleIwodFmd8IHB6Vyf+p/oZpAE3N+uRtJ0h2xDt4WBIrBO5qHm3FKiBzFK1NFw9qvdAZpMIqdnFkH0TJZfR6kBEmmZ/mbk8EwIs5DLuninmVNbQ1iwrElIG6+DKTOQBo+SGec+FMqCq/K5rSY4SeZxP9z1DsyJRBQ9fboET/yo1HbBT+UG16dbHD4MiKyg0E4fMnFTCXErsjMqQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2250e68f-dea4-4d90-5037-08dc70e8f147
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 12:01:36.5062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpOCPWwthvEL7z11hLSvTUeNsO06uYiOhlHSn5pA+va3uSpNF/3L14dMJRkfF+pkE8c8c9RhGe8KGPqMQWvAew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7025
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_07,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405100085
X-Proofpoint-GUID: kz2zSDtGI5kuhTuZ4zDl5vomsoKoy0gL
X-Proofpoint-ORIG-GUID: kz2zSDtGI5kuhTuZ4zDl5vomsoKoy0gL



On 5/9/24 10:08 AM, Eugenio Perez Martin wrote:
> On Mon, May 6, 2024 at 5:05 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add VIRTIO_F_IN_ORDER feature support for virtqueue_fill operations.
>>
>> The goal of the virtqueue_fill operation when the VIRTIO_F_IN_ORDER
>> feature has been negotiated is to search for this now-used element,
>> set its length, and mark the element as filled in the VirtQueue's
>> used_elems array.
>>
>> By marking the element as filled, it will indicate that this element is
>> ready to be flushed, so long as the element is in-order.
>>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c | 26 +++++++++++++++++++++++++-
>>   1 file changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index e6eb1bb453..064046b5e2 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -873,6 +873,28 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>       vq->used_elems[idx].ndescs = elem->ndescs;
>>   }
>>
>> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement *elem,
>> +                                   unsigned int len)
>> +{
>> +    unsigned int i = vq->used_idx;
>> +
>> +    /* Search for element in vq->used_elems */
>> +    while (i != vq->last_avail_idx) {
>> +        /* Found element, set length and mark as filled */
>> +        if (vq->used_elems[i].index == elem->index) {
>> +            vq->used_elems[i].len = len;
>> +            vq->used_elems[i].filled = true;
>> +            break;
>> +        }
>> +
>> +        i += vq->used_elems[i].ndescs;
>> +
>> +        if (i >= vq->vring.num) {
>> +            i -= vq->vring.num;
>> +        }
>> +    }
> 
> This has a subtle problem: ndescs and elems->id are controlled by the
> guest, so it could make QEMU to loop forever looking for the right
> descriptor. For each iteration, the code must control that the
> variable "i" will be different for the next iteration, and that there
> will be no more than vq->last_avail_idx - vq->used_idx iterations.
> 

Very true and something I was worried about, e.g. what if, for some 
strange reason, we could never get i == vq->last_avail_idx.

Perhaps as a surefire way to make sure we terminate appropriately, as 
you mentioned, 'i' should not increase by more than the distance between 
used_idx and last_avail_idx. If it does, we exit the while loop:

unsigned int steps = 0;
unsigned int max_steps = (vq->last_avail_idx + vq->vring.num -
                           vq->used_idx) % vq->vring.num;
while (steps <= max_steps) {
     ...
     steps += vq->used_elems[i].ndescs;
     ...
}

Though if we do find that steps <= max_steps, should we treat this as an 
error or give some kind of warning? Since I believe that, under normal 
behavior, we shouldn't find ourselves in a situation where we weren't 
able to find the matching VirtQueueElement in the used_elems array. And 
not setting 'vq->used_elems[i].filled = true' may cause issues later.

> Apart of that, I think it makes more sense to split the logical
> sections of the function this way:
> /* declarations */
> i = vq->used_idx
> 
> /* Search for element in vq->used_elems */
> while (vq->used_elems[i].index != elem->index &&
> vq->used_elems[i].index i != vq->last_avail_idx && ...) {
> ...
> }
> 
> /* Set length and mark as filled */
> vq->used_elems[i].len = len;
> vq->used_elems[i].filled = true;
> ---
> 
> But I'm ok either way.
> 

Let me know what you think of the proposed solution above. It doesn't 
explicitly separate the search and find operation like you're proposing 
here but it does clearly show the bounds of our search.

But doing:

while (vq->used_elems[i].index != elem->index &&
        vq->used_elems[i].index != vq->last_avail_idx &&
        steps <= max_steps) {
     ...
}

Works too.

>> +}
>> +
>>   static void virtqueue_packed_fill_desc(VirtQueue *vq,
>>                                          const VirtQueueElement *elem,
>>                                          unsigned int idx,
>> @@ -923,7 +945,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>           return;
>>       }
>>
>> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
>> +        virtqueue_ordered_fill(vq, elem, len);
>> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>>           virtqueue_packed_fill(vq, elem, len, idx);
>>       } else {
>>           virtqueue_split_fill(vq, elem, len, idx);
>> --
>> 2.39.3
>>
> 
