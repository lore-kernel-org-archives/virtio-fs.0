Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A76225CE
	for <virtio-fs@lists.linux.dev>; Fri,  8 Mar 2024 13:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709904527; cv=none; b=C5tk1peHI6fV+GetU1j582ycD7ZzbgSFvhOGBHBnh5Js2iJNpnMJqnDWOnIPkLO996cYvnc3YcybcTgHdVdkHEvHzWO8WXvmPz9ZfMuuJvbu2iFhC9Cw0dBrvtG0b4882w10JdZMVI9CS8rhIxpm88vp2Iu7//LF96fTfnOPZ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709904527; c=relaxed/simple;
	bh=Ov2+Z8tyoxGFXoSnbak0pf8prFsCDmdXJZZuqda2jgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAo1w7tEdEAJc1nG8YT/YbIO3DmPYML9GbZiji0fWSLpfOyf7HMeG7GxPExZprruQOBHCP5PNVDnQWK+EBhAPEH7/6tySFIova5N0Llvl8JiEtuBRX1uxMxsgE64EplrBEqGvm/maMwpG7k1z5hiMegMljGN6rEWxlNmnIXPZlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q3wV+TQI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q3wV+TQI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709904524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xBigzBSsPRz1gtnNtjGrUVoZLDHAEsI3bQhOrzQ8Bp8=;
	b=Q3wV+TQIITnVbYH9/sW3aTLHqTNGKhLeYFS4TZ9AtC67nfQgmeJOtfBUXCVC0vV6V4+mZx
	4jXj9d74Y+sDst5+3Wkj2oU7AoTkASpCpyLo0UUIu55n/6BG7Vjz2Xbou4o+66a8bnnkaL
	eVeTOj/PuxQ/MYTTyFf0z//EznFdIXM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-IkDAtIx9N4K4FGolWKzC0A-1; Fri, 08 Mar 2024 08:28:43 -0500
X-MC-Unique: IkDAtIx9N4K4FGolWKzC0A-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-a45a7d558feso228681166b.0
        for <virtio-fs@lists.linux.dev>; Fri, 08 Mar 2024 05:28:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709904522; x=1710509322;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xBigzBSsPRz1gtnNtjGrUVoZLDHAEsI3bQhOrzQ8Bp8=;
        b=RBVkIRTywSsOBn485orp6t4Ew07+sX9/w24x2LlAjm+2ssKmZWemhslxoTbM6ZooPQ
         i5KrCJbXwTubMR1Gr0Vjj9+2LhWlFu7huCRS691RLqLUaY2Ffsbh6Ax4xNgUWSZk4t7X
         vO/wo9YeXiAOzlpG+Qcsh2x//paTHkIDhA/bFP7GsWMydS2oqf5iZ9INjjRAbmZnW1oK
         Hkw1ezAtaCDJ7iKGA5WuOfFu2R2uNYhUv31kXdA79TG8RF6Wc3EHgW9e2Ccuo79vnH2/
         oAIPDpgHjVbXCsOyqp6uBs7eHGcLdnl7FBRD+CQMBYGoa9gZsOfAxWWLImGizefoFoji
         H2tQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCZb4FqleiwwvolLN6K9TtoSqhmrfdj/wxJEGkDv/GHdqVNWsKJJSVhM9zPRPMw7nB3SCADrM/iNGUYToRKDgO+AMdxgGZz+f5
X-Gm-Message-State: AOJu0YyK6FEDkuq98te2kH7N10c7KU+1/aMsW71NAR95K6SSl7uGwdvq
	NTz51AXdwEKCTxZQFsYIDIV9XRIp4Qv+o74lt1lfp+hZMScjBvRBxlrWwr9AQ0g5N2sFABL68rs
	xi0ooAcRv33OwPH2hyZfvEFGFLX4Kz+upzQ7JbfVTBTMi/5y47ZYLPadydARAM+9BVXtx0K607e
	jFRcBy2AY3Y4no5Qnupq5Ep9lEd20cvxyM
X-Received: by 2002:a17:907:7e86:b0:a45:beca:9a08 with SMTP id qb6-20020a1709077e8600b00a45beca9a08mr310301ejc.27.1709904522370;
        Fri, 08 Mar 2024 05:28:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfx/3uXJlMf9MhArXSSO/IkGtohfpuSXGmAN32UGS+/7c3ftDx1ymntm75Ds5kpgXsS0zXzkgTWvJ6dimiIaE=
X-Received: by 2002:a17:907:7e86:b0:a45:beca:9a08 with SMTP id
 qb6-20020a1709077e8600b00a45beca9a08mr310255ejc.27.1709904522013; Fri, 08 Mar
 2024 05:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
 <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com>
 <20240306023143-mutt-send-email-mst@kernel.org> <CAJaqyWcDMu58H6P3FvyTM7L-GphLB1kj7fcOTBw6FC-O2DcpZA@mail.gmail.com>
In-Reply-To: <CAJaqyWcDMu58H6P3FvyTM7L-GphLB1kj7fcOTBw6FC-O2DcpZA@mail.gmail.com>
From: Lei Yang <leiyang@redhat.com>
Date: Fri, 8 Mar 2024 21:28:05 +0800
Message-ID: <CAPpAL=xRiVfr4tObY_MwudQ0qyhWOqMzaHQaCdx7YtMnZc7GDw@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] virtio, vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: Jonah Palmer <jonah.palmer@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, qemu-devel@nongnu.org, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, Eugenio Perez Martin <eperezma@redhat.com>, pbonzini@redhat.com, 
	fam@euphon.net, stefanha@redhat.com, qemu-block@nongnu.org, 
	qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jonah

