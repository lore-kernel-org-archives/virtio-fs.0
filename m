Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D086F374CB
	for <virtio-fs@lists.linux.dev>; Mon, 18 Mar 2024 17:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710783432; cv=fail; b=C+NsaIpGr2veR1futN/OT9gfA8OwYxh8Rvo00unqubadcmmABhzOmwu394jfhi2+01QCrwWWGfseIFUOSen+5bFjPIYax3ZWBh1sRBkpYtNx/L9E26Yq1eCHE1DjkmIDh6DBqvOAJTK36uYEJQxY4n3EXDkTN0bALva8ZlRMgwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710783432; c=relaxed/simple;
	bh=YpMjh9uxQJtkogkP3vSDNy6NFg6HZXiQrR5kCE5guj8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hrO+zrowk5svh/7QL/lUHO490f8uZXb4sSy0gmVt8teQf3II8EWTDTJAY1BUxExeYOdCESif2JI03jIsZbvoMyX3Sxe2RI742IKnsHMIYaxvApIf/zCwHyEXe6bD/JBnPCkjirwLBGnGVxK6TUtnw0/0u/Oa7SelMkdPeHgxNt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=u62vSY6h; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="u62vSY6h"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 42I9g7KR010349;
	Mon, 18 Mar 2024 10:37:01 -0700
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wxk77hfv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 10:37:01 -0700 (PDT)
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.24/8.17.1.24) with ESMTP id 42IHSpwe022640;
	Mon, 18 Mar 2024 10:37:00 -0700
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3wxk77hfv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 18 Mar 2024 10:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPhB0h3fijiB/+XBWRAYp7BUM6CXkLWZpO+XXl4DM1QhMnlJa/VQrNmJQ/ey3gZryHVTi3d9yMjYSI4/AInif3b/jGfVMwhCv8Wu245HEmypxvOGiTP69v7ew94WMU2/A4aIy96A7yDn3VDVaV9sMuOMeb+nVq4fAzqeSa7dLOhbZxeEnWJzbOiqaZQsMnQffUWiMs1l1GV7pe6bCN0mdNdPU8pP5boUV5iYkoG4tQ/0EM602nnFZo1tnOkuaSknAqUxn37FyHAU8ANf8zT0Sw8dtCYYxSATuxr1KYNxIaT1IPhEvTgZRTnA0TXW4tuIXheMo6fZCHZbg2yC26XCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YpMjh9uxQJtkogkP3vSDNy6NFg6HZXiQrR5kCE5guj8=;
 b=UZAEYRRzUmhQlWp8sZk+CNuT4djnqGJ82onKPVQn54sUm8/GYjS7qNRQ00Z3+dV4gq8gtKY8tdVbsmXhp1scKcicsuaP8xD1YgKeLtnXkdz7vkO3tua0il6cIZOlry9Yh+PMrThU6AOw6bHbg6poX+exo3xXEa6mwFmML2tTAVMezgL5sCf+3+L+oW7EXVa7QJHGkiLB4D+vWAa2EGIM/3kpWCmqwyWg6JRzuuELBZGndmudmTAnpBlItLFqSKVrrPVbi1I670+vIRadhDM1IUrexhiyMGGQY3IpmmNKHT3CddNHVBKuFLKuFUgZpnJuizI/WmNSRa44btw5dLl/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YpMjh9uxQJtkogkP3vSDNy6NFg6HZXiQrR5kCE5guj8=;
 b=u62vSY6hJHntpL1dL8863p4NJJzjiW1v9T1XfXF8V10OJMXGSZeuwzFlInZbivorJVJHSa6RsGWMCWrvsaExlQ/ulHPxmWNr4yGfhbQagDP9VMm5PhtgmBCsX1qsHhRisxBm/50A1WBW6scy9zDx35t5MsfpYy7HdDaAN3lmFsY=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by CO1PR18MB4811.namprd18.prod.outlook.com (2603:10b6:303:ee::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Mon, 18 Mar
 2024 17:36:57 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::9728:b607:b464:a2dc]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::9728:b607:b464:a2dc%7]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 17:36:56 +0000
