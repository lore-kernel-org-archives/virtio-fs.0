Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B104303A35
	for <virtio-fs@lists.linux.dev>; Mon, 14 Sep 2026 22:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423271; cv=pass; b=Glxdw0pAfHDH8u9zwrewouIwzvRAeBUyvbkIxHMnERla1btzuKkMI/v9S0EAswguNU/mZiMCjdKb7m7EqxitYdiaU2Q+8YBWoIZ6NA++iDdwTZM0vN7m6lB3YJKPG5fB8oQ0zhO3K6aslturA6qhfENBH/6itsWofu8tWg2oVIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423271; c=relaxed/simple;
	bh=u074ZkJrbh/sxcHtumlTwM+gkaHZ9o4Ni2U3r4twwug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fOxM8qoBZjFLxt17nvhaw3adBBCDJMvYj1vVs9WJ8H2j8eB2kJqn1R4zB2lp/fuK8G5yfcb4p6bxPRVKUWNNcsxTH7AixmA27rg38SCQFcFqSw+k7m9wIHmiYApsKoX1L0MF9noocKzAtXARR5Od0nrIrU7U2+IXetv1r4sAfgI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wDciPLCh; arc=pass smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wDciPLCh"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5306706e89dso20511cf.1
        for <virtio-fs@lists.linux.dev>; Mon, 14 Sep 2026 15:01:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789423269; cv=none;
        d=google.com; s=arc-20260327;
        b=mmwCk2CAA9aOAG8W3xO/16UCuexYxLTGnrj9dLVENbIe5UF6a+IZWZDslEJVPa9Zb/
         P5Wx6rRPbySMN4ZXvwqPmEilqOy7w5gEZJn9er6f+9+38Qiv49zdKmsRl/rf2Wwbf3KO
         u0NTvqQpo7ZUJjk+qrQBy7vdNjZQEi+Vo2XXrs9LOgn1MDPi1kW2qC0fXTzl0OlLhfjY
         JVx8z/bSUC6e6mTvwG3VQ6a1rIY6g8SzCpww45hTI2qom3am8F19LS7dCQb7xwZVGmXj
         b3ba7OI8gYisoprdSdxQo99h2O5IFhv1CI3bCL8fWturDEGTAqce2P4Axw2joMpEibfE
         jC8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/jUCnXWS5HMAcD9KVLzpXLWgp/l50UoHWvAneYo+hEo=;
        fh=Cig719i0VfdrAPZ3SGR9HZ7WlUqlVwJqS0yLrFAV4Lk=;
        b=XTAzHTZGBrhslWVic5GZ5LEig+xoNud1zbue/5+2olTDbumgjxsHijR95Z9vGSJVsL
         aHcnhnVyxgJm3tEpJ3OxzJhvd6Jy23O5QG4u9ZtXqRkzcEuAfqPHqeH6en4+guAbkr8E
         yVg27UC4fNkSH1MAqCmtYHkS3NQ6eTao2Jym0NB+XX49Nz57cVyVzZ4ML8qTVuzryE6P
         Y1pMcKfEN6qBawUY0UjRKsjUeuFR+3EoM2KfyE5xuzaQvq4HNsno22HJfF/PHEQCLYdg
         1TwDj6qRHRRZkVKwA1LiljpUn/6EmHzJRTqWSDLYJ38SiRPisBxN+iRk2W4D+euM6k2c
         RL4Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789423269; x=1790028069; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/jUCnXWS5HMAcD9KVLzpXLWgp/l50UoHWvAneYo+hEo=;
        b=wDciPLChEGXQZmfZdAPwAYTHBW4/tuFJYuSyRN2fUmnUKIFgJ767ksr5YZIvmySMwt
         IkwB05IYU5dysfLc/S/8f0lRuW16BL8daBjMA4mE3pM7TnWwMecQLwNSAYC3ZkO5JICk
         vkdjx/wvzbzivRUznJXCGe9cV1a5GlUZiirXDa+9wiYC74B5+OHU81NEzGUqWJGkT39R
         xvzzeWsS0oU+AEjPFS8Yf1Wwu1IpP3mPnWwBERHSZmkhkGZ/J1R/1QiUtLnFJhpukfa0
         0iMP0dYntRNsIvaLEfy5kS5IAi8J8xMximutrpF2ex6xsiPAx0X+2bxJojWaXdlk+Kcj
         KwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789423269; x=1790028069;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/jUCnXWS5HMAcD9KVLzpXLWgp/l50UoHWvAneYo+hEo=;
        b=c2K7LRou+QmpCFsmkMu4fkQ3EyxCt2H1/EiGHwXR/KHiBbrZ7uGW6hR+q6kAKfo8eW
         hanaEbdJHdUFVkcWFM7OqNjpRY6i0FQ1CDgwMp2gtu25uKw+JO0q4cWtUk6wjNE0OOBP
         FNPXobFsplZ11+42n6eAeT18SNhYcyuBGzkzPm62lrZXpBcCuKzp9nZS627E0hIn1u3k
         aybgOOm+ufKar9AjfnqeIAFWRdldYHyRuSsRgeqr/vWiVUzOcFgPHuPpyV7vU9JiOQQO
         J0+m+S3NV0/KLBSnjb1mM8k5yTq8YTITtWXG27RcF5rx9WbodDiD8+BCrdA6gK3jb/UW
         DZVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxOiFOevgE+9Mr8eZ8152eDPMvaIvuizul+z509kxlBKQVUm2GOWnPbpon3YF3pt/SYwGh6MDwRRIo=@lists.linux.dev
