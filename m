Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC385D46B
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572167; cv=fail; b=JNy5Yd3Fv3xeSGqh+Ap4rH3YrvVZ8A5LSqryxbSFDgtI5efoGJHDlj/UVvtmDErHysJBpRBVE13e6IfYRqpmZGH8SJwDmnan99Q37ORmV7OOqoxjbYex6bevh7E7W1ax4PJ9UyZjmsDl523nQyZ6p5O6fQQNeovDh2+5fnpNNOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572167; c=relaxed/simple;
	bh=905IyN+wI1lWQosI5Xe0yX9J2JkgyvoOGhvjc1mB+70=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hgmz6IVbojY3NIR6jM3eTKdd93Qg7P30JA/vmoMrwjo8OCw3CAMEbQc8MxuvhkARwrzKvnN1jhByGxoIajX0GIur5FvVCEHtgWTe7Hqm8F4Hli9c6VJo8asqqcj7mP/DeZLHcsf6EU4+FhEYDgFGoArnnLersG2ZRVA7JtJLtyA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GxG80Z1R; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OsyZD0v9; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GxG80Z1R";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OsyZD0v9"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424GYbUh029298;
	Mon, 4 Mar 2024 17:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=psE9ORBH7E9dbgMg+sd9CQv8iQz5jJ0YwUjO4WqCO7c=;
 b=GxG80Z1RWD5LOhLhb0ywetXOfB9gDtGN04+zIVmOkjTnkIh7XpbjUO26ZkSd8IwQmzbj
 oFk3+c6Iv1D6LSuB9tJHwaEZKYMTsfsTNBNCimvd025b0TxgGUVSTQGkyZrHIHk/9PlU
 B1Ou9xW7xI8sTSXhZq8DxdY2UjAI6IJ1aYzzDr9ApSdJJu6Fxws36wd1Z6QNXrXJG6SX
 gkxAYUtOBpzDCl0oamcdwQW8xFmze076w2H1sdIzzr5yJd1ycgl9xalz4UfzfEdVMqps
 YcPwur5d2PiKXZ2AdnFYaFjJYiySgEXK0Q9fFEdyoF7AzCCGhNJCFd1gS2lhjMfI502f zQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkvnuv4hj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:04:17 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424GxLiU015342;
	Mon, 4 Mar 2024 17:04:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj6bbhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:04:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZ/EGyRkHM6ZORYPeXmJeNn/2kI7hKc6RZtPDP/i46c8PRXUjYEy3okS5ImXPxWo8oiOLuk5NKhKM6CAQmqDLkwr6GDCv7tYY0GvTrx/LynZu9vlVdqdAF/k2wKfEv09dLwxTyysxgWYb3OI6iMadhx6bkURd8HxL7bdY/ym4q+EOXuEybj1SL/No4FKc738yE4xgDRPwH7CLZ8A23aHFamb6TYBOqfgZd5ikH16YlSxgaMqCHNQO+EZo8ppC6VVmerqE4Oy9Ce+dFzwM4x1ETeHa8DJ4XC3l9krQSBcRxp6mrqMDr48CP1bP0v+/8qssvbdfh7o5emeK0I1/nnVVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psE9ORBH7E9dbgMg+sd9CQv8iQz5jJ0YwUjO4WqCO7c=;
 b=lqpjbKQVl6/FW2RKgFaAOgD29e+JFl09eVQ6zm8aNOUKzkgBDyN5OaR0I7SbWQQX74EL0H3aK3LKmsNALMWLvTkfDwfGIE5asiv6s+nzYBF5sb9Z+DPlTB93+FbsPzHBhYvV+GLbWHZz0Kr7f3IlgAEkviCa+sSR0TOm+rHtltwaeJiPTSaVVK6q66KJrrgS4rgCA7KVH4AHk0QF4HQ5cbC+QS5+fTF7OQzlk/6hCH7WW7wZ7K6QLRWlHR69mW6/4fzVbnsM3m+WuhU0iXEqsJkjzr7KpbfRYjOkZbYuRypKco2v6+9Q3/54fKb5xsWQM/bJuOXdLEoY7PnTlx57hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psE9ORBH7E9dbgMg+sd9CQv8iQz5jJ0YwUjO4WqCO7c=;
 b=OsyZD0v9MKRsSf7biYiRB4vFgpfmOPXxTzkkos5AE+jKCKFvQwzNbI/vm+L4QOv/RFGrHZ7PAD10ZU4snwZWihhGiaZBrEfCFU9EEdlMYT9aCiby82EQi7oQJPsK+bxKpHxqthxvWXusTWNDGfyzzbsQGp1Tdlz09tq8Io3pntI=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CH0PR10MB5020.namprd10.prod.outlook.com (2603:10b6:610:c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Mon, 4 Mar
 2024 17:04:12 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 17:04:12 +0000
Message-ID: <964078ad-35de-4687-86e4-e3bc059481b0@oracle.com>
Date: Mon, 4 Mar 2024 12:04:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/8] virtio/virtio-pci: Handle extra notification data
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
 <20240301134330.4191007-2-jonah.palmer@oracle.com>
 <CAJaqyWdokP3yqbP8wPfgttFyFWfy1O3ST4jUQmiJ+n-xkrp_Zg@mail.gmail.com>
