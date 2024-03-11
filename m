Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2764776F
	for <virtio-fs@lists.linux.dev>; Mon, 11 Mar 2024 14:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168827; cv=fail; b=X1Hkh9wqypEOysbxztajEtJYe2WGUiglTj8tBmRFrkNiJf46HhV4lgabxNuuqJWidZzBxdVyWDAgEw0Hf//50NsiEEnUemgWrfW3YoKRjgrjiY84G2lur9+3FxLrtWOakCYJCk7Cgsp3h7yK2wm6tsfiLFU19gzXQTzhdWvZkEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168827; c=relaxed/simple;
	bh=S59GY5vRI4UXsF9tZJgbpw5frZttHY2hTai9nfOMaYY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RnmSnbma4/TMgy7O2Awq1rR/q5N4jWblGtcSTstBVyyBacBlyiESGE/iR1Bms/FsN93RD19RfyJE0sy+/ItPd4JQtIcsEzW+j0t7IXekmgBYPlD4yH5y05DxxQK3pzuE+CmQJPgNlwwu+PFIL90E4xD0EdPXuDkFsdLHLerVFmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hUCUASZx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=DAR6/AS4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hUCUASZx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="DAR6/AS4"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42BB4da3018123;
	Mon, 11 Mar 2024 14:53:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=yTe4LWF5sgl4KxYKbBT0NSqrhM8+TjWSz6p+V9TBoKM=;
 b=hUCUASZxjRxqRMaQFl1okYiE35f4K4VhuJffz2+wwsUFzxG5/iYpidP9y46LEKKZfILl
 1uB3bYYOxC/mx2z64C+mfjuj3EuoNa8GIsHg9o9DXF75FxJzihrnNeRVhaDqEgQ7aJAj
 haprKpmHkNcy3J4c6j7NjfjgZkBUn8CyQKy2aSDoeMdMXW8gCT3F0qiJ/PFlpJFF09dm
 WjieuToi/EV4Q4DJmov4lHolRWnXVIyD9k3zqaPx6YCI/VCk1QTCuiH4eIgrluD7+gzd
 8Sf58J4xVI5GMsPaj579+uU+ni74D8HvDUEEOoWJc8UOa0TpEjXBfilQx1lKQS5L+Yti xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrgauke5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 14:53:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42BEpUOc019715;
	Mon, 11 Mar 2024 14:53:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre75uv91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Mar 2024 14:53:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJfu6Fo2FGCoFMPJDiM1XDNSVIHLAQtAmkU+mF4LwySthSZrpOKaR9Ha4lKzmFSdglJZ532TvLxttWLWTkVcQ+a4aIVN3ibw4RgvFjKD+QB5AQSUAsXsR3hxGf7CmiksSVjyw611382OZld318oR59UPJoKoiiCz1IpgMPu8y1dPsnWnXDlh6ORCEh68c9S5M77hD+ERrDRTSLTWjOnntRHVt62J0zel+ybRn+7gHexYgxF6di/jF+5tv+MG2bBKLXDxHUgora1UHGKMblQEiqZMp4XjH/JOkuu/s+7Zjz/bhjJHjkRdFqpLtC2I+rh7DZaqsOdWs6FdLRf4THuZoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTe4LWF5sgl4KxYKbBT0NSqrhM8+TjWSz6p+V9TBoKM=;
 b=dxZuOelFeTTx1EsoqbPvl2lk/bwYxn1jg+w1yBx3DtSo/JLZKqBfHAujs/AtRy+W9v/aF5N5xJ9T2qwe6iRb/SeLMhKTdQoadC8bZvedzcZZRA5oWs+QT2FmiSBEAFSCi7+G8n7AnM4llw5+l5Lf2BERyhoJYYjrZ8R5ZPPKJm2icJs/i8pssjaSm1xZiKCgAYcieAxh0CoicZc9fVPX00p6z52OVc8/L8gee5Xq1gj91EiAdBZfDPJz+hmPK8eFuvKHBWI9ppksMg0FvosiesJJgdVBOIzBBKNYpTjELrLzvj6uAYCtLDISkT8qKtHHrdnGiGO6QZhhft3Wuf+n2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTe4LWF5sgl4KxYKbBT0NSqrhM8+TjWSz6p+V9TBoKM=;
 b=DAR6/AS4EZLyJBU9QUryPiXjdGcB1CxHDvdcHvcZYkR8cWNGQmJqJKMyFF5x4O/JGcenVWAoy9+CP20MZ4U4S0t7vMyxXF+k6E9l/+KlALvXujM8A5TXarSftSEPu3Yr9ju0cU1hcIenSeuZopp/PlCui7GABxaCUYx3iA9XVTo=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH7PR10MB6673.namprd10.prod.outlook.com (2603:10b6:510:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.34; Mon, 11 Mar
 2024 14:53:30 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7362.035; Mon, 11 Mar 2024
 14:53:30 +0000
Message-ID: <fc09c190-ff37-47a0-96a2-6b364e04d334@oracle.com>
Date: Mon, 11 Mar 2024 10:53:25 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/8] virtio-pci: Lock ioeventfd state with
 VIRTIO_F_NOTIFICATION_DATA