QE tested this series v1 with a tap device with vhost=3Doff with
regression tests, everything works fine. And QE also add
"notification_data=3Dtrue" to the qemu command line then got "1" when
performing the command [1] inside the guest.
[1] cut -c39 /sys/devices/pci0000:00/0000:00:01.3/0000:05:00.0/virtio1/feat=
ures

Tested-by: Lei Yang <leiyang@redhat.com>

On Thu, Mar 7, 2024 at 7:18=E2=80=AFPM Eugenio Perez Martin <eperezma@redha=
t.com> wrote:
>
> On Wed, Mar 6, 2024 at 8:34=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
> >
> > On Wed, Mar 06, 2024 at 08:07:31AM +0100, Eugenio Perez Martin wrote:
> > > On Wed, Mar 6, 2024 at 6:34=E2=80=AFAM Jason Wang <jasowang@redhat.co=
m> wrote:
> > > >
> > > > On Tue, Mar 5, 2024 at 3:46=E2=80=AFAM Jonah Palmer <jonah.palmer@o=
racle.com> wrote:
> > > > >
> > > > > The goal of these patches are to add support to a variety of virt=
io and
> > > > > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport featur=
e. This
> > > > > feature indicates that a driver will pass extra data (instead of =
just a
> > > > > virtqueue's index) when notifying the corresponding device.
> > > > >
> > > > > The data passed in by the driver when this feature is enabled var=
ies in
> > > > > format depending on if the device is using a split or packed virt=
queue
> > > > > layout:
> > > > >
> > > > >  Split VQ
> > > > >   - Upper 16 bits: shadow_avail_idx
> > > > >   - Lower 16 bits: virtqueue index
> > > > >
> > > > >  Packed VQ
> > > > >   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> > > > >   - Lower 16 bits: virtqueue index
> > > > >
> > > > > Also, due to the limitations of ioeventfd not being able to carry=
 the
> > > > > extra provided by the driver, ioeventfd is left disabled for any =
devices
> > > > > using this feature.
> > > >
> > > > Is there any method to overcome this? This might help for vhost.
> > > >
> > >
> > > As a half-baked idea, read(2)ing an eventfd descriptor returns an
> > > 8-byte integer already. The returned value of read depends on eventfd
> > > flags, but both have to do with the number of writes of the other end=
.
> > >
> > > My proposal is to replace this value with the last value written by
> > > the guest, so we can extract the virtio notification data from there.
> > > The behavior of read is similar to not-EFD_SEMAPHORE, reading a value
> > > and then blocking if read again without writes. The behavior of KVM
> > > writes is different, as it is not a counter anymore.
> > >
> > > Thanks!
> >
> >
> > I doubt you will be able to support this in ioeventfd...
>
> I agree.
>
> > But vhost does not really need the value at all.
> > So why mask out ioeventfd with vhost?
>
> The interface should not be able to start with vhost-kernel because
> the feature is not offered by the vhost-kernel device. So ioeventfd is
> always enabled with vhost-kernel.
>
> Or do you mean we should allow it and let vhost-kernel fetch data from
> the avail ring as usual? I'm ok with that but then the guest can place
> any value to it, so the driver cannot be properly "validated by
> software" that way.
>
> > vhost-vdpa is probably the only one that might need it...
>
> Right, but vhost-vdpa already supports doorbell memory regions so I
> guess it has little use, isn't it?
>
> Thanks!
>
> >
> >
> >
> > > > Thanks
> > > >
> > > > >
> > > > > A significant aspect of this effort has been to maintain compatib=
ility
> > > > > across different backends. As such, the feature is offered by bac=
kend
> > > > > devices only when supported, with fallback mechanisms where backe=
nd
> > > > > support is absent.
> > > > >
> > > > > Jonah Palmer (8):
> > > > >   virtio/virtio-pci: Handle extra notification data
> > > > >   virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DAT=
A
> > > > >   virtio-mmio: Handle extra notification data
> > > > >   virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DA=
TA
> > > > >   virtio-ccw: Handle extra notification data
> > > > >   virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DAT=
A
> > > > >   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost featu=
re bits
> > > > >   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
> > > > >
> > > > >  hw/block/vhost-user-blk.c    |  1 +
> > > > >  hw/net/vhost_net.c           |  2 ++
> > > > >  hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
> > > > >  hw/s390x/virtio-ccw.c        |  6 ++++--
> > > > >  hw/scsi/vhost-scsi.c         |  1 +
> > > > >  hw/scsi/vhost-user-scsi.c    |  1 +
> > > > >  hw/virtio/vhost-user-fs.c    |  2 +-
> > > > >  hw/virtio/vhost-user-vsock.c |  1 +
> > > > >  hw/virtio/virtio-mmio.c      | 15 +++++++++++----
> > > > >  hw/virtio/virtio-pci.c       | 16 +++++++++++-----
> > > > >  hw/virtio/virtio.c           | 18 ++++++++++++++++++
> > > > >  include/hw/virtio/virtio.h   |  5 ++++-
> > > > >  net/vhost-vdpa.c             |  1 +
> > > > >  13 files changed, 68 insertions(+), 17 deletions(-)
> > > > >
> > > > > --
> > > > > 2.39.3
> > > > >
> > > >
> >
>
>

