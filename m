Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB761CAA6
	for <virtio-fs@lists.linux.dev>; Tue, 26 Mar 2024 19:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711479734; cv=fail; b=PVB+i95QM6VDRvnRpJqbqvUWWfnrahrMHZeqGlxkVQD+2k5TZKvntGh6NH0aMcM26AsP0oND7Kq72sABrbXroMwyeO7lSW7wIjhZNAsoNTjmTtEX15DS8ldxIfdYjv/9Fdv7ZpqdqIOiUUpIB/YbraG/qlJ2gS8WuVtsE5C7HKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711479734; c=relaxed/simple;
	bh=QJEw2a8UTJIHu8lhG1TVF3jf8WHlSBOtpWrK3bDkhRo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rbN+kPwuLDOYC/NB6CGMiTmk+K19G3q95dZ/uNz0wzICuOjyy6xI2qVBZDJbfBSSEWB6WsGDDJQbXnDW5uf+5MOX8F0LCqwNSM9AMWdSGXB1+buImkcwg7zEr34z8nT3ns98FDPG5l8A4H0uZAogDXsmerT6Q/81R91/iWIdKgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iDuidUpn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=gfDpBaoV; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iDuidUpn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="gfDpBaoV"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42QIwwsd014356;
	Tue, 26 Mar 2024 19:02:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=eRfmUbNKwlIAGs3f3tDx2NeybP4RGyOUA5ItLkwhzq4=;
 b=iDuidUpnlUjVggGgCuGEqV7RVkMqjVlPDzaoxCZe68vARmdvhlLybTTl7RUTdYglxQji
 AevbT2QZMllX2yCPONHsAwEmntyBtiqD9bq1RvEBNruLtZELw5C1OdEJsZCaUHLhZmIT
 1/gqQaubcRYKDXUcoSHxAmL0QnYTZv2Aa61jmXXvtGuSp1vrjtcTbgl8GQhZRdLDo9sk
 emDcwg1k38QnIRRy3sbFsrqNthK8Fk5q5CLwqndMVsU/OWyxdfNDYuvQraZIAUmkYvUe
 /CHY8HC5ekrabqyggu92iBTUKupr2ybdzTow4oxxFDUME/itnaqkkc8PLSSG0L9+TLEo bQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x1ppunuc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 19:02:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42QI6eVM030916;
	Tue, 26 Mar 2024 19:02:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x1nhdqasw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Mar 2024 19:02:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIl2o4aDGmVpCqr+yeolBybdeVW59Eg0qL0dJa1GuO9y8RR7mJtfhyRV4ysyauFHSQR08xXkm/GKz8AOvFM/JUgM2scKvpitRyDSLk2qc5f1rzpGmIOj+UE/nFDumZQwq2I3igrvmDz/SYLL4Jwl42dkN9bfq8gsr9lc5xLY6YbdEUlVZpM5KXXi8mj6HU1DanMkLfQzXJIoBLZv3fHrjhgwO3+YlaWAgUpLykqGFXA3UUp+gR173oewMR0T9XKpmcVU28rjulzGtfMe+gfGJ29hKLIBevLJJj7JajBdnGUiEGMB+ZfWEoySzyvQN12ICkZZ8QdtldujIqRbN+oxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRfmUbNKwlIAGs3f3tDx2NeybP4RGyOUA5ItLkwhzq4=;
 b=Ye3+T5pESe2IHiCPH4smnr2sxroOFJ9Yl6ydeBf9oKJOKPsD2Q4XaKLBw222OkN2TmvIYe3H4ytamnUZriCsQTQOyKpE/25kfAQNwJNYta4QX+VeZRcvpJE4ZlMts0TtHFJtj3v0ZgD+B8kVY3VZwEbxRysle46ehVT0HgCaT5jLG4jdWJj3HJlZhF6ZZ/3JovsL3V98kVfBIlFuLKssFuVFPp6T/MjdFXij6QG+BrA+qTCuIUISht2jz7KFa17NR5SdQ28EfoP3A03niyTiQ9MyslFKd9TD6qIPSCfnApWk7GwwQZu0XAfJEbDyFCptvWlwC5364vI1ULukNnq+nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRfmUbNKwlIAGs3f3tDx2NeybP4RGyOUA5ItLkwhzq4=;
 b=gfDpBaoVMM75BUWTO5xZsbEroHRLOUtpnDYI9kU3LK03AbaO26T8c+xpYPYuFrOez5tYdnfEPzb9df5vzP6pxzKFVo4Uf+l/GmMQ2LvpMVs8O37ncCIn9lVe0Wg51sq+VaXj/v7w4+/IOyJ3qqQnAWOxfTY+9qaiwzi/TkdEIAs=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CY8PR10MB6513.namprd10.prod.outlook.com (2603:10b6:930:5f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 19:02:01 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 19:02:01 +0000
Message-ID: <ad9fb016-bd2b-4e75-8bcc-d361676aef5f@oracle.com>
Date: Tue, 26 Mar 2024 15:01:57 -0400
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
 <d435919b-ec5e-41d5-8bbc-354d027f67d0@oracle.com>
 <CAJaqyWcHokNf97uwE0=S56CK9cBpB54sF8cdW7+BhFc5VzBRUQ@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWcHokNf97uwE0=S56CK9cBpB54sF8cdW7+BhFc5VzBRUQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:208:256::11) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CY8PR10MB6513:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xb4B4ZAvv1EWTOz1XMjqZ2hPAgabR6wLIhLHioAnsdPP8q2aSWep3ljVw+P5GjqNCl2B06x4kKjcN8IFyDTxHts9/SvavgDLAxL+ww4QK1v5Ea2drPu20tTIJnhB2lZP7WnThNtFTuOLnCgQ0CZslhUVrzWyPZbh4GO2cvvJzR3dXMFUQqBxPVi/SiDqK2ExVhFkmgy9oJ0XPc+AMAa7OD2OhTIQpm2cDItFBmVN4Bzh+uhm5ePfTQXbQjvFSNidEuntjjo97S5/af8FUfAlYwz9cPATXspaNnFf+V1UTw6xQoW/0SFGL+V1lIUkDr4JrKLJovvICgLknW0Thdb8VVBce1rQaXt4hX8OC41Tr161X8aba6C7SXmnBMQWlV2Zn+YCwYN7+cVvtITnk1VeDA4PD4+h1eeOv+eMGRds/veoD5xU4DyI3E+fHUYw4MNPDY0EoB0u059/9wmbDLMec8zqE3K1/l5AS9DdtI5n0lvBJj7RDpgeIxdPLfUo12npz9dZwUU6glHhbWQ77q4bSENlTLnVAMUmMDNo7vfsVXPnyh1tOvRYWS3AwoPnBI8vwjiKsoVjwoVYo4BKnWAsgIwKJ0sG9kgGb3rjz5iSckwoyU332ngeHga5PFBOtCeIyERl6UuNKeVc1ayu+el/krDvuu/k1EIbaoL0krPmpVM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Tm82NlFhNWU5MVZEVEo4TWM5LzJnaVJlNXpJT3R5WHUwMVRZcnR4Y1lHOG9t?=
 =?utf-8?B?S0xZa3M4cURBM1VwdThKV3ZEZExVYmgxRW8vR1A1eVA0RzU2MW0zR3JFRGE1?=
 =?utf-8?B?dXVXQ3RxcUE1eERrWlcvUDFmVk02K2xIa2xyUlJ5eE1iSGhPb3hIdDJDZGRj?=
 =?utf-8?B?VEZtckZRWWcwdUtCb2JheW95SmJnYmMzQmJ4Y3lONUs2NFJTeUJ2NktiK3BP?=
 =?utf-8?B?RW1IOUwzaFUrV25wM2UrcXp5M2xQNnIxK1EzbFErQXFpOGFZYTVVMTEwSFlX?=
 =?utf-8?B?Wm1QUlBrNFVOUURpR2ZUTHJZZTdtaE93cHBmWGxYSGU2dGJJQkNkZDJqcFN5?=
 =?utf-8?B?S292NFcrbSt2OFVSNjBTQkI3UC92L2l0b1B1MW9BeFBleXFBVDhOZFRxejJy?=
 =?utf-8?B?WGp6bk5MZXFYT2h1Y0d1aE15LzZqdkJsN2creGcvYWJzcGdoSGRiaTkxbXdB?=
 =?utf-8?B?clpLMDNsaWV6RENPZVZVbEliQTlRRXFnY2lKT1N6bGl5VDV2RlhEcHBlRnBK?=
 =?utf-8?B?eHM0eXg4Qmd1dXl2Z0EvQ2dXcG0yRkEzdVBDeUdSOTF2LzY2aWtRaVFITHg2?=
 =?utf-8?B?R2JUb20ycFVoWnU5dC9lcFpZRTRTMDZVRE1BU08rY0xRdDdaTytSY1l0NFJz?=
 =?utf-8?B?VXdncGFPK1VKZjFVOWI2NHhaVW84ZnFPd2Zrcm56QVFWck9xMnVqSTh3WlFK?=
 =?utf-8?B?ckorV1hoeFhQLzZ1SUxtM0NqZDZaOERpQXBmN2lDQUtHV0NQV0VwSDJtNjhT?=
 =?utf-8?B?QlBqdS9WeGlUZnh1ODQ0bW9vVklzVEs5RkFXWjlkcVBSOFY5aTdzSURSVmhH?=
 =?utf-8?B?cDRBazBKNnNNVEE0cVZiK0xlbnlwc2lTemZNcWxWMU9wWG1YYXJDNVlsOVoy?=
 =?utf-8?B?ZjJnWjZlT0cwYkxmczN5VUZ5cXhOS1k4azVDeVBwanNzU251bDA5U0FndTlv?=
 =?utf-8?B?WWIzSHljTnJ4L1EyUVZyOWhQbnJzTXg3VmJFZ0R2Vzc4UGp1SEZzUHNaVkhO?=
 =?utf-8?B?aHd1emh3WjhFOTl4MzcvRDJ2dXVuN0ZUZ0Erc3JuaC9ab2JnTXdCT3Rjcklk?=
 =?utf-8?B?cXF2RTR6blpmMWdIUFNiY051ci9PNURxd3RwM29qSFdmMDFoSEFvN29CbWdh?=
 =?utf-8?B?bEh4ZGswVko1M084R0NRczlRejUzZjJwazJBazFsdXpSRENvZmV0YlgzeG5z?=
 =?utf-8?B?ODd4NE5NeEJLUlZTVThKWGZMRm9yUFMzUXAxdzRRV09QcUtmN0tiMWlWR0ZN?=
 =?utf-8?B?QXlIQ0pLeUVHYnVXdVpvcWNQZU5TeDdXcFZ0Zzc1anJadDg0NUZENjJGRnph?=
 =?utf-8?B?dEN6THJ0anVwenVMYTRqWVk1NWFFeUluZDE3OTIyTGUxcGd6MTlSRVVWTmlP?=
 =?utf-8?B?M3ZRSGpFT2F6K2hoS2pIMzJ1TkN6ZkQzZFc5V1FjOHQvdlVUMTAxWlBmNW1O?=
 =?utf-8?B?c040UlUvT2V1Qk5wL05kbzgrbFBwakFrNWhsTFhHV3pSVnVRNXRTNVdFdHJW?=
 =?utf-8?B?clBrVEZ6WHRyZ3lhTW56ZnlLT2ZCajhrMWx3ZVltSWh3YnJkaFg0YVYwVEZ2?=
 =?utf-8?B?bE5vU1ZrMFJxR0hKdGhGRFBFOTRsci81R1VTS2ZyL245QjJJZnUyZXB1Sk9m?=
 =?utf-8?B?OVFLUENWR1lTUGxZb25xTHI4MDhDSGQzU0I4L3dUUCtkRm81TDQyTllOb1Y3?=
 =?utf-8?B?ZDNRa0padTE2RHVTK0JuKzUwOW1pQVVjZE90ZXF4R2laZW9WZE9mb3pvT2cx?=
 =?utf-8?B?bXhLR3k3bDZXTC9jZlJFZnpjTlh3cG15TTluQndJWk5zYlh6Z1FLa3FWbzVx?=
 =?utf-8?B?bm1sdUJuaVVkU2FEL0NNVkQ3Lzl1TGRCOThNRVQrU3U5akowOWkxSmI2dC9a?=
 =?utf-8?B?NjRUdHF2dVE5VW5tQnYzZkg2MVp5dUFCWHlNcmRnRlRETy9ocVhscVZIMTZo?=
 =?utf-8?B?WnNQTFRjNHRJdUZ2ZFl4VjdPa0NnQVcyODhrL1BZQldTYmJMMldEaWFtZWc1?=
 =?utf-8?B?Tm9JVHJPZW1kN1lIaVBXSjZWNkhxTm81RjdJTjZnTEZ0NkdkdFFyam56akZP?=
 =?utf-8?B?VlRMbGI0U1R2U0JHTmVkNHI5Y3hWWjRocExDVGNFQkZ6TTN0WGZYTTdzcjl0?=
 =?utf-8?B?enczUUZCRWhvQjJwQTZUcEd6SUhSWkRlMkVRYTZUK2diczhmTlh6VVY1QVAz?=
 =?utf-8?Q?HLKhXTWezO77iI1WcTFPw5I=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jwe3T5ISY5529DzQZPuChi6ivqfdPkfnfvY8Jialu4a161mmbs8m9Kk20nlEUsma0yEk5XWxp+6elxnnsk4sakUzp2q9uM0vkW3i+Sp28xEKpeQn9yXsuR3mE7r3p9rrfnF5VhjYZ1Pw//pCEhIjufNpzfrgnjhfD19381GeSG9pokeRCF3rlxcRxmyG2DGdGoX0OaRKUl4YoKMySP8uTOVFbEjlKpjuU3Z1guggHorO78yvJwGP8P9dU4f/YQsyymVdoL9b64wBOZ6o6AL/dqjj44boVoBjHGbnYThl5eOPhVwsf9sAY5llHEBhN6/3432Pal6yJR30pWhOvLChn/fow7+qhtKfRFI0FtE3eq/uIoh8l/aEVnMuUUhupG0L4aTR7mlXEe5kpXe1qE4WtOzU2t0CDL3J+y3o8KCX9957ixuOP2ewXzYTbo9bruyIi/D3mCPQ3QS6kJ7g+CRaFvrWNoh1zYRIq7FnFlqtAj6RfpuxXgUkrgdB8Cd3raEqCy5qC45eSMIbzRXYpAFRvo0qlb5W5OJMvALlCfXS24R71SUpzTcuP2QhJKrT+EQs0gdZdFsd/Cs5/ckSrWsxHon4JtOE/f4i0ux1lv5EdSQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bbd66e-a05d-4288-ad00-08dc4dc73811
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 19:02:01.5514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NfTGMw5xKEuzlXSQZcR38VfHSHfPgNj5W1Wu7yBTnrSUrc7JFNBHpYCRHaD8niAsh+AsrYELYX/h5VQktzsKsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-26_08,2024-03-21_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2403210000
 definitions=main-2403260136
