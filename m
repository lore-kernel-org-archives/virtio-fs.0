Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFB01339AB
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 19:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711050538; cv=fail; b=IBjhiBYGkSmqa7kUv3h0F+i4LEHQTvSldHtxB48pNfQ9HYc4TrO+9WdjDnwDA5idnFkBvz9kId/lq/yK9s335G6JLAP8+/mD9D2LdYo2dD73Eap0/Ayz4nNdFDt18kxGM46ADA0CyD2pgq4wiAR2mpJGdq9tlQhyTD82U5Js8aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711050538; c=relaxed/simple;
	bh=fY7HNPLFvwHWfs/Met0S0cHQamS7hSLfc9HDHww3SuY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cg/3aMORdqAaXYO1lGwKkoKShvkHpToQnCoDLztVEdWwGZJi72DH/2kGkwS+ibI98a1KSVkqcPT9m5r2u5JJS4aFeS0wh0uuaRapgLhWGWWRzNzjT9/eFhJx/4t///UBlfq+i2Gs1KsjdXUghK/7wiGq9bkTDue6OmWlgPleJNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AKvuxTrL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=URwT0MAH; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AKvuxTrL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="URwT0MAH"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LJfY0j010905;
	Thu, 21 Mar 2024 19:48:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=dRBHCrmbuMZdhmvWhuvqtyZJIb16G0j6s+Aobd3fRCA=;
 b=AKvuxTrLH8cvUKz7YyrY2R3PAyUdY4mJnIyUVSKa+71Bq/BlUPmJHy8YOruUyDu2cGC0
 qPdipdLMcO+YEsVhS4Hb18ZHUNW/MBd4yTgD0d76P/KKieGIcP3DuHEcbXC0h3lEmmK5
 /0qRAejpH9ok8c3iBn0Sath2J9sdSo4KHxuPegWdzCLG8Y2HQZP6gU304Jaa6F79BB3H
 NgCqO5oeQ0+OZulYW0DsoNcsoiHrZClMFEpk77skrSW1mvtFCpCJ1rYjaQ0RQ+dez3sw
 mvi+dOElCh1RYCCTEBN/bKgYiOQzo66bI1kd4OpTULtU2nB1ggx4HsvfeoyZ26IG70F5 jQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww3aak6y6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 19:48:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LIqGFG007481;
	Thu, 21 Mar 2024 19:48:46 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1vad816-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 19:48:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4Y5CGaFTbmRF/JkqwS75QrL9wRjWGp5IBTAtDppOCL43mBv3UJrWdcsHTgcwhlSphK72jBGRmkcqaX36S1DivBLxt0QJxad8enve9Plyfwx1JZxQ5y9dFjQ3ESYWby/ldskJ4gr46ffm1oIWuxlkUifZUULC0ql+QOPDlBX79GrVmesn75eMowtVh0w2Z4Gfbw/TGiZRZTN+os94cHXv6g94Osz/IXjEnJkzHHX8DM4chutgwjY5QnBe+8kqENurJkuZZtV/jIzh5zmxSDLs46AtO8f8/Lr/YfZxprhlnCFbR1U0U+e5LFafZwpBp/Wf3GNeg7HMlzIKvjXfqUJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dRBHCrmbuMZdhmvWhuvqtyZJIb16G0j6s+Aobd3fRCA=;
 b=fQWp+Zdo+j2ccL54CKi8MXU4AUDBq4kjvcBcryj9lcOVPGeUcAm+2WSvSxkATGUmT35bEa0kvcREg/Ze8Df5vT6CigUp8g/YBezH659Z05gr152IQKR3rsn8wDmANQ5BhJWD1PrXP5l8eBJlR/vran3DpofO9zPNn5V0ko+Ov67pGNCzuH1ub+P2HMmB/7J9sUPY4/2dcees7LML8O4d4qydYRmGflatpZJ5i8J6tEVN+HeCvKAPQrIxYQQVEwB2do/T7OrwdHNTAdsNYVFQG8jv3Esva5cxzguokII4nrykk0s6PXajpCVMX+L4Tfds8dHqBfG9RQrQ/d/mVilcPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dRBHCrmbuMZdhmvWhuvqtyZJIb16G0j6s+Aobd3fRCA=;
 b=URwT0MAHFf09usox2iyoYL/02A8dLjkCtaN2U0bI+rwL0LwuYTL32oEQdoCNAEfAxrtB+MhxcFN0gzJretL9jPVXWY69lajy9xgWFbKbD8fbAN1pahxga4gRUmVsdXhgM7DvhG4d1TpHvj/Leq0B5HYaf0lxoVaqAjvlMnrBxD8=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH2PR10MB4197.namprd10.prod.outlook.com (2603:10b6:610:7d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 19:48:39 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::971e:3ef:2061:dc38]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::971e:3ef:2061:dc38%3]) with mapi id 15.20.7386.030; Thu, 21 Mar 2024
 19:48:39 +0000
