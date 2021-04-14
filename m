From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:24 +0100
Message-Id: <20210414155137.46522-13-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 12/25] DAX: virtiofsd: Add setup/remove
	mapping handlers to passthrough_ll
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, stefanha@redhat.com, vgoyal@redhat.com, virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 1553d2ef45..afa86650c1 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3144,6 +3144,22 @@ static void lo_destroy(void *userdata)
     pthread_mutex_unlock(&lo->mutex);
 }
 
+static void lo_setupmapping(fuse_req_t req, fuse_ino_t ino, uint64_t foffset,
+                            uint64_t len, uint64_t moffset, uint64_t flags,
+                            struct fuse_file_info *fi)
+{
+    /* TODO */
+    fuse_reply_err(req, ENOSYS);
+}
+
+static void lo_removemapping(fuse_req_t req, struct fuse_session *se,
+                             fuse_ino_t ino, unsigned num,
+                             struct fuse_removemapping_one *argp)
+{
+    /* TODO */
+    fuse_reply_err(req, ENOSYS);
+}
+
 static struct fuse_lowlevel_ops lo_oper = {
     .init = lo_init,
     .lookup = lo_lookup,
@@ -3185,6 +3201,8 @@ static struct fuse_lowlevel_ops lo_oper = {
 #endif
     .lseek = lo_lseek,
     .destroy = lo_destroy,
+    .setupmapping = lo_setupmapping,
+    .removemapping = lo_removemapping,
 };
 
 /* Print vhost-user.json backend program capabilities */
-- 
2.31.1

