Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E35E3F7898
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845872; cv=none; b=s5nhX9QAX7Fjv9/4xIlkK/xHTxdigzZKiwC/JlmwU8HYg2jjddkpCAuOV+YMADgFIU+NpmN6bupUU+sK6b3Ipe2tLNr0GvFMhgIONu9SaB1AQewvdcDD1DV7JknC9LNHQZNef7z7Z3OGGI48UlDqVfaa8c8MSDhb7XWFODCYLYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845872; c=relaxed/simple;
	bh=Yoe4ouzD+Ga6/WRjo8rrhPx85XUfhnHf/hoKZtpa4Yk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n2gbCBUdJDid3yRUx6NOtK6PAEdzvqNRtNSHvBUm8ZsPvVSpbApf5bXim0o74aLpuQrmKJJTq/eaA9DZ6ytFHwMrkj4mWqXaUcJC19D2aNUwmpAEQhx7gwZqQg8obb52Q0LVvWVbQn6j4iBtZbFvdH9Wll4FdU862hDiV47I4dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jerJN6VK; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jerJN6VK"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-81e69a2db34so11706877b3.0
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845868; x=1785450668; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0mhSD+dGlrr16JyRhT612XgJdqAQYtisMHkX7vK1jo8=;
        b=jerJN6VKL9GkaogT4dyMPC0vGI8HtfcpgGNn4auqN7PLn+DZgdsB5T0xGCGeJEoD6X
         5cPqhC6NvTJm6rvHK0dfQy52T3lJc4S0ntbALf4qY6LWj2DchOUjb50jpUKit+COCEQ7
         jYEmGdaoNiNs7FdDzTfV6bvLWSGk+GdclC9WaQjrwLLYdemInEi2396EBJTbkhSxk5at
         NLy1p5SmBq+dx0LmqrJ52KWzO8ga9lMIn4GAHlhJdXXB1rTSEPW/qeVno+Jfqa7qi1fU
         p2sRvopCEVIzA3GdCeXY9nP87OzoS0tL5Tj7xkXkNFbjiOAQL+OLfCgJ49hP0EclKuqK
         AoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845868; x=1785450668;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0mhSD+dGlrr16JyRhT612XgJdqAQYtisMHkX7vK1jo8=;
        b=HLEGtnCG3RSarv1UWc+XIpHI2EQhHzY8SkXbHQzcDPX9gSwCMFMG3K6z7ZiE1k0txv
         4JNTcF6fKQA7PkpNW5grXW4XhypENezO/kygQ+W7A5ahlj4lVfvq0F2x7rUu5DH3J36H
         27Ig9kgsuQdiKD/SkhakCFhQ6ds9ufesv0a6Qal1741YDxTHqGaT/qCN7DY8TPNeE6IN
         5PgmvM7nnAdxK+i1+zfebuz7xbx9rBAJmF+HRFm/yJt0eyTol1bKFjxUWhANOzBXvcSJ
         z+OhRwlnT5ufd/SARCuXlwdXkeG8xqk8yLcAHI5+IByDlNcYuNnueg1jBJqorXmSdEBS
         2VEA==
X-Forwarded-Encrypted: i=1; AHgh+RoSsk+iBkELDUoo0cXuagXvMygm/Yt6JpkZE4mXWhsZivvhHpdggzeVYXTtdZXuwxyuiUumsbYdwwo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCETG0Cf1dAAyMlNHYBh7IMJLpb+Fsl3gQRvkmfuRst4o2591U
	ilORlnMEdu9w8ClRqfdV1tjknWFOD3CyLlaAVF0B9k7SrZrH+bo5ngVi
X-Gm-Gg: AR+sD13UZ6z7bjcmo3D/d6Teuk77fU39QWUD104kvdhOQkWw9E4nwoNcuVxUe5jB6uR
	UrPPchwvOZ7861agu8JoIAEZnpUS7pR49xW2w3xkoc56SHadbE6ruzQFLJTRhw/443TcVVxcyMI
	3NH100JZdVGu6EJgVelBelduGST8+1RkfbUVUZow/RkH82zRGwg99HzIyNV2MZR2JrT1j01G+8k
	zIWofiEntHAtRHL6XUjdtGdnNZal8fZkTtt6mTK9IBmck4uCssQX5ygagLyCVLZsQhJaPn2pOFe
	la38MGK+XmIx0UtOXJ4JYTKshY7l1nX6e1AcHdm34Ev8/7FlsNyrpc4eqUZeO+RMjDSBnVSrB6Z
	VpYtwq8hJAPjiBVR6Bq58dyPp09ZiQ/FqWc67+9864kZV0kRCd2OSUcXSXZivDMTFmtwbre+Ud4
	VAKvicMO0=
