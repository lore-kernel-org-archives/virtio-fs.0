Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA67939EF05
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486907; cv=none; b=NL+7tKAK2qfrDjAbkmxoAonpEb5bVuHiF4By8juK5Dx1o236S15ht1F9w0++9uyRX1eHN62y/VBmy0iFib6sCUHo6u9lwzefXMfi3YkMM51W3eR1yKhqIUaZBpMOCJqg7MpIDskyAUlmY03jlpcEuI43NL7CnWbMCPOQawlXfgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486907; c=relaxed/simple;
	bh=pL9nyAt7s2HcJHsg/JFdnAJzZe9tDscI1Rzc2VTyxTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t5AfXaFS6le/5C1mcct0V7cnIc7gqXiHIVn4f85gwjcUn48y+SZ/oO8pgqMk0Dfzl9NAKCfTwcR6n8KalpF0PPcG02kfKytCNHx5CgpQuFo1aVkJVNFpfe9kXC0Pux5ce44V31iQyiMUE2eepnxMQIsfEjHD+JWud7J70LNxFro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZXpdI4Kq; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HfKAFWj1; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZXpdI4Kq";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HfKAFWj1"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66V8Uujc2957283
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:35:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	cp/RqiEqjShtXcIzeV2FMEUgaoztlVGs1VzLDa+6+yo=; b=ZXpdI4KqlqFBJT/4
	SbMrBoKqMPSZzKqKsdSUWkiDrdAEyuMeFKljm7FU5610qWl3PaJECw2Nvcz0Sgom
	DBp9XEhxdvd0NwiNFRoeWZrParuyp1fMxFW0RydGgQV+gUDtocdTggVcS+I601wr
	EzRILB1y/BE18y/8DNdYmC6ySPZw7eTwhGC8H5EY9Qe31wWcBOH/byxeVh52SkxH
	liP5xREdBzlng/7xSwszB39NgJxgziWddhLLVIcamm3/g35RFSTiuORC/LIKVRHY
	rPLxPsg8iJ8mk1nSmm8ASyIn2WtyE6DG+QhMMCY9nbxtW6F6CHo34WfPh9ictfMJ
	yXSVkA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4frr8jg0hj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 08:35:04 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-526da7e3c9dso6231081cf.1
        for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 01:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785486904; x=1786091704; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cp/RqiEqjShtXcIzeV2FMEUgaoztlVGs1VzLDa+6+yo=;
        b=HfKAFWj1+LHqyWNHdBsMY2Y3gpLZ9wEHXXB8lmiDRi+x/I6aRUUSeDOfimJ1NGExex
         mLecBFay88y1PqfCpBKC0DEOAcIPUc0BVV+CMWrr72jjqvujcYR3PQp6GdxhIkBQoXPg
         Pud7Ffbnt287g9eDqSCxF7TgkSzhpi4L5aiP3hXF+jtkHigS3bjJ5WPcln7QobDG70T+
         8CRm/+Ud4zksTz2tId4qRISEQVyG0r50H27SbiVvkhx9Kz7yjp3FRZdq3qKhqV+545Pm
         yKeDGieodbMUzmYq7rz8eTgrgtVJO9cADVDxamesPNb1ljTc0cKNJI7zeLyGKGweCxLi
         P0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785486904; x=1786091704;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cp/RqiEqjShtXcIzeV2FMEUgaoztlVGs1VzLDa+6+yo=;
        b=KsrGVfr7x9aMZKQ+7GTabbTxOKloJ0mFg3eypMfBAthuVxSsD54XQa6GAOdb6FQSLP
         ngeJgFsKqjPweJB9YqaNXp3GfTJuCjJhLXUnnWROgSSvy8pBDdfPDDyqCoJshGiAAMzU
         XAhUfiB358Lfb2Z90wkgi4BzS5Fe70aFU+XPyzUN1QKt1bWlH2L8E7x6/1ie8P7UOUD4
         cqMJLNFeoJ0Pjmt363rCeOC+Qy3kTxp0D1PbV+pWkSaIUxJnXW5eQeeVoW9C/Y0cI+ul
         Hp+X4muWOjzh9xjoSznL1VZaOCvcqe1fkjPU+cfZvYZzG7NRMkq0OHvljdI6e+DZTnrd
         IXFQ==
X-Forwarded-Encrypted: i=1; AHgh+RpfSPIhH6QnnsN3ke7qyXwxg6U/fIZVIbwIlS/eMfzRtBrcTKhJwIrhqn8gM5hh15CdUbvLbj/nFa4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBiTv23sBdi1hgMZ3Z7SF48ugiOzE4a+A8JDe/YaKXEB6SOaqy
	l0LP53L9Y7UzGqJrdVRuS5myBmAJ1WRTSHrzhm0CYeNpS5ASGezbY0qSpARGvCgrvjP9iR4p1mi
	US2fM07UgIs0MmEphfo+TaJJjN/SZ+S33sYr0VJ6p/BPBXIqxtG/EjS2in82SRiM=
