Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664294582D7
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785250254; cv=pass; b=ZPCYw70tNsuEMwwIiz9nakNi86ky0foiHPVWP2L33v8A/nNX46S7dm6CX59inPvk6gRep7wlcGPuMfM3Cj2sHTPajoxX+/u47JcLpAeSuFkiyLn0PV3rjQzwtkfjbEu5jGtrkxAENd/fGvMSMt5RSyEXBZMW4H6rynBKUdA0pVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785250254; c=relaxed/simple;
	bh=J3IT61DzsFHu7ECB0czGarDVZ7JwdvlYkaNxomxBG5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+H5DApEB0dZbsaBbJ1VedqdocBJYN49BHDOAfLl43NlHAg/mupVhVxhY8ghqkTa+BXV2R27EDk/PEUEdiquk9LTikZ4XaNleIgVvpnxvZ2o7P2+VYztwd7RNWMLZz0YMu7LFkceFJ2L5Sy0yM4k5ADM1+RwBTUjqCQr+ZyHK7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D6YyOZWf; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D6YyOZWf"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5218927884fso41716471cf.3
        for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 07:50:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785250251; cv=none;
        d=google.com; s=arc-20260327;
        b=QoRdK7j7Wt6mE+9fTb9p24vjlPAwEyWBkPIBKZ/aQ51zhvB3QUqY1HKt71NfrDI8bc
         SJi0ChggQhMBvpp6tbPCKgt7AGqP8m6caDOZvqpiSWaC4xFrkhbFNi5PmEjFgjHFMFdJ
         hjJ8La7+KagJfGq/DKXDTNTzSBCL1YbFf7V+taVgHdmR0NMK3iiOdK6YguRB3CSnFXZz
         TP6fVDlaSStVFz889T8WACg5vTYVrz/Z4Aoa/TrRPC54hAwLECNFwk/eRJw+lgGf1r8+
         lrqGqLgETOMZAwQpw7w70lvKZqxow8syPRU8nCo4r6jwkbhDOpYS6Wr3JFrjKLuMXHmr
         N/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8V82S70hOOVVM3hCCAMIvqx2miKyqpXj+SGwb2HfEt8=;
        fh=QC/ZnC3p3Z4XOffCCWZ0Q4VZsfo6dlaUbX9f7Gn6sng=;
        b=r6XfjWHQkNb5NrYQUH+R2ccNUcoGzNnnbDnx1OhSA8ODTIlP0QAUmRssxkfpvope3F
         gO17sofzj/QyqLaoxpakxXgffbhs6x/q+8u2mvuarpsDc6ELvumoSmPxl+RB4fqhkjlc
         7mirPuNd5r3TYNt1RQxXrmtdzvLBq6y4n9wkSEeai2A8rYJ1pSy0IfyR6DETT6SLg/wY
         xsbcdVRGFx3eC923y9DegYzBdSxOoxcaQS1+xfgB7yfFRfRuBfTCUa/KTB1fpaVSCufF
         MXjRYTe2cFx6YjB3Yl0nBrwyzpQPtJpgEvIrATujYlsSWbZH/6ZP+B1CxmFtqT026+sZ
         pYgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785250251; x=1785855051; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8V82S70hOOVVM3hCCAMIvqx2miKyqpXj+SGwb2HfEt8=;
        b=D6YyOZWfeljTkAi+xhwEfjFrn2Iw1T++0pXh/Bgscx0QhnDgMYsnbiSTRW0diSkbBO
         2OTygWI6nmHKhgqw+YeDpfdNAOfoRlYws6hZIUvgt7zXoGKqL8nFCco/RPuLHGKMLeFg
         SxIRBB+TCGkfUt1ZuBNIWvwee0CfOF8LKl7vNU1h3SDu0IpTTiM/WJP4emraz/sA1jvn
         A6kyZLdHzNfuFpzXcZn6cjdCBkXzbDJ69vlm4DkQYgcgT/inByGu0F5tHYQvNxk0u0FL
         teyQ3z2AuBaxE291uFivVPCThT0T7A/fP7lX9/oW/6HOUXy4qr8DaGPoUnxFhg+doOwX
         kn6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785250251; x=1785855051;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8V82S70hOOVVM3hCCAMIvqx2miKyqpXj+SGwb2HfEt8=;
        b=srP7qQgw+X0gLSxZXUN+T7BY/f8O4oUpiX9BYszx/paKe5TKPsTNlNbqK/8oDZP+/p
         xP0KX4BfRu1eo41mGXNIrgA14ARmNwXnTWJplDEdwfV+YbTimdTawhg6NQSt0HVNA34f
         Tg1MtEiH1iWnel/EehZziL5ckPiODbqx6Xrx2V5UBNXV/ylxHti1mtv86Vf6IjzxGgIG
         2xNCwByex0cyNV/ozBdnvNI5Z1Cmx8dHqULuWJPWanZSr+17TKbfd4HiILu5naC8RuZl
         Lyj+HN4haT8xUm5Tg3qd8PFANEX9iUXiDvt4LZkFR5WY+1f+WpGrPRbW0Z5BhuHsm1II
         l2ZA==
