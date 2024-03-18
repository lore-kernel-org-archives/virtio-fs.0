Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5CE3770B
	for <virtio-fs@lists.linux.dev>; Mon, 18 Mar 2024 11:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710760943; cv=fail; b=AP/44V0XWgusr9KI0nyk/BIq5thasvX7ueMvTqrDXin3cd2vhg9bJujtJStwVPCSeDSKfKcsimCUshJGWI/DwL4/5jQhUgPY1Fbti7WyhLze8kR1K4ivmUZwLMtp6wJ/lA1g3AnbnvKb2G10DzTIMQG7DIUzfasKAClq6RuQ3IE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710760943; c=relaxed/simple;
	bh=BsXHQnbYzclATg/bZNi5koqGwfRr6tv3wrjRw0O8K4U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ph1nDsYtItroSLvm0xp4xbOu53RBifZauwoNX6sTNK6q7C8ioEqozicJu++Ujhah8f5IbYt36jFec0ckeXR6K83rZHZ4nkQqAO+9OP8b+9BjZa0vE+LoCY+lHLDKlwIFDOfmJvNHC200Bmf43K0IZiMJC+ajFrIwfm4pwnl+9dY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JcR15j1g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zOYFxaTl; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JcR15j1g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zOYFxaTl"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42I1jGJt015524;
	Mon, 18 Mar 2024 11:22:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=j39JdN6/XLvoY4jikwqbOuE/1hyWnkbLhEXGK2lAVM4=;
 b=JcR15j1gWnY8yCyHGhLzHxmYAHL4CK9YIKN3+kWvizYT5utEyJY7Qi1jFnVNvFOPXd1d
 Z3M170JCALAECXhpry2bQQBfgAH5obRXWnyQLhicBjMIFXHBanOUQml6D+ZdQEXp7K/S
 j+U4+JkkSTtXmn3kButFkS0/18d08fOi1D3OlfQHyG6R57+X4yVNu1rPKDTaxV/fFBtG
 GA4ApnGZhtAxlEaj964g+DDAakDeyYIuIXjKHI8b+t9sYWGCNrmAk/xUfglnjkFGf1Yn
 MTXvQR4R+YTfgHF1zoWTPRWQ3xXWVms+wdCeX5Ubu6TeydjlrhHgKni1D509Ksh4NaGe yw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww3yu2mht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Mar 2024 11:22:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42IA3uYY007329;
	Mon, 18 Mar 2024 11:22:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v4qdhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Mar 2024 11:22:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbdI70vSxeUQ3mKnjTNmFUfKRgxjK0gCwGnwBNkzArMMT0+Litd3LrYekYYzuhkm/O4S1HMFJGYAz9Qo3v+jDvMiavz2cY3ndbgDkdxE9oDVpsXmjDlK3rS6F9N7nfD9tr91CfsUW8HunXlyZEWonPqnNUmYtNlFUitWB6xcZhPSDrAF4qTBUCdSVBzGlcaGi7f+FmcEBqNhQd27iZx3YppOi0603zjcVYu/ytTvujUqI1NSEImSn+Mw9798QEcu9ssSlJBHpXJql4K7PumSR0HMHiQUzB0qZAjG7qc1BX5WbPs54efl6TJpthlS+Y+Xp63wQqVDvhHWphZidUN01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j39JdN6/XLvoY4jikwqbOuE/1hyWnkbLhEXGK2lAVM4=;
 b=MgMA+z34H/fs7f+wpdHdLCn+ZeykbbYcKnwi00+Wx9TvYLGiWKGFEWvWN95y8/ERGix28HAdRunKFN2t8Z5po5XAA8wGg9UzKZeBjOMqaHm7l4ncKKNfnzJzBBpHc8SqUi8UyjG4e6o61yoyMaLKUtWKOuqef+XUBjuV6rheI0AMco3s65gO9AfR03cVRhT0iIPp/njM2GwXDIL7H0haJuC0q6KB3whJobieLeDzG4ojEai3EOU8lUhAPdlgCSIi8yAqIJEfnL+t9+sYGAMSFwRnqWBAN1o6kqNpsdGZeNmBa6adk4ThChXP+zMSY3TUWX2bWmAp8SMjYm1BSPelug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j39JdN6/XLvoY4jikwqbOuE/1hyWnkbLhEXGK2lAVM4=;
 b=zOYFxaTl+GmjDXM2fd0mVevOhpjkxHLSE8aWBJXqg8qHS9LsQiQ0iyLT8+73gQFm8/e5nxXw7WUx6GCZoOkFyrmfEou6bC1ZWYYkLeZw5IL8kXygEfv3nsCFO21yk9rxlziGKZ0lvyLcDzNjWD33lQpiHTNpEwEPTIBBIF+etaU=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by SA1PR10MB6519.namprd10.prod.outlook.com (2603:10b6:806:2b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Mon, 18 Mar
 2024 11:22:07 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 11:22:07 +0000
Message-ID: <89dea52f-b4cc-4a8b-986b-68d73df180fd@oracle.com>
Date: Mon, 18 Mar 2024 07:22:02 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 for 9.1 0/6] virtio, vhost: Add
 VIRTIO_F_NOTIFICATION_DATA support
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com,
        eperezma@redhat.com, si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, leiyang@redhat.com, schalla@marvell.com,
        vattunuru@marvell.com, jerinj@marvell.com, dtatulea@nvidia.com,
        virtio-fs@lists.linux.dev
