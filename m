Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF38274B39
	for <virtio-fs@lists.linux.dev>; Sat, 25 Jul 2026 00:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784938563; cv=none; b=j+YD915vLPTlGdaoAZBIzd4k1UJI1r3dXgcMrS9l6xJ0SotZ/Nj8D3AIaK331Si0C4D/YZ4xxI5T84VlHzAwv0IBlYI3LU7H8rgZ5Rj97BPQPvXMwE0CIr62rT4WOb5gQyiwwPYDhdjV2e93do3eRekoHrJegDDFhOjbkTkcuFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784938563; c=relaxed/simple;
	bh=dc7TB88WjzGf5NN+k/kRTrrb8nvregG2BXCrThbRoYE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JqBdpLVTRTO0GBPW85zeDYKKUBdWGZpuhneEp7J2m+bXLCzabzz5ZB66r+RX2c7wxHdqGuR23KgJq9/yqG6Bn/8VpmhWmIdqwobtUZD33rESJaj66Z7CQJlmjcc/WbKH4Sg3zH9Sz0hjpBbnGCQTwQZVf8y781ylrU+/PXbCEOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WsGR7f7i; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsGR7f7i"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-81f3b227a4aso10313827b3.1
        for <virtio-fs@lists.linux.dev>; Fri, 24 Jul 2026 17:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784938560; x=1785543360; darn=lists.linux.dev;
        h=content-type:autocrypt:in-reply-to:content-language:references:cc
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HnkydtulEAp9ia4aZg6S81fqx+Zi4SJgLq6KxpbKfLo=;
        b=WsGR7f7irLNPuIDBK86NHsmDo5vlyCo003m9CxK86Ey4kUPC8DBikJvJaKmO36HY5n
         lww0uauk5xashywEqODzTosYPZ8/PPEwh+yRZ2YtFCT1uLi+qeen6jOKsAY8ECQ/OZLb
         qcYlYWhazVEH6sYKVFeZrSbzirFZ9eLCl3X+gm3MHk27YlJlUpNK8fdTg+PEtUnw8NHY
         TcNWBg8FyIVlLsVNO6AkMwWcwd3zFZup4FUghwDESacsy4mQFvKWPdRZZ3wBeTMtgjuO
         6fVecObdo8GE7AeA0b7yI2SE96j+8sv1UCDjrxq1yqe7UugssMEoBsJG1c2/C6mz0CSD
         CbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784938560; x=1785543360;
        h=content-type:autocrypt:in-reply-to:content-language:references:cc
         :to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HnkydtulEAp9ia4aZg6S81fqx+Zi4SJgLq6KxpbKfLo=;
        b=m9/uUH3iNTdMmybXvDOzhjhlzbZ0GofyU2ITV+qrocicxjh3J30D5xOTjM+vtbYEuH
         g5HMMwdOGhVGKaWMvBWMYda09zGDhXVcaWsJlHVpOU5kAYx0W7AXdGzmCeObDDPlln+S
         jEmJzpo920w9Raw5bWDcTORJArjue7yxWa42Ei0UaCJbfh/8gJLKXb7/3FJf4ELvyz7c
         TxGpR8cvrvnsjSx6dRL3DrWZodYAMEiC+bO24TZvKHz0ggLOOqBnlQ2c8uThuF8mr9sp
         M5bxCFx5yMyOuIfgcfy7u6f28pDdCo++WNKJ5MInYuO6XedNYuVGGmvpQxy2jqCp9zq2
         bL3A==
X-Forwarded-Encrypted: i=1; AHgh+RoYQThmUGbweOnr5gNBkH8ZtIVFE09Wb0FKrW25C18bc/3ut2qa0Jjqu77BF56aEOD8wG3sjKJycGc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxwsQN6RB3arq1+sqaZP1iIUmpbcoK8gRYrXGxvcXILAX2BHPpo
	DmI23uBhPEQvBSoGer4mPlLFrZfT3DWhrcvSZi343Br1ZwdHFAEmwGv9
X-Gm-Gg: AR+sD11EKSlgkXL0FAA7HlhaQ/d7Bf7rZ9gzpE3lspvzAsBskI9/M0o/d5pWBNy9RFF
	HXeU4jPNu+/R7Np2vyI+VbnKh+833zFfLzhS+sMhGmAgLsF4YLm3UEXIkfgFtXaBsY5SYHIYnOZ
	Mp6fTJI6zvx2ekC3eTRu/34vaulrYqWvWAY8aRHzeP7sDBhM51AdQZitoH0N6b4N9/r5OFFK7zM
	x6Uc1uMfVjLg2El4T9IQoQBrFk4WKlvw7PT9Z6iz9vQPGNKHluKtiXjHehFgCgqDMj1zNHOJKyX
	OMTvg3ujOcWaWNZKcU8r+M60CObEPAhwMwaV7qSahiNEvl3izc9BS2PpMP3YQE9S/UIT2pTb5zK
	uc6J1/6FAZ1sNF0u4u0hwW+QwYMdRBIVqgnHs+HScIMg5q5YYun/naHhcqq7dAjKw+lQclv8/gS
	bsceLH
