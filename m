Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA0D13D29A
	for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 09:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716458125; cv=fail; b=JFYyXjZNASjGqvvBGWz93T8GxcPRGpnxi+v8k8XxffHfklbOdBHzXksFRHJQZvaaRa2Xm9OD8BJ8Ag00FeuRnRmGfmCHU1mCOgpnepwVbhEGORaPsLCXB4jYI0JTRGYigStyeQWnAywGOwLq/3yINCAXYvrIYDclZ8yUNjw8auo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716458125; c=relaxed/simple;
	bh=qxGOvRE/uKLcQ7lCx/BTPp3yhQ6pzefdIR8aSjrBPoM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SB700kYMn+mlNI4GB+FUAsfgfaL8krad6TMXh/IENqJpKOMbOK4lXaw9MGJjYEibX4KO4QGdAeOWVk6QKRkxzaMG+Iah1UiyjiSC9RVV9LM24W4t+oR1tp5MuiE+PdbftopVkPPFPEpqttaI3FUtnGaqmfyqJoqE1WJy9IAHvWU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eE9UM6nz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZydKY3Lo; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eE9UM6nz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZydKY3Lo"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44N7a0D7019750;
	Thu, 23 May 2024 09:55:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=lvpxiFCPiKvz9b9C7opm6TxGcQ3q/BqmmTWAw6brSVk=;
 b=eE9UM6nzN0zPuETchF2Zigtbz21yKTdbTvJtnrNk9/HFVr0nQ5vKVOVQHa7XKEahv+0X
 Zqb61f62T/OCiHJRf/HawtWeOu7F/+jj8x87T3G+XITeruhnXusgMuUQUDvC0+fmUxt7
 YH3jfRE5ZtuMue3rKNuTdSpHGPnPf2uaf/jI6uZTx8/pj7VZFjkF4UCgTUkDy1fyRKGi
 VT2idDJwKHvqOt8vNHYPP+If2WXz0mjqEMbxlQF0kFkfTJNK/zrJcZYslRhDFAuPcoLY
 3O0gyFoGntLnZ6WbP4Rb+3Gh5Fmo8dzwJQUVSFvA8GsDmt9XY1qah1QQlcFfEqAOrCdN 5g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k469rj0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 09:55:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44N8eNBA005048;
	Thu, 23 May 2024 09:55:14 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsapd39-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 09:55:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G82aTMBithLNmDoHewu6HRvbbt6A4ZczEgyHujofeqhegfhTNggwL2xOEWcyhZk827zWuQMskwilCKXnI6RfXmrRgszNypIVjqaD2Q6IaiYABU8/uOBlkQgr4K5gTRLM2h9uh3T6LZUCqJ3YJTNKm8EDgXsrt5/VIrFEOph+LucrEtBLt8yY20kWIVh/gS+dQE8OzwSS6pEXty8kSh+4Yae+tItLQehPhq+rmS/0NrvcjgWrl+CQw3h86nRrt0cZnxSsHAF9xlI0jT2qFsYsDeOZ4h+KP3hkcmXSX+1NUbVyHzmBxE/7IQl/qLXKhGnFJBxVFj1sW5YoMDYTeb4rIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lvpxiFCPiKvz9b9C7opm6TxGcQ3q/BqmmTWAw6brSVk=;
 b=bzBn7FuNEWQftbYQ+KZzosEhvmiZvHw45K9eY5rgWOurV1ZgGr9V/2Qn8nv+2rtRdX8F9sfGC5CoCWUGRngtEcRGNIyXCCDAkD8OErobM89ddWGd3Y8T8haphdhdl6SI4lLwqgdzyd2VPC1T7whtRe1xfsqZzl/WqJkl6JbsPBrbBdNhk5W/vaBBL5NhCYo5uL64U+5juM+tcKVO7OkXFpluRirCJFTKfo42gkvnbCOVc0nDZWqHsXPCFJGS4+AUDXtuL9u2Z5gN/Idx3Ho3gTEZ8ssNwQqxqHvYlKxfKo1ikbG3OxM/waxheYggEoRFCPX813qJzuv3jxF5u8Q0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lvpxiFCPiKvz9b9C7opm6TxGcQ3q/BqmmTWAw6brSVk=;
 b=ZydKY3LoEgdG7wrn5NVlZ8ncYQqkKxZALCGj7soHe0sX2Q/1mdv06RV7w7yw+anZlWUrQe6jAi00UAvGCkA76NQXy9Jl/SQxzxoL/31VPHb0H99sxGLEr5BRy7Y7VQd5NYOqrOu40WRzEm543mDqWd0WTQCzwDaUb9H3PgPik5g=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by BY5PR10MB4257.namprd10.prod.outlook.com (2603:10b6:a03:211::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 09:55:11 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 09:55:11 +0000
Message-ID: <5f5b47e1-4a39-4fed-bc31-45ab0502a7e3@oracle.com>
Date: Thu, 23 May 2024 05:55:08 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] virtio: Add bool to VirtQueueElement
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
 <20240520130048.1483177-2-jonah.palmer@oracle.com>
 <CAJaqyWcTh9YPMyitxoOZTxTjKishHCcNSz8wm1B2FRG4YdYGFg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcTh9YPMyitxoOZTxTjKishHCcNSz8wm1B2FRG4YdYGFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0247.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::12) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|BY5PR10MB4257:EE_
