Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE6D359A6F
	for <virtio-fs@lists.linux.dev>; Fri, 21 Aug 2026 02:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787281084; cv=pass; b=WkzAwqc4b1gQiixIPxF2ih3Hk7bbA2W5+7uOJjxWLWAkYfGmqG+1It8o1SmSm4JO3ommI/3noviHRAswYL6PkeVykBxTQFF0lSq+sOza/xKXlCuElMyfxsC/Id7HUBHWPyF+14Sh4AdK1860i54YCsxZ6TjlKEeUxiHWiIek9CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787281084; c=relaxed/simple;
	bh=oce7tIcoCwv409o1d8gwwumi2xb825oLwlSSftCpvjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SgrFCHVRFuU8gBp6ZpS2vogGw2nUCCWypr8PF6nAlEC+r2CMz4YCGFn6IAoPciCDwyaeL8IjuxV3rH9GTRm2asBmmQCa3vPqGgezREuo+ve8MC+OcnbR1mc2JqDcXmXRTBthjL/2qZDuxBUJu7LcPWTomWKe+8bzHPMaPn3XnLo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xg2rtLxQ; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xg2rtLxQ"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c05dcdf49so4794801cf.0
        for <virtio-fs@lists.linux.dev>; Thu, 20 Aug 2026 19:58:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787281082; cv=none;
        d=google.com; s=arc-20260327;
        b=cJlFrGxU/c380H9rjxLIZaam3D3skY2sBQQIxo924Zk71C81VVvlcQuPqnZRzqN432
         FXQ0GMyjOXdmwOF9dJkoR9sQ5Nb4Pv7OWHmsixWEt/kxu4NRuzZYwPfSQxCuQYCNvrE5
         dx1ngCBs9HyQlZYxq/rc5Q+yLHN08ZMtTnQotnp8vzpCJmReRjday0dWEs7VSIEkTje3
         hfcLVNiRuwOFsGQAfe1D+cKovGQf9PjqRTnkcNMSNoaX/aIr/gJlXbmOFn8UIwiaTc+I
         Mu50icgfm8p5Ti4UDCwSKg9t47IMi9cgbOSkB/lylJwLXJdg7z/jpoHYH5yx7E/dd3JC
         Ukcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zSNmTPaNindB5nxKaFCyV4uOayvfqWNLHa5LTnes58A=;
        fh=XyukITcSq5F/sNwRisuwY2Z+ulRdl9iyIlxfRviqZMg=;
        b=h/4oUDJRiyKex8CAZHyMMTNVMw2Y4geU622o76b71oS1JykSn+U++8dRQiRF9SqnXA
         qe/Znuzd6LV96BYOiweLFwHk2h5nAIu9n0pbzclagzd2kOeSQyXTL9P67Of7wcu+kuCI
         i1e6AnLler7afyM0brQU1P4Yr5GwBmn7DtogeCboOUxbQruBWUlXIGnWc9lA2cSOTKZV
         JrKiNrhLFc5I0/6e4FZbWcsqfFl2QYvuJ4UL8HOl0lQ/jAtg5Svuo5Z5+G9hDGKPq4/k
         0mpJ4CAcilD/jHonalrePQCBPaWOErLUSYcjmJ5Aab29JUC8cuDZ9oaxCzP6Zt0B/Nd3
         JcOw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787281082; x=1787885882; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zSNmTPaNindB5nxKaFCyV4uOayvfqWNLHa5LTnes58A=;
        b=Xg2rtLxQUW7TGq381IYk9KVWdMvpyZa9dN7uHcvSPuqk+q7jnifvvo95c9tuLAedEI
         4KnIQHTHpFk1izFXm+w/Y5tR59ejIW+JMKYLcR9BeHdvxgMf6vZga1WfjPJF6MtxOp3K
         b5GuRC5Q69GWXPQv+cKqJK68trOg9r3D/sD7ZfjcKxmQETC8wRNLSGkEWadXbzi8L9js
         +msyEIclTdG+p9QbiX6oHZkHAuiiH3QWWyCRsnpTq7OMsWCvnJnhed1sBMSOpZ7p0QJ6
         8Vgt66E2TIPkn2uqYGpoiejjhl85mbeN2U+750dBY2oxbhcKT2Hqkk2B2HM1AM/S5eXc
         skig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787281082; x=1787885882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zSNmTPaNindB5nxKaFCyV4uOayvfqWNLHa5LTnes58A=;
        b=m6H9SJxfsNY0KlLTEyiTX+TwhWzUXXfECclLS1wD9MAL31RloBJKMhM5ZrwK0pmLAH
         BuY6LfUF8wG2TfOqsDJAJ5zFk4Hb/Ep38KLAITX2OIX4LH3UXUW32oQ0dkDtJk6uIdCP
         Y9YeAXeiK3Aq4fbx7JH/CC4zSt4e9hOr+n6Ugin6r7sxhKr1MiatmgSqU4qMOtuZtmkz
         ZOBdm6mFzSPy/4Xb+TMPaNSYsZP1CHXm1Mgh4gvPEMc/HYu7iJG1gVuU9J9WneUhGIHF
         9N4IN4ZHgfkfMC8x16HZUX9UvKA99aFO4uVdplF4MYwEye+CM6jNj4cLhwsKMrKIQ8CA
         tqmQ==
