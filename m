Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6024818E20
	for <virtio-fs@lists.linux.dev>; Wed,  3 Apr 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712163083; cv=fail; b=YeOjWuz0VwScmb7yXCveG5Qsp/Un6nulBQ6oOMRgLBDsEZW3SSfe1VpApsq7fRozlM1qBdwpWH0rG+cw49ICJbHKU3423MrpZkn6hpztgvKeKSmJSxdku8/O9hmg0KOYyWBjcOOwN9ujKL6tcsUnXZHubz7UsLyZx8+8VUtWBuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712163083; c=relaxed/simple;
	bh=ewWybRcpEhgqZBpndRnb9Z3OrS7jADmGHcN2gMzS2jE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bbDPZmv6IL1GtLUFa4+8UqbKda+Cp3sH42oTiTbxEEG17pV+k5T/C5mdvBDLLsFrZOSm5/LAEuONV8xSo9Co3d5Q2VPT3CAC5NAVqCKGl/A0Id31Mpsm8wlSNoVsXsTFw4XRzGu/kI6pgJxT27ULarEOQPk/0pu/5+yBnZ37os8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GS+GLchb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=b2A6vXlU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GS+GLchb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="b2A6vXlU"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 433GPVEc003622;
	Wed, 3 Apr 2024 16:51:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=uQOXQBcYwVnTGIAwYPvAs91KAYUwQd1U8ee+k4GyI84=;
 b=GS+GLchbCFU8wsucGFI2IziS9JFXKxh3E+0Tlw4XIUQK5GC91q2gJOJHsqWdIXoQwVno
 TuP9Cio5PtnkTkiY4mm87pJsibDtOa9RV4gkTIjk5hxtFlfsK7zYml5yo7NaQ1seFsLf
 HEw9O1LQSOtiakheMxKvZCGYbZ1A6VS+5C36oeHHxgg7bh4/hXol9QBo5Ez0xgX7Hlr8
 Vp2GBtEvlqxyfXRvuE2qB9qOLFSfw5ssxAMYrvkMeuNwm+iljkgm4oYcb5/A3SYtIN8+
 zRVMKCJQhffGjNSQIC1RpfTRtufz5clf+WVB9+RuWHYivgIG5Oa6MSPDYucBh0rPycu6 /w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x6ambfkhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 16:51:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 433FZ4JT009875;
	Wed, 3 Apr 2024 16:51:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x6968vkfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Apr 2024 16:51:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rq3ia5bNkhDv8/TSUHVyQgm1cAGFzqhMm/qgNTiSVLdTDucp9P4OMB8FT+R/GvimP7kdFnGRqBavS0NjNrAASGXifVlVoRQDIzkMwR8dtbX9eih3J5Md4hNaU2sLVq8bfB+jNGZgvDMiDNleyPJt6SilpVEWHP+OTYcJOHJDmUMzWwyvf8E0CDcMmytzh4JjnH02eWqRQknKMQIF5ITnz4Gh8LFpngnfqyYaPWNAh4fDH99z7HOJWg9dgFeFel4mNBMY2yfyadd3m4sWHZnto7GkSqeRa43t2xYjmxfnQlDjZX5MPv0m67pyiNPb8ysVCay8+BsENFcOUTIWVQkDuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQOXQBcYwVnTGIAwYPvAs91KAYUwQd1U8ee+k4GyI84=;
 b=XdufeAD5xVDsSyGL2NMSLWekZSQ+XaeLc1Z+mCEXj0lC/69s8iOv5itSG5JpsfJcNhjr+bOBguEnuMQXbUQhvGD0Eeqw5qHwtIQWypUBqOjc87J5sdQrRw6+adMuViPcnXDPpe8FabVTFIorjsr41+RWxkvxn+8+umk/2l7FfYxlNCen+SYoxde7Rh8SOUuBjqbMP6BXb9nHfGi9yrCKvGVEILDeBIMRTY2Ur3qXqmRvAEuTM68RJojkHbqGtPAvCB9zDyqyhFMGHsIc37JTACzQ7dZW1pmMga7xH7VDrfceBlCuvXKyrNs8A9iAi0G3lAEYYtjCbE8BGN90PTCARA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQOXQBcYwVnTGIAwYPvAs91KAYUwQd1U8ee+k4GyI84=;
 b=b2A6vXlUSiMrzhs91VXJm9ByjyS48av/7Py9gLuJC9VyF1uyPHLy63/m8Fl4a1SEqMt4hZLHy1cfw4JxjANnPAcEpYNWShvLKzjFVloqCA7mHzgJ60mG/dB19zYr3FxNVuItDpbj88aFz3e7uX+TWwXBgYbYL9Q+C4PioKRckDg=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by IA0PR10MB7326.namprd10.prod.outlook.com (2603:10b6:208:40d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 3 Apr
 2024 16:51:10 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.042; Wed, 3 Apr 2024
 16:51:10 +0000
Message-ID: <768ffc05-333a-4f00-9944-940bcaca59fd@oracle.com>
Date: Wed, 3 Apr 2024 12:51:06 -0400
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
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWdyZdu48+cZ2umafLRi9NTz3YHxSxmyq6SD9d4noTR2jQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:510:174::16) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|IA0PR10MB7326:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	8uuaLPts7Pof90clf8arOAU+EMkO+VQe4ltIgZkfnbD/aOUb2k/Fe69UvAhVdoSZZkFq4Gl78bicFiskToGLPVqselbrS7yeJpvR1Xk24S/H3gwj35dopFYe9tind2+xiOeNqRjdmAxVANPT5CJoA1V7fFNrQe1hROvPz75px+oY2HUzL+ZCoicvv98LEwGCe/Op64Yxr1HHioTiJBXY9kOpJmKTJV/g5X/kNqOcVzUZ6meN3yBrly5S85FAO7IgCiumKs3kpevirc6VFUAtn6hv67AW8IRgpLzyn+wkUnSYRI50otqmcEbtDqhrDXAn0FhM85J0KTErQfB00pXc8ulR4W4RimN4iNkL7/L1kJrU9d5ujV5BDPQM7fAJV6m0OcqjN9dG+7qJLeqRGS3s2wFIlKZWGTCyDj8JFY4i49VSP4NYEAkkv1QnABMGpjQZgXS9vPi5bz+kTAD6XuWRU/ijJX9GKPcgHmjxVNWLm+UUpOEZPuV9YUpElSg/2Or+ajgfwzeSNeYy1BNvkIPKFnwfF3re97uN5FptLN6eKsjqL/neTp/qK6ToNOiCeqXIR1b56YJHsEM8cjiZQ4N63+G454FEQLtjpe7z/scV+V3x3BbcDqnonoLnAHYyq6RkEzzHTQSAl9zBiSMeI4NVbInPgtbKdGNIBC+4DQo2ZUQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WGQwZnF1WFNzbDJLZnR6cU9Ybi9YbVBlclc4d2plMXAzM2Z3eCthU1dIc2xO?=
 =?utf-8?B?MHVJWCthZUEzQ0JiNkpEaGhVbTdERTZPc28zdk5GMVFXcHI5UkVaREtMVkNV?=
 =?utf-8?B?WDUwaDJHd0phNTJQS2tEaHdLNlR3SWQ2UXp0OXNDTkI1Y1hWVVJaSDFjNkxH?=
 =?utf-8?B?U1A2UVNVNnpGVStYM2kxTWVTZ1g4akZTZWpUMkhHSytxMXNYWThoUWJBeThT?=
 =?utf-8?B?VWdXS2g3UWkrL2NxdTZpRjY4Ti9zbGpJRDZpRkZCR0pqdG15dzkxaDdSYVJU?=
 =?utf-8?B?dVNEbDlYTTRHd0RxMEljaUIzZUpVMHcrbHl1K0dIM1FRNWtEekxMK1R4WXpi?=
 =?utf-8?B?dFdqUlhiREdlQmhBRVlWcTBRNUtKTnVIVmdUekp0S2tkdlkvaUMxeFlXY01B?=
 =?utf-8?B?bDd5b2pzZ2VlbDErY3FwSi9nNkt1UEdDNWY3aGlVL3NUNlE5TGxsd0tZcnpj?=
 =?utf-8?B?ajRxY01HdWFrcmptSG1IS3VoeisxTGhOcnJMamh6L0Z5UFo2V2lReS9XUWI2?=
 =?utf-8?B?Z3VTNytIYW5xakNzWlBSTURYMUl5ckxtTW9xelIrNkxDUFRMaVZ3Mk1Od0Nk?=
 =?utf-8?B?RXhrc0hFdmFWdWxudHI5US9nUGlEOVJmYkRobk84ZFhMazd5TUdXbTVsbGlj?=
 =?utf-8?B?dEF0YTJhWFRoWG5naDlmQllQOFc5NFNSd1dDQi9zczdQNnV3QWdvN2lJeDRD?=
 =?utf-8?B?a3Fhd0NvUkNoMkNiQTJHUlVSZWovQjBoR0ViNE5RS2lzMXFMOU5aZStmOUxw?=
 =?utf-8?B?WWxLWFdKV21jZWZXQVhmTlVjSUdyM3JpYWk4a0NXVUNJZFFaOC9UU3dFYmZa?=
 =?utf-8?B?bkxzbm53dWNhbWo0OUcyUHlhbU0xSXJZeHAyeCtQS0dwNzJMTjhkOWVFSlZ0?=
 =?utf-8?B?K24xSW9nYmJhNHdoTmdUS3dCUDFZU1B6VXRsemJlR2VDeEhyK2RNTVBCR1Bk?=
 =?utf-8?B?LzdwZ1NiallKbVFSNjQwTlZKWTZ2N29lZk5YUlhuU2VKR0J1OW5GdEhoOE1C?=
 =?utf-8?B?emVTSEwxaFZsL3ZjbEhITUlNZ3VNM2lXWGRydnYwRzdjNzRGYURBRWRCOHpr?=
 =?utf-8?B?aEFKT1ZYT2NxYnl3TVd5MWVtNmlaRVNUbTUrMHdnaTRsT0FXejFvc1o5aDEr?=
 =?utf-8?B?NndjZzBySWNVOHdNYVR3dmVBbHpIS05IM1Y3UERFRGVvcjdmS2VDc0xSRDc0?=
 =?utf-8?B?ZE16N2JGTjliNFZxVVhwR2NYVXcwUWFPYzNTWm94enNEdkM2MktaQlR2RGJJ?=
 =?utf-8?B?endtQUlueXBvOTdNNDFGekNxcjh2U2NsQVRXdEp1V0tDUk12cVJQUXlUbU9B?=
 =?utf-8?B?bGhPWFdkN254bXFvbHU2bGJiWUhGWnVoSk9aWHZHZ0lFR1N1b3ZIZmUyOENn?=
 =?utf-8?B?dldySDFVcGt3aUh6NllWMmxRRzlqcXljeW1MTlQ3NlFVRjBkalduZmFCV2Fi?=
 =?utf-8?B?aTFwRXFVWnVvUGZYV1pPRU92bjZ3WllzTnl6dGpKclVRS0pqcy9KMFY5T0Fz?=
 =?utf-8?B?aVpkVjFONmxLSXpsbHdhUHJHVi84dHREYVRGc3kxbjlTUFA2dExlNEpqaFN2?=
 =?utf-8?B?Ti9LaFJuQk85K1pNNnd4Z1ZWVHFqUTJCQng5OHF2aEdRVGNUQjNwUDV4OTMr?=
 =?utf-8?B?bkFvMnRsNnpiWGxtODdlbVZrdVRHTXVvL24wU2taOFpIbWFuTFE3d28wamFm?=
 =?utf-8?B?L1Z3WE55Z1FTV2RONkxsS3R5ZkZQSDBsdnBNWmJ5bW1yRHFwMis3STVCMm5C?=
 =?utf-8?B?d2VySzdhaXU3OEZVR2pBOURmdTU5ajVsSjA5VDdTSzV4bzFSNnVYaDFHQ0pD?=
 =?utf-8?B?alRXSWFVbnJYRk90SWlkbjFQSDNBdlppU0U0N2grb09aalVVd1J4anFUbjZn?=
 =?utf-8?B?RW1ZZVlabkhZeEp2TkhqWVpZSkd4amNaaWhubCtSWkU0RFVoUzV0c0ZqTktS?=
 =?utf-8?B?OWx5QytnRFRDcEJtWElmK1F0emV5aDRwZWdjUFk4eERVQXNEZ1NHcU14bkhJ?=
 =?utf-8?B?Tk1IQ05iREE2WUc1K3ZaQWY3dmo5MHFRbUhIN2Qzay9IK2dDVGZWRzYzSDE5?=
 =?utf-8?B?YStGYm9hQ0IycnErZUJOc2JlbzVoMmw0SUtRRDZwME1UN3pzZCsyL1lOZjVt?=
 =?utf-8?B?LzJPZkluRk1XUTJuUUJqVU5UUitOYTBuankydGp6TXU5OUNNSDNOckk1RzBw?=
 =?utf-8?Q?V3TUp7iIMnUagX+T4RMAwW4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/O2C+FPhqPl9mswD60zMbNaM4wre7Re6x5aHoXZxyHvdb2cU4+zPB07yQ9I2q8jPKNBH9RCzxGhMkz/qbKj26m5BYrL7YGGXArm0gI/s2odAeQMOz+teYqWkXF//2bGs4vJhSS3oc8UF8koW4978d0uW/CtG1He+fqvbSYUqt5R53QgZNkHd1BOtwV8edPc2GzC56FHCCFMW4MM3YcI9bhaxQi1evTqhK300zZ2lSaCP2a44HiQdjvBDXZoZqcwHJFkjMXVZcOYRHOoBhXp6xAAJkDpxfTMmE3o2/q21Z7WWH5o2PUeHYUC6OpKEVBkw+oFSuKoZz8kxFyY/f0a0Q7XE3tpufp6WspUqTGXRZnTVxF+MlN4uymhz1ngQ2aoNjjfL+EDY7+QI9BcxruvQ0Lw5i4y/Bm5wjR8BvN3hMHiUFdPHbti03bMkdBKDFTN6/RWbULlgvnaR2q8srI6jOmqrMzXTwieGSDfZBcPyI9dXklj3Ua/0Z44QfaDUiVmBlm21AVj5QER7oHlddLeHn+id6cAJvmR3evFiEyCoBd3SQ4cwsGit2WY07HF3zSkcGwRgG61QkWCiRkDPVKxebgzhKdZ+ZcJw3HIVhhSU988=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e736bedb-fe11-455f-bb98-08dc53fe4348
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 16:51:10.0457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H/t9+2dAhxGBXHMz9Qwn3sczBwdaMhMSo0xDPAVBIach39Kc6UmlFevys42nfJ3ntPPbJIJI8fwLWNqsFnPaFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7326
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-03_18,2024-04-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2404030113
X-Proofpoint-ORIG-GUID: biclQDixV54bXOY0GcFzcQ-83AQ9oirg
X-Proofpoint-GUID: biclQDixV54bXOY0GcFzcQ-83AQ9oirg



