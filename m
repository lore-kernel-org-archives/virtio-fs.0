Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406D4145A11
	for <virtio-fs@lists.linux.dev>; Thu, 23 May 2024 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462661; cv=fail; b=emGETi0mFL3JvMz9KowZNdyRTMIdLTmadKoxrfv8B3ZsXoF5O91tlstK+8/uC+e0bPjNTzC1jRfVaOVzSD1qD1hBglO6wXDcNzr7KMvBRLQH9+VwUTssjwhK9LsT7/FlyrdLYhhfNyGqntGb/yThT9tG+9KbPzrkEATCOiFxLZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462661; c=relaxed/simple;
	bh=buVcHGm5w9jLR+mJ1M02ycnELfLnxXHRIVlWpPtdYxM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=urHpjO64a1Z13KTMIjTCl3cmrmU0CWZm+rXIX09cVLHiTISQfhZY+fGP8mVgaJIjkePR8BM9eah7qDJNS4nQFaLRLkBpL+Yjq/vXwBBio8m8Gb3gpDrZgXkQ/0BU9WPLKQn6EmwVCsAq33MfIEqMGZ87Fbl+rnQc1FUydYxKzLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xp2Unv7o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=en/3IsKb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xp2Unv7o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="en/3IsKb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NAflDr015130;
	Thu, 23 May 2024 11:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=nbKpLPWNL/hr3XBEz1ikgrXcO8mBn1AB6b6IeE7A000=;
 b=Xp2Unv7obuZMPWZpbuR2VWV3ciL39x44hZJQnaOzU9eFrkcAHkjX65Ay0sfkHCnsU9s1
 bkRGO/JFCqWosIiN7G/BdsMo8GMVUcXXsLIXZ3E00a5XuNAN7Slxm1ZTUnK/RNm3Nna8
 GTid7A33Ou+8LvfVFDROm8ZZJOLYCHg450OpL0EthfcuTRns3LpAG8/7E3lHWT0vx+Le
 +oJfRozrhg+i5bvwKi97GSiI3V+SFV63F+7ltr62EcFLrKxhVBbjGLrM/AlRhR1byw/4
 6LGdTF+OSRGs9gz05tuty6t6EMKZRCz1VYWBY3Knjxp8iGb1IXjjcRFG7kPdklbMoQld Ww== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv9tg3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44N9IYod019587;
	Thu, 23 May 2024 11:10:51 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsaf1nh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 11:10:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGB68KA25O4l5hHSErchjy59mjKeuYDjQaI1gA9DbjQejtD8xtzq/mHWzA/fmPQa10yH4zqb1+G1lK/qNMExpOprlhQGV1/bR7X2yLQyn3zsVgqNgHnliJN96izknzEL4FUt7iDAIgWRoFw2x0qB31IVg5LfTi4nuWIgEHpzVrJSZMMOAm1s5Gck4cPtHsNrkT6FAaomz4qWlx1vMsjwP5GBXqlX9/Gy7jQnoqffdSyAt7Zq1bW4NS/y/7FZJsYmRGsZC+O+ILgdTKYtgSDTjjQanB7QTvULhjbeWIK85X0Metnm7elR9LA6BeTf8T5fqdww5Iv3C61uIYDLdW+vgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nbKpLPWNL/hr3XBEz1ikgrXcO8mBn1AB6b6IeE7A000=;
 b=F9G7wbD8NvFhmj8HzKkeHlTPmQ+u0wgDUd0FcMuzvC9Avsa8ipR91o/jdePHTpMDolY6RhZvijXT6qlYWvqqyqWCyLMc9tuox5RlX9KYImXNxBcQbN9sohQRFEjiRZi51bjLjjwHhr/p299My6rCczReiydyCU8NiBqwu2RSoG6vBaST/oYQDA6I3p/WYik2XuGJAQMXoojjiEAEarqzITVQojNTDAhmje7m+RAxPtUfJ7w/H2blbXlqCMxWt7f1iJ4MBPDjSwx3A1a7/nkFUz/3Wyrbo+VFiqc2CWSOieB6ZQrK/8qySjIoNnE1J2j/7lzvIqo181HvkHLqCH7lMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nbKpLPWNL/hr3XBEz1ikgrXcO8mBn1AB6b6IeE7A000=;
 b=en/3IsKbMxFEBot5a96fSUcfP3thrhadC70sbSYFQuGLr03A7jU1vo91/huzVEtHmaR8wxP7dGv9hxlur4AILjVP+L2YpYdC+hDZwKAB6RSNMnpTI2Wsa96mokY51m3d5MKPM1jhOg+2TN4ox3TXb12dGcdBhZWW89yJJ/JRVcQ=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CY8PR10MB6827.namprd10.prod.outlook.com (2603:10b6:930:9e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 11:10:49 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::7635:ba00:5d5:c935%3]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 11:10:49 +0000
