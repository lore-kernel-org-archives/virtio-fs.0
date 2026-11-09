Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794219943;
	b=D642eC5+3li85Nci90ZABS86hVhOTJP+q4mvdd4y3CaN4mzU34AB/xqtU634NHW8h1DU
	 0pQPrMpDUM/Su/eEyapjO68FtcV/oEeYinUei2lYTbFMq93KXaQkcsM7DM9DMolgqDf75
	 f3p7MCr3nTYoRcgTxpg+nuGXo8m+mg1+cqII9lY2llawnYPkZeE2n+Etw46mSGsv076MV
	 ypgrV/8+WmzwJG1ddYTN3Cun+LLv67zv/sfWCZc7Thx3Ogm7UKms9LiGnS/tcvo1yQ30C
	 8AzCIG2rO5EAqC6V5Rns9QRdxaiIsKgCOdM1J3Nu6fZlqoU2hVmfPtV4rxRcr9/X1gQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794219943;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Type:Content-Disposition;
	bh=pXEKbtbosUlzfcqYYDS6HEaUWzEBNVodepyG4eI4gKI=;
	b=ADEeiVJuOpIaEdnkM740SmyAStbTrk5q9CCM98j7r7KMzveSLWfPFgP1imMVKnA/LZYm
	 5f2Ume7EtKEkl6RrbrOrFmww/8qT8cvvkUjXetp3Dh6PblyUVWt48lXLYaJhrP2OQo0Kv
	 gdhhrHjht1xIGN0As620P+HTK+eklYSmGBcXY5TDIZGYWA8SvIRxlfuL0k9XBGoN3/gob
	 bSIbD9lD228W6SHBcsIyUugWjowut49EBaj0ujAsyuOUXKbbdkhnf4jA0Ktj4Ji8FlnQX
	 Bwjd/lh5Po9Y3Uss0dLEFAUK7TY0UWHTcdWHYsEcuPkSBbwLgFErGyBDeUfg9RlaqwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eFe4mZO2;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D3606A326
	for <virtio-fs@lists.linux.dev>; Mon,  9 Nov 2026 10:25:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DE3D3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=eFe4mZO2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794219941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pXEKbtbosUlzfcqYYDS6HEaUWzEBNVodepyG4eI4gKI=;
	b=eFe4mZO2MBCgD5TtP1W4muHFgBCgBjTmwIziMU5G4WtKagQPLsI2dyFHhX5YiDLUy3JAaT
	330mQkURhx3VSoBxMGAVWyzARfX3XbKMXJ/WIfeRXwDc5a3xBTG+6oHaA6ZNblLgYeXYXU
	rgsYSIBr61NbUWtYTpPLW2ml6+rk8ME=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-M5MQA9OeOBKcYHHginIneg-1; Mon, 09 Nov 2026 05:25:40 -0500
X-MC-Unique: M5MQA9OeOBKcYHHginIneg-1
X-Mimecast-MFC-AGG-ID: M5MQA9OeOBKcYHHginIneg_1794219939
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4b764ffc014so6831375e9.0
        for <virtio-fs@lists.linux.dev>; Mon, 09 Nov 2026 02:25:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794219939; x=1794824739;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pXEKbtbosUlzfcqYYDS6HEaUWzEBNVodepyG4eI4gKI=;
        b=TZMcxStyFZdjuKNDqU0fy4XWY7z8cQlb5maJhR1wq9gytXvxGPnNMrOIK7paWUMk/0
         VB1yw/HozZUQMdCZGc323ChAGfOugiujtFRdUBeT0K2pwEJRkmSXeghKtA7opKMrVpBW
         i1ALUuE92X+BD2jQxNZJQtr5LEnWf+GypDYUUKA6rDJxQXP4WEj6Zwf5IUMLmlv1EmNz
         0xxMu68bl6SXScTwIyxHfXMLcfNwhRsyrunTcoI0bekGaEFusoEBWFY1yito1mZyXdbx
         COtqsHkhr33eZWwO3GyR/ODY2vXWQL1n/km5x0TiP0nXrUnuVC2C1WofohjW6GgPKvmY
         zoZA==
