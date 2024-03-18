Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3CE364DA
	for <virtio-fs@lists.linux.dev>; Mon, 18 Mar 2024 11:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710762925; cv=none; b=P5gCpGkDjbuAGLSvE5Uu46guvogCL7mbBCCCULlUH0THqW0u7blZ+dzmrs+ITuN6MwdM7fuL1hruY0lFktX1BxePMGnAOSSsCpq4yI5Luhw3Rle8iWBOXJQmVyTZAR15gCy5/41XF7DeEggHZlg7xJ1//BLiqT9znBD9V5FAmeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710762925; c=relaxed/simple;
	bh=nYJ91inuUPOnRialvuu0OxZ3Re2srlgMLLGSR64wlfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbaZXsjMScIUatNmWKx8T9K+HR/JSk24EGeTmHwbduR/6/sk/k2r2bXSq2eiMXm29XpaH/2eHF3azGpf7O+r003zJLXDR2faLnaRVeYwYawCBC9V6CPt+xESmM8/sgv5DaGcWQ6hLpNLkoh5oIZcYNN+MzFbyutqdjKUt/+7nwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=KPkOp0lU; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="KPkOp0lU"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-513e89d0816so978355e87.0
        for <virtio-fs@lists.linux.dev>; Mon, 18 Mar 2024 04:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1710762922; x=1711367722; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GW5y8fNL3N/3morbKABzGjIncGz4LjPASv+Wo+zVV4k=;
        b=KPkOp0lUuKN6Mc8ARjh2VtVFQzR/u7dKlIbOlSsTw2mC9SH0UnD4UM8fNTZp8pTne+
         hlxVTLNE3XoRUY96l9gR6Q3U1D5tgxijKPxi/g68oGxwI+FZVoHwBaT2Zsg5WJtNz5wq
         U3upyDCfIqkn58kUp0HadJSm2LtFuciAkxDGsCOykmUCtkL3bDylPd8h3DPQE2EcdFSH
         r7akye7L9pGxwB+aLj1sYJ3SY7n1P7YzI9jsinQzPVo8wQC9HIVnZU/rpX2UI44Klb7G
         VzD76rug3sS880MSow+vupxtHN885YzewGwSg4yBXaP/6jn/zG2BTtLQ9gchG0NavuVe
         BMOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710762922; x=1711367722;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GW5y8fNL3N/3morbKABzGjIncGz4LjPASv+Wo+zVV4k=;
        b=lcwGM8Nopwp8VAArTseCY4GcDW0I5p26/ngYgraC7AE2x2VxbQUTfJg9pvXU81RKuv
         poTKPLRTcKsKtv/ils3EiwVcUU4wxWyIY/GXSG7FRjsbo7wXwurG2c/1Bmcc+iNIDnQB
         VNxAqrkDYjkCNUtf5l6LEPC1J9FZwv5PbKTsLMJVCawp0Pt4+RuOUYRqgi/M3EXU4oUO
         /87AUm+3C2px2x9fWHZUesxuY4E/dBdX/rAoq43QJYeglH0Fd8jokWk4LS5/tvxg9VXr
         vB4Bk3vvDDugzcJcckR+BSx3SiSFPhp85tZMilmJwWTZMsFnflF+YgVNo761jKGsywFv
         eeeg==
X-Forwarded-Encrypted: i=1; AJvYcCWo3Me+SmMA1hcbL7oDGKF/OpexbCIjY7HPn2W4LRcwzmupE5B6qlqfSGJZRLqGf9+ucJv7jHBHxlBnO8onkFDWrQCy/EqlYAa3
X-Gm-Message-State: AOJu0Yy4uoQz2ebyb77Dh1Z5mIIiL0M0Vf8Xl1UIeQDxeO+faQO3gxZ1
	Vb0RAtFmHkz1PpKhrJobzbeIroAYZr4pStzT6pep1NuOQVXFB5Y/+C+mPY9XM30=
X-Google-Smtp-Source: AGHT+IEWy1ryDBZIH4c3Gnuv/Dku7Y8iPOJCiJu/lUCAsOCAWpu41RhR1BO6xK2lg3Yazruu8hHzOg==
X-Received: by 2002:ac2:4ac6:0:b0:513:5af1:9d7b with SMTP id m6-20020ac24ac6000000b005135af19d7bmr7767772lfp.47.1710762921520;
        Mon, 18 Mar 2024 04:55:21 -0700 (PDT)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id ld8-20020a170906f94800b00a46754900a4sm4479799ejb.33.2024.03.18.04.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 04:55:20 -0700 (PDT)