Message-ID: <e30726a2-825a-4266-82e1-00658e014a45@oracle.com>
Date: Thu, 23 May 2024 07:10:45 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] virtio: virtqueue_ordered_fill - VIRTIO_F_IN_ORDER
 support
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240520130048.1483177-1-jonah.palmer@oracle.com>
 <20240520130048.1483177-4-jonah.palmer@oracle.com>
 <CAJaqyWdxt+cPNR=unm6P1cGCKV=LwhuMYdVeQLbWF6wYLBLWKg@mail.gmail.com>
 <5469bc3f-7fb5-4fcf-ad9c-6467aba635b9@oracle.com>
 <CAJaqyWe1ozf867a7tnSKjkijnHtT+5i7y8p9zvtTXqgZNk74aA@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWe1ozf867a7tnSKjkijnHtT+5i7y8p9zvtTXqgZNk74aA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0387.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::32) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CY8PR10MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: c6fcccd7-194a-4ac9-d8d5-08dc7b190073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?NC9WTldMRHRCcUtxV0pwWUJpeEFZNjdFZEtEbXFUZ3ZUUnczTUFibUlQY2V5?=
 =?utf-8?B?Zm1pZVB5MDE0ajhSaUptQ2ppZFE2eExMN0RDSHhhUlVxZUtZMWprWWZrV2JJ?=
 =?utf-8?B?aXlKczFKbisyaXQ4OTlzbXgxSmRCaUt3bjJ0Z0dxcHVBN0Zwc2ZZVEI0M0Iv?=
 =?utf-8?B?enlwVWFpL2xuc3FhM2hRNStXZWFZNjkyd0lCY1B4WFdNUHZkUUJCN241SXFr?=
 =?utf-8?B?ZFJHR24rai9KbnYxWkdvR3RYOTNldnc1MTlxYzhSVE5aMkdsVGl4Q200b25L?=
 =?utf-8?B?S0VmTEp2d2c5ODVBL0w4c0ZEY0U0bncyTVE1dGVTOVNjSmkybjBLQmZqSXVa?=
 =?utf-8?B?eDUrc2JYdTA1dWo1QnQvOTZHdksyYkhqY3FscVFETEpZOGVQOW43Q0doeDdQ?=
 =?utf-8?B?Y0c3Q2kyTUNxVzBmQ0pWRno3OUlYUWp6UnowdVVHVHBUOGFiNjFkK2FFYlZt?=
 =?utf-8?B?QWhUT3hkeEhaZjVPNEVEbEh0UGh5ZGE5RTRuRzFEeDdwUVdiWkk5ZlZrU0JP?=
 =?utf-8?B?UUNLMER4TFFOUkxZdUw5TEQwSFNqY09ZUjk5VW1qNU4xdHBka0FsejFIVmRJ?=
 =?utf-8?B?SHhTcEJqTWpjUkw1MTYwUGhTWFZWbldxeWptM25MUGIyR2t0RjZDeWFUdVZB?=
 =?utf-8?B?L3diVjZlbTg5czBIYjBxTm12WWJsLzdMbUtVcUR6M3lwOUlsMm1MYzFtVFVu?=
 =?utf-8?B?aHBaT0lhRW41d1FBdEpiU3ltNllnUjkyb1hhUGJxSTlqUGYzZU9TeHNNMDFT?=
 =?utf-8?B?RFdxMUxDa2grQnhDMDFiaUpUTWwxa3dremVFRS9tOHduWjYyZE5BUVhVVWdJ?=
 =?utf-8?B?a0ZaWVBGaFhlUVZCNjVvaHhHRWRkVEpMTi9XcFlRQXZhK3VjNW1mUjlIS3hQ?=
 =?utf-8?B?dDc0UXRVamxEYmZNczVPTU41emdaTnpaeGY2TllOWFAwOWtXdmdTbjZ1U0lH?=
 =?utf-8?B?T0VWSWFnbHQrby9oZXJqK1Q3RWFqbnpIaWNQYitnZ0NFUEtrL094U0FlK05K?=
 =?utf-8?B?N0Q0WDFoZXkrN21wRzZYV1FiQUxkUDNtaDNERHFjWmExWCtOc0NJR21HVTNZ?=
 =?utf-8?B?dWg2cWRqcWNVbkFWbzAvWGlUUlEvQ0dqTHpURXUweUt0ekp1MVR1V0FsSEs2?=
 =?utf-8?B?MU9kcldySkxlZkpIYmx3eWhyeEs4ZTBWdm9lRXdjNHlBazJtbE8xNHRNYXZr?=
 =?utf-8?B?aTBIYkpqblZPTkZmdGVXc25vWmJWeHR6V2VzZGNKR21TQmJybCtuM29KOTRE?=
 =?utf-8?B?V3MxZWNJeGVlZFo4K2wwTmZRNy9CclpNamtOZWRneFl2R09Kc0w4SVd3OC9D?=
 =?utf-8?B?YkorZWlCTU8xd1JKMUJvZ2ZyZkpMc0Q0SWlaZVZFUk5aMGhlOUpneUd2WkZi?=
 =?utf-8?B?cm04bldiUFFNY01uNmQrck9ESlAyS0FFdzdYRHExK1QzUUJabElwL0pVeXZa?=
 =?utf-8?B?NDZSa2MrNnAza2RsblJvUVZnTmlvSGFBRlZzQ09HSUY4bkJvdVROWDBnN3R1?=
 =?utf-8?B?N2ZLWEtkV0lTajVtVmRvVjJVRFVtR2lManhLbGlkTXNsQW9RVzBCNDljbHFo?=
 =?utf-8?B?OEZOZmFuQWtvNmlXWC9VL1RsRXV5K2NzclZGdkJWUllXVll4UE9Cdlp2c0Y0?=
 =?utf-8?B?b29FSVdKdmdpdTMyMytibXFNYXQ0N1BBTklVWUZMSDE0QTNrVmowd2RlZzQ5?=
 =?utf-8?B?TGwya1ZjWWhwZVIwOEZQMEZGYW9lWDdlVUN2MkI0Z2dYLzMyeUVKdyt3PT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?WDNzYlZGcy9aWkxtUlZvNjAwdUNEV0xGcDE3RTgxa1Y1LzRadmMxQk9pYzVN?=
 =?utf-8?B?N3VReU1CS3RFVkxxY2c3TkFFbklYM00yMlZuZlozN1VkNWZKRExzVlY0YUcv?=
 =?utf-8?B?V1BiNU1LQzVJc3dEZUhRVlQwUGtIeTBEa2sxWllydUFDMDVNYWdjYktsOUZO?=
 =?utf-8?B?TXpYaDZYOTZHRmk5OW5HZjlOcFFZcENzNlkzVDk1blRJSllEdlk4d2FqWXlG?=
 =?utf-8?B?M0g1MjdaalRValBMblVSSnIzYVkyNzRSWUNiclpZL3Q4M0lUS1dFREg4KzRu?=
 =?utf-8?B?TS9HNnRqclY1ZnprYm1jZmRab1F1a0phSVR4dlZOT3M5OEc5NWxPOTlIY2Mw?=
 =?utf-8?B?ME5SbGwvNkxaYzN2VFZOcyt1TjVWMDdxWmpETndibjBBTHY0OW1vKzQ3cFpk?=
 =?utf-8?B?Y0hZVWM2RzJmTlJVSmY3eUZzL1VPL2xIT0ZmTWdKZFB2aWt4ejFFWFVCK3ZI?=
 =?utf-8?B?RkVucEh1UW81ei8wMEl3cFJSRnloSUpUdU4rQVBHMmhweTFhQmFSMXFOY1Za?=
 =?utf-8?B?OHlyVGFBSjJTSlFLNjloR2hyY25INWhzSGNYanhyeGUrcEZ1Q0g4K3YyRXNV?=
 =?utf-8?B?a2paalNRSDVGZTNtcS93K3pHcnZzMWd1aDVvemZTdTNpTnJ2bFFLUUpSRDli?=
 =?utf-8?B?aXNDSVNlSXdYb1hnbVhFVHJRRTMxd1k5M3g1eWN5WmE3aWNFQWZPQTRQOExh?=
 =?utf-8?B?QTZwTkFEZXZ0SHBGbklnekFnSzAreEJyRSs0bUEwMkRMS2xwcDdQNW9rMVVr?=
 =?utf-8?B?K2lzRXFINWQzR2I2R2wxaExHaDUvcHNZY25jTloxaXpEZkxXKy9zSzNPUldC?=
 =?utf-8?B?bDhUaUlsVFJHS2IvWjZyTlpTUXVYZ2c5Mkh3UndBK3BPRmh3eGRJbXRqQThB?=
 =?utf-8?B?UjdYY2oxblVFVlMrNnhKYWx1NkxlL1lUL255NGdEd1QrUUEydlgzaytKZy9K?=
 =?utf-8?B?TlkvQUU4NlR4SGNyZkVmTCsrd3VhRG5EMlFiRksrMU5veVhjaUlVYnV1WWI5?=
 =?utf-8?B?Q09DYjg0U1A1WmxHUWQvQ2VTWDNic2s1T1ZVMGR1R25kaVRDck9Cb3IrUU9k?=
 =?utf-8?B?RmJvbGdVblF1R0libXV3Ykw3WWpTVDF1R0VrQ3UvVWVWMnFYdmxhNDdZU01M?=
 =?utf-8?B?NGNyMVp1ZUc0R2R3YWJYRVZJQWpqVG5OUlZiQ0dBUXZIK08xblVxQnJsVGN1?=
 =?utf-8?B?UEIwQXYrckd4RTdyeGJXVFpCUUdCSnlpMzFZaU9OS0RLUGRSL0lkOGlwVFE0?=
 =?utf-8?B?eUV6RnR4SktlSDE2REVpL0IxeUhjWWNGanJjRGRJWDNtdWZ5bTJGSXM4dmtJ?=
 =?utf-8?B?VEJrMXo3bkdaQTMxajA5S08ra096b0NSU3hoVHVPM0RIT09Td25mRHRlQXB2?=
 =?utf-8?B?QUdwZ1RtSHp2Tyt6a1FCbTdpdWg2RHVqbkdIZ3d3V2c2QUdwSHZsWWhaTVZK?=
 =?utf-8?B?VENSRnZlTG1vK21lRnJzQlpYQVo2SmR2aFlKUVNCTURoTnRmdzVCQ2grWjVL?=
 =?utf-8?B?WUNSeVRaT1BZQ1hoYXhVRUxqZXJGcUZlSit2Y2N1eSt6MzFmZDFJdnl1aUFl?=
 =?utf-8?B?Z3RHRXN2Y3dkcVlvRTg1N2VCcWJCaUNlRkgyMjBuRnBHZ0NWUHNhcnlpUm5s?=
 =?utf-8?B?OGVWSjNxT1hra095SDFETnR1QTRHc21GSmRKZXNaczNaTC9Sai9ObWx6MHpr?=
 =?utf-8?B?UmxIMGNSTFFWeVM4MnQxVW0rNHZLbXBVbk90UzVxcS9pQnNlU0JrejZoblEw?=
 =?utf-8?B?M0JNRjBLU0pkYktZR1lpQ0JoZ0ZoSU1pcGdPYXpEK1RFS1QwL0VRZ3M5c1kv?=
 =?utf-8?B?bDZVMWRVTHJMN1AvYWhicFhYZkYyaXZnMS9Rc0xRelBSZzYxdVhHWUlKc2Rs?=
 =?utf-8?B?RnYzcGdOMnZ6SE91M2MvcXlPOFVDN2hEZWk0ZEVkOHJ6OTRvY3d4ZGZBTk8z?=
 =?utf-8?B?NGR3N0FUU3FUcllXUTk3TlBnd0lkYitYRzM2UzlldFE4Y1VVV25MYjZRR2ht?=
 =?utf-8?B?NDNpZlp2ejBMaXlIUVJWQzJZT3dTS3ZKWkhQVHFoczl0YUxCQkZkNENkcnNC?=
 =?utf-8?B?ZXQ4K0RVbUlNTlMzVjVlMEZmR3pSWFM2QlNRMVN2VUhrL2h5cC8xNnFuNlFB?=
 =?utf-8?B?QkVXZUpqc1RWOUQ1L1p6WXNrZ1FOUXB1aW9QSjluWVk2Y2crTGRpSk5GQTdx?=
 =?utf-8?Q?X9Cs7tXoo8A53tsK9SP4vXw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	QAxzd7bSZuVW1AW3Iy81Wy+FZZFWYYnY1UWMljoRX2b42hy4JHUcg3K331vu/Dp43YmnHjhnVFxUCRuWhEZaectAa4jc9TylrR1hXeFHQ4kBPLY/zJ67LyyeEBPizeP3F7fJjLGyHTJglegNsO6q/sDmLKvsaIWx35LNDb/8cQgS7RwJ1W9Ac8Z92aAxjsLGjqc4HRFSBiqpUzCbemUu8o/bH8x0Dq2UImu05lrK92zM+bzM+zpwR8sdDxz3ySc5NSLkZwWgqTqfP18hGPOxgrXsoWSv1rcb3SmiUX+weq6TvB9ePNG0PiGvh6PpbYdzEuq79vNACCgihUfMshXXOytNEcIdNVt0QLx+5RgVNfBxriZI7qbzoK9MXrP4FKfK9BCU+8Mm8SSaH5NuRND3yTO9gtjoDAGvPtR/4L0ZvY4+GyTd8ofWtMPfx+TWUKiB2OtYiLcOOT3EUvuhHFiF0JyUMBxKKTgqIGNwq4XurE++q3PgC44t2qSLxEkMG6GQokm4nadIpisp09BkkID2nXw4XCU+knfgj1KWUfbJavFONekjtYWufmnV1ItjkIPpGCmPENE1SbmgJ6ZoskZ3YLEhy/DDSMaeZTBAeJTkNfc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6fcccd7-194a-4ac9-d8d5-08dc7b190073
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 11:10:49.3668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t2qMkRsb+DgVLkgtpapEe3yejoc6PRO6nNyy6bhmnsZGc18INUacvNwioWlXYyRQ7oWNQqZH7F5V0pf8gLmr2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6827
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230075
X-Proofpoint-ORIG-GUID: 51b3CRfe5WFa3hUyo1pbwkJgYNKQVLid
X-Proofpoint-GUID: 51b3CRfe5WFa3hUyo1pbwkJgYNKQVLid



