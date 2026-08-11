Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E392E7389
	for <virtio-fs@lists.linux.dev>; Tue, 11 Aug 2026 02:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415588; cv=pass; b=MCYFMIaJNz3chLNB8NBXpqtNb7ZFn6KdBErWKWvE78VIfVqYvv42rZdJmvfbUINAFWVCeR/PS7MfIaG1eGS8RI3rhs3qhg91rGjRUUOAt95gTEVLkzKVqSKlt64/lwWU/sbrqNzQ2pliffgua+CrUK6YIn7Hk1Eld/72LDBNoEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415588; c=relaxed/simple;
	bh=EjziMU5SkwVThvh12csVBMSUAMYA69uMHi5XHVj5ol8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rQbqHi2Zw0frZ8MZXQy4djaI4+hY1Pw6wqbS+02bJGfAY6rEJJyTCHeAxKxJz0heUs8SDxHFx/pPX5kVBTsVVrYj2keXUkF8353DOqj/aHu/PYEMlstrbtnEGpcCKn1gXRo2hpwKgxbGSgwE6PTiagh9Yi+8VkSIIFg2CRlGd4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CPuDh5fm; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CPuDh5fm"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c2a76536bso23819131cf.1
        for <virtio-fs@lists.linux.dev>; Mon, 10 Aug 2026 19:33:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786415585; cv=none;
        d=google.com; s=arc-20260327;
        b=Az75GbQxOtaXPwaDtuuvvaVRyxOS9voHVX4e6+QvJUuG497leo0mfsZ2Ez/jsbamR+
         fBu4RirOAStQJbTZz9/iy8jEF8e4/Dl/KQ78KORxuKoPj+k4n5Hhgh5pp27sEplWuajP
         fuw/68JWB+ujtq3exbpMPX7e3MqMRe1c57Rp910QFEnZy8JRt1OWbvXauvUNXagT1IWR
         4z44SGCAoaDO3uuGu1+1vLmwD4Ry1WYTPGlZmm8T0rJ6ZqTVajlRtUDuDjpdHpnBmQQ5
         NmFTerYLlwRU//WQmC4MQB1DPVbdSS68IjIKGUd4hoL3Ka2oLmbXo7UnTB2gesJCMmo9
         ffAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l47ouiWxP5ccdaTdd4P/MDEyQu/nWl9Vr1nsGjRMchM=;
        fh=jbHE0qMT8UJvd/dC6rDw4gwSdvjvA+/wTTcjt5nL3i0=;
        b=cy9kbCP6B5wEsdLLcva1IEcVGHfrYMAbLoiAdOvwwPQx1R3Gg2OPb7FeupfkCIPa3h
         W3LKsnjBmX6klHCurMBjOTkeKXjDy9kCnjzgV7xqLUSYFfanYKBdhhb7a3FNulUvl6vr
         THFLVDCREDJb9M4OqvapstnLkp5TC+4yolBUTBgACYUAXKE8KQqrZjCH0+T8ppny4FwV
         7px3hyb7NpiMcDwXi7yS0JFqikixJzg/Jv5ecwTYgAl7vRdw3jXuXDQHFjg332iM2+aQ
         SqmCQuQRli4NUla86kZkLtE+0X4m3ekQvskXQ6HJjsvvP/1qyQobueokBVPc86T9CkVi
         IfFw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786415585; x=1787020385; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l47ouiWxP5ccdaTdd4P/MDEyQu/nWl9Vr1nsGjRMchM=;
        b=CPuDh5fmbgJWG/6ReGlQUGH3FwpTb5T6Ka+7HkuMmIQau7Kj7rATU6wlogz0/0/wEK
         zH5081U18W9EZAdPuUzsL9mwWmh2WgYVba96M8K1AaiFlqBr2Or0DPMkCQaYzP0rJF4t
         B9Fz6EiJl0p1Zo9aop+BgxmzblpfDz4UcJxYKs/YqXXccY7ys1sHfjmMIzMB7XgCGeN9
         TfJe7VpxCK0ujbqRtuFPVrd1dKqXtgK87oHT88MBUYYnMhy302D5U9MlObbuYL3eeF5n
         fpc3fE734xmoCgncTHRjCEcJF22Eqx9sIJw2MfVeyheQ/5et2pp6d5tq9u1yvUwYnN7E
         xvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786415585; x=1787020385;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l47ouiWxP5ccdaTdd4P/MDEyQu/nWl9Vr1nsGjRMchM=;
        b=kj/JG1vA/dbYyOiVE0+u3W8daJmH/hYIN2RqGaMEsxMugq35g9YSJzwfeEhSDfvF5q
         lPOFKTSSHAyIGZhHB0L3Swm1rrcTROlqUe86lo37iiy3+C2Ds8otA6YV8eH30GEoeFpj
         FKTq1xOC9P3RO5FHEIDiO2o8ep/XUS26zNfj0NR5Mm8fbKEPEx+RhbD+MQd4GYFH/tGy
         orNv55qCRDb2yk0J9InOv0JmokEuWwqH1XS+ncjqYN0d1/YIRwd464mxND1Y3vbGvqQG
         Epo78QYuANRgrMxdd3C79oQ0hbFudced6683g6Sw0Nkt0avkoNpEyqmHvYEz+H09Hvet
         pwrA==
