Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9B07A73A
	for <virtio-fs@lists.linux.dev>; Tue, 12 Mar 2024 15:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256035; cv=fail; b=jJIqzoq7k6EpVQxKbwGA8d5e+P9dEMrnOpWH5zB8bCY4LWK7f52Ah7Nxvrzw8FIls8b0apcixdmh930ipznrtqAUZFeYh2VXHEVD55Zr2lM8mNMIGJu7QpoCPkpPjUoGQ7KXTmBEKUHeru93O4MZaJB5G5uFbNaHsCYwS41Nh9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256035; c=relaxed/simple;
	bh=S431ZxAYLzDRJq6Xqp8oanQf0Q5J74WlNC0Y9kYcqrQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kj9YwKozFQuTWCNDf6uAl4zNRw18tm7sGwdCXSbGCePNXhjnn0VkD8TJcSzfVjCFEWJCqUG1kp8K6DkrM7SxB31s6La0WL69y4HfgvFYIvZVKwfRFU8osEokj9kk1Dgfwd7Ktgrqr5+PmqeCvTkz0T5jiSIw3hWmF6OUPDHtbto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DfMbLr7m; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gf+Kwicu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DfMbLr7m";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gf+Kwicu"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42CE6Ob5015882;
	Tue, 12 Mar 2024 15:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=3AsiO6xc7RIgjgxq9yeMLwIZEE49uj8UHOHr3tIEgrk=;
 b=DfMbLr7mpzSsD17wrjwAzXwUABRaoRQgVK4+T8jDBlioxnq8paNc80XzD+ztml0CDIxd
 7wZaL0AlhbY4lYzSftd1akCyA4vSAAgTfRNBaITzIThJpmMMzsR+MWA9GDTCZ0/1L9z2
 dUlBWoFJDxi9tmOIlCS8YQOJ27bNam9YEYc2VFyWS/Njhtm3hUIgJSmlnHa+/s88sSq0
 29rhjnvQNliOgEkq3HGbpdxCM/mE9J9h608oFw1/HYbu4B0DGhfRmjMi+uKsTesH6nzZ
 0G0aTIH53d/Rsh1k1i3Asd/ycdcpF+7kRZHLPyxw9o+R3Arnnjx+Q+btnr0izMsT1UIE PA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrepcx6fa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 15:07:05 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42CEa9km033777;
	Tue, 12 Mar 2024 15:07:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre773ta0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 15:07:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlwWW/W114Wip10oULgb9/gRp7wVi3F3roOIoMEge3L2BfWcnpmRD9IbdswglEzT2I7vuRNLGu+BdgaCAQqucnkpqSz2S1WEl4SLDSewwOEV0anoAVVcY2zzUezCDisC/JKYEh5M0InTowDQl5AeaNGVkUEGiJZRFSzkAVbyBG5I/XCJzOVPNvCjCGK6r+cgnPiWAbQCVipbTKGRvudhvZ/g77we/2Xstt/Sgebmn8Dhw01m6IGakMLPLlJUhxN8bbux3Fqf/LVTrFeDRIVnedAk83qLQKuyY29nZYwZTso+Z7UgP9LUs/yI0VBl8n6yuuNyFZx0HAzrlsKVa0lYgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3AsiO6xc7RIgjgxq9yeMLwIZEE49uj8UHOHr3tIEgrk=;
 b=nGVNaNk284s7scu8Zb1BXXgg7N0Z4MaCuJezInD8wvWZLpWaB0YIj3pNY1PuM4mdc1r4l4p7cT73DFE5Jam7piRJL2O6HfCQzX2pOqn0AmihNrzmlvWGPuGKacvkkox4VlL5dGbOjzXCUvIf1YD8ztpTOCXVvzrPVHDjqgGnUTNiJxpPXq64xmpUfOalHhQROwJnkOcvIgV2ReI5ow2sISKalrjfohS5fFbKWFvk9tSZ68YVxEoPAGJeu7vGTSOxnmDvFghhUZTVd1NpCQzYlUy7MJcO3vZ3uouh+1NngOZcZu5Kg/SPTJRS8p5qRrbOzVl2SnAzHqSfkZaasc5Miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3AsiO6xc7RIgjgxq9yeMLwIZEE49uj8UHOHr3tIEgrk=;
 b=Gf+Kwicu35qt8crX+n4ZRxxrNOlQIHqO5CMkOWa+JtNFndkUdMwtdMdYAZJWXG5Crsdv9kR5bjn2H/VeJ47guMB1gK6M7X/oi1t/Xm0sBku2LUNne1mKTCmLcWZUbcLjH86L/xXriPRfYB4zUMrprXvAUFnb44y+0CH+HpQ2ln0=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by IA0PR10MB6793.namprd10.prod.outlook.com (2603:10b6:208:43b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.35; Tue, 12 Mar
 2024 15:07:01 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 15:07:01 +0000
Message-ID: <37e871fa-6837-437f-acad-789fe466260b@oracle.com>
Date: Tue, 12 Mar 2024 11:06:48 -0400
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
 <fc09c190-ff37-47a0-96a2-6b364e04d334@oracle.com>
 <20240311114638-mutt-send-email-mst@kernel.org>
 <c7a91e57-04eb-4ed1-8bb4-1d1b05894c8a@oracle.com>
 <20240312105706-mutt-send-email-mst@kernel.org>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <20240312105706-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0306.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::11) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|IA0PR10MB6793:EE_
