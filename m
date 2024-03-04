Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2BE34642A
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 17:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572380; cv=fail; b=GQHsH4w4BSXooJ9SFcDap0M88eKSNAfNy4h5cfJEvQdMIhuLNc+65mvn1kj2J4dhpf+cKUzujGyatnpUi0q6dgB4AW0tD49w6mNRqmXb4Sgo7K2ppethxyRpaJ/xT+4yIrwovjJI2k6xPJeycBsV1rxSmqsR5oTFmCO/UNNPoes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572380; c=relaxed/simple;
	bh=v4C5zIwZKNa6VCjrf2zS1M7vv70nx4Z93HL0eN65/IU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=laQmDChGEF2YYA44aCqUrVJ/i5oxWgZ47vJ8sQVwQkMOc52Dgvk8HVqA2Wlc75u7Br9zdADRhE8iknHZLlmD8UOSooafOUGUpXFwxBTwaLSLkLvvPGL2PGzxlacPIYsyq7CCRqSiLZWZBMsI3IW9OXnGjFzZ23+d3UVdYAhbWsI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cWL2Av/p; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nk7ipA8H; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cWL2Av/p";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nk7ipA8H"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424GYf4D029333;
	Mon, 4 Mar 2024 17:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=S7MyuqKl6n9m327Wk00DsY0UM1I3n+ZnWuQrfxsPfhw=;
 b=cWL2Av/plRLdPMYX0OaaE4v8QUA/5a6UE74CYMbuI5tzLdtY6bUR3/jJ2OxK4p709aqt
 dpdt7Wc78HNIfGAhLH0ZjFRNEOUI8EUr3S/3TtXLA0f+4fANSRZINfaQMwVWUQIrrM0M
 KXO9Wof4kOfnem0ETxze0yGd0+dOzpyNaGI3bHR5/+qw+W8fu293Px+DrNXj4XCamu1x
 BvcWWo2TLnzLldTWAhVTSZeQn9bHRoAiuD3aPK+bc9F+2Nw3EjstXywCScOdVAwUufTX
 DitwZQzrOKk2a6SuSL+teQL60NQsoq4wnVBQI8b4giOEEj9Jav0PJpvVAh6mgWJoD7Wx cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnuv699-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:12:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424GGGib017412;
	Mon, 4 Mar 2024 17:12:51 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj6btv7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9r0TKRpUpNH+AuN7I2943DtorVf0JjjfB41TRlJqF9J6djAi/2P6B5HyfmeYRUAWEKN0HnJGQHZW5jIe2CS3k/7nmCZVN6GaUjGDnd6gZjsePSuCflIiLro8ijJBcG0nXJUD12+YUvFIp8JIeQRpYLvejWdasntLXrbukV9wsAjmoVzq/fnchLGXAQmgTuqQSXQpNjMtfd+wRdeH6dK0twqT7E3QUK6bKnVGSys/PU/yrQ9tXcE26Frj5Gr+XQBvp9suazecolpu0ae2/XQAN0S9AVejh3Glk7fWCCdQp57AFpQeQXa6DjQtHihmoYaRuGvxHJSVUYTzMytKOoQrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S7MyuqKl6n9m327Wk00DsY0UM1I3n+ZnWuQrfxsPfhw=;
 b=MGDB1v/zlScXvUUz4SUUaczy6o22PBUi3nU5BBt4cqes8dhr3h5hHseYzewLUfz8KbCLkY0hdFE9gq1pkgqhYODaOZhIWS0godN3vA+dybx7H0PFUuq21F+c6vYV9izyGjr4437MdH4bKtLYFqWV8SmwD1VgDKbs8iaHi00EUNCn6rh/1nfRlafptqu1FrLP99EjSQmV8Xn7t9/GGgxBFDJqNxYzfu+atAfx9hjpp3NFvyC2UmbGXX4uxI/Py47qu+1/wPTAHz1dAw8ymSQR5bMD4ubKWbpGV8xbJP7dx1oXAmEJMhyg5VZ3vzeYQQVOqzxRVHDejbJYbb18xLaKlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S7MyuqKl6n9m327Wk00DsY0UM1I3n+ZnWuQrfxsPfhw=;
 b=nk7ipA8Hq61I/FSwfuwss5V3T7+QQqZL5qUT3gszNwa3u/co4bFvPEEtfY7zDXFAOQBADCbZ8G5iYPN97kM9eI0LX82yUrTL44cBFl4dYYbVjfgY8LhbtN1S/lVvSWt+avJHcq8OLnIWp1mYyTvD9ZLUUCkzvQi0bq1wuiFvkTc=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH0PR10MB5818.namprd10.prod.outlook.com (2603:10b6:510:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Mon, 4 Mar
 2024 17:12:49 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 17:12:49 +0000
Message-ID: <82f1eede-b1f2-41e4-a3e0-2d5b62c7bc21@oracle.com>
Date: Mon, 4 Mar 2024 12:12:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 7/8] vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to
 vhost feature bits
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <20240301134330.4191007-8-jonah.palmer@oracle.com>
 <CAJaqyWfUk4m6pJGmGN9A5k7Eqb=eDjVk26udo_hanCOv9FjHEw@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWfUk4m6pJGmGN9A5k7Eqb=eDjVk26udo_hanCOv9FjHEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0148.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::33) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH0PR10MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f72a81a-db78-4ca0-69cd-08dc3c6e5163
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	w6xam5Fc5T9GfjU+zYri2kmaxQ96ZGYjpSLW9X2ByTYawfvhkvM4l/OX35To0YAxczvn3dO9ToFfjSJz08XyW+XizhfCRB9HL+eJqNe7oZG8BRcO+5FOfG3FAjyRfIbvV/AKMA76/BgEnJxi1n8eeZITKrmJD5GJO1dn46ryQNJrf3Mo0laLmZhjyEh/uU5IzD3fl8uRlt8ENfO06P3ZHk4Vk9xYy3YLYWqpwxRK7Vayf6t8HNSAxpOpmNRdSQ1Bc1bQB2Y7WHoiw+E8z5sR842+QwY2S3chNK+FDUu2NDVC76njBhXcoJBxygjG8gt39grxrJ1EVi58jd1uRogMARr0meT3nnwtjwczN/jP/nEKSwtMeZms/tljzFNHlJMQzM8V/snaHXa25jPtJdMyL0NqLy7Y05+8OZfpuKhkjVOTbt4S9jGsaJNKM38mKZH7UPx153RbsZ2VS5jelu9zCMvJpKlYoXubAKCP/r6lo4Z5RtLWLn1XWd15cnhzdfKWvuAsNaZ4KDqIemoxEL8DErPF6ud0qgL1w3qlN9M0iQptcMbNpRdZBbK2C3ipcFBvhOZ9MLLgX4e0/slbHc6BCr98JXBnluzB2tVQn4EgVMOUCdijllJOufm3Iw4qYFKvXIIh0lVNjCVWS6bvAegmBkb3Ko5Q49UN4RywLB4C1/4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OVhGS3kxZmtQTDRxYlJieVdxM1ZZbzNQRmQrd1Y1Q2lvc0FDZjl5UFFHVEhP?=
 =?utf-8?B?WFZhNWVFWHdRNGNyWS9wWWl5UkxXUWhtREdnc1A3SU5Ya1ZnYlNQYWtLaFM1?=
 =?utf-8?B?Y2RTMzNGOStlcXpjOElEZGxNRDZYTmZkdDFZQ3RmbmFCS0R3OEJpclVvSTBL?=
 =?utf-8?B?N3Y1MjBlUTI5Y1R0Y25NY1FLQmM0Y3VwdUdGV01RUVZyWXZRdDlaMVhEdmsz?=
 =?utf-8?B?emlWa1JHRFhxUTkvUnQzVU9yYUxzWkhOc3RWWkwzN0JSb2duUjlWR3Z5bWVX?=
 =?utf-8?B?U0xYTzhPN3JTNzBIZ1VpZCtvcTYvcmxvN3FnWHhMZ3dicVo4L0Z3TGFMcWZl?=
 =?utf-8?B?akd4K0xpNWRvSHJyTjhuc1RpNW1lOURhZ0NkM2ErajM3NWVyOVovaE8wY2Jj?=
 =?utf-8?B?S1hJc2xrbXRrMVBUaVgyOTNuOFkxc3ZEWitZT0lFam9OMnNmOHVCRTJBS1Zz?=
 =?utf-8?B?MGwwaW5xaklIWTNGRFkrOHdrQlU0TVBOZk16UVRUQUFHb2gzZUk4cDJ1ZjJX?=
 =?utf-8?B?dzhGMU9vZEpJWDRtWW80dlNiWU5ZT01PQ1Fpdm9LOHd6aXdYbHBtWlMzMzRw?=
 =?utf-8?B?RzZMSit1Sm52Wm55MlB1cEVsTFpBZk53cGpPT1l6RlZPZ0x2VFpPcHpJT0la?=
 =?utf-8?B?dFFBSXZ5dEIwYStCN0trQk9wenE2a0dTMjNSZmVqaDFVbmlWMUNTbi9nNCth?=
 =?utf-8?B?QjZ6Wm5GOW5QS202SVdsQWJRMHh0N0ZTVnQwOUlNMzVVcWpoOVNsdU9DZmJu?=
 =?utf-8?B?NnA5elhpcWx5ZmFBK2dXWlhmMkRhYk5zeVR3ZXM0QUo1Z1ZyN2JLY1ByZzdp?=
 =?utf-8?B?aytWOTkyY25BVFNRK2puVlpkcEhvUTVqNmZLYzNvZ1ZxYkJ3ZWFpVFBQdEc4?=
 =?utf-8?B?RS9NdllNbS9WVzdzakl6K050UDMrc25YS0ZyYy9GWkYyMUo0Q0lmRnJja0dt?=
 =?utf-8?B?V3ArYTlleU5PeW1lblg2SjlaNjVxRGdCVlZUZStGSDQ2cWhrUW12b0F2MVg4?=
 =?utf-8?B?L1E4NkFiNVFNcWR2MG5yTXpXcjBQeVdKN1VNNzlVaVp0Z1lVOWZURGRST1Fi?=
 =?utf-8?B?dlErZ2djSDlRRTBxMUF1cE5RbytCRTRMOC9QdU9uc3hJQTE5YW0weWFqNUlp?=
 =?utf-8?B?QXBGeVZwM3N5VmhYb0ZBeU52bjlYZy9zYUlwWFFoUFB6Zjdtc29ZbC9rSTdF?=
 =?utf-8?B?bCsvcHVZd3N4d2pPS2dIRldMRUxtaVJ6V09pSlZ1ZUlkUWFrVUJKZFg2TGxT?=
 =?utf-8?B?dTV5QlNKZDFaNitQRG1LVyswZEZzU1hiZGNPejRxOGRZOVVSKys3SVJWUDZm?=
 =?utf-8?B?bEJ0SkVVWnVTaU5qLy9tZVk0WnA4T3BKODZBS0JZbk80aVlRNmtBTGZ2cHYv?=
 =?utf-8?B?eTJtVjZHd3lBOGVXaUUybytrTVdsRVhJL2tVai9HVE9WTDVNVGhmSlJzRjdY?=
 =?utf-8?B?Z05ERm13V1JHV0M0YkFJSWw1UjE1YXpVU0pTTCt6cFlhRGZqcHNYQ3NRekhX?=
 =?utf-8?B?cG1CejVRVzNyZldQTm9lSTF5OUpCVVRiOUVXSm4rZklmRmpoMUxQb3YxekVq?=
 =?utf-8?B?UllwRmJvSTl2dHBOMkZENnlrK2p1RFVnTTBUc09zMVo4akpEZHBDSTR1VU9h?=
 =?utf-8?B?eFNvM0N0ZmdPaFhJOWh3aks4clhrdnZadktuK1FyNElSL2Q2WTdLWStBcElH?=
 =?utf-8?B?VDU3WEttWlY4c3BpSVErWTNOSEF1NTM0NmhBdGZvYndzVHBJa3pCc1N6c1NJ?=
 =?utf-8?B?cDg5T3lUaUxKQU9NL0g1R0lvNnRiRUp0TktkcTZXU200SnllL05YaDk2Wk5y?=
 =?utf-8?B?aGptUXBNVFNFZkxVcXozNE9GTlY0VnlyT1hLUTF0RE9ZVndVaHlFV2ZvWTl3?=
 =?utf-8?B?Q01qMWpxY25kRFZKMGJYb0JhTEp0Nk56RTJDSGF3QnA4TUxyLzhuTHVVK2dU?=
 =?utf-8?B?aDY3YnI1TzBielBZVXZpVmFzS0dnUEcyUDYvSjRHdjJGSDRiemR2ejZSMXZ6?=
 =?utf-8?B?Sm1aMXRJRWZPZEk0TFJyMUVjQ3lwU2xiNWJDWmxZSWFvM01tWksvcFZaM1Nm?=
 =?utf-8?B?aHNFc2pxd3djTmtzYXMyUkxQSUgwUFh6OGYyT25VRVB0S2psSmxweC9Od1Jj?=
 =?utf-8?B?cU5UWGFEOWdrR3Vuak13WEhnRnJLelpFOFBwY2ZuQndZZXFYWHNZWXRzRTFE?=
 =?utf-8?Q?mx5VAoXmPcgqpv9bZSpPAA4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	fAezozVBbiWXf/g8/J4/LjdynT7RIGhBwkait5C0C1qbXfawGUcSvhIC8a3IcdFzHONIjJZvrhjaWeoalAMk8ZJr5xCLWVWsBeZyapeJJY/cuRMlMUqZPp/G4lj7ewibstORihzeEzg1t1QJR34Q1uL5m7H6z0HenvGr6cdSppHPQOcwDRJd5nFO4xkZeAMaBzV4zhKyFIAcOLATq1gCGMo1ltND2NugoDBvcUHtzckY8NpBwjPDCc4NoLUsciqFfVCi95EgN5uqmrJgT/V0pfGGzulSwfBIMPjAtockbQTcSraSHFGYyTeeqxEdL2lL9MxmhNC9N9JR0YQUVvrpu9+R27B8//9uVNkUR8abFQlShve4lHxT7U6k2NkBWffEi526oO6IhTbPFjyD/k7gxxBe3hRwAGcgfGH6l76/Iya/dWeXq2VlgqGTO5qa1GBMOuynJ/LozRR2R0mO1991A73lMZTEJVa5SChjW8r1JvobMgyGud87j/0idqfXKOZFLrqiwIlBfa2LQGfNGaXV0R2bzmfzJGRjqp/PxmaJhdnI0xlQxdMtSQLETg2dNC9ytIunl6kKn0v5sOOhLD0y3lIKcMevVvBhLRNanqs8BHo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f72a81a-db78-4ca0-69cd-08dc3c6e5163
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 17:12:49.2022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jp7N6tBFQloDwPqSz0FTAHIWcAkT25VbYHtbp4BYo6z4y72+kAjBuFiRrd7E6wyV6JEzNXjWw+bJQTJPc87aag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_13,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040132
X-Proofpoint-ORIG-GUID: vbBbzwicGljF8tF-gjoHYMgDCumPDLTY
X-Proofpoint-GUID: vbBbzwicGljF8tF-gjoHYMgDCumPDLTY



