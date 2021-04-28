From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 28 Apr 2021 12:00:47 +0100
Message-Id: <20210428110100.27757-14-dgilbert@redhat.com>
In-Reply-To: <20210428110100.27757-1-dgilbert@redhat.com>
References: <20210428110100.27757-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v3 13/26] DAX: virtiofsd: Add setup/remove
	mapping handlers to passthrough_ll
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, groug@kaod.org
Cc: virtio-fs@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 110f85a701..a16d425b78 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3145,6 +3145,22 @@ static void lo_destroy(void *userdata)
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
@@ -3186,6 +3202,8 @@ static struct fuse_lowlevel_ops lo_oper = {
 #endif
     .lseek = lo_lseek,
     .destroy = lo_destroy,
+    .setupmapping = lo_setupmapping,
+    .removemapping = lo_removemapping,
 };
 
 /* Print vhost-user.json backend program capabilities */
-- 
2.31.1

