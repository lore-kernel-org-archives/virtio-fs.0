Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5CF3290B9
	for <virtio-fs@lists.linux.dev>; Wed,  5 Aug 2026 23:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785973402; cv=pass; b=sUWZEUG8ZuNKi+6H9lhLlOvgQ2jjakfWqQJzwk4jgnQGLfMaKZUzHd3yKzYNwXWhdau4V7fSYxZL1dYfRx2oEkAfcG1CLbgTCq12IVi6Y+VRLfqqp4S12pzR4h77mMiLIRiO5jeZhOviY6edkdsF48pTM2Oo8+mpKwqGREnFd2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785973402; c=relaxed/simple;
	bh=ARMMhLCc3nzs4UBjk3UYz30NETeDzPnnKvs8QQVwhXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F7I1cza0/NPMt8urRedRoEfe8Ufakj65YCiiZOZHW7TloNgPLrMl/uvfosibbl/eXBKub+0+mtDzdXKtlsYDoRWL+5me7LeVO893YMo2BT/QzZgdX0wVuBNp9Mwh3lRMQwgxFLuoc+wM91xATP9SZ/dOaFvUsmcC3VUxtN+ozQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MR+p0Mac; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MR+p0Mac"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c2a76536bso14511581cf.1
        for <virtio-fs@lists.linux.dev>; Wed, 05 Aug 2026 16:43:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785973400; cv=none;
        d=google.com; s=arc-20260327;
        b=r0gsU0+BU/mA8GXNcEI4yWUYLfcWPPadkCaTnN4RLX6hS5rJGqXEcaZjWKueB/jiqh
         6kOYpxhtN3G8zDC/7NzW5/9MOCMrHcriCxrtr6oHVcfktuKHZNMDihqbErskaD69Miyb
         8aBGPrwggNeWhIMREplAPgL4eEOCTX4Jnkvp3J+U4U7Y65g6U+dNQhl8pfS1XY3ztQvU
         uO0ygJP17+wi/tAwWE9liQatMcpSTGCc52CICAWkH0enQ8tmKMI8Gm/mLLGSOAyyTPkB
         nyf7a4406uOvJD+YNvQSG/zsKmgsYIOvYRbVG+SgDyfhDMkpoZBydhGUb5HPDyyEHjIT
         QmVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xIJW997ztiLIhHGWA4IExsY472xyxS4LNfDtfQost7I=;
        fh=8IVZO6O3W1NcF/2K3nX9idu3z+gsUtVh1HM5uA1Fl30=;
        b=HDwSAZ74kqfJO6dKyVfB9uYZL0HRQ47Vu8XSsEi6HkDu2KM3vOWYBGQuRr5+skn7gJ
         qH2Ru8pWGFdH6yuGSd4lLuIYb1iTWBBS0RK4ts5tMcIbhj5cS/OOGMNAQQoA9lIYBEyB
         3ax062yTBxs0m2zIcjl6euv56VUMaHzzHi77zJd472klKOkB3IjhjWJvixiURe28N8BF
         d3ocKhnERhVvA0fmKe7ZOpFJ085XE/hOzyekkJzwR12/5TXDPLLEO067TGmMhGGC0wCd
         rNlTxzNoiWu7qBtHYz/362z001rC9YZ45OJb9sd8QcpfZrBPxnGd+6Kbu39vKWYty0eQ
         0+KQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785973400; x=1786578200; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xIJW997ztiLIhHGWA4IExsY472xyxS4LNfDtfQost7I=;
        b=MR+p0MacmqaueZ5f9x3z5HQUCvnq81WV7QmhpEkdGjoUGoH2cX0+O7jhGCuRaaUDLs
         jZRKSgMfogLNqqeMJ19KoNn6DsQMMkZQDjVxawxDOxAEXEy/Goz9TcuwKfaDtQo0/TIq
         0R3DCXr8QakMhz1jxmfRB3BtaCw6+EuCvAm+Ob1cef14QisFDyZ8j4tOMnbf5a/jCPPN
         bSWgY/JVKJVXLfthflRpSgsOxfvyjUHFUL2OOvfGnwXtIEROr2WBwpgQCme1UAPKHuAg
         YVJgdg3NeIyAbeBuTpgElUxZOPeTngasordoAWPpD07GV6NFt020lAiYjwDCyXidQOlp
         IbRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785973400; x=1786578200;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xIJW997ztiLIhHGWA4IExsY472xyxS4LNfDtfQost7I=;
        b=C59sYMZOAAmZZXTRtzhBActAwWxgiv8Qyw5H/sZQ+47bKTJugAcZzzPCChMs74HYu4
         I0oewj+P1xU5+KuRaphpwim9L02Tiv8zOb/yNH3ogIpmIlGl67XnDtHAOp7mZprY+L21
         l/WzjQj9sKxE2SHshIGd3WM6rVcJSO4GSW4PZR9KtfRQ6xOMpOHlx8zhw35WQ8Odyj62
         CpKbocWiZTcwfHnXzGAUKGwlgGaOlUwtw7Or08BMJK69+HDvTVcKeNkF8g7P/8/K9JlE
         u+Aa3Yv7r0uVf1YWL3uWq/LNG5ZKR1U8bgJkW378n2XCVyZ3rqRlptD+nmOZ+KjZOKWF
         LZ2A==
