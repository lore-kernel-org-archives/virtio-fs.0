Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795518852;
	b=ax94AYLdzduQ1d5NvbrK8FPbcQO+nZKcDUdvLdDNQWdSTjmTff05IoPC/FxIhEuS+Zzj
	 CTdQ1tzmH41AdD7K0R32t8ShCCLA+BmXYwcjtGwuuRJZk1YBXpfeyWgK5U4o5aqGsG6he
	 hVWjco/zux5uls8kQzaPw6UFU9febcamsxWQk5lZg23dMRuOyqSUipKglz9jY1Xdu1lsv
	 tUX2zln8viwsXhGjgIRQc8pib+v1as+VyD3JMHDdPnLVKWFUMvAU4huahPz0xdj461CV+
	 a2FiH/KQC4OAZEYTF5IfvsfV1nRiCnPuxd4QnGcw3A4aCC9qbHCJhX85yq3uH5/JxTA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518852;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=YxcSWKYnItj3yo5FCFqsfm26g9ItY5gHtNPYg7zw1LA=;
	b=lgynoWios2A9zdFUbhkbeCPQatekpfW2I0mx9IuKyjYD3zhoNYinZ74jHxf3EF+kn5dB
	 QDShSjWKLsbUrKkuBMAKjTiDx9AdU6DGfkW091V6A6AHxRL2nu7x6bZcTAw839wyi1zIn
	 PYqpqM6xuySxZYhC4Xwhct9aU+orIiHiaKFEBWPSKaUKEnhhlT3uZuG7i8QtOiNU2QOWP
	 JHbathzhu6VEyG3mDwSJzaslT0BSuNtwRm1Ztg+w5brRIzgUXEQvWCQwkTl+j/Uuv3yp0
	 zoHZQZIYdNzOYEdds28bUosmlyXBY56TqWm9zLvcWRHpWPItTqkrZ8YR9AgkdjZTOcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=szeredi.hu;
	spf=pass smtp.mailfrom=szeredi.hu;
	dkim=pass header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=GMzzcfBv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.179
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA81606A33E
	for <virtio-fs@lists.linux.dev>; Tue, 24 Nov 2026 11:14:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AA81606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.a=rsa-sha256 header.s=google header.b=GMzzcfBv
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-9497a167a6aso648557385a.1
        for <virtio-fs@lists.linux.dev>; Tue, 24 Nov 2026 03:14:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795518851; cv=none;
        d=google.com; s=arc-20260327;
        b=nxq6SPLpkpwJzQMoHa6xyf+0ag2CK2cg6TunaV/lTfoP+NWS8CuaPN0UEX/yIz5CFo
         ZWL26b+vUMceKKlpI5CbQ02pBeXxySKYyDKXkahu93T5v6eH48WvZxdPK+baUR0blu7Y
         XF5Oe9Ojq0i/ZyvBXj1fasgqydDpcwceVbF7cVNzPZ6kYD2IyNpdU/njH7vxvRwvc/H9
         ndd5MaJcm0NMp7K8FyO44RHuSou+V9cKgOhNcg7ZjkdQQj1f9gUySRIV7CHvGZ/C2l2P
         Rxym4NMhFCSJyki3wVfEloGT+bU0IKFvy/vkqeF/JaT+E43l27XzvxwOuvx4VNwRNO3u
         FEdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=YxcSWKYnItj3yo5FCFqsfm26g9ItY5gHtNPYg7zw1LA=;
        fh=DocpvWJh0SnNEGhMjTGzp3nuDJEzVzqMqhNfMIBZV3U=;
        b=MtKNVm2DGlywFEkooX6Ao0u+RHF0PbVrn2z7GwzA4p+lQcFz2BXNnJuDFX89XSpl/L
         MHohzn0CPBu0zeHYE0HHYCmO00mvBxkxIJaE+20/C2EpNnXEhbAm/QKTiW3NxuW9Rau2
         s6+ULzPiIePT/zOucnQkx5uHrOJ+6SF2x+H7uF+vjg8HGYw2MaNTPRfsYccCALn2h2fj
         8S6E+84MocU3v6qMPRhZrMBD7gdnuHyM2iIOBrqau+OQJlhj2YjocoaThHvHK8FBzgK0
         m4bCpB/NW5G5UBKm9yRaFUMDYrPpl8PVuIJB1DkeTlx80lgUjx8Y8fX9zRfgcbzHBBRM
         s77A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1795518851; x=1796123651; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YxcSWKYnItj3yo5FCFqsfm26g9ItY5gHtNPYg7zw1LA=;
        b=GMzzcfBvw+aONBCpWkjfANJ6eTt7SCTdxcTNrqAbFsQlXUww+E75+oNRQxShLUNA/3
         LihFRUw40zgScK/aVX9Ex3KN8pBKx+Htdt0R6r6WhHeHSAEgvOsZP79+JNtSiVABjTL2
         tgwMkgP+cx/csM/Y5yW24w498WmHXnLlB7J5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518851; x=1796123651;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=YxcSWKYnItj3yo5FCFqsfm26g9ItY5gHtNPYg7zw1LA=;
        b=E+/HeVIZR8sp3TfAGdWigQkYTgU+vFoef3IMGK4xGEP8iVupCQN/R7O3seKOWXfWgv
         hl1HeZIxHOEtHy2tMRkqJo4NI1TEDwge99LHTW/nXeB2mDaPkqsbmK1VtUjc6s4M49hv
         NH10qQ8GKCUl67iu+cGpyuWw6pPUL0XfloAQWQkkM8UEEbTbFe0SolCo9t5YYxeTS4Xw
         ql4RcEmGyNgmCyUS5W37EOY8yzMewmgSuX2IMKcl8Dx+tt8KfugTigdJm8C2rIYo0oJK
         eqwghngb4wkeFE/J4QuzzZkijWBwmJFczQv45Emv5nLnEQB5jmiy1zjoaRIBCgm1KkIG
         cy5Q==
