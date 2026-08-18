Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D913BCD1E
	for <virtio-fs@lists.linux.dev>; Tue, 18 Aug 2026 05:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787029949; cv=none; b=A5oz/eNnYCxNLdtH3a3VeWlktfNzi6ldCnHcl3CZzAx7afxkexkeeIQUAtkI8JwevTrNaIKAqOQAB2lay2GptjMfWExMj2SifvyKRoe+FPZVARH4Tz1COr5ecWWpa+y5W5mmbJ35kjK9o4oE0EwBTmLJ+8qtf/4VizNAuVZpN9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787029949; c=relaxed/simple;
	bh=vwbYBaMbgDk4wePAOZ4o3ZHnYy3c61j7iZi/xAaHWVE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FafwTuhI7Uy0vmVg4hBSpJQWGZreyqf4PA+1flNyF7C2MM/cFqxpnwfXachNx9avIToRzku8dVS8NL+igfnq8b7JM1GdiV+iqhtbD9r5YMw+2I8JBM/rHsEi+Kk2Jh2vmxijBPvYq1hfVCz26yt525W5PLkN1xZ5+BT/kiQBaCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aETuo+fV; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aETuo+fV"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e507b079dso2752825b3a.0
        for <virtio-fs@lists.linux.dev>; Mon, 17 Aug 2026 22:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787029948; x=1787634748; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9dnSpwb0dn+bdk24pKhPvPsrY1aMYcRsQf+7mWHImvs=;
        b=aETuo+fVLihJkr1+YRAYAEQB3XAy0YpBEhEPCmqWA5zImjrSPqvbHQoGsP62PhnIcf
         h+05GTT+3FIbbp8Ld3wdFdAwDalVXbbYskxgG7dev1VnpK6mASBELgEoUSSq36Blzn6N
         u2zm/ic2qyy95unkYlPglPcERv7tlonovna/LNBvEO39yZWYCL79dMrebOQyS7rH5T7C
         xXdfRUnE8bDYN/ATeV/mZPqga3F66XM4kQ/52AHCWWJW7H2rYGoegvuNB2JvYgD3M2ws
         7Ruw7pgxyllvsDGrJAjj72LyZLK8Gng6aR29XPemFK4UBguCY3VGjS2ItykIIQg6eZLw
         +cyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787029948; x=1787634748;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9dnSpwb0dn+bdk24pKhPvPsrY1aMYcRsQf+7mWHImvs=;
        b=NJfSTAWH02q1a6qcLynUeZnwwn2OW7UIipNMBWU9eyPGDdRYnACbWAdDlVsC/NMvnT
         lnevqMYExFSGokjUIdpJBEqK2Aa8rNdtzv1hcbsYdvrLjQeUq3sEtWBs2xkvT72S8KhO
         7xwTBkKCF0qlzKF+ftUevdSjwgBUxFRWs3BsT7L1LNp/nsrFVUHtmQLIWsTtdd+nm6pO
         B15ms+BEPoPT5OSW+fOix8ZcVJ38H0kZb29jPz7uhXQFpjsaQ8LybwEOFjGA9q2LquhZ
         T5syiMtjeeexKLQ//Uv1TJAUr0bVj1Vy+H33lLIGSfUbJgxuA7F2STcB/8jkn2VZ8xhe
         pnuw==
X-Forwarded-Encrypted: i=1; AHgh+Rru0Ty0Q5Cw0835kDQMiOdKtFoSpF0EEr8HLRpkQ6TNLtC8g39tZui4w0UyucZezKUClbfIGoCTNYM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQTZAh2dWtBRwqFnl4taoYFBGWv8r4e2+qfkDpS9ui2J0uvDsY
	tiZ/3lFrkPBMFHNg0Ex99eh8lsYpsIMcQ8yc7Dz7j8wh2Z7Et9MB1xyK
