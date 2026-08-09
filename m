Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334FF7E0FF
	for <virtio-fs@lists.linux.dev>; Sun,  9 Aug 2026 00:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786235822; cv=pass; b=MqPlWGtWp1ss/4FndAvVCtZOMutesUbENxWT5ExkCy+IY9mJxjiVF8/ZmA7J2mWIrgxaQm9a+F+i11kT1mjoaCiifj9oUgeTf+OJrHPXDb3spBW6BOt9eZWhUnAa21kpskutxIBK0qpXBLuFxz5Ah2p6/TGnigcWkAplsG9xPbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786235822; c=relaxed/simple;
	bh=5JLADKAvtVo/lnyK6Q4mBoKnMEFaVsYYEOTCQurIBVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CTO9FeIp27GaOSE3n/rd15kYUDV+VIXHq6VmUF3HYvJ6H9lhvsjS0WqgrUYEyCC4Cdoi/AyuZC7qLyA8Kx7Ok1XDN+x2PNCytZur0r5U2A9McLpJt1+9+tB95A+S9zHeWNUkZ4cY2JYNxLD7YWUcnJz6ughDV5b42p9D2ivDnwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z4WZ3ZVM; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4WZ3ZVM"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c167c58f2so5647481cf.0
        for <virtio-fs@lists.linux.dev>; Sat, 08 Aug 2026 17:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786235820; cv=none;
        d=google.com; s=arc-20260327;
        b=qbuYWIMVqQvZP1xzSB1P1pPLPPTukEwQL22vTWiFhDgk6ewkcuVVhbxVUopMdlZGGE
         o24FZ5fbyTSKndOWEtx9PvqYIM5k6dWObhDGPTNxkb1qe58lCyDbZxQzt1Y0rc0op8OJ
         9xSiVc1nWkLaZzTqnfCCHeujN2hhIqKWlbp48MVEF1eoFrRpX+lW+FoZl7wTQCTZcPxV
         ALS/eK1Ej5JloWJiLO1Odg0vOGJ0l23CsbHZ9Jne/NnzoZGUG5Ke3l1XdE0hSDmVqYvZ
         7BpTzap/aptqjiTH0GYEUXkfP1eVusrnT9PlRF9eyLUtGj1Ruz5HLRQRxZAXUNaOkn1T
         NfrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U2FNMfCeaIJSY3FbDIFWzwdejgvJPNQmwpErCpjxCc0=;
        fh=l1zxyeVU5Na4UdIiPHN0Ht1hwEoPW0tQzc2OuMYdvsQ=;
        b=YiYxQm4Z5ztygz6w2xhR3Il5mUHP2pIvs2iJ/hXSrrxYe8TTrqvplOHhwZR2q5xB4K
         8y5rFKq4isBGbMc7bSMRdSH6h0Esc/KnGIiwtsTA6KO+CEZYiVks8SQ1uX8i7kD1iIEY
         taEl3a2HD4CrCGLinceNTmynNql7RH8uGTc00fuRFyWTKhpzvDvUFSggaUWG/P6UlqyV
         pdD0ouOhNu/LGkrVHVx2VCaaQYz8obP5K/uBa/9UAUQG1FrLqUqPxNaXyt/Awk9ibe4b
         5yaj37qP37v6DX4uxJvES/Ru28vQT6EwfUiubU3YBjsRKMo/gxidWgClaf/6GfZc4Sl+
         nWtA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786235820; x=1786840620; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=U2FNMfCeaIJSY3FbDIFWzwdejgvJPNQmwpErCpjxCc0=;
        b=Z4WZ3ZVM6NrRzy0ZC6G1Na8awGhOOxi1BnbiYpPxRKSh/scHHS1nEiYgIo59ioD6At
         LImi54Z9SDOieBlCxet7rp5poJSN1Hg17zTNcjqBeQTLfMcdxl1wQgQUMHys/uCxb1E3
         ZhFl0tIwYLcm+0ul0aN2XqzStdqRFS/Bighj1Ii/co+iVVEOUOFBKj+oDEgYfw1njZks
         iBpmAPZJryKPaFmiTJQMCMzdRXsVDPNuDDjBkcWBQraU0H1gNweL4CW0GMtBKTaYOXS2
         QE1MfMImrbjuZumtWrTXmiiknvdWjI6DiTXAl2UF1KBTunioHNElFB0ZsOH0m59qwUwP
         tP7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786235820; x=1786840620;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U2FNMfCeaIJSY3FbDIFWzwdejgvJPNQmwpErCpjxCc0=;
        b=LdYtKh07mRAWlD7U9h06DnXMKgzr7PQQQWSLJO0/dkn+AxHdhlziA0R/Z4QPwwJDVJ
         AwiL7PnIwrvIEYtE7Ce/9vvhF8TKrMuTN2PYHT8UF+brrJBCjX3Wmt5T+LINZQumMgvw
         ksuY9b5FQNVQmYLHnAxvwTpcoyX4k1Xeixe0S4fDYTh36UkR7dVEOk/BcDdXBudvbE+/
         6VfPNT2tNsQHjzyA00352oKaBz/jLg+Ikxw/+F8cbAIqtUWVlF6l9ikjLkb74aUMJ2Vh
         cgRylA1+3CVO/g1keA1fPc9GIXE1ZtSSPUXqWlw7Yna/9e47lCFwprzb3hIsal6+SOAp
         xOHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpHKpSf6EgdGC8H8oEZyLA35+c2Cw/+Mb471EnZwPDSH9zbOodn+WYHhRtQUsdYQHd/EbbFq7BhjSM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOSuDFTFvYdBmcLx4NRxvWQHlCfrqQb5RH8+goqDMMg/gq9xdA
	3TVGIij0WqNTz8TLjdcM6JxS9HeRQix9toNmnaganAa3jviNVtvW59vK0WFrnrZMRoL89HQLp5A
	Aq9X+tfUquJIPQrTlqQ/X9ZwPKAVKNJw=
