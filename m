Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336EE21340
	for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 10:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715338336; cv=fail; b=kcX3njR3HmEtN7/LYzZuY3bE87wc2sr71O7GMoZlFb+wWI7U/gXKC9bEP2Ky2qIAHyDOL6WYg4L4WctbINbNe8zl8Wop7sA4d3Jv6taHnHS7TxQp7RMv3azr89MRiBeORPKe9F5TgMXupMhC3z/4RKLKRRRxpBv02RwpSEZIvmo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715338336; c=relaxed/simple;
	bh=SVnCbYvs8Eszp9clyJRKVwuBb61qQZ4y9T2RdzID0i4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dKhw5TPo7wZJXk8EGJv2JbXXSNWkl/mlyt+KcQ0urCAjtiRvm50+6FszcUAooR/QQDpCcSj6LyqmGkS20BagzTJ6DgM2bGhMuPWFr87JR/gdcQ293TTB13J2DRTvNzBUvaJ8Zn1eiBi+/7pqkP01INM1a/If/lwFVTHXz6t725U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ROTo86d8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mT9up7H7; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ROTo86d8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mT9up7H7"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44AAptbP015481;
	Fri, 10 May 2024 10:52:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yx6oEqXl6er2/LYOA2kXQLQt4lTkkcUgEtcTnFrBeMU=;
 b=ROTo86d8DbYviYmMa5q19dGE0Y7/Lfv3Hi9otGo80BCcufP4RTydhmFxTwOsC0O3b+j3
 vE87TcRxln/tNWUMS9LUBSQ+zNEZ1UeLdP7GNfE6z6dPLNKo2oFxwevK5mLV98nd2Ejs
 nYBN1Tn82U4pEG9k0ycqT1l3Zckga5nyJTTkcHK4c/wVgctyUz8nqZHqb7CuTtVcfOrI
 ocJw1/BQQKcG7DFgFzV1ZaYnA61hmphbQaV4AEnjEa5fi0zUW96z4MmjMOG8O3mbt7Lr
 f92b2KO7d/vfYiOXWxRfyu344vehc2w+z2maUh11yGSK/Z7SkOffJp/ZSIy8YZDOUPwZ vg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y1a0j8qc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 10:52:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44A9vAhD020144;
	Fri, 10 May 2024 10:52:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfpqvcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 10:52:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJ/my/78F3jELS9NyNHYYNopA8OKPgGMNDS3b2SYZxEf0HGdasPF9Ib2pdJ3pHJsu5p/tO4m2BUAbVEZWi2CokKmA/jwlSIEV/s19qohTHb3lte3IF7FFq4JTuVitXuDcfUXZsgUNxAyn6qyxbt6DxIJwhW3NL6rI1FU/zjX2j423NJzUA9LvbRHK8c5oC9szBVKVueTOoXmEuCRgCCi3lSu1JLgBfONhQo2t+Hl7r9muW0tq2N2ZAAPFBv+7QMJb/9Sk1QQb3WnfEjd3JaHloMh1qWJ4aq0fiMaVKSAT0teGcFtC8CsUU3zTwEV7QQJDdH2j98AZa06tRHHqzUcKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yx6oEqXl6er2/LYOA2kXQLQt4lTkkcUgEtcTnFrBeMU=;
 b=YFq0oUJWG/qch8Y61Xdl0JERbDXEQpKcoCO5WDGeCWDyXNIWji3GLuybmPKSjNTaloEfj8jg/mVczUHQJsFx9rZMsKrIfVWfaIKS4CVXrCb1dh9FEapdXdabZ9alX1RLlq85A6Q63STC1VzvMMBJ+9domO0d27Fikht6cfIAxUgHHtexzR/M4zYe6GUniCRvYoBLGZ28pZPz+wPZ4CneD5yqsDLd/NH1lUHy5UZuTfHsdX/ewgy+VI9AYJI1IA/mA6eD3w8NvdjykbtnGMw26SLctKAPG78NSOdGXhWTKOYMT+XClScFcGRRmeAEeRrYkflsEWANWLM7wtMJLyG6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yx6oEqXl6er2/LYOA2kXQLQt4lTkkcUgEtcTnFrBeMU=;
 b=mT9up7H7clsiVlsvLQpT4Xc1vtwPC4Cv8dCn9WRFamVJgKeU1ZrwNV2iZOceEzuuK04POC8xh0kI/nmwyymYA7eoT302guLDfE9AP+/Unc8gO5//NAUGLlBGp5UvmDSYZief4mKgIG+HkpOQNBgdd8ef8YqMq2nxaxCnqYeSiJk=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.52; Fri, 10 May
 2024 10:52:07 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 10:52:07 +0000
