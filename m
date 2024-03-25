Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A03B5381B
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 17:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711388101; cv=fail; b=XayEn3LbNF6BXLSJWIx0ktUPAJQnjvJczeV1J60t8fo0bDmG22EC8khD/J+xUf+laOlnPUkzbTF4PPtdA48hbKQjApg8iPEx5OI6hNhoEu/R/VnmWMPjBLjrujLV9WCCsILVdvCdm/wP5qeJuKd+IXiU0KdCy6tcU88otiSGu8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711388101; c=relaxed/simple;
	bh=3//I6q8B0rLLqpZvXEn7Z28STCECS6KwEudFzrYm0ME=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bAQ/2pOtNgzR+PIk33+Frj41D9HN9EO4LgODf/yW1cg88Dz0Dp2QiwHYKmpGzGYxNXOmXBzwOlYPG3MBMX5WhU2GfAiMITelSPE749WTaY45R4G8FxEWnada3SNLJx/7QLR+d+pQW0/+MWVNoPFF7yPFL5KCPF2wJevOUNX5b6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=giYRcvQn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=faxdaMQv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="giYRcvQn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="faxdaMQv"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PHRVXV029498;
	Mon, 25 Mar 2024 17:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=kowof4zSR2s+0VstKOOEps4zszM/DpB5XJ1WngSV670=;
 b=giYRcvQn3z3qcgO/Xb17wkCiJe0MdvuQhQLOeW3W47ctTtwx+Ci4i9xRdD2CwukIpYKL
 CUChqvHqDtdZb9kMl5+UQnLttEmMgikKg47rkdmd0MkcTt+mUOX7AKPJqJzdRzpPygj3
 8N5tG5r+rISIipFbYPTcNj+rlguMtK/qgo2DzolGFo5AmLUr6LDIWwFJf+Xxve04iYpB
 zSUOe3CC5MYjDpU+7eoUJ+UTlSpn/0S1LjSH88sB0q9iappyKIzpPlT13UYLqnb7+a0M
 YlfEbP9MXjyeoQXpA/hM96AzX3fWU34BpalwH2IskC8NdVgOSLvPUUQr1CRvetne81nb 5Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1q4dua3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 17:34:54 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PGkM3I020231;
	Mon, 25 Mar 2024 17:34:49 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh5u0w5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 17:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGk2YP9vEQ7TeQCtkoc5Z9H9BgxixNVOfFsbd4SZ0WGPen41MeOPr4/HFOzrxVkc0wlFOJi0/xv+zsacuZaN4ip7+p9e2RPf/Zq6v9BCHEfUt+LV6UW2MpajfDgU6LmRiINlaxvOz4a/IaiqCvmA8tXJN0DXUMOQiPpnJP+fxwOpTpzg68y83mvNpfJ/yNq1WbRvVcI9rVr3ksI4IAXr1cdBW665a/7bOp27xTOogUFlB7qHTs+V91F9FIA/AWFaT+j1euVY00/fu1OE9M3KhjbbpNKx8uI9cQSCM4pHs6Ro1DLKlLe06ubnFIcanLq71ufWT82J8gzSIPbWS8iOhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kowof4zSR2s+0VstKOOEps4zszM/DpB5XJ1WngSV670=;
 b=ZvcA/3evbFn7RwSECCiPuAGSKtps/BV7yhu3zCCkkUvQjZ4Q/uYb2srnY48BfT+KzgtZqHQfU0FklNgJxVaLCjzPjbj7+tKMA9fSIjO+owVGAYycVuNhzrfgwLjifmqPwIDy1RJIN0u3MOnj+Evj6Vxy3nm3+nNlCpaQoOAlGDb/qzqS9uBaB4Noqs+Z6jNZuP5LGRIPvlr1MbzfD2gYA1/WQmndpg5+isV758JoLkx1wBPlKCEAMtoIBf+EqcdYgbqeWWJslaa9elMi8pyMsV+fpSjz8D/mfiSjMSDsz+YfofQcSsknyi9UaAiQHJT+AL0aeIDZoU9CllayllTGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kowof4zSR2s+0VstKOOEps4zszM/DpB5XJ1WngSV670=;
 b=faxdaMQvCRFg0NlYGuDFYYMrHl5NCModMkLHQdRTGTGTw3Ha8TpUNPwCk7TalEQbYDSYCLMp+UCO+7LfNym+WmQvwMKdA3QCS7hXSbcJ1D6kM1iuPSd9Jj8EJBGuco3aVs4n+6DpQGLVplqX2bkZ2zpVqtVXNGmfssbIFs8OYrM=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by LV3PR10MB7819.namprd10.prod.outlook.com (2603:10b6:408:1b0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 17:34:47 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 17:34:47 +0000
Message-ID: <b12559db-fc07-4fec-92d3-0e492ae34947@oracle.com>
Date: Mon, 25 Mar 2024 13:34:42 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 4/8] virtio: Implement in-order handling for virtio devices
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <20240321155717.1392787-5-jonah.palmer@oracle.com>
 <CAJaqyWedsT+0DT-SCAH7SMFnuWHazTsbe1kNC+PENDSxvu3W0A@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWedsT+0DT-SCAH7SMFnuWHazTsbe1kNC+PENDSxvu3W0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:a03:254::25) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|LV3PR10MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: def11f73-e8b9-4e67-8dea-08dc4cf1dd91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+4XznSQ7gdj6YM/oaGS4Ni9VXjg3UjJkw71Mo30rQLzjR4/R4tnMGdVkRHerQsBhOtcKsW6VGMzKQdmgNnNoW511NbebaRW1p7tp7kaia/MoJ4nPLgz/WSKIMlBZnHBqGteMNpJ7Zrt02oJe651y3SHZPJ0fpJmRcEc1TzxD3OH30RWFDmwhZPyLaXdbj6ZB/IYokVEUkT8j7t6gdv9hP31SkZbKRaYwHCrJoxVOoXFLFdxgtmBV7Z3UGtM11LKx+ldte6awwD25HgmShiNIodhnODeu7KaRon4VMpz7H1Uad5oM9H8Lhm4aT7I3KqOuxHG7pL5ZBHfAOgrVeQS/jPgRyLkTvA23Y2ITk0dlltRU2DUxaDercsgkKz5FslrA7h0RSyOYHnCmLnrKsASrai1cAijNk+kCyUtEKRYcFSSQK2s3QDiQE6auPU3Hd6ZcMalNoF2w3cR+ocxqiXJzkoSE8eYVtv0zyvbP8zGWGx3S+P1zLrXNmOBtPP89L+ok3SfN/fBsCkg2V05dNAm33BckbVG9VVb2dFo26kpTAU8vWhhXvZZFwllr8Sw0NOmOOaJXne4jFqAqVBRwKQilxG7gzq+fbrE45kPxi9oryPZGp2sWosFgbJILxLATxKX03JdrYlR6r6nKzHTZ4cRRrqyEWNWO4fHeup71xlNtLUE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OEtqSHV1N3JPWk56ZForOCtBV2sxMExnRUE3a2pqQUJyeFJkMUhJQ3ppVkda?=
 =?utf-8?B?dWJWc2hYY0FvNkhJQW05WkNJenNjWTBTeVNJTXVqK1k2dyt2STMvblk5VFhF?=
 =?utf-8?B?SEF4ZFhOMEdTTlk4bU9wUnFScEM4ejVjTGt2Z2E4eXhzaDRTZWFabWM4SGxr?=
 =?utf-8?B?cWZFZWdrL2JFVVV2ZmlVeDhsN1g1V2ZmV05WY3lkYVlqS2ZoR21uVEEvaW1l?=
 =?utf-8?B?VFF1VE1vOURpWitvaXliOVlNMGFRdXVITWRSZFM4L2FpN1V1VzQ3c1hDWVF0?=
 =?utf-8?B?YUNyQURjRXF5cXJza0lxMXNFTDlKeDJSNGNndytHbFZJa1kwYnlmNVhWSGhk?=
 =?utf-8?B?ZXp2Q2xrK1Ira0RoWnRvUUIrc1dSMUFHdEl6VmNWVXFlN0hVM2doTkwvL0pW?=
 =?utf-8?B?YmVva0dBNzR3bGFVdDV3Y1VQRmtsRXNaQXd4OURXTjNkNXkrTjBHMGNwUWdB?=
 =?utf-8?B?MXNUNndzU2pPU3BLcERGMStQVVJKbVhPR1liTTUwS1Q4b0ZWZVVjWFU3OTRw?=
 =?utf-8?B?ZzFXSVljdkJ3YXZRVlY3ZnZqMlZ3QnhTMG9seEVlOVNLY1FVZi9nUHJKUkty?=
 =?utf-8?B?VmJmZDdvclpVN2k5ZVZYK0V1ZFBvNWp3c3lSNHUzYzJ6NExYZFpudjA4V3hm?=
 =?utf-8?B?R2QvWFdtODFnN0lCbkdXdmJoUWNPd2RvVUlsRTJQbTl0TldSMmRnbXpMVk90?=
 =?utf-8?B?TnN6UGtrbXpCaU5YdmJWK0x2RWp3VWM5ekFGMkhvVENTY0NHMUdnUnBVdlNQ?=
 =?utf-8?B?aE1QY2JoYXpSd0tzd0pXOHYwaitPWXg4NW5wK2hCVGhhTUZXejFsMDlOR3ZH?=
 =?utf-8?B?d2Q1TGJ1QnZaM0N1b29qc0hkbkt2TUlDRG9wbklDaXNmTlZWb2F0cGlaNTVa?=
 =?utf-8?B?dzM2aGM4UGdQci9ZVlh5L0pWcUJQdG1jY21IMHhyMlJPZi91SmF1d0J2SUFt?=
 =?utf-8?B?MmRtNmt4YUFsRHQyc2x5YTVZNmI1ZURPVm9hNDMzVnNwTVpMVnNHN0xmK3V5?=
 =?utf-8?B?VlF2MEdaN0ZKVUFTeDF5UUtvYS81RGpCY3hEbWNGZVpGaWUyVUQxalZrcEcr?=
 =?utf-8?B?bGhCV2pURnZidzFhQ2pNY1A5amJDcTJueStlMVhGeDdSOStMTVY1NXBpRWtV?=
 =?utf-8?B?TXV1MUlwdm9UR1JPaTNxNXlid05ueXo3R2h1WVhPRFp0UjM4U3RwM0lwUDhj?=
 =?utf-8?B?N3NUTWtVWnM5V0JKYjJNREhOT1JPQW5qRDkwZGJmaXhBaFVXU2w3RmFDa3ZN?=
 =?utf-8?B?L0UwK1R2cSsxbS9ENmxjZnU3Y1FhT2Y4a1lMalE3dCtZT1ZFSmFzNHIzdVNr?=
 =?utf-8?B?L1RwUFVPRkZNQTlRWnAza0ZqSHl1VEVkZHZzUnQ0TjdMSXdiamVKVklBYk9v?=
 =?utf-8?B?alJpb1l0ODRINzZmbGdFQmRnaTB5b2ZjbmJ3YjluaEc0bGZmMjc5bml1ZTJH?=
 =?utf-8?B?YTNtL01pUkVpaWlsMnd2ZXhlSXVvN2JYMDE4QVBuempzRGFDa0lHTkpFTWl1?=
 =?utf-8?B?TTZXdmJmdkFveTM1c3RMcFNRelF4czFQbW9ZVTllZWFvZWs5YzByRGlPUHhE?=
 =?utf-8?B?czV0Vk5rUEhQK0c5UzBHdkhUMUhlc3QzYTlkS2ErYllmRFpRQXJTSUtHSGYz?=
 =?utf-8?B?N2NyRWtrY3NOcXhtc21oRnJoYUhmWkZLcGcvc0FZSXVSVzNMWk1VYnlFOFBv?=
 =?utf-8?B?N3JQUmFKUVVqNytSOFpudkt3ZHZZanB4d09McXJteU96SHNTaG85QWpzT1Nv?=
 =?utf-8?B?RVF6NURZQ2IvWjlkVko0RGxyS1NwZFhDY1VmQnQ2TGlvV2ZucWpMMXBzQ0hK?=
 =?utf-8?B?bXdVREdvcmlIaGs4S0E0WVJNSWxiV0diWVdzdEpOK2NyNi8raStEdUduSWhT?=
 =?utf-8?B?YVFYUmYxNHBsWGdsUVEvenBLaGhhZ2xqYmxNaEI2enJxSEE0RlI5amN0WEZn?=
 =?utf-8?B?SkNJU004S1B2U2NtelNnU2p4RFJ4T25nZ2x0ekN3VjRzWTd6RFlxTnllcGVl?=
 =?utf-8?B?VjZMQWR3U1g2ZzlWR3doUEhDdndMMmFXMGlmRlpOVFRrY1YzSkxkSldsalpX?=
 =?utf-8?B?MGl1aW9oM2k5a3BoMEVMSzNyVlgrWFg1b1BMWFBlcFN1M1pNN3dKOHUvTnN4?=
 =?utf-8?B?cFJXNVQ5a1dDbVRmUXJWejNkRHdzbFIwMFdSalhXTkNyOHFucTlHYkx2UkJU?=
 =?utf-8?Q?29VMNzFCoM9F+7NindDjcaE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/mpDC8iPQUBsL+4LPxwRuyEubUhhwtLVTC7buuHSoS2A7g1CyPbaE04dFvnLMhuR4e7QrqAXYKz22PeovczDIwXyJfS1WK5jqelCYDN2eh2MKVy3HAZNUhjsPts7q3VmiphdWK4yi5+D3S4TXQf6GNw/vvlPYPTT7z3iFo0iqw1Y3Q+drOhcxMWiaZQGRPRRWiC9YTiYJBEofhIYGzAmsc9ky9bE65a4DQFk9JGusxA7Hg+JDVm3Z9+2Wa9uUpwc9uTNYNJq5xozXv5iak5vfmbs0v+k6/rEu4F5fQrovDhdfDY1znqsscqcgTrUwQxNCBfwDwbeiY9lCZOYOrPkvhT+pkB+bc6pwbQTYO/Vf0DuEDVlDU3LI6Hyz4Xtd3Vh3mrKfIp0bQnxTLasOUeiiQttgrZIyG39QtvIoRnyudFMcdRcrK982ubF0aiBH42lkNI29RjXEs5ZKg0GFS48YGZfnrfZAvmM2YmnRFpx6YjUnNUdV19441pjSJPPtuTuhdjGZu6Wxc7pjaml9DcRx7/aISVsNntXfjN23TOvM6hJUvlhg+nlzwqgED5W7XgRe0+OjkeB84xK/slCjok8MuJ/T3qet3yL2GfHwMrPqsA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def11f73-e8b9-4e67-8dea-08dc4cf1dd91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 17:34:46.9333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dyTRPh8A3nPaGGpehHrZ8naSAAM4V6XtT+ueETbl80405tsm09oUng0hQLXwnyRbfWsW2PqX+MrWZLKjnzQbaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7819
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_15,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250101
X-Proofpoint-ORIG-GUID: d3J4PvwJH67BNpF-StTH0fIybj1Un4S1
X-Proofpoint-GUID: d3J4PvwJH67BNpF-StTH0fIybj1Un4S1