X-Received: by 2002:a05:690c:6a86:b0:81e:7b95:c777 with SMTP id 00721157ae682-81f69dea973mr2491717b3.35.1784938560525;
        Fri, 24 Jul 2026 17:16:00 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f657a2d56sm6978687b3.14.2026.07.24.17.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 17:15:58 -0700 (PDT)
Message-ID: <b0ad1083-372b-4440-abfc-dd2ff8b51ede@gmail.com>
Date: Fri, 24 Jul 2026 20:15:51 -0400
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 00/15] vhost-user: isolated memory
To: ConKite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Content-Language: en-US
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------QO0gevjSZi4nSb4i04j50d10"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------QO0gevjSZi4nSb4i04j50d10
Content-Type: multipart/mixed; boundary="------------4M1ZxfF0mO0jpR8FOg9JRcIn";
 protected-headers="v1"; hp="clear"
Message-ID: <b0ad1083-372b-4440-abfc-dd2ff8b51ede@gmail.com>
Date: Fri, 24 Jul 2026 20:15:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: [PATCH RFC 00/15] vhost-user: isolated memory
To: ConKite <connorkite@gmail.com>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>,
 Mathieu Poirier <mathieu.poirier@linaro.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>,
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org,
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>,
 zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?=
 <berrange@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alyssa Ross <hi@alyssa.is>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Content-Language: en-US
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT

--------------4M1ZxfF0mO0jpR8FOg9JRcIn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/23/26 18:29, ConKite wrote:
> This patch series implements a memory isolation mode in vhost-user. The=

> purpose of this mode is to provide the option of additional security by=

> eliminating direct access of guest memory by vhost-user devices.
> At a high level this works by:
>=20
> 1. Adding qdev and qapi properties required to enable isolation mode fo=
r
>    various devices.
> 2. Allocating an isolation memory region in an anonymous file and mappi=
ng it
>    to host memory.  This isolation region will hold the bounce buffers =
and
>    vrings necessary to move data.
> 3. Using a vhost-iova-tree to allocate and track the mapping between
>    guest regions and their corresponding bounce buffers in the isolatio=
n
>    memory.
> 4. Creating shadow virtqueues to intercept request notifications.  As
>    kick and call events are received by an svq, it copies buffer
>    contents and descriptors between isolation and guest memory before
>    notifying the backend or guest.  =20
>=20
> Note: This project is currently in a partially functional state. For
> example, in testing vhost-user-input and a keyboard, keystrokes may
> register correctly or be double counted depending on the combination
> of backend daemon and guest OS used. However, the desire is to make
> this work public at this stage for comment on the overall
> approach.

Thank you so much for the work!  I'm very excited about it.

I do have a few questions:

1. Is this dependent on the specific vhost-user device type?  In other
   words, does this code need to be specific to vhost-user-blk/net/etc
   devices?

2. What kind of performance penalty is there for isolation?  The use
   of shadow virtqueues seems relatively complex.

3. Does it make sense to have device-type-specific code to validate
   data sent back by the server?  This could protect drivers that
   trust virtio devices.=20
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)


--------------4M1ZxfF0mO0jpR8FOg9JRcIn--

--------------QO0gevjSZi4nSb4i04j50d10
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpkADgACgkQszaHOrMp
8lPfBg/+Kf7ty+9TeveppA/nsZtuUXa0efXsct2J1f0nM5fJIgjD8k4b9YNPOny2
6pP7vuBJcGtv3OH9oKfR5bXJpa9ceGK61wiTcDeZbh++DYlw8YZI9FzkVa6sDO6f
yekRqZinDnU3vFkG3RAF1eE3hWpIhARI6IBEDo6EmOjpD1utxXUkWpbJtS5cWgPr
Xo1znWq/tg/r2OxO5AjARF/s1LxpGtuZeV2qXV8mTi3vzlcsuz8KzDpKq8tbtzE6
eSpCREwIj/dJYbXsQ9A6cp41/XCvYnHvMb7fhZxL7wxR9MUcobLYRBVpNs18uHOs
tgUqCDiY+hxnVdXKyZP1y2vA1Nywb82qmBxaxSNJf8+dnX58Ziyb9VKMr8t8Q8kS
6ykc6eBF5cl2erNiJB9wvO4Td9yuJh6e6LyxRNlwGmkdpuHYhoknONV0d0ZqO2MF
XxDWcOqcYnCu7ySTGDT5gOvysH3kOX6S5jr2uUZJxrJOaTdUPPx+3X2KgR8gHu83
1Hy95OiUNwIJNSQBaS/THqFWUEEm/scJkKhuKmPVoYNq2rllGlLbCcD/TS/Iu7c/
QJsgRj+UAurWuJ3IQLqGosh4N/ysFur9jf979fbzVGbNlo1JEqq7anlSg2kYHPuy
4VQMwVBKp0MLVs4f4Nz2c8Su9LtqLEvmEac5z92xV4vi2zNbLFI=
=iiNx
-----END PGP SIGNATURE-----

--------------QO0gevjSZi4nSb4i04j50d10--
