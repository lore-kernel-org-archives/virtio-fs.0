Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8609C16FF3B
	for <virtio-fs@lists.linux.dev>; Tue, 12 Mar 2024 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254057; cv=fail; b=Un7HTcF/+RiQK/5wSLxss0sAwGWoB+Tc06MPrHKNfwGQkoZIMa3Snpq0eAQc1U3GCfKs/ckEvN+YHgH/t5Q8nbUcJZhwOsn3TWLzHZVATJT/02jWz0KuSfx5gDsZRSFkZrHj7UYsNJSIXrv4FLejyWWUTZ/u8BWBsew6fm5jQJ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254057; c=relaxed/simple;
	bh=l7T5Zq6rR1e4YuBw2vzt6Do1wc3P2+5ewmc1iRLs4hs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bYqcBzjIM+TcnkviF1oAi2SNsDrIKnA6/W4YIj2bcEHjMhra9Wj7JBHeOq0Fm8behTFbz3+LrK06RWwBp7J7LQrNIYPWczw3boJ6aivJI6qfbm1nWjTc7BW8UOULQZ2AMO8snok9tQvE3PrmfS1AP0SCdqR3DzW4P3ZJsJVlPI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EU1mzJbU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GyKsCkey; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EU1mzJbU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GyKsCkey"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42CE64cJ004316;
	Tue, 12 Mar 2024 14:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Ad1i/qPa/5Ng5ksv5O6+u1iOieRCivW0FmUkhi7KkIo=;
 b=EU1mzJbU+Ea6MtXwlzVFoUH7OP/MO+Ddv8VC66jMZmp7o5BxYhs7GANcsb5Li49A0nxF
 r0LpqubriLbMjuCJFS5mZacmwM8/DrCmkZ/icqCVszBMbgoGC6JQLlAblbaljxWzCRhw
 Ri7lhf8RibJzO8aoqOdXzkJUbL8k7+tD6lA14fyMtcdGqlR704OJ9fYXvvGZL8bQDLNC
 MOLJ8/qx33NxTnP/4VrjAJvUpkvhRZH2j+Wf15Q6aWGadWrXqdeE2yg2MBqZ5PGVGxIb
 udQmv+CQBPOn9D+m8VbBUQtWEj+yEchLfL2ctVRzJ+bF3bK0nBWGULpGm/P611AvKuRw Rw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wrgaup09u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 14:34:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 42CDvbQM009129;
	Tue, 12 Mar 2024 14:33:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wre7dha3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 14:33:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmP12hKQeLHm8Oj9HLwt2ECGq9SzbT8eRGr/yFzgXP84dHL89eaWgcQ0ycw4ELjnpG4rO39PQuEkqJSsheL7GTmC5K4nkXG4ANYg6alW9qvWQIapvJ1M1azHlQcuP1ndrYfg5KJOxo2C2f3In0rrODMOymyC5sZAzqUHCOLY05V+AHDXryBv052R+UwWeW6cWRDsET9otsPE3VSXCTwJMc3cOQzFYtKa5U9yM1KuXtUvxaP9truzoO6FTLAdot9NzGeagWIUUquCCvWGt6mGTtKq6AuBHozWipIBIqO4B35ZW6W6x/Xjjj6U0O7GqBd2biFG9RNl7542krH1WnmRAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ad1i/qPa/5Ng5ksv5O6+u1iOieRCivW0FmUkhi7KkIo=;
 b=kPKgQSKg8YH+IWij0xMobbkbcdj6vmYc/HBQyGcBBqfy+Z65aZ0hVkOAusUKsinoVzMVpUFJW89URJbJSETvXemSFfBYOh7NXfpjZPfrbMFYySQ0iTahupEkVOZmPKTttBo9n6ty+K0F/1Vy0aBMJK/GrmTqXHa+VNZrCyhggOzzHzeUmW0CtbdMREf9ollL3s9LcRx57S7auaeebiixLcrgsjTKNMSZnsn7YuvOnyAAhHEi9hb8NGqhwb6ztyznn4ubztE/zZQWCMIsDOeWb82JIlYZqiQRwbp00JSX0YFg6bWa3zt7ILYJRIpFABXul8T7jajmYl1ocI1dYOX70Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ad1i/qPa/5Ng5ksv5O6+u1iOieRCivW0FmUkhi7KkIo=;
 b=GyKsCkeyxwQM2X/CWwrdpuSTcC+fYO+zCZl9T4CdN9IheBNQM/yhygmQcIG43PDMLOyDjYZ72WUPFpHHIJU0By8dWA4bQ3FUhqnyQMzEDYO4LGSLnJfSVo7+WISFkq6u7P0wlav6/O+9pJrQLcl259cTeEEUDbq3nmSvFpT7FCQ=
