Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ADB17C77
	for <virtio-fs@lists.linux.dev>; Sat,  2 Mar 2024 15:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709393717; cv=none; b=ev9QHdrlK8o74Y8XynjtQDW0MPCfeltNyw7idLtEoDt0lxxh242TJ1PVTQ6ghqEQK7GWHcoSdVWjdU9j96vw68Ple7ZC6hFtLz3GZ2DDgOObS9EnxbCsBcqKsVMp/S9fr5U3Hcn4lqVazeqDZs1HSgRs+KcxJ8pvvbTaF2vI0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709393717; c=relaxed/simple;
	bh=rvIZ1ISW8OVyDG6fzM2qEVQv8tlrA84XsWawFkvLWAU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aMCTz2W0lbl9LBpzvdyutgWtzDb2BDhPww7ZjqOZ66pvMSrzztWyWY2k7XP3MhaVWydv97nrpddC+4IfTyn0m3DhI5iHhUo9FblM/ha3CRD7Ot+fduW524SC0sy/NImG+L5+WIwnNA7Lh++JYsK6XfyiDIWsl2QVOp0Y/Ma3xuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jKJAqCm3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jKJAqCm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709393714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+Ysx85g/W0kQzYguGb7KsJTcMOviltiNzvv6o9/n7kQ=;
	b=jKJAqCm35eWnIhattvXtEue6SZMXETLzO0KVOkVzwKJpN/a0NQHPT8/RlKcKSErbIQ0y3q
	HN1s/Ym5IDLtIvivIZbOgvOXmLyXbRkp869LoQMYHO3t/5gU86X6MLUw5Gu3sSCr/ftgrq
	50dSHOo9ubrW6SmGnTSvwaw4sy57ja0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-K8-zI3PoMn684KRt7yp6QQ-1; Sat, 02 Mar 2024 10:35:11 -0500
X-MC-Unique: K8-zI3PoMn684KRt7yp6QQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a44e57bbc30so24542766b.0
        for <virtio-fs@lists.linux.dev>; Sat, 02 Mar 2024 07:35:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709393710; x=1709998510;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ysx85g/W0kQzYguGb7KsJTcMOviltiNzvv6o9/n7kQ=;
        b=svv0O8yZtBNML5tOSvsUCAcylZabPzEyIUVDTu0pCV+emhrg5mNiXOduzzsXX7SaEP
         T91UuUNYqKGOsqkuo8rblmhCr7aXy1CHIU2BWMUyZzYiGWGxGjdwm9JPgVBC8tUew2A1
         bNk2Lj3uOFwRBSqjqIxsmCP5sq5BEnrQIa0b02qtEHmWL0OyLte7AXBJ/DghSYu4mAou
         T0PoBVwjCe43QdyZgocMNtxzJI27K7Je/aNwtA4PaPwCZuirgTzYEvDMOM2+K5KDcNaI
         mCzwFbsYf9hrPOINVoaQ2wLy+SXVrR7ml7dkC86F0rxEklMRJvtA7ZZUpFpeXCToMMMZ
         sG7g==
X-Forwarded-Encrypted: i=1; AJvYcCVxxYHljTYhI08yyypqZlA6R6P5lf4R89H8gqKHTxWyk7fuVXZn6q6IraCYTgGv5bHQcqFZMWqkUKw71PftzrCJ+YwY+sL29PsJ
X-Gm-Message-State: AOJu0Yz2BDko7T0PL3Rk7W9H6o0+l9graeODFT05whV+H0294/M8KDKd
	Cbj6GUIyG6gMTV80H+dRYFuLLFKFkyyI2ZL11cd5lebO/krTRDKIkyeKhke/Di7cCBERKKxICYN
	4DWf8H8yUS5RzYbyfSohlYeEig/8G72oZcX0nxlFlhmDfj3v7eON9FFbcPw==
X-Received: by 2002:a17:906:1cc2:b0:a44:4578:c79d with SMTP id i2-20020a1709061cc200b00a444578c79dmr2627060ejh.4.1709393710247;
        Sat, 02 Mar 2024 07:35:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY9MUodEcq5pRtp8+1j9t8Xxh2XdPUcbjFbDne1Iba7u3u+yTyQRsz3fYX6MPN5o+XBJvruw==
X-Received: by 2002:a17:906:1cc2:b0:a44:4578:c79d with SMTP id i2-20020a1709061cc200b00a444578c79dmr2627035ejh.4.1709393709867;
        Sat, 02 Mar 2024 07:35:09 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-133.web.vodafone.de. [109.43.178.133])
        by smtp.gmail.com with ESMTPSA id ag3-20020a1709069a8300b00a44790d06d3sm1918149ejc.71.2024.03.02.07.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Mar 2024 07:35:09 -0800 (PST)
Message-ID: <356dff14-af44-403b-9a9c-b4ea9e156f19@redhat.com>
Date: Sat, 2 Mar 2024 16:35:08 +0100
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 6/8] virtio-ccw: Lock ioeventfd state with
 VIRTIO_F_NOTIFICATION_DATA
To: Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
 si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net,
 kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com,
 borntraeger@linux.ibm.com, farman@linux.ibm.com,
 richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
 cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com,
 qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
References: <20240301134330.4191007-1-jonah.palmer@oracle.com>
 <20240301134330.4191007-7-jonah.palmer@oracle.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240301134330.4191007-7-jonah.palmer@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/03/2024 14.43, Jonah Palmer wrote:
> Prevent ioeventfd from being enabled/disabled when a virtio-ccw device
> has negotiated the VIRTIO_F_NOTIFICATION_DATA transport feature.
> 
> Due to the ioeventfd not being able to carry the extra data associated
> with this feature, the ioeventfd should be left in a disabled state for
> emulated virtio-ccw devices using this feature.
> 
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>   hw/s390x/virtio-ccw.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
> index b4676909dd..936ba78fda 100644
> --- a/hw/s390x/virtio-ccw.c
> +++ b/hw/s390x/virtio-ccw.c
> @@ -530,14 +530,16 @@ static int virtio_ccw_cb(SubchDev *sch, CCW1 ccw)
>               if (ret) {
>                   break;
>               }
> -            if (!(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +            if (!(status & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +                !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>                   virtio_ccw_stop_ioeventfd(dev);
>               }
>               if (virtio_set_status(vdev, status) == 0) {
>                   if (vdev->status == 0) {
>                       virtio_ccw_reset_virtio(dev);
>                   }
> -                if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +                if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +                    !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) {
>                       virtio_ccw_start_ioeventfd(dev);
>                   }
>                   sch->curr_status.scsw.count = ccw.count - sizeof(status);

Acked-by: Thomas Huth <thuth@redhat.com>