On 3/22/24 6:46 AM, Eugenio Perez Martin wrote:
> On Thu, Mar 21, 2024 at 4:57 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Implements in-order handling for most virtio devices using the
>> VIRTIO_F_IN_ORDER transport feature, specifically those who call
>> virtqueue_push to push their used elements onto the used ring.
>>
>> The logic behind this implementation is as follows:
>>
>> 1.) virtqueue_pop always enqueues VirtQueueElements in-order.
>>
>> virtqueue_pop always retrieves one or more buffer descriptors in-order
>> from the available ring and converts them into a VirtQueueElement. This
>> means that the order in which VirtQueueElements are enqueued are
>> in-order by default.
>>
>> By virtue, as VirtQueueElements are created, we can assign a sequential
>> key value to them. This preserves the order of buffers that have been
>> made available to the device by the driver.
>>
>> As VirtQueueElements are assigned a key value, the current sequence
>> number is incremented.
>>
>> 2.) Requests can be completed out-of-order.
>>
>> While most devices complete requests in the same order that they were
>> enqueued by default, some devices don't (e.g. virtio-blk). The goal of
>> this out-of-order handling is to reduce the impact of devices that
>> process elements in-order by default while also guaranteeing compliance
>> with the VIRTIO_F_IN_ORDER feature.
>>
>> Below is the logic behind handling completed requests (which may or may
>> not be in-order).
>>
>> 3.) Does the incoming used VirtQueueElement preserve the correct order?
>>
>> In other words, is the sequence number (key) assigned to the
>> VirtQueueElement the expected number that would preserve the original
>> order?
>>
>> 3a.)
>> If it does... immediately push the used element onto the used ring.
>> Then increment the next expected sequence number and check to see if
>> any previous out-of-order VirtQueueElements stored on the hash table
>> has a key that matches this next expected sequence number.
>>
>> For each VirtQueueElement found on the hash table with a matching key:
>> push the element on the used ring, remove the key-value pair from the
>> hash table, and then increment the next expected sequence number. Repeat
>> this process until we're unable to find an element with a matching key.
>>
>> Note that if the device uses batching (e.g. virtio-net), then we skip
>> the virtqueue_flush call and let the device call it themselves.
>>
>> 3b.)
>> If it does not... stash the VirtQueueElement, along with relevant data,
>> as a InOrderVQElement on the hash table. The key used is the order_key
>> that was assigned when the VirtQueueElement was created.
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c         | 70 ++++++++++++++++++++++++++++++++++++--
>>   include/hw/virtio/virtio.h |  8 +++++
>>   2 files changed, 76 insertions(+), 2 deletions(-)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index 40124545d6..40e4377f1e 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -992,12 +992,56 @@ void virtqueue_flush(VirtQueue *vq, unsigned int count)
>>       }
>>   }
>>
>> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *elem,
>> +                             unsigned int len, unsigned int idx,
>> +                             unsigned int count)
>> +{
>> +    InOrderVQElement *in_order_elem;
>> +
>> +    if (elem->order_key == vq->current_order_idx) {
>> +        /* Element is in-order, push to used ring */
>> +        virtqueue_fill(vq, elem, len, idx);
>> +
>> +        /* Batching? Don't flush */
>> +        if (count) {
>> +            virtqueue_flush(vq, count);
> 
> The "count" parameter is the number of heads used, but here you're
> only using one head (elem). Same with the other virtqueue_flush in the
> function.
> 

True. This acts more as a flag than an actual count since, unless we're 
batching (which in the current setup, the device would explicitly call 
virtqueue_flush separately), this value will be either 0 or 1.

> Also, this function sometimes replaces virtqueue_fill and other
> replaces virtqueue_fill + virtqueue_flush (both examples in patch
> 6/8). I have the impression the series would be simpler if
> virtqueue_order_element is a static function just handling the
> virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER) path of
> virtqueue_fill, so the caller does not need to know if the in_order
> feature is on or off.
> 

Originally I wanted this function to replace virtqueue_fill + 
virtqueue_flush but after looking at virtio_net_receive_rcu and 
vhost_svq_flush, where multiple virtqueue_fill's can be called before a 
single virtqueue_flush, I added this 'if (count)' conditional to handle 
both cases.

I did consider virtqueue_order_element just handling the virtqueue_fill 
path but then I wasn't sure how to handle calling virtqueue_flush when 
retrieving out-of-order data from the hash table.

For example, devices that call virtqueue_push would call virtqueue_fill 
and then virtqueue_flush afterwards. In the scenario where, say, elem1 
was found out of order and put into the hash table, and then elem0 comes 
along. For elem0 we'd call virtqueue_fill and then we should call 
virtqueue_flush to keep the order going. Then we'd find elem1 and do the 
same. I have trouble seeing how we could properly call virtqueue_flush 
after finding out-of-order elements (that are now ready to be placed on 
the used ring in-order) in the hash table.

>> +        }
>> +
>> +        /* Increment next expected order, search for more in-order elements */
>> +        while ((in_order_elem = g_hash_table_lookup(vq->in_order_ht,
>> +                        GUINT_TO_POINTER(++vq->current_order_idx))) != NULL) {
>> +            /* Found in-order element, push to used ring */
>> +            virtqueue_fill(vq, in_order_elem->elem, in_order_elem->len,
>> +                           in_order_elem->idx);
>> +
>> +            /* Batching? Don't flush */
>> +            if (count) {
>> +                virtqueue_flush(vq, in_order_elem->count);
>> +            }
>> +
>> +            /* Remove key-value pair from hash table */
>> +            g_hash_table_remove(vq->in_order_ht,
>> +                                GUINT_TO_POINTER(vq->current_order_idx));
>> +        }
>> +    } else {
>> +        /* Element is out-of-order, stash in hash table */
>> +        in_order_elem = virtqueue_alloc_in_order_element(elem, len, idx,
>> +                                                         count);
>> +        g_hash_table_insert(vq->in_order_ht, GUINT_TO_POINTER(elem->order_key),
>> +                            in_order_elem);
>> +    }
>> +}
>> +
>>   void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
>>                       unsigned int len)
>>   {
>>       RCU_READ_LOCK_GUARD();
>> -    virtqueue_fill(vq, elem, len, 0);
>> -    virtqueue_flush(vq, 1);
>> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
>> +        virtqueue_order_element(vq, elem, len, 0, 1);
>> +    } else {
>> +        virtqueue_fill(vq, elem, len, 0);
>> +        virtqueue_flush(vq, 1);
>> +    }
>>   }
>>
>>   /* Called within rcu_read_lock().  */
>> @@ -1478,6 +1522,18 @@ void virtqueue_map(VirtIODevice *vdev, VirtQueueElement *elem)
>>                                                                           false);
>>   }
>>
>> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
>> +                                       unsigned int len, unsigned int idx,
>> +                                       unsigned int count)
>> +{
>> +    InOrderVQElement *in_order_elem = g_malloc(sizeof(InOrderVQElement));
>> +    in_order_elem->elem = elem;
>> +    in_order_elem->len = len;
>> +    in_order_elem->idx = idx;
>> +    in_order_elem->count = count;
>> +    return in_order_elem;
>> +}
>> +
>>   static void *virtqueue_alloc_element(size_t sz, unsigned out_num, unsigned in_num)
>>   {
>>       VirtQueueElement *elem;
>> @@ -1626,6 +1682,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           elem->in_sg[i] = iov[out_num + i];
>>       }
>>
>> +    /* Assign key for in-order processing */
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        elem->order_key = vq->current_order_key++;
> 
> Since you're adding this in both split_pop and packed_pop, why not add
> it in virtqueue_pop?
> 

