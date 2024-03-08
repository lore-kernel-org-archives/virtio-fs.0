Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80608C1A
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 17:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709919932; cv=fail; b=GVutZ4LpW9DnPLnSQy2c9xD6/2zuibKZuaEAPiIEyADmzVDzs1+YBOCDvSTYT2fQcTdBvdH18MGunDo4cpecGJhkzkiOX7QQUyV2cHfQ8angP3Z+iA0WXxl6YM9VLVa16MiQVMFMKWjuUrJ1ES/Rpre1RXSTm8DLol/5Hrwhync=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709919932; c=relaxed/simple;
	bh=RNQKMrTtmtVJEFceGWDC/XTEMAsTErKvJwwaNQmYDZI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QGg52qBPVyVuTqW9DIiS5wzFmspY1jCuzj8K2PdBybnk9gxDkIzMnvYzhR80tux0DF7M0cp6VhhLFR8NhGN2QyCKJkqSdQCDDYV0CQP8QvYB+v+Q41G2N++PWvAYw/VSoWte02ki5vImXZn/1kGWbv10B/tl838z4mo2VwGplS8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kfxeRfOR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=COcilv7F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kfxeRfOR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="COcilv7F"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428DTMoj027339;
	Fri, 8 Mar 2024 17:45:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=MjEjyGxf1CbfBNNsd4RYGdpDhEL8SaojOZoGLgh0xW4=;
 b=kfxeRfORHUtqYRvHaZ1ZIqvMaFSqizO7Oc7rnLJviQyanQqky6wLek0mQ0bCwcQGuc/j
 6dwzaBZVb+drNll87CwvJPo6pkbGwsclMT4po2cKRtS7m7I3pp06vZ2ZLxlYIdxxtPn7
 oi0COOK7Tv8hZzTQNPguKfPgHM+CL/7okNidMcslpT1el9PBJTbGST4OyGgKx9eTklMw
 obHfCa/wiE1Ve9ba9AO/RQyZGjq1aL6bY3XefVkp5kqGG3Bab93kQQ/RJTd6/LjritRh
 0bN091wkoNpuefvzefa0YSd3kwzm93NXlfXDoi3WDE7aMDeeh2IIfmcloF0vw4908Gfi 6A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktq2ekpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 17:45:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428GjUlt016040;
	Fri, 8 Mar 2024 17:45:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjd5jwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 17:45:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QiqKk9FvEkGUHol7LfyYfplNy50ETGkgTxjCja5UBJ8IGiYuFYGtwQbV+M1aNFPe1BlSvJ58/OR/TDXEUazOW1e0/d1YKaZsy0vmRjMzD8VlE1OkS3uu025w9sk/Fco4QiFU4mhmzIAD1O1NhN0esdayyu3ua5cR9p3A/hJsTDSaYMKCu6fKpfsX3dNO1jINcK9L9XooQBNphSbd1WYvHgI7NNxRBWPM9HCWosa5KUa066cPQtXzLU68HK2QmnHrcajEFTMmf4pkFz/225Vyg6QrjbB9fcGF9LJWmMnIdOX8Fsm1sD8axk9RzGvJ4ooknGdL85vz8vsRXzVdjrrLmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MjEjyGxf1CbfBNNsd4RYGdpDhEL8SaojOZoGLgh0xW4=;
 b=AVSwpBQDQgzWAbdqAc+3XAtUDmEOGHXqwUYQ273LjBhxaNn/cMGJ0KYxtWKFaLOWey9p7wxos4OmoZqnuA7iGsMEFsruAy7NKLq13Pl3lc4t2GjVOuBUPwtiCJJKHGGRkml6cmKfWaBfXsW7pRIUM3mI6aA/HillRYAbvqQd4WZIVXIPTR51E/DqMIDSJNZazArbl9pm26m14VHDgxlNzoYwa49QS63IjGW8gueJq7QrqaI42rCvMInKx9P7VeexX2MvGQgkptF9/EzcyxHgL/3AeNkiQmbFQCIasOZWTKz5UiEYLdW4pAFU8ReQEZ4PKU074A3wG938FWnsPs/kvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MjEjyGxf1CbfBNNsd4RYGdpDhEL8SaojOZoGLgh0xW4=;
 b=COcilv7FuHy09/nMRSYd5YDzLrli6/hI2S+SHEnChD008xZamqGK+eoAmrB/gpA1aA8Vkog5SrG3SBm351ESSOFOTSLs1gfWzocJsPh8ro8YCWQTh4nnq9QHW9abcoAt/SActCEPNgNBU5qNwyckWdB29cqdfSLIrnSDZbPy/Tk=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.28; Fri, 8 Mar
 2024 17:45:18 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7362.024; Fri, 8 Mar 2024
 17:45:18 +0000