X-Gm-Gg: AR+sD104XBtgLz3Tud71ZoiOt9GZiKx8wXqSRsoT20LyS7MJrpv1sXD/DNbxTSDq9Yq
	He2SmUMyGP0lSMhJjtMknrtwXDkik5XUG/fMgNQUT0GqTE+8COBxEnlTppEhaQ9zLPvCS0g/8Qx
	iPayLz5xXDdxfpB9ZFnKkw8TKXNTv01Bp6YIBDSBQg3mUQHBJrz6a5Su4CzjBYTxyO7OORNMGaD
	HMU4i6LugmvF7aiezjsmpSg3glzy1eIYYApCFgq6uEs1eEDtEcb6KCa3N0PBAtEFxlc7gE+mY4P
	K0cIbNiFdb/cAk81U3IwTd/KaC6gjj8ak5oeSXcgdlQmw7p+y6FskH+ggqYKBGu0gIYVKkmdZc1
	Ka3XkFEqm9oaGazARBRxORJinRbQXhdAgNAC6ad4lU+lSV0B1RtLZ0wJSMsAVU8dJF45WnUxzSO
	M8/heJ73mpiks2kp4VpDkwZqZvZED2Uac6eUQ2ncK3J38hl2zO2T2Huun4XYuF9o91/w==
X-Received: by 2002:a05:6a00:808d:b0:847:e2c7:59b6 with SMTP id d2e1a72fcca58-84fde1ce5d1mr31913848b3a.11.1787029947566;
        Mon, 17 Aug 2026 22:12:27 -0700 (PDT)
Received: from [127.0.1.1] ([2600:1700:e140:14d0:d043:a40d:25c1:432c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b6fc0e84sm1031160b3a.43.2026.08.17.22.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 22:12:27 -0700 (PDT)
From: Connor Kite <connorkite@gmail.com>
Date: Mon, 17 Aug 2026 22:12:18 -0700
Subject: [PATCH RFC v2 03/13] hw/virtio: iova_tree_foreach wrapper
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260817-vhost-user-isolated-memory-v2-3-948aae960abb@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787029936; l=1780;
 i=connorkite@gmail.com; s=20260723; h=from:subject:message-id;
 bh=vwbYBaMbgDk4wePAOZ4o3ZHnYy3c61j7iZi/xAaHWVE=;
 b=wt3JAdEQQY0WOd6NAZCMl2xoPft+pWYzPIfGFmmMVVjmM5AQRpS7XXXxcs7BsebWgzN8hEnWj
 rBA2T+mhFQfAhf0I2K0qofH4RWgVMouKexIY0LXa5EKULkDz7ZcLkhp
X-Developer-Key: i=connorkite@gmail.com; a=ed25519;
 pk=xg/3N8AntFCYogaIgN5NC/KkT7UlZB6ktPIRliJ3hv4=

Add a wrapper to vhost-iova-tree that calls iova_tree_foreach on the
underlying iova_map.  This provides a means to execute some function on
each node of the tree.

Signed-off-by: Connor Kite <connorkite@gmail.com>
---
 hw/virtio/vhost-iova-tree.c | 15 +++++++++++++++
 hw/virtio/vhost-iova-tree.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/hw/virtio/vhost-iova-tree.c b/hw/virtio/vhost-iova-tree.c
index fa4147b773..0a9b38b6f3 100644
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
+ * @func: Function called at every node.  A true return value ends traversal
+ * @data: An argument passed to func
+ */
+void vhost_iova_tree_foreach(VhostIOVATree *tree,
+                             GTraverseFunc func,
+                             gpointer data)
+{
+    iova_tree_foreach(tree->iova_map, func, data);
+}
diff --git a/hw/virtio/vhost-iova-tree.h b/hw/virtio/vhost-iova-tree.h
index 08f63b61cd..c84fd652bd 100644
--- a/hw/virtio/vhost-iova-tree.h
+++ b/hw/virtio/vhost-iova-tree.h
@@ -29,5 +29,7 @@ const DMAMap *vhost_iova_tree_find_gpa(const VhostIOVATree *iova_tree,
 int vhost_iova_tree_map_alloc_gpa(VhostIOVATree *iova_tree, DMAMap *map,
                                   hwaddr taddr);
 void vhost_iova_tree_remove_gpa(VhostIOVATree *iova_tree, DMAMap map);
+void vhost_iova_tree_foreach(VhostIOVATree *tree, GTraverseFunc func,
+                               gpointer data);
 
 #endif

-- 
2.43.0

