Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E1D16D4C1
	for <virtio-fs@lists.linux.dev>; Fri,  5 Apr 2024 13:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712325543; cv=fail; b=VPu9Oc3S9o1aS+EBl7dFhEPDGvdzX4g5nC1iV83o5cSq/17eNRwHIKHmRuk9iZYkjOo75nh9vARwMmYIU7lhS9skZEMD7jAa+tOqs3l/EffdJhhHJizGRq3Uj3wkSXYtqhzGu6DKHOPMrT8DwAmLzy2TkTHhKWez7gO86v04nds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712325543; c=relaxed/simple;
	bh=CzTiKBsfjuliSoL14GCf5akf5uMMBbLqzGFhZdtekC8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I1T/rzFcuazfSLFPtrSac3oaf5c9AgbSshrQ3jlgZRilPbUIArUC6GI4xUUbRIBZZE6ThSBfu12BKAbPTdfl8Q3HXUrRpX3HAa5iicJ15S1xtru3HQDlzEI7BXorEqaLGR4oFHJ7dSonGQgRAnXhIi5RBMfHu2NiSQFvykXFEr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=IblQDX1N; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ej+05+hL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IblQDX1N";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ej+05+hL"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 435DjLqs029866;
	Fri, 5 Apr 2024 13:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=nqAxjETEGeVZmcFoCHGaztbmG+/fp5UAIR9Nv9VrF88=;
 b=IblQDX1N3zTWSBvy2SH/jLjE35r/nUeyBdy2R3YagmLkVzcj3D9hHbZ1LkotpdcYaUin
 2sZDFmUSyjvRESj6Mpx8LCSKw8u3FXjNP9OCiMQAIUrVEKNRfht5R0L8T5Os9lCjJGCh
 cud5906TjYZJTKwXhss/wpmO4QG+Imuz2KgZ/mr0Zn0Sv8eumCT/BoxN4WedTxL8m/Xj
 0HQHXdq1FolTph3A8Cit4Qs7/V9talBlFloAVedQsgOSPmjIt3KUQpf8qVg4qK2H3SXy
 foL1ubaGWtCLGMKRa/LWuIS7WjsPCtFedMgM4gbpCqJCrPSC2zwRQFR6lxJKZ9QcgoLN /Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9epukk9e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 13:58:54 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 435DUssF026698;
	Fri, 5 Apr 2024 13:58:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emp0x8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 13:58:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3O0SEzlurDlNdhm6VzReRPmWILa9Wzp7XPOFNT/jh4pW11WZTEEYt5iOMXsHl+XleF3ADr0BNQ8tyhlV8TPB770J+Ze+OhODbpq9UPZW3yVqE4xpYbkLt/RewChqyzseLnbhCbQywltZ7crmIt3hMDD+uIFYQMkzJ+rCizX6HurNTyrnuD3xdIsjzASlXEeFZVXqGh6v8PQ0/nriQsqD6RUJM0nsRD2j+wIPij1Ef02IfCcq92kFEP8FqqEQqXO8+hzWja2uCaMa+nh5l5xK2JjJujb9PQjKg2ZgXDX/UKb97D+KwfMPBgNqCSLJJ/cFRQUC1ORhfhloaqb/DrHOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqAxjETEGeVZmcFoCHGaztbmG+/fp5UAIR9Nv9VrF88=;
 b=mmTeIwkhPWoRGDSaO1DFGw/2EadPGIa0bgU0eugyXGIFL+J468/CONQ7VCrCWBnPMwwH79V2kAgP5UUDdqMtfrnkE+KsJN4Grcr+Q4Sr+jY2g4xVE2xUpTKdCbwYldQRdy2KmZpeG8gJL7SKch86ScgmJ38R8KRfSrzqyFfoPFWszrk/jujIP00BwEAtHPEsWlxcljpKWV1wX/Tobm1GLFyDqkS7BOQG+LDJKXHkfw9CdRlXsSEqWYV8SzA0z2y2QmQqDICehhjdgtZGyJr85wbHH+lSqIBcfNzH9uO8tKTAXtjgtZ49b6jxvYBYXOaaNAcfUSSzdJ3fFizM9Zv14g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nqAxjETEGeVZmcFoCHGaztbmG+/fp5UAIR9Nv9VrF88=;
 b=Ej+05+hLpjxwhbnN2XlAHS3Y82DXKrDXFrKZR4TL3vQC1tmoXJw1z2pDQq7+e41/7tExrQPMhI/w9m3hBgxy3ZiTdvvqsO18yCklD4nOdfAXrrEIYHOqqmKdmmhZwEZ/I72xuL7adrcMl3RnV+tT5t0Qzjv8eAlXz3H2cj0ckrU=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CH3PR10MB7645.namprd10.prod.outlook.com (2603:10b6:610:17a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 13:58:51 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 13:58:50 +0000
Message-ID: <c1e78d58-53bb-4091-b775-3d4a004a8bfd@oracle.com>
Date: Fri, 5 Apr 2024 09:58:46 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/5] virtio: Initialize sequence variables
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240328162203.3775114-1-jonah.palmer@oracle.com>
 <20240328162203.3775114-2-jonah.palmer@oracle.com>
 <CAJaqyWdyZdu48+cZ2umafLRi9NTz3YHxSxmyq6SD9d4noTR2jQ@mail.gmail.com>
 <768ffc05-333a-4f00-9944-940bcaca59fd@oracle.com>
 <CAJaqyWe3bw6WML9MLEhnpNuWL0_HUQJ4WrSyr1jnGHs6Jwn0-Q@mail.gmail.com>
 <42b8e8bf-ecfb-4633-b1b6-a33435f81cdc@oracle.com>
 <CAJaqyWf1=v7V-SzmbRCQo-DzuOKCQK2u5E9XVFV877Z5choVig@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWf1=v7V-SzmbRCQo-DzuOKCQK2u5E9XVFV877Z5choVig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:208:23d::21) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CH3PR10MB7645:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	lPwAeaZyIACsXS4U7LDTNe0icVmF96GEzWYhFIff7kRzB9D6iwqT8Cjc+0k6Q3GJ3cDxuh2/uzsTg44+lt8AUkZB8Gfgo+jncB8zzlinpGW5OYEVdYeGUHjbUchtXBtcx3E1r0nQzxI5DcfZGmnDD1OqXWZBLzjnMWxoI0OwYgPjev9EazKplKPoVPFFRvnTxNUT3sx4O9LoSgNVO5P3zWB9FVvhcDbJAjKMPfLqBA3AofAR8lHkJTuIDlw0uvY6hVLSbGDyJYnAOZcD8F5CFFzhX9b2u8VqoHMzdoJtT5SnKURGiDa9Kawrfp763bIuQ7VI/rnfRXB0LmNzuNooBfavl1jOr+fkZbCmu4+jdUZTrmFdyjlqTpwXG52DD9wA8GmpmJKp4k1g1EnrPNF5f15LefHFiKviFfOsqxvjxbiz4ZUQk8iwub1SJsEn2MMc7kf2FngeNTIqVIzJBGgYDdGt9A8u6V4vocwL/bHRhr8TLtMq2n/zVApTzwUg0VjWdmC28IzdmxLPHDbQ+cDS8R7nGJ2lHhXyRCgm+gRNYtzEdYMzTC6NyPxzqqE0zq7np8Cu40ZtTJb/Apj7uCD8+S1lvMvReay3EggnhSjEUJeTgEgZ2rkGz/4aNxZZ0IlRk/GcjYrwZ+hpPdoUwWDpimJHYlQ9ncsHgqeUrJmLDIc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ajlDVmhrTW5PVkhFYmxZd1FNNFBnR0ZSZVA0K1pVL3ByTmhUMjdjWHFScUZ3?=
 =?utf-8?B?OG1VSkU1V0tuMG1MOHMvVWJlU01TN1ltQk9XbHlWZXFCL3RjM3NxbXhCbkFv?=
 =?utf-8?B?UjQ4T0ZtVDdiWHkrdjliVGlzRkxvS2JCN2tWZlp2d2liMDcxN0NSMHE2NURr?=
 =?utf-8?B?a3gyZElaYTdpcGlDUmF4bk1SZkx0bitFTmQ4OVZlekdUN2RJb1VBZDRVcDVZ?=
 =?utf-8?B?bEwxbnZxMFVzWnU5WWNYTFRIdFNMV2pGaTFHcTdMZUlUR3BuNmYxU3lIWVMv?=
 =?utf-8?B?clZlbkxYYnFCdmUzbEVLUkZSck8vWmNUdEh1SmV2NS9WdWswTmY5ZVlnbEFX?=
 =?utf-8?B?dzF1aE4vbnRrK3dyLzJ5Q25TT1prLzZ2WlVGci9IeDVIVmhuOTExTXdWVHZ0?=
 =?utf-8?B?NERKL2lhR1dQNVdmYnVObTVWRXRhZ3dSOEoyekZpOVY1WnZtZ1JuckZXS0Q4?=
 =?utf-8?B?Tm51UUlXU3JnL2o3bnNYZC9wRWE5VEtuc0dSSk5vQWkxK1pqSVZERno2UENL?=
 =?utf-8?B?ZGJmVGNJYXNadTZMY2ZiZmo0MDBad21uZS83anduUzBPbkxxRnpFN3ZhTHhE?=
 =?utf-8?B?ZXRVNEpPRk9sbnhrV3d4aFNVUkVlUU5hd05EejNIZmZ2eW9nK3cxazhCWXFl?=
 =?utf-8?B?UUtZZElUY2ZieHlpMEo4VWhYUmNFRFQ4WGQvTk1hMTU3OEZYSkVsWENWY21J?=
 =?utf-8?B?YnlCbktVTVVpY3JEYnBHazdwaldEODFnYy9QMW9ZcnJZNk1nelBkNDdHM3B4?=
 =?utf-8?B?UFVVc3VSR0V4OHpzckYxVFFXRjdMYnBxSzFsWCs1OEpsSnJ6cnYvNjZ3b3Vy?=
 =?utf-8?B?T1B2OHY0czJUeks0bHdhU2xQTDJKMEpUWUFjMEM4V1F3L2x1UnZmelhEZDBV?=
 =?utf-8?B?Zk9rb0lMMzBmKzJab1dSMENURCtHQW1hZG9DdGZiQ0F2ZDAyTVVuTkdmN2tF?=
 =?utf-8?B?L1ZDdzhJbVNNM3dkOWZjM2NLbjcvaVEvVnR3SUx3RFZTeVE2WVFYaTI0SkRk?=
 =?utf-8?B?anhpZUUzSDlzVkk4QUNCUGo3MkxaM0MrZVZUTHpra1NBb1I0bHltbGV1eGxt?=
 =?utf-8?B?UVNSaHk4dVNkL0EwdXgxdk9yc1gwQ1E5QTFrellERHkxME0yN2VlaW9Gbnpw?=
 =?utf-8?B?aE5ibFhNd1h5TlplU2ozZlA4YUE1S0VDbCt4cTRPU25uOXc2NFAyeFJpcVJD?=
 =?utf-8?B?UlUzQ1VkTG9YcnVLU2RyZTNORTIybVdHQ0ZOQnhidzJkM21CVUozYUZPQ1Fx?=
 =?utf-8?B?bHByR095QkNxQ2FhL1ZndWFVK2p3eWc5WFhGVUhocEJ3YXJ1N2I2L1dEdFh0?=
 =?utf-8?B?WFliUUMwMmd1dU9vSHY2SU1yV3NtYWcvUlRLMkFGa2JVcEQycGFCdnFpT0x1?=
 =?utf-8?B?UE1XYXVNbjNrWWMxaWNGaWhzZTJWY1hlNkV4QWNQQXhsVktyMlA1M0ZEUHV6?=
 =?utf-8?B?M1F1MWE0d0lkckwxTUhjck9LZVpsUEhQWTBMQVRkMWFzT3ZaZGJhbmhqSUNu?=
 =?utf-8?B?MkE5enBLaXRsbHkvS2JIRGFTOXFJOGwxcHZRNnVrZEYxVk55NlFnSVQ3UmtP?=
 =?utf-8?B?L2I4aFVLN3A3MmYxbld6dUVua2JvZU92MURXcnNmcG9FQkdIUzFkWDRMSlNx?=
 =?utf-8?B?UzV2UU1jUUpGRjBjSVlFZ0J2bnhQWGM3SWtsNzJzdk9PVmtiN0xCVzJuczM5?=
 =?utf-8?B?eWVTalowSzJycFgzTU9TcThOZEY4Nm1EaUVpa2FUQTZjYzBFSlhYUUE2WXNo?=
 =?utf-8?B?bExvdy9DTzlNdWdia21NVFFxRHViOWkxR0M4WTJIUzlXOXd2WlJmRzN1WkNW?=
 =?utf-8?B?YzQwY2IrZzVOR0VjZFpXSDZ0ejdWR1BnaWZ6SmRNNVR0QU53TTc1eDJFZ1M4?=
 =?utf-8?B?NU12V1psbG5TQUFsc3AzRWp4TWxlRUhtVWF0cGtIMXkxQk9IaUE5ZzBXOG8w?=
 =?utf-8?B?b3loQmRCbC8xcHVLdDNLNmVZRlRZQ3dqVXlJcVN5VkswTXltOXVDQWFjQjI5?=
 =?utf-8?B?OS9RWi9YOTA4U0N2emhMa1p5SjVpcURQWGU2NkprYlpzY3AyWDlBWjZlZWFy?=
 =?utf-8?B?WGEwb3VEY3ZIejFscXhpR0NYN0NiSVN5SE94YXcrQllQUXY5cXgyMzFiZlQ2?=
 =?utf-8?B?aEFLcHQvU0RzWndLaS85cStGSldWVktub1czcUx2RmNMMDE4SEI2c2lBa2tC?=
 =?utf-8?Q?Mk1VwqnNkofOD2z5/vRbaDE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7pLmO5Nzp7rLSbroAZAElp4YCUov+UeMr0RiO4NxGoRzMPGiCaz/t4UOtS8zGiHW16/F7vRLACYLMNbutPhljiL04JHmDx0EM2BCkJhE4j3rc4641meMapQk0uAqFGZT+ui8sbTf2lIf1tXMQ3i3l4CpcuLcQl8HhdeS6GlI11Lfe0mXzL3F8uoKv6kLbUQm/wOSzuCL9oYt6+his1vsf2qj1EGPwyIrXdm6HfwUW+N9T4rB1OboTznUKsgnPfeL7cd09oN1OcaMfJqJVazq2TzphsWYvnVjBlGdr32aWkwuXIKq4cTk+SImphgxA45lPK5JzOQixc78iANg7tG4T9ibAk41Lh49mJEkN782bCbWvRTurYciyFGSaRPQ6TYnjWbSKFeShVLCo11P+RGUpurwUHuHdWJT3Ew+lK0ww/mCdNRhPzkB5MwG487enMX3gdEEaC7X6F9qJha0TzYxG3TlH2a6ERTSnzB8A0u6OTXWRjd25HrJmlLHXnfR1YjWMLNB5RuBlrtyTd9sKIqHdxCj68fhHfPvQ6joHbclVSc9y9gYNmd0wU49AHHQmgB5HkOikdMcWGCXIql1laPwpoUFSjGrtIs3QqFBnAh5M1k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c2e70b-0e85-42e8-da8e-08dc557885b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 13:58:50.8904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: smp1QQ5MmjDqSHBuMGpZFbsN9qhns/r8Q4F7pszU9x/WuIPlrtiZoTWTyEtFAIPdKGLRB9cgzq0kfR112UPoKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7645
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_14,2024-04-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404050100
X-Proofpoint-ORIG-GUID: oSLexkcDDgDf5mkHk_1tQ0AspIM4JV1f
X-Proofpoint-GUID: oSLexkcDDgDf5mkHk_1tQ0AspIM4JV1f



