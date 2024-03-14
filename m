Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF6973196
	for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 16:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710432385; cv=fail; b=m5gwTeOjag2bmCXPiYJu7MhhXsDWuqTRCSMsTFTi3QFiHAqwRdYxSngbzh97ZY1406wOxWjEk0yTV6yj67EgUqp26Pa9eF8hsQ++8nCtQE6Vj5c2I4CD+6Vc3dT28Djx/0vYHgQCNolx6WxwE16edResjodhtPKzMjr1L3cITrg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710432385; c=relaxed/simple;
	bh=5gN4WQTKR7Rk1iX5QoJqT0TWICGPcaS4W2P+Dyt8MPY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=twg5C2rq6urQgcXaveqYkI18Oh55PPO1GHTvSVWTKER58pOipVvtv1druwe9V3L5umMyU3ivOXFw4nOFhTtX4n/T+79015AGClZpJyb4g/LrXGsutIxx4+bAs00PsDurygKY62zEtU6x5xPI4PfNT/g2y0h8iQYnDJu/lcZ9inM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K+UfXRuN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hknLHDQy; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K+UfXRuN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hknLHDQy"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42ECLaKo007606;
	Thu, 14 Mar 2024 16:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=CfxRK9H7gTlJjQRVFDWyVQdaoYTPQoSo1Ua8ICH/fTw=;
 b=K+UfXRuNDP5Ip/rqqdcFrKLqXPaRSJgqzyrotIGI91gc1aLFb0ncpCJAYb7+O4hvsPAs
 zaGlq1TvEAfjunGIeA8w2sJNF1IEoC98yvjk8WxXM2K+g24ii8lPv4thH9ZprJNAdMWD
 +4G2SHT53FK3UJljoBvJyk0S3GUVMRZ1qia/8Gc9sNA/GBQHNyOJjHYZM31x09ido4R1
 MB5V/AIXdEQYz1zLf5Ix+tnuSGWpsdczQtUq3yFGodfim758hDyheqI5I+kVcA64VjYN
 N9y9SWZe5WkdN/xYb8Ft8WaNJlnjVKPpUOBiqjbvpT+QCvg2PShOsihmvj083+MzP4iW Zg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wv0af8n1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 16:06:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42EEhgUs009173;
	Thu, 14 Mar 2024 16:06:02 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7guh47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 16:06:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TitIXV1fL3apzZ8jfXCJf9vk1hfWPglqTCjne8BtmOmDJC1NZ+OMBWkg5mYBQ74XBECeCgeCFsqBIttFFw4EaOoD/VHG/Bj8idwFY+U0tqvpzPtxo81ULyRpK/bnSBrOX/gIUJhaJJiVWCvkkxgASJCBENTi/vO6fhebpwJ/szh/iFetfCtRYPEZNxcXnAyIhYHucEIw9UFIJ7o1IbJjNU4RJSrCPhWETWDIzPOUHaDT7902aCfxUSj9mBZKo9sQHl5twPOv20AYjDGu52l09HUbC4gg2jpDBpyg8w/l84kiE1qoI4KXZd4XXl4nM8kYEbtkpm4mwz2rI/QJIf3ixw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CfxRK9H7gTlJjQRVFDWyVQdaoYTPQoSo1Ua8ICH/fTw=;
 b=lkX4+Ez+qyx5a4G9yZHm/Ufx8CX0uz+sTvG5tcNbdA/j1Es5J2Y7NPkM0H2FgGYL6A8zCMle/NPcrrZcKEF/5L4VFENrIObku25+UacFlSdrkBYq75ndELpjOhtpNfelMIs/8JaFVVXeUzOi8Z2A4Wo4jGsk0H7Wji/yDZwwXa1uAlfhNDA/DrtFvSGTTmUcTbrR+ikTbmglEshH1tCwo9ObEGHt/aFh0TSBZx8V9oxmEmpWXJUSHSq3dN4/JTgddGwbaELCoAjOeSwHy8VODvCtUfI89eScxyQ3B2wvWfUrs3uyvbzm91m7tuzXbPQ7xrOu53R845TebDIGFW9Brw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CfxRK9H7gTlJjQRVFDWyVQdaoYTPQoSo1Ua8ICH/fTw=;
 b=hknLHDQy6mLv796MnImzydeYSjZ4QB0babtv2waikBuLn8APj0w2HDbw0FGekcBL13+k16zLo/Qy4ZOskg1g8uggvMjLpRHWM0q8lT7QbvJexDPbdF33dHvUGOpDJNjy+jupGB5y3yQQk7X418yFCFaSd7B+ci0xSuDWgpFdXqE=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by MW4PR10MB6417.namprd10.prod.outlook.com (2603:10b6:303:1e9::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.19; Thu, 14 Mar
 2024 16:05:59 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 16:05:59 +0000
Message-ID: <f173f397-965f-43f9-9ce0-b417e86d6935@oracle.com>
Date: Thu, 14 Mar 2024 12:05:54 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] virtio/virtio-pci: Handle extra notification data
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, mst@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, leiyang@redhat.com, schalla@marvell.com,
        vattunuru@marvell.com, jerinj@marvell.com, dtatulea@nvidia.com,
        virtio-fs@lists.linux.dev
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
 <20240313115412.3334962-2-jonah.palmer@oracle.com>
 <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
 <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com>
 <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7P222CA0018.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:510:33a::12) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|MW4PR10MB6417:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c5cff2-75d2-459d-1399-08dc4440a340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pqp8j/djWXSAsRWIAWguHpk3/JOm8Ib8srhuA5/aQv5NSUXxu3UK0hdPNXFuvILztE5zQWTCJ4feOsO60SJNOH/Dbd+7MUnDGQFzYGrH3oOYKI3WZP/n0XCCJPblK01vZ1k202EK+zEdmoUv8CpGjRYK2j/6p/JhPse5o5663npHEcW+xMga5OhRLAggqLgH0bD2OZvCbkjcd4tKJ/7tCnPssZ4SkUb4EADoA/RrfqySbAI8xREa1t6F7V73Sl13N1CT10homsJEdabTbE1obFLNdNjiPb4ulnWYoBz289ipuPSNJOuAieFcbXrvof3hzwCBxvxL6NR8JoGgJoSLEuQIQYU3Jv1TaVDjVspXFhEQd55pHHfmKWxDQqk9s1y7WnC5P23sIjs1lhDvac3xEiRAvXOPTYNPjWEi/shhGbLW0rxSXDAKH1hZP9s0jBviTVwO7Wp4TWe5gHT/7xJXjhNQEGqGnRPtyTft7rVQ7rCFnlpgbkEth/Z+JMJNJUBb09nBhCtLKnWDvXSSHxzeSwAtUFylo0x3NZ+XidgP7eyrxUbHCgWPgOoKgg9ErbE1B3K/sY9B3eGsVOpDuFHRnYySmAu3otXcKu7z0AI+rIftJUL4DyA3XvdeQpN24X1DgoIvaV7CLjDJOzJU0l4q1MnOIZ0JJV1sFcdeqctBRzY=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dEZNbXE2cWVLSGtQNUgrWFRGWU81OHNXVEowU3h4SWQyQjVSL0I0aTNnQzJZ?=
 =?utf-8?B?R3ozdks2S3k0cFV1aHVGS1psT0JlTUUzaXh1NWVzUy9MczYwMmQrdVZUMlpC?=
 =?utf-8?B?SWJjSzJsVFR1SFMxdCs3aE04VC9zaDNnd0pnOGNnVHdpZWMyT2krcXZML2dr?=
 =?utf-8?B?V3VOVFNKdi9iV1B2YmxmUk9LVlU4Y25ndHpEemxJZDJxVDJmQ0lWQzNQanky?=
 =?utf-8?B?Y2sxSUsydVlQYWw1Y3JXVFE0ei9qR2paa21OOXE5djFTaVhHYUdONTUvcC9z?=
 =?utf-8?B?ZkQ1alNsSUk2MGxCb0NTRkYrU2FiZm1LNGxDVzcwclBLRnFCWDhkOVM5b1FJ?=
 =?utf-8?B?REFpMWdNb1NmbjZXdFY3VWVMb3NOanZnTWFxWitFSUk2MzNOYTM2MXQyYWN6?=
 =?utf-8?B?bE9MQkk0dDQ3Mmx5NWZ0Y0hKejhMbXNoRTNYUS93Zk53ZElpYk11QVIwU3hi?=
 =?utf-8?B?VHp2bHJqNWpjY21DNzRhc3FqLzA4SzBtby9oVTNrOXBTYUZ6K3pVUDF0d2ty?=
 =?utf-8?B?UWpTQXZJZ3JlbE9uQVFyanVTYjBrZlVQWnBvVHBwRCs3UWFLRzQ1YWpmTXkz?=
 =?utf-8?B?N1RORDMvalpVYS9jcUhQS2FTYXB5ejE3cFNPeUlwTldlRXdSd3l0bXlBL21O?=
 =?utf-8?B?aGZ1cTRiM2NlaEMyVmdIVXl4Yitic3A0T3FDb0pJWGs2aEdTQkNFdHVlMElG?=
 =?utf-8?B?b0Yyc3lodURrcjA1YTJxemtRQUtGOWkwbDdaMXVoYmRiSjVRNmFPN1A1aGdV?=
 =?utf-8?B?KzJaQUVxSlZoMWpIZEpMeTNkcWMzNlluMEdGeXdzdUMyWG9XLzdBY3YvcFNK?=
 =?utf-8?B?aUhRcTh0RytSL2w4T3MrR1UzcDVmcmFNNnhsQ21TZ29xWXRTeVZFT0hhbWY3?=
 =?utf-8?B?aTdzZ1M5V0hPa2h0YXgySzFuWmpjaXpFOXJ2WjFCQWxKMGRnT2E0aEdwTFdj?=
 =?utf-8?B?TDFWUkJ6TlVHWmhVcnJicng0WkRHemJTTnhnaHg5RE14end1WGNCMmhJQnBl?=
 =?utf-8?B?TEZWV2FjUTVaeVY0dXNTMjNOUU5GejdvSTJHWFN3aEVTcFRYbU1JcmpVZWlt?=
 =?utf-8?B?VVpVN2xrZzFHZ3N3b1dLSCtLcmp6Wkw1UXFRV2dwRXZMajBMTm1MWnJQNDIz?=
 =?utf-8?B?dnBDRHRsK1NHY2V3Y2VCdkRiU25SU0hNSFJxTkErazMyaVdHcUh1UGxYTDRy?=
 =?utf-8?B?L0o1U3pZbkw1Z1JnNThBamltdlNpWnBNbkI3Q3MzRzhmaThaUTNtdmVZaUdG?=
 =?utf-8?B?dUY0ZVZ3WlVGTW0rRm1HL0tEYUF5eW4wQ0xzYUhLSHhLRUZGZU9ITEtiaWpR?=
 =?utf-8?B?emtMdnFOV3FtUWMrWjZpdlZIL1VHRi9naGp6YitrUUhXZ2VrS08xMlh5V2RN?=
 =?utf-8?B?RDc4R2dRTjhqd1IwdjJ3ZUMrbGJmM204SzBtb0EwQU1Hay83YldOMHowLzVx?=
 =?utf-8?B?L3gvNDlzVUs5UFVCQ2dlbjVZdWUwbjY4dkVNMUx3c0prSXNqTXBVM3lKTWtY?=
 =?utf-8?B?akRIS3NMMkZ2S2dZTFYyekFCQTg2TnFSVTZldWU0bm9jV3FQWXNsRE1FSEZ1?=
 =?utf-8?B?MnpYTUd4NkJRcXRma1RrdGxuMW4xamo4N3VNUURjMXRkakhKaGhPRTRrbVh0?=
 =?utf-8?B?dXA3TjZ3aWtUWk5kRDloMDhwT2pjbHJodE9TaUQ0alE2UkhTY3dRU2x4OGlr?=
 =?utf-8?B?Z2Vab0ZFUVVSSEQ1UkZzR25acUsyR214RDZHWVJnd1RXWVdDdlVMa0M3aXlo?=
 =?utf-8?B?TVZqdi9KVEZMV0syRTUwcDZORW5odTJHNmZKRXRaTVpsbElva0QyNlVvdndO?=
 =?utf-8?B?MHNPTHhvdnZTYmpSalpNNWp5STllSmswM1djNjFyR1pMd3JRVGFBQWVpZGJh?=
 =?utf-8?B?c25mMlFzb2RjakdEOUtmVTJtVU5Gc3lIaWVkRHNsTHBPcmhvaU4xV2Z2M1NK?=
 =?utf-8?B?a0dpZmxVaXNjVElreGVaVlgvdTJHMlhvODU1RUNSS1laL1pqREZQaytlT0lN?=
 =?utf-8?B?RmpDNmZmR00xRG1VR05NekJobGJNdGRzWDVRYlJHTXBXenJqZGlXOGVONExH?=
 =?utf-8?B?elo3TElBR0tad0ROVFhPMFdRZVY1VHlhVXd6WWtiaUNNd0wrRzF5UFdJTTZq?=
 =?utf-8?B?ZVdpY2pYR0l6eTJRakxUSXNkRlgyTytIN1JhbzFVanVuZkFvNXJsaGNSYWpN?=
 =?utf-8?Q?an/bKajFy/VRwjc76sgGmkk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5J/58NUTPDXHyKPQmQQSlJgHbtYCBr2JfN1gXiLZMplnpRBNPzxk8pQ+3mjn5HkSdNTkJ3Ua/EA1/ZE77xfsgEEdYtxwakbXTm33CcNSntzP1ZOGTaFo1DgrqQMrzlO30FCpey50W56/HxPCTsjH0AUzRGR4sD/OWz0m0+y+DlkwVgEvG2O2ZvvxztZDwvIPhocc3AQLV5KZ9VYmSjZ6WefjUhjkK5oh292W2L4Mc4X519qo4/wNDFfD6XwFtOvA+3qP6IXHcMRM8hm+GyQf4uZRrYcSMcSVYVPlcDxMJJSbt1QXkDGiYQ9RzzxUzE85sLTkgyYJDeyC73XTIIkB/dTtAjWRRRtgFRVS1boXzLSGslcEabH4XV/Wgfjk+uCHBGI4wI56zfe2w3KpuKxSgJSzyJFAhMzJkMZmWNj74VdnECPE+6kMOssPjUrDqfP+nZcndc47Pl/dxs9N13sx7roRqBPoahnrO5HrLugwpFpI/WGedreucBGQ7J8tKAWS933BnS6euCiqLv204rZqwjJE6VhDr8VxMB2q4w7oDVTcWG0/tIAhp6Ik/Z23ZaAYe7Jj5MHIjub/zJ5T+L8e1dc2NBtZIZ6spNH86T+Vq9I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c5cff2-75d2-459d-1399-08dc4440a340
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 16:05:58.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G+aukhBS/NJfXTauitGpiATu1P47qoBsxmjnILjhAhz6AOXy1ktE9yyE1KJ0hxYhQFlFaJWgQYBUqNLFUp6SUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6417
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403140120
X-Proofpoint-GUID: TqBtBI9veVZtFr3SQjfHUxTTmrackGcC
X-Proofpoint-ORIG-GUID: TqBtBI9veVZtFr3SQjfHUxTTmrackGcC