From: Srujana Challa <schalla@marvell.com>
To: Jonah Palmer <jonah.palmer@oracle.com>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
CC: "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com"
	<jasowang@redhat.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>,
        "raphael@enfabrica.net"
	<raphael@enfabrica.net>,
        "kwolf@redhat.com" <kwolf@redhat.com>,
        "hreitz@redhat.com" <hreitz@redhat.com>,
        "pasic@linux.ibm.com"
	<pasic@linux.ibm.com>,
        "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>,
        "david@redhat.com" <david@redhat.com>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>,
        "cohuck@redhat.com"
	<cohuck@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "fam@euphon.net" <fam@euphon.net>,
        "stefanha@redhat.com"
	<stefanha@redhat.com>,
        "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
        "qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>,
        "leiyang@redhat.com"
	<leiyang@redhat.com>,
        Vamsi Krishna Attunuru <vattunuru@marvell.com>,
        Jerin
 Jacob <jerinj@marvell.com>,
        "dtatulea@nvidia.com" <dtatulea@nvidia.com>,
        "virtio-fs@lists.linux.dev" <virtio-fs@lists.linux.dev>
Subject: RE: [EXTERNAL] [PATCH v3 for 9.1 5/6] vhost/vhost-user: Add
 VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
Thread-Topic: [EXTERNAL] [PATCH v3 for 9.1 5/6] vhost/vhost-user: Add
 VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
Thread-Index: AQHadvm+nv9RkeGvxEucZP7sjx33xLE9x0UA
Date: Mon, 18 Mar 2024 17:36:56 +0000
Message-ID: 
 <DS0PR18MB53681506B2D1472731345484A02D2@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240315165557.26942-1-jonah.palmer@oracle.com>
 <20240315165557.26942-6-jonah.palmer@oracle.com>
