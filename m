Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13A73CDBBD
	for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 21:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446918; cv=pass; b=EGl9hfP50EvJMkW/7sFIkIUTY/wecoYE58mZOyCVRkfJ6qKiSCjVNUj89gwfr6ovQmOWvpqUlvu82wAVJnzQTmn40N3ffGTacd1++7t+C0Gu2XQ3GT/J2lIRt6l9NRdgRTw8KXrva+lrX+sxHiMqNx20Li21MUZT3/WOcaDXUbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446918; c=relaxed/simple;
	bh=ICsiHyGi4ddk32IDh6/2Ix77mm5g4eDlHXegf8TDsho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZEP0FEh+2YlsPbD4NUc+MK/96Q8URVMmkrMVu7y8xoMffU/ZLb9mZL/Hv2TypPSpMyxZq/mIA18RMwnkYc0zeVSKmAf0u6jOGQeoDpryALKOJw1lzFnI0ZrpqEJwU821v0IznInOzOxfFzYGeEBmDaPpLhG+pTYVIwUoEYRtyBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n8E6SEnA; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8E6SEnA"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51bfad59921so1670961cf.0
        for <virtio-fs@lists.linux.dev>; Thu, 30 Jul 2026 14:28:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785446911; cv=none;
        d=google.com; s=arc-20260327;
        b=hcLqTjwDq5Q4GK5YlAMSP66++MAhd3oja4KckR0cnfE/fdWuvSW15OBwYBE7idtkce
         K6zGQmmei3kMu9D/VIbDjP7un2ZiqVWP+H+t0K49ODiAB7Cu3E6uyOK9G1zfuCK2Fj1f
         gj1yJjhRT5YIrqd01xM+pwhV/NO/NeQAN/j13tixsarm4/yWfUF4VBFjWov4LXycpODx
         wIdxJkHRFyTZnPvECUDOUhAqpKIH/WprunAXz9Gg6qZqKmF2T83gyUhFNsEXy5aWVS1X
         nCj8lV/LvTx2tlECYIqXU+pStLni7eOlye6+r7SiPmIZbK0PYk+k+Ub/f1cC9pV5tNwU
         SiYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8U5244hAigndAEdl7eLC13olLEushepCON12adQSRDs=;
        fh=8Ez9ukQs8h3eafJaYDCVG7ykJtXSyhMW1tCexNFNNyA=;
        b=U+xXKg7hkW71CxVibxKBv1hJ+jc/cJ5ueT+I6APWHfoo57BU/34jWyKtPgOxF5/267
         8s9s0GZafaGfyECBmBCzmnHcG7wkpyxZTPSiwxyM185yNr19LjqykQ9TYGnHbfgxPYV3
         2bjVX0rY0Q55ErpeaqC7MRUJnZd43nhU/rZpD7w8cEpstrjMmHLlczd5L6hFA43zibkk
         1CUmtueJ9NKO3RO2kWaNojJJrKfzxkP0vW7doOhE+4meV1BZLCvK3CoLmtk8ugTorRjl
         cJsL/JYJDGGbr26+QNwPHp2Hv8rEosQrB54oxAmGJobjOB1EKK8fEv13tRpr+R0H7zmp
         x2Dw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785446911; x=1786051711; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8U5244hAigndAEdl7eLC13olLEushepCON12adQSRDs=;
        b=n8E6SEnAdaKi5CLmAobTYH3+pG5N5lZeUernYOWzEaupCMoiUcGjnFaeq+gtk70Q13
         YzistsvlYvbYJJKzc82xT/pW3dNArX0zocS+dbvb4Vgdw4R3dT8bjfgEu0+zgW7+Mi25
         6RvXitdL57ABziuaCqp3JSisDwH8QynJBszTOS23V8kuf2ZpT2C5Kq9fBACDKeKlqDTS
         VThXfQjkP7elvHrw2WfEUqZpkQUNFrFcTWcHkWC+3+1RBtuyuORglSrnlJ5vfMB/SZDX
         AkYKs14pTSIx/KQeKzJTsIVIS4Yl5w9PO7utcwXB2PDhe7rnv1/q5LLJdcpl/GFGXT8H
         ySRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785446911; x=1786051711;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8U5244hAigndAEdl7eLC13olLEushepCON12adQSRDs=;
        b=Ouepyer3lPwrlqzuyU27WXJbqpt6Gvz84kKVn82nS7h5Jf6FmeCLDWsCltfCgggN1V
         NWcN8Zz0eOq6UhhrBBD7YGjjYafsMCly9+sJO5r6vZQgL58GXzrNkzVSxMxMFSYflVQA
         eBmAt11P5nLMUGgwd46zyAuV0dzj/N5Y396W5eVGrxFI0Ba+Yt+0aBUbTmNRAMUEbtJV
         7GZjBSNvXtBr+KS8VZHwSl2pIi/YdaHYfOUmQcqQu0gOOM4njR/gBijiuDbrQnWUbnkn
         N3R1vdKnTcWEtn5z1xMvSy16CgX1x9wipUbDEQP7ua3zT8Cmbijr0YrW2awF7w0+y4H1
         1WLA==
