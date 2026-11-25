Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795599584;
	b=V+oUEvMaqMPPRYdAEqrYZLYEofAyYRieVlC+VRgoZbSkExEdTgMNE0F2Y5KyarnExt2w
	 8hGVlJj+nnLriVuhAr7g4HFUPEoTt2b6mDwCwL3wAYztoNE1wO2iaxlRH6aWIdRa37tD4
	 zVxMnz2x1iDK4I0ekf1smYgfZMkOF/8tUBTLIuDz07W9UBhiA1J7o7MV/XJi0Opka9yVK
	 tUO8Rv4AYh/ea0A7epiv2UQi5inhHvNOwi7RtLGFLmYnuHzB95CjYNIDUfRlxACdtnIGy
	 0RGjNaoJez2yBUvVvoMkuUT89EMHCHCfA49avX/wmLTKLWTuP242xmC+WF9YjDvAjpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795599584;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=06CDHqP7t8VW2Q7Qnt1JYGz3UVTxeAwOx5LZVWzf/jo=;
	b=o6h+SaWoxcBXxje1c/ptupcgcy3Cby8onHxIrHLEmfupm5TQCG1Y/to4zFRsCHinmxjX
	 GJaHxRhXzmFHFvkoHNvBpaGb9u/VIXsC65cBZqmGGrINk2/1aY9iFV7zmhN0dBDVDTyYj
	 Z1FSDmmWL56+YIFVpqEVogfJsZi51PC/JJNyC+7Rx546d3kQ3RAolj7U6MULJLJPd19Me
	 f4gAL0goZAdJzm+WXoKaTs8UhdY5nMvLfwoiQzEp6B0pSr14J8oe0Mk/gitx6bNBLFrpf
	 1xsyFRhVwrkaGZLG7aH1+MbdoLQGfMxlxShXhq9ACR22T/JMYlCbtZ35f8v6P7/SQ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E221D606A336;
	Wed, 25 Nov 2026 09:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E221D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 1fb90370e8b411f19a56ed5b684f684d-20261125
X-CTIC-Tags:
	HR_CC_CHARSET, HR_CC_CHARSET_NUM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME
	HR_CC_NO_NAME, HR_CHARSET, HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, UD_TRUSTED, CIE_BAD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:ba469694-0e2d-466e-8fc7-55d24415b2a8,IP:10,
	URL:25,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:ba469694-0e2d-466e-8fc7-55d24415b2a8,IP:10,UR
	L:25,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:c5b09dbcdd18cb4833e49ca365a6b0bb,BulkI
	D:261125173937JK7RFES4,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2|1,URL:11|94|82|1,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:1,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,
	TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1fb90370e8b411f19a56ed5b684f684d-20261125
X-User: liwang@kylinos.cn
Received: from computer.. [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <liwang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 901844680; Wed, 25 Nov 2026 17:39:34 +0800
From: Li Wang <liwang@kylinos.cn>
To: Miklos Szeredi <miklos@szeredi.hu>,
	German Maglione <gmaglione@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Cc: =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	fuse-devel@lists.linux.dev,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	virtio-fs@lists.linux.dev,
	Li Wang <liwang@kylinos.cn>,
	stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] virtiofs: fix lost reply due to unaligned cache line sharing
Date: Wed, 25 Nov 2026 17:39:08 +0800
Message-Id: <20261125093908.48619-1-liwang@kylinos.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Post: <mailto:virtio-fs@lists.linux.dev>
List-Help: <mailto:virtio-fs+help@lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
List-Owner: <mailto:virtio-fs+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

virtio_fs_enqueue_req() maps fuse_req::out.h for DMA_FROM_DEVICE in
place. fuse_req comes from the "fuse_request" slab with no DMA-granule
alignment, so out.h shares a CPU cache line with the waitq field.
request_wait_answer() updates waitq while the DMA is active.

Note: Sashiko correctly identified the bug, but the resulting behavior
is not as described. Sashiko reported that unmap invalidates this shared
cache line and drops the waitq updates made by request_wait_answer(),
so wake_up() walks a damaged list, the waiter never runs, and a later
wait-queue operation can panic. That is not what current arm64 does for
this buffer. fuse_out_header is 16 bytes and does not cover a whole cache
line. dcache_inval_poc() uses dc civac on that partial line: a dirty line
is written back and then invalidated. The waitq update is kept, but the
out.h written by the device is lost and reverts to its initial all-zero
values. virtio_fs_verify_response() rejects that header, because
its unique and length do not match, and the request finishes with -EIO.

Place out.h on its own DMA granule and start waitq on the following
one. Allocate the slab at __alignof__(struct fuse_req) so those
offsets are granule-aligned in memory. Coherent architectures keep
ARCH_DMA_MINALIGN at the natural alignment, so fuse_req does not grow
there. The padding is compiled in only when virtiofs is enabled.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-41eaaf0f-0eb9-4809-99cf-5f83439eb848
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/fuse/dev.c        |  3 ++-
 fs/fuse/fuse_dev_i.h | 18 ++++++++++++++++--
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index b198cc729cba..00e637d5e552 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2342,7 +2342,8 @@ int __init fuse_dev_init(void)
 	int err = -ENOMEM;
 	fuse_req_cachep = kmem_cache_create("fuse_request",
 					    sizeof(struct fuse_req),
-					    0, 0, NULL);
+					    __alignof__(struct fuse_req),
+					    0, NULL);
 	if (!fuse_req_cachep)
 		goto out;
 
diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
index a8eba46a3e51..e42f3dc30d3b 100644
--- a/fs/fuse/fuse_dev_i.h
+++ b/fs/fuse/fuse_dev_i.h
@@ -12,6 +12,18 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/fs.h>
+#include <linux/cache.h>
+
+/*
+ * virtiofs DMA-maps fuse_req::out.h for DMA_FROM_DEVICE in place.
+ * Put @out on its own granule and start @waitq on the next one.
+ * fuse_dev_init() allocates the slab at this alignment.
+ */
+#if IS_ENABLED(CONFIG_VIRTIO_FS)
+#define FUSE_REQ_DMA_ALIGN __aligned(ARCH_DMA_MINALIGN)
+#else
+#define FUSE_REQ_DMA_ALIGN
+#endif
 
 /* Ordinary requests have even IDs, while interrupts IDs are odd */
 #define FUSE_INT_REQ_BIT (1ULL << 0)
@@ -94,10 +106,10 @@ struct fuse_req {
 	struct {
 		/** @out.h: The request output header */
 		struct fuse_out_header h;
-	} out;
+	} out FUSE_REQ_DMA_ALIGN;
 
 	/** @waitq: Used to wake up the task waiting for completion of request */
-	wait_queue_head_t waitq;
+	wait_queue_head_t waitq FUSE_REQ_DMA_ALIGN;
 
 #if IS_ENABLED(CONFIG_VIRTIO_FS)
 	/**
@@ -118,6 +130,8 @@ struct fuse_req {
 	unsigned long create_time;
 };
 
+#undef FUSE_REQ_DMA_ALIGN
+
 /* One forget request */
 struct fuse_forget_link {
 	struct fuse_forget_one forget_one;
-- 
2.34.1