X-Received: by 2002:a05:690c:600c:b0:81d:6eec:fe22 with SMTP id 00721157ae682-81f4c31fc3bmr16487457b3.44.1784845868465;
        Thu, 23 Jul 2026 15:31:08 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:06 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:06 -0700
Subject: [PATCH RFC 07/15] hw/virtio: iova_tree_foreach wrapper
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-7-6b97c439eb28@gmail.com>
References: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
In-Reply-To: <20260723-vhost-user-isolated-memory-v1-0-6b97c439eb28@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Haixu Cui <quic_haixcui@quicinc.com>, Raphael Norwitz <rnorwitz@nvidia.com>, 
 Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, 
 =?utf-8?q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Fam Zheng <fam@euphon.net>, 
 Stefan Hajnoczi <stefanha@redhat.com>, Milan Zamazal <mzamazal@redhat.com>, 
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, qemu-block@nongnu.org, 
 virtio-fs@lists.linux.dev, "Gonglei (Arei)" <arei.gonglei@huawei.com>, 
 zhenwei pi <zhenwei.pi@linux.dev>, 
 =?utf-8?q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, 
 Jason Wang <jasowangio@gmail.com>, Peter Xu <peterx@redhat.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Alyssa Ross <hi@alyssa.is>, Demi Marie Obenour <demiobenour@gmail.com>, 
 Connor Kite <connorkite@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=1785;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=Yoe4ouzD+Ga6/WRjo8rrhPx85XUfhnHf/hoKZtpa4Yk=;
 b=SHFDvD0FHkAmxfuGP0PJ+XhJubxb/9Wsa2vNeIpQYm30SiB9dn47KOyhBUjqLUHJCQAMZpONh
 2Odk2TK5fDCBU7bFrC04DFy3SRr5uW7vINzO/2fA8K0BupPKKrrCzXL
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a wrapper to vhost-iova-tree that calls iova_tree_foreach on the
underlying iova_map.  This provides a means to execute some function on
each node of the tree.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-iova-tree.c | 15 +++++++++++++++
 hw/virtio/vhost-iova-tree.h |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/hw/virtio/vhost-iova-tree.c b/hw/virtio/vhost-iova-tree.c
index fa4147b773..d8206379bf 100644
--- a/hw/virtio/vhost-iova-tree.c
+++ b/hw/virtio/vhost-iova-tree.c
@@ -189,3 +189,18 @@ void vhost_iova_tree_remove_gpa(VhostIOVATree *iova_tree, DMAMap map)
     iova_tree_remove(iova_tree->gpa_iova_map, map);
     iova_tree_remove(iova_tree->iova_map, map);
 }
+
+
+/**
+ * Traverse through the iova tree in sorted order
+ *
+ * @tree: The VhostIOVATree
+ * @func: Function called at every node.  A false return value ends traversal
+ * @data: An argument passed to func
+ */
+void vhost_iova_tree_foreach(VhostIOVATree *tree,
+                             GTraverseFunc func,
+                             gpointer data)
+{
+    iova_tree_foreach(tree->iova_map, func, data);
+}
diff --git a/hw/virtio/vhost-iova-tree.h b/hw/virtio/vhost-iova-tree.h
index 08f63b61cd..f3b7c48cb9 100644
--- a/hw/virtio/vhost-iova-tree.h
+++ b/hw/virtio/vhost-iova-tree.h
@@ -29,5 +29,8 @@ const DMAMap *vhost_iova_tree_find_gpa(const VhostIOVATree *iova_tree,
 int vhost_iova_tree_map_alloc_gpa(VhostIOVATree *iova_tree, DMAMap *map,
                                   hwaddr taddr);
 void vhost_iova_tree_remove_gpa(VhostIOVATree *iova_tree, DMAMap map);
+void vhost_iova_tree_foreach(VhostIOVATree *tree, GTraverseFunc func,
+                               gpointer data);
+
 
 #endif

-- 
2.43.0

