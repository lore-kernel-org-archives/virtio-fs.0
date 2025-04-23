Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98DD26982F
	for <virtio-fs@lists.linux.dev>; Wed, 23 Apr 2025 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745402686; cv=none; b=hzpFnNzjv5aJ/q92DcJTonSsmcVL8CUSLQm3DEOlDorSZQctAMI2w3VRClCl0jHNbGho4RDu82btUlig3LQIGTissuRtZ+BfatzUt6iTYBaf96Fd8Hi6ZceeIKEqrxesEqM7JuERGzUVjWQQd0hgpwidM0fGXE+sFqGjh7dzg8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745402686; c=relaxed/simple;
	bh=Q1DZEFD0o9lF+OIlXe5WsD53lQTPEpygAsFncnn4fhE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=r6RqCFYYsrjGsFiVCdOmfjVSSAj8vkvMNH/mgpGRKatczOngkcRGZONZGVcD5FhHPb+A6tcbptyI06HLQdskYmj7Jb97oJpqWD+3BL3t/TH5oS126IMu0GKqC0teQ9vM5JmSbNbiARGNnjGjnM+id5AlgZT01/cxybSyQWhBHYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gfqEg3n8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfqEg3n8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745402679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dfJ8ee1JcGaW26GYypXXmBRYQFwhYmKpVjA9hXGr90A=;
	b=gfqEg3n8z+5PVoWUJA5A/Us1nuZfaJZO7GushP9UEpKg29dgvv8eLaISy3tQc06VmJO6uh
	pp80oURY6uf5YkM+3qYrLUX6c/XPUpSodYruQtKpJfX1H5BrwjxC4Fveth1oLUS5WkpXli
	3rdQGkN5Fg/MeT9NQnEEmRmYy4XN6vY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-QS16Uv7VOkSohRz7NlYGTw-1; Wed, 23 Apr 2025 06:04:38 -0400
X-MC-Unique: QS16Uv7VOkSohRz7NlYGTw-1
X-Mimecast-MFC-AGG-ID: QS16Uv7VOkSohRz7NlYGTw_1745402677
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43ceb011ea5so34763105e9.2
        for <virtio-fs@lists.linux.dev>; Wed, 23 Apr 2025 03:04:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745402677; x=1746007477;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfJ8ee1JcGaW26GYypXXmBRYQFwhYmKpVjA9hXGr90A=;
        b=O0mhmZjuoEFZNOpY/BPyiOpfNal8MydK6eEBT7lRj8mekgefVEqdv6RRt8TWQB70AX
         rx9vmN0VIN9Q6a9Zs3G5xQbjLLKmQiHUK3GnWeYaaL6uwQEF7IZZsJSts7nrL7ZZTqQL
         MzRYjwA2o3DFw06uCMCeY18qwgqwQLxTobkyWmw8pHYbxmOSxbNjGKnJIMaBSe3cwNrp
         qWfbYrariP6fnQXXAlPhjzkhki2ZyLiVr1LWjQzbMlJgBGl8C+Z9xTIBfdnhmDzfJB27
         I5Gd/6wHzBBwbmeJ78MB7OTxrc7e9KINw9rsPhYJ3N/oNRMZfqV4+ObX/cMWcdSaf/bX
         EM6g==
X-Forwarded-Encrypted: i=1; AJvYcCV3oIvZadl4K0DmfJKotX9X9XIiqqubjK3/rhAsa0VcmxssyeLzjU64BkbChRDih16tKX0ehXIDfD0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwktgFzVNLry8Z1t5yQ0jPiNBFxCfmZSIX2oHiozB4vK25j94fn
	C5zwiA8qTbaPc0Ox5qDyFqVnEpGyUClfOgs3176xc266qjdSzqFRfFq2qAsbWgqQNSDPdnFefNG
	21H4fPiFqF8UM6LC0xynF/DN/U82yzM2/LpjlfC3BhtQTF2TlXyK12+ndFw==
X-Gm-Gg: ASbGncv/TC/jW+orRViLUkxjfFKfg0GRSVCSplFD9SMUmNqBjJyvIwojyjN6YvTf4SR
	ZMpbItu8OzjQFiv+V4rzuc71pDB1pGa7icaWWTPWHQdKqc/wxBcfV14UzC7cDwVe/jQZ2mZ11jT
	IV1FQe1UPtsiIkG1TMi2kjk03+dH6OPq3cI6uToPm1oi3oUGQ2vMulvykqQpl5V81+heokgLQT5
	ClXQwkB1I55MlppAzkGE/YE58/01/scI0TA0ezBmo1KVmOupAJexwc//r43yW8Y4WKtQkqLuEpc
	MnF3Xg==
X-Received: by 2002:a05:600c:4ecc:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-4406ac0aec8mr135507195e9.22.1745402677015;
        Wed, 23 Apr 2025 03:04:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIFXjqe3M7fS9Zn7zaRr2MREQb058bSeQBbesrewGJ1D94yTO2P2NnnEVqH/uN+77wlnvJkg==
X-Received: by 2002:a05:600c:4ecc:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-4406ac0aec8mr135506745e9.22.1745402676670;
        Wed, 23 Apr 2025 03:04:36 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-44092dbe7e1sm19787025e9.33.2025.04.23.03.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:04:36 -0700 (PDT)
Date: Wed, 23 Apr 2025 06:04:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Haoqian He <haoqian.he@smartx.com>
Cc: qemu-devel@nongnu.org, Stefano Garzarella <sgarzare@redhat.com>,
	Raphael Norwitz <raphael@enfabrica.net>,
	Li Feng <fengli@smartx.com>, yuhua@smartx.com,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
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
Subject: Re: [PATCH v5 3/3] vhost-user: return failure if backend crash when
 live migration
Message-ID: <20250423060336-mutt-send-email-mst@kernel.org>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
 <20250416024729.3289157-1-haoqian.he@smartx.com>
 <20250416024729.3289157-4-haoqian.he@smartx.com>
 <998122CC-C357-4499-831D-DC739E42A520@smartx.com>
 <20250423060235-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20250423060235-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AmbMiEOAVMy-5gojOSKVcq3l9ZG7O7VYr_XQ-u2rLB8_1745402677
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2025 at 06:03:20AM -0400, Michael S. Tsirkin wrote:
> On Wed, Apr 23, 2025 at 02:45:42PM +0800, Haoqian He wrote:
> > ...
> > Gently ping. Looking forward to the review of these patches.
> 
> it's tagged for the next pull, but pls do not quote all
> of patch just to add 1 line.
> Thanks!

Also pls do not send v5 as a reply to v4,
as otherwise it looks like a part of
a discussion.

