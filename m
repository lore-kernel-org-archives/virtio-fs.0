Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1B03C456F
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029946; cv=none; b=qniqtIeNH3+ba41OTy4TKrVtS2n881nI76WVG+EHZ6Za1C22+OT3aVPPjxxiLBHuOwXNHYhDHgJCPWofy+YljYhXgf/wG0m+xiyZ1oOKjQTubMBAcwaaizsGilTJIfkVgFx5Bf7Cs+KPeeN2cV5oM5/viW2UQvlNdft6S04LFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029946; c=relaxed/simple;
	bh=o7eLAZfdtjRRWSqHEojyG/bzxtWRaxaRR5MzJJtbNk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tkbj01DYLlugTAM2f6Nni8KaLKiHoOBRoJPDqq977MgpRqgqvP6m+2m3s9Cwr6LK66EDNvrI/YaYPCBkzzwQvofKrUyt+li0FNiLew9KlhcToFhP6t/6ZC8lN9HMQ+iuJf7obtqRTR9xNSwdc93FIBpmhogUtm8hxZSP+vp1cZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=q0qgBWXa; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q0qgBWXa"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-84fa3b14ee1so3080128b3a.0
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029945; x=1787634745; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GF0FtzLMWaPpijge2pYmINjU8s3/LYKiLpVZpt8RABo=;
        b=q0qgBWXamNsH+pkx5IrvBMNqjLyzQ4Rdi9ueTrrxVJntz4Wn0LQWXpAmnuqe+cihTf
         GFq0GRZWTa4CK9C1XUp+UftuL/EihFcziAyE7qB+chKdc1BitEQX5XrOfqPgQnxpU61/
         Ynv/Lm9MdfV3seZ1+yGzFdqfn5rM4N3dTV0UK+TeYl7eSY7p5+Pv6RcX/T30oHzV6ml2
         tstcvSxYR29ju/XlLUE6NNn1D3lE4ccIdJD8A1BVK8IfGPSVm7Hwi6DzyyeHg0jz7Rg4
         nuuSPzgW4CeW/3dVg9Q8GPqbJ7zjYoOGiOZt2DtihtBD4wRNQiSOOX41YTStyss5y4Nw
         eFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029945; x=1787634745;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GF0FtzLMWaPpijge2pYmINjU8s3/LYKiLpVZpt8RABo=;
        b=qDi9OqVnP25P8ikrZ7AdhxyxOWg6jS/A2tkUAkqSnyF0NZGdKj2SQUJWYC1nZDw3wn
         JERszjjv/l9PZBmTG9yJ32BBTwygv4dbn7CfBxEQmOpn0maZ662R6a9/VHP9q3j7FeF0
         Rov4/TP/u1BuKQpr+JHzwQfeDecQg+0qUivS9MdVItbz22BlxsXMk8g0Grzt/PaMF80M
         ilkVx+tJPxpmGFLasS5JxzpLMmqesc87ELy6pWAtmJZdOGX1JXhcsRbr4+JeDEP28Rn5
         +TynykpGpafFPtSe530JlpZ2KPUPf6SrwDOUok6iKvdbldl3D+HRT7aYe2+nFUcPWLhJ
         IO0w==
X-Forwarded-Encrypted: i=1; AHgh+RozrKlDxSEMWemuqfSJPO3YZdfW6kNVh9Y357IODmTyY42AAoF7SYSr3RB9+0z4CJDHVD2xFbPolng=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3UtV2HJ6P9jfjh82FMuBSU7Be5Sif8lousKw6ABR3Q/4eluI8
	ggNPtJ78/vOhPliWF/gy/kOuajtrVq4p1HRYayclcb/bf3DYeJQekR0X
