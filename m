From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Date: Tue, 21 Jan 2020 15:32:36 +0800
Message-ID: <20200121073236.9067-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH] virtiofsd/passthrough_ll: Fix wrong output
	format in lo_setxattr()
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: virtio-fs@redhat.com

Actual debug output:
-------------------------------
[2778114403742] [ID: 00000033] lo_setxattr(ino=93998909307364[2778114466291] [ID: 00000033]    unique: 56, success, outsize: 16
-------------------------------
Correct debug output:
-------------------------------
383 [2341816212531] [ID: 00000098] lo_setxattr(ino=3, name=user.test value=test size=4)
-------------------------------

Fixes: 63bc560920ad ("virtiofsd: print log only when priority is high enough)"
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 tools/virtiofsd/passthrough_ll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 57f58aef26..ff34e77a23 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2528,7 +2528,7 @@ static void lo_setxattr(fuse_req_t req, fuse_ino_t ino, const char *name,
         goto out;
     }
 
-    fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64,
+    fuse_log(FUSE_LOG_DEBUG, "lo_setxattr(ino=%" PRIu64
              ", name=%s value=%s size=%zd)\n", ino, name, value, size);
 
     if (inode->is_symlink) {
-- 
2.21.0




