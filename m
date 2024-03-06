Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2103.outbound.protection.outlook.com [40.107.244.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7B95F542
	for <virtio-fs@lists.linux.dev>; Wed,  6 Mar 2024 09:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.103
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716628; cv=fail; b=poD5rjy72Fa/ZpUwy0QsP7ECpW77XvTmUIf4zTled21uOtHf7LPuTjH1YGx1WxgnqG19ZgVaTBlA92FRaWN3oCIc9IV0vvPve5W93WnL4glrRfE2xFIH3N6uiBpjMB4MsPWFUXrSPpwsuW69exC9vqkxvi+8RJKw6nDZ8pbaaBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716628; c=relaxed/simple;
	bh=6x5BwLlhlo6gy2LHJRo2FeWqaPywm0roI02wY0qAmdo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=REkgZ2luIxEVJ96Y/DsEfasjIpnpelU4SbfbTZuARVkXQ+spEsIUVDFmHwdV4h2M+DShvEQAzz7wOwohMOUJYn/7c7YDK6MeVgS3yJaLu+XiIpidF3y0H70v9Aj8shrgBI8UeooJ/HeemVAgboeDY3qLAluaYa8AeLmsPdB4DpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nephogine.com; spf=pass smtp.mailfrom=nephogine.com; dkim=pass (2048-bit key) header.d=nephogine.com header.i=@nephogine.com header.b=q4oSG5k8; arc=fail smtp.client-ip=40.107.244.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nephogine.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nephogine.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nephogine.com header.i=@nephogine.com header.b="q4oSG5k8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9SBi5L1hMRGlxxYgT+BqfcLupa249qkbmZu9943rWSLbrxZX8iu+TFOWH2kUm8vPEX6Q6J5SiZm06/3pPCUwpIeXCh3ur3qbcvUq+xf8ZlpvL0LDo00ENfJxShtWMajkGqpSskGNCBRl+d4FDd7SiJRDfYd2ihK6HQiCLRnnLC0tvDsWd9c2Ia9Hlt9m1WkKHh8OTEN5TQV2pXNEY5TceyayN/kSG07pMaSNNgQMD3k0GV7DnOJQfr460Xirm5adca29EJ7ZETkcEPNuCLIKA0iM05Rstb0EVOncQfF3dAhCtxnx11hzPMlyqnvreECPKUNnF8+3GEweFXEh5OD5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6x5BwLlhlo6gy2LHJRo2FeWqaPywm0roI02wY0qAmdo=;
 b=ecit+nniT4Y0rYW5EYoQ0BF1TcoCBttJCogzMGVMc3scp7ykZfQJT+Qc6gOFBnV5W/DXwZIFMFKaf6lXi8PdzIj4OBd6LBFn1JGfOPZzDh7bCkgsLaTbaq7KvrdKEzirB4NjhzI2XAUWqV0DinKz87AeC++4IgSrb9DDoqbfdzJqVKKan1NItT92WL/UK1qIliOEWhGcytQpe82IZ8eb6LL5P/38T+WOHeGt796cjzl2KS0hTh+UjJO+wMQiex+pdl842koG962MQLofH5hyqEfCsBUnwI6SJq+BMFhG2A0K1/89yhASGkUT18S9rZCSOGnuOh/DAuPNACwO824n6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nephogine.com; dmarc=pass action=none
 header.from=nephogine.com; dkim=pass header.d=nephogine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nephogine.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6x5BwLlhlo6gy2LHJRo2FeWqaPywm0roI02wY0qAmdo=;
 b=q4oSG5k8UF34lpiKll5FteX3U8PJ4ohsXnl8t9Z5YOUBlkhol7hQiY69xnRjhSi4IdCIh0/ZD+4GvDGd3fW32kV7fB4WCT8CzNZj/j3S2iMg+3Z9pQViWymzzqUuwOK8a/x8mMZ8cel8IqiJqtU1q5eg4P+l1yg5IYoWzHFmUA6u/Yr4cwHQsu4XO0jSdJ8O+v91Nx/f2TAX9KbeqfiXGOKX54OunMFNTzcsUAn9EuS8HaeHfXLw/3x4GpPe725fCeOu07JRrZ2oaYIRKa3xYngKCXK0pNVRGtmPyGz0d3BCLov46YV5kOgEYRnQri1CVQgqlLeUa5E78vtv8VVW9g==
Received: from PH0PR13MB5682.namprd13.prod.outlook.com (2603:10b6:510:111::19)
 by SN4PR13MB5358.namprd13.prod.outlook.com (2603:10b6:806:20b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 6 Mar
 2024 09:17:02 +0000
Received: from PH0PR13MB5682.namprd13.prod.outlook.com
 ([fe80::559:1c9e:f927:c0f2]) by PH0PR13MB5682.namprd13.prod.outlook.com
 ([fe80::559:1c9e:f927:c0f2%5]) with mapi id 15.20.7316.035; Wed, 6 Mar 2024
 09:17:02 +0000
From: Xinying Yu <xinying.yu@nephogine.com>
To: Eugenio Perez Martin <eperezma@redhat.com>, Thomas Huth <thuth@redhat.com>
CC: Wentao Jia <wentao.jia@nephogine.com>, Rick Zhong
	<zhaoyong.zhong@nephogine.com>, Jonah Palmer <jonah.palmer@oracle.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "mst@redhat.com"
	<mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "raphael@enfabrica.net"
	<raphael@enfabrica.net>, "kwolf@redhat.com" <kwolf@redhat.com>,
	"hreitz@redhat.com" <hreitz@redhat.com>, "pasic@linux.ibm.com"
	<pasic@linux.ibm.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "farman@linux.ibm.com" <farman@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "richard.henderson@linaro.org"
	<richard.henderson@linaro.org>, "david@redhat.com" <david@redhat.com>,
	"iii@linux.ibm.com" <iii@linux.ibm.com>, "cohuck@redhat.com"
	<cohuck@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"fam@euphon.net" <fam@euphon.net>, "stefanha@redhat.com"
	<stefanha@redhat.com>, "qemu-block@nongnu.org" <qemu-block@nongnu.org>,
	"qemu-s390x@nongnu.org" <qemu-s390x@nongnu.org>, "virtio-fs@lists.linux.dev"
	<virtio-fs@lists.linux.dev>
Subject: RE: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
Thread-Topic: [RFC 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
Thread-Index: AQHabBevlMLGKrDWtkqrfBcQc5nAI7EobiuZgABipwCAAaIVsA==
Date: Wed, 6 Mar 2024 09:17:02 +0000
Message-ID:
 <PH0PR13MB5682B1B136F763453D0343AC88212@PH0PR13MB5682.namprd13.prod.outlook.com>
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <CAJaqyWfD96Dh9gVavzC22KuaG4bwJ0m7sbWOsy9fR4y1HJ3-Gg@mail.gmail.com>
 <PH0PR13MB56827829C8502484EACF080D88222@PH0PR13MB5682.namprd13.prod.outlook.com>
 <CAJaqyWdr5PyxNJ2D_HMk8U2xEpfPTebi4d91V3ONs91yNibwOw@mail.gmail.com>
In-Reply-To:
 <CAJaqyWdr5PyxNJ2D_HMk8U2xEpfPTebi4d91V3ONs91yNibwOw@mail.gmail.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nephogine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB5682:EE_|SN4PR13MB5358:EE_
x-ms-office365-filtering-correlation-id: e44f931e-1c85-4c51-3b18-08dc3dbe2f2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Q4HiBS1a1cYyrdBna0ICmUykYj+h74mRMcEZA6nnesmYmvB13jcmHGWZBrIEABnPjZUHCFaAYpSKvzQwvSSnoPjBBR+XnratJWIacOO5YBYdgb/2V5Q4JLmgzYtbzXnMEppg1GwbZH8bdfXjSxTuLlLWsX+BTohDnMlHjFxxJT1iw9HiJxPDJfb+WhDq1q9kDCgATDxnoR8DImjFL+vi9XFyUs6iKB7cnalRAyIbi2yoatz4l6yv9h7jblbLUDxEiBB9V/eZE7vS+s6I+TGpF3ccf3fFa4GTzoaZp41MqWFFjOC7/ZG4za9hzaubzRUnxwSTyigf3RU3WrGZbMQ1HCjLxEjCj0NA9JRYPXvbqrovR0LgPC+hMEUUJFw+XtzY3oiXhjg/y6JaEli12UHSv2jrxLX3kzsRNERzJHGRUKxznqPSj7noScFFqShuRac0p/gBcccAqbplBevs7x89aSfpAGN2B/kSIgG91AHuadhoHmqcUKEBZSXOfFYL32qkDKBtEWDB6EqC7eAivTXoIK/velLM56kAauX+OA9O7dF9M8Lxl7XRLmYCdiaHL/9gao80yrDQ2mcrxeEdJppY9PTG8MbT3dPZvmsCCuD5sgUisQlXfvCg6us8ThzvshHa9e3OUr5xx9vQNikX3yrht6N+ZpJotMxEBRxZucJOEFA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB5682.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RWxEWXBLWmExZUZGZHVnV2t3SGhXandzQ2RMZk9YMWJxbTV4eWQzSGRRUDdW?=
 =?utf-8?B?WHZTSWxFaVowVmR2NlJHZ0ZEckkwbXczc3k4UkEzNWE0czVaTkMrT2M1c3hG?=
 =?utf-8?B?SzY2WkE5bk1GeFdwOTVwcy83TldhR0hSaW4xVkJLUTBVeitWU1VpSXJJNnR6?=
 =?utf-8?B?a1RldHlaK3M1WjlOQmc3Njh3bHBUU25Pbng4RjhGY3VVQ0Q4L0xwT1A4akc5?=
 =?utf-8?B?SG5yUjZ4Yy9nRkxPOW9IWWh5dksxMy80Zllha3F3Wk91TjczNEVmRUgrR09L?=
 =?utf-8?B?eUZHbnZYSlJ2K00zZzJkcmxuUjJwQVdiNDhUMTY0ZEZvbVZxbWNSc2d4VTJP?=
 =?utf-8?B?VlBpLzhVM0tQdFI2ZzNjM2VOdGVoNS9UMTRZQTlIWjhUQXlTaENIOUJGTEZs?=
 =?utf-8?B?T1gyQ0liWHg4dmRjRmIyV2VkNmI4dmF1UlM3eUovcXEydVFXeDlxR3RJTmx4?=
 =?utf-8?B?ci9IVVQ4S3N4aXRrRy9PZE5acVg0bjZWNnB5Y3FBVlp3NndQZEsyWUY5cnZz?=
 =?utf-8?B?Y1I3dUh5TVlXdmN1Vzc2Z25ISXdoQ3V5clNqSVNOaTB3RWVBek1UeFUxYXlF?=
 =?utf-8?B?V2NJRkhkWTVudW1qS0VkTStyVlgxN0FoSStuTEN2QnJHZzE3WU8xQ3E3YWFK?=
 =?utf-8?B?QWFuc25MWnBydXMrSWI4YXlCSnRHcEd0Wmc0SzdSMmxLMCs0c3FibGdaNzZ6?=
 =?utf-8?B?aEgyblYyRmNQSVN5M0ZqU3JjVlJRVUg0YlJtOXYzaGZrcEdjTGJBWlN3ZlBV?=
 =?utf-8?B?T052QnlRa3FGd0xTRWlIdE5JTDRaalRSZERpeUtVTjBJUGpYa25QYjcvcWUr?=
 =?utf-8?B?eVJ2QndWdWV0KzNIVFdoVU9vc0UreDd0cXVhcnJKZkNhcG1KQkJ6QnQ1d1lm?=
 =?utf-8?B?ZkNBZ2dMcU4zeUVKRzhPVTVHY3QyTzR0d2tiLzJKVXFCUmRCeVpUd2NiY0t4?=
 =?utf-8?B?N1FBQnBXdTFYN1gxejdvNFY0OUVzRUFkS2RHN0tUUmVKOEt0LzBUMmNMaTNZ?=
 =?utf-8?B?N1BSWUZ6YXR3dUp3ckJ4bU5WcGl4TUpLTW16Q0YvODF4cEdXczkvV0dZRzNy?=
 =?utf-8?B?TDNzeVRwQ2gvWGJwSStydVM5OXd2Um1mUjI0cWR0MHhXMjhoS0lwSzJVWmVi?=
 =?utf-8?B?L3VmWHFSSUxHWjJ1bDNtdG1uZ28vdjBEN2E0TWFmeGxmcUxVbTFsV3ZqQU9Q?=
 =?utf-8?B?SFUrRlJrUG9oZzJRZ3B5NXdQMHptcVJZWHgwbTdsRG5CL3lkZU5DQkpjaVgx?=
 =?utf-8?B?b1hLMFZ0Zk9nTXVERmpnVkltLzlBOUZaSVA5WHUrYVFaaUswWm8rYmtJN29Z?=
 =?utf-8?B?UTg0dU50eFNKYlBMUXNVL1NsOFpRUC90TTRLZ2twa1dlYkxUbnhnb1lxU1VK?=
 =?utf-8?B?OHFTVklrRmp1LzlYUVpNUHA2d1czMGxxbTNBYTAvZjZDQVpseFBjKzM2K0hK?=
 =?utf-8?B?bHc1UzlrWWpVUjUrcU13ME9hTlVodDFVcFlXZER1T0x3OXJLNVgvS3RGMFhD?=
 =?utf-8?B?Qmw5WU1pZXFndmNwQUtDdmFCY3puM1VnbkllSDJoR2FsSDZ1cnIrTjBRa2Rr?=
 =?utf-8?B?ZXRvbmsvb2I5dE1XVXg5NVF4anhTODhXZ1E4Rkl2U0xoNnNkSitsNjRXWEJt?=
 =?utf-8?B?ZCtKMnVuWFZ2QWJQNkxLNU82am9lb2F5c2F4SHlRQzEzL2tXa1kxWlZqWHlr?=
 =?utf-8?B?YjBMaVJ3NEloY0Y5aHFaWkgrWjQ3aDB1alY5Z3IvK3pkMHhnbUlhU3BKL0hX?=
 =?utf-8?B?WUxrVUt6ejZBQlZUcmRZdlhkRU5nQy9JR1BEaUNWWWxpZExxMHpLZEVPb2RU?=
 =?utf-8?B?cjNTTGZmY3JvR0tOUWVIdlJoYVRvMVAyWWIxR0k5VnhWWm9MRFIzWDlrY2Vx?=
 =?utf-8?B?MDJET1BNNm1PSGZKWVl5aUlnU053ZzRyWUhhSjdBUWtOQy9aa3NSdDFZZWNN?=
 =?utf-8?B?RUxKZjhRaVN0YUt0RkxCK0t2K1pWaXNobUxncUErQ2orSm4vTHAxWTkxWWh4?=
 =?utf-8?B?OE05NjRiZUsxMnZFWlFZMG4zWWwraGpEYlJSZDFtcUlsM0lYTmJYS2lmZ3NS?=
 =?utf-8?B?UXRhcm44QnlGK08zZ1RHcU5YbWl4SFdzRmZEcHlvTlpsQ2s4WmhIK25vTFZ5?=
 =?utf-8?Q?5kMbVVLdvJBIfmxoqwPtRs+Hp?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: nephogine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB5682.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44f931e-1c85-4c51-3b18-08dc3dbe2f2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2024 09:17:02.3938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u96LzuHWd2DWX26sEXoZU6RvdARa/KQ2I7pMvq/bEMDnvUXp/QfUGeS+Peys4IKCbgS/4JyjSL4SZc94tS1f+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5358

PiBPbiBUdWUsIE1hciA1LCAyMDI0IGF0IDQ6MjHigK9BTSBYaW55aW5nIFl1IDx4aW55aW5nLnl1
QG5lcGhvZ2luZS5jb20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gT2YgY291cnNlLCAgSSBhbSBnbGFk
IHRvIGRvLiAgQW5kIEkgbmVlZCB0byBjbGFyaWZ5IHRoYXQgb3VyIHVzZSBjYXNlIG9ubHkNCj4g
c3VwcG9ydCBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFUQSAgdHJhbnNwb3J0IGZlYXR1cmUgb24g
RFBESyB2RFBBDQo+IGZyYW1ld29yayB3aGljaCB0aGUgYmFja2VuZCB0eXBlIGlzIE5FVF9DTElF
TlRfRFJJVkVSX1ZIT1NUX1VTRVIgYW5kDQo+IHVzZSB1c2VyX2ZlYXR1cmVfYml0cy4gU28gdGhl
IG5ldyBmZWF0dXJlIGFkZCBvbiB2ZHBhX2ZlYXR1cmVfYml0cyAgd2lsbCBub3QNCj4gdW5kZXIg
dmVyaWZpZWQgaW4gb3VyIGNhc2UuICBOb3Qgc3VyZSB0aGlzIG1lZXRzIHlvdXIgZXhwZWN0YXRp
b25zPw0KPiANCj4gQXMgbG9uZyBhcyB0aGUgZHJpdmVyIGtlZXBzIHVzaW5nIG5vdGlmaWNhdGlv
biBkYXRhIGl0IGlzIG5vdCBhYmxlIHRvIHRlbGwgdGhlDQo+IGRpZmZlcmVuY2UgYmV0d2VlbiBv
bmUgc2NlbmFyaW8gb3IgYW5vdGhlciwgc28geWVzLg0KPiANCg0KT0ssIEkgc2VlLiAgQW5kIHRo
ZSB0ZXN0IHJlc3VsdCBpcyBPSywgdGhlIGZlYXR1cmUgbmVnb3RpYXRpb24gY29ycmVjdGx5IGFu
ZCB0aGUgdXNlIGNhc2UgcGFzc2VkLg0KDQo+ID4gT25lIG1vcmUgdGhpbmcsIEkgd291bGQgYXNr
IGhvdyBkbyAgSSBnZXQgdGhlIGZ1bGwgc2VyaWVzIHBhdGNoPyBEbyBJIGNvcHkgdGhlDQo+IFJG
QyBsaW5lIGJ5IGxpbmUgZnJvbSB0aGlzIGxpbmtbMV0/DQo+ID4NCj4gDQo+IGxvcmUua2VybmVs
Lm9yZyBpcyBhIGdvb2QgYWx0ZXJuYXRpdmUgYXMgVGhvbWFzIG1lbnRpb25lZC4gQW5vdGhlciBn
b29kIG9uZQ0KPiBJTU8gaXMgYjQsIHdoaWNoIGFsbG93cyB5b3UgdG8gZG93bmxvYWQgdGhlIHNl
cmllcyBhbmQgYXBwbHkgd2l0aCAiZ2l0IGFtIg0KPiB0b28gdXNpbmcgImI0IG1ib3ggPDIwMjQw
MzAxMTM0MzMwLjQxOTEwMDctMS0NCj4gam9uYWgucGFsbWVyQG9yYWNsZS5jb20+IiAodW50ZXN0
ZWQpLg0KPiANCj4gaHR0cHM6Ly9weXBpLm9yZy9wcm9qZWN0L2I0Lw0KPiANCj4gVGhhbmtzIQ0K
PiANCg0KPiBGb3IgZ2V0dGluZyBwYXRjaGVzIHRoYXQgeW91IG1pZ2h0IGhhdmUgbWlzc2VkIG9u
IHRoZSBtYWlsaW5nIGxpc3QsIEkNCj4gcmVjb21tZW5kIGxvcmUua2VybmVsLm9yZyA6DQo+IA0K
PiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvcWVtdS1kZXZlbC8yMDI0MDMwMTEzNDMzMC40
MTkxMDA3LTEtDQo+IGpvbmFoLnBhbG1lckBvcmFjbGUuY29tLw0KPiANCj4gWW91IGNhbiBkb3du
bG9hZCBtYm94IGZpbGVzIHRoZXJlIHRoYXQgeW91IGNhbiBhcHBseSBsb2NhbGx5IHdpdGggImdp
dCBhbSIuDQo+IA0KPiAgIEhUSCwNCj4gICAgVGhvbWFzDQoNClRoYW5rcyB0byB5b3UgYW5kIFRo
b21hcyBmb3IgdGhlIGFkdmljZSB3aGljaCB3b3JrcyB3ZWxsLg0KDQo+ID4gVGhhbmtzLA0KPiA+
IFhpbnlpbmcNCj4gPg0KPiA+DQo+ID4gWzFdDQo+ID4gaHR0cHM6Ly9saXN0cy5ub25nbnUub3Jn
L2FyY2hpdmUvaHRtbC9xZW11LWRldmVsLzIwMjQtDQo+IDAzL21zZzAwMDkwLmh0bWwNCj4gPg0K
PiA+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+ID4gRnJvbTogRXVnZW5pbyBQ
ZXJleiBNYXJ0aW4gPGVwZXJlem1hQHJlZGhhdC5jb20+DQo+ID4gU2VudDogU2F0dXJkYXksIE1h
cmNoIDIsIDIwMjQgNDozMiBBTQ0KPiA+IFRvOiBXZW50YW8gSmlhIDx3ZW50YW8uamlhQG5lcGhv
Z2luZS5jb20+OyBSaWNrIFpob25nDQo+ID4gPHpoYW95b25nLnpob25nQG5lcGhvZ2luZS5jb20+
OyBYaW55aW5nIFl1DQo+IDx4aW55aW5nLnl1QG5lcGhvZ2luZS5jb20+DQo+ID4gQ2M6IEpvbmFo
IFBhbG1lciA8am9uYWgucGFsbWVyQG9yYWNsZS5jb20+OyBxZW11LWRldmVsQG5vbmdudS5vcmcN
Cj4gPiA8cWVtdS1kZXZlbEBub25nbnUub3JnPjsgbXN0QHJlZGhhdC5jb20gPG1zdEByZWRoYXQu
Y29tPjsNCj4gPiBqYXNvd2FuZ0ByZWRoYXQuY29tIDxqYXNvd2FuZ0ByZWRoYXQuY29tPjsgc2kt
d2VpLmxpdUBvcmFjbGUuY29tDQo+ID4gPHNpLXdlaS5saXVAb3JhY2xlLmNvbT47IGJvcmlzLm9z
dHJvdnNreUBvcmFjbGUuY29tDQo+ID4gPGJvcmlzLm9zdHJvdnNreUBvcmFjbGUuY29tPjsgcmFw
aGFlbEBlbmZhYnJpY2EubmV0DQo+ID4gPHJhcGhhZWxAZW5mYWJyaWNhLm5ldD47IGt3b2xmQHJl
ZGhhdC5jb20gPGt3b2xmQHJlZGhhdC5jb20+Ow0KPiA+IGhyZWl0ekByZWRoYXQuY29tIDxocmVp
dHpAcmVkaGF0LmNvbT47IHBhc2ljQGxpbnV4LmlibS5jb20NCj4gPiA8cGFzaWNAbGludXguaWJt
LmNvbT47IGJvcm50cmFlZ2VyQGxpbnV4LmlibS5jb20NCj4gPiA8Ym9ybnRyYWVnZXJAbGludXgu
aWJtLmNvbT47IGZhcm1hbkBsaW51eC5pYm0uY29tDQo+ID4gPGZhcm1hbkBsaW51eC5pYm0uY29t
PjsgdGh1dGhAcmVkaGF0LmNvbSA8dGh1dGhAcmVkaGF0LmNvbT47DQo+ID4gcmljaGFyZC5oZW5k
ZXJzb25AbGluYXJvLm9yZyA8cmljaGFyZC5oZW5kZXJzb25AbGluYXJvLm9yZz47DQo+ID4gZGF2
aWRAcmVkaGF0LmNvbSA8ZGF2aWRAcmVkaGF0LmNvbT47IGlpaUBsaW51eC5pYm0uY29tDQo+ID4g
PGlpaUBsaW51eC5pYm0uY29tPjsgY29odWNrQHJlZGhhdC5jb20gPGNvaHVja0ByZWRoYXQuY29t
PjsNCj4gPiBwYm9uemluaUByZWRoYXQuY29tIDxwYm9uemluaUByZWRoYXQuY29tPjsgZmFtQGV1
cGhvbi5uZXQNCj4gPiA8ZmFtQGV1cGhvbi5uZXQ+OyBzdGVmYW5oYUByZWRoYXQuY29tIDxzdGVm
YW5oYUByZWRoYXQuY29tPjsNCj4gPiBxZW11LWJsb2NrQG5vbmdudS5vcmcgPHFlbXUtYmxvY2tA
bm9uZ251Lm9yZz47IHFlbXUtDQo+IHMzOTB4QG5vbmdudS5vcmcNCj4gPiA8cWVtdS1zMzkweEBu
b25nbnUub3JnPjsgdmlydGlvLWZzQGxpc3RzLmxpbnV4LmRldg0KPiA+IDx2aXJ0aW8tZnNAbGlz
dHMubGludXguZGV2Pg0KPiA+IFN1YmplY3Q6IFJlOiBbUkZDIDAvOF0gdmlydGlvLHZob3N0OiBB
ZGQgVklSVElPX0ZfTk9USUZJQ0FUSU9OX0RBVEENCj4gPiBzdXBwb3J0DQo+ID4NCj4gPiBIaSBX
ZW50YW8gLyBSaWNrIC8gWGlueWluZyBZdSwNCj4gPg0KPiA+IFdvdWxkIGl0IHdvcmsgZm9yIHlv
dSB0byB0ZXN0IHRoaXMgc2VyaWVzIG9uIHlvdXIgdXNlIGNhc2VzLCBzbyB3ZQ0KPiA+IG1ha2Ug
c3VyZSBldmVyeXRoaW5nIHdvcmtzIGFzIGV4cGVjdGVkPw0KPiA+DQo+ID4gVGhhbmtzIQ0KPiA+
DQo+ID4gT24gRnJpLCBNYXIgMSwgMjAyNCBhdCAyOjQ04oCvUE0gSm9uYWggUGFsbWVyIDxqb25h
aC5wYWxtZXJAb3JhY2xlLmNvbT4NCj4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gVGhlIGdvYWwgb2Yg
dGhlc2UgcGF0Y2hlcyBhcmUgdG8gYWRkIHN1cHBvcnQgdG8gYSB2YXJpZXR5IG9mIHZpcnRpbw0K
PiA+ID4gYW5kIHZob3N0IGRldmljZXMgZm9yIHRoZSBWSVJUSU9fRl9OT1RJRklDQVRJT05fREFU
QSB0cmFuc3BvcnQNCj4gPiA+IGZlYXR1cmUuIFRoaXMgZmVhdHVyZSBpbmRpY2F0ZXMgdGhhdCBh
IGRyaXZlciB3aWxsIHBhc3MgZXh0cmEgZGF0YQ0KPiA+ID4gKGluc3RlYWQgb2YganVzdCBhIHZp
cnRxdWV1ZSdzIGluZGV4KSB3aGVuIG5vdGlmeWluZyB0aGUgY29ycmVzcG9uZGluZw0KPiBkZXZp
Y2UuDQo+ID4gPg0KPiA+ID4gVGhlIGRhdGEgcGFzc2VkIGluIGJ5IHRoZSBkcml2ZXIgd2hlbiB0
aGlzIGZlYXR1cmUgaXMgZW5hYmxlZCB2YXJpZXMNCj4gPiA+IGluIGZvcm1hdCBkZXBlbmRpbmcg
b24gaWYgdGhlIGRldmljZSBpcyB1c2luZyBhIHNwbGl0IG9yIHBhY2tlZA0KPiA+ID4gdmlydHF1
ZXVlDQo+ID4gPiBsYXlvdXQ6DQo+ID4gPg0KPiA+ID4gIFNwbGl0IFZRDQo+ID4gPiAgIC0gVXBw
ZXIgMTYgYml0czogbGFzdF9hdmFpbF9pZHgNCj4gPiA+ICAgLSBMb3dlciAxNiBiaXRzOiB2aXJ0
cXVldWUgaW5kZXgNCj4gPiA+DQo+ID4gPiAgUGFja2VkIFZRDQo+ID4gPiAgIC0gVXBwZXIgMTYg
Yml0czogMS1iaXQgd3JhcCBjb3VudGVyICYgMTUtYml0IGxhc3RfYXZhaWxfaWR4DQo+ID4gPiAg
IC0gTG93ZXIgMTYgYml0czogdmlydHF1ZXVlIGluZGV4DQo+ID4gPg0KPiA+ID4gQWxzbywgZHVl
IHRvIHRoZSBsaW1pdGF0aW9ucyBvZiBpb2V2ZW50ZmQgbm90IGJlaW5nIGFibGUgdG8gY2FycnkN
Cj4gPiA+IHRoZSBleHRyYSBwcm92aWRlZCBieSB0aGUgZHJpdmVyLCBpb2V2ZW50ZmQgaXMgbGVm
dCBkaXNhYmxlZCBmb3IgYW55DQo+ID4gPiBkZXZpY2VzIHVzaW5nIHRoaXMgZmVhdHVyZS4NCj4g
PiA+DQo+ID4gPiBBIHNpZ25pZmljYW50IGFzcGVjdCBvZiB0aGlzIGVmZm9ydCBoYXMgYmVlbiB0
byBtYWludGFpbg0KPiA+ID4gY29tcGF0aWJpbGl0eSBhY3Jvc3MgZGlmZmVyZW50IGJhY2tlbmRz
LiBBcyBzdWNoLCB0aGUgZmVhdHVyZSBpcw0KPiA+ID4gb2ZmZXJlZCBieSBiYWNrZW5kIGRldmlj
ZXMgb25seSB3aGVuIHN1cHBvcnRlZCwgd2l0aCBmYWxsYmFjaw0KPiA+ID4gbWVjaGFuaXNtcyB3
aGVyZSBiYWNrZW5kIHN1cHBvcnQgaXMgYWJzZW50Lg0KPiA+ID4NCj4gPg0KPiA+IEhpIFdlbnRh
bywNCj4gPg0KDQo=