Message-ID: <bf6e9625-0fc3-4bbb-9e36-fe6571aca8cb@oracle.com>
Date: Fri, 8 Mar 2024 12:45:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/8] virtio-pci: Lock ioeventfd state with
 VIRTIO_F_NOTIFICATION_DATA
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: qemu-devel@nongnu.org, jasowang@redhat.com, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
        hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        farman@linux.ibm.com, thuth@redhat.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, cohuck@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, qemu-s390x@nongnu.org,
        virtio-fs@lists.linux.dev
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <20240304194612.611660-3-jonah.palmer@oracle.com>
 <20240308115951-mutt-send-email-mst@kernel.org>
 <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcRDjSXbgxMHbdPy_YO4boQthu_4_9zKYX3S5t-G1ju2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH7PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:510:174::16) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|SJ0PR10MB5741:EE_
X-MS-Office365-Filtering-Correlation-Id: ab74c5d2-6aca-4dfb-43e3-08dc3f9784a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YIganbVkY9C3w3p1Gcz1I9iaPotGfK257Eq2+NJDR8piTKg2Y4T6zL+qd2qkcdlxIFHDJT5XnT+TQDBA0XEpSg1Ffs/Fu2K6dRskPBCVJFdLvspM6jssMeEl5C1YnMXlRTGv7s6zJupF1Ub7PXMTRd1GHmnrXvGDnG0D1w13F2RgdnC1uEwDFQW2+IREJabAO+MgFYhIacgQYWzLXs6YR2+0MC7SxrTNmIsE96GdH+Uyff3m6TXtq7h2KgHhamGWZv946Jw+lP8cWN2RnwEa+CiY03v2mfyjS+Ah1IaJjwt2k+M8mVWZyJcBJKw3gOQ+MFD7pZYMRSQOHv/Sto748m9R8InWIwyghMjts1IFfKQCeiGSXqxpoUM0RCRe+JmWuNf9xWhxoTkbilyntiBOmNRPRP7JSlQ5+4UEnHvTPuJoNOnB66jgd23wa638r5MjdN6AAHP6hqvob65wN5iTBzCbZP31D3NX2YAh9xo7GsgKwS4dlsxXR7+oq7BYXmKRluL737jn3uSNrJrtvCpyNcBvliFr1je9Fiy47NnktZdNelxVinKXTmHTTYsU3grmEPzqtfrxtwqTJTGGTbKFmDXCjAe2dkAw5uvNmVWM80M=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Z0NVSnVRWDNxejkvYlh1V3NFa1lxTW1qZkl6ZWYxVXpEblRDKzE2ejExSGs3?=
 =?utf-8?B?M0JCN2RPUnJON1p4Sy9PV0Y0SHFxVGxOTlpkbE9kWWZuNXBVdExUdU95STdH?=
 =?utf-8?B?dlZKVGwzYlRjRVZMcUk3a3UrZVY5TmtYNUl3WWY3Y1RCL09GandwdmJTanh2?=
 =?utf-8?B?b21LejE3RzRUSGp6MWtCclNJVGlWM1RCU1c0MW42UlkvQ3BBYkQyUExhSGtM?=
 =?utf-8?B?Y0F0YXhkSlR0MnF5Zjk2NzgzS1hlbXJLamcvbmRIZGEvaUdqZU9CTmFvbXk4?=
 =?utf-8?B?aW9iRWFJaDdEVjYrblVIWWVqWXZGS253OEp6ZzdiOVdSMWtIaXBZNVVWNk54?=
 =?utf-8?B?MUJSaXZWNWRydnhobFk2b25McW91bmtYcHpSN1p0RDBrOGZQMlh2aUY0bm1h?=
 =?utf-8?B?TEt1ejU5ZjJSUlZvMFZhUXNFMmdScUdMNDZQcEp0Qi9mUCtFZys5OU9aOVVj?=
 =?utf-8?B?YSt1NmhxbkhLWS9VVllxOENIRDlQdzhNZkM4ZU90SGpMV2RsakxlMnRlekNF?=
 =?utf-8?B?U1ZiZVI3dXcwM0p1UERjWVpqNE9maGVDQ3JZK0x5eldhVHdOaStaVFM4azBW?=
 =?utf-8?B?OFcyWVVWTUM1WjgzTW42MVJKejA1V2JFUnQrM0kvL2xGV3hIbnJidno4S1gx?=
 =?utf-8?B?Zi9ReUsrYzBvNmx2aDgxbjhnNmJ6M2xjS3BhcUMxTkw1SUtRUDE1b2VuZTU0?=
 =?utf-8?B?VnV3K3Azajk0SEErazVrQW80ZDBwandwRnU2eW4vNjdlUjZGM2RsTFA1V1FL?=
 =?utf-8?B?WlJYcjJMUldpdVRLNGZtRHJHM2JhWVl6MHJJSTh0RlZFd25CZC9HVlBVbjU3?=
 =?utf-8?B?dC9HQXhpck00cU10K1JML3E3S1RLOGxHa1FKb2tjV0tkeFdtdGJHZ2h6TS9y?=
 =?utf-8?B?eG5CNy8wUHNLVTBjeFNCNDRqSVVDYUh4NTdiTGlRVTZYalQwRXkva2hkaENP?=
 =?utf-8?B?ak9seEdRQnZhR3Y3ZjlxWVYra24yNElDM3RCM3lGalBxTW5ORGZwWDRIeDJa?=
 =?utf-8?B?bm5VMFBhaVFnQ3JNbkdxbCtGRlE1MFAzUDZ1M3pQTlBYQWZ2aGg1MlFLN0FU?=
 =?utf-8?B?UzJ3YUtWa0Z3UHlsTlVuUkEzbFpkdnpBZFpkK0oxQS9sQ2VQWjY1RjVObTdJ?=
 =?utf-8?B?OU41Mzd3c2p1VEtTUmFpZDh6b0h5N3hOSDl0Ukg0NE5DVUwvUktDZmJQdE41?=
 =?utf-8?B?RXR5NzM1dThkOVJ2NmlsM3RpaGlVclB5VFJWS1ZvelpGMmx2ajk0SjA4Tkgx?=
 =?utf-8?B?M2M0ekw3blVzeHpuRkVGTitPVGV1bWZmRmdYMGd2TFlHTnhYNUF4RWd0TTZO?=
 =?utf-8?B?YTFOSHpMR1UvNTM2dVdidjlrNW5McVFZZmRKcWRRaUJyRmJTZDVkZ2tQWHo4?=
 =?utf-8?B?azE2akMrdUduNXRSNHFjUm85NGFLQlhoZHU0S0d1dWloczBVeHZMbVVIMVNw?=
 =?utf-8?B?WlZ0UXJlbkZUWEZmUGFTOUFKMi9RVHZXUDduZUtIelI5R2oyNXFLS0hpaTF5?=
 =?utf-8?B?N0RzcUFYMVo2dy91dHc3aGNmNWF0WFdreGdVd0gxcnhNa2MydFlINmtKRzVK?=
 =?utf-8?B?Z1cyQS8xRkgzbDcxTW4yem9ZYWEvN1NXZ3pZYm5vc0xPcldTL3hWZFRvL0Zj?=
 =?utf-8?B?UFBTQlh5bFFUWG5BUlhEQVdFNG04RWNwWkIrcGsrVjgxYllNbEpTZVNHL3RF?=
 =?utf-8?B?M29xcnIrNFQ2TllQVUp5SVFEVXBMT1VtS3NlMFBqRjJxbktVNVJIamdlbDNR?=
 =?utf-8?B?LzRiWTdCNGpkL3hqL0VUQTJvUjAzNzZocjNYYnB4L1dnekN2c3JyNjg3UmJB?=
 =?utf-8?B?R0NQVTFKRDNhNHRHSEc1RHBWR2FJaG5LK0VtbGwxbTJlUGdWdHB0dEpmUFNp?=
 =?utf-8?B?U1UvRWg3MS92VE9JbHpNVG5OOG12Sm1JelNyQ1o2VndidkVDR2U3WExFaEkx?=
 =?utf-8?B?QWswMTBNT0xrR3JOOEg2WVYvd2xTUlZEV1pXRUl0RGR3Y1pVZ1RKNFd4Y0s5?=
 =?utf-8?B?Q3hBTmJ0QWxJL3E5TTh4b2R5eW5Dc3BrNXQrQkV2YnF5enFqOUwxNUlqVVpX?=
 =?utf-8?B?aEcrdkZWdGlTYTNFWXFmcGlTVTFFTGV6UFk0R3A1anIxM21tMm5JOGJ5VjY3?=
 =?utf-8?B?akMybU1YY0w2akx1R0hUUVhLbXloYm4vWGxuN3h0M1NFa3ozNWV2MUQ1VmpU?=
 =?utf-8?Q?EV8potxs+1Z5CubbMGM/uyo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	XaqTNV4EqOfTGPzxZCfgCNxleQaDEirAWpZoPqFZGJWZ5wzlF1tvIv3FP2v71TCcC15BgBUN49lKzzzrrfaCu84Cy7fdTiZ79Fro1LhyIEFIUjKQ38hmgrsqSoCkcpaOTrU5uv6YBi2NBf6ZYXBfFhX8z5CcEOLGNtOVUuZ61+uMWIaW5YVFm8n9KtKmIvgt2TpNEu43oEV5nfDOOQyawuMzTpo+FVsPo+TP5JLKXXIiCYsY6CfAUmxUT47SMeTDF/o0Uzj9x6FcaE4FrIoa6h6PgdgPoA7BtOq6AI+uHH2rxJAyHSF6OFaOTrlUS9c8nrF6poeIdFp9dr754p3EmWaIIDIly54HcMBS+9FUink9OO8gvzjDya3wAD5mD3krNddnHZRZ4W4CyWMuW+42E3ymz+6onRg7W8suzncn7LSwsogyhq+edwoceEoc8+KwDFHhrHsCIPNuyBgEUbFAOEP2O3GFFQ8x90TdUeqbIBXBjxAsURaNldkmQllSa+U0AT+oiuYhdV8cWyASsqIH/C3w/tZBPVl2rV6/+7+DxNO7txKeQgltR4vSuBDWT66aHUiY0RqIgW+fb3SXx9pWPvziZ0Ks3bzir8RnTdTThnY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab74c5d2-6aca-4dfb-43e3-08dc3f9784a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 17:45:17.9730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SB2ZvkzZeUBJ8yYGRRKIly5+sH9vDX9aQ/wkdh+HjXbhb5uM9uQROnA7JE3dv+f1xIOZESxyBS/o4P7p/mV6Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5741
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080141
X-Proofpoint-GUID: jPcsCar6M2SKpUa_bT-tELAsbTJO7ypS
X-Proofpoint-ORIG-GUID: jPcsCar6M2SKpUa_bT-tELAsbTJO7ypS