On 4/4/24 12:33 PM, Eugenio Perez Martin wrote:
> On Thu, Apr 4, 2024 at 4:42 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 4/4/24 7:35 AM, Eugenio Perez Martin wrote:
>>> On Wed, Apr 3, 2024 at 6:51 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>>
>>>>
>>>> On 4/3/24 6:18 AM, Eugenio Perez Martin wrote:
>>>>> On Thu, Mar 28, 2024 at 5:22 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>
>>>>>> Initialize sequence variables for VirtQueue and VirtQueueElement
>>>>>> structures. A VirtQueue's sequence variables are initialized when a
>>>>>> VirtQueue is being created or reset. A VirtQueueElement's sequence
>>>>>> variable is initialized when a VirtQueueElement is being initialized.
>>>>>> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
>>>>>>
>>>>>> A VirtQueue's used_seq_idx represents the next expected index in a
>>>>>> sequence of VirtQueueElements to be processed (put on the used ring).
>>>>>> The next VirtQueueElement added to the used ring must match this
>>>>>> sequence number before additional elements can be safely added to the
>>>>>> used ring. It's also particularly useful for helping find the number of
>>>>>> new elements added to the used ring.
>>>>>>
>>>>>> A VirtQueue's current_seq_idx represents the current sequence index.
>>>>>> This value is essentially a counter where the value is assigned to a new
>>>>>> VirtQueueElement and then incremented. Given its uint16_t type, this
>>>>>> sequence number can be between 0 and 65,535.
>>>>>>
>>>>>> A VirtQueueElement's seq_idx represents the sequence number assigned to
>>>>>> the VirtQueueElement when it was created. This value must match with the
>>>>>> VirtQueue's used_seq_idx before the element can be put on the used ring
>>>>>> by the device.
>>>>>>
>>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>>> ---
>>>>>>     hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>>>>>     include/hw/virtio/virtio.h |  1 +
>>>>>>     2 files changed, 19 insertions(+)
>>>>>>
>>>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>>>> index fb6b4ccd83..069d96df99 100644
>>>>>> --- a/hw/virtio/virtio.c
>>>>>> +++ b/hw/virtio/virtio.c
>>>>>> @@ -132,6 +132,10 @@ struct VirtQueue
>>>>>>         uint16_t used_idx;
>>>>>>         bool used_wrap_counter;
>>>>>>
>>>>>> +    /* In-Order sequence indices */
>>>>>> +    uint16_t used_seq_idx;
>>>>>> +    uint16_t current_seq_idx;
>>>>>> +
>>>>>
>>>>> I'm having a hard time understanding the difference between these and
>>>>> last_avail_idx and used_idx. It seems to me if we replace them
>>>>> everything will work? What am I missing?
>>>>>
>>>>
>>>> For used_seq_idx, it does work like used_idx except the difference is
>>>> when their values get updated, specifically for the split VQ case.
>>>>
>>>> As you know, for the split VQ case, the used_idx is updated during
>>>> virtqueue_split_flush. However, imagine a batch of elements coming in
>>>> where virtqueue_split_fill is called multiple times before
>>>> virtqueue_split_flush. We want to make sure we write these elements to
>>>> the used ring in-order and we'll know its order based on used_seq_idx.
>>>>
>>>> Alternatively, I thought about replicating the logic for the packed VQ
>>>> case (where this used_seq_idx isn't used) where we start looking at
>>>> vq->used_elems[vq->used_idx] and iterate through until we find a used
>>>> element, but I wasn't sure how to handle the case where elements get
>>>> used (written to the used ring) and new elements get put in used_elems
>>>> before the used_idx is updated. Since this search would require us to
>>>> always start at index vq->used_idx.
>>>>
>>>> For example, say, of three elements getting filled (elem0 - elem2),
>>>> elem1 and elem0 come back first (vq->used_idx = 0):
>>>>
>>>> elem1 - not in-order
>>>> elem0 - in-order, vq->used_elems[vq->used_idx + 1] (elem1) also now
>>>>            in-order, write elem0 and elem1 to used ring, mark elements as
>>>>            used
>>>>
>>>> Then elem2 comes back, but vq->used_idx is still 0, so how do we know to
>>>> ignore the used elements at vq->used_idx (elem0) and vq->used_idx + 1
>>>> (elem1) and iterate to vq->used_idx + 2 (elem2)?
>>>>
>>>> Hmm... now that I'm thinking about it, maybe for the split VQ case we
>>>> could continue looking through the vq->used_elems array until we find an
>>>> unused element... but then again how would we (1) know if the element is
>>>> in-order and (2) know when to stop searching?
>>>>
>>>
>>> Ok I think I understand the problem now. It is aggravated if we add
>>> chained descriptors to the mix.
>>>
>>> We know that the order of used descriptors must be the exact same as
>>> the order they were made available, leaving out in order batching.
>>> What if vq->used_elems at virtqueue_pop and then virtqueue_push just
>>> marks them as used somehow? Two booleans (or flag) would do for a
>>> first iteration.
>>>
>>> If we go with this approach I think used_elems should be renamed actually.
>>>
>>
>> If I'm understanding correctly, I don't think adding newly created
>> elements to vq->used_elems at virtqueue_pop will do much for us.
> 
> By knowing what descriptor id must go in each position of the used ring.
> 
> Following your example, let's say avail_idx is 10 at that moment.
> Then, the driver makes available the three elements you mention, so:
> used_elems[10] = elem0
> used_elems[11] = elem1
> used_elems[12] = elem2
> 
> Now the device uses elem1. virtqueue_push can search linearly for
> elem->index in used_elems[used_idx]...used_elems[avail_idx] range. As
> the device is mis-behaving, no need to optimize this behavior.
> used_elems[11].index == elem->index, so we mark it as used somehow.
> Let's say we add a boolean to VirtQueueElement.
> 
> virtqueue_flush can scan used_elems[used_idx]...used_elems[avail_idx]
> looking for used elements. At this moment used_elems[used_idx] is not
> used so it stops there.
> 
> Now elem0 is pushed. It is the first one in the
> used_elems[used_idx]...used_elems[avail_idx] range, so we can write it
> to the used ring at fill. used_idx++. We use the rest of the
> descriptor until we find one in used_elems that is not used, which is
> used_elems[12].
> 
> After that virtqueue_flush is called. At its scanning, used_elems[10]
> is used, so it writes it to the used ring. After that, used_elems[11]
> is also used, so it is written also. used_elems[12] is not used, so it
> stops there.
> 
> Finally, elem2 is pushed, so used_elems[12] is written.
> virtqueue_flush detects it, so it writes it to the guest's used ring.
> 
> Let me know what you think. I find it simpler than declaring new
> indexes, but I may be wrong.
> 

I think I see where you're getting at, but I just have a few clarifying 
questions about your proposal here.

So you're proposing to add entries to used_elems at virtqueue_pop, ok.

avail_idx = 10, then the driver makes some new entries (elems) available 
in the avail ring:

used_elems[10] = elem0
used_elems[11] = elem1
used_elems[12] = elem2

At this point, avail_idx = 13, used_idx = 10.

elem1 gets used first, ok.

Now, if I'm understanding correctly, you're saying that in 
virtqueue_push explicitly (not virtqueue_fill/virtqueue_flush), we scan 
used_elems[used_idx] - used_elems[avail_idx] to find used_elems[i].index 
== elem->index and mark it as used, e.g. used_elems[i].used = true. 
Okay, now used_elems[11] has been marked as used.

Now we make it to virtqueue_fill. What's the role you want 
virtqueue_fill to take here (if any)?

You say that after we mark this element as used, we go to 
virtqueue_flush and scan for used elements in used_elems[used_idx] - 
used_elems[avail_idx]. Of course, the first one of this order will be in 
used_elems[used_idx], which is currently showing the element as unused, 
so we're done with this element for now.

So, what exactly is the role of virtqueue_flush here? I'm inferring here 
that you want the virtqueue_flush role (for split VQs) to do both the 
writing to the used ring (normally done in virtqueue_fill) as well as 
updating the used_idx (normally done in virtqueue_flush). Is this correct?

Next, elem0 gets used second.

Again, in virtqueue_push we scan scan used_elems[used_idx] - 
used_elems[avail_idx] to find used_elems[i].index == elem->index and 
mark it as used. Okay, used_elems[10] has been marked as used.

Then you say, "It is the first one in the used_elems[used_idx] - 
used_elems[avail_idx] range, so we can write it to the used ring at 
fill. used_idx++. We use the rest of the descriptor until we find one in 
used_elems that is not used, which is used_elems[12]."

This, to me, sounds like "in virtqueue_fill, when we find an order (e.g. 
used_elems[used_idx].index == elem->index) write it to the used ring AND 
increment the used_idx. Keep writing elements to the used ring if 
used_elems[used_idx].used == true and, for each element being written, 
incremented used_idx."

