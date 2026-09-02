Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE269352010
	for <virtio-fs@lists.linux.dev>; Wed,  2 Sep 2026 07:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788335173; cv=pass; b=TGJMuBuIro8Kg59dfO7ofVbKT0g72fFQOjSn7XNy0PumlFEVoXIIatNmM+sXJPYGxRN6/yzLwVZpCLjAY02YTwCbodt8YkUe30lGmn6pAamB7GN6uyyt8rMeZOGN/teNTBfAFnvM12vYvpVwBz9VbL4WBvY2uNrtXAcnGs3AmqQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788335173; c=relaxed/simple;
	bh=Ff42/5Zin2A49xGekI+VoPU4wwYez+C35cPmEHD27Io=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XwYo3l2LMJicl7vvbtyg3Pp54GjjuwegW2Am28B5uYBGHdfG/7n2S2qtyXOCd/hOx/V3SEvEDQBN+fC3ibjF2DnqRm1Wd7Wwe8A8axTiuChY79AI5uf9e788KpyHA3zf9QkItIFFs/Ben0iwlpWIcwDU49iqXfhLDUC7jcKfhzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=BewLp586; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="BewLp586"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-52d7a3defe8so7308061cf.0
        for <virtio-fs@lists.linux.dev>; Wed, 02 Sep 2026 00:46:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788335169; cv=none;
        d=google.com; s=arc-20260327;
        b=ZNXrzHtyJ5xcqK6GQJ+9do+ufc1P6OI7rnmUoY/zF6+7omkKIaR+u45Ll4jeZ2RfiD
         O1aV3kDsaW8bU0O+W/3NtRw3e7h9+zOPzuW2TF431jRNDuj/azK46bLoiCKLWqM+7YQf
         Gs8rJ/i+p3ooLRH7LMXJO+8CCVnTwXf3UcmAVqNJnaRmXU0ttK8dHHjgrfUvGe3TWVdM
         RwR1nUIwgeQTgE0MrCpWqGppdxgIAzSdqhjWWmHbzGD7C1FI9xeTxQ+DZZm6e8glrWs4
         Xb67EyEaRHm6BB4p9SOLDnubtccaf7EyHd4RaEjslhYxdPhi0f364cQ6gvbhvk8ctxfX
         DAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=IvhExhiWnI8V1WRxlxJqXXVBUw3gqvoomsk9oVMgNog=;
        fh=4RYEem5CTodqtsUEYws2JSXsNwm3HJ7ThofUmNBn0tk=;
        b=Q528LPCtlCWqMD+kkBHl3IPo+N+B+65Sa1VbaJUyzqOmfcxzWgbWdMJHLSFaMP1ISM
         j5s8e6VXfMYudXmc4z5rlBD6Trjd2fWT8Hd8T643Mr+pZ4A+jLGGtqAM0abVIrNVTUON
         Xe0yziO5bNZCbuVXVR0sgqgq2pOCxKmgxZwSeRjHf9J1/3EeAo14D3CKze0/AHh013A6
         IJI0INkRSh0B8rO0/x3zMDrfbI8UQO7F6TmJFBlbsRa9bkYXxuacjfCsSTONVLZcnd4v
         Y/nS6uFGE6zbt8ZqGLuvMhfextEsmn7WfL2RWr3dWqr1L3j6Q+vs8m/oZmBe57qqgoCB
         EIWg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1788335169; x=1788939969; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IvhExhiWnI8V1WRxlxJqXXVBUw3gqvoomsk9oVMgNog=;
        b=BewLp5864fLI59deg+/275iAUTRhS+A9MbGn9dCjYfyB+UAKIpbn2gQJOIO0qZY0tX
         eR6VzsSOAJg7AYrwhirq9+jkuR9ZMlpS6he0OmaxdfL7m94jBXjc4OKi6iJVF2OZBNIu
         TWnHWHAGeLLPAm+7MSkEo3jNMDGxtAG/BscRE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788335169; x=1788939969;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IvhExhiWnI8V1WRxlxJqXXVBUw3gqvoomsk9oVMgNog=;
        b=aNq+JIPhf6a0T0RSQj/7WlqmSa49n5pcPlS3rb6mEl8kxA7vo2znGwzo68bjhzSYIH
         VTeizzGreD2sGmCaJ/CyHP2YiQp++U8OrS9C4bhm+bbFthr4xU5o40KI9xibnvrSuZWp
         rWGNjbhb5csA+G3FpJZW6jAGw3iwRehpgLIyTEksT16T0sWJi1qTg9/1IniQejO7o2dP
         mdv970/UbErfdWp59KGXj8AbLefmXqZBkxa/uHeVjtBsof6eGzAGR2CU6qHxVsECmsXm
         BFnYS2b9cegO+yj9yba8zxnz3+4OjLmKYUKIAl94XTC1d0Yf+gGshm4wOZcLcqycnstP
         Dgng==