References: <20240315165557.26942-1-jonah.palmer@oracle.com>
 <ZfW-tO4zXeAWDgFg@nanopsycho>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <ZfW-tO4zXeAWDgFg@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0072.prod.exchangelabs.com
 (2603:10b6:208:25::49) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|SA1PR10MB6519:EE_
X-MS-Office365-Filtering-Correlation-Id: 485d2f26-5405-4ae6-f2b9-08dc473da530
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	iuwdrY5Ordzi95fKOdFU8YnqXdmp+n7+aZLdrvqAGoADu95k1ws22h9wPVHMYIk3ftqiuzDA45ude+oxkh0cVy8yWssZC+0tnQvW19lhI5XlCGAmAqfOKtu5ihA1xwx/9cx3GnzJIbjVdyRuaDAdsR6MSOmEieqMKEm25m9nA/JkwSAV3dbpLT8fbLiMlzYVB0vH9yYDIsxe2gZyW8AvrRbs3AC/NHj7fzhPojx64sANx4Ae4lKCdksgm+U2LMZJAtVjGgPwqbY+f4PhxYF1MjDU+ORou3PoQ+XFS7xJBpq9EjYYkFDwzNnEzd0e9NlnRpqO03JghABfguLKnn9tk+F2kbrCV5ni/Xw7dj88GPCQnn8wxhjkqeeJSafLam4tuUt3lzfSGzfYrnbs+GTntzHhlvb+EI6wpnzvApPMz1JIE+cCHfJbaseqLLsyQYmO3Xe+32eZh/9gx4jNszskl5cg6E+3y4Jue82YjJczKGHwBYSa8+gepiV7hKbUL/14yz/NupBQ3vmLw9VCBWyFbD7+bu92LK6fzbukABt0Gia9KQNJmR4P/nVa2CbXbbmJVtxl7slFfiOHmkL/6cmC/FEdPezgKW2KV+cxLSmthygF+w0EY/e6IoGvKRhhBy3s
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bjlMazgrK2RhWEZjcjZaWTRhZFlkbldXVXoxdjdXeXFHTDRxTFpvSDVQc1hn?=
 =?utf-8?B?WWZFSjVDOW0zTGZ6aUx2VTNHc2paVmxFWGx4eTRyek9rcXZMdGc5TlF5M2p1?=
 =?utf-8?B?UFd0dmZKWnJkbUpXand5TldLNFdScXZDQVRxTHAreDI4aTNqNnJkaXFPSHor?=
 =?utf-8?B?eGNrdkJYT0VrMEdRRjlyTXNBUkZjRW9HZTRDOTl3QUs0bWlQYi80em5SU0pj?=
 =?utf-8?B?bG04RG02a1M0QlBHbXF0MHlaNUJvaWtSMzBoTUNia3VSK2lwaEdKWU1jZXhE?=
 =?utf-8?B?VWd3STVLMGVkMTlJWURSVi82N3NseEZrS1BhdnVsNDMrY1RPNy9wanpWVWlt?=
 =?utf-8?B?cVp5ZkszTk1ISzlUdWorMlBpMlBMaEk0RkVqOHYvU1ZYNHlzd055WTdZWDZq?=
 =?utf-8?B?L0FTOFVVWjVjenpQZVJ3SDdWWEZkNzdCZXFvbk1tOXV5S3N1TnhhODN5U0Q1?=
 =?utf-8?B?Qlh4QlBOdHZEY3JxdnJYVGo3ZDkyVVJ1b3JWVG0vT1ZwekdOQWkvQktJK0Qw?=
 =?utf-8?B?blNLdjhHeTAyRVQwNUxRS0Q0bjF5eWpHUG01RjdVa0VmcUhKYTd4cTVISTA3?=
 =?utf-8?B?eVV1cVF6b3RXckpVYUxaa1ZGdk00VkJadks4RGpDVmw0WjFYY1Jha1JmaGNP?=
 =?utf-8?B?ZXp3ZStCRHUzbGtPNEJ5ak5ocVFRRjE1eml4RmZCeU9lWGY1c25xK2VueFVh?=
 =?utf-8?B?eGFOeGNyK1ZBUjJsdU16bVMzOU4rbkVtN25POGNMYzk4elU0OVVPdDZtWEU2?=
 =?utf-8?B?a2pKZGlaeVUrTzZjYzBpRVFaUENRT2xTSk42bFhYWmlGOWxHV2s2RnVJMzhw?=
 =?utf-8?B?RzhuRld2ckI2Y0VPdmtYQWtaUzFlTVNOdHZkbmIwVDlPUWVQKytrQ0oxWS8z?=
 =?utf-8?B?RVBkNHJJOFhhT0JRRTNvTW1FR1dMakdXR1ltc294YnJaSzZxZE5ITmx4VkN2?=
 =?utf-8?B?TTVqcXdHY1ZGK1M2Ylh0RENBd2x3SEUrU0NQNFp6Z3k4c3BjNm5lZE93L3I3?=
 =?utf-8?B?SGZraFdLQTFOaVh0M2RyeFphWlV2SDVta2lxblNpV3JCYVZFVE11Wk1ONHBo?=
 =?utf-8?B?YURJVWczSXFsM3Z0R0RSUlg4T1IrR3ErcnhsQS8xaGtGZmh5dGxaOVZrb3lK?=
 =?utf-8?B?N2F5VnVwR2NIMlo3WHcvMDkvUVpVc3RBbWljbE5vOWl5Vy9hQjVESTRYM2FS?=
 =?utf-8?B?VnJ0R2VaMXhJSEtqWFo3RVVOd3JReXFsblFwY1VHUGdwazRRaDMwYUpESVM1?=
 =?utf-8?B?RVFjQ1ZZT0tHdGN6cUFDWGVsdC9yYTJNWmVKd1NUQUx1RjVnNEZWQ2tJTGhO?=
 =?utf-8?B?ZkcvSGpPUC85NHRTUUdUZXFpaDVEVS83VFYySWFKWFBZQ2hoZElvQ1A2ZHkv?=
 =?utf-8?B?ZmpvSzNQandpanJNZmhlK3VYQ0ZpVUR3dlIyTGpRamw0aFJBbFMydWlhS3ln?=
 =?utf-8?B?VjFCbkJMUmpRQTJKMkFkUUwvaUJOcmZIT0FVTjdhcnROOUNrZTZxR2dmTzI1?=
 =?utf-8?B?cm1vNGs3TzBpSjJiOGxJeGJHMTFFbG1VbTJGUHByTDdOZGZMbC9rK21mMmNO?=
 =?utf-8?B?OG1tZW1vOVFVWnRLZms2N2RJUnc0YSt1Q0IzbG9wd2Vndml4LzdKaDRVenhG?=
 =?utf-8?B?eXdKYWtTZjNHQ1RXSXpoWnRjSy8zR0c4LzZGZjNlL2w0STR2dWhuOXlUZ0dN?=
 =?utf-8?B?aFY4RHMvN2pKN2tCUjJuOW9nVDAyaERIR2JvcXdOMnlwdGRLNkJDUnNYS2p2?=
 =?utf-8?B?TzQyb1hIcmNrL2RFWW5wbEl5WFVCUWNNaG5GRFZvSHh6MGpLR2Y5TUZpVzMy?=
 =?utf-8?B?UTFlcmpucEZwS1dHQnRSNE5pekp1bjVLOEJOSzlzQ29GZHhib09TRGxqQTlJ?=
 =?utf-8?B?YTZ0R0VEZHRNR29LakhMMjk3UW5jM0VVemdqOWdxdlQyRnI3aEtYckVObkhk?=
 =?utf-8?B?eE9ZVHpXRXVIZ1BzU2VaazVxTWZ1dEpWczhORHZLdE01MkwxeG82amRzelJH?=
 =?utf-8?B?aldXZVJNelRtdW9FbnRLK2w5L25xUktEZHJ3bFYraVBKRGtoYVpDUTN3bU00?=
 =?utf-8?B?ckJRdHRxZjJuQXI3Y08yWjJFZXhmb2EwNHFXNnpOaWxGTjV6MTFCdVBORXBk?=
 =?utf-8?B?eERSbWU1cEcrZWZFYnIySjBDeVkxbVdsRGZJbU81d2duRFNLWjVnOVFhK2wr?=
 =?utf-8?Q?cDfBeUKfTSNRYRn0wVwVW2g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	sIXqjATY+DmRiB+M0RhWJSiX/TAT/M3S1VpMqqDoYFsaISSflONV4/xSPssyMbTbKuPm8v1SSCvI/009EDAIowAZysZz/H7xGahRVhTdMRuDOvj03Rrw3e71bIuu0eq+5z2LaxAs/SHnLXugXz3aGC/pVmzKfLuUXx0Fa4n2i8/xdc1PB0vk68oOPeo2sc5QR8NKUara5dHBXZ9tX2DvDtzTXPejlySy/Ck6GEwvBjEutLAl6h0L3eQxW8tarInpFTwu6cci2MmiqNw/TpurVDwvxHE1XBlYM7xlCtHMXWbCy253u5H0Wk3Ij7u2dYLx5DvlcduYy8CkHwIdq7n2bDGmJetbWwTzGAc0XOuM4Nm53JYsVnIM8/VB8QWpUEwxUuZbRDJn8gKs9SL9v97V6BxXcltq4EdJ3XVs89Fwwi+7IPiVOGv350faB7/VUei0E6AxHW6aMo6GpZv5KOcBZ9amJelsIJ0hq+tWi0/Xbhlcb1p/Kgk5yH9zMJkbdAxl7BioJT2THNwj+QXYuZrQsm77rTk9hMfdBAiUwoxjSLtMsT5n8Ia5iIU+0MudZBwtvI9WCvYAdzfzdBNEQuQiPNPLrdpH2M+K0aiMcWsDldk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485d2f26-5405-4ae6-f2b9-08dc473da530
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 11:22:07.1505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FMI6FvhmzM90rmqdSUDdmAdzrZe9fMqge9m8A9aTnCTn+MwbL0/iF1JswxHzTaKJVziuQA9pV2kIvd5l8ytVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-18_02,2024-03-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403140000
 definitions=main-2403180084
