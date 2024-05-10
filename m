Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F016C445
	for <virtio-fs@lists.linux.dev>; Fri, 10 May 2024 10:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715336820; cv=fail; b=rLRbDn3JR8BVQyRXyVEwOWALvw5neab59WcwLm+iYWj1N/TwBJ+50YVpLmH6W1p6FhxCW94M4FikWWrz4pzAv0J1RxkguNOczpBQEJpe22Hssn/W2WyPoGtCwuLNbEKJGqk5WMviJoJtLuj+nIrQbSF62B5Tdk60XbI8qjaKDl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715336820; c=relaxed/simple;
	bh=EC76AgMJhO5tHPb9m+K8QggagCgv3BjutTCs0Kq+B3g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KYXHxrCXF6P75nJAujPI3Ak/vCCVul/UmIE+7SlLg03m1H2S95yKN1ypmRNerMOX5h8f2YSlbADSVO3vJ79TRocOgx+e887MHfmYeZ2Ma4bwNKQjb4Jp+Hi5uBrADy3t7DFZJZEXS1UBqWCmKRAV83q/5uCbsrHd2zycLOHW69k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YRUeWs3q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=s3ksHA3c; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YRUeWs3q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="s3ksHA3c"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44AAHShW017516;
	Fri, 10 May 2024 10:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=qkEclQ4XxgLTeDFUQC+soRhPWGrY/BZz3gGITc0QDlg=;
 b=YRUeWs3qVIWgAOMKm3Pt7HBt5jooH0dgG6M9XWxBOKBD2fxgp9rM4iLDuRsdrMiphQPX
 M3+pNk07b598Vor2AiixVCFhGSIJlDAMn1toMCOQMaWMSL+HwfslrR0PcHUaoiqI2wKV
 TdFamBlHeRp/wqo3Uw491iYSV3CDrGnfLgOPOuWRkRcLoZ5cSsvUGbN69QbdfmMZAfFR
 NLKPZH/T/ZK718ShzcuXSgjeQvqBdVyfVWU5zQjd+q2wjAZVBAUhp360aJTTYqNID9Mr
 OBqfa5tY3IiwdxemtwdT/glo5FLVNfzo7tpk1LBZKiSSwUrLlDql/Oy4WpIUemQasmjD KQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y1hps80nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 10:26:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44A9bGrH031006;
	Fri, 10 May 2024 10:26:50 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xysfpmtx5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 May 2024 10:26:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NWLi+nWarI2t1dHxG0FD0x17OQYNhQDkkvHVJ6+x0fZURWRiaOAngPWyPDxk5f/fvRQfXD9VcB84Xx8Hzpx70oT4X4of98qfdemczoCBzD8YhgshLyfjNuG1hFON+UEUAyH2GSPQC9Hz6q9KtNXkmCnj39ythw0xyy5+tIdjuswjXRA8NFOygLHBUAuOFiXHou+DNbBio0GqBTuqf101q+34ldcolyKKc4kGI0tnkUbJ+k2Pk7fy1lONJNC9wrmKzatwSX67Hkzf8Kvv91y4jLTPBrq8yiuesvIs448UvRwy5k4Dt1L4wk0GFB7fLCEZ7P2YIk4xRemiDrvP9+Cb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qkEclQ4XxgLTeDFUQC+soRhPWGrY/BZz3gGITc0QDlg=;
 b=WflF6ZpPGrrdOAkwErm6UQ5H/hlClK4XNUKhbi+i1J7vtoKgvlLe02sQsPMXj73jMUEv6g54dG+LtolVbQQeSCN7qYOUMYz3UCEf4evMoqke6VUlFfn2M1giH8IEzHdAeCRxB2u0WZHnER2Y8dz9XlKXie7SrBacc7bQCnBB9sMCO3tlZE+v4qXc7xxfxFBFXGofMuM7pNr3oO0gWwtCjf/41IHzBBibXSScHy3/T/v61RuqYtI0tze6XzlNdCFyBXvKx4uaNQoOxFyIYyIyFAt3hgurhMU0YPdSYhq5v/OfZ10jhBTU5l4caceNXhIeI22wgFRrKKL3oOvQjPpqSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qkEclQ4XxgLTeDFUQC+soRhPWGrY/BZz3gGITc0QDlg=;
 b=s3ksHA3cSeJvooHnSXtEcvxe+hHGHo/w92mAGda7d48X1YaVSLS5C27xry8PXh0xlROyNp5Bqh0kzzCnll3+sWWrMZsSOLzrzmCoQlWBToz9IZihtjmA6U6S5AtwIBoXbGEG0ck/K+y5WUvRwc5R+A4tSv012aGVucapduSDbvY=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46; Fri, 10 May
 2024 10:26:47 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 10:26:47 +0000
