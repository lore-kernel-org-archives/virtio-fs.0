Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=124.126.103.232
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795427733;
	b=poQjmvjBTZaiSHl1uOt9tZ6F/13F37AxGqQrDS87dj2cBmxqhwsGyDw+PcYk+Ma94lXD
	 1Ztnml6qF+MSgNfzWbYUw/kS4wpXAQUVTDq4jXi0g2dFS6SyJ/bXCLxtFxILhafYz11RQ
	 x/MAwgwsjHArp8Vl0TjwU7d3Q5QaL9fDI+qi7lNS7nvh2IwqPDFyxW4PomwHusPS7Uaui
	 x/p7iq8p+Lu8gNESACh0ktTmTqlgRqiA44n0TegEMaobFSkT079MSE9XumPsbeFA7W9py
	 ALzc0n6Bu8BwRhzy2AkhCJM1x69MnXy+cqb1BpvtyBgEBIpGcj3TFPc4ygr0MGbdsTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795427733;
	h=DMARC-Filter:X-UUID:X-CTIC-Tags:X-CID-P-RULE:X-CID-O-INFO:X-CID-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:X-User:
	 Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ExBrdivvPGnMfALa1gyv4ambGV9X8LsRbMUTFusz2lM=;
	b=DiAtWX3bp/chaBbmkf8J0uv3RxlO5OsIOeKhbzDRVt8bFhL7KxBzRdHwM5yKOIlK3MP7
	 qIaYcmi+JNqkRi/GTlaZUR/dIEfUrbBQZUrrpvPZSd5HBO9yAaYHkBNdGtOY5E6stPcCe
	 0uycUfPu1N8J3DXU9gzwiNbWIW1HqOfl2PfnKpx9qQdDCqglFXPDBU7WnxlaRL/GY53F8
	 z1gxfXzlXvu6Xc0a9KGL7DX6IgT6LwfPimU+5cfXQaDH4qjXUBzAvTWxPL5p21p84kohM
	 pEoPd9/8R2r2d4NB3WufJOxZZnncf4tmIgLxBE6Rhj+l1D22ohqyU8FM0k0PF+zqTCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kylinos.cn;
	spf=pass smtp.mailfrom=kylinos.cn;
	arc=none smtp.remote-ip=124.126.103.232
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99CC606A31E;
	Mon, 23 Nov 2026 09:55:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E99CC606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ff3964bee72311f19a56ed5b684f684d-20261123
X-CTIC-Tags:
	HR_CC_CHARSET, HR_CC_CHARSET_NUM, HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME
	HR_CC_NO_NAME, HR_CHARSET, HR_CHARSET_NUM, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME, HR_SJ_LANG
	HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN
	HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NAME, IP_TRUSTED
	SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d9d3e7ed-4998-436a-99a2-9ca028c2f262,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:d9d3e7ed-4998-436a-99a2-9ca028c2f262,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:a8d4509ebbf7a42d767ec0deb1659f01,BulkI
	D:261123175525VOW09MFG,BulkQuantity:0,SF:17|19|38|66|78|102|127|153|865|89
	8,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2|1,URL:0,File:nil,RT:nil,Bulk:nil,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_IBB
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ff3964bee72311f19a56ed5b684f684d-20261123
X-User: liwang@kylinos.cn
Received: from computer.. [(116.128.244.169)] by mailgw.kylinos.cn
	(envelope-from <liwang@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 137605619; Mon, 23 Nov 2026 17:55:21 +0800
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
	stable@vger.kernel.org
Subject: [PATCH] virtiofs: fix potential unmount or device removal hang due to stuck FORGETs
Date: Mon, 23 Nov 2026 17:54:55 +0800
Message-Id: <20261123095455.88622-1-liwang@kylinos.cn>
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

virtqueue_add_outbuf() returns -ENOSPC when the virtqueue is full.  On
this path it can also return -ENOMEM, when a split-ring DMA mapping
fails, or -EIO, when the virtqueue is broken or a packed-ring mapping
fails.  send_forget_request() turns only -ENOSPC into 1, so
virtio_fs_hiprio_dispatch_work() stops and waits for a completion.  Any
other error frees that FORGET and drops its in_flight count, then
returns the negative errno.  The worker treats every non-zero return as
a reason to stop, so the rest of queued_reqs is left unexamined.

hiprio dispatch_work is scheduled only from
virtio_fs_hiprio_done_work(), which runs from that virtqueue interrupt.
Once no descriptor is outstanding, the device raises no interrupt and
nothing walks the list.  virtio_fs_send_forget() submits a new FORGET
directly and does not schedule the worker.  The queued entries are
reached again only if that new FORGET is placed on the virtqueue and
the device completes it.  A new FORGET that itself gets -ENOSPC,
-ENOMEM or -EIO does not schedule dispatch_work.

-EIO stays -EIO for every later add.  New FORGETs never enter the ring,
so they never produce the completion that would run the worker.
Entries already queued still hold in_flight.  virtio_fs_drain_queue()
waits for in_flight to reach zero before it flushes dispatch_work, and
unmount or device removal hangs.  -ENOMEM can succeed on a later
attempt, but with an empty ring the same entries wait until some later
FORGET both enters the ring and completes.  Each such completion
retries only the head of the list and stops again when that head fails.

After the FORGET is dropped, return 0 so this same worker invocation
continues with the rest of queued_reqs.  A full queue still returns 1.

Fixes: a62a8ef9d97d ("virtio-fs: add virtiofs filesystem")
Cc: stable@vger.kernel.org
Signed-off-by: Li Wang <liwang@kylinos.cn>
---
 fs/fuse/virtio_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d247a02cdca9..d2d1e8fe3a91 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -655,6 +655,8 @@ static int send_forget_request(struct virtio_fs_vq *fsvq,
 			kfree(forget);
 			if (in_flight)
 				dec_in_flight_req(fsvq);
+			/* Dropped.  Let the worker keep going. */
+			ret = 0;
 		}
 		goto out;
 	}
-- 
2.34.1

