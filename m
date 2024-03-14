Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A55745C2
	for <virtio-fs@lists.linux.dev>; Thu, 14 Mar 2024 20:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710447836; cv=fail; b=jFBveCeXQj7w2Y0weJV3zYk5dEJziFucEYHYkHqKXqq9miwmBjemnGRjFr0h3Rx/BHEt6VDyeNhJN0rDQchmd/lFd+4Qjygwbd+xDXday3t0eqXgCcc0KosX7CL+B9vqginEW/GsDFVGiBPKAhycC4uv47Wsy2OSTb78c5221ko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710447836; c=relaxed/simple;
	bh=T7iyZvHqrifNRO7AzWw8Pl65MbUUOQJzvbp7PNl1j5Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HtS8td495EE+Nobs0KyzggN2z74/Og3Xj+jMT+ZIVlc3yROSa487/z+a3El5+CnWFWuh5FnC0E2TswdrqgCoGZi51Y4IAy35nDoNf2ciZVO1MtV0QD8j8LPoKX1p+272dka0zxeWD3nPQ+GC0UYIVavdfXZC9Mpj/WWencKzSnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mjmkiK++; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=c6BErRU4; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mjmkiK++";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="c6BErRU4"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42EJxF9h008873;
	Thu, 14 Mar 2024 20:23:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=5rIFtoBJMNOAQKIUfOm8+jqGAJX2h5amQ1m0+F4nVhM=;
 b=mjmkiK+++s+lMw2yY33VieKO4Whg4LZE8dLycOW2Zo+AjoxDOyAl/j9+elQ0UP9MD5/R
 KCOfpp41Wi4aHDimoKROhY337DGjU+xGLMMC1cIpI/2/r2/A1iScEJdE1/bvvWXaB1Tq
 WPHnQ9U5WpU792BjbR3q66jix+rGu0kbVk2cmtZvVtLV2LhCvVOD5Mit2h9LJHaD2Wtv
 ZhduZt9uM2ptL/iR742aFASe4ZkZmvjZtS1dkywbt0DPTzUDRZhpJGHjeWQ3tKhpQzQy
 fk5tQQwBs5QN5LQXiuWbK4JS22cqaGdlpxRoPBFqBY4bQi4RN/lX29HpdlbK8zM/3B28 fA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wv0af96ex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 20:23:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42EK7Dnv004810;
	Thu, 14 Mar 2024 20:23:40 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7baen6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Mar 2024 20:23:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f95QW9gyyOefYL6cxx4NplZT2Xb8bj/X9BTNgWjN6Dx4geIhA7XYZoACreL7WvRedtRWHYx4SNiwjc2kSFyg0JMrDp4hmBV/EeU9jUDXGJw4Ssu8vw9JayRnhmr2QniORP/EgFw1NFW9juL3QqidQ7rxxz4rWhZ5pY7rJMnHksF3S0TMnmXZgT8+FhQSjrFxIxiUlcyUHVT89IWz4cpy9MIlPcvxts1dZUy9MUhKx55C2c8iPjAthHfQvQY7UenjZBbb0c4Dpq8OvtCuqaY7dDi2qAso8gNO1AL3LPvg5h9bOmN6jL7do5O6MIxZPgtieAGTWFXciblQp3Fy3ajC6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rIFtoBJMNOAQKIUfOm8+jqGAJX2h5amQ1m0+F4nVhM=;
 b=G1+QErw6l96rNoibbpfNtfbDwSu95tc7k/dFgGHQPKw1O/YDWAterFgBCq+3mOvGFR55y5ZeFimfhrRbA7kR9w/PFPyvIKO+XI48iDnpFLkjaOBVM1OICpKjJ++iWIpptO9ySZ1UOs6h6z++G0y7yyVdpC6Jday1k4uiunup4h20SOi79elKpaKkvhTbVzH14th0U8pqWXcisu6Q3+zZJbAx8is7uAcFbO1RiOoucSLuyhSvTjtAaxfByvLBASVB7eqiIDqLCpEHphY4tLmJqeJfIGUrvcScEBi4FSjXePXPlXi2Zmd+Z6kEutozBA0X4xjSrKljVJG2mjtBh0t3VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rIFtoBJMNOAQKIUfOm8+jqGAJX2h5amQ1m0+F4nVhM=;
 b=c6BErRU4xO6vfmP+X982EWg8UwRZqgto/nrkwGeBD2zM/NYWnvQppJ3Xuvsc7aw8WUNFxNZ/IY0LXa2giXsuVl/uetvRPCJVng2N4Mt0mi/8DCqc7qdNsKrqbliMlqTDtJtTHgOV5/4dfZXk4ssn9cuQm2jcT8L87hL/CGW5QQs=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.36; Thu, 14 Mar
 2024 20:23:35 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 20:23:35 +0000
