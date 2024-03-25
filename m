Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5D2F2D
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711385556; cv=fail; b=Fw5sKHrqZpqisXWv6r0ABiuUr+dnmE4kvY8Jq692igaAFK/T7o54nM7/UpJJphYVZwVDHmO0R3Y/L8uMFZNhrdWTPR7CX0EmHWl+JZ99hsyn3Vmtj1qb7+yZIH2TWGqa/3IiKcA2f19FDNUywcIyAgXjTtK2kKabuGSV1xA7g+s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711385556; c=relaxed/simple;
	bh=ldgy7glXBWpdKVD/Zm3+4SxSeHIoFCCSi1rVdShLb8U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DvmA1EpkKj8X9mlqVJIfq5keRxulOpM2q3SDM0Cw9BQogPLSFBCYyyjb5m1J0VfJGm3qeHxS1VzIwVXbWFQag3/RfXhLfYSVJAvPPYhHqbf4RsMRlXkzJFrHOa+HfcBl8TVwJMGcc/Hs9inUg6f8gyTN3toDW8D28k3rDQt9zEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KWZ/9LDX; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pkQXGkbq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KWZ/9LDX";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pkQXGkbq"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PBtZ97004011;
	Mon, 25 Mar 2024 16:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=8RCMj71n2LfPDqARiMEio5fitPHhqxNZ0lY+m36fb+E=;
 b=KWZ/9LDXLjqRTEeBt20qoR9+YCwx+TfhkVBtJoMHW1a/onnERbjd85mgVgthnc5ZeN3g
 JYctNeNSu7HN0aV06O2aTVlv7bnjNWyYvTtfq/oWi0EYkqnBjYNLFOBVgwtXnLhy0/Tz
 TMxgkIDV7L8ryWoQcBhrvanKtz5lGB/lxq4A4uy3OHUYcidHHYuhrgSr5dvV8wbD7r/i
 u1SvG0zWulT3sUHiI1AgS1O/LauiEjwWtHheZGq8RvG/TUntyheJaC+8IIU45Jw7PdRk
 XouFe3TgJbho29qyYEpBulnae/Kxb1VnwSdwdOdMPxsFngzxlFMTV/keQgEhcsmnRMGp pQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1pybk4x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 16:52:27 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PGOdaB010560;
	Mon, 25 Mar 2024 16:52:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh5wvma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 16:52:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMZNstoselknQzzp27Zb06HHneF07sVzZQN3vdIB13+T+KFkgGPIwnJT+REItLtcEBkG4/s4Xh2WsZcCe96lgnzxe8RW++O17Oy1DRolZ1CLh475K/RfZuyIBLi4QfyZ/nBPPJUC06nv5k4iq8zdhXuWjB/eLbn3QF1qyjqVvh1aq/XHm/xbBte0EebAq/BX3gdj1YTfw5aaMqO0RJjIiygbIkHdec2lLzqwwFF9eU9H+ptrvhFDH0VfLhhywaDbZ0sdV5jpRXKBSPTHhl8Rd+aNdf59z2mQlEo6d99gNYPtNm1vJCEfgpoW1UMXyox7EWq4LbTM2kzGfL+H83t4fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RCMj71n2LfPDqARiMEio5fitPHhqxNZ0lY+m36fb+E=;
 b=RlG/UKTpecG8Ox1jqlI+lGSQdIAGcJW3msf41omjEk/dALBQgvAvLTbA6taZUjCyR0Cflx36Z9i9OZs9PBauZVv7qOj9Bf7D+mDD3mQn/rFy9ec5/Z9XQSac3+Tby/hP8WNUyfNyjfKaxZhPdUG1chLiARtaaqnYQlCqbaOO8xYUVp+ImSWuLFWaxOx/LX6LQdfCqO6IPqgHnNqAVw439L0MTqXtzAKZTPF1KCdTHFLwTlg40KN0KkyoffcexABhFBmYHNVk46xHd0oN1C9J0m12NDzY5JdRiOVfgEJJu1Vj/9d/J5dEJJugqvsmIHp5l0JD48jRPxIGIRXxebOMhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RCMj71n2LfPDqARiMEio5fitPHhqxNZ0lY+m36fb+E=;
 b=pkQXGkbqaGXkGrm1b9o9YW7xlyAb3F9yTTM1sk78+rRnUGPBLnPWReCg9ndlxokeVDNClNgPhsmY4qVz4snJ8/BOzOTe3bQPpoKdpuntGj1CWy04VgjRNrX5mRAqEiJ2YzS7tFyIbBK6WOSk7Ej1Koegvvwjw2EDevvHJ+Eazvs=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by IA1PR10MB7336.namprd10.prod.outlook.com (2603:10b6:208:3ff::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 16:52:21 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 16:52:20 +0000
Message-ID: <5b8494df-c15c-4d18-ad4a-74b5584429ce@oracle.com>
Date: Mon, 25 Mar 2024 12:52:16 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/8] virtio,vhost: Add VIRTIO_F_IN_ORDER support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <CAJaqyWf-oS_Y7EgO7DrVxMj5Roe=yjbbU3tka=Yj3St1ALCvnw@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWf-oS_Y7EgO7DrVxMj5Roe=yjbbU3tka=Yj3St1ALCvnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:208:91::13) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|IA1PR10MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: afb71ded-01e7-4594-9088-08dc4cebef9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Y9jOZPgAf4zdk2c+8uitxlzstAdyLOMumr+10XRHwrZRLAGDl13w98Kx7ynvKn8HhZtwM2TBkeG/FTexgHWWEh3wpgWNMhn6OQHiVvgf+7kMW8lAXCedIouYclKalMHucB0/lL36kLizK2k5+sZZ6I8k0vHMY4xlkLIhIaGVkYDDy1exQhsm324ECUcHVOy54/F1jOc5w6/UERP8gD6MCmYzDbH9y/HVub34/EBYfdnuNAcM/VcDdOqEoH9v0G0DcStyFVdjwQdJOzxVHh+yTDfbX+KG3Xyio1+sGYAI+MXdvcxoRuaYtWNH+z6JYmu20wEbhBNTu6leCuPiArcoGLW71dl23wwRk+Gz+DgODaZwi8qBXx55C61enKLFr9E09ov7AqLL53Uj+W25yKhh5vFGjTjIIzLTkgob7iKjeA7W/pt/RAKG5onSA9CCqSmdsEeon53+Vo+23lbHfkhTcTfY5B+5qyluxISbhcKBxFEiNeKtITjjgOAgDpOItOILgg5H9xNE+fVWJWWu4nI9/PXA8pMT2DQd9O6Q9YJUZsCix35o0TPq+d3yzD1w/hxXf6u/zJH5nZnIiNbJOpqa9tTaxz5v0JMW00Xnc9/OaBA0EpLfVjwnSVHkwPjfYVbsJC9FfXttZxEyXUX/5xt+iAs/71BDc6U4c5QFjJzzUYI=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OGF5OXh3VUNIa0RuTm5FbEcvRGhsTXNxRnYrazU0WGFQZ0JKUUkrZjZtVG4y?=
 =?utf-8?B?WHlvUHdJLzdYMHdzNStRMkpreGRScmVubkxsNld0a1BpSXFMWFBVaDY5blFL?=
 =?utf-8?B?eEVyRGtxL2pDVFJISDN1VFUyeElYODhmQWhzM3NXK0RFSGRjcVIrWk9IRS9y?=
 =?utf-8?B?aThPdEUwYUZSdE9NQnphamtETytLR3BBd3lhZzdxazdjZnRhcDdQN2ZUYUhB?=
 =?utf-8?B?VTVsRnVDT3l3RGhwMitMNWlGYWhFQ3FqWU14TUFHalJqSTR4YmxQSjQxM28x?=
 =?utf-8?B?V0prcDRxMnJxRndhdWVTRXRtV1g5YkNRUnowSlpZRzI3bHJ5UHFjcHptTjBr?=
 =?utf-8?B?dnRMWnBKNmJQRnhNZTJHWjQ3R3lXZm4wdWVuNnlxMmJuZ1c0eGVJcXBCVzdz?=
 =?utf-8?B?TUMxL3FTMHZCTEhjYU5acWxGQjVHSVh4MCtVWkthNW9BMDVtYzFxOG1qUjdX?=
 =?utf-8?B?RWRjc0VmdWMxN203UU1mSWxWa3cvN2hYOUtvT0R1alpoc0lacFJpTlI3OXJ2?=
 =?utf-8?B?Vi9IYmhDaVdPWFpxZ3kzSGxiQVpvdTN1YjhJdktzUks4SU1nUE9ZSUt0Mk0w?=
 =?utf-8?B?NE9LUmhXQXBLeHhOeFFLWEVZTHVKWlFxbVlDYzV6bTZUVDhkZExjYmgvSUFT?=
 =?utf-8?B?RDFYZlR2WjJ3K3VueC9DT0d5OEFqQjFiaWIrL004bHpDb0VKZTJhMVVzUnJk?=
 =?utf-8?B?MTR4b28vTC9iZ3RCUVF5c2IxVENrSkdmUHluWUdpVXVlT2c0YzdKQUxXdDlN?=
 =?utf-8?B?U2tpWCtseDRpclJDV0hhNDZXdktWTk9iNm8ybHcxd2Nvd3J5LzBFL1RPcGxX?=
 =?utf-8?B?Z1BwN0YvNjh3WG5idkY3Unk3UzgvbUVoNVJkNCtRdmRpYUFMbXh5ZWJVaFR1?=
 =?utf-8?B?WlNzNmJBVXpQZ0RFTGlYRGJBM05NMkx6ZytRa0NoV3laRk9sQ1pzUU1SNXNu?=
 =?utf-8?B?R1c3Z2NuY2RLWmlPbWlhZ0g5NC9RRHFVQTBWVVNBUVV5NVpjM29CbVNGRmF0?=
 =?utf-8?B?VURqWmtuVE9kUFdJMit3b3cyTUtYR1lpSW13UW03NFhNT1U2TCtIQS9rdlR0?=
 =?utf-8?B?WDcxclo4Z05USUt5V3M2a3hiTVozcHE1Q2xvQS9XT1FTZUZlcVJicDBIY0lv?=
 =?utf-8?B?RERmQkZhMDBMc3VuMXpUbjNwaGVyemFwR0pzeFlXeWZqbGdxVkFLOWwwNXla?=
 =?utf-8?B?M0dNaS82ME01V0tiVVp0S0JLOVNpdGJXUnY3dHg0REJNRHNqT0tnV28vS1lo?=
 =?utf-8?B?NFBvM1dNaEdHdzRlcVBXclI5MGRUUCtLcnRCRXg1Vzh3cmFYa3ByMWE2RTZV?=
 =?utf-8?B?dHpNb0NTRk04NVJpckhCRzBjQjVuenF5eDdtaFdsU00xUDUwRm5NdE5DL1pz?=
 =?utf-8?B?ZGRhSEEwNlhxbjRPRCtsdVRMeWpVZTNHTTlGOWxJYjNFSndFUHlIUE9JK004?=
 =?utf-8?B?Q3o0MVFkNHNmbGV4SG96L1lCMCtaTkRuN0g1TlR2dVFJcDRjekh5ZXVsVHpW?=
 =?utf-8?B?emtwMHhyL2tTdk5kQjdkdkh3cmR5SmlIT05DL1RVSXBmcFR4Vk5lcm9PSGdp?=
 =?utf-8?B?YUVUaGF0TzYyeXFUYno2ZkRhd1RXQ2NFUXdNcmt3NVF6bGJpNWIwZTBlcExp?=
 =?utf-8?B?UkFzc0V6R0tzcURickdLcDNGYzZMN0dodkwwdzNUU29jbVdPVmVXbER2WjdQ?=
 =?utf-8?B?eFdHUm91cExoL0pUcWppeHdnRzR1WVpaenhRQmVVNWZvZ3ErTUpwTDJNVFlm?=
 =?utf-8?B?dVptMFRQdXpzdTBxdmxJQUlEWXhvWGxsWW9rRHNhU3BBSE96TUVFU0xTNjlv?=
 =?utf-8?B?L0kwaDVnV080MXZRWFVNRHlkT21IODR4SW9PZkE1RUgrbStTUGM1MFVqRExS?=
 =?utf-8?B?M0VYVjJBK1Y2TU9MUWFPeHhESWhRZVptWmY4Uk5rc1ljTFRKUTZBai9ya1R6?=
 =?utf-8?B?ZDNiT1AybHBMR1BtN29kNitrNDgyL1ZaSHMvemQ2Yy9zVTUxcHFtZnpHaDdZ?=
 =?utf-8?B?aUhkMnBuMDl4YitZdEJmOWd0UTc4NTgvQklmcUQ1RzN6V0ZOTEJZU2R2S1FD?=
 =?utf-8?B?WWF4ckxuTy9jcFVKREVKeUNpU2ZZTUJhNk1TUDNMWWUvU25EcjBSRys0SWJm?=
 =?utf-8?B?Snp6TUlrRnpWdm0wN2prQTJDRUl3Sk1PMkVWYWw1aVlKSVNOVThqaFovR2pM?=
 =?utf-8?Q?u8HR0+9HJLxYeSEZ9dhwGQY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Z3VZc1l29HlC/6Lg866zRYuAxZKbAVx+gAN2te9X5M2ZB8W8aGnW1OBOjAae/zgaCP1BLXJ73tmX2TYgZZFXW4fsNJjfnCpUdM8DEHOn2EwlYDtgkpY7wudmVmgYdhEABjIIlXp7xOKVmkDUooQkYGlX1V/mxznzIEPtByENm3KQeMnWWWafHOmYj8PLuAcTselvdjxADyFdgtu2UgwPY2qmdiiIn4i07tmJLAE87qpkb7MjxRUK+IGvhi3OQeomXY8NjphzyWq0wBhabqdaKgiS86v70qdJN4T1Rt+/v45z7p5to2C3LPEmEpc9kjxUVS4I92BPgg7qfsZedvyX08y6B9+h9ucD5zz8KyP1wEAthIqYHGqbS7DWfLS3k8NtyK0KdJza3n0+AMC+QK0W0GkLGTMrFOMbAaVv/HZISOptcFSwOmiTY0ZrxpMTqZMFRtghYMNaYCxv6E3tHcrcd9i67wfqY/vf/a1EqyR92wt95DVlYiJIEmn2FNXuEClgrlOGnp03RhF9k8OytyBGjl6/8y5jpSvahwsipBZqEj88bUTr9e6KdLKyCYE5C8yeeRp+NX72r7s6vc0XHJiuSec+GH1iA/b6Z9dKn7kTN0M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb71ded-01e7-4594-9088-08dc4cebef9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 16:52:20.2244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v03bxJoArOS7jZ0/YXKAko3BvYkLQmtnimYTz8u/dfO4TQm5GoXOSMLrN/r+imfFtZQZcQmRSThI5PXfaTEPdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7336
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_13,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250095
X-Proofpoint-GUID: 2jJUCeFBZ7LVQvXrJVlOf_Rhhn04JI5d
X-Proofpoint-ORIG-GUID: 2jJUCeFBZ7LVQvXrJVlOf_Rhhn04JI5d



