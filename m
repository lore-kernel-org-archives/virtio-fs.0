DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding;
	bh=YgqSWgggc8NIZdLGsTHPcESqoSDlIYTq+9ZXTSuDuJM=;
	b=Y0f6hvJ0sVqlSteHNXY/4E5fm99CdPtRNXoq0VC6btvAStVgjT+0haXKmNT2VXzbD7
	uICpGraQRHxynoRak714mcQDoJKeW+VL8HKjoXQfB3MDCpUEBv3Rldab3FrH5ZRyjyiX
	RcUYZa6Ra8SF9wj8acoGtm9MPx+wuFFAQtaWvB9i7RVRkTecK+BJ2KgZbWwhcQZvTBhp
	L/xi6eJES5/tr8Wryd0M1XK0vniR+T6BvVOMAQfUDOTzfjf58LdIlJ94rD/400yChGAP
	VjKK9DPMW+dXbfPNBRwG9a+/i2Kk1dfX4Q96xPRc7tE9vrX+qzxcMaYc9FaZFfDN01YK
	NQEA==
From: Mahmoud Mandour <ma.mandourr@gmail.com>
Date: Tue, 20 Apr 2021 17:46:38 +0200
Message-Id: <20210420154643.58439-4-ma.mandourr@gmail.com>
In-Reply-To: <20210420154643.58439-1-ma.mandourr@gmail.com>
References: <20210420154643.58439-1-ma.mandourr@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"
Subject: [Virtio-fs] [PATCH v2 3/7] virtiofsd: Changed allocations of
	fuse_session to GLib's functions
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org
Cc: "open list:virtiofs" <virtio-fs@redhat.com>, Mahmoud Mandour <ma.mandourr@gmail.com>

Replaced the allocation and deallocation of fuse_session structs
from calloc() and free() calls to g_try_new0() and g_free().

Signed-off-by: Mahmoud Mandour <ma.mandourr@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/fuse_lowlevel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/virtiofsd/fuse_lowlevel.c b/tools/virtiofsd/fuse_lowlevel.c
index f965299ad9..ecc20c9310 100644
--- a/tools/virtiofsd/fuse_lowlevel.c
+++ b/tools/virtiofsd/fuse_lowlevel.c
@@ -2472,7 +2472,7 @@ void fuse_session_destroy(struct fuse_session *se)
     free(se->vu_socket_path);
     se->vu_socket_path = NULL;
 
-    free(se);
+    g_free(se);
 }
 
 
@@ -2495,7 +2495,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
         return NULL;
     }
 
-    se = (struct fuse_session *)calloc(1, sizeof(struct fuse_session));
+    se = g_try_new0(struct fuse_session, 1);
     if (se == NULL) {
         fuse_log(FUSE_LOG_ERR, "fuse: failed to allocate fuse object\n");
         goto out1;
@@ -2555,7 +2555,7 @@ struct fuse_session *fuse_session_new(struct fuse_args *args,
 out4:
     fuse_opt_free_args(args);
 out2:
-    free(se);
+    g_free(se);
 out1:
     return NULL;
 }
-- 
2.25.1

