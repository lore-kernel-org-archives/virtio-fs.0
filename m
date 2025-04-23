Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632D726B099
	for <virtio-fs@lists.linux.dev>; Wed, 23 Apr 2025 10:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745402606; cv=none; b=fr63WwbYajjbo+qCmZetBpBfXDmPnpbeIp8HXqPAle8UpvP54Q76DySoyB62GV+kMTSVm8PzBEY2WmXhKK9ANqmeEzOxbJVRtztkqbNsiK+tpPBiudv3Y9GN8ylpLWEnh4KEqUKnuDZ8ro1FpmFDRdJPr0MPtkEcZ7zOUbShk5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745402606; c=relaxed/simple;
	bh=2yt4XnIaSVHhI+eFxGyBtC4Upz0I4jy4j58fjXpXHyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sZ/TaXe2QHYd+SRPqle7awDW8tId5GOkeeDaay19+5xWCeKVS1XsovLwoJYBXwdICzRiI1WtVvUQ9HikeAb6F7yj/BpzuP5T+xy/BvZ9v8eiBdO3XfwrcWf8YDm98eC+P1/qAiTA/MPTmjmIHi3FumWYaLMKH70G+LZsInW0HeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bTkz6zmF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bTkz6zmF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745402603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2yt4XnIaSVHhI+eFxGyBtC4Upz0I4jy4j58fjXpXHyw=;
	b=bTkz6zmFbo+ZEr0OHSAbUyd8cnxSKpXH2fos8USvBVjlxegO5qu3MdC/LbMwrsxGhbDHGS
	RMy9I6AJHHYTfSR4BR07gtWvHEQ+4X2kWpRqzQIls0X3bbFvbHeBskR82qE/sUE+GbAtbe
	fntPn5LDANNIrTjuOIlL3g+0yuRylyA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-BmsihwzGNhyOMcVgHj7ycw-1; Wed, 23 Apr 2025 06:03:21 -0400
X-MC-Unique: BmsihwzGNhyOMcVgHj7ycw-1
X-Mimecast-MFC-AGG-ID: BmsihwzGNhyOMcVgHj7ycw_1745402601
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43ce8f82e66so35455195e9.3
        for <virtio-fs@lists.linux.dev>; Wed, 23 Apr 2025 03:03:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745402601; x=1746007401;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yt4XnIaSVHhI+eFxGyBtC4Upz0I4jy4j58fjXpXHyw=;
        b=duzbi8R7cua4/kghVAJ87BEQgeNDuYq+AeSFOuzADlLuyKY8wN7ycQOXqFlJEx2lBe
         HbHGbDXavv5BYbwLNplIqzhedIjFzU+PY4EgfEGHwIphQ5B83f9KaHpgYyjenUX/V6ft
         pAVe18/ZIPm9cNadBF1H72vVkHqwTtKvbR8Nx5GYuutMyaPKZqrF37J1tOoE5SQ1isEz
         xDcnydLo19jXRzkcc3j1Vzg893TjnIcaGfleTOCTL8XXvegDLu52oi9KpZijwggHSG6A
         vWdBGwHgokIGBdvACmvPFvhXACipG5LrYAViIccBzbBreknvs2XZYQfWE5GP4JwfCDww
         3WdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWt0sdEh+eCgVfX51TkD5XOctjim1Fgmxj/10WRIxSK6qgc6Fij0ouN0Pn9zRCIQDUUfSDVv489l1E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzud8KT0hAiAvecUut93GrYxrhkWcfi5zajkGJkK66nWDhYv++v
	r0wgrKMuqs0UNixbVVxogFAyCR4nE9kogZdzU/ECLcPwIaC+v+qtcUcxpR5BntrqTbrsPOfg4ik
	ZO2LIhpMn6wFph9YMR/1L6a5C/2aO4E1rF0XlX4TdSSaDJR0mwDUsdvJILw==
X-Gm-Gg: ASbGncusJOg8htO1eCKVUrW+qGnq4FhTSh0LinBp5D/Y1oYh0Yaj0ZL2cpM+M28kerP
	JNFmS6h2nrZ07UaTXY7LffsjToSsuqwUpEUrH2mu/A33BZ7/wwG8VhVw9/ow0mGpeDn9N97a5HF
	H5BADa+H5GmhdHCfxGaVtLCrMBh5cMxxGucjGeA+FkPHMWv0hjrjSSwa92i9VQ/H4ulWzAZmZiX
	THZInVCipFVklkno+/C8okm4SNSW+6wQaJ0mFtd1daQkrZS8Cghr5k9y5dlQYGRdl4o9Y0KoVWC
	WJvOKg==
X-Received: by 2002:a05:600c:1911:b0:43c:fd72:f028 with SMTP id 5b1f17b1804b1-4406ac3a9f3mr154837425e9.29.1745402600790;
        Wed, 23 Apr 2025 03:03:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8euMN/wVa9owSsB3+PoiIBM0iqkyb41jQRDW+a5zyolKau8WB9dkkB/xH4h/C7Y2IW+UCeg==
X-Received: by 2002:a05:600c:1911:b0:43c:fd72:f028 with SMTP id 5b1f17b1804b1-4406ac3a9f3mr154836995e9.29.1745402600397;
        Wed, 23 Apr 2025 03:03:20 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa4a4c8fsm17856740f8f.89.2025.04.23.03.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 03:03:19 -0700 (PDT)
Date: Wed, 23 Apr 2025 06:03:15 -0400
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
Message-ID: <20250423060235-mutt-send-email-mst@kernel.org>
References: <20250401151819.1526461-1-haoqian.he@smartx.com>
 <20250416024729.3289157-1-haoqian.he@smartx.com>
 <20250416024729.3289157-4-haoqian.he@smartx.com>
 <998122CC-C357-4499-831D-DC739E42A520@smartx.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <998122CC-C357-4499-831D-DC739E42A520@smartx.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xX8GwjH2PVRpsRY3I8tRE3kcvEyQQvCW2e_2q1aZp44_1745402601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 23, 2025 at 02:45:42PM +0800, Haoqian He wrote:
> ...
> Gently ping. Looking forward to the review of these patches.

it's tagged for the next pull, but pls do not quote all
of patch just to add 1 line.
Thanks!

