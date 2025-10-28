Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880AB350282
	for <virtio-fs@lists.linux.dev>; Tue, 28 Oct 2025 20:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761681811; cv=none; b=JQL79RVsFo/Tdr0Ts5z7PGnmhIm7Uj+/CWhbji7ZDMZfq76ODpb0wk7bdK/jC8VlktMQ67pWSRrkp9+oU6s2jMnXZZDz3hlILbUhSYRXM1ILfUB4Hz8l/hhw3jkNXJyo7GN8k6t8Qf43cc1iiEHbi2S2xBRBZRh0K5AzK9JkvDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761681811; c=relaxed/simple;
	bh=BDUaSKODNKtMq7VQYWR0GriGBCfWmxRXz2MCLuAhAaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=orve4FJmenVf6d3Vdb1co1kohwwZPrlANGVKbYEy/qOa0co0NFf5ALOwAjjSqJ9ZW04Bis8bgdIWNgT1KkI2MnOgh4TmHzvYZqFSJFals/xp3HEZw+xgEqFsNsNuR8pDvOe7SCCz8ap+DJuKEdyuWmrOUw8Xvqw4FIEvuVQ3p6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzhzgkeg; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzhzgkeg"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7a213c3c3f5so8341184b3a.3
        for <virtio-fs@lists.linux.dev>; Tue, 28 Oct 2025 13:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761681809; x=1762286609; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=H8joGPkRS7NaA/SU5NP/PHmANMNfQZvGYAt78YOV8B8=;
        b=fzhzgkeg4981XtDrVE/sXnlhkXWzzFFqPuhQXEI4Zu5Sal3AYHUEssBAbOj4+wVpUl
         JLIHjIVYrrSc5Uj5JjQIQzqZfQeRVMqssDYWYIYzjY9s/bPGAyCIFq93iLSxMnpFjPUV
         DdocZK3e6JbuNMCmAjEpUWU6CdOKGdstr+/RmfoK9a0kldZFKzkP1Ns4oWmjAToe2pf6
         YbF0apnlQW/eUSUeGt4OopJDxIT6X5Xjca2rYVkWqw76mY+JIdoTA+Ny+nRwdWQVS7ij
         MM15lQbGSFiRDBLQnMeyshoWnKTwXbod2O144Pn7i4GFtMpjJF9687slNF10XYxUoiZN
         Bcow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761681809; x=1762286609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H8joGPkRS7NaA/SU5NP/PHmANMNfQZvGYAt78YOV8B8=;
        b=OUiR+iJ5hxyeK3W1MhCAldZcS4uCRf0qkYwzn2vZdUyl9/3H65ivGmwUZwCThrzkXO
         rlmlK+XMTurBbe6Ebu7VTvvVTdEaSzwC45nXRT+WcNeTpRyCcKQBRyejIB3XEXAXPivJ
         YGmp0e2DiL5NLiHb+LZ1eqF1H53nOTcn8gTwb+wKvh2u/hWYdrZb3C4eqhn8/PLVtdPT
         CTdFKicQV7xxaG0hpIEh3kn04p8qK9BckPgTZXXr3T0ZTrdaatSFTUefx+paxBqqR5DR
         kFQRb8NOrfNOgyffAyH8d0hqZRJFcMT79haOu66ufB0pc1HxoWPjQC1VL8/6rElpddnb
         7OMw==
X-Forwarded-Encrypted: i=1; AJvYcCUkA7kwH4LAOys8cJtu5ouIy8ME1Q6mXN/G2rWUlcS92wcHugk7st0BMW2CTy4pXb3kSOO4kM8iSUA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIEfDYKmTItCFo1HHROg5GRzXNTSoFgo6zEtpS+w5Qz0yi3RlY
	5Kq4WQcrHqMrjw6So4wgbo4zFm39iYZIa8xb76tNFK3yw03r4feJVEU+
