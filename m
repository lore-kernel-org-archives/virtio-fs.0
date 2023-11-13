Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7D823778
	for <virtio-fs@lists.linux.dev>; Mon, 13 Nov 2023 19:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DgvyWa+e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699905230;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=jsB/blGJe10FBypomL2a71Dy+mRX5eGykP5hzFFdqfY=;
	b=DgvyWa+eI/X+0ajjksrJeyoXYhggacR8wnak3z4Jbm6N5kV6VexPdUiirCT6Ql2BVlcS8U
	1SBxKniQsNIaKuPnfL3r6+qwFjyrm62mWTuEbVhXFGlZ/MIeh+T/TSUT0pqYWx0S5hMW2p
	aWS0Fkw247g0u569dJcO9Mu33unvzH4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-D37M29vUOzmPVHRkK074Yg-1; Mon, 13 Nov 2023 14:53:49 -0500
X-MC-Unique: D37M29vUOzmPVHRkK074Yg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9c983b42c3bso636263066b.1
        for <virtio-fs@lists.linux.dev>; Mon, 13 Nov 2023 11:53:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699905228; x=1700510028;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jsB/blGJe10FBypomL2a71Dy+mRX5eGykP5hzFFdqfY=;
        b=lbubFbk9ha8JOK8NKR2wzsN+fy7gWSYNlAePvbWMNCOSP01jP19ftVnqTc0eosQ4yP
         8fWODtZh11AQD+1DGwBuFAHGU01o7G2RU7Z0dLNZXq1FUYAwLkNJ1TAhoGO/O3tEwXFI
         0WsQijSokurcLXDDq4i8Cd4k7eMOwMzvM8y/jyuL7LO57zB9ODCqqENcDBTsATI6ZLYz
         bVDrOALJTM07+kkDP3h0TujYFzCx0I8lB+OsAvfbPLhV/0ROBqd1Sp6FspZ/WVA9+Wkl
         oVHRkIeLh1jt/vkbZVVi52qRTky4QCQp6LwfNOy1Xo1lPrT79G1CN7oV6I8lscCI0o8f
         s3sA==
X-Gm-Message-State: AOJu0YygWMZSjITIyP5WNleauCdWF0+csH5yzQpEVShYU2+TJhePPAlO
	lNtV+4CasQOWNyJCX08gvbZFbS6rM0UKMVpBvc0Eu7W6fc3tHg2NvccxRfmfkB3IFpdBlxtsL/1
	IrMBePIIrdGj5YYVwzb1Ft8Nl6sLBmbkRszlYnIUsxEks5Gk=
X-Received: by 2002:a17:907:868e:b0:9ae:5a56:be32 with SMTP id qa14-20020a170907868e00b009ae5a56be32mr483875ejc.38.1699905227903;
        Mon, 13 Nov 2023 11:53:47 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHvsW7bn2gp+IAFBx9xb/1LrNIKW7fIOiEAZxkAAgdLCD2VPIw7BN0zRm2NDr+WXJbCjuPbJQKQUxRrftO+8pY=
X-Received: by 2002:a17:907:868e:b0:9ae:5a56:be32 with SMTP id
 qa14-20020a170907868e00b009ae5a56be32mr483864ejc.38.1699905227600; Mon, 13
 Nov 2023 11:53:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Vivek Goyal <vgoyal@redhat.com>
Date: Mon, 13 Nov 2023 14:53:36 -0500
Message-ID: <CAGJMmikZKqijQrhSRmKoaGkvRfJEjLPftmZ8Ngqv=NEYb=sfPg@mail.gmail.com>
Subject: Test Message
To: virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

Hi,

This is just a test message. Trying to figure out if this list is now
active or not.

Thanks
Vivek

