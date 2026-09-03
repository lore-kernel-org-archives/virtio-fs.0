Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3994369D51
	for <virtio-fs@lists.linux.dev>; Thu,  3 Sep 2026 06:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788415351; cv=pass; b=d2zwSBdJELrOZ0sxkywcItCR+sNWRjaND9ChqTuoYitbgOR+gstG17FqTUnGt1eQL6SfdwZKRe89PtyjoOv/Q53xHbWS76FYXmXj2JVSxg02ojkJLkH7ga712fB55Q8KFjrG16conDZ+XftlcrgDGyMksfUzgIiaVCzNNgHP/4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788415351; c=relaxed/simple;
	bh=MqCVsIXApH5rSZl9riM2RDiGAEQhKGYbfZVh9vQvGRk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EYK1eDlAj65cno3cy5WSbsyHcPPzKZq2C/hK+tEHk8j9WH0P70XMtHf6lT3C9gE/Z0QvVSDrPJ0aqw0rhaqzsSpZi/94fNv865nUzTYYhAr+GyY/DaWbdfWe/dynxNUbKXNa6fWgmR3Vls2wMoC8LpvhVm398u3zcv6VuBjsB1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=qU5AqwbP; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qU5AqwbP"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-90cc107c451so12650376d6.0
        for <virtio-fs@lists.linux.dev>; Wed, 02 Sep 2026 23:02:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788415347; cv=none;
        d=google.com; s=arc-20260327;
        b=gkp4SkbyiMioZcigtXp4xf2gMskBQvR7og0uoCuJUxQlJe/qR63mJhRLJIjnml5qjb
         kaCf1Vl6q2kOqTRpGoCVmskmNRoqhPIltKfrfgPbVxkqxWthP3QrBZHw6L/yMSV2/3A1
         XNPflrK2q6eKq2lk9Ub8o1fEVrpg85rpF5xZd6aaR2E2e4mBO6OfT7y5Wh+S9SCbEXW8
         kJ//xZgSQvTRsCYYqAXWcxbyG3f1tzrADPr0fIXko0dwltPaaErSA4PDccKUYo9IXWRO
         7JfAnhuvnn5WH0rrxczykziOl5E6xj0MsN0iPQFD5dFBfqhDAxRPW5UhJ9IKZobBT+gg
         KbQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g1yu7nHtD7hEUEB0dyUurj+KKcQHD9tfZrm0XNASdrI=;
        fh=A5o/U0tcLYVrQwFLSrEqtuDqKSwSSpnBIjGkz4Olxx4=;
        b=jDpSO8UHbbbkhHWwt2lHIQb8KdXyE/nWSdEXhkAIPS5A0mLYoSGa2S634/5Y99DMVx
         FPxIGdOaE/vYkOBpZN732xNUtnGPy+lVfD0+wE4jwpcIYQyenxa929kxmPptOBr3lVNc
         I3XIURDTRVDfqsM2TgjBvTe7su/Nn1VY4pkCoyc46tqluwFww7P9xQF4xH4xSRkdWWxG
         RO7Cy4X33sShFvFgOLervebF6t2ZiO7wkvdwpJx4XFaxfr3fNYq2bWLh9V3ysGRSbeCU
         WmiRiUV6BoQWgoLggihUg6t/FrJmgEmLWQtqqgEfVjr6yrxrGIokmAAc5Qg8kNwzqKf0
         bBdw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1788415347; x=1789020147; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g1yu7nHtD7hEUEB0dyUurj+KKcQHD9tfZrm0XNASdrI=;
        b=qU5AqwbPY044LP9Rm0tNf9c3ZViphwEOdMxc6W9W8QofdUCkby5Qv6G+g8yq4aNv5N
         SpnQmmg9RdCsTD1dDcr3oYIOByCjECflNsb2zXU5CZDtcEvkSTv/HGSgDZemBu4YDxxA
         jDcvIXNGQnW8o/BszHpb0ESaobO9djuLNRfzE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788415347; x=1789020147;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g1yu7nHtD7hEUEB0dyUurj+KKcQHD9tfZrm0XNASdrI=;
        b=YV3D3tvQpTmKZctie/K2tQfl4RGHm7RgKfIfARF/YOR2iPu7t8BxxLFuM7coRUUzKe
         HXAB5o7vI4r4qJfyBghXxUhQQgS5oZNrMmz+99HX/DeQ8ijDFcMjPQiIF2pSFjGgFtiN
         E3CWNp+Ztz6JFibKPbrMCfSEpa+IPWpHUecdiQnn0HGD7ySWFwF15eMY1GCPWICknvgs
         RvIm+372sHLEtyQu/g5Rby/TZK/caYtGCDob1+09jpl4NVo7QIz5hEFSdf5b8zi0xucL
         4qxshRScN1h2t5U5EkR+DqkL9vEwZhuS0feFa40bl7n44AkoOLbb9pY7XUH7aviKqABB
         +qWA==