X-Proofpoint-ORIG-GUID: cpYjfjhL5yVj92az5k0vlpVNzhkVwTJC
X-Proofpoint-GUID: cpYjfjhL5yVj92az5k0vlpVNzhkVwTJC



On 3/26/24 2:34 PM, Eugenio Perez Martin wrote:
> On Tue, Mar 26, 2024 at 5:49 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 3/25/24 4:33 PM, Eugenio Perez Martin wrote:
>>> On Mon, Mar 25, 2024 at 5:52 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>>
>>>>
>>>> On 3/22/24 7:18 AM, Eugenio Perez Martin wrote:
>>>>> On Thu, Mar 21, 2024 at 4:57 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>
>>>>>> The goal of these patches is to add support to a variety of virtio and
>>>>>> vhost devices for the VIRTIO_F_IN_ORDER transport feature. This feature
>>>>>> indicates that all buffers are used by the device in the same order in
>>>>>> which they were made available by the driver.
>>>>>>
>>>>>> These patches attempt to implement a generalized, non-device-specific
>>>>>> solution to support this feature.
>>>>>>
>>>>>> The core feature behind this solution is a buffer mechanism in the form
>>>>>> of GLib's GHashTable. The decision behind using a hash table was to
>>>>>> leverage their ability for quick lookup, insertion, and removal
>>>>>> operations. Given that our keys are simply numbers of an ordered
>>>>>> sequence, a hash table seemed like the best choice for a buffer
>>>>>> mechanism.
>>>>>>
>>>>>> ---------------------
>>>>>>
>>>>>> The strategy behind this implementation is as follows:
>>>>>>
>>>>>> We know that buffers that are popped from the available ring and enqueued
>>>>>> for further processing will always done in the same order in which they
>>>>>> were made available by the driver. Given this, we can note their order
>>>>>> by assigning the resulting VirtQueueElement a key. This key is a number
>>>>>> in a sequence that represents the order in which they were popped from
>>>>>> the available ring, relative to the other VirtQueueElements.
>>>>>>
>>>>>> For example, given 3 "elements" that were popped from the available
>>>>>> ring, we assign a key value to them which represents their order (elem0
>>>>>> is popped first, then elem1, then lastly elem2):
>>>>>>
>>>>>>         elem2   --  elem1   --  elem0   ---> Enqueue for processing
>>>>>>        (key: 2)    (key: 1)    (key: 0)
>>>>>>
>>>>>> Then these elements are enqueued for further processing by the host.
>>>>>>
>>>>>> While most devices will return these completed elements in the same
>>>>>> order in which they were enqueued, some devices may not (e.g.
>>>>>> virtio-blk). To guarantee that these elements are put on the used ring
>>>>>> in the same order in which they were enqueued, we can use a buffering
>>>>>> mechanism that keeps track of the next expected sequence number of an
>>>>>> element.
>>>>>>
>>>>>> In other words, if the completed element does not have a key value that
>>>>>> matches the next expected sequence number, then we know this element is
>>>>>> not in-order and we must stash it away in a hash table until an order
>>>>>> can be made. The element's key value is used as the key for placing it
>>>>>> in the hash table.
>>>>>>
>>>>>> If the completed element has a key value that matches the next expected
>>>>>> sequence number, then we know this element is in-order and we can push
>>>>>> it on the used ring. Then we increment the next expected sequence number
>>>>>> and check if the hash table contains an element at this key location.
>>>>>>
>>>>>> If so, we retrieve this element, push it to the used ring, delete the
>>>>>> key-value pair from the hash table, increment the next expected sequence
>>>>>> number, and check the hash table again for an element at this new key
>>>>>> location. This process is repeated until we're unable to find an element
>>>>>> in the hash table to continue the order.
>>>>>>
>>>>>> So, for example, say the 3 elements we enqueued were completed in the
>>>>>> following order: elem1, elem2, elem0. The next expected sequence number
>>>>>> is 0:
>>>>>>
>>>>>>        exp-seq-num = 0:
>>>>>>
>>>>>>         elem1   --> elem1.key == exp-seq-num ? --> No, stash it
>>>>>>        (key: 1)                                         |
>>>>>>                                                         |
>>>>>>                                                         v
>>>>>>                                                   ================
>>>>>>                                                   |key: 1 - elem1|
>>>>>>                                                   ================
>>>>>>        ---------------------
>>>>>>        exp-seq-num = 0:
>>>>>>
>>>>>>         elem2   --> elem2.key == exp-seq-num ? --> No, stash it
>>>>>>        (key: 2)                                         |
>>>>>>                                                         |
>>>>>>                                                         v
>>>>>>                                                   ================
>>>>>>                                                   |key: 1 - elem1|
>>>>>>                                                   |--------------|
>>>>>>                                                   |key: 2 - elem2|
>>>>>>                                                   ================
>>>>>>        ---------------------
>>>>>>        exp-seq-num = 0:
>>>>>>
>>>>>>         elem0   --> elem0.key == exp-seq-num ? --> Yes, push to used ring
>>>>>>        (key: 0)
>>>>>>
>>>>>>        exp-seq-num = 1:
>>>>>>
>>>>>>        lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>>>>>                                                 remove elem from table
>>>>>>                                                         |
>>>>>>                                                         v
>>>>>>                                                   ================
>>>>>>                                                   |key: 2 - elem2|
>>>>>>                                                   ================
>>>>>>
>>>>>>        exp-seq-num = 2:
>>>>>>
>>>>>>        lookup(table, exp-seq-num) != NULL ? --> Yes, push to used ring,
>>>>>>                                                 remove elem from table
>>>>>>                                                         |
>>>>>>                                                         v
>>>>>>                                                   ================
>>>>>>                                                   |   *empty*    |
>>>>>>                                                   ================
>>>>>>
>>>>>>        exp-seq-num = 3:
>>>>>>
>>>>>>        lookup(table, exp-seq-num) != NULL ? --> No, done
>>>>>>        ---------------------
>>>>>>
>>>>>
>>>>> I think to use a hashtable to handle this has an important drawback:
>>>>> it hurts performance on the devices that are using right in-order
>>>>> because of hash calculus, to benefit devices that are using it badly
>>>>> by using descriptors out of order. We should use data structs that are
>>>>> as free as possible for the first, and we don't care to worse the
>>>>> experience of the devices that enable in_order and they shouldn't.
>>>>>
>>>>
>>>> Right, because if descriptors are coming in in-order, we still search
>>>> the (empty) hash table.
>>>>
>>>> Hmm... what if we introduced a flag to see if we actually should bother
>>>> searching the hash table? That way we avoid the cost of searching when
>>>> we really don't need to.
>>>>
>>>>> So I suggest reusing vq->used_elems array vq. At each used descriptor
>>>>> written in the used ring, you know the next head is elem->index +
>>>>> elem->ndescs, so you can check if that element has been filled or not.
>>>>> If used, it needs to be flushed too. If not used, just return.
>>>>>
>>>>> Of course virtqueue_flush also needs to take this into account.
>>>>>
>>>>> What do you think, does it make sense to you?
>>>>>
>>>>
>>>> I'm having a bit of trouble understanding the suggestion here. Would you
>>>> mind elaborating a bit more for me on this?
>>>>
>>>> For example, say elem0, elem1, and elem2 were enqueued in-order (elem0
>>>> being first, elem2 last) and then elem2 finishes first, elem1 second,
>>>> and elem0 third. Given that these elements finish out-of-order, how
>>>> would you handle these out-of-order elements using your suggestion?
>>>>
>>>
>>> virtqueue_fill is called first with elem2. So vq->used_elems[2 %
>>> vq->num] is filled with the needed information of the descriptor:
>>> index, len and ndescs. idx function parameter is ignored.
>>>
>>> Optionally, virtqueue_push is called. It checks if
>>> vq->used_elems[vq->used_idx] is valid. valid can be elem->in_num +
>>> elem->out_num > 0, and reset them on every used ring write. If it is
>>> not valid, this is a no-op. Currently, it is not valid.
>>>
>>> Same process for elem1.
>>>
>>> virtqueue_fill is the same for elem0. But now virtqueue_flush gets
>>> interesting, as it detects vq->used_elems[0] is used. It scans for the
>>> first not-used element, and it finds it is vq->used_elems[3]. So it
>>> needs to write an used elem with id = 2 and the corresponding length.
>>>
>>> Maybe it is interesting to implement ways to improve the look for the
>>> last used descriptor, but if any I'd go for a bitmap and always on top
>>> of the basis series.
>>>
>>> The algorithm has not been tested, so maybe I've missed something.
>>>
>>> Thanks!
>>>
>>
>> Thank you for taking the time to clarify for this for me, I appreciate it.
>>
>> I spent some time yesterday and this morning working this over in my
>> head. I believe I understand what you're trying to do here and it makes
>> more sense than employing a data structure like a hash table for this
>> kind of job. However, I have a few questions regarding this implementation.
>>
>> So, one question is on the reuse of the VirtQueue's used_elems array.
>> Wont reusing this array cause issues with packed VQ operations, since it
>> also uses this array? If we want to stick with using this array
>> specifically, perhaps we may need to rewrite its logic if the device has
>> negotiated the in_order feature? E.g.
>>
>> virtqueue_packed_flush (...) {
>>      if (virtio_vdev_has_feature(vdev, VIRTIO_F_IN_ORDER) {
>>         // new logic
>>      } else {
>>        // current logic
>>      }
>> }
>> -----------
>>
> 
> That's right.
> 
>> Regarding this paragraph:
>>
>> "virtqueue_fill is called first with elem2. So vq->used_elems[2 %
>> vq->num] is filled with the needed information of the descriptor:
>> index, len and ndescs. idx function parameter is ignored."
>>
>> This looks exactly like virtqueue_packed_fill except for the idx
>> parameter we'd pass in (sequence_num % vq->vring.num).
>>
>> In any case, regardless of whether this element being passed in is
>> considered to be in-order or not, we still add this element to
>> vq->used_elems in virtqueue_fill. Ok, got it.
>>
>> Then you say "Optionally, virtqueue_push is called". I assume by
>> "optionally" you mean we need to know if this is a single-shot operation
>> or a batched operation. A single-shot operation would call for
>> virtqueue_push whereas a batched operation would just use
>> virtqueue_fill. If this is what you meant by that then ok, I understand
>> that too.
>>
> 
> Totally correct.
> 
>> However, I think before we start considering whether or not we need to
>> call virtqueue_push or continue with virtqueue_fill, we first should
>> know whether or not this element is in-order. And I think to do that we
>> should use the check you mentioned:
>>
>> if (vq->used_elems[vq->used_idx].in_num +
>> vq->used_elems[vq->used_idx].out_num > 0)
>>
>> or perhaps:
>>
>> if (vq->used_elems[vq->used_idx] != NULL)
>>
>> If the element is found not to be in-order, I assume we return and we
>> are done with the handling of this element for now.
>>
>> Now my confusion with this part comes from calling virtqueue_push inside
>> of the virtqueue_fill function. Wouldn't calling virtqueue_push inside
>> of virtqueue_fill present some kind of recursive execution path? Unless
>> I'm missing something here, this probably isn't something we need to do,
>> right?
> 
> Maybe I explained something wrong, but virtqueue_fill should not call
> virtqueue_push. It's up to the caller (virtio-net, virtio-blk, etc) to
> call one or another. Can you elaborate?
> 