This is a bit confusing to me since next you say "After that, 
virtqueue_flush is called. At its scanning, used_elems[10] is used, so 
it writes it to the used ring. After that, used_elems[11] is also used, 
so it is written also. used_elems[12] is not used, so it stops there."

This sounds very similar to what you proposed for virtqueue_fill, except 
it looks like you're also saying to do this in virtqueue_flush, hence my 
confusion.

If you wouldn't mind, could you clarify the roles of virtqueue_fill and 
virtqueue_flush here for me? Thanks :)!

> This makes it difficult to actually batch used descriptors. My
> proposal is to address it in another series, by delegating it to the
> caller and recovering proper usage of virtqueue_push(idx) parameter.
> The caller can specify either to batch as usual, or to delegate the
> automatic (and potentially inefficient) ordering I'm proposing here.
> 

Just to be clear, for this series, you'd like me to implement a solution 
that does *not* consider the case where virtqueue_fill is called 
multiple times before virtqueue_flush (and to put a solution for this in 
a separate series)?

Are we not concerned that we might shoot ourselves in the foot here by 
implementing a process that may not work well for a batching solution, 
especially when we have an almost-working solution for batching and 
non-batching cases?

>> We
>> could just keep adding processed elements to vq->used_elems at
>> virtqueue_fill but instead of:
>>
>> vq->used_elems[seq_idx].in_num = elem->in_num;
>> vq->used_elems[seq_idx].out_num = elem->out_num;
>>
>> We could do:
>>
>> vq->used_elems[seq_idx].in_num = 1;
>> vq->used_elems[seq_idx].out_num = 1;
>>
>> We'd use in_num and out_num as separate flags. in_num could indicate if
>> this element has been written to the used ring while out_num could
>> indicate if this element has been flushed (1 for no, 0 for yes). In
>> other words, when we go to write to the used ring, start at index
>> vq->used_idx and iterate through the used elements.
>>
>> If a used element's in_num and out_num == 0, then this element is
>> invalid (not yet processed) and we stop the search.
>>
>> If a used element's in_num and out_num == 1, then this element is valid,
>> written to the used ring, in_num is set to 0, and the search continues.
>>
>> Lastly, if a used element's in_num == 0 but out_num == 1, then this
>> element has already been written to the used ring but not yet flushed,
>> so ignore this element and continue searching.
>>
>> There should never be a case where in_num == 1 and out_num == 0.
>>
>> However, this would probably mean that before (or right after) we
>> actually perform the flush we'll have to iterate through the used_elems
>> array one more time and set their out_num's to 0 to indicate the element
>> has been flushed.
>>
>> Again, this is just for the batched split VQ case where we have to keep
>> track of elements that have been written but not flushed and elements
>> that have been written and flushed, given that we don't know which
>> elements have actually been written to the used ring until the used_idx
>> is updated.
>>
>> This approach appears more costly though if we're really trying to avoid
>> having this new used_seq_idx VirtQueue member.
>>
>>>> In any case, the use of this variable could be seen as an optimization
>>>> as its value will tell us where to start looking in vq->used_elems
>>>> instead of always starting at vq->used_idx.
>>>>
>>>> If this is like a one-shot scenario where one element gets written and
>>>> then flushed after, then yes in this case used_seq_idx == used_idx.
>>>>
>>>> ------
>>>>
>>>> For current_seq_idx, this is pretty much just a counter. Every new
>>>> VirtQueueElement created from virtqueue_pop is given a number and the
>>>> counter is incremented. Like grabbing a ticket number and waiting for
>>>> your number to be called. The next person to grab a ticket number will
>>>> be your number + 1.
>>>>
>>>
>>> So it's like last_avail_idx, isn't it?
>>>
>>
>> For the split VQ case, pretty much. Though if we hit this case in
>> virtqueue_split_pop, we may get into some trouble:
>>
>> if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
>>       goto done;
>> }
>>
> 
> That's a fatal mistake and the device breaks, vdev->broken = true. It
> cannot be used anymore from that point on, because of all the checks
> of that variable.
> 
> Does that solve the problem?
> 

