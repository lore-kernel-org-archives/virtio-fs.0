Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9255B34CFC6
	for <virtio-fs@lists.linux.dev>; Fri,  7 Aug 2026 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786132189; cv=pass; b=sp7hWfohb3IPMwDxMp8AMVEDmKpUoZMfjsbeAOkjE79Vm6BTyLb3oHQeRHuAMjMf0ejHQQDt8VN40oMSjJttWueOyAoGqZZ06elux73CEjioS+hyT/mrVMW91YVUjT2W6JVVSpqVU1U2D1UPBP+r5NOjpEVuPlIutT9pPftkDJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786132189; c=relaxed/simple;
	bh=RMEHLe/jKiFlDSBdVolYnR71XD+CkKKG9B+43Vq5jio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0Vq+QKZ+PzjUWpV/vKGnGuOQZrNZtAv5S9GEX7jyGOPO532EO/uCjFR/UmDhcmNrU2EqFQjDtVlYo01Fqwf1U+4o07FuNlITI+ObsUtu21XPWCr0edaTCZRshKu+56BEasYriG2rnHqPmx7YzvqM51y/maOe5a/AZ9SC991lHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WfO1H7fo; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WfO1H7fo"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51e4ba1cfb4so24363251cf.0
        for <virtio-fs@lists.linux.dev>; Fri, 07 Aug 2026 12:49:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786132185; cv=none;
        d=google.com; s=arc-20260327;
        b=mecEDvKN21i6ZjRvKrFfKGeNr1gp7LFi3HxUslfw/KH544s4+XXQ1s5LVr6O/lKnLy
         /lrKxLgfPhMGcBByufLCitHIWa2AopljcdhDlZ/D3fAYHY9q0pB7Ma6HLMTHXoW7Fa+v
         SLsf5ANPBP/p6DFBZn8gVDVeVHEqx9BN2UGaOcBgF6EBXYEOaHC1H0f4jhQ7t+HyphEY
         U5kuodnfuszvB8OHTr3SSZjF6SNfN4UgeXkm3Gp6xPcQ9w0pfFKMmU/3gCCOMtaLJdJx
         /UC/mBYyRuBkWFfGg4SvLqyVyG0ug+mswbV2Czs4bv2gn94VdcmliSgHorMlk3VlvicD
         /MDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oa2+1M11/amWz20nSf71eFbs+AKd7wmkPXqSWC+J0Nw=;
        fh=izHJjPHghBUVWa6pXMuL5uq8D/DempVJlCmEBXDOw4Y=;
        b=Xz/d5QoqbBPGDxzfVNIUwP4xTg+CnswJEu8FIH796xni6eX3jbz4hMg8E3oTUDexJv
         OBr//LF+srtlFaF+P8Oh6rNh9X+ACIcMeoVs8+ECjWkrs24SeGmpGUh0roIzdxAGuNEI
         apWpu5/CS95iIMYmLd0++qzZPWQy6DqePnpAFDhzWAWBKfIJ30a5tPvU3IV3E+iihkWN
         rx/OKh+BS3f7jzPNoerBPacU4c5VX90Qj29zFscDU14C+faJ2e9zIQAU+YvIV2VRfOaK
         0lwJcD8+ZwgOGUJmsxiQOZgWSExldCJEp3OCWOJPeThidDWnqIRuWcWAQDRm9NQ02WWD
         yZ+g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786132185; x=1786736985; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oa2+1M11/amWz20nSf71eFbs+AKd7wmkPXqSWC+J0Nw=;
        b=WfO1H7fodcdVNlC/14IwW+y7xjiEf3HRCCHak0yjUIVHhKpxQcuUE7YZ6Zpopqd7WV
         0WValqR638sb7yz7DmjPkeSCdrbxtb3Lo/kDpzEjNfrujIT2FzrcZWB+zujZom5YOV4k
         iggLEqojxY9oEjoww3WeWMkBfxdyNhm2E853GaQhLWFP0sK8KjdGCyaEAs3tt3GHxD9U
         iCqWc83FSulpJryxvYSafkc8GXj1bsnTWha/TeqEoxYzJedMezn6MuczzXIa13O1TBH2
         kJ4xc/woOHkRyqaNLIGNdqxSfW2b7y/nG1EuRgbNDrF38pq0udurg/5Ax3GmIBP+WPkG
         /aBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786132185; x=1786736985;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oa2+1M11/amWz20nSf71eFbs+AKd7wmkPXqSWC+J0Nw=;
        b=Ts83xr/hS8/ljb8NJXfUJTNbcdHQHhYK+l49fDk2wSENMNMksF12efKyyZfDxpCeeM
         O1VsuNN3aKjJJR/FdbHw+Vb+/6wB3dvFb3drn/D+frlgG+/r1crXGjZlXBCGfD0klKVX
         aSsS/Il0tlg5HCbOSm2ysoYtw2YJQ2wYpcVOCIprS8CjURGrgyaLlWNx+9dian5HRM5P
         Tfs4sC7qt154iVwn8TxiefIDrP8hBBeZKAEnpBOYZ9RwglAjB7JUYvwiTCKpTYoHNc6/
         yjhSe8z8EvQwA2yvMXnr/NFuMH1uaWegbnoWaWWaggWrH9Oy8QE07fHlu8mtloxhoaKe
         2isg==