On 3/1/24 3:04 PM, Eugenio Perez Martin wrote:
> On Fri, Mar 1, 2024 at 2:44 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add support for the VIRTIO_F_NOTIFICATION_DATA feature across a variety
>> of vhost devices.
>>
>> The inclusion of VIRTIO_F_NOTIFICATION_DATA in the feature bits arrays
>> for these devices ensures that the backend is capable of offering and
>> providing support for this feature, and that it can be disabled if the
>> backend does not support it.
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/block/vhost-user-blk.c    | 1 +
>>   hw/net/vhost_net.c           | 2 ++
>>   hw/scsi/vhost-scsi.c         | 1 +
>>   hw/scsi/vhost-user-scsi.c    | 1 +
>>   hw/virtio/vhost-user-fs.c    | 2 +-
>>   hw/virtio/vhost-user-vsock.c | 1 +
>>   net/vhost-vdpa.c             | 1 +
>>   7 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/hw/block/vhost-user-blk.c b/hw/block/vhost-user-blk.c
>> index 6a856ad51a..983c0657da 100644
>> --- a/hw/block/vhost-user-blk.c
>> +++ b/hw/block/vhost-user-blk.c
>> @@ -51,6 +51,7 @@ static const int user_feature_bits[] = {
>>       VIRTIO_F_RING_PACKED,
>>       VIRTIO_F_IOMMU_PLATFORM,
>>       VIRTIO_F_RING_RESET,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>>
>> diff --git a/hw/net/vhost_net.c b/hw/net/vhost_net.c
>> index e8e1661646..bb1f975b39 100644
>> --- a/hw/net/vhost_net.c
>> +++ b/hw/net/vhost_net.c
>> @@ -48,6 +48,7 @@ static const int kernel_feature_bits[] = {
>>       VIRTIO_F_IOMMU_PLATFORM,
>>       VIRTIO_F_RING_PACKED,
>>       VIRTIO_F_RING_RESET,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VIRTIO_NET_F_HASH_REPORT,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>> @@ -55,6 +56,7 @@ static const int kernel_feature_bits[] = {
>>   /* Features supported by others. */
>>   static const int user_feature_bits[] = {
>>       VIRTIO_F_NOTIFY_ON_EMPTY,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VIRTIO_RING_F_INDIRECT_DESC,
>>       VIRTIO_RING_F_EVENT_IDX,
>>
> 
> vdpa_feature_bits also needs this feature bit added.

The vdpa_feature_bits in /net/vhost-vdpa.c, right? I did add this 
feature bit to this list, unless you're referring to something else.

> 
> Apart from that,
> 
> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
> 
>> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
>> index 58a00336c2..b8048f18e9 100644
>> --- a/hw/scsi/vhost-scsi.c
>> +++ b/hw/scsi/vhost-scsi.c
>> @@ -38,6 +38,7 @@ static const int kernel_feature_bits[] = {
>>       VIRTIO_RING_F_EVENT_IDX,
>>       VIRTIO_SCSI_F_HOTPLUG,
>>       VIRTIO_F_RING_RESET,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>>
>> diff --git a/hw/scsi/vhost-user-scsi.c b/hw/scsi/vhost-user-scsi.c
>> index a63b1f4948..0b050805a8 100644
>> --- a/hw/scsi/vhost-user-scsi.c
>> +++ b/hw/scsi/vhost-user-scsi.c
>> @@ -36,6 +36,7 @@ static const int user_feature_bits[] = {
>>       VIRTIO_RING_F_EVENT_IDX,
>>       VIRTIO_SCSI_F_HOTPLUG,
>>       VIRTIO_F_RING_RESET,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>>
>> diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
>> index cca2cd41be..ae48cc1c96 100644
>> --- a/hw/virtio/vhost-user-fs.c
>> +++ b/hw/virtio/vhost-user-fs.c
>> @@ -33,7 +33,7 @@ static const int user_feature_bits[] = {
>>       VIRTIO_F_RING_PACKED,
>>       VIRTIO_F_IOMMU_PLATFORM,
>>       VIRTIO_F_RING_RESET,
>> -
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>>
>> diff --git a/hw/virtio/vhost-user-vsock.c b/hw/virtio/vhost-user-vsock.c
>> index 9431b9792c..802b44a07d 100644
>> --- a/hw/virtio/vhost-user-vsock.c
>> +++ b/hw/virtio/vhost-user-vsock.c
>> @@ -21,6 +21,7 @@ static const int user_feature_bits[] = {
>>       VIRTIO_RING_F_INDIRECT_DESC,
>>       VIRTIO_RING_F_EVENT_IDX,
>>       VIRTIO_F_NOTIFY_ON_EMPTY,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VHOST_INVALID_FEATURE_BIT
>>   };
>>
>> diff --git a/net/vhost-vdpa.c b/net/vhost-vdpa.c
>> index 3726ee5d67..2827d29ce7 100644
>> --- a/net/vhost-vdpa.c
>> +++ b/net/vhost-vdpa.c
>> @@ -62,6 +62,7 @@ const int vdpa_feature_bits[] = {
>>       VIRTIO_F_RING_PACKED,
>>       VIRTIO_F_RING_RESET,
>>       VIRTIO_F_VERSION_1,
>> +    VIRTIO_F_NOTIFICATION_DATA,
>>       VIRTIO_NET_F_CSUM,
>>       VIRTIO_NET_F_CTRL_GUEST_OFFLOADS,
>>       VIRTIO_NET_F_CTRL_MAC_ADDR,
>> --
>> 2.39.3
>>
> 
