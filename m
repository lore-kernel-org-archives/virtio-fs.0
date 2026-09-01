Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F6368D7F
	for <virtio-fs@lists.linux.dev>; Tue,  1 Sep 2026 19:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788289796; cv=pass; b=f/sVyxTQiWJOz5+vRDPU84kPXBwQdCBXMODfVo4OXoih0Aj9QcqvbMoW99qrDkWS+GdaKfKVagrxe8Clr7czuQWXMyaX0Lbf8zuauvR+cWtqQ5M6hPBjPxYr6ZwRonZez9WwkVAvgmdN/f/OClInoXOm8xhR53RJTZ0S5YwDaxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788289796; c=relaxed/simple;
	bh=mAQIG/zHz5/rsCJGVAvuXEVPh6n4h86XOWbkLdw3fK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fSRQh/C3+ilbPJteyyGbEn42PaauP3FuCozb99um7Ej3O0Bh8hrm8l6Iu+7sTqXphQXEjK50qdRb+lk8W8Zqsr0WSS69Jc3IQoQmFbB5akfsCeLvrp5y7bqLkA4ZFqHi8YdcUitgS+Hw6Cdko8sh2zVn0przBu9xIXzaVRPdJ+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RxDSl5zz; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RxDSl5zz"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52de50e77ffso1643441cf.2
        for <virtio-fs@lists.linux.dev>; Tue, 01 Sep 2026 12:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788289794; cv=none;
        d=google.com; s=arc-20260327;
        b=mmd5Vf+wKZ1W092QsxaVcqm5c/ym60R5Eyf5yytBu+ZN6djPHw3LLG/ltI3USbu4nS
         GolmMTP8wgyXclFllGGWfJCGN2P70dk1dhWxBgyzKsQsHY876+k2flG9rsGWvJasdtuy
         OBuiSskeMjPJWqjoL4ja7kfQQ8mjpzSmTDwjJVZ9aTZ6J9SKb2sVYbQjXnd7wiEkO4P3
         DxeawUkXkH8t1cJ7V2GrOJxosifG10Lw8fLF5nJvr71x4IABMlj/G4kpgUg6vO8viokl
         vPe720BVbkcKCQ0aIYsbCVPB+FftFeyTmMl/YL6S8Via59kBUxR/qrndCa+f/V57ew00
         dkkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LzrY3kQLyl1dbjndSKm2x24o7tAe9NeimDIm782FwvM=;
        fh=F5jLWIBHvhx40Z1O7mL0ZTQgopc/3+9IzRIXx9AKIdc=;
        b=lshOjNOdS/R8qIgAFWRWmntJPt0ZpwO6+JVn41t9nbVZVR4YkzYCm9Hrk4x6DU5YGr
         5Hzd9BEUnbCOWeAhB6v2moU2cu+LJNCdBTHVoHmj+tez4MnmW2gpSwn2rtqbIyu5/jZn
         cuLmsgMb0N5+Pk2+V9A2qdz0wGlrp1XT2olQws7YL7oNihWaOFMXyuNTcHA26o11dfks
         m0hk1kJKMkMNEeEzqsFNU0cGlt7Ap+OAgBf+j2DOvIiA3KmWoI+uXbFP7wDCHayfVHV1
         BYN5TCy0RQ8Wg3HDni2D8tv9QFzjOuusEplfOuBcQV/M6aI9ZiaKPBwMR9NsyHq5ICvg
         +o2A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788289794; x=1788894594; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LzrY3kQLyl1dbjndSKm2x24o7tAe9NeimDIm782FwvM=;
        b=RxDSl5zzXrSxDGsB9HAfEMZwZaAMdKbWvt3HB5S77gXFqOXFyHkl8pykQQDw2ftUHN
         5Yy02wYe+yHJ1tl+AW9Q8Vd+H7KifkAySoS1WIZLsL5d0NXXuoHk5Ptju/B4MpYVX/7I
         tbtJRKq+mgy3I8pmo4gVQK7rrPY3g0y+kNxMWBtTegXMPaGrEFTO0y26I7jJgGqMsr/B
         6YK7UBn1UANwYtZ79y+ZxKr5IM1EXs3X4w733/DiwASc9b8SR1RAeXwReaGjnrKnwQ/6
         rbEN76lVbBw67FIBlAVfjDgvkZV1nYggYuZVkjOADcs9xPOW0l4JdjEnJhnRmb3KMyDx
         kGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788289794; x=1788894594;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LzrY3kQLyl1dbjndSKm2x24o7tAe9NeimDIm782FwvM=;
        b=A5LV2RkpOc1lOpkGcWkXt4MYETWUZSuCJmUWUOzNtFwAaWQYOPGYqmRIGzWZKTuuUD
         LysbyDZLh/CBARssI2uC9sx18pqlp4jy1NQGkYazD9Gf/2aINzmbdTWxP4UUrkFGfgso
         9fMYhlEvONAfHfPKzhkD/gHFNWQkIli/akS771fzAmOuKWk2MDvcW8xQct5QBEOAcVE+
         cFnkX0WfpHBuLolFmn+b+He0MnsgqTP98bpf/V1S2LVltKZpwPgO2l7/dgCZB1pmJeqI
         mfDlNLAbWrJniZ8HCU2fqW0dzUr3rNthDAltjQiPGPGab7ZYKUleuot1ww/AwO49FnJC
         dZGg==