On 4/3/24 6:18 AM, Eugenio Perez Martin wrote:
> On Thu, Mar 28, 2024 at 5:22 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Initialize sequence variables for VirtQueue and VirtQueueElement
>> structures. A VirtQueue's sequence variables are initialized when a
>> VirtQueue is being created or reset. A VirtQueueElement's sequence
>> variable is initialized when a VirtQueueElement is being initialized.
>> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
>>
>> A VirtQueue's used_seq_idx represents the next expected index in a
>> sequence of VirtQueueElements to be processed (put on the used ring).
>> The next VirtQueueElement added to the used ring must match this
>> sequence number before additional elements can be safely added to the
>> used ring. It's also particularly useful for helping find the number of
>> new elements added to the used ring.
>>
>> A VirtQueue's current_seq_idx represents the current sequence index.
>> This value is essentially a counter where the value is assigned to a new
>> VirtQueueElement and then incremented. Given its uint16_t type, this
>> sequence number can be between 0 and 65,535.
>>
>> A VirtQueueElement's seq_idx represents the sequence number assigned to
>> the VirtQueueElement when it was created. This value must match with the
>> VirtQueue's used_seq_idx before the element can be put on the used ring
>> by the device.
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>   include/hw/virtio/virtio.h |  1 +
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index fb6b4ccd83..069d96df99 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -132,6 +132,10 @@ struct VirtQueue
>>       uint16_t used_idx;
>>       bool used_wrap_counter;
>>
>> +    /* In-Order sequence indices */
>> +    uint16_t used_seq_idx;
>> +    uint16_t current_seq_idx;
>> +
> 
> I'm having a hard time understanding the difference between these and
> last_avail_idx and used_idx. It seems to me if we replace them
> everything will work? What am I missing?
> 

