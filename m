From: Peng Tao <tao.peng@linux.alibaba.com>
Date: Fri,  2 Aug 2019 19:12:23 +0800
Message-Id: <1564744343-8087-1-git-send-email-tao.peng@linux.alibaba.com>
Subject: [Virtio-fs] [PATCH] virtiofsd: do not always set FUSE_FLOCK_LOCKS
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com
Cc: Peng Tao <tao.peng@linux.alibaba.com>

Right now we always enable it regardless of given commandlines.
Fix it by setting the flag relying on the lo->flock bit.

Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 contrib/virtiofsd/passthrough_ll.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/contrib/virtiofsd/passthrough_ll.c b/contrib/virtiofsd/passthrough_ll.c
index a81c01d..be75cb8 100644
--- a/contrib/virtiofsd/passthrough_ll.c
+++ b/contrib/virtiofsd/passthrough_ll.c
@@ -440,10 +440,16 @@ static void lo_init(void *userdata,
 			fuse_debug("lo_init: activating writeback\n");
 		conn->want |= FUSE_CAP_WRITEBACK_CACHE;
 	}
-	if (lo->flock && conn->capable & FUSE_CAP_FLOCK_LOCKS) {
-		if (lo->debug)
-			fuse_debug("lo_init: activating flock locks\n");
-		conn->want |= FUSE_CAP_FLOCK_LOCKS;
+	if (conn->capable & FUSE_CAP_FLOCK_LOCKS) {
+		if (lo->flock) {
+			if (lo->debug)
+				fuse_debug("lo_init: activating flock locks\n");
+			conn->want |= FUSE_CAP_FLOCK_LOCKS;
+		} else {
+			if (lo->debug)
+				fuse_debug("lo_init: disabling flock locks\n");
+			conn->want &= ~FUSE_CAP_FLOCK_LOCKS;
+		}
 	}
 	/* TODO: shared version support for readdirplus */
 
-- 
1.8.3.1

