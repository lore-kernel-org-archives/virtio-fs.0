Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415779;
	b=WZSnVoAs+rQbZrw7Mpk/7pY0C8JgK3lIkCSaE3AzwFaibCfVmt8/oLas1YgifLJ6fLbp
	 BG/3lhiHQxkK679AEc9QTDhuEgXqvJuoHupA4JwpE3dBVt8+R+XhUaj5LVQTsqiC0TlKv
	 ytShEkY1sgh7xIYyxlOnqwHxM9kr9wM5682HjrQba4jHhNYl2Jqu+8pvPgOtRCkrptxnA
	 gTpAejfyGNX9HvMLxTU7roRREKFVWcRBEuKNC2otPvn1UBBUw1/7o3n8GnEfHH1+gvFZp
	 9MfddZ4AjIlGbCWkQRD03gMr+qeEYOKW5Se+5MX0WofJ5QpIR99smonxtGiMuksposA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415779;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QhvI4EcrcVWaHsYhZmDudDFBhnWCIbKlWCXMmkXssF4=;
	b=nhLFA7YJczbTJoDnrgvor1ZAJIq+MxaFc98Z32zWoWWKtM20KW64aRNHis9AECM8cyYr
	 NxblRNVBxI+c5GR5r5fdiOKbu5Q6UXZLe7E3IJree6VVAQ6SS8vfxerrDqvyxxdcu6NkO
	 aRuFUsZ6NYtUIOC01KIeCxhq1XF2brsE5DxXWCfuxie5txN9MTn1kP38iuk16KN6k9Hgc
	 bA4BCm1Hp0mofveYOQav+fxCcaXRl6UEbv2hzdvWWDfvrhpgSyyVmw/qTqnhsouvy0LcZ
	 tq/pYG1FXrVilC0Sy7ugNhtQ6car1Gsv+6wVF3RGgdYw7s2k/jZ3Szf4izG4/WGQc+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iec6Pvv3;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A213D606A31E
	for <virtio-fs@lists.linux.dev>; Mon, 23 Nov 2026 06:36:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A213D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iec6Pvv3
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8b77e464208so229362b3a.2
        for <virtio-fs@lists.linux.dev>; Sun, 22 Nov 2026 22:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795415778; x=1796020578; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhvI4EcrcVWaHsYhZmDudDFBhnWCIbKlWCXMmkXssF4=;
        b=iec6Pvv3a6V8s2spPNA2MiXFRx/ExJ1/vg7UsJnjOVIovvV0sNY1my7OfeGLE8Zn3w
         0ZNzfeWYVHo5oSF9VvOwZmPe2391cwOVO74OOfgkRlonpU+XdrBlkO2Iws0foVI8u3Y7
         wJVpTRVE2nSkj01aKYJnPq+QOt/bjcywNzAUIvWvNC23h7AAi3mqg9Z2BqeQd45AvlE1
         1XfnTzIv1+xL15X6yr7CN/elf0zmc34qA9rFdtnRo+uhlEMhkyJNn479JXxwg65Ixgsl
         LvmaYhVbURNVrgLpfxLV9dSXi2fE5oeHsNXK4zIUG4smQmf14HImjcHcb1J2ct3DRu+0
         G7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795415778; x=1796020578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QhvI4EcrcVWaHsYhZmDudDFBhnWCIbKlWCXMmkXssF4=;
        b=VlWPRQWMImVLGBa6qXKidF2kHUu8OK9HgbNZZWkX2gJPQRsD4PisewXbmCnhaxe5OO
         vLS3KJIhZUekyGynRyIb1IVJwGzwpFK7tfQYfPGnrzhHjBQT9WHthnpSyWiWXVhmB57p
         tgvDOUZqLDch7dTC9qIKHnK4gMPJVkSz4S08yMBdRIXkBNlxCnLBguo9Qrp00be34psh
         Vl3Vmga7CUJtAQHi0M02Xw/6HN2FUPut1HLQSa/2OLUdcjen+uiU2W5DE3SkQlWsDMLm
         VkjhsElLDr9ytfDaxkBo5LuNn1FgV4t/+d1kW9eZ/8zlPSw0dMDR6NxVNN61FneKUPu5
         BRHQ==
