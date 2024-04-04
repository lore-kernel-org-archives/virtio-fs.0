Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37751BC30
	for <virtio-fs@lists.linux.dev>; Thu,  4 Apr 2024 14:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712241713; cv=fail; b=jLou+FDUD4lflWdyC3ydITfmK2JXkVGv0INwBXMdDcA+IJvsKxEtiNVzo8pBJQ1j0fKR/NbpjHDz2ylKviMLf9sEOVVulvItwUm0blXqSNVbpYzne6C5NVObXoJ5P0Bq9xfbKZW0tEI5bYjcBtFSI8aIVnCU1UhwFygd1A4wmo0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712241713; c=relaxed/simple;
	bh=i7rNa4ukcEEDIwLW7VE471qDBCk/NchmivqZn+iZjjE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jh0127Zu+R8ZCavKS088GzWRFRY9kbqibP9+14OO1j4Y7sqAulPoit+QGK8GRjEeW7zQ3THFi+0pEmvtaxSxDELUXSzFTANd38WEUr+6pHm7GWI6t2FTV80jPvykatJyv4i65uEOZrWX5xlYXqbBk45/iOr8dCxLlhUoxyJwZF0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BVxyL9Om; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KxdMdeQZ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BVxyL9Om";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KxdMdeQZ"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 434COVwl022087;
	Thu, 4 Apr 2024 14:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=bZLMQg9Zte/4sRJC6QUUEMavQRS45ghgg6Ob2GfHQUE=;
 b=BVxyL9OmZ+FLFVPhfSnpUMf2L+1FvfA3rIAm4RfsqIomwyua3G/bgT8BbGHDLmTHjHXZ
 Lgl36RmWBiAAKBp1O8Vdnx4Od+Fx1z5+IcjxcWnhOB9EpnIwBu+1wXiwP7ZlWXl43Ep9
 NuJp66en3b4RZ0dN9RRdFGsAekmfLcpcZmDL7eK/ChZrrZWMeqUs4sfy6tmPQM7GRHfZ
 bXb+5o6Z+PjxYfB3UaWURiDwZFTrMxEvmVnrdMtRY0Davan+8srtiL/GdmO27Th4NBGh
 esF2Xv1IQZ2cbFFrJYXRl7KPDVN9pz77Jhg/d5GDFDx7oayT47scBvFvT2X2oLSqkOob 8Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9evysee3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 14:41:35 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 434EIlEJ031239;
	Thu, 4 Apr 2024 14:41:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emwsx5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Apr 2024 14:41:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UwChvAr4JsvRPsvt7PHJAPYhirP7E+qtA6SVe0yHIXoxG+MIsNDwF4AWov1rGAEoPOi81HEKjKGQlRANUKhh9PHf6be/2Z3wqyK54iHkskjAw4gpr8YB+4PXhXiIKPQdUNtgDSexyGVWK+CtnvCQ1mGGKgenIVzA+30sYcZ0bXSn1GTDnSVfRyWSUwGCORn9j0TYmDknPRT+lR4Sdk1IV0L+GX73r/tE75xw6WqaZasPDDXK6gLQoad/bYoeYIp9W3EUctY/M2kZVdHWEc/tCT/3kNT7v+7rYJ724TJXVuP6lkfev/Ww8Gk920unDxrWaY85J8glzX9TeIaf4TcAEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZLMQg9Zte/4sRJC6QUUEMavQRS45ghgg6Ob2GfHQUE=;
 b=WaWsjFKJI9/q2h0QCsc9Mfm2dHnwqa1cgc7GBTSAdvnYAZdcExl0ndfGSevgxlQxbcgv4+mvQjGMx49zKlC11hjzLAc6dPxp88p+zontxz1Nh6RVqDvRDNkH/rIkDlrhh0sjPG4yW4B0G7GqaXTNmeCY3Dirigp3t0FaqKdAB8TluEqMjS9TZZw4L4EpNuTh7NB6rkOSO5MTQrAEBPJKq7fDzCgyV+nSMyAhdlSq5bR2bcrNdOZnIbgH8gLjMXjS7PXvtaqM3dB8gqS86QZ/7rEobEMZBD1YBUc2W5jRAVWRPS7+KxOkSVrSR2Q601e7YjWqvCFcqjzdzawFni7p7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZLMQg9Zte/4sRJC6QUUEMavQRS45ghgg6Ob2GfHQUE=;
 b=KxdMdeQZN0BysBnhW96nZ7NnB4w/y/nk/xB0wxTzTWBhtbcsPff9m78gDLN6sSAcT26rzSG9FqSfJmBTSxCPUH0ZfAn9BTF8Gq1y1QslrgXNKgIyPm8VhM+bRCQ6j/G2giaKafOgKeYZ4/r4NSlRP6XvNUDUyYoiAsFKiBzx8Wo=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by DM4PR10MB6742.namprd10.prod.outlook.com (2603:10b6:8:10e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 14:41:31 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 14:41:30 +0000
Message-ID: <42b8e8bf-ecfb-4633-b1b6-a33435f81cdc@oracle.com>
Date: Thu, 4 Apr 2024 10:41:26 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/5] virtio: Initialize sequence variables
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net,
        kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
        qemu-block@nongnu.org, schalla@marvell.com, leiyang@redhat.com,
        virtio-fs@lists.linux.dev, si-wei.liu@oracle.com,
        boris.ostrovsky@oracle.com
