Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618D5612F1
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709573540; cv=fail; b=lTdy9nosRFCOJl0+iwtoxKpJh+grtCHlCsKcOud2bx9C8a/5cqdouIdGpdlTcIyvq+AU7NnsW98khSpaVVktT8/77vfDedxSKINPqO/eXHeQ4GBz7UNZfLfxwMwXnNy7rA6sHVQ1Y7qhXDv4iPrMkjKjFWTXSFU38EF7lILY9xA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709573540; c=relaxed/simple;
	bh=RyaingN/2J41LJ09J8yRI7VrQ3aaXQN4nL3UxFwLH78=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RL9uVKmDvt7w76gqpjLcKXVd3cdOo391goSJ79vQZ9uAPZ+MVE0QdtyEvlN2tQccKNYWbeWwDyOk/5kVsuirh/fDV1wVPO30uPLvqTMEiM5y0XqipR7XZuZjAq+699dCZQSxjnopRTXBUIHTTczne76611yISH68wkxtkQhntTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OivEhU8t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UWxWy0MZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OivEhU8t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UWxWy0MZ"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424GYKF3018500;
	Mon, 4 Mar 2024 17:32:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=K0XuQxLJvBShX9Dt7+1+fLUecvLcH+Z9TK37exc41/U=;
 b=OivEhU8tQw7Wz3HDnMzkMTSmcBMXl1PjHy7jrYcGt7GxqjHB129owgXZE9/wszEEyml+
 qnZhpgOJGLbIDZfrOsaxBnVt52XNzSiF1rDyAvQ2Nn2J5dY6cH8vmMwB1oeZZ2RIlvmN
 LAzKpXvk+ZSaHA81wIjkK+9bMlyEgHUfAzmxkwLT0Bm8M46inRmpvpQqwiebzxibx/vR
 YrW1ihp2u9XNsQWZDADjcYGT5+Np1XBT+e5v0RLQFRucDY8TeG9DD9a7EtyuwM5hAH7+
 cuc8BGIIn7Uk7g+CrofYnaAiyZqT3A6hme6EUPvVzHKbN7xclsj0sFnQhAUyOp8m443b uA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wku1cc98n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:32:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424H2dii016981;
	Mon, 4 Mar 2024 17:32:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj64bx7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:32:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6cgcsn4dFovz1Nk5LodfsODyyCswI7ga7RwSzTabzUD70qOBRLPilITY/upUyUNgOq4Ovh2oznNtI/uDmD4ca/mY6r01tkpGtMQu7OkxVZSiQDPP463sO12dHu12v9JuKoNaGDZ4CUtZidToEtcA3LyKWXGBL9kW7TJAFaF5031x3euccgrxJ3X3E3Prf7hhtzUhLwbPCbUTSMNBDjf62GOk1hkSTCJh7U2vPUcOI0yFQdgrCPkYuBFnN8Hm46nSatLvmGHJ8eeEoVMai0b8wjhy5NhKmd5kjnHYaCS4/RIoQ3sEKJyEBEF4M7qYBjp1IOYxmWtzxHgTDS26O3gtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K0XuQxLJvBShX9Dt7+1+fLUecvLcH+Z9TK37exc41/U=;
 b=cWksY/wyVrf8I2vfTJUmiNgGsfv3Vnl1Kyyc6fZr8HGU4Us7haulzl85ESbH1MehDp5jneOuqnBR4zWFwsJeFjIMU6yldo7cNGcGtCXMF1DaAogHtmFXKX8KBhUryidtG4APopqaOLMqIei3zwTa87Yt1suDNCW8wM5BibDryG2U9K4kMb1haU11tWtl1dlrE70exE+QbfK2tczb0zpiJumj/PZNkdf+kgpBfhbBXOWBVY/TQWRKSqg/G4ytU6LoT6ULvHwQf1EAgrpVfv2zkWeKQszxm3iMldYbMwAUrSQ7MmMnv1QNYnn/pgjcJqi4wDfxoykeMcTlzw5rCfWrYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K0XuQxLJvBShX9Dt7+1+fLUecvLcH+Z9TK37exc41/U=;
 b=UWxWy0MZv/VQpkBKYkvQM9KQ8GS4UoHyGjgcRY8S+f6D4tb9R+O+AUs48I4lT3QFhkVAPHC5scmMQ2SaNOrPay1sIC2GGXUokhuzs8FnpYwdGtZ6uXPBof/1SZv9AgfAOt/l1MNsUl711uOg65JwAlQP5KmW/RYP2B8ZyzBsisE=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CH3PR10MB7743.namprd10.prod.outlook.com (2603:10b6:610:1bd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Mon, 4 Mar
 2024 17:32:08 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 17:32:07 +0000
Message-ID: <d9c1aaa3-5b46-4b6d-adf8-5a787d3ebfaa@oracle.com>
Date: Mon, 4 Mar 2024 12:32:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/8] virtio/virtio-pci: Handle extra notification data
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <20240301134330.4191007-2-jonah.palmer@oracle.com>
 <CAJaqyWdokP3yqbP8wPfgttFyFWfy1O3ST4jUQmiJ+n-xkrp_Zg@mail.gmail.com>
 <964078ad-35de-4687-86e4-e3bc059481b0@oracle.com>
 <CAJaqyWcnfhRA=xXHxdgF-u8gxJEAt7FQFryCrwj52N+4aLPbUQ@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcnfhRA=xXHxdgF-u8gxJEAt7FQFryCrwj52N+4aLPbUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR07CA0103.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::44) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CH3PR10MB7743:EE_
