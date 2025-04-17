Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451291172A
	for <virtio-fs@lists.linux.dev>; Thu, 17 Apr 2025 01:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744854567; cv=none; b=KRoaKPzrnmU/92hSqD0ebojZsnEHfCDX14Pq2Fs2mviDyLaCNFAYXUmy9G2fY1TkX80Z7t6Wkl7P3qPVMmyyeSi0b/T22aThmWUNezYKO9yw1zpbKxJikWg+/IQ3hiQetqnIH2lai7uWQXo1d0uGLEDcFKEmZ+HPENlV5WqXLVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744854567; c=relaxed/simple;
	bh=Ac9ljzYMGXmeexunKmU6ZSR542/F06QdlaBYL41LG+w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F+bezM/QMym32ryyu4MLa3IbWusu/BOBnI/JP9wvlpJIavicfkKFDfumK9i5MiNqbI47Apd/hKUXfxJ58uyoVZoYi27vGXlykjw4I7aun3HUsI3AozaTzIwcU31So3BVcVc4XAq6UI4lWqmDRkc1mjKRilKi6xHvVIPctrHktu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LhbLsykJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LhbLsykJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744854564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoXW3euL7P1b5uSmPIoxAMaBPZOcNV1ldqEm0tWPLn8=;
	b=LhbLsykJafncx+6NKPWMyY4CkT0x+6OjhcTRYQS+3qOKD4wQsayBqRq2FWuK36H6YAMNIZ
	6xGhOMaTVlXSAMzyPuGfBwScan2NCzXbvnekYwjJqcC07RGqkoY2Sm6Wr5Cw+MCj27COpG
	mVkGh6i3BFEzMXzTdn5Goyo3kxGWXxg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-P8f3vRIZMiGd7Mxq8_ASRg-1; Wed, 16 Apr 2025 21:49:20 -0400
X-MC-Unique: P8f3vRIZMiGd7Mxq8_ASRg-1
X-Mimecast-MFC-AGG-ID: P8f3vRIZMiGd7Mxq8_ASRg_1744854559
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5f4b7211b65so213598a12.0
        for <virtio-fs@lists.linux.dev>; Wed, 16 Apr 2025 18:49:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744854559; x=1745459359;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eoXW3euL7P1b5uSmPIoxAMaBPZOcNV1ldqEm0tWPLn8=;
        b=u3l/ZMj/yOS6t6zz0y6suKr2WiguAQqsTzGsOtOAICw5Dg74ZsUg71qwIbkevYDWZP
         urDfjkIOUhX7TIh7RwbpJCXgfVQE6JCnWnwSIt2L75AfISByv7CyuYfr2hfsZRNgwkyX
         FGIuWknsVwgvD1pPbXhcN7xRu8N/LcAN+H/ZqFwc4YVg9AERVJmr6bguo9Pm8tBAgxN5
         JL4onktMKe0AluT616cL8rqxCpaHF0YwXL8PFfNPymwWy23jFfeBQtzXTw43F/WqK6y9
         fusKjBh3Mlp63T+YdCYno2LK6ryb28rq+0EeNm1tkGzobiaBLOarlxlN/nOtL03I0rAE
         MUdA==
X-Forwarded-Encrypted: i=1; AJvYcCVsKoLXmU2FouR6GVRQ6WnUpBW+31nxXeMV+4gYq++S6fdaBaNZfrmYXmOcLH+7cz9JrJdOT/TagKM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw50vz+DyV15OJSOQq470Y5Au/VcTLRP/ibA6jI7sSEUI9HQbGZ
	9BJ/4wsrcAiWAZINYIRqStOJ8h7cLT9QOcHYlfjbi6BHAP0vmVLBEcBFMuEekLBD5rCWCdiQk9k
	PUJ18alJ+vA/XLqCaUTahZmSM/qR92qm4xersbfi3aLX2COmVsHLe0I8ZKcJSmb14b9x3r4Q1NP
	YKXi/geMyzBVc4IIB/2tYQkYaNx25SpY5A
X-Gm-Gg: ASbGnct/FrZ5TfsxN9ZV+0ZCgCnFTQMopDml8H06YENnj3VsA7pPkhQKqrQ6qojkxMn
	cn6ZhFilW4fLdNNwfGO6mAhtDWwBpr4h4+/VXElCEFCZTehdQU6z/ugHqK0bWxIQf7/tIqw==
X-Received: by 2002:a05:6402:3486:b0:5ed:837:e3db with SMTP id 4fb4d7f45d1cf-5f4b770ba1fmr3913784a12.32.1744854558905;
        Wed, 16 Apr 2025 18:49:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFz9s8GC12Am+90eLD0JT2AHn+T88kVZVNYDHzSNx3KUp/zbpO0N2dDHR9WOl/NTV7ff3nUxoqD/2eq7jKlDRI=
X-Received: by 2002:a05:6402:3486:b0:5ed:837:e3db with SMTP id
 4fb4d7f45d1cf-5f4b770ba1fmr3913756a12.32.1744854558548; Wed, 16 Apr 2025
 18:49:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250401151819.1526461-1-haoqian.he@smartx.com> <20250416024729.3289157-1-haoqian.he@smartx.com>
