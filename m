Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C610459AE5
	for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 18:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263455; cv=pass; b=ILoz1LFfW01uvGcADcNkt65iZEoLU2pMfbKQxYMAvasljh2Z5/OTHDg3WWzZCU1k1tK19UMPfWrxNJ8KuJmn9y0Si2/J8o5rR8N1aHuXSBOYtmeWMQ4nUvO4n8sHShEwSbH7LeZBoDGOXloh+PDzYE6oaR/dyGC7gL9jcfS+lNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263455; c=relaxed/simple;
	bh=L4hFpOdjenD5OV2dCOq+Wa8hv0asqxCOzVyOz5Gf4CQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sqaTCWREEEqcfQ9dck8rtei+dedUHEBwNee7Uxuf0fqIgMzPF/PlxJ4eTYiykdgX9FIqyvSinuj0sHm6CqZiZ9tyUiV7TXQL0T0lMxoXpsB92csDFgqFSTa7BhaPl+kwrCGVAJJCz63tvhUpYgQ6jmcQHW51PuFV+w2Dw7kfzJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXULrLNb; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXULrLNb"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c01089e8aso1099411cf.2
        for <virtio-fs@lists.linux.dev>; Tue, 28 Jul 2026 11:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785263453; cv=none;
        d=google.com; s=arc-20260327;
        b=ouGBWM9aoxSGHeTQV8IdTU/CZArnbOqH/D6cTELPkFKqOwTu6iN0z4u4hsMA1+0k6O
         LYxswIrPdLRGtPE4GckSuKVy848QwNNA4RZ61DBVDWA/mwaWsUDiZreimgV1LuhBKNHC
         XXnqJSgWJdqDBl6i4NcUa7E0cHJx/RC3NJgH2HRDmfxBNvyumxp/AAfXm0a7YCPQ15E5
         XZfsqTnDLJ8vaoqAo08JZz1WvrHo+KLZrOG4gc0OeH9qBqjR8gxegpo7dQHZU+roEkGv
         mMNprSFmeFyj3YP2QnJ68+rB+AyrWoshJT/Q8zRdLWcEyhD2P5lvoR6ZxuAOKeyJoJFY
         ezwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L4hFpOdjenD5OV2dCOq+Wa8hv0asqxCOzVyOz5Gf4CQ=;
        fh=rmyOrcnT3aV7ZYrI0fc95wZFQr4O0cOn3h+DM/S5yMc=;
        b=Jt9+dAnQ041CY7+yv6/HCc/zRJUXK4eY2rWXVMOGMgyzWNDvJFioseZJgE4rqSK3L6
         P98x2j24hGeDCDS/rd60ewQrrYMZm79FeAGJjlan63VxWvJhtzdo1PYc8KSdqgrGSx+O
         Gq60PZJFcPEVo3//oBXi1PNUvymRncBNsEwfc+AEnJxXuuu+wee1QlpRnjqNFTygRAb9
         gBVddkQ3hwVzreb4bigKiytn1s5BZs+xi48uLfL3btjwG1X3Swqz9A7VRcn30fIYoXpS
         Nb08Taoxd/Q86j+Jg5WSq/zSuivFuikOZz2wLvekb4OiBQidg0wNItNQc89UcdUuIg5b
         XCXA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785263453; x=1785868253; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L4hFpOdjenD5OV2dCOq+Wa8hv0asqxCOzVyOz5Gf4CQ=;
        b=iXULrLNbacklW0lXUY2T56g+t/Pe0DzykKx4eOHvzuYrLOGDgFEy4Zt6YbMl71cUiU
         IIpUqc9CeT9l8DpQAI9wPlwYxSqnPygaxTrJtYNVFouK47GUqs26OD+DvpwV6NoMNBW1
         bd1V7KD38lDDlitSV/HgfPKKV/gzKXIX4lSK4kkL+XWyvwGehOzstoO+AN0LFAROZdIR
         SE2y/hsfAy9GmRCVvM22W+aHa9Xbwnkd8Ca282kSaRphwRQk/5jFNQiXa2VYWP5RY+Gp
         MPVjejU61/BQeVRzJ0owBDAOw9IN5pD9r+oiOXyzFjStDDSVfp1gZRzx9hKtoFdkJ4jY
         sGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785263453; x=1785868253;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L4hFpOdjenD5OV2dCOq+Wa8hv0asqxCOzVyOz5Gf4CQ=;
        b=BeNzef41h8o7HSpPI7Fs4z/+MnBMXmmQLuNKQSyevfZoE9BQ7IKkhTEVlltE1ta4Bd
         JX2KLLBdlR8mAtEc9X+kjVVR8Dc8iGhE/Yok4XG/uJgebSLfUptP7zbbV/AnmgZes+hd
         TaUfw7kcQlu13tmsVT/giIS/9+6gaTMgoJsPNjXLCvG//VESpXd2Se+4VVYPmzH186Ur
         YfV6xuyx7BzlrCU2/g0Cp5cdkZ1CDp02mK1Qvvfmp41ZKeJj+ClSwTeXmImoKB0dALCJ
         VPNrhFyMsr9DGxhF4YAyEjDU8/D1inoaaiEt4hbPXN/4BcqBKKdIsB2wgdt4KBEbdVyo
         6YlQ==
