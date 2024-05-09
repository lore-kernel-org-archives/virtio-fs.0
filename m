Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D11FAA
	for <virtio-fs@lists.linux.dev>; Thu,  9 May 2024 12:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715257994; cv=none; b=XSFXKd4X/0uNgnG9JUBfdCXze26bIyY8RB3dpVtqzBYBbk9IeQI2lsQJ7q7Fqkh8tELrS3CgPlDPjWC514EJIeyxca9tAZOZ1KSCtRFxdjnc2GvyZVa+mAVkT77qpG2ln+UFtRs2SGlr5daS6O/ZZwltKPXYir7iLVqOSrAubiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715257994; c=relaxed/simple;
	bh=KnxlSkJMKpq/o5qBJkVGmGEPz67emEnYhilyiFn8a6c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9OdPVa6pNm/QG4MbdZIxrRPbzqsnOz7X4ip/Qilsv2FlUPCsfBxr6J+Qf4PV7H+DhmVhcuhkeF5cCk44Rpthz86h3YFL4dw0B0X0logR9c6ZxRJFV06co9s7v1kJ8fpTUPWk80f0/V9zuGfzd8+YlN/jlLHBJLCXb4lTnO2fYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=US/s2jDf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="US/s2jDf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715257992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTfIGJcFdzJQwTmvkwZdfYxzltdUjfBTO20WHVEG6aI=;
	b=US/s2jDfhXQJ2RrFJTaNVtutnDysBqCEpoW6B6jNfdQl2fyTf/g21mFswpVZuGALTXLa1b
	zwTDaTuOi7nGgRdps4w5ZcbOo3Lnh8933+PuuVzHQDMO6X+4Z9yWtdKTN0pUc0A6ytk/80
	JixG7xTAV/b8uPeoRdl5dSkaybpFd40=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-375-3Cw7cAOgNRCLyzorf3F-1w-1; Thu, 09 May 2024 08:33:10 -0400
X-MC-Unique: 3Cw7cAOgNRCLyzorf3F-1w-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-de59ff8af0bso1298033276.2
        for <virtio-fs@lists.linux.dev>; Thu, 09 May 2024 05:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715257990; x=1715862790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aTfIGJcFdzJQwTmvkwZdfYxzltdUjfBTO20WHVEG6aI=;
        b=lxONNRilOysMHKGXJIyqEfymxtoY09KS7OPp0bGiCqNfKt5wztidVxBCBd3vhG1U+T
         88D1Yy/g1s2+lxC47fYcwXwjbazs3MmGjnu7hbOafO9tuN0v9zyUyzZlh67/Ia4k9Vd/
         BKzyggdJLa1teg+xw0no2jVJq1AUgAWHuLpzvpfUQUG6aOMDjhzSxDg1w9od5rT+U3Lf
         hIfQo6cNbUMQCZRjuBnyKYNO5WmVa/ThMi80GLJ7v/6z9GKZVNwcm026BeBp61zj4TTo
         3KHZylPcumWpDpzagM624s7yoKsw92sFxNjZcbMgXUwFidQYdDUbhjZDn+MM7OIxlZ6E
         cGNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWH6yfDs9mkUzeZzWJzXffA95VNvKWnv865w2Wo2UfYW0HwEu5Jq2sDX2H3wPlqp/yPylPzVPbrQ9qZYVjY5zlWKXRs7VzxvclX
X-Gm-Message-State: AOJu0Yzunw6xABUoy8qniMaa8dq+rX1j4XRnIjdxOwB0B0oWWICHgbBX
	9kM/Q7LJMi5zLzTeBm6jGwj8rTAvTgD7qKz7Gu8/QHin9suexWtuxFexXbxFJpCZTwjFfyXZCSt
	vxPeJwZIYZEnMEyluyBsptQneoSWsoEo8cS0dMQIjdr00H2DD+s0ht86TsDL1Jb/05KIzCRRMfZ
	3c04UT61l79KtELMg2HSkAVeLX4+w1Bw6+
X-Received: by 2002:a25:868d:0:b0:de8:bdd3:c113 with SMTP id 3f1490d57ef6-debb9d88cebmr5104899276.25.1715257990103;
        Thu, 09 May 2024 05:33:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGHd7wVkLpRhvoT2EdR+x4C4Ic3RUl/kFAq9rPrXBfXobueUXJ7fzEZdGAgcweZtMhLXG6IqtFWL9aLe40XY9I=
X-Received: by 2002:a25:868d:0:b0:de8:bdd3:c113 with SMTP id
 3f1490d57ef6-debb9d88cebmr5104857276.25.1715257988475; Thu, 09 May 2024
 05:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240506150428.1203387-1-jonah.palmer@oracle.com> <20240506150428.1203387-2-jonah.palmer@oracle.com>
In-Reply-To: <20240506150428.1203387-2-jonah.palmer@oracle.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 9 May 2024 14:32:32 +0200
Message-ID: <CAJaqyWeitQo0rqR5+q7e1OjBF=zWHpg++cwyH3dRhaNaM6bB+w@mail.gmail.com>
Subject: Re: [PATCH 1/6] virtio: Add bool to VirtQueueElement
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	schalla@marvell.com, leiyang@redhat.com, virtio-fs@lists.linux.dev, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 6, 2024 at 5:06=E2=80=AFPM Jonah Palmer <jonah.palmer@oracle.co=
m> wrote:
>
> Add the boolean 'filled' member to the VirtQueueElement structure. The
> use of this boolean will signify if the element has been written to the
> used / descriptor ring or not. This boolean is used to support the
> VIRTIO_F_IN_ORDER feature.
>
> Tested-by: Lei Yang <leiyang@redhat.com>
> Signed-off-by: Jonah Palmer <jonah.palmer@oracle.com>
> ---
>  include/hw/virtio/virtio.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/hw/virtio/virtio.h b/include/hw/virtio/virtio.h
> index 7d5ffdc145..9ed9c3763c 100644
> --- a/include/hw/virtio/virtio.h
> +++ b/include/hw/virtio/virtio.h
> @@ -69,6 +69,7 @@ typedef struct VirtQueueElement
>      unsigned int ndescs;
>      unsigned int out_num;
>      unsigned int in_num;
> +    bool filled;

in_order_filled? I cannot come with a good name for this. Maybe we can
add a comment on top of the variable so we know what it is used for?

>      hwaddr *in_addr;
>      hwaddr *out_addr;
>      struct iovec *in_sg;
> --
> 2.39.3
>

