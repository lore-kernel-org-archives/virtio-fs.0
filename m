Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A25C131E32
	for <virtio-fs@lists.linux.dev>; Mon, 25 Mar 2024 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711386519; cv=fail; b=Dz1upsDLdMfm1N9H/5l4/fKWsh3/cL1pJ0rH65E+1HkQyJvmuJX1OJhpFMABhNXPj+vS5diidULTaNZYtNgzryM5IBsO1Oo8MAFpMjGCj+Kd3rzMnlrlGiT2dzognCbD8Yih7vfqeSP7lI1rFvCQ+w3y0yfw83xvQrwWU3OhoAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711386519; c=relaxed/simple;
	bh=H/Zv9eVQn7y+L2LnyYKMCekQS2vEKb2etNJ0ae61O2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CGySOCn17aMzuZimoFCMjiCigqgzJWuUzmCNz5AP6HNzBSWhGzuxPRfgckxANEyE2zKqy1w3+0az5oIECvW/J6Ig8sQ/DgwZlm9+K/FtZCyzfF5HMWzxTSC2K39iG5/hSSbElxw5CVmmyw/ViueGHGaWA/aaht2JgwvKd9NY1yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=grFW6g/U; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Q0p34SBV; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="grFW6g/U";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Q0p34SBV"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42PBtw8v002744;
	Mon, 25 Mar 2024 17:08:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=I/w66yf7XZeXGafram8B2dJU77uTTJInb4t+KDEhkd0=;
 b=grFW6g/UDNXMn9fYvb02rIZsHxa7cJMmU0wwSoTVK9XZyAYGuQNUT7Wc/pAIvJTndZBq
 X9JX27K6Qx1WKQ9Fl1B12Qw4K/0Iv6Nth5s9IADx7og/rP9NN3Mh3J2g5VVrvS2Zc6be
 dFd3w+/YuBk+jP9OF+KrYGghN0tTF2rPWZcCcvkY4MnzDThq7bmc0KDgeNNGsv8GfJg1
 hqyCz9lxX6gSPzqLoGpi0aM73JqXqOiYuXbkepJEePrT1thXU8HsjXzrzpS4t5kGxqBW
 T1rB0lLsFGbyBSYHpJHl9rnTRLVDM1NcmcrEc+8VW931R9/5rZbwqsVidG8gocuQHc/P aQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x2s9gsn9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 17:08:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42PGp9K3006856;
	Mon, 25 Mar 2024 17:08:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhc2fgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Mar 2024 17:08:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdkqIQAZDWSQsuZqIshCfuj5SH3k/b1cIY6zUK0G3eLDhACkrntK0bBHpV6LAf35H1ByeZGwMz+PqgVZmnbQ9hOtzbFfK1U5WlMzNlVFHoKPDU+jFoHfm0YDnLnxunsFps/SKA4TdztbQone42XqVoo8So5zbKqZV2+RAZsZzUoA3aVGiu/LSFmLBFk0mCJ5XHsYaT21oLZ6BGowudbQNgK/ASkhC5Si6oVLIas33MtSohF6UEvp4OZMA2ysn+wy9mvdoZqyHe+dDTQbnvwZy8hNhnsWdAkYrpqTSjA+ZVps6y5XQQkko4irRcPHZLiIEpZc/0VLxOQ8a9G1JPxiZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/w66yf7XZeXGafram8B2dJU77uTTJInb4t+KDEhkd0=;
 b=n0cs4MTxiRCw1j/JudOFs48NcNueY6FB8T/829H6t6mqckh0ZK3RYUE70Nt6iu4AqWB7WJTd9YlNeYDmeOqatdiZ7h36s5B5ENfUf/C5DAAUAmhHoO0lW+KInY1dCFkgDkoAQhqTo+IN7LDzZQCYMTFrpZ0T8a3aoH+jzTWjK39lJc+Nrsb/HI8vZAP6p+wMcwmmAXwcmmUjtkwsJfH2M7CIcN1r9UiQsoS9KjEb7plVA6WaT7wzA/tvJ+ViVGTR7ist+95eUPOJjSKncqpcT5Gmd0jfcmYkgdBNYX/Rvqnk1RKS/HR8Os5T51lxre8Cz1rvPlzOhxQT1ssdT8GE/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/w66yf7XZeXGafram8B2dJU77uTTJInb4t+KDEhkd0=;
 b=Q0p34SBVH51o0p14pZX5nmZu60/krcUiMuPeGH6PaAMRNNIqedmQdvkqyBTczqq+onmVwZitcqIzTr8Axgy2vtNxbB8Xdh58hlql4dU+R+EnunZN9/BgT8srEr90/OXALB6DGwMFxqVZffjGi2tNnNFXJ9CtrvXs8kGYgcTLKzw=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by BLAPR10MB5107.namprd10.prod.outlook.com (2603:10b6:208:324::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 17:08:29 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.031; Mon, 25 Mar 2024
 17:08:29 +0000
Message-ID: <205047df-d581-4eb3-9a63-73b7f1754d01@oracle.com>
Date: Mon, 25 Mar 2024 13:08:25 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/8] virtio: Define InOrderVQElement
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240321155717.1392787-1-jonah.palmer@oracle.com>
 <20240321155717.1392787-2-jonah.palmer@oracle.com>
 <CAJaqyWdg5tg1XR43bHkMRnqvkTZVvrqXMKM__YD6t-xGBOXdYg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWdg5tg1XR43bHkMRnqvkTZVvrqXMKM__YD6t-xGBOXdYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0085.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::30) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|BLAPR10MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dc91461-27f8-4b8a-8743-08dc4cee311b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	moa8ZKT/Rm4OCikoy8CHgn8UQTJO7AmJAJ7rhZnXuhjzlMmQ+LLTc5fIQZPFo52cfj+GpZB/GXxnhTJoEfzo6SOKYMsVGqqEKXHWWnJHeQVyfAIkZBQYAmWSIPRtvAZPgqlek3ZPIlUtmmQuSYZlje/PFjEvSLKnWZJnC3QT1oXPZ4Rhra52sPMautRGkx2rfKdNd1GztcM/UFiVNvbU8mPjgw87QKeG03Yqi3PUi9otpBUMb28unxiDoTK4aFaNBmLdfQCwVlbQi7F42Y7nQofTrGPFx9upUTb0bW/MEjpUTJ18f3KxX5Fup3c6EyXeFwm1syd0pLY+P+eZO6FSwSeQN0aLWD++uNz+kqF5JKYOn276ub7s941albbK5X3dOf6aV5EVKoX4MiA7ureD++4tiOKB9Z8jQgXTJMMD1xbrzYscLPY9w4zgiCefvcnWALFsLhemd/zLSvQqd780kiz49qvXKEytFj4Kqepxc0b7fG8oxYH3XZLZ+ujYx1whzmIGIaUTm/B0LjdIpvwE7Dh+5aA7mpXA5fNmQ2oj//pz06pKW0/9SIa8NFRTxf/NImfSp/ybzdiubCDgUGOakEKGF7sgWJkx90dn88jYZ+7NsYyKk/PGpBm5GKAiJsmxQ+IgTiwPWIgjTi4NY8wHhiYIappGV85+Smxb6IE3C98=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?djZOK01pSklJY2pTc3lJYVZWaG5JVFNZUXA1bDF2M0h4eE04bitHM1lGRDN0?=
 =?utf-8?B?OWlHYm1FQzZjNFFGeVVqcE05VFpqTlBiQWdIT2hHRm1WNld0WURoV29MRlVz?=
 =?utf-8?B?S1BvcWpPb2hJV0NWaSt2OFB5S0lzWHNWSTNHOHphaDZXek9rYUlGaEg4SXZS?=
 =?utf-8?B?N2NTM3BGVlZpRkZXOERuZzQrRUpqTWs0eVc0YWltaVJIRXhmL1VzR3ZrTGtI?=
 =?utf-8?B?WCszZWZBaWR3em5MZ1BPMVJWZU9ZVDROWERDaXVEVThvSTc3eU1PY29vTzJZ?=
 =?utf-8?B?amFaRHpHWmM5bHR6VTFIcHNHQ1lUV0lpU0hvOCtSbUJMVmNqWXlvempRei9H?=
 =?utf-8?B?RnRld1VnbW0yc2wwZ0RvTXNiZ1F4aXVpSDFtWmdYa2taWnQ1Q0JBTnhVWG1Z?=
 =?utf-8?B?VzYrd1BJZzVDYUJCMjlXMzZ0S21SUWo2dFg5eUhWRXhlOUZzZHNYaFNKajZZ?=
 =?utf-8?B?V0hMb0dNcnhGd0Vid2lIN1V5NDB1c3hpek9JUEtGM2dhSlMwcmhyRkJ1Vlp2?=
 =?utf-8?B?aWpQSUJhRUEwZWhHSTY3ejVYMXFSemkxRDlBeVVlRU9PZWI3NXYyc2piS2Y2?=
 =?utf-8?B?azNCd1U5V3JTM2FnNSsxV0k2RWpTUVg1bG5uMTNCYUlDUFhSTXBsZkFRTElX?=
 =?utf-8?B?S01UUnh3T3NoSElhZ3Y4RDIrVFZZWFYrODgwU0RHdzdPbTVKRjZ3a2RHdWg5?=
 =?utf-8?B?djBOVEprSmNxMEY2b2NyUWhhYVdDNUQyZHZadmZFQ2plUUpuQnRjZ2JKZTd3?=
 =?utf-8?B?cnJnM21jQ0hrc09ubGRQUkdhWXdTTERJZFdOY0Q2a0hXOG9jZWRCYmZMYjRT?=
 =?utf-8?B?K3BUUUNyUTZJTVFyNHRHMGxLbVU2RGJ6ZEZ3Y2JsR3pXQzR3U0VjZnFuRCth?=
 =?utf-8?B?ck9zMktoVHpNaXpWeGRXU3duVFdyVW81WEpXSUxXRGFOTWNqZGxwc1ZRRkl0?=
 =?utf-8?B?ZzJ1ZlZWQjZoQkFMUnRTbUlCQmVYMnlNbVlrdUtEdm1zMUFwMmlNbDExNlls?=
 =?utf-8?B?a0pyQTBxdy9kZVpJWWRxS3RRWmtXaFBoOGhRMDd6RmtUMlVSM2VhZnJ2TEQ1?=
 =?utf-8?B?V3ZyTlY5YjNqeFc0S29YMkI4Vk0wTFpTMDkxSUo0b2thc3hjODNieEo0QWtx?=
 =?utf-8?B?QnFZQzYwWGRGVS9MMmIxOWJGczVkbE11RTA0clRUWTYwWGZ4N0h1a1NMSUVy?=
 =?utf-8?B?STI1Ui9aU25JcWEzNE5JcjJZakdmeWE0WWdvQjdVWDdvRDZ0RTFNeXNQQVhU?=
 =?utf-8?B?WGNxNWhuU3FPdzRST01uOS9CakhNUG5Td1FGVTdkeUFEYlozN0tEZFRFblVC?=
 =?utf-8?B?NHROK0pkT1ZTK2xCb2ZSTnRMYysyN1kyMXdjNlFLUHp5SmFISjdTQzlGMWRY?=
 =?utf-8?B?bDZRbDVIRUl3Y2tzakQ3cnpIc1I1dmR4YU9lR1VvMnVqVVExbzdqYUQ5eWNs?=
 =?utf-8?B?bGlub05CM0hJRjNHbDF4TkVyM0tFb3Z1TlFNT091WnpwVXNFQ3FvL29MSW1S?=
 =?utf-8?B?L0ZxM1Npbjd3VEtJNWYvc21ob3ErbWZVWDRvb3hvSHgvNEVnckpZTHoyMEhO?=
 =?utf-8?B?OG1nMlBya2JNNHNFRlZMdmZDVFl3dFZmYWpydzRVR3lzK1ZoOGpxVTdnYVRI?=
 =?utf-8?B?eGVXZnJ5ckp1L2o4b3NqVmV0WXlxMDNNZGg0cTVDSGdmSEVoRFpBRDVYRUFq?=
 =?utf-8?B?OUtiRG43MzRVUWkvNGx4WTF0VzNKZXNIMGlMN2dBWENoSGZZTkNPNWN4SlVV?=
 =?utf-8?B?NGJhVXlHQXZhZXBLRUhBellNK28yUFAxMXVmcytJT2RSRExnNmxpWDZaTW1K?=
 =?utf-8?B?cjFGUDRoRDZQOC93WFFqN0srd3V2U1lSR1ZSTnl0My9Uc2VMMWNFNCt0T3NM?=
 =?utf-8?B?YTlzS2dSS0ZpYlN0dFl5SldJV0xWK3d4ZGo1cEE4OHdqa2RqMGgyQXN4Z3VL?=
 =?utf-8?B?clJFaks3YnVoVmREUVZ4QnpCUDc3cWJqeXRDOGZEMytUWlZwYjN4eWowQWxq?=
 =?utf-8?B?emhEWE4wckFYbU0vYnpkaWE5RDY4ekE3VXo2Z3ZLYkxBWXhGTUZGQ21Kc2hs?=
 =?utf-8?B?NFc4MXVib0N3QWdCdUVBR2N4UnhlV3RoRFdVNGVCOSsxM1dJSVJRRTg1Tk9T?=
 =?utf-8?B?SXpDMU84WUQxYm1KTEFMcjE1ajVUVGpsTWJBdXNPK0NuaE9keXA1NUFCWGhL?=
 =?utf-8?Q?ORyX0AwOC7EwRK66A5TsHPk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	i+ZfXaFQBpXNQujy6XJYwain0um68ppZj03RzhEkxts4pUrrk8qI0sxBD1uJ/MZFfmmEpp85og6NYfGmCtee8faJwlENZ1klUCpFGU7+3kNZxJn724gJ6RtPj8AWzAqUahSsMoyjLyabfZIUk7eWA2LdKklADtv3WXsMDp7K+GehzJEfqGbY1s9JTAN2QC8aiK99yLbnOHf4aseKQ+wYWmmYHbPCTsw4mWr5lHwJKf89koslAbQp48Hq3JZmfajM3oVufs2nZQUv6C6pTv0kle9eeZkPSNH/JazGt6rG/X7sFSaNKxg69/5nuiktgU+ym2ZxkMCgztOKFNjrLW7jcYxqnhOIC26TkRjR+3bxyhQWi7Rn2WMr0S9sVhVxDjoyOlKWt4rSAT/pC7miCjaj+s7TD1IhtLtotlXvQl6QRfKkqtWZjx/3H260mcsPBdNqGNX9T+d+IbVhQ+JpRljbFXFyw4znedzwye7k90Gt3TXQfS7JkQewFahnTrWzeFETOeHrBhBds+FqLqYTxXvQCPc4Xm+s+NtExK3w9DoPLCm+0DJf2FAjs5Z9Mzl7r+wYFl/GKcFqwHpOiC+4MJWeF1N7KIemPXxrf5Vdt04eXjo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc91461-27f8-4b8a-8743-08dc4cee311b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 17:08:29.1027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5XWHFBQK1BSgNhnXQyYGr2Q4uC8GHG8yAe8nRBD0B5DMPftxZlqVaAoRsA1k413iy8/oySLkJaEoMatd7pqjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-25_15,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403210000 definitions=main-2403250098
