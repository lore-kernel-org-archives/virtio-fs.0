Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074E31C288
	for <virtio-fs@lists.linux.dev>; Tue, 26 Mar 2024 16:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711471778; cv=fail; b=ENdx2OkkgHdtOXU4O0H3u1fbT9tKbfXeq24t1iCimrfxzKAW8ZwldQZGUeJy0zDwQK0jv1PDVoBXMtu83tB+9Ow1FluHNK6v81s6ks49eTXKXv0YLsNKI/k5PSKPyLBdACcrsLbo/QQkGM4GFP34aGb2xSMiUazWsj3c0L75idk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711471778; c=relaxed/simple;
	bh=Pw2G/E3Dv27MtIdyeUy+Vfn2NrbfrAc1sg+mUmJ4wW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uzrubcqUFJpmAQNBrVwqw2bpmpIf4emV2Evvt/jhk9gU6NaoCv8yzR0FiMl9/htajEWoE2H8f0pn0Y3jkwGUwN4i6vJ6D+E5W3YPPTwlrTEkOAaFgTCC8cF4KN36ZCehfZCMs4fPlZop81rvT1f5XLeVYPby1mzu5P2meOras+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n5DS7zPx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GoPZZROU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n5DS7zPx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GoPZZROU"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QEubW3007891;
	Tue, 26 Mar 2024 16:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=9PY5ASEcrt3PaBKCVdqSxdRmXKfXzqn10Op9/MMQJ9E=;
 b=n5DS7zPx9lIOrgoYtEQ3YkGJkcAVO2CbMSOruwJVXKQRNZn6ugaopkFhpYY81mju2o5N
 2Ngd8ofJRW/wdYnw4di4ccHdXEkPiFqmkL6qowQIdM4riQNeMwMsDKLgNp44Qm1h93Jd
 WGopQRcnrKjAlEHQyBjxbPkaLjSDRH2pWrL6DhBP2vNxWmoQdIm3az9HOyqPKbF44M9V
 pRA4zkmdVjqu95msnVKdNHzb1iWuqhLfYVkdgrQ5mXVWZrGD09U1FPJBS0t4tWfreQxQ
 k8PYhFrkI1cTsLDm/U8k/Zti6XhQ4sLJSTPhAjGdRlxHH54/wvSADckY/Ridi16etsOQ rw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1np2djmv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:49:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QGf3YD017590;
	Tue, 26 Mar 2024 16:49:22 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nh7gyng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 16:49:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nso4pEoijaRR9JKElRjh+7+t9vkWtIWRxnBypJqHehmBLjlkzNAl9IM/GYBn0xhGqLH1J5GmHXh2rMofvACSNYWB8Y9u/fXVggGtdyRuv9z8pWwqE1Cf6QlwGzFBtTUC6rNMG/p3jSvdto936ANYDQ83Uir7MBwiboIEEKq295SyKhigNn91Zv1o/Y6G6wh0udqfjr12j/rAUEfuZIwV4jtHmzyJdYzvmwpasMDfT7Z7XsiZ6/BtpCXP8XgnMl/wZUa8oGPjQMRh9u3clKVppcunC6wz6gzCPUonp/n1dhB2jHgNua4uDHDHW5QOzHOKWLVoU/mZbonQgVr5tRaZ0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PY5ASEcrt3PaBKCVdqSxdRmXKfXzqn10Op9/MMQJ9E=;
 b=eRPsvkTqBpJ05K2AObpgOqarq/2pirkh+ihBcyE5mBHfvohWShwFzvLduRmgWyOMf9AfU4ZhbMl1qVWP5+dI9KaCc5tHMB5RsaL70jmhBjvG4iNqXOMx+2bGI47h2yWuChVjTCMpIgNIzQ3rZfdOz3TkkqjLqPdWatmBimBTwkQv16YWrbslJxuQdZLGTY5Q4rs81RWcS33KW2WsLfZP0/9L8H5lgXuKjUCpJSLtR2hXCgxs8rMhAho76pjhaHMbCfQRCyUEFyFW31F9rnto7hg6g34GogNlWBTuBzw+GjgKcqLJqHzfxnS4pf9bPlyZNGAULEGsYL4CL75H9cO4ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PY5ASEcrt3PaBKCVdqSxdRmXKfXzqn10Op9/MMQJ9E=;
 b=GoPZZROUyFaZOb3uvlj1e/rCLe+sBzQBhuePvIqla2dIQN7JIGC1e09wiL4T28VMfZFAkRjJR2br3sRJ1Zbpwt6GcmUrAI5/VHXvx8j3oYg5ZHyiD1IEE13emDwQbdS3e5d3nAP6cBJak+LXO4wy9h9oWIBizxGhnREw8VZYiOg=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by DS0PR10MB6824.namprd10.prod.outlook.com (2603:10b6:8:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 16:49:20 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 16:49:20 +0000
Message-ID: <d435919b-ec5e-41d5-8bbc-354d027f67d0@oracle.com>
Date: Tue, 26 Mar 2024 12:49:15 -0400
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
 <5b8494df-c15c-4d18-ad4a-74b5584429ce@oracle.com>
 <CAJaqyWesW0w=X-okVFAt9Fpy+PybVgq6XSAh=gaej1ozQR+3wg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWesW0w=X-okVFAt9Fpy+PybVgq6XSAh=gaej1ozQR+3wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0009.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::19) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|DS0PR10MB6824:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	a6pOU14L8GLF+I4a7QfQ02ut3o06ueDCDlhoRlU9EmnD3NcKquChxRjMKwvtRI41Z+Nf1MX9U6fA2pgDWXrkkPC5mPRpTuiJ4s327MDY0GAGG39uHSslyeNbHM4l2T5ag1Zj6vvtOayBBvqjRuCbElfTcA2G605FWtWh+rmtgSR+PSCMHhNY+AsluQOYQhCmZau8U4JuBFiXgAMtMBjtRiHt4chYFMxPchof7YCuOoYlmzPtsE++bYQo83MgJjPX32mlftPIA2Zj7iLaARsVureQgy4w7mD6Jsx2fIjr1CFOoOEOIOfx+ERp1BmdqpmL6KgBD5Q86jF5Bd1Y02jsJ7UydiMZxhsS3iBkFvUAW5XVmJK2KiQ0PlSXHrtK903Rmk4uyY3p/gi1OtRXmsl/nWxkStJLiftvRhrNxVw+3GZDDCDBJpnvxNRoGRu4nBgIkbaG47FL7G7fYncMl/OYr2gO3Letnz/aMO7MzU9ublX2cIi5J0AHS9C51pbpJtQn7mOMB8eX3XOD7WuyfTUJ4Nx7NhHFY05Vk9pqH/C32xWN5UqVc98nfvir4n5SG0oCSPyTiO7lLSFX8LS5Z64bgJNzHPdNynuasuAZA2t6T0KR1vbMbioeVAFClAb56xHhvxzl+1o35TA3GIyhBHv6p1bgt6myiiJyxhkWfIJ9oIg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cGVCd1FaeHFVYkFCcTB5cDh1bk9hWVJpMHJKL2tqVC9YMHgrb1ZGNER6QTZh?=
 =?utf-8?B?Yk9pajEveUFidWxMbmFwU01hdDY2TmNyS3gwa0JpaUtob01xK0ZERUE3Zk5U?=
 =?utf-8?B?RzNrM3c4dzdUZElTNlpVbkhQZHhzL0dOcndRZDVsb0c4alNJS0RMaGgwVS9v?=
 =?utf-8?B?a1NvbVNhVGV5Q1dZbWRUZnNVVk9nYmRzcDU2T2dlSElpZGYzcWJ6ckFWNVNL?=
 =?utf-8?B?Y0EycXBCNE5LamFJZEdsRC82ZU1jL2pwSSt3NVIwcWxYcDNpYjU5ZFFEbXgr?=
 =?utf-8?B?RDd6Z1Z4U1I1bVZvbUo2MWZsa0xxS3ZFZ01VK1ZTL3JQWlVUeWNqRllyRm9T?=
 =?utf-8?B?aXc1cnpqTXZBQzhtbHFQVDhzQXBOV0t1V3pJbnpPRXZkMkc0Q1hnNFVoWXhH?=
 =?utf-8?B?cC9KZWFjTXJjRGJ5Qk1oSkJYL2ZhUnhEeXZMcTRTd2NLdU8rN2NtdUEyUkN2?=
 =?utf-8?B?dzZDR3hZQVZhUHY0WldxQnk1aUFlaW1kdWdraExwVUd5V0h4RE9zeVM3YWxu?=
 =?utf-8?B?Q2V4RG15ZEhibUpLNlhJRFpKQzdiaFhMOHZqSWFoSTdhK2szcEtERENuQTFM?=
 =?utf-8?B?ejBUMnFBMEYwMXVJU0Q2K0srbUVwalpIeGtHb3ZCL0VieG5vNW9HeWdacGpO?=
 =?utf-8?B?ellBMUxpdUZ2dXVTM1JYTVRrZHNnZytlakVUWVZlNGc0a05WSDdCdzFDMGdO?=
 =?utf-8?B?RTJKb0V6UnVzNnkwV1FyS2dZcXBmVWJVdUZuSitqaW5scmluZEpKUjVSNnpJ?=
 =?utf-8?B?QWhuaC84Ti8ya3FVT29BVzltVUptcWIyN2R3dlhXSDJIbWcweGVicnNhdHJY?=
 =?utf-8?B?RkNyQVdxQnNTVmpZWFpqSmpyQUhURThaZmdHKzBNbHhCZVl2N1BTY3cxV2lY?=
 =?utf-8?B?c0crNzJMTTVNRkRoeTNzQjZVODYxVElWQW1HZnF2Y1grLzJhYUhHS2hOaFpU?=
 =?utf-8?B?OG5qaTBXTERjb0RFcDdXZE9EOXNZMjhnV21vTmdhdDIrS091VG5LUmZ2angw?=
 =?utf-8?B?cHYxVUI2SjNqb2J1QXVERHFTc2U0Um1yY1hxNTc1ZkkyK1JPejZGdnBjRzdl?=
 =?utf-8?B?VVRQbW1IWlhJN1plZGVGcXlDZFBVNmRmN0ZGb29aUXhPdEt3Q21MeVJXaS9C?=
 =?utf-8?B?emdUaVo4TWZicExHSGp4L3J0NWlLaWNkMnNEQWpIM2M5MHU3b0o4UFNHRnNB?=
 =?utf-8?B?b0lsMWRzeGxDSGc1c1hMU2FVWjFVeEFWcjcyQXdQZXBrMllTdmxuL3psMkZY?=
 =?utf-8?B?QjJqQTc5TDZCVHYwZXdjbVgydVdoaUlFKzRqNWNtc0l5T1hoQi9SQWxiejRs?=
 =?utf-8?B?b2FsY2FidisyUWtjSjlDRGJMSGVHdDd1Vzg0WDF2eVRGTnhjRTJaYkUwNFcr?=
 =?utf-8?B?dWpmZmlYeDAzdVVCcE45bXlGTnpYRWpnS3lISTB4NWtzNlhPb2dQUVZyOHUw?=
 =?utf-8?B?b3loNC9zNk5pZEZ4UnhKVDVqd201ZzErTm9Pd3pNd3pSYVVBa01OUjN0RDdx?=
 =?utf-8?B?UTNoanJvOWVFblNPVDNkZk9jVVJnT3I0TitqamNUTWNuc0pxU1N0bjMxN0JZ?=
 =?utf-8?B?bDlRSzhFeEowMmVVM3hjQitya0Jqemoya0pCYm9EbTBybnBGMzdHSzVid2hD?=
 =?utf-8?B?L1VDUTJNZVFobjVjT0tFeW40aFZLbmVzQXl0U0Y5T3NNM3Y0ZzM2RnY4Z2NK?=
 =?utf-8?B?NjB2dVc3NXk4bDRyWFEzRFBYbDBhaVNPb2x6ZkZnck52c3Y5aDBnYU05RjJQ?=
 =?utf-8?B?c1orSjBLWXNjQzJreWUrWmFTcWYwc3R0ZnhZaVJKQTdIM0FOem53M2llK2tw?=
 =?utf-8?B?VW9yRVRCWGtiZDR0eFVuT0ozcXdqVWJQOS9TblVuUmFBQjV5UGp4TmJMT0xN?=
 =?utf-8?B?T3BQWEk4amkxRHRhc0QrRVhJRzlVVzhtUHBkTkV5S2htL2VGQ3IxZnRIblMr?=
 =?utf-8?B?REJjZXE2YXNTeG02c1FkZ0hCdUhnaEc3YzB5TmswWUNKZE1hQ1lFN2JxcXA0?=
 =?utf-8?B?ZEpmTHFOUk5NNGlIUHJjdXphd1R1Ymk1SXhlK1N3MGJZa1R1QUF0aSs4d0Nm?=
 =?utf-8?B?V3grRDhSc05CWGRrY1NSUE9iNUt3R3ZYb1RjZ0pzckd5V3dCNDNKS1RLaDcy?=
 =?utf-8?B?WVRQcVBHbXRJYXltSFBhQ0lsZHQ2RTZBdlY3OGlnWUtBZkhLMjZqVXR0cGQw?=
 =?utf-8?Q?iFjesA9TPqPZqQ1klud9x2g=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	drnYiyuG7oz7kGOjxzTTo+bLpWWvAch4TMC1SdlzylUREkSQMgGfc9Zyf80+tRzAnvgWz/H5jzkHfJvOU7eTfzXr/8Eq+EXnGqbbMET04dUvDYLgyQLi7tGacLEz4OpnieM4NfANOoCQploNSB0v7Fjyu+nQYBhbA7VrtzNF+m4YIhipaEwp6vVr+Hn+G+xsbrvvKaNirsID3tWBXEy/eBNv7fjfSYSiGMT5bh50a8CMDeBh6L9KuIZVYXBdHHgAyEDxCpxK39sN4v+AbN/UdAiMnUugtVOyA8lzBn6va2XNg237rvTTeeIuUdSpdIasGgjUJcwFZVg00k4jpnvW/rB7039sXRSrx4A5DTTRWzjBQ5WW3/UfGIlejx/W0EPasmZZjq4MvbGhteSzI8Vwz7DKls3niatEItl0vuFGjyQUNXJYcjYaxukpoz856rWUeFLha+5PEvYXljHmNTJAHNMITmA0CJoJOGQV04TfKDuvBf/KgJEVqX91xkWoVjrCn2SsiYod7azAGapQ5cuDLYv0+stFwlO2PfKL8b/MuOlyL7s4SmF/hi2rrMZt9I+IVlpDeaFp+KlmEGS2ws6/hkEO4ijm/ZaFxWPENk7VGIc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdbe8c92-12c8-46e9-2dda-08dc4db4aebe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 16:49:20.2278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LlFRrZ2kVrtdgOLHBz0CpjQAV2SvqG+MsMZC/B4rbBhC3T23c3oY702E22iBwBPiYp8Nv1C2AimUHrAjJvGyKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6824
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_06,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403260120
X-Proofpoint-GUID: Q5sDW2gJeJboeC44efLDJKrw5i5BHfSl
X-Proofpoint-ORIG-GUID: Q5sDW2gJeJboeC44efLDJKrw5i5BHfSl