Message-ID: <ea85931c-34b2-4cd5-b612-1436a71c2758@oracle.com>
Date: Fri, 10 May 2024 06:26:43 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] virtio: Add bool to VirtQueueElement
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240506150428.1203387-1-jonah.palmer@oracle.com>
 <20240506150428.1203387-2-jonah.palmer@oracle.com>
 <CAJaqyWeitQo0rqR5+q7e1OjBF=zWHpg++cwyH3dRhaNaM6bB+w@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWeitQo0rqR5+q7e1OjBF=zWHpg++cwyH3dRhaNaM6bB+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0041.prod.exchangelabs.com (2603:10b6:a03:94::18)
 To PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|SA1PR10MB5868:EE_
X-MS-Office365-Filtering-Correlation-Id: 704e75e3-f106-4a34-4a60-08dc70dbb28a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Y2plSmQ4b1FTUzlqblZ2ZVhaUnBlem1ncGN0T3p2Y3JXNjRRR0JVLy9ibmdo?=
 =?utf-8?B?Z1JTUWErQXlndWhZRVBXcjJuQkVtUXAyalBmVlpva3Jybmh6TmxtT0xaTU1W?=
 =?utf-8?B?NXdYVnA4aDZIbnZ1MjBDZFFKWWlLRm05VVpLelN0QmRNbW4zRWI0YnJJZ05N?=
 =?utf-8?B?V1RmNGhJRU5pZGJvMmNjUG04ZU56Q2xxZnNsK3NkNE0yVjRQN2VnNjAvR2RG?=
 =?utf-8?B?QUIwTnFoMkozWlpMdGZHcG1CWk1ySmVkbHIzb3Z0S25IdVAxL25JNGR1THRX?=
 =?utf-8?B?bHpkcFJCQVBRVjZSbENXZFMzM3JqR1Q0TzhLSVNhRTNNNnBQSWdIQVZ5Z0lJ?=
 =?utf-8?B?Q3lEU2h1V1VzSDFIOERGUXR5QnlNZXExUGpOdCtJeW1Xek1hR0VlSVl5TnZw?=
 =?utf-8?B?cENpWForL3EwUXpEc05KYTBFdzRjanMraERkVStmSHlaSkQ3SmxTaXo1MHVW?=
 =?utf-8?B?QnVVbk1KazF5dGJuUnZsanJ6cGkxcWVudWZZbC90ZUJjRUsxQnE4TmRRR2t4?=
 =?utf-8?B?ZXhSWFpHOUl2elRRSkhmbldqK1gvcnlmTURsd3VsakxzZUk3OWJ6UjRZQlU5?=
 =?utf-8?B?T2ErY2xLZU5QMW9RaGFvR3IyekxVdndRVk4yZ081Vm1BUnpva3hVMXB5N2x4?=
 =?utf-8?B?WnR3RFluQjNYRHM5R2VxdVVERTQxSVFWLzdzRzN4OE9UOCtPRUcwSWNpdE16?=
 =?utf-8?B?amJDWko4cmZERTA1dU9yU214a2JIdXVHRkxlaDlDeEhRcGZnOTJIbytDS2t3?=
 =?utf-8?B?dVJiVFVVZTBTeUdhUHJpK0RDQ1ZhdUprcG0xN29QdkkzeXlIeFhRc2VlTVkw?=
 =?utf-8?B?c3R5cTMvR0dUbTJUN04zTEZHWnVXYTdSb0MxN1dGQzdmOGNnb0JrOC8yV1kv?=
 =?utf-8?B?bmFkODdvbkdKVTJNeUNtZlVzSjZrNy8xdGpYM3hCMWR3dm15bXlxaEhXVGxp?=
 =?utf-8?B?UGVnZGxYcjM4d21aVmZGYndzNTc3K01NK2ozN3FlcDFVdThubXR0UDhlRzV2?=
 =?utf-8?B?T0hWYUpzTEdjQmd6ODBpbTZxeXNkRXVNMGJVbWloU3Z5RExiMXh3MWZjYk5F?=
 =?utf-8?B?QUduT3IwTjVURmhOUjJrTUMyVXJRRTgyUGlPSzEyU216SHpNZ3BFVDBTeHFr?=
 =?utf-8?B?TmZWeXRLRUVFY2Z4Z2xXclNHVWV2d3duRVZSVm1kWTNhNk54ODFNbU0vbXE0?=
 =?utf-8?B?ZG5MRWwvRzNvNVNLRVFvN2VBU3FwcXFDdEZVRmo5Z0FHUTBQbzdITzV2Smgx?=
 =?utf-8?B?eUdmZjRIYVdvMkROVElkU1JUQzZUazJjc3V3bnIxQTN4a3prYkNkNk1WWWJY?=
 =?utf-8?B?ZUlKbi8vakpTUFRnQVRhNE9ZclZPRmFBM3NmaXFuRE9pMi83YWpWNkI3aWI4?=
 =?utf-8?B?dWgwMlBHb1NzQWdSRDFoN3ZtU04zVkFrMzVmaFBzTktjYXRNTXUzZTVnVWRk?=
 =?utf-8?B?eFJJT0wvQjNqRC9tcUxYWWFqLzJDeXBMSktRWk9OTEQ2QTVlZ2VxM2ZrNGll?=
 =?utf-8?B?UUllWlM2VzRNL0Nvc3dWWHYrWXFCME5ENWdVK0lkNERIWngrOW5mVzl2TVJL?=
 =?utf-8?B?b0tkYXc2RnpMQnl1Ujl3aXFRUkdpUElLSVo0M2hCbHFDTFJtclhubzV4Q2dB?=
 =?utf-8?B?VGtRRzZWN0dXN3JlYURFYVFjQTZGYnFjeklvNHRjZXdHSTJFVjd5cjJXWHk4?=
 =?utf-8?B?MmlxaDZ4cEk1dlkwU3NtRWx1QmJicm16M0Y1STJPVFZyZHorZG82RGZnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eWFNekVyYUIyMGd5NDVycWtkZFp0U2pQYjZBRFRpVzdHVXF5VFFJd0N6S21x?=
 =?utf-8?B?YXJjSjBRVEFJYkRlOUw0RzY4YVlIMk9seU41TDV1MldWVzA4WG1iZGtValpv?=
 =?utf-8?B?NDZNQ2R3YlljOEg5aFdKVlNnOVZZdHQ2NUpwcWJaVzFxSWNOL1k1UUZOc3FC?=
 =?utf-8?B?aFdmbFF5MlpXR00xTlBSeXFNZmR0azBoNi9zUG9LYkFyL3ZDTVhhRzFGZVBi?=
 =?utf-8?B?ZjEybTg5dEJDWTEwTUd0SzJZRG5oUXRoV0JXQlJmZnd6Y3d2YWpBTTc1cDhF?=
 =?utf-8?B?RmszdVF1dEY5UGVnZ29uMDFCUnZiclF6bmErRng1VW82QUFuZHVNRDJLQUpt?=
 =?utf-8?B?eStQdUJHUnA5NEZRblF6SXJhc2JFL1Q2NE14aTFEbmh4UEo2V1FQdDJybllk?=
 =?utf-8?B?aEpsSDZKbDNpeEtUQVBHNnpWMUU4eGw4RW45Rm5GR0w1cEtvdXNPeFBwM3pq?=
 =?utf-8?B?VDY3WW04a2o4OFQvcVFaOW1EbkwraXZLT1NNeUFDOGZVRzFmeUY2NGNkRU9s?=
 =?utf-8?B?YUJHNlJtc0dZdVVla2pwSldueVdJTlprSkpYR2wxbHpjQndxMkJVcWQraSth?=
 =?utf-8?B?c01nUDNSUzJLN09oV2Q1TnFISlNpV2NSLzBvT2VreU1Dak9VdDFJaHE3RE42?=
 =?utf-8?B?U3k0VVR0NDNqVWxMMXRGZHU4MlhGY0l6U2VhOEJkUktGT09lSVEyYTRpeHFi?=
 =?utf-8?B?OUZNN3NuTll3dnVjRjE3TUhLU3RDbXkrN1FGVU52aVcyZm9Nc3ErZlBTa1l2?=
 =?utf-8?B?dVk3U2Y0U3JCcmxCWnkwTlRFOEhaOUdPLzJ1NjZ0U0VobS9xVTNOWS9jVlZs?=
 =?utf-8?B?ekFmMTJLUjdGbjJ0ZU44V2w4dVpUemRJZ0JncTdZWXhyaXlhdWdjY3dZb3RP?=
 =?utf-8?B?QytzTDdSV3AwbTY1ek1aZkFDOUVITC9COHNsN1RIQmFOU2lsTE1JUGRDSjh2?=
 =?utf-8?B?V2xmN0xTdTR2QjFETkJPbXVkWm1RMmNoT2tvbk9va2V0ZnVFV2RYTEZVTUJJ?=
 =?utf-8?B?SjFpNmZ5WVlXWmtwL0hVdzRaWlFTdmJjaGFCYm1mamd1NXZqdE51QkRaZC92?=
 =?utf-8?B?V1pyTy95OTF0VmlseE9janYzYWp1c1V2TUVCcDJDT0FFZjBnZFQrd2hRS3RS?=
 =?utf-8?B?dk1JZ3ZyV25mZ1NVVUpONDY2c3pTYUY1VExkRHp3T2JVL0RjWTVoLzJGZm1P?=
 =?utf-8?B?NnRkSXBJMVJJK1VoL2NpbFBnMDhtNXNLdTlLdzdRS2N0dDQxWHZRU0twNVZD?=
 =?utf-8?B?MWNTVzd5RjFTNEZNdyt3QW5lQTJzSjhsMTNpSk5nMEUvSk5wdjJyMGtIb2Jz?=
 =?utf-8?B?TmE2Y2R5RGExYUZxa3lkUjFWcjJOV0hmWFU1bThZYXBhbmk3Zm8zSjRMWGlh?=
 =?utf-8?B?WDN2N01BRnZrNEZqYVM2NzN5VnJ0ZXMvelZzRk40dFhDeVdpNXUrTGF2MXJw?=
 =?utf-8?B?aE1JZmNYQWhDSlpsTTRWNEFid3VGbFpzVFAxWVZQVkZPRStNNEVqdlJmRG4r?=
 =?utf-8?B?L2h1dHVJUC81OUJDRm04cWVkYjRqUGErNm8yRjZJZGdHa0pFK253TFpwLzI1?=
 =?utf-8?B?REtzeEdnN1F1ZTFKeS9WMTAxQkxveExqeFhnYkZkT1FtZmk1dWE2SEJ6ckwx?=
 =?utf-8?B?M1QwSGZ6T29DMGM2WWl4cmxIdENJOW9tcHVsREkrZkc4K0RNYnVDcUtIZXov?=
 =?utf-8?B?VFZNbWpnOFZrQXlmVWVEVG1NY1FHSW5sS1RYK210ZmVwcndsSm9INzJ3Tnkx?=
 =?utf-8?B?MVZCNWdHaWRSbHMyYXl4MWI4MUt3VXJDZWZudllQRU9uNnhTYmlBcmRzeTJh?=
 =?utf-8?B?V2pKQzJpNngvTjRMZEdhU3NzS2xDMUpLLzBUQnVmVzB0M2JUeUNGYmJhTWxq?=
 =?utf-8?B?TU9hT1E3d0ZNcnE5OFI3Rk00a3JxanQ1T3pLVXM0NjJqOTUrbFFJUXdHYkg2?=
 =?utf-8?B?RVYxa1A5Mjd4UWlEbnkvNTlyKzZDVmF3c0tJcXh0bXlkNXNPYXhpQS9GaTB4?=
 =?utf-8?B?QTFGTjc1Qm1EWm53Ky94dWwrbUJoWnYwTlA0YmNqT09nUXBJY21XUFE4UG9Y?=
 =?utf-8?B?K0w4ak1DWUM4NlFDdU5DdXJ0eUN4RFBqVG0rN0RwdFZOMVNPU1QzQnpidVFq?=
 =?utf-8?B?VUxnazZvN2NTbkdDV2kwSWFBbHNCNGlxMmFFKzM2a1JrM0tzb0RjNW9vYWpM?=
 =?utf-8?Q?B5I8/NZLUngEs2LRLDgZVZs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SQZofzNgeiOKTGDLqcDfUFjZGzk7bumrZcvOfKFnMpo8n/mNCmHrfbMh/CLeF7kJKlcTdScSe3PcHh+eZ7itNo1czQH4Hy7mIOT9qZA+BJAp2Zn9mu17Dnit07KKlmnCZGNSyZ2IDlshfrhV8n4R3yjQCd3b/d7/AsuDk8XYVwBxJCvUHFvv/nVMmRjxkDm8o5Sy2Z9sm2XavcC51WghSUyc8PyRte8RJxYEenF3/Ae3gFAzYgko4xI1CZi8vp44t9CBdpfNEepG6cYz0V7IIjJBVr3WUZd0ivco/DrtvHeWZG+/9dptLQgfxWemwBMBdeZ50bWzzTKDOIQXKT+F4OREPWNdwOZU/t0GVy5S8xZWXKU792dx9SOeIzkWcxsUcxlfR01D9uRC+QFVBLkIHByMyXInyTpK5xgBS62+lJBZYWtwDEzHMwm3EygbpGt61IjU/QP2jvtZ9O9J3THV90pmzhS2Wep2Cv5VmEnSV1jGvwgRj8lbU6LrJHn7dDpaHfH/mx2DIalD7eia7FUA68qQz10Ejs9kE0tCjPZ+BtRIFkXhWMNsJHnDwxNtDTcIVFJ1FmJRKiQ1k6sog2QNsjO7kjbkPR5ONIS7ZtSX404=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704e75e3-f106-4a34-4a60-08dc70dbb28a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 10:26:47.7306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v3peudG8J0TEB5r6ajrxsR5JpY3tFrrf4oCJFKIEZYvCQfcXMFVLHqm2OL9xbS5QuOBInXb9Ai3bTzU9zkjjGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-10_07,2024-05-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405100074