X-MS-Office365-Filtering-Correlation-Id: 55f5e5dc-effc-47ac-8e74-08dc42a6120d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	118mIlMW39ceQJmsEYpvmsZPIJagg6a4QmEirdWEqsjpkBYc3860+hGqp6P6gq4Vq5+1xKu/KRExaXdWSLu1XIhAMl3j+SdVuji/tc2yznhKZpR12Jautmw1Z3E8dKGTewbZ7mF/XNAzp6vk4/6DhUJF8MFuo/d/lbm/S7NJd13jd7pLyOP2QPP1qGC32ZGP9mBFMnUW1gFC9D0yjZno5VWhVv8eomUBc8h248G0U8LkDUIr3FfJSUK3RxUjUsBNuFJkJKZI+D4SHTPAMGg2kYNIJyD1Tl3gOPR1SkQHN8oI8euQCd+a2K4pruIfDT+g23AZMY0bgE8o8uspxiRdLMgtFyyOpg8vbEJvYaqoTk/JWZPwKi+Ik+G/QtTfdVnJCZgmuVRjP26YIeIz445YSlzvuHwygb9iip+/BngRrDKG8d2zuSc6uQuA5dawmsKEq/zLKdY+eeLA/QXWxJYKFERiemJufttq52bU/E/YtDeQiMsTEdOm5imQ+a0S/pDyit/aYajrbI0a0WiiSJ3hAfbPGP9pTHbLstYlbN0ZilgfuoW9tdTjql3rSHhSXqClQknB0azMN0SYgZaTFWw2BWVd8TuNQFYsnNovstkiphs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Q1ZYamorQy9DUWR0VDhiQkhBV3Q2YUJHYmYrNGtNUys0VUVWQkFaM3d6YWRZ?=
 =?utf-8?B?bHNaaVRRVTA4NCt6TlRFditnSjFMSGZ5Z0JQQUJDNi9TVWxjbTQybzFGV29D?=
 =?utf-8?B?ZklYMWI3UjQ0RGdDa2pYSS80TDdyVmp0cDhoN1VjVG5wbXBRbUFSL1A0bHlr?=
 =?utf-8?B?MkNEcXY2OHh0a0VocEhJNnJIVUN3RDc0UFhzRG1ucHJBc3JIU0JMdlRzS2V5?=
 =?utf-8?B?R3NHZFBjdWpFVy9TbHNubDc3cnpzTnIra2FoY1BCcXZtdE1RVFFpRHR6Vnpq?=
 =?utf-8?B?Mms5OFRkYngwVFhTVllYYjFVQ0ZNbnE5bFpscnV5RWcvZU8rempZaHVJTm9h?=
 =?utf-8?B?SW5Ta1ROamlrR0N4eVFIM2djcmFSTithLzI5SmVXWTRyb1EzWkw4RFlKbzNx?=
 =?utf-8?B?Z2RaZ3EzZ0dYUDViblh6QjRac3FLVUJ1NWpBSU8wYTNLWjlHNUx4NFZXUUNL?=
 =?utf-8?B?S2xFRFNzZTdaSldRVGJiTWk3RGI2bzRHeldvb2crZkVacHJ6bEVZaDREWGRT?=
 =?utf-8?B?aFllL2ZobUwwNWRmQmtWK2ZQVVhQY1JhVER0bitJaGE1dHV4MG5XMkQ4Vlkr?=
 =?utf-8?B?YndFa0VkT1dCNWRZT1M3bkZTL0JaMWlCQnJOOWEzeERGUEdTS21ReFYrd011?=
 =?utf-8?B?S1I0andmSkF2MGludmRYbjBmQjdUNGp1a24wMjRjdEEzYnc2cU9kYmJuMU1n?=
 =?utf-8?B?NHYxaTdhVjVBNEhmUjZXdG42SHJIYzAwWUxVZ3F0QnRRRU5tSW1iMVhnYkRX?=
 =?utf-8?B?QXpYMFlFb0FaUUt6SVQ1OWtGaThpbERkMUZoNjl6VVBYdFJEcTlKbFFUK2NR?=
 =?utf-8?B?di9UeFlMOUgyVlJKZ2VHZTRIa3diOUc1SEpXNnhXbVVpOGI4dUZuUVI2UFhi?=
 =?utf-8?B?Uy80eVV0S3VXeG9oZ0JwZzlaRE53eVZqV3VmY3NFdFZueW5MSXhka3ZaZlAz?=
 =?utf-8?B?MGprc2RsTWg5cHZ0aXBDSTBGb09lKytVQTlKYWwrRUlKbHhoVHgvVCtYVy94?=
 =?utf-8?B?TUgxM0NQaEFBWnlwWjBHRU00RVJyUWpGMVZNWC9MbVlIZlhxR1dNekI3dVky?=
 =?utf-8?B?ZkFIQXgvcEc5eS9Tbzdxd3p2S1pERTJzdnAycG43WlBneHlIL3o4ZzhJZjZO?=
 =?utf-8?B?NmJlTHRyaDAya0lEV1Zlc3Y5aE9sNktHY09YckhOMHE3Z1lSWUJKTlVuZG10?=
 =?utf-8?B?Rm1ESW5wWXI5aEFUOFhGWVprR3ZSM0xKQzhzNllaY1Z3UGhpTHZ2ZlFJU0hz?=
 =?utf-8?B?ZWJoUDJOc21sRE1XeFJ6UGNmaFRVYTBGUmRPRThuQUgydjhBODdrMkZvWU1p?=
 =?utf-8?B?azZVY2F0WVpBWWpLdXNONmVDcmNmYzNYRHhVdGNCWFVRbHFOdTB2aWxaeXBM?=
 =?utf-8?B?TkJXbGszSnVvK0JxRVkwNmtsSkhnTGVuY2hrRFpBM3lyd2Jnb1FhNUV1aElU?=
 =?utf-8?B?QmdEeVlHVTJlQlQyV054QXh3dXo2V053WmJpalhHdVV2L0ZDKzhFa2p1SWFl?=
 =?utf-8?B?RWxabEFub25aNGdXdHVZbEF4ZjJUS3ZrNmczdlIyRjJzOGpVdHE5dU9tR1RC?=
 =?utf-8?B?ZWl5VFZ1V1pETVpDRXVJTk1LWmE4aWxMRzkrUEtPbngydWxTVGJrMmdOd2lH?=
 =?utf-8?B?ODhHQnIzUTBNV0JGUjVwRHg2eTZaN3BnZTRodUxjL2FEWm1Qb3drOTkydXN1?=
 =?utf-8?B?V0FTZ1o1UEp4ZWdoQlVCMWdYaldSUmJ2ZzNaV0xpZUgrSGU1Q3hlQWJGdVMx?=
 =?utf-8?B?ZU1pVTlXem5kdUdCS05lRkZnNGZPTlV0UVQ0WWRiNGU3cFdxWGpDODdvM3Uz?=
 =?utf-8?B?alZlbFZTRW5tS3hoZE9DL3JFVjJGS3dPei9VaGxMZ3lLaDJtU0sxZnphOVZL?=
 =?utf-8?B?bk1FalFvTWFCdzkrM3dkdEcrNFpaSzY0clJWaWZnUy9JTUZiakJwc1UrcFJM?=
 =?utf-8?B?NFBXelNzakxtSkRzUkhKL0RSVTJIOC82eXJBVWk1WlQyKzZwa01kdVk2V3pL?=
 =?utf-8?B?RmVTNUY5Nm9PS0x1ai9Id0MzRHorZ2xNd2pqV2xIUUF3RTR6OWR6N0tLRlRW?=
 =?utf-8?B?SDZFM3dtcU9raEFtcHRjSG1rM1Q4dWxNTnI4SGwrZ2F1R3FBOWRzdmkvL3lB?=
 =?utf-8?B?QmJMcEx3Z1RSdlRIZDQ3dGxKV1dia0x1Sm9ocW5IVVhHdTZVdEVmOEoxVlpn?=
 =?utf-8?Q?0PCdBwy/A8Qdz6rcWSC84M8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jLZRh6m/j54RuVaWL8O+SXzG5cgLpBK8TDUCN95Mj3DUfR99ZSOPxpQ1+xHGnVy+WXRxBXswZxl2xv8VIvrWbMlM5qVwu7N2zw9nWQTuWjOW+QHfO82xmv+u1Ti0zs4CsvkXVbALplCa4XCk3eZC3yB8IOru81MDIIs+iYrU/6JFaA3fjwp5dpuzND09V2xcuIlKuobIDBMNJfcqUQmewbFPKjLvUtC5jaLxCby1cfe1KJsF8EBCWahx0d9Mt6kzobSN4cvgwInugbM4FqNnJB9vG/hIc6WZmMHjvEV9B93QSvSOf234hhWsQv31ySyW4s/KerAAJA/bxcNCagUnSuXQQ3yZ8W8yA8dhWpxRrvH/bHFaJEE/YsuOaJiJFZYngSmD+fAI2CNPp7BxZq7p/IGKz8t6eW92LaP59+mQtegDqul3ux05r1KqVzCvswKdeotZNfpvoxIvc7YhQTKEdwejSzHbtJCZAIXTIutYwQIdnd3mH9zXjQCeYHRUKeZaWCO1E9kcY7y6xrAMaxt48ffeRAwdL8Gr142sFARZmmw/dZeA3T1iZqP3z7gE04mEHi+VcPWFnTX2xC3pjvPp1LDbKYWKXODpez/3cwo+Xsc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55f5e5dc-effc-47ac-8e74-08dc42a6120d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 15:07:01.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1a08Y7LwJSgirDn26ikka1TWC6XPaC5fV0Tq9xuDVR550LvenRmn/kMmyojFcVjG9suvY2dd4cLD5NZI+mcvpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6793
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-12_10,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403120115
X-Proofpoint-ORIG-GUID: 0gqjlOIYneyHv1bsqLPjjSgUc65C0alC
X-Proofpoint-GUID: 0gqjlOIYneyHv1bsqLPjjSgUc65C0alC



