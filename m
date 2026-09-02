Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB37B3B3BF3
	for <virtio-fs@lists.linux.dev>; Wed,  2 Sep 2026 19:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377712; cv=none; b=ljVa2swCwYVLbKmpPMV2u5Zdl0R+7pIXvIP5quS1SBgFPsv0CLHo3KBu6hN/l/JHPOzIcth5aU3xBAOsxar3iU44wRpo565beaOfSJkwqmgp6o3NwCFJfsHDrfPZvaTLBMJfZf2Z8w5tsCtjLWUwcreVQEkjfm6x+3sI3MPI4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377712; c=relaxed/simple;
	bh=BvdDyPUvlOpdi9wnTRyO+uo5N4XFvGV8H4S7yy3KuIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=naIyjN/SWotVrT/OGHlG65c0PldnLwdgMfTfK0RrFqWE5pDtn+WIIkt7DheAfHEV4+GodBOW/zJONo7GF7iHRiMfILzNCzSmunib9MZQ5d9hRb/u518zNNx1XP5cd+w4zwfcAu49wNSNfOtKcGUW77VKTSTjB8QEs4cK4cyMDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=DS+R64jP; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="DS+R64jP"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93903d81a82so146693685a.2
        for <virtio-fs@lists.linux.dev>; Wed, 02 Sep 2026 12:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1788377702; x=1788982502; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CZzpxxPA75w/wx7lhKvy8pkZXTVKN6GbmCrT4ENXQUA=;
        b=DS+R64jPIsZNELGcaAECY59L6Gwjgu+BnlhUdtFAsiJFwKiaPV8V8OiWx2NQ6LaNxt
         8gmiYbto80yn0lo6z14rJ7a9ySzJtsHv7LZejz5rf109HdWKef01VhUOk13d4D7uteFp
         VohEk0sakBSsfRA8YW47FHzO6vnqGpq5+LpRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377702; x=1788982502;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CZzpxxPA75w/wx7lhKvy8pkZXTVKN6GbmCrT4ENXQUA=;
        b=diC5e7zjb7KV7pvYaP6BjbhOq2D41Zf+0/GjXJJeAeqiv1395+Qa5OGCFMfr/94J80
         l8gln4myA5bNzqSMS5zL2RZ5zz8614GVhX4HMbPKLw7CEpkGD6ESmK2I8dDl3rl40d4M
         yQmL08/isnLEU+S5U1gK5gjumqiKDRQd+FKEHiNLBLSOLQkG0s20f0gbGY4SBcp9sfZV
         eO5xCvQMZUaarVPDOI0gAEiP3bxecY+f17TKNGa8ct/HsgOIL8dzbSuEC/GwYwe9I4CI
         0N9T7pMJFCkClkPq7ub/VdyQlO36BBk3i1N5NpytS0z4oPw1FAU3ekxLZtH8+67kwMcr
         dkZA==
X-Forwarded-Encrypted: i=1; AKwUvBzhc54xAYOyLTiKLd1mhhAjwjzUY8ROcNExvgH7IVrn5Vz3keL9KP0BZOOLaTonC2cbd+/d8ubLQHI=@lists.linux.dev
X-Gm-Message-State: AFuF++mx98mPiPBScI3uiXQxCxrxw1fHdu3hn6OkqDPDeNRo4pVtuLLr
	1GhF6KJQ4SaWYrekjbSR/pH4U4+YBMinMIprMClyCfC8Fj8BJNLvSldLMqpbxOvfEoZL7orUlbh
	4ctJeEw==