X-Forwarded-Encrypted: i=1; AL+hErHbAE65utAHLGsi0d/6dJjCDAjdx+Makqct9pfKZ7LG2pSUpx5ihEc88jQcjpmiHUh5o1Gc9Lwz0yA=@lists.linux.dev
X-Gm-Message-State: APuU4Z9CMkPXL11R69c3wTylk+BqR0Yrvsfg2PZ1Kkrki0h77ESvlboB
	X9MQVvfupStyTkYnGuUt9HH7hY+jLrk6C9ppPyfgLULrG3Wcf4x1dviKqqD+o7cz66GRO0kRy1y
	IirwJkqcPGKjllVnt+GFR5fJ7AxbZ9dL/3ElAyqml+bWhH9pivzf+F4GOkvLI9A==
X-Gm-Gg: AYBFou0gZZLO33E3jl5/hfu246isp8UWS7O7iezW2ZI2+POa+3X6CEiNMpMQWzTLqVn
	IRgKawOW8H6aqD81fQeoYyacQZvlwBMHlYdhi+dSIaPeq5daxS+aIE3GCxFaSgx6m46TAmJ/hC5
	e8AcLLFnYA60mw/hPAeVKpIksjPqRCogvSNA2KL44aYFiTfw0So7TByer4pHr0t3z7rqitHLz7t
	v+t0W86hHdxhWHyPZ0N7dubpaYUtG7de6MJG2br5q+QaGZcn/o1bdVJ7isyO85YNMlT3nJOmw7P
	WBLU7q/fh7LbX3RrgpNy3akPIS2bvPB51ndtNwjuYx4/zMzFMHzNgIcE7jWtl+AKNj4jUZmyHvf
	hjry9jZ/Ic/iNccdOzJigv/IQhEPR5HIVmqYG2vvCrgYACBB0PNXW
X-Received: by 2002:a05:600c:3113:b0:4a1:f720:74cd with SMTP id 5b1f17b1804b1-4b963c91d7fmr67427655e9.24.1794219939141;
        Mon, 09 Nov 2026 02:25:39 -0800 (PST)
X-Received: by 2002:a05:600c:3113:b0:4a1:f720:74cd with SMTP id 5b1f17b1804b1-4b963c91d7fmr67427265e9.24.1794219938670;
        Mon, 09 Nov 2026 02:25:38 -0800 (PST)
Received: from sgarzare-redhat ([80.116.143.202])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b90ee1ddc7sm178161235e9.4.2026.11.09.02.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 02:25:38 -0800 (PST)
Date: Mon, 9 Nov 2026 11:25:36 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
Cc: qemu-devel@nongnu.org, "Dr . David Alan Gilbert" <dgilbert@redhat.com>, 
	"yc-core@yandex-team.ru" <yc-core@yandex-team.ru>, Stefan Hajnoczi <stefanha@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, virtio-fs@lists.linux.dev
Subject: Re: [PATCH v2] vhost-user-fs: fix virtqueue array leak on realize
 failure
Message-ID: <avGfejcI5dd7kFLT@sgarzare-redhat>
References: <20261109062401.81161-1-dtalexundeer@yandex-team.ru>
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261109062401.81161-1-dtalexundeer@yandex-team.ru>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wPJtwEE4YHwnmQqtXwbw5q4oA_yFOVs2yJsFPEjEjyE_1794219939
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On Mon, Nov 09, 2026 at 11:24:01AM +0500, Alexandr Moshkov wrote:
>On failure, vhost_dev_init() clears vhost_dev, so the error path frees
>NULL instead of the virtqueue array. Keep the pointer in the existing
>vhost_vqs field and use it to free the array on failure and unrealize.
>
>Fixes: 98fc1ada4cf7 ("virtio: add vhost-user-fs base device")
>Signed-off-by: Alexandr Moshkov <dtalexundeer@yandex-team.ru>
>---
>v1 -> v2:
> - use the existing VHostUserFS.vhost_vqs field in realize and unrealize
>   instead of local vars.
>
> hw/virtio/vhost-user-fs.c | 10 ++++++----
> 1 file changed, 6 insertions(+), 4 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