References: <20240328162203.3775114-1-jonah.palmer@oracle.com>
 <20240328162203.3775114-2-jonah.palmer@oracle.com>
 <CAJaqyWdyZdu48+cZ2umafLRi9NTz3YHxSxmyq6SD9d4noTR2jQ@mail.gmail.com>
 <768ffc05-333a-4f00-9944-940bcaca59fd@oracle.com>
 <CAJaqyWe3bw6WML9MLEhnpNuWL0_HUQJ4WrSyr1jnGHs6Jwn0-Q@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWe3bw6WML9MLEhnpNuWL0_HUQJ4WrSyr1jnGHs6Jwn0-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|DM4PR10MB6742:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JUd5l6dYVFYOPOVEVRJsTs31P8Z8B7RVzGnTRJiAUg5pwurQpokOePrR9DZsxaJOPjPUncDGg9NqRhpynap5I9Cs3S+/y2mEQpFCqBnbXQXxcKs5bj1TTVwLLCkoWVBJmEb24m65VRFXo3cYDK88lThxyKTVZ3K9LKnYCY4KHUIEbt5lp4SN0LeQvw23NPSoq96JPm3jq1nT6O3rUvugrijD47+Bz21z8qWbnpFq59milgUyeJykF8q9r31uA6v0HO37NR8kjFJJtOSi7qKaUAR/PDIerZfd6UUDb2qVoNf0Dmlb16fDTaG4uDwk6LD5ZV8tp8F09EuZ1yAwWoBHOTNRJTUmpCo02V3DmZW0WdZmX7Ie/oD/05o68fqhX+HrH35e1nRjEL6mQJPNrR2p9sZjf24bJNmTXC3oMvqgICgByapskAZWqQOB/LT/kgZSGCfdUXHpxcxs47jdGqt/BJwa8wmUcqKxGBOhdxQOqBjoXyusqq8bHpAWaAbBfesDgZ84yDf+aWHANwdSPK3pyuaBOLV2qDPzD4LH7QJ+Rri/WZdXGw7IdpAYD6KNCLLiitGDuBl1hnNrcZiqL02EQi4yEJS/JB3oNBxOGpT6mXI4FMm2oagTfXBQvWjKo0f9fix/oAWzm7Pz+aELEV4w3M+hUT8eLhstICJ+Qh0lp78=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Ny9CQ0pyZnBmQ1BBMkxXc2FoYzNJZmtNME9UQytzcWViaHBubE9Tc2Qxd1FX?=
 =?utf-8?B?NzV1REdCRHI2UDZhdTJGSjdKcS9NeW1DM1RqTW5sOTRvNzN6VFQ2NjJFclQy?=
 =?utf-8?B?YVdPRm9HZld5SGdpK05UWFc3TkkwN3ViOW9GYzdKc3FHZDUzanIwODRtQ2o1?=
 =?utf-8?B?aGtWOThKczlrZnlSc0ZqZE1ETU5jbWFuV0lrMTJrSmxKTmFVQWYrV1BiVlZM?=
 =?utf-8?B?b0Y4ZmhMaGxpRWFaMms4VmFGQTJnZUNJeVo4OVREZm9kc3dKM2pnVGhuU0gx?=
 =?utf-8?B?ZHJ5NUlTMFNDY1dNNGZaZzFPSGtwbS9YYTZTc3dadW1CeGovdm1YT0ZHTUx1?=
 =?utf-8?B?c2w5OHBKOXBPVFdZOWJSbnFqV3BZdWo5dGNIN21PMWpCanNBYjhwdytHb1Fn?=
 =?utf-8?B?SDdyTFNpdFlRSVFMNDV5cUtnTWJvKzNwL1pLc3k2RVlYM0tPMURDWWV2dk43?=
 =?utf-8?B?Zkx3bkI5eUQ0V3FMSmpSTVFRaS9HYmM1S09EYnVFTFBwSlllRFVqVUwvUTBM?=
 =?utf-8?B?UjF1TmM1MVhTMGpsdTVQRDlXZDRsZ1dBUUszbG5sZ2RRc3oraU1xUTVVMGVT?=
 =?utf-8?B?YU5JeFNUd0VJTXFJMzI5UmlvNFhpYUp1dFQ4KzM2a1BoN2I3dGE2SDRiNjFX?=
 =?utf-8?B?Z1NhQkdGUkRHamNzYTFVanZEUVJhejkxLzlSYyt6TVNrcVQyY2tKNEpITmVY?=
 =?utf-8?B?OHpIUWQ1QWpNLzc5QmFwTkw4ajJSOVZUNTNCMGNNZW1PWmdjS0JGMXVVWTlk?=
 =?utf-8?B?eVh0U0NYM2VDRzNacjFXOWxiMXJQM0FxakUwMUlTNWkvNDV4ZkNVQkJsRzN2?=
 =?utf-8?B?SzJ3cHJCZklBQnBHWERWNElnWVI5WC9jSW1VNTEwQXE0MHZFNmVzVU1hcXU0?=
 =?utf-8?B?YkhVWFhmYnpNb1J0N25wWHJ2T0hNSUZPK2dtYWFyTDhSajNsUExnNHhEeXJD?=
 =?utf-8?B?N3liNUF3M0NLZW5rODNmMGdZemt4UnJRd2xVakowUm1XektsRTFoSHZRRllS?=
 =?utf-8?B?ZkFrMmRianpGM1JYMzh3MmhYZEo4MlhUelFsWkFuTkk3YXpiR3ZOL1I1Umxh?=
 =?utf-8?B?Yy9RSUlRNHVBbVFiT0VFRC9VeFlibzU4ZkthUlAzUHJLYUlqNE1MNHRIcDRj?=
 =?utf-8?B?VmhjQVQ0WDJzSUo0RmpzZnRXNUpNaHJTTVA5bjNhUFFJZFpmeFJ1c2VtT3hE?=
 =?utf-8?B?eEw0M1l1NXRHVFQydERTa3p1M1VnWHhpQ0h6anpPRHZVbzVudmZ1N3RVYjFU?=
 =?utf-8?B?VjBKdVE0VU1qMXV3VFM3TTRLVHJzMzcvY2wvUXpyNFpXNUt1RWU1RVM0clRy?=
 =?utf-8?B?MDU3TzhnOThKcmZUcU1nVEtOMzM5MG5VWHUxRFoxMmFKZ3FCc0FDUUZFVHhY?=
 =?utf-8?B?TFhSM3B2Ykk2ZjhQVzJBejFjUEZacVdQUmRlYWU2SktidWZXZDdmdThhOVdz?=
 =?utf-8?B?MnVuMTRNakZ1Rk5kU0g0Nit5VXhxN1BhWUFBWUdSTFpiZHRUR2I5MnZib3BB?=
 =?utf-8?B?TUpiaHJuVkFYK1JLTFcvdlpqYUVUWmFxUEoyMHE1M294U2JGTnk2dVdZaklZ?=
 =?utf-8?B?dVBPak51R1dCcWQ5UGpHZWlLNFYyQmx1MWxQU2JMODA1aGdkeTc4blhsalo3?=
 =?utf-8?B?WUdROXd0UVV3OEZzWFZkcHNVWFNsTGFMeWZPTUxFMjhsd3lwWWIwSEJ1cVF2?=
 =?utf-8?B?TEFIMStXamdpYzlmalVVK1NjcERCdnduVlgrL3M5ZTBEMWFkNHZUeGJJbG5k?=
 =?utf-8?B?cWo4TkNXSmFZMzVFczVRMzFFU3IxaDFFdWNEVkZieUdpZmh5YlZkSkxQM01z?=
 =?utf-8?B?MmxIMXdtZjlDdy9DY0lyY0tneFJSNnFnR2VCK0ZxWHU4VE1PUGhBazY3TUtB?=
 =?utf-8?B?MkV1SUdFaEs5ZHkxMzlQZHFEVXErbU9jbi9Cc1lrVndKMHZOeHFreFZ1Z1RV?=
 =?utf-8?B?KzdUTkd4ZkNQTnZxYXRiV1pKMUtFV3pWQkI4d3hXaHlYMDROM21TeGNoUEE4?=
 =?utf-8?B?R012Z2tGY3NUZGJFZjUzK0lZcXpBRGtZQWNCQndOVURkc2pqZTF5d1ZiWVBx?=
 =?utf-8?B?NzJidk11M3hDMEV4YURweE12ekRFZkJoelZrZE9TTFBlWGZ2RGpNL0hyNHlD?=
 =?utf-8?B?QTgwdVFpWVFFVk9uWXp5TWpYTWVJTDRTdDNOV3dNRWZsNUVDRWNWYlZheFlJ?=
 =?utf-8?Q?9cJdqO5w/Mp2hLpzScDjhMA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	66KFVVTkC079U5IGvPcT1XqiDA9xMUdHQvKka/yULPOSHxfStnKETt+jbdONEcfzTRBGIuu61qfrjUg1If9NOzj8tnTKJZdykOOFYy144D2vtBbMPYa1CYbXjvPFcbbtSBIgMUgR6biOHKOdT0JvlwVHtqMm800JRZ4Q2vCreq9o9ww3o/t/MqdT+K660Z7CsUWBItOHVwKb1OyudZ2AIOHvIK/7eyTNe7P9fB6XB5kYnntMCz8vrC1Jw6/fM+QOR/40GavtkUSF3/AkrBVM3GAwJyJUubD/wcjQS2nfZiIG0UtaQ0iZU5pS8nqtZLNOBJSq9R/b+zDBqHIdQYSExnckZjML8YDjCeV4e7gOI3m/iAGL8MXzgf4RlL2YtwBzUSLbTXCwd0MMrZgnqSNs55Vw+mPZPp47Z2XCJaOIpPClC2M2HoHytB+85peLgIZTSmZ0xCbb+kztseUJJVBG2vs/VNV6gTXk8aRtOCAG8ZdsiHAO3YOfij9LB3HiFSe7hGqW2Bl3k9cWnQ5yvpjudtp2vB38bo4hHY5yALiAAYNAwRKWRJOLvjXcb8etmJ1zYsZ6T1EhQnlJpzBFvyeTtaOF9pXDtx8fPRiBAIVUwCk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6428ce-3e78-4dd7-b1d7-08dc54b55118
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 14:41:30.8736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RJaLKTcEAgb8FpPn4xBd5UeB4InU8bNL/uQs9j051AxMEnGl5uz1LCb5KTJI6LiaJvkWBV9CmNbnF1mU5uTNew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6742
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-04_10,2024-04-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404040101
X-Proofpoint-GUID: dAwAIDePxjK3s-rMAdZ1TUkmGBa-r6Cd
X-Proofpoint-ORIG-GUID: dAwAIDePxjK3s-rMAdZ1TUkmGBa-r6Cd



