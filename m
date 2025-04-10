Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D0D1E9B14
	for <virtio-fs@lists.linux.dev>; Thu, 10 Apr 2025 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744304253; cv=none; b=K2+P0Dp9hKaxtSzmpjU98jZ8LoQi7pfkRdpM+CriXAflepw+oDPEFOEVd/RwnltggruWhuWgPTXhTZgY9cN244+y2uFeutnCQLlBk6XN18/yoEbxVGLejGOpVpoAcEE2aBF1MfuMbZABtCsUxS19hMDBxiKqbCx6s2cjdxzc4FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744304253; c=relaxed/simple;
	bh=ss+5XJT1L1JKhrMDChRQXk1bnTOpIUtNNT9UA1Sk+cg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=KKRYG9jqwNiPAytRRazsATPR7lsO3m/1ENLg7WolvhyTmPgyMdvLFY68emsKAo5evPXRWSRizO9XV9cJUf/t/XkisAllm6Zlzt70MB57ebJCx+05agmPHqCMWthkzFgyHjzD4gQ8y5FZuPZ/SeP4SkURrvkdSPRY0gcDoKyanZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NansQvU3; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NansQvU3"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39c1ef4acf2so646550f8f.0
        for <virtio-fs@lists.linux.dev>; Thu, 10 Apr 2025 09:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744304249; x=1744909049; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ss+5XJT1L1JKhrMDChRQXk1bnTOpIUtNNT9UA1Sk+cg=;
        b=NansQvU3j2WlQrYLRy0tUxpmsTUfDuvGv2B6LDi8QpNLVy5zIOV8PhWlr91AOmyJ/O
         rvU7T5xciJb4BUeU7y2C9RKnk/KEBRJsvZ4+K2cTOl94FqCF0BlzcBQXywVw68h2ZjL/
         1is2A4cT9jNBIclbzHS6r14KpUymKqEfi/AKTrnXuGF2rAYJvAMdh4+yuSGSYpFkeb+1
         zTbKLF//o0XvkWh/9S38Z1J1A7N2/WzZiV0v0ndlNmnW3KgqUhrOlcw4tdPQ5T2y0ar1
         vUlm/W09RW3UydZlZJSHezYIUe+woN9xoW8zdl/k3WX66qSJ8Cjx9amiQhixqdAOvFs+
         FKGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744304249; x=1744909049;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ss+5XJT1L1JKhrMDChRQXk1bnTOpIUtNNT9UA1Sk+cg=;
        b=aMuR/axnFsXP+jTu738+WCVKIWswnfZKReYY7g+kf9uMC5XZkijXdi9zskwCurppTa
         08bfCWOtUJUC4LzwnUvRso6ksdn4DH90GpLphboavtTxrEWrGDxIFmORPtvSe5a6+YiV
         SmhxIIwQQSIoBB0ArbdqWCD7MmLjdc7xuPdzxlRbhuX19NI2pyHVpQP1prLUm2MGzDcn
         t7v0y7IUhCgg7WUuwYVTd4SET/EVjiuIimXx4sKnzFoYT/84GerA2M/fAkeKzbNIWitD
         dIGxBMu7RKSgu/TsJ+kYuEfxXqWDf5Z7OYrvyd6/FdKEvXcOpUpjKGwICdSp6hlJVWsl
         vSzg==
X-Gm-Message-State: AOJu0Yw9KfDK7hCbGaVTCOvBijyOlueL1Cb63aZCjv4/gWoNkwAdfHZ7
	Su4B1pKNe4X2IJt8NaGzG3GLKZaI2c6xwl4AK3EBZLfOG70aX0GCZ3vBtzUEVVajy9OcsWIjwOQ
	/dabyH5JXnpWqnnj851OxPCYab60o/9dG
X-Gm-Gg: ASbGncs7Q0Yq//NoAY+ja+YrNekFkOkyXZW3eVPvfWY0V27EKyYFyZjZDuD5cxY2iPH
	TljKbAk6OyVhmSTBWnNzYxVYKE+UukgB6FPODp1q+sZ3PyhQx8tGpgxVIy0TVh2bkBN3rxB5Qf3
	h3Cc8Yj5U/jAHLrJSUjG3ACOACjlS3DJEbnst+xtjygY7aMTxiE/ri
X-Google-Smtp-Source: AGHT+IGCFV28rETiIdMUDmx17r228VDK1wkPPjFeGXjRwjEUBCsMsMMoAMiYtrm9kZkFcWh7X9pXSgaJa8G8K12rfvM=
X-Received: by 2002:a05:6000:248a:b0:39c:2264:43ea with SMTP id
 ffacd0b85a97d-39d8fd3e9d9mr3134768f8f.3.1744304249232; Thu, 10 Apr 2025
 09:57:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Nils Kattenbeck <nilskemail@gmail.com>
Date: Thu, 10 Apr 2025 18:57:13 +0200
X-Gm-Features: ATxdqUE75ue_1qSQ8XCuCp9CyJs-b2ZDhZeaRMewcQ8_hvzmHzRW2WWJowLHef0
Message-ID: <CAKkJDRfz=yb5U=Gu=evx5SW=ih6_5KTKQoqO=tfCEdVX2HEuVw@mail.gmail.com>
Subject: Is it possible to use virtiofs to mount guest directory on the host?
To: virtio-fs@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hello,

This may sound like a weird inquiry but is it possible to run
virtiofsd inside the guest
and mount the exposed directory on the host?

Our goal is to replace SSHFS with a more modern/lightweight/performant
alternative
as SSHFS which is pretty much in bugfix-only mode and not actively
developed any further.
As our primary use-case is local development based on VMs virtiofs
would be a great fit.

If this is not (currently) possible, how hard would it be to adapt it to do so?
Or is this simply impossible? I would also appreciate pointers to
alternative, lightweight solutions.

Take care,
Nils