Ah, it does. My apologies, I should've recognized this would result in 
the device breaking.

>> However for the packed VQ case, last_avail_idx might not work in the way
>> we'd need it to for this implementation. In virtqueue_packed_pop, we see
>> this:
>>
>> elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
>> vq->last_avail_idx += elem->ndescs;
>>
>> It would appear as though last_avail_idx is incremented by total number
>> of descriptors associated with the element, which can be greater than 1.
>> This implementation increments by 1 for each element.
>>
>> Actually... It's good you mentioned this because I think my packed VQ
>> implementation is wrong. For packed VQs, vq->used_idx is incremented by
>> the total number of descriptors in the flushed elements and not
>> necessarily the number of elements being flushed like in the split VQ
>> case. I'm adding elements to vq->used_elems in a per-element sequence
>> rather than going by the number of descriptors an element holds, which
>> should be the case for packed VQs.
>>
> 
> If you keep it by your proposed index I think you can increase it one
> per head, as they are the entries that are written in both cases.
> unsed_idx should increment properly already.
> 
> If you move to my proposal, both should increase by elem->ndescs as
> you suggest here.
> 

Ack! Thanks!

>>>> Let me know if I'm making any sense. Thanks :)
>>>>
>>>> Jonah
>>>>
>>>>>>         /* Last used index value we have signalled on */
>>>>>>         uint16_t signalled_used;
>>>>>>
>>>>>> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>>>>>             elem->in_sg[i] = iov[out_num + i];
>>>>>>         }
>>>>>>
>>>>>> +    /* Assign sequence index for in-order processing */
>>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>>>> +    }
>>>>>> +
>>>>>>         vq->inuse++;
>>>>>>
>>>>>>         trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>>>> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>>>>>         vq->shadow_avail_idx = vq->last_avail_idx;
>>>>>>         vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
>>>>>>
>>>>>> +    /* Assign sequence index for in-order processing */
>>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>>>> +    }
>>>>>> +
>>>>>>         trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>>>>     done:
>>>>>>         address_space_cache_destroy(&indirect_desc_cache);
>>>>>> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
>>>>>>         vdev->vq[i].notification = true;
>>>>>>         vdev->vq[i].vring.num = vdev->vq[i].vring.num_default;
>>>>>>         vdev->vq[i].inuse = 0;
>>>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>>>         virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
>>>>>>     }
>>>>>>
>>>>>> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
>>>>>>         vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>>>>>>         vdev->vq[i].handle_output = handle_output;
>>>>>>         vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
>>>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>>>
>>>>>>         return &vdev->vq[i];
>>>>>>     }
>>>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>>>> index b3c74a1bca..910b2a3427 100644
>>>>>> --- a/include/hw/virtio/virtio.h
>>>>>> +++ b/include/hw/virtio/virtio.h
>>>>>> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
>>>>>>         hwaddr *out_addr;
>>>>>>         struct iovec *in_sg;
>>>>>>         struct iovec *out_sg;
>>>>>> +    uint16_t seq_idx;
>>>>>>     } VirtQueueElement;
>>>>>>
>>>>>>     #define VIRTIO_QUEUE_MAX 1024
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>>
>>>>
>>>
>>
> 
