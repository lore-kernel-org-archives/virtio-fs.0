Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC5B208A9
	for <virtio-fs@lists.linux.dev>; Sun, 11 May 2025 18:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746986444; cv=none; b=TY5ABQ/UxKQOaz5NuKzgsjTXOFuxI0yaVig4cx1qm31aSehxDQwkaAkI1RKTr3lGR0+wOGuSbH14o2HM50sZxMaHV2zpjbK8g9UM7Vmj5AaIzNmGi6uXdNz7Kw+4+wXLb31ClC5T1ZaFuvEPQGFb4utGhXI+HaAqDEfSBh2WVZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746986444; c=relaxed/simple;
	bh=RF6i8GS2yQQhGULAyl2zxOTS+RViTZMXwCHnOLKdSVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=jc2b1K2B36g4DszvqNzFPfYmnqUeHpFULBABiy5hgDU44tDv62vaeFYCOrhywh+7hKydoTs8Aj1Wr++Yc63FHEs5GqVFQfrQI6k5oioT0hEqC22o8KBoDoe4UZ/sK3IIoomK3uFIIAAm5tyXGfKcz17+ti8+ls7g7miDa7KwNtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FyKgkKOM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FyKgkKOM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746986440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ALE2KMQWCGBqmIePCS8sG6Vuvf8zpyoGRV/yfZwMSQc=;
	b=FyKgkKOMecq2zKdD8AFWcRQ2TETTRwBu2V3aH9A/54dh/czYLJnXvow7Nj6ToLBXVbZOFV
	z5dTVYGtxGXHiY3rhGM6N3zr7x9xmIYUsOmQ+/WVMlyzLN9/oa9mtkXPqjoC8z2cfx0SP1
	tyk2ekvlVOBdoswv07D8e/dg9UX3oPQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-557-7mN8M2IgMF2vGGFJ4sCrbA-1; Sun, 11 May 2025 14:00:39 -0400
X-MC-Unique: 7mN8M2IgMF2vGGFJ4sCrbA-1
X-Mimecast-MFC-AGG-ID: 7mN8M2IgMF2vGGFJ4sCrbA_1746986438
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3a0b570a73eso2052933f8f.1
        for <virtio-fs@lists.linux.dev>; Sun, 11 May 2025 11:00:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746986438; x=1747591238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALE2KMQWCGBqmIePCS8sG6Vuvf8zpyoGRV/yfZwMSQc=;
        b=a5tm6F7vcTlSjRHHIs37+Zq3+ik2+46NUX6aGTWYTWxoGd/wlzXxCA2wkG+LJmqvV7
         Kdx7bXrMUnL5AC5HP6ZpD4N7IsYLC1cgLdEwsNHHXKKEQv8ZAnXzIAcv9wmJiIYx3fQG
         fsbvqZvzfH9Al06ZXYitt2YisuzlxxbFZZmYlYqpCNI0ss0w4oGQoN+7MKQ+ciO9wizL
         7S912E6iedBcMYnQZtz4i15Ksgw5CAMBOuMwj9qtdJKM3i3T+1A18cyJwBd6UZ/JkF3X
         hWf3z6AITiX3o/YKlh2K+uS09nSdy5guWYthEJmtSxOnxU+m9Fmv/MIeJDUIg6VuC46z
         9yuw==
X-Forwarded-Encrypted: i=1; AJvYcCUa02PguSmDxQJ+V+lJw5MT9K6ndOXiesMwOak3JqlzandkPY1L6S8SQRNT/bx2nut4OOfMmQ6Y4t0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFB5AihtJWxxvLfClOBfLfKvle9PNa1criAOVw+sWIGkrMmmrt
	0OJE/2iPcuEWJJ6E9kRSTJnlTyBLHkcUV3+teF7MTbFSJSSK7f/kThThaoEQgKoLzCChHBlGG0Y
	It+q52wAvoUtJDxiiIXELRz0l/B751ikSbxR5+3mZ14BuPeOWeZ0ry8rmCA==