X-Forwarded-Encrypted: i=1; AHgh+RpaoG1O7Py/Kyf2eVFdW9nlEJvmksis44FHENHQczVnyTIA78c0tgVlQOwWr4lk9jb4pIztBcjmcEE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyqyj8Hhjok3ng9ChqShzUDWan/fRgFq8ME//fijvOTX9CVuaoN
	g5CL0eqhfRFs4HetVknhIng8SpYIEVhzJFdOxpiw6m0apShV+Vzr+KqhM5KNThe3hnEAIPAADvW
	fraHMdkx+7+qYynHhowdTIS+ZwNBDOlo=
X-Gm-Gg: AR+sD106FnVKjxluWYcMLswpAMoRF4Yt/B+RjioFc1RMRAscVDg2DH56V9CqGTRbKKD
	EA2XkfxrAsM+mvrksqd6kL0kuWzPxSTLV/8BPawR8Qefve1H1ebeWjNoVmwUD4fsVRQi/fvJnb/
	WibIq8B++1LCVuSBhSjAL2Fhn7aHdM4txUjNgZxB3oeToQAcwHMGS2kua+cZfWdYOfVOfvGvWs7
	5waf4DbhhgH04g9vgnKfQsn8McqENMfrQ4k+gD6uol3b//WDzmQgyz4f+DuQnWmsxREmf4/ajwk
	0v+VwXH06bO7P8qKEuDpp3G53mS7Dok=
X-Received: by 2002:a05:622a:5b04:b0:527:f0a:ccbc with SMTP id
 d75a77b69052e-529d70b6cb5mr32460691cf.18.1785263453238; Tue, 28 Jul 2026
 11:30:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-2-6b97c439eb28@gmail.com> <283bc630-2538-469b-a296-7da57d2e4c3a@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <283bc630-2538-469b-a296-7da57d2e4c3a@rsg.ci.i.u-tokyo.ac.jp>
From: Connor Kite <connorkite@gmail.com>
Date: Tue, 28 Jul 2026 11:30:41 -0700
X-Gm-Features: AUfX_mwW719DYHtdwo6QFm09jpiQQxLRyjTxCixfhvRfmX2uXr1nq7-HqPgd6Tg
Message-ID: <CA+spn3pModAB5vom-x16hLbnUhR0BbMqfk3aX7KK7RZ5SJ8jMg@mail.gmail.com>
Subject: Re: [PATCH RFC 02/15] vhost-user: Add memory-isolation qdev property
 to vhost-user devices
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

On Fri, Jul 24, 2026 at 3:57=E2=80=AFAM Akihiko Odaki
<odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:
>
> On 2026/07/24 7:30, ConKite wrote:
> > In support of future work to add a memory isolation mode to vhost-user =
devices, a
> > qdev property, "memory-isolation", is added to all vhost-user devices. =
This is
> > simply a bool representing whether the mode is active or not.
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>
> This and the next patch add interfaces before implementation. Perhaps
> it's better reversed.

Agreed! I will move these for the next rev of the patch series.

Thanks,
Connor