Received: from PH0PR10MB4664.namprd10.prod.outlook.com (2603:10b6:510:41::11)
 by CY8PR10MB7169.namprd10.prod.outlook.com (2603:10b6:930:70::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.26; Tue, 12 Mar
 2024 14:33:55 +0000
Received: from PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9]) by PH0PR10MB4664.namprd10.prod.outlook.com
 ([fe80::75a:a398:452a:90a9%6]) with mapi id 15.20.7362.035; Tue, 12 Mar 2024
 14:33:55 +0000
Message-ID: <c7a91e57-04eb-4ed1-8bb4-1d1b05894c8a@oracle.com>
Date: Tue, 12 Mar 2024 10:33:51 -0400
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
From: Jonah Palmer <jonah.palmer@oracle.com>
In-Reply-To: <20240311114638-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:208:335::14) To PH0PR10MB4664.namprd10.prod.outlook.com
 (2603:10b6:510:41::11)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4664:EE_|CY8PR10MB7169:EE_
X-MS-Office365-Filtering-Correlation-Id: ec27bc57-a02d-4875-8af1-08dc42a1726b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Gd2Fnickai/OCzQ8nUS11akIfgTVyyrVzkhhVHREbFP10rDdUDvC9JMrRm1SVJAmGONrndiHxLFin0xP/Dv/w/YGuUo0gEEBwAO6QVdHUGdOKTZgk3MCuKxhBLdnskK8sCI5ZbafwZeppvIGdy/rq43KCBT6AhPTfyShU1JfLqDSwXYmMM/zLi35srBOzdFjJXZga2J6yVMGzJ8CObVAN6NT96ozQlRVqR8nthFHGMZL8Oa/nWCKY6CnPtN/6WjE+3aRY0Itp1a6EPdoCrX08GGjNien50ALKdzsL5NdVKPJZq/VzTMdF7hXSNTny3Azqma/4eo5dDJKgK7NpHROD7oXo0cUo9z2ttj2J2ARTWrzf7xOv0UB/27AecMQnuGukS4mo4s71tCow73umWoBnoDXGE4FvHDZMquGmveu1KJm7veBPIInEC+6dXRx4D0mzJ/ZPwEkjngCkPE1ullxRK1L6suYGTnFY4TaTMvedkHQOOjEI+Eh19f60gRZH8O+t77G9bR7w9l7yYF3V0JWnSdpaJHxC9o5i+uMjLPQT7G9yFZzdrftzPgV53JUWT47smsNRrb6MxKGW2qTCcUtxhtuBmpwnNlah/FTF6VNOHg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4664.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OUhuaDJmMnJudkt4R0Z4S2hLOWsxVHVDUzE0Q2ttOTVrQ1FXcmVlOGwxQVVy?=
 =?utf-8?B?Y2Ixd3FiVW9NMXl1Mk9oWHdFSlNGbG14eVlJbDM2aGxoL1VsN2VyZjhHOEs3?=
 =?utf-8?B?OGxHcVVsUC9WOE1EWm0wZEZaR2NtOXU3cDNCMkYxbk1hL1VBajlhSG5rNlUv?=
 =?utf-8?B?N21USUFuQjJTeGJwV0Q3QmUwVjg0ZHpUV3VwSFdIcUFQdG5yZ3BQY0UvbVBy?=
 =?utf-8?B?NWMxTDhpeW1KcXBDWm81TmV6TktoS05saGRjS1NveFJYSWRXOVlnWC8vOXFq?=
 =?utf-8?B?ekpSbkNvd2hYbkxMTWdnWWJJTnBYb2hwTmRJeXptMFFGWXVyRmRDQVY4WWNr?=
 =?utf-8?B?YVpDS0xRUDVaUEJRY3RNSHlScXBhOXllSHN5OUF6Z2UvUkRlMXhuWmtkK0c0?=
 =?utf-8?B?WmZOT3Jqa1BZbXZvK2psZ0YwUjJvMFRWRkJsaldzRFFqMTkvSXdVMW4wZ2ZI?=
 =?utf-8?B?Uzd3Y3VjU0Fid1cyMGZjV0ovR2tybXo2Z0FqZFdoMWtWekpVV3FaN3U5SnRs?=
 =?utf-8?B?S29yODg0TVFVanNYeXdYMUUyaDRRdlNNNFYwRjFvbzFKU2hjMWV3ZTFPZTZm?=
 =?utf-8?B?ZFBad1oxMk9jRjRPdnZ1YlFKNG5yb3ptamlsa1VoYW1KRzJWZXM5eFNyeEkw?=
 =?utf-8?B?b2xBMzRrWGFSZ0lwdEUreklzYlR1dVU1azZQYjQ3QWQyQjdVWnV3VHFwY1Uv?=
 =?utf-8?B?RG5ISFJnR3ROeURmUzhkQVQrby9nY2doRmRlWklOS2gxY2R2clNnTDZGR3dM?=
 =?utf-8?B?ZVkxL2hrc2l5d3ZzOFlpeU1WSUFVSjk0NHdNYzZINXZjaGNlOEJNNWxkY0Ny?=
 =?utf-8?B?elpLUkNjTEZ1RGEyY0RVYjg2bEJ0WjkydXdtY2xoSjV3ZGxoc0Nlbmkwa001?=
 =?utf-8?B?RWtVRi9wY3JZc2dCQ0lQZWpEQWhScCtwWDkzaTNyV0ZBYmtLSFNuaU9sN2Jw?=
 =?utf-8?B?anM5TGd2S3NVMHc5Z1VubkZXZDRlVlhadGJRZzQ0L1ZzRzY4cTlTMkhCZUFX?=
 =?utf-8?B?cUpld21iY1BMQm1RUjlwN1JHRE9pc3NsRk9UY2UrWG5ra1phQWozUEJ1TVlp?=
 =?utf-8?B?QnBYSlp1MGpPakJCVmExZmpiaWZaMS9oNHhrVkV3RmpHb0hPRnp4SWpOdFJS?=
 =?utf-8?B?OVdxc1pWL084c25iMTJTWDVNU3ZjaDBkVFBLRW5BWDNYUS9ITTRhYy9yMGZa?=
 =?utf-8?B?d1ZOeFpaSWFqR3JHWS9kZ2lVMXpXa3hFOVZQTklZUnNQQ0pUV3U4ZU5Gb3Ix?=
 =?utf-8?B?aTR0NnBRdFdlK3k4UXErem0xTUN0R0szWHdzSmVKWlo3UXQ1YTdvTDBKZEl2?=
 =?utf-8?B?RHg3Y2xhcWZmcVY4TWVjYlRkTXpTMkVCL204R2ExTUpQaHlaV0hGTWpHajRW?=
 =?utf-8?B?RjF6VmlFOWdlZU9OVU0vaVF1b1NqOXc0RFQveWcvclpVdFB2bnUzV09YcWxL?=
 =?utf-8?B?QSs3ajgwbGtEcEJ3a0RTRFFCenltbk9WYjUzalc3Ujd2Q2IxUnZ6R0J1TUoy?=
 =?utf-8?B?RWhmb0tLaXR4WVFIbFg5Vzhxby9UQjk2cWNFYzcwMnFoV1J3bmpYVkpmUjd5?=
 =?utf-8?B?Y1NLZnBUdEJQMkg5UE1xVEI3UENxUWoxK1lqNnQ5M01od1lDQnV4bldxaFBV?=
 =?utf-8?B?MEUrVkxnOFpiYUxHREQvVklqK2xWQVNoNEU2eEFQY3oyRUR3eFc4Y1laN0hM?=
 =?utf-8?B?cmxOSjJkOGdrQUR2VW1BZ2FHUVNmUnVLazRWMy8yMkFKcTZEb3VZZG15WEQ0?=
 =?utf-8?B?NnZtMVFEKzM5NmMrWFdFd1JFeDlkWFI0eVkxaWVCSitkOWk0bmtPZHd3UWxr?=
 =?utf-8?B?a0RKOWVpZ1BvUHo5ZTdFTC9SOEV0b0lIeE5LZy8weHRkdnRMK3plZ2Vpd24v?=
 =?utf-8?B?YkNBSGZBcDU4MDlPQUdBMjdoRmtoeWhwdUg0aFlkR0VVaG0yL0ZnMVRGb3hp?=
 =?utf-8?B?RjhpU2F4b0o0VXl2TndWUXF2dlU3WkNabkU0SFM5SGJYRE0za01qRVErMmpC?=
 =?utf-8?B?WkhNVlZNQXMwTlFndElNVGRVRE1XSGl3VWNNTzlybnFwRmJ3SWRab0pKVHIv?=
 =?utf-8?B?UTQ4T21ncGZQcWUxRkdIejRhcklBK0loR3VORjJVT1V0R1ZJVFpHemdZdEVC?=
 =?utf-8?B?SkJvUXBzUG12SVNrMmZuTEUvQ2JrcTFlSG9JVGhSREFpSVN3VnpoYjFvM0pR?=
 =?utf-8?Q?AKL04rwHoOx4s88A1WFoqeQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	vt7DQgKPEZtyuCIsBYkHqAQzwxtlkubelayqpgaeXhiR0Q4lNAhqKPumKZQX37T18WUh5/lCxN24vvGfpwEyJn8RQ+kwuSIXdAcB5xFswg+ltQm/N2s2hP0KYChZiufLm+zHXW5iNUrtDC7SoYGmhtuon5c8EL8i9AnvhyvWaZkx1FNY/C7IxbRK2q0juHMgM8yGSrzcKO+a33IYYbERnhjRLUN8ELD8iMk39SwtDJZ1z/V7NdZU7xWyKF4VKy/JP8IO/CYZVb2nD299vIUBWjLV5TRAzMH1iFbspm/dJqRzMkj9mA1KSkz1+4m+Gth8feki5LkBp9JFeYSwjS0+didA5bYfIDZOCoLApHBMuJDRx7Xm+VXbgmWQJoJqlQVGl2AmkbzVC8VaVrH8vWZq+i5BvPCv88BXJqKSrfHL35hCWHofQtrnO+sZBuAQsHAcjvGFG9gQBkYScFJrIQqZSpvxJPIF0vAiEDWuUiAsGldi+/g3rha/aHOrxbmaSDr7JtaZ+kvJjXyDDpwjkvqe+SlCS3vWqXiUrYLAZ7kkXOLGuMUgAJWgNtK0tJafICpy0AzsIlrqiLaLAutznAklWFcJ8dYpNnmmYll0dZ0rN+8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec27bc57-a02d-4875-8af1-08dc42a1726b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4664.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 14:33:55.8560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImrbWVFsuJVs8j7AOIGnU6IT1xYlclWEIzDzhGz/2rX1WIGCB7tGXgq7sJEyXGiwBuwuMknKvxC1XHDtGUzIMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-12_09,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403120111
