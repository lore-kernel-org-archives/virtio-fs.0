Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86BF441F
	for <virtio-fs@lists.linux.dev>; Thu, 16 Nov 2023 10:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVOSNqPG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700132364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=2sCjJjVV4K2yv3hGRV7QHNScewMtRKf8RzEEv7WzTMg=;
	b=fVOSNqPGuS5nz+69OUs6zqCgjcDZW0zKrWmErUJS4dzs3NxecYVTguxlzvDiV4ec4OxaTJ
	qDgEbLq54COyQbLZ4cDPbIKSIHINxwZJaJoLMW/LUdS1JopjErGDpadIzfYfnrECB1LlF3
	D3hHMXXKY9+S8TExtbPq4MESumuA4rE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-0_rTL47VPpy79RQdSXPKow-1; Thu, 16 Nov 2023 05:59:23 -0500
X-MC-Unique: 0_rTL47VPpy79RQdSXPKow-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2c509a6223eso1369311fa.0
        for <virtio-fs@lists.linux.dev>; Thu, 16 Nov 2023 02:59:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700132361; x=1700737161;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2sCjJjVV4K2yv3hGRV7QHNScewMtRKf8RzEEv7WzTMg=;
        b=CzDxhomm/b9a13pmhd5+34DeuF9blrdi9huJ5lBr52PyJwiLbwrSVfYbOqvJioF2sc
         fh27DETNef2/PgQDkUoN/BcduXfvbBgx5BRoTQMJ4Dd1IJ6d1TgMQ4W+O0C+IbrlYbRD
         jGJolJv9rZHvwS6EkmI3AR3rHhnZCAImA/0QGQuSVbOZtsTRfP8k1esk4stE1qovG33s
         +I4dbrOGSHCojyxSa24Xy1qR4bv5eh/h65Dhdzx7wvSBinU0C57nVN+/jGRuylyofQDF
         X0/HOIFcvjxD7T26nLWStHRQ18n+iC/a3pBDwBDhVUXvA2C2WXmC/skZ8FjxT6Xz4nVk
         ShxQ==
X-Gm-Message-State: AOJu0YwjgBy3ZwuMGFtB6sUYFr7anYrAP/pobXZscPaBxZktN0ZTmYxl
	pm1H1bihkeM3YDhdrNqAAkclCl8IwYXyadwbJyWGQc7mSAEDrnD9uKyxU2jkq+oun1WOaKHPRm0
	LYIUEF0NBJgMs40ydPzIcwayu1poErdhkd17JaZKizCwPRlY=
X-Received: by 2002:a05:6512:39c1:b0:509:4c65:f4cf with SMTP id k1-20020a05651239c100b005094c65f4cfmr6249477lfu.0.1700132361441;
        Thu, 16 Nov 2023 02:59:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IECWaoUrWDaztxT44u2EPDPmW2BLfS6Xbbd0ZPUDp4dHKwa5NorKczrV6lU733pXfhz7V/kpBFCQQMgCrCp4wE=
X-Received: by 2002:a05:6512:39c1:b0:509:4c65:f4cf with SMTP id
 k1-20020a05651239c100b005094c65f4cfmr6249465lfu.0.1700132361070; Thu, 16 Nov
 2023 02:59:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: German Maglione <gmaglione@redhat.com>
Date: Thu, 16 Nov 2023 11:58:45 +0100
Message-ID: <CAJh=p+58UU2B8wrAV4yxD7eFmjRmLYP36ErjDM_BXWOQZJKq0Q@mail.gmail.com>
Subject: NOTICE: virtio-fs list migration
To: virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

The mailing list virtio-fs@redhat.com has been migrated to
lists.linux.dev, this change was required due to listman.redhat.com
will be moved to an alternative hosting solution.

The new address for posting will be:

        virtio-fs@lists.linux.dev

This change does _not_ require any action on your part, all list
members have been subscribed to the new list, maintaining their
subscription preferences (regular or digest).

Email archives are also migrated from
https://listman.redhat.com/archives/virtio-fs/, to
https://lore.kernel.org/virtio-fs/ this change will result in broken
links to the old email archive.

Sorry for any inconvenience this may cause you.


-- 
German

