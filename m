Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6C035201E
	for <virtio-fs@lists.linux.dev>; Wed,  2 Sep 2026 08:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337504; cv=none; b=rBCNFZRoPCPtE61bdH0hCNJGyQgFJq9k6jXwHGGQ0mo3eMhXDwidNuaoVcG3mV7TGbcQ9n2foMU1fFj1K0/w4IX9/3/fMEHXjhxDdO1BaeB/FhodaFM4MLCG0JgwIwkEwxZlA2VBRpY7wOu4pgmeHBv5bMpzz1xZi5fbuFOOJUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337504; c=relaxed/simple;
	bh=qLk48G2PhAkYDNfkfYjf02uvSevvadhGP5DVjOq6b8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLyZW+kOgbhP5mcWlj1LeF6RrxzhevkrOniWf1VN0ABn6ThHJ7B4jUDw7TOan0q7b1cWY+Vs8eBriAQG4N/hAyp/mn4qeIx3/LIvxfYDn8q//rCQ4rcB286nV1vo9QmYSNIYuvOzAnn9Tt8oA/xXTvofeLFxQZOYSz6kd53lPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bd7KCmvq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bd7KCmvq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788337502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XLuwEcoYlZMRIp51yDsHxNP7hpRb1BmADwZOEKjwdQE=;
	b=Bd7KCmvqFPoQ+WdLfuumCVq6MGWGE276eh8LGDlwOFAnmnixixMmLjz+DHIo4EQ22zPe+m
	jTOM606uWvLXrBYvRmFaOYZZ6qinFwGGjIe3QHRxH8LyWQ7MEcrczgywz2E/7njtVZPBuN
	Qvz8x7c6nwOI0EPJQ19pBfBdWR4cJLk=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472-vjZW9jtUPdiaVCaPUcVioQ-1; Wed, 02 Sept 2026 04:25:00 -0400
X-MC-Unique: vjZW9jtUPdiaVCaPUcVioQ-1
X-Mimecast-MFC-AGG-ID: vjZW9jtUPdiaVCaPUcVioQ_1788337500
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-836c9f68dcbso14227557b3.0
        for <virtio-fs@lists.linux.dev>; Wed, 02 Sep 2026 01:25:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788337500; x=1788942300;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XLuwEcoYlZMRIp51yDsHxNP7hpRb1BmADwZOEKjwdQE=;
        b=ew0AfIwq2zSJCd1D2xF9hAYGOco3cZUoxA875V1sk72S0jRJYXyFqq3mpojjLLCUNS
         vS0jcaAAipqSL6z60bnUVadEgGV9cVLCLHk7j8wbVnJf9GJlseyNGp1t5+K0d5mFtY4j
         Cbku1oK7eO9C3y+wJ5uzPTlI0Xm93pdsSq2Zm3JqzMq413mWwin5GXKNF08WFm5Dktr4
         JrLqpIsVpdw0BQJq0OFlTN9Z03xFDryjaYawKFEdKzrnSHReOLQufkCfSw47FB/H80ob
         bf68l/SD2QObMVCgpTPXX8vV1SmR5M4lazU1EfB9UCppGb5OlV5agP37mSQxsVbHV+5h
         Dslg==
X-Forwarded-Encrypted: i=1; AKwUvByQAMiCNhtHZceh1gfe5b6NZh6rdkGkr0gd+WU72/OoCD2ewltCWZYEaoptQtfVex5HCDNoxjfGC1A=@lists.linux.dev
X-Gm-Message-State: AFuF++kHug24bA6Tp74HH0XfJN7mXxvSEbwlo0rokMDmTLJQIjw9nVmE
	nU5qOCYISHHuqN5X/nxaKQPDLkoHxnNFgmku1k3SLr2A2BFyDxJkpJu6bzpfeXQfNRJAvFq/NDU
	ZV3RgiWk3hIJEt/gyIoHrHrx+Shbq7fNI/vKojz8wylJ1bSdt1DffyoNtwz4XY2Bk3/IR0Mw0ms
	71EN2RBoqiQUOsHUY8B672/wYel22M1vR8RErO
X-Gm-Gg: AYBFou1mZT9/kOUHxTHVHiJUrTna6Tij2LaWqqw7057i/Vn+L1Zjto2vxD9PKMkCb0q
	fiyg7K57xpHdgNbjS04h4FrMO4yQHYBb5v4ZMIpReFJhNB8Qp1JiT+2gd3iQxk6sXEz1fb29Cpu
	jWhq32nDgpjqIDagznp3fuFg+MUznkVoWgd1q9qkXJj1580QyK/Y+D3Fj92D/5WLR5uRi2+0MyY
	c5lOq7KxfEiRhbLiUEW5hlyNTsawwdTEwm0QSSzD+dV/2lBBV+jZrNRwYI=
X-Received: by 2002:a05:690c:85:b0:81e:abe2:e01b with SMTP id 00721157ae682-86c54546feamr14084437b3.26.1788337499939;
        Wed, 02 Sep 2026 01:24:59 -0700 (PDT)
X-Received: by 2002:a05:690c:85:b0:81e:abe2:e01b with SMTP id
 00721157ae682-86c54546feamr14084257b3.26.1788337499500; Wed, 02 Sep 2026
 01:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
 <20260817-vhost-user-isolated-memory-v2-5-948aae960abb@gmail.com>
 <CAJaqyWcO3bSakzykPr-p=eBrqntNaTdUuvZdo2-B_DVxrt6wjw@mail.gmail.com> <CA+spn3pSp6ZEnF+Y7_ukirg570QX8Nwa71fPEw=02h3_k3r6jw@mail.gmail.com>