X-Proofpoint-GUID: GPlJTftdhgiL0J3cYSiaO-XNmpQZEhH-
X-Proofpoint-ORIG-GUID: GPlJTftdhgiL0J3cYSiaO-XNmpQZEhH-



On 3/22/24 5:45 AM, Eugenio Perez Martin wrote:
> On Thu, Mar 21, 2024 at 4:57 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>> Define the InOrderVQElement structure for the VIRTIO_F_IN_ORDER
>> transport feature implementation.
>>
>> The InOrderVQElement structure is used to encapsulate out-of-order
>> VirtQueueElement data that was processed by the host. This data
>> includes:
>>   - The processed VirtQueueElement (elem)
>>   - Length of data (len)
>>   - VirtQueueElement array index (idx)
>>   - Number of processed VirtQueueElements (count)
>>
>> InOrderVQElements will be stored in a buffering mechanism until an
>> order can be achieved.
>>
>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>> ---
>>   include/hw/virtio/virtio.h | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>> index b3c74a1bca..c8aa435a5e 100644
>> --- a/include/hw/virtio/virtio.h
>> +++ b/include/hw/virtio/virtio.h
>> @@ -77,6 +77,13 @@ typedef struct VirtQueueElement
>>       struct iovec *out_sg;
>>   } VirtQueueElement;
>>
>> +typedef struct InOrderVQElement {
>> +    const VirtQueueElement *elem;
> 
> Some subsystems allocate space for extra elements after
> VirtQueueElement, like VirtIOBlockReq. You can request virtqueue_pop
> to allocate this extra space by its second argument. Would it work for
> this?
> 

I don't see why not. Although this may not be necessary due to me 
missing a key aspect mentioned in your comment below.

>> +    unsigned int len;
>> +    unsigned int idx;
>> +    unsigned int count;
> 
> Now I don't get why these fields cannot be obtained from elem->(len,
> index, ndescs) ?
> 

Interesting. I didn't realize that these values are equivalent to a 
VirtQueueElement's len, index, and ndescs fields.

Is this always true? Else I would've expected, for example, 
virtqueue_push to not need the 'unsigned int len' parameter if this 
information is already included via. the VirtQueueElement being passed in.

>> +} InOrderVQElement;
>> +
>>   #define VIRTIO_QUEUE_MAX 1024
>>
>>   #define VIRTIO_NO_VECTOR 0xffff
>> --
>> 2.39.3
>>
> 