X-Forwarded-Encrypted: i=1; AHgh+RpHIX+oh63PqG5uqvWh6TRsCeW53eMYR6jyrn/3hkwgrXc4JQYJHyfxT4y9ps2H4FyI1Lxr9Y8AqvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwopVwLLsAvEpjgOTHPFB3moqUPamIk91qQVODHnLEC/Kh6xxhZ
	jzKDfBeWb55CBLDLPzYf/q0NgDMT/JB8KXYGyBrS4PECNooa6zthsDcxWe1wVkswr5GFR8nBiBL
	FXPZMMQzscJGZfOk3dCIhnd/OYxxKcp8=
X-Gm-Gg: AR+sD11HIkjaA5/C1hNPGL1H1hHCm2Y32mvYZJFL9cqaCOKkTt+I4EwRnQsfjyBsCAf
	aUWnaJbEY6au1UGzPtGiGSvxHfH456kyF+aI2moGyW5rGm+WK+oO21AAZPJkhv/VpRBWITo9e7l
	6IIyQjlGRK0fHhs/LHRzJPT7Q/Aqg0xpJ16E/I9J2OaqQXQDtJ/8MrYmS5V1UvTFmymKJdEgL8W
	kY0ftjcf2tqJWjkzB1DCuN9FjQn7DU5sQLsd4CX8MmLtn18YcURwQxliyOahZU+zWdyJ1/s2Aa7
	KgoPdQHpLvCcA+76n2/3YguHUVZT/Twi0nEXtwcNI6G7xdM8B8JWuzMRZGLJnlmv8PhKERsNrlA
	m1l0=
X-Received: by 2002:ac8:5a91:0:b0:51c:1ff:2512 with SMTP id
 d75a77b69052e-52ce61a411cmr105675181cf.33.1785973400069; Wed, 05 Aug 2026
 16:43:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-4-6b97c439eb28@gmail.com> <6f915ae4-f9b7-4e27-9c3a-3a99917b499f@redhat.com>
In-Reply-To: <6f915ae4-f9b7-4e27-9c3a-3a99917b499f@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Wed, 5 Aug 2026 16:43:08 -0700
X-Gm-Features: AUfX_mxPQyAbn0_F9JssL-jejkCyVtJEtgg98Zlrxpmii0NR7zZ1YyRDcPcZAPA
Message-ID: <CA+spn3oXmgk7_LMP+hZRDPRTQX8qm0uBGAyztsq+Yu4_d4_ZKg@mail.gmail.com>
Subject: Re: [PATCH RFC 04/15] net/vhost-user: add memory isolation
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

On Mon, Jul 27, 2026 at 11:48=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
>
> This is dead code (hence G_GNUC_UNUSED) and is harder to review because
> we don't know how it will be used until later in the patch series. I
> guess vhost_user_init() and net_passt_vhost_user_init() will gain a
> memory_isolation argument in a future patch.
>
> Linear reviews of the patch series are easiest for reviewers. Please
> reorder this so that vhost_user_init() and net_pass_vhost_user_init()
> are changed first. You can hardcode the argument to false in those
> patches. This patch can be moved afterwards so that memory_isolation is
> never dead code.

Now fixed for the next rev.  This and the previous patch are swapped,
with hardcoded values of memory_isolation used until the property is added
to net.json.

On Mon, Aug 3, 2026 at 5:27=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
>
> I have a gut feeling there ought to be a better way to add an option the
> only works for vhost-user, but maybe not. I certainly don=E2=80=99t have =
a
> constructive suggestions. :)
>
> (Apart from that, my only comments would be the QAPI =E2=80=9Csince=E2=80=
=9D field
> missing, as Markus noted on the previous patch, and the patch ordering
> Stefan has noted.)
>
> Hanna
>

Added "Since 11.2" to both locations in net.json.