X-Forwarded-Encrypted: i=1; AL+hErGdg7rriUwvq1ZzxHA6lDpvtKzVbZUEbsv1+/fGSvt6pw7OPgqCBbcjrVuzlrC8i7GhkC/6Vq/N5iw=@lists.linux.dev
X-Gm-Message-State: APuU4Z+4Km3pXrHXJen87nwZojUA4GVJd9AkIFyjwJg3Z1CSx5N73vi0
	KKn1jzcui0jmFPUR1qS12/d3ubi8OEmSMEU6KtHxqyxPM1C5WCmVM1Y0Vs3bLQ==
X-Gm-Gg: AZFdTZfmangXITPeucCFOr5sRMWsNmEbMJY7Li+iO8eoaPpUhbHHu7Yxe014wLEcqN4
	sMOobzvuR5XUjHfT2JSau0cu6pArmWjcMMLmVRnBmpdEuEFDlv3RAEC3wN6kZh7eRNkzHKhdJ9E
	goPEj8OvG2VPm3qarXN4tpEFUHL9jWO0ZDB1KodOzxFUMbRuzoz5dPtv70PPRNtSnFD6nLAXkPy
	qFCfN+RRflH+3v69qyYWB+1yGRBMdcmIESa60rD0jIEzJI6JC/hBDglg67GL00/QmkRriHhDfFZ
	EV3EMZz6sF+eK1asumTFHd8DpFcwa6vdfeTvO5uqqkrtzEIh+30P6GqBVSNWOugTesbC6yHE3u0
	WzTAG/MaPbvzqkQK2LmrAxmeBycqZOLVu0zZotESErjx/4Onab0a8QONVWgXhwIGQQbYtz1MFrL
	7Q7IGQXfJJdXr9ZmbG+2VGZfwklXBZWcRD5YY1Yi0gQZptg73LK+VLAbeT31XPX49uByRL/CUP7
	uOjhoC422cYkCs+DJ4dk+An18NtvfswNuNySZW60zCKxs/W/uixcovjVL4B77Ql1IvswdB723r0
	HItee3P3GTiakTJtL41Ghiaf6SzM9FRF7ht18WJa2XoHnltpb3SSpvg9Q3Va9mFek6L3ZD/qdtz
	jdZBOQnTXpA0PsTCG
X-Received: by 2002:a17:902:e38b:b0:2f0:7707:227c with SMTP id d9443c01a7336-2f0770728c8mr46065645ad.4.1795415777889;
        Sun, 22 Nov 2026 22:36:17 -0800 (PST)
Received: from localhost.localdomain ([139.159.170.71])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f118c88sm47430695ad.56.2026.11.22.22.36.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 22:36:17 -0800 (PST)
From: Qihang <q.h.hack.winter@gmail.com>
To: Li Wang <liwang@kylinos.cn>
Cc: German Maglione <gmaglione@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Eugenio Perez <eperezma@redhat.com>,
	virtualization@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtio-fs@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>
Subject: [PATCH v5] fuse: virtio-fs: fix lost wakeup on a full virtqueue
Date: Mon, 23 Nov 2026 14:36:09 +0800
Message-ID: <20261123063609.82014-1-q.h.hack.winter@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <6c6cea56-1af2-4a37-b081-83244d5e09cd@kylinos.cn>
References: <6c6cea56-1af2-4a37-b081-83244d5e09cd@kylinos.cn>
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

virtio_fs_enqueue_req() drops fsvq->lock when virtqueue_add_sgs() fails
with -ENOSPC, and the caller requeues the request in a second critical
section.  Completion processing can run in between: it reaps a
completion, finds queued_reqs empty, and does not schedule dispatch.  If
the queue then goes idle, the request can remain on queued_reqs and keep
in_flight above zero.  A subsequent virtio_fs_drain_queue() can wait
indefinitely.

