Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD072EBB8D
	for <virtio-fs@lists.linux.dev>; Sat,  8 Aug 2026 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786168367; cv=pass; b=RtB11EuHscupUhc4TOr96da6yNvQAwPLlF/ifP59TC+VDuJYieE05vPZFa4zW/WKmnR5XQYiGnly6WOQx7c/vFAwrfaxbekorzmMlIl5ESEE2gS13aAOysIqDvZwUQtuP35IIGnEIz4zOBAun3hGkmzZOqk02u2MJniOtcAecvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786168367; c=relaxed/simple;
	bh=1SBwwcNhgHr0pAv+l6XkEVP+vIBzgfNcqQaQ5Cpnqws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hx8yYrD9nCkpwZTL4fD3rUSdK7JO9EBxskFlcyomFm18guLPKz4cXApFiDXJpKKx+e6eYRYsy9CUoNv0HLp75D0yp+FJun3KGzOGFjbPhhxB3MxAc66s7ajuG0dcEHvkyBzr7Z1HKIU2rpTm1jDqFreqRzSZwnkyDpnFzwUpnpA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VUeV1HQJ; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VUeV1HQJ"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c2a76536bso2573381cf.1
        for <virtio-fs@lists.linux.dev>; Fri, 07 Aug 2026 22:52:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786168365; cv=none;
        d=google.com; s=arc-20260327;
        b=jfGETd+25nH3OImEptafIxIsrZh2K9NPLtzewxMFTtkIA0vUXMsuaLujOf7vCaZZbX
         tju/2od6uEwJbY69TmEeN777fkJVILF+Nmh9CTev4GKsUbLr0aHVvuus6lECIMZjEQ2b
         g0MtFb/tFJyO+GobBowZ0VJudwCviNcGPI+LrtnytDzJC6opMS9PmF+i+gOVyGlMOopL
         CrwEzh+klvjR6zzD76PtnmT8/QSwg5v4y08QFVM+zAR/op5fjtfs4baXdnD1I6fvd1Ti
         pIViWDDnekt/pwZb3V8eWIqUpdik3WDz1fAw/K1tWtwyROSVAMDoX1lY61gz/MRJS71F
         NgAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f73IJPUp6q0Wp68Ac+cralPtDGHihzN4LDNZXFWNQE4=;
        fh=sJ5HprJiZHfSgWys6v3+IMGey5XZtGlfj6/ty5s3h/4=;
        b=nuxYev5IiyOH/fQJwb5c8b4j2yoj0Bsf4iTJErPHkkwVnOBrNi3EW6hnqgk8wdy6ho
         XNFg4ggLV4cfFeUzDeJ4zL63FI10pwqlif4xACvqjfzWKPI5saj4/cDZrOJ04LbDiR69
         uUqljHiVQCr9BzYgY/BHMKLejJc/tQNOvT/9Z/yH0CEPztmObZr31c/zKI8camK2FdQk
         3rgCc2uT4zLU5ujUjUp0LQfHjvmOmVb8BfbFeynY9r9kK/nMYmAfFZ1jbq3pw4vnV29Y
         tADYq+GZU4ZcTYfW8EvntzleeN7aZa5U4baJz8uBK3lKBH3mvXL3J68x5iGdnFssQm5g
         WwGg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786168365; x=1786773165; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f73IJPUp6q0Wp68Ac+cralPtDGHihzN4LDNZXFWNQE4=;
        b=VUeV1HQJCnZkoT9xiXXMRLEfugpw02omc9S3Ce6g8uumpE7e5mAvgbPwX/qkaXtUYx
         eNnoRdgujRlHNB6pWVKqsthDGrergiaQ6ckbvBc66rEzArGuA1+hu+YcDTKZ8IhKthFb
         HdLj7c+zoELZx/xKB9izLeMbgPByWxvzLNG/36QbpdyPQYX8/9mMLiu9eHzWD/u9Q4Z9
         aGxXTcQ5zfD/3h/NeYFH3LQT8lIHkDup/L1fubURvI6fCQMbR1ho7oqLSLcuG2r9fnrc
         FSV4ukzi8B7dpxATHlS9wBcUmPWFwz5dWWCs6kMBuTDMCsOfC+57wLHR6lbS2ePiF1k7
         6rHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786168365; x=1786773165;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f73IJPUp6q0Wp68Ac+cralPtDGHihzN4LDNZXFWNQE4=;
        b=YCO7mkATOE+Q8WMU3foG7AQQBHC+8VS/aqxS7MhtBKitBFg5xKR4WbBRrK7NffXVmM
         wVc6/pMUbyh92c68AJG4VzPOoSkI/8nytVX0JcfJwb2T0828Yq5pMJMzWs2s3Sbz1bKx
         aFabLNnVVGIITCZLnD27/6pZ+XC94gNRIxfu9A+xYXFahkxGmF/XymC1eI6b/CjQMJXa
         DKvY7/3P5HPhrRkRfeTzWfJXdPjpl8Um2m1XnS7TCp+v/M/7YdFsh+e4KgL/aPYGi8Pj
         DdELOOXCyzUaeKU6YwuAQlZ28ln95yNk/TLqv94UW7N2PBy7M8hk2iNwpkm8Y9l7XEaE
         SjdQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXEomJw3IgN/wENsCf8kILTEn+E0GmigL4cdd9kmurvya9CPKpxY49+M8vh0v51xXE62sJpt10LVA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxcuduEqqSazqNELiL/DuS9RgzNKN4P+IuYB4U6Uvrialt7r15A
	gr7+1cs6uYf2eIOH3A6kkBZGYhgPDQNyeatblfRun8LBA7pbDkR8+kwhOeN4q6Xn3I1CqI0DOKV
	j+2bxGpLiRxiS3BJ1nim+l0lf7GfBNSo=