X-Forwarded-Encrypted: i=1; AKwUvBywidPYyTS0esQJVva8eTj4XEs1AY4XIfDGPMN8OLEtZqiWG1hRRCCr2bITr0YlKN1Bzj1AGlwjgYQ=@lists.linux.dev
X-Gm-Message-State: AFuF++lf9ejts1BzaPsX07YbqH2N6DuRE0UfeWs4uKNa1IIeiddDZAXN
	ttCXCvy0daFnCRmX3BRAp4FFA3KEQixjN3IxMF5LnFSDtIaLFbeW8vgL7I26nM37XEmKMzLwxrm
	BKcjewZTyVUSlCzzxg5a4A2JuI1FhEOG5k5ujCEQrkw==
X-Gm-Gg: AYBFou1dhqKrcXBQl7Q0vWdQ0uWvHig/Z22QXkuX78cYexQG3ld7oKi6gDBoyONhgyY
	Du9IYYBR/LLVerWTQXiyqHoIhenCVH0pj2O+3LosmDw/lhIhJQPBOwM06ujkTxLD0HN3oOIMkCo
	bOjXdBag0WJs4skgft6gzAPxDV9jRIF40dHvbQAu6pMQ6ycbqKyJuoz6h2KgasGydMk8tx4YzWp
	o7GC/v/BkkR7FrmoJ/ZSQy/xwM40pWzAd3VlzHPISKJq0gENk0HcTdPjO+WpMW8TVM2Os9onVVv
	jjm8QZgy7RPMaDcLg46MdZa6f4wQe/m+MfkusIrqSGW0dY+4YJ9Sps7JwL44u/7d6nf2230VsDj
	I+kBndOhU9ToYi01R9Q1rgFQ7tTewuAZ8/Q==
X-Received: by 2002:a05:622a:350:b0:52d:ca81:e5b2 with SMTP id
 d75a77b69052e-53036b92bdfmr107966781cf.5.1788415346430; Wed, 02 Sep 2026
 23:02:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901213412.1763253-1-changyuanl@google.com>
 <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com> <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com>
In-Reply-To: <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 3 Sep 2026 08:02:04 +0200
X-Gm-Features: AcwNN1XVuV6dMjB2XnXfKHVLJna_Qp6Z527eNokz21zXxuW9nXlLJkU0cPkN91g
Message-ID: <CAJfpegsWp-s1v62mwhafAsGPXsP_aEPTgG_FoOLHVmNeWtevHw@mail.gmail.com>
Subject: Re: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
To: Khazhy Kumykov <khazhy@chromium.org>
Cc: Changyuan Lyu <changyuanl@google.com>, fuse-devel@lists.linux.dev, 
	virtio-fs@lists.linux.dev, peternewman@google.com, 
	German Maglione <gmaglione@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Sept 2026 at 21:35, Khazhy Kumykov <khazhy@chromium.org> wrote:
>
> On Wed, Sep 2, 2026 at 12:46=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Tue, 1 Sept 2026 at 23:34, Changyuan Lyu <changyuanl@google.com> wro=
te:
> >
> > > 1. For virtiofsd: Does the automatic detection of pseudo-filesystems =
via
> > >    fstatfs magic match upstream expectations, or would upstream prefe=
r an
> > >    explicit configuration option (such as per-path cache policies)?
> >
> > Why not just set "--cache never" for the pseudo fs export?
>
> Enabling caching does give a pretty noticeable performance improvement
> for those files that can be cached, and we'd like to have just a
> single export instead of setting up multiple and assembling it
> piecemeal. (To this end we do have an out-of-tree extension to the
> virtiofsd-rs passthrough module to allow changing caching duration on
> a per file basis as the protocol allows..., been meaning to start a
> thread if folks are interested in this since it has proven somewhat
> useful for us now).
>
> But I felt having first class support for this felt more "right" -
> enabling caching shouldn't break reading of certain files, and the
> server is in a position to know if a file would support this or not.

I'm fine with this.  But virtiofsd maintainers will have to make a
decision about merging or not merging this feature.

One idea that occurs to me is that the kernel is in a much better
position to give a hint:

 - file is normal: POSIX semantics apply
 - file is pseudo; POSIX semantics don't apply

The "normal" category could also be split into:

 - file is local: changes always generate fanotify events
 - file is remote: changes do not always generate fanotify events

Thanks,
Miklos