Oh I see, my apologies! I misunderstood and thought you were suggesting 
to call virtqueue_push inside of virtqueue_fill.

>> -----------
>>
>> Lastly, when execution reaches virtqueue_flush, what would define an
>> element as unused? Perhaps...
>>
>> if (vq->used_elems[i] == NULL)
>>
> 
> used_elems is not an array of pointers but an array of
> VirtQueueElement so we cannot do this way.
> 
>> or
>>
>> if (vq->used_elems[i].in_num + vq->used_elems[i].out_num > 0)
>>
> 
> Right, I propose to reset both in_num = out_num = 0.
> 
> Thanks!
> 

Gotcha. I'll take this and work on getting a v2 RFC out.

Thank you for the re-clarifying things again Eugenio!

>> Thanks Eugenio!
>>
>>>> Thanks :)
>>>>
>>>>> Thanks!
>>>>>
>>>>>
>>>>>> Jonah Palmer (8):
>>>>>>      virtio: Define InOrderVQElement
>>>>>>      virtio: Create/destroy/reset VirtQueue In-Order hash table
>>>>>>      virtio: Define order variables
>>>>>>      virtio: Implement in-order handling for virtio devices
>>>>>>      virtio-net: in-order handling
>>>>>>      vhost-svq: in-order handling
>>>>>>      vhost/vhost-user: Add VIRTIO_F_IN_ORDER to vhost feature bits
>>>>>>      virtio: Add VIRTIO_F_IN_ORDER property definition
>>>>>>
>>>>>>     hw/block/vhost-user-blk.c          |   1 +
>>>>>>     hw/net/vhost_net.c                 |   2 +
>>>>>>     hw/net/virtio-net.c                |   6 +-
>>>>>>     hw/scsi/vhost-scsi.c               |   1 +
>>>>>>     hw/scsi/vhost-user-scsi.c          |   1 +
>>>>>>     hw/virtio/vhost-shadow-virtqueue.c |  15 ++++-
>>>>>>     hw/virtio/vhost-user-fs.c          |   1 +
>>>>>>     hw/virtio/vhost-user-vsock.c       |   1 +
>>>>>>     hw/virtio/virtio.c                 | 103 ++++++++++++++++++++++++++++-
>>>>>>     include/hw/virtio/virtio.h         |  20 +++++-
>>>>>>     net/vhost-vdpa.c                   |   1 +
>>>>>>     11 files changed, 145 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>>
>>>>
>>>
>>
> 