X-Forwarded-Encrypted: i=1; AHgh+RrvWKcwuTdlbFKiup/da9FQmJzBfSFXdj9mGL9fz9udAH57XFNGkJyCvii+5JaTRyP6Z0uCp4yg/Qc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9GR9m8ksrxwnUVsveTl5p1aokgfVw1+9Va78ZR/hJXhEx+im2
	K3DpACwKxCakEuAkAJ4Pb0uRT63yNzcHvNlXN9ralv6B+XB9pxHKocF/IyGdY3A13vXvGZRPyI5
	kDCCWKnpZDG8r6wofgVz7D9ncXGkImH4=
X-Gm-Gg: AR+sD13PxrE0BgPQWu4Hs3YKUd3t1ENITpfYaWCA2wWMqp/BZ1ipBui4siwgcLK/6mV
	xlOV0VX+KQgk1a8UR6U4frgkCXWVttBPXmoP3adenNEvvkoc3Vj9ZwEaCBLfKKgZtt8E5dSuJHw
	7z3M/35XGGc+E4TF1l5s/dVdY0TFB5iAFcxUEEvEOJ2g2L6WvbX9o8iTFfTmUDZKoSW8+4kzXdQ
	VXH4iNxywy+3F06eFR9L53NkH0Lt7EQEtQIyFrdHteAGVFnKkM5B5CFQ7QNRVy1v7PuWcdSepFr
	Y4L4QkSOae2UaCISjbTciu6Dfh6xLopXNnhU0k2wmNFVh8+2MQsPoXJKuC8Fqug2AIUrI9S8hjB
	mB5WuRSAYIS1LjQ==
X-Received: by 2002:ac8:6542:0:b0:528:f72:a986 with SMTP id
 d75a77b69052e-52d20aa158amr42855501cf.44.1786132185015; Fri, 07 Aug 2026
 12:49:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-9-6b97c439eb28@gmail.com> <3fa5a8c6-a803-4b28-a45c-26a71dd99b7d@redhat.com>
In-Reply-To: <3fa5a8c6-a803-4b28-a45c-26a71dd99b7d@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Fri, 7 Aug 2026 12:49:31 -0700
X-Gm-Features: AUfX_my2rO0hUcLEmIPzvmjdKfkHE3vbYKhjrn3aDfg0wC4qV_6jHYQibz9VYjs
Message-ID: <CA+spn3ocMhWx_0wK_b0oNGxphnBw3gJQqYd9XR9D3Bq3bETKFQ@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
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

On Mon, Aug 3, 2026 at 5:48=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> On 24.07.26 00:30, Connor Kite wrote:
> > By default svq vrings are placed in an anonymous memory map. As svqs
> > will be leveraged to enable memory isolation in vhost-user, it is usefu=
l
> > to be able to place the vrings in a shared isolation memory region.
> >
> > Adds the option to specify vring placement by providing a vring base
> > address before starting the svq.
> >
> > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > ---
> >   hw/virtio/vhost-shadow-virtqueue.c | 22 +++++++++++++++-------
> >   hw/virtio/vhost-shadow-virtqueue.h |  3 +++
> >   2 files changed, 18 insertions(+), 7 deletions(-)
>
> I would go beyond Stefan and say that I do really ask for explicit
> bounds checking on the area.
>
> Besides that, `vhost_svq_stop()` still always calls `munmap()` on `desc`
> and `used` and that must absolutely not be done in case a fixed location
> was provided.
>
> Also, it would be nicer to have a function to set the base address
> instead of having to modify the svq object directly.
>
> Hanna

Got it!  I now check that the last address in the vring area is not
less than the
first address.  vhost_svq_start now returns an int so that success/error ca=
n be
communicated to the caller.

I just moved some existing changes to vhost_svq_stop forward to this patch =
to
just memset the vring area to 0 if static location is used and vring
pointers are not
null.

vhost_svq_set_base_addr has been added in to remove direct adjustment to th=
e svq
base address.

Best,
Connor
