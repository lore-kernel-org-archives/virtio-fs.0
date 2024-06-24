Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161EA13D2BC
	for <virtio-fs@lists.linux.dev>; Mon, 24 Jun 2024 14:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719241080; cv=fail; b=kEstJgw88PGBUrwMry09VxIddK4jel5ZEhWgQLXMdDVPm5oYoiSy/kjcNBRglO47QOTlJuI6m0T5vD5jUN5ssj+K5yGZ1YaYiEZObfDANt/wQMXDeOfLgHjgCDt169OxTAhte2bx07WESvGMiLRDUtrguZtZ97W4hUNSQ6zixqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719241080; c=relaxed/simple;
	bh=qR/47xewhHr1UHQZQtDU3uXEaVmp95Q2JzPLwiuWA5E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Pki7uxqfM7YTwe0t1WqV8IwjV9Z4Za0vOGiv6WR9zY2EPQb3WyRGm3mv/6o9eFPDXCFRf91nv6kSjd+CqSgshs4dRh6cudXzvvvwUbmheix+ESswT07JzwKCxHma7Uty2c2N+MR54LEqbpQRbZ6m4GMu+WKHKvD18A1zn1kZX2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h9F8ti3A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=T1OOBAR4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h9F8ti3A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="T1OOBAR4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OEtRqK010081;
	Mon, 24 Jun 2024 14:57:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=auxXHX7hdvTgFctWstlVD3BnP72ymlEbi3y7rJByIy4=; b=
	h9F8ti3AIdc56Mp0l/6AI/RC1kb0zlFuhDGEaJgbkGGf1MikChfeKTXLU/lUIZFH
	kkovYReHlDm71rkzQmYWgfLWcMH5IKFpf4qr1HrF3Har72RkR1Bvg0VlHFGoVO3Y
	3eSHDSnVMQ6TMcWX31/AxT3uGJPagCB7wDtTu4c/mpYmSDj75AWel1DWy9hKoYHL
	P8ipON9ytTLjqdbv42bC5lkiKEeQfSZDGL4DELlm1yBX8LtXSbc/e9Cx18ctRzgX
	Do2ENs7TkIIegBD2gnX969QePVhGOq+VGO8/wuPBWvUFT1xXrSgCYR0hk4EZkmOc
	34z8ZhvQ/8Kosaf4Hn8Iow==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ywn702w6s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 14:57:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45ODZ4r9010749;
	Mon, 24 Jun 2024 14:57:49 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ywn2cj5ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 14:57:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVx3WCMNyD5KmS0R2jzUOYNY5LP8B8Ss5EQAfNsjN8fhgxAGREpa12mDNfUVEU0aYZKmcLuAZ42YGuBOvaHpyHgqaNJ6x6IfqchYKuBq0BoeDsNhJob3lIXMHY4x1Ncgal6ziTbDezFL4mGIikVaGzCkjwIjwZc8QjOe9yqH73fQBBn31mclYY2gBwBvvgsDf8R11z3HuXfrlQUyaygDHzMqk2MVSGsaf/mtdLC4e4SXhsJCW5Fqn+xlwn/3FWwUl+QItgRlH1yDiRK92NQF4avEyVF92iEhcqXmfXKl3scLHosgubQDnUuxcw1817D5GDy/1TdDONm9kuKQGtuniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auxXHX7hdvTgFctWstlVD3BnP72ymlEbi3y7rJByIy4=;
 b=GT5iPieEvbAi+14ax35q20ISdcoOdWQtaCnl8pyaydAnCXOsilAG+wyoiR0Z7BOD4L6fTULH3K5WV0bzewhfrdkPR/iL3cMd8WS0+oZV6Bal3Wv+1Fm9MFM9nsbBpxALPZmZNM3rMMVAu/Z1Ne1s8txh+yoOnKb+ZlUY1iZeuCV/GN0rsHP5OSb1unw4zkE+cWJXu8HJyNoW7EYPYcoPsc5kD2hE96kq/e1paJ40F86ZuvGY/b5miLDjEMGMrTSSgkzlNRXgS5hE9yCk0z5FhqXakExCqj+7jEpwXJT/StcsfmBUx6JF5/oaa+6+YMirT1ACJMMiw3KJSUbDLKCl0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=auxXHX7hdvTgFctWstlVD3BnP72ymlEbi3y7rJByIy4=;
 b=T1OOBAR4QO4+5W01v9wWFhE73cZwZWcQ92RhwzghnqKWxw0LGSdT6Jpr2DzOYcswdZJeuAs2ui1ylbp0A9zH3FvCQ+VeQnK+Pjc8y87UxOCADrtulFP7/KOLi9g+ic7x0/PmY9CRzQ4CATSgSeLZx+2vQxE5KjzIFWcMpxylNSs=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by BN0PR10MB4903.namprd10.prod.outlook.com (2603:10b6:408:122::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.26; Mon, 24 Jun
 2024 14:57:45 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%7]) with mapi id 15.20.7698.025; Mon, 24 Jun 2024
 14:57:45 +0000
