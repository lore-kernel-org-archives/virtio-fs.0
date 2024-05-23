Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9051D13D28F
	for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 10:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716460203; cv=fail; b=ipVkZz0GiCU8RijykAue75xWHkG0/6jYzJuDMDp4R+uzD5HiAiedKDu01EV2eQsO9mwgFCVl8M9O+TEQdE+1yEvkPj+slflZ3WY5XNeqBDpev/qJmSoFO1bldLHgRyegHEhbs8c2i0/+0idQoiRzAHU1dzdHpqmpRGR0ccESzRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716460203; c=relaxed/simple;
	bh=nhRPdHDoRYAlkkk+f56ibQBNOnjmV6xuYNJaU6GQKrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VVFA8hY6tzAAMBJI4Aqt7g1E1Oe3YBmjAvmokQYpJ8DGcA62FD+mgJZs4W6Ml2s5NZrjNyBEnsCk9zFZdtzxVbCRfxhCTli01ux58a12kB0MvWjUzXLRtJhFPUmVXYYkqyIWXNPhep/sJipuZGuE8GWtlkpnCTgj4S2VE7cgVmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lcAZecwx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YO3LQf+b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lcAZecwx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YO3LQf+b"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NAGZei014562;
	Thu, 23 May 2024 10:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=0px6N60NnpRWFoLbrcOLdFPUZVzZIRmiH5LiHrc3sBs=;
 b=lcAZecwxMOaBVcafkK5PO8+qsLPofY5/VNBjL3yw1EW69rOIaHzYrZtYyBJY8QBrYdkL
 /K5YlJAOEdJ6llz8zlpJTRrIK490+Lv7CFv6ZDIGL0rrQZd8K3xZpgqUlUTIo4nerQSG
 gSkklNpd5FoVG1ciHgtsKsCYHi/B2V6L2hMmPdIK6ThbDkg/vdGPn8Tz6bCM1+hnT/KO
 Tj3vdw61bPwNTlzqhl1CPC7rw0EBhg+6LtJOhA7niSWii9uFpLIbXQtNh5qjLcEhFqgq
 7n3uQOQqTys99iJV4v3nq5qUJ90zIdIupGw5RkOyXQ5YD/ucmW+4epknEIYtoK6TBa59 7w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv9r2f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 10:29:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44N94XIN002749;
	Thu, 23 May 2024 10:29:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsac1wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 10:29:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pk0WGKFjO88wOGdvQzKlAcqx+d/Rb25x5Seri8ZsK9eiAtkYYkENcymFb1Vn6X5sgRJhVWe/nXdXxnAJC6347vYGemr7j1T0vTAHb3wdctxU55Qa2zwSyKo/ftrEQk5L/2w+V9WFEZ2DNywn7JdTVJNX4FtfDDWKHtHTDdAJBL7XVRBXJ6hSxFYtFrfsPNdGXSDEggDL3pXTvkDeFye7tEcTmAIlmEJB3ZP5lvy3uqMl62di3f3vsWRDRkTqAIcFtNe0H7IwjUuQ7qP9VYH6sc+weBI3sXaItuS7kCLAGSyYzVPZk3LtoZhzE/6CDqAcEH6dR8Y5KKbU2RSZznNEFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0px6N60NnpRWFoLbrcOLdFPUZVzZIRmiH5LiHrc3sBs=;
 b=VSST4YDgOldKoiqpz+sbVBa43ztqXR8ZF4dlkIDX1XfuCw/9zSjoQSzADQiyUDURItnm/0xU8zzebbcH4efljLDSkd8rw+B/9FeRATZ8EH/G7iCeSE1uyxJtGJYLsO4yjiKcfVjUO2PQHfTMKr8MFXBbMiWK3zxHNO+bqtcQvznZvKp5urTt6EulkPOdd3zOejcRMF/1eimcBlqKSiBA2uRF89Qzjm93PdoXsraKBHQ+KmFVx1Cdfz+6l1e7vOi0Za/A5cjMzUQ67e2G0rKQ4uQbZP8upCJMfKEVmC84HNA0UpAoYankLTsSDhsb2/+GdfVdVnBiFtVfMZdTJqU37A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0px6N60NnpRWFoLbrcOLdFPUZVzZIRmiH5LiHrc3sBs=;
 b=YO3LQf+bTXvZv87ByZHK5rRx1NmySx6itfM45YJ8I0sd66Ufe3VmlFnQhwFkCJpv0MLkpBne6O21GdyilB6X+7u0tX5zPVxswbl7r7/OCOkhMKpkfNHE49m5IHmVfrkru1+sDS10V+Rjmzf17DiHpCuYCfKFsTHxXEpGMoajtkk=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by SJ2PR10MB7037.namprd10.prod.outlook.com (2603:10b6:a03:4c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 23 May
 2024 10:29:52 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 10:29:52 +0000
Message-ID: <5469bc3f-7fb5-4fcf-ad9c-6467aba635b9@oracle.com>
Date: Thu, 23 May 2024 06:29:48 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER
 support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
 <20240520130048.1483177-4-jonah.palmer@oracle.com>
 <CAJaqyWdxt+cPNR=unm6P1cGCKV=LwhuMYdVeQLbWF6wYLBLWKg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWdxt+cPNR=unm6P1cGCKV=LwhuMYdVeQLbWF6wYLBLWKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::35) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|SJ2PR10MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: 7879ce5d-2211-40cc-dcd9-08dc7b1347ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|7416005|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?OHBtMmlHVjgzYTQwU0ZwRDkrN054SXBtdzFoVVVuNGRwcUhQU0tmSTlZNWN1?=
 =?utf-8?B?aDRHV2tvckpnS2tOa0NIY1F3bTRmVUVzdXNTd3pKUEdnNDNLZ1JIZTNLNFlL?=
 =?utf-8?B?Q01XZXMxRC9wMUUybTl2cE5qV3A3eGVqNjdUMVdoVmkxN2dMcHJ0U1lndzgw?=
 =?utf-8?B?UkdRQy8xNHpCbHAvVlprTUdzeCtwbURYYzVwYlQzUFFZWW1EODVEb2c3RytL?=
 =?utf-8?B?djVTMVRNd2NHd0Zsa0R1WHdVMGNvUDRpR3p2eVRLbHpZNGsvUFpkTVA5V3Bz?=
 =?utf-8?B?S1duL1A2cDZENVpKZjZGaHJ0RjFaNFpZZlVPWGYrTlJLendPZmVwQWczdXJX?=
 =?utf-8?B?a0RzMDRHeVMwdTVtaDZMTUkvNHVmWW5scEpjQUxLZWo1V1NTeWo5MUpPLzVS?=
 =?utf-8?B?QVVrekdrcVNVQTMwNzN4b01mTUs4TGRTMlVOSXhNOFhuNHA5MkljcFpESUR6?=
 =?utf-8?B?RmVXZnNMdy9GUndnMFRqRGlaZ2tjSUtQb01ENXBHVnF3NFpCZGNBQkpvTW1F?=
 =?utf-8?B?aGtGa2NiQU0xT0pENU85Yk1ZRVgxUTQwYmw4Z1FhSURkdTRLU05UR25GcUtu?=
 =?utf-8?B?WGRrSXMrcUYvQllreW5JY2M5WVF3bWxxanFoaUdVUTBURmVFTGFMV1lqUWU3?=
 =?utf-8?B?eGlMSGtoTDVZSjJwOGprdzhSSGRDcFl1UUhzcDZXTVVrcWV0K2xQa1J1N2Zs?=
 =?utf-8?B?RjQ5YjMxTkhEWjE1T3hQNElMOFMvcjlrcUlSTXdTeDNJRGtlU1NodDArR2hH?=
 =?utf-8?B?SFd0elJiS253ZU4wQ2pnYlFlUUZIbk9SUHB6L3NmYytzTTNKMElnTjVra2lJ?=
 =?utf-8?B?L0l2ajByUUdrOWdmbE5hV1V2eXViY0tvT0JjODZYUkVycFgvUXFjNXdOa21F?=
 =?utf-8?B?S2ZTbnBxM0FsVG1xcTJiQVJDZHZRTUVYWmV4SEllUkRTZmhUUFNUOVB5c01i?=
 =?utf-8?B?ejFGSGlyUlQyMEwvS3pWeG5CWjZDQUZFR2ExVGxhd2ozR1FpZ2tqQUQ3dHJ2?=
 =?utf-8?B?VEhCUFVjVEZobDd1ZUxtajVHNnRIYjZPSi9yL0kvNjlZNDNPc29xc2tFTW9V?=
 =?utf-8?B?b3VBUHlPSmhBWWJFNEVTdUxhenQ3bjF3b0JkaUxJNmc3TXRoRGFIT0xCTHlM?=
 =?utf-8?B?ZlR3OWYrZVVNaFRHeVdoV2QwQmJ5NktQOU1sN3dkNkh3bjlQbUFtU1cxbnN5?=
 =?utf-8?B?UlR5ZGhkNm5vMHJQa2lodThlK1VmY3lPdVZhZzFCdzNZUms4M1lweElTVGhZ?=
 =?utf-8?B?dEg1SUFDbUx4L2ora1gxdTNlaytjdGVvcDRuR0Ywcnh5eVlLT1hKRFNHaWR1?=
 =?utf-8?B?MmJHQjJwM1B5N2owNEozT2JaT3J3d2Y4Y3ppMlR0OHdPNE5DWmJXajdWRys3?=
 =?utf-8?B?SDIyaHZhV2tUWFlQaEZ1UmthZFFVT2pYNlBMNFBvU1dSOUNTWHZGRjJocmRv?=
 =?utf-8?B?Q2hHbk5NMnRqSHQrR3R4b2JxblY3V0dRZDRJcTFYWVV5RUsrTzdYeGd0TVJz?=
 =?utf-8?B?anBGTE9pTjdvdEhVVkJIRzRzZWhYR3VrRHRCTDlvS01tVGNScThhUWlRTmFB?=
 =?utf-8?B?RGtZNmpyekx4czNERXQwQUpqWTFyTFB3cDBDVXRBQ0VTVHdBT0VkSExOeExx?=
 =?utf-8?B?RFdVbm5nWjV4aUJyYmk5RFNrRFZMRHNPN2VsbFNzc2JUOFNZcVR2TGsyb0xD?=
 =?utf-8?B?NkZBcWtYN1pkSnhUTnBzRmxSWkNLQVRRNUdtSmFRZlIxcWdzVkZsd2JBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MmxobDZxcjlVZmhXL0VuMjl0UFhBL3FlSHhOL2Y4NjhsZFhWVkpSVVh5MEVY?=
 =?utf-8?B?VFN0ckRNNUpqTGc3N0lkWEo3cDNTRXE2bTZ3MkZsZlYzRG5TTkt2ZDFZRUpn?=
 =?utf-8?B?VzRERDZZNEJEckVDZERsdUdHTWQrbm1mTnQ3enltOGVxcTgxRTc0NVBaZm1W?=
 =?utf-8?B?T004a0RzcHU5TlhXTUxUTk1VNHM1UWkwNVh5UFhLOVNVd29VVWhqSzQyZEIz?=
 =?utf-8?B?Y1h5MEJITWNudzVjRHJPNkVyYmNESUxUakI5QUhKOTA5SGV5VXUrSG1zb0Rr?=
 =?utf-8?B?MTVZZEdGTlhCNG5JbzZ0eVoxRUM4YkpkakhYam1xK2tWWUo4Tm1RUTdmS2w5?=
 =?utf-8?B?dWRDbVd1RGtrMlU3dWVRSkFJUzRDQ2RNeUdFQ2tnSXFTRVdQOFpvd2dxblE0?=
 =?utf-8?B?cEZESzZPUnZ3eFdDak5kbWVDTFNZZlJSZVRPVy9hNUtqeGxSWUhvcjlHeUlM?=
 =?utf-8?B?UDNrclJqUzNmdThhMnB6TlBaeCtKMHZab3dUd3lDcTFnM0VjQmRHb0RGeElE?=
 =?utf-8?B?UThEalU2cXVqbWdxSWtIK3Z3VlNkcnNRcnNYUCtHdExkOGtHSmFxRjFiTmFM?=
 =?utf-8?B?eSszNDhmU0tHc0s4dnVKVHA2OVJKNkNjRnVTTDJxYnlzMXpYZ3U5Y1FaVHZr?=
 =?utf-8?B?d2VYWFNkTHU5anBDRU1xOHlycFNVU0dVcWU1cmdEZGw5VzRYYWFCVm9JWTNT?=
 =?utf-8?B?NlMxTGtTaTBmTGY4dlZwcXFSYWNYNG80YWRYcEtsVHBjRGJacWNTZTZQd2R6?=
 =?utf-8?B?b1VsNU4weUZ6ZmROeHpNQjlGdExDakRuZ0FTQTNvdHluRnlXSG80K2R6L1hj?=
 =?utf-8?B?RDNma05TYXhsV2Z2NG4rOC9vQTFHWTg2d1d2TGQvcERSNnN5aWsvc08yTlRN?=
 =?utf-8?B?NlNONHFqcklVeUIxMDE4ZTJlT0pKcno3bjlkOHZvY29aY2dZOXRwdysrcFZY?=
 =?utf-8?B?Q05PVUpnNXRCK3JSdnlKQTRVQ0hsejJqdlI0KzNLUE1ja3VHRmwrUkxmRU11?=
 =?utf-8?B?cmJhTFllbTRXd0JWVGF5RHFySkZ5U0ZYZ1JGelpTQ09jeU5STnhIbjhlT2s5?=
 =?utf-8?B?cHlPZVdGRFU0RnpqT2t3djhlOC9CdllBYVJxWG1CeG5KbFVuZ3lUT1lYUU5v?=
 =?utf-8?B?UzN3MnZEekpvRnB4T0UveHhxWHhyaGllTXlNM2l2MkJ0VDArZEpxMkRwdjRJ?=
 =?utf-8?B?QzF4VHFrVVR1SDQyZzVjU3R2Y0txQUw5OURIS2FjdXhHY01GR05tWGtuVk5j?=
 =?utf-8?B?THZNZmtkeXhYTXBaenFuMG9vT0g2T1ZxU1NOcXJIeTlsdHBKdy9YVW5hSENm?=
 =?utf-8?B?ckhCUzBkRSsyWkYvUkpteDNicGhJL2UvSC8yellhVE1NQ21SS21MRXpOOUFp?=
 =?utf-8?B?UE51KzhKbXRnSDV5RlV4YkZIZWlZU0luOUx5L3BQdnY3M2QxZ29FMldkUmM0?=
 =?utf-8?B?eEY5TVJPV3ZLTnBSb1NORkpSQTZJUHZmdkdHazhUQ3dnUjNIRzBFRDFSQkUw?=
 =?utf-8?B?MTF1M1FkTGVlNjg3UmZ3V3hGUEsyZVk1SkhzOFFxMTZXcXlwamlHdllwb2tT?=
 =?utf-8?B?c2NXeEc3QTZvL1lqWlJsWWZKYXAvUFF4alZLVyszZlBtY1FUblVBay96RFI3?=
 =?utf-8?B?dXk2M01nTjc1ODdXM292Q00rVjdPNGkvTFNnUThTaCtoV0dQaHFWbWRBNkk0?=
 =?utf-8?B?eENobVYxTmZpSTFXV1BPcEE5UzZXdjRHMEZkamZBbHJuWTFXTUZpcWxYM3pp?=
 =?utf-8?B?dythbVorWUdIS0NmMlh4bk9kMnBnajIyOW5mTTNlV2EyYzkrcjAwUmNOMVlT?=
 =?utf-8?B?RytzZDhTdnU1djNRNUFpcXVENUw4QUFRaGJVelNCSWZXYi9pdnp5QWVvWEYx?=
 =?utf-8?B?Zkg5SzFPdWNyUHI2THBpelhoYS9yTElWU3lLMU9qdzZIaVBWcnZUSjhVSVhF?=
 =?utf-8?B?NXBGUTU0Titkayt4dGl4ejlZK2Q1V1NEa2RNbXd0VWVXSk1SenY4Qy9BTWZz?=
 =?utf-8?B?Q0JycGJpUDNEZFNGbWo4ZDBDcis5QmpmNkhhb2REMVJwckNoMVNlUjR3OEtK?=
 =?utf-8?B?V0tqV2Z5NWkybzcvR2JOTjl0NGVEYjZMWDJZRWZWb1BRLzJ1UlZlSytMaW9y?=
 =?utf-8?B?SWJoWDA2VWcrVGFKQlBEZHR3QnJyVDZWOU9ZVnNOUGh6K0dKajR1QkV4SWp2?=
 =?utf-8?Q?ozwAAk1b1m0KuyON2IPa0Rk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	VZ1aO6CPCZzETDkEkhKm5XFoStnkHdRlTZHqEuva6wBdDDPASOcJJ2YMbZQj34+anRxedHVCVDYDYo09bMQ24O48STLMc/KLR5Kd/XidJhAfWFbN8W14kceUGbseFXSfv6gtqStSXct2ftQKwBri2odGgbCUP2JqIm2fQfFywu+eAc34+MiBIxL3U9rD6Xh0NxG+M0LgC10OnhI3hDn7NtLHYowrQqep5/98aFWc7B1rFeZRwBnnQPuRP6+tp2OV8VzRyowiyTGLN0v51F4kFpdtCshhpkRbtZPkpB0Yjn3Cmz92pMR9z2prKCkVkHdg1v5OODPzvqqRrW+Qoz7IzJ9/M55JtwTHJXGHlztU3E42Lumr1h95hsa8vuQ3iE9x/L9jTrY8FKKbkuziB0yBVs1483nZlwCroIzCk4w04eo5EvphU/485/oOGu49TLEpURJsAQGYzEs9mSrI6vdLu4x55yo89UhfjExC06lhuJT0u+Z/enrBIvEPpPNihc6cL3G0uNMVwoO5iT08e5fS135Zp6qxyG1UI+RsZIDyj+khmtB2v73WcqWBvcm4jHODYlI3q0wAV3LeWcx+DH7fBIwow3jYNyKPD+5ZD3H+rOY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7879ce5d-2211-40cc-dcd9-08dc7b1347ec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 10:29:52.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m39c/527WTsfYtINrDambI5aNZYn8DK4NtuiBn85DhGRQ2+z8zQhcuF/OlQVWuHV493xgyso3IoOV6icn83YwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_05,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230070