Content-Language: en-US
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWdokP3yqbP8wPfgttFyFWfy1O3ST4jUQmiJ+n-xkrp_Zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0016.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::29) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CH0PR10MB5020:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8fe575-bb3f-4917-33e1-08dc3c6d1d1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	N8mHW9jMDf6lgkCxPNY0Me8YpjKMAUU0zT01U90OSKBoYi2286qN8+0u2SQUIZ5gZxE7APatzUwyweh9UrWGvkj++WCBcYxeUP6qlIEd64VgpEqCFIe1f/m8UZx9+tQSB5dJIN4IYjyP1jz/EAtc9yKjCPcUqfLsRT49vjcxl9NYiufK3WegJdsYYmQwTnb8HE0o6G9M1zom64ePT5MwZi8zAsEENe4zOLMaGVjYyx0mABL9pCOibEH+vD3njg9Fucw1X0+dMBycGyaK2OYrcdg85t6vVWvZs9WrMgQwfohO5XKujJMk99MySnk66SZk3t1ZwKRAZCi/wq8uRtjmRtxirbVK2PkxBOJq/vwgfWnVMnQGdibzqU4dUN55eEWCK4CGUfG+6v3EC7cQXA4jlcxh36Xk6LrOjSIzsSoh1lHfPvAJOeBYOpm02XcyzmzQEWjyCmp+G1VpCUp3krV6DbZbni4rchmogSwH3jsCGvoM3RdHd1M5Lq8Ck8gvE+1fsHvFVxeY5IdLOBP4SBYuf7cksoDLK0Zvbf+j6eSNKEQJiuX1lwceBJnNerUS5o9jpsByOeEEQt8ETLUHcqgwrV+R5wIBMhK3uevQTwgghM/MHTNVI1jJdZQpndJ0zUB8kXHlAOuJCMGbVYN/sIOKP4KogdMrVDCsAH8wEEQV/v8=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K1lobmRFczdWaFN2dU9jdmhzYStvMWRVUTNxUWdsVS8rS0hmWkIzUWoxdUdX?=
 =?utf-8?B?N1dQV1ZRMVBDczFqWlcwTmtRVTJKcGxqei80V1ZHek81b2JHaUhBcy94MFo2?=
 =?utf-8?B?VGoybTFONnEzcG9WUGFTTmZuNFdtYzhIWDVZd3phTEpiOWFyV1FqcnFhbXlp?=
 =?utf-8?B?a2JoY1BpeVFWMUhTcUdSM1pFZzQvamlhRW9McGMvQTc1SGlIK010TlJGVFM5?=
 =?utf-8?B?cHNMdGllQTR2UnQ0RmxnZzlrY2F6bzRnYzkzUDBPU1RnbFZ4VzcwRjB1NHlL?=
 =?utf-8?B?dWJqN0hDSVhNY2ZReGwwQ0wweGxYTHNzL2VvRFhRaWI2cGlQUTExVkU5UTJM?=
 =?utf-8?B?RGVPNnhuTFh1U0xRKzBuMzJRN1Bhc2JuclFkMSsxQkRmeVRtU1psMjlCcG5T?=
 =?utf-8?B?dHZabUIxV2l0eVByS3RPR1RldDJ6YThLRjVPZnZiV3V4ZXdkTjF1ZklwMWNF?=
 =?utf-8?B?cUhQekM2bDFCSjc0ckJaT1hlZDBjWXRBVXh4MGN0S3RvZVBEczZYMmFIQjZT?=
 =?utf-8?B?TUpBWjh0cXRKUE1ENFJhVVNSOElackVJTTF5MXJQNXg1NVkzUm81dnl6RHdX?=
 =?utf-8?B?azF2ZzJ2Z0txckdQdjBTZVVmTjhSajlaWVFQVVYzczBFd00vSGM4anF3NE96?=
 =?utf-8?B?M3BIYS9Nc2U4MXdSbWdnby95M3ZIbHVraS9Zc1pNRHlWMXNLUW1TKzhqckJB?=
 =?utf-8?B?cmc3MXhkOUx1eGRZYjRZb3QrazVUQk1SY0Q1UEJrZjlJaFFDQnprZ3lKZ1lF?=
 =?utf-8?B?aHJoWVo0ZDZGclNVbHFMeG5ZczdDVk5RRGo5SFQ2MmpqZ0JlRFNjclhQVTdI?=
 =?utf-8?B?anh2VTdFUitmbi9tOHUyanRIcjUwTCtIUEY0UGlWTnl4YXIra1IrV0xzMzJ1?=
 =?utf-8?B?RXhEekhpcmFNS1R5SUplejk2TXFMQUVFMHByTklEOGVqQkRlc1ZsTGNiNnlU?=
 =?utf-8?B?N1FkZ0Rmek9EMldyWHBxNGxYREgreUEzcm9EcVppQ3RIV1EvNWpsM3hLRlJF?=
 =?utf-8?B?bkRyNlVqM3lUY2JXR0pvR3Jua0ZZWSs5T3lUSzFQUXh2ZnZrc1hjMWtQUU1L?=
 =?utf-8?B?L01aQlkyZnRZa2wxMXFvcG1LUU9pVUc5T2FrZ3libmRza1A0OVBWc21mQ0xz?=
 =?utf-8?B?QzNGbEl6YmZRbUZ5a0RJZkJ2Rm1sdFNuMEVwMmxRUUF6NjFFVkVxMjZhMkp3?=
 =?utf-8?B?RXNXRkQ1RnFwWDZEME1FeCt3Y1ZUUVpVNDUrTFdMR0tCUE9qVFpOai9pVkph?=
 =?utf-8?B?L1l2bmQ2M2w4VHVzR1g2YXZFYVAySWxIVEN5QXpvbldOdXpjWnUxWU0zMnB6?=
 =?utf-8?B?d25KRmNQc3NlSitxRnlXbStRd1Mxb082R2N3YlZacGxKTkdoL3RGYnIyVXda?=
 =?utf-8?B?SDJwMndKZ1V2WHhiS1l4TzFUcmZmLzVOY0ZVc1BUbmN0SVl5eEhyT05WbnNW?=
 =?utf-8?B?eitzcWhiL2NFaEV6L3VvTU1NL3pFYlhIbTNqYWpvQjJ5RlhacXNKSjJhQkR0?=
 =?utf-8?B?eDd1Um53UFFOVjd1eGpiK3N1Z0d3bjRsWEpQMDBZNUEyWFFZZGxBUFN4eDZM?=
 =?utf-8?B?WkNnUXRXUU5MdXZuUmJvODc5bndLbW9XT01SWEVVUVFWVkNBNGszUTRWUjR4?=
 =?utf-8?B?Y0RGM0NPMk95U3pIbEYvT3ZNTStOaVF4bm9lekp5MDNwcm5RMitMT2tQMFFD?=
 =?utf-8?B?V0x4aTNjKzJPb0trbEQwalBBMGttRWo1bjA2eDVZSXpyTlBCZmk4M2R3c0xr?=
 =?utf-8?B?TXlvRktWZUQvQjZYTzlWQTdDaE1lQVZCTVRmdkxla05BQmF3QWd2TlB5dFBV?=
 =?utf-8?B?ZjU2L0FTN2NVa1pSQ1FFS0NPb01GeW16WjN3YVZBaS9YcXpTMGZLWktKNU05?=
 =?utf-8?B?OEkzVkVtbGZOY1BSOHcwd015V1BmbmJ0ZHI5RFgvN2krb21LNXQ0NFU4WVpV?=
 =?utf-8?B?dTdkQktObTJabURpMDdLbFFGaGVzZ25CVVhYOGo4V3FyekJzRjhCNi93QzBa?=
 =?utf-8?B?L2htdS9aNnl2SkIrcUVKK21VSWxCbnZCaGptT0s0V3M5TzY5ZHhXTjk2bXZi?=
 =?utf-8?B?TDBMNERtdnQ2T0wySDhXTDltRUQxU28wVlV5VWtzeXBYZXBVS2Y4U0l3eFRH?=
 =?utf-8?B?YUY3eHB0ektCTVo5ZlY5RVo2Ymg5bS84WjlrM1hubW9sSUNTRmhhL3UrTkpH?=
 =?utf-8?Q?mIGkq/k14FN8Q4R45ffeNQU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8kfHsG2/4/LSbXwV+dR0rtycgnLB65h1N5KS0jTpIDecGdLkKJhZcSprTDMzUn+izbOq9kqi8E5+inlVawVwFxiYAa3DdwsT8vY8uP8Dp3d0rnVF255jAhDITLmzz4ZIrVUIb9FIq89o7ox5ueSPKYeZsNG4dontJuH1QMoMpNeKQnGpW7VnS0WG/uLI+FzKK1bTr89JjTEbwKrPv0iQNtskGsqJlUlmNWDUYOl9s7maRSt4OvBd+qq1UsjGLZCXkrUhng46r2yG/0W00Rb2QKcUQct1r3YdACbg/QC24vcwGzXcPHu1eUJ/HhyDVFak9DR2+nVD0ORHAszF/yWSSbDtcN8mIErFw+hZGk/SfUvqNp5so5s7sW9q5n/rvITbHuFurGQX2YbKneklD0YPNaUrQ5lujfSKpfK9ZH0EDVj8pr8BWks0GNEugVKTwLA8yT9lhnWlg9hHRzPW3r3bXYIAKcQO9v46P2YunyXA1scVMiFPNU8o3LU8t/ADk/q2oAFMWfuKIdC8U1+/S/CMWXFfDgm8TEQp103iKni3o9vyTMdT1uuO558348T2ETfJ7JVaP0IPqF9G2XMjsSx3PVvIfBSeNp35oiPbd/sqGbk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8fe575-bb3f-4917-33e1-08dc3c6d1d1e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 17:04:12.4667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2VpL3aJRQSfJcHxkCuhG013B4q/XLri2aeX46oIYRt+fr9YxpJlEBFMUBBtVWciGrNfPyMW8JmrnpysgGgI/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5020
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_13,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040131
X-Proofpoint-ORIG-GUID: oBfkjHBRDemwoV7o5TMkpcUEOfwEGN80
X-Proofpoint-GUID: oBfkjHBRDemwoV7o5TMkpcUEOfwEGN80



