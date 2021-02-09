From: "Dr. David Alan Gilbert (git)" <dgilbert@redhat.com>
Date: Tue,  9 Feb 2021 19:02:15 +0000
Message-Id: <20210209190224.62827-16-dgilbert@redhat.com>
In-Reply-To: <20210209190224.62827-1-dgilbert@redhat.com>
References: <20210209190224.62827-1-dgilbert@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [Virtio-fs] [PATCH 15/24] DAX: virtiofsd: Perform an unmap on
	destroy
List-Id: Development discussions about virtio-fs <virtio-fs.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/virtio-fs>
List-Post: <mailto:virtio-fs@redhat.com>
List-Help: <mailto:virtio-fs-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/virtio-fs>,
	<mailto:virtio-fs-request@redhat.com?subject=subscribe>
To: qemu-devel@nongnu.org, vgoyal@redhat.com, stefanha@redhat.com, virtio-fs@redhat.com, marcandre.lureau@redhat.com, mst@redhat.com

From: "Dr. David Alan Gilbert" <dgilbert@redhat.com>

Force unmap all remaining dax cache entries on a destroy.

Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
---
 tools/virtiofsd/passthrough_ll.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/virtiofsd/passthrough_ll.c b/tools/virtiofsd/passthrough_ll.c
index badac23fef..21ddb434ae 100644
--- a/tools/virtiofsd/passthrough_ll.c
+++ b/tools/virtiofsd/passthrough_ll.c
@@ -2947,6 +2947,17 @@ static void lo_destroy(void *userdata, struct fuse_session *se)
 {
     struct lo_data *lo = (struct lo_data *)userdata;
 
+    if (fuse_lowlevel_is_virtio(se)) {
+        VhostUserFSSlaveMsg msg = { 0 };
+
+        msg.len[0] = ~(uint64_t)0; /* Special: means 'all' */
+        msg.c_offset[0] = 0;
+        if (fuse_virtio_unmap(se, &msg)) {
+            fuse_log(FUSE_LOG_ERR, "%s: unmap during destroy failed\n",
+                     __func__);
+        }
+    }
+
     pthread_mutex_lock(&lo->mutex);
     while (true) {
         GHashTableIter iter;
-- 
2.29.2

