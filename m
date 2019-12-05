DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id;
	bh=k9WRyzbnSUx0tKZrmYGQBb0c7I+JAD9hVhVu9tEmm9o=;
	b=EJaT/cDTXi+HJWgSI/iXLQ3caGRCLbqfA9v+S+usgG46VvqMFyiQtiNScSl9u2jeBH
	NDJ+R2733Oi5FijeKgCsOigKnlrN8GnuPnFZWAi/J2Uo+KfOp84GUa5ncMqpGFruHD3a
	zW1a6PtByoVOI0LI20xCGv9t/Xr1c4/2XGiyaGNkIFcpRbEPL/rHxyWhy5T/mjuZ1dY8
	sama4qNEjw2mpqSzjFB20P/coWIdA9j3Jkm/7Mu7ch5aPZMhAQt5TcXyuRi1bSDazR19
	oQDzoFOukiS+9Q8ykN7oLifkXotUHdbv5YO+Ixm+JDN+Zl3WIgd1AmFYySnj54U4hVXL
	1msQ==
From: Catherine Ho <catherine.hecx@gmail.com>
Date: Thu,  5 Dec 2019 04:01:26 -0500
Message-Id: <1575536486-24134-1-git-send-email-catherine.hecx@gmail.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: fix double fuse_mbuf_iter_advance
	when do_removemapping
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, virtio-fs@redhat.com
Cc: Catherine Ho <catherine.hecx@gmail.com>

Commit 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support
multiple entries") forgot to remove one fuse_mbuf_iter_advance in
do_removemapping.

Without this patch, virtiofsd will report:
[ID: 00000123] do_removemapping: invalid in, expected 1 * 16, has 60 - 60
[ID: 00000123]    unique: 232, error: -22 (Invalid argument), outsize: 16

Fixes: 8e92b1fc98f7 ("DAX: virtiofsd: make FUSE_REMOVEMAPPING support multiple entries")
Cc: Peng Tao <tao.peng@linux.alibaba.com>
Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
---
 contrib/virtiofsd/fuse_lowlevel.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/contrib/virtiofsd/fuse_lowlevel.c b/contrib/virtiofsd/fuse_lowlevel.c
index bde66c72c3..752e7d97b9 100644
--- a/contrib/virtiofsd/fuse_lowlevel.c
+++ b/contrib/virtiofsd/fuse_lowlevel.c
@@ -1894,14 +1894,6 @@ static void do_removemapping(fuse_req_t req, fuse_ino_t nodeid,
 		return;
 	}
 
-	one = fuse_mbuf_iter_advance(iter, sizeof(*one));
-	if (!one) {
-		fuse_log(FUSE_LOG_ERR, "do_removemapping: invalid in, expected %d * %ld, has %ld - %ld\n",
-			 arg->count, sizeof(*one), iter->size, iter->pos);
-		fuse_reply_err(req, EINVAL);
-		return;
-	}
-
 	if (req->se->op.removemapping)
 		req->se->op.removemapping(req, req->se, nodeid, arg->count, one);
 	else
-- 
2.17.1