Message-ID: <bd4083c3-863a-bd52-7880-2709afe73873@oracle.com>
Date: Thu, 21 Mar 2024 12:48:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Content-Language: en-US
To: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240321155717.1392787-1-jonah.palmer@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::13) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH2PR10MB4197:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d02ba3b-1e7e-420c-b78c-08dc49dfe6db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	WHDrTq7arl4Q085AJG9xQg8zITuc559S8TYWvZylxhTkDYRifUVovBTJwh0JI+NXO7RiSPdbFKEOnAirXL8CM1aiS97kztHsEEHByWgwuoZQADceC1KJbKhakXJjb+cJzD2sYZpl+Pes9+YfdRNYMPtqS+bHc37gLSyBkSHLqFVhyK1bJ+1ZJ9zsP86O1+u05aUU32oWH6o4NwZsEzNCEB2vQsMzN/S6EqPNK54aBXpaO05hrJOMq58qfXPKMNdVgp3aqwtW82+oSnHyCzmOYQpmjHHZqipOTx5Ellp2sdHsczVYju1lQVaxQvbbIrGqUYuyGnrcXhDm1gZP212DP7XxSC3ZjYW4O9wByiFzOKgQ2C415BwOGUVF6QIvHWb79eUOVS86VAZW+VuZ8fW39wJ7Jh4IiM8m0sJ0SAhZpWLArzdfK6EI+Pu+1tkx7uQDMn/CwbixibgeYXV+9Y24IxFQCBgYLZaMGZ+XQS78O8YAACiiSI1Ma6BX+ACGEehYyXxPUQPBuSW6/XtXXkek1Secmzazh1rkG2mjvcBbhGknQXgWeq8QDmUvoYlgRKSdJ7umG1ZHBn2t5mw9a1BGn+RlAR5QQEweNflaZe6CCeJWN0C0BOM4QoCvQb9YP2Xv
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?N1YrUi9JVDFHNWZ5VUJjYUZJOElUa04yMkF6STVWOU5OaWwvVWt0TDJqa3Yx?=
 =?utf-8?B?RzJTYytYRXVMK0dvVVM5Y25KL0lhTkFVL1pvSGZPYmFqSEJpd09McUlNZ0pS?=
 =?utf-8?B?dU9RbFlmZFhPUC9PMGFUeEZLOXN5c0YwZXNGNFQwQ0tsMjhuSWhOTWtmMU0v?=
 =?utf-8?B?L2YwVzBvYjhxSno5aXlqd3kwbm5jWHgyT3FLaG1pbHNpcmJROS9ueUttL0d4?=
 =?utf-8?B?UDFqekNSZkdwS0t5WDAwcFlQZkRIVGJ5OStKSER1MnJsQ1pKQitvNWEzcTkr?=
 =?utf-8?B?MEl0RFFnSW4zTGd3QlJCYzdOb3R4UWNZQ25wQXMwM0I2YVA1aWJ5dkRjVnZm?=
 =?utf-8?B?VWVWTEc1OUw3ZkxMQzFab2YxdGsvOURFbytLanRkbTFueENSOHFHWVlyS2tO?=
 =?utf-8?B?U2Jnd3dhTkloTzNuN2tER1ZBSVIrTzN4L2psQnlQajVPRWhPa0hjZDc4dzU2?=
 =?utf-8?B?cXJWVGJxZ2o0VVZzNGZVSjFuQlZtTmZrOEtRcHJXbFZCMG15Vk1SZ20xSE5r?=
 =?utf-8?B?emx4R2t3L2QyWG9yTHpreUt6cEF3dy9IUWkvSkpjSjJMVklxNVFNVTU3VkNK?=
 =?utf-8?B?bzFEdXMxZjAwai9rMGs5dGptN0N3RWtIVHhKZXFJbnhBeWhDclk4bTFtMkd1?=
 =?utf-8?B?Y001ZnV0UFJ1d01zM1NJR01tN1lzY0dXajNDLzZUUkFQaVh5THZKNkRWSWZz?=
 =?utf-8?B?bjBuOUIyVDVDVnowc2Z4WWJqS0VOMWR1N1JzaHFyNkpXaVl4TktIZlNMc3p2?=
 =?utf-8?B?aFNjbDZtSkNOVUtSbEV3Z2NRVlJORmZUTk9od3dGWWJ2U2lEUk82cFdiM3dq?=
 =?utf-8?B?cGVoUXkyQWw1YU5yaGg3eHI4N2dvekNyTmdCQ3gxc3M0NnhWcDd4L0VXVjBO?=
 =?utf-8?B?V0hRWXpkem9uN1hGazVUNlJkR00vemxlZlREaVg2Z0lhcmtQZEpTUkpmdFM3?=
 =?utf-8?B?cURTOEdvcDdTZ2lnMmpEb1ZBbXhLNFExNDJoazBraklNYVRWZE9Kek5sZkpF?=
 =?utf-8?B?b0dRdjFDWTNCT01NTWRwaUpNOUhlTGdEUkZxTjdybEcyV1VGcEdISFQ0cXlk?=
 =?utf-8?B?V0ZueEtadWo4UHVSenRtRHVTTmMwNjYzNWFUSFJwWklXWjlwdWpoZHBqcEVJ?=
 =?utf-8?B?SkJzYmR3V3RVV3RzUlRzVjcvQzV4U1JvNWhYSUJUZEtITjRHYkZVam8yS3U1?=
 =?utf-8?B?S1hSM0N2dGFxMzdDZ0ZxcGh0dm0zWjJySi9lekJMNFBCdzVpcThOYWJVNCty?=
 =?utf-8?B?WG1lUkkrakY3MklWRG9wT3dZN3V4UWtxajBYYnZyYnpodE5oWVBwalJrbVRN?=
 =?utf-8?B?ZE9YejZTZGlHSGZVZTNwWkRxdEtBUUx2T3hkNnRzcTFuUjVQS3ZOQ1BLUzdN?=
 =?utf-8?B?V2FOam9jN2FmM0pVRXI2NmVkWmwwdWtWeXh3UDR1cGRFZXN0SE5ETXpUc3Rk?=
 =?utf-8?B?aEQ3ZCtlWGZka2hRQkRQVHdZNkR5bGRBZElEcHllU09aWjFVT3RmbU14azFw?=
 =?utf-8?B?RHBsUzhKZnpWWCtReUY3OUV1UjdSamU5dWtHV0hQbVd0RFFPMWFaUmZPUm5t?=
 =?utf-8?B?dFpLSGxmdVVVYXVvSmI3TGxTZUFJZU9NN3dGb2YwS2poMXA1RnJDTDZ3eUp3?=
 =?utf-8?B?dk9ab1NVSHVua1o3bDB4RVUxa3l6cUxWTWVnWDREZUEwVFFXYkd4c1JwcUlM?=
 =?utf-8?B?OGRYVytnUWRUc2oyRFJ2QXNVQkphQnZCOW1wTzU0VWxNekdKRUpXNFZYU1d0?=
 =?utf-8?B?cVNwdTZTRmU4V1dyU0JaV3hLTjIxS0dSakYrcFgxTytqUkQ5ZzVIcW1LcTRt?=
 =?utf-8?B?anh4VzZ6WkZQN1JsSy8xTmV4eFhXczg1cFNYNXMxQXVtVUh3bE45T015Mm44?=
 =?utf-8?B?MWo4OTd3bE43eHh0WURwcFFnMlgxTHZtZmVmRm93aHRldjhnc1VOTmliTjds?=
 =?utf-8?B?WlNPN2Y3NDBXYWpTVXV0d1AreWFvZUphVGtoaEQrUFNNY2tTSW0wY0d2Q2Ft?=
 =?utf-8?B?dzdRVWloYjRTR3ROaGdpRnBscXlUMkNmZWx2SlZaUW1CTlFDT3JUeGwrQkxP?=
 =?utf-8?B?d0ZMYTNVVDAyQlcxRnhoU0NBdmhPdThqTm9ZYVhVS1hMb014MEE3ODhlMlNX?=
 =?utf-8?Q?QMFAAnPQmnP5NYQqMI6+aJKV/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	WWN9hhl6NW+fq6HAl1gq7ru6izKZr2B5iJ3QSgyJdCRBCINTUOlvc2t+5N74aqc+4GX7ID4tDCpbi5H931i3AEqgsGk3MN+R3OGkf+DeJQgwUBSZhkB1xeKVNlVZVCoYXR0hAYRWGTN5Z4g9/3jpgeaNWqiKgmo/UKuE6PfYZVr8pIK1xJigUo+6x9uRo61F2VTih6ktLv8HQ7WfXfjPU2YSavKJmZ80wpUMwN4h2sy5M2owOM9torsNCD1DJFTW/HUIUG/IlMIdFoA1pxwRroZewaJanofm2B0GxlxbZgHkcjrAEqqCgu7A8UXA/aaCwwDuX0zGovYYYF3uVGjchANkJTopTqH4IgDQERNWTbDigaJX1M6tRWaj3OkIC38L0vIAEvotfo5zLiofnSxnBXHp1D9/hZjbLMKxxaIcixjrgLOLWhQJU/SUA0NNFtX+E56/U52z8qN2b6y9HHuG6769ka52G6jm+vTAwr5gzznY7GD5w/ndvHedQ4X9JALNiR1Zce4GspiPC0ReCPNCDN2pw3jMH3edle62T8Vp0pREzeyJh9J3dC3dPsdOkBtxDjgxwVncn8+xUTxDRnUxQN9UBWnYVg9nHxKmoESb6DQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d02ba3b-1e7e-420c-b78c-08dc49dfe6db
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 19:48:38.9297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WS+6v/w4bkldgfM/DK0RCPFR4o/qlM/8LdiY+NRdYhSnwZYP7pF6zKOfaQkvo3DmAwndTGUl8Ic2uX3V3xVBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4197
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_12,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403210147
X-Proofpoint-ORIG-GUID: XrN1qzpJ2jgecoJaMYwVgJhvGJ6DF9n2
X-Proofpoint-GUID: XrN1qzpJ2jgecoJaMYwVgJhvGJ6DF9n2