On 3/12/24 10:58 AM, Michael S. Tsirkin wrote:
> On Tue, Mar 12, 2024 at 10:33:51AM -0400, Jonah Palmer wrote:
>>
>>
>> On 3/11/24 11:47 AM, Michael S. Tsirkin wrote:
>>> On Mon, Mar 11, 2024 at 10:53:25AM -0400, Jonah Palmer wrote:
>>>>
>>>>
>>>> On 3/8/24 2:19 PM, Michael S. Tsirkin wrote:
>>>>> On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
>>>>>>
>>>>>>
>>>>>> On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
>>>>>>> On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
>>>>>>> wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
>>>>>>> wrote: > > Prevent ioeventfd from being enabled/disabled when a
>>>>>>> virtio-pci > > device
>>>>>>> ZjQcmQRYFpfptBannerStart
>>>>>>> This Message Is From an External Sender
>>>>>>> This message came from outside your organization.
>>>>>>> Report Suspicious
>>>>>>> <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
>>>>>>> ZjQcmQRYFpfptBannerEnd
>>>>>>>
>>>>>>> On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>>
>>>>>>>> On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
>>>>>>>>> Prevent ioeventfd from being enabled/disabled when a virtio-pci
>>>>>>>>> device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
>>>>>>>>> feature.
>>>>>>>>>
>>>>>>>>> Due to ioeventfd not being able to carry the extra data associated with
>>>>>>>>> this feature, the ioeventfd should be left in a disabled state for
>>>>>>>>> emulated virtio-pci devices using this feature.
>>>>>>>>>
>>>>>>>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>>>>>
>>>>>>>> I thought hard about this. I propose that for now,
>>>>>>>> instead of disabling ioevetfd silently we error out unless
>>>>>>>> user disabled it for us.
>>>>>>>> WDYT?
>>>>>>>>
>>>>>>>
>>>>>>> Yes, error is a better plan than silently disabling it. In the
>>>>>>> (unlikely?) case we are able to make notification data work with
>>>>>>> eventfd in the future, it makes the change more evident.
>>>>>>>
>>>>>>
>>>>>> Will do in v2. I assume we'll also make this the case for virtio-mmio and
>>>>>> virtio-ccw?
>>>>>
>>>>> Guess so. Pls note freeze is imminent.
>>>>
>>>> Got it. Also, would you mind elaborating a bit more on "error out"? E.g. do
>>>> we want to prevent the Qemu from starting at all if a device is attempting
>>>> to use both VIRTIO_F_NOTIFICATION_DATA and ioeventfd? Or do you mean
>>>> something like still keep ioeventfd disabled but also log an error message
>>>> unless it was explicitly disabled by the user?
>>>
>>>
>>> my preference would be to block device instance from being created.
>>>
>>
>> I could very well be missing something here, but I was looking to see how I
>> could block the device from being created (realized) given the functional
>> mismatch between negotiating the VIRTIO_F_NOTIFICATION_DATA feature and
>> ioeventfd being enabled.
>>
>> However, I realized that feature negotiation only happens after the virtio
>> device has been realized and it's one of the last steps before the device
>> becomes fully operational. In other words, we don't know if the guest
>> (driver) also supports this feature until the feature negotiation phase,
>> which is after realization.
>>
>> So, during realization (e.g. virtio_device_realize), we know if the virtio
>> device (1) intends to negotiate the VIRTIO_F_NOTIFICATION_DATA feature and
>> (2) has enabled ioeventfd, however, we don't know if the driver will
>> actually support this notification data feature.
>>
>> Given this, we could block the device from being created if the device is
>> *intending* to use the notification data feature along with ioeventfd, but
>> this seems premature since we don't know if the feature will actually be
>> successfully negotiated.
> 
> Yes this is the option I had in mind. Many devices with this feature
> do not actually work if they do not get the extra data
> so they fail FEATURES_OK, anyway.
> 
> 