Date: Mon, 18 Mar 2024 12:55:17 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com,
	eperezma@redhat.com, si-wei.liu@oracle.com,
	boris.ostrovsky@oracle.com, raphael@enfabrica.net, kwolf@redhat.com,
	hreitz@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
	farman@linux.ibm.com, thuth@redhat.com,
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com,
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net,
	stefanha@redhat.com, qemu-block@nongnu.org, qemu-s390x@nongnu.org,
	leiyang@redhat.com, schalla@marvell.com, vattunuru@marvell.com,
	jerinj@marvell.com, dtatulea@nvidia.com, virtio-fs@lists.linux.dev
Subject: Re: [PATCH v3 for 9.1 0/6] virtio, vhost: Add
 VIRTIO_F_NOTIFICATION_DATA support
Message-ID: <ZfgrpS0mxLW2LMVE@nanopsycho>
References: <20240315165557.26942-1-jonah.palmer@oracle.com>
 <ZfW-tO4zXeAWDgFg@nanopsycho>
 <89dea52f-b4cc-4a8b-986b-68d73df180fd@oracle.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89dea52f-b4cc-4a8b-986b-68d73df180fd@oracle.com>

Mon, Mar 18, 2024 at 12:22:02PM CET, jonah.palmer@oracle.com wrote:
>
>
>On 3/16/24 11:45 AM, Jiri Pirko wrote:
>> Fri, Mar 15, 2024 at 05:55:51PM CET, jonah.palmer@oracle.com wrote:
>> > The goal of these patches are to add support to a variety of virtio and
>> > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature. This
>> > feature indicates that a driver will pass extra data (instead of just a
>> > virtqueue's index) when notifying the corresponding device.
>> > 
>> > The data passed in by the driver when this feature is enabled varies in
>> > format depending on if the device is using a split or packed virtqueue
>> > layout:
>> > 
>> > Split VQ
>> >   - Upper 16 bits: shadow_avail_idx
>> >   - Lower 16 bits: virtqueue index
>> > 
>> > Packed VQ
>> >   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
>> >   - Lower 16 bits: virtqueue index
>> > 
>> > Also, due to the limitations of ioeventfd not being able to carry the
>> > extra provided by the driver, having both VIRTIO_F_NOTIFICATION_DATA
>> > feature and ioeventfd enabled is a functional mismatch. The user must
>> > explicitly disable ioeventfd for the device in the Qemu arguments when
>> > using this feature, else the device will fail to complete realization.
>> > 
>> > For example, a device must explicitly enable notification_data as well
>> > as disable ioeventfd:
>> > 
>> >     -device virtio-scsi-pci,...,ioeventfd=off,notification_data=on
>> > 
>> > A significant aspect of this effort has been to maintain compatibility
>> > across different backends. As such, the feature is offered by backend
>> > devices only when supported, with fallback mechanisms where backend
>> > support is absent.
>> > 
>> > v3: Validate VQ idx via. virtio_queue_get_num() (pci, mmio, ccw)
>> >     Rename virtio_queue_set_shadow_avail_data
>> >     Only pass in upper 16 bits of 32-bit extra data (was redundant)
>> >     Make notification compatibility check function static
>> >     Drop tags on patches 1/6, 3/6, and 4/6
>> > 
>> > v2: Don't disable ioeventfd by default, user must disable it
>> >     Drop tags on patch 2/6
>> > 
>> > Jonah Palmer (6):
>> >   virtio/virtio-pci: Handle extra notification data
>> >   virtio: Prevent creation of device using notification-data with ioeventfd
>> >   virtio-mmio: Handle extra notification data
>> >   virtio-ccw: Handle extra notification data
>> >   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature bits
>> >   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
>> 
>> Jonah, do you have kernel patches to add this feature as well?
>> 
>> Thanks!
>
>Hi Jiri! I think there are already kernel patches for
>VIRTIO_F_NOTIFICATION_DATA, unless you're referring to something more
>specific that wasn't included in these patches:
>
>[1]: virtio: add VIRTIO_F_NOTIFICATION_DATA feature support
>https://lore.kernel.org/lkml/20230324195029.2410503-1-viktor@daynix.com/
>
>[2]: virtio-vdpa: add VIRTIO_F_NOTIFICATION_DATA feature support
>https://lore.kernel.org/lkml/20230413081855.36643-3-alvaro.karsz@solid-run.com/

I missed this. Thx!

>
>Jonah