On 5/23/24 6:47 AM, Eugenio Perez Martin wrote:
> On Thu, May 23, 2024 at 12:30 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 5/22/24 12:07 PM, Eugenio Perez Martin wrote:
>>> On Mon, May 20, 2024 at 3:01 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>> Add VIRTIO_F_IN_ORDER feature support for the virtqueue_fill operation.
>>>>
>>>> The goal of the virtqueue_ordered_fill operation when the
>>>> VIRTIO_F_IN_ORDER feature has been negotiated is to search for this
>>>> now-used element, set its length, and mark the element as filled in
>>>> the VirtQueue's used_elems array.
>>>>
>>>> By marking the element as filled, it will indicate that this element has
>>>> been processed and is ready to be flushed, so long as the element is
>>>> in-order.
>>>>
>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>> ---
>>>>    hw/virtio/virtio.c | 36 +++++++++++++++++++++++++++++++++++-
>>>>    1 file changed, 35 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>> index 7456d61bc8..01b6b32460 100644
>>>> --- a/hw/virtio/virtio.c
>>>> +++ b/hw/virtio/virtio.c
>>>> @@ -873,6 +873,38 @@ static void virtqueue_packed_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>>>        vq->used_elems[idx].ndescs = elem->ndescs;
>>>>    }
>>>>
>>>> +static void virtqueue_ordered_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>>> +                                   unsigned int len)
>>>> +{
>>>> +    unsigned int i, steps, max_steps;
>>>> +
>>>> +    i = vq->used_idx;
>>>> +    steps = 0;
>>>> +    /*
>>>> +     * We shouldn't need to increase 'i' by more than the distance
>>>> +     * between used_idx and last_avail_idx.
>>>> +     */
>>>> +    max_steps = (vq->last_avail_idx + vq->vring.num - vq->used_idx)
>>>> +                % vq->vring.num;
>>>
>>> I may be missing something, but (+vq->vring.num) is redundant if we (%
>>> vq->vring.num), isn't it?
>>>
>>
>> It ensures the result is always non-negative (e.g. when
>> vq->last_avail_idx < vq->used_idx).
>>
>> I wasn't sure how different platforms or compilers would handle
>> something like -5 % 10, so to be safe I included the '+ vq->vring.num'.
>>
>> For example, on my system, in test.c;
>>
>>      #include <stdio.h>
>>
>>      int main() {
>>          unsigned int result = -5 % 10;
>>          printf("Result of -5 %% 10 is: %d\n", result);
>>          return 0;
>>      }
>>
>> # gcc -o test test.c
>>
>> # ./test
>> Result of -5 % 10 is: -5
>>
> 
> I think the modulo is being done in signed ints in your test, and then
> converting a signed int to an unsigned int. Like result = (-5 % 10).
> 
> The unsigned wrap is always defined in C, and vq->last_avail_idx and
> vq->used_idx are both unsigned. Here is a closer test:
> int main(void) {
>      unsigned int a = -5, b = 2;
>      unsigned int result = (b-a) % 10;
>      printf("Result of -5 %% 10 is: %u\n", result);
>      return 0;
> }
> 
> But it is a good catch for signed ints for sure :).
> 
> Thanks!
> 