X-Forwarded-Encrypted: i=1; AHgh+RpvGE4eQRjvEcauGn8F7nLrz6OnLtCN7VZ7HltP48njJq1GFEg+tnetZNWD/lcCUXFSrHZF3iryQbo=@lists.linux.dev
X-Gm-Message-State: AFuF++m4E33U8DDlqWmW4qE55rxob5dzwuhpDvlxSx3powi0e8ggCYUU
	yDMTPqvy22NR0eK/YJe6CDTN2UtRx+doYujOb2u53GuK6TG/lNFU1GBoKDgB2bOTWLnkgLPtdtU
	RRI88wGq+wlxyoMNr5VMC5Qi8BbApKbyFS2MXYR8Ifg==
X-Gm-Gg: AR+sD12sD2/HIPMt+6kZLqnQxem0aBY/n9v88Yv0/iv1fI0prOuGtfGFe6Av67Chhcu
	bMAZVWbbvi8BXRMu08JCjukxomSrd1rZi7BRNP3qjEAkWrnn4wpGOX15QILRudM8PIU/Efqffgq
	oW/SMmNTH6R7ppOWrRSFxbfHfCL+5GEKYXTN37t+SndtLS480EaukUDMRRDtWUXnbLALMNkq9ul
	lmH9jnaHBzxKaWc2+1aQ7PM1F2twIM7Jlv7fzs1fbXasO5PnPTKwtwaA462ptgxEKVSxEcoYHe5
	UGdNj+Y2iEi8eRE77VAOzZZu8UaBzOfG07SPZqrqSI/GQTcDnbZwbd+Y4QfqxprO/zlc7g8GR2x
	WZYqy9fK2hhU=
X-Received: by 2002:a05:622a:14c6:b0:51c:f8f:13d with SMTP id
 d75a77b69052e-53036d70d07mr26470561cf.37.1788335169278; Wed, 02 Sep 2026
 00:46:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260901213412.1763253-1-changyuanl@google.com>
In-Reply-To: <20260901213412.1763253-1-changyuanl@google.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 2 Sep 2026 09:45:58 +0200
X-Gm-Features: AcwNN1UFf7VhA4ev-1okF184xxRRDQXQHWQimzIKZ-vmP1OFAqzs-nCx_0ZY4jI
Message-ID: <CAJfpegtWYP-q82428iHd9gOBkAmoB=mgfGZRs3oi2FiAm3W-yA@mail.gmail.com>
Subject: Re: [RFC] Handling 0-sized pseudo-files (cgroupfs/sysfs/procfs) in
 virtiofs and FUSE
To: Changyuan Lyu <changyuanl@google.com>
Cc: fuse-devel@lists.linux.dev, virtio-fs@lists.linux.dev, khazhy@google.com, 
	peternewman@google.com, German Maglione <gmaglione@redhat.com>, 
	Hanna Czenczek <hreitz@redhat.com>, posk@google.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Sept 2026 at 23:34, Changyuan Lyu <changyuanl@google.com> wrote:

> 1. For virtiofsd: Does the automatic detection of pseudo-filesystems via
>    fstatfs magic match upstream expectations, or would upstream prefer an
>    explicit configuration option (such as per-path cache policies)?

Why not just set "--cache never" for the pseudo fs export?

> 2. For the kernel: Does the proposed copy_splice_read() fallback for
>    FOPEN_DIRECT_IO files in fuse_splice_read() look acceptable?

Yes, in fact this patch has been sitting in my local tree for a week.
 Pushed out now, updated with a link to this report as well.

Thanks,
Miklos
