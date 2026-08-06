Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB196175A83
	for <virtio-fs@lists.linux.dev>; Thu,  6 Aug 2026 02:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785984666; cv=pass; b=lAiTChmb6a6VqkVJPshBHgG2Vi/adNTXLFWN5QntdPzn2tU2XxLthab6gzsw6ivvRDgTHhEfbV+ltRiksooZeevsweQYkTKvu2/XJ2Jtw6sjz6H2RruV+99WWxMkecfYnxQkct00dUbcB/DKLR+u0TgfZsHmWhME+mk+VmY8xGI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785984666; c=relaxed/simple;
	bh=/KuIAlLmkwjYe02EBicjMGBp4Z2mkQF1m+EuAqyCHOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KbQkDBh3U7wuDgaCrB4aNFqrYx2tMA40UGiZUMcghrY6s9JB35L2Z1SUkAfcVWW/jmFOgMj1CyispgQ8gVfEdmp3BChjU3a9gTZo2wQTC0K/33R/HrwTLd1zzFjpwFjlCBkDkQkoOSORaAoeL+mjImSVZy0V1PXh8SR88VU2XsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aXt4JD+x; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aXt4JD+x"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-529a1ee0e62so11065621cf.2
        for <virtio-fs@lists.linux.dev>; Wed, 05 Aug 2026 19:51:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785984664; cv=none;
        d=google.com; s=arc-20260327;
        b=rNypkjiFWOIODc7t81dAcXQbGA0uM4thQ0YY/6uFmsdlgnjktc7EIguisOUR7Ek+12
         0wdchxkuTTRjZcOhatmdBjn3jI42yabueQi1wUya8plmjmgb0vn7ye0vOC6LmlFHrgyY
         2bywteK5oM8pCp6wbF+s56LsvoYpZBnJVTSeP1hjVkAL7DtzTb52iC9I4ywpTWoFIH7t
         luKqnzT4VxK0jz0Kf3qrE2tfPqPmFjnNxFnmRwpDfcs89gLQbGJpT5YDZGtUY9pKtYwL
         eM696FKtagtW1nRgbJpfTYNNKmuJb90NquJQ+1TuW31D3JFJyMHW9WBv2WZQWqliDgLR
         0uRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y8B4/ecGO2Mq14LjwKIDLibLrauS6XdTr/m0chUgNdg=;
        fh=niUnwlO3D5Ku8zcuzYwsVBe6JTDSARatZJf5xsVq1HY=;
        b=dLFuNcz1IlO4qmrDMc73+o3/988iYfWnooxQc20QMJjxwYGJXhyebGtRzXb/ES9UEu
         g9KmuQNNnQeXRpF8wiyWkoB8z2AWBfi0XBO8PadPW9H8NyZBFFeEFc2Xe4HGtsPQt2YF
         H4WIYDw1qoG8HyziQO6n43owOyqTBufbocqtGpEnj80mgKcBCPEOWfM76QvyvMpepvgh
         DZ2RCqo4E4HiqjCsyao1Y4KKDuNILafc6VnZfrHsp5oFV8z/2WXA0HSOiwDmbWTEcSet
         hUwRyDKP4RxgfeGY3WcNA7Yr0+b645o57UW6o3K3d67H6yZXVPAWA16hAIElxN+c0m+d
         voVA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785984664; x=1786589464; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y8B4/ecGO2Mq14LjwKIDLibLrauS6XdTr/m0chUgNdg=;
        b=aXt4JD+xkISItFwL8PtHvCgIchKXr92Vx+H7sXpFkv9t/ZTGJSXEAQaG6U6EDZv5lh
         Cw0o91TNcyGVWj5iQOknHdzHkGdoCuG1QXZfxuKZa4G9CBLVfr7iE7H7eoCIQx2YrW0I
         k8+fOtCfwDtBUnu7oow2V6yLM2ahMLovFb0uTV7yeZHerS98Jt72VUHt5XZk/UnxHYht
         /+/VNw5HtUswUlAYQXljjxO5KVxaw0531m2wNRKsaoMv7ke/xIMWHANf3mIRpurif7s1
         hM52rErFvbwC0aGhZykmHjcACj0eSmcwLM3euivOKw+cgiqYyQDVjCpnZQFLqd1gCwWi
         JR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785984664; x=1786589464;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y8B4/ecGO2Mq14LjwKIDLibLrauS6XdTr/m0chUgNdg=;
        b=EP9rcfeAcMMJmAGSdutgs6pFA0Si4LyvJ5HEkQw4rrRCMXmlKdqwU/i/L+t/eHULS/
         qackbN8BInXcsn/A0a3vVK6UVe+P7P459PwM4IQeVIWOYhV5s77l75ja60rcIBELUyeQ
         PR/J7MrwCd65ka3Jo5icv0r+VctMnt/kfoAWq3qGXWnZcoDmV5IhkCvfkdyUZ1nLpAxU
         ZQ8WUtFihjlRE54kmei43FfnHch6NGWKGqBVce3duW+DIg4u5WMw3NjnvSJ7FJL7pqQG
         xugnA/BlqfSo/AXvIhnF8Ow/Q4T/+P/FNz3hk6u+iXVuxaNpZkB6lj29aF4AfTa0RM8S
         USaA==
