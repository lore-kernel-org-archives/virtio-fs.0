Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6E7816
	for <virtio-fs@lists.linux.dev>; Tue, 13 Feb 2024 00:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707783210; cv=none; b=YTAJC10k2TLt9ouIqgOWtJA2i89RkHrc8VKSfmiUyB7svYivSim1nDp1rWiJErDYg+bK0MhZrZATfYHQWgGgzqF7p/K1lW2pxuyjCY5qCD6Ig/9e7t7BjCbCAyHpvc/alAJVa9qjrm541SBonrumVgG91fBGpApmaWFPAceoCpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707783210; c=relaxed/simple;
	bh=hd8ZTq2sDwWRqeoAKm381lzAkHmMP0UWzosyI6LCFoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSW95dqbn5T61AEeoOZ5ywYV8azT4IIDgEsq7eQV9fmm6Isl9xwq1KJKMjpXIhKR13G8Hu5Qud9+GQTvNkttS2pOtEFpi/TK79ULy2U8pVEDMB8GuJWITep66zfy32aF861XoI3qaov7N8L7BFqM8F+Q1RfGV6GgoFY/nAUnFh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BMJJRrp3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMJJRrp3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707783208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DVtLq4kSxxcXAHECUE/gwzTexd/LJnjpTSpOjMxsz6I=;
	b=BMJJRrp3wJyTGXgv4c3aus+ifAGzfkPIn891/p7XF+NI5KTkKcgX508Fk32wHDWvfs+ZYB
	Dkxd8aVLGrOm/8hp7EJHSOHMr0tRDWrbze6P3286zroXRb8ZlNgiafD6dlgkPtJDfTjVml
	qb66HuBIqe2Hdt/3Iv999v+Qa3zOGEI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-160-7SEf2osaPxOlNcVNJ_rqLg-1; Mon,
 12 Feb 2024 19:13:21 -0500
X-MC-Unique: 7SEf2osaPxOlNcVNJ_rqLg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DC541C068DB;
	Tue, 13 Feb 2024 00:13:21 +0000 (UTC)
Received: from localhost (unknown [10.39.195.51])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12578112131D;
	Tue, 13 Feb 2024 00:13:19 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: miklos@szeredi.hu,
	Greg KH <gregkh@linuxfoundation.org>,
	Alyssa Ross <hi@alyssa.is>,
	mzxreary@0pointer.de,
	gmaglione@redhat.com,
	vgoyal@redhat.com,
	virtio-fs@lists.linux.dev,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v4 1/3] virtiofs: forbid newlines in tags
Date: Mon, 12 Feb 2024 19:11:47 -0500
Message-ID: <20240213001149.904176-2-stefanha@redhat.com>
In-Reply-To: <20240213001149.904176-1-stefanha@redhat.com>
References: <20240213001149.904176-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Newlines in virtiofs tags are awkward for users and potential vectors
for string injection attacks.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 fs/fuse/virtio_fs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 5f1be1da92ce..d84dacbdce2c 100644
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
+		dev_dbg(&vdev->dev, "refusing virtiofs tag with newline character\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.43.0

