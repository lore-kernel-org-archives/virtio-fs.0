Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6F316FF22
	for <virtio-fs@lists.linux.dev>; Fri,  5 Apr 2024 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712331498; cv=fail; b=BuLqeWm9Q+iYnYzFIGT0PU1APFh3sTN+uikbYYqSI4OvYbWcc1lVTwjmCNXiRPni5kFi3nVRXhVplOEz6UNyE9Lj84w5BJaaxTv9bUlYd8Hwrtj+3edviprcpe0OsoUscF54zcc9AmILihKlYHdk2lQUhBhNK/c9xnqOrkMbxKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712331498; c=relaxed/simple;
	bh=1oqXF3j6DZmaWEIGR8t8dx6D0E6vpCSJAfv8xE+ORvY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BWF6oUIMsG92YnWBCc62UCDnw5skvEQMNxPbyV5HlySRYwOUOqpYoi5U0LTCY+76DVDSHw92+yOGzq9NhUQZNpKFfV8oaMkGHNO38mos/T6VYwd4K7oVF7qi9nCJx4N4MROpuckRmDbU+eEmjlY4L5gSOHlsPvxecTdXRCOmnqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bWIMN7xw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=y9ylEjLP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bWIMN7xw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="y9ylEjLP"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 435F3bqP009209;
	Fri, 5 Apr 2024 15:38:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=SpzDG/X7S+xeNjzVHlr26h3QGN6iMDS4AubEMCRe4Rc=;
 b=bWIMN7xw1QZEc59cBrvfVkBy3Ikz+wcTPJmipYWTclfdkDxKWslx1Pfma5HUasXonyma
 udEzKOzlWN2K6f1Hm3xwaWmH6uJ+VFUNqSLUiGpnsyH4gUKUeX3F+ViQ1HVs7kf8Czyx
 oR+A/w6q2s8icApx6adwlKfK7lbuDmw6yT8PyTtCvqbsDd96iUkkm59p0ztTNds0tAfC
 zwXBO8hGqSrF80Ugb8iZM07K2Rr/wjeUTGACMyCE5G7YBQqw1ogrIYVRZppY5/Lpu+3I
 IYl1Xg4AZ/PHPAWzlSM/l6SxgWhGy0gX6WtnqFb2Dso61ascWrNSc8/p+wsIQkz17kPO jg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9emtku10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 15:38:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 435FW8dw039049;
	Fri, 5 Apr 2024 15:38:04 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emsrrk6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 15:38:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kzvkPgP6Sh92V1TfFbWaGvvVvkBh+/R8VbhK+bdS/rLB7k8o1TQO+7d0yfzFvRThJumuVugtqj61WI/KOYAXGHo2h7gOqCLEqo/sS28HBVdRIIxmIEvouRktV/MgneiLCa410/pva00u+7dhp6yAW1DQ6n+p3HXMGTVhkIe8RxB3AVHqb2KXopYBnjoVZFr9bl2tYfSU1zUQdit+z2XdmNZMqpSqlRAXrKE7Tr/nOiDmAC8YBNeJgpaqO02ZwnSqxRv2CWcxEqso9tsuuYMB4JnfsB3ajrGrswRMCBufFRmErf2GPQNskIJUpM1dfJ04+GI6G0hNqXA6SrXC+eMWkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SpzDG/X7S+xeNjzVHlr26h3QGN6iMDS4AubEMCRe4Rc=;
 b=ViDeWjNpbyPoIsOMgVolLlg70vP4cYxg8b7FeASY1ql4WwlnUmr7XcU2tPTZ4+V0dSYtYzqz2SmBBoFtFN/t48DjjUDfnf1jkRUiVA4kwQFzpY8EJI6+wUM43OJFnE49qJsqYmFbW6Gr2DJ6jZboxHCaz3zfVZ7i+VbL8MgAjfCsaN0wCQ6XpSM10X/aWTSkfElCaE0rYQjsFDYcdgTK+asgqjo5wRL9Duck3PhZlUu1gdWq00gBMlgYsVRIl60yqOmSVfyu2L0I3hK5Ej4fr2alNXogDBOWOqJI5oWpb8Ylvn2RO4ID8Wwu1do9pq91q8l90u1t1Bj1OV6D4kpKpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpzDG/X7S+xeNjzVHlr26h3QGN6iMDS4AubEMCRe4Rc=;
 b=y9ylEjLPe/oK21nG0rhI8+UUjvAaFDVd7ORDdP72Gn91g90HrRqB34+hY7rLRPKjOgPowArwYZZtyenEmo7XEAVo7ZwTQdu03haG7PaAYTFlCiGsayS/LkM8i8yW2a2bvOi4E9Kk+1KYhbIiLi/84kdmEbZtWCoguqk27HEtYV8=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH8PR10MB6409.namprd10.prod.outlook.com (2603:10b6:510:1c4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 15:38:01 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 15:38:01 +0000
Message-ID: <6ff2ba6b-f77f-41f0-acda-dfa964d12985@oracle.com>
Date: Fri, 5 Apr 2024 11:37:57 -0400
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
 <c1e78d58-53bb-4091-b775-3d4a004a8bfd@oracle.com>
 <CAJaqyWdZQpYUK=bNe1UsV-5F+U=JC3rkN6YEYxid-Zmha+WCpQ@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWdZQpYUK=bNe1UsV-5F+U=JC3rkN6YEYxid-Zmha+WCpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR10CA0022.namprd10.prod.outlook.com
 (2603:10b6:510:23d::6) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH8PR10MB6409:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	c3v2f7E7PvIPcvIxf7OPa7luqZcsgXnWNRTIQqUIIXHhqL6eHUt1o8D9hBJPzQiU5/WzOB7aph0gyFR06mcv3GvQf9/jUYZZoTjGShvutkxf9Ocz6wXC49A0z3YyRbQjF+9GyauHamd/BdGE7P+lkyfd+fIPmnTHDt6gJrAD9/bpg3bY9I5O8eRH//rkQ4um9+0pgOjRFXDfkb75IPuuqX8cPj3MCs+4ipBHRq4WKp1icKqQEhk2DB8pqVGXo+joYIHS9EkECYWVEM3xOjZ693FaLdw6vWpcqrIN49B1mAjR4eJUts7xcfAQ1KQhirh3B9L0cTN8Nx3LoqJ1XGy2F6Jm+vnCQpJ81+J0P8d36BHKFH0i6iHnRKyzMvbkPUd8NgBUJQBHPImowRxJhlM7xlOZHs9pBOSIeZMvRtCyuZtS0IlHt7txGpIcC3GlNbgK5uZqSNChVN7moWCHfK9fklowTIaiQCEII368Y1jAUFFSZIewDgvrhVj5uyfT+BRiimZ30qadRv+wh2QVdKojE88YHCTKDd1FeIfA04wEIiEA1LsMcgp8LZVMmDm8Ark5PPUGOjJrua/ecuoVfqH1a+5QI0mWgJ0fcizqVZrmAiZvcDT773/U5qllohETBUPukwuV4jWTHaIaplP2382Qe6hO10TjrdbeMrkyX14ZlZM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?U21jTnJ5MmcrZnF3Q05PRGNnS1JUb0Z3RG1aa004WDA2SHFUbXY0ODFxT2hy?=
 =?utf-8?B?dkdsUnIvNkc2UHgwQkJPRzdWTy9RaEZrMllCWnZBWmtKV1dZNjM2QkVjUytJ?=
 =?utf-8?B?YzBtV095SkFxYTFNR1YxM0NoZTdTYVZjSXhyMFJlUU1sSFYrR3dhelNybXBT?=
 =?utf-8?B?TXk4dGdjZGgvd0thMC84ZFM2SHQ4b2hVbDJxYTY1VzhraDBWV3c1dldYV2x1?=
 =?utf-8?B?OXJwcndqM2s1SHBObExUNTZ1UGR5WjZEZi9hQmY4dUpmRURNTmJnV0tjSDhs?=
 =?utf-8?B?cCtITjVPYldEWC92bkxwSW5GRUtjZ3ZUeVNlSUwyQ2Y1R0EwSG1PcHZ2dmNE?=
 =?utf-8?B?TVB5eG4wVG5EczdOS2Z1WU9qa1MwWjJDV214NW0rdHgwQ1dYMHZHS3pzL3dK?=
 =?utf-8?B?RkFVR1hNYno2Si9NMkpHRmhseFlQNkluS3Rhd3ZFcm16UUc2cmNUdzEvcUxa?=
 =?utf-8?B?OFhyZzFiMzBLVjZweWZQRFZCZGpvK3RWakxqOHFTLzlWU1FIY1VDWit6Q2Nv?=
 =?utf-8?B?UW9NYjJQblg4dVhkamVTMlo0NXRzUGhQQTJNbitrZUF0cHZqTUlqS1BrS3NI?=
 =?utf-8?B?ZUc3eXp0M3RFVGpBek4vQ3NFRExuZTUxaS9WVVVHcnpYRGxzc0VFN2ZTV1J4?=
 =?utf-8?B?TlRaVTA4WDVEQTNOZ3Y1Ryt4Sm80b2orVkNXMUtWMEMvcXFDVGNETzZ0NXZl?=
 =?utf-8?B?Tk1Za3FJYy8zODZzV0FYMTRCVGpXNWRaQjBtcVJkMlBoY3pwNjI5d0VkT2du?=
 =?utf-8?B?TkJzNzF6RGdsQkxoOHErdnlOY2xYL1dpaHhJbUNVelB1aU1PSWEvelcrZWFk?=
 =?utf-8?B?YmhSR1M2dHpxQk53ZCtZZXg1MWdhbTlNenRML1M1V0JlUXFJZEc4bzhMN0NE?=
 =?utf-8?B?dzdhMjA5dVNsUHprOVVuSjd6a0hyRHcyOFRKL2lIRTdpVUdOak1ubTBHNWJX?=
 =?utf-8?B?aGNwSk9zellLNC9JK0lVRGgvSjc4bHljanF0Q0R1RU9Qc00xSFBqQXM5QWtr?=
 =?utf-8?B?d0VRY3NCTkVLVndzUFlIcndFMDhjTjErTlV6azFMbGpETVlHYXBGSHF3MlJh?=
 =?utf-8?B?K0Y1S3ZhWmFuVDBvTk1JdE9GZUduSmFIblhnRzFCZmtja1R4Smo2b3FwMlY4?=
 =?utf-8?B?M3MwVE9POERLckVXZG5FQnkzaHNiOUowaFdzRlcxYVo1UjJoZ3RodXFXRHdU?=
 =?utf-8?B?alVRWHNmN3RuTjlZTG96TkYvZHF3QUF5MXZyM0puS0dseEVnaG4zaEMxalkx?=
 =?utf-8?B?QmV6ckNGVk1tdHlsc3hiQnlRdnJ3dHk3b3RmQy9NNHl5L1daT1Mxb0NhUHdp?=
 =?utf-8?B?OGtVWmZ0VUwvY2pxc08zK0FGLzlWVGgrTWlveUtGTURNNG1ubUlZSUdTTml0?=
 =?utf-8?B?WkdCbXQxVmJBTU5ONTJ5cGdrWTgvOG16V25BRzhvam9TQlVDL29WUTduQlhS?=
 =?utf-8?B?NmI4UzRWRTd5cjJXNjVwV3VHak1lVUZMVWx5WG9RdUtHdlFuT1E4WloyZU52?=
 =?utf-8?B?TklFTDlQVzNWVXFseU90UU9nYW1DYllaYVMxNzJES0E4MGpSY0YvdzBWcmt1?=
 =?utf-8?B?dmNKTnMxUWNJR2tHSEl6VUk5ZWtTTFVMN2pWWS83YmVjeDd2ODlJbStabXBh?=
 =?utf-8?B?YjhaYXVkMy9MRGhaVTZiTUovRUxSL3hzenVBNUNQampLNjl3NmpzZGdVbjZh?=
 =?utf-8?B?SmVTalhYWEJJZDhjREFwam1WajFSL1ZYb3lETUs1T3RJUTdtSXRCR0ZQb3hz?=
 =?utf-8?B?L0t2TjVQV2dENi9TNEFEY1FWZTI5WjFjbURLNGVCaWV5S3ROZVkvelp2K3F3?=
 =?utf-8?B?RU1vMDJFZHNheWRsZTJSb1QzdG1ndWVFb1hDbVBaU3BHaFRQVVM3UnpYMzJY?=
 =?utf-8?B?MzMvOHlrcVloNk44eTlmZlp5clF4c0hpcDVKY0ZMMGlJYnBSbnZLTFNFVGNi?=
 =?utf-8?B?eHAyVTlESi9uRkFpWXliMStqM21wc0w0eHdkSkZ6NE1qSHZYMkViRUE2Sy9o?=
 =?utf-8?B?WUE2OG5mdGRFY3ArRDR0OThSS1dqS280WDlld3lXcU5hR1BmZmN2UEhOSFJS?=
 =?utf-8?B?OCtHVzltbUhEcFFIWERGWnlKVHB5d2RFdTVyRUZ2aHl3Z1MxWUgzVzlWWWZm?=
 =?utf-8?B?YmpvNWpyWHMyUitZNCt1WW84T200bmJSNzhUUmVod0h3VmNJeGRBMU43bU9U?=
 =?utf-8?Q?/mipvzFuXvYLc4LX0CGmpMc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	LDv3dUXiNG5TJ9ReZ+RnZx36v4uQAEE+IBibgSAnOJ3juYF8uhrywAfg9wXRkp87O5vzjKWpX0XWXxmGSmj03B66not4OXQAFSmqholIDZfP5ltwRl4t593roA0BljXAuqck5Kb/bIHTciOxaCRup7otfMu4Lds76exXorupgGcjKSjy7qe9jktzW6UilKBGjUhz+RwahMfs4F5GVsFwi+y/apHNv68omZ8M4C+33FVtvrF51t5RFRMhDxatNUIsOviGWYwARz9NL98CsQF2m6m79IouqcgRgI0jwz7KiGOTg72aXWojGkSxchaKlk+wkoetoFBkPHDgCYDYdVJTZpOjrcF/bLWKLptRyPhi/vZSfsJTmWOpjTLDwj4i+g2/lx/5k6Kq6a4YWZ2WHq/ZDVmM6jH8XFJJtOyc48U/Mavl3qcacxlM2cn6/KX66haXS176hci1GE3jashzgDZVLQwz9jQzdY1hvNuWBcr/NlXeSmmHc/LeXlJD/u2rwrY/xy7Z3EASWJCGbwqyPLbswZhpkyh35Lf3pzeVoXnOWztYNGNKwZh21Q/X1enQF/In2OW+UfekDM8O4JDwUj7GaTJ7N5AFmiiCPeN9StsYsKY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fc2068-7054-4212-067a-08dc55866039
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 15:38:00.9377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXErgOA59VVo0grGxmtorvwKTRJe58VgXTKLVNl48FohJDdt3uHo44iFXLaYkrBWgNwbtfGNJHsJ5Z4y04YY1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6409
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_16,2024-04-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050112
X-Proofpoint-GUID: NF8S112YwvSiHRvkgb_K9ZCi6EqD62_r
X-Proofpoint-ORIG-GUID: NF8S112YwvSiHRvkgb_K9ZCi6EqD62_r



On 4/5/24 11:04 AM, Eugenio Perez Martin wrote:
> On Fri, Apr 5, 2024 at 3:59 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 4/4/24 12:33 PM, Eugenio Perez Martin wrote:
>>> On Thu, Apr 4, 2024 at 4:42 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>>
>>>>
>>>> On 4/4/24 7:35 AM, Eugenio Perez Martin wrote:
>>>>> On Wed, Apr 3, 2024 at 6:51 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 4/3/24 6:18 AM, Eugenio Perez Martin wrote:
>>>>>>> On Thu, Mar 28, 2024 at 5:22 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>>>
>>>>>>>> Initialize sequence variables for VirtQueue and VirtQueueElement
>>>>>>>> structures. A VirtQueue's sequence variables are initialized when a
>>>>>>>> VirtQueue is being created or reset. A VirtQueueElement's sequence
>>>>>>>> variable is initialized when a VirtQueueElement is being initialized.
>>>>>>>> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
>>>>>>>>
>>>>>>>> A VirtQueue's used_seq_idx represents the next expected index in a
>>>>>>>> sequence of VirtQueueElements to be processed (put on the used ring).
>>>>>>>> The next VirtQueueElement added to the used ring must match this
>>>>>>>> sequence number before additional elements can be safely added to the
>>>>>>>> used ring. It's also particularly useful for helping find the number of
>>>>>>>> new elements added to the used ring.
>>>>>>>>
>>>>>>>> A VirtQueue's current_seq_idx represents the current sequence index.
>>>>>>>> This value is essentially a counter where the value is assigned to a new
>>>>>>>> VirtQueueElement and then incremented. Given its uint16_t type, this
>>>>>>>> sequence number can be between 0 and 65,535.
>>>>>>>>
>>>>>>>> A VirtQueueElement's seq_idx represents the sequence number assigned to
>>>>>>>> the VirtQueueElement when it was created. This value must match with the
>>>>>>>> VirtQueue's used_seq_idx before the element can be put on the used ring
>>>>>>>> by the device.
>>>>>>>>
>>>>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>>>>> ---
>>>>>>>>      hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>>>>>>>      include/hw/virtio/virtio.h |  1 +
>>>>>>>>      2 files changed, 19 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>>>>>> index fb6b4ccd83..069d96df99 100644
>>>>>>>> --- a/hw/virtio/virtio.c
>>>>>>>> +++ b/hw/virtio/virtio.c
>>>>>>>> @@ -132,6 +132,10 @@ struct VirtQueue
>>>>>>>>          uint16_t used_idx;
>>>>>>>>          bool used_wrap_counter;
>>>>>>>>
>>>>>>>> +    /* In-Order sequence indices */
>>>>>>>> +    uint16_t used_seq_idx;
>>>>>>>> +    uint16_t current_seq_idx;
>>>>>>>> +
>>>>>>>
>>>>>>> I'm having a hard time understanding the difference between these and
>>>>>>> last_avail_idx and used_idx. It seems to me if we replace them
>>>>>>> everything will work? What am I missing?
>>>>>>>
>>>>>>
>>>>>> For used_seq_idx, it does work like used_idx except the difference is
>>>>>> when their values get updated, specifically for the split VQ case.
>>>>>>
>>>>>> As you know, for the split VQ case, the used_idx is updated during
>>>>>> virtqueue_split_flush. However, imagine a batch of elements coming in
>>>>>> where virtqueue_split_fill is called multiple times before
>>>>>> virtqueue_split_flush. We want to make sure we write these elements to
>>>>>> the used ring in-order and we'll know its order based on used_seq_idx.
>>>>>>
>>>>>> Alternatively, I thought about replicating the logic for the packed VQ
>>>>>> case (where this used_seq_idx isn't used) where we start looking at
>>>>>> vq->used_elems[vq->used_idx] and iterate through until we find a used
>>>>>> element, but I wasn't sure how to handle the case where elements get
>>>>>> used (written to the used ring) and new elements get put in used_elems
>>>>>> before the used_idx is updated. Since this search would require us to
>>>>>> always start at index vq->used_idx.
>>>>>>
>>>>>> For example, say, of three elements getting filled (elem0 - elem2),
>>>>>> elem1 and elem0 come back first (vq->used_idx = 0):
>>>>>>
>>>>>> elem1 - not in-order
>>>>>> elem0 - in-order, vq->used_elems[vq->used_idx + 1] (elem1) also now
>>>>>>             in-order, write elem0 and elem1 to used ring, mark elements as
>>>>>>             used
>>>>>>
>>>>>> Then elem2 comes back, but vq->used_idx is still 0, so how do we know to
>>>>>> ignore the used elements at vq->used_idx (elem0) and vq->used_idx + 1
>>>>>> (elem1) and iterate to vq->used_idx + 2 (elem2)?
>>>>>>
>>>>>> Hmm... now that I'm thinking about it, maybe for the split VQ case we
>>>>>> could continue looking through the vq->used_elems array until we find an
>>>>>> unused element... but then again how would we (1) know if the element is
>>>>>> in-order and (2) know when to stop searching?
>>>>>>
>>>>>
>>>>> Ok I think I understand the problem now. It is aggravated if we add
>>>>> chained descriptors to the mix.
>>>>>
>>>>> We know that the order of used descriptors must be the exact same as
>>>>> the order they were made available, leaving out in order batching.
>>>>> What if vq->used_elems at virtqueue_pop and then virtqueue_push just
>>>>> marks them as used somehow? Two booleans (or flag) would do for a
>>>>> first iteration.
>>>>>
>>>>> If we go with this approach I think used_elems should be renamed actually.
>>>>>
>>>>
>>>> If I'm understanding correctly, I don't think adding newly created
>>>> elements to vq->used_elems at virtqueue_pop will do much for us.
>>>
>>> By knowing what descriptor id must go in each position of the used ring.
>>>
>>> Following your example, let's say avail_idx is 10 at that moment.
>>> Then, the driver makes available the three elements you mention, so:
>>> used_elems[10] = elem0
>>> used_elems[11] = elem1
>>> used_elems[12] = elem2
>>>
>>> Now the device uses elem1. virtqueue_push can search linearly for
>>> elem->index in used_elems[used_idx]...used_elems[avail_idx] range. As
>>> the device is mis-behaving, no need to optimize this behavior.
>>> used_elems[11].index == elem->index, so we mark it as used somehow.
>>> Let's say we add a boolean to VirtQueueElement.
>>>
>>> virtqueue_flush can scan used_elems[used_idx]...used_elems[avail_idx]
>>> looking for used elements. At this moment used_elems[used_idx] is not
>>> used so it stops there.
>>>
>>> Now elem0 is pushed. It is the first one in the
>>> used_elems[used_idx]...used_elems[avail_idx] range, so we can write it
>>> to the used ring at fill. used_idx++. We use the rest of the
>>> descriptor until we find one in used_elems that is not used, which is
>>> used_elems[12].
>>>
>>> After that virtqueue_flush is called. At its scanning, used_elems[10]
>>> is used, so it writes it to the used ring. After that, used_elems[11]
>>> is also used, so it is written also. used_elems[12] is not used, so it
>>> stops there.
>>>
>>> Finally, elem2 is pushed, so used_elems[12] is written.
>>> virtqueue_flush detects it, so it writes it to the guest's used ring.
>>>
>>> Let me know what you think. I find it simpler than declaring new
>>> indexes, but I may be wrong.
>>>
>>
>> I think I see where you're getting at, but I just have a few clarifying
>> questions about your proposal here.
>>
>> So you're proposing to add entries to used_elems at virtqueue_pop, ok.
>>
>> avail_idx = 10, then the driver makes some new entries (elems) available
>> in the avail ring:
>>
>> used_elems[10] = elem0
>> used_elems[11] = elem1
>> used_elems[12] = elem2
>>
>> At this point, avail_idx = 13, used_idx = 10.
>>
>> elem1 gets used first, ok.
>>
>> Now, if I'm understanding correctly, you're saying that in
>> virtqueue_push explicitly (not virtqueue_fill/virtqueue_flush), we scan
>> used_elems[used_idx] - used_elems[avail_idx] to find used_elems[i].index
>> == elem->index and mark it as used, e.g. used_elems[i].used = true.
>> Okay, now used_elems[11] has been marked as used.
>>
>> Now we make it to virtqueue_fill. What's the role you want
>> virtqueue_fill to take here (if any)?
>>
> 
> Sorry I meant virtqueue_fill here.
> 
>> You say that after we mark this element as used, we go to
>> virtqueue_flush and scan for used elements in used_elems[used_idx] -
>> used_elems[avail_idx]. Of course, the first one of this order will be in
>> used_elems[used_idx], which is currently showing the element as unused,
>> so we're done with this element for now.
>>
>> So, what exactly is the role of virtqueue_flush here? I'm inferring here
>> that you want the virtqueue_flush role (for split VQs) to do both the
>> writing to the used ring (normally done in virtqueue_fill) as well as
>> updating the used_idx (normally done in virtqueue_flush). Is this correct?
>>
> 
> I modelled this after the packed vq scenario, where all is updated at
> _flush. But yes, I think you got it totally right.
> 
>> Next, elem0 gets used second.
>>
>> Again, in virtqueue_push we scan scan used_elems[used_idx] -
>> used_elems[avail_idx] to find used_elems[i].index == elem->index and
>> mark it as used. Okay, used_elems[10] has been marked as used.
>>
>> Then you say, "It is the first one in the used_elems[used_idx] -
>> used_elems[avail_idx] range, so we can write it to the used ring at
>> fill. used_idx++. We use the rest of the descriptor until we find one in
>> used_elems that is not used, which is used_elems[12]."
>>
>> This, to me, sounds like "in virtqueue_fill, when we find an order (e.g.
>> used_elems[used_idx].index == elem->index) write it to the used ring AND
>> increment the used_idx. Keep writing elements to the used ring if
>> used_elems[used_idx].used == true and, for each element being written,
>> incremented used_idx."
>>
>> This is a bit confusing to me since next you say "After that,
>> virtqueue_flush is called. At its scanning, used_elems[10] is used, so
>> it writes it to the used ring. After that, used_elems[11] is also used,
>> so it is written also. used_elems[12] is not used, so it stops there."
>>
>> This sounds very similar to what you proposed for virtqueue_fill, except
>> it looks like you're also saying to do this in virtqueue_flush, hence my
>> confusion.
>>
>> If you wouldn't mind, could you clarify the roles of virtqueue_fill and
>> virtqueue_flush here for me? Thanks :)!
>>
> 
> I see how they're confusing if following the split vq way, sorry!
> * _fill: Only update used_elems (or equivalent)
> * _flush: Write information to used ring or descriptor ring.
> 