Content-Language: en-US
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, qemu-devel@nongnu.org,
        jasowang@redhat.com, si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
 <20240308115951-mutt-send-email-mst@kernel.org>
 <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
 <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
 <20240308141907-mutt-send-email-mst@kernel.org>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <20240308141907-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0034.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::9) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH7PR10MB6673:EE_
X-MS-Office365-Filtering-Correlation-Id: af9c2a7e-a399-4427-4111-08dc41db03fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qs8dlcIsWjsSsIR5xSxmtI87n55Vf+51JqmbBIvKZVd2TlRj0OiJdbp7YK4kU6gzicD+LLhHm+PUkzsv36a3M9ocl9aMURChQrCQkMgfKmHj09TpUE/+9DM2efTwmSI19Ureb3tdsWss1LYwpFk3kPaHNnNJn7V0SSRst0kPvBidFpKJgX0e1MvqdTKkGiomXjNlmtFDhEavaNJ7kXGyo6mqfinD8+/irOp22UfOyHt/Sq011pDw6o7lIHnRqqQmZRVS8cC/iUfd+EAbKjMvlbitBt4ec8ifl2On7/68XpR2h8TE0PKGRAAro6CB/4xSM3FWwPDvok7Yn2EB82Gqab+9zesRCNFw/9BLCXgTR9kUOk2w3emxhCqbxS/S731MbXkfGipAwUh3qHkERvQcuep7DpmL2Ji3xAw/122llef7OSX1LG43tBzzrVCyqq16enlQ0tQZxXiasLBDMtrSeaYi5LtoHrJSLIM6IW9YgZlkzP4xj1E8wybBE8g5jv49oa22j5Y3dxe80q1P8jB0mvykSU425RGp9U/jWY/2A29RZXiapkMK5x/B3S79fLfxeorruI/ML6Bzld9cgigGWFYo0PvlupAN3Y4/9jZANl4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bkN0QTh1Qkd6ZjF4azFMZzIzM3pxVG55VGtZVlVZRy9jUEZ1SEg2dW9ubys0?=
 =?utf-8?B?YnpzQnpiclAzMEtTR04vQWdESjFjdHFvY2I5VUZMTjFybEF6eENGcWZ6T3pK?=
 =?utf-8?B?OVYwMUtxanFYVGkzNUZNTFRYZWpXUEltczkxbnJzZkxpdnZHRGIzNVluemR1?=
 =?utf-8?B?T3N2VE45M1l2cmQwSGFNampQSFhZRTlBbCtrTUZ0N3NhYjk1Rmg1WWZjMUlj?=
 =?utf-8?B?NlEvTnVzNVhxOWluV2NHV0RFa1NJcXBKYTcwOEpXdHRlNm04OENCOUR2UEJD?=
 =?utf-8?B?dDk2S3oyekE5bjBxMjJ6dmJkMi9rRWNQQlBYLzRhUjhCaHU5R3lqYk1Ob3pm?=
 =?utf-8?B?a21vVkp3WFJTcGlxZ214SXZ6MG40aFJQdFJZZkpodHRncmZ1SFEva3llOTZw?=
 =?utf-8?B?WTV0TUNBL25xODZ4Q0NObkJSZVkxMU5sM3NVWHk2dEtySGYxUmtFY3RINERH?=
 =?utf-8?B?Wk1QUllRYWpONElQUXUrRGZtUk1PQ0tFTC9yVXdNVmhycFZEZ3pJWUQxSjM4?=
 =?utf-8?B?SXpjOFl4TnhIMEhlOEIvSHNYUnQ4NkkxNTdBd2ZqamFUTjFWY1VCeTdRUDRp?=
 =?utf-8?B?bE0yUEpkQXVnZ2pBNXluV1AvUXRtS3dPMHY3Ukc4RjBHSklmRUVvRFdlL2ph?=
 =?utf-8?B?WUxtKzdEdDJVYWsrQm1JZC82a2ZhL1pleWVqd3FQMGIxcmg2T3p0QXBIL1ZT?=
 =?utf-8?B?alJnTCtFbzJhYWJBNTFxZnh2SnZ6aHg5YTU2bEd5MnNTZmY4UmcrVGx3MGpX?=
 =?utf-8?B?SGlLcGdwR0lJcHBLVWpPU3lUUFFENXdwU0wvdHBFdE1kekFLNGdKd3ovY1E2?=
 =?utf-8?B?dW16cGZDUWdUd25mTzc0cU5Nc040aHlnUENPVjZlOW5Dazd0L1pXSUp2SnQ4?=
 =?utf-8?B?MVhMSWZnRk1RU25xSGxPZmpEdUR1UDJBS1lCTWZLNDZOT1FlekpOZ3ovVHZN?=
 =?utf-8?B?QlUzU0NpRWY5UEpwRWxMbGhRTXpLU29CTlNqRHlMVkN4Ni9TUkx4S2JYdmsy?=
 =?utf-8?B?OUhoNUU2UGh6SElKTHdRRU8xMUZLcmc1bVEySGI5d2x0Z0x6dDA3Z3NBbW9P?=
 =?utf-8?B?NTVWZWxSYUkwUzZobXpaV3VIMmdidC9FUXJxRjREcEQ2VUhQT3FCTkJ5UElG?=
 =?utf-8?B?L0FaTUZKUHhuOXdKOWtmN2g0K3JjbHdqNFNueThzY1QwcmNLdFZZcktINEh2?=
 =?utf-8?B?Q2FVa1JYRncram1FKzVJb2NGdTh3VC9VVWJNMndLeFBNZzJnajhQclFsdThX?=
 =?utf-8?B?WHVjcGNmaVlhQk1WSEhpRm5GMVJGL1VtTWJWL21UcVdsZjRPbTZVVDJMcEF3?=
 =?utf-8?B?RStvWmRwK20rUVdicW4ySUhiNzRLc0RDOUN0OGFHUkZIYTJ3YVJZSU5idGVn?=
 =?utf-8?B?bFpaSFhCZkRDR1FjTHVzNVVqQkVWOGRtS2ZsS0tsN1h5TWRneklLaEJRNEt1?=
 =?utf-8?B?QXo0WDVoQ0Z3VVNGcEZhWDVndE1qTEhiR1R0N3huUDVwOHBXSngxa1lST1pS?=
 =?utf-8?B?Y3Y4ME5hTGhWYlJWRjk1a3dyZml2VThwdkpiaHh6dXUycTA0T1p1Mlh6elFC?=
 =?utf-8?B?c3dXUXNkMVNlRllqUEcrQWtCZnZ3N3hGRnF6dHVxb1BvaWV6NzdZbkNWV084?=
 =?utf-8?B?UGpObk5vWXRqVGRnUlpBWGlQZ281aWNyZUptUnE4blZyK05hUmVrL01uNC9a?=
 =?utf-8?B?bEJwTHZpSnJoMzBQdzhQL0dvOWM1dVhtK1ZHU1lKNnNNUzJVc29kak5ZcVdJ?=
 =?utf-8?B?Z1BMNXY3K3VoQjJZaU1RRVRTWHZtTzJlWmRhcEF2VFJnRk9KMnJXY3VtNkpV?=
 =?utf-8?B?K0kyZEx3UkpSeldPam5mMklGNlNBc21CUmREWFpicW9XMjk3amNic3kzV2dX?=
 =?utf-8?B?VjNtU0NFcFNYSDI0ZDF6SU1saDVVYUFyOFdhM05NQi9NRi9HSEVuK1FrVVpq?=
 =?utf-8?B?b0lwVmthbDlRSklnRWhhTVRrdzkwcjNUTDIraTNKNmhjenUrS0I4RmhpWlQ5?=
 =?utf-8?B?NmoxTXJTdEgxY25odjIyNVE3L0MwWnpNb1N6cnlERGNtdnRhMGFybDdidTBZ?=
 =?utf-8?B?UlROR2NFb2Jjb3VEZkE1ZnVnbVNqdXlPWVFYeWZZbXRPTXJXcGRnU25DeVM2?=
 =?utf-8?B?TUkxdlhNc05tS2hwY3RpcGxidkFnY2hob1Myc2FlQkRONDhvS0luRGNkWEE3?=
 =?utf-8?Q?jqODFEPOtBbwu+OVe3t4Ffw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Wrm4sBkCfAEG2RXACRTfwMvRDV6TyOufX/Okgu1GM3IM1o2xg7+3EXoGZw3dqhRpwjdQQfDwfEKzAo+xYgPiAkMOe8ZhciYsB08GtEGPqA9ZfhRgiv7Ausmq92sqn5yDIrpydzkrgp3YNYlvKj/nEYY+s1vcb/OC98bZe91I7U5faKfYh8Ao3ATWvy8qJvdQmvCi4lVRCHridGTfh0+Ga8z3bE/EgLaWr21iYLKnKx1RspM/CdU+5DkhNi0ZUOJ4+H+vM71qdpLBpPkT4lcovuotsTFwJABEecV80mOTltYxBo7VvocBxdyStcIS4pG+PURREPS8XKnSAAIYVF/lQFPYQZ3uQ5sef89z7atbuk7xnMmVvzfN5eQeuSnDnhu3E3rSUXu6Azgq48lqZRShgmwSbFaH5xvNaqhp8tzRmaqDZF2tZVkju/W9ZQ3fMrp/hJAPY1YNDRGZXihK2KGKx/iE9GYrqkdUVydr7bs+utDG7ggppWVH/GyR4/tvJiXLt1EkJbtNea/VbajS/oF1V2R1qXJKsQkTJ4AtYq98CDj7lyJJWS4HbOqmixrx7Mm5XqAHzeY7hBi27/wHCYHKc/Xoh6thQwXtr4fDCUt/0Dk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af9c2a7e-a399-4427-4111-08dc41db03fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2024 14:53:30.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lOqq0eU73KxrkJ1gqV3J5ePxY7Ay2o4r4T3hcVF6Bc0SiIZgKSS4NlXaM4L+K3FLjbqbJTvCDsGXk546yoaBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6673
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-11_10,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2403110113
X-Proofpoint-GUID: o1Ru_zn5P4iVXPxMGsHbjyFtmvJPdl0y
X-Proofpoint-ORIG-GUID: o1Ru_zn5P4iVXPxMGsHbjyFtmvJPdl0y



