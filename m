Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2373A135A53
	for <virtio-fs@lists.linux.dev>; Thu, 21 Mar 2024 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711056356; cv=fail; b=le8g8KeHOe3O+IbruN8Uz+cFu5ldF64fqSsjDBIyiOcJJ4H2RUvjd9VzqDmFqJFKGG5/cJcdcbuT+M7JKoB9qMoW7t7oPfIGqHMa98OW5VX0hH/EhJGTKUecsMRTEhyFEY3NAlcr4yZEjlo2LAtxilzgdTZCvG18Gi7qRcmTag8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711056356; c=relaxed/simple;
	bh=XVPZpQJQG8izexPBwA5gg2Vc2UsEGNWDK4KOnbZTZ70=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QhtYLGpLnKCh5XoggIxH4noGDFRqCGJXaU0daUpDviNqVuzKO5NhA+hFX8zQMe22c/A8VwnOWKXbQ9w0wY/kW5TFGb6hgMdoAdwm7HziIqzked/4z+XRL3556YtKck40aGTZksqc3lkdylNp3R5RoUnNvBDVc98MEEtgriD8gxQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UUZgdiI7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ANoNSpa+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UUZgdiI7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ANoNSpa+"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42LKY7F2020033;
	Thu, 21 Mar 2024 21:25:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Gm4SD2+0LBHYf6XMwT0rSK16+YAMSLT0UK+XGSDnYQY=;
 b=UUZgdiI7M55Hff6tAifxy5d+fneKgpMuAJswrFdng5EegP2VBRqudZoi0OWWDXq1WZPs
 MKMK2CgHycQ5AQFrdyY8Ud1lUbm8r5I6DKQFSAt1lAM/qgh5zVZCgep0S9+2cm0Stnhl
 vmv3OHlBFVZtYwcJdJM+bScsBuhngSg+dAIMhe7Gt1ZWadcsVR8YoJwuThyVt3nLG9HA
 Bq4MvQlKEnK264gwjqVMwAXDCnDOly/lJMDEQZmLugoTJbyhbTzK4Llhj+YxXqTbEyFk
 A8XZ2UAizGREeyr1C6EjoXqN638Q7zUibNGDorsBaHTVnJAtKHIPg195K01u2aDOyDa4 +w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ww1udkecp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 21:25:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42LK0wID007916;
	Thu, 21 Mar 2024 21:25:46 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ww1v9uvya-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Mar 2024 21:25:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrKjOdP6ArOl/Hb+LXR0ME3xM4HFps+QuZd4gx1njhn0hFeQOan5tHoC/vWzqg5qPY4Ciw4XVlG7kmu2A7KQNLnpdf5GwLGz2WncsHaBcCt36us/K9yhukbG0hFvf8zpTZtCvrzQFTOSSdDxDY8EtfniZeTa86DFmqhPEp66yVIFnq34qBpwsgIvq6PDMCnvYz93N7ELXst2Cy3EX8BydWic951f02ieIvV8p2acsYeYx+WBw74roQsTdVesfd0QrIpic0rrlZNHv7uM7qCB0N8AXChqoDMQNn59S0mYeU2ykCZTZNopxtR97DvfzOOCcJvpXj/ckx6L3+bA5t1WFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gm4SD2+0LBHYf6XMwT0rSK16+YAMSLT0UK+XGSDnYQY=;
 b=Fs+louoVhTaTJa9Oic1TqF9aBl54Ev/ekzJRN8w9xIX+86GdC81Lo5jYXsB/cUviUD67hXd4mLVE6ZSDcCPDl+bWz5AfGvWx/wgVgmHwmM7f7KMZcQSIK8pICM9wHS2T63YcQwC0I6w2ZW/tXAc7fBS752v4b8KIaUIoHDLAweKfN6e4zimGFHlpUWk5I+9k2LbHvdE0+9XiHbG/lWaFbNVc8prWD0i+dsoC/pHR1l3ZBb+jSzXwjimsIrUt6vfCh4RKcyzzCR+An3I10bGmerAq6FBny5IYPdxLIjKHRITZmIjSbLKcBJbU2wEFzZDAu4FHxVTX7twYxK2cH7iLTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gm4SD2+0LBHYf6XMwT0rSK16+YAMSLT0UK+XGSDnYQY=;
 b=ANoNSpa+GfX175ZWPIwGciNUKZeL1hR1whHxzhpFbN4AIFVL1JeOsVY7ifL+fQsZwKSMfGl3/OFl5iuAQjmm3Arxc1H2Y+U87GwvjfjWZnR72SZMXAqE55SD8th0uJrn2dt+Vrh6Wq7j7+5307R61gl07bO57rbVFLPjqhv86BQ=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CH3PR10MB7235.namprd10.prod.outlook.com (2603:10b6:610:124::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Thu, 21 Mar
 2024 21:25:43 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7386.031; Thu, 21 Mar 2024
 21:25:43 +0000
Message-ID: <d38ce388-41db-4838-a27b-58f905dc11f2@oracle.com>
Date: Thu, 21 Mar 2024 17:25:37 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Content-Language: en-US
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org
Cc: mst@redhat.com, raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, fam@euphon.net,
        eperezma@redhat.com, stefanha@redhat.com, qemu-block@nongnu.org,
        schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <bd4083c3-863a-bd52-7880-2709afe73873@oracle.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <bd4083c3-863a-bd52-7880-2709afe73873@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0004.prod.exchangelabs.com (2603:10b6:208:71::17)
 To PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CH3PR10MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: 88ca293b-fda1-4e5c-d808-08dc49ed772c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	n7TDLhsl+xzvdqwikQy3Ua/rBujJA1uYOXrWmkFSIGkVZTImH1Zh604E448zQwfy1krlRPct4GaJA4s6Af1M4f3WM27W0Zz7WrgqO9vbm84ruIj9QAjL2UwHwhfl5DzTs9yPoOY5Y8VfsQikMn+GKQ4yZddnnaCNCRBYVfeaiHsHISctarSUoeReFDKrSGB6mQHacQmASelTy8q31gZLSvb4+asHWkpEwH1fv6d7U3zdxGMEIKWHuGnpxbXuVIPz1172a5r5pbyLV5PB/0zPXG5aPvGvzP58oxhjViOxZ/U0XMNoQoJ7A76Y8YRGv7wwphgZWMR/ixvnfR6t+sVdSZnHtGJ/dmshlK0UWy8W4TTdKlBsaFKMxukAgjZTvXjn4x4s9JTub7Jt51TiZClE2hAO+qTOZgL+lsHniuUKFN+Y9Qpy20EuNXPur3DKJthUA0TN+sDx+/2ViCU7nIMcatUYaw1ocXeWWiMCxdDXUwg9v3s539uSZ4M0dpfVzwYFbIowh7cK0y2r8zbmmxymE3UU7xVHJrBFb1owK2Pqpaq0AmmE1NxJKKxJNi9+3+ZWHhJhMef4BvtSrsjthamIijd/cRcWxDDdCv0qrcCSVjYildgpwSud4DC/z0OJjXOt
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MUlkRTliMUplOHBzMTZGTS9PQSt2TExyNi9sQVcyN3VZTm5pVWhTV2hpNU1M?=
 =?utf-8?B?b1RzQjNOMCtxWHZsQ1BQaStEYksxL2RoTkk0eWphZmtpTExDOHI0NzI3K0Fm?=
 =?utf-8?B?QjkxL2htWTVyY1hvZGIxbm1ybjRZNkZqVU9nUkNBcWhHS2RwTTEyTmJ1S0x0?=
 =?utf-8?B?OTgvM1FKbmtmQjZ3Uk1QVHZzT2lyNDVEOXJtcEY4UWFOTkhXdnN1d2dLTUpu?=
 =?utf-8?B?SG9JeDUwSnREeHhvbkRuN1dRelFHQjRobVM3WjhWUUFheUp5bFRTWGg2QU5L?=
 =?utf-8?B?czN1Z3BDKy90dWk5K05aZUoyL2JQQUdTQUZWUHE3UStNZXdIQjZLeWRtSzlK?=
 =?utf-8?B?SEk1ZUx3YlhIMTZ5Q00zUVY4Q0Q1TWdGalVJRmdTU2l4L1pYaFkvZmRPdC9m?=
 =?utf-8?B?Vm16M2N5eStDL1BMblY5YXhkNExjVU1iMGw2bFhJNS9sQXBnR0laSW1yRHN5?=
 =?utf-8?B?ZVgycWRBcXdLRUMvMTErdDBCeTl4bmxQKzRna3JoaUtOL2xGT2hXdEVxTlE5?=
 =?utf-8?B?WEpUMXFYUWVtNnhBMmFZVmZCdHNKOTIrZWFVYXBiUGQzaVVtak1nck14WnM4?=
 =?utf-8?B?MnlBaUo0ZEFxTXNUVGlCZFJHQ0d5ODJ2SFMxYVJuSitUMVlkM3ZsMENMb05v?=
 =?utf-8?B?RFRUQ2ZjTUZBeXBrRGdZanZudGhpK2FZRWNKVzcyOGk4cEgxNHN2eDM0MElj?=
 =?utf-8?B?cnpWUWtMcDM0aTFZZExNcjVqeCtKVGVZb2E4V3BBTk9QNHZraDZuL2J1d2pi?=
 =?utf-8?B?TDdmMFVPaVdyaDdRa3pQZUY3V3pjOHFseTk1Y08vckszVXYwRjl6cU5nS3Az?=
 =?utf-8?B?TllCNlNDSmJMNGtzU1RKdm4ya0FVUnFRNVRleXZEV0p0eFpFaEE3bE5laXRF?=
 =?utf-8?B?RnJkeHEvRUtYYWR4TXBxbkQ3dndiZzlGdHVXU1h3ejN1TkVGNUVocS9hcHJ0?=
 =?utf-8?B?SEkrVnFhUitGOG91YlV2TkROaGpzWGdLSEQwcXRCN0NxYUZXbHh4RXl2NXBl?=
 =?utf-8?B?bWp3Y0NTcU9ab08xQ1VoeC9SVjN0QXovQzMwS0dydytnSndVMVlHZXMydlNu?=
 =?utf-8?B?cy9TaVFHQmlmUTFGNkRIbDE3bVlKbE1qU1o4b0hPeExCR01yVXlQeVVrbVFt?=
 =?utf-8?B?OWdGQk40SW51YzdNMHllMG82ZDUxaVUvN2pBNTlYaXh5Y010N01BaExVVUVx?=
 =?utf-8?B?T2xwRzJaVjdQUkQ3Q2pBbU10ZnpBdWV1TVVWOEllNkZkVVV1WXBUSTAxVG5L?=
 =?utf-8?B?VmZlMHhGUHdtaEFVS21GbVVWK2tsaXFhU0g0RDFwQi9Vc1MwVFdxeUFrMmZL?=
 =?utf-8?B?UmxyYXBPTTZIbDNyWGd3eDkyekZ1QVlHbCtOR0tQVW9TRDBXcElYTTFHdEZQ?=
 =?utf-8?B?TXhrTnl2ZGYvWlNDUWcxSjczWUZYbTdkRG5GNUR6eUpsb3dGYUl6VEJCdUgy?=
 =?utf-8?B?VWd2UnlEM2xDcTFJUkxPb2hZOWRpU3VtRllvZUFsa2ZoTU5DdlJPL1NPU002?=
 =?utf-8?B?ZHFLMlorTlM4R3BaVDNjQlhJenZLNlFMMXdzeEFFbXQvdFR0U1FVbmQ2RHpX?=
 =?utf-8?B?QTdHTGVldDluS3kvWHlqVmdta1F6S2tRODJ0bmx3WERORHNHa3FGRFZGN0Ju?=
 =?utf-8?B?czJiTTRZdGtiSFhlYkUySlgwS0Qwd0RzV0x5SXgyVFBjdWVCREJoZk9uV1R1?=
 =?utf-8?B?Mkd3d2J2VEd1L2RyV09FVVNuanFmbmxVNVEyWmowcWJpRzZ4WlZnRG5ZempQ?=
 =?utf-8?B?eml0Q3hjdHNjeW95dGlDeEhyVkY3c0NwM0pIYmpYRTFRRnpQK2hnMGdNUEFG?=
 =?utf-8?B?WHJzR1dNSHI0NTNnbXgvOGIxN3NEVGYrMXhLZ0hQblJ6c1hQZ2Zzb3hLd2N0?=
 =?utf-8?B?NWlxZjhnYXJveGFqMUI2UmlDeUU3VDlVS1l2R1dsMUlvYnZIYllWM1BIWFlt?=
 =?utf-8?B?ek90ei9IYWR4dWdGaWtMbnNpaXFRcTBCa0NOcWFJbWZ1VDdDWnNyamdqbXlu?=
 =?utf-8?B?YXE3endxUE84UEo0djN6NlR6Qk9Od0gwTnUxYkZhczB4SFhVTFJNS0pLMGd5?=
 =?utf-8?B?UXU4cVV0OWlkLzJic0YwQ3NNbDJpbjJWeTdQU1hFQjRldlhyNHlNK2xRZDl5?=
 =?utf-8?B?azFhbXgrTkR6cERXTFN3WWxyWmhHb3BVdUpkMDZCUkNyQVYzbFN4dk43Y1NI?=
 =?utf-8?Q?joOSTcr495g8TF6n4Ok7qFg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	rTSCpVeKPQOI/8pIaSl3OetoHdfpWQlTgOKhWHa7vpjqLADNYQaT1RVb05Odec88klpi4kVUQDNT20PbkBjETfQjebxpHHC5p45vBNO9VLLfbMVp8HY3Ar0kyzBDU3k72nLAum1+Mpee8hcSATzbTJO5eXuDXPtdi28lATqVGMkqldm7neh8XXaMU6c2e8LZOn/AhcZXHcCaGo/Kl8xKB0pZFHSryI4OSN8alLVmrFWsM0soS8HvN7jDnp+Zvi7GCRB3Di1Zre9Mdk738qGbhPff1pYzHjs0xDWNPPFkqVwGOeMJB8tR1RFnVhflQ9tPDojkZK0MjeMzY6ZN318oWKGwh8v+nV6O6LelvAWI0BIBOR+Q0Z2W9QHjrw3KDiLHf9A4+cqn8lG3jRssryFsP3kRERYvkc/F4lX4Vnh7P9D+qXUrX5b1nyiBDYTb4lO8HhVuQKFHW1/ONMtPvgdkD8Q4N71DsXj+BF+fyARJu4xNyBYotefisnPPwc13sDWGolaXp8xHVcaTBbuLIzrNQcLpX9VaFbfcdAl7qzmOwNEfqOUBYWb7ZUl2mqbGjG/N8Ixs8ekz1j/XVPeCEN6HVwfOFFvBYVaj9g9S1ysG8r0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88ca293b-fda1-4e5c-d808-08dc49ed772c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 21:25:43.6541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/jM5DtEPBOjQjQfzyF5J2yQzLEKJvgk9NKw+Cqsqi2o3i7+x/QkkXAbR1XuDPPqDUkbpIW6GiArTCkUiohOlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7235
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-21_12,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403140000
 definitions=main-2403210161
X-Proofpoint-GUID: N0IlGWd02wM5Pb--dCzrcZVyfGb8Nphv
X-Proofpoint-ORIG-GUID: N0IlGWd02wM5Pb--dCzrcZVyfGb8Nphv



On 3/21/24 3:48 PM, Dongli Zhang wrote:
> Hi Jonah,
> 
> Would you mind helping explain how does VIRTIO_F_IN_ORDER improve the performance?
> 
> https://lore.kernel.org/all/20240321155717.1392787-1-jonah.palmer@oracle.com/#t
> 
> I tried to look for it from prior discussions but could not find why.
> 
> https://lore.kernel.org/all/BYAPR18MB2791DF7E6C0F61E2D8698E8FA08DA@BYAPR18MB2791.namprd18.prod.outlook.com/
> 
> Thank you very much!
> 
> Dongli Zhang
> 

Hey Dongli,

So VIRTIO_F_IN_ORDER can theoretically improve performance under certain 
conditions. Whether it can improve performance today, I'm not sure.

But, if we can guarantee that all buffers are used by the device in the 
same order in which they're made available by the driver (enforcing a 
strict in-order processing and completion of requests), then we can 
leverage this to our advantage.