On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
> On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com> 
> wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer 
> wrote: > > Prevent ioeventfd from being enabled/disabled when a 
> virtio-pci > > device
> ZjQcmQRYFpfptBannerStart
> This Message Is From an External Sender
> This message came from outside your organization.
> Report Suspicious
> <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
> ZjQcmQRYFpfptBannerEnd
> 
> On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
>> > Prevent ioeventfd from being enabled/disabled when a virtio-pci
>> > device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
>> > feature.
>> >
>> > Due to ioeventfd not being able to carry the extra data associated with
>> > this feature, the ioeventfd should be left in a disabled state for
>> > emulated virtio-pci devices using this feature.
>> >
>> > Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>> > Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>
>> I thought hard about this. I propose that for now,
>> instead of disabling ioevetfd silently we error out unless
>> user disabled it for us.
>> WDYT?
>>
> 
> Yes, error is a better plan than silently disabling it. In the
> (unlikely?) case we are able to make notification data work with
> eventfd in the future, it makes the change more evident.
> 

Will do in v2. I assume we'll also make this the case for virtio-mmio 
and virtio-ccw?

>>
>> > ---
>> >  hw/virtio/virtio-pci.c | 6 ++++--
>> >  1 file changed, 4 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>> > index d12edc567f..287b8f7720 100644
>> > --- a/hw/virtio/virtio-pci.c
>> > +++ b/hw/virtio/virtio-pci.c
>> > @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>> >          }
>> >          break;
>> >      case VIRTIO_PCI_STATUS:
>> > -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
>> > +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>> > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>> >              virtio_pci_stop_ioeventfd(proxy);
>> >          }
>> >
>> >          virtio_set_status(vdev, val & 0xFF);
>> >
>> > -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
>> > +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>> > +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>> >              virtio_pci_start_ioeventfd(proxy);
>> >          }
>> >
>> > --
>> > 2.39.3
>>
> 