Message-ID: <b4e9c0f8-659c-486a-9d51-70f5909dcbe9@oracle.com>
Date: Fri, 10 May 2024 06:52:03 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] virtio: virtqueue_pop - VIRTIO_F_IN_ORDER support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
 <20240506150428.1203387-3-jonah.palmer@oracle.com>
 <CAJaqyWeASizkBEmef4Yo7Mv0hF2zKe2p627G4ZEgVG0kMkCCOg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWeASizkBEmef4Yo7Mv0hF2zKe2p627G4ZEgVG0kMkCCOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:208:32a::31) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: fbad93cb-8ce1-48d5-0b7e-08dc70df3c2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?WGRWWlNGOC9GUEtJK1Jaemk4RURGaUN3N0E5NUs5YXNpQkdXei9zMzM1b1F5?=
 =?utf-8?B?M3VaRVl1TGNRNEhGOHBIbFEzMk04TEdjelRoc1RLa2xOOVJiS0dOWXVKbDlm?=
 =?utf-8?B?Q2FoS28wOFY2OUZJRkxLRjk1M0dPZk0reVFzTFNjTWtVZ3h3WXB0SEhJc2xJ?=
 =?utf-8?B?TFJGTFdXbDA0SGRGU2pVTHVJVXFMTHBncUxxYVlmdXd1SHJiaFdtSlYySnhW?=
 =?utf-8?B?c1Q4WE1OYXAzOWliT3djN1NFRmhqZDBGYTRHamNrZGFvTnhXdEtLN1FObWlV?=
 =?utf-8?B?UlBRZVYwcUphem5MR1VmdldQbDJQWUExNmNlZTNLd3F2V0RXTWpITlVaVUZx?=
 =?utf-8?B?TkpTc1I3ZGlQZEl6Y3Izalc1MU9OdzB1d0Zpd1lKSjdTb2RUQ2NMc0ppaFc0?=
 =?utf-8?B?RU5ZWnd3Z29BK0hZeGt5QzBNSnVxT1pSV201c0dCdGVwaGxRYUFGbWJJS2gr?=
 =?utf-8?B?ejN1bTlYQ2JJbEFsTVRvRXpLeGQ5S1JoY01QeTNTZ1J6QlJGY29DU0I1Yi9I?=
 =?utf-8?B?SVV6NElvUE01WVdPeUVPMHZOVWdFS1dFMnE3aHNleVRXRVpMMGJVTmI5ZXhX?=
 =?utf-8?B?Y04xeGorcWFSRlVxby9sa011RTZieXNoaUF4S3dRWTdDMXhac1FBN1JUMVM2?=
 =?utf-8?B?dmlzUGtOMXFsTGZhUzRWTXNDWE9tTG5YYUlwamp5akREV3BnQTVvMzk4QmMy?=
 =?utf-8?B?c2pHRE1WMDEvU1NKaTVJa3JwMlJ4TldpOEQvejk3VDNwSEdtUkpMQ3dlK25P?=
 =?utf-8?B?MnNUU1BLVUJLOURHTFp3NXJSdUN5N1BwcWY1MDZIZHRnR3U1UFA2Q2JCR21O?=
 =?utf-8?B?NlJPay8vYkdxYURkMXNNdVAyU3g0T1lzMFdKdjkxZnY0cjVBaHhVSU1sSW9q?=
 =?utf-8?B?ZVUwYnZDdWZmY1lsUjA0VGg5VFZQMmV4a2FZdzcyLzNFQUQ4TmVBZlo1RXBN?=
 =?utf-8?B?UW9VSUxpS211ejBpOHVZU3V6bkQrOFZzR1Z2L2dJaFk2T3FtN2VhQTg0VXRF?=
 =?utf-8?B?UnM5VWVkOGRWSVo3ZHlVbkFQSElCZ0pId0Y3bjQ2R0JqNGxDTVJMSnh6V0Zu?=
 =?utf-8?B?R0VneWErTnlVOHpPZ1crRnZ1Y1UzVGtIVHNORVl6UTlENFVpb3JYZ1EyU0dt?=
 =?utf-8?B?Q0xkcW1LQlBoOU93SGVsdmZ5UU85TEhoTVJwMVNlTWJtZmNpbDVKcjROdnBU?=
 =?utf-8?B?alZaOU1XNXM0NVN5bmZ3dDVGZDFqRVkzWUJJcXljeEZxeEJUaGxjbytkS2JQ?=
 =?utf-8?B?bjdKaGNUanAzdnZ5clVBT1JzVDVYOHdEVWlsV3M2R0VtYjJrNUtIQkJjSFZT?=
 =?utf-8?B?WEpxaTk0aUtZdzRvMjV6cmV0LzNsbTl1MW11QUVXRDI5RUViaE1CeC9HdEpF?=
 =?utf-8?B?dWhDQTRmb0I0VUorUURGN2czY0hVL0FRUy9sRUcrLzR0eHRldjkxbktiTk5j?=
 =?utf-8?B?dTVjTUxUZnJJWnlDUThTZ1pjRG1OdFArdThOMGFReGErditjOVR0Yk9wSHk0?=
 =?utf-8?B?WjB1cUlrTXZSanN4dldueloyWG03VzMvTnhEcWtQekFGQjV6b1hRRlM5NTZj?=
 =?utf-8?B?NFFMaTlSazhycmpacFpXbkM0Tm5mTnd0b1hsdkJRbDJtQjkrNGpHVFpNdzR1?=
 =?utf-8?B?MmpwclNVOUZiZGs1MjVzRHhyY2ZuYXRVc2IzSHVoVkxzNnhIM24rdHpsbjcr?=
 =?utf-8?B?d1RxZW1WN3NnZXY1ZU9pQ3haRVkrMGpra2ErNC9xTWtlQXJGOTBRZEpBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmllRThlT2JaT3B1Z1RLWXUwcWRIczRZcG93MzZMd3ErZWhscHd2N1RLVnJs?=
 =?utf-8?B?VytGWkI1Q3RFQjB4Wkh3ekVreHQvY3ZmcTAxc3c0QUVYNEpvdk5XcjJENTFz?=
 =?utf-8?B?VjBvVE9CMXJZeHN0dFZWSVcxL2dIbUEzRk45N2ZWbEo3cmFKay9BSHlBUjNI?=
 =?utf-8?B?NDh5NlRjNFhUNHVQaTE2UzhIWHZWM0NQaEUzaGI0ZDR0VHp6c0RERmJFYUl1?=
 =?utf-8?B?WVkvN0cwRmhjNTZJOVVqSFJKalNFb0tYNEFTOXQ3K0ZuMk4wZFF0SmJRQ2FO?=
 =?utf-8?B?Z0Y0SWdmOUt1T25lUG9wdzMvSjhKbHVLOE90RnFydmxjZWlYZ2ZkWTluaHlY?=
 =?utf-8?B?QndHTWhtWUhBM1NrTUYyVTFtK1J1emd2NTNRTnpLQnpPSFhBUDFLWnJWQkky?=
 =?utf-8?B?L0FmcHFLSEtUSzhpeFgzVHp1eGZQU2p2em9OV0wwWGdiZ2MzaU9qZWVBcU0z?=
 =?utf-8?B?d3ZjbWJqaGppTWNkdWRLdjhkbGpKUlh4RWE5ODlLQlZwRlJTKzVpV0FzNWZw?=
 =?utf-8?B?RnIvN05HeTdxT3ZuVFJvRW5KSW43ZWtBcTdOL2lYWDJhK3ppUHpBWkdjM0w0?=
 =?utf-8?B?YnA3MitKcG8yYzZBT0Y1NTdRQkRjQnVFQWdTWThGZmZQb2J5bWlvOHJRRVVl?=
 =?utf-8?B?VnE0djlnSXhySzd1Q0VZV1VSclNCZW94NFhrdGlBTFEyUkg3RFlxZWEvSit2?=
 =?utf-8?B?cmRBWUdPU3dJVU50SGdzNGtUV2JVMTFja1o0N2N5RE1ldERJVXUzOThLcS9O?=
 =?utf-8?B?SHRpYUlmMDFwQkJWckRSTHN2WEcwRlNId20rTWlKdjFaMkhzL2t2ZzlRU2RF?=
 =?utf-8?B?UmRIR2wvVzNlRzVCZG5JUjUwNU1PdGJDbHdNU0Y5MjJGYklXbzhEcEU3aDRF?=
 =?utf-8?B?QzVUSnZKdXJQbkdIdkcrRDQ5Z2FJemxOS1MrSjRjdmlkZk5JRlNJejBMRkxH?=
 =?utf-8?B?Mi9YNlg1K1RCWlRLbEJZdjBwWHdEQ09adjZjSEtCN0Z6R2NYQ1NzREFFWW5Q?=
 =?utf-8?B?Z1U3a1VPdGsxc09uSHNxbE9aMlFQeG1lMmpTU1k0NGNpem1KRW9wQXhKUnp2?=
 =?utf-8?B?OVFaWFZ0WEJoSjVDRTJNMHFrckJrNXlYZE4vOWprVGJRdjk5S0tCTFlVcHJu?=
 =?utf-8?B?OWxiRmxIYTU2dEFKSUR3OVVSMjQvUU02ak9IdTJsaGtndWNWWWxNbWlKM25O?=
 =?utf-8?B?aGVJT0NxUXJnZFcrNkdpZnZZc0NwS2VZOTZjVHMrTDF3c3V3THRzZGZkUUZM?=
 =?utf-8?B?cW5OQms3blZOZHB1UmpwRUJrNytObWJkSVlZN3Q3eWY4V0czbkhSL1Vna3Jo?=
 =?utf-8?B?YTRCbStHenFzS2tNaCs3aVZlTjZDd21WRXRwMmlONUpJV2xYU3FIdWZUMzZw?=
 =?utf-8?B?Wm1iSGdHRjNtdFpyUXl2UmlYcXZaajhrd01idGk5UGNtRm84bDM5QlZTbER4?=
 =?utf-8?B?UkxFMDhTMEFvZHdTMXZxWDNFbjJtWEFVMWdSK0NXTXpDNllzSUphdG94UkVH?=
 =?utf-8?B?QUlEalM5STV2bGc5R2xtdVl5Ukk0b0wzWlFUa3Q4VkNlWTlNa0RaMGZMbStF?=
 =?utf-8?B?UnExTHEranVuR2QwdEpoMFdBb1JMOXMyMmRCenlTdkdRNGROdCtMbnNWZ3Bo?=
 =?utf-8?B?NU8yZlRPZTVCVFVJRHIvU3ZjanRkVks1OW8wWTQ2YTk1VWxVSlVneUtlM1Jq?=
 =?utf-8?B?UzdkY3k1Mno5SVdyTGtHbzVjZTBFYUpoKysyblRHK2xUbkswWmRiRVRDcmJZ?=
 =?utf-8?B?ZGlHUUR6RmV1MG4rTU1rb2dScjgrTFJBVmZqbzkrNDhvL0o0aFYvUG5iMDNt?=
 =?utf-8?B?Tmphc2xNZEVrMzhqWkRXZG9FODRVdlBNUlpOYnd0RlNpMUU0MEVDQmdZRFdV?=
 =?utf-8?B?dm9nZkZrYVUvbVRHSHp3ZllPZWdVbXZkbFJtV0tPNi96QW9sK3BwV1d0QWNz?=
 =?utf-8?B?ZVM2d081VFpCb3JjQ2JLVzRndTFGQjB5WUZOM1FXcVF2dWpKaE05SmZMNzBl?=
 =?utf-8?B?TGxVc2I5bm5WZXdTQWZOb21GSTN6d1lYd2tyZzBHRDRtTEUxUXpHTWkwb3VV?=
 =?utf-8?B?REVLSU5JejA4dXQ5WFlodWQzeUlGb0pYR3M2SnRLcXIxN3ZMSFkxSnpFOGY0?=
 =?utf-8?B?ZkVQWHdBVm9Mb1RMaE9IekdGR1BrMng0aVFCcFBxL21xWU0rQ3hvbUxlU3FX?=
 =?utf-8?Q?4qUxAq47xYwnGfrIhvX76AI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LWe5lktNXqrGz2j4gphoKkSB6mdISeNlK9YinPD27UeOXHVHwc6PfQXyh37+4afwpu0YxmINgY/ihA1ukjxyiGoNIBav6I4c9bopILdGeioWsd/MEVbJjysX7Hefweg2hYqlGdsmTvOUINuNXKKGUYCtRiYAwDwE5Z4voCxcs27xxpRCDkpB911W8gGup/7xKgk8s7PBurHFWDcuq8/FyFOaWy1PbxII0B+Qi/zmMcCY7MSOTrdG6+S2Qv4CYt/HCyYJKglk74GpmwUBns6ueE4y1pUt34KNqnYCTlfw2fhWzj9aIuOmkKQY0+yaRLfPPNaRJe+X2fhyZdSzaoEk82YnSRdASLmIXmIIKimEL0/Eq1gz8+2wLRejQIn9wnYfF3sVGquR+Mes9jA5U4HRoh48Ft3BfUyNxeiXC0nu3K+Q9I1bwUWfKYyBPmd45hVl++tjmkEIdpy9Vxxgl9cWGgqi7YV/eVj4PVpNqhk7dOYBhf3lYRI6qKc4vs8mpbG4PYCXP8uc+Jnb5DQA9Pn3zNHKsO0RZ0MFIeTRPqfaK5cDE0EJmdhD9cy+2xjVuk2cvURJavhH4MRnnIpeNkxkxrhsdqoW0YzviBTthTVagdY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbad93cb-8ce1-48d5-0b7e-08dc70df3c2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 10:52:07.0752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2T9+z3/WaocXxBEjMT8jNbr9CzjyHF0jav3q+rXTYQCe11iOfdH5eEwck5Rr9pbQPvwtqEajCxXlsyAH+D3Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_07,2024-05-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405100077
