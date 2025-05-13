Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2768204583
	for <virtio-fs@lists.linux.dev>; Tue, 13 May 2025 08:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747126485; cv=none; b=DlPEPi41ea7jMw2T2Sxvc/a311r29muZAbp3QOLkrZ7mqCmM1m9OCwY6p/ORuk5btMdtsNSiLbAZoD2BVBEBn3gVUUHYUyOEsSEMcpyYjFT3jh+o3xzxTm+ixbizfhRVB/uJ+6BULscViBZPrxcElvzTjhueg4S3P002TBKb+Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747126485; c=relaxed/simple;
	bh=qWxxjinNe9I4CYZsYJoFAYspq452G2jjVRzo8Y/rOsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L41Fy26wuWTHWno8jPI22EiUGNHBKn4Alj4rQp65e9k+EC/GcB1wueWEOuduzDsByRNgJ4f9HAeO1qccXg6ntIGU4pAAfoUmYzDi4mDMglXAQiEnu2rGeuaZam60r8VdxisZq/gEk26FOACCPToQKMM9yPrUBuchkKMsQPSB7mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JtkZIxsj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JtkZIxsj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747126482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qWxxjinNe9I4CYZsYJoFAYspq452G2jjVRzo8Y/rOsM=;
	b=JtkZIxsjkgHz8rfIPdggDZKhYjuCYRJyKc2139orPu8EiUTYECdZo47b4VMgENtREVZdhN
	I3QdhhOueSMS9gXckCzHaIFOW1QSAh7KRTQwIq1pU21tlogpPB/MUtVagDrkLS0dGFT+j7
	L8EKWvUZmN4kCbKdpym2VDWIGvJjcSE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-541-NVss0q3VOjuNdV1NRYRSaw-1; Tue, 13 May 2025 04:54:41 -0400
X-MC-Unique: NVss0q3VOjuNdV1NRYRSaw-1
X-Mimecast-MFC-AGG-ID: NVss0q3VOjuNdV1NRYRSaw_1747126480
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-ad22c5408e7so341578366b.3
        for <virtio-fs@lists.linux.dev>; Tue, 13 May 2025 01:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747126479; x=1747731279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qWxxjinNe9I4CYZsYJoFAYspq452G2jjVRzo8Y/rOsM=;
        b=emNdYHdQfRcFYFejDglwNmfgjtZkpSfeq/hJazKRi7TQhhlF2PVhwVy9qexC+GAEWF
         A97bYxrl69WbShilQpIt6rtTm5fEjf/w2LBxJKu/UJdHrVpvdv74FbZd6kC8KnhFfE5X
         NRMeJACWZ6LeXyW80uGU27Mtr3kkeCX/Gg612//GcBtKb5kk8+WNRCDRx5bFaUkkSU41
         CLZA1uuOapj7DTYqhiwn3ySXsFC2/BRk9RHmJWRngDStp+6dti5PpVjJH9YrP7R+DSos
         Um2eGw5mRqwJwgvF1rFh5wd8+cwYvuDEO1HTcQN7ELGLvXWUPeDXt9IXzIpaSnsYEVOh
         tBxg==
X-Gm-Message-State: AOJu0Yz7fPLlA9XjX/zSsRS9AhUQc6JxCFRulcj/5JW+sPjcjc05JbGg
	4Ja0jQTY1896ft/zRo7D13ydIinW/Orxo/nbAVdAEMsZPYHODuplnstWCy06IO+q7W38Ha7+xzA
	DbETGBmfcVTVZBhbSZmZ5/Z89BiTDD/3w960U/9F/Yd1CmBuB6RJEh8krIn1aXU2zx3ZANuT/Nh
	LgC/jeI6PqB9zOKEab9c140OfktjeKFMGhQbe6elHUr6l/rQ==
X-Gm-Gg: ASbGncuoqDzI5tmNAdfgawoFaZIIuNT+em4gZYPE6MfuB15Y4bBhYqYSGX0VVgQl+Et
	8ZtvNB5wSb/anRu2BjO8CFRsQzt8PL5sfhxGmJziUvSrgeCO96Zn3nZ553+S9T86c0GpPdw==
X-Received: by 2002:a17:907:1ca7:b0:ad2:40f4:c257 with SMTP id a640c23a62f3a-ad240f4cb3amr954133866b.26.1747126479163;
        Tue, 13 May 2025 01:54:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGztY89ag3nk9r14zFmr2CrpbEo++0iUNziNKnRDQrj1ElA/+tC79wxt40G47zgAld+KHsQT62dtpRLMeMgf6A=
X-Received: by 2002:a17:907:1ca7:b0:ad2:40f4:c257 with SMTP id
 a640c23a62f3a-ad240f4cb3amr954131466b.26.1747126478653; Tue, 13 May 2025
 01:54:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAKkJDRfz=yb5U=Gu=evx5SW=ih6_5KTKQoqO=tfCEdVX2HEuVw@mail.gmail.com>
In-Reply-To: <CAKkJDRfz=yb5U=Gu=evx5SW=ih6_5KTKQoqO=tfCEdVX2HEuVw@mail.gmail.com>
From: German Maglione <gmaglione@redhat.com>
Date: Tue, 13 May 2025 10:54:02 +0200
X-Gm-Features: AX0GCFvrjEK-Sjz5IgQR2_gLXW6CAhPcYjUmTXmHwyznDVw8HWG18cWH0tF4AyE
Message-ID: <CAJh=p+7j2aMiEgi3D4Vj8tUJTsAdZS92B+DpAJ9EgiUwacbPTQ@mail.gmail.com>
Subject: Re: Is it possible to use virtiofs to mount guest directory on the host?
To: Nils Kattenbeck <nilskemail@gmail.com>
Cc: virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4HBIFYtUMUtpIddVh7azSpIlZRhMut9SsqfIFyylbVo_1747126480
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 10, 2025 at 7:07=E2=80=AFPM Nils Kattenbeck <nilskemail@gmail.c=
om> wrote:
>
> Hello,
>
> This may sound like a weird inquiry but is it possible to run
> virtiofsd inside the guest
> and mount the exposed directory on the host?


No, is not possible, we have an open RFE[0] for it, sadly we don't
have time to work on it, but we are open to contributions.
This could be implemented using https://wiki.qemu.org/Features/VirtioVhostU=
ser

[0] https://gitlab.com/virtio-fs/virtiofsd/-/issues/73

>
> Our goal is to replace SSHFS with a more modern/lightweight/performant
> alternative
> as SSHFS which is pretty much in bugfix-only mode and not actively
> developed any further.
> As our primary use-case is local development based on VMs virtiofs
> would be a great fit.
>
> If this is not (currently) possible, how hard would it be to adapt it to =
do so?
> Or is this simply impossible? I would also appreciate pointers to
> alternative, lightweight solutions.
>
> Take care,
> Nils
>


--=20
German