On 3/1/24 2:31 PM, Eugenio Perez Martin wrote:
> On Fri, Mar 1, 2024 at 2:44 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Add support to virtio-pci devices for handling the extra data sent
>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
>> transport feature has been negotiated.
>>
>> The extra data that's passed to the virtio-pci device when this
>> feature is enabled varies depending on the device's virtqueue
>> layout.
>>
>> In a split virtqueue layout, this data includes:
>>   - upper 16 bits: last_avail_idx
>>   - lower 16 bits: virtqueue index
>>
>> In a packed virtqueue layout, this data includes:
>>   - upper 16 bits: 1-bit wrap counter & 15-bit last_avail_idx
>>   - lower 16 bits: virtqueue index
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   hw/virtio/virtio-pci.c     | 13 ++++++++++---
>>   hw/virtio/virtio.c         | 13 +++++++++++++
>>   include/hw/virtio/virtio.h |  1 +
>>   3 files changed, 24 insertions(+), 3 deletions(-)
>>
>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>> index 1a7039fb0c..c7c577b177 100644
>> --- a/hw/virtio/virtio-pci.c
>> +++ b/hw/virtio/virtio-pci.c
>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>   {
>>       VirtIOPCIProxy *proxy = opaque;
>>       VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
>> -    uint16_t vector;
>> +    uint16_t vector, vq_idx;
>>       hwaddr pa;
>>
>>       switch (addr) {
>> @@ -408,8 +408,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>               vdev->queue_sel = val;
>>           break;
>>       case VIRTIO_PCI_QUEUE_NOTIFY:
>> -        if (val < VIRTIO_QUEUE_MAX) {
>> -            virtio_queue_notify(vdev, val);
>> +        if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>> +            vq_idx = val & 0xFFFF;
> 
> Nitpick, but since vq_idx is already a uint16_t the & 0xFFFF is not
> needed. 

Ah okay. I wasn't sure if it was worthwhile to keep the '& 0xFFFF' in or 
not for the sake of clarity and good practice. In that case I could just 
do away with vq_idx here and use explicit casting on 'val'.

> I think it's cleaner just to call virtio_set_notification data
> in the has_feature(...) condition, but I'm happy with this too.

Do you mean something like:

if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
     virtio_set_notification_data(vdev, vq_idx, val)) {
     ...
}

Though I'm not sure what would then go in the body of this conditional, 
especially if I did something like:

case VIRTIO_PCI_QUEUE_NOTIFY:
     if ((uint16_t)val < VIRTIO_QUEUE_MAX) {
         if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA) &&
             virtio_set_notification_data(vdev, val)) {
             // Not sure what to put here other than a no-op
         }

         virtio_queue_notify(vdev, (uint16_t)val);
     }
     break;

