Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FEE344DB7
	for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 23:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786406074; cv=pass; b=Ue+GFmap/EmsO2SSUTM4HpHKfTw40UCN9Q+h4CjYxlYAfHOdPr4cCZPmG2SrD/F1hqCYq1B1zn8z1utwpqcEU0gbNEkcmMiRCbCs0lfu/BfpaM2UVAP00o/1l8ti42e3/Ktp1VYVPRWNnxnAhDIay7rofkJD8DEpvuiWeLtP/lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786406074; c=relaxed/simple;
	bh=ZFEgdp/UwYgZGct1QOEr8/MQtZr1ebJngOymetVyykU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fEmSv52fA5+XBMPyXEcb+3Algj3/3a9kp7bRUljRaZnbmOb/d6tLtm5DZDJIE4rpUeaEiwuXi+rEkSYoBhOO7YvtWoVfhF2ygFF7uJUv/+arli2xeolnn3rps1TIhMMZiSu3TIkqDylu1mcNlS56hhz5jJtUIR4fUuMCLAGrwIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMW2Qw9E; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMW2Qw9E"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c2a818fc4so16436391cf.2
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 16:54:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786406072; cv=none;
        d=google.com; s=arc-20260327;
        b=qqjIvakS83njdTZRgpGWTc3z+3pGlbwf6Tp545H1msJr8Ye4yXAxm3077duOHzv1zG
         bXDhI+0Ki0EuF7xrM9YU7lYSZlcjsSrmGE3nd61Ld7CKZW0zabk+TCHCDKQuNd02y3SY
         1UVtyR9xuJVlerq6VrgGnkuUzpTzjh6k9mtMkK9rOfY9Fw1Ab/o1QF/1F44jTbfwomZ5
         aX86ClrgPq6tkz//MvAElxIMtM9VQGbpVbmkM1C4GxvZBiR3nfgu6DCWJjE4bxxtXalz
         6Zy0DyY2cvifFdFr8VOsERemqbdRwsJHKr/L3JmygNLOkTIZrKbRUzlowCbZDQoQ/4Dr
         gBuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nq9yccxUs/kr8RrWpDcEE5cMK15U5ZnX0pXbLqC7Eqo=;
        fh=ytElwRTBXn+FrKjyxMZK9HAN172eklnRSsXYVKkPE9M=;
        b=Q8rK4ciEGHJgAlrlZH0btNF5LLVGBDJTOkEBYlLUXoll2i6Rsx5vitac1MWfFxaHfj
         rtpcM1HQ4IyWjxJtJ6xHH7sjtktDeKVsw7bR94exs+jFe/etGsOFdBKQR2GmwuRkNNVj
         SNu5WjJSQomFyKHAq6NBIuZ6PqVhDe2vF0H7uUWDR6eb7LlPGL+unV0sqaM97WHoJgMV
         Xnu8EXZFZeVJYZmltEfERZK6yLRVTbWy82I7Twq40ItNaP2bLzT2b1GikmIjwN7FoZbP
         yC6AJG4F2OsUG9waFjfV4WZjq3R5e1yl6OFPUWgE/GddaL37o8DGTQP6apL/X+lSApiF
         80Kw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786406072; x=1787010872; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nq9yccxUs/kr8RrWpDcEE5cMK15U5ZnX0pXbLqC7Eqo=;
        b=kMW2Qw9EB+pgTtKaKczf3uHXd7MMqzinxOXC2VZ7C2PooxFN1eWVWiXu/Kv04b0KSe
         S0MDn5wUsDDoYuCfA6f0JUbgMOcqBzcLtzWRkHzrkZR76tvp69WDAqEjw1qryZdZjlmG
         7o9LggLU2oD8s7ZcLXkM9Rs3gQ1bdniXHN+4pkigGnauhYAdsAgE3EI+Mx6OHmzz/uxm
         riITYasGzykudF3qEVJ3+Z+YiXlqps4hqHGA3CeSyA+uaB9Ha023SM5BiHLGEa4aVwuE
         kS7OAIG79zT8GtzaxZFSywxNpwDi4Vevz9EY0lC4qmDoMbe3uFXl+L2i9L/puqHioBSZ
         8bXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786406072; x=1787010872;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nq9yccxUs/kr8RrWpDcEE5cMK15U5ZnX0pXbLqC7Eqo=;
        b=a3sS12pf69aDCxKJt1504C/H8kR61e/+D2mHLvSFnue+M7Bj0nppADJ9ThCY5zcqa4
         0Id9XxmX3wO90yqbDwb2hZGkyloAaBaH7rCffjFQs0OUrQdUOjCdunyocsjdGd6B9012
         hzu3wlLeAeTgHSpeAWdItxLMKYuVnPJoaWx8eFZPzceduWdZrTjR+PxayD6CcWuOnFtR
         mQ7wHP+mb5jtu0h04zs7rwuhGSNQOu0ROnOKX7NDppnaPDrQapJrM9HX7FfMPwAaXDPi
         cAoBNgXTa/LePoepBfiJv4drQcsKTM8oFJukEdPNfGMabCofeGPHSk7rABz40qbAuQQu
         W5MA==