X-Gm-Gg: AR+sD10iSUxmvCd185Wyi4NSSFPm6IYhj7YLqPjj1BAh/07s6zOhQhJ/uOVubKNySPU
	YvTEGCXh1BC70BiR/5FDQFAiF2dtvuUmQv4/bLp+jgPvLMREcLrh78j5mIL3gxj1gzz0tM+MigJ
	8LyH7JsfIcP+CWW2i9fe8BcMFVYBZyCrXIwqgWCrVVLSQgpjALArWj1Hrg3+Pjr/b16ahOpigNS
	d6MbK/VTegHp8qqGjx34S/OnLYW7wjA3M6exTSboinisqi2TeXjD7MOkTdmie7/TW41vZnaPYnz
	hnxpahf24RsGujbjWTWPTtFQkIJipYq529IVjg/6VEZElDnXvze1g10IQD28EMVQEAXMwclpL75
	18yx0T2PAxbttFA==
X-Received: by 2002:ac8:7fd1:0:b0:52b:4c5a:5844 with SMTP id
 d75a77b69052e-52ce6107865mr337663041cf.20.1786235819757; Sat, 08 Aug 2026
 17:36:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-11-6b97c439eb28@gmail.com>
 <b6bc052c-1bf5-449b-85d0-e1c4624a5d99@redhat.com> <CA+spn3r9X4WST1c4LYS63xN0EFogkD1dJ6P4omk7ndMDeF9D5Q@mail.gmail.com>
 <fa4a6c1a-6b21-47b7-8d1d-25b71cd70a8e@redhat.com>
In-Reply-To: <fa4a6c1a-6b21-47b7-8d1d-25b71cd70a8e@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Sat, 8 Aug 2026 17:36:47 -0700
X-Gm-Features: AUfX_myUuB4bkE-RAsE8iU-1mb_0CTwrRXRqflL9p9Ur6l0u7MEkNwMV10ZQaUc
Message-ID: <CA+spn3o8FRxRK6q8SAyXxjNhRBdCt7m3Si3hqD5JZ9WpVf+FWQ@mail.gmail.com>
Subject: Re: [PATCH RFC 11/15] hw/virtio/vhost-user: create isolation region
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 4, 2026 at 4:03=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> >
> > I guess the alternative would be to have an `isolation_mode_ctx`
> > type of struct to hold all of the above.
>
> Yes, that=E2=80=99s what I thought, to have an object that would hold eve=
rything
> that is used by the isolation code (and rather specific to the isolation
> code).
>

You got it!  A struct to hold all context specific to isolation mode
will be in the next rev.

...

>
> I mean, in this case, I would have just used a plain C array because the
> size is pre-determined by `nregions`, right.
>
> In general, *I* have not used GArray yet (no particular reason), which
> is why I had not come in contact with the `&g_array_index()` pattern
> yet, which had me stare in disbelief at first. (My main problem being
> that the name `g_array_index` is written in lowercase and thus indicates
> being a normal function, whereas macros in C are generally written in
> uppercase to allow at-a-glance distinction. So it pretends to be a
> normal function, but glib recommends a pattern of use
> (`&g_array_index()`) that would never work with a normal function, and
> that I find a dreadful decision by glib.)
>
> Hanna
>

g_array ugliness is now avoided by using g_new0 with nregions to allocate
the memory.
