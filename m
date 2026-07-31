Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B332E7384
	for <virtio-fs@lists.linux.dev>; Fri, 31 Jul 2026 00:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785459125; cv=pass; b=TLGy4yZ+IH5vTjZ1srs7f4uhKlmf4VKnd+5/KPErzjy9hjOL9Ohbzlk0hF1yKB+8M7tkE9dMHQLaqf41EfCmw/eLHWp/ceo3fD2BqaBHz651wEPgigjqbStOH2NCx2aMhWL+skTjjp9wClvkP1BJjNocThJgmYTN7zKYSatASmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785459125; c=relaxed/simple;
	bh=OCufJAKP0o8ko4L+o+cbyDbnsK8ugHfbZWTCLS/3Jag=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gtzITl9f4S7avWvrPmsaDgOdnnPC6kxa8in6Q7xmzfIg+CyO/OYl0Ie1v4BiW4jvL77GHQkQRvyM1ZWGvVOAgabf5gQ07HudXPdmll4ipeF4XvwFaoor19S9QOgg4dAW2skteA41kkQYfKGM+BYdrnQ+qEMDJ+b3beWTVs2zBMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YDLrLFmL; arc=pass smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDLrLFmL"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-934956bee57so9471685a.2
        for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 17:52:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785459123; cv=none;
        d=google.com; s=arc-20260327;
        b=SiptyT/ZomVgd9pUUzCxgWL6j9c6uOwwlvLtOqW1rjKeVZqI6mAtNVwt/cib59OjFa
         Vs/P5g1rRd07/Jz1HV0KgJireSEHlCwj1pTdG5YEK7nEwu+sagQ8bPyfo2MF74HC1R/E
         +S85wZ24IKbUBwBjqNy10ynUOkPqKH5xsIJgigC2mzVTraKoFjMkPa844RTq/mCFOk/x
         Sb990zMjVlzimTQjOa/2QhS5i1sxhfd/mR7koGZ8DqbzOx3hP2jdngxlwENDK+u8lsbA
         LMth64yxj3fRJwk/cFyp92uP9gvtNrffNATYgJtRn6gs2YGGrS3LtPmmnN3b0pauP+lF
         r9pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vjMP6aJWfSUMo3nRh7FU/rwRMj+UFQIPHjMaWbFWddk=;
        fh=bEQBthINHbLnSi5c2TViuKWgKyuYW0JEyS8Qhbzcs+Y=;
        b=YjjoilNQT3Mm/2obBa0S5870W5YCYQ7lfwJnecGm/tP2IXOlxcpy94CfEUdFVnyuAV
         28rfxFqr5eWK2JRJhNJyR2icmRNYD7+uR0AKfsfya+5t5J1PNjqExDxXTccoJBEMi5Sj
         N+KE1hr5GWX5vW5MICDOycPBXR+r78f3bNyA0OeZ87GLlNxfIUZz6G2rXSD2Zj2xJc+i
         N7LS7qXmLeLTU6zJ0OyntWQnPsE6+f2x9fIaPDD2Q8P+pqGfA7j1FBWSxoclP2v0l+Od
         SbTnd//R1vUcqx39UZamlfuDiIBj3KdF3pTmCooeMC7ybzdCNrC+2bRE7U+XrtdRWpmd
         z7hA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785459123; x=1786063923; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vjMP6aJWfSUMo3nRh7FU/rwRMj+UFQIPHjMaWbFWddk=;
        b=YDLrLFmLeFkUigagLl92GJTG1Ai9FeMhB47OPF99Lvi3kLmfT1Y7q1JGm5B7Vb/2os
         bcBV3eKijth0cTwmD3L3FCDwETDOAAR9LkgI6DZhzaQ7iWieGercuw3oFcYPnu+0v8UB
         T5FugAK7o0SjHHnAVwlwopq/I4EhB1H6YaytcH73F7Ysw3Wq9NxhBiFAE493U70xZYDW
         muQyb2V3vg6RxM7ZtoJakmsEeuQUXj/DgxlO6n23YX5HRzsgEvmuM8K43zA3czjAVPlO
         FrFkg1TSYW06Vgzo42CRIJkGP4pk8XMGattq4QEnsoyYjtTPfmjyqUiBxur0agkq7aR6
         XIKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785459123; x=1786063923;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vjMP6aJWfSUMo3nRh7FU/rwRMj+UFQIPHjMaWbFWddk=;
        b=qB58S/1BP3jytHo3SK0voL+TUD8tmPD6QZVZPI3XzKmXqnpnLbjmRsnFSPsRxGtOsB
         u14j8W41El6Ae3zNteHYnzmV5N4P43JhePywmBZ1s9aql+FZLgx4I9Q/QnReZPYAfHGv
         XXJqkhxQRtXDmZjc+PK0XxROZ26K76VOfHuZhmEUBwE5WGPbnHThkK0xUrHl0fgoDYcI
         OB9etzrUt0O52zIDfgdfZBsmek8i2tSh9YjaGkjEZiFtKXfnZaLjwxRKTZIh+oEc+Huu
         +jnLSItyoV1DQ7+2p2jCG4CzVCgbyGH3l9PVWc2TTqpUU994c65f/stsJNmD7oVWIdkf
         oekg==