For example, we could simplify device and driver logic such as not 
needing complex mechanisms to track the completion of out-of-order 
requests (reduce request management overhead). Though the need of 
complex mechanisms to force this data to be in-order kind of defeats 
this benefit.

It could also improve cache utilization since sequential access patterns 
are more cache-friendly compared to random access patterns.

Also, in-order processing is more predictable, making it easier to 
optimize device and driver performance. E.g. it can allow us to 
fine-tune things without having to account for the variability of 
out-of-order completions.

But again, the actual performance impact will vary depending on the use 
case and workload. Scenarios that require high levels of parallelism or 
where out-of-order completions are efficiently managed, the flexibility 
of out-of-order processing can still be preferable.

Jonah

> On 3/21/24 08:57, Jonah Palmer wrote:
>> The goal of these patches is to add support to a variety of virtio and
>> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
>> indicates that all buffers are used by the device in the same order in
>> which they were made available by the driver.
>>
>> These patches attempt to implement a generalized, non-device-specific
>> solution to support this feature.
>>
>> The core feature behind this solution is a buffer mechanism in the form
>> of GLib's GHashTable. The decision behind using a hash table was to
>> leverage their ability for quick lookup, insertion, and removal
>> operations. Given that our keys are simply numbers of an ordered
>> sequence, a hash table seemed like the best choice for a buffer
>> mechanism.
>>
>> ---------------------
>>
>> The strategy behind this implementation is as follows:
>>
>> We know that buffers that are popped from the available ring and enqueued
>> for further processing will always done in the same order in which they
>> were made available by the driver. Given this, we can note their order
>> by assigning the resulting VirtQueueElement a key. This key is a number
>> in a sequence that represents the order in which they were popped from
>> the available ring, relative to the other VirtQueueElements.
>>
>> For example, given 3 "elements" that were popped from the available
>> ring, we assign a key value to them which represents their order (elem0
>> is popped first, then elem1, then lastly elem2):
>>
>>       elem2   --  elem1   --  elem0   ---> Enqueue for processing
>>      (key: 2)    (key: 1)    (key: 0)
>>
>> Then these elements are enqueued for further processing by the host.
>>
>> While most devices will return these completed elements in the same
>> order in which they were enqueued, some devices may not (e.g.
>> virtio-blk). To guarantee that these elements are put on the used ring
>> in the same order in which they were enqueued, we can use a buffering
>> mechanism that keeps track of the next expected sequence number of an
>> element.
>>
>> In other words, if the completed element does not have a key value that
>> matches the next expected sequence number, then we know this element is
>> not in-order and we must stash it away in a hash table until an order
>> can be made. The element's key value is used as the key for placing it
>> in the hash table.
>>
>> If the completed element has a key value that matches the next expected
>> sequence number, then we know this element is in-order and we can push
>> it on the used ring. Then we increment the next expected sequence number
>> and check if the hash table contains an element at this key location.
>>
>> If so, we retrieve this element, push it to the used ring, delete the
>> key-value pair from the hash table, increment the next expected sequence
>> number, and check the hash table again for an element at this new key
>> location. This process is repeated until we're unable to find an element
>> in the hash table to continue the order.
>>
>> So, for example, say the 3 elements we enqueued were completed in the
>> following order: elem1, elem2, elem0. The next expected sequence number
>> is 0:
>>
>>      exp-seq-num = 0:
>>
>>       elem1   --> elem1.key == exp-seq-num ? --> No, stash it
>>      (key: 1)                                         |
>>                                                       |
>>                                                       v
>>                                                 ================
>>                                                 |key: 1 - elem1|
>>                                                 ================
>>      ---------------------
>>      exp-seq-num = 0:
>>
>>       elem2   --> elem2.key == exp-seq-num ? --> No, stash it
>>      (key: 2)                                         |
>>                                                       |
>>                                                       v
>>                                                 ================
>>                                                 |key: 1 - elem1|
>>                                                 |--------------|
>>                                                 |key: 2 - elem2|
>>                                                 ================
>>      ---------------------
>>      exp-seq-num = 0:
>>
>>       elem0   --> elem0.key == exp-seq-num ? --> Yes, push to used ring
>>      (key: 0)
>>
>>      exp-seq-num = 1:
>>
>>      lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>                                               remove elem from table
>>                                                       |
>>                                                       v
>>                                                 ================
>>                                                 |key: 2 - elem2|
>>                                                 ================
>>
>>      exp-seq-num = 2:
>>
>>      lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>                                               remove elem from table
>>                                                       |
>>                                                       v
>>                                                 ================
>>                                                 |   *empty*    |
>>                                                 ================
>>
>>      exp-seq-num = 3:
>>
>>      lookup(table, exp-seq-num) != NULL ? --> No, done
>>      ---------------------
>>
>> Jonah Palmer (8):
>>    virtio: Define InOrderVQElement
>>    virtio: Create/destroy/reset VirtQueue In-Order hash table
>>    virtio: Define order variables
>>    virtio: Implement in-order handling for virtio devices
>>    virtio-net: in-order handling
>>    vhost-svq: in-order handling
>>    vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>>    virtio: Add VIRTIO_F_IN_ORDER property definition
>>
>>   hw/block/vhost-user-blk.c          |   1 +
>>   hw/net/vhost_net.c                 |   2 +
>>   hw/net/virtio-net.c                |   6 +-
>>   hw/scsi/vhost-scsi.c               |   1 +
>>   hw/scsi/vhost-user-scsi.c          |   1 +
>>   hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
>>   hw/virtio/vhost-user-fs.c          |   1 +
>>   hw/virtio/vhost-user-vsock.c       |   1 +
>>   hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
>>   include/hw/virtio/virtio.h         |  20 +++++-
>>   net/vhost-vdpa.c                   |   1 +
>>   11 files changed, 145 insertions(+), 7 deletions(-)
>>