X-Gm-Gg: AR+sD13U2eAoQH+vwiFDRfAaAzy/SDhUOPgGqvE7HaXvPOmZs0cMplALx1Ej7x4BZsS
	53sa8/dQXpUePM4ihI8QvY6xLFYMwzBe5BKgQCuGN2uXY9u/wiOF6CVU35+w/4uzqhzcmKZJ+pA
	538dKYeXe5Y8dGn3U/4E2I+v0uE8ZmHW1VfRE3tZhOirLnqEt010xQCkPer97MnyRyQ9ZaZMGEz
	TcZF08UvakJVsLbyjLMMVY6QmWLj5c/jILjBPV9FvItUcsIeA27OLYHXxvc3NDoe26mxymspD4Q
	veaG4CrKRTlzsPnRI0kzN17B/AAfLsIhQzLh236vbEuAjM+FL1TtIKNKgWxTdvQWAZ/4O26LvcD
	i/4eW2MxHizGrZst+8puQx4+H2cAHnNCozgiM18+KC/LuTprnM6EO550xhPB6UfZQ+eCQGPYq2t
	UKRlFlyDG6bEvFOnkA24Exe6CdJGdxhflrjnxoYBYDC7QrK1Wz5LPkzXEb9rcMtC7vDQ==
X-Received: by 2002:a05:6a00:3763:b0:851:ba04:ca02 with SMTP id d2e1a72fcca58-851ba04da9amr4656750b3a.16.1787029944848;
        Mon, 17 Aug 2026 22:12:24 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:24 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:17 -0700
Subject: [PATCH RFC v2 02/13] util/iova-tree: g_tree_foreach wrapper
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-2-948aae960abb@gmail.com>
References: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
In-Reply-To: <20260817-vhost-user-isolated-memory-v2-0-948aae960abb@gmail.com>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
 Stefano Garzarella <sgarzare@redhat.com>, 
 =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Gerd Hoffmann <kraxel@redhat.com>, 
 Mathieu Poirier <mathieu.poirier@linaro.org>, 
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>, 
 Raphael Norwitz <rnorwitz@nvidia.com>, Kevin Wolf <kwolf@redhat.com>, 
 Hanna Reitz <hreitz@redhat.com>, 
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
 Connor Kite <connorkite@gmail.com>, 
 20260817233147.2867623-1-connorkite@gmail.com
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=1906;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=o7eLAZfdtjRRWSqHEojyG/bzxtWRaxaRR5MzJJtbNk8=;
 b=Z3tFhfEr1Omnp83Zy3bXpXXEiQIMkob68NNERZBNgm5EjVu9Ykqidco7cjuQ4gnEqs7pgUwhM
 ELFXw7D56GGCzrXpmI7r68dyx5q3Ot2OBTpnrqhYAOCg7lgJmRrB5TA
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a wrapper to iova-tree to call g_tree_foreach.  Provides a means
to execute some function on each node of the iova-tree.

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 include/qemu/iova-tree.h | 21 +++++++++++++++++++++
 util/iova-tree.c         |  5 +++++
 2 files changed, 26 insertions(+)

diff --git a/include/qemu/iova-tree.h b/include/qemu/iova-tree.h
index 14e82a22d5..a1938e36a1 100644
--- a/include/qemu/iova-tree.h
+++ b/include/qemu/iova-tree.h
@@ -161,4 +161,25 @@ int iova_tree_alloc_map(IOVATree *tree, DMAMap *map, hwaddr iova_begin,
  */
 void iova_tree_destroy(IOVATree *tree);
 
+/**
+ * iova_tree_foreach:
+ *
+ * @tree: the iova tree to traverse
+ * @func: the function called at every node. A true return value ends traversal.
+ *        Arguments:
+ *            gpointer key:   key of current node
+ *            gpointer value: value of current node
+ *            gpointer data:  data passed in at g_tree_foreach call
+ *        Return: gboolean
+ * @data: an argument passed to func
+ *
+ * Wrapper to call g_tree_foreach on the underlying g_tree. g_tree_foreach will
+ * traverse through every node of the tree, barring an early return. At each
+ * node, g_tree_foreach calls func with pointers to the node key, node value,
+ * and a pointer to data passed in by the caller.
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

