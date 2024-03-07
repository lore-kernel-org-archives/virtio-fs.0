Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A05C8529C
	for <virtio-fs@lists.linux.dev>; Thu,  7 Mar 2024 11:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709810232; cv=none; b=ie8MJy3R1sR1CCgzSH7dPrmV8S56D9btAe/adzO/OpeMOK4gACqp3X+BWFpg4UJoHIp2JiXc0oEk+LZiZTocwBu2jPw70JZ5UTRvC01crihBpnKP/uSeGmiKwrGbbP1Z8HbqvyXCt7AQwAkjMphXvJG3r7sEVtdm8CX43N/96Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709810232; c=relaxed/simple;
	bh=yZWiOXPCubRyFkEu1ueW82RzNpb+ZWkvYfeFzle5CzA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AhQ6lcoMBMRWJybaUqftKmpwuiCxtrK51BxMrpn9yi42FTEuQRsdzzeXkJGMMyNhMGwS+lbikP0UVf5NKuLRDt7FAXiPGXyDKDLPpHyAOPaNM2eFK5yHUTl49EyLpz/nGSpcR2rmuEsxw4e1+WBmTM6PGcrE6u9N8OSm9m7E9Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bDWW6qXK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bDWW6qXK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709810229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IrM9V3Les7c2pOgU8QkEtywlg42IO/HWCy3/3IGeckM=;
	b=bDWW6qXK3UmJUddTq5/ffKWedWmkZapTbDrGB4mN7mMTJGI10XStnBkDPrWgGtwTQFsKDw
	Ipsu5MKHFr0WA8eSj1M4TOnmbVszssOhDVdmnxBGWvK4tJ9XVzA5QiEr3Tuav9iJ+qXi1P
	1d67Xa2PqH1eHxSOo/6VqfJUE4MJlLA=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-114-P2iqcFguPMCFBbRPVU9HKg-1; Thu, 07 Mar 2024 06:17:08 -0500
X-MC-Unique: P2iqcFguPMCFBbRPVU9HKg-1
Received: by mail-yb1-f198.google.com with SMTP id 3f1490d57ef6-dcf22e5b70bso1224281276.1
        for <virtio-fs@lists.linux.dev>; Thu, 07 Mar 2024 03:17:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709810208; x=1710415008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrM9V3Les7c2pOgU8QkEtywlg42IO/HWCy3/3IGeckM=;
        b=gC4H6Mkf2BXpebljf2qklKrjvFvhxXCcRc1MFLxA6dunNpssS300CHtxASYo68WoSA
         j6J40EJ8T9TIe9/c2Z6iaglktGFEzlu3gbFyxgVh+3QMU89Gv1rPkfu7WGDqLj8dv8je
         El5VuYhrMJI+cyQucV+4xwSp6X8ryQBUzPYq/Mo+UyhW3Q/GFlR9ANSpx+Esyu9W6sMi
         dklUwV14Jzdvb865VCC1ps0Ygv2lyCucjIhSmLK3CPw8EwfzhXWNYWrc9gcxpvw+p2ge
         +KAYuDs98XvqoXxNR6hK2TmOdxifpP+rEVUmJ0QlE5/MgAeTLDzMyWxckgyyHx3UtwcL
         0zwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/teZuw+QHV7/6BFJJDLwn3ckoxoZMMWxo1KkXMWEnxpZltTS999493ZnLYRbcLOUGY8n/JMKYS7I9uISpcqDx95X45Riya5Ow
X-Gm-Message-State: AOJu0YymxinouXz6hyB5JCo/4dO4iKvM5M7dUlesBR9RHi4HBUnI0lCT
	510wd1fHvsrIplZ3/95xKnTZ5mdYm5jguhbXpGVHpHjVfPuP0YSZsdslPKjaBr3bXNdxA7Op0Ts
	2ZUNYghFezjc3KgZsSjzJ+77WQobD26jkQYuD4PeMczrK6yYzFaRi+AGgX7rSuBAfrWdQrvhkZw
	OzmLJMg228g+8Nsnco2GjxlFOgqM4BCS9Y
X-Received: by 2002:a25:9192:0:b0:dc6:49d3:dd52 with SMTP id w18-20020a259192000000b00dc649d3dd52mr15022136ybl.34.1709810208207;
        Thu, 07 Mar 2024 03:16:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHjDRsVuX4Q24gAs5STcWHZQncfKJPCgrPy5VzGN1y5ajUzJz6F+YJ+ckolBSjNGMovf1oSe0dqMWXTww0VTBQ=
X-Received: by 2002:a25:9192:0:b0:dc6:49d3:dd52 with SMTP id
 w18-20020a259192000000b00dc649d3dd52mr15022120ybl.34.1709810207948; Thu, 07
 Mar 2024 03:16:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304194612.611660-1-jonah.palmer@oracle.com>
 <CACGkMEtoA3SN9e9WnNpFyR32rkf_pWUNj-6uj2TZBzjB0E+3SQ@mail.gmail.com>
 <CAJaqyWdAFTkjGBJBmxvmTZT8UUiH86UGgE74X_bcq22nd-WwHA@mail.gmail.com> <20240306023143-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240306023143-mutt-send-email-mst@kernel.org>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 7 Mar 2024 12:16:11 +0100