On 3/22/24 7:18 AM, Eugenio Perez Martin wrote:
> On Thu, Mar 21, 2024 at 4:57 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
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
> 
> I think to use a hashtable to handle this has an important drawback:
> it hurts performance on the devices that are using right in-order
> because of hash calculus, to benefit devices that are using it badly
> by using descriptors out of order. We should use data structs that are
> as free as possible for the first, and we don't care to worse the
> experience of the devices that enable in_order and they shouldn't.
> 

Right, because if descriptors are coming in in-order, we still search 
the (empty) hash table.

Hmm... what if we introduced a flag to see if we actually should bother 
searching the hash table? That way we avoid the cost of searching when 
we really don't need to.

> So I suggest reusing vq->used_elems array vq. At each used descriptor
> written in the used ring, you know the next head is elem->index +
> elem->ndescs, so you can check if that element has been filled or not.
> If used, it needs to be flushed too. If not used, just return.
> 
> Of course virtqueue_flush also needs to take this into account.
> 
> What do you think, does it make sense to you?
> 

I'm having a bit of trouble understanding the suggestion here. Would you 
mind elaborating a bit more for me on this?

For example, say elem0, elem1, and elem2 were enqueued in-order (elem0 
being first, elem2 last) and then elem2 finishes first, elem1 second, 
and elem0 third. Given that these elements finish out-of-order, how 
would you handle these out-of-order elements using your suggestion?

Thanks :)

> Thanks!
> 
> 
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
>> --
>> 2.39.3
>>
> 