X-Forwarded-Encrypted: i=1; AHgh+RrzhbkXoTKfogEYA26kxw3o4Wu6Up0a/gCKM/SNMl5zzjgT8ns2+v54kkOOHEfzlwxjgiR8o3AMjT0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywy1wKbHQDbzbNnl7CGNr1QrudPokw4Sbh02o+FLjn9rW6IdeWG
	fXZ1H5RLyCvgBvPydDQYFYBJ60zU83Q8BrwXSDSVhgarXGY2RB9n0LA4UMhsYnm36lEBg51TySn
	s7JOFcPMXHG8dOE9aCdIHuootjdbszxU=
X-Gm-Gg: AR+sD10GncqjHTrtw4UVEkbV2pYQew76U/f/rTIFu+Czcd/LgLHtXWmU9CovX5sQy09
	Y6iW9AlGLzXUe2lE5573Va+hZQCv/3lixQF3HFYERbALfu/5WMMV88lHymMrLjVKbV44XTQ0hsa
	XtcghlkNGXwFAbzo6S7GwkTKoVJU5YMtFBWKOU0djZjLkgWhlZsdGS4ZxeJyAn8IUPTRa/ZT3rH
	69kgIfheKS6HP2aZBZNDvDzCoJUMYT3N6iUYXjWjd42JJdqLe40TxJsxD5yb6Pr3sdl6KMwccxC
	+V8JWR8H/bPsC3aVb3QS+UN+8+74GJGW72/gByWf4ncX0QBjsZTM36T1Sf5MQfiTPY+Vn9s784j
	rkg==
X-Received: by 2002:a05:622a:2307:b0:517:7e26:36a4 with SMTP id
 d75a77b69052e-52ce61df7dfmr124407901cf.34.1785984663704; Wed, 05 Aug 2026
 19:51:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-8-6b97c439eb28@gmail.com> <39200a6f-8241-4033-ba7a-5c9bbbdc8ff1@redhat.com>
In-Reply-To: <39200a6f-8241-4033-ba7a-5c9bbbdc8ff1@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 5 Aug 2026 19:50:52 -0700
X-Gm-Features: AUfX_mwdgfZNtUVKN2fr62b4CYdJBKHGSJqFmOuYnQn3J4JowOt9nqgKAcaQl7Q
Message-ID: <CA+spn3p-Fc_uLO1bwSXC39kmQ-iR-OpB-a6cjMTphb-_Ant-_w@mail.gmail.com>
Subject: Re: [PATCH RFC 08/15] hw/virtio/vhost-shadow-virtqueue: used handler
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
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

On Fri, Jul 24, 2026 at 4:29=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
>
> The error of the handler that may have left elem stale is ignored here.
>
> Regards,
> Akihiko Odaki

I have now added in a check that returns on error without setting the guest
notifier.  So essentially the call is ignored.  Maybe this could be expande=
d
on to handle errors more gracefully depending on the error code.

On Tue, Jul 28, 2026 at 8:06=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.co=
m> wrote:
>
> >
> > +/**
> > + * Callback to handle a used buffer
> > + *
> > + * @svq: Shadow virtqueue
> > + * @elem: Element placed in the queue by the device
> > + * @vq_callback_opaque: Used to pass arguments to callback
> > + *
> > + * Returns 0 if the vq is running as expected
>
> The doc comment should mention what non-0 look like. Are errors reported
> as a negative errno?
>

Yes, a negative errno is expected on failure.  I have added clarification t=
o the
comment.

On Mon, Aug 3, 2026 at 5:42=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 24.07.26 00:30, Connor Kite wrote:
> > Adds a handler callback to shadow virtqueues in order to enable
> > non-default processing of used vring elements from the device.
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >   hw/virtio/vhost-shadow-virtqueue.c |  4 ++++
> >   hw/virtio/vhost-shadow-virtqueue.h | 14 ++++++++++++++
> >   2 files changed, 18 insertions(+)
>
> The avail handler replaces `vhost_svq_add_element()`. I find it a bit
> unintuitive that this handler does not replace `virtqueue_fill()`, i.e.
> that it is not a =E2=80=9Cmirror=E2=80=9D of the avail handler; that the =
avail handler
> actually handles avail elements, whereas the used handler is =E2=80=9Cjus=
t=E2=80=9D a
> callback on each used element. Was that intentional? (If so, I think the
> comment should be explicit about this choice.)
>
> Hanna
>

I implemented it as a more narrowly-focused callback since virtqueue_fill
needs to be called regardless.  If I instead called virtqueue_fill
from the handler,
I would need to pass in the elem index and length via svq->ops_opaque,
which is a bit awkward as vhost_user defines ops_opaque when registering
the callback.  That's certainly not impossible to do, but this way felt cle=
aner.
For now, I will add a comment explaining that the callback should not be us=
ed
to add elements to the underlying vq's used ring.