On 3/14/24 10:55 AM, Eugenio Perez Martin wrote:
> On Thu, Mar 14, 2024 at 1:16 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 3/13/24 11:01 PM, Jason Wang wrote:
>>> On Wed, Mar 13, 2024 at 7:55 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>> Add support to virtio-pci devices for handling the extra data sent
>>>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
>>>> transport feature has been negotiated.
>>>>
>>>> The extra data that's passed to the virtio-pci device when this
>>>> feature is enabled varies depending on the device's virtqueue
>>>> layout.
>>>>
>>>> In a split virtqueue layout, this data includes:
>>>>    - upper 16 bits: shadow_avail_idx
>>>>    - lower 16 bits: virtqueue index
>>>>
>>>> In a packed virtqueue layout, this data includes:
>>>>    - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>>>>    - lower 16 bits: virtqueue index
>>>>
>>>> Tested-by: Lei Yang <leiyang@redhat.com>
>>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>> ---
>>>>    hw/virtio/virtio-pci.c     | 10 +++++++---
>>>>    hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>>>    include/hw/virtio/virtio.h |  1 +
>>>>    3 files changed, 26 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>> index cb6940fc0e..0f5c3c3b2f 100644
>>>> --- a/hw/virtio/virtio-pci.c
>>>> +++ b/hw/virtio/virtio-pci.c
>>>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>    {
>>>>        VirtIOPCIProxy *proxy = opaque;
>>>>        VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
>>>> -    uint16_t vector;
>>>> +    uint16_t vector, vq_idx;
>>>>        hwaddr pa;
>>>>
>>>>        switch (addr) {
>>>> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>                vdev->queue_sel = val;
>>>>            break;
>>>>        case VIRTIO_PCI_QUEUE_NOTIFY:
>>>> -        if (val < VIRTIO_QUEUE_MAX) {
>>>> -            virtio_queue_notify(vdev, val);
>>>> +        vq_idx = val;
>>>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
>>>> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>> +                virtio_queue_set_shadow_avail_data(vdev, val);
>>>> +            }
>>>> +            virtio_queue_notify(vdev, vq_idx);
>>>>            }
>>>>            break;
>>>>        case VIRTIO_PCI_STATUS:
>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>> index d229755eae..bcb9e09df0 100644
>>>> --- a/hw/virtio/virtio.c
>>>> +++ b/hw/virtio/virtio.c
>>>> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev, int n, int align)
>>>>        }
>>>>    }
>>>>
>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t data)
> 
> Maybe I didn't explain well, but I think it is better to pass directly
> idx to a VirtQueue *. That way only the caller needs to check for a
> valid vq idx, and (my understanding is) the virtio.c interface is
> migrating to VirtQueue * use anyway.
> 