In-Reply-To: <CA+spn3pSp6ZEnF+Y7_ukirg570QX8Nwa71fPEw=02h3_k3r6jw@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 2 Sep 2026 10:24:21 +0200
X-Gm-Features: AcwNN1VFs3JiV82m8NsHxkJ5WoGL26ISmwsJoyVHQSjMN_WVexonJK0rZLR1tLI
Message-ID: <CAJaqyWfeMEznFZvJwNXVD=01=u7Mk-4qJZ1LChPGFgUh3TrOqA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 05/13] hw/virtio/vhost-shadow-virtqueue: specified
 vring placement
To: Connor Kite <connorkite@gmail.com>
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
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M3ZJUvopgliU3HlJHrVVxZnzABTBRqwrH1OwDuOrD2Q_1788337500
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 9:10=E2=80=AFPM Connor Kite <connorkite@gmail.com> w=
rote:
>
> On Fri, Aug 28, 2026 at 5:16=E2=80=AFAM Eugenio Perez Martin
> <eperezma@redhat.com> wrote:
> >
> > On Tue, Aug 18, 2026 at 7:12=E2=80=AFAM Connor Kite <connorkite@gmail.c=
om> wrote:
> > >
> > > By default svq vrings are placed in an anonymous memory map. As svqs
> > > will be leveraged to enable memory isolation in vhost-user, it is use=
ful
> > > to be able to place the vrings in a shared isolation memory region.
> > >
> > > Adds the option to specify vring placement by providing a vring base
> > > address before starting the svq.
> > >
> > > Signed-off-by: Connor Kite <connorkite@gmail.com>
> > > ---
> > >  hw/virtio/vhost-shadow-virtqueue.c | 69 ++++++++++++++++++++++++++++=
++++------
> > >  hw/virtio/vhost-shadow-virtqueue.h |  8 ++++-
> > >  2 files changed, 66 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/hw/virtio/vhost-shadow-virtqueue.c b/hw/virtio/vhost-sha=
dow-virtqueue.c
> > > index 496e7e58a3..f54a61439a 100644
> > > --- a/hw/virtio/vhost-shadow-virtqueue.c
> > > +++ b/hw/virtio/vhost-shadow-virtqueue.c
> > > @@ -812,6 +812,13 @@ size_t vhost_svq_device_area_size(const VhostSha=
dowVirtqueue *svq)
> > >      return ROUND_UP(used_size, qemu_real_host_page_size());
> > >  }
> > >
> > > +size_t vhost_svq_vring_total_size(VirtIODevice *vdev, VirtQueue *vq)
> > > +{
> > > +    VhostShadowVirtqueue svq;
> > > +    svq.vring.num =3D virtio_queue_get_num(vdev, virtio_get_queue_in=
dex(vq));
> > > +    return vhost_svq_driver_area_size(&svq) + vhost_svq_device_area_=
size(&svq);
> > > +}
> > > +
> > >  /**
> > >   * Set a new file descriptor for the guest to kick the SVQ and notif=
y for avail
> > >   *
> > > @@ -842,6 +849,19 @@ void vhost_svq_set_svq_kick_fd(VhostShadowVirtqu=
eue *svq, int svq_kick_fd)
> > >      }
> > >  }
> > >
> > > +/**
> > > + * Set vring base address if using fixed locations
> > > + *
> > > + * @svq: Shadow Virtqueue
> > > + * @addr: Points to new base address
> > > + */
> > > +
> > > + void vhost_svq_set_base_addr(VhostShadowVirtqueue *svq, void *addr)
> > > + {
> > > +    svq->base_addr =3D addr;
> > > + }
> > > +
> >
> > Would it work to keep that allocation detail in SVQ, instead of
> > letting it leak outside? Something like a flag to allocate the areas
> > with mmap or qemu_memfd_alloc, instead of the base_addr itself.
> >
>
> For the purposes of the isolation mode as it currently stands, I'm not
> sure the allocation can be entirely hidden without adding significant
> complexity.  The vrings need to be allocated in a region that gets
> sent to the vhost-user backend.  If
> VHOST_USER_PROTOCOL_F_CONFIGURE_MEM_SLOTS isn't negotiated, then we
> are limited to 8 regions in total, so it is beneficial to be able to
> allocate them all in the same region, and in fact, the vrings are
> currently tacked onto the beginning of one of the bounce buffer
> regions so that they don't count against the limit.
>

Ok I see. Would it work if those details are encapsulated in a new
struct, perhaps named SVQDeviceMemory, which all ShadowVirtQueue from
a given device uses to allocate all memory together? It could use that
explanation as a comment too.

I'm very bad at naming things so feel free to rename it :).

> Having said that, a longer term desire would be to update the
> isolation region implementation such that it is no longer organized as
> a 1:1 copy of guest memory in terms of size and number of subregions.
> We would then need an allocator when copying guest buffers into the
> shared region, but it would be much less wasteful, and we could
> guarantee that only 1 region need be sent to the backend for the
> bounce buffers.  At that point, the vrings could be mapped into their
> own region.  There would need to be some mechanism to ensure they all
> get mapped into the same region, but I think those implementation
> details could be kept within SVQ.
>

That would be great, and the work on optimizing SVQ indirect
descriptors could use it too.