Message-ID: <8b87682b-f22f-461e-bca7-1c80a6b9c760@oracle.com>
Date: Thu, 14 Mar 2024 16:23:31 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] virtio/virtio-pci: Handle extra notification data
Content-Language: en-US
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, mst@redhat.com,
        si-wei.liu@oracle.com, boris.ostrovsky@oracle.com,
        raphael@enfabrica.net, kwolf@redhat.com, hreitz@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, farman@linux.ibm.com,
        thuth@redhat.com, richard.henderson@linaro.org, david@redhat.com,
        iii@linux.ibm.com, cohuck@redhat.com, pbonzini@redhat.com,
        fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org,
        qemu-s390x@nongnu.org, leiyang@redhat.com, schalla@marvell.com,
        vattunuru@marvell.com, jerinj@marvell.com, dtatulea@nvidia.com,
        virtio-fs@lists.linux.dev
References: <20240313115412.3334962-1-jonah.palmer@oracle.com>
 <20240313115412.3334962-2-jonah.palmer@oracle.com>
 <CACGkMEv6bRgrV_nvZK5Tb89CvTP5Kpyj4+na4Q9F=xBOJ6=8sw@mail.gmail.com>
 <b0e4a124-cced-4cbc-9f89-b8967f5a0b2c@oracle.com>
 <CAJaqyWcmzuY5R8hC-zwp_mEK40sYgwHU0vhewKziQLsY2EnpLg@mail.gmail.com>
 <f173f397-965f-43f9-9ce0-b417e86d6935@oracle.com>
 <CAJaqyWfspBXGw0WE2=HBuZiBJjyWTrMm2jyB4e0mP9UkixS4Mg@mail.gmail.com>
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <CAJaqyWfspBXGw0WE2=HBuZiBJjyWTrMm2jyB4e0mP9UkixS4Mg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0148.namprd03.prod.outlook.com
 (2603:10b6:208:32e::33) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|PH0PR10MB4423:EE_
