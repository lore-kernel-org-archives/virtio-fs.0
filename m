DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=HMA+Yh0ic+1ygR00eLSjhUGZu87gLJ2En6bwkM+gtYU=;
	b=tZN5IbONU28HQF+6r/H7MUWUGcGQRQd5cr/FuSuZzU+cvepsYpxd249dKESGDrhuXD
	EgjfpXfq5OOLMN2HEhNAd/B2tQRhIz3RPNsqoBYZg+BJqGovK/isjrKid85jNy6SHBZE
	m4SXC5tbusW2+UkeC+58QG9rvX6HRxjGZfbujyFbS6rKtQ0/TOQ0ZdrI5z0X0RrPteqF
	hNWA7v5YZvzC+4F7D0aFKifK+qpJWwt1hT+sMZ2jJPCmPohXFBOu/A3tOJIR08WEeI0t
	2rLWFaRu5LOCx2W3yZjynl5fARvQOWXwzJsZXgV+J9GbRBVA1suCqVFDo3g9id7gmDy4
	L5iw==
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Date: Wed,  6 Nov 2019 14:06:00 -0500
Message-Id: <20191106190602.14522-1-msys.mizuma@gmail.com>
Subject: [Virtio-fs] [PATCH 0/2] Add ID and timestamp to the log with
	FUSE_LOG_DEBUG level
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

For debugging purpose, this patch series add ID to specify the thread
and timestamp to check the time delta for each events.

Masayoshi Mizuma (2):
  virtiofsd: Add ID to the log with FUSE_LOG_DEBUG level
  virtiofsd: Add timestamp to the log with FUSE_LOG_DEBUG level

 contrib/virtiofsd/passthrough_ll.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

-- 
2.18.1