X-Gm-Gg: AR+sD1055Fb4TDxI9C9kSGDoQdsjQCkFBG7n5F1Xd2Wi4Dby2RJsXsZWQ2PI4pa86bz
	MUxz+DvDcXm/cqfZ0Vi7R25IYBLHBkEGtTj7yCxwgw4aIpiB1TbEt2+LxZBfdKq0BvLboWXtlyS
	vWw4pRQ15LPwAishNRzvlKDfUI7cuYwf0xpW0rZCeRQppRxgoQx0xbp+JqLpfMHbLeYqgEB+X6E
	NQnMVqKk4e00n417X2C3CTTazgkts47DJ+wwBcQSDDvxbypsAL0ZYowf9aaG52yjtb8tWlPoEPE
	HRVyLQCVIjbhspHvWHT3ID8qOPZhO0r8zre8Rpr5bXhv4SljTK6i4U9N8tHveh87QgmTYPOTKDL
	uhgM=
X-Received: by 2002:ac8:7c4f:0:b0:51c:1132:c7f7 with SMTP id
 d75a77b69052e-52d20a3212bmr73283081cf.29.1786168364959; Fri, 07 Aug 2026
 22:52:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-10-6b97c439eb28@gmail.com> <ba6158dd-7b7b-4457-9256-497ab60a27d3@redhat.com>
In-Reply-To: <ba6158dd-7b7b-4457-9256-497ab60a27d3@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Fri, 7 Aug 2026 22:52:33 -0700
X-Gm-Features: AUfX_mz29_PGUItMUHiK2fhIF6i4er8uxAWBlXK1AVB5x0b6YqHJWCDPmzom6BY
Message-ID: <CA+spn3qP1xahLRTNutmOLvDEXJXHh9W1tMeGeKiiDiz-ntyknw@mail.gmail.com>
Subject: Re: [PATCH RFC 10/15] hw/virtio/vhost-shadow-virtqueue: range
 boundary in translation
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

On Mon, Aug 3, 2026 at 5:56=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
>
> It=E2=80=99s not immediately obvious what is ensuring that `iov_len` can =
never
> be 0. Sure, it would be wrong and makes no sense, but that is why I
> think an `assert(iovec[i].iov_len > 0)` would be appropriate.
>
> (Looks like `virtqueue_map_desc()` is what rejects zero length, but that
> is not really local to this code path, so not immediately obvious.)
>
> Hanna
>

From the QEMU Coding Style guidelines on error-handling it looks like
errors that
could be initiated by a malfunctioning guest should not cause Qemu to
exit. Would it be
more appropriate to return false when zero-length is detected?  That follow=
s
the existing error path returning up to vhost_handle_guest_kick, which
renders the svq
unresponsive to future kicks.

Best,
Connor
