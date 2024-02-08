Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250883839B
	for <virtio-fs@lists.linux.dev>; Thu,  8 Feb 2024 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707420846; cv=none; b=fyVJXKDomXNMaBltMYEuq2DkQlquDtTn2JHv5mfiWL7eQeNreGDwT5l/Bv/GL+2lPhj7JRHuwdyTqaB58JnDR1EivcsakTN8ZQ4mkOP1FgyKvQ6P0y223qz4u/4fpOliPuhTOH/UGBD276hKsgoUOrVB+L+GzChbNrt4S5SUSOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707420846; c=relaxed/simple;
	bh=gIYe1G2D5czXLxBwjohuKB4A+4yKGd/4oBCUNojNndE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=FAP/791OXw0vXv5/xWQxC3NOd3yCTQOcu76P+QDo0EXZGQCFJ56PPqo8sfce8qgk4uHiU+F9Ccqj4FKOxslenMSTkpmknpV3ixkvB/UUTdkIIKF09geKKdIs9gmDP0i3q3Vx3spyKUeHJbgJnyFFJm64EMfKKxd2lhpDaC0BizA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xlduq/Ae; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xlduq/Ae"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707420844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B5DAQZFX3akFCHabnQKTMIcW//WJ3thDgfeNbjmdQfE=;
	b=Xlduq/Ae9HL+01G7HviRS873JmGCxZEo2FQtUYbLAWKwX+ExWyqitfUPtQCCsSZIOfqVRX
	1K2Epd7sRH8vAlwiR+4DYOpmPwfjGGhWqZKJRcjOsm5DpzEirXAbTjYQWnI9cMps/IpClI
	nmfboaSHZryxjW2I32l916AYtQxrvp8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-0vhgBgLjPX22OLWp2_Nu4g-1; Thu, 08 Feb 2024 14:34:00 -0500
X-MC-Unique: 0vhgBgLjPX22OLWp2_Nu4g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56A1C85A589;
	Thu,  8 Feb 2024 19:34:00 +0000 (UTC)
Received: from localhost (unknown [10.39.192.44])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD956AC17;
	Thu,  8 Feb 2024 19:33:59 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: Alyssa Ross <hi@alyssa.is>,
	gmaglione@redhat.com,
	virtio-fs@lists.linux.dev,
	vgoyal@redhat.com,
	mzxreary@0pointer.de,
	Greg KH <gregkh@linuxfoundation.org>,
	miklos@szeredi.hu,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v2 0/3] virtiofs: export filesystem tags through sysfs
Date: Thu,  8 Feb 2024 14:32:08 -0500
Message-ID: <20240208193212.731978-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

v2:
- Vivek mentioned that he didn't have time to work on this patch series
  recently so I gave it a shot.
- Information is now exposed in /sys/fs/virtiofs/ whereas before it was part of
  the generic virtio device kobject, which didn't really fit.

Userspace needs a way to enumerate available virtiofs filesystems and detect
when they are hotplugged or unplugged. This would allow systemd to wait for a
virtiofs filesystem during boot, for example.

This patch series adds the following in sysfs:

  /sys/fs/virtiofs/<n>/tag    - unique identifier for mount(8)
  /sys/fs/virtiofs/<n>/device - symlink to virtio device

A uevent is emitted when virtiofs devices are hotplugged or unplugged:

  KERNEL[111.113221] add      /fs/virtiofs/2 (virtiofs)
  ACTION=add
  DEVPATH=/fs/virtiofs/2
  SUBSYSTEM=virtiofs
  TAG=test

  KERNEL[165.527167] remove   /fs/virtiofs/2 (virtiofs)
  ACTION=remove
  DEVPATH=/fs/virtiofs/2
  SUBSYSTEM=virtiofs
  TAG=test

Stefan Hajnoczi (3):
  virtiofs: forbid newlines in tags
  virtiofs: export filesystem tags through sysfs
  virtiofs: emit uevents on filesystem events

 fs/fuse/virtio_fs.c                         | 138 +++++++++++++++++---
 Documentation/ABI/testing/sysfs-fs-virtiofs |  11 ++
 2 files changed, 128 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-virtiofs

-- 
2.43.0