Ah, okay I see. This was the extra context I was missing.

Will do, thanks Michael!

>> Another option might be check this during/immediately after feature
>> negotiation, and then unrealize the device. However, I'm not sure if by this
>> point it's "too late" to unrealize it.
>>
>> There's also other options like defaulting to using notification data over
>> ioeventfd (since a user would need to explicitly enable it, showing intent
>> to actually use the feature), which is what we're doing now, except we could
>> add some kind of warning message for the user. Another option could be
>> setting the device to broken. However, these options don't align with your
>> suggestion of removing the device completely.
>>
>> Let me know how you'd like me to proceed with this. Thanks!
>>
>>>>>>>>
>>>>>>>>> ---
>>>>>>>>>     hw/virtio/virtio-pci.c | 6 ++++--
>>>>>>>>>     1 file changed, 4 insertions(+), 2 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>>>>>>> index d12edc567f..287b8f7720 100644
>>>>>>>>> --- a/hw/virtio/virtio-pci.c
>>>>>>>>> +++ b/hw/virtio/virtio-pci.c
>>>>>>>>> @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>>>>>>             }
>>>>>>>>>             break;
>>>>>>>>>         case VIRTIO_PCI_STATUS:
>>>>>>>>> -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>>>>>>> +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>>>>>                 virtio_pci_stop_ioeventfd(proxy);
>>>>>>>>>             }
>>>>>>>>>
>>>>>>>>>             virtio_set_status(vdev, val & 0xFF);
>>>>>>>>>
>>>>>>>>> -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
>>>>>>>>> +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>>>>>                 virtio_pci_start_ioeventfd(proxy);
>>>>>>>>>             }
>>>>>>>>>
>>>>>>>>> --
>>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>>
>>>>>
>>>
> 
