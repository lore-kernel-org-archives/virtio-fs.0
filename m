Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AD92941A
	for <virtio-fs@lists.linux.dev>; Wed,  5 Aug 2026 23:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785973568; cv=pass; b=hEicGe9aD8pfTY0pfW3+ILfrNls5TxRcWDOGOmhzCkMLmZEsuhfp0O+B2lJwKJvc2axRfjyNUKjj/Jr4ivzAIqT09nR68p3xPANoRm+0SdjTl94eYDAPjrWBVPVC2qknZqmULYLFpTdBtM5KYz0PW5YGScj0LUpzcc2a5vtdljI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785973568; c=relaxed/simple;
	bh=a+jbxXcZd6T761LCsOqRGhayNLoemufhjnBHkUePrL8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tFiw2CDBg8bkbjq0N85GY3ijLip6E9iTirTdd49+DbmiTF4IM6zIP/pJAu8lur/y0n758sbqmobPA3wnpd8Eq/tdzLP/x4d5ELeVakB51FRziTO+EbALeIbPV1+2wUMG1dWk5uchQmo3VJMAjXkhXIQKEVYHLOU/Q6feHdnwIjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DPjuyu3k; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPjuyu3k"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e57a753f9so128436685a.2
        for <virtio-fs@lists.linux.dev>; Wed, 05 Aug 2026 16:46:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785973566; cv=none;
        d=google.com; s=arc-20260327;
        b=kRXWKZbNSkAGoZV4+Eq3JYO3GyZRj23+3IA5hPArTdGK3nZsykM2EB8fa7FjAJ3Bwo
         Phi+paqombAAGF2JWwge2QxxHHvWXW899kEcyVf9ThZ6gfyg6h0J+bbP7SuRuN+trHK9
         Fkl3a2xoXqiRq901UwxqvfExiclJwdsnOElUONjNETOKCPoDSEmIHqOE+tDjkmmZTbBL
         Nu6jBMHq6E6G2qltnEuKBIsrSTD0KUdS41x2k5/iYiWbtJvNRkS3BP440ieEch5qd4Jk
         J1wKOd2meJ0znRkGFBGctaKcx/yW3biowCWkMfOG0Yi9LnKs/lho3AWfv4w69dsYWl/7
         EeKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBoUgyuLcxLRQy3pxTBFtiWOKZu+vFLM2ROsWki0jc8=;
        fh=1jTtQh8zIlkKl+MPJ19om0aWuUe2kd/7zaC08NaiX+k=;
        b=D+XeWzufzKA8O/dCgGcPMSccY8C9XXRsDwS7uLo15Z6QVO/WKw5GmxXsgXz+rn6/wl
         Q4Ee9aInpsNe08d6gLLfRMjS2z82cHvMBzxJvcIQyGRm5tb23foYhYrGzJwu02Yy7akr
         dh2gaaM1G6zNx4uv93wrz9mfx8jM+u8zx7TM+hb3+BNzEIUHTC1BaB+5j4zwQ+UHC4Mx
         kyBMOrW689TuqCg2rrrHFFZkmbEFc05Ohs4Z4HxSx19cwZSomqosIh2QISMAZqxYC8Sv
         YTIKkLjAUJORaloPTFE8h4JGp7M7bW1dClB2/20kBETV1t1py5tQ2XkuvOVWQTtyz6kh
         HCEg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785973566; x=1786578366; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bBoUgyuLcxLRQy3pxTBFtiWOKZu+vFLM2ROsWki0jc8=;
        b=DPjuyu3koDkLUCBzukpNHLUhrSYVO12cBP6PuU0otq/llEPXG2GksLMG0AX+HMhWjo
         GdACTdFFot8hREif8LF5z3DyiYOeLt2hU9GnKbkIQx/c3Vr0Tacu55dyT7w42wyyTRxY
         gBk+zkwhAyISkb+aKKYcyFOHTXoP0OCKgIqUVTqY2NMekM9gmX92bT0fiPuDz5HPFlbl
         ubcDh6VfHjV6oYB3mQPDi2fpNnTl93wxsQZnPbMVqA7hpI5dKmu8Xatx6JRrEWPOBXIT
         YM4MQH8bemYnn9LYVRhVe29lIX4TdMRMoI8wNMBoGV+GRD8Jg2RqHG5Q5Qcvk9RZhvdE
         EFMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785973566; x=1786578366;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bBoUgyuLcxLRQy3pxTBFtiWOKZu+vFLM2ROsWki0jc8=;
        b=ILXma1rNWIGHFT9uIOewK1swyy4/bVaupzILEN+5mNv7TQWJmxyC3yQo4wlG7Vh9ls
         9HYSU9/gU61p23ptBYovDCaoGGiuV+sviMND3fVvY0BMvRNhLZMUmXdZKgDj+j1WrTal
         ndLIaMQeSIaH+y4SOTFRRO/nJQg0ZueuVEqFFmZRjiuAUSLIBv8YIOkT/w2aOhsB/OEG
         WtXLkh1tFZRDq6Gb9JbvAlePlV+0C7xcKIuBN71gUspIRR+JqXgAxjr7y2JDr68rnPIA
         +5VHQR6HPvb9IE5OkEyAfYtqi/eycNnvvl5LZn74qLskRpZ6HR7VjuZxV+2HQBC/zsxC
         NmLA==