X-Forwarded-Encrypted: i=1; AHgh+RpyC9upSgJFUSJ8wNE5DBdeCko76lFhA7yDEJy5gdCJOYhkZMtLz3VGZnrEpZE690X7a37PuwCpFgQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxEdIKRHouobIXxLS0fOZ/A+6FSkheVVWUqfgSM++aHL9y7eo4q
	aZAkH9LqSNOp8CAeVKvw5UUHxyPfdQtOXSMVOAuesnFifnV/YM98km/Rj50aKxmXdAWAZrsP29g
	K77a7m+ex/CnKMdxyybWbBdEElP8/30Q=
X-Gm-Gg: AR+sD13gwyXFZAWhaqhjjGZyyxRRUdQ/hEow6iwSHevFdpOuRQ/26UTM/n3PvQN9Igd
	tsEIpLphpBsTe5jVucf5q7I2pjKqJndlFcmFZnIFjvSzNZn2Oq969Njjy0VpkJia3prlutsKOle
	SuRtrBaNndlj03r4dpy1qop1z3KQ7YYbfzmruFvIVc+c1A86YgMPC7o2vNgrDAcillnQ1atmmhR
	/3oOUe3SJUgR3I6QAZDH7M5GMNbycXzv4qSLelKo0m/fGrByVHpdARedO7Ad+PnPVppoK74J+9E
	SSBCA0q2fEKFanwL6G+2l/Ni6kL7Eait/FUG+qw8Z3TctsRXCS9dZER3BaHUnGOIHq1yAPFOBY9
	d1q4=
X-Received: by 2002:ac8:7fd6:0:b0:51c:1bb9:137f with SMTP id
 d75a77b69052e-52d4c0e990fmr62676311cf.24.1786406071606; Mon, 10 Aug 2026
 16:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com> <82cd1e6f-85f8-409d-9214-00c696fbdcae@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <82cd1e6f-85f8-409d-9214-00c696fbdcae@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 16:54:20 -0700
X-Gm-Features: AUfX_mxGOP5dGxvbLn4sLop8Z_8XlVgjEM0ILnF5bv1b-7DqCdw9mdRSoiuqfm4
Message-ID: <CA+spn3pBnL4BokUKcp2uQCH3vfW4v3mYAuzwx3Ppnv4vutuHmw@mail.gmail.com>
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
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

On Fri, Jul 24, 2026 at 6:45=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
>
> This is not undone in case of errors.
>

I've added event_notifier_cleanup calls to the errors here.  As Hanna menti=
oned,
I have svq_cleanup added in a later patch but should probably pull it
forward.  I
believe that currently doesn't clean up notifiers, so I will be sure
to do that as well.

> > +
> > +        if (svq->hdev_kick.initialized =3D=3D false) {
>
> Simpler: if (!svq->hdev_kick.initialized)
>
> Regards,
> Akihiko Odaki
>

This is now simplified.

Thanks!
Connor
