From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:26 +0100
Message-Id: <20210414155137.46522-15-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 14/25] DAX: virtiofsd: Make
	lo_removemapping() work
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: Vivek Goyal <vgoyal@redhat.com>

Let guest pass in the offset in dax window a mapping is currently
mapped at and needs to be removed.

Vivek added the initial support to remove single mapping and later Peng
added patch to support removing multiple mappings in single command.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Peng Tao <tao.peng@linux.alibaba.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index bf7a7f3c23..a9f0505414 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3209,8 +3209,36 @@ static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
                              fuse_ino_t ino, unsigned num,
                              struct fuse_removemapping_one *argp)
 {
-    /* TODO */
-    fuse_reply_err(req, ENOSYS);
+    VhostUserFSSlaveMsg *msg;
+    size_t alloc_count = (num > VHOST_USER_FS_SLAVE_MAX_ENTRIES) ?
+                              VHOST_USER_FS_SLAVE_MAX_ENTRIES : num;
+    int ret = 0;
+    msg = g_malloc0(sizeof(VhostUserFSSlaveMsg) +
+                    alloc_count * sizeof(VhostUserFSSlaveMsgEntry));
+
+    for (int i = 0, o = 0; num > 0; i++, argp++) {
+        VhostUserFSSlaveMsgEntry *e = &msg->entries[o];
+
+        e->len = argp->len;
+        e->c_offset = argp->moffset;
+
+        o++;
+        if (--num == 0 || o == VHOST_USER_FS_SLAVE_MAX_ENTRIES) {
+            msg->count = o;
+            ret = fuse_virtio_unmap(se, msg);
+            if (ret < 0) {
+                fuse_log(FUSE_LOG_ERR,
+                         "%s: unmap over virtio failed "
+                         "(offset=0x%lx, len=0x%lx). err=%d\n",
+                         __func__, argp->moffset, argp->len, ret);
+                break;
+            }
+            o = 0;
+        }
+    }
+
+    fuse_reply_err(req, -ret);
+    g_free(msg);
 }
 
 static struct fuse_lowlevel_ops lo_oper = {
-- 
2.31.1

