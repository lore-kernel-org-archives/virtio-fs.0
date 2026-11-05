Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793895764;
	b=2F2dEufSnOpCr5eqLV51U7pIezFLGTlGoy156nccVwFjM0u7apxVe+EAI5bPW9zU/ws+
	 3kAJXjE6wnk0hJiebqa9dRolAs7tdeuA0rnoY+6ou6UFHXY82MeFeko7g6pLnOzT0TWsV
	 fdA/csr/S4wpQLlI9X0TTFWA60G1YDpsRe3Zqp6cDfSmwED86wpGw6Py0ImvkqiNlh61Z
	 8lv7UcaPjqpkeetmjBjN1Gjk/UvkST8R9ownDFKNyw3r9UUK5a9ZsSUM1Q4r2ZNRYwacN
	 CwGLFycwYfcf8uAMh8/JvNg1vWFRnyicpX5xMkeXdpLLx5hgx5RKhsIxx/sTReBE12w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793895764;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=yp4b6kyGEJPqZint46r2vh9Z9N2SkjAHusHEqtZNfKo=;
	b=ekDP3FrcpnWThTxetPsKaBOnAUfui/5KSsH8ghlWbCsbwPCi4YEYJiHHkKkQ9msusLia
	 shL/yb6drAG+5tbPAt7GGcCZCCDvVeeODa1mVEMcBrB0/4MA2Ea9dfLIo557veSasqhXk
	 md0Yg5H6YEZDZAymsenjM22KHDZEWbTHVzkOIQ/7f0t96ZvMJk5NFgHQZ73yEJa2e7Run
	 lLhpcmIQPd7dk1gH8oHlJmtRdAj7q7rpGrPQ2QQNWBV+n5x+FunwJ/effRT5fS639/alw
	 bwDYFnnt79l7y1uPY5SgzRRp/1pvp/MARpZJxNMHPzWJe74gzEkXzid2qjhjXI6Qz6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="JH4/AJvc";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE4D606A330
	for <virtio-fs@lists.linux.dev>; Thu,  5 Nov 2026 16:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDE4D606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=JH4/AJvc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793895762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yp4b6kyGEJPqZint46r2vh9Z9N2SkjAHusHEqtZNfKo=;
	b=JH4/AJvc/mR+S5X44wHz5LbleJlgMed4Iwl4yd0RXWBsQ4FmX/2nAqfJFxJHt4MreFoyG9
	NWtB22WjZKY5A6bZvwlB6Xe+f2C+VP6KwC6daP+qAtJs5OuXWmVtMOSLsUMf6LbRLdLc61
	x8H6j7HddMkp+/4JtZ2jWtzuTQacgwg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-eukgoq90OrybtRYqytHSBA-1; Thu, 05 Nov 2026 11:22:40 -0500
X-MC-Unique: eukgoq90OrybtRYqytHSBA-1
X-Mimecast-MFC-AGG-ID: eukgoq90OrybtRYqytHSBA_1793895759
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a210f93860so17624245e9.0
        for <virtio-fs@lists.linux.dev>; Thu, 05 Nov 2026 08:22:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793895759; x=1794500559;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yp4b6kyGEJPqZint46r2vh9Z9N2SkjAHusHEqtZNfKo=;
        b=1ey+XIxwW9NXzGZ1QNJd4XRrLlM0IIYKFRVBAK1VZjPFxQfaRvqujloZ8t2VfTZu3I
         J0b+PqCslhrszBJGAoEpSWY4MaL/q3ppA4YiUVStCM3hgxjLVot4ev+507VhDqIsBjkm
         oXEbFERqH67NSYysWbY7Vidn2KIE3rsOdYRKGSlEsFVIbEwp8GK8UD1W4P9rAPRonifa
         p86s+U3r+efDdHRtVTGtTm+hEJbKcDTwDpZ4PfwD/ZzdGU/lFgU9McpoY6ffutomCY5X
         YPxFPIgIjknkIDkUMrOROa0alXrEPo+FczYPocdqYHmc+bLC1gU/ZrgupZwnW5eiFHTR
         Czcg==
X-Forwarded-Encrypted: i=1; AKwUvByFh0CL2mgak8fYo0f0DyzjfI0zPpt9yLXxMWUzdYSKBUN1N0TiL2us0HU4Mzz2wzWzl5S98tfcSGA=@lists.linux.dev
X-Gm-Message-State: APuU4Z8TUkZgs/cSMcpDLdesN6sX6p9nrZEmu0447SCqu6ua5MqyUeHh
	tAqFMcdOEiTqka9lGbldKbemVfkKERMmqzmDlih56TwroyjV+V4rRM1XPM7kcL4t9jK1rIg3CdO
	4omGFf9MeccSoPTVnI7RKv7DNwUHWM0RMY52xVB9vlWYMK80J0Ml3B8Kq4yn3bg==
