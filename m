Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6784AEE2
	for <virtio-fs@lists.linux.dev>; Tue,  9 Sep 2025 15:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757433266; cv=none; b=GpAtKevgjkQBT4an0Gu4PgB4TtDKrNi1Ngs2nizwQBhk5DH2zBKAYVYMtjkWSrMq+uNt2Q5EIrZeQgZpKj24W2qxBaMOyUncmfB9DkmW7hY7Yfwvb8BFPbVRdIFcx/C7Q6vnhXV6sVpbvhPAiHC8jsIfwzNK9yUDIS3T9ChI3cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757433266; c=relaxed/simple;
	bh=zBxD/WgCU5wbpv7e0FRBV95KjhkMpdvOcHaWXJaFOWo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EHNGsyLoSaIwrr/Y02lZztXCvxXCbuiFMCWTr84EZrGpIYA98y3fPpFww8GVTEHMvlOeR9FP0X/yE5R+gyhDjRGJnHxNKtOS/Z7iArUOYSDlOEJ4qUJ8KbR3Cnz8y52XKPFXTyeGVOsSz4AEu87kTiuYK8VlKZnTnGBkv2hMqhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vMTDqR8C; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vMTDqR8C"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b5d6ce4ed7so1367031cf.0
        for <virtio-fs@lists.linux.dev>; Tue, 09 Sep 2025 08:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757433263; x=1758038063; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VqGZ99/taR9w+xuAip1KMNcoTr4YDAyDRTxmqZoXxuI=;
        b=vMTDqR8CIGv5xMtQ/Rk/OCrrKMESbNsBTxSUO85uUFVeVIBbbHdY/4xFhgDFE13D+h
         KVAIEIWbIoHfcl7Ftxwk4/Wppp71M/DFQ6EDSTeKTBEO1LqQd+vbCKnt4J0fGyKljyg0
         pD7dtYX9SHR986PfEryRGJ5SmsgnC1n2LTpK6zzNt8M/ncaQcrt/502vJL+LpvJaT5dV
         tkAuFmCI7DafgsFp75Bd2lOoyUlaAMMByVOYFOKHbm14QZk7kV1uheMo11aEaRV3zJKn
         3IUFrl3FVvPiIfwpXBCRnMrHDA/AVbn0GeRgDKZH8cGz4RgfgVIVGsE2/86SwgULpR6s
         BNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757433263; x=1758038063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VqGZ99/taR9w+xuAip1KMNcoTr4YDAyDRTxmqZoXxuI=;
        b=cmvh/n2fc7ueoM+8XX/EHqlsoc+sFSm9ePngjfw0IYGNQQPEEWi9+B0vsd657fzEGP
         ez8G8f2V3H9Abmhrw+69hHy3vYfAJjyunyfYhKsn91hTyxGwEAvE3HFAqWZn1QTWf4pV
         3pBXyPA2nV9iYNWsCxAfZLV2aJCSZMoevCDCkp6PGlaOcDDqT2dvHeVfaKijAA0pbH/o
         nBJEigMrHRNJfSoJvt3oDkicL/VYGdNrLRvDWYknaA54G88Tt/NQzIEd4RuHFD+w0DCs
         mzZWWRLxwSQAfKq9EAJwEW5ZBk2R610w4uW154N9svstjUeI3buU21I+4PY3dVPEC2qQ
         e+eg==
X-Gm-Message-State: AOJu0YwRSThUXbCMi3c0oACCyK0GJgKAYuNmA1rA4ZtATKTjSTYMvlnf
	kFLqz+Gt6Dw9ldMV4lftNTUw/hNLDaUm7eMSDdiyNFwO5vzBGu0fhY+wmgWrIjWsSMfI/R/aHUM
	a72gLIhcy0I7K3iIPbqAil5Yl3fYd4fIjJhdA+/pc
X-Gm-Gg: ASbGncvQk9zY55Bznc9Y5FFgLdD55CVJOBFd+gDoSUFXE+2IBe2OzOYechEPC513+0J
	ZNrSY7MB2aMYL7Rk0racq9SXR9EQmIQyFqZsJLx6SBBQYPpVUAD5yW/HtL4zKp5RE8aMfACpqn/
	/YxMLKQb8aOyyi3IEYdwHUchhr69KSq0IKMQbE3+FbVmGny1luUpnpR3NHQUe6IqIjNlnupOsI3
	LFxqgQw5zPx8NZANG53d1QX0doM6c9bAtuR1/ufD8hvkK+92UFNVXlNzzM=
X-Google-Smtp-Source: AGHT+IHYBtAdKdGsn2IZKcWxWelKeCDWj57fHYGEHDuhCYbehbrTT6GiRS2PIeYSy6/Nq9K+EIFXD+6dTMiwhsN+L6Y=
X-Received: by 2002:ac8:59c9:0:b0:4b3:8ee:521b with SMTP id
 d75a77b69052e-4b5f6d1d109mr18601991cf.0.1757433263056; Tue, 09 Sep 2025
 08:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAOvQCn5H3Xpn3RJbMyE6=BkcbgBPrjap6mDbRYJ3wayiV_yGGA@mail.gmail.com>
 <9783ed13-6628-42ac-b82e-92ff489ff367@redhat.com>
In-Reply-To: <9783ed13-6628-42ac-b82e-92ff489ff367@redhat.com>
From: Jeremy Bongio <jbongio@google.com>
Date: Tue, 9 Sep 2025 08:54:11 -0700
X-Gm-Features: AS18NWCIFcCrvlKObGfroopFtUPqQg7_EOIYy_6QpzhNjHUPrhndXoUEAN6u-OE
Message-ID: <CAOvQCn7fjO=P2pAi7rcRsLD6Eit_rxFq8T867WektwDv2XDt+A@mail.gmail.com>
Subject: Re: DAX support in virtiofsd
To: Hanna Czenczek <hreitz@redhat.com>
Cc: virtio-fs@lists.linux.dev, German Maglione <gmaglione@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Does that mean you already have code for read-only DAX in virtiofsd?
We have been using the DAX that was implemented in virtiofsd and
vhost-user rust crate but later removed.

Our vhost-user implementation is for an internal VMM.

> I don=E2=80=99t think there=E2=80=99s a strict order here; if you want to=
 implement
> write access, that solution probably has to be found, so delaying it
> until after the rest may not be ideal.  On the other hand, we=E2=80=99d a=
lready
> be happy with just read-only DAX, too.  (And steps 1 through 4 may need
> to be done simultaneously as a proof of concept, to show that potential
> vhost-user spec changes make sense.)
I will start with read-only as we haven't solved the write limitations yet.


> There is absolutely no resistance to this work, German Maglione and me
> (virtiofsd maintainers) would be more than happy to assist.
Wonderful, thank you!


> FWIW, there=E2=80=99s a virtiofsd =E2=80=9Ccommunity=E2=80=9D call (usual=
ly just German and me,
> hence the quotation marks) every two weeks on Wednesdays 10 am ET (i.e.
> currently EDT, so 2 pm GMT), including today, on
> https://meet.google.com/bsx-qnxz-ifz (notes on
> https://etherpad.opendev.org/p/virtiofs-external-meeting).  We=E2=80=99re=
 happy
> to discuss anything you=E2=80=99d like there, too.
I plan to join the next call, Sept 17.
