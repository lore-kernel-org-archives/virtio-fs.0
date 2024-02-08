Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FECE37162
	for <virtio-fs@lists.linux.dev>; Thu,  8 Feb 2024 19:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707420837; cv=none; b=oJksgmTqLwSaEzhUrEGrmSamUsXgxhRy+buz6F/oSKmxGaiLBVjTKKwbPHy2cXXzquZLaG0N7KrvbqofTEV6nwlYCqSAtpowVYfcvfXfDIDGXsCwqXpe0lC6EIt/eurUi7qhi+6TJ3Ybu86eyFdf0e6Me6B7UyWBUhZBqNVqa9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707420837; c=relaxed/simple;
	bh=n48oWo3G3KIEcmxV/611DpsMC0ryPm6br1Qg/jnSK7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYfHa6gXGP/iEMHCbL/eW75iRwEcpc4sSQLMMP+1X78C19OdZIAe6NCRigC3wT2732j9P/n3G/JmwXOlCgxGzyCsnQES/W8E2bGhpNaBnO/GkQ7PDsgxBjv9Wf7xA7KPtwbDaOKE7Epte5OahjLrh7sD4uufQ/KrXA5iIAMMx1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bvUzwcVa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bvUzwcVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707420834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jPnUeFg/dcRAFFaWxKcnPQO6N26PYx0VPSOmFP3Xkj4=;
	b=bvUzwcVa8N9f3JZO2cDRJWBoHNgtwF+37sSwYzWnLi3J38RXnRUjt1I0Mh57PAVIHbLJHB
	yFkAFfY+juR1sWwqePi96HAg+dkbd9Rb5mKc3w4ezTPeombdX2KVeDz/xW4AAm6BB0YJup
	gLhlbMKXC+0VXUVG/0ZIWHRQg1VCDBo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-LJMYgYA7NpSvlOrGcxDMZg-1; Thu, 08 Feb 2024 14:33:53 -0500
X-MC-Unique: LJMYgYA7NpSvlOrGcxDMZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A184810201EA;
	Thu,  8 Feb 2024 19:33:52 +0000 (UTC)
Received: from localhost (unknown [10.39.192.44])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E80D2026D06;
	Thu,  8 Feb 2024 19:33:51 +0000 (UTC)
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
Subject: [PATCH v2 1/3] virtiofs: forbid newlines in tags
Date: Thu,  8 Feb 2024 14:32:09 -0500
Message-ID: <20240208193212.731978-2-stefanha@redhat.com>
In-Reply-To: <20240208193212.731978-1-stefanha@redhat.com>
References: <20240208193212.731978-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

Newlines in virtiofs tags are awkward for users and potential vectors
for string injection attacks.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 fs/fuse/virtio_fs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 5f1be1da92ce..de9a38efdf1e 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -323,6 +323,16 @@ static int virtio_fs_read_tag(struct virtio_device *vdev, struct virtio_fs *fs)
 		return -ENOMEM;
 	memcpy(fs->tag, tag_buf, len);
 	fs->tag[len] = '\0';
+
+	/* While the VIRTIO specification allows any character, newlines are
+	 * awkward on mount(8) command-lines and cause problems in the sysfs
+	 * "tag" attr and uevent TAG= properties. Forbid them.
+	 */
+	if (strchr(fs->tag, '\n')) {
+		dev_err(&vdev->dev, "refusing virtiofs tag with newline character\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.43.0

