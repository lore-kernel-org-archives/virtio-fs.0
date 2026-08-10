Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B1F356747
	for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 21:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786396380; cv=pass; b=cYgqDili6eOhE5pyJuJOAxPO41yxSU3h+ZhV8kdYm5ngT/ONCjS2q2w4zgR3cTrPUXiUgdyHKmoAQOTYAwAsm1iMSbTiYDDzSEx4mSU8cUilezBn4Au+pipVfyIrW6d600IDbgzFdO2Kslsewd2s1CGU0jCKtvZoShC5iHUajyQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786396380; c=relaxed/simple;
	bh=rx6afI/3z3PhA9v9LDg1Ras9+rTeN6gp6d49jWsqI/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hT6+r0zCvUL0qX2RXSr1YjkzsdUX3bbBeW9/DjYiirJ6ipLvSY/i6++iJ9pukmlAPyOIRSudf+lJH5NySzw2Hiat0TsEXGOUBtkpHvV1u7YSFTuy2Q+kPpWKuxVSeQywf/gznYWJOIJzXpFTkW6gsmJvB3M+3KV3mIctV2sCYDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ln4OtRzA; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ln4OtRzA"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c928bf172so15571461cf.3
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 14:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786396378; cv=none;
        d=google.com; s=arc-20260327;
        b=J1orkMqGCF4Aeazl8Z2nbvRjhh7e+KzdMQJCAW/4iT5ddQ07yzbahR0jaGttP7rlMw
         PhG6n/t9qYKtaaG6t8lKiR3bRYnuJM2TrH0LfeVbJ1kb/wwV1J8Tn81TJvuPzI3wLNf7
         ir923wjfiJs+1hbX+87lVjcN3srMWUXrufwqfD5kwIpQD76NPChlQrugE/6M/ldlauIp
         aE7tq8OV4TUo1tjqJj+5Kh9e13tj9LyO1hjK/UG//eyl+Ru21X/8vr4G2EtMGKCsWuGc
         vuSuPGtApdnDtUJNuLgN+U2qhRA3XJQWH6/MttB9K3INNzhfEpoAzvPvR6fOSTECYAsc
         SDOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8rb7mcmgz2NloesB3CUAU15K7LfiXfnLUABNUwSnRkg=;
        fh=/B4ZPCiJyCdfLAwDiqoxKg6bUbxp3BbiUk1legLHTIk=;
        b=eAxmBlMFNrDCKe9Yz5poNKTp69i60HkEa8iRZAVhk0Ju2McezVQdrrMPq1MjlzW7r/
         zW196RKeHgRITELdfh3eRxHBgYlsEca2wX5U0CVXebWsJe9tjrKkjs4+G+nrq5s5ADFh
         V9Gyi4lyFO4V2YS4/r2q3S6N8rbl0BgisTiPPSc9+brHzLP8Q9WAUHsAnvz9eY8Nd3lG
         pFcE9QhmyVmoNG4il3e4mXId8/v+jgVk9H78SHJcDT0va40gSb+GgLB4pDWrci65JQga
         yNaEE6Pl9/D+dkcxOOHjZtIcgje8aqrSGBJBqeoIoGaPcSxKp/rvOqCOJ31ELA5gx/Hy
         TfKg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786396378; x=1787001178; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8rb7mcmgz2NloesB3CUAU15K7LfiXfnLUABNUwSnRkg=;
        b=ln4OtRzAaCWuuM8IoRaVcO4M/yX0Yxo6aDmmPErtUK5nXZHWpZQ+nHeffzxEX6roA/
         tIw5h325VqkzSXkCEmuOeV/IuACTTFGxZGdLVhULkXb3ydO4NLFDrfsDuGf9kY0qo5lL
         nS5CPf7QCrIE0DIZNK0E4bNzU0kpewVXG5n5sCy+tzfbH1VEaYKBzZpqEiWKtTsAh8yy
         LXLjSuP7PUG0WsVdKqeMovefGUDU8kz88nBKd/z2FOcWayeHlJfgQ9L6f2IzwiVD0Nrz
         /NftjE7ChPASXq1h3zWQIkOoCDKoCE31gmg1gSkY0bt3MCDD2u8KDwNA2z7TAyNOfdla
         Y9fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786396378; x=1787001178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8rb7mcmgz2NloesB3CUAU15K7LfiXfnLUABNUwSnRkg=;
        b=LbBA0UfK1zVeEM3VllLXDslIcw5HDW92hFBiRB2RXbDi+dTb7Y4K4WYz4M+82jNVSb
         tYj8hb1742NvcoDvkCahNe4yyTvSgtZDV3hL9HF/3xEiDIGyxcjo4c5k+UtRpxVX+YAA
         wcQDJpC9qT8335t7rZ7kD6m9CAV1NkTFL7x5n6ZycJvu4OLxYTarmFDPksn7pIKyDG0T
         r7DG34LdFKUwVTcRYEEdWVNMgfG1G4aO2RdfmiyGWfaGowUIXKCQe+QEe3/7utbXY3kF
         tCDW/6xFcUSu5A2oxU5bRhoVVA5/gbTrYH2P9WOvL5OGqzJNpcuRzzg0fWFqS0vxqqKw
         wzVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoQM+rzq8YbP6iVDNXca27JowLvJLlGmRkfPR5Bnn9Q6RsV8oOzN9B5st57Ct9ArlHkuRNc15nH8B4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpBb2Z3pKdHgaHL73z+naoMHe3/MaSLO+fm9DhlgwFRnNj0Mrz
	CeufHy56EmWIPM4eVKo5xagZsKVk7G5ZJlGfE3/h5sdctBDds9oGwvrUWlrddCV0sWdsNOTk7G2
	N7X7BC5q9CBywMYDiImYpp2Qv0RkP+ME=
