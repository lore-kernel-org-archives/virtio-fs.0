Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF4825A645
	for <virtio-fs@lists.linux.dev>; Wed, 20 Aug 2025 08:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755678856; cv=none; b=Qdpeq59WVZ+hE8ABmnXw0TSnl3+Q7TceqjdG+A0i/rBkM6hV8whhcTKekB720jLLwqNn1GTJZbttrJPCdVuMOhiHl7EkJEmCNrjrq1JGEtn5FMT+JY3E7OQZ2M+7IDVsZXnAceUTeFMFtLAqy3JeclgtJUjeZO/Co25L9Vl3ruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755678856; c=relaxed/simple;
	bh=9KE2ug4oxCPsR8eMe2INNLHczHWzbVhiVhMzZbJ9z1U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Kt+MxkOSOhKDJNV6SqIKz48GUAFzTaJHWdOiaNTuf52mDqhxrDdZoFav0U77iSsdfd1iIM8LAkRzxfUuBMEkM/7opGS5gx+XOzsSuNqckbNZOdPA5iPz1RSZiW2BNkMhLWatPZ+Ee7X7nB+mv4GUT4aJHphV853ysrIom+mvf7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G3emfKzV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3emfKzV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755678853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WadwIMrASvYO6tUJ3jzoio/88Ha9SRjKdt5QKCkvtzc=;
	b=G3emfKzV1U4cQINE3CZmgDZLBGj3gIhWapB7uBOUavjdgKd7yCjRRJoIHmLpT9nk84A1Y1
	D4WBGwCsOWYRAVoCoFjTGX7NhW8FsuXQi5TsWk5lknAGGkHDqYuO+3RblfdfvcVHUa5vis
	7THKDHwMYRj6HFNL14v2DFYaoZq0+1w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-eKDLKltUNqyT0i9fTW8EXw-1; Wed, 20 Aug 2025 04:34:12 -0400
X-MC-Unique: eKDLKltUNqyT0i9fTW8EXw-1
X-Mimecast-MFC-AGG-ID: eKDLKltUNqyT0i9fTW8EXw_1755678851
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1ac1bf0dso4077755e9.0
        for <virtio-fs@lists.linux.dev>; Wed, 20 Aug 2025 01:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755678851; x=1756283651;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WadwIMrASvYO6tUJ3jzoio/88Ha9SRjKdt5QKCkvtzc=;
        b=MbkUwCWtTlH7wrzqVvWBf5w/Cupl87ldD3RpZY0z0nR7ZI9M4x05ZkIZuE/A5hkThX
         rav82g779ZglHOjdXZ7w1w3POVRoYP+ZPtUuPzs/C3Kg9q0EI56xI+WLe/OrQ+TE4xtJ
         iDgiT5KMoMLqlwerXWnpLEbYV+SYAnvWXDbjEg9kIST2GabCdz79kx0x+BMfDhcRENiB
         q30zCHzZqqHv3YlUxmKXz74XB6dGWpQULAEMiEocbfM0dJdwtzmr1fgLivkzHXzTx5RE
         cgRludSCmqvxyFk3XebUg0KHCOrgCectvZA1pk0Q3F2wyhARziyXzDrxC3sVc/FUe489
         OEeQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTC66Nx5VrlzUxag/kXOrfvza+DeT+iYYbLVnKaFmCwU2M7cYaIRXlAjMAOoS9OR54fOK61ht0v9c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5sC3nGQRYbNBtUEvh/KAfvLMBZv91DkWKaY38IQEXG8SMA+sn
	sqm2zXqIVpIiMssjDME3GQWJLtXsxP6Ge0ra1xLzDnKICLyvlDsX3sQesWKkKfLLmTeuDq8OhLB
	dxckil1MLAXjhVyuK9MVeMrK/JsuG1/Xwyhx+ZJq9iHllNhqK5znDQCzDH95cyQ==
X-Gm-Gg: ASbGncuw8i8M88kizbOUhpDuCQM+kKTc/H28TVO9sSwGhh/GEfnQcm/VI+B4WurrukQ
	SXajXhoiR7KPThuxCu/1Q7WOpfohAr21A2YQA4a7Ep3bPPtQgIV+cWZyAtnHSdpMqqfZkg7qc+t
	UQ1Xqp6GKk3MHETo/vKPFVdKrcN/TNjAT9FOb+IDJyBgnUE2qh5IhUbXSgYg9d4oSlLt8xEWJ+s
	5kngCxF1z+Sr3QDLstfx/ePb8AAqqeuAgUZWwnzXjzsq/jZiwsrx2JEcKCa/OwbVr55dV+BRG+R
	kWHcryPzPhpQUnJbp4vQpEwCEvlpTMJOS+SOuW0jUVzxwsleU8023WthWtENWEw395EcvW+zebB
	ocR2cIXEBUjA3UUFWR7QDwzKjvsgrEmvyDTjWsTMib1hB96jfp27c4XpKDqTBs4+x8Jg=
X-Received: by 2002:a05:600c:c494:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-45b4743654emr17038275e9.5.1755678850860;
        Wed, 20 Aug 2025 01:34:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIBe1ofv9h7wEdg4lov7XOR2BU1XZJnS5qzEUa2SGJghzgqGJFlTJZVe+M6UaNHw3/WJsh8g==