X-Forwarded-Encrypted: i=1; AHgh+RoWGOvfjCPn0wi1M6ucolO4QD8LVbJ9c6qpzKnud0W5i/bcnyXZg5MiYDvLygcu6d6Kh9JUGi6zvfU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFep/zLbgApazZQekAFU7rR+iTcTHnWTtz8B1+auri+xTEi+zJ
	++Zy0kViWAXQKhfrg0+kf7g4wYSVe8odG+xrpfFMQNYqbhgufe1HciD4bLpP8BCT8buxCqBe6a0
	VO+EvB3zx5B2BmTK+QZ5p4ZMQVGH/sGE=
X-Gm-Gg: AR+sD10Q2aMRb9ZcQhfEh/8rnKm8MVVfW+aX8KW9KsaOSNeqOcdrEnOJxBfEjEXv78+
	JWFRlPNpkCTemlTR71MrSfmoJaiu9w/fHr7fZcKplYYREFQRrd9PMzYY1k1I2adRumAZnSJkwRS
	kZgEr9ykq5Z34SciiPok6phUZWfgavz7ncYY+wPkMP7hhHyfpMbO/G96z59MbpodkXkYEz7P9oh
	VmxCqR4DIRHIZ1N23H2y5bPaUv9ZRs7r7LrSKi0pZ8AsYgiT+Qtj+BAQNFmjXnOBmafj4/5WUG4
	gtbKCUV57aYd+d8a0xrKudBNyNudfrObC7vQDPGfcH/2LRBVPdOwWvCVguNjP9Lm15Vbhi7xx3e
	4RspgZKxF1JcIxQ==
X-Received: by 2002:a05:622a:111:b0:52d:6cf5:1c01 with SMTP id
 d75a77b69052e-52df5a73d25mr28383211cf.36.1787281081993; Thu, 20 Aug 2026
 19:58:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-7-948aae960abb@gmail.com> <ab5f4ec8-0ef3-49df-94c1-b7145d4153d4@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <ab5f4ec8-0ef3-49df-94c1-b7145d4153d4@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 20 Aug 2026 19:57:50 -0700
X-Gm-Features: AcwNN1UfP1iX8bGmorWimeRMWt5bx7-t2Md_OfCGSwYi-defJG8tPospdb8vZ94
Message-ID: <CA+spn3qk45YZC6FDMFk9FAr6aM=OziGfbeNwmScoz9DOU1rawA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 07/13] hw/virtio/vhost-user: create isolation region
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

On Wed, Aug 19, 2026 at 12:36=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> > +/* Memory region shared with back-end when memory-isolation is active =
*/
> > +typedef struct {
> > +    void *shared_mem_addr; /* mapped shared memory */
> > +    VhostIOVATree *tree; /* controls mapping of regions into IOVA spac=
e */
> > +    void *vring_hva_addr; /* beginning of vring region in shared memor=
y */
> > +    size_t vring_region_size; /* amount of shared memory reserved for =
vrings */
> > +    size_t size; /* size of the mapped shared memory */
> > +    int fd; /* descriptor of anonymous file backing shared iso region =
*/
> > +    Int128 iso_iova_offset; /* translation from IOVA to hva of iso reg=
ion */
>
> This Int128 usage is misleading. The value derived from iso_iova_offset
> is always consumed with int128_get64(), which asserts the value fits in
> 64-bit. But we actually need to enforce that the address before
> translation resides in the shared memory. So making iso_iova_offset
> Int128 is not a good way to assert the real invariant.
>
> Furthermore, "[PATCH RFC v2 10/13] hw/virtio/vhost-user: handle data
> movement with shadow vqs" has:
>
>      ptrdiff_t offset =3D u->iso_mem_ctx.iso_iova_offset;
>
> If defined(CONFIG_INT128) && !defined(CONFIG_TCG_INTERPRETER), this will
> overflow with u->iso_mem_ctx.iso_iova_offset > PTRDIFF_MAX. Otherwise,
> Int128 will be a struct, which causes a compilation error.
>
> uintptr_t is sufficient if the invariant is enforced in some alternative
> way. A negative offset would be represented as wraparound, and a
> positive one will never result in wraparound. Just always ensure the
> address before translation resides in the shared memory.
>
> Regards,
> Akihiko Odaki
>

Your point is taken on the Int128!  I also got similar feedback from
Stefan Hajnoczi and Hanna CzenCzek that it was unnecessary
complication.  Will move it to uintptr_t and double check the
bounds-checking on translations in the later patches to confirm that
it didn't depend on the Int128 type.

Also, I thought I had moved all cases of ptrdiff_t to Int128, but I
apparently missed that one.  The offset must have been less than
PTRDIFF_MAX in testing since this didn't come up.  Will fix and change
to uintptr_t as well.

Thank you once again!
Connor