On -ENOSPC, add the request to queued_reqs before releasing fsvq->lock,
as send_forget_request() does.  This prevents
virtio_fs_requests_done_work() from checking queued_reqs between the
failed submission and the insertion.  Both callers can then return
immediately on -ENOSPC.

Free req->argbuf before adding the request to queued_reqs.  Once
fsvq->lock is released, the dispatch worker may already have taken the
request, so the -ENOSPC return path must skip any further access to req.

Count the request in in_flight on its first submission.  A retry keeps
the existing count.

Fixes: 106e4df1206b ("virtio-fs: improved request latencies when Virtio queue is full")
Cc: stable@vger.kernel.org # 6.11+
Link: https://lore.kernel.org/all/sashiko-outbox-204365@kernel.org/
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
---

Since v4, queue the request under fsvq->lock on -ENOSPC, as Li Wang
suggested, and drop completion_seq.

 fs/fuse/virtio_fs.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index d247a02..4d4f2e3 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -596,12 +596,8 @@ static void virtio_fs_request_dispatch_work(struct work_struct *work)
 		ret = virtio_fs_enqueue_req(fsvq, req, true, GFP_KERNEL);
 		memalloc_nofs_restore(flags);
 		if (ret < 0) {
-			if (ret == -ENOSPC) {
-				spin_lock(&fsvq->lock);
-				list_add_tail(&req->list, &fsvq->queued_reqs);
-				spin_unlock(&fsvq->lock);
+			if (ret == -ENOSPC)
 				return;
-			}
 			req->out.h.error = ret;
 			spin_lock(&fsvq->lock);
 			dec_in_flight_req(fsvq);
@@ -1433,7 +1429,11 @@ static unsigned int sg_init_fuse_args(struct scatterlist *sg,
 	return total_sgs;
 }
 
-/* Add a request to a virtqueue and kick the device */
+/*
+ * Add a request to a virtqueue and kick the device.  If the virtqueue is
+ * full, queue the request on fsvq->queued_reqs for the dispatch worker and
+ * return -ENOSPC; the caller must not queue it a second time.
+ */
 static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 				 struct fuse_req *req, bool in_flight,
 				 gfp_t gfp)
@@ -1503,6 +1503,20 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 	vq = fsvq->vq;
 	ret = virtqueue_add_sgs(vq, sgs, out_sgs, in_sgs, req, GFP_ATOMIC);
 	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			/*
+			 * Queue the request before dropping fsvq->lock, so
+			 * virtio_fs_requests_done_work() cannot check
+			 * queued_reqs between the failed add and the
+			 * insertion.  Release argbuf first, as dispatch may
+			 * retry the request as soon as the lock is dropped.
+			 */
+			kfree(req->argbuf);
+			req->argbuf = NULL;
+			list_add_tail(&req->list, &fsvq->queued_reqs);
+			if (!in_flight)
+				inc_in_flight_req(fsvq);
+		}
 		spin_unlock(&fsvq->lock);
 		goto out;
 	}
@@ -1527,7 +1541,8 @@ static int virtio_fs_enqueue_req(struct virtio_fs_vq *fsvq,
 		virtqueue_notify(vq);
 
 out:
-	if (ret < 0 && req->argbuf) {
+	/* On -ENOSPC, dispatch may already have taken req. */
+	if (ret < 0 && ret != -ENOSPC && req->argbuf) {
 		kfree(req->argbuf);
 		req->argbuf = NULL;
 	}
@@ -1564,13 +1579,9 @@ static void virtio_fs_send_req(struct fuse_iqueue *fiq, struct fuse_req *req)
 	if (ret < 0) {
 		if (ret == -ENOSPC) {
 			/*
-			 * Virtqueue full. Retry submission from worker
-			 * context as we might be holding fc->chan->bg_lock.
+			 * Retry from worker context: we might be holding
+			 * fc->chan->bg_lock here.
 			 */
-			spin_lock(&fsvq->lock);
-			list_add_tail(&req->list, &fsvq->queued_reqs);
-			inc_in_flight_req(fsvq);
-			spin_unlock(&fsvq->lock);
 			return;
 		}
 		req->out.h.error = ret;
-- 
2.54.0 (Apple Git-157)