X-Proofpoint-GUID: jIbcI6lParGtm7E9VhP1V4xcraX0TCOq
X-Proofpoint-ORIG-GUID: jIbcI6lParGtm7E9VhP1V4xcraX0TCOq



On 3/11/24 11:47 AM, Michael S. Tsirkin wrote:
> On Mon, Mar 11, 2024 at 10:53:25AM -0400, Jonah Palmer wrote:
>>
>>
>> On 3/8/24 2:19 PM, Michael S. Tsirkin wrote:
>>> On Fri, Mar 08, 2024 at 12:45:13PM -0500, Jonah Palmer wrote:
>>>>
>>>>
>>>> On 3/8/24 12:36 PM, Eugenio Perez Martin wrote:
>>>>> On Fri, Mar 8, 2024 at 6: 01 PM Michael S. Tsirkin <mst@ redhat. com>
>>>>> wrote: > > On Mon, Mar 04, 2024 at 02: 46: 06PM -0500, Jonah Palmer
>>>>> wrote: > > Prevent ioeventfd from being enabled/disabled when a
>>>>> virtio-pci > > device
>>>>> ZjQcmQRYFpfptBannerStart
>>>>> This Message Is From an External Sender
>>>>> This message came from outside your organization.
>>>>> Report Suspicious
>>>>> <https://us-phishalarm-ewt.proofpoint.com/EWT/v1/ACWV5N9M2RV99hQ!Op20OCZE8kFi__wOXJ_Z0URZ2e_9fdaYz2tejZvKqiDgOm6ijq_imUptzxsrej_4riwCrBGeKmQ9VKXqnbV1ujbfiOV5-E2e1s3pKqpqUL-gRIuMQLDLygRD1hoX3Q$>
>>>>> ZjQcmQRYFpfptBannerEnd
>>>>>
>>>>> On Fri, Mar 8, 2024 at 6:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>
>>>>>> On Mon, Mar 04, 2024 at 02:46:06PM -0500, Jonah Palmer wrote:
>>>>>>> Prevent ioeventfd from being enabled/disabled when a virtio-pci
>>>>>>> device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
>>>>>>> feature.
>>>>>>>
>>>>>>> Due to ioeventfd not being able to carry the extra data associated with
>>>>>>> this feature, the ioeventfd should be left in a disabled state for
>>>>>>> emulated virtio-pci devices using this feature.
>>>>>>>
>>>>>>> Reviewed-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
>>>>>>
>>>>>> I thought hard about this. I propose that for now,
>>>>>> instead of disabling ioevetfd silently we error out unless
>>>>>> user disabled it for us.
>>>>>> WDYT?
>>>>>>
>>>>>
>>>>> Yes, error is a better plan than silently disabling it. In the
>>>>> (unlikely?) case we are able to make notification data work with
>>>>> eventfd in the future, it makes the change more evident.
>>>>>
>>>>
>>>> Will do in v2. I assume we'll also make this the case for virtio-mmio and
>>>> virtio-ccw?
>>>
>>> Guess so. Pls note freeze is imminent.
>>
>> Got it. Also, would you mind elaborating a bit more on "error out"? E.g. do
>> we want to prevent the Qemu from starting at all if a device is attempting
>> to use both VIRTIO_F_NOTIFICATION_DATA and ioeventfd? Or do you mean
>> something like still keep ioeventfd disabled but also log an error message
>> unless it was explicitly disabled by the user?
> 
> 
> my preference would be to block device instance from being created.
> 