Ah, I see now! Thanks for the clarification. In that case, I'll remove 
the '+ vq->vring.num' in v3.

>>>> +
>>>> +    /* Search for element in vq->used_elems */
>>>> +    while (steps <= max_steps) {
>>>> +        /* Found element, set length and mark as filled */
>>>> +        if (vq->used_elems[i].index == elem->index) {
>>>> +            vq->used_elems[i].len = len;
>>>> +            vq->used_elems[i].in_order_filled = true;
>>>> +            break;
>>>> +        }
>>>> +
>>>> +        i += vq->used_elems[i].ndescs;
>>>> +        steps += vq->used_elems[i].ndescs;
>>>> +
>>>> +        if (i >= vq->vring.num) {
>>>> +            i -= vq->vring.num;
>>>> +        }
>>>> +    }
>>>> +}
>>>> +
>>>
>>> Let's report an error if we finish the loop. I think:
>>> qemu_log_mask(LOG_GUEST_ERROR,
>>>                 "%s: %s cannot fill buffer id %u\n",
>>>                 __func__, vdev->name, elem->index);
>>>
>>> (or similar) should do.
>>>
>>> apart form that,
>>>
>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>
>>
>> Gotcha. Will add this in v3.
>>
>> Thank you Eugenio!
>>
>>>>    static void virtqueue_packed_fill_desc(VirtQueue *vq,
>>>>                                           const VirtQueueElement *elem,
>>>>                                           unsigned int idx,
>>>> @@ -923,7 +955,9 @@ void virtqueue_fill(VirtQueue *vq, const VirtQueueElement *elem,
>>>>            return;
>>>>        }
>>>>
>>>> -    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>>>> +    if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_IN_ORDER)) {
>>>> +        virtqueue_ordered_fill(vq, elem, len);
>>>> +    } else if (virtio_vdev_has_feature(vq->vdev, VIRTIO_F_RING_PACKED)) {
>>>>            virtqueue_packed_fill(vq, elem, len, idx);
>>>>        } else {
>>>>            virtqueue_split_fill(vq, elem, len, idx);
>>>> --
>>>> 2.39.3
>>>>
>>>
>>
> 