X-Gm-Gg: AR+sD126ZlpKgV8FpLc0xjX1FP6HRA3kCOOnOMrUBTjJPMG+Wdn2O8HcBSOx3y6TBX6
	MW2OaGOdeJOaduKJEimiuKZFW+KUw9KQd9I28W4kZjP3pI2mffCLy3vjI31A4gavZOieGCJr/CX
	SbS2YMkGMFL2HjhxYIZ6qdoJ5C9+vWT2LXInMGv5xxjqL7PEchjR7Xmkki4QDZGq+SaEgZ7Hh0C
	Bd+2ABU/wWhtvQlb6gbDrmrYkOqE4qPoHRDAuFjp3tih3JAlen1LpW4e2monqAKsoERtJ9KuNth
	TsDRCYNMWLnWWLVHg3Wpf8YG4sJd8ajQdkygwJy47cqOhOX0cr1cnyGzhPwUMYCRMSZZcbomTee
	PggDXydc2cuUedsznPot+HpJ2mnv99p8BNONf2mfJc047vHTQzRk=
X-Received: by 2002:ac8:7dd0:0:b0:527:69dd:5413 with SMTP id d75a77b69052e-52b4aeb6ee6mr13426151cf.5.1785486903923;
        Fri, 31 Jul 2026 01:35:03 -0700 (PDT)
X-Received: by 2002:ac8:7dd0:0:b0:527:69dd:5413 with SMTP id d75a77b69052e-52b4aeb6ee6mr13425341cf.5.1785486903379;
        Fri, 31 Jul 2026 01:35:03 -0700 (PDT)
Received: from [192.168.69.212] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd450d71bsm66135766b.46.2026.07.31.01.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 01:35:02 -0700 (PDT)
Message-ID: <eef9784f-5e68-4f1a-ba12-85ad4128116d@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 10:35:00 +0200
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
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@oss.qualcomm.com>
In-Reply-To: <20260730205846.19479-2-stefanha@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=Bd7oFLt2 c=1 sm=1 tr=0 ts=6a6c5e38 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=4s3hRJSeHn4rkQlkrse1kQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=M51BFTxLslgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=20KFwNOVAAAA:8 a=0-W2_F3agLd6ZuelXpwA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: 4-DfSbv_kB4JvnEklbQFF5FwGFbFvLHT
X-Proofpoint-ORIG-GUID: 4-DfSbv_kB4JvnEklbQFF5FwGFbFvLHT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDA2MCBTYWx0ZWRfX6ti2A2C94Q9S
 Qp3t7OK5mgpTMBBBBDG7k8rgjDMyjbIB9IZooJE3BmnNZ0eK6KI05xnQuLMeVO0TEehDYJY9b55
 Y9YukZdolzNWgzQEsgjQofJkZKW8a37enlacGFuvfxsrda2twcbbFzHldb24p3zu8314iJPCFc3
 nggaB1YoS2RO1euz10SrC0WRGPp2SOi/eheR2vpG7THEJhsmuKpgNJuRHnO1PCqc3S4QQQPRKxn
 l+UzX2FO1AN4470qix/fHW+UJuaiD346OubYfLz6Qq1N2RkaQO0xH49jYeJY8mlXLYkvGsVpdoj
 K2QAORDRr3zDg2jYro/5cgQmPlmaUfw78vY/IfW/eUl2sGEDx70lCdIov45KWoJlxXLbs/t3uPR
 z9arsI9eos4OJNZ6V8FP/uPwDrQ/QhHnjKkQaK4UDeweYSlyBCG7cbviCsQRoAU9Z9QjjW8KPoF
 K4ShaJM4s6QLYPvH2yw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDA2MCBTYWx0ZWRfX4I6VCMVuBG8D
 umwGikJxpmfUabPETm4hOdglqswmyHWnya7ieFhXK6Xl03zpf78HO0XrXNRIGc3PDaRmdwjqHM/
 LNaTk+EUADzS04ueq8ullGDiWazxc5w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_03,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0
 malwarescore=0 clxscore=1011 suspectscore=0 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310060

Hi Stefan,

On 30/7/26 22:58, Stefan Hajnoczi wrote:
> virtio_add_queue()'s queue_size argument is a signed int. The
> vdev->vq[i].vring.num and num_default fields are already declared as
> unsigned int, so change the virtio_add_queue() argument's type for
> consistency.
> 
> A note on consistency: the VIRTIO specification defines queue size as an
> unsigned 16-bit value.

Why not use uint16_t then?

> QEMU's device models variously use uint16_t,
> uint32_t, and other unsigned types for queue size qdev properties.
> virtio_add_queue() limits queue size to the much smaller
> VIRTQUEUE_MAX_SIZE (1024) constant, so the different widths don't really
> matter.
> 
> I have checked that all callers of virtio_add_queue() pass an unsigned
> queue size.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> ---
>   include/hw/virtio/virtio.h | 2 +-
>   hw/virtio/virtio.c         | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index c99cb19d886..ff7f837fb92 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -302,7 +302,7 @@ void virtio_device_set_child_bus_name(VirtIODevice *vdev, char *bus_name);
>   
>   typedef void (*VirtIOHandleOutput)(VirtIODevice *, VirtQueue *);
>   
> -VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
> +VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
>                               VirtIOHandleOutput handle_output);
>   
>   void virtio_del_queue(VirtIODevice *vdev, int n);
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index daa5607338c..e1210f024c6 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -2564,7 +2564,7 @@ void virtio_queue_set_vector(VirtIODevice *vdev, int n, uint16_t vector)
>       }
>   }
>   
> -VirtQueue *virtio_add_queue(VirtIODevice *vdev, int queue_size,
> +VirtQueue *virtio_add_queue(VirtIODevice *vdev, unsigned int queue_size,
>                               VirtIOHandleOutput handle_output)
>   {
>       int i;

