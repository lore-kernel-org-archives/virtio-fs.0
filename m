Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B4C321C173
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487130; cv=none; b=jV5cDcCNbqfC9QYczpMP8EdTljiMfVx0P97LxakBI+GEpYTqkZOfzWGZtX5rioaDnA/qTqaI3fa01+HC7gE0ugrY93pZicubR809JyZJfThgUbonJFb04TuaIMtSC1iib6ySAiWr9MyganlYnzsR740WG/5KrGsWmmFavSj+MzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487130; c=relaxed/simple;
	bh=cM1vMKDFhsfQ/ca4UAwVAxnl8iYPdj/lsz9nZU+ZMxw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cOADp/keir8Wt/3o7v0qaJyyU2moizNDqg9WNvwcHz+/ppe1ACGzPH+0Dvyc5bN43+X343gLNbE/R8+ssoB8fD0iisAP6N8IMT/0Q2BvWSX6gYqBd+sfjjwb32rj4I5SMukvWMkDU8YGVcaspxTlOoyS0Tb7D3cWtxLQoCrOy6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jTpG/z41; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=I7tcYv1C; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jTpG/z41";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="I7tcYv1C"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V7vYaM3672641
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:38:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	ABDS/iSM2z3ur2dcISaciA5V68ezVpBH8EIj0tIo3dc=; b=jTpG/z41eqKwy3G2
	1iSWgwy4loDZppiE4kmv8WtcUG6lDo/dLtSNNf2ZvVppxDkFb8EhKDRQ6Ovgfxp6
	Hk3VRFPSoayNw1q6/rL7sjXRubnhptGRdjCCLuaHQoguN4DASPCEfZqLfXZ2SZRH
	GC1pVM0c2VYsAiXMfbalkEmbMolQ/Pps+ca0CR+ZGbMzYa1hrRuS8Qp8eSumyzmE
	8FVIu60djf5kPO8YXyqAEUcrxIS12Zgv/757QtuqGfdu7S5buBscPvINoxYnFAfJ
	oQNIRYJZL5fIWTn0wOxg4bpVnnkY+7UFDHChXSPRU8JacHJvJ7z+cCn/xkDpKaP4
	EDOUJw==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frpgk0ffh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:38:47 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-930f5da3467so70449285a.2
        for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 01:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785487127; x=1786091927; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ABDS/iSM2z3ur2dcISaciA5V68ezVpBH8EIj0tIo3dc=;
        b=I7tcYv1CG2q5ZCLEcfptNuMwFjc1RR8MLJFyC9PiyXplfFUmcJUn8xdr5DHS/l8/FB
         6AdwktVtzblndfMnOIRei391vU4CZ2Gms8266xDEeC2uSbtlXZVO4X2AfE1GeAHbXyMM
         0TCim2v+f0taiasZt/N5Ag8vOxerjvUDwTdB58bqH6OjfJ4AmzpLBSRpzHwLnkoUeRfn
         p0egKN2zLW/V3dZ804DdQOiThJ/lisBrbTFQujcrMyDxlSLD5pwaD0BUS5c+8VpLItVa
         ZMPSFejL475JyTSor4/jT4/ZID4dQc1vAhAVKpb/ncOQJUN875hDuVqlMSZnfzxFwtI9
         Tj+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487127; x=1786091927;
        h=content-transfer-encoding:content-type:in-reply-to:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ABDS/iSM2z3ur2dcISaciA5V68ezVpBH8EIj0tIo3dc=;
        b=LqAlVoFMBmxBqgrouaDrNHAA+51lUzQYcVhi8floeh/qM84GYxgxhTNDQLrzLCfBvb
         be+pRM8rMr0GyFO/w5Rft+gNXUNNL3A2HeS2cg6oeuvY15x8OTlhK2ayacKr3q95eiRT
         l2QmQALwoWlxNxZzuXiyDLZHu3er+F13a/WriYY7BU3qpQijKyPdW2mEaaOzhLcoEmiv
         wAaR+mx8qnCtpqV6xmXiZ4sdGV5CvYeHsTS+cxeGIyzKxwrvXy0rKsMgEZtuGctMKvHd
         HwdLa3B2x8x7gxjLq4r5xPyrgGc7/B9Q1M8c3oL2BEw29J6FbBzQkz86nxr19FI9aG82
         SdBA==
X-Forwarded-Encrypted: i=1; AHgh+Rpu1HhBwnHFE+tYmG7wfKjEMwXOvKH7JmA9bjm6J4TV9VTTTnZGJ+IQgrgg5aRiOU1nyx7hJD8UoPE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxBeRJkD8RbsTEiYV6AihrtJVQehzKuGHfX7N5kGGHKJTMXFOB9
	vihUoz0DEVhiy0bQEtluGTlyJA6YIUTzgxFAdj+jMXYDFgnjXBtn9jMyvhsp5s4LhDLaV7B/lqX
	5R40C8nYEqBsdTguSL3IZA688f5cZrkeIJXGWJXui9RfVH3bvdf2Tjmw7nV8nFTg=