X-Proofpoint-GUID: iN0QFhZt_pfoQtj6LKOUjTXfBtWxHrB-
X-Proofpoint-ORIG-GUID: iN0QFhZt_pfoQtj6LKOUjTXfBtWxHrB-



On 5/9/24 8:32 AM, Eugenio Perez Martin wrote:
> On Mon, May 6, 2024 at 5:06 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add the boolean 'filled' member to the VirtQueueElement structure. The
>> use of this boolean will signify if the element has been written to the
>> used / descriptor ring or not. This boolean is used to support the
>> VIRTIO_F_IN_ORDER feature.
>>
>> Tested-by: Lei Yang <leiyang@redhat.com>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   include/hw/virtio/virtio.h | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index 7d5ffdc145..9ed9c3763c 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -69,6 +69,7 @@ typedef struct VirtQueueElement
>>       unsigned int ndescs;
>>       unsigned int out_num;
>>       unsigned int in_num;
>> +    bool filled;
> 
> in_order_filled? I cannot come with a good name for this. Maybe we can
> add a comment on top of the variable so we know what it is used for?
> 

Will do! I can change the name to be more obvious as well.

>>       hwaddr *in_addr;
>>       hwaddr *out_addr;
>>       struct iovec *in_sg;
>> --
>> 2.39.3
>>
> 