For used_seq_idx, it does work like used_idx except the difference is 
when their values get updated, specifically for the split VQ case.

As you know, for the split VQ case, the used_idx is updated during 
virtqueue_split_flush. However, imagine a batch of elements coming in 
where virtqueue_split_fill is called multiple times before 
virtqueue_split_flush. We want to make sure we write these elements to 
the used ring in-order and we'll know its order based on used_seq_idx.

Alternatively, I thought about replicating the logic for the packed VQ 
case (where this used_seq_idx isn't used) where we start looking at 
vq->used_elems[vq->used_idx] and iterate through until we find a used 
element, but I wasn't sure how to handle the case where elements get 
used (written to the used ring) and new elements get put in used_elems 
before the used_idx is updated. Since this search would require us to 
always start at index vq->used_idx.

For example, say, of three elements getting filled (elem0 - elem2), 
elem1 and elem0 come back first (vq->used_idx = 0):

elem1 - not in-order
elem0 - in-order, vq->used_elems[vq->used_idx + 1] (elem1) also now
         in-order, write elem0 and elem1 to used ring, mark elements as
         used

Then elem2 comes back, but vq->used_idx is still 0, so how do we know to 
ignore the used elements at vq->used_idx (elem0) and vq->used_idx + 1 
(elem1) and iterate to vq->used_idx + 2 (elem2)?

Hmm... now that I'm thinking about it, maybe for the split VQ case we 
could continue looking through the vq->used_elems array until we find an 
unused element... but then again how would we (1) know if the element is 
in-order and (2) know when to stop searching?

In any case, the use of this variable could be seen as an optimization 
as its value will tell us where to start looking in vq->used_elems 
instead of always starting at vq->used_idx.

If this is like a one-shot scenario where one element gets written and 
then flushed after, then yes in this case used_seq_idx == used_idx.

------

For current_seq_idx, this is pretty much just a counter. Every new 
VirtQueueElement created from virtqueue_pop is given a number and the 
counter is incremented. Like grabbing a ticket number and waiting for 
your number to be called. The next person to grab a ticket number will 
be your number + 1.

Let me know if I'm making any sense. Thanks :)

Jonah

>>       /* Last used index value we have signalled on */
>>       uint16_t signalled_used;
>>
>> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>           elem->in_sg[i] = iov[out_num + i];
>>       }
>>
>> +    /* Assign sequence index for in-order processing */
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        elem->seq_idx = vq->current_seq_idx++;
>> +    }
>> +
>>       vq->inuse++;
>>
>>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>       vq->shadow_avail_idx = vq->last_avail_idx;
>>       vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
>>
>> +    /* Assign sequence index for in-order processing */
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>> +        elem->seq_idx = vq->current_seq_idx++;
>> +    }
>> +
>>       trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>   done:
>>       address_space_cache_destroy(&indirect_desc_cache);
>> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
>>       vdev->vq[i].notification = true;
>>       vdev->vq[i].vring.num = vdev->vq[i].vring.num_default;
>>       vdev->vq[i].inuse = 0;
>> +    vdev->vq[i].used_seq_idx = 0;
>> +    vdev->vq[i].current_seq_idx = 0;
>>       virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
>>   }
>>
>> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
>>       vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>>       vdev->vq[i].handle_output = handle_output;
>>       vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
>> +    vdev->vq[i].used_seq_idx = 0;
>> +    vdev->vq[i].current_seq_idx = 0;
>>
>>       return &vdev->vq[i];
>>   }
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index b3c74a1bca..910b2a3427 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
>>       hwaddr *out_addr;
>>       struct iovec *in_sg;
>>       struct iovec *out_sg;
>> +    uint16_t seq_idx;
>>   } VirtQueueElement;
>>
>>   #define VIRTIO_QUEUE_MAX 1024
>> --
>> 2.39.3
>>
> 