But I'm not sure if you'd prefer this explicit casting of 'val' over 
implicit casting like:

uint16_t vq_idx = val;

> 
>> +            virtio_set_notification_data(vdev, vq_idx, val);
>> +        } else {
>> +            vq_idx = val;
>> +        }
>> +
>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
>> +            virtio_queue_notify(vdev, vq_idx);
>>           }
>>           break;
>>       case VIRTIO_PCI_STATUS:
>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>> index d229755eae..a61f69b7fd 100644
>> --- a/hw/virtio/virtio.c
>> +++ b/hw/virtio/virtio.c
>> @@ -2052,6 +2052,19 @@ int virtio_set_status(VirtIODevice *vdev, uint8_t val)
>>       return 0;
>>   }
>>
>> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32_t data)
>> +{
>> +    VirtQueue *vq = &vdev->vq[i];
>> +
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>> +        vq->last_avail_wrap_counter = (data >> 31) & 0x1;
>> +        vq->last_avail_idx = (data >> 16) & 0x7FFF;
>> +    } else {
>> +        vq->last_avail_idx = (data >> 16) & 0xFFFF;
>> +    }
> 
> It should not set last_avail_idx, only shadow_avail_idx. Otherwise,
> QEMU can only see the descriptors placed after the notification.
> 
> Or am I missing something?
> 
> In that regard, I would call this function
> "virtqueue_set_shadow_avail_idx". But I'm very bad at naming :).