On 3/8/24 2:19 PM, Michael S. Tsirkin wrote:
> On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
>>
>>
>> On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
>>> On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
>>> wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
>>> wrote: > > Prevent ioeventfd from being enabled/disabled when a
>>> virtio-pci > > device
>>> ZjQcmQRYFpfptBannerStart
>>> This Message Is From an External Sender
>>> This message came from outside your organization.
>>> Report Suspicious
>>> <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
>>> ZjQcmQRYFpfptBannerEnd
>>>
>>> On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>
>>>> On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
>>>>> Prevent ioeventfd from being enabled/disabled when a virtio-pci
>>>>> device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
>>>>> feature.
>>>>>
>>>>> Due to ioeventfd not being able to carry the extra data associated with
>>>>> this feature, the ioeventfd should be left in a disabled state for
>>>>> emulated virtio-pci devices using this feature.
>>>>>
>>>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>
>>>> I thought hard about this. I propose that for now,
>>>> instead of disabling ioevetfd silently we error out unless
>>>> user disabled it for us.
>>>> WDYT?
>>>>
>>>
>>> Yes, error is a better plan than silently disabling it. In the
>>> (unlikely?) case we are able to make notification data work with
>>> eventfd in the future, it makes the change more evident.
>>>
>>
>> Will do in v2. I assume we'll also make this the case for virtio-mmio and
>> virtio-ccw?
> 
> Guess so. Pls note freeze is imminent.

Got it. Also, would you mind elaborating a bit more on "error out"? E.g. 
do we want to prevent the Qemu from starting at all if a device is 
attempting to use both VIRTIO_F_NOTIFICATION_DATA and ioeventfd? Or do 
you mean something like still keep ioeventfd disabled but also log an 
error message unless it was explicitly disabled by the user?

>>>>
>>>>> ---
>>>>>   hw/virtio/virtio-pci.c | 6 ++++--
>>>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>>> index d12edc567f..287b8f7720 100644
>>>>> --- a/hw/virtio/virtio-pci.c
>>>>> +++ b/hw/virtio/virtio-pci.c
>>>>> @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>>           }
>>>>>           break;
>>>>>       case VIRTIO_PCI_STATUS:
>>>>> -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>>> +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>               virtio_pci_stop_ioeventfd(proxy);
>>>>>           }
>>>>>
>>>>>           virtio_set_status(vdev, val & 0xFF);
>>>>>
>>>>> -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
>>>>> +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>               virtio_pci_start_ioeventfd(proxy);
>>>>>           }
>>>>>
>>>>> --
>>>>> 2.39.3
>>>>
>>>
> 