On 3/25/24 4:33 PM, Eugenio Perez Martin wrote:
> On Mon, Mar 25, 2024 at 5:52 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 3/22/24 7:18 AM, Eugenio Perez Martin wrote:
>>> On Thu, Mar 21, 2024 at 4:57 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>> The goal of these patches is to add support to a variety of virtio and
>>>> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
>>>> indicates that all buffers are used by the device in the same order in
>>>> which they were made available by the driver.
>>>>
>>>> These patches attempt to implement a generalized, non-device-specific
>>>> solution to support this feature.
>>>>
>>>> The core feature behind this solution is a buffer mechanism in the form
>>>> of GLib's GHashTable. The decision behind using a hash table was to
>>>> leverage their ability for quick lookup, insertion, and removal
>>>> operations. Given that our keys are simply numbers of an ordered
>>>> sequence, a hash table seemed like the best choice for a buffer
>>>> mechanism.
>>>>
>>>> ---------------------
>>>>
>>>> The strategy behind this implementation is as follows:
>>>>
>>>> We know that buffers that are popped from the available ring and enqueued
>>>> for further processing will always done in the same order in which they
>>>> were made available by the driver. Given this, we can note their order
>>>> by assigning the resulting VirtQueueElement a key. This key is a number
>>>> in a sequence that represents the order in which they were popped from
>>>> the available ring, relative to the other VirtQueueElements.
>>>>
>>>> For example, given 3 "elements" that were popped from the available
>>>> ring, we assign a key value to them which represents their order (elem0
>>>> is popped first, then elem1, then lastly elem2):
>>>>
>>>>        elem2   --  elem1   --  elem0   ---> Enqueue for processing
>>>>       (key: 2)    (key: 1)    (key: 0)
>>>>
>>>> Then these elements are enqueued for further processing by the host.
>>>>
>>>> While most devices will return these completed elements in the same
>>>> order in which they were enqueued, some devices may not (e.g.
>>>> virtio-blk). To guarantee that these elements are put on the used ring
>>>> in the same order in which they were enqueued, we can use a buffering
>>>> mechanism that keeps track of the next expected sequence number of an
>>>> element.
>>>>
>>>> In other words, if the completed element does not have a key value that
>>>> matches the next expected sequence number, then we know this element is
>>>> not in-order and we must stash it away in a hash table until an order
>>>> can be made. The element's key value is used as the key for placing it
>>>> in the hash table.
>>>>
>>>> If the completed element has a key value that matches the next expected
>>>> sequence number, then we know this element is in-order and we can push
>>>> it on the used ring. Then we increment the next expected sequence number
>>>> and check if the hash table contains an element at this key location.
>>>>
>>>> If so, we retrieve this element, push it to the used ring, delete the
>>>> key-value pair from the hash table, increment the next expected sequence
>>>> number, and check the hash table again for an element at this new key
>>>> location. This process is repeated until we're unable to find an element
>>>> in the hash table to continue the order.
>>>>
>>>> So, for example, say the 3 elements we enqueued were completed in the
>>>> following order: elem1, elem2, elem0. The next expected sequence number
>>>> is 0:
>>>>
>>>>       exp-seq-num = 0:
>>>>
>>>>        elem1   --> elem1.key == exp-seq-num ? --> No, stash it
>>>>       (key: 1)                                         |
>>>>                                                        |
>>>>                                                        v
>>>>                                                  ================
>>>>                                                  |key: 1 - elem1|
>>>>                                                  ================
>>>>       ---------------------
>>>>       exp-seq-num = 0:
>>>>
>>>>        elem2   --> elem2.key == exp-seq-num ? --> No, stash it
>>>>       (key: 2)                                         |
>>>>                                                        |
>>>>                                                        v
>>>>                                                  ================
>>>>                                                  |key: 1 - elem1|
>>>>                                                  |--------------|
>>>>                                                  |key: 2 - elem2|
>>>>                                                  ================
>>>>       ---------------------
>>>>       exp-seq-num = 0:
>>>>
>>>>        elem0   --> elem0.key == exp-seq-num ? --> Yes, push to used ring
>>>>       (key: 0)
>>>>
>>>>       exp-seq-num = 1:
>>>>
>>>>       lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>>>                                                remove elem from table
>>>>                                                        |
>>>>                                                        v
>>>>                                                  ================
>>>>                                                  |key: 2 - elem2|
>>>>                                                  ================
>>>>
>>>>       exp-seq-num = 2:
>>>>
>>>>       lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>>>                                                remove elem from table
>>>>                                                        |
>>>>                                                        v
>>>>                                                  ================
>>>>                                                  |   *empty*    |
>>>>                                                  ================
>>>>
>>>>       exp-seq-num = 3:
>>>>
>>>>       lookup(table, exp-seq-num) != NULL ? --> No, done
>>>>       ---------------------
>>>>
>>>
>>> I think to use a hashtable to handle this has an important drawback:
>>> it hurts performance on the devices that are using right in-order
>>> because of hash calculus, to benefit devices that are using it badly
>>> by using descriptors out of order. We should use data structs that are
>>> as free as possible for the first, and we don't care to worse the
>>> experience of the devices that enable in_order and they shouldn't.
>>>
>>
>> Right, because if descriptors are coming in in-order, we still search
>> the (empty) hash table.
>>
>> Hmm... what if we introduced a flag to see if we actually should bother
>> searching the hash table? That way we avoid the cost of searching when
>> we really don't need to.
>>
>>> So I suggest reusing vq->used_elems array vq. At each used descriptor
>>> written in the used ring, you know the next head is elem->index +
>>> elem->ndescs, so you can check if that element has been filled or not.
>>> If used, it needs to be flushed too. If not used, just return.
>>>
>>> Of course virtqueue_flush also needs to take this into account.
>>>
>>> What do you think, does it make sense to you?
>>>
>>
>> I'm having a bit of trouble understanding the suggestion here. Would you
>> mind elaborating a bit more for me on this?
>>
>> For example, say elem0, elem1, and elem2 were enqueued in-order (elem0
>> being first, elem2 last) and then elem2 finishes first, elem1 second,
>> and elem0 third. Given that these elements finish out-of-order, how
>> would you handle these out-of-order elements using your suggestion?
>>
> 
> virtqueue_fill is called first with elem2. So vq->used_elems[2 %
> vq->num] is filled with the needed information of the descriptor:
> index, len and ndescs. idx function parameter is ignored.
> 
> Optionally, virtqueue_push is called. It checks if
> vq->used_elems[vq->used_idx] is valid. valid can be elem->in_num +
> elem->out_num > 0, and reset them on every used ring write. If it is
> not valid, this is a no-op. Currently, it is not valid.
> 
> Same process for elem1.
> 
> virtqueue_fill is the same for elem0. But now virtqueue_flush gets
> interesting, as it detects vq->used_elems[0] is used. It scans for the
> first not-used element, and it finds it is vq->used_elems[3]. So it
> needs to write an used elem with id = 2 and the corresponding length.
> 
> Maybe it is interesting to implement ways to improve the look for the
> last used descriptor, but if any I'd go for a bitmap and always on top
> of the basis series.
> 
> The algorithm has not been tested, so maybe I've missed something.
> 
> Thanks!
> 