X-Forwarded-Encrypted: i=1; AL+hErFCLPPMGD65fZZijXs5h4Fo2R2+pA3J39FyliYTm/JxxYvOd7mGRJUowrdRDzT0JMt1Y8UP3+I+DpQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z+DKuasuaFodmpuok3+esZqOK23VLVVGvdyZJ5IYGlgv29783O/
	j6m/5YLBax31CowE4IJ/RAFiE4ftkhCrDo9+Degs9BgHq6icpYhn+PVjr3IP4lgLqXB8Y18woeD
	oMMbQPCT/2HO1b2wtgJGHeXpBCkCA6rlSfL1N6bAJwQ==
X-Gm-Gg: AZFdTZdogBKTJkxuc0V9H5qFrOiwZ3UqoPbTZkc7rCjGSkGvFkUzzrWgGXrQlX1WwWY
	q6upGCSdnhysf/YseOpOWcyArm/bEUe4RmC9FsAK8HEhbQft+JdpQkaBuAzF8K7tirj/tUFn13w
	9Qv2SsHKZNlHypj0rq2Ql9e3jk+PGXhSbVFpsam7TSzqVBLzoRjqVysayQJw/oowyDFuoT7SPJd
	/VcBtHHWG0ppt0iXZtzjwReDNtGFZhGRdtAESRCLXLFUnFq0ORBrC2K3/xcME/Tby8HlUznMNip
	mBTqTB7JNi2KuvkU847yRhcqBW5h7vJF9PPumUGQPjqXMz4ZOVmG6+f1P7gBiDIMI3BQ+7y7PV6
	7kI15DRFAJo2Qv3RqGAyWh7wy5dMjBYDmw9G/c1WvQPM2uYpEg38uoC4Zg2sY411bBg==
X-Received: by 2002:a05:620a:199a:b0:949:aceb:b77f with SMTP id
 af79cd13be357-949b36034edmr2558799785a.30.1795518851115; Tue, 24 Nov 2026
 03:14:11 -0800 (PST)
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261123095455.88622-1-liwang@kylinos.cn>
In-Reply-To: <20261123095455.88622-1-liwang@kylinos.cn>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 24 Nov 2026 12:13:59 +0100
X-Gm-Features: Aa3M54pbj8-6gfE1d-Xj-d2hBGWMonaIctmbDSe8aODDQN2gLU60G5Esc5wLwmc
Message-ID: <CAJfpeguSMMaBuELCVtUpEvCZZCRZK-xvs_TMMD8r_KuuzzQoaQ@mail.gmail.com>
Subject: Re: [PATCH] virtiofs: fix potential unmount or device removal hang
 due to stuck FORGETs
To: Li Wang <liwang@kylinos.cn>
Cc: German Maglione <gmaglione@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"Michael S . Tsirkin" <mst@redhat.com>, fuse-devel@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, virtio-fs@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 23 Nov 2026 at 10:55, Li Wang <liwang@kylinos.cn> wrote:

> After the FORGET is dropped, return 0 so this same worker invocation
> continues with the rest of queued_reqs.  A full queue still returns 1.

Applied, thanks.

Miklos