X-Gm-Gg: AR+sD12brl/wPauhr4VHuG7OD0JDCcyZUhr5/6+Jrt3xFoSw1Tu9j6wNUx5xDygwjWz
	OOve83QFbVIB/+ik42orlT2vrn16/qQX1Jf0Ytt75DnmKq86jdt+y8g4XMmOnZYKOuZxhea1fDx
	eN876KgvOcyiI/3q63REfYqq99vpvyKgRS1CGYDaSSaLu3BuHdlDg+qDDDfkyCLuGf3y0GDG/jk
	dwslrGaYKs29bFM38vVth3JlVNkAmO2eNh5joKqOLONOsHgy7DKf1AleR/PbX0fdxjhWKddtHkQ
	Kaz903LU2bTtMPOIIOdkm3Esgjsdv2UUheXLbo+YSjfAx1Vv3TyMuYilMYye536yWmuHdJIKJxt
	sqg==
X-Received: by 2002:a05:622a:614:b0:528:3b9b:4f55 with SMTP id
 d75a77b69052e-52ce5f619f8mr466338621cf.6.1786396378418; Mon, 10 Aug 2026
 14:12:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-12-6b97c439eb28@gmail.com>
 <a0580312-28d3-4cac-82d3-20b211b7038a@rsg.ci.i.u-tokyo.ac.jp> <CA+spn3q7z8aPzLPMr1RtSzni4mM_16G=zGKytqC741iHE=dQkA@mail.gmail.com>
In-Reply-To: <CA+spn3q7z8aPzLPMr1RtSzni4mM_16G=zGKytqC741iHE=dQkA@mail.gmail.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 14:12:47 -0700
X-Gm-Features: AUfX_mx6rTanfPWvC6lR4aqwha51vytwdcQIBjN5UmvHYAunn8xg4ezcJ-_lA0g
Message-ID: <CA+spn3q8uPsn901CoKrhq3xO1X5DVc_KCBYpjz5vRTry=W2-Bw@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] hw/virtio/vhost-user: send isolation regions to device
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10, 2026 at 10:40=E2=80=AFAM Connor Kite <connorkite@gmail.com>=
 wrote:
>
> > >       int fds[VHOST_MEMORY_BASELINE_NREGIONS];
> >
> > This needs one more element for vring.
> >
>
> Good catch.  Fixed!
>

Actually, I'm not sure I can add an element here since the size of
VhostUserPayload.memory.regions is defined as fixed to
VHOST_MEMORY_BASELINE_NREGIONS, which is 8.  It seems
plausible that if this is a standard expected size, that adding another
region could violate some assumption in the back-end implementation.
However, I should be able to avoid the issue by combining the vring region
with one adjacent in the IOVA space when sending to the back-end.