Thank you for taking the time to clarify for this for me, I appreciate it.

I spent some time yesterday and this morning working this over in my 
head. I believe I understand what you're trying to do here and it makes 
more sense than employing a data structure like a hash table for this 
kind of job. However, I have a few questions regarding this implementation.

So, one question is on the reuse of the VirtQueue's used_elems array. 
Wont reusing this array cause issues with packed VQ operations, since it 
also uses this array? If we want to stick with using this array 
specifically, perhaps we may need to rewrite its logic if the device has 
negotiated the in_order feature? E.g.

virtqueue_packed_flush (...) {
    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER) {
       // new logic
    } else {
      // current logic
    }
}
-----------

Regarding this paragraph:

"virtqueue_fill is called first with elem2. So vq->used_elems[2 %
vq->num] is filled with the needed information of the descriptor:
index, len and ndescs. idx function parameter is ignored."

This looks exactly like virtqueue_packed_fill except for the idx 
parameter we'd pass in (sequence_num % vq->vring.num).

In any case, regardless of whether this element being passed in is 
considered to be in-order or not, we still add this element to 
vq->used_elems in virtqueue_fill. Ok, got it.

Then you say "Optionally, virtqueue_push is called". I assume by 
"optionally" you mean we need to know if this is a single-shot operation 
or a batched operation. A single-shot operation would call for 
virtqueue_push whereas a batched operation would just use 
virtqueue_fill. If this is what you meant by that then ok, I understand 
that too.

