Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF9131717F
	for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 22:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784845866; cv=none; b=ZF3fUiM5bzbMBdqO7irwL8CALpr/YonKbbIVTsvXsyVh60gjPAyK+p5sU0o0baGhGvr0g1UQigS6XGv+mNpZvsBG0jEGbJ/TjfCDpObvYXW8HQXVueNMW+Rs3TToFQCca/Rnyzp97J2oJk06/W1s1EpzKE6tuDLjz5IvAvxE6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784845866; c=relaxed/simple;
	bh=4NYTmMM/tKQClf8Rfwd0s8ArOE7KiiEH3lfBWfSv8GE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DoztIn7kC2fPNHx9/4bwoqRWZK/wooWESq6buUp7gC88qS+E7Jbub1NJfYf3In+/B2EZL/sn342pTkt8hp67C2nG1n/dEvUpu31XrKzRA+xUZGiKZzdVy0mDimFD39Vkszz3aDPtW+w3uK4fLYoUevuDbog99v/2ij+wPEVpakU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7EjLJ3h; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7EjLJ3h"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-81eb41c1f1aso10182207b3.2
        for <virtio-fs@lists.linux.dev>; Thu, 23 Jul 2026 15:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784845864; x=1785450664; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NcYm30w4l7Vli4IAxyKgucSKPfeiorfv7ej3+wDF8Ng=;
        b=N7EjLJ3hT94v/qOiMqCquIU0ihDhQwy1kFQcSNO0ln9F5IBUZw1g5kp6cv1DfkrwWV
         6KXOftVFeQP/e7EE6yTb1lCcvEyNmzniY7iXP3PDBGqJstu26/bXaH0IOlbyThG6HMrb
         vmLPCGTghOR1/a7bvdz+OApJqiVY1OVmG/K8E3TSNjh0CWGdAMLHPXGoGGDOP7DbHMdl
         IOizoctmPeUHGCYERWqWZyMLoVDYS/dbra27YRZEnj4frIuom3LsgCRvYZjH5Q3IehQ8
         X3nY4Ym4mRRP8RBh7o1K8+/A4GlzoGFEIyOhYc6CTdlE0+OoomdoCFtpSDGauGgqjf0g
         hecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784845864; x=1785450664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcYm30w4l7Vli4IAxyKgucSKPfeiorfv7ej3+wDF8Ng=;
        b=ZYNKCIbWuC4WA/av+sOuvpxgXjHFPQcv6T8jDWfUjAw6/lXi+r02KB9+kB8a2U3QFp
         SXs17CM6Y7USs3+n5UWMWj3+HxIKYsB1wozv/7oBujf1sMy60v00rxM+S7GN5YCAeewg
         pRkK1QN9RkWwzzhlSpadYq46S+qxXRAWZqEyftZwNs7aWucVVXtpU6eIln3dHOP/n8RF
         l7fmM5flvkWmpZXyEOJWYBqavkaG/z2nGN494aNeTstVhfS7WkDeLbK3Pj66IkDbeuoN
         s8hzLYvWbfUOzZHThkZ91XevRtafgeGelGdjBnkwOpNUh0n7WVBaIzCnE+WStFyREqo5
         vTRw==
X-Forwarded-Encrypted: i=1; AHgh+Rr2lcLbt/N9LnpvHQfiNza1tHYaOgHDNZu2pheiCTX5E/hV1pSI2juZ8Lk2kmd3cL6V7dw/N1ziApM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyecmoOlOX6wxIPxdnav8ngjL4C55tpfGMER1CfqcoDdbWIsRHm
	54eAH6X1bnQvQ4RHW0tYYfR6tQ5xER3MiMcy689YK6x/OUwbq8bvjEC8
X-Gm-Gg: AR+sD12WL7mD3MHoOQrInyaU/BOJqKiHCDCLmjZ3NsxS6LHz05c0rXT4MLf+Xv2VhCj
	vmvWJ0VQvfOxKm95F5+dAigxmNmbzz4AsaHY1W8grqLGjwgbnHFGDGBHKRz+Q/IjRLNHkUAlSwV
	gpuxNiaWf7LjZrshbtLOlqqT0szsQjpeXnggaweAdZEPL1X8QdoBloPfXlT1kJiCk6PgfKyI5x7
	EDAHcignUWgS50IQQDgJZYIyzd0EafkDNa08yNequIFu+LJD6cQOpJP5a45SreIde/feJWPEQ95
	29RcJLCeQtDebbP+zj86E1JyK04W2LWPeRhPMA9fzl8O3JGDACwinjEl+38wFEh9M2FGdmYsq7Y
	bD8zYnVK9mx1q4AKliaxUjKOCwBgg02BNehKDqRwehlS/KZa2NLUf0m7m3B+raX90Vk7L4uO8Or
	VZnxCuEvM=
X-Received: by 2002:a05:690c:23c1:b0:81e:9bcf:3331 with SMTP id 00721157ae682-81f4c308803mr15470147b3.50.1784845864063;
        Thu, 23 Jul 2026 15:31:04 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:446f:49ff:37bd:d45a])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81f33c3c1c5sm35766777b3.17.2026.07.23.15.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:31:03 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Thu, 23 Jul 2026 15:30:05 -0700
Subject: [PATCH RFC 06/15] util/iova-tree: g_tree_foreach wrapper
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-vhost-user-isolated-memory-v1-6-6b97c439eb28@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784845839; l=1380;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=4NYTmMM/tKQClf8Rfwd0s8ArOE7KiiEH3lfBWfSv8GE=;
 b=phRfMm78NGRBj6uBF6zMDcCEhyCfeowKCx4+ej3y94dVfM5n66RXMSPbK+UaifHytU6Sc8h5I
 VlIfEHiwhCVBrikoJ+SbUFScNgv+jfy0OCahLgR2lVACw5+ssxMOwlp
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a wrapper to iova-tree to call g_tree_foreach.  Provies a means to
execute some function on each node of the iova-tree.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 include/qemu/iova-tree.h | 13 +++++++++++++
 util/iova-tree.c         |  5 +++++
 2 files changed, 18 insertions(+)

diff --git a/include/qemu/iova-tree.h b/include/qemu/iova-tree.h
index 14e82a22d5..4d77f4dc57 100644
--- a/include/qemu/iova-tree.h
+++ b/include/qemu/iova-tree.h
@@ -161,4 +161,17 @@ int iova_tree_alloc_map(IOVATree *tree, DMAMap *map, hwaddr iova_begin,
  */
 void iova_tree_destroy(IOVATree *tree);
 
+/**
+ * iova_tree_foreach:
+ *
+ * @tree: the iova tree to traverse
+ * @func: the function called at every node. A true return value ends traversal
+ * @data: an argument passed to func
+ *
+ * Wrapper to call g_tree_foreach on underlying g_tree
+ *
+ * Return: None
+ */
+void iova_tree_foreach(IOVATree *tree, GTraverseFunc func, gpointer data);
+
 #endif
diff --git a/util/iova-tree.c b/util/iova-tree.c
index 5b0c95ff15..2239bb6ae1 100644
--- a/util/iova-tree.c
+++ b/util/iova-tree.c
@@ -303,3 +303,8 @@ int gpa_tree_insert(IOVATree *tree, const DMAMap *map)
 
     return IOVA_OK;
 }
+
+void iova_tree_foreach(IOVATree *tree, GTraverseFunc func, gpointer data)
+{
+    g_tree_foreach(tree->tree, func, data);
+}

-- 
2.43.0