X-Gm-Message-State: AFuF++l/k8XP9PMiny8SQY5cM6XodSFeHD8QimwkABDLwgeyT6HYie3e
	v6/ATrL/WoWsGUoVkTEAckgJUjq4amNkcy22h8fWy9gyCcAflS6u++cKV5CCRZBdCGQTsAllX+u
	hCDvAu+xqDnPxhpJvdDQUNPJ5b/ZEB2QkoTFNfNoi
X-Gm-Gg: AYBFou2z6r+eHQxYYURq4KpGCbGgEtz2kCM+tPE0BPMlpPAgLz7HwGbIqwhTezdCR54
	nYGa7Hu08PlIEWoDkVYqwhuxtgT0/XtPvnTDTGUeqzYHzNBLEFE6PQ1Oc++ixhM8/kp6wxbeOUK
	WUamX6qJ6jqGVequLOllOD0l4jt1AFf6V5s319RDwUePyIGFFbsNdif7Rvlj0501DCooJf8PjFi
	pwi1+/9AR7Q3K68J7ytIWQtLqjebWOVuw1VRWv2ynlADfMIHTw6fkZa+h2Y+vWKuADo6mlMUzcA
	4XHgT2+2la8kIRF99tao+HGmE1+EKj27wH+idlnUL87tAXdrtBLrzVUuBRdk0puEW3KStVGhs+m
	dGrH3hDtzqrrmxS/KqnxWbgVqARD9cnLRIcY9LYvQzw==
X-Received: by 2002:a05:622a:144a:b0:530:4182:5a95 with SMTP id
 d75a77b69052e-5311a5ea835mr1388571cf.2.1789423263806; Mon, 14 Sep 2026
 15:01:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901213412.1763253-1-changyuanl@google.com>
 <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com>
 <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com> <CAJfpegsWp-s1v62mwhafAsGPXsP_aEPTgG_FoOLHVmNeWtevHw@mail.gmail.com>
In-Reply-To: <CAJfpegsWp-s1v62mwhafAsGPXsP_aEPTgG_FoOLHVmNeWtevHw@mail.gmail.com>
From: Khazhy Kumykov <khazhy@google.com>
Date: Mon, 14 Sep 2026 15:00:50 -0700
X-Gm-Features: AcwNN1UAZX6HXGRkfXXv8pnAk8GmfsbACR91va4FlYm2LZCed6LJBVPYR-pRLqw
Message-ID: <CACGdZYKVz+0mrOuh2nyu2-jY=JXY69HbR=7PP_UHG5F-bB=-+Q@mail.gmail.com>
Subject: Re: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Changyuan Lyu <changyuanl@google.com>, fuse-devel@lists.linux.dev, 
	virtio-fs@lists.linux.dev, peternewman@google.com, 
	German Maglione <gmaglione@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 11:02=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 2 Sept 2026 at 21:35, Khazhy Kumykov <khazhy@chromium.org> wrote:
> >
> > On Wed, Sep 2, 2026 at 12:46=E2=80=AFAM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Tue, 1 Sept 2026 at 23:34, Changyuan Lyu <changyuanl@google.com> w=
rote:
> > >
> > > > 1. For virtiofsd: Does the automatic detection of pseudo-filesystem=
s via
> > > >    fstatfs magic match upstream expectations, or would upstream pre=
fer an
> > > >    explicit configuration option (such as per-path cache policies)?
> > >
> > > Why not just set "--cache never" for the pseudo fs export?
> >
> > Enabling caching does give a pretty noticeable performance improvement
> > for those files that can be cached, and we'd like to have just a
> > single export instead of setting up multiple and assembling it
> > piecemeal. (To this end we do have an out-of-tree extension to the
> > virtiofsd-rs passthrough module to allow changing caching duration on
> > a per file basis as the protocol allows..., been meaning to start a
> > thread if folks are interested in this since it has proven somewhat
> > useful for us now).
> >
> > But I felt having first class support for this felt more "right" -
> > enabling caching shouldn't break reading of certain files, and the
> > server is in a position to know if a file would support this or not.
>
> I'm fine with this.  But virtiofsd maintainers will have to make a
> decision about merging or not merging this feature.
Ack. Am hoping this list is the right place to get attention :) I
tried signing up for gitlab but I think it very much does not like the
corporate network here -- it was asking me for a credit card to create
an account (!!!).
>
> One idea that occurs to me is that the kernel is in a much better
> position to give a hint:
I'm not sure I understand the proposal here: the guest kernel doesn't
have context beyond what we pass through the inode lookup, right? I
don't think we have enough information /in the guest/ to know if a
file was a special pseudo file or not /on the host/. I might be
missing something...?
>
>  - file is normal: POSIX semantics apply
>  - file is pseudo; POSIX semantics don't apply
>
> The "normal" category could also be split into:
>
>  - file is local: changes always generate fanotify events
>  - file is remote: changes do not always generate fanotify events
>
> Thanks,
> Miklos