However, I think before we start considering whether or not we need to 
call virtqueue_push or continue with virtqueue_fill, we first should 
know whether or not this element is in-order. And I think to do that we 
should use the check you mentioned:

if (vq->used_elems[vq->used_idx].in_num + 
vq->used_elems[vq->used_idx].out_num > 0)

or perhaps:

if (vq->used_elems[vq->used_idx] != NULL)

If the element is found not to be in-order, I assume we return and we 
are done with the handling of this element for now.

Now my confusion with this part comes from calling virtqueue_push inside 
of the virtqueue_fill function. Wouldn't calling virtqueue_push inside 
of virtqueue_fill present some kind of recursive execution path? Unless 
I'm missing something here, this probably isn't something we need to do, 
right?
-----------

Lastly, when execution reaches virtqueue_flush, what would define an 
element as unused? Perhaps...

if (vq->used_elems[i] == NULL)

or

if (vq->used_elems[i].in_num + vq->used_elems[i].out_num > 0)

Thanks Eugenio!

>> Thanks :)
>>
>>> Thanks!
>>>
>>>
>>>> Jonah Palmer (8):
>>>>     virtio: Define InOrderVQElement
>>>>     virtio: Create/destroy/reset VirtQueue In-Order hash table
>>>>     virtio: Define order variables
>>>>     virtio: Implement in-order handling for virtio devices
>>>>     virtio-net: in-order handling
>>>>     vhost-svq: in-order handling
>>>>     vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>>>>     virtio: Add VIRTIO_F_IN_ORDER property definition
>>>>
>>>>    hw/block/vhost-user-blk.c          |   1 +
>>>>    hw/net/vhost_net.c                 |   2 +
>>>>    hw/net/virtio-net.c                |   6 +-
>>>>    hw/scsi/vhost-scsi.c               |   1 +
>>>>    hw/scsi/vhost-user-scsi.c          |   1 +
>>>>    hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
>>>>    hw/virtio/vhost-user-fs.c          |   1 +
>>>>    hw/virtio/vhost-user-vsock.c       |   1 +
>>>>    hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
>>>>    include/hw/virtio/virtio.h         |  20 +++++-
>>>>    net/vhost-vdpa.c                   |   1 +
>>>>    11 files changed, 145 insertions(+), 7 deletions(-)
>>>>
>>>> --
>>>> 2.39.3
>>>>
>>>
>>
> 