I wanted to add this order_key to the VirtQueueElement after it was 
created. I suppose I could do this directly in virtqueue_alloc_element 
but I'd have to add another parameter to it, which might be unnecessary 
given it'd only be applicable for this specific in_order feature.

I also suppose I could just capture the VirtQueueElement being returned 
from virtqueue_packed_pop/virtqueue_split_pop and make the assignment 
there, but it felt out of place to do it in virtqueue_pop.

>> +    }
>> +
>>       vq->inuse++;
>>
>>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>> @@ -1762,6 +1823,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>           vq->last_avail_wrap_counter ^= 1;
>>       }
>>
>> +    /* Assign key for in-order processing */
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        elem->order_key = vq->current_order_key++;
>> +    }
>> +
>>       vq->shadow_avail_idx = vq->last_avail_idx;
>>       vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
>>
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index f83d7e1fee..eeeda397a9 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -275,6 +275,14 @@ void virtio_del_queue(VirtIODevice *vdev, int n);
>>
>>   void virtio_delete_queue(VirtQueue *vq);
>>
>> +void *virtqueue_alloc_in_order_element(const VirtQueueElement *elem,
>> +                                       unsigned int len, unsigned int idx,
>> +                                       unsigned int count);
>> +
>> +void virtqueue_order_element(VirtQueue *vq, const VirtQueueElement *elem,
>> +                             unsigned int len, unsigned int idx,
>> +                             unsigned int count);
>> +
>>   void virtqueue_push(VirtQueue *vq, const VirtQueueElement *elem,
>>                       unsigned int len);
>>   void virtqueue_flush(VirtQueue *vq, unsigned int count);
>> --
>> 2.39.3
>>
> 
