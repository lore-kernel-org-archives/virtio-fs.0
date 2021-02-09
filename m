From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:13 +0000
Message-Id: <20210209190224.62827-14-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 13/24] DAX: virtiofsd: Make lo_removemapping()
	work
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Let guest pass in the offset in dax window a mapping is currently
mapped at and needs to be removed.

Vivek added the initial support to remove single mapping and later Peng
added patch to support removing multiple mappings in single command.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
---
 tools/virtiofsd/passthrough_ll.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 0493f00756..971ff2b2ea 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3023,8 +3023,30 @@ static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
                              fuse_ino_t ino, unsigned num,
                              struct fuse_removemapping_one *argp)
 {
-    /* TODO */
-    fuse_reply_err(req, ENOSYS);
+    VhostUserFSSlaveMsg msg = { 0 };
+    int ret = 0;
+
+    for (int i = 0; num > 0; i++, argp++) {
+        msg.len[i] = argp->len;
+        msg.c_offset[i] = argp->moffset;
+
+        if (--num == 0 || i == VHOST_USER_FS_SLAVE_ENTRIES - 1) {
+            ret = fuse_virtio_unmap(se, &msg);
+            if (ret < 0) {
+                fuse_log(FUSE_LOG_ERR,
+                         "%s: unmap over virtio failed "
+                         "(offset=0x%lx, len=0x%lx). err=%d\n",
+                         __func__, argp->moffset, argp->len, ret);
+                break;
+            }
+            if (num > 0) {
+                i = 0;
+                memset(&msg, 0, sizeof(msg));
+            }
+        }
+    }
+
+    fuse_reply_err(req, -ret);
 }
 
 static struct fuse_lowlevel_ops lo_oper = {
-- 
2.29.2