On 4/4/24 7:35 AM, Eugenio Perez Martin wrote:
> On Wed, Apr 3, 2024 at 6:51 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 4/3/24 6:18 AM, Eugenio Perez Martin wrote:
>>> On Thu, Mar 28, 2024 at 5:22 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>> Initialize sequence variables for VirtQueue and VirtQueueElement
>>>> structures. A VirtQueue's sequence variables are initialized when a
>>>> VirtQueue is being created or reset. A VirtQueueElement's sequence
>>>> variable is initialized when a VirtQueueElement is being initialized.
>>>> These variables will be used to support the VIRTIO_F_IN_ORDER feature.
>>>>
>>>> A VirtQueue's used_seq_idx represents the next expected index in a
>>>> sequence of VirtQueueElements to be processed (put on the used ring).
>>>> The next VirtQueueElement added to the used ring must match this
>>>> sequence number before additional elements can be safely added to the
>>>> used ring. It's also particularly useful for helping find the number of
>>>> new elements added to the used ring.
>>>>
>>>> A VirtQueue's current_seq_idx represents the current sequence index.
>>>> This value is essentially a counter where the value is assigned to a new
>>>> VirtQueueElement and then incremented. Given its uint16_t type, this
>>>> sequence number can be between 0 and 65,535.
>>>>
>>>> A VirtQueueElement's seq_idx represents the sequence number assigned to
>>>> the VirtQueueElement when it was created. This value must match with the
>>>> VirtQueue's used_seq_idx before the element can be put on the used ring
>>>> by the device.
>>>>
>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>> ---
>>>>    hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>>>    include/hw/virtio/virtio.h |  1 +
>>>>    2 files changed, 19 insertions(+)
>>>>
>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>> index fb6b4ccd83..069d96df99 100644
>>>> --- a/hw/virtio/virtio.c
>>>> +++ b/hw/virtio/virtio.c
>>>> @@ -132,6 +132,10 @@ struct VirtQueue
>>>>        uint16_t used_idx;
>>>>        bool used_wrap_counter;
>>>>
>>>> +    /* In-Order sequence indices */
>>>> +    uint16_t used_seq_idx;
>>>> +    uint16_t current_seq_idx;
>>>> +
>>>
>>> I'm having a hard time understanding the difference between these and
>>> last_avail_idx and used_idx. It seems to me if we replace them
>>> everything will work? What am I missing?
>>>
>>
>> For used_seq_idx, it does work like used_idx except the difference is
>> when their values get updated, specifically for the split VQ case.
>>
>> As you know, for the split VQ case, the used_idx is updated during
>> virtqueue_split_flush. However, imagine a batch of elements coming in
>> where virtqueue_split_fill is called multiple times before
>> virtqueue_split_flush. We want to make sure we write these elements to
>> the used ring in-order and we'll know its order based on used_seq_idx.
>>
>> Alternatively, I thought about replicating the logic for the packed VQ
>> case (where this used_seq_idx isn't used) where we start looking at
>> vq->used_elems[vq->used_idx] and iterate through until we find a used
>> element, but I wasn't sure how to handle the case where elements get
>> used (written to the used ring) and new elements get put in used_elems
>> before the used_idx is updated. Since this search would require us to
>> always start at index vq->used_idx.
>>
>> For example, say, of three elements getting filled (elem0 - elem2),
>> elem1 and elem0 come back first (vq->used_idx = 0):
>>
>> elem1 - not in-order
>> elem0 - in-order, vq->used_elems[vq->used_idx + 1] (elem1) also now
>>           in-order, write elem0 and elem1 to used ring, mark elements as
>>           used
>>
>> Then elem2 comes back, but vq->used_idx is still 0, so how do we know to
>> ignore the used elements at vq->used_idx (elem0) and vq->used_idx + 1
>> (elem1) and iterate to vq->used_idx + 2 (elem2)?
>>
>> Hmm... now that I'm thinking about it, maybe for the split VQ case we
>> could continue looking through the vq->used_elems array until we find an
>> unused element... but then again how would we (1) know if the element is
>> in-order and (2) know when to stop searching?
>>
> 
> Ok I think I understand the problem now. It is aggravated if we add
> chained descriptors to the mix.
> 
> We know that the order of used descriptors must be the exact same as
> the order they were made available, leaving out in order batching.
> What if vq->used_elems at virtqueue_pop and then virtqueue_push just
> marks them as used somehow? Two booleans (or flag) would do for a
> first iteration.
> 
> If we go with this approach I think used_elems should be renamed actually.
> 

If I'm understanding correctly, I don't think adding newly created 
elements to vq->used_elems at virtqueue_pop will do much for us. We 
could just keep adding processed elements to vq->used_elems at 
virtqueue_fill but instead of:

vq->used_elems[seq_idx].in_num = elem->in_num;
vq->used_elems[seq_idx].out_num = elem->out_num;

We could do:

vq->used_elems[seq_idx].in_num = 1;
vq->used_elems[seq_idx].out_num = 1;

We'd use in_num and out_num as separate flags. in_num could indicate if 
this element has been written to the used ring while out_num could 
indicate if this element has been flushed (1 for no, 0 for yes). In 
other words, when we go to write to the used ring, start at index 
vq->used_idx and iterate through the used elements.

If a used element's in_num and out_num == 0, then this element is 
invalid (not yet processed) and we stop the search.

If a used element's in_num and out_num == 1, then this element is valid, 
written to the used ring, in_num is set to 0, and the search continues.

Lastly, if a used element's in_num == 0 but out_num == 1, then this 
element has already been written to the used ring but not yet flushed, 
so ignore this element and continue searching.

There should never be a case where in_num == 1 and out_num == 0.

However, this would probably mean that before (or right after) we 
actually perform the flush we'll have to iterate through the used_elems 
array one more time and set their out_num's to 0 to indicate the element 
has been flushed.

Again, this is just for the batched split VQ case where we have to keep 
track of elements that have been written but not flushed and elements 
that have been written and flushed, given that we don't know which 
elements have actually been written to the used ring until the used_idx 
is updated.

This approach appears more costly though if we're really trying to avoid 
having this new used_seq_idx VirtQueue member.

>> In any case, the use of this variable could be seen as an optimization
>> as its value will tell us where to start looking in vq->used_elems
>> instead of always starting at vq->used_idx.
>>
>> If this is like a one-shot scenario where one element gets written and
>> then flushed after, then yes in this case used_seq_idx == used_idx.
>>
>> ------
>>
>> For current_seq_idx, this is pretty much just a counter. Every new
>> VirtQueueElement created from virtqueue_pop is given a number and the
>> counter is incremented. Like grabbing a ticket number and waiting for
>> your number to be called. The next person to grab a ticket number will
>> be your number + 1.
>>
> 
> So it's like last_avail_idx, isn't it?
> 

For the split VQ case, pretty much. Though if we hit this case in 
virtqueue_split_pop, we may get into some trouble:

if (!virtqueue_get_head(vq, vq->last_avail_idx++, &head)) {
     goto done;
}

However for the packed VQ case, last_avail_idx might not work in the way 
we'd need it to for this implementation. In virtqueue_packed_pop, we see 
this:

elem->ndescs = (desc_cache == &indirect_desc_cache) ? 1 : elem_entries;
vq->last_avail_idx += elem->ndescs;

It would appear as though last_avail_idx is incremented by total number 
of descriptors associated with the element, which can be greater than 1. 
This implementation increments by 1 for each element.

Actually... It's good you mentioned this because I think my packed VQ 
implementation is wrong. For packed VQs, vq->used_idx is incremented by 
the total number of descriptors in the flushed elements and not 
necessarily the number of elements being flushed like in the split VQ 
case. I'm adding elements to vq->used_elems in a per-element sequence 
rather than going by the number of descriptors an element holds, which 
should be the case for packed VQs.

>> Let me know if I'm making any sense. Thanks :)
>>
>> Jonah
>>
>>>>        /* Last used index value we have signalled on */
>>>>        uint16_t signalled_used;
>>>>
>>>> @@ -1621,6 +1625,11 @@ static void *virtqueue_split_pop(VirtQueue *vq, size_t sz)
>>>>            elem->in_sg[i] = iov[out_num + i];
>>>>        }
>>>>
>>>> +    /* Assign sequence index for in-order processing */
>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>> +    }
>>>> +
>>>>        vq->inuse++;
>>>>
>>>>        trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>> @@ -1760,6 +1769,11 @@ static void *virtqueue_packed_pop(VirtQueue *vq, size_t sz)
>>>>        vq->shadow_avail_idx = vq->last_avail_idx;
>>>>        vq->shadow_avail_wrap_counter = vq->last_avail_wrap_counter;
>>>>
>>>> +    /* Assign sequence index for in-order processing */
>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER)) {
>>>> +        elem->seq_idx = vq->current_seq_idx++;
>>>> +    }
>>>> +
>>>>        trace_virtqueue_pop(vq, elem, elem->in_num, elem->out_num);
>>>>    done:
>>>>        address_space_cache_destroy(&indirect_desc_cache);
>>>> @@ -2087,6 +2101,8 @@ static void __virtio_queue_reset(VirtIODevice *vdev, uint32_t i)
>>>>        vdev->vq[i].notification = true;
>>>>        vdev->vq[i].vring.num = vdev->vq[i].vring.num_default;
>>>>        vdev->vq[i].inuse = 0;
>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>        virtio_virtqueue_reset_region_cache(&vdev->vq[i]);
>>>>    }
>>>>
>>>> @@ -2334,6 +2350,8 @@ VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
>>>>        vdev->vq[i].vring.align = VIRTIO_PCI_VRING_ALIGN;
>>>>        vdev->vq[i].handle_output = handle_output;
>>>>        vdev->vq[i].used_elems = g_new0(VirtQueueElement, queue_size);
>>>> +    vdev->vq[i].used_seq_idx = 0;
>>>> +    vdev->vq[i].current_seq_idx = 0;
>>>>
>>>>        return &vdev->vq[i];
>>>>    }
>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>> index b3c74a1bca..910b2a3427 100644
>>>> --- a/include/hw/virtio/virtio.h
>>>> +++ b/include/hw/virtio/virtio.h
>>>> @@ -75,6 +75,7 @@ typedef struct VirtQueueElement
>>>>        hwaddr *out_addr;
>>>>        struct iovec *in_sg;
>>>>        struct iovec *out_sg;
>>>> +    uint16_t seq_idx;
>>>>    } VirtQueueElement;
>>>>
>>>>    #define VIRTIO_QUEUE_MAX 1024
>>>> --
>>>> 2.39.3
>>>>
>>>
>>
> 