Oh, are you saying to just pass in a VirtQueue *vq instead of 
VirtIODevice *vdev and get rid of the vq->vring.desc check in the function?

>>>> +{
>>>> +    /* Lower 16 bits is the virtqueue index */
>>>> +    uint16_t i = data;
>>>> +    VirtQueue *vq = &vdev->vq[i];
>>>> +
>>>> +    if (!vq->vring.desc) {
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>>>> +        vq->shadow_avail_wrap_counter = (data >> 31) & 0x1;
>>>> +        vq->shadow_avail_idx = (data >> 16) & 0x7FFF;
>>>> +    } else {
>>>> +        vq->shadow_avail_idx = (data >> 16);
>>>
>>> Do we need to do a sanity check for this value?
>>>
>>> Thanks
>>>
>>
>> It can't hurt, right? What kind of check did you have in mind?
>>
>> if (vq->shadow_avail_idx >= vq->vring.num)
>>
> 
> I'm a little bit lost too. shadow_avail_idx can take all uint16_t
> values. Maybe you meant checking for a valid vq index, Jason?
> 
> Thanks!
> 
>> Or something else?
>>
>>>> +    }
>>>> +}
>>>> +
>>>>    static void virtio_queue_notify_vq(VirtQueue *vq)
>>>>    {
>>>>        if (vq->vring.desc && vq->handle_output) {
>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>> index c8f72850bc..53915947a7 100644
>>>> --- a/include/hw/virtio/virtio.h
>>>> +++ b/include/hw/virtio/virtio.h
>>>> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *vdev, int n);
>>>>    void virtio_init_region_cache(VirtIODevice *vdev, int n);
>>>>    void virtio_queue_set_align(VirtIODevice *vdev, int n, int align);
>>>>    void virtio_queue_notify(VirtIODevice *vdev, int n);
>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t data);
>>>>    uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
>>>>    void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector);
>>>>    int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int n,
>>>> --
>>>> 2.39.3
>>>>
>>>
>>
> 