In-Reply-To: <20250416024729.3289157-1-haoqian.he@smartx.com>
From: Lei Yang <leiyang@redhat.com>
Date: Thu, 17 Apr 2025 09:48:41 +0800
X-Gm-Features: ATxdqUEbOeZjib-VfImPIPAM7Okl7Yivuy_D-UczmwsEQAmJL3TYtZQX7sFBhL0
Message-ID: <CAPpAL=zN_Opj2nyutaDeZvcKDn0z_LYqJR77n=7Yz=AnhPx-xA@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] vhost: fix the IO error after live migration
To: Haoqian He <haoqian.he@smartx.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, sgarzare@redhat.com, 
	raphael@enfabrica.net, fengli@smartx.com, yuhua@smartx.com, 
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Laurent Vivier <lvivier@redhat.com>, Amit Shah <amit@kernel.org>, 
	=?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Fam Zheng <fam@euphon.net>, 
	Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	"reviewer:vhost-user-scmi" <mzamazal@redhat.com>, David Hildenbrand <david@redhat.com>, 
	"Gonglei (Arei)" <arei.gonglei@huawei.com>, Eric Auger <eric.auger@redhat.com>, 
	Richard Henderson <richard.henderson@linaro.org>, 
	"open list:Block layer core" <qemu-block@nongnu.org>, "open list:virtiofs" <virtio-fs@lists.linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4WbDSqKfR9Ktdw6jzDD3k8L-zcN6RoZNL-bGYqyjkgI_1744854559
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I tested this series of patches v5 with virtio-net regression tests,
everything works fine.

Tested-by: Lei Yang <leiyang@redhat.com>

On Wed, Apr 16, 2025 at 10:49=E2=80=AFAM Haoqian He <haoqian.he@smartx.com>=
 wrote:
>
> At the end of the VM live migration, the vhost device will be stopped.
> Currently, if the vhost-user backend crashes, vhost device's set_status()
> would not return failure, live migration won't perceive the disconnection
> with the backend. After the live migration is successful, the stale infli=
ght
> IO will be submitted to the migration target host, which may be leading t=
o
> the IO error.
>
> The following patch series fixes the issue by making the live migration
> aware of the loss of connection with the vhost-user backend and aborting
> the live migration.
>
> ---
>   v1 ... v2
>     1. Fix some grammar issues in commit message.
>     2. Remove assert in vhost_scsi_common_stop and return error upwards.
>
>   v2 ... v3
>     1. Added more detailed comments and commit message.
>     2. Change the newly added type name and parameter name.
>     3. Remove set_status_ext, change the return type of set_status to int=
.
>
>   v3 ... v4
>     1. Call set_status() only if the function pointer is not NULL in the
>        3rd patch.
>     2. Add the more detailed commit messages for the 3rd patch.
>
>   v4 ... v5
>     1. Fix code style issues in patch v4.
>     2. Rebased on master.
>
> Haoqian He (3):
>   system/runstate: add VM state change cb with return value
>   vhost: return failure if stop virtqueue failed in vhost_dev_stop
>   vhost-user: return failure if backend crash when live migration
>
>  backends/vhost-user.c                  | 20 +++++++--------
>  hw/block/vhost-user-blk.c              | 27 +++++++++++---------
>  hw/block/virtio-blk.c                  |  7 +++---
>  hw/char/virtio-serial-bus.c            |  3 ++-
>  hw/core/vm-change-state-handler.c      | 18 ++++++++-----
>  hw/display/vhost-user-gpu.c            | 12 ++++++---
>  hw/input/virtio-input.c                |  3 ++-
>  hw/net/virtio-net.c                    |  3 ++-
>  hw/scsi/scsi-bus.c                     |  2 +-
>  hw/scsi/vhost-scsi-common.c            | 13 +++++-----
>  hw/scsi/vhost-scsi.c                   |  5 ++--
>  hw/scsi/vhost-user-scsi.c              | 18 +++++++------
>  hw/vfio/migration.c                    |  2 +-
>  hw/virtio/vdpa-dev.c                   |  5 ++--
>  hw/virtio/vhost-user-base.c            | 23 ++++++++++-------
>  hw/virtio/vhost-user-fs.c              | 23 ++++++++++-------
>  hw/virtio/vhost-user-scmi.c            | 27 ++++++++++++--------
>  hw/virtio/vhost-user-vsock.c           | 15 +++++++----
>  hw/virtio/vhost-vsock-common.c         | 12 ++++-----
>  hw/virtio/vhost-vsock.c                | 11 ++++----
>  hw/virtio/vhost.c                      | 23 +++++++++--------
>  hw/virtio/virtio-balloon.c             |  3 ++-
>  hw/virtio/virtio-crypto.c              |  3 ++-
>  hw/virtio/virtio-iommu.c               |  3 ++-
>  hw/virtio/virtio-rng.c                 |  5 ++--
>  hw/virtio/virtio.c                     | 22 ++++++++++------
>  include/hw/virtio/vhost-scsi-common.h  |  2 +-
>  include/hw/virtio/vhost-vsock-common.h |  2 +-
>  include/hw/virtio/vhost.h              |  8 +++---
>  include/hw/virtio/virtio.h             |  2 +-
>  include/system/runstate.h              | 13 +++++++---
>  include/system/vhost-user-backend.h    |  2 +-
>  system/cpus.c                          |  8 ++++--
>  system/runstate.c                      | 35 ++++++++++++++++++++++----
>  34 files changed, 239 insertions(+), 141 deletions(-)
>
> --
> 2.44.0
>
>

