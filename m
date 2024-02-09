Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F5F32C6C
	for <virtio-fs@lists.linux.dev>; Fri,  9 Feb 2024 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707481177; cv=none; b=Z1vTqev7MnVMbD7wc5y+qUCazTJFbo7TVp6psG2RG9Zt2JAepahLVROQR40lnk7O/c+JpoLSjtCqCuwhtQ9XxofEO6bjcanab3mGgxFL6p6gBA18TPwlGhyhNPfHabUB9iYY8Lo69XV6WV1amridTz+r552a1pj6V+nL8kmN8gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707481177; c=relaxed/simple;
	bh=pPsXR4LXERir+3yl7dR7PIdmPZ/niX/68c9RkRA7nKk=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=bc6kNL53FtzJcPB6DkO1fzBm50ZOGJiiTTKBgVbPuaFS69E/L4/QhKywgABrU5txGLpKB5cufhJ/7ihwgknWqHpUIuo0+mJVnlvT3wJSBdPuBXOpkOwRj6qenK43xwxhd97vkRd9ADAhIBUMOhLOtcqZbUiW2CZ7z4IiPWZxw6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVztUBPD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVztUBPD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707481174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kq0zPAaOeR38KDlLclahoCBb6eOWgUuY4y6kUGHll4k=;
	b=RVztUBPDStViuzNIgSrE6Mk0XIV4+BL5WohAJ+8ioyW4oO0NVOd4mOqi6TvxMBzBvnvyLK
	6VmHGA2KWXKuqXN11TtyrEZbgRJv+qD3dEdAgx1xkVu4cvN08yL8Bzu4ouKViYnXo7ALbn
	k97uiEyUPgnVp2SeHMTkMsp3Mk+7IBg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-7hnOAlfoO5OqSyOkG43TkQ-1; Fri,
 09 Feb 2024 07:19:28 -0500
X-MC-Unique: 7hnOAlfoO5OqSyOkG43TkQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8309D29AB442;
	Fri,  9 Feb 2024 12:19:28 +0000 (UTC)
Received: from localhost (unknown [10.39.193.29])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CDCB492BE2;
	Fri,  9 Feb 2024 12:19:27 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: miklos@szeredi.hu,
	gmaglione@redhat.com,
	Greg KH <gregkh@linuxfoundation.org>,
	virtio-fs@lists.linux.dev,
	vgoyal@redhat.com,
	Alyssa Ross <hi@alyssa.is>,
	mzxreary@0pointer.de,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3 0/3] virtiofs: export filesystem tags through sysfs
Date: Fri,  9 Feb 2024 07:18:17 -0500
Message-ID: <20240209121820.755722-1-stefanha@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

v3:
- Use dev_dbg() to avoid spamming logs [Greg]
- Fix 644 mode on "tag" attr and use __ATTR_RO() [Greg]
- Use kset_uevent_ops and eliminate explicit KOBJ_REMOVE [Greg]
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

 fs/fuse/virtio_fs.c                         | 135 +++++++++++++++++---
 Documentation/ABI/testing/sysfs-fs-virtiofs |  11 ++
 2 files changed, 125 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-virtiofs

-- 
2.43.0

