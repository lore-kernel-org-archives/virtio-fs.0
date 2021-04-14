From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Wed, 14 Apr 2021 16:51:28 +0100
Message-Id: <20210414155137.46522-17-dgilbert@redhat.com>
In-Reply-To: <20210414155137.46522-1-dgilbert@redhat.com>
References: <20210414155137.46522-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH v2 16/25] DAX: virtiofsd: Perform an unmap on
	destroy
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

Force unmap all remaining dax cache entries on a destroy.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index 910c4831fb..726343677e 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -3128,6 +3128,20 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
 
+    if (fuse_lowlevel_is_virtio(se)) {
+        VhostUserFSSlaveMsg *msg = g_malloc0(sizeof(VhostUserFSSlaveMsg) +
+                                             sizeof(VhostUserFSSlaveMsgEntry));
+
+        msg->count = 0;
+        msg->entries[0].len = ~(uint64_t)0; /* Special: means 'all' */
+        msg->entries[0].c_offset = 0;
+        if (fuse_virtio_unmap(se, msg)) {
+            fuse_log(FUSE_LOG_ERR, "%s: unmap during destroy failed\n",
+                     __func__);
+        }
+        g_free(msg);
+    }
+
     pthread_mutex_lock(&lo->mutex);
     while (true) {
         GHashTableIter iter;
-- 
2.31.1