In-Reply-To: <20240315165557.26942-6-jonah.palmer@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|CO1PR18MB4811:EE_
x-ms-office365-filtering-correlation-id: d5e81ef9-b2da-4ccf-69ed-08dc4772022b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 jqzI4OoMUPHjnl416pKCIoUc559AKZB9YG9fK2quJIQKRh+UllMFGjC+8Xgj2wtLLUH51CUgjhzol7BGWnxl206bLFfUCuFHT6rjhzy4PnDMSzI3+i9sifI95QNPQOlYy8bPg0SD07w1dZesBHtS5WFESLVKMM2rlef/AMnrJ4hbRA4pOwGUDj2VgFabkOaM6GWtgoHWpQPaMzRLTUwpU+UEvAcedKkFO8gZvEHsHikJ/Ia1gslt5gNWmEpX8IesPQiAp1lj3jHS6kPF+/n916A9e/EtuNNt2gPMk65rowmzMYpdRKeBaPwG3TF0EBVs6VtF9ko1+2T4nCDvPNukCGyp3Ms13Qww2S6dl4y3yEvQ13k5Xvlvcnb4jR0vvlTGUeYQFohmlf83jKu1FxVCH04dHXu7q8MaXhT20Hxtz4IxvwSNhQOE7Qh7rlsF1FNrQ68jVaNISZWr7UqzCA0bK8SciHWcOua/Tz9IAshZtZnwZEK/4R9bIjrNduxIQ0D6PobVy9QEJe04wu4T1eNQP/5GCAk96lPO7rjKkATZXNiJT2MvLNyC0GyIhpnMiV3zVqiG7Ch/0g36/rflhDnNPyLXvXNK6I4bNitLNPgCgbwNHg4Q7B2PSynBPk5Wz+x4WsXXGw9+O1lAhkR/yS0cCk83/7ExsFap2NTcFerFLF+jvv45JSc7Bxsjsvbh/DYE4ZxkUZxotey1qczmt36NTok3ss8Qdnhf1MxhO+sz1Ro=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?aytJVzZHUGwvRkUrVUNneDFlMm5EeXlWRGk3d2VIaGJFT3Y3bjN2enNlRFpN?=
 =?utf-8?B?ZHNuUk55dnlvbWdPd1liTThGdnBpc0lQa1BqRU40Z0JHY3gvTDVoUndLMFU2?=
 =?utf-8?B?b09zYXV4L1Ntc081N1lMY1BvOUYzTms1OEFQRkNZU2l6Rm1XMGdKOW1BTnFJ?=
 =?utf-8?B?UFdSbnZtdUVLbDBSejVBL1laWFozU0ZJOC9tOVJuL3dwVkw0RTJndlR1V08v?=
 =?utf-8?B?L1ZEd2k1RWRITnRJMHdnbysyOXZFUHBYWXdpcExza0xyMGY1RUFraDZJUld5?=
 =?utf-8?B?VGVkN21VRnI1ODJKWUVsMVhVZVZzK29leXVvaCtHNS8wK0prQmR5OVJ5Z2gw?=
 =?utf-8?B?amJFRmgxM0hVaXJsRWhJM2JEVFlqS1YwSkd6ZFFXNnpFSVNGWUNtUFU2amxN?=
 =?utf-8?B?cDZVcW9mLzJsRktWM0kyRTZyTnNqaFdyQm13R3EvWGpidlJrYkxGbzVuUFpo?=
 =?utf-8?B?SHlnWGJmdlpWQjVpOWl4Qi9TTXczWHBmbnI4YkNINGg5VmREbm5BeUczWjhT?=
 =?utf-8?B?L201Z2l6MENiOXpmMmJBaGgvcWxDQ0NPbTVPK1gwUmZHNStYU1JFaDJmYU5x?=
 =?utf-8?B?T2MxWncyMm54RlVLTzB4TXpzVzR6eWhMeFRUZ0h3TXdnSVphRTdEMzU0T3R0?=
 =?utf-8?B?b1NCWllFVFAzaXJwRS9ZRW15TmZSYzUzQVJyaVNPZjYrelRWRmV0Y3dpUm1Z?=
 =?utf-8?B?UTAyQ3luRU5LeFNvYkpZdy81Y24rdlZhbnRMVXUrbzNqcThDcXc0SEZrUmtv?=
 =?utf-8?B?cmcrSGs0R29sc2c5NmZPb1g2T2lmamJkc1AxVFNJM3hLVmwwOXFvUUx4eExS?=
 =?utf-8?B?OEtmNXdvb3h1NjhvOHRRSjNHc0RIM0hPQVAwcUlCWXUyN041VEhwMkEzTEF0?=
 =?utf-8?B?aG8rcU1yaWtINklqdnM4WXpjeTNNTHV0OVlMSVpmeUV5VmtQYjBIT2c0YXlj?=
 =?utf-8?B?U01qdHp1c0NxWTNJbGY1eTRocFBNVjA1cGRKMWpseTFrSkExTUo5RVNnZ3N1?=
 =?utf-8?B?eS93SUNacXl4UzdyN3FyWGZKeFc4UG5SRTdkOVYzKzJ1MGxSZUxBOU5FRUx6?=
 =?utf-8?B?TVFhdGgxQVhFN0ZXY0gzRnNGeGd0eG90K3lVKy8zYitNZFR1enRyN2poMTJy?=
 =?utf-8?B?UHRUNlNwT2hDQVhVSzcxbG9mZklOL1djRThkNVlrYU9HWTRTMlBPdHBvM20x?=
 =?utf-8?B?TEdnVW9iVW9oQzU0OG80NDlMS0U2Tm4zRTFRWGZReXdqYlpqTE9mM0I2ZXNV?=
 =?utf-8?B?amp3TWw5MmJXVDlVYitTYUxITVJzVzdhMms0VTRLdXRjQUU2MS9mOHV6bHFH?=
 =?utf-8?B?azU2S09OTGRZRGVlZWZ0OEF0bWs2Qm5tV2N2UnZhb1ZNbHAxMXJjK2FyU3FZ?=
 =?utf-8?B?YXZNVVdYV1VvZjFoZnJ4YWlFTUFGdkZkQWNzYlR4eENqSnQyOXMxL0JERW42?=
 =?utf-8?B?NVlRSmt4WWhqby82OU1NN1BETC9RNTNyZk9ENU1TTGZkb250L0c2QjdSa3Nq?=
 =?utf-8?B?SGtyRFhYcG9GOTZsdFB5VlZLcVRsRVBPMWRNZkNOZ0RRS0VKQzhlVXFCTHBR?=
 =?utf-8?B?MitiNlNDRWZuYks0dTJSZkc0WVN2dk9RVE8wVnVKVkV0RWlJbXRFa2RhaGpQ?=
 =?utf-8?B?dFVjNkZRMTJUTm5vclVjM2FINFIxVm11ZFl4OFlmN3pjUjlSR1JJRDBueEtI?=
 =?utf-8?B?S2hBZkFKR0o4bHFnUE1aaWRXbFJobEQrZ1VHSUNZdU5CRFZwS1BCR3JvMHdJ?=
 =?utf-8?B?amM3SmcxbjZjZHBRT0RaNm5Fa2RlMzdyaGFKTU9yVklGVG1pTmtyMTBiMGV2?=
 =?utf-8?B?VklIMEtkK1B3ODNmL2JYN1ZreWtteVNoQU5qSjVPSmhQOS9LQWl2WWpaNVAv?=
 =?utf-8?B?VHdrdG8zNFlJM2dlczYyWEVMeXN0a1o5WDdRaElRVXU3azVvaE9zRXJEZEJl?=
 =?utf-8?B?enhhS01uclJHNkd1QUdDRU9jNmN4aFZQaGhxMnRrUGdQN1Qvak9EV2wvejMx?=
 =?utf-8?B?cUZiOE85MVhOME84WlN1b1UzVFBvajBUQUwwa2JXU2cxcXFrUGc5VjhPSlNI?=
 =?utf-8?B?UkVtd1JWMUZpT0pDeUZhNTlCLzlOWmlFSzNSSlNtVERHdFhDbXVYMzFvWm5P?=
 =?utf-8?Q?CmLwssW6oZLVJtlBYvKmf+Tpz?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e81ef9-b2da-4ccf-69ed-08dc4772022b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2024 17:36:56.7813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: En3xv0JM3hsh1Qn3DSBymB05bghAGo+3NI+bo8idjsAwOpRoXv14BWnlziVqc3PVo0VB4irZj0bxvXIagBGD/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4811