X-MS-Office365-Filtering-Correlation-Id: a11c371e-d148-46c3-5932-08dc4464a012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	VTwkocSRHe5YLCWKQm/LNiyI0pUYRTTfuB9Y5JePBTjLmDg6x3EwSpBw5hNntQJRzeZ15CZWiTtge+vD9d0l/1TiyY8k+5//EMLzBfETuffxWjvb5eHqdqnfucS0zsLNzePIIfIdav7aGD009URnZwF6AO6PARN0NoEw5mVQe6DLZ31/B6NBykvxSiUc56mYQJlf+sJSPWeoxmlekYKEbSwPFebGFaB9kZsq9iFkvHQwQ77Ue0QXjgakqhtBQ5ChbNuGRFjJ6YYKegTgiMkUe66dqoHl7u1myeesNwU/FwWq7u6Pw87bBaxclKZ36Wo7jERDaYF+han+HmxG+V4XcQ46Tj+ed6UQLNRKRZ37UnZ3h+38Z1SHsLM4Gny6MuBxIorG03CGbQTagn4R9oBTV4G4Qx10XD57lokxlMI38kD+0ZVlHKSRM+116aU1ivyXtLnAzfN6PArOpSd2FoYieZ664Md6CVPdZ1ztBScWt710izwtsnsuATBT0efIGvOeSiwVCaGRBniCUmTaHGjUZl5SRLB/jsLFSg+AauvA0wFZ4AuJMd+wzbWkoz74DUXLc5NMy0Qk4PR7Hunf3jvJwJdjcqU8noNzTwcji0IAORinPUzzmPXwco1Ll3hd1C6foPD3PF3MVeHS+KV3DN6W4RMuOU/KxE2PmWv9XvHYcUQ=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eG14MUxGd01FbjN3MUtHcm5IYzJMM1lOc2NSbSszRXRXZG5Ma3laTnJKSkJY?=
 =?utf-8?B?dE1BWURFUUVsNDdCQmZGeXhGbXpRVUNNVmk5MC9QVnBvU3lhaTU3TTNDL3JH?=
 =?utf-8?B?WVRmSmJ2c2dsVnRrQmo2c0ZzK0NkWnB0aFlBT244NnZMZmxsbGw4VW5Oc0li?=
 =?utf-8?B?dWFjTk16am1EVUtFU2JMb1llSzJvakNRVzZ0d0w0K2xwdzBrYk1CVnY4b1Z2?=
 =?utf-8?B?cE81VG9ldGRUaERnejVreUpsSmRGTWpvMnUzNU9jdEhZNW5na0kvcjhOMjVz?=
 =?utf-8?B?bXRoaU42akZzUDVXOTlPOWNJdy9vZDNucHVGcmtUcEoxQ1dPeTRBeHhUQmpl?=
 =?utf-8?B?M0ZnRnJVQjJYK0lpaXVGdmtkYVlMV3dEVU5abkRKTWdSeGF0WUJPakhiMU4x?=
 =?utf-8?B?T1hHeS8zR3BONVQwQnFzdjhHdWFyY0pBdTF3R3pBRzdQRWtnVmlqRHBVd0Ft?=
 =?utf-8?B?RnBUSTBQS2xlS01JZHFidW42M3NRYlZScnNTd01Qd0UwZ3NRaTVzUllKZmNV?=
 =?utf-8?B?aElQSTFGVGJDZ1RKc3cyR2VPeGlzWHFaeHNzM2s5NU05ckN3dUZCaml1c0FN?=
 =?utf-8?B?bjNIaGJ3Qm9uaHRUSVlQcVNob2RZMWdiRXpHUnhoalRBMUtHUm9JUWxNL0ZZ?=
 =?utf-8?B?eGhJYjN5blJ6VEovczh5SGR2dWFmb1NFdHdGcXh3NzZnOHp5ZTAxNzNwTnk0?=
 =?utf-8?B?eVhUS2ZCMTBqK0RMdFVHbmdCUHlZQmlzZTFCREYrdllOL2JuWmYrZmk3Nm5X?=
 =?utf-8?B?WXNlRExOQUdESFd4aUR3RlFzY2pMSXVVR0xMU3pzWXFKTXdNaHlQNDNoalZ3?=
 =?utf-8?B?R2hIR3Eyb1hsZWMrNDcxL2hxRnViMHRxNlpvVDNvNFhqcjB3aU5kY25zQmk5?=
 =?utf-8?B?aW9CZ1dwMU8vUjUwSWQyek5XYTJISFh0RldvWEpZSmNCSXRWUEZLa0lFc2FF?=
 =?utf-8?B?VHl4NTZ4cVdySXlLRExYYzI0QmZKbWlaQjJOSmg3YXh4ZVdSRzVTY3N4djQ3?=
 =?utf-8?B?TnF5d3l1c3NoR0dlSzROYW5BL2p6YjMyMEZuNEF1ZGhOWWdaSkZaM0kzd29p?=
 =?utf-8?B?NmpFRCtPTzlPUGlJZlAvUWdocTR2RkhpaXIrTFBMOUVHc3Q4SzBlTVdRQUxa?=
 =?utf-8?B?enZ0MmFxdUJaM1ozaXJxQ0R5Mk5tQ3haK0RVWm1iZHdqSUJRN1c4U2dDR1Qx?=
 =?utf-8?B?STZNQjBRbUFsS25JbWxKRkg1QTRHUVBDTEIxdVVDc1hzMVpMbk9oczN6cHRR?=
 =?utf-8?B?eUkrZlZvS214d3lKVE5yV2VBVExodDBhWXBPckdIZHBjRGxUZU1MamlwTC8z?=
 =?utf-8?B?SEF1cjZ1d0JGZjUzdElMeUYzdDkvZURKUm5LbTJsM0Z1cElmV0pnQTBJaWxJ?=
 =?utf-8?B?VTV6STNEVHphZ2VLb1MyZS9FZ2FJWWJyS1Q0NW02Y1pzbXowc2MvWllWZFpn?=
 =?utf-8?B?S0NlTjduNURpakpGNys2OGVvTER0Tm5wT214SUJSQ29yMDVEQjNQbTJDN3Vm?=
 =?utf-8?B?TjJ5VmdqcE0wdktSMWN0YTZ4VTJBUDZVdXN1YzE5dlRuMVBnL21sd2FnUTZ1?=
 =?utf-8?B?MkhaLzFXbEhZUWxaRVlkdXc4YzEwYjQxOURUZ21JTVAyNVdKb2pEQmt1K3E5?=
 =?utf-8?B?VDJONFM3eHFrZzhsbmUvZ1dpUUZwc1NXVy9IVC9hazl4ZFZoSHhYcEJlbGdD?=
 =?utf-8?B?ekhsS0tpL2RjRGxlcTk3OFFpcjRJelNsQ0VycmRzVVFtcks4SCtZOWwveW5T?=
 =?utf-8?B?ZExhSmc5TU5JMndUVWRYVDlJbVNDOUs0ZzFvL3ZJWXpUNmR6a0hoMjdXTGFD?=
 =?utf-8?B?MitBd2NOV2tQTHBJSlJhdy8zNFdQMFNpcWtpQ1ljWVBhS2VOTkJFTWVKdHor?=
 =?utf-8?B?MkFxa2JwaFRueHZmNzhFY1dGUm1BdFIxY1ZEZWZGSGhoTE5iQXNnVnBQRTlL?=
 =?utf-8?B?aDZQNG14OUVLYkFxMWViOFlIcm56SVhBd2pYbS83dy9tUFVKWE1QQjYxSmds?=
 =?utf-8?B?RVF3eUJ5Y2pNazl3NU5MU2dSSHdkRmwrRUFXemZKYldjeWRydndFR3ZybVZs?=
 =?utf-8?B?OUZLQVEyeW53VXZWalcrT1p1aGtJVWdRQ1ZlcE90YkJFSXhEQ01zaGlGNUJ1?=
 =?utf-8?B?VEJwRmtVbUZQWDkzdXh1aFdmdWY1aE42R1hsT041K3lNUVVHL0k2RUh0d2Qz?=
 =?utf-8?Q?4bg3KFVEpGnKg+/fzz4sMzg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	cFSlXRa+b60+qOUKsME7zx96ZmAmYKTigNPVnnR7FKoG1r32wJ7wDh8OAc3Ib9IkmUJKZBGYVQsVtIhUMci1lHyGskEpk1GgdcAUcW1tD6RDgQqf7KIMRWtyqSq3OrbBu1omKHlaXHuWCpNc9j+fAZSl9ITZ9m5I+i8fkwP/AesMFatbkEu6OZqEwVg6mN7fVWjmvxMJdOe3BwmWcruh/lZj2lhIUb9i53rkgYU1hdFjy8lujm7yUwYzYb0DPdajgtnb8f6/oBg59X23Z2RXOZgUs7my4j0n6UWWitKYLfY5vswfQvAk0ISdy8gn0jEAY7++VWCknCoJmChW9qocJMeU0hSGnO3P2XSWKHwRtTEAgFwU428WaR+oUeHUgHlkYmmrZzftR8HJfK+e5PbpKEV7bO8gHEqbCsO60ew7wAGG4t4KoL2no97oub+bQrs0rLWt6LWLaqJZMIljk62SvURM9rdhj9XDeRlHivvO6is6XC5nEA9F4CSccNNRN4MmWdxCkJY2qSemSHdbydHqyQxBhyFccsqPHWPJsoaMBHFCVr+rtsZckJ8RPwQxfR/KQi0K3EP669o1sEncef4GJ/CbnvM6/xM+ykeHiv9lLNw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11c371e-d148-46c3-5932-08dc4464a012
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2024 20:23:35.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iCia8P5zbQ7JM0Yb2J32Q5gm+Adr0n5ZkwbCB4c4eiYTSx+WC9K0OFUJJ+wiD+cgkLXAkav1T89OR7+NtX0CwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-14_13,2024-03-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403140157
X-Proofpoint-GUID: m4R_jQMLj-qSE9zjy6D53Gys6wvIUR0v
X-Proofpoint-ORIG-GUID: m4R_jQMLj-qSE9zjy6D53Gys6wvIUR0v