I could very well be missing something here, but I was looking to see 
how I could block the device from being created (realized) given the 
functional mismatch between negotiating the VIRTIO_F_NOTIFICATION_DATA 
feature and ioeventfd being enabled.

However, I realized that feature negotiation only happens after the 
virtio device has been realized and it's one of the last steps before 
the device becomes fully operational. In other words, we don't know if 
the guest (driver) also supports this feature until the feature 
negotiation phase, which is after realization.

So, during realization (e.g. virtio_device_realize), we know if the 
virtio device (1) intends to negotiate the VIRTIO_F_NOTIFICATION_DATA 
feature and (2) has enabled ioeventfd, however, we don't know if the 
driver will actually support this notification data feature.

Given this, we could block the device from being created if the device 
is *intending* to use the notification data feature along with 
ioeventfd, but this seems premature since we don't know if the feature 
will actually be successfully negotiated.

Another option might be check this during/immediately after feature 
negotiation, and then unrealize the device. However, I'm not sure if by 
this point it's "too late" to unrealize it.

There's also other options like defaulting to using notification data 
over ioeventfd (since a user would need to explicitly enable it, showing 
intent to actually use the feature), which is what we're doing now, 
except we could add some kind of warning message for the user. Another 
option could be setting the device to broken. However, these options 
don't align with your suggestion of removing the device completely.

Let me know how you'd like me to proceed with this. Thanks!

>>>>>>
>>>>>>> ---
>>>>>>>    hw/virtio/virtio-pci.c | 6 ++++--
>>>>>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
>>>>>>> index d12edc567f..287b8f7720 100644
>>>>>>> --- a/hw/virtio/virtio-pci.c
>>>>>>> +++ b/hw/virtio/virtio-pci.c
>>>>>>> @@ -417,13 +417,15 @@ static void virtio_ioport_write(void *opaque, uint32_t addr, uint32_t val)
>>>>>>>            }
>>>>>>>            break;
>>>>>>>        case VIRTIO_PCI_STATUS:
>>>>>>> -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
>>>>>>> +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>>>                virtio_pci_stop_ioeventfd(proxy);
>>>>>>>            }
>>>>>>>
>>>>>>>            virtio_set_status(vdev, val & 0xFF);
>>>>>>>
>>>>>>> -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
>>>>>>> +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
>>>>>>> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>>>>>>>                virtio_pci_start_ioeventfd(proxy);
>>>>>>>            }
>>>>>>>
>>>>>>> --
>>>>>>> 2.39.3
>>>>>>
>>>>>
>>>
> 