X-Gm-Gg: AR+sD116Mq57zkJq9DYEwXLNazB/Ai1GNAKaAGjsHSADGGuwk9lnA/IbsY/+21N8bBH
	jRx4x2H1FPS3T4Y7GV15y2ntP0GQmX+9BSihvJvxfK08C5vvD7HYuNzDwg9ulWlCUKqqUKKlCkq
	0uzNR1EPvsp4qWnLjwh4dbN/cbg/upick6kBI7+GOPwD4HSuJA8hYNkiRMzo/LqhCjRAkj15oY4
	ZzNomllDliNA0WK7+mAUW9857VH+rh3TbAFEkTtuliYsfVs0Ewzu7Y7als1UqzDvLSe/JCImnCK
	v0agD2SSOF2fWeNILmDvGfOxKN+kUleyfzNoYF8VuP/UGctGideDw4C0xihpgSLYG0jVcefqty/
	fsHAq1jb/FYvqILZTdXvuOFsT1lpn0KweWmeCA8WTBSTkWwkN6+c=
X-Received: by 2002:a05:622a:1f95:b0:528:3b9b:4f50 with SMTP id d75a77b69052e-52b4af40e91mr12931351cf.9.1785487127090;
        Fri, 31 Jul 2026 01:38:47 -0700 (PDT)
X-Received: by 2002:a05:622a:1f95:b0:528:3b9b:4f50 with SMTP id d75a77b69052e-52b4af40e91mr12931131cf.9.1785487126690;
        Fri, 31 Jul 2026 01:38:46 -0700 (PDT)
Received: from [192.168.69.212] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b0efsm68261066b.10.2026.07.31.01.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:38:45 -0700 (PDT)
Message-ID: <b7a8f165-1d7a-4733-b8a1-1c90448dfcbe@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:38:43 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] virtio: make virtio_add_queue() queue_size an
 unsigned int
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
To: Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        virtio-fs@lists.linux.dev, Hanna Reitz <hreitz@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Milan Zamazal <mzamazal@redhat.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Dorjoy Chowdhury <dorjoychy111@gmail.com>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Alexander Graf
 <graf@amazon.com>, Laurent Vivier <lvivier@redhat.com>,
        Jason Wang <jasowangio@gmail.com>,
        David Hildenbrand <david@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, qemu-block@nongnu.org,
        Greg Kurz <groug@kaod.org>, Raphael Norwitz <rnorwitz@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Stefano Garzarella
 <sgarzare@redhat.com>,
        Kuan-Wei Chiu <visitorckw@gmail.com>, Amit Shah <amit@kernel.org>
References: <20260730205846.19479-1-stefanha@redhat.com>
 <20260730205846.19479-2-stefanha@redhat.com>
 <eef9784f-5e68-4f1a-ba12-85ad4128116d@oss.qualcomm.com>
In-Reply-To: <eef9784f-5e68-4f1a-ba12-85ad4128116d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: ExbYPmmivNMXsOFmo3gnogFtzF46pw8R
X-Authority-Analysis: v=2.4 cv=P4sKQCAu c=1 sm=1 tr=0 ts=6a6c5f17 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=20KFwNOVAAAA:8 a=hTGag2EiyIdp9CllqmUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MiBTYWx0ZWRfX/1WQsx27AKlM
 SJVj3/n6DLeLkKYrzTnhrbwG9oYQlg8O9X8AWLMFenMDpGZlls5LylISEdwHqIqBK0qPLjWtANJ
 TTe2Wz0e/QpILiG7Cs6B3x/TqGDwaU8=
X-Proofpoint-GUID: ExbYPmmivNMXsOFmo3gnogFtzF46pw8R
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MiBTYWx0ZWRfX4s7hLwbPQ6p8
 zgxSXlpFOXThl9DobOD5+9q6hS+/nBeaNjtKbA6vsohjavMo4RoqXJG03FbwFqRcyTAW0AC/yJm
 vSbhjfT3glsBjvi7gYkQ3R69JWuhD/EUiC0qS4tKG0wxZAqK/9mv9EUTBWxBHqJ1sFU0z8LxxcQ
 qR2dJ7uXNZdVr3XE2YgG6PZ6pFbLxnL70N8EI9aN4i/HtcOe7LirDF633cV9lwji9rqeNQQtlhv
 oJGJYQPqOZsazMlBNkOC03kLzp6q9bElYc/B1BqVgCDkN1NzxKx9Qc2BvE90UJX2kyfeFD6eoFz
 VnsHdbRpgNewP2FNuCShQCviyzFlIkBkcA8QjfQPg3OUogSl/Gtp1zVdjVWpEqgp/NLajFpvQvl
 v335auO9TimT0Yix6p+bMrrHoEhFHeyTsQLlpRmNGj2XJuTrTBRKntgYr6vgebFvi8BxmKZk9uL
 cKvObDS6c7nQRdgzJ+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310062

On 31/7/26 10:35, Philippe Mathieu-DaudÃ© wrote:
> Hi Stefan,
> 
> On 30/7/26 22:58, Stefan Hajnoczi wrote:
>> virtio_add_queue()'s queue_size argument is a signed int. The
>> vdev->vq[i].vring.num and num_default fields are already declared as
>> unsigned int, so change the virtio_add_queue() argument's type for
>> consistency.
>>
>> A note on consistency: the VIRTIO specification defines queue size as an
>> unsigned 16-bit value.
> 
> Why not use uint16_t then?

(Otherwise size_t is more explicit for unsigned int size).

> 
>> QEMU's device models variously use uint16_t,
>> uint32_t, and other unsigned types for queue size qdev properties.
>> virtio_add_queue() limits queue size to the much smaller
>> VIRTQUEUE_MAX_SIZE (1024) constant, so the different widths don't really
>> matter.
>>
>> I have checked that all callers of virtio_add_queue() pass an unsigned
>> queue size.
>>
>> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
>> ---
>>   include/hw/virtio/virtio.h | 2 +-
>>   hw/virtio/virtio.c         | 2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)