X-Forwarded-Encrypted: i=1; AHgh+RrfVqVp8SDbW9S82lk7arBMTcw6gW5mTA8NYb8ZYSNepLf881K0KXz6PWo4MbAXF2inwmm2TVAUEZY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzgBlbRhjb+++75KhJDFITicWGvJApbd0KPZ27LM8xlw9UXUTjv
	zo/Elx8q42mLFG1jvS17SoCPvUrskVKHMKM9eWjAkz1rMWGs74KB0y4qSiHHHa6aE+PBrj/JkgO
	ZtzanpGcZNaI+URWkJNSAqO8Hjk7BA3w=
X-Gm-Gg: AR+sD13jR/yG39Yl59nRXHfeuqDCfeFA6dJSFSIPTzDecWlXvsb39OYYV78sbUXmHU4
	QT7LYXTJKrQHYFWarUG9AiGFNxNVVpoiOzVs2zGx/WyM3kwJtnGZQEq5m9XW1HB5l6i8G5N7YpB
	YPHF8lQnkle6tA/aprCvhaq+Uu5IqpZja3yI7EYdSKN2zWI24HrMvSPVzgAsgFsPdQsygUrnTDF
	BEOiH/LbzdKM55soINIppE0MZXJeZEjhvwe2tnG2sRiZDP9BgSgW/pZLVLbfYhOKaDk9ut4zsYE
	yuiGDJvJBrPWWt1SHL2Ssbx0k1lfqIuibhW9w27TJ8p8zYoIIdkLqS1VxMexkqM7oDUKW1RYvQ=
	=
X-Received: by 2002:a05:622a:248b:b0:51c:f3:34e3 with SMTP id
 d75a77b69052e-52b3849c151mr47267131cf.28.1785446911402; Thu, 30 Jul 2026
 14:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-5-6b97c439eb28@gmail.com> <20260727190604.GD371693@fedora>
In-Reply-To: <20260727190604.GD371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 30 Jul 2026 14:28:20 -0700
X-Gm-Features: AUfX_mx1j5MBaUGOE6NKwGCPoRQwCG8zc56N5iSyDBsMPzBNCOI9mFAWQ7QJtrA
Message-ID: <CA+spn3rAiRCs3KAL55-qCJVWzUX7p+riyLW2s_dqKmS+tbX4jg@mail.gmail.com>
Subject: Re: [PATCH RFC 05/15] vhost-user: add memory_isolation to VhostUserState
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Haixu Cui <quic_haixcui@quicinc.com>, 
	Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Milan Zamazal <mzamazal@redhat.com>, Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 24, 2026 at 4:09=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> The signature of the stub for !defined(CONFIG_VHOST_USER) is not
> updated, breaking builds.
>
> Regards,
> Akihiko Odaki

Good catch!  I have fixed this in passt.c, which I believe is the only
location affected.

On Mon, Jul 27, 2026 at 12:06=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> On Thu, Jul 23, 2026 at 03:30:04PM -0700, Connor Kite wrote:
> > @@ -73,12 +74,14 @@ typedef struct VhostUserState {
> >      int memory_slots;
> >      bool supports_config;
> >      bool supports_inflight_migration;
> > +    bool memory_isolation;
> >  } VhostUserState;
> >
> >  /**
> >   * vhost_user_init() - initialise shared vhost_user state
> >   * @user: allocated area for storing shared state
> >   * @chr: the chardev for the vhost socket
> > + * @memory_isolation: disables device access to guest memory
>
> "Device" is confusing because it has several meanings. "vhost-user
> back-end" would be clearer.
>
> "Disables" is also a little confusing because the vhost-user back-end
> still needs to access guest memory somehow. Memory access cannot be
> completely disabled. Something like "restricts vhost-user back-end
> access to guest memory via bounce buffers" could be clearer, but it's up
> to you. We probably don't want to repeat the full explanation in every
> comment about memory isolation, so it's fine to omit the details as long
> as there is user-facing documentation somewhere that explains what the
> feature does.

Perhaps for brevity it might make sense to say "@memory_isolation: restrict
direct access to guest memory from back-end".
