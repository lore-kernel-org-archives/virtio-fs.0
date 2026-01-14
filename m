Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3F53A900F
	for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768427909; cv=none; b=pZZ9tzfGb/IUM14illrQe7UJcyMl4XB3fKxPl1IEFtInwzSIQ0x9WesNheiVQlQK9Fz8Xbf//tIW6ZetIELEuVtwCaxsRUmaqBPqaU9oaxo+iKHe9xFrqi0txtmHO9i59UqBNYcVHDvG9Hl0DMMHLKI9IgshoqPH44LoGt0A6jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768427909; c=relaxed/simple;
	bh=Qm2NtxYoErewJnCVk+qXB95+SIIMybZV2bev4fXKzbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=lCa0lPbI7ypQxvMu6NBF/eEr8dh2ApmDKFFWtDT1lNuUtA2kQhw/WOHAfJfmoKfI//+TzfMTuEm+YE4/ifxLnxcHVVmYLwpVRJ/rIVAe3P+Z+AGEC9hPRZCr6zWRGRk5hNcykoOqH1jmZlWPV7B47K8rC2zvrkAbNO3spTjxLv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eT39JzGf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eT39JzGf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768427893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t8SBT1pBmEfJh/nYjObHr7fEkO+/sSZDOi3orguP0nw=;
	b=eT39JzGfd1gIAMQbjC57ZNSnhrqhpL0GEBhceMl/eyw2hjqXCB6Z8KOONTccUXhtz/kGRE
	1VsMgqPiyqXnskUzXk7XIbslQdvUWt1RdqjUNKECcml5LXWGPwSuwe7JBEtFdLiEyMHfyJ
	nZaG1tTSXV1JOGpDVqXmWGf1vUUkxXo=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-QVUDpC36N72zTlgWD3Zo3A-1; Wed, 14 Jan 2026 16:58:11 -0500
X-MC-Unique: QVUDpC36N72zTlgWD3Zo3A-1
X-Mimecast-MFC-AGG-ID: QVUDpC36N72zTlgWD3Zo3A_1768427891
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5ed0924e15fso275558137.0
        for <virtio-fs@lists.linux.dev>; Wed, 14 Jan 2026 13:58:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768427891; x=1769032691;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t8SBT1pBmEfJh/nYjObHr7fEkO+/sSZDOi3orguP0nw=;
        b=bSOjf2YYpJKBfSMThORMKutFuS9DGKRCawkG06LvF3l22kHlSlZU+vLQeU1UDHN6hX
         eQ633SeWKJ5CrINdUZZRS7YJV7PY2vaR9eiHz2y+VITK+LkJGwzHCWMIk6Cmgfbedj39
         YJmsUJ3Vhqnq1HouT0jf/ISP91lpxhNfY45QOeDzO253HdUNPOs/BrGTdwB4NVz8ToZ1
         Pv+xIyPBcTgNL4tHTxEIC1kY1aQVZafAeb+Q4uJQ1Qt4djJ3rXd/A1zveSfLyDaCnwof
         2qZBOSknuiKH5H1+0mbbY1wN6baGbcIg4gkfbIywytrGiOoqOmigL8qlyrDFsKvCiuGG
         M29g==
X-Forwarded-Encrypted: i=1; AJvYcCVZ5ir2e+7rqAn92/G5+rzfEkfqtK6gilFBEXwFIrpnYqr1OyxdAbD5Mv4SGjn2gLxSdVeZJ98XHfE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwR74Ruxs3B0t4pIsuaOHKGL6PvQWQieFBC8OOWGYpEaIpKNOEe
	XcskQjHZiwZFdbIUKqcQAMb7ydZPiFnvGS2rE4Sod5KCq6T/Txdzq6uqGN7nxdUvv5taD80iIYl
	PZA1Kl+DRI2LQuw8WwQGm0qoVKC3wFfed2qsgyVexCbhBk+umskGbp/f6SzUyYQ==
X-Gm-Gg: AY/fxX4/bKFuw2HbYccgsAbDKAl6S7scsR5G305cDy6Wy5Lgiyybz46mh2R3ASW9pM7
	tt9tmhz78iazbq9KDUrwJ6NODEtledNjwSnSQbSN97po5c3JEs7RZ6pmysiZ6myMkzQYRKxQ29O
	OQZEa1+8OL2t/KsYFpt6ni9rAE3OnJb0r32CDlrkROxAAOeuJtt3h85xwUtcvibCW8bkyQicnUN
	s3ueCgEfMiS051woRpQmzC073BKGaleZf5nUQoRjSGtwRDQxBNwS3SnMG7ZphIV+ldrRR9P4ekg
	FQH9EC3B3k/a8VsKq1m5Ynt/4Ba6wqzSaQvCyc8S4c224BRiVDwUrCpe9vijY1mXJCYRn26jOyQ
	haHs=
X-Received: by 2002:a05:6102:5e86:b0:5ec:c528:4dd3 with SMTP id ada2fe7eead31-5f17f69f277mr1758002137.42.1768427890920;
        Wed, 14 Jan 2026 13:58:10 -0800 (PST)
