Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437D546AF
	for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 09:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716458233; cv=fail; b=kywOUMQIT5oltYLSeC0x+kFajyfPpWGeN6Tly9Er/P3LxIV8CkWqzXi5MEXqVYY8RB2dXJaeI8cfaRe248Y9YzknAzPnp2kgF3tVgLOcW8uuAfkHMebeGDT3iRLUxfaT72L/om9na+VYTNr4hUWv30YaCbJGOFcjpxXLfyTNDPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716458233; c=relaxed/simple;
	bh=OZuJcXD2gsYN6zdyHXrFMYILXOzRzMAskCWGf04Nmrg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QjJRnNyjejjz3cSf1D69XWw0r7xTpJnul/mHlde8RO+0nqNmqxDB8cCWjeFywFWzkthUwTRiDBV5Qc196ikC7gAZfVnpzKIJ+1r0X9y5WH7myn4XMWUajIkw3quxNHLl9c9CozLTw9Zt1qhKIBNn3FSQStKcKzprOQrQMCLzAVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F8+BF/FD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pHeUaq4t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F8+BF/FD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pHeUaq4t"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44N8sMeW017233;
	Thu, 23 May 2024 09:57:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=UYUjla0/SDgWMetuo2eqmagGYf2qXAQYh8z3LrouJdw=;
 b=F8+BF/FDmjzASucrE0GT/j5fEyDjXyPbiijwOdlJfPR+zMU35009qVRG9jFJ3nz2JLtM
 ONcHG+sGRZw1fnxwCI2BtYkjv/H1G6QsXJDjsPDBcTlP84b5T4fTjpr9lN98yMiaBgFF
 AOpXLVR2BIjgOd+yLYW+HUV82zfgASsZa/Np0ui0H2LQi4TQmF/8+V39c/GlU5V6POAD
 XmUnzeDUHInqDnhGtdG48d9NRu9dnj9ixYW4PFwEK1dcfr1zSTdMYR4n6Y6tqWG8AY6P
 R5YXR/+1MMSAiiOw1ot/b6BeR4u8PxZaLYlct1/4ROfe2U6GKBDDeNSWv85cOHz5ZxKu oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jresjma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 09:57:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44N8mJYv025734;
	Thu, 23 May 2024 09:57:00 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsapery-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 09:57:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j45sATKZ5xvKsX0EKLZ7mbDyjutY5vBGoWKhBHTUhk5EaMw43yBsxaWx5FH/qQY6Q4UkV1mby28YX1rCw/ZUNW6jA1Od7peQe+emHY24bkvFOH98yYz1oCfL9i47CifV798ga77pnDQVucMuqdZV/1BG84iJ+CKOslZVDGN70USfTEO0sKEdTXEmj9mJ16kCqO8IwM9D0ni1c0pqQaMa3MHefjpZPxH4JtrWsi8+r2STLkTcOAUKsWpz2SOK6wBBJw7C6BxEWxPYSvJIXYyJ7mQshgwcanZX/hM0LGs2E9Mh+yaMhcJkZ/qYUu5VzxVlcPxE9ewfs/Ax68WLJB/orA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UYUjla0/SDgWMetuo2eqmagGYf2qXAQYh8z3LrouJdw=;
 b=mz2PPdMq7uXyG1mvpM/OZLpFzNfx4ElMspZuUiD5GV95SBqf1NvLSeiLUM0plRKdiEkH9z9quLXZ4tKRG5PkE/21zZz9CZoNJQcxsZRg8TTARsg+2YJ+f1cM9nl4wep7juzAb0j4EVxVvkqVLKbvmfEjfM8D/3TdpDyJu9oDeokKjVBXXYqZ+SFKoe/PYFUbtSfK7Z9KZtFVvOTKW480TwwjdGcUZBGO75PjhjKpPxT7ox7qgjkU5x2iGUMOoJXrlMSIEeHzYtvLmyQ09DVYYRyEGA3j38/Ine2VFCwSvy3GI7Jqb9sXUmy79LyGDLZ0poszk9K8hb5DZFOBe38YOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UYUjla0/SDgWMetuo2eqmagGYf2qXAQYh8z3LrouJdw=;
 b=pHeUaq4tkxBa4Mv3dBiwrTJIT52AFdmmBQx+ffKyoj0hkKt+/tXimVxI7m1D7+JE5Yy2VYMGlahzauVP5c1AdLdXxPBFJEOyL5+CH3cHFhXCyOR3ti+uj78s6STVJndn1qC/fIoUjSXJetjEhq00y1Ltq2ibvqYwwKsXjrZKK2s=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 09:56:58 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 09:56:58 +0000