On 3/14/24 3:05 PM, Eugenio Perez Martin wrote:
> On Thu, Mar 14, 2024 at 5:06 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>
>>
>>
>> On 3/14/24 10:55 AM, Eugenio Perez Martin wrote:
>>> On Thu, Mar 14, 2024 at 1:16 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>
>>>>
>>>>
>>>> On 3/13/24 11:01 PM, Jason Wang wrote:
>>>>> On Wed, Mar 13, 2024 at 7:55 PM Jonah Palmer <jonah.palmer@oracle.com> wrote:
>>>>>>
>>>>>> Add support to virtio-pci devices for handling the extra data sent
>>>>>> from the driver to the device when the VIRTIO_F_NOTIFICATION_DATA
>>>>>> transport feature has been negotiated.
>>>>>>
>>>>>> The extra data that's passed to the virtio-pci device when this
>>>>>> feature is enabled varies depending on the device's virtqueue
>>>>>> layout.
>>>>>>
>>>>>> In a split virtqueue layout, this data includes:
>>>>>>     - upper 16 bits: shadow_avail_idx
>>>>>>     - lower 16 bits: virtqueue index
>>>>>>
>>>>>> In a packed virtqueue layout, this data includes:
>>>>>>     - upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>>>>>>     - lower 16 bits: virtqueue index
>>>>>>
>>>>>> Tested-by: Lei Yang <leiyang@redhat.com>
>>>>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>>> ---
>>>>>>     hw/virtio/virtio-pci.c     | 10 +++++++---
>>>>>>     hw/virtio/virtio.c         | 18 ++++++++++++++++++
>>>>>>     include/hw/virtio/virtio.h |  1 +
>>>>>>     3 files changed, 26 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>>>> index cb6940fc0e..0f5c3c3b2f 100644
>>>>>> --- a/hw/virtio/virtio-pci.c
>>>>>> +++ b/hw/virtio/virtio-pci.c
>>>>>> @@ -384,7 +384,7 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>>>     {
>>>>>>         VirtIOPCIProxy *proxy = opaque;
>>>>>>         VirtIODevice *vdev = virtio_bus_get_device(&proxy->bus);
>>>>>> -    uint16_t vector;
>>>>>> +    uint16_t vector, vq_idx;
>>>>>>         hwaddr pa;
>>>>>>
>>>>>>         switch (addr) {
>>>>>> @@ -408,8 +408,12 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>>>                 vdev->queue_sel = val;
>>>>>>             break;
>>>>>>         case VIRTIO_PCI_QUEUE_NOTIFY:
>>>>>> -        if (val < VIRTIO_QUEUE_MAX) {
>>>>>> -            virtio_queue_notify(vdev, val);
>>>>>> +        vq_idx = val;
>>>>>> +        if (vq_idx < VIRTIO_QUEUE_MAX) {
>>>>>> +            if (virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>> +                virtio_queue_set_shadow_avail_data(vdev, val);
>>>>>> +            }
>>>>>> +            virtio_queue_notify(vdev, vq_idx);
>>>>>>             }
>>>>>>             break;
>>>>>>         case VIRTIO_PCI_STATUS:
>>>>>> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
>>>>>> index d229755eae..bcb9e09df0 100644
>>>>>> --- a/hw/virtio/virtio.c
>>>>>> +++ b/hw/virtio/virtio.c
>>>>>> @@ -2255,6 +2255,24 @@ void virtio_queue_set_align(VirtIODevice *vdev, int n, int align)
>>>>>>         }
>>>>>>     }
>>>>>>
>>>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t data)
>>>
>>> Maybe I didn't explain well, but I think it is better to pass directly
>>> idx to a VirtQueue *. That way only the caller needs to check for a
>>> valid vq idx, and (my understanding is) the virtio.c interface is
>>> migrating to VirtQueue * use anyway.
>>>
>>
>> Oh, are you saying to just pass in a VirtQueue *vq instead of
>> VirtIODevice *vdev and get rid of the vq->vring.desc check in the function?
>>
> 
> No, that needs to be kept. I meant the access to vdev->vq[i] without
> checking for a valid i.
> 