X-Proofpoint-ORIG-GUID: l6K2mWSfiPEr59EYiVqUJwM8ks5XvPuQ
X-Proofpoint-GUID: l6K2mWSfiPEr59EYiVqUJwM8ks5XvPuQ



On 5/9/24 9:13 AM, Eugenio Perez Martin wrote:
> On Mon, May 6, 2024 at 5:06 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
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
>> index 893a072c9d..e6eb1bb453 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -1506,7 +1506,7 @@ static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_nu
>>
>>   static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>   {
>> -    unsigned int i, head, max;
>> +    unsigned int i, j, head, max;
>>       VRingMemoryRegionCaches *caches;
>>       MemoryRegionCache indirect_desc_cache;
>>       MemoryRegionCache *desc_cache;
>> @@ -1539,6 +1539,8 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           goto done;
>>       }
>>
>> +    j = vq->last_avail_idx;
>> +
>>       if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
>>           goto done;
>>       }
>> @@ -1630,6 +1632,12 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           elem->in_sg[i] = iov[out_num + i];
>>       }
>>
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        vq->used_elems[j].index = elem->index;
>> +        vq->used_elems[j].len = elem->len;
>> +        vq->used_elems[j].ndescs = elem->ndescs;
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
> 
> I suggest using a consistent style between packed and split: Either
> always use vq->last_avail_idx or j. If you use j, please rename to
> something more related to the usage, as j is usually for iterations.
> 
> In my opinion I think vq->last_avail_idx is better.
> 
> 

Totally agree. The reason I used a separate variable in 
virtqueue_split_pop was to capture the value of vq->last_avail_idx 
before it got incremented in the next line.

Not sure if it actually matters whether or not I use the value of 
last_avail_idx before or after it's incremented. I don't think it does 
but, in any case, I opted to use the value before it was incremented so 
as to be consistent with virtqueue_packed_pop, where last_avail_idx is 
used before it's incremented.

I'll change j to something more meaningful though. Maybe 
'init_last_avail_idx'? Hmm... will need to think on it.

>>       vq->last_avail_idx += elem->ndescs;
>>       vq->inuse += elem->ndescs;
>>
>> --
>> 2.39.3
>>
> 