Hi Jonah,

Would you mind helping explain how does VIRTIO_F_IN_ORDER improve the performance?

https://lore.kernel.org/all/20240321155717.1392787-1-jonah.palmer@oracle.com/#t

I tried to look for it from prior discussions but could not find why.

https://lore.kernel.org/all/BYAPR18MB2791DF7E6C0F61E2D8698E8FA08DA@BYAPR18MB2791.namprd18.prod.outlook.com/

Thank you very much!

Dongli Zhang

On 3/21/24 08:57, Jonah Palmer wrote:
> The goal of these patches is to add support to a variety of virtio and
> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
> indicates that all buffers are used by the device in the same order in
> which they were made available by the driver.
> 
> These patches attempt to implement a generalized, non-device-specific
> solution to support this feature.
> 
> The core feature behind this solution is a buffer mechanism in the form
> of GLib's GHashTable. The decision behind using a hash table was to
> leverage their ability for quick lookup, insertion, and removal
> operations. Given that our keys are simply numbers of an ordered
> sequence, a hash table seemed like the best choice for a buffer
> mechanism.
> 
> ---------------------
> 
> The strategy behind this implementation is as follows:
> 
> We know that buffers that are popped from the available ring and enqueued
> for further processing will always done in the same order in which they
> were made available by the driver. Given this, we can note their order
> by assigning the resulting VirtQueueElement a key. This key is a number
> in a sequence that represents the order in which they were popped from
> the available ring, relative to the other VirtQueueElements.
> 
> For example, given 3 "elements" that were popped from the available
> ring, we assign a key value to them which represents their order (elem0
> is popped first, then elem1, then lastly elem2):
> 
>      elem2   --  elem1   --  elem0   ---> Enqueue for processing
>     (key: 2)    (key: 1)    (key: 0)
> 
> Then these elements are enqueued for further processing by the host.
> 
> While most devices will return these completed elements in the same
> order in which they were enqueued, some devices may not (e.g.
> virtio-blk). To guarantee that these elements are put on the used ring
> in the same order in which they were enqueued, we can use a buffering
> mechanism that keeps track of the next expected sequence number of an
> element.
> 
> In other words, if the completed element does not have a key value that
> matches the next expected sequence number, then we know this element is
> not in-order and we must stash it away in a hash table until an order
> can be made. The element's key value is used as the key for placing it
> in the hash table.
> 
> If the completed element has a key value that matches the next expected
> sequence number, then we know this element is in-order and we can push
> it on the used ring. Then we increment the next expected sequence number
> and check if the hash table contains an element at this key location.
> 
> If so, we retrieve this element, push it to the used ring, delete the
> key-value pair from the hash table, increment the next expected sequence
> number, and check the hash table again for an element at this new key
> location. This process is repeated until we're unable to find an element
> in the hash table to continue the order.
> 
> So, for example, say the 3 elements we enqueued were completed in the
> following order: elem1, elem2, elem0. The next expected sequence number
> is 0:
> 
>     exp-seq-num = 0:
> 
>      elem1   --> elem1.key == exp-seq-num ? --> No, stash it
>     (key: 1)                                         |
>                                                      |
>                                                      v
>                                                ================
>                                                |key: 1 - elem1|
>                                                ================
>     ---------------------
>     exp-seq-num = 0:
> 
>      elem2   --> elem2.key == exp-seq-num ? --> No, stash it
>     (key: 2)                                         |
>                                                      |
>                                                      v
>                                                ================
>                                                |key: 1 - elem1|
>                                                |--------------|
>                                                |key: 2 - elem2|
>                                                ================
>     ---------------------
>     exp-seq-num = 0:
> 
>      elem0   --> elem0.key == exp-seq-num ? --> Yes, push to used ring
>     (key: 0)
> 
>     exp-seq-num = 1:
> 
>     lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>                                              remove elem from table
>                                                      |
>                                                      v
>                                                ================
>                                                |key: 2 - elem2|
>                                                ================
> 
>     exp-seq-num = 2:
> 
>     lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>                                              remove elem from table
>                                                      |
>                                                      v
>                                                ================
>                                                |   *empty*    |
>                                                ================
> 
>     exp-seq-num = 3:
> 
>     lookup(table, exp-seq-num) != NULL ? --> No, done
>     ---------------------
> 
> Jonah Palmer (8):
>   virtio: Define InOrderVQElement
>   virtio: Create/destroy/reset VirtQueue In-Order hash table
>   virtio: Define order variables
>   virtio: Implement in-order handling for virtio devices
>   virtio-net: in-order handling
>   vhost-svq: in-order handling
>   vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>   virtio: Add VIRTIO_F_IN_ORDER property definition
> 
>  hw/block/vhost-user-blk.c          |   1 +
>  hw/net/vhost_net.c                 |   2 +
>  hw/net/virtio-net.c                |   6 +-
>  hw/scsi/vhost-scsi.c               |   1 +
>  hw/scsi/vhost-user-scsi.c          |   1 +
>  hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
>  hw/virtio/vhost-user-fs.c          |   1 +
>  hw/virtio/vhost-user-vsock.c       |   1 +
>  hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
>  include/hw/virtio/virtio.h         |  20 +++++-
>  net/vhost-vdpa.c                   |   1 +
>  11 files changed, 145 insertions(+), 7 deletions(-)
> 
