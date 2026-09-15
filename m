Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C5C43E4BA
	for <virtio-fs@lists.linux.dev>; Tue, 15 Sep 2026 05:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451128; cv=pass; b=GrK+SH6oW2WKu2auqDmvII+yuF9y9vqNuLrQMmGhlaWYSSgFh/uqlgDSE9MOvKPz5xqOe5Y63bGjfozc/pEnfwlESWU8DGry4JU6E2KuDf+25cxXHXz3EDJUD/eB7jTOjidkVOCMVXDkRHgdlorIrAswpp5LHVryNit2YOEIuDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451128; c=relaxed/simple;
	bh=l5Uw69JZUr1QcSua6I3kTK6OuQTiECTzvg0I4B4pBok=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h3amuF/iY/BW5EVdyC5tzA4UR7Z5xSl2E9FoZuVWKdxI84D1qpekGaxX/u1LjjrkMPSMVjP+L8j7wGiUGJh4gV7ABzdLK597yOBRjesPNkVFxlwWy766ALIDwzFYhhPy0vMtMnrJhTh/tFvOkCHWcUtpjxRNhsZjNCfXmSXthSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=L1179yD+; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="L1179yD+"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-530e5b2cab9so17693091cf.0
        for <virtio-fs@lists.linux.dev>; Mon, 14 Sep 2026 22:45:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789451125; cv=none;
        d=google.com; s=arc-20260327;
        b=K/+HNBzIspEH3hps+Gz4uglVhmVtZ0DNu/3NnbDHLI06/V2qej4CysGmHgxRxncAZr
         IKRWWo3yO9lpBmHlOzZgvNi6qd0VbKeOxh8f5MktjAGz5N9ngaF/zKoZfABWbtAU5WOI
         KG6wJVM/+GpYym6cK8VRRlnC7KJrJYFTvYF+6zZpAE4bl06DcrvZz8u9qnzMkAHLyjL+
         hR62iNghPlDfo8C6kI7uY1kPtQFnTRCO6LFxiHPcBgKo1wnnzaWniZSRkZ84NWkBhE+f
         hfQ0Drd1K83lgeOis2udGWcdM/M57ljAPeeyAomc/5wWCWDIlgU8opT4jkARkbdCdA4Y
         Wqyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GWxSooxDJrD2T+q4Hj8D1+BEWhhIxIncoIk4y1XYCEI=;
        fh=2kPg9NcVp4rHcGLmoTjM3AsNhSIQ3pvt4z5P95MwScw=;
        b=ZzwU2L/Yv+Wz8XZupw+bYJ54DyIAy+A+n89WKZIW2wkqnah9hbA4VJ9JFKAH4ZMN2z
         kPR9gDnQPVFpTdGEehNQ38KTa32V5jHsxngVfwL5cDh6Z9887NdT512wIPe6/g/zVREG
         jhXeCVBbfRFAP0TLEpGvJIPi3a5feY7bQuZnmdfl7+WuLtef1aajEdOfIRBb3JvEqZXd
         Bylslqj8XGqvqSLEcGqzys1exe9kJAdompiHfiBstajGIR3SQDaPQlB1zFDXkoTRAf1y
         W7RR5UUfXXYfvZ075OE9fZzRWPsO2VaIIUg8/uQOQLz9frsR9EGGtpGO6a1pl7e1lzL/
         OhfA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1789451125; x=1790055925; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GWxSooxDJrD2T+q4Hj8D1+BEWhhIxIncoIk4y1XYCEI=;
        b=L1179yD+28Zy6HYjU48KsBWW7Rs41/DYv8yatq6vkVUOaL3dEskQ3Kv9dMEFSG0meK
         LEEnLTOZibpCkcM0j5w22NPnsrPHfTvzy17AxxKbjEC8pxHRQPyMtwpJpJGg/p6CdiDM
         PQrsWW67UewxDhCgi3PUgJ/dlW95IqKnkTMKw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789451125; x=1790055925;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GWxSooxDJrD2T+q4Hj8D1+BEWhhIxIncoIk4y1XYCEI=;
        b=wMXdQAzwZdjVEKiL64kDVwXq/Xz6HdPSRAyndZvyiWEZN2/b/BO2croei+iuEwO793
         Kae+HMjGjPxlU0TPlVofGe/69q/MgsOcXfRbIG5o4NBbWAp/JUjTJlvLjGkFwa814BXD
         c2DFNGjgTXOfGnye4fVKD4FX2kyZ3HoPCCj3NemIWlJzoNHpYc7mI7aZUDirICmBObEQ
         vQzRoDFKHlp/wjKTJs0JtLQPSJZmKq2A92tHfCcT/AuRu1HOw1l1qHO5tbI9ZrX4YDLw
         F2qtJPDIMWjK3jxvlKMAi2EncROlt+wx4PEdueBUTu5AvzNeI003sLo8b7ktQmXV03JV
         39qg==