Message-ID: <59b17704-0d15-4963-aa7f-b469494e58cb@oracle.com>
Date: Mon, 24 Jun 2024 10:57:41 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] virtio,vhost: Add VIRTIO_F_IN_ORDER support
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240620175612.2381019-1-jonah.palmer@oracle.com>
 <CAJaqyWebry2dbn4EzfBeqadhzw25tMUFSOKLL6AsUXEFiH9gsQ@mail.gmail.com>
Content-Language: en-US
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWebry2dbn4EzfBeqadhzw25tMUFSOKLL6AsUXEFiH9gsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0077.namprd05.prod.outlook.com
 (2603:10b6:a03:332::22) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|BN0PR10MB4903:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e9d2d7c-be88-4c74-f2ea-08dc945e01a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|1800799021|7416011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?V2JPTzFFVkhxSFJHeVl1WkxRUW9RSFdIbzBrZitiK0tJclpwZnVpcURBVXho?=
 =?utf-8?B?S2JZSFB2SDBDQWo3NkRtUE56Y255YTc5V3E4MFJ1dTVWSVhoVDJ4c0FSejJF?=
 =?utf-8?B?OUMwa1VyeThTMWYxdURCN1k2N05oVnkxb1pxeitZRTFaMnlpTGpwd2V4WEt1?=
 =?utf-8?B?UEZUMlhZZHdnYUtrZkVwM3lYTW9VL0ZyakYzOU81d3RwZ1dXaUhyc0FjY2JC?=
 =?utf-8?B?dTVXamVTK1JXcWlWSy9xNmZuWUdPN0VPL1JyUTZ4RlRhMHM1S0JXbHJZbytX?=
 =?utf-8?B?MjVTcm5RVUhEbkVRbnV4SXorZHVyMnlzdkpvQkI5WDdoNjVqSVBjaVAwM2Mz?=
 =?utf-8?B?anA3UStEM1diZm5tdTRrT2RhTm90eTVwRjJlbElORVE1UG5lcVBkZlhoZnpx?=
 =?utf-8?B?Zm9nVStvNHZncXVjL016L2FTcU1KU2NUOWhISWJnd0RRSjd3YWF2b0FPMnBE?=
 =?utf-8?B?NklFVzl6NUtOeW1hRDE3dUMxRWY1WnNzRHN5TDFUVjBlRGtUMnN6ZFRHNFZh?=
 =?utf-8?B?Tk4wZTkzM0VCN1pHYmVyVmd0a3g1NEcrK2FYVENuaWhuV0xiZnJ2QkxPTXFa?=
 =?utf-8?B?eWJuRVF3Z2JtZE5adTVYWkluVmhaelRmUW9oMldYUnFnNWF0bDFwTG40UmtD?=
 =?utf-8?B?c3NJK2c5b05URzlhSVR5cnJpRkw4ZU5lUnVDaVlSWXZjV3ptYkdET05rK0JH?=
 =?utf-8?B?emQwcVlqSUdKZHhzYkR4bWNZWHhRYUlNbmgrc3AxL2daeXA1dzlLSnZXSXpC?=
 =?utf-8?B?WklHM2RrVmMwNk9xWUNUbk1icE1IYTFVWk1UUVJ6TXpQLzV2b1p5bk56cWZS?=
 =?utf-8?B?UEJsbTZWWnFkazBHM1ZxeS9Kc3Nscm1DK1h3Q2FTZzNYR1U5NEV3Z3hEVW94?=
 =?utf-8?B?QXdJMHN1LzNHUG1xTFdsa3hFZHZWbEhMYmRSUmlFRUxGV1N0dkxyOCtYWUg1?=
 =?utf-8?B?bHN5bGY4b2oway94WHZiU3YxNGQwTjNtbUgzdVplUnhORzJWZ1lYcGdtbXMr?=
 =?utf-8?B?RzVYWUc5ZERDeVp4Y29IaFY4TVBaRTdMNVI0VU9tbzVkOFZncGNDK3duZ3hT?=
 =?utf-8?B?NDlCZkI1UWU2ZnNobkd2Snlud2E3OXlMYm5EMklaaXVDbG5ad1l5cGFuczBu?=
 =?utf-8?B?SnZQdnIrckVuMEQ5VTNueUVSVmw5dVYyVGd5Z2NhMm5ES3JqTldUWTZJZUVi?=
 =?utf-8?B?T1JZby9Kd3ZvN3ZpWUJlVTBFcy9LUVJJR2xsc0F3NE4yQ1N4RUhwV0dNSG1Y?=
 =?utf-8?B?MWJIWDgrSG1wWDZmOXordzNDWEVoNmdqWTFPbUxkNGdXWThldllMb0V5aDdn?=
 =?utf-8?B?alBYdm8zSW9YNUdseUVpS0JNZjlZOVliZ2EwSE9xeW1XYjV0OE5leXc2NXUy?=
 =?utf-8?B?aUwyblBNRHQ4L3h3K3V5RmZ2N2FHVEhRMkNyYXhMRFMwMGIvS1ArQ0xyMmRI?=
 =?utf-8?B?UFdzdm8rM2ZjM3h6dGVxd0RiN0YrWUlldHVEU0FVcmtKOGNBT0haNTR5SGRW?=
 =?utf-8?B?V25ZM01HM1F5Qmk4dW4yeDdGU2haYWcvamFSazkvVVRLQ3c2dmZHaGpaQWxD?=
 =?utf-8?B?Y1RqM3ZvSXh0VGZtenNFQjREdTJLblRaMXJWSVA2VFR0REJUbC9uWE1ycldN?=
 =?utf-8?B?MWZQNllzdW5udS9vRnFKRit2TWdsaysvdGlUaEY3MjFDb2Z5UTlncUFLS1Ni?=
 =?utf-8?B?a3MyeGFGN2J4emt3NU9YclhtTXBNdm9jdGpHSmNzVXhCWjFKYUtiUGNSOFJZ?=
 =?utf-8?Q?jyWiOt95CxmWZKdQZDZv5czOPheS8NtjQdYgl8z?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(7416011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QUdEYUpmNHV0QndPdDJkbmx5aXAzVUdvdnNpRERucGNYbmVkSy9lc2kyYnZo?=
 =?utf-8?B?L2trMXVXeS9oWkVQcVBXdFZGc3h4b1UvY1JqSFE0YlpOMmErNWJ6UDRrd2RC?=
 =?utf-8?B?SytaRE1kVUdzbzl6eXg2L1Y3aUZFL3ZjY3pMYU10YUphN3E5dVpCV0JFQm1i?=
 =?utf-8?B?SEZzSW1JbFVnTjV1eC9hWnJzWTc2aTVLOTJJSUJoQVV1SXFza0dUbmxhMGZP?=
 =?utf-8?B?V2FkY1JnYzhGbjRVaDRoTHVhQkV3NUpwdHVGQmxuR05xUXVFaXEyVVpxVHZr?=
 =?utf-8?B?RDRTb1o1bGFSZ3RrS3lmeE1RNEw1VHhEbzlOcTllTlAyZW4rWlcwaXdYQ2J2?=
 =?utf-8?B?a1huNTcvbXczaUU0MzU3RVhrb1ExMG5pWUh2aEtnYkVzR2k1cHY3MmJSRFls?=
 =?utf-8?B?NXVIRXJHWmtSTzdzMXRCOVBxZmdEalpQMGZIalhRWGI2Sk5WR3NJYnRkMEg5?=
 =?utf-8?B?b0tkWkE5ZFdCY2dvVlB1ZThETnczN1FacGNnMWxyS0ZJeCs3MEVDU1dDNHJP?=
 =?utf-8?B?Q1V5MzBjbk5EcHpMSVRoN1NDdGZHTncxNDdzNHlmUXEzQ2UxelZrYlcvWDRa?=
 =?utf-8?B?VTJzZS9tc1NNdXFRa0ZEdTIwVUFLUFpLR21ad2RQcVdxbjg3aGJNV2Fpb3Vw?=
 =?utf-8?B?ak5iRUFWNGlaTktiUnlVbC9CME9lRHA2TXU1cmtpN2txUGFlWFhoYkxSNmRy?=
 =?utf-8?B?MHk1VXZJNG1tcVh5R2F1aWQxWmNYRnBTQlhyUVJ1MHRMVHM5WDNSMmVwSnR4?=
 =?utf-8?B?VFlzTTQwOFZudWIyUS9ob2RaRTM1bk5KK25kbFBnSEl0UklOTVlpUlJMNVky?=
 =?utf-8?B?bmZsQW9yd0R1dnNGTjMyS21hcnlYaEI3R1pQM0Y2SkdlK1RqaHJnRW1pMUUz?=
 =?utf-8?B?UVNhbi96dUdNdHVZcE9BeHNidm1YNXpBN3FDRWpNUXlVb3J6blEvbWoxVnpx?=
 =?utf-8?B?VTZjTkE3QWk3V2lZM3dsWGUxV0Z3eXpuSkEyUzc1K3NxdjRwWWJuNGFKWHh6?=
 =?utf-8?B?UW91TWZLcnRrS2tXbWpFZ3NUTUx2Vktpck5FVXpTcTBmZnFvT0d5OGFZWCtF?=
 =?utf-8?B?Zk1QQVRZTTNQbWJvTWpObjdaOWpHZ3ZRRG03eGZzSVhiK2VwQ2tqNzBPQ3VC?=
 =?utf-8?B?VVdRalBBOHdoQzdBRnVsUXhMZGw0dnRNWVQ5UXFYdEx0LzBmUUl3eUNZc28v?=
 =?utf-8?B?OFJWWjlKN29qUzB0ZE5vbjYrTHRrK0tiS1RaeXUzbUtIdytxUG1mQzB6b0Nk?=
 =?utf-8?B?WHJUamNKZGJkVFpCWVBYZDRTSkFmWWdlRC9BMHB3S3dNdkNHRHNLYW4zSHdr?=
 =?utf-8?B?cnhrQ005c3liVmRCQWN1MDE5Y2U3dnp4RFFueUJVRVdEWGJjMHdtNHpUUld1?=
 =?utf-8?B?VUNuVGYwM1E5TGgrMWRMRFJNZmJmcU5QY1h5RU1sZlUyNHFUYWxld0drY2ZW?=
 =?utf-8?B?RmtTRStKZUwzNmdEc3c5VFp2SVdFZk1FUnI3ay9kVzNzOVJnSlUxaG00T29y?=
 =?utf-8?B?eklXWTFVSlZiT2FBelRPV3RaNFBPd2ppRUVzaU5mbkUvUkkwcTJFaWVtOENZ?=
 =?utf-8?B?emlhOVRJRy9SNlBjTmYrbnNsUEV4MkVxTWozNnBYTDZ2ZFlHNVRva0JxYmw5?=
 =?utf-8?B?YXcwMGovZThXcmkwSDJ4aEhtNjl6VWU1SUdQZHh5OXMzV0s1bUV1bXVvL1hS?=
 =?utf-8?B?L2JTNXlMMWUwL0RtNytlcjM2RUZLQkNwcjZBam5Nb0lwWTRCRGdLZFF2NHho?=
 =?utf-8?B?UzRoV1k0ek9MNFhZRDhPTkNCbTJBbnNUa2lMcmdzaHNMV3FkR3ZKYlpvRXl4?=
 =?utf-8?B?NEtRcFpENklQRU4wOFlmUG9URzFDcWpnY1JsSGdsbkQ5SWRxK2QxUnpaOUtu?=
 =?utf-8?B?TFpwcXlHNkxiOWJBS1VKdi9uYklUNzVKaDBrMnFjUUdJbUdjYVpsb1dsNGJ0?=
 =?utf-8?B?T21NclJVM0dST3lQdTZJS0dwcWJuSVM5L01lREwrWEZFZ1oxbmpONUQ2WHoy?=
 =?utf-8?B?Zkd4RjgrY0dDS2FKTHM1V3FUS2hvbXdWQlVVVCtRNStTcjhtQVNZdFh5MmFS?=
 =?utf-8?B?Mis1M0NUZGJnYUxraTllU29RYVdnSFdpbnVxNFIxWnpZUk9zMVZpY2hUU1J4?=
 =?utf-8?B?NFdZbVdEUVBBOVpucEI1REF6YjdMUGE0NC8wZ3JhcjBiY25TZzFwRlJqWFBI?=
 =?utf-8?Q?nx0ixuQndAjjaaDThzTXcjo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	KLld0UJPt8inNdgga/d+7Gvs9E+YGofSXVXMFSJ+59NZfnzzjnhe33k7NbrtD902L5LDBpjbbZxLZKeTOPed4vkUA97Aka2GOoiCAxUMlK3kqPTLu4dU4EHdDtC1cWk9sjMWuc/gWPv7ImqyVVXJDDQUk5OBDzeUhawp9Q19l9Gpp8z4U4G/pnmAatm2BHPi6MRgKS6pAxJ0hPwl6F18p1XLFaGcHE83vcsaoJGNhwo13ErdvUhEvZjGI0Z+QZ/I2fm8/0pRmPIHyHNRJ2+Y4LD8lg2zbK14QKEdyXIGLO/mcLYY2LbB3wCzw1M5+rWQR/AapivIB9CBfMCe+9gb9qIzLpDsmYIUwhrxvCu0wEI+JBPNIF68f7ClhgwXPmz+R4NrUmi68k+Vmh4r29bHHdjFY9AoXIXALjfj52ieTCU2fjKVdTlAcytc5lz2Ic8nxzLaYDib0ujKF1kJDkbNpbX9e4ucFTmpMyT/HKztiqtzuVaiPyKWbn0kKJ7890EtLOlogS2dC1aYcZk4QKby3Dng/aANEufmEQ8AFeP/OL1UKRd17htvSBMXI8/MM1OYDcSck4M1Ffp/JtbDNFT8+fsl9LQ4GPg68v1Yr5xrQac=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9d2d7c-be88-4c74-f2ea-08dc945e01a9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2024 14:57:45.6511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sj8Gnqqd2Yw2kmGikGaz2x4wDouYGzBoOM5Le63lfYXpeSFkbFIvR6YQS+dStkX+u4BaXEOO44jXTtZ2AWSe+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4903
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-24_11,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2406240120
X-Proofpoint-ORIG-GUID: C__pRoWx3LiZBUxbv8c3f8XhbSgk_Tgd
X-Proofpoint-GUID: C__pRoWx3LiZBUxbv8c3f8XhbSgk_Tgd



On 6/20/24 2:40 PM, Eugenio Perez Martin wrote:
> On Thu, Jun 20, 2024 at 7:56 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> The goal of these patches is to add support to a variety of virtio and
>> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
>> indicates that all buffers are used by the device in the same order in
>> which they were made available by the driver.
>>
>> These patches attempt to implement a generalized, non-device-specific
>> solution to support this feature.
>>
>> The core feature behind this solution is a buffer mechanism in the form
>> of a VirtQueue's used_elems VirtQueueElement array. This allows devices
>> who always use buffers in-order by default to have a minimal overhead
>> impact. Devices that may not always use buffers in-order likely will
>> experience a performance hit. How large that performance hit is will
>> depend on how frequently elements are completed out-of-order.
>>
>> A VirtQueue whose device uses this feature will use its used_elems
>> VirtQueueElement array to hold used VirtQueueElements. The index that
>> used elements are placed in used_elems is the same index on the
>> used/descriptor ring that would satisfy the in-order requirement. In
>> other words, used elements are placed in their in-order locations on
>> used_elems and are only written to the used/descriptor ring once the
>> elements on used_elems are able to continue their expected order.
>>
>> To differentiate between a "used" and "unused" element on the used_elems
>> array (a "used" element being an element that has returned from
>> processing and an "unused" element being an element that has not yet
>> been processed), we added a boolean 'in_order_filled' member to the
>> VirtQueueElement struct. This flag is set to true when the element comes
>> back from processing (virtqueue_ordered_fill) and then set back to false
>> once it's been written to the used/descriptor ring
>> (virtqueue_ordered_flush).
>>
>> Testing:
>> ========
>> Testing was done using the dpdk-testpmd application on both the host and
>> guest using the following configurations. Traffic was generated between
>> the host and guest after running 'start tx_first' on both the host and
>> guest dpdk-testpmd applications. Results are below after traffic was
>> generated for several seconds.
>>
>> Relevant Qemu args:
>> -------------------
>> -chardev socket,id=char1,path=/tmp/vhost-user1,server=off
>> -chardev socket,id=char2,path=/tmp/vhost-user2,server=off
>> -netdev type=vhost-user,id=net1,chardev=char1,vhostforce=on,queues=1
>> -netdev type=vhost-user,id=net2,chardev=char2,vhostforce=on,queues=1
>> -device virtio-net-pci,in_order=true,packed=true,netdev=net1,
>>          mac=56:48:4f:53:54:00,mq=on,vectors=4,rx_queue_size=256
>> -device virtio-net-pci,in_order=true,packed=true,netdev=net2,
>>          mac=56:48:4f:53:54:01,mq=on,vectors=4,rx_queue_size=256
>>
> 
> Hi Jonah,
> 
> These tests are great, but others should also be performed. In
> particular, QEMU should run ok with "tap" netdev with vhost=off
> instead of vhost-user:
> 
> -netdev type=tap,id=net1,vhost=off
> -netdev type=tap,id=net2,vhost=off
> 
> This way, packets are going through the modified code. With this
> configuration, QEMU is the one forwarding the packets so testpmd is
> not needed in the host. It's still needed in the guest as linux guest
> driver does not support in_order. The guest kernel cmdline and testpmd
> cmdline should require no changes from the configuration you describe
> here.
> 

Oof... I didn't even realize that my tests weren't actually testing all 
of the modified code. I was so focused on getting DPDK to work that I 
didn't think to check that. My apologies.

I am running into some trouble though trying to get packets flowing in 
the guest. My Qemu args look like this:

# Regular virtio-net device
-device virtio-net-pci,netdev=net0,disable-legacy=off,disable-modern=off
-netdev tap,id=net0,vhost=off,ifname=tap0,script=${QEMU_IFUP},
  downscript=no
# Virtio-net devices for testing
-netdev type=tap,id=net1,vhost=off,ifname=tap1,script=no,downscript=no
-netdev type=tap,id=net2,vhost=off,ifname=tap2,script=no,downscript=no
-device virtio-net-pci,in_order=true,packed=true,netdev=net1,
  mac=56:48:4f:53:54:00,mq=on,vectors=4,rx_queue_size=256
-device virtio-net-pci,in_order=true,packed=true,netdev=net2,
  mac=56:48:4f:53:54:01,mq=on,vectors=4,rx_queue_size=256

In the guest I have the virtio-net devices I'm using for testing bound 
to the uio_pci_generic driver:

dpdk-devbind.py --status net

Network devices using DPDK-compatible driver
============================================
0000:00:02.0 'Virtio network device 1000' drv=uio_pci_generic 
unused=virtio_pci,vfio-pci
0000:00:03.0 'Virtio network device 1000' drv=uio_pci_generic 
unused=virtio_pci,vfio-pci

Network devices using kernel driver
===================================
0000:00:04.0 'Virtio network device 1000' if=enp0s4
drv=virtio-pci unused=virtio_pci,vfio-pci,uio_pci_generic *Active*

But then after running the dpdk-testpmd command in the guest:

dpdk-testpmd -l 0,1 -a 0000:00:02.0 -a 0000:00:03.0 --
   --portmask=3 --rxq=1 --txq=1 --nb-cores=1 --forward-mode=io -i

EAL: Detected CPU lcores: 6
EAL: Detected NUMA nodes: 1
EAL: Detected static linkage of DPDK
EAL: Multi-process socket /var/run/dpdk/rte/mp_socket
EAL: Selected IOVA mode 'PA'
EAL: VFIO support initialized
EAL: Probe PCI driver: net_virtio (1af4:1000) device: 0000:00:02.0 
(socket -1)
EAL: Probe PCI driver: net_virtio (1af4:1000) device: 0000:00:03.0 
(socket -1)
TELEMETRY: No legacy callbacks, legacy socket not created
Set io packet forwarding mode
Interactive-mode selected
Warning: NUMA should be configured manually by using --port-numa-config 
and --ring-numa-config parameters along with --numa.
testpmd: create a new mbuf pool <mb_pool_0>: n=155456, size=2176, socket=0
testpmd: preferred mempool ops selected: ring_mp_mc
Configuring Port 0 (socket 0)
Port 0: 56:48:4F:53:54:00
Configuring Port 1 (socket 0)
Port 1: 56:48:4F:53:54:01
Checking link statuses...
Done

I'm not able to see any packets flowing after starting packet forwarding 
and running 'show port stats all':

testpmd> start
io packet forwarding - ports=2 - cores=1 - streams=2 - NUMA support 
enabled, MP allocation mode: native
Logical Core 1 (socket 0) forwards packets on 2 streams:
   RX P=0/Q=0 (socket 0) -> TX P=1/Q=0 (socket 0) peer=02:00:00:00:00:01
   RX P=1/Q=0 (socket 0) -> TX P=0/Q=0 (socket 0) peer=02:00:00:00:00:00

   io packet forwarding packets/burst=32
   nb forwarding cores=1 - nb forwarding ports=2
   port 0: RX queue number: 1 Tx queue number: 1
     Rx offloads=0x0 Tx offloads=0x0
     RX queue: 0
       RX desc=0 - RX free threshold=0
       RX threshold registers: pthresh=0 hthresh=0  wthresh=0
       RX Offloads=0x0
     TX queue: 0
       TX desc=0 - TX free threshold=0
       TX threshold registers: pthresh=0 hthresh=0  wthresh=0
       TX offloads=0x0 - TX RS bit threshold=0
   port 1: RX queue number: 1 Tx queue number: 1
     Rx offloads=0x0 Tx offloads=0x0
     RX queue: 0
       RX desc=0 - RX free threshold=0
       RX threshold registers: pthresh=0 hthresh=0  wthresh=0
       RX Offloads=0x0
     TX queue: 0
       TX desc=0 - TX free threshold=0
       TX threshold registers: pthresh=0 hthresh=0  wthresh=0
       TX offloads=0x0 - TX RS bit threshold=0
testpmd>
testpmd> show port stats all

   ###### NIC statistics for port 0  ######
   RX-packets: 0          RX-missed: 0          RX-bytes:  0
   RX-errors: 0
   RX-nombuf:  0
   TX-packets: 0          TX-errors: 0          TX-bytes:  0

   Throughput (since last show)
   Rx-pps:            0          Rx-bps:            0
   Tx-pps:            0          Tx-bps:            0
   #########################################################

   ###### NIC statistics for port 1  ######
   RX-packets: 0          RX-missed: 0          RX-bytes:  0
   RX-errors: 0
   RX-nombuf:  0
   TX-packets: 0          TX-errors: 0          TX-bytes:  0

   Throughput (since last show)
   Rx-pps:            0          Rx-bps:            0
   Tx-pps:            0          Tx-bps:            0
   #########################################################

I'm still working on improving my networking skills so I'm going to try 
and figure out what's going on here. Will let you know if I figure it 
out and check in with you to see if the test results are satisfactory 
before sending out a v4.

> And then try with in_order=true,packed=false and
> in_order=true,packed=off in corresponding virtio-net-pci.
> 
> Performance comparison between in_order=true and in_order=false is
> also interesting but we're not batching so I don't think we will get
> an extreme improvement.
> 
> Does the plan work for you?
> 
> Thanks!
> 
>> Host dpdk-testpmd command:
>> --------------------------
>> dpdk-testpmd -l 0,2,3,4,5 --socket-mem=1024 -n 4
>>      --vdev 'net_vhost0,iface=/tmp/vhost-user1'
>>      --vdev 'net_vhost1,iface=/tmp/vhost-user2' --
>>      --portmask=f -i --rxq=1 --txq=1 --nb-cores=4 --forward-mode=io
>>
>> Guest dpdk-testpmd command:
>> ---------------------------
>> dpdk-testpmd -l 0,1 -a 0000:00:02.0 -a 0000:00:03.0 -- --portmask=3
>>      --rxq=1 --txq=1 --nb-cores=1 --forward-mode=io -i
>>
>> Results:
>> --------
>> +++++++++++++++ Accumulated forward statistics for all ports+++++++++++++++
>> RX-packets: 79067488       RX-dropped: 0             RX-total: 79067488
>> TX-packets: 79067552       TX-dropped: 0             TX-total: 79067552
>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>
>> ---
>> v3: Drop Tested-by tags until patches are re-tested.
>>      Replace 'prev_avail_idx' with 'vq->last_avail_idx - 1' in
>>      virtqueue_split_pop.
>>      Remove redundant '+vq->vring.num' in 'max_steps' calculation in
>>      virtqueue_ordered_fill.
>>      Add test results to CV.
>>
>> v2: Make 'in_order_filled' more descriptive.
>>      Change 'j' to more descriptive var name in virtqueue_split_pop.
>>      Use more definitive search conditional in virtqueue_ordered_fill.
>>      Avoid code duplication in virtqueue_ordered_flush.
>>
>> v1: Move series from RFC to PATCH for submission.
>>
>> Jonah Palmer (6):
>>    virtio: Add bool to VirtQueueElement
>>    virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
>>    virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER support
>>    virtio: virtqueue_ordered_flush - VIRTIO_F_IN_ORDER support
>>    vhost,vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>>    virtio: Add VIRTIO_F_IN_ORDER property definition
>>
>>   hw/block/vhost-user-blk.c    |   1 +
>>   hw/net/vhost_net.c           |   2 +
>>   hw/scsi/vhost-scsi.c         |   1 +
>>   hw/scsi/vhost-user-scsi.c    |   1 +
>>   hw/virtio/vhost-user-fs.c    |   1 +
>>   hw/virtio/vhost-user-vsock.c |   1 +
>>   hw/virtio/virtio.c           | 123 ++++++++++++++++++++++++++++++++++-
>>   include/hw/virtio/virtio.h   |   6 +-
>>   net/vhost-vdpa.c             |   1 +
>>   9 files changed, 134 insertions(+), 3 deletions(-)
>>
>> --
>> 2.43.0
>>
> 