X-Forwarded-Encrypted: i=1; AHgh+RrdzEhepSnBqhezA2vZ/4o2bqvh6QIbmvOrQXyI8PDVYxePCdmAOOGRB5/E5oC+yd7OCmciYQyFySg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBPf8umoKtZz+DxOkQBAgSZKkrBkiFI2/aiMcf0kt6lESi25kE
	t5Kj6yWccWLjdGRBuy3Z3R48kfTiZ24gx1Zu8dX7UnlT/JnzO6QoXUIzIB8DX2yL4A8804GJTqQ
	HrydU8m78rxl7bfiOV0tQtI5PaxgC0/8=
X-Gm-Gg: AR+sD12jipSC/Dp/i/I3ODm7FIxlUznpb2IZG3x/lKakuhQbGa35RfoiaewZaoB3kJW
	q9tY+Kn3ibNQ5AVDonCLHAZKGyTy8wemC7YwWa8y8CIkgW2qcCFqIIt2mGKWspAvMOEeE6P0OjM
	O7QzrkqTgmrV1ZYGD1mNxRIIVo5Onirs7Akx7aMRgvgKu4n08h60K2bv1uGBXeMP/C6QaTP2xfo
	y/rUqxRyl5VIbaBpGGDxbG7asw5ObxyS9Go1e9oqttIO0FqU37yo07RgTW7fYBtMlp4HWusM2Qs
	6Ngg4je3L6e7VCSOtEA=
X-Received: by 2002:a05:622a:8ce:b0:51a:8c86:bd4a with SMTP id
 d75a77b69052e-529d714ba9fmr28796611cf.71.1785250251043; Tue, 28 Jul 2026
 07:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com> <905f74aa-8367-4843-915a-8817b3d236b1@gmail.com>
In-Reply-To: <905f74aa-8367-4843-915a-8817b3d236b1@gmail.com>
From: Connor Kite <connorkite@gmail.com>
Date: Tue, 28 Jul 2026 07:50:39 -0700
X-Gm-Features: AUfX_mzzxYt661ys1X2DW_QadGUCq94mbsDtuWfpra2rKx2_1jRG39Gj9jKKP2A
Message-ID: <CA+spn3p519J-ZPFUiiHZYy05n6p=8Eu-sgvkAQJYBcg=WvOXMg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] vhost-user: isolated memory
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 12:08=E2=80=AFAM Demi Marie Obenour
<demiobenour@gmail.com> wrote:
> Does this approach work for a generic vhost-user device, as opposed to
> one that knows it is a block/network/etc device?  Also, how much overhead
> is there compared to the normal case?

The idea is for this approach to be agnostic to the specific device in use.

As noted on the cover letter, I am still working through some rough edges o=
n
the implementation still, but when the project is more stable, I will be
benchmarking the effects of memory isolation on performance.