X-Gm-Gg: AYBFou2SlugpqqBnuZk+NA+aEznz+a66LwCsiRphuLRDP/Vr5dTxkiRL8XIDp/dBY22
	yFpmahXhTZzf3pMOAhHe0cYrg82jqrGt/CaA7/f6cjYdHJ6jIotr3GuFf9vcD1MzuXQBD2/Ivq3
	a91+VkILYgchu47+onmmAv+ReBFPatRrezxbg2L5k4e/GUw+8zBbwiq4xNqCXyHqy1bK4ZbdR/K
	87X4ZZHUVtg2nKQQr4kvycrJjxntzzici5LrNDEAwxg2cDNkw5JnhPx12r5FyjX8Y+L+VNdUT+/
	nzuV2Xy5ekwZ2xDAVGHeu5rUwXcyUS3RzfgX+Mrk3jLX9R/utlxWGMC5zt7A8wBM4uj3h+a2kFC
	laTytrK9n7PbMRIQIRBQDBIuBzJtAruxb35P/DE3horQJ3D3fWw==
X-Received: by 2002:a05:600c:37cc:b0:4a2:1cc:6551 with SMTP id 5b1f17b1804b1-4ac1980143dmr389437505e9.35.1793895759196;
        Thu, 05 Nov 2026 08:22:39 -0800 (PST)
X-Received: by 2002:a05:600c:37cc:b0:4a2:1cc:6551 with SMTP id 5b1f17b1804b1-4ac1980143dmr389437015e9.35.1793895758684;
        Thu, 05 Nov 2026 08:22:38 -0800 (PST)
Received: from sgarzare-redhat ([5.77.70.210])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed08343dsm10816165f8f.30.2026.11.05.08.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 08:22:38 -0800 (PST)
Date: Thu, 5 Nov 2026 17:22:35 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>, 
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@lists.linux.dev
Subject: Re: [PATCH] vhost-user-fs: fix virtqueue array leak on realize
 failure
Message-ID: <CAGxU2F78TcwwEhudRsgDP15JszMEr3CY50omS+13qmh-jqASgA@mail.gmail.com>
References: <20261104080939.439160-1-dtalexundeer@yandex-team.ru>
 <auyR97ogGdws_udv@sgarzare-redhat>
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <auyR97ogGdws_udv@sgarzare-redhat>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yegKLu5u5ES31DCxSS1is8P_VjVD9sml1n8TE6Q_O5s_1793895759
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, 5 Nov 2026 at 15:29, Stefano Garzarella <sgarzare@redhat.com> 
wrote:
>
> On Wed, Nov 04, 2026 at 01:09:39PM +0500, Alexandr Moshkov wrote:
> >On failure, vhost_dev_init() clears vhost_dev, so the error path frees
> >NULL instead of the virtqueue array. Save the pointer locally and use
> >it to free the array on failure.
> >
> >Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
> >Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
> >---
> > hw/virtio/vhost-user-fs.c | 6 ++++--
> > 1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/hw/virtio/vhost-user-fs.c b/hw/virtio/vhost-user-fs.c
> >index 0d8842817a..9b33fe13bb 100644
> >--- a/hw/virtio/vhost-user-fs.c
> >+++ b/hw/virtio/vhost-user-fs.c
> >@@ -198,6 +198,7 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> > {
> >     VirtIODevice *vdev = VIRTIO_DEVICE(dev);
> >     VHostUserFS *fs = VHOST_USER_FS(dev);
> >+    struct vhost_virtqueue *vhost_vqs;
> >     unsigned int i;
> >     size_t len;
> >     int ret;
> >@@ -255,7 +256,8 @@ static void vuf_device_realize(DeviceState *dev, Error **errp)
> >
> >     /* 1 high prio queue, plus the number configured */
> >     fs->vhost_dev.nvqs = 1 + fs->conf.num_request_queues;
> >-    fs->vhost_dev.vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
> >+    vhost_vqs = g_new0(struct vhost_virtqueue, fs->vhost_dev.nvqs);
>
> While checking if others users of vhost_dev_init() have the same issues,

FYI backends/vhost-user.c has the same issue. I'll send a patch to fix 
it.

Thanks,
Stefano

> I discovered that most of them store it in the parent structure (the
> equivalent of VHostUserFS). Then looking at VHostUserFS I discovered
> that we already have the vhost_vqs field there since the beginning, but
> we never used it, so what about using that one here and in
> vuf_device_unrealize() ?
>
> Thanks,
> Stefano
>
> >+    fs->vhost_dev.vqs = vhost_vqs;
> >     ret = vhost_dev_init(&fs->vhost_dev, &fs->vhost_user,
> >                          VHOST_BACKEND_TYPE_USER, 0, errp);
> >     if (ret < 0) {
> >@@ -272,7 +274,7 @@ err_virtio:
> >     }
> >     g_free(fs->req_vqs);
> >     virtio_cleanup(vdev);
> >-    g_free(fs->vhost_dev.vqs);
> >+    g_free(vhost_vqs);
> > }
> >
> > static void vuf_device_unrealize(DeviceState *dev)
> >--
> >2.34.1
> >