X-Proofpoint-GUID: NPe2lpW5tKvfqAF1tT_7L-RPJvlH9u-o
X-Proofpoint-ORIG-GUID: NPe2lpW5tKvfqAF1tT_7L-RPJvlH9u-o



On 3/16/24 11:45 AM, Jiri Pirko wrote:
> Fri, Mar 15, 2024 at 05:55:51PM CET, jonah.palmer@oracle.com wrote:
>> The goal of these patches are to add support to a variety of virtio and
>> vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
>> feature indicates that a driver will pass extra data (instead of just a
>> virtqueue's index) when notifying the corresponding device.
>>
>> The data passed in by the driver when this feature is enabled varies in
>> format depending on if the device is using a split or packed virtqueue
>> layout:
>>
>> Split VQ
>>   - Upper 16 bits: shadow_avail_idx
>>   - Lower 16 bits: virtqueue index
>>
>> Packed VQ
>>   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>>   - Lower 16 bits: virtqueue index
>>
>> Also, due to the limitations of ioeventfd not being able to carry the
>> extra provided by the driver, having both VIRTIO_F_NOTIFICATION_DATA
>> feature and ioeventfd enabled is a functional mismatch. The user must
>> explicitly disable ioeventfd for the device in the Qemu arguments when
>> using this feature, else the device will fail to complete realization.
>>
>> For example, a device must explicitly enable notification_data as well
>> as disable ioeventfd:
>>
>>     -device virtio-scsi-pci,...,ioeventfd=off,notification_data=on
>>
>> A significant aspect of this effort has been to maintain compatibility
>> across different backends. As such, the feature is offered by backend
>> devices only when supported, with fallback mechanisms where backend
>> support is absent.
>>
>> v3: Validate VQ idx via. virtio_queue_get_num() (pci, mmio, ccw)
>>     Rename virtio_queue_set_shadow_avail_data
>>     Only pass in upper 16 bits of 32-bit extra data (was redundant)
>>     Make notification compatibility check function static
>>     Drop tags on patches 1/6, 3/6, and 4/6
>>
>> v2: Don't disable ioeventfd by default, user must disable it
>>     Drop tags on patch 2/6
>>
>> Jonah Palmer (6):
>>   virtio/virtio-pci: Handle extra notification data
>>   virtio: Prevent creation of device using notification-data with ioeventfd
>>   virtio-mmio: Handle extra notification data
>>   virtio-ccw: Handle extra notification data
>>   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
>>   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
> 
> Jonah, do you have kernel patches to add this feature as well?
> 
> Thanks!

Hi Jiri! I think there are already kernel patches for 
VIRTIO_F_NOTIFICATION_DATA, unless you're referring to something more 
specific that wasn't included in these patches:

[1]: virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
https://lore.kernel.org/lkml/20230324195029.2410503-1-viktor@daynix.com/

[2]: virtio-vdpa: add VIRTIO_F_NOTIFICATION_DATA feature support
https://lore.kernel.org/lkml/20230413081855.36643-3-alvaro.karsz@solid-run.com/

Jonah