X-Forwarded-Encrypted: i=1; AKwUvByxs87MEWoMoVv2VFiiCfAhPw8f+Bk0EmumAT71DKLH7TJ2ipSfgERqb2Ue9Hy+3qOowM41OqJCutg=@lists.linux.dev
X-Gm-Message-State: AFuF++kzlv0xj2IpZe+1aSlHDimDpCeIG1ZZWhfsnBx4BwStm82F6bJw
	VEJ1kN0CALHnN8VKQhX2/8/OJU1tmMoN0w+62TeJsbMxYd3LuXhOP6/EarzimDFByahZPRlbyx7
	se0/6ODJMFI/xcAxABwfwwSshZfaOVLipYrxqIJ3xPg==
X-Gm-Gg: AYBFou10+EjwIypJMm6Rq7/8lUPvFIW3BKl8RGj0C2UuVcdYnYH8ZkdXe/K+WFe6jlg
	L35YyC1zCcfFGMZD41zrKZ/YgYYPCWb3+udc5xuScA9c5ZMjaEc6JKNa0n64MNEAhHaFVHkkd48
	vULB+7MX0otLbdXq82LLNLiNXgocAGJtZS4D77FGaXzHZ6XTShELZaNbVX0vGzSIVRFlNlugRDu
	nhgKuI+l6NR4b1rXq915DxuqehWHrfbkeAPIkwRRcVsfrtE1E3AVpRvj+4Q1ZIgBopc36ic0J91
	ejptu8icPDDHb6XaPRkN9sKECKZytVW49MPE2s4gwFDf9oVIypPgRTXwMxa/IRu6uKgtfRELQZd
	fBIWTiMm0nDC3YnVy09kF
X-Received: by 2002:a05:622a:507:b0:530:f73a:90a9 with SMTP id
 d75a77b69052e-5310d071109mr84282011cf.53.1789451125103; Mon, 14 Sep 2026
 22:45:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901213412.1763253-1-changyuanl@google.com>
 <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com>
 <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com>
 <CAJfpegsWp-s1v62mwhafAsGPXsP_aEPTgG_FoOLHVmNeWtevHw@mail.gmail.com> <CACGdZYKVz+0mrOuh2nyu2-jY=JXY69HbR=7PP_UHG5F-bB=-+Q@mail.gmail.com>
In-Reply-To: <CACGdZYKVz+0mrOuh2nyu2-jY=JXY69HbR=7PP_UHG5F-bB=-+Q@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Sep 2026 07:45:13 +0200
X-Gm-Features: AcwNN1XUPy7cho8LCyUGl-U4hP73_j7-zlZrh9pWB2G7CvtlMUD_1OKksPIyp5M
Message-ID: <CAJfpegvK6_Jz4tUcguaFo=R0ZzG3Lg7TOsJmvFnMN_+Jyeii6Q@mail.gmail.com>
Subject: Re: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
To: Khazhy Kumykov <khazhy@google.com>
Cc: Changyuan Lyu <changyuanl@google.com>, fuse-devel@lists.linux.dev, 
	virtio-fs@lists.linux.dev, peternewman@google.com, 
	German Maglione <gmaglione@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Sept 2026 at 00:01, Khazhy Kumykov <khazhy@google.com> wrote:

> I'm not sure I understand the proposal here: the guest kernel doesn't
> have context beyond what we pass through the inode lookup, right? I
> don't think we have enough information /in the guest/ to know if a
> file was a special pseudo file or not /on the host/. I might be
> missing something...?

I mean the host kernel is in  good position to give a hint to the
server about the semantics of the file being served.

Thanks,
Miklos


> >
> >  - file is normal: POSIX semantics apply
> >  - file is pseudo; POSIX semantics don't apply
> >
> > The "normal" category could also be split into:
> >
> >  - file is local: changes always generate fanotify events
> >  - file is remote: changes do not always generate fanotify events
> >
> > Thanks,
> > Miklos