X-Gm-Gg: ASbGnct3lg5+y8pGttq7aAKsFK4zNhoRAXBzj3xWYlx2apM7oiRy6ar554GCkr9HvGN
	IJaDo5WaRnUIRVpNM5gMdjhkuibdoqEpsau6QUWSrxW6U9kPas1ft61I6nPHcMEt0Ro/uQ6zxSy
	aNKKSKoWZjTAo7/iYLC2gPCe0LaGXU+BdBceGek20C0hAlMHAsIqW1rL6uM1hJUJVpfetbJbKYw
	0BoF69ssLeqZbYt6ULJkG7KZm4eRmCt779pzEsRJFwkSnabYEV/Zg7KXM/0kUFWFlDs1u8AwoQ9
	kHQ43KyHrPPNTIANkQdtQok2Q/FsNl6t5V+IoLZM7o6kKXUamo40QqPkNCllsnfaQoy/Pz27Dj3
	vT0cPsHj2fnkAZFImJbF9f9zG+esqUVeUmkQg1XqDvYwcOwNwi6g5McMSz6D7bReeicxCAhhw+E
	6b2xkWrpWzOKYPraYyx4nZCC8GxgaSAvXvIbpvZw==
X-Google-Smtp-Source: AGHT+IFax4JLp6peVjA4GRSNGg+x5gUWORdeMvPmm1KtEIj6rMAl9UjikOCZ4H3Vmq+EX50VwOXgvg==
X-Received: by 2002:a17:903:1c2:b0:294:def6:bc1e with SMTP id d9443c01a7336-294def6bd88mr4468365ad.15.1761681808551;
        Tue, 28 Oct 2025 13:03:28 -0700 (PDT)
Received: from brajesh.. ([2401:4900:78f2:772b:141e:4f0f:8f8f:6f84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d4254asm128996765ad.82.2025.10.28.13.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 13:03:28 -0700 (PDT)
From: Brajesh Patil <brajeshpatil11@gmail.com>
To: miklos@szeredi.hu,
	stefanha@redhat.com,
	vgoyal@redhat.com,
	eperezma@redhat.com
Cc: virtualization@lists.linux.dev,
	virtio-fs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	linux-kernel-mentees@lists.linux.dev,
	david.hunter.linux@gmail.com,
	khalid@kernel.org,
	Brajesh Patil <brajeshpatil11@gmail.com>
Subject: [PATCH] fuse: virtio_fs: add checks for FUSE protocol compliance
Date: Wed, 29 Oct 2025 01:33:11 +0530
Message-ID: <20251028200311.40372-1-brajeshpatil11@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: virtio-fs@lists.linux.dev
List-Id: <virtio-fs.lists.linux.dev>
List-Subscribe: <mailto:virtio-fs+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:virtio-fs+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add validation in virtio-fs to ensure the server follows the FUSE
protocol for response headers, addressing the existing TODO for
verifying protocol compliance.

Add checks for fuse_out_header to verify:
 - oh->unique matches req->in.h.unique
 - FUSE_INT_REQ_BIT is not set
 - error codes are valid
 - oh->len does not exceed the expected size

Signed-off-by: Brajesh Patil <brajeshpatil11@gmail.com>
---
 fs/fuse/virtio_fs.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 6bc7c97b017d..52e8338bf436 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -764,14 +764,34 @@ static void virtio_fs_request_complete(struct fuse_req *req,
 {
 	struct fuse_args *args;
 	struct fuse_args_pages *ap;
-	unsigned int len, i, thislen;
+	struct fuse_out_header *oh;
+	unsigned int len, i, thislen, expected_len = 0;
 	struct folio *folio;
 
-	/*
-	 * TODO verify that server properly follows FUSE protocol
-	 * (oh.uniq, oh.len)
-	 */
+	oh = &req->out.h;
+
+	if (oh->unique == 0)
+		pr_warn_once("notify through fuse-virtio-fs not supported");
+
+	if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique)
+		pr_warn_ratelimited("virtio-fs: unique mismatch, expected: %llu got %llu\n",
+				    req->in.h.unique, oh->unique & ~FUSE_INT_REQ_BIT);
+
+	WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
+
+	if (oh->error <= -ERESTARTSYS || oh->error > 0)
+		pr_warn_ratelimited("virtio-fs: invalid error code from server: %d\n",
+				    oh->error);
+
 	args = req->args;
+
+	for (i = 0; i < args->out_numargs; i++)
+		expected_len += args->out_args[i].size;
+
+	if (oh->len > sizeof(*oh) + expected_len)
+		pr_warn("FUSE reply too long! got=%u expected<=%u\n",
+			oh->len, (unsigned int)(sizeof(*oh) + expected_len));
+
 	copy_args_from_argbuf(args, req);
 
 	if (args->out_pages && args->page_zeroing) {
-- 
2.43.0