X-Proofpoint-ORIG-GUID: 5N3jsqJO9_8H-o957SesOpfgmi3Z0V73
X-Proofpoint-GUID: 5N3jsqJO9_8H-o957SesOpfgmi3Z0V73



On 5/22/24 12:07 PM, Eugenio Perez Martin wrote:
> On Mon, May 20, 2024 at 3:01 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add VIRTIO_F_IN_ORDER feature support for the virtqueue_fill operation.
>>
>> The goal of the virtqueue_ordered_fill operation when the
>> VIRTIO_F_IN_ORDER feature has been negotiated is to search for this
>> now-used element, set its length, and mark the element as filled in
>> the VirtQueue's used_elems array.
>>
>> By marking the element as filled, it will indicate that this element has
>> been processed and is ready to be flushed, so long as the element is
>> in-order.
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c | 36 +++++++++++++++++++++++++++++++++++-
>>   1 file changed, 35 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index 7456d61bc8..01b6b32460 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -873,6 +873,38 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>       vq->used_elems[idx].ndescs = elem->ndescs;
>>   }
>>
>> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement *elem,
>> +                                   unsigned int len)
>> +{
>> +    unsigned int i, steps, max_steps;
>> +
>> +    i = vq->used_idx;
>> +    steps = 0;
>> +    /*
>> +     * We shouldn't need to increase 'i' by more than the distance
>> +     * between used_idx and last_avail_idx.
>> +     */
>> +    max_steps = (vq->last_avail_idx + vq->vring.num - vq->used_idx)
>> +                % vq->vring.num;
> 
> I may be missing something, but (+vq->vring.num) is redundant if we (%
> vq->vring.num), isn't it?
> 

It ensures the result is always non-negative (e.g. when 
vq->last_avail_idx < vq->used_idx).

I wasn't sure how different platforms or compilers would handle 
something like -5 % 10, so to be safe I included the '+ vq->vring.num'.

For example, on my system, in test.c;

    #include <stdio.h>

    int main() {
        unsigned int result = -5 % 10;
        printf("Result of -5 %% 10 is: %d\n", result);
        return 0;
    }

# gcc -o test test.c

# ./test
Result of -5 % 10 is: -5

>> +
>> +    /* Search for element in vq->used_elems */
>> +    while (steps <= max_steps) {
>> +        /* Found element, set length and mark as filled */
>> +        if (vq->used_elems[i].index == elem->index) {
>> +            vq->used_elems[i].len = len;
>> +            vq->used_elems[i].in_order_filled = true;
>> +            break;
>> +        }
>> +
>> +        i += vq->used_elems[i].ndescs;
>> +        steps += vq->used_elems[i].ndescs;
>> +
>> +        if (i >= vq->vring.num) {
>> +            i -= vq->vring.num;
>> +        }
>> +    }
>> +}
>> +
> 
> Let's report an error if we finish the loop. I think:
> qemu_log_mask(LOG_GUEST_ERROR,
>                "%s: %s cannot fill buffer id %u\n",
>                __func__, vdev->name, elem->index);
> 
> (or similar) should do.
> 
> apart form that,
> 
> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> 

Gotcha. Will add this in v3.

Thank you Eugenio!

>>   static void virtqueue_packed_fill_desc(VirtQueue *vq,
>>                                          const VirtQueueElement *elem,
>>                                          unsigned int idx,
>> @@ -923,7 +955,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
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