Message-ID: <31125aa1-c1ff-45b9-a1d1-1543f3bfdbbc@oracle.com>
Date: Thu, 23 May 2024 05:56:53 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
 <20240520130048.1483177-3-jonah.palmer@oracle.com>
 <CAJaqyWePFXKm9qSjczbWyacadd7Cxv2NxEvM1qT=UYNi_VW7qg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWePFXKm9qSjczbWyacadd7Cxv2NxEvM1qT=UYNi_VW7qg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0246.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::11) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|BY5PR10MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: d30437ee-2612-41c9-3fb2-08dc7b0eaf38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?aG9ieGhnNFdSaGFmZWhWRmNoanZTYVlyTUZJZE9Qai9pR1pvTGNzdS9KN1lr?=
 =?utf-8?B?YVViRG5TaWFYcmVCZTdoMlJ2V0VDY3ZUN0Rnb0xmY2ExZVdmOFp3bytEbWZG?=
 =?utf-8?B?ZUx2aStmN0QzcFdzcFZRZzdoWEk0cExNUGFPdlNCZ1IvMGhUMFhnNXRScjVM?=
 =?utf-8?B?Ymo3S1Z1cnQyVm0ycGM3SzQvQmhQV1FaNW9RMDdnclc3aDROeVAvcWZ5YktV?=
 =?utf-8?B?Z016M0ozU1p2c0Z2anAwRTZKVk9IbzdFNUpCbm5OZTlRaXdhK0lhekc1Wno4?=
 =?utf-8?B?TkhtMEpibWErMC81aFdkbjVuMlJDc3dXOGZPSDE5U2pZSWFsSWFkQXlhU1o3?=
 =?utf-8?B?UnY0d1p0WWs4cmdvL0FoRmJVOGJpT0ZWRHI4MGphRDZ1ajJiWkhWRUt1SHlD?=
 =?utf-8?B?NFpiOGc5VlFObDRaNzZKLzNSR1BHejR3Zm9NU2plVEwyUWQyQkxMUTM4ekY0?=
 =?utf-8?B?L2RQN3krczRpUm5qSzU2RHBLbm1qdXEvaXhSSytyVXdkSTRwMXcrR0R5WVA1?=
 =?utf-8?B?RVlvV2ZDYzNKR0xLL1pCNCtJMGMzRmMxdTVTRjl0dzlUV1dHOXBmdVV0djNh?=
 =?utf-8?B?V2kvRHVZdjhwUDl6VFh3dUVLN3VIdDFkclEyUWlWa2JDT29YeDk5WkRIR0Zt?=
 =?utf-8?B?amRHdGdWVEtDd3k5ZFdvc2dOMCtMZGVLSFgvRlozbG5NNDdHdjduV2VNL0xm?=
 =?utf-8?B?cUhaQWk0dFFYSThzMytsRmVFSUQ3UTJNdWNodS94blVEcEtrTUNrcXpNb08z?=
 =?utf-8?B?REZRZXdEVGdMeCsxSmxtRHNzenpMOVJlRVQ1Nmd3cE5ZOUc3SVFKNmkxeG1q?=
 =?utf-8?B?bUdUeDVQUHRKRnZwWThrbG9jbVhSREZhbk5CN1ZHOUV6b2ZqelhDWUdvVjFu?=
 =?utf-8?B?WjhvZ0drY28wRytSdUF1TEM5WFpJTnplUmFadDM1ZnpZV3ZORUEvQlRKRlVD?=
 =?utf-8?B?d1FqdVNQRy9XbzFoQzl3enUvQk5TUytaUFBPRHduVkkwMDVHdEtpbGlMN3Vi?=
 =?utf-8?B?RW1sVHE0UG1Za1dWNjd2RmVpd3pSSmZSM3RzTmxzb3ZhVzFNYUNIeDlnOWVv?=
 =?utf-8?B?a082SllxaGs5eGZWMGswbUIweHcydktScThrUGI3bWZ2WUtpVzJ6eDJJbEZG?=
 =?utf-8?B?cE1zMW9GbXRvaGljRjJMTHJzNTl6bmJOQ2wyUVhNM2g2d3l0eTVRMHVrcVZy?=
 =?utf-8?B?cStVVFltUkVkRGRKT0JocXdlUDB0Y2prbGtiMkxLb0tMZDRvcUpQalltK1lo?=
 =?utf-8?B?SjY0WmFpRFBGQjB6N0MwUk41YmZUQlFMcXdWb09PQWNTV21kRG0wY2hOZDhE?=
 =?utf-8?B?UlEzNEliWnB1WmJEeUROOXNpMEhxM01CczRQdHNsUjJvcWtabU81NlUwbGRE?=
 =?utf-8?B?cVpQWGNVQWhYeUx6OTBBeGNIK1ZCdUdjNzNFcHdlamtEaFdCcC9adjhRYlc4?=
 =?utf-8?B?OVVGYU5xVFdYdmdtSytUZ3puYWxTVlh5MGVrL0NnSitheThkZzZmc1o5MkNl?=
 =?utf-8?B?S0puT05TUCtoaXZEQ2I3RmthTWJIeG84S3NXRWVLYUhJS2V6SDlMcE00cnpC?=
 =?utf-8?B?ZFErUndFbWZaRjJRdXRTUlpoM3ZkUjlsdFlHNHNsY0JjZ3NDYjFkSzAvRVpi?=
 =?utf-8?B?SDlRcmxOemVQU0lESGsvV29NaWhHdXBWckQvaFlPeGM3NFpiMC9sMmVtYjFP?=
 =?utf-8?B?Szl1c0M5dVo5eUNWWnpGYWFLcUh5N2RNS1UzSjFrTXBDN1llUjQrSEN3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NU1udTArcFlJeUxuVTVRMXdZOGFzaFQwNWxDcVBQQmowdGZ6QnFWR1UzSnd2?=
 =?utf-8?B?eWJTeVZnM1drY1ZOWlFQemFyVUMzakFyZU5FMmNEdjdWcXVuMkJxQmJUNDIw?=
 =?utf-8?B?ZkdCcGszUEQ3YnYzeUFzZWNYbmRwa0szbGdTc0dFRmlpYkNHN2xXazFUQzRl?=
 =?utf-8?B?bzJyTFhmY3pFakhoMzZxREkwN0N0NTE2TTRyVmxzeDVQcWxTWUhvbXFGRXpn?=
 =?utf-8?B?RFd3ekJiUEVXUHhIVWZkZ2RFZThndmVRaThjYW9wUnQ4MUNTOG9UeVJxdE9u?=
 =?utf-8?B?QVpES0lWazZsZzhHOUlybzVabWthOTlhNG0wOXRtbno0TDIvL3Vpd2wrQ3ha?=
 =?utf-8?B?RmtrZnZrdjkzMFRXajA0RXlRbFpXMlA2TXBRVUFJUDdrdVhiMm1FNWU5K0dY?=
 =?utf-8?B?cVpFQlY3N0F6R25ibHVHVDd6NldVaDZwR3lmejBhNFltcDV5MEEvRzRkbjIr?=
 =?utf-8?B?WHJEZ2xyS01WNml4K0p5Zktsc25jekRJTUgyZnNuN29pTlF0ZUlUV3hZSldS?=
 =?utf-8?B?bWVMa2VXeGthWCtEMERmeEpneUZ0WUs0MXNUL2pwOHdsNFhqcjNnYVRuK1Zn?=
 =?utf-8?B?U2JiYmZ2dlpSMW1lRTJQWWgrajI3WFpPdjhqaGF1ejZWZ2labGVyMmdoRzFY?=
 =?utf-8?B?Q1pkbjZMSXlDbkVFMjVzcUdYUk5aYmViVGVUYk9qZUNxdnFBNjNMeUdYS1l4?=
 =?utf-8?B?NWYzZC9TUGFIWXVDZjdHTDlwT0VrcGVyMHIzeURXL1Q1YW5lblZORnZkd0VQ?=
 =?utf-8?B?SUFHWWNmaEFSTEdSMXBqcDZqUDVEeFQwOStpb281Q29GVzdkVHcwMHhvemVQ?=
 =?utf-8?B?bFVZOFUyQXNwZkhrMlcvVjlVMWtMK2xBZFRjZW1DQ3Y3cUVqemt3ZGNlclZI?=
 =?utf-8?B?YmczUjBGTDZIYStnSHpvcm9FOG4zUDkrV3J4YXU1aVhkVHFXUmQvNTM2NXhN?=
 =?utf-8?B?VFJYcGlXVXA2K1o2L3pRenhTT28wVXZQRTMxOFRtS290Qm5PSHcwQlFtd3ZO?=
 =?utf-8?B?ZjlacFVLcmtWbHRxR0lUU1VMTnR2TFNvOEtYclZqUzNJZk1IbXgrZnNtclcy?=
 =?utf-8?B?cVJ1Ylg1a0ZGZFI2cktONmNRRVVmZ2kxMmQxanB6aWpjQW1VWGdyczRDTy9U?=
 =?utf-8?B?V0Z4ajVDcXRueFlKUEgvak1oM3NndVlvSkttWmtYcldvNVpua2N2bG54N3lZ?=
 =?utf-8?B?YlhQdXlIc1RNRUxRY0lFNXIyRFl5dVlCZEZzOURGTVdyQmFPRmFFcEpTY0N3?=
 =?utf-8?B?T0RqdFI1VzA2YmtCd0s2a1FaV1N3bmhWUjZNdks5VUhnR1JuRDk5bkY5bzgy?=
 =?utf-8?B?QXpRQzBCSXcyTU85aThXVTJORWpCWnZqcHFZTUx0WnJrWDJMZ09xdzRZN1FH?=
 =?utf-8?B?V3ByZUxZUEw1dE50b1BuR3RMSEIzMklEWk1uaGx6QUJjbzJRNTgwQXhiZVlD?=
 =?utf-8?B?aFNBdnR1TG05K1F5MHhWeUNoSkZndzk2WU03ZGVWaU1hcXRleEJZMDRXL205?=
 =?utf-8?B?ZG0yenFzYlNMSHVZc011Vmtrd1lFck5OQUQzSFdzdHVkRFM2RmtxdUUyV2xL?=
 =?utf-8?B?Y2duMmxZMnlnYUZrUE5KeWpMQW9pall4bUVMM1BnT1N2V2l3WlUwWTJ3Vzdp?=
 =?utf-8?B?ZUhuR1diOHVyNGtCQkdMOTlLQzZjU05uMGtuWitxbUZmUnIrSUNuNU12TFJv?=
 =?utf-8?B?LzlScUo3bVhLVFpvK0hCU21sb28wOGN6dWpXbGFQcHpVdElRNEticDVZbUdx?=
 =?utf-8?B?MG1PeGhFTFByVWRuZml5MUIrdEJmQy9BczVsUDBlNDE2WnFOdnVvdVFNYTA3?=
 =?utf-8?B?NzRramQ1SzZzamNqYzFOQlVSWUV1ZU5BL3ozaFY2VlR5dHR1bVRod3k0V3Y5?=
 =?utf-8?B?ZkJPZEs4amREOC9GTDhaWTJyczR0cFJRUVl1eDJVRkdISzduTFdNZUZNVWJx?=
 =?utf-8?B?OXd5b2tsdkcydHl3c2JjemVEYmRpVU9YMzdxR0tCV042bnVYTmoxU0tsNWJG?=
 =?utf-8?B?bk9XUTRsM1dPdHpUeG45ZlZ2RlFEMWptcHZ5UFpzQ0JHRWZkN000bzFxeENz?=
 =?utf-8?B?VUg3eC9nRHFSTm5JanVyWC9iTlJ4eTBId0p6VUN3NGFFZ24xNzhJejBpR201?=
 =?utf-8?B?TXpra3o3NEFucnZKcUZscnk2RXJPN3JVTUxweGs2cWlSYnVYSlFHTlV4cGxO?=
 =?utf-8?Q?eG4AxrP1I1FYW4GOOSlyLZk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WZ7aWh/HSz+FVvsl44puUTHyegDV8CUohwnktRd3LWkhHbQ7yMSCkaj+Oe7HTR1X7HfOrtdV4iev2fwpsKr8xwawtCZ+3NKmKti5LJ0AAlg+2qVM1jODnC3iAmQbPr8boZfllfsn8e40R5tP7JWlpF8/rDipAIZ0w9/Z8F8bVXZgB3EEbzzojL9sEix8bn1Jxy4f7ZAnjr31/yM04KUwA9lxMpI55kbb49jwDSHJ3/4ZQJmqcOVG2CqyGXbBjnMlHk+JkmTPyEZaMdwMRKmMKyK2HXZuYCOZGBx7j3M71roePXHpVzqskI6tfgALFr2m/IcZtUXvS8rgdkqzoy2TqmSvsFVPpdbMhHKJBVj8FyjfelURTr8mXP1IUNyr7jfIX+DZaPlaD/U0elDEsVxoZdvaKJo8qPBLDIgXcRwYrtpA1MgCH4oF9lRfEALFo4wwEBq4bTAQ20vI1fgbhOBoD5AZeUfua7H016vg8z6zY6OuDZ7NiFrBLNZO92RUB7nHFIkOgXXqXNlq3kt7L8dYsDOoA3OYCxdN+PhB9j+cuxW0sjfHe9D4Au/5HPgtBVWW5bj+STCyDsG4hvQ/rhVatQISK/0jgMBdtCxdWWsQ9Co=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d30437ee-2612-41c9-3fb2-08dc7b0eaf38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 09:56:58.0673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpmDw6F6FoE6N13V+j45QRIXVQ9t9g/oEyXskikJ4DkkVtdVgj2hzWG9tERQ5axzSebze3vaPeP3vRwTtFVmrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_04,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230066