X-MS-Office365-Filtering-Correlation-Id: b3db7546-63b7-4d00-0ea7-08dc7b0e6fd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NW83ZzV3Z1o5WmVudHVsQzdZNFZsRVBwaHlBOCtlUVF1bXJjTXJZNTdFaEhq?=
 =?utf-8?B?bk9RdDh3UEpZMmFqVGRiL0N0VUwyVzdZRkpLZXdLUmlVTVZMRnVDRERNdzRD?=
 =?utf-8?B?MEZpMnFXTzd3QUhKeG43N2hZQ2JxRnpWNzQ2Ylh3T1J3RmdQbWNnazZuNzVJ?=
 =?utf-8?B?aGdPc1dlcE15K3hjamRLYUlvc3BMRElQMkV1enkxTXlxd01KVGxwWHhVQ1ZM?=
 =?utf-8?B?OHpFdGhaVzlyNWo2dWhOdCtLZmYzazF4UEw0ZnF2UlAwVDQ2UFZnSzhTR1My?=
 =?utf-8?B?d1VYczJJdmlMSmJLNTIzdkNCOFMxcnh1UkhndjEvNFZvWi9rOEdkMjZlcWxo?=
 =?utf-8?B?cjludGNNRVpaQStWR3V6N3B0UzVBU1VRL0VNSFIzdE5TaG1ZcGNkRjlhUHFn?=
 =?utf-8?B?ckZVdGRpZWJCbkhyVC9DV1o2eFdKclVIQmp0MTZRdE10VTJIQ0pJM0pja0ky?=
 =?utf-8?B?aTRKdzJZNXlDTno2dFEwRnNLdjZyQlRHY3YyL2wyS2ZmTm5LYkg1TStDRk9o?=
 =?utf-8?B?SVdRd2xHL01DMmNGbnBpdmRFanZrRkhHRGhtbUc4c1Zyb0lEZ0FFM2plTnFW?=
 =?utf-8?B?SjJDTmd6a29IalZ0Y05qVENmZG0vY0RCMmFudEtUaEY5RTFlQWVoOHIzU3Zy?=
 =?utf-8?B?bjRiTy9sTTQ1ckZRTmo3VDhBWER3d1lSUzBBd2lZVHlHOU1OdmpQWEhvVVNk?=
 =?utf-8?B?elo2NFJPVXdiWXJNajhWUUNVWTJFbC9BSURyYW9DdkxpN3VEcm5HREdWZ3Y5?=
 =?utf-8?B?azArMUo5SVptY2ZjVU5TcUpqZjVOT1BMd05KU0doVzNwQkp4QWw4WklramN5?=
 =?utf-8?B?R01CKy8zU1FxbmRybTNFOWZNcGxMOVZPVWRFa3NvU1JpUkhhSFZhRkJIVTZn?=
 =?utf-8?B?RkJobHp5NGE5WWlwZmxhMWRxaGxQbnk1MHArWFFjWUs5V1Q5ZzBpazZ0RXB2?=
 =?utf-8?B?UmU0VzJmeFNvSEZ6V1dTWFVkcGIwVnJQZTRtcEk5MTFDWldyRjlLMzR5RDlB?=
 =?utf-8?B?TGVJUjJjcVBCTmFLcE1hcEVIQk1qZE9DTUEzVnlnWU1xUDNlbVh4ajVEVGJt?=
 =?utf-8?B?VmRJaW12QXRzVEl0ZXFXanp4Y1RFL1VwVm9mV0RseW4wb3VGL1llZ0YzQis1?=
 =?utf-8?B?cm5MS2NTRkVCd01heExyTHhVYjlNTzd1dEpPWW03WEJaL0RROEg1emV3N3VW?=
 =?utf-8?B?QU9BSjR6ZWV4dm5yTnAyRUs3UGY2MzVWaVVWaHVQL1dMeVBXdTFOOWdqNlFP?=
 =?utf-8?B?RzBwS1A1VnhLcXF0Zy9UdGc3VWlvZ1BPdTI0ZkFxMk1RVWdkOW8rNVY2UzRC?=
 =?utf-8?B?d1hGbjZVbUJWak8xbXV0TWg4dlN0dC9hK1JlRzBmOVpVRys5VDVZLytJRmhu?=
 =?utf-8?B?elgrdEhPYnNEZlR1SkVPaEh2N3ptVjBNRWRNQVNSQmg4RCtKYlRzaE44OTJk?=
 =?utf-8?B?Y0NDRnNwUmp0MmxveFNsVzk4cnhZRSs4emc0dnFtVTBiYkc3bEs0R1Vyalpl?=
 =?utf-8?B?Wi9jdmJUYlRxNzJ2aGYrdnBJVXRYemxVOFFrNXJWKzM5R0JmaHhEbERKblUv?=
 =?utf-8?B?c0hPSFA1SVlxd2hsdEVhcmM3Njk1V3dkOUZpRE93c0c0dUJtSUdLWUtUZnEw?=
 =?utf-8?B?QXdwYk5XcDVvSGoxNGdCR3lSRjhXbUs4NEhxNVJkOGdUQWlDMmxHbXZtR293?=
 =?utf-8?B?RTJyZzJtUVZuTVByYVhTb3lGU3pBQ3ZqbnpkZjl4SDMzMGkyOGtic2x3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UVdzV1B4aDBiUTFkMHBaR2ZKL1NUQ01PMTdNR1ZFcWlvZkFTa2xOOGk2TXdt?=
 =?utf-8?B?RTZnWG9Ia0Y4bEp4bWppZXFGMnFFTXArTm9QN0ZDV0FWS2o4N0pLdEhiL0dI?=
 =?utf-8?B?MEJZRU16VUhyTnJhczg4enRIUE81S1ByNDRRb25SbDY1clpDeEF2aktvSlZu?=
 =?utf-8?B?KzBLR0F2encyeU5FaHJhdTArQkR0cFN5VlRrdHVDTTJLUzVqV0t3STFpdlNu?=
 =?utf-8?B?T3ZiczdUYkJxMXZyRXFGNVd0NE5tSGZ5a1ZPQU90dmxMSGsreVV1KytWUWlt?=
 =?utf-8?B?R0dpOWJpODlFTk5QSS9NdC9HRkpWS2U5cktPQVhYc3dFODY2RnVUMkc0U3Vw?=
 =?utf-8?B?MzJnNTRjRjhNTWI0c21kRDAvcnc3ZFhWa2hERlB1VVFEKzU2a1YwZmh2VlJi?=
 =?utf-8?B?UmxlUUxkeU9kQlZXcWJjMGNHYW0vNHlEY1ZETVZrL2F2bG95cWpZb3J0b2J3?=
 =?utf-8?B?c0dBTGdlWFU2OVBCUW5tVEtwUmhJdXJxUlVsMi9XYnZZSGU5RVkxR1J4b0VK?=
 =?utf-8?B?V3FteDl2MXAreC84Rm9uRlEwSUMycTBzQ0o2ZldVamNqNVlQVjIzM2NtYWVJ?=
 =?utf-8?B?NU9JUndJWTRWYTNoWXBaRkxqdFBYTFRMOXgvZmoyT1VRMEpiL09rUkZqOVB1?=
 =?utf-8?B?ZldyMCs2WVpVUkZWOHM2Yk96NFBnR3Y0RSsrb2FNTXRBSmtvRlhlMlJtcWcy?=
 =?utf-8?B?SzdiRWhIT2krTmhUVDRUNWlCR3MvaWNkYjU2WFBMVFBwNUZaaCsxV0FpelM0?=
 =?utf-8?B?NjJXY01nNW9WM1ZiRHliWU5kNGo5bTY1L1JhMDFSSUdMbEI1UGlvbmh4bnVT?=
 =?utf-8?B?emd5VzA1clhheUdadllNMW1HVEJuN1FTSUV5SmI0a1ZFZityd2NDOEJ2SE92?=
 =?utf-8?B?Rmo5UE0xTDJIQy8yMW5HbG4zdXYyakNmQ2pIS2dqOWFLU2huc21NdExYNUNG?=
 =?utf-8?B?UVRqcXNnZkZ0OEY3ckRkdHdVWDI0VFowYVpmUjlDQi85QUkrdTZLVjRUOGJn?=
 =?utf-8?B?WjJLQ3BzNElYQXpGYVg2TUJ6NDVrdGhsMWJ3ZkFYdGNvSkpJY2J4cjRrb2J1?=
 =?utf-8?B?MjI1d1F3ZmgzSEZLQzJVOHBUVDRYT0dicGgyOElCYk1WZWloZ2MyWkhZRTZm?=
 =?utf-8?B?c3E4dDhleENkUnd2NFozRTVKZlRVbmN0UHo3NXFoNGRmS1RmVGs0TlhEZjR6?=
 =?utf-8?B?UHhxVUFKYkp6OCtWRUVCVVNOSnJCS0xDbHFtcGdWOHIxUGhXMUFSYytnaXlM?=
 =?utf-8?B?WFBLWW1aSHJJMkh6dVF5RFZPcjh3RTJsd1hUbkRuT1NBM0U5SDVZQU1ZOGlY?=
 =?utf-8?B?NGdBOXQvV0FvTUJMOEtCeWY2TThvTTV1ck1EYzFsVXJPdE0rZDFmaHpDRDdK?=
 =?utf-8?B?OS8vbGNoVFM5cWNNSmpqR0kramowM1NoNnVCbEtRZ3hrMGMxS09FcDY4aXly?=
 =?utf-8?B?dGdvc1kzWk1Zb0tWNHpHVWREZ3ZwcmIwRzFDaU9rUXJlRFFqV2pxdlRQMVBa?=
 =?utf-8?B?M0VFN29sU2UxQnQ3OXJ2UmNqMzJpQWRaNng1R1l5NFBTOHczb3UveGUrckFQ?=
 =?utf-8?B?dzhpQUVKYkFzQk9YMEFWWGlSVkZDV2lkOGx0NXpBQk9wb3M4U0NFNVRKVENk?=
 =?utf-8?B?aFQ5OXQ0RTNURXFhcEZabit0aG1CWU1pcTQ1b3ZXbDc2Sy9TYUVQZWxkVlRp?=
 =?utf-8?B?RkNSQlRKMkUrdmhYUnZzZW1HNTkzUHFuMnZpWXc1eEluRmVZMVFERGVxeHlx?=
 =?utf-8?B?SXAzVDdPa1BzdlpldjBubzd6Y3ovK1J3Qlh6TWgzczRYdFVucURhQlpuYm5Q?=
 =?utf-8?B?YS9weHZLSitJZlI3SHdqUlEvMzJ0TlBhSXU5MFpsWnBGTlRUTTBtK2JqZlJa?=
 =?utf-8?B?WlFlVlNrRWNzNzRmM3VkUVdnMXk2dURuc1hGSGdvVnorZExRNjBJLy9sU29G?=
 =?utf-8?B?MEhqVzk0OElZTjJDSmZEd1BhTFB2Zk5INDZuM3dxM3orWm5ZNSswaTZ2aTVF?=
 =?utf-8?B?TXFmbjZtMkRNa0xGN1gxbU5sUG0zWkFIaFkrUS8wbkRRZDhXOEwvc0prN3pT?=
 =?utf-8?B?aUVaVDNVOGNSb1NYY0ZLUWdzM2VIWktrYnF5aXVmekdOclNFazZsK3lybmU1?=
 =?utf-8?B?NmtFR0xGQ2dzeG1tcWpub3RCb2Z0cnVINDdEWFdMcnVtVlJWVnZ6eGI5WlZS?=
 =?utf-8?Q?u5jsMYgfD1IcD67aN44uhmU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/ELdEOsh0npLKmAo4qi101p6ic7OEuK48Y6HNFk6xsBdpEcn/skwoXqXTImTcY+cv+VguIWi4shIRwgrbAFLSYR3URfkYcCUrxccnVUS/2cHwgBUPxAKij/ZP74T39d599AT7IM7OSnjyueYQEw1gk94HJfJ/F/v9jDzWc98kZ3l2VE+lK89mUIgRM4XBaQQ1oMYudUJ5N1/+H5i8ey+JeZuGKPkfH6QuZ+pZk50xh2Pz3bTWUL6Sel9QwqSgG7Vm0MIgikdXiK4MQZWCgzRw4SMYRNkB4GGKppl5U5fqiv8q4GbBj/0rwuWKbrH7df2UZfyJlET0M6QvhS5SiJcrRpgbCyr1cy6nDbbnKpK+J2l6aIso0v1Vj+HS/pYGrg08JQ1j9Pf3VjqHsmt1Rn79BAbgZZpdnjHMwK5HU/arR3b0/CghMjfXe1DHcdpPWDcfzEdW6V1rwbUK/c3/vqhYGXl48EKCMxo6zdwfLhoovPyG2lZutUCetlQBAdQiuPjYv9ilgKWSjok8kt38YqvnIzE/xtIb5IKVT3yMNsk+PTV2ZB47cq+a+8RudMKS4WP9I6dXo4Rym5HCCuBZz9TMpCmNeHplV/kKd1fTtf5/WM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3db7546-63b7-4d00-0ea7-08dc7b0e6fd8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 09:55:11.7714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NFYMGelieWGkhgpJe8y1zOxbe77kKMDFNhGjnHKfgaLOXWywLK2aAeRAL6jZkpHU/mCn+lGUv4U7HElQeCuI8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_04,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230066