X-Received: by 2002:a05:6102:5e86:b0:5ec:c528:4dd3 with SMTP id ada2fe7eead31-5f17f69f277mr1757981137.42.1768427890497;
        Wed, 14 Jan 2026 13:58:10 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-944124e97b1sm23437598241.15.2026.01.14.13.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 13:58:10 -0800 (PST)
Date: Wed, 14 Jan 2026 16:57:58 -0500
From: Peter Xu <peterx@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Alexandr Moshkov <dtalexundeer@yandex-team.ru>, qemu-devel@nongnu.org,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Zhenwei Pi <pizhenwei@bytedance.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	mzamazal@redhat.com, Fabiano Rosas <farosas@suse.de>,
	qemu-block@nongnu.org, virtio-fs@lists.linux.dev,
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: Re: [PATCH v6 4/5] vhost: add vmstate for inflight region with inner
 buffer
Message-ID: <aWgRZmQuQNDRRNRs@x1.local>
References: <20260113095813.134810-1-dtalexundeer@yandex-team.ru>
 <20260113095813.134810-5-dtalexundeer@yandex-team.ru>
 <aWfrT6JOMm9MGoIw@x1.local>
 <20260114213817.GA622013@fedora>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260114213817.GA622013@fedora>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B0FdiFHqtFnlkEwOH8s4FGv-8VdYBiV84pR1LR-KxTo_1768427891
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Jan 14, 2026 at 04:38:17PM -0500, Stefan Hajnoczi wrote:
> On Wed, Jan 14, 2026 at 02:15:27PM -0500, Peter Xu wrote:
> > On Tue, Jan 13, 2026 at 02:58:17PM +0500, Alexandr Moshkov wrote:
> > > Prepare for future inflight region migration for vhost-user-blk.
> > > We need to migrate size, queue_size, and inner buffer.
> > > 
> > > So firstly it migrate size and queue_size fields, then allocate memory for buffer with
> > > migrated size, then migrate inner buffer itself.
> > > 
> > > Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> > > ---
> > >  hw/virtio/vhost.c         | 57 +++++++++++++++++++++++++++++++++++++++
> > >  include/hw/virtio/vhost.h |  6 +++++
> > >  2 files changed, 63 insertions(+)
> > > 
> > > diff --git a/hw/virtio/vhost.c b/hw/virtio/vhost.c
> > > index c46203eb9c..f655c53b67 100644
> > > --- a/hw/virtio/vhost.c
> > > +++ b/hw/virtio/vhost.c
> > > @@ -2028,6 +2028,63 @@ const VMStateDescription vmstate_backend_transfer_vhost_inflight = {
> > >      }
> > >  };
> > >  
> > > +static int vhost_inflight_buffer_pre_load(void *opaque, Error **errp)
> > > +{
> > > +    info_report("vhost_inflight_region_buffer_pre_load");
> > > +    struct vhost_inflight *inflight = opaque;
> > > +
> > > +    int fd = -1;
> > > +    void *addr = qemu_memfd_alloc("vhost-inflight", inflight->size,
> > > +                                  F_SEAL_GROW | F_SEAL_SHRINK | F_SEAL_SEAL,
> > > +                                  &fd, errp);
> > > +    if (*errp) {
> > > +        return -ENOMEM;
> > > +    }
> > > +
> > > +    inflight->offset = 0;
> > > +    inflight->addr = addr;
> > > +    inflight->fd = fd;
> > > +
> > > +    return 0;
> > > +}
> > > +
> > > +const VMStateDescription vmstate_vhost_inflight_region_buffer = {
> > > +    .name = "vhost-inflight-region/buffer",
> > > +    .pre_load_errp = vhost_inflight_buffer_pre_load,
> > > +    .fields = (const VMStateField[]) {
> > > +        VMSTATE_VBUFFER_UINT64(addr, struct vhost_inflight, 0, NULL, size),
> > > +        VMSTATE_END_OF_LIST()
> > > +    }
> > > +};
> > > +
> > > +static int vhost_inflight_region_post_load(void *opaque,
> > > +                                           int version_id,
> > > +                                           Error **errp)
> > > +{
> > > +    struct vhost_inflight *inflight = opaque;
> > > +
> > > +    if (inflight->addr == NULL) {
> > 
> > IIUC this can never happen because pre_load() must trigger before
> > post_load(), and when reaching post_load() it means pre_load() must have
> > succeeded..
> > 
> > So, IIUC we can drop this post_load() completely (or assert addr in
> > pre_load instead).
> 
> I asked for this input validation check. If the migration stream is
> inconsistent (e.g. broken or malicious source QEMU), then the subsection
> might be missing but size could be non-zero. The destination QEMU should
> fail cleanly and not run into undefined behavior.

Ah I misread it as the one pairing with the pre_load().  It makes sense
indeed to have such post_load() in the parent VMSD.

Please ignore my comment, sorry for the noise.

-- 
Peter Xu