X-MS-Office365-Filtering-Correlation-Id: 457ad95a-49de-4f0c-e2ea-08dc3c710420
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	7kOAePWd6rntXKQ2H7MT7lpOuJH+1FOslt0JEOE8z9EDEv4WmMPC14a/qIEOQnAU5uDRtie3Sa4bLrqaW72MWl3HKrNqRoDw40VH/nL4QNqCIWIUoTJB9cn5vU9g9izUVAjDdSP1zRPHJVyCnna4IzDZVet2huu5tvoqlC+lqW+k6Mz8BO0CXxSjOHKvO9n37pG2APIMo8KV8qrro8BRsxOGVl8Vhgm8Lcx4otDM98pCcKItqS3Q7FlhMszRIKzSIm3RKoPraFhB+/LZgoureKH120JoW/wu44LAHz0u56gNSXYSHTcTN+L9bIQVMEoxAsVz86fmvNT9i99b++i3ui7++NTFoiYBdJ2qopDmzEZbucEdn4ET32FYFyFqFtZeSAZ+QhleIBdszKsRaAcVoOfVbHlXOWEsHhn3Nfq0ez5ZFysd7ElGHqlVIgvIToQcTvsTF2j4qGj+loy9NyORJm/3ikXprOnVurWbP0whBsdfiagrMDxsiM3Uet0tBMW4qLruFKY0LtQFGfcZRL9SUoTXpywuJPmwoGNjjksm4KupGeuOaCPtUMGvYs2uzkLSeThm7yO8mcd5my3d4zQCzr8w3XpNPvHM3EWgLd3D/3Q3Dsah9X0WLg7MhCs4Mj2TgHzPh1YW3ZU+9OsZf2xoTPcnDSxs5ftuWIgK7jM2Olg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NVBVUG0vYVAwaEgrRVhLV3VGL0xxamVIRll1VEI2Wlpuc0tzMUhiNHg5dE53?=
 =?utf-8?B?TXVBVDZJS3NJZ0ZpTUp5ZURhT2Q0Q3VyajltSE1VTmVRbjR6TkNySE13VTdF?=
 =?utf-8?B?UWVvQ0tVdzNGQ2s1TFEyWmRLeGpoOVk4SnVvZUQ3dW9Fb2YvVFdrNHdoejlH?=
 =?utf-8?B?TVNPNFhzSGdUVG1iV09VT0JweXRMYnU3R3JtQXYwRHJBdGRXOUZnUjJ5ZFdI?=
 =?utf-8?B?VVNnd3lEa1d4VG5ORURXYVZTK0VYZ1hiRi9Kc3ZERzdWUkp1bGp5R0N1S0d4?=
 =?utf-8?B?MzZsODY0Tnk0SUNZMTQwajQ2SjY1U0Z2aXZSVW14Z0wwdzVkOFE0cWR0WUQ2?=
 =?utf-8?B?bVZ1YTRTTXR3VXpxVDU5cGpEZEZwR2ZRTURsa1ZxWjdYM1hOMDRtOFgxYWdr?=
 =?utf-8?B?SE9BazlJblpaS0o4aE9kK3IwdGthTzlweUZyVFJSbTVzajBzc2RjeUVVbUpR?=
 =?utf-8?B?c1hidWVUYlRpaUlDVElJQ0VBVWNTaGZNUmY3dzloMXZkaFowSlViUTJmcmx1?=
 =?utf-8?B?SElBU2NkUCthUmsxbHExenlvWjdqZVRxa0RHNVFpcVhpdFZDaG9kWVM3TnBY?=
 =?utf-8?B?Q1pzakIrendSZXNpeGRqc3hEcVl2T1FqMDB6NzBQZWZWR1h3K2tTYUUvYkNs?=
 =?utf-8?B?RHk3NWRGSGhSQnpTelhJQklJZk50WWYydlF5VTZXdzJkVktzZFhHdUZIR1U3?=
 =?utf-8?B?UXJhMzdLSDBQOCtFMnM0ZzVrdVUzcEpkcGhVU3hhSUxGaE1rbGVhRXdscENM?=
 =?utf-8?B?UUdudkFaQVExODZxOGtTSDNaSDJ3TjUzT2hYTFk5aGhZa3Ewdlh6VHBYSGhy?=
 =?utf-8?B?a0NGbzRuTUgxd0U4bmcxRThYUUorbUh5SFN4WklJbW1tRXdnaGJMWXhOcHUw?=
 =?utf-8?B?ajI4QlRXMCtvOThONG5CRkJUQTg5VU9uMmZvMzNENTMwNEhxYjFHTElDQkts?=
 =?utf-8?B?Vm0xRDV2U1VjSnFrdFRnclV4b1MyZ3FiWUMxcklUVHlqN2VwVVJSbERMbHAz?=
 =?utf-8?B?SFM2QTYrQlhlbXhvTGw0R2xPTXlLSkVYWWhiUmMrZHU4d2ZLTFVOazArU0tV?=
 =?utf-8?B?aGNnVTdDcWMvcFA2K0VpWmJaZ29QNFNHdFFJc2ZYSFJ5bE1BVUdQWWIvVmpR?=
 =?utf-8?B?VXFSeU1yZ1Jwcmp6WVkrQkhlSmZPdG5GWndPV25Nd2NtTm0zYzQwL0NUNFhB?=
 =?utf-8?B?YzBUcURuWSt6OWNWS05FN29WeWxVZm9kazM1OW9uNWw2SHduQ1BJY0xKcDFN?=
 =?utf-8?B?cSs1OGgrNENwZ0JhSWtzc214MXA2S0lLUTVCSnNzc2FpVlZ6eDJzdTlCdU5N?=
 =?utf-8?B?aHFZV1d4dGxPVlk5SmpPN1pEZHIxbDFZWFJmb0Zsdk9saGlGbnk0K2wwMnh3?=
 =?utf-8?B?OU1HY2dnSlRJNC84ZEtqaXlEZTJmK3dWaklqbG54Z3VMM05QL1JkOFVFOVhD?=
 =?utf-8?B?eitreGxHd0pQd2VhZFQzREhEQ0U1RUZvbTRkOGtWY3R5YTNYOEpiN3QvbUM1?=
 =?utf-8?B?WHF6cVNzb2h2OWJrbHpwcHo5SDhhcktKQko5Q1ZoSHJzaVVRNkFQRzUyb2lE?=
 =?utf-8?B?Wk9xRUNSQ1NOWTNaaHl5NC84WWlHamhnUEhLWWhpQmprd0VqRFJQek5jWGNv?=
 =?utf-8?B?dWFrKzhkbUNnV293emJPcXB1Wjhlb0htQmg0L0dhTE1pYnAvbXZabUUvZ2ll?=
 =?utf-8?B?bUwxc2x0NnU4elBXSmhOWGNRUmd3MjVMTFNlNHpub21obGtqa0FDZzVPbmpQ?=
 =?utf-8?B?WXdadnNQQUx2VEVEZUNtVzlISkxHY2xoWlZCbDhadlg1Z0UrNHlGcGZQeU41?=
 =?utf-8?B?aTdJa3FWNExiNmZGQlNBTnRLaXZVTEZ1RFBpeGdGQ2VPcHlheEx3SDlTQ0pa?=
 =?utf-8?B?WEEyTHVYbkxzZ3BoQy9od0hUaE4rZ0Z2cGhVM2ttUnJlTzEyOTFMODlNTlgx?=
 =?utf-8?B?OUJWQ3Zyb2hyZ0lnYkNkZHRUVUxMZlkzL0pWTVBsWmlBQis4aXZzNEFnb25w?=
 =?utf-8?B?MDIwTmU0RzFKSS9KaFlZb1VZS1ByNmtlNTlFK0x2QU5Uckl4aExud2E2S1hT?=
 =?utf-8?B?RDNNNFV3NzRTTGpTQStqL0VleHBXR0l5SjFiUlMyMmdSWVA5UWo4d1FzYWFk?=
 =?utf-8?B?WXlXaHhvWGQ4U0c1UGx0clRGbm4rbG16ZUJnWGNRQXBoaGNhR2RraG95eUY5?=
 =?utf-8?Q?M3tbf1lNOII6P2CWkowsvvY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	IgPBavrsY41YerHdkXErGHxzPUxwLFHoOD17NTRJ/xeJG8/DBYYs6eQ4SOUqEiUiJ6D7t4RkuqTTwlq7QUn5/XqBykM+ng1zuKWIVN2+U7M9ckJ+G1F4Jyzw88tploiNehwVWcUIFokf/CgwEryfnQxkFSF3vy+jKjdSh5QCAtMIAokZqTt/mZ+BbxR85E1abzE/wFs1ai8X0G2Y8CESOAlXcHCAiZVurU2fp5E0T68O+98YCE5VOEK9V3NRhGVRcH821kLriYPNrkoEJMBVmVysULsdum/lPMruCCGtmIqHcIJWuGE4e4a6ifjooBmIYX6RpznAW+ExJnjx3cOl60c8B7ccNG97qrIzvgJubeDaJlUnP2L80+z75v2cvmNxdpi+sxAN6Wo/T3jBWlhDTD274jWnDIeunq9J65JXPJp6u2uzqrbpc7C/ZyliMMQZgNkfsBV5XP/oMygJzwR/TksI0L0DHhg2TSZvpMYg/AbhxGiJCYiP/8ZN1CBbOhfhw1bGlkuVxufVthY9RIfOFcK4lHVETegT5o5b0GpMJrE0YIaRZs0rFi+VGe7T5XzdxS6AUf0FUHIpUZHvS9s/UPnKo5M4tpoVe1iBuwXiTgE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 457ad95a-49de-4f0c-e2ea-08dc3c710420
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 17:32:07.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+W0u/nXtdBEvxHIP2ryj1aIxJEztUWCQ3wKJfyMCkKZFD3OgGkptG56bhYMlC5mAKsdMR9walPy9K8+qBkrcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7743
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_13,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403040134
X-Proofpoint-ORIG-GUID: BUzNV_bq5gr2MQcYjouuAZFZEjfsq_S7
X-Proofpoint-GUID: BUzNV_bq5gr2MQcYjouuAZFZEjfsq_S7