X-Proofpoint-GUID: BCxMjZ3jtMY2zOJ3lBoJIVhi4ByQWflL
X-Proofpoint-ORIG-GUID: BCxMjZ3jtMY2zOJ3lBoJIVhi4ByQWflL



On 5/22/24 11:45 AM, Eugenio Perez Martin wrote:
> On Mon, May 20, 2024 at 3:01 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add VIRTIO_F_IN_ORDER feature support in virtqueue_split_pop and
>> virtqueue_packed_pop.
>>
>> VirtQueueElements popped from the available/descritpor ring are added to
>> the VirtQueue's used_elems array in-order and in the same fashion as
>> they would be added the used and descriptor rings, respectively.
>>
>> This will allow us to keep track of the current order, what elements
>> have been written, as well as an element's essential data after being
>> processed.
>>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c | 17 ++++++++++++++++-
>>   1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index 893a072c9d..7456d61bc8 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
>>
>>   static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>   {
>> -    unsigned int i, head, max;
>> +    unsigned int i, head, max, prev_avail_idx;
>>       VRingMemoryRegionCaches *caches;
>>       MemoryRegionCache indirect_desc_cache;
>>       MemoryRegionCache *desc_cache;
>> @@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           goto done;
>>       }
>>
>> +    prev_avail_idx = vq->last_avail_idx;
>> +
>>       if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
>>           goto done;
>>       }
>> @@ -1630,6 +1632,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           elem->in_sg[i] = iov[out_num + i];
>>       }
>>
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
> 
> I think vq->last_avail_idx - 1 could be more clear here.
> 
> Either way,
> 
> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> 

Sure thing! Will make this change in v3.

>> +        vq->used_elems[prev_avail_idx].index = elem->index;
>> +        vq->used_elems[prev_avail_idx].len = elem->len;
>> +        vq->used_elems[prev_avail_idx].ndescs = elem->ndescs;
>> +    }
>> +
>>       vq->inuse++;
>>
>>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>> @@ -1758,6 +1766,13 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>
>>       elem->index = id;
>>       elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
>> +
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        vq->used_elems[vq->last_avail_idx].index = elem->index;
>> +        vq->used_elems[vq->last_avail_idx].len = elem->len;
>> +        vq->used_elems[vq->last_avail_idx].ndescs = elem->ndescs;
>> +    }
>> +
>>       vq->last_avail_idx += elem->ndescs;
>>       vq->inuse += elem->ndescs;
>>
>> --
>> 2.39.3
>>
> 