X-Forwarded-Encrypted: i=1; AHgh+RoiWHK2qsSyfdhihz9bgIrxVgPf23onU7n3Pv3WH5lgxowHDzSIYLYBD1C64ay1RLGi0AEdEIxJBBk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCvqTH9oOA4BrM6Yol6ZFIBh2TMla2AaIuRaZ5UD698w8PSKSN
	IKl7xIDUvuVUxJs/6NaV0LuIhcB1TCKePP4A8zM/7PajPkRpyTnSVGeBm2vtiRzkuUUknAZ+2qz
	z1mh4OBFfyJeC36ofNd3Zr0+/7+0uVh4=
X-Gm-Gg: AR+sD11z6SPdVsYL7AVrNmHrRGHvqNCLeQ8zaX2bMFTbbLMGHYrRKUGrXXDFqr+hUDL
	l0HVmq6tY4VEkfRbGlRV1wxpxObxRsKkp38O44w4NJRfe6Da3/HY72qGoWj44NA8tF3tD+9A1yP
	nsD/Rk1HcfXW/iTfECMRfm5FWws/uEoI4PKySRhM/vTkefjJtGqBQWM2NS9qryWy6w/3Q066LWU
	s7fYh6z94q9cPewtlCJKPs8LeAA+5llA3hFTr5/ZquGmP0e2GlGes86NxVFsfQHkiQS+QJR2clF
	bHcae++7U7H+bcnV+33Hah9huo90m9w6WjqmucxTAvRib4WDvXR8u5DkTuocsjltinSzAX/vN3P
	9t0o=
X-Received: by 2002:ac8:5d06:0:b0:51c:1ff:2512 with SMTP id
 d75a77b69052e-52d58670614mr1275201cf.33.1786415585557; Mon, 10 Aug 2026
 19:33:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
 <20260723-vhost-user-isolated-memory-v1-13-6b97c439eb28@gmail.com> <13594665-16ec-47e5-9075-f7bd5552b0a3@redhat.com>
In-Reply-To: <13594665-16ec-47e5-9075-f7bd5552b0a3@redhat.com>
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 10 Aug 2026 19:32:54 -0700
X-Gm-Features: AUfX_mwJzLB3L_tUMvJyoXZYiw6uHtEY3ibxhzMN-VRQUCLkfnI52lB5oLNIv00
Message-ID: <CA+spn3r7+pEb7e6=8JixTpk7M3rNhWv=JkGZchj2-3FK9ZQGYQ@mail.gmail.com>
Subject: Re: [PATCH RFC 13/15] hw/virtio/vhost-user: add shadow virtqueues and
 eventfd intercepts
To: Hanna Czenczek <hreitz@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
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

On Mon, Aug 3, 2026 at 6:52=E2=80=AFAM Hanna Czenczek <hreitz@redhat.com> w=
rote:
>
> > +    struct vhost_user *u =3D dev->opaque;
> > +    int svq_idx =3D file->index - dev->vq_index;
> > +    if (u->user->memory_isolation) {
> > +        VhostShadowVirtqueue *svq =3D g_ptr_array_index(u->shadow_vqs,
> > +                                                      svq_idx);
>
> Bounds checking via `vhost_user_get_vq_index()` would be nice. (Same belo=
w.)
>

Adding the bounds checking outside of the memory-isolation only code path, =
since
file->index wasn't being checked previously.

> > +        if (svq->hdev_kick.initialized =3D=3D false) {
> > +            int r =3D event_notifier_init(&svq->hdev_kick, 0);
> > +            if (r) {
> > +                error_report("Failed to create kick event notifier");
> > +                return r;
> > +            }
> > +        }
> > +
> > +        file->fd =3D event_notifier_get_fd(&svq->hdev_kick);
>
> What if `file->fd` was -1, i.e. `VHOST_FILE_UNBIND`? Should we put a
> real FD here then or just continue with -1?
>

Good point!  I think we need to propagate the -1 to the backend device, and
run event_notifier_cleanup on the existing svq->hdev_kick.

...

> > +
> > +        if (svq->hdev_call.initialized =3D=3D false) {
> > +            int r =3D event_notifier_init(&svq->hdev_call, 0);
>
> Do we need to check if the call event FD is already active?
>

Do you mean, do we need to call event_notifier_test_and_clear to see if it'=
s
been set and potentially run the call handler at this stage?

If so, this might be where some of the intricacies of when things happen in
vhost-user vs in vhost would require some extra care, unless isolation mode
implementation moved up into vhost.

...

> > +    /*Modified from vhost-vdpa*/
> > +    u->shadow_vqs =3D g_ptr_array_new_full(dev->nvqs, vhost_svq_free);
> > +    for (int i =3D 0; i < dev->nvqs; i++) {
> > +        VhostShadowVirtqueue *svq;
> > +        svq =3D vhost_svq_new(NULL, NULL);
>
> Patch 15 adds clean-up for this; I would squash it into here, as far as
> possible. Ideally, a patch series can be stopped at any step and not
> break anything, so if an allocation is added, the accompanying freeing
> should come with it.
>
> Hanna
>

In hindsight I shouldn't have considered cleanup a separate stage in the
development.  Too easy to introduce bugs that way.  I'll move cleanup up
and comment in the Patch 15 thread.
