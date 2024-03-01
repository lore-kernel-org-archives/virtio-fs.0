Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C653A8E3
	for <virtio-fs@lists.linux.dev>; Fri,  1 Mar 2024 19:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709322295; cv=none; b=G1Aa+e6VhXFZZgreP7PE32i1eOvef10G+NIxPpsOL70AD8R7UALUoP45Q1we/D0b4Df7t+83wPOOlTeWQpZJtzzGOsmbic52y2XtC52t07/PT5k+aFlOc3aRM74vym+Z/wWPnnq+mabFquZPmGRe+L2n8sgIEBkVkhcXhsBW3dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709322295; c=relaxed/simple;
	bh=XyUWBYcxC0J9gp6koPfr8SjlZyE9JyU9SSL/Jw9WfoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NTO0OYgphp8mfXxnA0ONafYFoj2PpaHCDMmQImJ+DE3VBCM6jZTGMSCk59ixm9Ap389wb9eSUNPtppJHMTK6Gk5Qx2CKE9mPdjCmarV20VsA0UOZAmOmeCg1hcgd6w8s9xVKB4ZXzF8zQ1W3ucyg/nFWr5bDgAb1166HLL0tbfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZZbnT3tB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZZbnT3tB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709322292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf2UEL+cQJVaADNBAhNdeM2N2bKFN/niMKZZQVDvnhU=;
	b=ZZbnT3tBVdwf2OWIql8txZ+laNg17SHQdKMAxxUaMFJSOnDIsMvyE6UCinc1CCqOvQvoVW
	ikePfBeCVA6PJd9aXCioTHNzlsS+vzGOf7iWVsTTdHxryz3d9W+XZzbys7cPa0KgJSVm/y
	L19/7OSw05/7IJIqi0CgTTfrf2NEO5c=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-PbdzsuFtO2eAdT6Qqlowdg-1; Fri, 01 Mar 2024 14:44:49 -0500
X-MC-Unique: PbdzsuFtO2eAdT6Qqlowdg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dc746178515so3584046276.2
        for <virtio-fs@lists.linux.dev>; Fri, 01 Mar 2024 11:44:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709322289; x=1709927089;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lf2UEL+cQJVaADNBAhNdeM2N2bKFN/niMKZZQVDvnhU=;
        b=cHeBqcyTbsr/9wYs0sMmJgogTXnuQkwcX4megNyZUzHfhPF3x7XyTiE0oh+Hov4Ftg
         fCwO1ZFRDjTE3MfLU2CO3dHuA5a80VrkvSPBC6yO23alTgeA/vVCUkr+xt2IhD+yrUNt
         DAvYZm6PcYhdTQ2SdMSGxE/5O7imac07qzcHwQZqdPNUawV0rCuIk1Vqz01HiXQOsUnG
         HpzQ8D+vCqwxk/5Fj09mpJhYaGpUSMwS2z5DzyMjsuMAWrqo1+6t28UCPkWhwTNK6ArB
         6RL9rH/3j5N131HcB4WQESJS50ONzLIFgitz55X0bj2jsZ5oGgh/Qemmey8huuwQTS3V
         ziow==
X-Forwarded-Encrypted: i=1; AJvYcCXQQaoyMRiGLUZLAWSqqaPKWyirvDYS481oTGZpXjxol74cWBbzd5bXYd1y/VVX5483v7rWpJQj9s7wI+4ddHZH/YFFg9BFWJY8
X-Gm-Message-State: AOJu0YxGcHyZMHg+1eiQX5ZD+RtENtrdANoQp0KRJ7zrAnHDLsisa/HN
	vzQqG0Azd1qsGIzFZXpGRR7tXIAJFeJIl1vP9e1GTWQxGmVvBQrIGYkEQkZUdOkf1O1OvnhUkL7
	kmNEwuwu+Ms/0ZAvojvyRbk3rDaJ9+GzLkdAPu9THjbWU3ClkftYprEBJzIZi7qINDXbJLLB/tN
	Jcy2jowZE5T6er3E8ouiyfBArEJiH/SCpO
X-Received: by 2002:a05:6902:218f:b0:dc7:4367:2527 with SMTP id dl15-20020a056902218f00b00dc743672527mr2997511ybb.49.1709322288840;
        Fri, 01 Mar 2024 11:44:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjm65dBSSOlNwC1BtrHh8qaNA3M8Enj9DzCv1Fr4qh7klO6+qedckFBQJXH5Kctw5k6GV0jj7LvdNbWRKQEaQ=
X-Received: by 2002:a05:6902:218f:b0:dc7:4367:2527 with SMTP id
 dl15-20020a056902218f00b00dc743672527mr2997498ybb.49.1709322288610; Fri, 01
 Mar 2024 11:44:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240301134330.4191007-1-jonah.palmer@oracle.com> <20240301134330.4191007-3-jonah.palmer@oracle.com>
In-Reply-To: <20240301134330.4191007-3-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Fri, 1 Mar 2024 20:44:12 +0100
Message-ID: <CAJaqyWfzobbNeUOR0LvpZ=Er1ShVN8vcZAr6Vm4gU+dth5v4cw@mail.gmail.com>
Subject: Re: [RFC 2/8] virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, jasowang@redhat.com, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com, 
	qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 2:44=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> Prevent ioeventfd from being enabled/disabled when a virtio-pci
> device has negotiated the VIRTIO_F_NOTIFICATION_DATA transport
> feature.
>
> Due to ioeventfd not being able to carry the extra data associated with
> this feature, the ioeventfd should be left in a disabled state for
> emulated virtio-pci devices using this feature.
>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>

Reviewed-by: Eugenio P=C3=A9rez <eperezma@redhat.com>

Thanks!

> ---
>  hw/virtio/virtio-pci.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
> index c7c577b177..fd9717a0f5 100644
> --- a/hw/virtio/virtio-pci.c
> +++ b/hw/virtio/virtio-pci.c
> @@ -420,13 +420,15 @@ static void virtio_ioport_write(void *opaque, uint3=
2_t addr, uint32_t val)
>          }
>          break;
>      case VIRTIO_PCI_STATUS:
> -        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +        if (!(val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) =
{
>              virtio_pci_stop_ioeventfd(proxy);
>          }
>
>          virtio_set_status(vdev, val & 0xFF);
>
> -        if (val & VIRTIO_CONFIG_S_DRIVER_OK) {
> +        if ((val & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +            !virtio_vdev_has_feature(vdev, VIRTIO_F_NOTIFICATION_DATA)) =
{
>              virtio_pci_start_ioeventfd(proxy);
>          }
>
> --
> 2.39.3
>