X-Forwarded-Encrypted: i=1; AHgh+RpgdBlXuBl7FxS2OAvaO3TqP11sbMe2GHTXP4jljIQ/68D23UfcIA56c9jlHz4rvujHrE66rXK0+ek=@lists.linux.dev
X-Gm-Message-State: AFuF++mkVW9swXsFhWhRJNxzxCvQN5MOietFrWBg7G2kpyicHQTALz/i
	pyLNnlGb4JslJlrCctBq4Gb3SffAByRX++WVExVz6TUW7pOt1ksZiHZFpdtIGHUBtYSGK+JXlHZ
	YoZNb2/xrvWel6N8KdR80Z3EEOUUbP3I=
X-Gm-Gg: AR+sD12IVQSKRTFjM71MwSlOt71Q71Ix8BXldlIuHQ7lYVxrhUJYtdfs+HgzS2LR3b+
	emlatWFPFVF/IfLqf57ZiLwkUovgS3yfHYXybCY7aOUOXEt/b/7iTm6HkI/k+srPL0X8qxOBonJ
	T45Ojww5FRnUs4uwnbP+11qhUbpM7gOHIhtfEaoCtm3ZdInPNslnmNokdRpUg/70A+wRX5JJDbP
	2iGxlJYohJZ2AldJwjGlT7pQBXHrNO2LH1juH+zNh2swq8Av1FRgDxmxFjf2L6Xqj6nzye5HF3W
	Nse2CO22doaZnokg79b3TGlflNs/8EWh3QaIj23vCJmWtkgupe5f2Tx3zfwMFihIOiQ1T+W/MZF
	m6X6JMRL9qQT7cg==
X-Received: by 2002:ac8:5702:0:b0:52d:cf85:aeea with SMTP id
 d75a77b69052e-530342b8cddmr5193391cf.24.1788289793744; Tue, 01 Sep 2026
 12:09:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com> <CAJaqyWcO3bSakzykPr-p=eBrqntNaTdUuvZdo2-B_DVxrt6wjw@mail.gmail.com>
In-Reply-To: <CAJaqyWcO3bSakzykPr-p=eBrqntNaTdUuvZdo2-B_DVxrt6wjw@mail.gmail.com>
From: Connor Kite <connorkite@gmail.com>
Date: Tue, 1 Sep 2026 12:09:42 -0700
X-Gm-Features: AcwNN1XNCKTlqjQGZhm19tCi0YpaqKL7VfH06S3TiO1xT5RaoJw_SlMzUkJivoE
Message-ID: <CA+spn3pSp6ZEnF+Y7_ukirg570QX8Nwa71fPEw=02h3_k3r6jw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 05/13] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, 
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, Raphael Norwitz <rnorwitz@nvidia.com>, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
	Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
	virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
	zhenwei pi <zhenwei.pi@linux.dev>, =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Peter Xu <peterx@redhat.com>, Alyssa Ross <hi@alyssa.is>, 
	Demi Marie Obenour <demiobenour@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 28, 2026 at 5:16=E2=80=AFAM Eugenio Perez Martin
<eperezma@redhat.com> wrote:
>
> On Tue, Aug 18, 2026 at 7:12=E2=80=AFAM Connor Kite <connorkite@gmail.com=
> wrote:
> >
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
> >  hw/virtio/vhost-shadow-virtqueue.c | 69 ++++++++++++++++++++++++++++++=
++------
> >  hw/virtio/vhost-shadow-virtqueue.h |  8 ++++-
> >  2 files changed, 66 insertions(+), 11 deletions(-)
> >
> > diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-shado=
w-virtqueue.c
> > index 496e7e58a3..f54a61439a 100644
> > --- a/hw/virtio/vhost-shadow-virtqueue.c
> > +++ b/hw/virtio/vhost-shadow-virtqueue.c
> > @@ -812,6 +812,13 @@ size_t vhost_svq_device_area_size(const VhostShado=
wVirtqueue *svq)
> >      return ROUND_UP(used_size, qemu_real_host_page_size());
> >  }
> >
> > +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq)
> > +{
> > +    VhostShadowVirtqueue svq;
> > +    svq.vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_inde=
x(vq));
> > +    return vhost_svq_driver_area_size(&svq) + vhost_svq_device_area_si=
ze(&svq);
> > +}
> > +
> >  /**
> >   * Set a new file descriptor for the guest to kick the SVQ and notify =
for avail
> >   *
> > @@ -842,6 +849,19 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqueu=
e *svq, int svq_kick_fd)
> >      }
> >  }
> >
> > +/**
> > + * Set vring base address if using fixed locations
> > + *
> > + * @svq: Shadow Virtqueue
> > + * @addr: Points to new base address
> > + */
> > +
> > + void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr)
> > + {
> > +    svq->base_addr =3D addr;
> > + }
> > +
>
> Would it work to keep that allocation detail in SVQ, instead of
> letting it leak outside? Something like a flag to allocate the areas
> with mmap or qemu_memfd_alloc, instead of the base_addr itself.
>

For the purposes of the isolation mode as it currently stands, I'm not
sure the allocation can be entirely hidden without adding significant
complexity.  The vrings need to be allocated in a region that gets
sent to the vhost-user backend.  If
VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS isn't negotiated, then we
are limited to 8 regions in total, so it is beneficial to be able to
allocate them all in the same region, and in fact, the vrings are
currently tacked onto the beginning of one of the bounce buffer
regions so that they don't count against the limit.

Having said that, a longer term desire would be to update the
isolation region implementation such that it is no longer organized as
a 1:1 copy of guest memory in terms of size and number of subregions.
We would then need an allocator when copying guest buffers into the
shared region, but it would be much less wasteful, and we could
guarantee that only 1 region need be sent to the backend for the
bounce buffers.  At that point, the vrings could be mapped into their
own region.  There would need to be some mechanism to ensure they all
get mapped into the same region, but I think those implementation
details could be kept within SVQ.

Thanks!
Connor