X-Received: by 2002:a05:600c:c494:b0:459:e39e:e5a5 with SMTP id 5b1f17b1804b1-45b4743654emr17038005e9.5.1755678850414;
        Wed, 20 Aug 2025 01:34:10 -0700 (PDT)
Received: from ?IPV6:2003:cf:d715:682a:c369:ef79:c58d:f183? (p200300cfd715682ac369ef79c58df183.dip0.t-ipconnect.de. [2003:cf:d715:682a:c369:ef79:c58d:f183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c0748797a1sm6478382f8f.5.2025.08.20.01.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Aug 2025 01:34:09 -0700 (PDT)
Message-ID: <9783ed13-6628-42ac-b82e-92ff489ff367@redhat.com>
Date: Wed, 20 Aug 2025 10:34:08 +0200
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: DAX support in virtiofsd
To: Jeremy Bongio <jbongio@google.com>, virtio-fs@lists.linux.dev,
 German Maglione <gmaglione@redhat.com>
References: <CAOvQCn5H3Xpn3RJbMyE6=BkcbgBPrjap6mDbRYJ3wayiV_yGGA@mail.gmail.com>
From: Hanna Czenczek <hreitz@redhat.com>
In-Reply-To: <CAOvQCn5H3Xpn3RJbMyE6=BkcbgBPrjap6mDbRYJ3wayiV_yGGA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ps9g84krnh6noshlBRb7IDXraE6H-McqQHimivq58M0_1755678851
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19.08.25 23:13, Jeremy Bongio wrote:
> Hello,

Hi!

> My team has been using DAX w/ virtiofsd for read-only devices.

Does that mean you already have code for read-only DAX in virtiofsd?

(FWIW, we were considering this specific case too, because it wouldn’t 
have the post-EOF access problem.)

> We are
> interested in continuing this use case, but support has been removed
> upstream for
>
> * setup/remove mapping in vhost-user rust crate.
> https://github.com/rust-vmm/vhost/commit/569ef077facafe21f16c0e65ff826b26d3c9a0b3
> discussion: https://github.com/rust-vmm/vhost/issues/213
>
> * as a consequence, setupmapping/removemapping in virtiofsd.
> https://gitlab.com/virtio-fs/virtiofsd/-/commit/87f67e84cb032e6f4ce4a9f408b6305f33d2d041
>
> The virtio spec already/still contains support for DAX.
>
> The primary reasons for removing support for this feature in vhost and
> virtiofsd appear to be that it is not in the vhost-user spec
> (https://www.qemu.org/docs/master/interop/vhost-user.html) and there
> are major edge cases not dealt with, so DAX can't be safely used if
> the backing store can change in size.
>
> Some of the major technical challenges to supporting DAX were
> discussed in: https://lore.kernel.org/virtio-fs/ZGaAalXSMhPb3eqe@redhat.com/
>      ...
> Specifically:
>> 1. How to inject SIGBUS when the guest accesses a page that's beyond
>> the end-of-file.
>> 2. Implementing the vhost-user messages for mapping ranges of files to
>> the vhost-user frontend.
> I expect the steps to support DAX in virtiofsd are:
>
> 1. add the necessary vhost-user messages for mapping ranges to the
> spec ... What is the RFC process for modifying the vhost standard?
> What mailing list should I use?

The specification is part of QEMU, so the mailing list is 
qemu-devel@nongnu.org.

Generally, you just send a patch to the specification 
(docs/interop/vhost-user.rst in QEMU) to propose additions to the 
standard.  If possible and reasonable, it’s good to accompany it by code 
that would implement that (in QEMU, and e.g. a link to a private 
repository of a vhost-user back-end with that implemented).

> 2. re-implement vhost-user messages in the vhost-user rust crate
>
> 3. re-implement setup/remove mapping in virtiofsd.
>
> 4. implement new vhost-user messages in qemu?
>
> 5. find solution for safely handling page faults beyond EOF.

I don’t think there’s a strict order here; if you want to implement 
write access, that solution probably has to be found, so delaying it 
until after the rest may not be ideal.  On the other hand, we’d already 
be happy with just read-only DAX, too.  (And steps 1 through 4 may need 
to be done simultaneously as a proof of concept, to show that potential 
vhost-user spec changes make sense.)

> Can you offer comments, guidance, opinions? Is there resistance to
> this work or is it that no one was interested enough to complete it?

There is absolutely no resistance to this work, German Maglione and me 
(virtiofsd maintainers) would be more than happy to assist.

FWIW, there’s a virtiofsd “community” call (usually just German and me, 
hence the quotation marks) every two weeks on Wednesdays 10 am ET (i.e. 
currently EDT, so 2 pm GMT), including today, on 
https://meet.google.com/bsx-qnxz-ifz (notes on 
https://etherpad.opendev.org/p/virtiofs-external-meeting).  We’re happy 
to discuss anything you’d like there, too.

(The next call after today would be on Sep 3, but due to KVM Forum, I 
think it will be skipped.)

Hanna