Ah that's right. This would make Qemu skip processing descriptors that 
might've been made available before the notification but after the 
host's last check of last_avail_idx. In other words, ignoring available 
descriptors that were placed before the notification but not yet 
processed. Good catch, thank you!

So, for the packed VQ layout, we'll still want to save the wrap counter 
but for the shadow_avail_idx, right? E.g.

if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
     vq->shadow_avail_wrap_counter = (data >> 31) & 0x1;
     vq->shadow_avail_idx = (data >> 16) & 0x7FFF;
} else {
     vq->shadow_avail_idx = (data >> 16);
}

> 
> The rest looks good to me.
> 
> Thanks!
> 
>> +    vq->shadow_avail_idx = vq->last_avail_idx;
>> +}
>> +
>>   static enum virtio_device_endian virtio_default_endian(void)
>>   {
>>       if (target_words_bigendian()) {
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index c8f72850bc..c92d8afc42 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -345,6 +345,7 @@ void virtio_queue_reset(VirtIODevice *vdev, uint32_t queue_index);
>>   void virtio_queue_enable(VirtIODevice *vdev, uint32_t queue_index);
>>   void virtio_update_irq(VirtIODevice *vdev);
>>   int virtio_set_features(VirtIODevice *vdev, uint64_t val);
>> +void virtio_set_notification_data(VirtIODevice *vdev, uint16_t i, uint32_t data);
>>
>>   /* Base devices.  */
>>   typedef struct VirtIOBlkConf VirtIOBlkConf;
>> --
>> 2.39.3
>>
> 
