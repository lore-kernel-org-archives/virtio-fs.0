Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9042942C
	for <virtio-fs@lists.linux.dev>; Thu, 16 Nov 2023 10:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UMbmPTnn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700129033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=WAki7NBoYeIJyAmtetyFYUmUlVhWQo+vMrXKfiO1GwU=;
	b=UMbmPTnn5fNe6tOwIKvQVkvIhuLvtap+Bz8Dp8GD9o1GpGJHn8Ui/jqRxHImtAIiUfl3gW
	2nkDuu3YBTt3Hv+EKgDeky6sZlMJiIDbE52GKG1Xg0drxZPzoStPnq8fTZex9aiUxNlBlm
	pJ6r1hR/9WTPI6ym3uyWauFdhmVadwE=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-i6HgHeH4PAKQfXbS6eENow-1; Thu, 16 Nov 2023 05:03:51 -0500
X-MC-Unique: i6HgHeH4PAKQfXbS6eENow-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-507a66ee696so108480e87.0
        for <virtio-fs@lists.linux.dev>; Thu, 16 Nov 2023 02:03:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700129029; x=1700733829;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WAki7NBoYeIJyAmtetyFYUmUlVhWQo+vMrXKfiO1GwU=;
        b=S6VfydBAs+FkNxaDp0fIU6RD1xDPL00yMkulSCdN5loZ/XY1F5DhHEc1rO7GVTb6Ir
         gziI2uKCYY4VHJrb1RRH+O/0SfaakMLDP1WnYVPAmXSIuCtv65D7mwXg30ptytWe1nU6
         qZ+H/hUzNcXS8aO6mrCyqaI7SSZ/97oz+KUAIqkeN1PCyXiT6R8jo3Y8Ty4M8aE9eFZV
         3PttealU4M7CMzp6jNJ3YhMvnCFQtWY3OYLanElh3XTyOFYupIoav31oq23/er/i15iR
         bmgyOCP0Ok7zvlekvsqXSlXAdziNxik4TDn+F2PPZRU4DyMHyX0nxTwwSFi3wWrw7GDP
         JY5g==
X-Gm-Message-State: AOJu0YxHh9LbG1GCt8bzdF3Ybpy7CrfTvDqjX6XrZaccM83dA3QGbd6U
	o4bI0QD37dQYguCUVFb74mcK8VQ7s9KWK65JDw9bnIS7Rz7E4u6eClvZIBUTmecbH93iSmPQrgZ
	7rd0XeBAXqxueh3wkPmKr7AHFHbMFdLoQKkv3tIr6zl8UZec=
X-Received: by 2002:a05:6512:3ca8:b0:508:1a9d:d768 with SMTP id h40-20020a0565123ca800b005081a9dd768mr5751326lfv.4.1700129029511;
        Thu, 16 Nov 2023 02:03:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHwVSOLslr2X/W4/Oa8G4luwzQ7Hd2c+XnIoVBDIi2Fjyr7tuXVzBsuiPXOtTsDcdVUq66uKaA/G1Jz+SEg4yI=
X-Received: by 2002:a05:6512:3ca8:b0:508:1a9d:d768 with SMTP id
 h40-20020a0565123ca800b005081a9dd768mr5751307lfv.4.1700129029167; Thu, 16 Nov
 2023 02:03:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: German Maglione <gmaglione@redhat.com>
Date: Thu, 16 Nov 2023 11:03:13 +0100
Message-ID: <CAJh=p+4Yq_d3wH1C1EAn-_TQyqtgHxg8kDD3BTBV0ZqheQP3AA@mail.gmail.com>
Subject: List migration test email
To: virtio-fs@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"

This is a test email to check the new virtio-fs list
Please ignore this message



-- 
German

