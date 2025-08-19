Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3372EB873
	for <virtio-fs@lists.linux.dev>; Tue, 19 Aug 2025 21:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755638026; cv=none; b=QWvz/n34VzWcNpp8cimEUFeA99+u4bnYuAQpmbV501xScYo5SHqt94qDeBlik9c0k2ezQvP0xwiPiBYptmfeiCVi93oXFok4gK6LUNmA94HI5BCbrp0w4eJkjCkr3kodGtY99hpHCodZK1mXNAqYGG7IFTxynncJMQhoo/zHDk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755638026; c=relaxed/simple;
	bh=p/yWW15+N+FFH/bHvFKpGBMyaN8TlzAJnwsz0W5BO/Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=XgnSYSCRw+skMsfpHNsmRa5Lq0Xa39xmugdCB7L62kdVQ5q2j65S9dunYKpwUEt32CQlPeV4Dn7VVFkPYalyDbhchn6Q+NtMW2ofIRD9Ptl87CNyad0HSUTzppZEfMA9AT0jq/i+1JurnZHKXC1PmercKvz4IZKvZy1vvG8nNhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XePCvSLE; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XePCvSLE"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4b0bf08551cso21621cf.1
        for <virtio-fs@lists.linux.dev>; Tue, 19 Aug 2025 14:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755638023; x=1756242823; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QvD3FOP6mYbYV7rdgOJjgQi9vy2AIKFV1/K1r+OTXw8=;
        b=XePCvSLEiYI4Jqb+vVmEYdPTZpc+krr6Xz17Qb3sPZOjqmyERPEDTFmOGo4Q1C3iQu
         YWlj8ZDq4r8ymrL88+yR5pLn4q3ncxKUWSnZtTdB8uqi6Onp3QE3u/8pRDlC0z/i3+DY
         U+XOFw1mQS0aZayFBWE89MtfQJpA9uPGl61wveTyATMe4iQUNhbVtdI5QZHVk6e0gmOB
         ZtNqH63YvpRaZVtnwaA9xgnUbbZdFvCoqPn++rh8UGXQRHU6ui5+S5cwtilErPKwdrtA
         45bes1YrGzwK3SPyBqJ+AzkdseIqMd7gFMRjGPPDiOGdQgaSOYetULF12yiBvTIU1UDJ
         7LkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755638023; x=1756242823;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QvD3FOP6mYbYV7rdgOJjgQi9vy2AIKFV1/K1r+OTXw8=;
        b=YI2f/CnaZaMBtEJ/04DLPtxdXrUsOn4nRpJ8tGeES20aXMFbiydZsx0W1eTyY6HzY4
         xM6s8UooNIEAYNCEUFYwUONqPDp3QX8t45gaqVHt1BCgdAe0ZI6ElbD1M3Xp10QVwORy
         FlrFjhzyOD/09OkYRaEcVlkt0cYNUnaN8SZ+2hMwpeaM7bxEDNdtAJz1BwrBKvpYyR7r
         VXMgM2fNj2ujwxkpjQyy1fMisdZA454aO9V55ToqAT5lVrPTQaDhX7Dq2muSNiGhJ8kW
         3yaKZHtaFKQ6ZZU+d+5uuGZ+isRmXvWW8N2h2YkaQ++i1x/koWZCVhwzRtwjq3tjgb8d
         ubrA==
X-Gm-Message-State: AOJu0YwNSHRV2/B16TO+goLyoiRDD5IPFyWhDHyF2VLCaqOPmGyYj1/x
	OB3ws/SZpHdkeOP484ycNtuxtTS1VvgPOFu/ZOcJrM7RQesMPoRYheBBcCDKlwOUgy1evo0uJdt
	gnK25cMeIo5n/c+NpAJ/BpaKMDfJk3Sq0HmGuQzGVBYAC+3R3LtR9eIGIaVU=
X-Gm-Gg: ASbGncvacE0hibsRoyWbfHcB6MBYnKDb8OBwP22mpSjr79QhfXcc12Ex6zy7IKfBTfJ
	U7FG/VOPIKnNAAI/sX4lxb9gq+JnGTQmb+Iq0+toTA41Zdl8iAQouiMNfneMYWqX48b+OpUFAix
	Xn6rmZm27ATcAQp+I5r4LnT1fQC/P2sWiG/nB/geNSD1TA/X6oddUz6rOljLULJGgNM5PJ0wCLa
	d0bFYkD3iDZC3PUoJZvmOHdxGvLfwrcdiUH80ynqVDUA+rbqT2cIeQANps=
X-Google-Smtp-Source: AGHT+IF0RZw2EUT5e6zggauMAajlYNouu5/GDeoHxnR4eTRZonoIMgopdvZlhEvN9OlYSS1FHrze0gmt/K4OMv02big=
X-Received: by 2002:a05:622a:156:b0:4b0:8576:e036 with SMTP id
 d75a77b69052e-4b2916cdeffmr1574041cf.0.1755638022885; Tue, 19 Aug 2025
 14:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jeremy Bongio <jbongio@google.com>
Date: Tue, 19 Aug 2025 14:13:31 -0700
X-Gm-Features: Ac12FXxQUC5AiVwBy26Md9z-5KLn7SVQBQxWEJv23duEjQRytBGjI0triqqIZMY
Message-ID: <CAOvQCn5H3Xpn3RJbMyE6=BkcbgBPrjap6mDbRYJ3wayiV_yGGA@mail.gmail.com>
Subject: DAX support in virtiofsd
To: virtio-fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

My team has been using DAX w/ virtiofsd for read-only devices. We are
interested in continuing this use case, but support has been removed
upstream for

* setup/remove mapping in vhost-user rust crate.
https://github.com/rust-vmm/vhost/commit/569ef077facafe21f16c0e65ff826b26d3c9a0b3
discussion: https://github.com/rust-vmm/vhost/issues/213

* as a consequence, setupmapping/removemapping in virtiofsd.
https://gitlab.com/virtio-fs/virtiofsd/-/commit/87f67e84cb032e6f4ce4a9f408b6305f33d2d041

The virtio spec already/still contains support for DAX.

The primary reasons for removing support for this feature in vhost and
virtiofsd appear to be that it is not in the vhost-user spec
(https://www.qemu.org/docs/master/interop/vhost-user.html) and there
are major edge cases not dealt with, so DAX can't be safely used if
the backing store can change in size.

Some of the major technical challenges to supporting DAX were
discussed in: https://lore.kernel.org/virtio-fs/ZGaAalXSMhPb3eqe@redhat.com/
    ...
Specifically:
> 1. How to inject SIGBUS when the guest accesses a page that's beyond
> the end-of-file.
> 2. Implementing the vhost-user messages for mapping ranges of files to
> the vhost-user frontend.

I expect the steps to support DAX in virtiofsd are:

1. add the necessary vhost-user messages for mapping ranges to the
spec ... What is the RFC process for modifying the vhost standard?
What mailing list should I use?

2. re-implement vhost-user messages in the vhost-user rust crate

3. re-implement setup/remove mapping in virtiofsd.

4. implement new vhost-user messages in qemu?

5. find solution for safely handling page faults beyond EOF.

Can you offer comments, guidance, opinions? Is there resistance to
this work or is it that no one was interested enough to complete it?