On 3/4/24 12:24 PM, Eugenio Perez Martin wrote:
> On Mon, Mar 4, 2024 at 6:09 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 3/1/24 2:31 PM, Eugenio Perez Martin wrote:
>>> On Fri, Mar 1, 2024 at 2:44 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>> Add support to virtio-pci devices for handling the extra data sent
>>>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
>>>> transport feature has been negotiated.
>>>>
>>>> The extra data that's passed to the virtio-pci device when this
>>>> feature is enabled varies depending on the device's virtqueue
>>>> layout.
>>>>
>>>> In a split virtqueue layout, this data includes:
>>>>    - upper 16 bits: last_avail_idx
>>>>    - lower 16 bits: virtqueue index
>>>>
>>>> In a packed virtqueue layout, this data includes:
>>>>    - upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
>>>>    - lower 16 bits: virtqueue index
>>>>
>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>> ---
>>>>    hw/virtio/virtio-pci.c     | 13 ++++++++++---
>>>>    hw/virtio/virtio.c         | 13 +++++++++++++
>>>>    include/hw/virtio/virtio.h |  1 +
>>>>    3 files changed, 24 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>> index 1a7039fb0c..c7c577b177 100644
>>>> --- a/hw/virtio/virtio-pci.c
>>>> +++ b/hw/virtio/virtio-pci.c
>>>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>    {
>>>>        VirtIOPCIProxy *proxy = opaque;
>>>>        VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
>>>> -    uint16_t vector;
>>>> +    uint16_t vector, vq_idx;
>>>>        hwaddr pa;
>>>>
>>>>        switch (addr) {
>>>> @@ -408,8 +408,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>                vdev->queue_sel = val;
>>>>            break;
>>>>        case VIRTIO_PCI_QUEUE_NOTIFY:
>>>> -        if (val < VIRTIO_QUEUE_MAX) {
>>>> -            virtio_queue_notify(vdev, val);
>>>> +        if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>> +            vq_idx = val & 0xFFFF;
>>>
>>> Nitpick, but since vq_idx is already a uint16_t the & 0xFFFF is not
>>> needed.
>>
>> Ah okay. I wasn't sure if it was worthwhile to keep the '& 0xFFFF' in or
>> not for the sake of clarity and good practice. In that case I could just
>> do away with vq_idx here and use explicit casting on 'val'.
>>
>>> I think it's cleaner just to call virtio_set_notification data
>>> in the has_feature(...) condition, but I'm happy with this too.
>>
>> Do you mean something like:
>>
>> if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
>>       virtio_set_notification_data(vdev, vq_idx, val)) {
>>       ...
>> }
>>
> 
> Sorry I was not clear, I meant just to take out the common code of the
> conditionals:
> vq_idx = val;
> if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) {
>      virtio_set_notification_data(vdev, val);
> }
> 

Ah, no problem! Thank you for the clarification!

>> Though I'm not sure what would then go in the body of this conditional,
>> especially if I did something like:
>>
>> case VIRTIO_PCI_QUEUE_NOTIFY:
>>       if ((uint16_t)val < VIRTIO_QUEUE_MAX) {
>>           if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
>>               virtio_set_notification_data(vdev, val)) {
>>               // Not sure what to put here other than a no-op
>>           }
>>
>>           virtio_queue_notify(vdev, (uint16_t)val);
>>       }
>>       break;
>>
>> But I'm not sure if you'd prefer this explicit casting of 'val' over
>> implicit casting like:
>>
>> uint16_t vq_idx = val;
>>
>>>
>>>> +            virtio_set_notification_data(vdev, vq_idx, val);
>>>> +        } else {
>>>> +            vq_idx = val;
>>>> +        }
>>>> +
>>>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
>>>> +            virtio_queue_notify(vdev, vq_idx);
>>>>            }
>>>>            break;
>>>>        case VIRTIO_PCI_STATUS:
>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>> index d229755eae..a61f69b7fd 100644
>>>> --- a/hw/virtio/virtio.c
>>>> +++ b/hw/virtio/virtio.c
>>>> @@ -2052,6 +2052,19 @@ int virtio_set_status(VirtIODevice *vdev, uint8_t val)
>>>>        return 0;
>>>>    }
>>>>
>>>> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32_t data)
>>>> +{
>>>> +    VirtQueue *vq = &vdev->vq[i];
>>>> +
>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>>>> +        vq->last_avail_wrap_counter = (data >> 31) & 0x1;
>>>> +        vq->last_avail_idx = (data >> 16) & 0x7FFF;
>>>> +    } else {
>>>> +        vq->last_avail_idx = (data >> 16) & 0xFFFF;
>>>> +    }
>>>
>>> It should not set last_avail_idx, only shadow_avail_idx. Otherwise,
>>> QEMU can only see the descriptors placed after the notification.
>>>
>>> Or am I missing something?
>>>
>>> In that regard, I would call this function
>>> "virtqueue_set_shadow_avail_idx". But I'm very bad at naming :).
>>
>> Ah that's right. This would make Qemu skip processing descriptors that
>> might've been made available before the notification but after the
>> host's last check of last_avail_idx. In other words, ignoring available
>> descriptors that were placed before the notification but not yet
>> processed. Good catch, thank you!
>>
>> So, for the packed VQ layout, we'll still want to save the wrap counter
>> but for the shadow_avail_idx, right? E.g.
>>
>> if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>>       vq->shadow_avail_wrap_counter = (data >> 31) & 0x1;
>>       vq->shadow_avail_idx = (data >> 16) & 0x7FFF;
>> } else {
>>       vq->shadow_avail_idx = (data >> 16);
>> }
>>
> 
> Right, I was not clear enough again :). You probably have guessed
> already but not modifying avail_wrap_counter would make QEMu to read
> the wrong index too.
> 
> Thanks!
> 

Got it, thanks!

>>>
>>> The rest looks good to me.
>>>
>>> Thanks!
>>>
>>>> +    vq->shadow_avail_idx = vq->last_avail_idx;
>>>> +}
>>>> +
>>>>    static enum virtio_device_endian virtio_default_endian(void)
>>>>    {
>>>>        if (target_words_bigendian()) {
>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>> index c8f72850bc..c92d8afc42 100644
>>>> --- a/include/hw/virtio/virtio.h
>>>> +++ b/include/hw/virtio/virtio.h
>>>> @@ -345,6 +345,7 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32_t queue_index);
>>>>    void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
>>>>    void virtio_update_irq(VirtIODevice *vdev);
>>>>    int virtio_set_features(VirtIODevice *vdev, uint64_t val);
>>>> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32_t data);
>>>>
>>>>    /* Base devices.  */
>>>>    typedef struct VirtIOBlkConf VirtIOBlkConf;
>>>> --
>>>> 2.39.3
>>>>
>>>
>>
> 