Ahh okay I see what you mean. But I thought the following was checking 
for a valid VQ index:

if (vq_idx < VIRTIO_QUEUE_MAX)

Of course the virtio device may not have up to VIRTIO_QUEUE_MAX 
virtqueues, so maybe we should be checking for validity like this?

if (vdev->vq[i].vring.num == 0)

Or was there something else you had in mind? Apologies for the confusion.

> You can get the VirtQueue in the caller with virtio_get_queue. Which
> also does not check for a valid index, but that way is clearer the
> caller needs to check it.
> 

Roger, I'll use this instead for clarity.

> As a side note, the check for desc != 0 is widespread in QEMU but the
> driver may use 0 address for desc, so it's not 100% valid. But to
> change that now requires a deeper change out of the scope of this
> series, so let's keep it for now :).
> 
> Thanks! >

I'll add it to the todo list =]

>>>>>> +{
>>>>>> +    /* Lower 16 bits is the virtqueue index */
>>>>>> +    uint16_t i = data;
>>>>>> +    VirtQueue *vq = &vdev->vq[i];
>>>>>> +
>>>>>> +    if (!vq->vring.desc) {
>>>>>> +        return;
>>>>>> +    }
>>>>>> +
>>>>>> +    if (virtio_vdev_has_feature(vdev, VIRTIO_F_RING_PACKED)) {
>>>>>> +        vq->shadow_avail_wrap_counter = (data >> 31) & 0x1;
>>>>>> +        vq->shadow_avail_idx = (data >> 16) & 0x7FFF;
>>>>>> +    } else {
>>>>>> +        vq->shadow_avail_idx = (data >> 16);
>>>>>
>>>>> Do we need to do a sanity check for this value?
>>>>>
>>>>> Thanks
>>>>>
>>>>
>>>> It can't hurt, right? What kind of check did you have in mind?
>>>>
>>>> if (vq->shadow_avail_idx >= vq->vring.num)
>>>>
>>>
>>> I'm a little bit lost too. shadow_avail_idx can take all uint16_t
>>> values. Maybe you meant checking for a valid vq index, Jason?
>>>
>>> Thanks!
>>>
>>>> Or something else?
>>>>
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>>     static void virtio_queue_notify_vq(VirtQueue *vq)
>>>>>>     {
>>>>>>         if (vq->vring.desc && vq->handle_output) {
>>>>>> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
>>>>>> index c8f72850bc..53915947a7 100644
>>>>>> --- a/include/hw/virtio/virtio.h
>>>>>> +++ b/include/hw/virtio/virtio.h
>>>>>> @@ -335,6 +335,7 @@ void virtio_queue_update_rings(VirtIODevice *vdev, int n);
>>>>>>     void virtio_init_region_cache(VirtIODevice *vdev, int n);
>>>>>>     void virtio_queue_set_align(VirtIODevice *vdev, int n, int align);
>>>>>>     void virtio_queue_notify(VirtIODevice *vdev, int n);
>>>>>> +void virtio_queue_set_shadow_avail_data(VirtIODevice *vdev, uint32_t data);
>>>>>>     uint16_t virtio_queue_vector(VirtIODevice *vdev, int n);
>>>>>>     void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector);
>>>>>>     int virtio_queue_set_host_notifier_mr(VirtIODevice *vdev, int n,
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>>
>>>>
>>>
>>
> 