X-Gm-Gg: AYBFou32MvIb3LMObtbp/b+16Wkp954CKH1xqZICSe9OeFCGbUIeENts9DooY8TTFHB
	xyIQCVhspcE+OUi2MaFdq3bfdBBmPSc0EjGuuT+DbhNNQFCUdTrT1+yQ6FlCnwo96lHxPio5fK0
	nJTpn5j3hYmZdfI/pBgRYSHS7g7ML0lcds1HAbPq61y9+GQCFNMvyBeFDVDMMdqOAgF41ub6UCu
	/SU9x6uBkXBV9sj4LXrs25drC2nWnvQBCa1gbX0xFbbZA+Mo1FceTE9EFDSJl1IP7vO4bTTMSDf
	jT3lkKw8yTQk/ff8iB3CZ1naAUkl4K54OXm8IO95GeIkYKA3rF/5PevwTlTJeBCKN7ykdq0ubLp
	amq5H+B+3RD03RhqDCl7WGW2/fJer2Z0jfMD9zonWoXuy/zqpDnAWdq9H1yDG8KzQk0GOrj8YER
	xrkZRRe2kAC1mZJurFr2Pf5btiZeu0slQPVk+NkPJzKMnmOSn24Cd7TJD2fqohAIM/72GtVJizN
	rrxcm7xU/q9GiNZlJ+sQ8eHNg==
X-Received: by 2002:a05:620a:19aa:b0:939:31b5:4e08 with SMTP id af79cd13be357-939608a7d9cmr871741285a.0.1788377701845;
        Wed, 02 Sep 2026 12:35:01 -0700 (PDT)
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com. [74.125.230.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f361042sm291937685a.26.2026.09.02.12.35.01
        for <virtio-fs@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 12:35:01 -0700 (PDT)
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52e3de6309cso185831cf.1
        for <virtio-fs@lists.linux.dev>; Wed, 02 Sep 2026 12:35:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxIAKBmzFqat7VWeTcD+1TzgazwI1DhvyNTdAUIT2Ry5bkrS+gLl1mhfVzvho7/mrX1IpQqAm8b1GY=@lists.linux.dev
X-Received: by 2002:a05:622a:22a1:b0:52e:2243:6292 with SMTP id
 d75a77b69052e-53043cb05d3mr3477651cf.2.1788377700377; Wed, 02 Sep 2026
 12:35:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901213412.1763253-1-changyuanl@google.com> <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com>
In-Reply-To: <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com>
From: Khazhy Kumykov <khazhy@chromium.org>
Date: Wed, 2 Sep 2026 12:34:49 -0700
X-Gmail-Original-Message-ID: <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com>
X-Gm-Features: AcwNN1X1Mg4LYCUjdd1XdfvBEc5eboyV6sEgS52Rgi2jqZ-kCC6ZRG_IJMk3rMs
Message-ID: <CACGdZYK7wk0fMz7v7K_HSBfJvOYRmpWvaeNF8fBfU=j041gYuA@mail.gmail.com>
Subject: Re: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Changyuan Lyu <changyuanl@google.com>, fuse-devel@lists.linux.dev, 
	virtio-fs@lists.linux.dev, peternewman@google.com, 
	German Maglione <gmaglione@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 2, 2026 at 12:46=E2=80=AFAM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 1 Sept 2026 at 23:34, Changyuan Lyu <changyuanl@google.com> wrote=
:
>
> > 1. For virtiofsd: Does the automatic detection of pseudo-filesystems vi=
a
> >    fstatfs magic match upstream expectations, or would upstream prefer =
an
> >    explicit configuration option (such as per-path cache policies)?
>
> Why not just set "--cache never" for the pseudo fs export?

Enabling caching does give a pretty noticeable performance improvement
for those files that can be cached, and we'd like to have just a
single export instead of setting up multiple and assembling it
piecemeal. (To this end we do have an out-of-tree extension to the
virtiofsd-rs passthrough module to allow changing caching duration on
a per file basis as the protocol allows..., been meaning to start a
thread if folks are interested in this since it has proven somewhat
useful for us now).

But I felt having first class support for this felt more "right" -
enabling caching shouldn't break reading of certain files, and the
server is in a position to know if a file would support this or not.

khazhy
>
> > 2. For the kernel: Does the proposed copy_splice_read() fallback for
> >    FOPEN_DIRECT_IO files in fuse_splice_read() look acceptable?
>
> Yes, in fact this patch has been sitting in my local tree for a week.
>  Pushed out now, updated with a link to this report as well.
>
> Thanks,
> Miklos
