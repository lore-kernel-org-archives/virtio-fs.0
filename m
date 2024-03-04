Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BD54653C
	for <virtio-fs@lists.linux.dev>; Mon,  4 Mar 2024 17:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709572141; cv=fail; b=cZ5eAqzcePlvVGodhMei90lK4SYvhj3+haVWTxOPmI+8mupffEv5ItjdgfSPNe6tG244vCJResAPOEM7kdkxctJwoXqIKou0xQxVngkfb43rCvftns4CXWF44jAzGArrZ+tMKwK0hW68vQs2xOkGlGxJwvnMsBrdSyLE7ILNHuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709572141; c=relaxed/simple;
	bh=qv3ytA8dDhCFqszQXkCljwgCNZDykCuXNWInVz5HoKg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uzgs8tuAgJ4f2YSRwpMh+8WVHPGPNG82oKF5QROA1RLvh/M7Xq4MW9eqNZCiY4qjr290IHLT+nIJZUWSzwSr0Q6UgG8RDFII1fjLXcWOafm6a1P+4BJerFbbzJWP4CzKpt+VOLvv3cjMn2y5aE6P6uXEwrbqRSMrwhovl3jkewI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DDBL3xwB; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YrAttoLX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DDBL3xwB";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YrAttoLX"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 424GXw0b031007;
	Mon, 4 Mar 2024 17:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Vk604auIhj2/Dz5AjUDeP6CTlTuAlnuFRjMWADuHJaM=;
 b=DDBL3xwBp55TPf+ejsKCRu6JThwOPvSj1Nx237xLdyOHcYgXIjlXUaOSo5XR6ygrP4aI
 HRmaut+cSlilu1dONxj9MX0MMRF0sW5KbWoxl0Z0bMvZq67NU0YqFJAzXqvr8EI/TzMo
 1LIMJipzekdsNsoirzDEIAst/X7muIOwX36O3OShEc6DhsQskLZQ1lmP4jEqE7u0TRX+
 7y06LzuMNkVcz6+bb+Ulol8rQuMqI4IvedXgWKxKrHo1lrvB/UPW/wUqU6zW91Zo9qrD
 sbqtR/aqqa2wfRKe+m6vb2oDkxvQTkvJI5JhKHLRGhifA82bnXUxqYhF0gaJY5VUbxg8 Pw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wkuqvc2gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:08:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 424GwVYw019156;
	Mon, 4 Mar 2024 17:08:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktj62x8v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Mar 2024 17:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSB7oP0hZ7Yo0MHJXJVBVRm8ikaCRrmN0Uwqi7RvIa5610wPK37Wi9wipzGO0wA0O0hinrz5VhJtyK+uIis1oECz0a3okwGN0V2+mOvplHoVFVMBv0tbS04pjy879QOPGYNajhcO5Y4V4mAGlTelFcKXPFefABhsPcmdmaI3A6p6bZ3vRNgCzFUmyqNLcTj7QL/2NUOqiIrAjdNysRFB8U6aEHxVLVbj6b3/DOzr69SPFZmQ+Ifee0yv/cKM+NoRNY/M7SIPjTG75ZD+Ti1Y0mYTBWayguS4HIrk2Mtg9bPMsNmFBq715i7m+9cEeAdnLytildtOjOCo5YCtogZU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk604auIhj2/Dz5AjUDeP6CTlTuAlnuFRjMWADuHJaM=;
 b=JpeTB+fGf594NZDSg/MayyrLVls50D+LBtuEgDK9c09V6KoeqIe9avysZ0M0VM0AHRYazPQ26qYEEymWPmGHm3vmLmPRGU2JduWHpyt11uUNatbD0/6EVUvzGyzcWcQacOgHGzmy1zStfQ2L4lHH1pA3L4Zkj71OwA4tygFAcaFIUs1CSTFuuZvLWkLEbmIqXCAJN7US5DnC5j/1h21kWceB4mUBio76HIbihqvraksSlZ/zrekQ4fMkmLM7DsMTads1IVdlGMxrDjoKdhi5Ezynzp6ZMOp3ZeOpekqvhimTXG3hjID5V3cZY/8eN76+GVmYjpyeCPp7yAkgh4iJww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk604auIhj2/Dz5AjUDeP6CTlTuAlnuFRjMWADuHJaM=;
 b=YrAttoLXNtCrGocrLmwPySTYgQ+jkvQX3n2zQ2EvABVVVvf7Aa7DSV1iEfkuaNfx8xnKyEr+EOaRxiULWCLUExnQDuuAzVouyOjb2o8GFPlsGRIqnyHmlb4H4JyXpJ6oWJ/yMi0e2R5NWztoZtJQhRWjbXXXhdTtAsF7eMluJ5Y=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by SJ0PR10MB5600.namprd10.prod.outlook.com (2603:10b6:a03:3dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Mon, 4 Mar
 2024 17:08:16 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 17:08:16 +0000
Message-ID: <08307881-37c2-4900-8022-5c67c2b4e1bf@oracle.com>
Date: Mon, 4 Mar 2024 12:08:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/8] virtio/virtio-pci: Handle extra notification data
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
 <20240301134330.4191007-2-jonah.palmer@oracle.com>
 <CAJaqyWd8WXtWyexk-oHxmAkgcG4pEawonqGHDhWwq1hb6+-_Og@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWd8WXtWyexk-oHxmAkgcG4pEawonqGHDhWwq1hb6+-_Og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0049.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::13) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|SJ0PR10MB5600:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c6e481b-9531-45d4-f35e-08dc3c6daea5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	rM9c8YoeR8CilU99okILWFJdPRncXjU0HPLKIQ+RIO8Z/ryvgxiKKbhCL3Il/muoxUFmvBejcIYLri1NVH2DiNRSoPOjDAYKJcxEmk0Yx72r7uM6CU7XoeW0UFVp515dN/yRqWp+7vyFoED7PTNTtpFs93H6d0pUoOkYPg28VMPmT61mU+CSipLIGb2e5vUQY4Fxu0x7yv8TEmAgYJB6fP268QDN2PshDi58wp8kXfs1OVNzSMCFJP+jeJlsZBLnIz22uXY6MGMkZUcCrEBwQ/WrHVioXRpOFRCgLJi2/Ehcw9xm7H0LeJBYpL5sw+SLxPxkuoqDe9Q4lC7Gg9ro0ctPcq8W2oBpAJEu0vmMoP+DCwo1d5CgrdSRDp8d7cASQ34/oKSzv/3kOQwxrycwA6+vjZU8TIqHFCsBbE8fMbUAJuezj+lABmA7eFqc2mZh9EHUH16n+h43MJjs1X0zNT4aYEVyW1qs5HJNm7q5PqZR28nIPUenCtWjsrIHghfQkVv++lTItMzZHmzhdlDaIQ8ocPrwunFvNttYx2g0BWv0PMCWzj6KTlEP4aDUXDNwM7RDCKajNQ2hiREQyLwp86ilXntLNLyz71Krl3idsQRjHWwF5Bz5kVnIFeLxoq7koQWfo4VzpkMf3LlBKbzBezF/bk2BjNui6u2Wemvp+K0=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZEhCSlpPR2Zxbno4OGVxMHJzU3d2M0ViK2tnVjBiSWVoQ0JHWXAyN0VRT1Jq?=
 =?utf-8?B?Yk14aXRkcGJSbXR0eFhXNG9vKzNlS1YzTkt6SFBMbDAxL2tpYjM2MUNUOWJE?=
 =?utf-8?B?cGJMcXdqY014N3JWZ1kwdXRXWjVSaUl3bHFPYi9TNS8zRlcwY3ZIWGFDcWN1?=
 =?utf-8?B?OXVyUTR1cCtEVGtEdHBCc2pCUXJyblBLWjlLVkp2ZWFrbXdvS1g5bTdiNHN6?=
 =?utf-8?B?Qytxdkg4L3VIT2FkUW5qTUI4dU84eEdPT3g1YmJveFQ1cGFERzJ0SGN1aXQy?=
 =?utf-8?B?aVErY1Bxc2xGejlRZW1ObXZBcUl4YTAxRkhGU1kyU3FaWEdERWhRY1NmWS9r?=
 =?utf-8?B?THVwaXkwNm5JU3RUUGsxT0x0RHIxRkMxYS9lM2tmQWh1eDBlUGVuNFNSaDBC?=
 =?utf-8?B?L25KaERrdVRTbndyUGZSRkZoa0k1R3VRT3JSVFBDWExja2dCUmJRMjRvWThQ?=
 =?utf-8?B?SEVjbStiQ0swZ0Z4NklzdDZqbFd3a3Q1N0NxdXNlSndhemFIN2l6NTBrbS85?=
 =?utf-8?B?eEswUXVHZjJYa2FNYjRGRU5FQjA3ZkNzdDdheURFN0d4RmhqY2tSOWxOK3pN?=
 =?utf-8?B?aUJTUUlVUWxZRWlJWVY2YUFLQ29iWEJBSDZ4SzZrZmhpb3lhZU51Y2FLM2Jk?=
 =?utf-8?B?L21mM0lSTWhSd3VzbDFsQzRLTkxKWFFadi9jbXFud0RZZFozd3dxYmE0OU5w?=
 =?utf-8?B?VkgxYzVLT3VoSWxZcy81d1hDWFBiTnpBSWtHc0lobWxFcGxwaG9wRUdIQjZ5?=
 =?utf-8?B?UjFrRnRnQnY1eG1SVVlKRzhrMWpnclhCdWRYWEQxdGM1eUNPSEhmelpGN1VZ?=
 =?utf-8?B?Nk5lNlZGdFlLY1MrMGdVQWtaaEtaVm91Nk1JMUkwYjhkaHRIVjZSRitqSzJU?=
 =?utf-8?B?VmwvVEVlNEdzeUJHWnBtTXNZUUNXNFRIL2UwaGlaN0hNT2RlV3JCV2lFMmow?=
 =?utf-8?B?YldGU3UwRWVwUjVDdFRScG5UMmNzZkxUSkNKUXRXVHVQYzcvUGh0UUxZVEN6?=
 =?utf-8?B?M1ZqaWZsYmYzZ29hL2djTnZkbm9ESEVPMWxkdFd6ck5ZQ2REdEprTVJyaFQz?=
 =?utf-8?B?dlVubFlERyt1dEdzOHJJSi95WHV5ajhTdlVkc3pUZldBbklOTWdQSnZlTjhx?=
 =?utf-8?B?U3pwZDZBTHNMZnYxR1lZakYzdjdqVGpnK0ZFdVpSdnNyV0tEQnBDcVhqZ3M3?=
 =?utf-8?B?ZE85SVcxbDB2YWx3NDZteENaZG9FZXZoanI3dnlxbEoySDJJM0x5RFdaWitj?=
 =?utf-8?B?RnBQdG0vcnk3bUdTKzB6VlF3Zk0xMVp2RTV3ZjFPLzN5Slo0cnloM1VwdUVF?=
 =?utf-8?B?dHAzZVNmcWkrWTNWU1RidXJveUZ3V2E5eXZEWkpBTkduTlMyRW1qc1JMT3Nn?=
 =?utf-8?B?YWdjcHhMTmgxNWZmZkdUWWlXOW56TFNjT0VCN1R0YW9zR09mdHFjR0JmR1Fa?=
 =?utf-8?B?ZkJDb1AxRW9nYnJsdHNNdGRaQ1puNk5tOHF2Y3pzV2lKQlQ1U2N2bjJNN2k2?=
 =?utf-8?B?VnZxYW9NaWNTU3g4ZDRLcXAvUFJsTk9XYThLUFd5V3lUZXIyWDZWZjR5NE94?=
 =?utf-8?B?TlovNTNwb0Y4Mi9KNEczaUN1YlV4MEJRUk8xbG5tVldJTCt4cDZOSjZzZzU3?=
 =?utf-8?B?bU5xK1RwNWlpVHV3M1FVMitKRDlMZmVZOUtoSTBONUlMb2FhWHI0S1FuN3p4?=
 =?utf-8?B?d3Fnbm96UHZkS0U0Q05qMXE0blBDZ29pYmNSSm5FZ0NxRFF5aFQ2Mk5hUmZ1?=
 =?utf-8?B?LzRaSjNVanM1M05uNTh0Zkx2OEJyK05uY2NzQlBGYVZBeVZmUXRYb2xiVE1r?=
 =?utf-8?B?MjkxYW14M2l4QkFNZ0JzYm1EbHZaM2l6K1dvckV4WlBvUTI0ZkRiYXdzRnZL?=
 =?utf-8?B?UzNRT0w0Z3d2eGdqT2tYRjN0ZmVVODVYcEhSTGxqUXBlYkhtL0VzWkN1VTZB?=
 =?utf-8?B?Z3VhaW93eXZsTVgwNHhXdzNTU3JxU1p6MndEMlpQbnR0QlppbTN5VlB1TWhh?=
 =?utf-8?B?REJEU3BacHNOOVpCbjdMV29JSGQ5eW9DdE1FM2RqOXY4UkNVMCt3WWZnNFNC?=
 =?utf-8?B?MWpaRis4Wm9ZZHVwRXpyOEVneEM2bXM3ME9qb1AwUEdHTXhNcFBTTjVpUWZ1?=
 =?utf-8?B?YVVQVDQ4MW5PNHMvNDRTbEtKRjFGVWVqNnU2djVUNUlkeDl1d0lNMDhTaDlp?=
 =?utf-8?Q?mIyKZfDeOUNEgNFV4HvWqsg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	PKFwQBGZJnwp35Z7PBnCZREKF9drH/CaGGupQGPaRm1MgDtCuj8zI3QrPF0gPWAaLHN8yeZ/8PX6vAGjiwQ2wvbZuUq/4NJHWTdaWSq70cUqXqjLdjnDWfxRkI2gnlgOUazyXEeJVLfrnSunP+I/Q1oHo4ARIgtRVwE+0J4/E01/kJ/9IgTRhbhnHrmMVAE5TvLV9+InvNDCNSCr+14ayJysYbaaRdT9T3jSMW16V6Yyfud7aqsRAzkS6ca1ir8La/N+egY1nmcbaOo4CKIl2Amu5jDnaqnPclKBjI+3AHcwNCHUUMldFZ+q9wlem4P3T4o+pqlfHgs3KdmUM+4TBqZw1+e0hv0UVi0C2osVJrUxvRlkvCllvzAqX5eajLLmJhDTfS9+oNArQlLTcTGX3pRiwTqNwC/AqUrhaUfJ1Hl8g9NN7shxlQfZWSSc3VF8K1v6VaOWh82xDo2Bytlph9EhQbNmIi9uZYjlHlnX84e5zqQzH9XxRaL1MqSP3EJXnbFZwAB1nO8S+JhWAnKbJOvLrXb//ElZ9TcwETjevjHge4rcYAzpiy4qdscwWf7Or6m4adbtXmhplRy0r54btJlNQ7BSqOeVREvEUo5G0kU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c6e481b-9531-45d4-f35e-08dc3c6daea5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 17:08:16.1912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pz/l2cnDEY10Y5MoDFNywBMyUJylWAePJrbiLNy/3Xu4LB2Y0r/xyzYrdU/lqF54xjsR1dnc8SkEQI7o1XqJkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5600
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-04_13,2024-03-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403040132
X-Proofpoint-GUID: wTEY1Yecc4sl40LkDH39qVp1lh3v6UPJ
X-Proofpoint-ORIG-GUID: wTEY1Yecc4sl40LkDH39qVp1lh3v6UPJ



On 3/1/24 2:55 PM, Eugenio Perez Martin wrote:
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
> 
> Sorry I sent the previous mail too fast :).
> 
> i should also be checked against VIRTIO_QUEUE_MAX and vq->vring.desc
> before continuing this function. Otherwise is an out of bound access.

Missed this, thank you. I will add these checks in!

> 
>> +
>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>> +        vq->last_avail_wrap_counter = (data >> 31) & 0x1;
>> +        vq->last_avail_idx = (data >> 16) & 0x7FFF;
>> +    } else {
>> +        vq->last_avail_idx = (data >> 16) & 0xFFFF;
>> +    }
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