X-Proofpoint-ORIG-GUID: l3Fa9pxtZSpRWKprc4EW2d8BoFL5s9gj
X-Proofpoint-GUID: 3x3tLeX405d_YLVGHRaxgWDVtqSiRBCc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-18_12,2024-03-18_03,2023-05-22_02

PiBTdWJqZWN0OiBbRVhURVJOQUxdIFtQQVRDSCB2MyBmb3IgOS4xIDUvNl0gdmhvc3Qvdmhvc3Qt
dXNlcjogQWRkDQo+IFZJUlRJT19GX05PVElGSUNBVElPTl9EQVRBIHRvIHZob3N0IGZlYXR1cmUg
Yml0cw0KPiANCj4gUHJpb3JpdGl6ZSBzZWN1cml0eSBmb3IgZXh0ZXJuYWwgZW1haWxzOiBDb25m
aXJtIHNlbmRlciBhbmQgY29udGVudCBzYWZldHkNCj4gYmVmb3JlIGNsaWNraW5nIGxpbmtzIG9y
IG9wZW5pbmcgYXR0YWNobWVudHMNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gQWRkIHN1cHBvcnQg
Zm9yIHRoZSBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFUQSBmZWF0dXJlIGFjcm9zcyBhIHZhcmll
dHkgb2YNCj4gdmhvc3QgZGV2aWNlcy4NCj4gDQo+IFRoZSBpbmNsdXNpb24gb2YgVklSVElPX0Zf
Tk9USUZJQ0FUSU9OX0RBVEEgaW4gdGhlIGZlYXR1cmUgYml0cyBhcnJheXMgZm9yDQo+IHRoZXNl
IGRldmljZXMgZW5zdXJlcyB0aGF0IHRoZSBiYWNrZW5kIGlzIGNhcGFibGUgb2Ygb2ZmZXJpbmcg
YW5kIHByb3ZpZGluZw0KPiBzdXBwb3J0IGZvciB0aGlzIGZlYXR1cmUsIGFuZCB0aGF0IGl0IGNh
biBiZSBkaXNhYmxlZCBpZiB0aGUgYmFja2VuZCBkb2VzIG5vdA0KPiBzdXBwb3J0IGl0Lg0KPiAN
Cj4gVGVzdGVkLWJ5OiBMZWkgWWFuZyA8bGVpeWFuZ0ByZWRoYXQuY29tPg0KPiBSZXZpZXdlZC1i
eTogRXVnZW5pbyBQw6lyZXogPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IEpvbmFoIFBhbG1lciA8am9uYWgucGFsbWVyQG9yYWNsZS5jb20+DQo+IC0tLQ0KQWNrZWQtYnk6
IFNydWphbmEgQ2hhbGxhIDxzY2hhbGxhQG1hcnZlbGwuY29tPg0KDQo+ICBody9ibG9jay92aG9z
dC11c2VyLWJsay5jICAgIHwgMSArDQo+ICBody9uZXQvdmhvc3RfbmV0LmMgICAgICAgICAgIHwg
MiArKw0KPiAgaHcvc2NzaS92aG9zdC1zY3NpLmMgICAgICAgICB8IDEgKw0KPiAgaHcvc2NzaS92
aG9zdC11c2VyLXNjc2kuYyAgICB8IDEgKw0KPiAgaHcvdmlydGlvL3Zob3N0LXVzZXItZnMuYyAg
ICB8IDIgKy0NCj4gIGh3L3ZpcnRpby92aG9zdC11c2VyLXZzb2NrLmMgfCAxICsNCj4gIG5ldC92
aG9zdC12ZHBhLmMgICAgICAgICAgICAgfCAxICsNCj4gIDcgZmlsZXMgY2hhbmdlZCwgOCBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaHcvYmxvY2svdmhv
c3QtdXNlci1ibGsuYyBiL2h3L2Jsb2NrL3Zob3N0LXVzZXItYmxrLmMgaW5kZXgNCj4gNmE4NTZh
ZDUxYS4uOTgzYzA2NTdkYSAxMDA2NDQNCj4gLS0tIGEvaHcvYmxvY2svdmhvc3QtdXNlci1ibGsu
Yw0KPiArKysgYi9ody9ibG9jay92aG9zdC11c2VyLWJsay5jDQo+IEBAIC01MSw2ICs1MSw3IEBA
IHN0YXRpYyBjb25zdCBpbnQgdXNlcl9mZWF0dXJlX2JpdHNbXSA9IHsNCj4gICAgICBWSVJUSU9f
Rl9SSU5HX1BBQ0tFRCwNCj4gICAgICBWSVJUSU9fRl9JT01NVV9QTEFURk9STSwNCj4gICAgICBW
SVJUSU9fRl9SSU5HX1JFU0VULA0KPiArICAgIFZJUlRJT19GX05PVElGSUNBVElPTl9EQVRBLA0K
PiAgICAgIFZIT1NUX0lOVkFMSURfRkVBVFVSRV9CSVQNCj4gIH07DQo+IA0KPiBkaWZmIC0tZ2l0
IGEvaHcvbmV0L3Zob3N0X25ldC5jIGIvaHcvbmV0L3Zob3N0X25ldC5jIGluZGV4DQo+IGU4ZTE2
NjE2NDYuLmJiMWY5NzViMzkgMTAwNjQ0DQo+IC0tLSBhL2h3L25ldC92aG9zdF9uZXQuYw0KPiAr
KysgYi9ody9uZXQvdmhvc3RfbmV0LmMNCj4gQEAgLTQ4LDYgKzQ4LDcgQEAgc3RhdGljIGNvbnN0
IGludCBrZXJuZWxfZmVhdHVyZV9iaXRzW10gPSB7DQo+ICAgICAgVklSVElPX0ZfSU9NTVVfUExB
VEZPUk0sDQo+ICAgICAgVklSVElPX0ZfUklOR19QQUNLRUQsDQo+ICAgICAgVklSVElPX0ZfUklO
R19SRVNFVCwNCj4gKyAgICBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFUQSwNCj4gICAgICBWSVJU
SU9fTkVUX0ZfSEFTSF9SRVBPUlQsDQo+ICAgICAgVkhPU1RfSU5WQUxJRF9GRUFUVVJFX0JJVA0K
PiAgfTsNCj4gQEAgLTU1LDYgKzU2LDcgQEAgc3RhdGljIGNvbnN0IGludCBrZXJuZWxfZmVhdHVy
ZV9iaXRzW10gPSB7DQo+ICAvKiBGZWF0dXJlcyBzdXBwb3J0ZWQgYnkgb3RoZXJzLiAqLw0KPiAg
c3RhdGljIGNvbnN0IGludCB1c2VyX2ZlYXR1cmVfYml0c1tdID0gew0KPiAgICAgIFZJUlRJT19G
X05PVElGWV9PTl9FTVBUWSwNCj4gKyAgICBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFUQSwNCj4g
ICAgICBWSVJUSU9fUklOR19GX0lORElSRUNUX0RFU0MsDQo+ICAgICAgVklSVElPX1JJTkdfRl9F
VkVOVF9JRFgsDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaHcvc2NzaS92aG9zdC1zY3NpLmMgYi9ody9z
Y3NpL3Zob3N0LXNjc2kuYyBpbmRleA0KPiBhZTI2YmMxOWE0Li4zZDVmZTA5OTRkIDEwMDY0NA0K
PiAtLS0gYS9ody9zY3NpL3Zob3N0LXNjc2kuYw0KPiArKysgYi9ody9zY3NpL3Zob3N0LXNjc2ku
Yw0KPiBAQCAtMzgsNiArMzgsNyBAQCBzdGF0aWMgY29uc3QgaW50IGtlcm5lbF9mZWF0dXJlX2Jp
dHNbXSA9IHsNCj4gICAgICBWSVJUSU9fUklOR19GX0VWRU5UX0lEWCwNCj4gICAgICBWSVJUSU9f
U0NTSV9GX0hPVFBMVUcsDQo+ICAgICAgVklSVElPX0ZfUklOR19SRVNFVCwNCj4gKyAgICBWSVJU
SU9fRl9OT1RJRklDQVRJT05fREFUQSwNCj4gICAgICBWSE9TVF9JTlZBTElEX0ZFQVRVUkVfQklU
DQo+ICB9Ow0KPiANCj4gZGlmZiAtLWdpdCBhL2h3L3Njc2kvdmhvc3QtdXNlci1zY3NpLmMgYi9o
dy9zY3NpL3Zob3N0LXVzZXItc2NzaS5jIGluZGV4DQo+IGE2M2IxZjQ5NDguLjBiMDUwODA1YTgg
MTAwNjQ0DQo+IC0tLSBhL2h3L3Njc2kvdmhvc3QtdXNlci1zY3NpLmMNCj4gKysrIGIvaHcvc2Nz
aS92aG9zdC11c2VyLXNjc2kuYw0KPiBAQCAtMzYsNiArMzYsNyBAQCBzdGF0aWMgY29uc3QgaW50
IHVzZXJfZmVhdHVyZV9iaXRzW10gPSB7DQo+ICAgICAgVklSVElPX1JJTkdfRl9FVkVOVF9JRFgs
DQo+ICAgICAgVklSVElPX1NDU0lfRl9IT1RQTFVHLA0KPiAgICAgIFZJUlRJT19GX1JJTkdfUkVT
RVQsDQo+ICsgICAgVklSVElPX0ZfTk9USUZJQ0FUSU9OX0RBVEEsDQo+ICAgICAgVkhPU1RfSU5W
QUxJRF9GRUFUVVJFX0JJVA0KPiAgfTsNCj4gDQo+IGRpZmYgLS1naXQgYS9ody92aXJ0aW8vdmhv
c3QtdXNlci1mcy5jIGIvaHcvdmlydGlvL3Zob3N0LXVzZXItZnMuYyBpbmRleA0KPiBjY2EyY2Q0
MWJlLi5hZTQ4Y2MxYzk2IDEwMDY0NA0KPiAtLS0gYS9ody92aXJ0aW8vdmhvc3QtdXNlci1mcy5j
DQo+ICsrKyBiL2h3L3ZpcnRpby92aG9zdC11c2VyLWZzLmMNCj4gQEAgLTMzLDcgKzMzLDcgQEAg
c3RhdGljIGNvbnN0IGludCB1c2VyX2ZlYXR1cmVfYml0c1tdID0gew0KPiAgICAgIFZJUlRJT19G
X1JJTkdfUEFDS0VELA0KPiAgICAgIFZJUlRJT19GX0lPTU1VX1BMQVRGT1JNLA0KPiAgICAgIFZJ
UlRJT19GX1JJTkdfUkVTRVQsDQo+IC0NCj4gKyAgICBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFU
QSwNCj4gICAgICBWSE9TVF9JTlZBTElEX0ZFQVRVUkVfQklUDQo+ICB9Ow0KPiANCj4gZGlmZiAt
LWdpdCBhL2h3L3ZpcnRpby92aG9zdC11c2VyLXZzb2NrLmMgYi9ody92aXJ0aW8vdmhvc3QtdXNl
ci12c29jay5jIGluZGV4DQo+IDk0MzFiOTc5MmMuLjgwMmI0NGEwN2QgMTAwNjQ0DQo+IC0tLSBh
L2h3L3ZpcnRpby92aG9zdC11c2VyLXZzb2NrLmMNCj4gKysrIGIvaHcvdmlydGlvL3Zob3N0LXVz
ZXItdnNvY2suYw0KPiBAQCAtMjEsNiArMjEsNyBAQCBzdGF0aWMgY29uc3QgaW50IHVzZXJfZmVh
dHVyZV9iaXRzW10gPSB7DQo+ICAgICAgVklSVElPX1JJTkdfRl9JTkRJUkVDVF9ERVNDLA0KPiAg
ICAgIFZJUlRJT19SSU5HX0ZfRVZFTlRfSURYLA0KPiAgICAgIFZJUlRJT19GX05PVElGWV9PTl9F
TVBUWSwNCj4gKyAgICBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFUQSwNCj4gICAgICBWSE9TVF9J
TlZBTElEX0ZFQVRVUkVfQklUDQo+ICB9Ow0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC92aG9zdC12
ZHBhLmMgYi9uZXQvdmhvc3QtdmRwYS5jIGluZGV4DQo+IDJhOWRkYjQ1NTIuLjU1ODNjZTUyNzkg
MTAwNjQ0DQo+IC0tLSBhL25ldC92aG9zdC12ZHBhLmMNCj4gKysrIGIvbmV0L3Zob3N0LXZkcGEu
Yw0KPiBAQCAtNjEsNiArNjEsNyBAQCBjb25zdCBpbnQgdmRwYV9mZWF0dXJlX2JpdHNbXSA9IHsN
Cj4gICAgICBWSVJUSU9fRl9SSU5HX1BBQ0tFRCwNCj4gICAgICBWSVJUSU9fRl9SSU5HX1JFU0VU
LA0KPiAgICAgIFZJUlRJT19GX1ZFUlNJT05fMSwNCj4gKyAgICBWSVJUSU9fRl9OT1RJRklDQVRJ
T05fREFUQSwNCj4gICAgICBWSVJUSU9fTkVUX0ZfQ1NVTSwNCj4gICAgICBWSVJUSU9fTkVUX0Zf
Q1RSTF9HVUVTVF9PRkZMT0FEUywNCj4gICAgICBWSVJUSU9fTkVUX0ZfQ1RSTF9NQUNfQUREUiwN
Cj4gLS0NCj4gMi4zOS4zDQoNCg==
