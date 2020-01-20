From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Date: Mon, 20 Jan 2020 11:53:30 +0900
Message-ID: <20200120025330.32140-1-misono.tomohiro@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd: passthrough_ll: Use cache_readdir
	for directory open
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Since keep_cache(FOPEN_KEEP_CACHE) has no effect for directory as
described in fuse_common.h, use cache_readdir(FOPNE_CACHE_DIR) for
diretory open when cache=always mode.

Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 5519682daa..088fef08f1 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -1674,7 +1674,7 @@ static void lo_opendir(fuse_req_t req, fuse_ino_t ino,
 
     fi->fh = fh;
     if (lo->cache == CACHE_ALWAYS) {
-        fi->keep_cache = 1;
+        fi->cache_readdir = 1;
     }
     fuse_reply_open(req, fi);
     return;
-- 
2.21.1