X-Proofpoint-ORIG-GUID: 6HV3O-5vHRP_Hvb8etvx2BaqUNKnan_n
X-Proofpoint-GUID: 6HV3O-5vHRP_Hvb8etvx2BaqUNKnan_n



On 5/22/24 11:44 AM, Eugenio Perez Martin wrote:
> On Mon, May 20, 2024 at 3:01 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add the boolean 'in_order_filled' member to the VirtQueueElement structure.
>> The use of this boolean will signify whether the element has been processed
>> and is ready to be flushed (so long as the element is in-order). This
>> boolean is used to support the VIRTIO_F_IN_ORDER feature.
>>
>> Tested-by: Lei Yang <leiyang@redhat.com>
> 
> The code has changed from the version that Lei tested, so we should
> drop this tag until he re-test again.
> 
> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> 

My apologies. I wasn't sure if I should've removed the tag for all 
changes or just the significant changes.

>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   include/hw/virtio/virtio.h | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index 7d5ffdc145..88e70c1ae1 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -69,6 +69,8 @@ typedef struct VirtQueueElement
>>       unsigned int ndescs;
>>       unsigned int out_num;
>>       unsigned int in_num;
>> +    /* Element has been processed (VIRTIO_F_IN_ORDER) */
>> +    bool in_order_filled;
>>       hwaddr *in_addr;
>>       hwaddr *out_addr;
>>       struct iovec *in_sg;
>> --
>> 2.39.3
>>
> 