X-Gm-Gg: ASbGncvt5QS8PQ/lsBI0FCderP1rQjXDk2NJzlJjOAYaIu/g3mIHJwfwLkJJkBKBgZz
	COc56A/1ogPLC4T1U5TeLA9LmyLSqQ+wSXHSE5Tly4zqwsKvkGJlwtMCJRZK51CvrRRuhgssIy6
	DMmYq2pGN45WS4TtZcnrZ27Hvr5r7+eK0Wae7WZeOq5YU6RosyW0V7nNlAaXCL+T6N7KHiws0EE
	Fg/b8hGDu1Mq3Q0pZgeT9/fCE7bIfr46RsjqFP+AFZ2xxCWXhW/6Cl02m05EAj/9rAwdiPuBL1c
	b5dFcQ==
X-Received: by 2002:a5d:64ec:0:b0:3a0:ba27:646c with SMTP id ffacd0b85a97d-3a1f64b5845mr7656932f8f.44.1746986438283;
        Sun, 11 May 2025 11:00:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP6QZpAGTJUBarwm/jThMZVY0U+88W4RO0pCjydS8n777dkK7eO9KK2cxTY7i/hxvART9r/A==
X-Received: by 2002:a5d:64ec:0:b0:3a0:ba27:646c with SMTP id ffacd0b85a97d-3a1f64b5845mr7656893f8f.44.1746986437805;
        Sun, 11 May 2025 11:00:37 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4cc39sm9761816f8f.100.2025.05.11.11.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 May 2025 11:00:36 -0700 (PDT)
Date: Sun, 11 May 2025 14:00:33 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Haoqian He <haoqian.he@smartx.com>
Cc: qemu-devel@nongnu.org, sgarzare@redhat.com, raphael@enfabrica.net,
	fengli@smartx.com, yuhua@smartx.com, Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Laurent Vivier <lvivier@redhat.com>, Amit Shah <amit@kernel.org>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Fam Zheng <fam@euphon.net>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?iso-8859-1?Q?C=E9dric?= Le Goater <clg@redhat.com>,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	"reviewer:vhost-user-scmi" <mzamazal@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	"Gonglei (Arei)" <arei.gonglei@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	"open list:Block layer core" <qemu-block@nongnu.org>,
	"open list:virtiofs" <virtio-fs@lists.linux.dev>
Subject: Re: [PATCH v5 0/3] vhost: fix the IO error after live migration
Message-ID: <20250511135931-mutt-send-email-mst@kernel.org>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
 <20250416024729.3289157-1-haoqian.he@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250416024729.3289157-1-haoqian.he@smartx.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lyX0OEjMY7IND_o_7oCk6eO1E-iySu6Xf7lnRRHdTA0_1746986438
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2025 at 10:47:25PM -0400, Haoqian He wrote:
> At the end of the VM live migration, the vhost device will be stopped.
> Currently, if the vhost-user backend crashes, vhost device's set_status()
> would not return failure, live migration won't perceive the disconnection
> with the backend. After the live migration is successful, the stale inflight
> IO will be submitted to the migration target host, which may be leading to
> the IO error.
> 
> The following patch series fixes the issue by making the live migration
> aware of the loss of connection with the vhost-user backend and aborting
> the live migration.

tagged, thanks a lot!


yet something to improve:

in the future pls post a new thread, not part of old thread.

also in the future, pls do not quote a huge mail just to add two lines
at the end, snip.



> ---
>   v1 ... v2
>     1. Fix some grammar issues in commit message.
>     2. Remove assert in vhost_scsi_common_stop and return error upwards.
> 
>   v2 ... v3
>     1. Added more detailed comments and commit message.
>     2. Change the newly added type name and parameter name.
>     3. Remove set_status_ext, change the return type of set_status to int.
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