X-Forwarded-Encrypted: i=1; AHgh+RroahkZiDfW0Owp7XEyhvqFmO8GjacGiKvFnBEaIf2NcwiRjE+a2IDh1ymF3Wfpc26f3y2sQqPzZqk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyPgstri5PBbmXPWPDFfAvfozgvDDOz9aYp6awOmQ0OuQ4GMYSt
	E0IhzX4Wd2A5hoYdXr9Yg/J8j+ZxI7YW274KemQenREiGQbXfj6boXL/zift8n2ZdO2wVvojcF7
	qWzV1eXRmXh50Iu8DkIcSijvK+U5FO+U=
X-Gm-Gg: AR+sD13MWI0OHXRGZbNoKzeu7/OiF7iKvVIMr+ueMrttPghpKrgyXlHB5WDWs92ysqa
	lXTrZiY03MgSk7kbLM/Pr6Ur6KQyCGDYSbeptqPmTF3ENOIuVeFafBOoS7H/FSJV/o+YmITt35z
	oSU+WlY+07q3KOFi2JC/0X73DCZJaj75axrDm3hc6RRvO8rX8h6jUjBGOGv47/CieK5pnLMzEQP
	5iJit3QnbQ7YlQiFtucbeVWNDWOcKPXaLRcLNaUY/R84cL/YI9wckOfEgGIV7KcdyQ4xiaQyX8t
	/Uz0SP6Vhu2bf8wRwGwe6qOEomC2T3oGjnzqfhb4Ggx37KhyxnkhiHsbyvbmWM09UJnEB8V7WrE
	=
X-Received: by 2002:a05:620a:72cb:20b0:92d:54f4:dfd1 with SMTP id
 af79cd13be357-9349684cb9cmr10355085a.54.1785459122886; Thu, 30 Jul 2026
 17:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-7-6b97c439eb28@gmail.com> <8f37b789-fd3f-43ef-b15e-ffd44381306b@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <8f37b789-fd3f-43ef-b15e-ffd44381306b@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 30 Jul 2026 17:51:51 -0700
X-Gm-Features: AUfX_mz-tdw8KKJwuR6YxYh8n0iDqjLfDogIE8aFoWVKkljVevwfK-AQZ4XgUGc
Message-ID: <CA+spn3qp_Le_Eym7-j5v8sjdE0i3TXw137oUZrHAnKUuJonr+Q@mail.gmail.com>
Subject: Re: [PATCH RFC 07/15] hw/virtio: iova_tree_foreach wrapper
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

On Fri, Jul 24, 2026 at 4:15=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> GTraverseFunc stops traversal on true, but this says false ends traversal=
.
>

...

>
> Here is an extra blank line.
>
> Regards,
> Akihiko Odaki
>

Thanks!  I will fix both of these on the next rev.