X-Forwarded-Encrypted: i=1; AHgh+RoWGEEN3KtJKkMkuYOkb9BFsXAKcs5qQEgUqhG0nmRzhPVZIm/CYtGL8O1fLyhKRdejMWEDzvilij4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQ4NJk2SAYYScsgVTQ/eSrdBDt4TWNO+3rdixDkO9+uS4dLjwa
	O5butx1owpTaFr3L7LXJki4wSkzqEcUm4aJALoZowTHN7X2PlK0/ndp1bwCJyILo/RzSJq6D1nf
	ELyGb+gQ4r41Nw4lhhcBFVQufizm6DXE=
X-Gm-Gg: AR+sD10up5wuPRIglbolikGrccBCJOpnIcGCfBr2P87DUpsHGHfUNnKNtGawZopbK5I
	2LVVUPHDu24xMlNd4Ib6r1TzD+SmRemGcJrjK44eMlE1fmQkQ8X6IgeATm4PI0iI8Q+L4LIc/8C
	ioLkAfKzFEwnZ+Ny0i69h1x1wRxoyLM7iicgoPrZ4kI6tAGLouYIXsYij0CTbM+4cb7Gp9pTGfg
	Wq+RkKNwTTCtgoIK9XrPkTEKflPj8LVr6VQMV3pSfHtJq4xAxdm9E8Q6wRVC9o/X6ZFmxWVRbs8
	Dsbmx9aeoq3M1S2MOo1Lz9ABez+Bzrdtqh2k5o6E6iTc0qYiBIrAZTd57BwlJrE0ySYq3EFCyWh
	JRwQ=
X-Received: by 2002:a05:620a:6406:b0:934:946d:599d with SMTP id
 af79cd13be357-936491c0d2amr1089166785a.33.1785973563793; Wed, 05 Aug 2026
 16:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com> <e40ea812-8774-46c3-aee6-511c6fbd07cc@redhat.com>
In-Reply-To: <e40ea812-8774-46c3-aee6-511c6fbd07cc@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 5 Aug 2026 16:45:51 -0700
X-Gm-Features: AUfX_mzXgSOHiICY1ddqK-TuDzFkaEE3jBELqqIvC9vbvc2AV0fuGlTf_pfRFfA
Message-ID: <CA+spn3ouZF2kRnvsBrasxdCwfmuXfK25mqgCcvpe0Oc3Y_aRwA@mail.gmail.com>
Subject: Re: [PATCH RFC 05/15] vhost-user: add memory_isolation to VhostUserState
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

On Mon, Aug 3, 2026 at 5:29=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> > -           netdev->u.passt.memory_isolation) {
> > +            netdev->u.passt.memory_isolation) {
> >               memory_isolation =3D true;
> >           }
>
> I think this part of the hunk should be squashed into HEAD^.
>
> Hanna
>

And squashed!  This patch has also been swapped with the previous one to
avoid dead code.
