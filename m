Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02225435A8B
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263107; cv=pass; b=E+aIPGGYslTtLh+dtsAgDDtbU2DKhOnqz7janRqnwFMuM/RGHXl+C68Oy389Y87HaDwjEzFca9kbApjSzpCqxYs3g8RdNuT4LRHMNRztIS2m/x9Ct+AtZtSfxhgGkkZ97KkldgKwKOR87TKfnXIXmKpdQiMJoT5/oMXFehLRPSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263107; c=relaxed/simple;
	bh=gAqvK93gccsAbXrwlOxk+NIJQ7er4MXZYOm+0aa8ORM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eRHBM1yyg4Hi+61S2oss1+4GAL8gM3ayhE5s2u1726hArF3+PBjlGlK7RNBjVHrXO8nN5J6v1bi/zwrY+Vfe6VbdiEp78ZAaXtd4e8XOUiSC+sZZJeBhpF1wR+vPp6xKQzhmF4OzKl2zX47wum602yU7M1aAoUSXstDCUz79Wuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BY5WQ7Mz; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BY5WQ7Mz"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c15bf5000so812241cf.3
        for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 11:25:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785263105; cv=none;
        d=google.com; s=arc-20260327;
        b=GF4FTgbklGEOnGfERe7uxGrhns4HPIotgeEo5G1TmZCFqKzIU2HEDctz6/YtsOXjCV
         yTkT9nDr4m6kaFi9huLVrZ9hL8aJ/Iu9exIJRJT6AI1sGubKqKJ0qyIK63c/aW3Ngbri
         CA3tKPW1sWx5eT6C1Iv74V+89q3nGGFfcd4ITSCElJJYeXTOKM2uLtop4joKQU4CsLCy
         8s66ATC4veO4tBxjzUUtPsPv9wOow5RPILgbeX9wqfMv+gVGSeNdFJSGX/OBqlDeAANl
         LBANq36MO9uqX8roy72vt7jUyheu8/66G8fGzAA8PHPhjdfjjVsV7MZzZTh7/cR01JNa
         bgRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yw/O6SQwJLjpZ7378AMJ71CoM2jdC0JRf6nC/TAnmgE=;
        fh=uBAMBCh91hsrTpLqiQmyF7Vem8HuBkHuWOprzXgBmj0=;
        b=JZ+cMXPC6mzEtxKm52MMBTHw794Ti6uTULtri3m6IKdRDJUiKWqQ90SAUOX5NYW2lY
         4005MVTX+55gDGiFbWacAo6HtfxfYoQeLV5jHs3O3jdPCjy6xzW5yUH1yiD0Jrbnlc/C
         G/65IyRoeG5/S+E6B6JfApiQlrFUEfa8+MWTyTui0UyhmU99pbAGdJsQFzH2ElZYz8cL
         pcqUw4Y+AxygvNllJlpnkP693e3AS5gRBbjS1lnXEKrqsQG7+0zyOLFwl2FcAx9fcz6W
         mgPSvMo0MgreIvRCGuhvoUV7nhHQuTLYDdfYmZEYWWk2IsGaV9LgvdXQL61LPUazgpgn
         6frQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785263105; x=1785867905; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yw/O6SQwJLjpZ7378AMJ71CoM2jdC0JRf6nC/TAnmgE=;
        b=BY5WQ7MzHYhp5/n2FpoT06yT9wHDiqzCX6QvNSd5yWilKXJ61IV1aqqkhrGTVb3Qxp
         gqs1prVQcHAdfZSrfx7pU8iSHcxkhFrVqiIljtOL0RjlnX+5KMK9aHns0D3WpIZXeaeY
         gfnjUnKKJ2N7//jig/rpNCTk3rUUvHGY1dcIopbklzaY0NlE03Al0fTejRr2WdpBKcD5
         KMeHaLomU5kwZjiA225kJmS8oqu8ikAlMTFR9fZ+aveemCawEDPohPRKdiwPJ8q+/X4L
         6rEE3b45rq3RBYICNsefn9MspxZZietbmKeBxKHcEjN3Ihv5np+fBULngjv0a99/PcE9
         NuZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785263105; x=1785867905;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yw/O6SQwJLjpZ7378AMJ71CoM2jdC0JRf6nC/TAnmgE=;
        b=lTdlBJ2vmqukovEVzP4L2hMJlG7qk+3YmhjHXt3rjLAphjnd3nLrZs1YmA8blKLdqJ
         pJvipLrxnglUp35EnNvXOhSL4ockF9FaJF2ABO1a0otXy+rym8X/oIbb7kTXgKNzIaG5
         y9nZF6oUe54ODg2fsLeFMvpbSSUqrJAhiJZujxtjq6K1BA8zWTVcj4X5nhmwSyiFCw8z
         EvA5S4T0BtDufPT5/30Oyk4Ij5svRfdgI358xFW0dN8Ow/IIm6T6jYweOgPlYTrvIo/M
         9T3lRdhrMwIZpiHv/Khy7CCi8ohS1ZaKF8FL0ZDHGE1VMZuQJR2B2t6r6UtmBXl5oafV
         ExLA==