Thank you for the clarification Eugenio! This makes sense to me now :) 
I'll get started on a v3 RFC.

Or should I send this next one as a patch?

>>> This makes it difficult to actually batch used descriptors. My
>>> proposal is to address it in another series, by delegating it to the
>>> caller and recovering proper usage of virtqueue_push(idx) parameter.
>>> The caller can specify either to batch as usual, or to delegate the
>>> automatic (and potentially inefficient) ordering I'm proposing here.
>>>
>>
>> Just to be clear, for this series, you'd like me to implement a solution
>> that does *not* consider the case where virtqueue_fill is called
>> multiple times before virtqueue_flush (and to put a solution for this in
>> a separate series)?
>>
> 
> No, it is supported. It is just not very efficient because of the linear search.
> 
> For it to be supported properly the caller should indicate
> virtqueue_fill idx properly. But that requires modifications to all
> devices, so I'm proposing to do it on top.
> 

Ahh I see now. Thank you for clarifying that!

Thanks again!

Jonah

>> Are we not concerned that we might shoot ourselves in the foot here by
>> implementing a process that may not work well for a batching solution,
>> especially when we have an almost-working solution for batching and
>> non-batching cases?
>>
>>>> We
>>>> could just keep adding processed elements to vq->used_elems at
>>>> virtqueue_fill but instead of:
>>>>
>>>> vq->used_elems[seq_idx].in_num = elem->in_num;
>>>> vq->used_elems[seq_idx].out_num = elem->out_num;
>>>>
>>>> We could do:
>>>>
>>>> vq->used_elems[seq_idx].in_num = 1;
>>>> vq->used_elems[seq_idx].out_num = 1;
>>>>
>>>> We'd use in_num and out_num as separate flags. in_num could indicate if
>>>> this element has been written to the used ring while out_num could
>>>> indicate if this element has been flushed (1 for no, 0 for yes). In
>>>> other words, when we go to write to the used ring, start at index
>>>> vq->used_idx and iterate through the used elements.
>>>>
>>>> If a used element's in_num and out_num == 0, then this element is
>>>> invalid (not yet processed) and we stop the search.
>>>>
>>>> If a used element's in_num and out_num == 1, then this element is valid,
>>>> written to the used ring, in_num is set to 0, and the search continues.
>>>>
>>>> Lastly, if a used element's in_num == 0 but out_num == 1, then this
>>>> element has already been written to the used ring but not yet flushed,
>>>> so ignore this element and continue searching.
>>>>
>>>> There should never be a case where in_num == 1 and out_num == 0.
>>>>
>>>> However, this would probably mean that before (or right after) we
>>>> actually perform the flush we'll have to iterate through the used_elems
>>>> array one more time and set their out_num's to 0 to indicate the element
>>>> has been flushed.
>>>>
>>>> Again, this is just for the batched split VQ case where we have to keep
>>>> track of elements that have been written but not flushed and elements
>>>> that have been written and flushed, given that we don't know which
>>>> elements have actually been written to the used ring until the used_idx
>>>> is updated.
>>>>
>>>> This approach appears more costly though if we're really trying to avoid
>>>> having this new used_seq_idx VirtQueue member.
>>>>
>>>>>> In any case, the use of this variable could be seen as an optimization
>>>>>> as its value will tell us where to start looking in vq->used_elems
>>>>>> instead of always starting at vq->used_idx.
>>>>>>
>>>>>> If this is like a one-shot scenario where one element gets written and
>>>>>> then flushed after, then yes in this case used_seq_idx == used_idx.
>>>>>>
>>>>>> ------
>>>>>>
>>>>>> For current_seq_idx, this is pretty much just a counter. Every new
>>>>>> VirtQueueElement created from virtqueue_pop is given a number and the
>>>>>> counter is incremented. Like grabbing a ticket number and waiting for
>>>>>> your number to be called. The next person to grab a ticket number will
>>>>>> be your number + 1.
>>>>>>
>>>>>
>>>>> So it's like last_avail_idx, isn't it?
>>>>>
>>>>
>>>> For the split VQ case, pretty much. Though if we hit this case in
>>>> virtqueue_split_pop, we may get into some trouble:
>>>>
>>>> if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
>>>>        goto done;
>>>> }
>>>>
>>>
>>> That's a fatal mistake and the device breaks, vdev->broken = true. It
>>> cannot be used anymore from that point on, because of all the checks
>>> of that variable.
>>>
>>> Does that solve the problem?
>>>
>>
>> Ah, it does. My apologies, I should've recognized this would result in
>> the device breaking.
>>
>>>> However for the packed VQ case, last_avail_idx might not work in the way
>>>> we'd need it to for this implementation. In virtqueue_packed_pop, we see
>>>> this:
>>>>
>>>> elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
>>>> vq->last_avail_idx += elem->ndescs;
>>>>
>>>> It would appear as though last_avail_idx is incremented by total number
>>>> of descriptors associated with the element, which can be greater than 1.
>>>> This implementation increments by 1 for each element.
>>>>
>>>> Actually... It's good you mentioned this because I think my packed VQ
>>>> implementation is wrong. For packed VQs, vq->used_idx is incremented by
>>>> the total number of descriptors in the flushed elements and not
>>>> necessarily the number of elements being flushed like in the split VQ
>>>> case. I'm adding elements to vq->used_elems in a per-element sequence
>>>> rather than going by the number of descriptors an element holds, which
>>>> should be the case for packed VQs.
>>>>
>>>
>>> If you keep it by your proposed index I think you can increase it one
>>> per head, as they are the entries that are written in both cases.
>>> unsed_idx should increment properly already.
>>>
>>> If you move to my proposal, both should increase by elem->ndescs as
>>> you suggest here.
>>>
>>
>> Ack! Thanks!
>>
>>>>>> Let me know if I'm making any sense. Thanks :)
>>>>>>
>>>>>> Jonah
>>>>>>
>>>>>>>>          /* Last used index value we have signalled on */
>>>>>>>>          uint16_t signalled_used;
>>>>>>>>
>>>>>>>> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>>>>>>>              elem->in_sg[i] = iov[out_num + i];
>>>>>>>>          }
>>>>>>>>
>>>>>>>> +    /* Assign sequence index for in-order processing */
>>>>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>>>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>>          vq->inuse++;
>>>>>>>>
>>>>>>>>          trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>>>>>> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>>>>>>>          vq->shadow_avail_idx = vq->last_avail_idx;
>>>>>>>>          vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
>>>>>>>>
>>>>>>>> +    /* Assign sequence index for in-order processing */
>>>>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>>>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>>          trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>>>>>>      done:
>>>>>>>>          address_space_cache_destroy(&indirect_desc_cache);
>>>>>>>> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
>>>>>>>>          vdev->vq[i].notification = true;
>>>>>>>>          vdev->vq[i].vring.num = vdev->vq[i].vring.num_default;
>>>>>>>>          vdev->vq[i].inuse = 0;
>>>>>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>>>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>>>>>          virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
>>>>>>>>      }
>>>>>>>>
>>>>>>>> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
>>>>>>>>          vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>>>>>>>>          vdev->vq[i].handle_output = handle_output;
>>>>>>>>          vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
>>>>>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>>>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>>>>>
>>>>>>>>          return &vdev->vq[i];
>>>>>>>>      }
>>>>>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>>>>>> index b3c74a1bca..910b2a3427 100644
>>>>>>>> --- a/include/hw/virtio/virtio.h
>>>>>>>> +++ b/include/hw/virtio/virtio.h
>>>>>>>> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
>>>>>>>>          hwaddr *out_addr;
>>>>>>>>          struct iovec *in_sg;
>>>>>>>>          struct iovec *out_sg;
>>>>>>>> +    uint16_t seq_idx;
>>>>>>>>      } VirtQueueElement;
>>>>>>>>
>>>>>>>>      #define VIRTIO_QUEUE_MAX 1024
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 