Message-ID: <CAJaqyWcDMu58H6P3FvyTM7L-GphLB1kj7fcOTBw6FC-O2DcpZA@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] virtio,vhost: Add VIRTIO_F_NOTIFICATION_DATA support
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, Jonah Palmer <jonah.palmer@oracle.com>, qemu-devel@nongnu.org, 
	si-wei.liu@oracle.com, boris.ostrovsky@oracle.com, raphael@enfabrica.net, 
	kwolf@redhat.com, hreitz@redhat.com, pasic@linux.ibm.com, 
	borntraeger@linux.ibm.com, farman@linux.ibm.com, thuth@redhat.com, 
	richard.henderson@linaro.org, david@redhat.com, iii@linux.ibm.com, 
	cohuck@redhat.com, pbonzini@redhat.com, fam@euphon.net, stefanha@redhat.com, 
	qemu-block@nongnu.org, qemu-s390x@nongnu.org, virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 6, 2024 at 8:34=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Wed, Mar 06, 2024 at 08:07:31AM +0100, Eugenio Perez Martin wrote:
> > On Wed, Mar 6, 2024 at 6:34=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
> > >
> > > On Tue, Mar 5, 2024 at 3:46=E2=80=AFAM Jonah Palmer <jonah.palmer@ora=
cle.com> wrote:
> > > >
> > > > The goal of these patches are to add support to a variety of virtio=
 and
> > > > vhost devices for the VIRTIO_F_NOTIFICATION_DATA transport feature.=
 This
> > > > feature indicates that a driver will pass extra data (instead of ju=
st a
> > > > virtqueue's index) when notifying the corresponding device.
> > > >
> > > > The data passed in by the driver when this feature is enabled varie=
s in
> > > > format depending on if the device is using a split or packed virtqu=
eue
> > > > layout:
> > > >
> > > >  Split VQ
> > > >   - Upper 16 bits: shadow_avail_idx
> > > >   - Lower 16 bits: virtqueue index
> > > >
> > > >  Packed VQ
> > > >   - Upper 16 bits: 1-bit wrap counter & 15-bit shadow_avail_idx
> > > >   - Lower 16 bits: virtqueue index
> > > >
> > > > Also, due to the limitations of ioeventfd not being able to carry t=
he
> > > > extra provided by the driver, ioeventfd is left disabled for any de=
vices
> > > > using this feature.
> > >
> > > Is there any method to overcome this? This might help for vhost.
> > >
> >
> > As a half-baked idea, read(2)ing an eventfd descriptor returns an
> > 8-byte integer already. The returned value of read depends on eventfd
> > flags, but both have to do with the number of writes of the other end.
> >
> > My proposal is to replace this value with the last value written by
> > the guest, so we can extract the virtio notification data from there.
> > The behavior of read is similar to not-EFD_SEMAPHORE, reading a value
> > and then blocking if read again without writes. The behavior of KVM
> > writes is different, as it is not a counter anymore.
> >
> > Thanks!
>
>
> I doubt you will be able to support this in ioeventfd...

I agree.

> But vhost does not really need the value at all.
> So why mask out ioeventfd with vhost?

The interface should not be able to start with vhost-kernel because
the feature is not offered by the vhost-kernel device. So ioeventfd is
always enabled with vhost-kernel.

Or do you mean we should allow it and let vhost-kernel fetch data from
the avail ring as usual? I'm ok with that but then the guest can place
any value to it, so the driver cannot be properly "validated by
software" that way.

> vhost-vdpa is probably the only one that might need it...

Right, but vhost-vdpa already supports doorbell memory regions so I
guess it has little use, isn't it?

Thanks!

>
>
>
> > > Thanks
> > >
> > > >
> > > > A significant aspect of this effort has been to maintain compatibil=
ity
> > > > across different backends. As such, the feature is offered by backe=
nd
> > > > devices only when supported, with fallback mechanisms where backend
> > > > support is absent.
> > > >
> > > > Jonah Palmer (8):
> > > >   virtio/virtio-pci: Handle extra notification data
> > > >   virtio-pci: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > > >   virtio-mmio: Handle extra notification data
> > > >   virtio-mmio: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > > >   virtio-ccw: Handle extra notification data
> > > >   virtio-ccw: Lock ioeventfd state with VIRTIO_F_NOTIFICATION_DATA
> > > >   vhost/vhost-user: Add VIRTIO_F_NOTIFICATION_DATA to vhost feature=
 bits
> > > >   virtio: Add VIRTIO_F_NOTIFICATION_DATA property definition
> > > >
> > > >  hw/block/vhost-user-blk.c    |  1 +
> > > >  hw/net/vhost_net.c           |  2 ++
> > > >  hw/s390x/s390-virtio-ccw.c   | 16 ++++++++++++----
> > > >  hw/s390x/virtio-ccw.c        |  6 ++++--
> > > >  hw/scsi/vhost-scsi.c         |  1 +
> > > >  hw/scsi/vhost-user-scsi.c    |  1 +
> > > >  hw/virtio/vhost-user-fs.c    |  2 +-
> > > >  hw/virtio/vhost-user-vsock.c |  1 +
> > > >  hw/virtio/virtio-mmio.c      | 15 +++++++++++----
> > > >  hw/virtio/virtio-pci.c       | 16 +++++++++++-----
> > > >  hw/virtio/virtio.c           | 18 ++++++++++++++++++
> > > >  include/hw/virtio/virtio.h   |  5 ++++-
> > > >  net/vhost-vdpa.c             |  1 +
> > > >  13 files changed, 68 insertions(+), 17 deletions(-)
> > > >
> > > > --
> > > > 2.39.3
> > > >
> > >
>