X-Forwarded-Encrypted: i=1; AHgh+RpkdZDBhJD5Mv+PRqdeEZoUq5CBa1mL3maIAQgfN40Y0nNlsYZ/cxhRbw9qEXH5/Dzd2Ob372MdVT8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8/E9XPHxKwZaZKLOTxvbcHXo5A5bwD1cvT+4n5FQ9DYbqQDLP
	D5q5kS+0VhnTMl+sFzWFktjLfKje//StgNaWFOjJH0dEsPP+h39UgXSSgEs7zG5N+7Ybra4e7Js
	TZZIiY3n/RMY++vBBtZZzKA0ANeK5M90=
X-Gm-Gg: AR+sD12KkpQVoquHN2JBJNFUd8Ymj3MLSUGqMUU6I/cKNuh1+0aizguqfLeo17rX2G2
	hC94Mx//ixo0CCqjN3zpb6+Om+KWmmiSot3lzKPiVa8nBoiK+wfPsoB23Nm48f4AnwcMpVsyo30
	xpnX+zRytqM/Y+z+K/J1w+hc20A99+a65hGgeJ+jsAsrPTGhhGmoWXIhzhr5/rBgsalLYavp6M2
	Ajo77TtCb/7S6tQIVEleHJ9aq1Dkmv1jhZhLTBtdINRW7xGNWswjwUbqGRGsqR8KuVj6t9SmC5F
	2aI41s9b+i8vJ5YzQzoB
X-Received: by 2002:ac8:5913:0:b0:51c:857f:9c12 with SMTP id
 d75a77b69052e-529d6f9df1fmr34798741cf.4.1785263104714; Tue, 28 Jul 2026
 11:25:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com> <20260727190757.GE371693@fedora>
In-Reply-To: <20260727190757.GE371693@fedora>
From: Connor Kite <connorkite@gmail.com>
Date: Tue, 28 Jul 2026 11:24:52 -0700
X-Gm-Features: AUfX_mxdl45Zem6osR1ajKoHrgb8A0mkuybo1B5FEZIrW6w-mTKndp87VL8pkVw
Message-ID: <CA+spn3pPNuAL=6qAfN7CGXnitoudv_JD+HUna+4cU--c_qoN4g@mail.gmail.com>
Subject: Re: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
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

On Mon, Jul 27, 2026 at 12:08=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.c=
om> wrote:
>
> On Thu, Jul 23, 2026 at 03:30:05PM -0700, Connor Kite wrote:
> > Add a wrapper to iova-tree to call g_tree_foreach.  Provies a means to
>
> Provies -> Provides
>
> > execute some function on each node of the iova-tree.
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >  include/qemu/iova-tree.h | 13 +++++++++++++
> >  util/iova-tree.c         |  5 +++++
> >  2 files changed, 18 insertions(+)
>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

This is fixed on my end now and will be included in the next rev of the ser=
ies.

Thanks,
Connor
